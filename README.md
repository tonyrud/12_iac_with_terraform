# Terraform Playground

Playground for examples and following along with Techdegree

## CMDs

Create resources in dev env. Deploys into `us-east-2` via variable

```make
make terraform_apply ENV=dev
```

```make
make terraform_destroy ENV=dev
```

## TODO

- make easier to deploy in different regions. Dir structure matches regions
- use dir name for env deployed..ie `/live/dev` is "dev" environment