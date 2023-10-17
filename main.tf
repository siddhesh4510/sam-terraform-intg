//@author: DevProblems(Sarang Kumar A Tak)

resource "aws_lambda_function" "aws-lambda-local-test-sam-terraform" {
    filename = "${local.lambda_build_path}/${local.lambda_zip_file_name}"
    handler = "index.default"
    runtime = "nodejs14.x"
    function_name = "aws-lambda-local-test-sam-terraform"
    role = aws_iam_role.iam_for_lambda.arn
    timeout = 30
    depends_on = [
        data.archive_file.zip_lambda
    ]
}

resource "null_resource" "sam_metadata_aws_lambda_function_aws_lambda_local_test_sam_terraform" {
    triggers = {
        resource_name = "aws_lambda_function.aws-lambda-local-test-sam-terraform"
        resource_type = "ZIP_LAMBDA_FUNCTION"
        original_source_code = local.lambda_src_path
        built_output_path = "${local.lambda_build_path}/${local.lambda_zip_file_name}"
    }
    depends_on = [
        data.archive_file.zip_lambda
    ]
}
data "aws_iam_policy_document" "AWSLambdaTrustPolicy" {
  statement {
    actions    = ["sts:AssumeRole"]
    effect     = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
resource "aws_iam_role_policy_attachment" "terraform_lambda_policy" {
  role       = "${aws_iam_role.iam_for_lambda.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_policy" "access_for_dynomodb" {
    name ="access_for_dynomodb"
    path ="/"
    description = ""
    policy =<<EOF
{
    "Version":"2023-10-16",
    "Statement":[
        {
            "Action":["dynamodb:PutItem"],
            "Resource":"arn:aws:dynamodb:*:*:*",
            "Effect":"Allow"
        }
    ]
}
EOF
  
}
resource "aws_iam_role_policy_attachment" "dynamodb_lambda_policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.access_for_dynomodb.arn
}


data "archive_file" "zip_lambda" {
    type = "zip"
    source_file = "./src/index.js"
    output_path = "${local.lambda_build_path}/${local.lambda_zip_file_name}"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = "${data.aws_iam_policy_document.AWSLambdaTrustPolicy.json}"
}

