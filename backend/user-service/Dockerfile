FROM node:20-alpine
WORKDIR /app
COPY user-service/package.json ./user-service/
RUN cd user-service && npm install --production
COPY shared ./shared
COPY kafka ./kafka
COPY user-service ./user-service
WORKDIR /app/user-service
EXPOSE 3004
CMD ["node", "server.js"]
