
$ docker build .
$ docker run -p 3000:80 -v `pwd`/example_app:/app -e "APP=ecosystem.yml" <container id>
