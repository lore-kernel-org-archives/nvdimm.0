Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 8F3621A1E84
 for <linux-nvdimm@lists.01.org>; Thu, 24 Mar 2016 16:19:18 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] test: Add a unit test for dax error handling
Date: Thu, 24 Mar 2016 17:18:40 -0600
Message-Id: <1458861520-17992-1-git-send-email-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

When we have a namespace with media errors, DAX should fail when trying
to map the bad blocks for direct access, but a regular write() to the
same sector should go through the driver and clear the error.
This test checks for all of the above happening - failure for a read()
on a file with a bad block, failure on an mmap-read for the same, and
finally a successful write that clears the bad block.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Makefile.am        |   5 +-
 test/dax-errors.c  | 139 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 test/dax-errors.sh | 118 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 260 insertions(+), 2 deletions(-)
 create mode 100644 test/dax-errors.c
 create mode 100755 test/dax-errors.sh

diff --git a/Makefile.am b/Makefile.am
index 8458277..e9231b8 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -144,8 +144,8 @@ EXTRA_DIST += lib/libndctl.pc.in
 CLEANFILES += lib/libndctl.pc
 
 TESTS = test/libndctl test/dpa-alloc test/parent-uuid test/create.sh \
-	test/clear.sh
-check_PROGRAMS = test/libndctl test/dpa-alloc test/parent-uuid
+	test/clear.sh test/dax-errors.sh
+check_PROGRAMS = test/libndctl test/dpa-alloc test/parent-uuid test/dax-errors
 
 if ENABLE_DESTRUCTIVE
 TESTS += test/blk-ns test/pmem-ns test/pcommit
@@ -178,3 +178,4 @@ test_dax_dev_LDADD = lib/libndctl.la
 
 test_dax_pmd_SOURCES = test/dax-pmd.c
 test_mmap_SOURCES = test/mmap.c
