# Stage 1: Build the React application
FROM node:24-alpine AS builder

WORKDIR /app

# Copy dependency files first
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application source code
COPY . .

# Create production build
RUN npm run build


# Stage 2: Serve the build using Nginx
FROM nginx:alpine

# Copy React production build
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy our custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]