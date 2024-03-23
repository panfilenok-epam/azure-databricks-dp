locals {
    # The name of the package. This name must be the same as the name of the package defined in the setup.py file.
  wheel_package_name = "dabdemo"

  # The entry point of the package. This is the name of the function that is called when the package is executed.
  # The function must be defined in the setup.py file of the package. See: /Libraries/python/dabdemo/setup.py
  wheel_package_entry_point = "my_entry_point_fn"

  # The file name consists of the package name, version, python version, platform and architecture
  # The name and the version are defined in the setup.py file of the package. See: /Libraries/python/dabdemo/setup.py
  # See https://peps.python.org/pep-0427 for more information about the wheel package.
  # This file must be located in the rettaform module folder.
  wheel_package_file_name = "dabdemo-0.0.1-py3-none-any.whl"
}

variable "databricks_workspace_url" {
  description = "The URL of the Databricks workspace."
  type = string 
}

variable "databricks_workspace_id" {
  description = "The ID of the Databricks workspace."
  type = string 
}

variable "databricks_cluster_id" {
  description = "The ID of the Databricks cluster."
  type = string
}

terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.0"
    }
  }

  backend "azurerm" {
  }

  required_version = ">= 1.1.0"
}

provider "databricks" {
  host                        = var.databricks_workspace_url
  azure_workspace_resource_id = var.databricks_workspace_id
}

resource "databricks_dbfs_file" "wheel_package_file" {
  source   = "${path.module}/${local.wheel_package_file_name}"
  path     = "/libraries/${local.wheel_package_file_name}"
}

resource "databricks_job" "db_jpb" {

  name     = "Databricks Job runnung by schedule"
  schedule {
    quartz_cron_expression = "0 0 */6 * * ?"
    timezone_id            = "Etc/UTC"
  }

  task {
    # It's required because the current version of the provider treats task blocks as an ordered list.
    # https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/job
    task_key            = "A"
    existing_cluster_id = var.databricks_cluster_id

    library {
      whl = "dbfs:${databricks_dbfs_file.wheel_package_file.path}"
    }

    python_wheel_task {
      entry_point  = local.wheel_package_entry_point
      package_name = local.wheel_package_name
    }
  }
}