module "topics" {
  for_each = var.topics

  # source  = "cloudchacho/hedwig-topic/google"
  # version = ">= 2.2, <3"
  # source = "../terraform-google-hedwig-topic"
  source = "git::https://github.com/max-standard/terraform-google-hedwig-topic.git?ref=firehose-reloaded"

  topic = each.key

  enable_firehose_all_messages = var.enable_firehose_all_topics || each.value.enable_firehose == true
  firehose_bucket              = each.value.firehose_bucket
  firehose_prefix              = each.value.firehose_prefix

  iam_service_accounts = each.value.service_accounts
  iam_members          = each.value.iam_members
}
