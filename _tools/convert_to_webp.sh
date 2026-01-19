#!/bin/bash

#
# This script finds image files starting with "600" in a source directory,
# converts them to the WebP format, and saves them in a destination directory.
#

# Set the source and destination directories
# Using $HOME instead of ~ for better script portability
SOURCE_DIR="$HOME/Documents/Oepicus/Renders"
DEST_DIR="assets/products"

# Exit if the source directory doesn't exist
if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: Source directory not found at $SOURCE_DIR"
  exit 1
fi

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

echo "Starting conversion..."

# Loop through all files in the source directory starting with "600"
# The glob pattern handles finding the files.
for file_path in "$SOURCE_DIR"/600*; do
  # Check if any file matches the pattern to avoid errors
  if [ -f "$file_path" ]; then
    # Get just the filename from the full path
    filename=$(basename "$file_path")

    # Define destination paths
    dest_original_path="$DEST_DIR/$filename"

    # Create the new filename by replacing the old extension with .webp
    # ${filename%.*} removes the extension from the original filename.
    webp_filename="${filename%.*}.webp"
    output_path="$DEST_DIR/$webp_filename"

    # Only copy if the source is newer or the destination doesn't exist
    if [ ! -f "$dest_original_path" ] || [ "$file_path" -nt "$dest_original_path" ]; then
      echo "Copying '$filename' to '$DEST_DIR'..."
      cp "$file_path" "$dest_original_path"
    fi

    # Only convert to webp if the source is newer or the webp file doesn't exist
    if [ ! -f "$output_path" ] || [ "$file_path" -nt "$output_path" ]; then
      echo "Converting '$filename' to '$webp_filename'..."
      cwebp -q 80 "$file_path" -o "$output_path"
    fi
  fi
done

echo "Conversion complete. Files are in $DEST_DIR"
