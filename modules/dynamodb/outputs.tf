output "table_name" {
    description = "Name assigned to the DynamoDB table."
    value       = aws_dynamodb_table.main.name
}

output "table_id" {
    description = "Identifier of the DynamoDB table."
    value       = aws_dynamodb_table.main.id
}

output "table_arn" {
    description = "ARN of the DynamoDB table."
    value       = aws_dynamodb_table.main.arn
}

output "table_billing_mode" {
    description = "Billing mode configured for the DynamoDB table."
    value       = aws_dynamodb_table.main.billing_mode
}

output "table_hash_key" {
    description = "Primary hash key of the DynamoDB table."
    value       = aws_dynamodb_table.main.hash_key
}

output "table_range_key" {
    description = "Primary range key of the DynamoDB table when defined."
    value       = try(aws_dynamodb_table.main.range_key, null)
}

output "table_read_capacity" {
    description = "Provisioned read capacity when billing mode is PROVISIONED."
    value       = try(aws_dynamodb_table.main.read_capacity, null)
}

output "table_write_capacity" {
    description = "Provisioned write capacity when billing mode is PROVISIONED."
    value       = try(aws_dynamodb_table.main.write_capacity, null)
}

output "table_stream_arn" {
    description = "Stream ARN emitted by the DynamoDB table when streams are enabled."
    value       = try(aws_dynamodb_table.main.stream_arn, null)
}

output "table_global_secondary_indexes" {
    description = "Global secondary indexes configured on the DynamoDB table."
    value       = try(aws_dynamodb_table.main.global_secondary_index, [])
}
