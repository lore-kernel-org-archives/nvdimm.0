Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id BF8A01A1F38
 for <linux-nvdimm@lists.01.org>; Tue, 17 May 2016 16:20:13 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: reorganize file structure,
 use per sub-directory makefiles
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 17 May 2016 16:19:22 -0700
Message-ID: <146352716208.1711.15183238430520498418.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for daxctl / libdaxctl move the ndctl infrastructure to
its own sub-directory.

This also moves tests to have their own Makefile rather than continuing
to clutter up one top-level Makefile.am.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Makefile.am                       |  171 ++++---------------------------------
 Makefile.am.in                    |   41 +++++++++
 configure.ac                      |   14 ++-
 ndctl/Makefile.am                 |   75 ++++++++++++++++
 ndctl/builtin-bat.c               |    0 
 ndctl/builtin-create-nfit.c       |    0 
 ndctl/builtin-help.c              |    0 
 ndctl/builtin-list.c              |    0 
 ndctl/builtin-read-labels.c       |    0 
 ndctl/builtin-test.c              |    0 
 ndctl/builtin-xable-region.c      |    0 
 ndctl/builtin-xaction-namespace.c |    0 
 ndctl/builtin-zero-labels.c       |    0 
 ndctl/builtin.h                   |    0 
 ndctl/lib/.gitignore              |    0 
 ndctl/lib/libndctl-ars.c          |    0 
 ndctl/lib/libndctl-private.h      |    0 
 ndctl/lib/libndctl-smart.c        |    0 
 ndctl/lib/libndctl.c              |    0 
 ndctl/lib/libndctl.h.in           |    0 
 ndctl/lib/libndctl.pc.in          |    0 
 ndctl/lib/libndctl.sym            |    0 
 ndctl/ndctl.c                     |    0 
 ndctl/ndctl.h                     |    0 
 ndctl/util/json-smart.c           |    0 
 ndctl/util/json.c                 |    0 
 ndctl/util/json.h                 |    0 
 test/Makefile.am                  |   60 +++++++++++++
 test/clear.sh                     |    2 
 test/create.sh                    |    2 
 test/dax-errors.sh                |    6 +
 test/dax.sh                       |   12 +--
 test/mmap.sh                      |    4 -
 33 files changed, 215 insertions(+), 172 deletions(-)
 create mode 100644 Makefile.am.in
 create mode 100644 ndctl/Makefile.am
 rename builtin-bat.c => ndctl/builtin-bat.c (100%)
 rename builtin-create-nfit.c => ndctl/builtin-create-nfit.c (100%)
 rename builtin-help.c => ndctl/builtin-help.c (100%)
 rename builtin-list.c => ndctl/builtin-list.c (100%)
 rename builtin-read-labels.c => ndctl/builtin-read-labels.c (100%)
 rename builtin-test.c => ndctl/builtin-test.c (100%)
 rename builtin-xable-region.c => ndctl/builtin-xable-region.c (100%)
 rename builtin-xaction-namespace.c => ndctl/builtin-xaction-namespace.c (100%)
 rename builtin-zero-labels.c => ndctl/builtin-zero-labels.c (100%)
 rename builtin.h => ndctl/builtin.h (100%)
 rename lib/.gitignore => ndctl/lib/.gitignore (100%)
 rename lib/libndctl-ars.c => ndctl/lib/libndctl-ars.c (100%)
 rename lib/libndctl-private.h => ndctl/lib/libndctl-private.h (100%)
 rename lib/libndctl-smart.c => ndctl/lib/libndctl-smart.c (100%)
 rename lib/libndctl.c => ndctl/lib/libndctl.c (100%)
 rename lib/ndctl/libndctl.h.in => ndctl/lib/libndctl.h.in (100%)
 rename lib/libndctl.pc.in => ndctl/lib/libndctl.pc.in (100%)
 rename lib/libndctl.sym => ndctl/lib/libndctl.sym (100%)
 rename ndctl.c => ndctl/ndctl.c (100%)
 rename ndctl.h => ndctl/ndctl.h (100%)
 rename util/json-smart.c => ndctl/util/json-smart.c (100%)
 rename util/json.c => ndctl/util/json.c (100%)
 rename util/json.h => ndctl/util/json.h (100%)
 create mode 100644 test/Makefile.am

