FROM node:20 AS base

# Copy the project server files
COPY ./server /srv/feedback-api

FROM base AS deps

# Install prisma dependencies
RUN apt update && apt install -y openssl

# Move to the working directory
WORKDIR /srv/feedback-api

# Install dependencies
RUN npm install

FROM deps AS builder

# Move to the working directory
WORKDIR /srv/feedback-api

# Build the project
RUN npm run build

# Run prisma
RUN npx prisma migrate deploy

FROM builder AS runner

# Run the application and expose the port
EXPOSE 3000
CMD ["npm", "run", "start"]