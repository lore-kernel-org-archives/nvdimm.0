Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3E66D2D
	for <nvdimm@lists.linux.dev>; Thu,  1 Jul 2021 20:10:25 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10032"; a="205606905"
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="205606905"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 13:10:18 -0700
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="409271341"
Received: from anandvig-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.38.85])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 13:10:17 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 08/21] test: introduce a libcxl unit test
Date: Thu,  1 Jul 2021 14:09:52 -0600
Message-Id: <20210701201005.3065299-9-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210701201005.3065299-1-vishal.l.verma@intel.com>
References: <20210701201005.3065299-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new 'libcxl' test containing a basic harness for unit testing
libcxl APIs. Include sanity tests such as making sure the test is
running in an emulated environment, the ability to load and unload
modules. Submit an 'Identify Device' command, and verify that it
succeeds, and the identify data returned is as expected from an emulated
QEMU device.

Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/libcxl-expect.h |  13 +++
 test/libcxl.c        | 269 +++++++++++++++++++++++++++++++++++++++++++
 test/Makefile.am     |  12 +-
 3 files changed, 292 insertions(+), 2 deletions(-)
 create mode 100644 test/libcxl-expect.h
 create mode 100644 test/libcxl.c

diff --git a/test/libcxl-expect.h b/test/libcxl-expect.h
new file mode 100644
index 0000000..acb8db9
--- /dev/null
+++ b/test/libcxl-expect.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021 Intel Corporation. All rights reserved. */
+#ifndef __LIBCXL_EXPECT_H__
+#define __LIBCXL_EXPECT_H__
+#include <stdbool.h>
+
+#define EXPECT_FW_VER "BWFW VERSION 00"
+
+/* Identify command fields */
+#define EXPECT_CMD_IDENTIFY_PARTITION_ALIGN 0ULL
+#define EXPECT_CMD_IDENTIFY_LSA_SIZE 1024U
+
+#endif /* __LIBCXL_EXPECT_H__ */
diff --git a/test/libcxl.c b/test/libcxl.c
new file mode 100644
index 0000000..241a4bb
--- /dev/null
+++ b/test/libcxl.c
@@ -0,0 +1,269 @@
+// SPDX-License-Identifier: LGPL-2.1
+/* Copyright (C) 2021, Intel Corporation. All rights reserved. */
+#include <stdio.h>
+#include <stddef.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <ctype.h>
+#include <errno.h>
+#include <unistd.h>
+#include <limits.h>
+#include <syslog.h>
+#include <libkmod.h>
+#include <sys/wait.h>
+#include <uuid/uuid.h>
+#include <sys/types.h>
+#include <sys/ioctl.h>
+#include <sys/select.h>
+#include <linux/version.h>
+
+#include <util/size.h>
+#include <ccan/short_types/short_types.h>
+#include <ccan/array_size/array_size.h>
+#include <ccan/endian/endian.h>
+#include <cxl/libcxl.h>
+#include <cxl/cxl_mem.h>
+#include <test.h>
+#include "libcxl-expect.h"
+
+#define TEST_SKIP 77
+
+const char *mod_list[] = {
+	"cxl_pci",
+	"cxl_acpi",
+	"cxl_core",
+};
+
+static int test_cxl_presence(struct cxl_ctx *ctx)
+{
+	struct cxl_memdev *memdev;
+	int count = 0;
+
+	cxl_memdev_foreach(ctx, memdev)
+		count++;
+
+	if (count == 0) {
+		fprintf(stderr, "%s: no cxl memdevs found\n", __func__);
+		return TEST_SKIP;
+	}
+
+	return 0;
+}
+
+/*
+ * Only continue with tests if all CXL devices in the system are qemu-emulated
+ * 'fake' devices. For now, use the firmware_version to check for this. Later,
+ * this might need to be changed to a vendor specific command.
+ *
+ * TODO: Change this to produce a list of devices that are safe to run tests
+ * against, and only run subsequent tests on this list. That will allow devices
+ * from other, non-emulated sources to be present in the system, and still run
+ * these unit tests safely.
+ */
+static int test_cxl_emulation_env(struct cxl_ctx *ctx)
+{
+	struct cxl_memdev *memdev;
+
+	cxl_memdev_foreach(ctx, memdev) {
+		const char *fw;
+
+		fw = cxl_memdev_get_firmware_verison(memdev);
+		if (!fw)
+			return -ENXIO;
+		if (strcmp(fw, EXPECT_FW_VER) != 0) {
+			fprintf(stderr,
+				"%s: found non-emulation device, aborting\n",
+				__func__);
+			return TEST_SKIP;
+		}
+	}
+	return 0;
+}
+
+static int test_cxl_modules(struct cxl_ctx *ctx)
+{
+	int rc;
+	unsigned int i;
+	const char *name;
+	struct kmod_module *mod;
+	struct kmod_ctx *kmod_ctx;
+
+	kmod_ctx = kmod_new(NULL, NULL);
+	if (!kmod_ctx)
+		return -ENXIO;
+	kmod_set_log_priority(kmod_ctx, LOG_DEBUG);
+
+	/* test module removal */
+	for (i = 0; i < ARRAY_SIZE(mod_list); i++) {
+		int state;
+
+		name = mod_list[i];
+
+		rc = kmod_module_new_from_name(kmod_ctx, name, &mod);
+		if (rc) {
+			fprintf(stderr, "%s: %s.ko: missing\n", __func__, name);
+			break;
+		}
+
+		state = kmod_module_get_initstate(mod);
+		if (state == KMOD_MODULE_LIVE) {
+			rc = kmod_module_remove_module(mod, 0);
+			if (rc) {
+				fprintf(stderr,
+					"%s: %s.ko: failed to remove: %d\n",
+					__func__, name, rc);
+				break;
+			}
+		} else if (state == KMOD_MODULE_BUILTIN) {
+			fprintf(stderr,
+				"%s: %s is builtin, skipping module removal test\n",
+				__func__, name);
+		} else {
+			fprintf(stderr,
+				"%s: warning: %s.ko: unexpected state (%d), trying to continue\n",
+				__func__, name, state);
+		}
+	}
+
+	if (rc)
+		goto out;
+
+	/* test module insertion */
+	for (i = 0; i < ARRAY_SIZE(mod_list); i++) {
+		name = mod_list[i];
+		rc = kmod_module_new_from_name(kmod_ctx, name, &mod);
+		if (rc) {
+			fprintf(stderr, "%s: %s.ko: missing\n", __func__, name);
+			break;
+		}
+
+		rc = kmod_module_probe_insert_module(mod,
+				KMOD_PROBE_APPLY_BLACKLIST,
+				NULL, NULL, NULL, NULL);
+	}
+
+out:
+	kmod_unref(kmod_ctx);
+	return rc;
+}
+
+#define expect(c, name, field, expect) \
+do { \
+	if (cxl_cmd_##name##_get_##field(c) != expect) { \
+		fprintf(stderr, \
+			"%s: %s: " #field " mismatch\n", \
+			__func__, cxl_cmd_get_devname(c)); \
+		cxl_cmd_unref(cmd); \
+		return -ENXIO; \
+	} \
+} while (0)
+
+static int test_cxl_cmd_identify(struct cxl_ctx *ctx)
+{
+	struct cxl_memdev *memdev;
+	struct cxl_cmd *cmd;
+	int rc;
+
+	cxl_memdev_foreach(ctx, memdev) {
+		char fw_rev[0x10];
+
+		cmd = cxl_cmd_new_identify(memdev);
+		if (!cmd)
+			return -ENOMEM;
+		rc = cxl_cmd_submit(cmd);
+		if (rc < 0) {
+			fprintf(stderr, "%s: %s: cmd submission failed: %s\n",
+				__func__, cxl_memdev_get_devname(memdev),
+				strerror(-rc));
+			goto out_fail;
+		}
+		rc = cxl_cmd_get_mbox_status(cmd);
+		if (rc) {
+			fprintf(stderr,
+				"%s: %s: cmd failed with firmware status: %d\n",
+				__func__, cxl_memdev_get_devname(memdev), rc);
+			rc = -ENXIO;
+			goto out_fail;
+		}
+
+		rc = cxl_cmd_identify_get_fw_rev(cmd, fw_rev, 0x10);
+		if (rc)
+			goto out_fail;
+		if (strncmp(fw_rev, EXPECT_FW_VER, 0x10) != 0) {
+			fprintf(stderr,
+				"%s: fw_rev mismatch. Expected %s, got %s\n",
+				__func__, EXPECT_FW_VER, fw_rev);
+			rc = -ENXIO;
+			goto out_fail;
+		}
+
+		expect(cmd, identify, lsa_size, EXPECT_CMD_IDENTIFY_LSA_SIZE);
+		expect(cmd, identify, partition_align,
+			EXPECT_CMD_IDENTIFY_PARTITION_ALIGN);
+		cxl_cmd_unref(cmd);
+	}
+	return 0;
+
+out_fail:
+	cxl_cmd_unref(cmd);
+	return rc;
+}
+
+typedef int (*do_test_fn)(struct cxl_ctx *ctx);
+
+static do_test_fn do_test[] = {
+	test_cxl_modules,
+	test_cxl_presence,
+	test_cxl_emulation_env,
+	test_cxl_cmd_identify,
+};
+
+static int test_libcxl(int loglevel, struct test_ctx *test, struct cxl_ctx *ctx)
+{
+	unsigned int i;
+	int err, result = EXIT_FAILURE;
+
+	if (!test_attempt(test, KERNEL_VERSION(5, 12, 0)))
+		return 77;
+
+	cxl_set_log_priority(ctx, loglevel);
+	cxl_set_private_data(ctx, test);
+
+	for (i = 0; i < ARRAY_SIZE(do_test); i++) {
+		err = do_test[i](ctx);
+		if (err < 0) {
+			fprintf(stderr, "test[%d] failed: %d\n", i, err);
+			break;
+		} else if (err == TEST_SKIP) {
+			fprintf(stderr, "test[%d]: SKIP\n", i);
+			test_skip(test);
+			result = TEST_SKIP;
+			break;
+		}
+		fprintf(stderr, "test[%d]: PASS\n", i);
+	}
+
+	if (i >= ARRAY_SIZE(do_test))
+		result = EXIT_SUCCESS;
+	return result;
+}
+
+int __attribute__((weak)) main(int argc, char *argv[])
+{
+	struct test_ctx *test = test_new(0);
+	struct cxl_ctx *ctx;
+	int rc;
+
+	if (!test) {
+		fprintf(stderr, "failed to initialize test\n");
+		return EXIT_FAILURE;
+	}
+
+	rc = cxl_new(&ctx);
+	if (rc)
+		return test_result(test, rc);
+	rc = test_libcxl(LOG_DEBUG, test, ctx);
+	cxl_unref(ctx);
+	return test_result(test, rc);
+}
diff --git a/test/Makefile.am b/test/Makefile.am
index c5b8764..ce492a4 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -44,7 +44,8 @@ check_PROGRAMS =\
 	hugetlb \
 	daxdev-errors \
 	ack-shutdown-count-set \
-	list-smart-dimm
+	list-smart-dimm \
+	libcxl
 
 if ENABLE_DESTRUCTIVE
 TESTS +=\
@@ -61,7 +62,8 @@ TESTS +=\
 	daxctl-devices.sh \
 	daxctl-create.sh \
 	dm.sh \
-	mmap.sh
+	mmap.sh \
+	libcxl
 
 if ENABLE_KEYUTILS
 TESTS += security.sh
@@ -190,3 +192,9 @@ list_smart_dimm_LDADD = \
 		$(JSON_LIBS) \
 		$(UUID_LIBS) \
 		../libutil.a
+
+LIBCXL_LIB =\
+	../cxl/lib/libcxl.la
+
+libcxl_SOURCES = libcxl.c $(testcore)
+libcxl_LDADD = $(LIBCXL_LIB) $(UUID_LIBS) $(KMOD_LIBS)
-- 
2.31.1

