FROM node:20.10.0

WORKDIR /usr/src/app

# COPY rollup.config.js ./
COPY package*.json ./

RUN npm install
COPY ./ ./
# COPY ./src ./src
# COPY ./public ./public

# RUN npm run-script build
RUN npm run build

EXPOSE 8080
EXPOSE 5173

ENV HOST=0.0.0.0

CMD [ "npm", "run", "dev", "--", "--host" ]

#docker build -t svelte/authui .
#docker run -p 5000:5000 svelte/authui