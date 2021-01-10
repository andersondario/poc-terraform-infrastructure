resource "aws_lambda_function" "lambda" {
    for_each      = var.lambdas_definitions
    
    function_name = "${each.key}-${terraform.workspace}"
    s3_bucket     = each.value.lambda_code_bucket
    s3_key        = each.value.lambda_zip_path

    handler       = each.value.handle_path    
    runtime       = each.value.runtime
    role          = aws_iam_role.lambda_exec.arn
}

resource "aws_iam_role" "lambda_exec" {
    name = "lambda-exec-role-${terraform.workspace}"

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": "sts:AssumeRole",
        "Principal": {
            "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
        }
    ]
}
EOF
}

resource "aws_api_gateway_rest_api" "api" {
    name        = "${var.application_name}-api-${terraform.workspace}"
    description = "API for application ${var.application_name} for ${terraform.workspace} environment."

    tags = var.tags
}

resource "aws_api_gateway_resource" "proxy" {
    for_each = var.lambdas_definitions

    rest_api_id = aws_api_gateway_rest_api.api.id
    parent_id   = aws_api_gateway_rest_api.api.root_resource_id
    path_part   = each.value.path
}

resource "aws_api_gateway_method" "proxy" {
    for_each = var.lambdas_definitions

    rest_api_id   = aws_api_gateway_rest_api.api.id
    resource_id   = aws_api_gateway_resource.proxy[each.key].id
    http_method   = each.value.method
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
    for_each = var.lambdas_definitions

    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_method.proxy[each.key].resource_id
    http_method = aws_api_gateway_method.proxy[each.key].http_method

    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = aws_lambda_function.lambda[each.key].invoke_arn
}

resource "aws_api_gateway_method" "proxy_root" {
    rest_api_id   = aws_api_gateway_rest_api.api.id
    resource_id   = aws_api_gateway_rest_api.api.root_resource_id
    http_method   = "ANY"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
    for_each = var.lambdas_definitions

    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_method.proxy_root.resource_id
    http_method = aws_api_gateway_method.proxy_root.http_method

    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = aws_lambda_function.lambda[each.key].invoke_arn
}


resource "aws_lambda_permission" "apigw_lambda" {
    for_each = var.lambdas_definitions

    statement_id  = "AllowExecutionFromAPIGateway"
    action        = "lambda:InvokeFunction"
    function_name = "${each.key}-${terraform.workspace}"
    principal     = "apigateway.amazonaws.com"

    source_arn = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.api.id}/*/${each.value.method}/${each.value.path}"
}

resource "aws_api_gateway_deployment" "deployment" {
    depends_on = [
        aws_api_gateway_integration.lambda_integration,
        aws_api_gateway_integration.lambda_root,
    ]

    rest_api_id = aws_api_gateway_rest_api.api.id
    stage_name  = terraform.workspace
}

