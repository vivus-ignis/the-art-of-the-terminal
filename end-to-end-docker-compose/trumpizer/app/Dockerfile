FROM python:3.11-slim@sha256:614c8691ab74150465ec9123378cd4dde7a6e57be9e558c3108df40664667a4c

ARG UID
ARG GID

# libpq-dev is a requirement for psycopg_binary
RUN dpkg --add-architecture amd64 && apt-get update && dpkg --add-architecture amd64 && apt-get update && apt-get update \
  && apt-get install -y --no-install-recommends curl=7.88.1-10+deb12u8 python3=3.11.2-1+b1 libpq-dev=15.10-0+deb12u1 pipx=1.1.0-1 \
  && rm -rf /var/lib/apt/lists/* \
  && groupadd --gid ${GID} docker \
  && useradd --home-dir /home/docker --create-home --uid ${UID} --gid ${GID} --shell /bin/bash docker

USER docker
WORKDIR /app

RUN pipx install poetry==2.1.1
ENV PATH="/home/docker/.local/bin:${PATH}"

COPY pyproject.toml poetry.lock ./
RUN poetry install

COPY . .

EXPOSE 8000
CMD ["poetry", "run", "uvicorn", \
  "--host", "0.0.0.0", \
  "--reload", \
  "--reload-include", "*.py", \
  "--reload-include", "*.html", \
  "app:app"]
