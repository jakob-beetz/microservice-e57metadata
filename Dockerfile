FROM duraark/microservice-base

RUN DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y git build-essential cmake vim unzip wget scons
RUN apt-get install -y libboost-filesystem1.55-dev libboost-system1.55-dev \
                       libboost-thread1.55-dev libboost-program-options1.55-dev \
		       libeigen3-dev libxerces-c-dev

# Bundle app, install, expose and finally run it
COPY ./src /microservice
COPY ./e57extract /e57extract

#RUN mkdir /e57extract/deps
WORKDIR /e57extract/deps

#RUN wget http://sourceforge.net/projects/e57-3d-imgfmt/files/E57Refimpl-src/E57RefImpl_src-1.1.312.zip
#RUN unzip E57RefImpl_src-1.1.312.zip

#RUN wget http://sourceforge.net/projects/e57-3d-imgfmt/files/E57SimpleImpl-src/E57SimpleImpl-src-1.1.312.zip
#RUN unzip E57SimpleImpl-src-1.1.312.zip


WORKDIR /e57extract/deps/E57RefImpl_src-1.1.312
RUN cmake .
RUN make -j2
RUN make install
RUN cp libtime_conversion.a /usr/local/E57RefImpl-1.1.unknown-x86_64-linux-gcc48/lib/
RUN cp include/time_conversion/*.h /usr/local/E57RefImpl-1.1.unknown-x86_64-linux-gcc48/include/e57

RUN export PATH=$PATH:/usr/local/E57RefImpl-1.1.unknown-x86_64-linux-gcc48/bin

#RUN cp /e57extract/deps/E57SimpleImpl-src-1.1.312/src/refiddmpl/* /e57extract/e57_metadata
#RUN cp ./deps/E57SimpleImpl-src-1.1.312/include/* /usr/local/E57RefImpl-1.1.unknown-x86_64-linux-gcc48/include/e57 -r

RUN ln -s /usr/local/E57RefImpl-1.1.unknown-x86_64-linux-gcc48/include/e57 /usr/include
#RUN cp /usr/include/e57/time_conversion/* /usr/include/e57

WORKDIR /e57extract/aux_/E57SimpleImpl-src-1.1.312_fixed
RUN scons .
RUN cp libE57SimpleImpl.so /usr/local/E57RefImpl-1.1.unknown-x86_64-linux-gcc48/lib
RUN cp include/* /usr/local/E57RefImpl-1.1.unknown-x86_64-linux-gcc48/include/e57

WORKDIR /e57extract
RUN wget https://github.com/USCiLab/cereal/archive/v1.0.0.zip
RUN unzip v1.0.0.zip

RUN mkdir build
WORKDIR build
RUN CEREAL_ROOT=./cereal-1.0.0 LIBE57_ROOT=/usr/local/E57RefImpl-1.1.unknown-x86_64-linux-gcc48 cmake ../
#RUN make -j2
#RUN make install

#WORKDIR /microservice
#EXPOSE 1337

#RUN npm install
