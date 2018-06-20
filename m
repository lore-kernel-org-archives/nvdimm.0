Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 16C85211BFCDA
 for <linux-nvdimm@lists.01.org>; Wed, 20 Jun 2018 15:51:52 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [fstests PATCH 2/2] generic/999: test DAX DMA vs truncate/hole-punch
Date: Wed, 20 Jun 2018 16:51:47 -0600
Message-Id: <20180620225147.12151-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20180620225147.12151-1-ross.zwisler@linux.intel.com>
References: <20180620225147.12151-1-ross.zwisler@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

This adds a regression test for the following series:

https://lists.01.org/pipermail/linux-nvdimm/2018-June/016431.html

which added synchronization between DAX DMA in ext4 and
truncate/hole-punch.  The intention of the test is to test those specific
changes, but it runs fine both with XFS and without DAX, so I've put it in
the generic tests instead of ext4 and not restricted it to only DAX
configurations.

When run with v4.18-rc1 + DAX + ext4, this test will hit the following
WARN_ON_ONCE() in dax_disassociate_entry():

	WARN_ON_ONCE(trunc && page_ref_count(page) > 1);

If you change this to a WARN_ON() instead, you can see that each of the
four paths being exercised in this test hits that condition many times in
the one second that the subtest is being run.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 .gitignore             |   1 +
 src/Makefile           |   2 +-
 src/t_mmap_collision.c | 208 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/999      |  50 ++++++++++++
 tests/generic/999.out  |   2 +
 tests/generic/group    |   1 +
 6 files changed, 263 insertions(+), 1 deletion(-)
 create mode 100644 src/t_mmap_collision.c
 create mode 100755 tests/generic/999
 create mode 100644 tests/generic/999.out

diff --git a/.gitignore b/.gitignore
index efc73a7c..936955e0 100644
--- a/.gitignore
+++ b/.gitignore
@@ -126,6 +126,7 @@
 /src/t_immutable
 /src/t_locks_execve
 /src/t_mmap_cow_race
+/src/t_mmap_collision
 /src/t_mmap_dio
 /src/t_mmap_fallocate
 /src/t_mmap_stale_pmd
diff --git a/src/Makefile b/src/Makefile
index b06b7e25..2dbe5e7e 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -15,7 +15,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 	holetest t_truncate_self t_mmap_dio af_unix t_mmap_stale_pmd \
 	t_mmap_cow_race t_mmap_fallocate fsync-err t_mmap_write_ro \
 	t_ext4_dax_journal_corruption t_ext4_dax_inline_corruption \
-	t_ofd_locks t_locks_execve
+	t_ofd_locks t_locks_execve t_mmap_collision
 
 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
