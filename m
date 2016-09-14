Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D04171A1E60
 for <linux-nvdimm@lists.01.org>; Tue, 13 Sep 2016 18:03:31 -0700 (PDT)
Subject: [ndctl PATCH 2/3] build: build libraries and utilities in separate
 directories
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 13 Sep 2016 18:00:28 -0700
Message-ID: <147381482831.12944.18340370850453419240.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147381481774.12944.1660067055752367684.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147381481774.12944.1660067055752367684.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

When trying to add an "ndctl test" user of the util/log.c and
util/sysfs.c routines, automake complained about util/log.o being
already built for a library when trying to include it in the utility.
Move the library build into ndctl/lib/ rather than re-using ndctl/.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Makefile.am            |    2 +-
 configure.ac           |    3 ++-
 daxctl/Makefile.am     |   27 ---------------------------
 daxctl/lib/Makefile.am |   28 ++++++++++++++++++++++++++++
 ndctl/Makefile.am      |   47 -----------------------------------------------
 ndctl/lib/Makefile.am  |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 77 insertions(+), 76 deletions(-)
 delete mode 100644 daxctl/Makefile.am
 create mode 100644 daxctl/lib/Makefile.am
 create mode 100644 ndctl/lib/Makefile.am

diff --git a/Makefile.am b/Makefile.am
index ce1032e3381d..9eb396639efe 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,7 +1,7 @@
 include Makefile.am.in
 
 ACLOCAL_AMFLAGS = -I m4 ${ACLOCAL_FLAGS}
-SUBDIRS = . daxctl ndctl
+SUBDIRS = . daxctl/lib ndctl/lib ndctl
 if ENABLE_DOCS
 SUBDIRS += Documentation
 endif