diff --git a/Makefile.am b/Makefile.am
index c5c89f4d50c7..db07205b33a1 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,58 +1,18 @@
-EXTRA_DIST =
+include Makefile.am.in
+
+ACLOCAL_AMFLAGS = -I m4 ${ACLOCAL_FLAGS}
+SUBDIRS = . ndctl
 if ENABLE_DOCS
-SUBDIRS = . Documentation
+SUBDIRS += Documentation
 endif
-CLEANFILES =
-ACLOCAL_AMFLAGS = -I m4 ${ACLOCAL_FLAGS}
-AM_MAKEFLAGS = --no-print-directory
-
-AM_CPPFLAGS = \
-	-include $(top_builddir)/config.h \
-	-DSYSCONFDIR=\""$(sysconfdir)"\" \
-	-DLIBEXECDIR=\""$(libexecdir)"\" \
-	-DPREFIX=\""$(prefix)"\" \
-	-DNDCTL_MAN_PATH=\""$(mandir)"\" \
-	-I${top_srcdir}/lib/ndctl \
-	-I${top_srcdir}/lib \
-	-I${top_srcdir}/ \
-	$(KMOD_CFLAGS) \
-	$(UDEV_CFLAGS) \
-	$(UUID_CFLAGS) \
-	$(JSON_CFLAGS)
-
-AM_CFLAGS = ${my_CFLAGS} \
-	-fvisibility=hidden \
-	-ffunction-sections \
-	-fdata-sections
+SUBDIRS += test
 
-AM_LDFLAGS = \
-	-Wl,--gc-sections \
-	-Wl,--as-needed
-
-BUILT_SOURCES = $(top_srcdir)/version.m4 $(top_srcdir)/lib/ndctl/libndctl.h
-$(top_srcdir)/lib/ndctl/libndctl.h: $(top_srcdir)/lib/ndctl/libndctl.h.in
-	touch $(top_srcdir)/version.m4
+BUILT_SOURCES = $(top_srcdir)/version.m4
 $(top_srcdir)/version.m4: FORCE
 	$(AM_V_GEN)$(top_srcdir)/git-version-gen
 
 FORCE:
 
-SED_PROCESS = \
-	$(AM_V_GEN)$(MKDIR_P) $(dir $@) && $(SED) \
-	-e 's,@VERSION\@,$(VERSION),g' \
-	-e 's,@prefix\@,$(prefix),g' \
-	-e 's,@exec_prefix\@,$(exec_prefix),g' \
-	-e 's,@libdir\@,$(libdir),g' \
-	-e 's,@includedir\@,$(includedir),g' \
-	< $< > $@ || rm $@
-
-%.pc: %.pc.in Makefile
-	$(SED_PROCESS)
-
-LIBNDCTL_CURRENT=7
-LIBNDCTL_REVISION=0
-LIBNDCTL_AGE=1
-
 noinst_SCRIPTS = rhel/ndctl.spec sles/ndctl.spec
 CLEANFILES += $(noinst_SCRIPTS)
 
@@ -67,68 +27,12 @@ do_sles_subst = sed -e 's,VERSION,$(VERSION),g' \
             -e 's,\(^License:.*GPL\)v2,\1-2.0,g' \
             -e "s,LNAME,libndctl$$(($(LIBNDCTL_CURRENT) - $(LIBNDCTL_AGE))),g"
 
-rhel/ndctl.spec: ndctl.spec.in Makefile.am
+rhel/ndctl.spec: ndctl.spec.in Makefile.am version.m4
 	$(AM_V_GEN)$(MKDIR_P) rhel; $(do_rhel_subst) < $< > $@
 
-sles/ndctl.spec: ndctl.spec.in Makefile.am
+sles/ndctl.spec: ndctl.spec.in Makefile.am version.m4
 	$(AM_V_GEN)$(MKDIR_P) sles; cat sles/header $< | $(do_sles_subst) > $@
 
