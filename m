Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 3EDB41A1DF6
 for <linux-nvdimm@lists.01.org>; Tue, 16 Aug 2016 10:24:28 -0700 (PDT)
Subject: [ndctl PATCH 7/8] test: convert device-dax test from shell to C
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 16 Aug 2016 10:22:04 -0700
Message-ID: <147136812464.27902.10272950614113633356.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147136808681.27902.14029119240021638000.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147136808681.27902.14029119240021638000.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for expanded device-dax unit tests, convert the existing
implementation to be entirely C-based.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/Makefile.am   |   13 ++++-
 test/device-dax.c  |  128 ++++++++++++++++++++++++++++++++++++++++++++++------
 test/device-dax.sh |   40 ----------------
 3 files changed, 124 insertions(+), 57 deletions(-)
 delete mode 100755 test/device-dax.sh

diff --git a/test/Makefile.am b/test/Makefile.am
index ab566148e1f4..d13c138bb28a 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -20,7 +20,7 @@ TESTS +=\
 	pmem-ns \
 	dax-dev \
 	dax.sh \
-	device-dax.sh \
+	device-dax \
 	mmap.sh
 
 check_PROGRAMS +=\
@@ -57,4 +57,13 @@ dax_dev_LDADD = $(LIBNDCTL_LIB)
 dax_pmd_SOURCES = dax-pmd.c
 mmap_SOURCES = mmap.c
 dax_errors_SOURCES = dax-errors.c
-device_dax_SOURCES = device-dax.c
+device_dax_SOURCES = \
+		device-dax.c \
+		dax-dev.c \
+		core.c \
+		../ndctl/builtin-xaction-namespace.c \
+		../ndctl/util/json.c
+device_dax_LDADD = \
+		$(LIBNDCTL_LIB) \
+		$(JSON_LIBS) \
+		../libutil.a
diff --git a/test/device-dax.c b/test/device-dax.c
index addf93f59252..7b624ea5bc8f 100644
--- a/test/device-dax.c
+++ b/test/device-dax.c
@@ -1,32 +1,130 @@
-#include <sys/mman.h>
-#include <sys/types.h>
-#include <sys/stat.h>
 #include <fcntl.h>
-#include <linux/falloc.h>
 #include <stdio.h>
-#include <string.h>
 #include <errno.h>
 #include <unistd.h>
+#include <stdlib.h>
+#include <syslog.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <linux/falloc.h>
+#include <linux/version.h>
+#include <ndctl/libndctl.h>
+#include <daxctl/libdaxctl.h>
+#include <ccan/array_size/array_size.h>
+
+#include <ndctl/builtin.h>
+#include <test.h>
+
+static int create_namespace(int argc, const char **argv, struct ndctl_ctx *ctx)
+{
+	builtin_xaction_namespace_reset();
+	return cmd_create_namespace(argc, argv, ctx);
+}
+
+static int reset_device_dax(struct ndctl_namespace *ndns)
+{
+	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
+	const char *argv[] = {
+		"__func__", "-v", "-m", "raw", "-f", "-e", "",
+	};
+	int argc = ARRAY_SIZE(argv);
+
+	argv[argc - 1] = ndctl_namespace_get_devname(ndns);
+	return create_namespace(argc, argv, ctx);
+}
+
+static int setup_device_dax(struct ndctl_namespace *ndns)
+{
+	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
+	const char *argv[] = {
+		"__func__", "-v", "-m", "dax", "-M", "dev", "-f", "-e", "",
+	};
+	int argc = ARRAY_SIZE(argv);
+
+	argv[argc - 1] = ndctl_namespace_get_devname(ndns);
+	return create_namespace(argc, argv, ctx);
+}
 
-int main(int argc, char *argv[])
+static int test_device_dax(int loglevel, struct ndctl_test *test,
+		struct ndctl_ctx *ctx)
 {
-	char *buf;
-	int fd;
+	int fd, rc, *p;
+	char *buf, path[100];
+	struct ndctl_dax *dax;
+	struct daxctl_dev *dev;
+	struct ndctl_namespace *ndns;
+	struct daxctl_region *dax_region;
+
+	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 7, 0)))
+		return 77;
+
+	ndctl_set_log_priority(ctx, loglevel);
 
