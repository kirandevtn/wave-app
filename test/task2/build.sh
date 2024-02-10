 
#!/bin/bash

# Clone the Git repository
git clone "$1" temp_repo
cd temp_repo || exit 1

# Check if the repository was cloned successfully
if [ $? -eq 0 ]; then
    echo "Repository cloned successfully!"
else
    echo "Failed to clone repository. Please check the URL and try again."
    exit 1
fi

# Check if a file path is provided as the second argument
if [ -z "$2" ]; then
    echo "Please provide the path of the file to check."
    exit 1
fi

# Read the content of the file
file_content=$(<"$2")

# Detect the language based on common identifiers
if [[ $file_content == *"<?php"* ]]; then
    lang="PHP"

elif [[ $file_content == *"<html"* ]]; then
    lang="HTML"
fi

if [[ $lang == "HTML" ]]
then 
    touch Dockerfile
    echo "FROM nginx:alpine" >> Dockerfile
    echo "COPY index.html /usr/share/nginx/html/"  >> Dockerfile
    docker build -t kirandevtn/html-image .
    docker run -d -p 3000:80 html-image

elif [[ $lang == "PHP" ]]
then 
    touch Dockerfile
    echo "FROM php:8.2-cli" >> Dockerfile
    echo "COPY . /usr/src/myapp" >> Dockerfile
    echo "WORKDIR /usr/src/myapp" >> Dockerfile
    echo 'CMD [ "php", "./index.php" ]' >> Dockerfile
    docker build -t php-image .
    docker run -d -p 3001:80 php-image
fi
#/temp_repo/

# Cleanup: Remove the temporary directory
cd ..
rm -rf temp_repo