-pkginclude_HEADERS = lib/ndctl/libndctl.h
-lib_LTLIBRARIES = lib/libndctl.la
-
-lib_libndctl_la_SOURCES =\
-	lib/libndctl-private.h \
-	lib/libndctl.c
-lib_libndctl_la_LIBADD = $(UDEV_LIBS) $(UUID_LIBS) $(KMOD_LIBS)
-
-if ENABLE_ARS
-lib_libndctl_la_SOURCES += lib/libndctl-ars.c
-endif
-
-if ENABLE_SMART
-lib_libndctl_la_SOURCES += lib/libndctl-smart.c
-endif
-
-bin_PROGRAMS = ndctl
-
-ndctl_SOURCES = ndctl.c \
-		builtin-create-nfit.c \
-		builtin-xaction-namespace.c \
-		builtin-xable-region.c \
-		builtin-list.c \
-		builtin-test.c \
-		builtin-help.c \
-		builtin-zero-labels.c \
-		builtin-read-labels.c \
-		util/parse-options.c \
-		util/parse-options.h \
-		util/usage.c \
-		util/json.c \
-		util/size.c \
-		util/strbuf.c \
-		util/wrapper.c \
-		util/filter.c \
-		test/core.c
-
-if ENABLE_SMART
-ndctl_SOURCES += util/json-smart.c
-endif
-
-if ENABLE_TEST
-ndctl_SOURCES += test/libndctl.c \
-		 test/dpa-alloc.c \
-		 test/parent-uuid.c
-endif
-
-if ENABLE_DESTRUCTIVE
-ndctl_SOURCES += test/blk_namespaces.c \
-		 test/pmem_namespaces.c \
-		 test/pcommit.c
-ndctl_SOURCES += builtin-bat.c
-endif
-
-ndctl_LDADD = lib/libndctl.la $(UUID_LIBS) $(KMOD_LIBS) $(JSON_LIBS)
-
 noinst_LIBRARIES = libccan.a
 libccan_a_SOURCES = \
 	ccan/str/str.h \
@@ -145,51 +49,12 @@ libccan_a_SOURCES = \
 	ccan/short_types/short_types.h \
 	ccan/endian/endian.h
 
