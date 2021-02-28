if which exiftool >/dev/null; then
	echo "Dependencies already installed and work correctly."
	exit
fi

VERSION=Image-ExifTool-12.19

echo "Downloading dependencies... exiftool"
curl -s https://exiftool.org/$VERSION.tar.gz --output /tmp/$VERSION.tar.gz >/dev/null

echo "Installing dependencies... exiftool"
tar -xzf /tmp/$VERSION.tar.gz -C /tmp >/dev/null
mv /tmp/$VERSION/lib /usr/local/bin
mv /tmp/$VERSION/exiftool /usr/local/bin/exiftool

echo "Cleaning up..."
rm /tmp/$VERSION.tar.gz
rm -rf /tmp/$VERSION

echo "Testing dependencies..."
if which exiftool >/dev/null; then
  echo "Dependencies installed correctly."
else
  echo "Error installing dependencies. Please install exiftool manually."
  exit 1
fi;

echo "Installing gem...vera"
gem install vera
