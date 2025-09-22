+++
date = '2025-09-22T04:39:08Z'
draft = true
title = 'Git Branch'
+++

# 📌 Git Flow Overview (Clean ASCII Diagram)
```
                          ┌───────────────┐
                          │   master      │  (production)
                          └───────▲───────┘
                                  │
                     ┌────────────┼───────────┐
                     │            │           │
                     │            │           │
             ┌───────┴───────┐    │    ┌──────┴───────┐
             │   release     │────┘    │   hotfix     │
             │ (stabilize)   │         │ (urgent fix) │
             └───────▲───────┘         └──────▲───────┘
                     │                        │
                     │                        │
             ┌───────┴───────┐                │
             │   develop     │<───────────────┘
             │ (integration) │
             └───────▲───────┘
                     │
                     │
             ┌───────┴───────┐
             │   feature     │
             │ (new work)    │
             └───────────────┘
```
# 🔑 핵심 흐름   
- master → 운영/배포용 브랜치   
- develop → 개발 중심 브랜치   
- feature → 새로운 기능 개발 (develop에서 분기 → develop에 병합)   
- release → 배포 전 테스트 및 안정화 (develop에서 분기 → master와 develop에 병합)   
- hotfix → 운영 중 긴급 수정 (master에서 분기 → master와 develop에 병합)   
