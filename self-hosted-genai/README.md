Break Free from ChatGPT, Midjourney: Unleash SELF-HOSTED GenAI!
---------------------------------------------------------------

## Tools I Use

- LLM backend: https://ollama.com/
- Chat frontend: https://github.com/open-webui/open-webui
- Images generation frontend: https://github.com/invoke-ai

### OpenWebUI extensions

- functions: https://docs.openwebui.com/features/plugin/functions/
- tools: https://docs.openwebui.com/features/plugin/tools/

### Notable Alternatives

- alternative to OpenWebUI: https://github.com/SillyTavern/SillyTavern

## Images Generation

### How stable diffusion works

- https://bipinkrishnan.github.io/posts/getting-started-in-the-world-of-stable-diffusion/
- https://stable-diffusion-art.com/how-stable-diffusion-work/

### Prompts

- SD prompt guide: https://stable-diffusion-art.com/prompt-guide/

### Models

- using controlnets in InvokeAI https://www.youtube.com/watch?v=kYQaZOG95-g&list=PLn4FL274Scym3h6HyoqcKC2gLF23wRL2F&index=48&t=360s
- in-depth on VAEs https://towardsdatascience.com/intuitively-understanding-variational-autoencoders-1bfe67eb5daf

### Getting trigger keywords from LoRA metadata

```bash
tail -c +9 Retro\ Digital\ v1.0.safetensors \
  | jq -r .__metadata__.ss_tag_frequency \
  | jq -rM . \
  | grep ': [1-9]' \
  | awk -F ':' '{print $2, $1}' \
  | sort -nr \
  | head
```
