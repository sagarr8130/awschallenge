resource "aws_iam_role" "iam_for__lambda" {
  name               = "iam_for__lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


resource "aws_lambda_function" "get_colour_count" {
  filename      = "Code.zip"
  function_name = "get_colour_count"
  role          = aws_iam_role.iam_for__lambda.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_colour_count.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:eu-north-1:776013880947:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}