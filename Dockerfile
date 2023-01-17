FROM golang:latest AS build

LABEL maintainer="Ali Akbar Mahbadi <aamahbadi@yahoo.com>"

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

WORKDIR /app/cmd

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /visitor .

#Second stage of build
FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /app/

COPY --from=build /visitor .

EXPOSE 65432

CMD ["./visitor", "server"]
