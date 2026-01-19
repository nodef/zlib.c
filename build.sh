#!/usr/bin/env bash
# Fetch the latest version of the library
fetch() {
if [ -d "zlib" ]; then return; fi
URL="https://github.com/madler/zlib/archive/refs/heads/develop.zip"
ZIP="${URL##*/}"
DIR="zlib-develop"
mkdir -p .build
cd .build

# Download the release
if [ ! -f "$ZIP" ]; then
  echo "Downloading $ZIP from $URL ..."
  curl -L "$URL" -o "$ZIP"
  echo ""
fi

# Unzip the release
if [ ! -d "$DIR" ]; then
  echo "Unzipping $ZIP to .build/$DIR ..."
  cp "$ZIP" "$ZIP.bak"
  unzip -q "$ZIP"
  rm "$ZIP"
  mv "$ZIP.bak" "$ZIP"
  echo ""
fi
cd ..

# Copy the libs to the package directory
echo "Copying libs to zlib/ ..."
rm -rf zlib
mkdir -p zlib
cp -f ".build/$DIR/"*.c    zlib/
cp -f ".build/$DIR/"*.h    zlib/
cp -f ".build/$DIR/"*.h.in zlib/
echo ""
}


# Test the project
test() {
echo "Running 01-zpipe ..."
clang -I. -o 01.exe examples/01-zpipe.c   && cat zlib.h | ./01.exe && echo -e "\n"
echo "Running 02-fitblk ..."
clang -I. -o 02.exe examples/02-fitblk.c  && cat zlib.h | ./02.exe 512 && echo -e "\n"
}

# Main script
if [[ "$1" == "test" ]]; then test
elif [[ "$1" == "fetch" ]]; then fetch
else echo "Usage: $0 {fetch|test}"; fi
