task :default do
  sh "docker build -t rasv:latest ."
end

task :scratch do
  sh "docker build --no-cache -t rasv:latest ."
end

task :run do
  sh "docker run --volume /mnt/s:/mnt/s -ti --rm rasv:latest bash"
end

