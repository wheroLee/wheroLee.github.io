+++
date = '2025-09-22T04:18:25Z'
draft = true
title = 'Git Commit'
+++
# Git 영역
1. Local; 개인 작업 영역
2. Staging; 수정된 내용을 보관하는 영역
3. Repository; 최종 수정본을 업데이트
4. remote; github 등에 공유

# 저장소 생성 방법
  ```
  # 로컬에 저장소 직접 생성
  git init

  # remote에서 저장소 다운
  git clone [저장소 url]
  ```
# 작업 순서
1. 문성 생성/수정
2. staging
```
git add .
```
3. repository 저장
```
# commit with message   
git commit -m "comment"

# commit with log   
git commit -a

4. remote 공유
```
$ git remote add origin (원격 저장소 github URL)   
$ git push origin main   
```
5. remote -> local 동기화   
```
$ git pull
```
