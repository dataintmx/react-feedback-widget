FROM node:20-alpine AS base

# Copy the project server files
COPY ./server /srv/feedback-api

FROM base AS deps

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