output "bucket_arn" {
  value = "${aws_s3_bucket.config_bucket.arn}"
}

output "recorder_id" {
  value = "${aws_config_configuration_recorder.config.id}"
}

output "aws_sns_topic_arn" {
  value = "${aws_sns_topic.sns_topic.arn}"
}