source_images=$1
target_tag=${2:-"latest"}
composefile=${3:-"docker-compose.yml"}

echo "tag to search for: $target_tag"
echo "compose file: $composefile"

split() {
    local string="$1"
    local delimiter="$2"
    if [ -n "$string" ]; then
        local part
        while read -d "$delimiter" part; do
            echo $part
        done <<< "$string"
        echo $part
    fi
}

images=$(split $source_images ";")

echo "got images to replace:"
for image in $images
do
   echo "$image"
done

for image in $images
do
  image_no_tag=$(echo "$image" | awk '{split($0,a,"[:]"); print a[1]}')
  image_tag=$(echo "$image" | awk '{split($0,a,"[:]"); print a[2]}')
  image_to_set="$image_no_tag:$target_tag"
  
  echo "replacing $image with $image_to_set"

  if [[ -z "$image_tag" ]]; then
    sed -i -e "s|$image_no_tag$|$image_to_set|g" "$composefile"
    sed -i -e "s|$image_no_tag:.*|$image_to_set|g" "$composefile"
  else
    sed -i -e "s|$image_no_tag:$image_tag|$image_to_set|g" "$composefile"
  fi
done