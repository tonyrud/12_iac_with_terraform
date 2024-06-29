DIR = ./live/$(ENV)

terraform_init:
	cd $(DIR); terraform init
	cd $(DIR); terraform fmt
	cd $(DIR); terraform validate

terraform_plan: terraform_init
	cd $(DIR); terraform plan

terraform_apply: terraform_init
	cd $(DIR); terraform apply

terraform_destroy:
	cd $(DIR); terraform destroy

terraform: terraform_apply 
