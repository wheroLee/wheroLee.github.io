+++
date = '2025-09-22T04:18:25Z'
draft = true
title = 'Git start'
categories = ["Git", "Hugo"]
tags = ["blog"]
+++

## Git 영역
1. Local; 개인 작업 영역
2. Staging; 수정된 내용을 보관하는 영역
3. Repository; 최종 수정본을 업데이트
4. remote; github 등에 공유

## Git flow
![image](https://private-user-images.githubusercontent.com/71390331/492394145-1380ef92-4733-4274-80d7-1f9e6395288f.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NTg1NTY4MTgsIm5iZiI6MTc1ODU1NjUxOCwicGF0aCI6Ii83MTM5MDMzMS80OTIzOTQxNDUtMTM4MGVmOTItNDczMy00Mjc0LTgwZDctMWY5ZTYzOTUyODhmLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTA5MjIlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwOTIyVDE1NTUxOFomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPThkZWIyZGY4ZTg1MDJiZTdlMjhiZDI4MjE0MzcxZTAzOThkNzg0YjAyZmUwNDgxMGYyNTEzYmNkZmY1OTYzY2YmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.T14v7yDjavhmIRJS8-VmcYLEHpSw7oqUVJNdf-R5Q10)

## 저장소 생성 방법
  ```
  # 로컬에 저장소 직접 생성
  git init

  # remote에서 저장소 다운
  git clone [저장소 url]
  ```

## 작업 순서
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
```

4. remote 공유
```
$ git remote add origin (원격 저장소 github URL)   
$ git push origin main   
```
5. remote -> local 동기화   
```
$ git pull
```