+test_dax_err_SOURCES = test/dax-errors.c
diff --git a/test/dax-errors.c b/test/dax-errors.c
new file mode 100644
index 0000000..4e9bb04
--- /dev/null
+++ b/test/dax-errors.c
@@ -0,0 +1,139 @@
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
+#include <setjmp.h>
+
+#define fail() fprintf(stderr, "%s: failed at: %d\n", __func__, __LINE__)
+
+static sigjmp_buf sj_env;
+static int sig_count;
+
+static void sigbus_hdl(int sig, siginfo_t *siginfo, void *ptr)
+{
+	fprintf(stderr, "** Received a SIGBUS **\n");
+	sig_count++;
+	siglongjmp(sj_env, 1);
+}
+
+static int test_dax_read_err(int fd)
+{
+	void *base, *buf;
+	int rc = 0;
+
+	if (fd < 0) {
+		fail();
+		return -ENXIO;
+	}
+
+	if (posix_memalign(&buf, 4096, 4096) != 0)
+		return -ENOMEM;
+
+	base = mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
+	if (base == MAP_FAILED) {
+		perror("mmap");
+		rc = -ENXIO;
+		goto err_mmap;
+	}
+
+	if (sigsetjmp(sj_env, 1)) {
+		if (sig_count == 1) {
+			fprintf(stderr, "Failed to read from mapped file\n");
+			free(buf);
+			if (base) {
+				if (munmap(base, 4096) < 0) {
+					fail();
+					return 1;
+				}
+			}
+			return 1;
+		}
+		return sig_count;
+	}
+
+	/* read a page through DAX (should fail due to a bad block) */
+	memcpy(buf, base, 4096);
+
+ err_mmap:
+	free(buf);
+	return rc;
+}
+
+static int test_dax_write_clear(int fd)
+{
+	void *buf;
+	int rc = 0;
+
+	if (fd < 0) {
+		fail();
+		return -ENXIO;
+	}
+
+	if (posix_memalign(&buf, 4096, 4096) != 0)
+		return -ENOMEM;
+	memset(buf, 0, 4096);
+
+	/*
+	 * Attempt to write zeroes to the first page of the file using write()
+	 * This should clear the pmem errors/bad blocks
+	 */
+	printf("Attempting to write\n");
+	if (write(fd, buf, 4096) < 0)
+		rc = errno;
+
+	free(buf);
+	return rc;
+}
+
+int main(int argc, char *argv[])
+{
+	int fd, rc;
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
+	fd = open(argv[1], O_RDWR | O_DIRECT);
+
+	/* Start the test. First, we do an mmap-read, and expect it to fail */
+	rc = test_dax_read_err(fd);
+	if (rc == 0) {
+		fprintf(stderr, "Expected read to fail, but it succeeded\n");
+		rc = -ENXIO;
+		goto out;
+	}
+	if (rc > 1) {
+		fprintf(stderr, "Received a second SIGBUS, exiting.\n");
+		rc = -ENXIO;
+		goto out;
+	}
+	printf("  mmap-read failed as expected\n");
+
+	/* Next, do a regular (O_DIRECT) write() */
+	rc = test_dax_write_clear(fd);
+	if (rc)
+		perror("write");
+
+ out:
+	if (fd >= 0)
+		close(fd);
+	return rc;
+}
diff --git a/test/dax-errors.sh b/test/dax-errors.sh
new file mode 100755
index 0000000..72f8771
--- /dev/null
+++ b/test/dax-errors.sh
@@ -0,0 +1,118 @@
+#!/bin/bash -x
+
+DEV=""
+NDCTL="./ndctl"
+BUS="-b nfit_test.0"
+BUS1="-b nfit_test.1"
+MNT=test_dax_mnt
+FILE=image
+json2var="s/[{}\",]//g; s/:/=/g"
+rc=77
+
+err() {
+	rc=1
+	echo "test/dax-errors: failed at line $1"
+	rm -f $FILE
+	rm -f $MNT/$FILE
+	if [ -n "$blockdev" ]; then
+		umount /dev/$blockdev
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
+# setup (reset nfit_test dimms)
+modprobe nfit_test
+$NDCTL disable-region $BUS all
+$NDCTL zero-labels $BUS all
+$NDCTL enable-region $BUS all
+
+rc=1
+
+# create pmem
+dev="x"
+json=$($NDCTL create-namespace $BUS -t pmem -m raw)
+eval $(echo $json | sed -e "$json2var")
+[ $dev = "x" ] && echo "fail: $LINENO" && exit 1
+[ $mode != "raw" ] && echo "fail: $LINENO" && exit 1
+
+# check for expected errors in the middle of the namespace
+read sector len < /sys/block/$blockdev/badblocks
+[ $((sector * 2)) -ne $((size /512)) ] && echo "fail: $LINENO" && exit 1
+if dd if=/dev/$blockdev of=/dev/null iflag=direct bs=512 skip=$sector count=$len; then
+	echo "fail: $LINENO" && exit 1
+fi
+
+size_raw=$size
+sector_raw=$sector
+
+# convert pmem to memory mode
+json=$($NDCTL create-namespace -m memory -f -e $dev)
+eval $(echo $json | sed -e "$json2var")
+[ $mode != "memory" ] && echo "fail: $LINENO" && exit 1
+
+# check for errors relative to the offset injected by the pfn device
+read sector len < /sys/block/$blockdev/badblocks
+[ $((sector_raw - sector)) -ne $(((size_raw - size) / 512)) ] && echo "fail: $LINENO" && exit 1
+
+# check that writing clears the errors
+if ! dd of=/dev/$blockdev if=/dev/zero oflag=direct bs=512 seek=$sector count=$len; then
+	echo "fail: $LINENO" && exit 1
+fi
+
+if read sector len < /sys/block/$blockdev/badblocks; then
+	# fail if reading badblocks returns data
+	echo "fail: $LINENO" && exit 1
+fi
+
+#mkfs.xfs /dev/$blockdev -b size=4096 -f
+mkfs.ext4 /dev/$blockdev -b 4096
+mount /dev/$blockdev $MNT -o dax
+
+# prepare an image file with random data
+dd if=/dev/urandom of=$FILE bs=4096 count=4
+test -s $FILE
+
+# copy it to the dax file system
+cp $FILE $MNT/$FILE
+
+# Get the start sector for the file
+start_sect=$(filefrag -v -b512 $MNT/$FILE | grep -E "^[ ]+[0-9]+.*" | head -1 | awk '{ print $4 }' | cut -d. -f1)
+test -n "$start_sect"
+echo "start sector of the file is $start_sect"
+
+# inject badblocks for one page at the start of the file
+echo $start_sect 8 > /sys/block/$blockdev/badblocks
+
+# make sure reading the first block of the file fails as expected
+: The following 'dd' is expected to hit an I/O Error
+dd if=$MNT/$FILE of=/dev/null iflag=direct bs=4096 count=1 && err $LINENO || true
+
+# run the dax-errors test
+test -x test/dax-errors
+test/dax-errors $MNT/$FILE
+
+if read sector len < /sys/block/$blockdev/badblocks; then
+	# fail if reading badblocks returns data
+	echo "fail: $LINENO" && exit 1
+fi
+
+# cleanup
+rm -f $FILE
+rm -f $MNT/$FILE
+if [ -n "$blockdev" ]; then
+	umount /dev/$blockdev
+fi
+rmdir $MNT
+
+$NDCTL disable-region $BUS all
+$NDCTL disable-region $BUS1 all
+modprobe -r nfit_test
+
+exit 0
-- 
2.5.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
