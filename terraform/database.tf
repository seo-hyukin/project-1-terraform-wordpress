
resource "aws_db_subnet_group" "main" {
  name       = "project-1-db-subnet-group"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_c.id]

  tags = {
    Name = "project-1-db-subnet-group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  db_name              = "wordpress"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "1dlsmnJP!"
  
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible  = false
  
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  tags = {
    Name = "project-1-db"
  }
}


