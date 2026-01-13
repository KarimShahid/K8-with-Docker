FROM nginx:alpine

# Clean default nginx files
RUN rm -rf /usr/share/nginx/html/*

# Copy all static content
COPY . /usr/share/nginx/html/

EXPOSE 80
