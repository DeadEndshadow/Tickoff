FROM node:20-alpine
WORKDIR /app
COPY push-service/package.json ./push-service/
RUN cd push-service && npm install --production
COPY shared ./shared
COPY kafka ./kafka
COPY push-service ./push-service
WORKDIR /app/push-service
EXPOSE 3003
CMD ["node", "server.js"]
