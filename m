Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6BC92210D851F
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jun 2018 17:38:03 -0700 (PDT)
Subject: [ndctl PATCH] ndctl, test: Disable poison tests for now
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Jun 2018 17:28:05 -0700
Message-ID: <152902248546.9927.13473307820258257919.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Given that poison injection crashes the kernel, disable the test by
default until 4.19.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test.h            |    8 ++++----
 test/Makefile.am  |    4 +++-
 test/dax-pmd.c    |   14 ++++++++++----
 test/dax-poison.c |    8 ++++++--
 test/dax.sh       |   19 ++++++++++++++-----
 test/device-dax.c |    2 +-
 6 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/test.h b/test.h
index e627785a5334..fa0c0cff9daf 100644
--- a/test.h
+++ b/test.h
@@ -39,11 +39,11 @@ int test_parent_uuid(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ct
 int test_multi_pmem(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 int test_dax_directio(int dax_fd, unsigned long align, void *dax_addr, off_t offset);
 #ifdef ENABLE_POISON
-int test_dax_poison(int dax_fd, unsigned long align, void *dax_addr,
-		off_t offset, bool fsdax);
+int test_dax_poison(struct ndctl_test *test, int dax_fd, unsigned long align,
+		void *dax_addr, off_t offset, bool fsdax);
 #else
-static inline int test_dax_poison(int dax_fd, unsigned long align,
-		void *dax_addr, off_t offset, bool fsdax)
+static inline int test_dax_poison(struct ndctl_test *test, int dax_fd,
+		unsigned long align, void *dax_addr, off_t offset, bool fsdax)
 {
 	return 0;
 }
diff --git a/test/Makefile.am b/test/Makefile.am
index a9b8b3eccbbf..92cf29d6065e 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -94,7 +94,9 @@ parent_uuid_LDADD = $(LIBNDCTL_LIB) $(UUID_LIBS) $(KMOD_LIBS)
 dax_dev_SOURCES = dax-dev.c $(testcore)
 dax_dev_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
 
-dax_pmd_SOURCES = dax-pmd.c
+dax_pmd_SOURCES = dax-pmd.c \
+		$(testcore)
+
 hugetlb_SOURCES = hugetlb.c \
 		  dax-pmd.c
 
diff --git a/test/dax-pmd.c b/test/dax-pmd.c
index 0b4bd98edce4..8ed3e9b764f9 100644
--- a/test/dax-pmd.c
+++ b/test/dax-pmd.c
@@ -194,7 +194,7 @@ int test_dax_directio(int dax_fd, unsigned long align, void *dax_addr, off_t off
 }
 
 /* test_pmd assumes that fd references a pre-allocated + dax-capable file */
-static int test_pmd(int fd)
+static int test_pmd(struct ndctl_test *test, int fd)
 {
 	unsigned long long m_align, p_align, pmd_off;
 	static const bool fsdax = true;
@@ -257,7 +257,7 @@ static int test_pmd(int fd)
 	if (rc)
 		goto err_directio;
 
-	rc = test_dax_poison(fd, HPAGE_SIZE, pmd_addr, pmd_off, fsdax);
+	rc = test_dax_poison(test, fd, HPAGE_SIZE, pmd_addr, pmd_off, fsdax);
 
  err_directio:
  err_extent:
@@ -268,14 +268,20 @@ static int test_pmd(int fd)
 
 int __attribute__((weak)) main(int argc, char *argv[])
 {
+	struct ndctl_test *test = ndctl_test_new(0);
 	int fd, rc;
 
+	if (!test) {
+		fprintf(stderr, "failed to initialize test\n");
+		return EXIT_FAILURE;
+	}
+
 	if (argc < 1)
 		return -EINVAL;
 
 	fd = open(argv[1], O_RDWR);
-	rc = test_pmd(fd);
+	rc = test_pmd(test, fd);
 	if (fd >= 0)
 		close(fd);
-	return rc;
+	return ndctl_test_result(test, rc);
 }
diff --git a/test/dax-poison.c b/test/dax-poison.c
index 7faa402e623c..a25bf0b17d61 100644
--- a/test/dax-poison.c
+++ b/test/dax-poison.c
@@ -15,6 +15,7 @@
 #include <test.h>
 #include <util/size.h>
 #include <stdbool.h>
+#include <linux/version.h>
 
 #define fail() fprintf(stderr, "%s: failed at: %d (%s)\n", \
 	__func__, __LINE__, strerror(errno))
@@ -43,8 +44,8 @@ static void sigbus_hdl(int sig, siginfo_t *si, void *ptr)
 	siglongjmp(sj_env, 1);
 }
 
-int test_dax_poison(int dax_fd, unsigned long align, void *dax_addr,
-		off_t offset, bool fsdax)
+int test_dax_poison(struct ndctl_test *test, int dax_fd, unsigned long align,
+		void *dax_addr, off_t offset, bool fsdax)
 {
 	unsigned char *addr = MAP_FAILED;
 	struct sigaction act;
@@ -52,6 +53,9 @@ int test_dax_poison(int dax_fd, unsigned long align, void *dax_addr,
 	void *buf;
 	int rc;
 
+	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 19, 0)))
+		return 77;
+
 	/*
 	 * MADV_HWPOISON must be page aligned, and this routine assumes
 	 * align is >= 8K
diff --git a/test/dax.sh b/test/dax.sh
index e35f914a6425..30fe16721935 100755
--- a/test/dax.sh
+++ b/test/dax.sh
@@ -28,6 +28,15 @@ err() {
 	exit $rc
 }
 
+run_test() {
+	if ! ./dax-pmd $MNT/$FILE; then
+		rc=$?
+		if [ $rc -ne 77 -a $rc -ne 0 ]; then
+			err
+		fi
+	fi
+}
+
 set -e
 mkdir -p $MNT
 trap 'err $LINENO' ERR
@@ -40,7 +49,7 @@ rc=1
 mkfs.ext4 /dev/$blockdev
 mount /dev/$blockdev $MNT -o dax
 fallocate -l 1GiB $MNT/$FILE
-./dax-pmd $MNT/$FILE
+run_test
 umount $MNT
 
 # convert pmem to put the memmap on the device
@@ -52,7 +61,7 @@ eval $(echo $json | sed -e "$json2var")
 mkfs.ext4 /dev/$blockdev
 mount /dev/$blockdev $MNT -o dax
 fallocate -l 1GiB $MNT/$FILE
-./dax-pmd $MNT/$FILE
+run_test
 umount $MNT
 
 json=$($NDCTL create-namespace -m raw -f -e $dev)
@@ -62,7 +71,7 @@ eval $(echo $json | sed -e "$json2var")
 mkfs.xfs -f /dev/$blockdev
 mount /dev/$blockdev $MNT -o dax
 fallocate -l 1GiB $MNT/$FILE
-./dax-pmd $MNT/$FILE
+run_test
 umount $MNT
 
 # convert pmem to put the memmap on the device
@@ -73,7 +82,7 @@ eval $(echo $json | sed -e "$json2var")
 mkfs.xfs -f /dev/$blockdev
 mount /dev/$blockdev $MNT -o dax
 fallocate -l 1GiB $MNT/$FILE
-./dax-pmd $MNT/$FILE
+run_test
 umount $MNT
 
 # revert namespace to raw mode
@@ -81,4 +90,4 @@ json=$($NDCTL create-namespace -m raw -f -e $dev)
 eval $(echo $json | sed -e "$json2var")
 [ $mode != "fsdax" ] && echo "fail: $LINENO" &&  exit 1
 
-exit 0
+exit $rc
diff --git a/test/device-dax.c b/test/device-dax.c
index 712c247adfb2..dd92f9a9d2c5 100644
--- a/test/device-dax.c
+++ b/test/device-dax.c
@@ -279,7 +279,7 @@ static int __test_device_dax(unsigned long align, int loglevel,
 
 		fprintf(stderr, "%s: test dax poison\n",
 				ndctl_namespace_get_devname(ndns));
-		rc = test_dax_poison(fd, align, NULL, 0, devdax);
+		rc = test_dax_poison(test, fd, align, NULL, 0, devdax);
 		if (rc) {
 			fprintf(stderr, "%s: failed dax poison\n",
 					ndctl_namespace_get_devname(ndns));

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
