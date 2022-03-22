FROM archlinux:base

RUN pacman-key --init && \
    pacman -Sy --noconfirm archlinux-keyring && \
    pacman -Su --noconfirm base-devel && \
    pacman -Scc --noconfirm && \
    rm -rf /var/cache/pacman/pkg/*

# prerequisite: jdk8 for Android
RUN pacman -S --noconfirm jdk8-openjdk git && \
    pacman -Scc --noconfirm && \
    rm -rf /var/cache/pacman/pkg/*

WORKDIR /workspace/

# Android sdk
RUN git clone https://aur.archlinux.org/android-sdk.git && \
    cd android-sdk && \
    chown -R nobody.root . && \
    echo "nobody ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/nobody && \
    sudo -u nobody -- makepkg --noconfirm -i -s && \
    cd ..  && \
    rm -rf android-sdk && \
    rm /etc/sudoers.d/nobody

RUN echo -e "y\ny\ny\ny\ny\ny\ny\n" | /opt/android-sdk/tools/bin/sdkmanager --licenses && \
    /opt/android-sdk/tools/bin/sdkmanager --install "platform-tools" "platforms;android-29" "build-tools;29.0.2" "ndk-bundle"

RUN cd /opt && curl -SL https://golang.google.cn/dl/go1.18.linux-amd64.tar.gz > go1.18.linux-amd64.tar.gz && tar xfz go1.18.linux-amd64.tar.gz && rm -f go1.18.linux-amd64.tar.gz
ENV PATH=$PATH:/opt/go/bin

RUN go install fyne.io/fyne/v2/cmd/fyne@latest
RUN cp /root/go/bin/fyne /usr/local/bin/

ENV ANDROID_HOME=/opt/android-sdk/

COPY main.go Icon.jpg ./test1/
RUN cd test1 && go mod init test1 && go mod tidy && fyne package -os android/arm -appID com.example.myapp2 -icon Icon.jpg
