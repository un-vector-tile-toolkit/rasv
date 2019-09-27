task :default do
  sh "docker build -t rasv:test ."
end

task :armhf do
  sh "docker build --no-cache -t unvt/rasv:armhf ."
  sh "docker push unvt/rasv:armhf"
end

task :amd64 do
  sh "docker build --no-cache -t unvt/rasv:amd64 ."
  sh "docker push unvt/rasv:amd64"
end

task :latest do
  sh "docker manifest push --purge unvt/rasv:latest"
  sh "docker manifest create --amend unvt/rasv:latest unvt/rasv:armhf unvt/rasv:amd64"
  sh "docker manifest push unvt/rasv:latest"
end

task :scratch do
  sh "docker build --no-cache -t rasv:latest ."
end

task :run do
  sh "docker run --volume /mnt/s:/mnt/s -ti --rm rasv:latest bash"
end

