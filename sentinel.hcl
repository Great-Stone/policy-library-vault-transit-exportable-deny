module "tfplan-functions" {
  source = "./modules/tfplan-functions.sentinel"
}

policy "transit_exportable_deny" {
  source = "./policies/transit_exportable_deny.sentinel"
  enforcement_level = "soft-mandatory"
}