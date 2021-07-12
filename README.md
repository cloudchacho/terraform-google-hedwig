Hedwig Terraform module
=======================

[Hedwig](https://cloudchacho.github.io/hedwig) is a inter-service communication bus that works on AWS and GCP, while 
keeping things pretty simple and straight forward. It allows validation of the message payloads before they are sent,
helping to catch cross-component incompatibilities early.

This module provides a custom [Terraform](https://www.terraform.io/) modules for deploying Hedwig infrastructure that
creates infra for Hedwig consumer app.

## Usage 

```hcl
module "hedwig" {
  source   = "cloudchacho/hedwig/google"

  pull_consumers = {
    myapp : {
      subscriptions : {
        user-created-v1 : {}
      }
      labels : {
        "app" = "myapp"
        "env" = "dev"
      },
      service_account: "myapp@project.iam.gserviceaccount.com"
      high_message_count_threshold : 100000
    }
    other-app : {
      subscriptions : {
        project-id-user-updated-v1 : {
          project : "project-id"
          topic : "user-updated-v1"
          enable_ordering : true
          high_message_count_threshold : 100000
        }
      },
      labels : {
        cost-center : "foo"
      }
    }
  }
  topics = {
    user-created-v1 : {
      service_accounts: ["user-service@project.iam.gserviceaccount.com"]
    },
    user-updated-v1 : {
      enable_firehose : true
    }
  }
  queue_alert_notification_channels = ["projects/<projectid>/notificationChannels/<channelid>"]
  dlq_alert_notification_channels   = ["projects/<projectid>/notificationChannels/<channelid>"]
}
```

If using a single Google project for multiple environments (e.g. dev/staging/prod), ensure that `queue` includes 
your environment name.

Naming convention - lowercase alphanumeric and dashes only.

Please note Google's restrictions (if not followed, errors may be confusing and often totally wrong):
- [Labels](https://cloud.google.com/pubsub/docs/labels#requirements)
- [Resource names](https://cloud.google.com/pubsub/docs/admin#resource_names) 

The Google queue and subscription names will be prefixed by `hedwig-`.

## Release Notes

[Github Releases](https://github.com/cloudchacho/terraform-google-hedwig-queue/releases)

## How to publish

Go to [Terraform Registry](https://registry.terraform.io/modules/cloudchacho/hedwig-queue/google), and Resync module.
