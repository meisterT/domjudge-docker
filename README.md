domjudge-docker
===============

WARNING: this is not (yet) meant to be used for more than demo and testing -- don't use for real contests

Requirements:
* recent version of docker
* cgroup enabled kernel

Use:
* ./create [repository-URL] (takes several minutes)
* docker run --privileged -p 127.0.0.1:12345:80 domjudge (also takes several minutes)
  (Use docker.io instead of docker on debian/Ubuntu)
* point your web browser to localhost:12345/domjudge (login with admin/admin)
