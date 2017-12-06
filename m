Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E881420352AB6
 for <linux-nvdimm@lists.01.org>; Wed,  6 Dec 2017 14:49:06 -0800 (PST)
Subject: [PATCH 2/2] ndctl: lss latch unit test
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 06 Dec 2017 15:53:38 -0700
Message-ID: <151260081841.5641.3484968163450235231.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151260081283.5641.2560511933614024819.stgit@djiang5-desk3.ch.intel.com>
References: <151260081283.5641.2560511933614024819.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 0 files changed

diff --git a/test/Makefile.am b/test/Makefile.am
index d5ef648..7f70e63 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -17,7 +17,8 @@ TESTS =\
 	sector-mode.sh \
 	inject-error.sh \
 	btt-errors.sh \
-	firmware-update.sh
+	firmware-update.sh \
+	lss-status-set
 
 check_PROGRAMS =\
 	libndctl \
@@ -28,7 +29,8 @@ check_PROGRAMS =\
 	dax-errors \
 	smart-notify \
 	smart-listen \
-	daxdev-errors
+	daxdev-errors \
+	lss-status-set
 
 if ENABLE_DESTRUCTIVE
 TESTS +=\
@@ -67,6 +69,12 @@ dsm_fail_SOURCES =\
 
 dsm_fail_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
 
+lss_status_set_SOURCES =\
+	lss-status-set.c \
+	$(testcore)
+
+lss_status_set_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
+
 blk_ns_SOURCES = blk_namespaces.c $(testcore)
 blk_ns_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
 
diff --git a/test/lss-status-set.c b/test/lss-status-set.c
new file mode 100644
index 0000000..5056a8f
--- /dev/null
+++ b/test/lss-status-set.c
@@ -0,0 +1,157 @@
+/*
+ * Copyright (c) 2017, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU Lesser General Public License,
+ * version 2.1, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT ANY
+ * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
+ * more details.
+ */
+#include <stdio.h>
+#include <stddef.h>
+#include <stdlib.h>
+#include <string.h>
+#include <ctype.h>
+#include <errno.h>
+#include <syslog.h>
+#include <libkmod.h>
+#include <util/log.h>
+#include <util/sysfs.h>
+#include <linux/version.h>
+
+#include <ccan/array_size/array_size.h>
+#include <ndctl/libndctl.h>
+#ifdef HAVE_NDCTL_H
+#include <linux/ndctl.h>
+#else
+#include <ndctl.h>
+#endif
+#include <test.h>
+
+static int test_dimm(struct ndctl_dimm *dimm)
+{
+	struct ndctl_cmd *cmd;
+	int rc = 0;
+
+	cmd = ndctl_dimm_cmd_new_lss_enable(dimm);
+	if (!cmd)
+		return -ENOMEM;
+
+	rc = ndctl_cmd_lss_set_enable(cmd, 1);
+	if (rc < 0)
+		goto out;
+
+	rc = ndctl_cmd_submit(cmd);
+	if (rc < 0)
+		goto out;
+
+	rc = ndctl_cmd_get_firmware_status(cmd);
+	if (rc != 0) {
+		fprintf(stderr, "dimm %s LSS enable set failed\n",
+				ndctl_dimm_get_devname(dimm));
+		goto out;
+	}
+
+	printf("DIMM %s LSS enable set\n", ndctl_dimm_get_devname(dimm));
+
+out:
+	ndctl_cmd_unref(cmd);
+	return rc;
+}
+
+static void reset_bus(struct ndctl_bus *bus)
+{
+	struct ndctl_region *region;
+	struct ndctl_dimm *dimm;
+
+	/* disable all regions so that set_config_data commands are permitted */
+	ndctl_region_foreach(bus, region)
+		ndctl_region_disable_invalidate(region);
+
+	ndctl_dimm_foreach(bus, dimm)
+		ndctl_dimm_zero_labels(dimm);
+}
+
+static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
+{
+	struct ndctl_bus *bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
+	struct ndctl_dimm *dimm;
+	struct ndctl_region *region;
+	struct log_ctx log_ctx;
+	int rc = 0;
+
+	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 15, 0)))
+		return 77;
+
+	if (!bus)
+		return -ENXIO;
+
+	log_init(&log_ctx, "test/lss-status-set", "NDCTL_TEST");
+
+	ndctl_bus_wait_probe(bus);
+
+	ndctl_region_foreach(bus, region)
+		ndctl_region_disable_invalidate(region);
+
+	ndctl_dimm_foreach(bus, dimm) {
+		fprintf(stderr, "Testing dimm: %s\n",
+				ndctl_dimm_get_devname(dimm));
+		rc = test_dimm(dimm);
+		if (rc < 0) {
+			fprintf(stderr, "dimm %s failed\n",
+				ndctl_dimm_get_devname(dimm));
+			goto out;
+		}
+	}
+
+out:
+	reset_bus(bus);
+	return rc;
+}
+
+static int test_lss_status_set(int loglevel, struct ndctl_test *test,
+		struct ndctl_ctx *ctx)
+{
+	struct kmod_module *mod;
+	struct kmod_ctx *kmod_ctx;
+	int result = EXIT_FAILURE, err;
+
+	ndctl_set_log_priority(ctx, loglevel);
+	err = nfit_test_init(&kmod_ctx, &mod, NULL, loglevel, test);
+	if (err < 0) {
+		result = 77;
+		ndctl_test_skip(test);
+		fprintf(stderr, "%s unavailable skipping tests\n",
+				"nfit_test");
+		return result;
+	}
+
+	result = do_test(ctx, test);
+	kmod_module_remove_module(mod, 0);
+
+	kmod_unref(kmod_ctx);
+	return result;
+}
+
+int main(int argc, char *argv[])
+{
+	struct ndctl_test *test = ndctl_test_new(0);
+	struct ndctl_ctx *ctx;
+	int rc;
+
+	if (!test) {
+		fprintf(stderr, "failed to initialize test\n");
+		return EXIT_FAILURE;
+	}
+
+	rc = ndctl_new(&ctx);
+	if (rc)
+		return ndctl_test_result(test, rc);
+	rc = test_lss_status_set(LOG_DEBUG, test, ctx);
+	ndctl_unref(ctx);
+
+	return ndctl_test_result(test, rc);
+}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
