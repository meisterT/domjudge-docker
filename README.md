domjudge-docker
===============

**WARNING: this is not (yet) meant to be used for more than demo and testing -- don't use for real contests**

Requirements:
* recent version of docker
* cgroup enabled kernel
* sudo
* debootstrap

Use:
* `./create [repository-URL]` (takes approx. 15 minutes with a fast internet connection)
* `docker run --privileged -p 127.0.0.1:12345:80 domjudge`
  (Use `docker.io` instead of docker on debian/Ubuntu)
* point your web browser to `localhost:12345/domjudge` (login with `admin`/`admin`)

If you want to get a shell inside of the domjudge container, use:

`docker run -i -t --entrypoint="/bin/sh" --privileged -p 127.0.0.1:12345:80 domjudge -c bash`