-	if (argc < 2) {
-		perror("argc invalid");
-		return -EINVAL;
+	ndns = ndctl_get_test_dev(ctx);
+	if (!ndns) {
+		fprintf(stderr, "%s: failed to find suitable namespace\n",
+				__func__);
+		return 77;
 	}
 
-	fd = open(argv[1], O_RDWR);
+	rc = setup_device_dax(ndns);
+	if (rc < 0) {
+		fprintf(stderr, "%s: failed device-dax setup\n",
+				ndctl_namespace_get_devname(ndns));
+		return rc;
+	}
+
+	dax = ndctl_namespace_get_dax(ndns);
+	dax_region = ndctl_dax_get_daxctl_region(dax);
+	dev = daxctl_dev_get_first(dax_region);
+	if (!dev) {
+		fprintf(stderr, "%s: failed to find device-dax instance\n",
+				ndctl_namespace_get_devname(ndns));
+		return -ENXIO;
+	}
+
+	sprintf(path, "/dev/%s", daxctl_dev_get_devname(dev));
+
+	fd = open(path, O_RDWR);
 	if (fd < 0) {
-		perror("fd");
-		return 1;
+		fprintf(stderr, "%s: failed to open device-dax instance\n",
+				daxctl_dev_get_devname(dev));
+		return -ENXIO;
 	}
 
 	buf = mmap(NULL, 2UL << 20, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
-	*((int *) (buf + (1UL << 20))) = 0;
+	p = (int *) (buf + (1UL << 20));
+	*p = 0;
+
+	rc = reset_device_dax(ndns);
+	if (rc < 0) {
+		fprintf(stderr, "%s: failed to reset device-dax instance\n",
+				ndctl_namespace_get_devname(ndns));
+		return rc;
+	}
 
 	close(fd);
 	return 0;
 }
+
+int __attribute__((weak)) main(int argc, char *argv[])
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
+	if (rc < 0)
+		return ndctl_test_result(test, rc);
+
+	rc = test_device_dax(LOG_DEBUG, test, ctx);
+	ndctl_unref(ctx);
+	return ndctl_test_result(test, rc);
+}
diff --git a/test/device-dax.sh b/test/device-dax.sh
deleted file mode 100755
index 6bc724fe7c95..000000000000
--- a/test/device-dax.sh
+++ /dev/null
@@ -1,40 +0,0 @@
-#!/bin/bash
-NDCTL="../ndctl/ndctl"
-json2var="s/[{}\",]//g; s/:/=/g; s/\]//g"
-rc=77
-
-err() {
-	rc=$?
-	echo "device-dax: failed at line $1"
-	exit $rc
-}
-
-eval $(uname -r | awk -F. '{print "maj="$1 ";" "min="$2}')
-if [ $maj -lt 4 ]; then
-	echo "kernel $maj.$min lacks device-dax"
-	exit $rc
-elif [ $maj -eq 4 -a $min -lt 7 ]; then
-	echo "kernel $maj.$min lacks device-dax"
-	exit $rc
-fi
-
-set -e -x
-trap 'err $LINENO' ERR
-
-dev=$(./dax-dev)
-json=$($NDCTL list -N -n $dev)
-eval $(echo $json | sed -e "$json2var")
-
-# setup a device-dax configuration
-json=$($NDCTL create-namespace -v -m dax -M dev -f -e $dev)
-eval $(echo $json | sed -e "$json2var")
-[ $mode != "dax" ] && echo "fail: $LINENO" &&  exit 1
-
-./device-dax /dev/$chardev
-
-# revert namespace to raw mode
-json=$($NDCTL create-namespace -v -m raw -f -e $dev)
-eval $(echo $json | sed -e "$json2var")
-[ $mode != "memory" ] && echo "fail: $LINENO" &&  exit 1
-
-exit 0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
