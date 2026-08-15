#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

./Generator.py

mkdir -p dist
typst compile --root . codebook/wide/main.typ \
  dist/competitive-programming-templates-wide.pdf
typst compile --root . codebook/compact/main.typ \
  dist/competitive-programming-templates-compact.pdf

git add -A
if git diff --cached --quiet; then
  echo "没有需要提交的修改。"
  exit 0
fi

release="n"
if [[ -t 0 ]]; then
  read -r -p "本次提交后是否发布 GitHub Release？[y/N] " release
else
  echo "非交互环境：默认不发布 GitHub Release。"
fi

release_tag=""
case "$release" in
  y|Y|yes|YES)
    latest_tag=$(git tag --list 'v[0-9]*.[0-9]*.[0-9]*' --sort=-v:refname | head -n 1)
    if [[ "$latest_tag" =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
      default_tag="v${BASH_REMATCH[1]}.${BASH_REMATCH[2]}.$((BASH_REMATCH[3] + 1))"
    else
      default_tag="v0.0.1"
    fi

    read -r -p "Release 标签（默认：最新版本 + 0.0.1）[${default_tag}]: " release_tag
    release_tag=${release_tag:-$default_tag}
    if [[ ! "$release_tag" =~ ^v[0-9]+\.[0-9]+\.[0-9]+([.-][0-9A-Za-z.-]+)?$ ]]; then
      echo "标签格式无效：$release_tag（示例：v1.2.3）" >&2
      exit 1
    fi
    if git rev-parse -q --verify "refs/tags/$release_tag" >/dev/null; then
      echo "标签已存在：$release_tag" >&2
      exit 1
    fi
    ;;
esac

time=$(date +"%Y-%m-%d %H:%M:%S")
git commit -m "Site updated: $time"
git push

if [[ -n "$release_tag" ]]; then
  git tag -a "$release_tag" -m "Release $release_tag"
  git push origin "$release_tag"
  echo "已推送 $release_tag；GitHub Actions 将发布宽版与紧凑版 PDF。"
else
  echo "本次仅提交并推送，不发布 Release。"
fi
