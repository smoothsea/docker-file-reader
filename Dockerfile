#######################BUILD IAMGE################
FROM rust:1.42.0 as build
ENV REFRESHED_AT 2021-03-09
RUN mkdir /app && cd /app && git clone https://github.com/smoothsea/file-reader.git && cd file-reader
WORKDIR /app/file-reader
RUN rustup default nightly
RUN cargo build --release

#######################RUNTIME IMAGE##############
FROM debian:buster-slim
RUN apt-get update && apt-get install -y \
            --no-install-recommends \
            openssl \
            ca-certificates
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone 
COPY --from=build app/file-reader/target/release/file_reader .
COPY --from=build app/file-reader/templates ./templates/
WORKDIR /
CMD ["/file_reader", "/logs"]
