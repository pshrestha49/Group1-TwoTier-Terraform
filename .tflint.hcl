plugin "aws" {
    enabled = true
    version = "0.21.1"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule "terraform_required_version" {
    enabled = false
}

rule "terraform_required_providers" {
    enabled = false
}

rule "terraform_typed_variables" {
    enabled = true
}

rule "terraform_unused_declarations" {
    enabled = true
}
