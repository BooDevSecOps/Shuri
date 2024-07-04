# Base image
ARG NODE_VERSION=19.9.0

FROM node:${NODE_VERSION}-alpine as build

# Set working directory
WORKDIR /app

# Install Angular CLI globally
RUN npm install -g @angular/cli@latest

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy rest of the application code
COPY . .

# Build the Angular app in production mode
RUN ng build --prod

# Use NGINX image for serving Angular application
FROM nginx:1.21-alpine

# Copy build output from previous stage
COPY --from=build /app/dist /usr/share/nginx/html

# Copy nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
