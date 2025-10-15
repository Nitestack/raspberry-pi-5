#!/usr/bin/env bash

find roles/ -path '*/.ansible' -prune -o -type f -print | while read -r file; do
  if grep -q "# external-file" "$file"; then
    owner=$(grep "# owner:" "$file" | sed 's/# owner: //')
    repo=$(grep "# repo:" "$file" | sed 's/# repo: //')
    path=$(grep "# path:" "$file" | sed 's/# path: //')
    stored_commit=$(grep "# commit-hash:" "$file" | sed 's/# commit-hash: //')

    api_url="https://api.github.com/repos/$owner/$repo/commits?path=$path"
    current_commit=$(curl -sL -H "Authorization: token $GITHUB_TOKEN" "$api_url" | jq -r '.[0].sha')

    if [[ -n "$owner" && -n "$repo" && -n "$path" && -n "$stored_commit" && "$stored_commit" != "$current_commit" ]]; then
      echo "Update found for $file. Stored: $stored_commit, Latest: $current_commit"

      sed -i "s/# commit-hash: .*/# commit-hash: $current_commit/" "$file"
      echo "Updated commit hash comment in $file"

      role_dir=$(dirname "$file" | sed 's|/templates$||' | sed 's|/files$||')
      tasks_file="$role_dir/tasks/main.yml"

      if [ -f "$tasks_file" ]; then
        if grep -q "$stored_commit" "$tasks_file"; then
          echo "Updating pinned URL in $tasks_file"
          sed -i "s/$stored_commit/$current_commit/g" "$tasks_file"
        fi
      fi
    fi
  fi
done
