# Use the Prisma binaries image as the first stage
FROM ghcr.io/diced/prisma-binaries:4.8.x as prisma

# Use Alpine Linux as the second stage
FROM node:18-alpine3.16 as base

# Set the working directory
WORKDIR /app

# Copy the necessary files from the project
COPY prisma ./prisma
COPY src ./src
COPY next.config.js ./next.config.js
COPY tsup.config.ts ./tsup.config.ts
COPY tsconfig.json ./tsconfig.json
COPY mimes.json ./mimes.json

FROM base as builder

COPY .yarn ./.yarn
COPY package*.json ./
COPY yarn*.lock ./
COPY .yarnrc.yml ./

# Copy the prisma binaries from prisma stage
COPY --from=prisma /prisma-engines /prisma-engines
ENV PRISMA_QUERY_ENGINE_BINARY=/prisma-engines/query-engine \
  PRISMA_MIGRATION_ENGINE_BINARY=/prisma-engines/migration-engine \
  PRISMA_INTROSPECTION_ENGINE_BINARY=/prisma-engines/introspection-engine \
  PRISMA_FMT_BINARY=/prisma-engines/prisma-fmt \
  PRISMA_CLI_QUERY_ENGINE_TYPE=binary \
  PRISMA_CLIENT_ENGINE_TYPE=binary \
  MORELOAD_DOCKER_BUILD=true \
  NEXT_TELEMETRY_DISABLED=1

# Install production dependencies then temporarily save
RUN yarn workspaces focus --production --all
RUN cp -RL node_modules /tmp/node_modules

# Install the dependencies
RUN yarn install --immutable

# Run the build
RUN yarn build

# Use Alpine Linux as the final image
FROM base

RUN apk add --no-cache perl procps

# Set the working directory
WORKDIR /app

COPY --from=builder /prisma-engines /prisma-engines
ENV PRISMA_QUERY_ENGINE_BINARY=/prisma-engines/query-engine \
  PRISMA_MIGRATION_ENGINE_BINARY=/prisma-engines/migration-engine \
  PRISMA_INTROSPECTION_ENGINE_BINARY=/prisma-engines/introspection-engine \
  PRISMA_FMT_BINARY=/prisma-engines/prisma-fmt \
  PRISMA_CLI_QUERY_ENGINE_TYPE=binary \
  PRISMA_CLIENT_ENGINE_TYPE=binary \
  NEXT_TELEMETRY_DISABLED=1

# Copy only the necessary files from the previous stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/package.json ./package.json

COPY --from=builder /tmp/node_modules ./node_modules
COPY --from=builder /app/node_modules/.prisma/client ./node_modules/.prisma/client
COPY --from=builder /app/node_modules/@prisma/client ./node_modules/@prisma/client

# Run the application
CMD ["node", "--enable-source-maps", "dist/index.js"]