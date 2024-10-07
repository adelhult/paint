# Build paint and copy to static assets
# Not that nice... but it works
cd ..
gleam build

#echo "Copying paint library to to the static assets directory"
cp ./build/dev/javascript/ ./demo/static/paint_build -r

cd demo

#echo "Running Lustre static site generator"
gleam run -m build
