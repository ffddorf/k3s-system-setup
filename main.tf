module "metallb" {
  source = "./modules/metallb"
}

module "test-app" {
  source = "./modules/test-app"
}

output "reflector_service_account_token" {
  value     = module.metallb.reflector_service_account_token
  sensitive = true
}
