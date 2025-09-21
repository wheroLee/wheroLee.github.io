#!/bin/bash

# ==========================================
# Hugo 강제 빌드 + 배포 스크립트 (Termux)
# ==========================================

# 1. 환경 설정
THEME="PaperMod"         # 테마 이름
CONTENT_DIR="content"    # 글이 있는 폴더
PUBLIC_DIR="public"      # 배포용 폴더
GIT_BRANCH="main"        # Git 브랜치

# 2. 캐시 정리 및 Garbage Collection
echo "[1/5] Hugo 캐시 정리 중..."
hugo --ignoreCache --gc

# 3. public 폴더 초기화
echo "[2/5] public 폴더 초기화 중..."
rm -rf "$PUBLIC_DIR"/*

# 4. Hugo 빌드 (draft 포함)
echo "[3/5] Hugo 빌드 중..."
hugo -D -t "$THEME"

# 5. Git submodule 업데이트 (public 폴더가 submodule일 경우)
if [ -f ".gitmodules" ]; then
    echo "[4/5] Git submodule 업데이트 중..."
    git submodule update --init --recursive
fi

# 6. Git 커밋 및 푸시
echo "[5/5] Git 커밋 및 푸시 중..."
git add "$PUBLIC_DIR"
git commit -m "Update site $(date +'%Y-%m-%d %H:%M:%S')"
git push origin "$GIT_BRANCH"

echo "✅ 배포 완료!"
