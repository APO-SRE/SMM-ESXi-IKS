# Providers ----------------------------------------------------------------------------------------
provider "intersight" {
  apikey    = var.apikey
  secretkey = var.secretkey
  endpoint  = var.endpoint
}

# Modules ------------------------------------------------------------------------------------------
module "iks_cluster" {
  source  = "terraform-cisco-modules/iks/intersight"
  version = "2.3.0"

  ip_pool = {
    use_existing = true
    name         = "APO-FSO-IKS-IP-POOL"
  }

  sysconfig = {
    use_existing = true
    name         = "APO-FSO-IKS-NODE-OS-CONFIG"
  }

  k8s_network = {
    use_existing = true
    name         = "APO-FSO-IKS-NETWORK-CIDR-DEMO"
  }

  # Version policy.
  versionPolicy = {
    useExisting = true
    policyName  = "APO-FSO-K8S-VERSION-DEMO"
  }

  tr_policy = {
    use_existing = false
    create_new   = false
    name         = "trusted-registry"
  }

  runtime_policy = {
    use_existing = false
    create_new   = false

#   name                 = "runtime"
#   http_proxy_hostname  = "t"
#   http_proxy_port      = 80
#   http_proxy_protocol  = "http"
#   http_proxy_username  = null
#   http_proxy_password  = null
#   https_proxy_hostname = "t"
#   https_proxy_port     = 8080
#   https_proxy_protocol = "https"
#   https_proxy_username = null
#   https_proxy_password = null
  }

  # Infra Config Policy Information.
  infraConfigPolicy = {
    use_existing = true
    policyName   = "APO-FSO-VM-INFRA-CONFIG-2201"
  }

  instance_type = {
    use_existing = true
    name         = "SMM-IKS-VM-INSTANCE-TYPE"
  }

  # Cluster information.
  cluster = {
    name                = var.cluster_name
    action              = var.action_type
    wait_for_completion = false
    worker_nodes        = 2
    load_balancers      = 1
    worker_max          = 3
    control_nodes       = 1
    ssh_user            = "iksadmin"
    ssh_public_key      = var.sshkey
  }

  # Organization and Tags.
  organization = var.organization
  tags         = var.tags
  
     addons       = [
    {
    use_existing = true
    createNew = false
    addonPolicyName = "smm-tf"
    #addonName            = "smm"
    #description       = "SMM Policy"
    #upgradeStrategy  = "AlwaysReinstall"
    #installStrategy  = "InstallOnly"
    releaseVersion = "1.7.4-cisco4-helm3"
    #overrides = yamlencode({"demoApplication":{"enabled":true}})
    },
    # {
    # createNew = true
    # addonName            = "ccp-monitor"
    # description       = "monitor Policy"
    # # upgradeStrategy  = "AlwaysReinstall"
    # # installStrategy  = "InstallOnly"
    # releaseVersion = "0.2.61-helm3"
    # # overrides = yamlencode({"demoApplication":{"enabled":true}})
    # }
  ]
}
