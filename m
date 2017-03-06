Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DE08480342
 for <linux-nvdimm@lists.01.org>; Mon,  6 Mar 2017 13:39:03 -0800 (PST)
Subject: [PATCH 4/4] ndctl: add device dax error clear test
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 06 Mar 2017 14:39:03 -0700
Message-ID: <148883634307.72901.8906703230765193251.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <148883624600.72901.16358369702902205527.stgit@djiang5-desk3.ch.intel.com>
References: <148883624600.72901.16358369702902205527.stgit@djiang5-desk3.ch.intel.com>
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

Adding a test/example on clearing of error/poison for device DAX. Most of
the code were moved from the test/libndctl.c check bus commands.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 test/Makefile.am      |   10 +
 test/daxdev-errors.c  |  361 +++++++++++++++++++++++++++++++++++++++++++++++++
 test/daxdev-errors.sh |   71 ++++++++++
 3 files changed, 440 insertions(+), 2 deletions(-)
 create mode 100644 test/daxdev-errors.c
 create mode 100755 test/daxdev-errors.sh

diff --git a/test/Makefile.am b/test/Makefile.am
index 524fafa..cd2226f 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -8,7 +8,8 @@ TESTS =\
 	multi-pmem \
 	create.sh \
 	clear.sh \
-	dax-errors.sh
+	dax-errors.sh \
+	daxdev-errors.sh
 
 check_PROGRAMS =\
 	libndctl \
@@ -16,7 +17,8 @@ check_PROGRAMS =\
 	dpa-alloc \
 	parent-uuid \
 	multi-pmem \
-	dax-errors
+	dax-errors \
+	daxdev-errors
 
 if ENABLE_DESTRUCTIVE
 TESTS +=\
@@ -72,6 +74,10 @@ dax_dev_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
 dax_pmd_SOURCES = dax-pmd.c
 mmap_SOURCES = mmap.c
 dax_errors_SOURCES = dax-errors.c
+daxdev_errors_SOURCES = daxdev-errors.c \
+			../util/log.c \
+			../util/sysfs.c
+daxdev_errors_LDADD = $(LIBNDCTL_LIB)
 device_dax_SOURCES = \
 		device-dax.c \
 		dax-dev.c \
