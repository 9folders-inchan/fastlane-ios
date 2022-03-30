# 최초 사용 가이드 
### 프로젝트에 서브모듈 추가
``` 
$ cd $PROJECT_ROOT
$ git submodule add --force https://github.com/9folders-inchan/fastlane-ios.git fastlane
``` 

### 최초 필수파일 복사 
".env", ".env.rework", "Gemfile"을 PROJECT_ROOT에 복사하는 초기화 스크립트 실행  
```
$ ./fastlane/script/Initailize.sh.command
``` 

### Fastlane 실행
```  
$ cd $PROJECT_DIR
$ fastlane beta --env rework --verbose
``` 
OR 
```  
$ cd $PROJECT_DIR
$ ./fastlane/script/deploy_beta.sh.command
``` 

# Deploy Lanes 
### Alpha: DEBUG 환경 빌드, AppBox 배포 (스크립트 포함)
``` 
$ fastlane alpha --env rework --verbose
``` 

### Beta: Release 환경 빌드, Testflight 배포 (스크립트 포함)
``` 
$ fastlane beta --env rework --verbose
``` 

### Release: Release 환경 빌드, Testflight 배포, 리뷰 신청 (스크립트 포함)
``` 
$ fastlane Release --env rework --verbose
``` 

### Custom: 정해진 룰 없이 여러가지 옵션을 모두 사용 가능 
``` 
$ fastlane custom versioning_mode:$versioning_mode build_configuration:$build_configuration dsym_upload_mode:$dsym_upload_mode use_upload_appbox:$use_upload_appbox use_git_push:$use_git_push --env rework --verbose
``` 

# Util Lanes
### CodeSigning
``` 
$ fastlane syncCodeSigning
$ fastlane renewCodeSigning
``` 

### Versioning (스크립트 포함)
``` 
$ fastlane versioning versioning_mode:major
``` 

### DSYM Upload (특정버전 업로드)
마지막 빌드 또는 특정버전 업로드 
``` 
$ fastlane uploadDSYMs dsyms_min_version:1.2.5
``` 

### DSYM All Refresh (모든버전 다운로드 후 재업로드)
모든버전 다운로드 후 재업로드
``` 
$ fastlane refreshDSYMs dsyms_min_version:1.2.5
``` 
