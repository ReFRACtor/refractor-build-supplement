# Command to copy over files. 
rsync -avz --delete --exclude="deprecated/" --exclude=".gitattributes" --exclude=".git/" --exclude="muses-conda-channel/" --exclude="*~" ../refractor-build-supplement/ ./
