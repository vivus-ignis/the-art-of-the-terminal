## Agentic coding harness underdog

### Links

- TeDDy https://github.com/atte500/TeDDy

- What is skill poisoning https://www.amitjadhav.com/skill-poisoning
- Skills poisoning library https://skillpoison.com
- Are local LLMs good enough? https://www.theregister.com/systems/2026/10/22/ibm-ceo-says-open-weight-models-are-now-irresistibly-good-and-cheap-on-prem/5304640
- "Concerning" (?) qwen3.8 behavior  https://cohere.com/blog/concerning-behaviour-popular-open-weight-ai-model
- 5 qwens beat fable https://github.com/guregodevo/memdoor/tree/main/examples/workflows/team-solve
- Ollama issues:
    - https://github.com/ollama/ollama/issues/7606 
    - https://github.com/ollama/ollama/issues/13235

### Setting up openshell with TeDDy

- clone this repo

```bash
git clone https://github.com/vivus-ignis/the-art-of-the-terminal.git
```

- install openshell

```bash
cd the-art-of-the-terminal/coding-harness-underdog/openshell
wget https://raw.githubusercontent.com/NVIDIA/OpenShell/main/install.sh
$EDITOR install.sh                              # ---> ALWAYS review! <---
bash ./install.sh
```

- make sure it runs

```bash
openshell status
systemctl --user status openshell-gateway
```

- build container & load profiles

```bash
docker build -t openshell-runner .
openshell profile import --file ./teddy-ollama.yaml
openshell profile import --file ./local-gitlab.yaml 
```

- create a sandbox

```bash
export GL_TOKEN=YOUR_GITLAB_PAT

openshell sandbox create \
  --name teddy-01 \
  --from openshell-runner \
  --provider teddy-ollama \
  --provider local-gitlab \
  --auto-providers -v
```

- load the code into the sandbox

```bash
git clone http://YOUR_LOCAL_GITLAB_IP:8282/GROUP/REPO.git
openshell sandbox upload -v --no-git-ignore teddy-01 .
openshell sandbox upload -v teddy-01 ../openshell/config .git
```

- monitor (in a separate terminal)

```bash
openshell term
```
