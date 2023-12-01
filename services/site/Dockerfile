FROM node:lts AS runtime
WORKDIR /app

COPY . .

RUN npm install -D
RUN npm run build

ENV HOST=0.0.0.0
ENV PORT=3000
EXPOSE 3000
CMD npm run serve
