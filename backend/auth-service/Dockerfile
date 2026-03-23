FROM node:20-alpine
WORKDIR /app
COPY auth-service/package.json ./auth-service/
RUN cd auth-service && npm install --production
COPY shared ./shared
COPY kafka ./kafka
COPY auth-service ./auth-service
WORKDIR /app/auth-service
EXPOSE 3001
CMD ["node", "server.js"]
