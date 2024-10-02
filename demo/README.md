A few examples and a short introduction to the API.

Visit the version [hosted online](https://adelhult.github.io/paint/).

## Developing

Start Lustre dev server:
```sh
gleam run -m lustre/dev start
```

Build the Lustre app:
```sh
gleam run -m lustre/dev build app --minify
```

Update the referenced code snippets:
```sh
gleam run -m reference src/examples src/examples_code.gleam
```

Add a new example:
- Add a file in `src/examples/`
- Add the example picture to `demo.gleam`
- run `gleam run -m reference src/examples src/examples_code.gleam`
