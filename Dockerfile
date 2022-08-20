########## Build Stage for deploy ##########
FROM golang:1.18-alpine AS deploy-builder

WORKDIR /app

# COPY go.mod go.sum ./	# 本来はgo.sumもあるはず
COPY go.mod ./
RUN go mod download

COPY . .

RUN go build -ldflags "-w -s" -o main



########## Deploy Stage ##########
FROM alpine:latest AS deploy

RUN apk update

COPY --from=deploy-builder /app/main .

CMD ["./main"]



########## Local ##########
FROM golang:1.18 as devlop

WORKDIR /app

RUN go install github.com/cosmtrek/air@latest
CMD ["air"]
