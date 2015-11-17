Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH] ndctl: dax pmd tests
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 17 Nov 2015 12:50:21 -0800
Message-ID: <20151117204650.25132.94694.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

Check the following conditions:

1/ gup fault

2/ gup fast

3/ copying a huge mapping on fork()

Cc: Jan Kara <jack@suse.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
This is the test case used to generate the kernel crash signatures
mentioned in "[PATCH 2/8] dax: disable pmd mappings":

https://lists.01.org/pipermail/linux-nvdimm/2015-November/002875.html

 Makefile.am        |    8 ++
 lib/test-dax-dev.c |   96 +++++++++++++++++++++++++++++
 lib/test-dax-pmd.c |  172 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/test-dax.sh    |   34 ++++++++++
 4 files changed, 310 insertions(+)
 create mode 100755 lib/test-dax-dev.c
 create mode 100644 lib/test-dax-pmd.c
 create mode 100755 lib/test-dax.sh

diff --git a/Makefile.am b/Makefile.am
index e998c5766631..2989e076972d 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -122,6 +122,9 @@ check_PROGRAMS = lib/test-libndctl lib/test-dpa-alloc lib/test-parent-uuid
 if ENABLE_DESTRUCTIVE
 TESTS += lib/test-blk-ns lib/test-pmem-ns lib/test-pcommit
 check_PROGRAMS += lib/test-blk-ns lib/test-pmem-ns lib/test-pcommit
+
+TESTS += lib/test-dax-dev lib/test-dax.sh
+check_PROGRAMS += lib/test-dax-dev lib/test-dax-pmd
 endif
 
 lib_test_libndctl_SOURCES = lib/test-libndctl.c lib/test-core.c
@@ -141,3 +144,8 @@ lib_test_dpa_alloc_LDADD = lib/libndctl.la $(UUID_LIBS) $(KMOD_LIBS)
 
 lib_test_parent_uuid_SOURCES = lib/test-parent-uuid.c lib/test-core.c
 lib_test_parent_uuid_LDADD = lib/libndctl.la $(UUID_LIBS) $(KMOD_LIBS)
