resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("deployer-key.pub")
}

resource "aws_instance" "ec2" {
  ami           = var.id_image
  instance_type = "t3.micro"
  subnet_id     = module.vpc.public_subnets[0]

  iam_instance_profile        = aws_iam_instance_profile.ssm_profile.name
  associate_public_ip_address = true

  key_name = aws_key_pair.deployer.id

  #   vpc_security_group_ids = [aws_security_group.all_out_egress.id]

  root_block_device {
    encrypted   = true
    kms_key_id  = aws_kms_key.kms_key.arn
    volume_size = "8"
  }
  tags = {
    Name = "Test EC2"
  }
}
