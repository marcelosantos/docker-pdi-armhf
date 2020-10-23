#
# Pentaho Data Integration for ARMv7
# Tested with Raspberry Pi 4
#
# Derived from
# https://github.com/andrespp/docker-pdi
#

FROM marcelosantos/docker-java-armhf

MAINTAINER Marcelo Santos marcelosantosadm@gmail.com

# Set Environment Variables
ENV PDI_VERSION=7.1 PDI_BUILD=7.1.0.0-12 \
	PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/data/data-integration \
	KETTLE_HOME=/data/data-integration

RUN apt-get update -y

# Download PDI
#RUN wget --progress=dot:giga http://downloads.sourceforge.net/project/pentaho/Data%20Integration/${PDI_VERSION}/pdi-ce-${PDI_BUILD}.zip \
RUN wget --progress=dot:giga http://192.168.31.46/pdi-ce-7.1.0.0-12.zip \
    && unzip -q *.zip \
	&& rm -f *.zip \
	&& mkdir /jobs

# Aditional Drivers
WORKDIR $KETTLE_HOME

RUN wget https://downloads.sourceforge.net/project/jtds/jtds/1.3.1/jtds-1.3.1-dist.zip \
	&& unzip jtds-1.3.1-dist.zip -d lib/ \
	&& rm jtds-1.3.1-dist.zip \
	&& wget https://github.com/FirebirdSQL/jaybird/releases/download/v3.0.4/Jaybird-3.0.4-JDK_1.8.zip \
	&& unzip Jaybird-3.0.4-JDK_1.8.zip -d lib \
	&& rm -rf lib/docs/ Jaybird-3.0.4-JDK_1.8.zip

RUN apt-get install libwebkitgtk-1.0 -y \
#   && apt-get install libswt-gtk-4-java -y \
    && apt-get install libswt-gtk-3-java -y \
    && apt-get install libswt-cairo-gtk-3-jni -y \
    && mkdir -p "/home/.swt/lib/linux/arm/" \
    && ln -s /usr/lib/jni/libswt* /home/.swt/lib/linux/arm/ \
    && cd $KETTLE_HOME \
    && mkdir -p "libswt/linux/armv7l/" \
    && cp /usr/share/java/swt-gtk-3.8.jar libswt/linux/armv7l

COPY spoon.sh /data/data-integration/

# First time run
#RUN ./pan.sh -file ./plugins/platform-utils-plugin/samples/showPlatformVersion.ktr \
#	&& kitchen.sh -file samples/transformations/files/test-job.kjb

#VOLUME /jobs

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

CMD ["help"]