diff --git a/src/t_mmap_collision.c b/src/t_mmap_collision.c
new file mode 100644
index 00000000..f652e913
--- /dev/null
+++ b/src/t_mmap_collision.c
@@ -0,0 +1,208 @@
+#include <errno.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <unistd.h>
+
+#define PAGE(a) ((a)*0x1000)
+#define FILE_SIZE PAGE(4)
+
+void *dax_data;
+int nodax_fd;
+int dax_fd;
+bool done;
+
+#define err_exit(op)                                                          \
+{                                                                             \
+	fprintf(stderr, "%s %s: %s\n", __func__, op, strerror(errno));        \
+	exit(1);                                                              \
+}                                                                             \
+
+void punch_hole_fn(void *ptr)
+{
+	ssize_t read;
+	int rc;
+
+	while (!done) {
+		read = 0;
+
+		do {
+			rc = pread(nodax_fd, dax_data + read, FILE_SIZE - read,
+					read);
+			if (rc > 0)
+				read += rc;
+		} while (rc > 0);
+
+		if (read != FILE_SIZE || rc != 0)
+			err_exit("pread");
+
+		rc = fallocate(dax_fd,
+				FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+				0, FILE_SIZE);
+		if (rc < 0)
+			err_exit("fallocate");
+
+		usleep(rand() % 1000);
+	}
+}
+
+void zero_range_fn(void *ptr)
+{
+	ssize_t read;
+	int rc;
+
+	while (!done) {
+		read = 0;
+
+		do {
+			rc = pread(nodax_fd, dax_data + read, FILE_SIZE - read,
+					read);
+			if (rc > 0)
+				read += rc;
+		} while (rc > 0);
+
+		if (read != FILE_SIZE || rc != 0)
+			err_exit("pread");
+
+		rc = fallocate(dax_fd,
+				FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE,
+				0, FILE_SIZE);
+		if (rc < 0)
+			err_exit("fallocate");
+
+		usleep(rand() % 1000);
+	}
+}
+
+void truncate_down_fn(void *ptr)
+{
+	ssize_t read;
+	int rc;
+
+	while (!done) {
+		read = 0;
+
+		if (ftruncate(dax_fd, 0) < 0)
+			err_exit("ftruncate");
+		if (fallocate(dax_fd, 0, 0, FILE_SIZE) < 0)
+			err_exit("fallocate");
+
+		do {
+			rc = pread(nodax_fd, dax_data + read, FILE_SIZE - read,
+					read);
+			if (rc > 0)
+				read += rc;
+		} while (rc > 0);
+
+		/*
+		 * For this test we ignore errors from pread().  These errors
+		 * can happen if we try and read while the other thread has
+		 * made the file size 0.
+		 */
+
+		usleep(rand() % 1000);
+	}
+}
+
+void collapse_range_fn(void *ptr)
+{
+	ssize_t read;
+	int rc;
+
+	while (!done) {
+		read = 0;
+
+		if (fallocate(dax_fd, 0, 0, FILE_SIZE) < 0)
+			err_exit("fallocate 1");
+		if (fallocate(dax_fd, FALLOC_FL_COLLAPSE_RANGE, 0, PAGE(1)) < 0)
+			err_exit("fallocate 2");
+		if (fallocate(dax_fd, 0, 0, FILE_SIZE) < 0)
+			err_exit("fallocate 3");
+
+		do {
+			rc = pread(nodax_fd, dax_data + read, FILE_SIZE - read,
+					read);
+			if (rc > 0)
+				read += rc;
+		} while (rc > 0);
+
+		/* For this test we ignore errors from pread. */
+
+		usleep(rand() % 1000);
+	}
+}
+
+void run_test(void (*test_fn)(void *))
+{
+	const int NUM_THREADS = 2;
+	pthread_t worker_thread[NUM_THREADS];
+	int i;
+
+	done = 0;
+	for (i = 0; i < NUM_THREADS; i++)
+		pthread_create(&worker_thread[i], NULL, (void*)test_fn, NULL);
+
+	sleep(1);
+	done = 1;
+
+	for (i = 0; i < NUM_THREADS; i++)
+		pthread_join(worker_thread[i], NULL);
+}
+
+int main(int argc, char *argv[])
+{
+	int err;
+
+	if (argc != 3) {
+		printf("Usage: %s <dax file> <non-dax file>\n",
+				basename(argv[0]));
+		exit(0);
+	}
+
+	dax_fd = open(argv[1], O_RDWR|O_CREAT, S_IRUSR|S_IWUSR);
+	if (dax_fd < 0)
+		err_exit("dax_fd open");
+
+	nodax_fd = open(argv[2], O_RDWR|O_CREAT|O_DIRECT, S_IRUSR|S_IWUSR);
+	if (nodax_fd < 0)
+		err_exit("nodax_fd open");
+
+	if (ftruncate(dax_fd, 0) < 0)
+		err_exit("dax_fd ftruncate");
+	if (fallocate(dax_fd, 0, 0, FILE_SIZE) < 0)
+		err_exit("dax_fd fallocate");
+
+	if (ftruncate(nodax_fd, 0) < 0)
+		err_exit("nodax_fd ftruncate");
+	if (fallocate(nodax_fd, 0, 0, FILE_SIZE) < 0)
+		err_exit("nodax_fd fallocate");
+
+	dax_data = mmap(NULL, FILE_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED,
+			dax_fd, 0);
+	if (dax_data == MAP_FAILED)
+		err_exit("mmap");
+
+	run_test(&punch_hole_fn);
+	run_test(&zero_range_fn);
+	run_test(&truncate_down_fn);
+	run_test(&collapse_range_fn);
+
+	if (munmap(dax_data, FILE_SIZE) != 0)
+		err_exit("munmap");
+
+	err = close(dax_fd);
+	if (err < 0)
+		err_exit("dax_fd close");
+
+	err = close(nodax_fd);
+	if (err < 0)
+		err_exit("nodax_fd close");
+
+	return 0;
+}
diff --git a/tests/generic/999 b/tests/generic/999
new file mode 100755
index 00000000..8f488cb5
--- /dev/null
+++ b/tests/generic/999
@@ -0,0 +1,50 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Intel Corporation.  All Rights Reserved.
+#
+# FS QA Test generic/999
+#
+# This is a regression test for kernel patch:
+#   ext4: handle layout changes to pinned DAX mapping
+# created by Ross Zwisler <ross.zwisler@linux.intel.com>
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_test
+_require_test_program "t_mmap_collision"
+
+# turn off DAX on our scratch device so we can get normal O_DIRECT behavior
+export MOUNT_OPTIONS=""
+_scratch_unmount >> $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+# real QA test starts here
+$here/src/t_mmap_collision $TEST_DIR/testfile $SCRATCH_MNT/testfile
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/generic/999.out b/tests/generic/999.out
new file mode 100644
index 00000000..3b276ca8
--- /dev/null
+++ b/tests/generic/999.out
@@ -0,0 +1,2 @@
+QA output created by 999
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 83a6fdab..793f71ed 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -501,3 +501,4 @@
 496 auto quick swap
 497 auto quick swap collapse
 498 auto quick log
+999 auto quick dax
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
