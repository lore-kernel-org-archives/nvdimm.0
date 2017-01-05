Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9D48B81992
 for <linux-nvdimm@lists.01.org>; Thu,  5 Jan 2017 07:26:49 -0800 (PST)
Subject: [ndctl PATCH] test: validate nfit_test modules before running tests
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 05 Jan 2017 07:22:42 -0800
Message-ID: <148362976248.39125.3102549215272905495.stgit@dwillia2-desk3.amr.corp.intel.com>
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

System crashes and other failures can occur if an environment attempts
to run the unit tests with the "production" / in-tree versions of the
nfit and libnvdimm modules. Ensure that all required test modules are
supplied by out-of-tree versions.

Granted that this detection mechanism will not differentiate the proper
tools/testing/nvdimm/ out-of-tree modules with something like a "driver
update" version of the modules, but it should catch the common case of a
platform being misconfigured for unit-test execution.

Reported-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/Makefile.am |   25 ++++++++++--------
 test/core.c      |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+), 11 deletions(-)

diff --git a/test/Makefile.am b/test/Makefile.am
index 592308ee5f07..524fafa4a28a 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -40,30 +40,33 @@ LIBNDCTL_LIB =\
        ../ndctl/lib/libndctl.la \
        ../daxctl/lib/libdaxctl.la
 
-libndctl_SOURCES = libndctl.c core.c
+testcore =\
+	core.c \
+	../util/log.c \
+	../util/sysfs.c
+
+libndctl_SOURCES = libndctl.c $(testcore)
 libndctl_LDADD = $(LIBNDCTL_LIB) $(UUID_LIBS) $(KMOD_LIBS)
 
 dsm_fail_SOURCES =\
 	dsm-fail.c \
-	core.c \
-	../util/log.c \
-	../util/sysfs.c
+	$(testcore)
 
 dsm_fail_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
 
-blk_ns_SOURCES = blk_namespaces.c core.c
+blk_ns_SOURCES = blk_namespaces.c $(testcore)
 blk_ns_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
 
-pmem_ns_SOURCES = pmem_namespaces.c core.c
+pmem_ns_SOURCES = pmem_namespaces.c $(testcore)
 pmem_ns_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
 
-dpa_alloc_SOURCES = dpa-alloc.c core.c
+dpa_alloc_SOURCES = dpa-alloc.c $(testcore)
 dpa_alloc_LDADD = $(LIBNDCTL_LIB) $(UUID_LIBS) $(KMOD_LIBS)
 
-parent_uuid_SOURCES = parent-uuid.c core.c
+parent_uuid_SOURCES = parent-uuid.c $(testcore)
 parent_uuid_LDADD = $(LIBNDCTL_LIB) $(UUID_LIBS) $(KMOD_LIBS)
 
-dax_dev_SOURCES = dax-dev.c core.c
+dax_dev_SOURCES = dax-dev.c $(testcore)
 dax_dev_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
 
 dax_pmd_SOURCES = dax-pmd.c
@@ -73,7 +76,7 @@ device_dax_SOURCES = \
 		device-dax.c \
 		dax-dev.c \
 		dax-pmd.c \
-		core.c \
+		$(testcore) \
 		../ndctl/builtin-xaction-namespace.c \
 		../util/json.c
 device_dax_LDADD = \
@@ -84,7 +87,7 @@ device_dax_LDADD = \
 
 multi_pmem_SOURCES = \
 		multi-pmem.c \
-		core.c \
+		$(testcore) \
 		../ndctl/builtin-xaction-namespace.c \
 		../util/json.c
 multi_pmem_LDADD = \
diff --git a/test/core.c b/test/core.c
index 3119fd826a94..d1c38902feb4 100644
--- a/test/core.c
+++ b/test/core.c
@@ -6,6 +6,10 @@
 #include <stdio.h>
 #include <test.h>
 
+#include <util/log.h>
+#include <util/sysfs.h>
+#include <ccan/array_size/array_size.h>
+
 #define KVER_STRLEN 20
 
 struct ndctl_test {
@@ -103,12 +107,84 @@ int nfit_test_init(struct kmod_ctx **ctx, struct kmod_module **mod,
 		int log_level)
 {
 	int rc;
+	unsigned int i;
+	struct log_ctx log_ctx;
+	const char *list[] = {
+		"nfit",
+		"dax",
+		"dax_pmem",
+		"libnvdimm",
+		"nd_blk",
+		"nd_btt",
+		"nd_e820",
+		"nd_pmem",
+	};
+
+	log_init(&log_ctx, "test/init", "NDCTL_TEST");
+	log_ctx.log_priority = log_level;
 
 	*ctx = kmod_new(NULL, NULL);
 	if (!*ctx)
 		return -ENXIO;
 	kmod_set_log_priority(*ctx, log_level);
 
+	/*
+	 * Check that all nfit, libnvdimm, and device-dax modules are
+	 * the mocked versions. If they are loaded, check that they have
+	 * the "out-of-tree" kernel taint, otherwise check that they
+	 * come from the "/lib/modules/<KVER>/extra" directory.
+	 */
+	for (i = 0; i < ARRAY_SIZE(list); i++) {
+		char attr[SYSFS_ATTR_SIZE];
+		const char *name = list[i];
+		const char *path;
+		char buf[100];
+		int state;
+
+		rc = kmod_module_new_from_name(*ctx, name, mod);
+		if (rc) {
+			log_err(&log_ctx, "%s.ko: missing\n", name);
+			break;
+		}
+
+		path = kmod_module_get_path(*mod);
+		if (!path) {
+			log_err(&log_ctx, "%s.ko: failed to get path\n", name);
+			break;
+		}
+
+		if (!strstr(path, "/extra/")) {
+			log_err(&log_ctx, "%s.ko: appears to be production version: %s\n",
+					name, path);
+			break;
+		}
+
+		state = kmod_module_get_initstate(*mod);
+		if (state == KMOD_MODULE_LIVE) {
+			sprintf(buf, "/sys/module/%s/taint", name);
+			rc = __sysfs_read_attr(&log_ctx, buf, attr);
+			if (rc < 0) {
+				log_err(&log_ctx, "%s.ko: failed to read %s\n",
+						name, buf);
+				break;
+			}
+
+			if (strcmp(attr, "O") != 0) {
+				log_err(&log_ctx, "%s.ko: expected taint: O got: %s\n",
+						name, attr);
+				break;
+			}
+		} else if (state == KMOD_MODULE_BUILTIN) {
+			log_err(&log_ctx, "%s: must be built as a module\n", name);
+			break;
+		}
+	}
+
+	if (i < ARRAY_SIZE(list)) {
+		kmod_unref(*ctx);
+		return -ENXIO;
+	}
+
 	rc = kmod_module_new_from_name(*ctx, "nfit_test", mod);
 	if (rc < 0) {
 		kmod_unref(*ctx);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
