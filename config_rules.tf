# -----------------------------------------------------------
# set up the Config Recorder rules
# -----------------------------------------------------------


resource "aws_config_config_rule" "encrypted_volumes" {
  name = "encrypted_volumes"
  description = "Evaluates whether EBS volumes that are in an attached state are encrypted."

  source {
    owner             = "AWS"
    source_identifier = "ENCRYPTED_VOLUMES"
  }

  scope {
    compliance_resource_types = ["AWS::EC2::Volume"]
  }

  tags = var.tags_rules

  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_config_rule" "rds-storage-encrypted" {
  name        = "rds-storage-encrypted"
  description = "Checks whether storage encryption is enabled for your RDS DB instances."

  source {
    owner             = "AWS"
    source_identifier = "RDS_STORAGE_ENCRYPTED"
  }

  scope {
    compliance_resource_types = ["AWS::RDS::DBInstance"]
  }

  tags = var.tags_rules

  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_config_rule" "dynamodb-table-encryption-enabled" {
  name        = "dynamodb-table-encryption-enabled"
  description = "Checks if the Amazon DynamoDB tables are encrypted and checks their status. The rule is COMPLIANT if the status is enabled or enabling."

  source {
    owner             = "AWS"
    source_identifier = "DYNAMODB_TABLE_ENCRYPTION_ENABLED"
  }

  scope {
    compliance_resource_types = ["AWS::DynamoDB::Table"]
  }

  tags = var.tags_rules

  depends_on = [aws_config_configuration_recorder.config]
}


resource "aws_config_config_rule" "efs-encrypted-check" {
  name             = "efs-encrypted-check"
  description      = "Checks if Amazon Elastic File System is configured to encrypt file data using AWS Key Management Service. NON_COMPLIANT if encrypted key set to false on DescribeFileSystems or KmsKeyId key on DescribeFileSystems does not match the KmsKeyId parameter"

  source {
    owner             = "AWS"
    source_identifier = "EFS_ENCRYPTED_CHECK"
  }

  scope {
    compliance_resource_types = ["AWS::EFS::FileSystem"]
  }

  tags = var.tags_rules


  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_config_rule" "s3_bucket_server_side_encryption_enabled" {
  name = "s3_bucket_server_side_encryption_enabled"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
  }

  scope {
    compliance_resource_types = ["AWS::S3::Bucket"]
  }

  tags = var.tags_rules

  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_config_rule" "cloud_trail_enabled" {
  name = "cloud_trail_enabled"

  source {
    owner             = "AWS"
    source_identifier = "CLOUD_TRAIL_ENABLED"
  }

  input_parameters = <<EOF
{
  "s3BucketName": "epp-tf-*"
}
EOF

  scope {
    compliance_resource_types = ["AWS::CloudTrail::Trail"]
  }

  tags = var.tags_rules

  depends_on = [aws_config_configuration_recorder.config]
}


resource "aws_config_config_rule" "s3_bucket_versioning_enabled" {
  name = "s3_bucket_versioning_enabled"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_VERSIONING_ENABLED"
  }

  scope {
    compliance_resource_types = ["AWS::S3::Bucket"]
  }

  tags = var.tags_rules

  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_config_rule" "s3_bucket_ssl_requests_only" {

  name        = "s3-bucket-ssl-requests-only"
  description = "Checks whether S3 buckets have policies that require requests to use Secure Socket Layer (SSL)."

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SSL_REQUESTS_ONLY"
  }

  scope {
    compliance_resource_types = ["AWS::S3::Bucket"]
  }

  tags = var.tags_rules

  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_config_rule" "sg_unrestricted_common_ports_check" {

  name             = "restricted-common-ports"
  description      = "A Config rule that checks whether security groups in use do not allow restricted incoming traffic to the specified ports."
  input_parameters = "{\"blockedPort1\":\"20\",\"blockedPort2\":\"21\",\"blockedPort3\":\"3389\",\"blockedPort4\":\"3306\",\"blockedPort5\":\"4333\"}"

  source {
    owner             = "AWS"
    source_identifier = "RESTRICTED_INCOMING_TRAFFIC"
  }
  scope {
    compliance_resource_types = ["AWS::EC2::SecurityGroup"]
  }

  tags = var.tags_rules

  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_config_rule" "restricted-common-ports" {
  name        = "elb-tls-https-listeners-only"
  description = "Checks if your Load Balancer is configured with SSL or HTTPS listeners."

  source {
    owner             = "AWS"
    source_identifier = "ELB_TLS_HTTPS_LISTENERS_ONLY"
  }

  tags = var.tags_rules

  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_config_rule" "ConfigRule" {
  name        = "alb-http-to-https-redirection-check"
  description = "A Config rule that checks whether HTTP to HTTPS redirection is configured on all HTTP listeners of Application Load Balancers. The rule is NON_COMPLIANT if one or more HTTP listeners of Application Load Balancers do not have HTTP to HTTPS redirection c..."

  source {
    owner             = "AWS"
    source_identifier = "ALB_HTTP_TO_HTTPS_REDIRECTION_CHECK"
  }
  tags = var.tags_rules

  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_config_rule" "elb-logging-enabled" {
  name             = "elb-logging-enabled"
  description      = "Checks if the Application Load Balancer and the Classic Load Balancer have logging enabled. The rule is NON_COMPLIANT if the access_logs.s3.enabled is false or access_logs.S3.bucket is not equal to the s3BucketName that you provided."

  input_parameters = <<EOF
   {
  "s3BucketNames": "${aws_s3_bucket.config_bucket.bucket}"
   }
  EOF

  source {
    owner             = "AWS"
    source_identifier = "ELB_LOGGING_ENABLED"
  }

  tags = var.tags_rules

  depends_on = [aws_config_configuration_recorder.config]
}