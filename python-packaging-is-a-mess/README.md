Python Packaging Is A Mess
--------------------------

## Package managers I've stress-tested

- [pip-tools](https://github.com/jazzband/pip-tools)
- [pipenv](https://github.com/pypa/pipenv)
- [poetry](https://python-poetry.org/)
- [pdm](https://pdm-project.org)
- [pixi](https://github.com/prefix-dev/pixi)
- [rye](https://github.com/astral-sh/rye)
- [hatch](https://hatch.pypa.io)
- [huak](https://github.com/cnpryer/huak)
- [uv](https://github.com/astral-sh/uv)

## Other package managers mentioned in the episode

- [easy_install](https://setuptools.pypa.io/en/latest/deprecated/easy_install.html)
- [pip](https://pip.pypa.io)
- [conda](https://docs.conda.io/projects/conda/en/stable/)

## Poetry controversy

- [Caret-pinning considered harmful](https://iscinumpy.dev/post/poetry-versions/)
- [Poetry developers introduced a random chance of failing in CI environments](https://www.youtube.com/watch?v=Gr9o8MW_pb0)

## Tools mentioned in the episode

- [pipx: for "global" python tools installation](https://github.com/pypa/pipx)
- [bandir: security-focused python code checker](https://bandit.readthedocs.io/en/latest/index.html)
- [ruff: fast linter and code formatter](https://github.com/astral-sh/ruff)

## Deploying with containers

That's all you need really to deploy a virtualenv in a container:

```dockerfile
FROM python:3.9-slim-bullseye

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install a lockfile produced by pip-compile
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY myapp.py .
CMD ["python", "myapp.py"]
```

If you're using poetry, try this [plugin](https://github.com/nicoloboschi/poetry-dockerize-plugin).
