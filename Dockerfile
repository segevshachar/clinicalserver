FROM node:14-alpine
WORKDIR /usr/app
COPY ./build /usr/app/build
COPY ./package.json /usr/app/package.json
ADD node_modules.tar /usr/app
RUN ls -la /usr/app/build
EXPOSE 3000
CMD ["node", "build/server.js"]
