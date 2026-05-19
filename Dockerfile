FROM ghcr.io/cirruslabs/flutter:stable AS build
WORKDIR /app
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get
COPY . .
ARG API_URL=http://localhost:8080/api
ARG IMG_BASE_URL=http://localhost:8080
RUN flutter build web --release \
    --dart-define=API_URL=$API_URL \
    --dart-define=IMG_BASE_URL=$IMG_BASE_URL

FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80