locals {
    table_name = "${var.prefix}-${var.project_name}-${var.environment}-${var.table_name}"
}

resource "aws_dynamodb_table" "main" {
    name = local.table_name
    billing_mode = var.billing_mode
    hash_key = var.hash_key
    range_key = var.range_key != "" ? var.range_key : null

    read_capacity = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
    write_capacity = var.billing_mode == "PROVISIONED" ? var.write_capacity : null

    dynamic "attribute" {
        for_each = var.attributes
        content {
            name = attribute.value.name
            type = attribute.value.type
        }
    }

    dynamic "global_secondary_index" {
        for_each = var.global_secondary_indexes
        content {
            name = global_secondary_index.value.name
            hash_key = global_secondary_index.value.hash_key
            range_key = global_secondary_index.value.range_key
            write_capacity = global_secondary_index.value.write_capacity
            read_capacity = global_secondary_index.value.read_capacity
            projection_type = global_secondary_index.value.projection_type
        }
    }

    dynamic "ttl" {
        for_each = var.ttl_enabled ? [1] : []
        content {
            enabled = true
            attribute_name = var.ttl_attribute_name
        }
    }

    tags = {
        Name = local.table_name
    }
}