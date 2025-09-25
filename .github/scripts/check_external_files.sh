#!/usr/bin/env bash

echo "| File | Commit Change |" >/tmp/changes_table
echo "|---|---|" >>/tmp/changes_table
echo -e "\n---\n\n### File Diffs" >/tmp/changes_diffs
echo "false" >/tmp/changes_found

find roles/ -path '*/.ansible' -prune -o -type f -print | while read -r file; do
  if grep -q "# external-file" "$file"; then
    echo "Checking $file..."

    owner=$(grep "# owner:" "$file" | sed 's/# owner: //')
    repo=$(grep "# repo:" "$file" | sed 's/# repo: //')
    path=$(grep "# path:" "$file" | sed 's/# path: //')
    stored_commit=$(grep "# commit-hash:" "$file" | sed 's/# commit-hash: //')

    api_url="https://api.github.com/repos/$owner/$repo/commits?path=$path"

    current_commit=$(curl -sL -H "Authorization: token $GITHUB_TOKEN" "$api_url" | jq -r '.[0].sha')

    if [[ -n "$owner" && -n "$repo" && -n "$path" && -n "$stored_commit" && "$stored_commit" != "$current_commit" ]]; then
      echo "❌ Commit mismatch for $file"
      echo "true" >/tmp/changes_found

      short_stored=$(echo "$stored_commit" | cut -c1-7)
      short_current=$(echo "$current_commit" | cut -c1-7)
      diff_link="https://github.com/$owner/$repo/compare/$stored_commit..$current_commit"

      echo "| \`$file\` | [\`$short_stored\` → \`$short_current\`]($diff_link) |" >>/tmp/changes_table

      old_content_url="https://raw.githubusercontent.com/$owner/$repo/$stored_commit/$path"
      new_content_url="https://raw.githubusercontent.com/$owner/$repo/$current_commit/$path"
      curl -sL "$old_content_url" -o /tmp/old_content
      curl -sL "$new_content_url" -o /tmp/new_content
      diff_output=$(diff -u /tmp/old_content /tmp/new_content | sed '1,3d')

      file_url="https://github.com/$owner/$repo/blob/HEAD/$path"

      echo -e "\n\n<details><summary><a href=""$file_url""><b>$path</b></a></summary>\n\n\`\`\`diff\n$diff_output\n\`\`\`\n\n</details>\n" >>/tmp/changes_diffs
    else
      echo "✅ $file: up to date"
    fi
  fi
done

changes_found=$(cat /tmp/changes_found)

if [ "$changes_found" = "true" ]; then
  cat /tmp/changes_table /tmp/changes_diffs >/tmp/changes_report

  echo "changes=true" >>"$GITHUB_OUTPUT"
  changes_report_body=$(cat /tmp/changes_report)
  echo "CHANGES_REPORT<<EOF" >>"$GITHUB_ENV"
  echo "$changes_report_body" >>"$GITHUB_ENV"
  echo "EOF" >>"$GITHUB_ENV"
  echo "Changes detected! Creating PR..."
else
  echo "changes=false" >>"$GITHUB_OUTPUT"
  echo "No changes detected"
fi
