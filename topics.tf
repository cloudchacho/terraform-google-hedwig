module "topics" {
  for_each = var.topics

  source  = "cloudchacho/hedwig-topic/google"
  version = ">= 3.0, <4"

  topic                = each.key
  firehose_config      = each.value.firehose_config
  iam_service_accounts = each.value.service_accounts
  iam_members          = each.value.iam_members
}
