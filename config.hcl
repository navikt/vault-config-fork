mount "app1" {
  path = "example/app1"
  config = {
    type = "generic"
    description = "Example App 1"
  }
  mountconfig {
    default_lease_ttl = "20h"
    max_lease_ttl = "768h"
  }
}

mount "pki" {
  path = "pki"
  config = {
    type = "pki"
    description = "My cool PKI backend"
  }
  mountconfig {
    default_lease_ttl = "768h"
    max_lease_ttl = "768h"
  }
}

mount "app2" {
  path = "example/app2"
  config = {
    type = "generic"
    description = "Example App 2"
  }
  mountconfig {
    default_lease_ttl = "1h"
    max_lease_ttl = "24h"
  }
}


policy "example-policy-1" {
  rules =<<EOF
# Allow to make changes to /example/app1 mount
path "example/app1" {
    capabilities = ["create", "read", "update", "delete", "list"]
}
EOF
}

policy "example-policy-2" {
  rules =<<EOF
# Allow to make changes to /example/app2 mount
path "example/app2" {
    capabilities = ["create", "read", "update", "delete", "list"]
}
EOF
}

token_role "example_period_token_role" {
  options {
    allowed_policies = "example-policy-1,example-policy-2"
    period = 20
    renewable = true
  }
}

auth {
  ldap {
    description = "LDAP Auth backend config"
    authconfig {
      binddn = "CN=SamE,CN=Users,DC=test,DC=local"
      bindpass = "z"
      url = "ldap://10.255.0.30"
      userdn = "CN=Users,DC=test,DC=local"
    }
    group "groupa" {
      options {
        policies = "example-policy-1"
      }
    }
    user "same" {
      options {
        policies = "example-policy-1,example-policy-2"
      }
    }
    mountconfig {
      default_lease_ttl = "1h"
      max_lease_ttl = "24h"
    }
  }
  github {
    authconfig = {
      organization = "testorg"
    }
  }
}