+
+lib_test_dax_dev_SOURCES = lib/test-dax-dev.c lib/test-core.c
+lib_test_dax_dev_LDADD = lib/libndctl.la
+
+lib_test_dax_pmd_SOURCES = lib/test-dax-pmd.c
diff --git a/lib/test-dax-dev.c b/lib/test-dax-dev.c
new file mode 100755
index 000000000000..3ca7cef0f71c
--- /dev/null
+++ b/lib/test-dax-dev.c
@@ -0,0 +1,96 @@
+/*
+ * Copyright (c) 2014-2015, Intel Corporation.
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
+#include <fcntl.h>
+#include <ctype.h>
+#include <errno.h>
+#include <unistd.h>
+#include <limits.h>
+#include <syslog.h>
+
+#include <test.h>
+#include <linux/version.h>
+#include <ndctl/libndctl.h>
+
+static int emit_e820_device(int loglevel, struct ndctl_test *test)
+{
+	int err, fd;
+	char path[256];
+	const char *bdev;
+	struct ndctl_ctx *ctx;
+	struct ndctl_bus *bus;
+	struct ndctl_region *region;
+	struct ndctl_namespace *ndns;
+
+	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 3, 0)))
+		return 77;
+
+	err = ndctl_new(&ctx);
+	if (err < 0)
+		return err;
+
+	ndctl_set_log_priority(ctx, loglevel);
+	err = -ENXIO;
+	bus = ndctl_bus_get_by_provider(ctx, "e820");
+	if (!bus)
+		goto out;
+
+	region = ndctl_region_get_first(bus);
+	if (!region)
+		goto out;
+
+	ndns = ndctl_namespace_get_first(region);
+	if (!ndns)
+		goto out;
+
+	bdev = ndctl_namespace_get_block_device(ndns);
+	if (!bdev)
+		goto out;
+
+	if (snprintf(path, sizeof(path), "/dev/%s", bdev) >= (int) sizeof(path))
+		goto out;
+
+	/*
+	 * Note, if the bdev goes active after this check we'll still
+	 * clobber it in the following tests, see lib/test-dax.sh.
+	 */
+	fd = open(path, O_RDWR | O_EXCL);
+	if (fd < 0)
+		goto out;
+	err = 0;
+	fprintf(stdout, "%s\n", path);
+
+ out:
+	if (err)
+		fprintf(stderr, "%s: failed to find usable victim device\n",
+				__func__);
+	ndctl_unref(ctx);
+	return err;
+}
+
+int __attribute__((weak)) main(int argc, char *argv[])
+{
+	struct ndctl_test *test = ndctl_test_new(0);
+	int rc;
+
+	if (!test) {
+		fprintf(stderr, "failed to initialize test\n");
+		return EXIT_FAILURE;
+	}
+
+	rc = emit_e820_device(LOG_DEBUG, test);
+	return ndctl_test_result(test, rc);
+}
diff --git a/lib/test-dax-pmd.c b/lib/test-dax-pmd.c
new file mode 100644
index 000000000000..fc64c7b82836
--- /dev/null
+++ b/lib/test-dax-pmd.c
@@ -0,0 +1,172 @@
+#include <stdio.h>
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
+
+#define NUM_EXTENTS 5
+#define HPAGE_SIZE (2 << 20)
+#define ALIGN(x, a) ((((unsigned long long) x) + (a - 1)) & ~(a - 1))
+#define fail() fprintf(stderr, "%s: failed at: %d\n", __func__, __LINE__)
+#define faili(i) fprintf(stderr, "%s: failed at: %d: %ld\n", __func__, __LINE__, i)
+#define TEST_FILE "test_dax_data"
+
+/* test_pmd assumes that fd references a pre-allocated + dax-capable file */
+static int test_pmd(int fd)
+{
+	unsigned long long m_align, p_align;
+	int fd2 = -1, rc = -ENXIO;
+	struct fiemap_extent *ext;
+	struct fiemap *map;
+	void *addr, *buf;
+	unsigned long i;
+
+	if (fd < 0) {
+		fail();
+		return -ENXIO;
+	}
+
+	map = calloc(1, sizeof(struct fiemap)
+			+ sizeof(struct fiemap_extent) * NUM_EXTENTS);
+	if (!map) {
+		fail();
+		return -ENXIO;
+	}
+
+	if (posix_memalign(&buf, 4096, 4096) != 0)
+		goto err_memalign;
+
+        addr = mmap(NULL, 4*HPAGE_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
+        if (addr == MAP_FAILED) {
+		fail();
+		goto err_mmap;
+	}
+	munmap(addr, 4*HPAGE_SIZE);
+
+	map->fm_start = 0;
+	map->fm_length = -1;
+	map->fm_extent_count = NUM_EXTENTS;
+	rc = ioctl(fd, FS_IOC_FIEMAP, map);
+	if (rc < 0) {
+		fail();
+		goto err_extent;
+	}
+
+	for (i = 0; i < map->fm_mapped_extents; i++) {
+		ext = &map->fm_extents[i];
+		fprintf(stderr, "[%ld]: l: %llx p: %llx len: %llx flags: %x\n",
+				i, ext->fe_logical, ext->fe_physical,
+				ext->fe_length, ext->fe_flags);
+		if (ext->fe_length > 2 * HPAGE_SIZE) {
+			fprintf(stderr, "found potential huge extent\n");
+			break;
+		}
+	}
+
+	if (i >= map->fm_mapped_extents) {
+		fail();
+		goto err_extent;
+	}
+
+	m_align = ALIGN(addr, HPAGE_SIZE) - ((unsigned long) addr);
+	p_align = ALIGN(ext->fe_physical, HPAGE_SIZE) - ext->fe_physical;
+
+	for (i = 0; i < 3; i++) {
+		rc = -ENXIO;
+		addr = mmap((char *) addr + m_align, 2*HPAGE_SIZE,
+				PROT_READ|PROT_WRITE, MAP_SHARED, fd,
+				ext->fe_logical + p_align);
+		if (addr == MAP_FAILED) {
+			faili(i);
+			break;
+		}
+
+		fd2 = open(TEST_FILE, O_CREAT|O_TRUNC|O_DIRECT|O_RDWR);
+		if (fd2 < 0) {
+			faili(i);
+			munmap(addr, 2*HPAGE_SIZE);
+			break;
+		}
+
+		rc = 0;
+		switch (i) {
+		case 0: /* test O_DIRECT of unfaulted address */
+			if (write(fd2, addr, 4096) != 4096) {
+				faili(i);
+				rc = -ENXIO;
+			}
+			break;
+		case 1: /* test O_DIRECT of pre-faulted address */
+			sprintf(addr, "odirect data");
+			if (write(fd2, addr, 4096) != 4096) {
+				faili(i);
+				rc = -ENXIO;
+			}
+			((char *) buf)[0] = 0;
+			read(fd2, buf, sizeof(buf));
+			if (strcmp(buf, "test data") != 0) {
+				faili(i);
+				rc = -ENXIO;
+			}
+			break;
+		case 2: /* fork with pre-faulted pmd */
+			sprintf(addr, "fork data");
+			rc = fork();
+			if (rc == 0) {
+				/* child */
+				if (strcmp(addr, "fork data") == 0)
+					exit(EXIT_SUCCESS);
+				else
+					exit(EXIT_FAILURE);
+			} else if (rc > 0) {
+				/* parent */
+				wait(&rc);
+				if (rc != EXIT_SUCCESS)
+					faili(i);
+			} else
+				faili(i);
+			break;
+		default:
+			faili(i);
+			rc = -ENXIO;
+			break;
+		}
+
+		munmap(addr, 2*HPAGE_SIZE);
+		addr = MAP_FAILED;
+		unlink(TEST_FILE);
+		close(fd2);
+		fd2 = -1;
+		if (rc)
+			break;
+	}
+
+ err_extent:
+ err_mmap:
+	free(buf);
+ err_memalign:
+	free(map);
+	return rc;
+}
+
+int main(int argc, char *argv[])
+{
+	int fd, rc;
+
+	if (argc < 1)
+		return -EINVAL;
+
+	fd = open(argv[1], O_RDWR);
+	rc = test_pmd(fd);
+	if (fd >= 0)
+		close(fd);
+	return rc;
+}
diff --git a/lib/test-dax.sh b/lib/test-dax.sh
new file mode 100755
index 000000000000..048d82975d92
--- /dev/null
+++ b/lib/test-dax.sh
@@ -0,0 +1,34 @@
+#!/bin/bash
+MNT=test_dax_mnt
+FILE=image
+DEV=""
+
+err() {
+	rc=1
+	echo "test-dax: failed at line $1"
+	if [ -n "$DEV" ]; then
+		umount $DEV
+	else
+		rc=77
+	fi
+	rmdir $MNT
+	exit $rc
+}
+
+set -e
+mkdir -p $MNT
+trap 'err $LINENO' ERR
+
+DEV=$(lib/test-dax-dev)
+
+mkfs.ext4 $DEV
+mount $DEV $MNT -o dax
+fallocate -l 1GiB $MNT/$FILE
+lib/test-dax-pmd $MNT/$FILE
+umount $MNT
+
+mkfs.xfs -f $DEV
+mount $DEV $MNT -o dax
+fallocate -l 1GiB $MNT/$FILE
+lib/test-dax-pmd $MNT/$FILE
+umount $MNT

