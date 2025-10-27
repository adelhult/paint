Visit the version [hosted online](https://adelhult.github.io/paint/).

## Developing

Copy logo
```sh
mkdir -p ./priv/static
cp ../media/logo.svg ./priv/static/logo.svg
cp ../media/pixel_art_example.png ./priv/static/pixel_art_example.png
```

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
gleam run -m reference_this -- --allow-all-ext src/examples src/examples_code.gleam
```

Add a new example:
- Add a file in `src/examples/`
- Add the example picture to `demo.gleam`
- run `reference_this` tool as mentioned above
