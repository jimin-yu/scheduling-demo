FROM ruby:2.6.6-alpine

RUN apk update && apk --no-cache --update add build-base 
RUN apk add --update nodejs yarn mysql mysql-client mysql-dev tzdata

ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN mkdir /app
WORKDIR /app
COPY Gemfile Gemfile.lock ./
COPY . .

# RUN yarn install

RUN gem install bundler:2.3.7
RUN bundle install

EXPOSE 3000
CMD ["foreman", "s"]