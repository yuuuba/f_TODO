FROM ubuntu:focal

RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
  && apt-get update \
  && apt-get install -y -qq\
    wget\
    git-core\
    zlib1g-dev\
    build-essential\
    libssl-dev\
    libreadline-dev\
    libyaml-dev\
    libsqlite3-dev\
    sqlite3\
    libxml2-dev\
    libxslt1-dev\
    libcurl4-openssl-dev\
    software-properties-common\
    libffi-dev
RUN wget -q https://cache.ruby-lang.org/pub/ruby/3.2/ruby-3.2.4.tar.gz\
 && tar -xzf ruby-3.2.4.tar.gz\
 && cd ruby-3.2.4\
 && ./configure\
 && make\
 && make install\
 && cd ..\
 && rm -rf ruby-3.2.4 ruby-3.2.4.tar.gz\
 && gem install bundler\
 && apt-get clean

COPY . /app
WORKDIR /app
RUN bundle install

EXPOSE 4567

CMD ["bundle", "exec", "ruby", "main.rb"]
