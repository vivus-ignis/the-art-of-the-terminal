# InvokeAI setup for older GPUs

## Requirements

- [asdf](https://github.com/asdf-vm/asdf)

```bash
cd ~/apps
mkdir invokeai
cd invokeai
asdf plugin add uv
asdf install uv 0.9.17
asdf set uv 0.9.17
uv venv --relocatable --prompt invoke --python 3.12 --python-preference only-managed .venv
. .venv/bin/activate
uv pip install invokeai[xformers] --python 3.12 --python-preference only-managed --torch-backend=cu128 --force-reinstall
uv pip install torch=='2.7.0'
deactivate && source .venv/bin/activate
echo 'enable_partial_loading: true' >> invokeai.yaml
invokeai-web --root ~/apps/invokeai
```

# Comfy setup for older GPUs

## Requirements

- [pipx](https://github.com/pypa/pipx)

```bash
pipx install comfy-cli
comfy install
~/.local/share/pipx/venvs/comfy-cli/bin/python -m pip install torchvision=='0.22.0'
~/.local/share/pipx/venvs/comfy-cli/bin/python -m pip install torchaudio=='2.7.0'
~/.local/share/pipx/venvs/comfy-cli/bin/python -m pip install torch=='2.7.0'
comfy set-default ~/comfy/ComfyUI
comfy launch
```
