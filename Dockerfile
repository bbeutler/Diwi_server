FROM ruby:2.5.1
LABEL maintainer=services@trimagency.com

RUN apt-get update && apt-get install -y \
  build-essential \
  locales \
  nodejs \
  graphviz \
  ffmpegthumbnailer

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN mkdir -p /app
WORKDIR /app

#RUN gem install rails --version 5.1.5
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5

COPY . ./

EXPOSE 3000

CMD ["rm", "-f", "tmp/pids/server.pid", "&&", "bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "3000"]
