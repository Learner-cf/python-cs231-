# cd cs231n/datasets
if (-Not (Test-Path "cifar-10-batches-py")) {
    Invoke-WebRequest -Uri "http://www.cs.toronto.edu/~kriz/cifar-10-python.tar.gz" -OutFile "cifar-10-python.tar.gz"
    tar -xzvf cifar-10-python.tar.gz
    Remove-Item "cifar-10-python.tar.gz"
    Invoke-WebRequest -Uri "http://cs231n.stanford.edu/imagenet_val_25.npz" -OutFile "imagenet_val_25.npz"
}
# cd ../..
