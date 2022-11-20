#Define AWS Region
variable "region" {
  description = "Infrastructure region"
  type        = string
  default     = "us-east-1"
}
#Define IAM User Access Key
variable "access_key" {
  description = "The access_key that belongs to the IAM user"
  type        = string
  sensitive   = true
}
#Define IAM User Secret Key
variable "secret_key" {
  description = "The secret_key that belongs to the IAM user"
  type        = string
  sensitive   = true
}

variable "sns_name" {
  default = "security-alerts-topic"
  type    = string
}

variable "sns_topic_arn" {
  default = "arn:aws:sns:eu-west-2:889199313043:security-alerts-topic"
}

variable "tags_rules" {
  default = {
    "rule"   = "epp-config-rule"
  }
}