diff --git a/test/daxdev-errors.c b/test/daxdev-errors.c
new file mode 100644
index 0000000..687e593
--- /dev/null
+++ b/test/daxdev-errors.c
@@ -0,0 +1,361 @@
+#include <stdio.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <string.h>
+#include <errno.h>
+#include <sys/ioctl.h>
+#include <stdlib.h>
+#include <linux/fs.h>
+#include <linux/fiemap.h>
+#include <setjmp.h>
+#include <limits.h>
+
+#include <util/log.h>
+#include <util/sysfs.h>
+#include <ccan/array_size/array_size.h>
+#include <ndctl/libndctl.h>
+#include <daxctl/libdaxctl.h>
+#ifdef HAVE_NDCTL_H
+#include <linux/ndctl.h>
+#else
+#include <ndctl.h>
+#endif
+
+#define fail() fprintf(stderr, "%s: failed at: %d\n", __func__, __LINE__)
+
+struct check_cmd {
+	struct ndctl_cmd *cmd;
+	struct ndctl_test *test;
+};
+
+static sigjmp_buf sj_env;
+static int sig_count;
+
+static const char *NFIT_PROVIDER0 = "nfit_test.0";
+static struct check_cmd *check_cmds;
+
+static void sigbus_hdl(int sig, siginfo_t *siginfo, void *ptr)
+{
+	fprintf(stderr, "** Received a SIGBUS **\n");
+	sig_count++;
+	siglongjmp(sj_env, 1);
+}
+
+static int check_ars_cap(struct ndctl_bus *bus, uint64_t start,
+		size_t size, struct check_cmd *check)
+{
+	struct ndctl_cmd *cmd;
+	int rc;
+
+	if (check->cmd != NULL) {
+		fprintf(stderr, "%s: expected a NULL command, by default\n",
+				__func__);
+		return -EINVAL;
+	}
+
+	cmd = ndctl_bus_cmd_new_ars_cap(bus, start, size);
+	if (!cmd) {
+		fprintf(stderr, "%s: bus: %s failed to create cmd\n",
+				__func__, ndctl_bus_get_provider(bus));
+		return -ENOTTY;
+	}
+
+	rc = ndctl_cmd_submit(cmd);
+	if (rc) {
+		fprintf(stderr, "%s: bus: %s failed to submit cmd: %d\n",
+				__func__, ndctl_bus_get_provider(bus), rc);
+		ndctl_cmd_unref(cmd);
+		return rc;
+	}
+
+	if (ndctl_cmd_ars_cap_get_size(cmd) < sizeof(struct nd_cmd_ars_status)){
+		fprintf(stderr, "%s: bus: %s expected size >= %zd got: %d\n",
+				__func__, ndctl_bus_get_provider(bus),
+				sizeof(struct nd_cmd_ars_status),
+				ndctl_cmd_ars_cap_get_size(cmd));
+		ndctl_cmd_unref(cmd);
+		return -ENXIO;
+	}
+
+	check->cmd = cmd;
+	return 0;
+}
+
+static int check_ars_start(struct ndctl_bus *bus, struct check_cmd *check)
+{
+	struct ndctl_cmd *cmd_ars_cap = check_cmds[ND_CMD_ARS_CAP].cmd;
+	struct ndctl_cmd *cmd;
+	int rc;
+
+	if (check->cmd != NULL) {
+		fprintf(stderr, "%s: expected a NULL command, by default\n",
+				__func__);
+		return -ENXIO;
+	}
+
+	cmd = ndctl_bus_cmd_new_ars_start(cmd_ars_cap, ND_ARS_PERSISTENT);
+	if (!cmd) {
+		fprintf(stderr, "%s: bus: %s failed to create cmd\n",
+				__func__, ndctl_bus_get_provider(bus));
+		return -ENOTTY;
+	}
+
+	rc = ndctl_cmd_submit(cmd);
+	if (rc) {
+		fprintf(stderr, "%s: bus: %s failed to submit cmd: %d\n",
+				__func__, ndctl_bus_get_provider(bus), rc);
+		ndctl_cmd_unref(cmd);
+		return rc;
+	}
+
+	check->cmd = cmd;
+	return 0;
+}
+
+static int check_ars_status(struct ndctl_bus *bus, struct check_cmd *check)
+{
+	struct ndctl_cmd *cmd_ars_cap = check_cmds[ND_CMD_ARS_CAP].cmd;
+	struct ndctl_cmd *cmd;
+	unsigned long tmo = 5;
+	unsigned int i;
+	int rc;
+
+	if (check->cmd != NULL) {
+		fprintf(stderr, "%s: expected a NULL command, by default\n",
+				__func__);
+		return -ENXIO;
+	}
+
+ retry:
+	cmd = ndctl_bus_cmd_new_ars_status(cmd_ars_cap);
+	if (!cmd) {
+		fprintf(stderr, "%s: bus: %s failed to create cmd\n",
+				__func__, ndctl_bus_get_provider(bus));
+		return -ENOTTY;
+	}
+
+	rc = ndctl_cmd_submit(cmd);
+	if (rc) {
+		fprintf(stderr, "%s: bus: %s failed to submit cmd: %d\n",
+				__func__, ndctl_bus_get_provider(bus), rc);
+		ndctl_cmd_unref(cmd);
+		return rc;
+	}
+
+	if (!tmo) {
+		fprintf(stderr, "%s: bus: %s ars timeout\n", __func__,
+				ndctl_bus_get_provider(bus));
+		return -EIO;
+	}
+
+	if (ndctl_cmd_ars_in_progress(cmd)) {
+		tmo--;
+		sleep(1);
+		goto retry;
+	}
+
+	for (i = 0; i < ndctl_cmd_ars_num_records(cmd); i++) {
+		fprintf(stderr, "%s: record[%d].addr: 0x%llx\n", __func__, i,
+				ndctl_cmd_ars_get_record_addr(cmd, i));
+		fprintf(stderr, "%s: record[%d].length: 0x%llx\n", __func__, i,
+				ndctl_cmd_ars_get_record_len(cmd, i));
+	}
+
+	check->cmd = cmd;
+	return 0;
+}
+
+static int check_clear_error(struct ndctl_bus *bus, struct check_cmd *check)
+{
+	struct ndctl_cmd *ars_cap = check_cmds[ND_CMD_ARS_CAP].cmd;
+	struct ndctl_cmd *clear_err;
+	unsigned long long cleared;
+	struct ndctl_range range;
+	int rc;
+
+	if (check->cmd != NULL) {
+		fprintf(stderr, "%s: expected a NULL command, by default\n",
+				__func__);
+		return -ENXIO;
+	}
+
+	if (ndctl_cmd_ars_cap_get_range(ars_cap, &range)) {
+		fprintf(stderr, "failed to get ars_cap range\n");
+		return -ENXIO;
+	}
+
+	fprintf(stderr, "%s: clearing at %#llx for %llu bytes\n",
+			__func__, range.address, range.length);
+
+	clear_err = ndctl_bus_cmd_new_clear_error(range.address,
+					range.length, ars_cap);
+	if (!clear_err) {
+		fprintf(stderr, "%s: bus: %s failed to create cmd\n",
+				__func__, ndctl_bus_get_provider(bus));
+		return -ENOTTY;
+	}
+
+	rc = ndctl_cmd_submit(clear_err);
+	if (rc) {
+		fprintf(stderr, "%s: bus: %s failed to submit cmd: %d\n",
+				__func__, ndctl_bus_get_provider(bus), rc);
+		ndctl_cmd_unref(clear_err);
+		return rc;
+	}
+
+	cleared = ndctl_cmd_clear_error_get_cleared(clear_err);
+	if (cleared != range.length) {
+		fprintf(stderr, "%s: bus: %s expected to clear: %lld actual: %lld\
+n",
+				__func__, ndctl_bus_get_provider(bus),
+				range.length, cleared);
+		return -ENXIO;
+	}
+
+	check->cmd = clear_err;
+	return 0;
+}
+
+static struct ndctl_dax * get_dax_region(struct ndctl_region *region)
+{
+	struct ndctl_dax *dax;
+
+	ndctl_dax_foreach(region, dax)
+		if (ndctl_dax_is_enabled(dax) &&
+			ndctl_dax_is_configured(dax))
+			return dax;
+
+	return NULL;
+}
+
+static int test_daxdev_clear_error(void)
+{
+	int rc = 0, i;
+	struct ndctl_ctx *ctx;
+	struct ndctl_bus *bus;
+	struct ndctl_region *region;
+	struct ndctl_dax *dax = NULL;
+	uint64_t base, start, offset, blocks, size;
+        struct check_cmd __bus_cmds[] = {
+                [ND_CMD_ARS_CAP] = {},
+                [ND_CMD_ARS_START] = {},
+                [ND_CMD_ARS_STATUS] = {},
+                [ND_CMD_CLEAR_ERROR] = {},
+        };
+	char path[256];
+	char buf[SYSFS_ATTR_SIZE];
+	struct log_ctx log_ctx;
+
+	log_init(&log_ctx, "test/init", "NDCTL_DAXDEV_TEST");
+	rc = ndctl_new(&ctx);
+	if (rc)
+		return rc;
+
+	bus = ndctl_bus_get_by_provider(ctx, NFIT_PROVIDER0);
+	if (!bus) {
+		rc = -ENODEV;
+		goto cleanup;
+	}
+
+	ndctl_region_foreach(bus, region) {
+		/* find the dax region */
+		dax = get_dax_region(region);
+		if (dax)
+			break;
+	}
+
+	if (!dax) {
+		rc = -ENODEV;
+		goto cleanup;
+	}
+
+	/* get badblocks */
+	if (snprintf(path, 256,
+			"/sys/devices/platform/%s/ndbus0/%s/badblocks",
+			NFIT_PROVIDER0,
+			ndctl_region_get_devname(region)) >= 256) {
+		fprintf(stderr, "%s: buffer too small!\n",
+				ndctl_region_get_devname(region));
+		rc = -ENXIO;
+		goto cleanup;
+	}
+
+	if (__sysfs_read_attr(&log_ctx, path, buf) < 0) {
+		rc = -ENXIO;
+		goto cleanup;
+	}
+
+	/* retrieve badblocks from buf */
+	rc = sscanf(buf, "%lu %lu", &offset, &blocks);
+	if (rc == EOF) {
+		rc = -errno;
+		goto cleanup;
+	}
+
+	/* get resource base */
+	base = ndctl_region_get_resource(region);
+	if (base == ULLONG_MAX) {
+		rc = -ERANGE;
+		goto cleanup;
+	}
+
+	check_cmds = __bus_cmds;
+	start = base + offset * 512;
+	size = 512 * blocks;
+
+	rc = check_ars_cap(bus, start, size, &check_cmds[ND_CMD_ARS_CAP]);
+	if (rc < 0)
+		goto cleanup;
+
+	rc = check_ars_start(bus, &check_cmds[ND_CMD_ARS_START]);
+	if (rc < 0)
+		goto cleanup;
+
+	rc = check_ars_status(bus, &check_cmds[ND_CMD_ARS_STATUS]);
+	if (rc < 0)
+		goto cleanup;
+
+	rc = check_clear_error(bus, &check_cmds[ND_CMD_CLEAR_ERROR]);
+	if (rc < 0)
+		goto cleanup;
+
+	for (i = 1; i < (int)ARRAY_SIZE(__bus_cmds); i++) {
+		if (__bus_cmds[i].cmd) {
+			ndctl_cmd_unref(__bus_cmds[i].cmd);
+			__bus_cmds[i].cmd = NULL;
+                }
+	}
+
+cleanup:
+	ndctl_unref(ctx);
+	return rc;
+}
+
+
+int main(int argc, char *argv[])
+{
+	int rc;
+	struct sigaction act;
+
+	if (argc < 1)
+		return -EINVAL;
+
+	memset(&act, 0, sizeof(act));
+	act.sa_sigaction = sigbus_hdl;
+	act.sa_flags = SA_SIGINFO;
+
+	if (sigaction(SIGBUS, &act, 0)) {
+		fail();
+		return 1;
+	}
+
+	rc = test_daxdev_clear_error();
+
+	return rc;
+}
diff --git a/test/daxdev-errors.sh b/test/daxdev-errors.sh
new file mode 100755
index 0000000..4ba8fb5
--- /dev/null
+++ b/test/daxdev-errors.sh
@@ -0,0 +1,71 @@
+#!/bin/bash -x
+
+DEV=""
+NDCTL="../ndctl/ndctl"
+DAXCTL="../daxctl/daxctl"
+BUS="-b nfit_test.0"
+BUS1="-b nfit_test.1"
+rc=77
+
+err() {
+	rc=1
+	echo "test/daxdev-errors: failed at line $1"
+	exit $rc
+}
+
+eval $(uname -r | awk -F. '{print "maj="$1 ";" "min="$2}')
+if [ $maj -lt 4 ]; then
+	echo "kernel $maj.$min lacks dax dev error handling"
+	exit $rc
+elif [ $maj -eq 4 -a $min -lt 10 ]; then
+	echo "kernel $maj.$min lacks dax dev error handling"
+	exit $rc
+fi
+
+set -e
+trap 'err $LINENO' ERR
+
+# setup (reset nfit_test dimms)
+modprobe nfit_test
+$NDCTL disable-region $BUS all
+$NDCTL zero-labels $BUS all
+$NDCTL enable-region $BUS all
+
+json=$($NDCTL create-namespace $BUS -t pmem -m dax -a 4096)
+chardev=$(echo $json | jq ". | select(.mode == \"dax\") | .daxregion.devices[0].chardev")
+
+#  "dev":"namespace5.0",
+#  "mode":"dax",
+#  "size":64475136,
+#  "uuid":"068776fa-50e6-4c27-b99a-4b1e710c627c",
+#  "daxregion":{
+#    "id":5,
+#    "size":64475136,
+#    "align":4096,
+#    "devices":[
+#      {
+#        "chardev":"dax5.0",
+#        "size":64475136
+#      }
+#    ]
+#  }
+
+read sector len < /sys/bus/platform/devices/nfit_test.0/ndbus0/region5/badblocks
+echo "sector: $sector len: $len"
+
+# run the daxdev-errors test
+test -x ./daxdev-errors
+./daxdev-errors
+
+# check badblocks, should be empty
+if read sector len < /sys/bus/platform/devices/nfit_test.0/ndbus0/region5/badblocks; then
+	echo "badblocks empty, expected"
+fi
+[ -n "$sector" ] && echo "fail: $LINENO" && exit 1
+
+# cleanup
+$NDCTL disable-region $BUS all
+$NDCTL disable-region $BUS1 all
+modprobe -r nfit_test
+
+exit 0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
