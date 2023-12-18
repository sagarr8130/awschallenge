# provider "aws" {
#   profile = "default"
#   region  = "eu-north-1"
# }

# data "aws_iam_policy_document" "assume_role" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["lambda.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }

# resource "aws_iam_role" "iam_for__lambda" {
#   name               = "iam_for__lambda"
#   assume_role_policy = data.aws_iam_policy_document.assume_role.json
# }


# resource "aws_lambda_function" "get_colour_count" {
#   filename      = "Code.zip"
#   function_name = "get_colour_count"
#   role          = aws_iam_role.iam_for__lambda.arn
#   handler       = "lambda_function.lambda_handler"
#   runtime = "python3.8"
# }

# API Gateway
# resource "aws_api_gateway_rest_api" "api" {
#   name = "myapi"
#   endpoint_configuration {
#     types = ["REGIONAL"]
#   }
# }

# resource "aws_api_gateway_resource" "resource" {
#   path_part   = "resource"
#   parent_id   = aws_api_gateway_rest_api.api.root_resource_id
#   rest_api_id = aws_api_gateway_rest_api.api.id
# }

# resource "aws_api_gateway_method" "method" {
#   rest_api_id   = aws_api_gateway_rest_api.api.id
#   resource_id   = aws_api_gateway_resource.resource.id
#   http_method   = "ANY"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "integration" {
#   rest_api_id             = aws_api_gateway_rest_api.api.id
#   resource_id             = aws_api_gateway_resource.resource.id
#   http_method             = aws_api_gateway_method.method.http_method
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = aws_lambda_function.get_colour_count.invoke_arn
# }

# Lambda
# resource "aws_lambda_permission" "apigw_lambda" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.get_colour_count.function_name
#   principal     = "apigateway.amazonaws.com"

#   # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
#   source_arn = "arn:aws:execute-api:eu-north-1:776013880947:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
# }



##############


# resource "aws_api_gateway_deployment" "example" {
#   rest_api_id = aws_api_gateway_rest_api.api.id

#   triggers = {
#     redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api.body))
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
#   depends_on = [
#     aws_api_gateway_method.method,
#     aws_api_gateway_integration.integration
#   ]
# }

# resource "aws_api_gateway_stage" "example" {
#   deployment_id = aws_api_gateway_deployment.example.id
#   rest_api_id   = aws_api_gateway_rest_api.api.id
#   stage_name    = "example"
# }