# 🛠️ Project 1 트러블슈팅 로그

## 1. ALB 연결 후 워드프레스 DB 접속 오류
* **일시:** 2025-12-03
* **상황:** - Terraform으로 ALB를 생성하고 접속했으나 `Error establishing a database connection` 화면이 뜸.
  - EC2 단독 접속 시에도 동일한 에러 발생 확인.
* **원인 분석:**
  - Terraform으로 새로 만든 EC2 인스턴스는 `user_data` 스크립트를 통해 워드프레스 파일만 설치됨.
  - `wp-config.php` 파일에 **RDS 접속 정보(Endpoint, ID, PW)**가 설정되지 않은 상태임.
* **해결 계획:**
  - (ASG 적용 전) EC2 템플릿(Launch Template)을 만들 때, DB 정보를 자동으로 주입하거나,
  - (현재) 수동으로 `wp-config.php`를 수정하여 연결 확인 후 이미지를 따서 해결 예정.


  ## 2. Terraform 리팩토링 중 Resource 참조 오류 방지
* **일시:** 2025-12-05
* **상황:**
  - `compute.tf` 코드를 수정하여 단일 EC2(`aws_instance`)를 삭제하고 ASG(`aws_autoscaling_group`)로 아키텍처를 변경함.
  - 하지만 `outputs.tf` 파일에는 여전히 삭제된 리소스인 `aws_instance.web.public_ip`를 출력하라는 코드가 남아있었음.
* **예상 에러:**
  - `Error: Reference to undeclared resource` (존재하지 않는 리소스를 참조함)
* **해결:**
  - 아키텍처 변경 시, 해당 리소스를 참조(Reference)하는 다른 파일들(`outputs.tf`)도 함께 수정해야 함을 인지.
  - `outputs.tf`의 출력값을 `aws_instance` IP에서 `aws_lb` DNS 주소로 변경하여 코드 정합성을 맞춤.


  ## 3. ASG 자동 생성 인스턴스의 DB 연결 설정 누락
* **일시:** 2025-12-06
* **상황:**
  - Terraform으로 ASG와 ALB를 구축하고 접속했으나, 다시 DB 연결 에러가 발생함.
  - 단일 EC2 때는 SSH로 접속해 수동으로 해결했으나, ASG는 인스턴스가 자동으로 생성/삭제되므로 수동 개입이 불가능함.
* **원인:**
  - `user_data` 스크립트(`install_wordpress.sh`)에는 워드프레스 설치 명령만 있고, DB 접속 정보(`wp-config.php`)를 설정하는 로직이 없음.
* **해결 계획:**
  - `install_wordpress.sh` 스크립트를 수정하여, `sed` 명령어를 통해 DB 접속 정보(Host, User, PW)를 자동으로 주입하도록 개선.
  - (보안 이슈: 스크립트에 비밀번호가 하드코딩되므로, 추후 Secrets Manager 도입 시 개선 필요함을 인지함.)


  ## 4. User Data 스크립트 실행 시간으로 인한 초기 접속 오류
* **일시:** 2025-11-XX
* **상황:**
  - ASG로 인스턴스가 새로 생성되고 콘솔상 `Running` 상태가 되자마자 접속했으나 연결 실패.
  - SSH 접속 후 설정 파일을 확인하려던 도중, 별다른 조치 없이 갑자기 정상 접속됨.
* **원인:**
  - EC2 상태가 `Running`이 되어도, 내부에서 `user_data` 스크립트(패키지 설치, 설정 변경)가 완료되는 데는 약 3~5분의 시간이 소요됨.
  - 스크립트 완료 전에 웹 서버에 접속을 시도하여 발생한 현상.
* **배운 점:**
  - 인스턴스 생성 직후에는 `tail -f /var/log/cloud-init-output.log` 명령어로 스크립트 진행 상황을 모니터링해야 함을 알게 됨.
  - 서비스 헬스 체크(Health Check) 시간을 넉넉히 둬야 초기 실패를 막을 수 있음.