# ベースイメージの指定
FROM debian:bullseye-slim

# TexLiveとその依存パッケージのインストール
RUN apt update && \
    apt install -y \
    texlive-lang-japanese \
    texlive-lang-english \
    texlive-latex-extra \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-lang-cjk \
    latexmk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    kanji-config-updmap-sys auto

# latexmkrcファイルをコピー
COPY latexmkrc /root/.latexmkrc

# コンテナ内で作業するディレクトリの設定
WORKDIR /workspace
