# ☁️ AWS High Availability WordPress Infrastructure (IaC Project)

## 🎯 프로젝트 목표
1. **고가용성 확보:** AWS Auto Scaling Group(ASG)과 Application Load Balancer(ALB)를 활용하여 트래픽 증가에 유연하게 대처하는 인프라 구축
2. **IaC 실무 적용:** AWS 콘솔로 수동 구축한 리소스를 Terraform 코드로 100% 전환 (Import & Refactoring)
3. **보안 강화:** IAM Role 및 Secrets Manager를 활용하여 키 관리 최소화

## 🏗️ 아키텍처 (예정)
> (여기에 추후 다이어그램 이미지를 넣을 예정입니다. 일단 텍스트로 구조를 정의합니다.)

* **VPC:** 10.0.0.0/16
* **Public Subnet:** ALB, Nat Gateway (가용영역 A, C)
* **Private Subnet:** WordPress EC2 (ASG), RDS (가용영역 A, C)
* **Data:** RDS (MySQL/Aurora), EFS (미디어 파일 공유)