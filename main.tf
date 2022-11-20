# -----------------------------------------------------------
# set up a IAM role for the Configuration Recorder to use
# -----------------------------------------------------------
resource "aws_iam_role" "config" {
  name = "epp-config-sap"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "config" {
  role       = "${aws_iam_role.config.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}



# -----------------------------------------------------------
# set up the  Config Recorder
# -----------------------------------------------------------

resource "aws_config_configuration_recorder" "config" {
  name     = "epp-config-recorder"
  role_arn = "${aws_iam_role.config.arn}"

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "config" {
  name           = "epp-config-channel"
  s3_bucket_name = "${aws_s3_bucket.config_bucket.bucket}"
  sns_topic_arn  = "${aws_sns_topic.sns_topic.arn}"

  snapshot_delivery_properties {
    delivery_frequency = "Three_Hours"
  }

  depends_on = [aws_config_configuration_recorder.config, aws_sns_topic.sns_topic]
}

resource "aws_config_configuration_recorder_status" "config" {
  name       = "${aws_config_configuration_recorder.config.name}"
  is_enabled = true

  depends_on = [aws_config_delivery_channel.config]
}

