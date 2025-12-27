resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = var.dashboard_name

  dashboard_body = jsonencode({
    widgets = [

      {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", var.cluster_name, "ServiceName", var.service_name, { stat = "Average" }]
          ]
          period = 300
          stat   = "Average"
          region = var.region
          title  = "ECS CPU Utilization"
          yAxis  = { left = { min = 0, max = 100 } }
        }
      },

      {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ECS", "MemoryUtilization", "ClusterName", var.cluster_name, "ServiceName", var.service_name, { stat = "Average" }]
          ]
          period = 300
          stat   = "Average"
          region = var.region
          title  = "ECS Memory Utilization"
          yAxis  = { left = { min = 0, max = 100 } }
        }
      },

      {
        type   = "metric"
        width  = 24
        height = 6
        properties = {
          metrics = [
            ["ECS/ContainerInsights", "RunningTaskCount", "ClusterName", var.cluster_name, "ServiceName", var.service_name, { stat = "Sum" }],
            [".", "DesiredTaskCount", "ClusterName", var.cluster_name, "ServiceName", var.service_name, { stat = "Sum" }],
            [".", "PendingTaskCount", "ClusterName", var.cluster_name, "ServiceName", var.service_name, { stat = "Sum" }]
          ]
          period = 60
          region = var.region
          title  = "ECS Tasks (Running vs Desired vs Pending)"
          yAxis  = { left = { min = 0 } }
        }
      },

      {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", var.alb_arn_suffix, { stat = "Sum" }]
          ]
          period = 300
          region = var.region
          title  = "ALB RequestCount"
        }
      },

      {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "TargetGroup", var.target_group_arn_suffix, "LoadBalancer", var.alb_arn_suffix, { stat = "Sum" }],
            ["AWS/ApplicationELB", "HTTPCode_ELB_5XX_Count", "LoadBalancer", var.alb_arn_suffix, { stat = "Sum" }]
          ]
          period = 300
          region = var.region
          title  = "ALB 5XX Errors (Target + ELB)"
          yAxis  = { left = { min = 0 } }
        }
      },

      {
        type   = "metric"
        width  = 24
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", "TargetGroup", var.target_group_arn_suffix, "LoadBalancer", var.alb_arn_suffix, { stat = "Average" }],
            ["AWS/ApplicationELB", "HealthyHostCount", "TargetGroup", var.target_group_arn_suffix, "LoadBalancer", var.alb_arn_suffix, { stat = "Average" }],
            [".", "UnHealthyHostCount", "TargetGroup", var.target_group_arn_suffix, "LoadBalancer", var.alb_arn_suffix, { stat = "Average" }]
          ]
          period = 300
          region = var.region
          title  = "Target Group (Latency + Healthy/Unhealthy)"
          yAxis  = { left = { min = 0 } }
        }
      },

      {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/DynamoDB", "ThrottledRequests", "TableName", var.dynamodb_table_name, { stat = "Sum" }],
            [".", "SystemErrors", "TableName", var.dynamodb_table_name, { stat = "Sum" }],
            [".", "UserErrors", "TableName", var.dynamodb_table_name, { stat = "Sum" }]
          ]
          period = 300
          region = var.region
          title  = "DynamoDB (Throttles + Errors)"
          yAxis  = { left = { min = 0 } }
        }
      },

      {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/DynamoDB", "ConsumedReadCapacityUnits", "TableName", var.dynamodb_table_name, { stat = "Sum" }],
            [".", "ConsumedWriteCapacityUnits", "TableName", var.dynamodb_table_name, { stat = "Sum" }]
          ]
          period = 300
          region = var.region
          title  = "DynamoDB (Consumed Capacity)"
          yAxis  = { left = { min = 0 } }
        }
      },

      {
        type   = "metric"
        width  = 24
        height = 6
        properties = {
          metrics = [
            ["AWS/DynamoDB", "SuccessfulRequestLatency", "TableName", var.dynamodb_table_name, { stat = "Average" }]
          ]
          period = 300
          region = var.region
          title  = "DynamoDB (SuccessfulRequestLatency - Avg)"
          yAxis  = { left = { min = 0 } }
        }
      }
    ]
  })
}
