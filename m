Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CC0B71A1E43
 for <linux-nvdimm@lists.01.org>; Wed, 26 Oct 2016 15:08:59 -0700 (PDT)
Subject: [PATCH] ndctl: Add test for device-dax error testing path
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 26 Oct 2016 15:08:59 -0700
Message-ID: <147751973916.37168.16873128081426478070.stgit@djiang5-desk3.ch.intel.com>
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

The test creates a dax device via the nfit_test with injected error.
The test uses fallocate(PUNCH_HOLE) to clear the error and then check
again to see if the error has been cleared. This requires code that
will be going into 4.10 kernel to discover the badblocks on the device
and fallocate support to clear the errors.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 test/Makefile.am          |    8 ++-
 test/device-dax-errors.c  |  130 +++++++++++++++++++++++++++++++++++++++++++++
 test/device-dax-errors.sh |   52 ++++++++++++++++++
 3 files changed, 188 insertions(+), 2 deletions(-)
 create mode 100644 test/device-dax-errors.c
 create mode 100755 test/device-dax-errors.sh

diff --git a/test/Makefile.am b/test/Makefile.am
index 46a1acf..6dce75e 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -8,7 +8,8 @@ TESTS =\
 	multi-pmem \
 	create.sh \
 	clear.sh \
-	dax-errors.sh
+	dax-errors.sh \
+	device-dax-errors.sh
 
 check_PROGRAMS =\
 	libndctl \
@@ -16,7 +17,8 @@ check_PROGRAMS =\
 	dpa-alloc \
 	parent-uuid \
 	multi-pmem \
-	dax-errors
+	dax-errors \
+	device-dax-errors
 
 if ENABLE_DESTRUCTIVE
 TESTS +=\
@@ -69,6 +71,8 @@ dax_dev_LDADD = $(LIBNDCTL_LIB)
 dax_pmd_SOURCES = dax-pmd.c
 mmap_SOURCES = mmap.c
 dax_errors_SOURCES = dax-errors.c
+device_dax_errors_SOURCES = device-dax-errors.c core.c
+device_dax_errors_LDADD = $(LIBNDCTL_LIB)
 device_dax_SOURCES = \
 		device-dax.c \
 		dax-dev.c \
diff --git a/test/device-dax-errors.c b/test/device-dax-errors.c
new file mode 100644
index 0000000..9705ac6
--- /dev/null
+++ b/test/device-dax-errors.c
@@ -0,0 +1,130 @@
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <linux/falloc.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <unistd.h>
+#include <libgen.h>
+#include <linux/version.h>
+#include <ndctl/builtin.h>
+#include <test.h>
+
+static int clear_badblocks(int dev_fd, char *dev_path);
+
+static int clear_badblocks(int dev_fd, char *dev_path)
+{
+	char *base, *bb_file;
+	char bb_path[128] = "/sys/class/dax/";
+	int rc, i;
+	unsigned long bbs[32][2];
+	unsigned long bb[2];
+	FILE *fp;
+
+	memset(bb, 0, sizeof(unsigned long) * 32 * 2);
+	base = basename(dev_path);
+	bb_file = strcat(strcat(bb_path, base), "/badblocks");
+
+	printf("opening %s\n", bb_file);
+	fp = fopen(bb_file, "r");
+	if (!fp) {
+		perror("open failed");
+		return -ENXIO;
+	}
+
+	i = 0;
+
+	/* read out all the bad blocks */
+	while ((fscanf(fp, "%lu %lu", &bbs[i][0], &bbs[i][1]) != EOF) &&
+	       (i++ < 32))
+		printf("badblock %d @ %lu for len %lu\n",
+			i-1, bbs[i-1][0], bbs[i-1][1]);
+
+	i = 0;
+	while (bbs[i][1]) {
+		printf("fallocate @ sector %lu for %lu bytes\n",
+			bbs[i][0] * 512, bbs[i][1] * 512);
+		rc = fallocate(dev_fd,
+			FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+			bbs[i][0] * 512, bbs[i][1] * 512);
+		if (rc < 0) {
+			perror("fallocate failed");
+			return -ENXIO;
+		}
+		i++;
+	}
+
+	if (!i) {
+		printf("No badblocks found\n");
+		goto exit;
+	}
+
+	fseek(fp, 0, SEEK_SET);
+
+	if (fscanf(fp, "%lu %lu", &bb[0], &bb[1]) != EOF) {
+		perror("reading badblocks");
+		rc = -ENXIO;
+		goto exit;
+	}
+
+	if (bb[0] || bb[1])
+		rc = -ENXIO;
+	else
+		rc = 0;
+
+exit:
+	fclose(fp);
+	return rc;
+}
+
+int main(int argc, char *argv[])
+{
+	int fd, rc;
+	char *path;
+	struct stat st;
+	struct ndctl_test *test = ndctl_test_new(0);
+
+	if (!test) {
+		fprintf(stderr, "failed to initialize test\n");
+		return EXIT_FAILURE;
+	}
+
+	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 10, 0)))
+		return EXIT_FAILURE;
+
+	if (argc < 2) {
+		perror("argc invalid");
+		return -EINVAL;
+	}
+
+	if (stat(argv[1], &st) < 0) {
+		perror("invalid file");
+		return EXIT_FAILURE;
+	}
+
+	if (!S_ISCHR(st.st_mode)) {
+		fprintf(stderr, "%s not char device\n", argv[1]);
+		return EXIT_FAILURE;
+	}
+
+	fd = open(argv[1], O_RDWR);
+	if (fd < 0) {
+		perror("fd");
+		return EXIT_FAILURE;
+	}
+
+	path = strdup(argv[1]);
+	rc = clear_badblocks(fd, path);
+	if (rc < 0) {
+		fprintf(stderr, "Failed to clear badblocks on %s\n", argv[1]);
+		return EXIT_FAILURE;
+	}
+
+	free(path);
+	close(fd);
+
+	return EXIT_SUCCESS;
+}
diff --git a/test/device-dax-errors.sh b/test/device-dax-errors.sh
new file mode 100755
index 0000000..54c43de
--- /dev/null
+++ b/test/device-dax-errors.sh
@@ -0,0 +1,52 @@
+#!/bin/bash -x
+
+DEV=""
+NDCTL="../ndctl/ndctl"
+BUS="-b nfit_test.0"
+json2var="s/[{}\",]//g; s/:/=/g"
+rc=77
+
+err() {
+	rc=1
+	echo "test/device-dax-errors: failed at line $1"
+	exit $rc
+}
+
+eval $(uname -r | awk -F. '{print "maj="$1 ";" "min="$2}')
+if [ $maj -lt 4 ]; then
+	echo "kernel $maj.$min lacks dax error handling"
+	exit $rc
+elif [ $maj -eq 4 -a $min -lt 7 ]; then
+	echo "kernel $maj.$min lacks dax error handling"
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
+rc=1
+
+# create device dax
+dev="x"
+json=$($NDCTL create-namespace $BUS -t pmem -m dax -a 0x1000)
+eval $(echo $json | sed -e 's/\]//g' -e "$json2var")
+[ $dev = "x" ] && echo "fail: $LINENO" && exit 1
+[ $mode != "dax" ] && echo "fail: $LINENO" && exit 1
+
+# run the dax-errors test
+test -x ./device-dax-errors
+echo "device-dax-errors /dev/$chardev"
+./device-dax-errors /dev/$chardev
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