diff --git a/configure.ac b/configure.ac
index 7bc97be9039d..7b4af616cf2b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -260,7 +260,8 @@ AC_SUBST([my_CFLAGS])
 AC_CONFIG_HEADERS(config.h)
 AC_CONFIG_FILES([
         Makefile
-        daxctl/Makefile
+        daxctl/lib/Makefile
+        ndctl/lib/Makefile
         ndctl/Makefile
         test/Makefile
         Documentation/Makefile
diff --git a/daxctl/Makefile.am b/daxctl/Makefile.am
deleted file mode 100644
index 67ae5aed4a18..000000000000
--- a/daxctl/Makefile.am
+++ /dev/null
@@ -1,27 +0,0 @@
-include $(top_srcdir)/Makefile.am.in
-
-%.pc: %.pc.in Makefile
-	$(SED_PROCESS)
-
-lib_LTLIBRARIES = lib/libdaxctl.la
-
-lib_libdaxctl_la_SOURCES =\
-	libdaxctl.h \
-	lib/libdaxctl-private.h \
-	../util/sysfs.c \
-	../util/sysfs.h \
-	../util/log.c \
-	../util/log.h \
-	lib/libdaxctl.c
-
-EXTRA_DIST += lib/libdaxctl.sym
-
-lib_libdaxctl_la_LDFLAGS = $(AM_LDFLAGS) \
-	-version-info $(LIBDAXCTL_CURRENT):$(LIBDAXCTL_REVISION):$(LIBDAXCTL_AGE) \
-	-Wl,--version-script=$(top_srcdir)/daxctl/lib/libdaxctl.sym
-lib_libdaxctl_la_DEPENDENCIES = lib/libdaxctl.sym
-
-pkgconfigdir = $(libdir)/pkgconfig
-pkgconfig_DATA = lib/libdaxctl.pc
-EXTRA_DIST += lib/libdaxctl.pc.in
-CLEANFILES += lib/libdaxctl.pc
diff --git a/daxctl/lib/Makefile.am b/daxctl/lib/Makefile.am
new file mode 100644
index 000000000000..92783847266a
--- /dev/null
+++ b/daxctl/lib/Makefile.am
@@ -0,0 +1,28 @@
+include $(top_srcdir)/Makefile.am.in
+
+%.pc: %.pc.in Makefile
+	$(SED_PROCESS)
+
+pkginclude_HEADERS = ../libdaxctl.h
+lib_LTLIBRARIES = libdaxctl.la
+
+libdaxctl_la_SOURCES =\
+	../libdaxctl.h \
+	libdaxctl-private.h \
+	../../util/sysfs.c \
+	../../util/sysfs.h \
+	../../util/log.c \
+	../../util/log.h \
+	libdaxctl.c
+
+EXTRA_DIST += libdaxctl.sym
+
+libdaxctl_la_LDFLAGS = $(AM_LDFLAGS) \
+	-version-info $(LIBDAXCTL_CURRENT):$(LIBDAXCTL_REVISION):$(LIBDAXCTL_AGE) \
+	-Wl,--version-script=$(top_srcdir)/daxctl/lib/libdaxctl.sym
+libdaxctl_la_DEPENDENCIES = libdaxctl.sym
+
+pkgconfigdir = $(libdir)/pkgconfig
+pkgconfig_DATA = libdaxctl.pc
+EXTRA_DIST += libdaxctl.pc.in
+CLEANFILES += libdaxctl.pc
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index f7d0a96af4f9..f6cd3f1c235b 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -1,38 +1,5 @@
 include $(top_srcdir)/Makefile.am.in
 
-BUILT_SOURCES = libndctl.h
-lib/libndctl.h: libndctl.h.in
-	touch $(top_srcdir)/version.m4
-
-%.pc: %.pc.in Makefile
-	$(SED_PROCESS)
-
-pkginclude_HEADERS = libndctl.h
-lib_LTLIBRARIES = lib/libndctl.la
-
-lib_libndctl_la_SOURCES =\
-	libndctl.h \
-	lib/libndctl-private.h \
-	../util/log.c \
-	../util/log.h \
-	../util/sysfs.c \
-	../util/sysfs.h \
-	lib/libndctl.c
-
-lib_libndctl_la_LIBADD =\
-	../daxctl/lib/libdaxctl.la \
-	$(UDEV_LIBS) \
-	$(UUID_LIBS) \
-	$(KMOD_LIBS)
-
-if ENABLE_ARS
-lib_libndctl_la_SOURCES += lib/libndctl-ars.c
-endif
-
-if ENABLE_SMART
-lib_libndctl_la_SOURCES += lib/libndctl-smart.c
-endif
-
 bin_PROGRAMS = ndctl
 
 ndctl_SOURCES = ndctl.c \
@@ -71,17 +38,3 @@ ndctl_SOURCES += ../test/libndctl.c \
 		 ../test/parent-uuid.c \
 		 ../test/core.c
 endif
-
-
-
-EXTRA_DIST += lib/libndctl.sym
-
-lib_libndctl_la_LDFLAGS = $(AM_LDFLAGS) \
-	-version-info $(LIBNDCTL_CURRENT):$(LIBNDCTL_REVISION):$(LIBNDCTL_AGE) \
-	-Wl,--version-script=$(top_srcdir)/ndctl/lib/libndctl.sym
-lib_libndctl_la_DEPENDENCIES = lib/libndctl.sym
-
-pkgconfigdir = $(libdir)/pkgconfig
-pkgconfig_DATA = lib/libndctl.pc
-EXTRA_DIST += lib/libndctl.pc.in
-CLEANFILES += lib/libndctl.pc
diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
new file mode 100644
index 000000000000..ec3941a4a754
--- /dev/null
+++ b/ndctl/lib/Makefile.am
@@ -0,0 +1,46 @@
+include $(top_srcdir)/Makefile.am.in
+
+BUILT_SOURCES = ../libndctl.h
+../libndctl.h: ../libndctl.h.in
+	touch $(top_srcdir)/version.m4
+
+%.pc: %.pc.in Makefile
+	$(SED_PROCESS)
+
+pkginclude_HEADERS = ../libndctl.h
+lib_LTLIBRARIES = libndctl.la
+
+libndctl_la_SOURCES =\
+	libndctl.h \
+	libndctl-private.h \
+	../../util/log.c \
+	../../util/log.h \
+	../../util/sysfs.c \
+	../../util/sysfs.h \
+	libndctl.c
+
+libndctl_la_LIBADD =\
+	../../daxctl/lib/libdaxctl.la \
+	$(UDEV_LIBS) \
+	$(UUID_LIBS) \
+	$(KMOD_LIBS)
+
+if ENABLE_ARS
+libndctl_la_SOURCES += libndctl-ars.c
+endif
+
+if ENABLE_SMART
+libndctl_la_SOURCES += libndctl-smart.c
+endif
+
+EXTRA_DIST += libndctl.sym
+
+libndctl_la_LDFLAGS = $(AM_LDFLAGS) \
+	-version-info $(LIBNDCTL_CURRENT):$(LIBNDCTL_REVISION):$(LIBNDCTL_AGE) \
+	-Wl,--version-script=$(top_srcdir)/ndctl/lib/libndctl.sym
+libndctl_la_DEPENDENCIES = libndctl.sym
+
+pkgconfigdir = $(libdir)/pkgconfig
+pkgconfig_DATA = libndctl.pc
+EXTRA_DIST += libndctl.pc.in
+CLEANFILES += libndctl.pc

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
