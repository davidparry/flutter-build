# flutter-build 
An image to use in CID pipelines like bitbucket for your project to build Flutter 2.8.1 Apps

# docker commands to update to build and push
docker build . -t davidparry/flutter-build:{tag}
docker push davidparry/flutter-build:{tag}
