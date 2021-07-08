module "subscriptions" {
  for_each = local.subscriptions

  source  = "cloudchacho/hedwig-subscription/google"
  version = ">= 3, <4"

  queue                   = each.value.queue
  topic                   = each.value.project != null ? "projects/${each.value.project}/topics/hedwig-${each.value.topic}" : "hedwig-${each.value.topic}"
  enable_message_ordering = each.value.enable_ordering

  labels = each.value.labels
}
