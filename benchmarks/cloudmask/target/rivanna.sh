#!/bin/sh
#SBATCH --job-name=cloudmask.sh
#SBATCH --output=cloudmask.log
#SBATCH --error=cloudmask.error
#SBATCH --partition=gpu
#SBATCH --cpus-per-task=1
#SBATCH --mem=32GB
#SBATCH --time=59:00
#SBATCH --gres=gpu:a100:1

## to run this say sbatch rivanna.sh

echo "# cloudmesh status=running progress=1 pid=$$"

nvidia-smi --list-gpus

# conda install pip
echo "# cloudmesh status=running progress=50 pid=$$"
#conda install pytorch torchvision -c pytorch
#conda install py-cpuinfo
#conda install --file requirements.txt
echo "# cloudmesh status=running progress=60 pid=$$"
module load singularity tensorflow/2.8.0
module load cudatoolkit/11.0.3-py3.8
module load cuda/11.4.2
module load cudnn/8.2.4.15
module load anaconda/2020.11-py3.8

conda create --name MLBENCH python=3.8
source activate MLBENCH
# conda activate MLBENCH

pip install tensorflow-gpu
pip install scikit-learn
pip install h5py
pip install pyyaml

cms set host=rivanna
cms set cpu=IntelXeonE5-2630
cms set device=rivanna
echo "# cloudmesh status=running progress=70 pid=$$"

cd /project/bii_dsc/cloudmask/science/benchmarks/cloudmask


#currentgpu=$(echo $(cms set currentgpu) | sed -e "s/['\"]//g" -e "s/^\(currentgpu=\)*//")
#currentgpu=a100

#python run_all_rivanna.py
python slstr_cloud.py --config ./cloudMaskConfig.yaml
#python mnist_with_pytorch.py > mnist_with_pytorch_py_$(echo $currentgpu).log 2>&1
echo "# cloudmesh status=done progress=100 pid=$$"
# python mlp_mnist.py