-EXTRA_DIST += lib/libndctl.sym
-
-lib_libndctl_la_LDFLAGS = $(AM_LDFLAGS) \
-	-version-info $(LIBNDCTL_CURRENT):$(LIBNDCTL_REVISION):$(LIBNDCTL_AGE) \
-	-Wl,--version-script=$(top_srcdir)/lib/libndctl.sym
-lib_libndctl_la_DEPENDENCIES = ${top_srcdir}/lib/libndctl.sym
-
-pkgconfigdir = $(libdir)/pkgconfig
-pkgconfig_DATA = lib/libndctl.pc
-EXTRA_DIST += lib/libndctl.pc.in
-CLEANFILES += lib/libndctl.pc
-
-TESTS = test/libndctl test/dpa-alloc test/parent-uuid test/create.sh \
-	test/clear.sh test/dax-errors.sh
-check_PROGRAMS = test/libndctl test/dpa-alloc test/parent-uuid test/dax-errors
-
-if ENABLE_DESTRUCTIVE
-TESTS += test/blk-ns test/pmem-ns test/pcommit
-check_PROGRAMS += test/blk-ns test/pmem-ns test/pcommit
-
-TESTS += test/dax-dev test/dax.sh test/mmap.sh
-check_PROGRAMS += test/dax-dev test/dax-pmd test/mmap
-endif
-
-test_libndctl_SOURCES = test/libndctl.c test/core.c
-test_libndctl_LDADD = lib/libndctl.la $(UUID_LIBS) $(KMOD_LIBS)
-
-test_pcommit_SOURCES = test/pcommit.c test/core.c
-test_pcommit_LDADD = lib/libndctl.la $(KMOD_LIBS)
-
-test_blk_ns_SOURCES = test/blk_namespaces.c test/core.c
-test_blk_ns_LDADD = lib/libndctl.la $(KMOD_LIBS)
-
-test_pmem_ns_SOURCES = test/pmem_namespaces.c test/core.c
-test_pmem_ns_LDADD = lib/libndctl.la $(KMOD_LIBS)
-
-test_dpa_alloc_SOURCES = test/dpa-alloc.c test/core.c
-test_dpa_alloc_LDADD = lib/libndctl.la $(UUID_LIBS) $(KMOD_LIBS)
-
-test_parent_uuid_SOURCES = test/parent-uuid.c test/core.c
-test_parent_uuid_LDADD = lib/libndctl.la $(UUID_LIBS) $(KMOD_LIBS)
-
-test_dax_dev_SOURCES = test/dax-dev.c test/core.c
-test_dax_dev_LDADD = lib/libndctl.la
-
-test_dax_pmd_SOURCES = test/dax-pmd.c
-test_mmap_SOURCES = test/mmap.c
-test_dax_errors_SOURCES = test/dax-errors.c
+noinst_LIBRARIES += libutil.a
+libutil_a_SOURCES = \
+	util/parse-options.c \
+	util/parse-options.h \
+	util/usage.c \
+	util/size.c \
+	util/strbuf.c \
+	util/wrapper.c \
+	util/filter.c
diff --git a/Makefile.am.in b/Makefile.am.in
new file mode 100644
index 000000000000..a27d95e15061
--- /dev/null
+++ b/Makefile.am.in
@@ -0,0 +1,41 @@
+EXTRA_DIST =
+CLEANFILES =
+
+AM_MAKEFLAGS = --no-print-directory
+
+AM_CPPFLAGS = \
+	-include $(top_builddir)/config.h \
+	-DSYSCONFDIR=\""$(sysconfdir)"\" \
+	-DLIBEXECDIR=\""$(libexecdir)"\" \
+	-DPREFIX=\""$(prefix)"\" \
+	-DNDCTL_MAN_PATH=\""$(mandir)"\" \
+	-I${top_srcdir}/ndctl/lib \
+	-I${top_srcdir}/ndctl \
+	-I${top_srcdir}/ \
+	$(KMOD_CFLAGS) \
+	$(UDEV_CFLAGS) \
+	$(UUID_CFLAGS) \
+	$(JSON_CFLAGS)
+
+AM_CFLAGS = ${my_CFLAGS} \
+	-fvisibility=hidden \
+	-ffunction-sections \
+	-fdata-sections
+
+AM_LDFLAGS = \
+	-Wl,--gc-sections \
+	-Wl,--as-needed
+
+SED_PROCESS = \
+	$(AM_V_GEN)$(MKDIR_P) $(dir $@) && $(SED) \
+	-e 's,@VERSION\@,$(VERSION),g' \
+	-e 's,@prefix\@,$(prefix),g' \
+	-e 's,@exec_prefix\@,$(exec_prefix),g' \
+	-e 's,@libdir\@,$(libdir),g' \
+	-e 's,@includedir\@,$(includedir),g' \
+	< $< > $@ || rm $@
+
+LIBNDCTL_CURRENT=7
+LIBNDCTL_REVISION=0
+LIBNDCTL_AGE=1
+
diff --git a/configure.ac b/configure.ac
index 1525cd4dd954..bc8e947e89f8 100644
--- a/configure.ac
+++ b/configure.ac
@@ -5,7 +5,7 @@ AC_INIT([ndctl],
         [linux-nvdimm@lists.01.org],
         [ndctl],
         [https://github.com/pmem/ndctl])
-AC_CONFIG_SRCDIR([lib/libndctl.c])
+AC_CONFIG_SRCDIR([ndctl/lib/libndctl.c])
 AC_CONFIG_AUX_DIR([build-aux])
 AM_INIT_AUTOMAKE([
 	check-news
@@ -113,7 +113,7 @@ AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
 			#ifdef HAVE_NDCTL_H
 			#include <linux/ndctl.h>
 			#else
-			#include "ndctl.h"
+			#include "ndctl/ndctl.h"
 			#endif
 			]], [[
 			int x = ARS_STATUS_MASK;
@@ -132,7 +132,7 @@ AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
 			#ifdef HAVE_NDCTL_H
 			#include <linux/ndctl.h>
 			#else
-			#include "ndctl.h"
+			#include "ndctl/ndctl.h"
 			#endif
 			]], [[
 			int x = ND_CMD_CLEAR_ERROR;
@@ -151,7 +151,7 @@ AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
 			#ifdef HAVE_NDCTL_H
 			#include <linux/ndctl.h>
 			#else
-			#include "ndctl.h"
+			#include "ndctl/ndctl.h"
 			#endif
 			]], [[
 			int x = ND_DEVICE_DAX_PMEM;
@@ -170,7 +170,7 @@ AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
 			#ifdef HAVE_NDCTL_H
 			#include <linux/ndctl.h>
 			#else
-			#include "ndctl.h"
+			#include "ndctl/ndctl.h"
 			#endif
 			]], [[
 			int x = ND_SMART_HEALTH_VALID;
@@ -209,7 +209,7 @@ AC_CONFIG_COMMANDS([gen-libndctl.h],
 		    -e s/HAVE_NDCTL_SMART/$enable_smart/ \
 		    -e s/HAVE_NDCTL_CLEAR_ERROR/$enable_clear_err/ \
 		    -e s/HAVE_NDCTL_DEV_DAX/$enable_dev_dax/ \
-		< lib/ndctl/libndctl.h.in > lib/ndctl/libndctl.h
+		< ndctl/lib/libndctl.h.in > ndctl/lib/libndctl.h
 		]],
 		[[
 		enable_ars=$enable_ars
@@ -243,6 +243,8 @@ AC_SUBST([my_CFLAGS])
 AC_CONFIG_HEADERS(config.h)
 AC_CONFIG_FILES([
         Makefile
+        ndctl/Makefile
+        test/Makefile
         Documentation/Makefile
 ])
 
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
new file mode 100644
index 000000000000..a89f95088565
--- /dev/null
+++ b/ndctl/Makefile.am
@@ -0,0 +1,75 @@
+include $(top_srcdir)/Makefile.am.in
+
+BUILT_SOURCES = lib/libndctl.h
+lib/libndctl.h: lib/libndctl.h.in
+	touch $(top_srcdir)/version.m4
+
+%.pc: %.pc.in Makefile
+	$(SED_PROCESS)
+
+pkginclude_HEADERS = lib/libndctl.h
+lib_LTLIBRARIES = lib/libndctl.la
+
+lib_libndctl_la_SOURCES =\
+	lib/libndctl.h \
+	lib/libndctl-private.h \
+	lib/libndctl.c
+lib_libndctl_la_LIBADD = $(UDEV_LIBS) $(UUID_LIBS) $(KMOD_LIBS)
+
+if ENABLE_ARS
+lib_libndctl_la_SOURCES += lib/libndctl-ars.c
+endif
+
+if ENABLE_SMART
+lib_libndctl_la_SOURCES += lib/libndctl-smart.c
+endif
+
+bin_PROGRAMS = ndctl
+
+ndctl_SOURCES = ndctl.c \
+		builtin-create-nfit.c \
+		builtin-xaction-namespace.c \
+		builtin-xable-region.c \
+		builtin-list.c \
+		builtin-test.c \
+		builtin-help.c \
+		builtin-zero-labels.c \
+		builtin-read-labels.c \
+		util/json.c
+
+if ENABLE_SMART
+ndctl_SOURCES += util/json-smart.c
+endif
+
+if ENABLE_TEST
+ndctl_SOURCES += $(top_srcdir)/test/libndctl.c \
+		 $(top_srcdir)/test/dpa-alloc.c \
+		 $(top_srcdir)/test/parent-uuid.c \
+		 $(top_srcdir)/test/core.c
+endif
+
+if ENABLE_DESTRUCTIVE
+ndctl_SOURCES += $(top_srcdir)/test/blk_namespaces.c \
+		 $(top_srcdir)/test/pmem_namespaces.c \
+		 $(top_srcdir)/test/pcommit.c
+ndctl_SOURCES += builtin-bat.c
+endif
+
+ndctl_LDADD =\
+	lib/libndctl.la \
+	$(top_srcdir)/libutil.a \
+	$(UUID_LIBS) \
+	$(KMOD_LIBS) \
+	$(JSON_LIBS)
+
+EXTRA_DIST += lib/libndctl.sym
+
+lib_libndctl_la_LDFLAGS = $(AM_LDFLAGS) \
+	-version-info $(LIBNDCTL_CURRENT):$(LIBNDCTL_REVISION):$(LIBNDCTL_AGE) \
+	-Wl,--version-script=$(top_srcdir)/ndctl/lib/libndctl.sym
+lib_libndctl_la_DEPENDENCIES = lib/libndctl.sym
+
+pkgconfigdir = $(libdir)/pkgconfig
+pkgconfig_DATA = lib/libndctl.pc
+EXTRA_DIST += lib/libndctl.pc.in
+CLEANFILES += lib/libndctl.pc
diff --git a/builtin-bat.c b/ndctl/builtin-bat.c
similarity index 100%
rename from builtin-bat.c
rename to ndctl/builtin-bat.c
diff --git a/builtin-create-nfit.c b/ndctl/builtin-create-nfit.c
similarity index 100%
rename from builtin-create-nfit.c
rename to ndctl/builtin-create-nfit.c
diff --git a/builtin-help.c b/ndctl/builtin-help.c
similarity index 100%
rename from builtin-help.c
rename to ndctl/builtin-help.c
diff --git a/builtin-list.c b/ndctl/builtin-list.c
similarity index 100%
rename from builtin-list.c
rename to ndctl/builtin-list.c
diff --git a/builtin-read-labels.c b/ndctl/builtin-read-labels.c
similarity index 100%
rename from builtin-read-labels.c
rename to ndctl/builtin-read-labels.c
diff --git a/builtin-test.c b/ndctl/builtin-test.c
similarity index 100%
rename from builtin-test.c
rename to ndctl/builtin-test.c
diff --git a/builtin-xable-region.c b/ndctl/builtin-xable-region.c
similarity index 100%
rename from builtin-xable-region.c
rename to ndctl/builtin-xable-region.c
diff --git a/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
similarity index 100%
rename from builtin-xaction-namespace.c
rename to ndctl/builtin-xaction-namespace.c
diff --git a/builtin-zero-labels.c b/ndctl/builtin-zero-labels.c
similarity index 100%
rename from builtin-zero-labels.c
rename to ndctl/builtin-zero-labels.c
diff --git a/builtin.h b/ndctl/builtin.h
similarity index 100%
rename from builtin.h
rename to ndctl/builtin.h
diff --git a/lib/.gitignore b/ndctl/lib/.gitignore
similarity index 100%
rename from lib/.gitignore
rename to ndctl/lib/.gitignore
diff --git a/lib/libndctl-ars.c b/ndctl/lib/libndctl-ars.c
similarity index 100%
rename from lib/libndctl-ars.c
rename to ndctl/lib/libndctl-ars.c
diff --git a/lib/libndctl-private.h b/ndctl/lib/libndctl-private.h
similarity index 100%
rename from lib/libndctl-private.h
rename to ndctl/lib/libndctl-private.h
diff --git a/lib/libndctl-smart.c b/ndctl/lib/libndctl-smart.c
similarity index 100%
rename from lib/libndctl-smart.c
rename to ndctl/lib/libndctl-smart.c
diff --git a/lib/libndctl.c b/ndctl/lib/libndctl.c
similarity index 100%
rename from lib/libndctl.c
rename to ndctl/lib/libndctl.c
diff --git a/lib/ndctl/libndctl.h.in b/ndctl/lib/libndctl.h.in
similarity index 100%
rename from lib/ndctl/libndctl.h.in
rename to ndctl/lib/libndctl.h.in
diff --git a/lib/libndctl.pc.in b/ndctl/lib/libndctl.pc.in
similarity index 100%
rename from lib/libndctl.pc.in
rename to ndctl/lib/libndctl.pc.in
diff --git a/lib/libndctl.sym b/ndctl/lib/libndctl.sym
similarity index 100%
rename from lib/libndctl.sym
rename to ndctl/lib/libndctl.sym
diff --git a/ndctl.c b/ndctl/ndctl.c
similarity index 100%
rename from ndctl.c
rename to ndctl/ndctl.c
diff --git a/ndctl.h b/ndctl/ndctl.h
similarity index 100%
rename from ndctl.h
rename to ndctl/ndctl.h
diff --git a/util/json-smart.c b/ndctl/util/json-smart.c
similarity index 100%
rename from util/json-smart.c
rename to ndctl/util/json-smart.c
diff --git a/util/json.c b/ndctl/util/json.c
similarity index 100%
rename from util/json.c
rename to ndctl/util/json.c
diff --git a/util/json.h b/ndctl/util/json.h
similarity index 100%
rename from util/json.h
rename to ndctl/util/json.h
diff --git a/test/Makefile.am b/test/Makefile.am
new file mode 100644
index 000000000000..8f0115387fab
--- /dev/null
+++ b/test/Makefile.am
@@ -0,0 +1,60 @@
+include $(top_srcdir)/Makefile.am.in
+
+TESTS =\
+	libndctl \
+	dpa-alloc \
+	parent-uuid \
+	create.sh \
+	clear.sh \
+	dax-errors.sh
+
+check_PROGRAMS =\
+	libndctl \
+	dpa-alloc \
+	parent-uuid \
+	dax-errors
+
+if ENABLE_DESTRUCTIVE
+TESTS +=\
+	blk-ns \
+	pmem-ns \
+	pcommit \
+	dax-dev \
+	dax.sh \
+	mmap.sh
+
+check_PROGRAMS +=\
+	blk-ns \
+	pmem-ns \
+	pcommit \
+	dax-dev \
+	dax-pmd \
+	mmap
+endif
+
+LIBNDCTL_LIB = $(top_srcdir)/ndctl/lib/libndctl.la
+
+libndctl_SOURCES = libndctl.c core.c
+libndctl_LDADD = $(LIBNDCTL_LIB) $(UUID_LIBS) $(KMOD_LIBS)
+
+pcommit_SOURCES = pcommit.c core.c
+pcommit_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
+
+blk_ns_SOURCES = blk_namespaces.c core.c
+blk_ns_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
+
+pmem_ns_SOURCES = pmem_namespaces.c core.c
+pmem_ns_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
+
+dpa_alloc_SOURCES = dpa-alloc.c core.c
+dpa_alloc_LDADD = $(LIBNDCTL_LIB) $(UUID_LIBS) $(KMOD_LIBS)
+
+parent_uuid_SOURCES = parent-uuid.c core.c
+parent_uuid_LDADD = $(LIBNDCTL_LIB) $(UUID_LIBS) $(KMOD_LIBS)
+
+dax_dev_SOURCES = dax-dev.c core.c
+dax_dev_LDADD = $(LIBNDCTL_LIB)
+
+dax_pmd_SOURCES = dax-pmd.c
+mmap_SOURCES = mmap.c
+dax_errors_SOURCES = dax-errors.c
diff --git a/test/clear.sh b/test/clear.sh
index 16b0cbf3a71c..7765c10078e0 100755
--- a/test/clear.sh
+++ b/test/clear.sh
@@ -1,6 +1,6 @@
 #!/bin/bash -x
 DEV=""
-NDCTL="./ndctl"
+NDCTL="../ndctl/ndctl"
 BUS="-b nfit_test.0"
 BUS1="-b nfit_test.1"
 json2var="s/[{}\",]//g; s/:/=/g"
diff --git a/test/create.sh b/test/create.sh
index b190eccfc243..b0dcdb7da2bd 100755
--- a/test/create.sh
+++ b/test/create.sh
@@ -1,6 +1,6 @@
 #!/bin/bash -x
 DEV=""
-NDCTL="./ndctl"
+NDCTL="../ndctl/ndctl"
 BUS="-b nfit_test.0"
 json2var="s/[{}\",]//g; s/:/=/g"
 SECTOR_SIZE="4096"
diff --git a/test/dax-errors.sh b/test/dax-errors.sh
index 51fe082f0de4..2a498f11e089 100755
--- a/test/dax-errors.sh
+++ b/test/dax-errors.sh
@@ -1,7 +1,7 @@
 #!/bin/bash -x
 
 DEV=""
-NDCTL="./ndctl"
+NDCTL="../ndctl/ndctl"
 BUS="-b nfit_test.0"
 BUS1="-b nfit_test.1"
 MNT=test_dax_mnt
@@ -83,8 +83,8 @@ echo $start_sect 8 > /sys/block/$blockdev/badblocks
 dd if=$MNT/$FILE of=/dev/null iflag=direct bs=4096 count=1 && err $LINENO || true
 
 # run the dax-errors test
-test -x test/dax-errors
-test/dax-errors $MNT/$FILE
+test -x ./dax-errors
+./dax-errors $MNT/$FILE
 
 # TODO: disable this check till we have clear-on-write in the kernel
 #if read sector len < /sys/block/$blockdev/badblocks; then
diff --git a/test/dax.sh b/test/dax.sh
index 9d2c27225653..8db436a869b5 100755
--- a/test/dax.sh
+++ b/test/dax.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 MNT=test_dax_mnt
 FILE=image
-NDCTL="./ndctl"
+NDCTL="../ndctl/ndctl"
 json2var="s/[{}\",]//g; s/:/=/g"
 blockdev=""
 
@@ -21,13 +21,13 @@ set -e
 mkdir -p $MNT
 trap 'err $LINENO' ERR
 
-blockdev=$(basename $(test/dax-dev))
+blockdev=$(basename $(./dax-dev))
 dev=$(basename $(readlink -f /sys/block/$(basename $blockdev)/device))
 
 mkfs.ext4 /dev/$blockdev
 mount /dev/$blockdev $MNT -o dax
 fallocate -l 1GiB $MNT/$FILE
-test/dax-pmd $MNT/$FILE
+./dax-pmd $MNT/$FILE
 umount $MNT
 
 # convert pmem to put the memmap on the device
@@ -39,7 +39,7 @@ eval $(echo $json | sed -e "$json2var")
 mkfs.ext4 /dev/$blockdev
 mount /dev/$blockdev $MNT -o dax
 fallocate -l 1GiB $MNT/$FILE
-test/dax-pmd $MNT/$FILE
+./dax-pmd $MNT/$FILE
 umount $MNT
 
 json=$($NDCTL create-namespace -m raw -f -e $dev)
@@ -49,7 +49,7 @@ eval $(echo $json | sed -e "$json2var")
 mkfs.xfs -f /dev/$blockdev
 mount /dev/$blockdev $MNT -o dax
 fallocate -l 1GiB $MNT/$FILE
-test/dax-pmd $MNT/$FILE
+./dax-pmd $MNT/$FILE
 umount $MNT
 
 # convert pmem to put the memmap on the device
@@ -60,7 +60,7 @@ eval $(echo $json | sed -e "$json2var")
 mkfs.xfs -f /dev/$blockdev
 mount /dev/$blockdev $MNT -o dax
 fallocate -l 1GiB $MNT/$FILE
-test/dax-pmd $MNT/$FILE
+./dax-pmd $MNT/$FILE
 umount $MNT
 
 # revert namespace to raw mode
diff --git a/test/mmap.sh b/test/mmap.sh
index 745962b0c059..e66fb1369434 100755
--- a/test/mmap.sh
+++ b/test/mmap.sh
@@ -2,7 +2,7 @@
 MNT=test_mmap_mnt
 FILE=image
 DEV=""
-TEST=test/mmap
+TEST=./mmap
 
 err() {
 	rc=1
@@ -46,7 +46,7 @@ set -e
 mkdir -p $MNT
 trap 'err $LINENO' ERR
 
-DEV=$(test/dax-dev)
+DEV=$(./dax-dev)
 
 mkfs.ext4 $DEV
 mount $DEV $MNT -o dax

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
