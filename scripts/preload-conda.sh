#!/bin/bash

# Function to check if a specific package version is in the cache
is_package_cached() {
    package_name=$1
    package_version=$2
    conda search --info --use-index-cache $package_name==$package_version | grep -q "version: $package_version"
    return $?
}

# Function to install and remove a package to cache it
cache_package() {
    package_spec=$1
    conda install $package_spec -y
    conda remove $(echo $package_spec | cut -d= -f1) -y
}

# Function to build cache for TensorFlow and PyTorch
build_cache() {
    # Create base environment
    conda create -n cache-builder python=3.11 -y
    conda activate cache-builder

    # TensorFlow versions to cache
    TF_VERSIONS=("tensorflow==2.4.0" "tensorflow==2.5.0" "tensorflow tensorflow-gpu")
    
    for version in "${TF_VERSIONS[@]}"; do
        if ! is_package_cached tensorflow $(echo $version | grep -oP '\d+\.\d+\.\d+' || echo ""); then
            cache_package "$version"
        else
            echo "TensorFlow version $version is already cached."
        fi
    done

    # PyTorch versions to cache
    PYTORCH_PACKAGES=("pytorch==1.8.0 torchvision==0.9.0 torchaudio==0.8.0 cudatoolkit=10.2"
                      "pytorch torchvision torchaudio cudatoolkit"
                      "pytorch-cuda=11.8"
                      "pytorch-cuda=12.1")

    for package_spec in "${PYTORCH_PACKAGES[@]}"; do
        if [[ $package_spec == pytorch-cuda=* ]]; then
            version=$(echo $package_spec | grep -oP '\d+\.\d+')
            if ! is_package_cached pytorch-cuda $version; then
                cache_package "$package_spec -c pytorch -c nvidia"
            else
                echo "PyTorch version $package_spec is already cached."
            fi
        else
            if ! is_package_cached pytorch $(echo $package_spec | grep -oP '\d+\.\d+\.\d+' || echo ""); then
                cache_package "$package_spec -c pytorch"
            else
                echo "PyTorch package spec $package_spec is already cached."
            fi
        fi
    done

    # Deactivate and optionally remove the environment after caching
    conda deactivate
    conda env remove -n cache-builder -y
}

# Main execution
build_cache
