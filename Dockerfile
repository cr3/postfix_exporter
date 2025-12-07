FROM golang:1.23 AS builder
WORKDIR /src

COPY go.mod ./
RUN go mod download
COPY . ./
RUN go mod tidy

# Build static binary with systemd support disabled (nosystemd build tag)
RUN CGO_ENABLED=0 GOOS=linux go build -a -tags nosystemd -installsuffix nocgo -o /bin/postfix_exporter

FROM scratch

EXPOSE 9154

COPY --from=builder /bin/postfix_exporter /bin/

ENTRYPOINT ["/bin/postfix_exporter"]
