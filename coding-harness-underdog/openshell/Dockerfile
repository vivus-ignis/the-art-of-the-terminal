FROM python:3.14-trixie
RUN apt-get update && apt-get install -y vim-nox
RUN pip install teddy-cli==0.2.1 pre-commit==4.7.0
ADD git-password.sh /usr/local/bin/git-password.sh
RUN chmod +x /usr/local/bin/git-password.sh
ENV GIT_ASKPASS=/usr/local/bin/git-password.sh
