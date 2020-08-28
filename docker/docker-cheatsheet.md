# Docker cheatsheet
[도커(Docker) 입문편: 컨테이너 기초부터 서버 배포까지 | 44BITS](https://www.44bits.io/ko/post/easy-deploy-with-docker)


이미지 가져오기
```
$ docker pull <image>
```

컨테이너 실행
```
$ docker run <image>

# -i for interactive mode, --rm for automatic remove after stop
$ docker run -i --rm <image>

# -d for background mode, -p for port forwarding
$ docker run -d -p 9999:80 <image>
```

컨테이너 목록 보기
```
# -a for all containers
$ docker ps -a
```

컨테이너 삭제
```
$ docker rm <container-id>
```

이미지 삭제
```
$ docker rmi <image-id>
```

부모 이미지와 컨테이너 간의 변경점 확인
```
$ docker diff <container-id>
```

컨테이너를 가지고 새로운 이미지 생성
```
$ docker commit <container-id> <new-image-name>
```

Dockerfile을 가지고 빌드.
```
# -t for specifying name and tag
$ docker build -t <name:tag> <path-to-dockerfile>
```

Dockerfile 예시
```dockerfile
FROM ubuntu:14.04

RUN apt-get update &&\
  apt-get -qq -y install git curl build-essential apache2 php5 libapache2-mod-php5 rcs

WORKDIR /tmp
RUN \
  curl -L -O https://github.com/wkpark/moniwiki/archive/v1.2.5p1.tar.gz &&\
  tar xf /tmp/v1.2.5p1.tar.gz &&\
  mv moniwiki-1.2.5p1 /var/www/html/moniwiki &&\
  chown -R www-data:www-data /var/www/html/moniwiki &&\
  chmod 777 /var/www/html/moniwiki/data/ /var/www/html/moniwiki/ &&\
  chmod +x /var/www/html/moniwiki/secure.sh &&\
  /var/www/html/moniwiki/secure.sh

RUN a2enmod rewrite

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80

CMD bash -c "source /etc/apache2/envvars && /usr/sbin/apache2 -D FOREGROUND"
```

	- Dockerfile의 각 명령은 곧 레이어로 저장되기 때문에 레이어를 줄이면 좀 더 효율적임.

이미지 업로드
```
# docker login을 통해 login 이후
$ docker login

# (Optional) 자신의 아이디에 맞춰서 이미지 태그 생성
# 새로운 이미지를 만드는게 아니라 기존의 이미지에 새로운 링크를 만드는 거라 Image ID는 동일
$ docker tag <image> <user-id>/<image-name>
```



## docker compose

[도커(Docker) 컴포즈를 활용하여 완벽한 개발 환경 구성하기 | 44BITS](https://www.44bits.io/ko/post/almost-perfect-development-environment-with-docker-and-docker-compose)

-> 위 링크의 yml 파일이 제대로 동작하지 않으니 `https://github.com/raccoonyy/django-sample-for-docker-compose.git` 이 저장소 내용 그대로 사용하도록 하자.

컨테이너들끼리의 소통을 위해서 서로 연결해주는 작업이 필요함.

