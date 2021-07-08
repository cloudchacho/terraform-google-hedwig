terraform {
  required_version = ">= 0.15, <2"

  experiments = [module_variable_optional_attrs]

  required_providers {
    google = ">= 3.16.0"
  }
}

