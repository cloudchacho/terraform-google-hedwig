module "topics" {
  for_each = var.topics

  # source  = "cloudchacho/hedwig-topic/google"
  # version = ">= 2.2, <3"
  source = "/Users/max/terraform-google-hedwig-topic"
  # source = "git::https://github.com/max-standard/terraform-google-hedwig-topic.git?ref=firehose-reloaded"

  topic                = each.key
  firehose_config      = each.value.firehose_config
  iam_service_accounts = each.value.service_accounts
  iam_members          = each.value.iam_members
}
