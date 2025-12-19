resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = var.dashboard_name

  dashboard_body = jsonencode({
    widgets = [
      ############################################
      # ECS: CPU
      ############################################
      {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ServiceName", var.service_name, "ClusterName", var.cluster_name, { stat = "Average" }]
          ]
          period = 300
          stat   = "Average"
          region = var.region
          title  = "ECS CPU Utilization"
          yAxis  = { left = { min = 0, max = 100 } }
        }
      },

      ############################################
      # ECS: Memory
      ############################################
      {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ECS", "MemoryUtilization", "ServiceName", var.service_name, "ClusterName", var.cluster_name, { stat = "Average" }]
          ]
          period = 300
          stat   = "Average"
          region = var.region
          title  = "ECS Memory Utilization"
          yAxis  = { left = { min = 0, max = 100 } }
        }
      },

      ############################################
      # ECS: Running vs Desired vs Pending tasks
      ############################################
      {
        type   = "metric"
        width  = 24
        height = 6
        properties = {
          metrics = [
            ["AWS/ECS", "RunningTaskCount", "ServiceName", var.service_name, "ClusterName", var.cluster_name, { stat = "Average" }],
            [".", "DesiredTaskCount", "ServiceName", var.service_name, "ClusterName", var.cluster_name, { stat = "Average" }],
            [".", "PendingTaskCount", "ServiceName", var.service_name, "ClusterName", var.cluster_name, { stat = "Average" }]
          ]
          period = 60
          region = var.region
          title  = "ECS Tasks (Running vs Desired vs Pending)"
          yAxis  = { left = { min = 0 } }
        }
      },

      ############################################
      # ALB: RequestCount
      ############################################
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

      ############################################
      # ALB: 5XX errors (Target + ELB)
      ############################################
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

      ############################################
      # ALB: Latency + Health
      ############################################
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
      }
    ]
  })
}
