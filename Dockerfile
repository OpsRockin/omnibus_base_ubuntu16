FROM ubuntu:16.04
LABEL MAINTAINER=sawanoboriyu@higanworks.com

RUN apt-get -y update && \
    apt-get -y install curl iproute2 ca-certificates

## Prepare for Chef
RUN mkdir /root/chefrepo
ADD files/Cheffile /root/chefrepo/Cheffile
WORKDIR /root/chefrepo

## Create Omnibus Environment and Seppuku.
## (Delete chef to reduce image size.)
# use Chef < 17 due to embedded ruby (2.7) not works
RUN curl -sf https://omnitruck.chef.io/install.sh > /tmp/install.sh && \
    bash /tmp/install.sh -v 16.5.77 && \
    /opt/chef/embedded/bin/gem install librarian-chef -N && \
    /opt/chef/embedded/bin/librarian-chef install && \
    chef-client --chef-license accept -z -o "omnibus::default" && \
    rm -rf /opt/chef /root/chefrepo /root/.chef /root/.ccache /usr/local/src/* /tmp/install.sh

## Preinstall gems
WORKDIR /root
ADD files/Gemfile /root/Gemfile
ADD files/prebundle.sh /root/prebundle.sh
RUN ./prebundle.sh

ADD files/bash_with_env.sh /home/omnibus/bash_with_env.sh
ADD files/build.sh /home/omnibus/build.sh

ENV HOME /home/omnibus

## ONBUILD to build project
ONBUILD ADD . /home/omnibus/omnibus-project

WORKDIR /home/omnibus/omnibus-project
ONBUILD RUN bash -c 'source /home/omnibus/load-omnibus-toolchain.sh ; gem install bundler -N'
ONBUILD RUN bash -c 'source /home/omnibus/load-omnibus-toolchain.sh ; bundle config set without "development test"'
ONBUILD RUN bash -c 'source /home/omnibus/load-omnibus-toolchain.sh ; bundle install'
ONBUILD RUN bash -c 'source /home/omnibus/load-omnibus-toolchain.sh ; bundle binstubs --all --path bundle_bin'
ONBUILD RUN echo "Usage: docker run  -it -e OMNIBUS_PROJECT=${PROJECT_NAME} -v pkg:/home/omnibus/omnibus-project/pkg builder-ubuntu1604"

CMD ["/home/omnibus/build.sh"]
