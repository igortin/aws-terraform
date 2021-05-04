resource "aws_iam_instance_profile" "trainning-profile" {
  name = "trainning-profile"
  role = aws_iam_role.trainning-role.name
}


resource "aws_iam_role_policy_attachment" "trainning-attach" {
  role       = aws_iam_role.trainning-role.name
  policy_arn = aws_iam_policy.trainning-policy.arn
}


resource "aws_iam_role" "trainning-role" {
  name = "trainning-role"

  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_policy" "trainning-policy" {
  name        = "trainnin-policy"
  description = "A trainning policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}