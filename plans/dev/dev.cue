package todoapp

import (
    "alpha.dagger.io/dagger"
    "alpha.dagger.io/docker"
    "alpha.dagger.io/os"
)

// docker local socket
dockerSocket: dagger.#Stream & dagger.#Input

// run our todoapp in our local Docker engine
run: docker.#Run & {
    ref:  push.ref
    name: "todoapp"
    ports: ["8080:80"]
    socket: dockerSocket
}

// run our local registry
registry: docker.#Run & {
    ref: "registry:2"
    recreate: false
    name: "registry-demo-dev"
    ports: ["51051:5000"]
    socket: dockerSocket
}

// package the static HTML from yarn into a Docker image
image: os.#Container & {
    image: docker.#Pull & {
        from: "nginx"
    }

    // app.build references our app key above
    // which infers a dependency that Dagger
    // uses to generate the DAG
    copy: "/usr/share/nginx/html": from: app.build
}

// push the image to a registry
push: docker.#Push & {
    // leave target blank here so that different
    // environments can push to different registries
    target: "localhost:51051/todoapp"

    // the source of our push resource
    // is the image resource we declared above
    source: image
}

// output the application URL
appURL: "http://localhost:8080/" & dagger.#Output
