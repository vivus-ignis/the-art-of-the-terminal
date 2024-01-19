Direnv doesn't support poetry out of the box (see https://github.com/direnv/direnv/issues/592),
so you have to take an extra step to add it:

```bash
mkdir -p ~/.config/direnv
cat ./direnvrc >> ~/.config/direnv/direnvrc
```
