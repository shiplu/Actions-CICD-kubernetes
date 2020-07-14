# Spring boot tags the image as demo
FROM demo

# Become root to install as default user is cnb
USER root
RUN apt-get -y update && apt-get install -y curl

# Get back to old user
USER cnb
