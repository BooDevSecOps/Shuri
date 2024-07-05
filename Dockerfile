# Use the official Node.js image for compiling and running Angular applications
FROM node:latest AS build

# Install Angular CLI globally
RUN npm install -g @angular/cli@latest

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the entire project to the working directory
COPY . .

# Build the Angular app in production mode
RUN npm run build -- --prod

# Use Nginx to serve the Angular app
FROM nginx:latest

# Copy the built Angular app from the build stage
COPY --from=build /app/dist/* /usr/share/nginx/html/

# Expose port 80 to the outside world
EXPOSE 80

# Command to run Nginx
CMD ["nginx", "-g", "daemon off;"]
