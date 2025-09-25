#!/usr/bin/env bash

changes_found=false
echo "| File | Commit Change | Diff |" >/tmp/changes_report
echo "|---|---|---|" >>/tmp/changes_report
echo "false" >/tmp/changes_found

find roles/ -path '*/.ansible' -prune -o -type f -print | while read -r file; do
  if grep -q "# external-file" "$file"; then
    echo "Checking $file..."

    # Read structured data from comments
    owner=$(grep "# owner:" "$file" | sed 's/# owner: //')
    repo=$(grep "# repo:" "$file" | sed 's/# repo: //')
    path=$(grep "# path:" "$file" | sed 's/# path: //')
    stored_commit=$(grep "# commit-hash:" "$file" | sed 's/# commit-hash: //')

    # Assuming the default branch is the one specified in the path if any, otherwise main/master
    # This part might need adjustment if branch isn't part of the path logic
    api_url="https://api.github.com/repos/$owner/$repo/commits?path=$path"

    current_commit=$(curl -sL -H "Authorization: Bearer $GITHUB_TOKEN" "$api_url" | jq -r '.[0].sha')

    if [[ -n "$owner" && -n "$repo" && -n "$path" && -n "$stored_commit" && "$stored_commit" != "$current_commit" ]]; then
      echo "? Commit mismatch for $file"
      echo "true" >/tmp/changes_found

      short_stored=$(echo "$stored_commit" | cut -c1-7)
      short_current=$(echo "$current_commit" | cut -c1-7)

      # Get content for both commits
      old_content_url="https://raw.githubusercontent.com/$owner/$repo/$stored_commit/$path"
      new_content_url="https://raw.githubusercontent.com/$owner/$repo/$current_commit/$path"

      curl -sL "$old_content_url" -o /tmp/old_content
      curl -sL "$new_content_url" -o /tmp/new_content

      # Generate diff
      diff_output=$(diff -u /tmp/old_content /tmp/new_content || true)

      diff_link="https://github.com/$owner/$repo/compare/$stored_commit..$current_commit"

      echo "| \`$file\` | [\`$short_stored\`  \`$short_current\`]($diff_link) | <details><summary>View Diff</summary>\`\`\`diff\n$diff_output\n\`\`\`</details> |" >>/tmp/changes_report
    else
      echo "? $file: up to date"
    fi
  fi
done

changes_found=$(cat /tmp/changes_found)

if [ "$changes_found" = "true" ]; then
  echo "changes=true" >>$GITHUB_OUTPUT
  changes_report_body=$(cat /tmp/changes_report)
  echo "CHANGES_REPORT<<EOF" >>$GITHUB_ENV
  echo "$changes_report_body" >>$GITHUB_ENV
  echo "EOF" >>$GITHUB_ENV
  echo "Changes detected! Will create PR."
else
  echo "changes=false" >>$GITHUB_OUTPUT
  echo "No changes detected."
fi
