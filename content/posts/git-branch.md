---
title: "Git에서 특정 커밋으로 브랜치 시작하기"
date: 2025-09-17
tags: ["git", "github", "개발"]
categories: ["DevTips"]
---

Git에서 특정 커밋을 기준으로 새로운 브랜치를 만들고 싶을 때는 다음과 같이 합니다:

```bash
# 커밋 해시 확인
git log --oneline

# 특정 커밋에서 브랜치 생성
git checkout -b feature-branch <commit-hash>

# 원격 저장소에 푸시
git push origin feature-branch
