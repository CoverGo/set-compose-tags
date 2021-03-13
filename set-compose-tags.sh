source_tag=${1:-"latest"}
target_tag=${2:-"latest"}
target_registry=$3
composefile=${4:-"docker-compose.yml"}

echo "tag to search for: $target_tag"
echo "target registry: $target_registry"
echo "compose file: $composefile"
echo "source tag: $source_tag"

images=$(grep '^\s*image' "$composefile" | sed 's/image://' | sort | uniq)

#echo "found images:"
#for image in $images
#do
#   echo "$image"
#done

for image in $images
do
  image_no_tag=$(echo "$image" | awk '{split($0,a,"[:]"); print a[1]}')
  image_tag=$(echo "$image" | awk '{split($0,a,"[:]"); print a[2]}')
  image_to_set="$image_no_tag:$target_tag"
  image_tag=${image_tag:-"latest"}
  
  echo "processing $image"
  if [[ "$image_tag" = "$source_tag" ]]; then
    echo "replacing "$image" with $image_to_set"
    sed -i -e "s|$image|$image_to_set|g" "$composefile"
  else
    echo "skipping due to tag mismatch"
  fi
  
done