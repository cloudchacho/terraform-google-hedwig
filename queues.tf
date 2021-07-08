module "queues" {
  for_each = var.pull_consumers

  source  = "cloudchacho/hedwig-queue/google"
  version = ">= 3, <4"

  queue               = each.key
  iam_service_account = each.value.service_account

  labels = each.value.labels
}
