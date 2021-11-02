package todoapp

import (
    "alpha.dagger.io/netlify"
)

// Build the source code using Yarn
site: netlify.#Site & {
    // deploy the yarn build result
    contents: app.build

    // Netlify Site name
    name: string | *"demo-todoapp-staging"
}
