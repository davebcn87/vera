if which exiftool >/dev/null; then
	echo "Dependencies already installed and work correctly."
	exit
fi

VERSION=Image-ExifTool-12.19

BIN="$HOME/.local/bin"
mkdir -p $BIN
echo "Downloading dependencies... exiftool"
curl -s https://exiftool.org/$VERSION.tar.gz --output $BIN/$VERSION.tar.gz >/dev/null

echo "Installing dependencies... exiftool"
tar -xzf $BIN/$VERSION.tar.gz -C $BIN >/dev/null
mv $BIN/$VERSION/lib $BIN
mv $BIN/$VERSION/exiftool $BIN/exiftool
rm $BIN/$VERSION.tar.gz
rm -rf $BIN/$VERSION
