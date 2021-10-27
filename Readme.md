# this is a tiny skeleton for a node-js app
theres no deps to install, the container image is 21mb (16.5 compressed, accoring to dockerhub)

server.mjs behaves kind of like express. if you need fancier behavior: bother me,
i have more fully-fleshed-out versions of it laying around in other repos.

if you add dependencies, this will bloat fast. you should use dive to inspect the layers of 
the container image and modify the dockerfile to remove large bits of dependencies that
you don't need.
