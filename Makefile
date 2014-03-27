# Makefile_Linux	|	Sep 08 2011
#
#	This is the Linux makefile for the StolTest plugin.
#
# Document Author: William Yu
# Document Contributor(s):
#
# Revision History

#g++ -m32 -march=i586 -g -std=c++0x -o STOL stol_main.cpp  serial_port.o  socketcan_port.o  radarbox.o  vehiclenetwork.o  udpsocket_port.o  dgps_box.o  radar_base.o  vehicle_base.o  dgps_base.o savari_logger.o  stol_logger.o savari_base.o savari_bsm_data.o stol_display.o cellphone.o cellphone_base.o timer.o -lxml2 -lpthread -lncurses -lrt -lcurl -Wl,--export-dynamic `pkg-config --cflags gtk+-3.0 gmodule-export-2.0` `pkg-config --libs gtk+-3.0 gmodule-export-2.0` -lgthread-2.0

CC = g++
BASEDIR = ../../..
PLUGINSDKDIR = $(BASEDIR)/Plugins\ SDK
SDKGLUECODEDIR = $(PLUGINSDKDIR)/Glue\ Code
SDKINCLUDEDIR = $(PLUGINSDKDIR)/Includes
STOLDIR = /home/stol/stol
STOLINCLUDES = -I/usr/include/gtk-3.0/ -I/usr/include/glib-2.0/ -I/usr/lib/i386-linux-gnu/glib-2.0/include/ -I/usr/include/pango-1.0/ -I/usr/include/cairo/ -I/usr/include/gdk-pixbuf-2.0/ -I/usr/include/atk-1.0/

INCLUDE =	-I$(SDKINCLUDEDIR)

PREFIXHEADER = $(SDKINCLUDEDIR)/LinuxHeader.h
CFLAGS = -s -O2 -DIGNOREQT -D__INTEL__ -DLINUX=1 -D__GCC__ $(INCLUDE) -include $(PREFIXHEADER) -I/home/stol/stol
CFLAGS += -m32 -march=i586 -g -std=c++0x -Wl,--export-dynamic
CFLAGS += $(STOLINCLUDES)
LIBS = -lxml2 -lpthread -lncurses -lrt -lcurl -lgthread-2.0 `pkg-config --cflags gtk+-3.0 gmodule-export-2.0` `pkg-config --libs gtk+-3.0 gmodule-export-2.0` -lgthread-2.0
BUILDOBJDIR = BuildLinux
SONAME = JohnTest


OBJS =	$(BUILDOBJDIR)/$(SONAME).o \
		$(BUILDOBJDIR)/PluginMain.o \
		$(STOLDIR)/serial_port.o  \
		$(STOLDIR)/socketcan_port.o  \
		$(STOLDIR)/radarbox.o  \
		$(STOLDIR)/vehiclenetwork.o  \
		$(STOLDIR)/udpsocket_port.o  \
		$(STOLDIR)/dgps_box.o  \
		$(STOLDIR)/radar_base.o  \
		$(STOLDIR)/vehicle_base.o  \
		$(STOLDIR)/dgps_base.o \
		$(STOLDIR)/savari_logger.o  \
		$(STOLDIR)/stol_logger.o \
		$(STOLDIR)/savari_base.o \
		$(STOLDIR)/savari_bsm_data.o \
		$(STOLDIR)/stol_display.o \
		$(STOLDIR)/cellphone.o \
		$(STOLDIR)/cellphone_base.o \
		$(STOLDIR)/timer.o

all: CreateBuildObjDir $(OBJS)
	$(CC) $(CFLAGS) -shared -Wl,--no-undefined -o $(SONAME).so $(OBJS) $(LIBS)

CreateBuildObjDir:
	mkdir -p $(BUILDOBJDIR)
	make -C $(STOLDIR)

$(BUILDOBJDIR)/JohnTest.o: $(SONAME).cpp
	$(CC) $(CFLAGS) $(SONAME).cpp -c -o $@

$(BUILDOBJDIR)/PluginMain.o: $(SDKGLUECODEDIR)/PluginMain.cpp
	$(CC) $(CFLAGS) $(SDKGLUECODEDIR)/PluginMain.cpp -c -o $@

clean:
	rm $(BUILDOBJDIR)/*.o -f
	rm $(SONAME).so ../../../../Plugins/$(SONAME).so

install:
	cp $(SONAME).so ../../../../Plugins

bin:
	sudo cp -rfp "Builds - STOL_VSL_Display.xojo_binary_project/Linux/STOL_VSL_Display" /home/stol/stol
