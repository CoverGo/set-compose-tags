# set-compose-tags
Github action to change images tags in a docker-compose files. Usefull for development or integration testing purposes when you need a part of images from a main registry with stable verions, and another bunch of images should be taken different, specific to your branch. 

## Usage
```yml
    - name: Prepare compose file
      uses: ./.github/actions/set-compose-tags
      with:
        images: company/my_image;another_company/image;
        target-tag: ${{ needs.version.outputs.issue_id_slug }} # or any fixed value
        compose-file: docker-compose.yml
```
## Parameters
**compose-file** path to docker compose file to manipulate
**images** semilion-separated list of images to search for
**target-tag** tag to set on images specified
## Outputs
 None. All changes are performed in the target file. 
