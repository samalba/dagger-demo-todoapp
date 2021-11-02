# Todo APP

[Dagger documentation website](https://docs.dagger.io/)

This demo deploys a javascript todo app on two environments:

1. `dev` using local containers
2. `staging` remotely to a Netlify Site

## Init the demo

```sh
rm -rf ./.dagger/
dagger init
```

## Create a local dev environment ("docker-compose like")

```sh
dagger new dev -p ./plans/dev
dagger input dir app.source ./todoapp -e dev
dagger input socket dockerSocket /var/run/docker.sock -e dev
dagger up -e dev
```

You know have a dev environment. Everytime you will type `dagger up -e dev` it
will re-deploy the source code the local containers.

## Create a staging environment (deploy to Netlify)

```sh
dagger new staging -p ./plans/staging
dagger input dir app.source ./todoapp -e staging
dagger input secret site.account.token <MY_NETLIFY_PERSONAL_TOKEN> -e staging
dagger up -e staging
```

NOTE: it's ok to commit the plans and inputs to GIT since Dagger secrets are
encrypted.

Now you can go back and forth between the local dev `dagger up -e dev` (to
local containers) and deploy to staging only when needed `dagger up -e staging
(to Netlify).
