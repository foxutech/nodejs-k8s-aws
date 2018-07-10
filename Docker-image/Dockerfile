FROM node

ENV NODE_VERSION stable
ENV NPM_SCRIPT start
ENV remoteUrl mongodb://mongo:27017/admin
ENV GIT_URL https://github.com/scotch-io/node-todo.git
ENV PORT 8080
ENV YARN_INSTALL 0

COPY . /node
WORKDIR /node

RUN chmod +x /node/bootstrap.sh
RUN npm install -g n --silent
RUN npm install -g yarn --silent

ENTRYPOINT ["./bootstrap.sh"]
