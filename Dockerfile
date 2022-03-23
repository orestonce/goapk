FROM ubuntu:20.04

RUN apt-get update -y && apt-get install -y curl unzip

RUN cd /opt && curl -SL https://golang.google.cn/dl/go1.18.linux-amd64.tar.gz > go1.18.linux-amd64.tar.gz && tar xfz go1.18.linux-amd64.tar.gz && rm -f go1.18.linux-amd64.tar.gz
ENV PATH=$PATH:/opt/go/bin

RUN cd /opt && curl -SL https://dl.google.com/android/repository/android-ndk-r23b-linux.zip > android-ndk-r23b-linux.zip && unzip -q android-ndk-r23b-linux.zip && rm -f android-ndk-r23b-linux.zip
ENV ANDROID_NDK_HOME=/opt/android-ndk-r23b

ENV GOPROXY=https://goproxy.cn
RUN go install fyne.io/fyne/v2/cmd/fyne@latest && cp /root/go/bin/fyne /usr/local/bin/ && rm -rf /root/go

WORKDIR /workspace/
COPY main.go Icon.jpg ./test1/
RUN cd test1 && go mod init test1 && go mod tidy && fyne package -os android -appID com.example.myapp2 -icon Icon.jpg
