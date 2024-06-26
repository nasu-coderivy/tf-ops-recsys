resource "aws_scheduler_schedule" "ec2-start-schedule" {
  count = 0
  name = "recsys-ec2-start-schedule"
  
  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "cron(0 22 * * ? *)" # Run at 22:00 every day
  schedule_expression_timezone = "America/Sao_Paulo"
  description = "Start instances event"

  target {
    arn = "arn:aws:scheduler:::aws-sdk:ec2:startInstances"
    role_arn = aws_iam_role.scheduler-ec2-role.arn
  
    input = jsonencode({
      "InstanceIds": [
        "${aws_instance.this.id}"
      ]
    })
  }
}

resource "aws_scheduler_schedule" "ec2-stop-schedule" {
  count = 0
  name = "recsys-ec2-stop-schedule"
  
  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "cron(0 6 * * ? *)" # Run at 6:00 am every day
  schedule_expression_timezone = "America/Sao_Paulo"
  description = "Stop instances event"

  target {
    arn = "arn:aws:scheduler:::aws-sdk:ec2:stopInstances"
    role_arn = aws_iam_role.scheduler-ec2-role.arn
  
    input = jsonencode({
      "InstanceIds": [
        "${aws_instance.this.id}"
      ]
    })
  }
}

resource "aws_iam_policy" "scheduler_ec2_policy" {
  name = "recsys-scheduler-ec2-policy"

  policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "VisualEditor0",
                "Effect": "Allow",
                "Action": [
                    "ec2:StartInstances",
                    "ec2:StopInstances"
                ],
                "Resource": [
                  "${aws_instance.this.arn}:*",
                  "${aws_instance.this.arn}"
                ],
            }
        ]
    }
  )
}

resource "aws_iam_role" "scheduler-ec2-role" {
  name = "recsys-scheduler-ec2-role"
  managed_policy_arns = [aws_iam_policy.scheduler_ec2_policy.arn]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "scheduler.amazonaws.com"
        }
      },
    ]
  })
}
