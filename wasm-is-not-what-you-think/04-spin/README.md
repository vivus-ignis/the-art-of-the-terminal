## Spin install

```bash
git clone https://github.com/fermyon/spin
cd spin
rustup target add wasm32-wasi
make build
./target/release/spin --help
export PATH=$PWD/target/release:$PATH
cd ..
spin templates install --git https://github.com/fermyon/spin-python-sdk --upgrade
spin templates list
spin plugins update
spin plugins search
spin new quotes
```

### Add to spin.toml

```toml
files = [ "quotes.json" ]
```

### Running the app locally

```bash
python -mvenv .venv
. .venv/bin/activate
pip install -r requirements.txt
spin up --build

# in another tab:
curl localhost:3000/?tag=optimism
```

## Spinkube

```bash
curl https://get.k0s.sh > k0s.sh
# review the script
sudo bash ./k0s.sh
sudo k0s install controller --single
sudo k0s start
sudo k0s status

# make sure your user is a member of 'root' group
export KUBECONFIG=/var/lib/k0s/pki/admin.conf
kubectl get nodes

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.3/cert-manager.yaml
kubectl wait --for=condition=available --timeout=300s deployment/cert-manager-webhook -n cert-manager

kubectl apply -f https://github.com/spinkube/spin-operator/releases/download/v0.3.0/spin-operator.runtime-class.yaml

kubectl apply -f https://github.com/spinkube/spin-operator/releases/download/v0.3.0/spin-operator.crds.yaml

kubectl apply -f https://github.com/spinkube/spin-operator/releases/download/v0.3.0/spin-operator.shim-executor.yaml

wget https://get.helm.sh/helm-v3.16.2-linux-amd64.tar.gz
tar xzf helm-v3.16.2-linux-amd64.tar.gz
export PATH=$PWD/linux-amd64:$PATH

helm install spin-operator \
  --namespace spin-operator \
  --create-namespace \
  --version 0.3.0 \
  --wait \
  oci://ghcr.io/spinkube/charts/spin-operator

helm repo add kwasm http://kwasm.sh/kwasm-operator/

helm install \
  kwasm-operator kwasm/kwasm-operator \
  --namespace kwasm \
  --create-namespace \
  --set kwasmOperator.installerImage=ghcr.io/spinkube/containerd-shim-spin/node-installer:v0.16.0

kubectl annotate node --all kwasm.sh/kwasm-node=true

cat /etc/k0s/containerd.d/spin.yaml

spin plugin install kube

spin registry push --build ttl.sh/taoftt-phrases:1h
kubectl get deployment

kubectl get deployment taoftt-phrases -o yaml | less

kubectl get pod

kubectl get services
kubectl port-forward svc/taoftt-phrases 8000:80

# open another tab:
curl http://localhost:8000?tag=experience
```
