module "subscriptions" {
  for_each = local.subscriptions

  depends_on = [module.queues, module.topics]

  source  = "cloudchacho/hedwig-subscription/google"
  version = ">= 3.4, <4"

  queue                   = each.value.queue
  topic                   = each.value.project != null ? "projects/${each.value.project}/topics/hedwig-${each.value.topic}" : module.topics[each.value.topic].name
  enable_message_ordering = each.value.enable_ordering
  iam_service_account     = each.value.service_account
  disable_dlq             = each.value.disable_dlq != null ? each.value.disable_dlq : false

  labels = each.value.labels
}
