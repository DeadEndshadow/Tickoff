FROM node:20-alpine
WORKDIR /app
COPY tickmap-service/package.json ./tickmap-service/
RUN cd tickmap-service && npm install --production
COPY shared ./shared
COPY kafka ./kafka
COPY tickmap-service ./tickmap-service
WORKDIR /app/tickmap-service
EXPOSE 3002
CMD ["node", "server.js"]
