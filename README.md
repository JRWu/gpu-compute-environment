# A docker-compose compute environment for gpu-computing.
```
Features Cuda compilation tools, release 10.0, V10.0.130
NVIDIA SMI Driver version 410.48
```

# Quickstart 
NOTE: This quickstart guide assumes you have installed docker-ce, NVIDIA driver, cuda, nvidia-cuda-toolkit and nvidia-docker.

1. Clone the repository
`git clone git@github.com:JRWu/gpu-compute-environment.git`

2. Change directories into the repository.
`cd gpu-compute-environment/`

3. Build the container.
`docker-compose up --build -d`

4. Shell into the goup compute environment.
`docker-compose exec project bash`


# GUIDE FOR A FRESH LINUX INSTALL WITH NO NVIDIA DRIVERS INSTALLED
NOTE: This guide assumes NVIDIA hardware running ontop of Ubuntu 18.04.

1. Install stable docker-ce. 
```
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce
```

(Optional) Perform post-install docker instructions in order to run docker as root.
```
sudo groupadd docker
sudo usermod -aG docker $USER
```
NOTE: You must restart your shell or your computer for the docker permission changes to take effect.

2. Download and Install the NVIDIA driver from:
https://www.nvidia.com/content/DriverDownload-March2009/confirmation.php?url=/XFree86/Linux-x86_64/410.66/NVIDIA-Linux-x86_64-410.66.run&lang=us&type=TITAN

```
# Assuming you downloaded into the Downloads directory:
cd /home/$USER/Downloads
chmod +x NVIDIA-Linux-x86_64-410.66.run
sudo ./NVIDIA-Linux-x86_64-410.66.run

# Follow the recommended instructions for the installation.
```

3. Download and Install the NVIDIA cuda toolkit from:
https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=1804&target_type=deblocal

Assuming you downloaded into the Downloads directory:
```
cd /home/$USER/Downloads
sudo dpkg -i cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_amd64.deb
sudo apt-key add /var/cuda-repo-10-0-local-10.0.130-410.48/7fa2af80.pub
sudo dpkg -i cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_amd64.deb
sudo apt-get update
sudo apt install -y cuda nvidia-cuda-toolkit
```

At this point, you must reboot your PC in order for the driver changes to take effect.

4. Install the nvidia-docker runtime.
```
# If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
sudo apt-get purge -y nvidia-docker

# Add the package repositories
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - 
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update

# Install nvidia-docker2 and reload the Docker daemon configuration
sudo apt-get install -y nvidia-docker2
sudo pkill -SIGHUP dockerd

# Test nvidia-smi with the latest official CUDA image
docker run --runtime=nvidia --rm nvidia/cuda:9.0-base nvidia-smi
```

If the command did not throw an error, you may proceed to the Quickstart portion.

