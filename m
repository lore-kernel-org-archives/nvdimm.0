Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 877781A1E05
 for <linux-nvdimm@lists.01.org>; Sun, 26 Jun 2016 16:26:26 -0700 (PDT)
Subject: [ndctl PATCH 8/9] test,
 libndctl: move pfn + dax configurations to a destructive test
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 26 Jun 2016 16:25:10 -0700
Message-ID: <146698351008.40541.11263210132538068607.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146698346627.40541.14661847967712551305.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146698346627.40541.14661847967712551305.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The kernel is converting nfit_test resources to vmalloc() instead of
DMA_CMA.  DMA_CMA collides with other common options enabled in
distribution kernels which makes nfit_test unusable without intrusive
kernel configuration changes.  The vmalloc conversion precludes higher
than PAGE_SIZE alignment configurations for pfn + dax devices.  Instead,
move these tests to run against an memmap=ss!nn range.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/Makefile.am   |    3 ++
 test/dax-dev.c     |   22 +++++++++----
 test/dax.sh        |    5 ++-
 test/device-dax.c  |   32 ++++++++++++++++++
 test/device-dax.sh |   30 +++++++++++++++++
 test/libndctl.c    |   91 +++++++++++++++++++++-------------------------------
 test/mmap.sh       |    7 +++-
 7 files changed, 125 insertions(+), 65 deletions(-)
 create mode 100644 test/device-dax.c
 create mode 100755 test/device-dax.sh

diff --git a/test/Makefile.am b/test/Makefile.am
index ed9981583331..ab566148e1f4 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -20,6 +20,7 @@ TESTS +=\
 	pmem-ns \
 	dax-dev \
 	dax.sh \
+	device-dax.sh \
 	mmap.sh
 
 check_PROGRAMS +=\
@@ -27,6 +28,7 @@ check_PROGRAMS +=\
 	pmem-ns \
 	dax-dev \
 	dax-pmd \
+	device-dax \
 	mmap
 endif
 
@@ -55,3 +57,4 @@ dax_dev_LDADD = $(LIBNDCTL_LIB)
 dax_pmd_SOURCES = dax-pmd.c
 mmap_SOURCES = mmap.c
 dax_errors_SOURCES = dax-errors.c
+device_dax_SOURCES = device-dax.c
diff --git a/test/dax-dev.c b/test/dax-dev.c
index 3209eb148ed9..519df324fdc8 100755
--- a/test/dax-dev.c
+++ b/test/dax-dev.c
@@ -32,6 +32,7 @@ static int emit_e820_device(int loglevel, struct ndctl_test *test)
 	const char *bdev;
 	struct ndctl_ctx *ctx;
 	struct ndctl_bus *bus;
+	struct ndctl_dax *dax;
 	struct ndctl_pfn *pfn;
 	struct ndctl_region *region;
 	struct ndctl_namespace *ndns;
@@ -62,11 +63,14 @@ static int emit_e820_device(int loglevel, struct ndctl_test *test)
 	if (mode >= 0 && mode != NDCTL_NS_MODE_MEMORY)
 		goto out;
 
+	/* if device-dax mode already established it might contain user data */
 	pfn = ndctl_namespace_get_pfn(ndns);
-	if (pfn)
-		bdev = ndctl_pfn_get_block_device(pfn);
-	else
-		bdev = ndctl_namespace_get_block_device(ndns);
+	dax = ndctl_namespace_get_dax(ndns);
+	if (dax || pfn)
+		goto out;
+
+	/* device is unconfigured, assume that was on purpose */
+	bdev = ndctl_namespace_get_block_device(ndns);
 	if (!bdev)
 		goto out;
 
@@ -75,18 +79,22 @@ static int emit_e820_device(int loglevel, struct ndctl_test *test)
 
 	/*
 	 * Note, if the bdev goes active after this check we'll still
-	 * clobber it in the following tests, see test/dax.sh.
+	 * clobber it in the following tests, see test/dax.sh and
+	 * test/device-dax.sh.
 	 */
 	fd = open(path, O_RDWR | O_EXCL);
 	if (fd < 0)
 		goto out;
 	err = 0;
-	fprintf(stdout, "%s\n", path);
 
  out:
-	if (err)
+	if (err) {
 		fprintf(stderr, "%s: failed to find usable victim device\n",
 				__func__);
+		ndctl_test_skip(test);
+		err = 77;
+	} else
+		fprintf(stdout, "%s\n", ndctl_namespace_get_devname(ndns));
 	ndctl_unref(ctx);
 	return err;
 }
diff --git a/test/dax.sh b/test/dax.sh
index 8db436a869b5..ae63f89b8e6b 100755
--- a/test/dax.sh
+++ b/test/dax.sh
@@ -21,8 +21,9 @@ set -e
 mkdir -p $MNT
 trap 'err $LINENO' ERR
 
-blockdev=$(basename $(./dax-dev))
-dev=$(basename $(readlink -f /sys/block/$(basename $blockdev)/device))
+dev=$(./dax-dev)
+json=$($NDCTL list -N -n $dev)
+eval $(echo $json | sed -e "$json2var")
 
 mkfs.ext4 /dev/$blockdev
 mount /dev/$blockdev $MNT -o dax
diff --git a/test/device-dax.c b/test/device-dax.c
new file mode 100644
index 000000000000..addf93f59252
--- /dev/null
+++ b/test/device-dax.c
@@ -0,0 +1,32 @@
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <linux/falloc.h>
+#include <stdio.h>
+#include <string.h>
+#include <errno.h>
+#include <unistd.h>
+
+int main(int argc, char *argv[])
+{
+	char *buf;
+	int fd;
+
+	if (argc < 2) {
+		perror("argc invalid");
+		return -EINVAL;
+	}
+
+	fd = open(argv[1], O_RDWR);
+	if (fd < 0) {
+		perror("fd");
+		return 1;
+	}
+
+	buf = mmap(NULL, 2UL << 20, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
+	*((int *) (buf + (1UL << 20))) = 0;
+
+	close(fd);
+	return 0;
+}
diff --git a/test/device-dax.sh b/test/device-dax.sh
new file mode 100755
index 000000000000..f24a350b2806
--- /dev/null
+++ b/test/device-dax.sh
@@ -0,0 +1,30 @@
+#!/bin/bash
+NDCTL="../ndctl/ndctl"
+json2var="s/[{}\",]//g; s/:/=/g; s/\]//g"
+
+err() {
+	rc=$?
+	echo "device-dax: failed at line $1"
+	exit $rc
+}
+
+set -e -x
+trap 'err $LINENO' ERR
+
+dev=$(./dax-dev)
+json=$($NDCTL list -N -n $dev)
+eval $(echo $json | sed -e "$json2var")
+
+# setup a device-dax configuration
+json=$($NDCTL create-namespace -v -m dax -M dev -f -e $dev)
+eval $(echo $json | sed -e "$json2var")
+[ $mode != "dax" ] && echo "fail: $LINENO" &&  exit 1
+
+./device-dax /dev/$chardev
+
+# revert namespace to raw mode
+json=$($NDCTL create-namespace -v -m raw -f -e $dev)
+eval $(echo $json | sed -e "$json2var")
+[ $mode != "memory" ] && echo "fail: $LINENO" &&  exit 1
+
+exit 0
diff --git a/test/libndctl.c b/test/libndctl.c
index 8346108aacec..947849d7176b 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -223,8 +223,6 @@ static struct pfn pfn_settings = {
 		   8, 9,  10, 11, 12, 13, 14, 15
 	},
 	.locs = { NDCTL_PFN_LOC_RAM, NDCTL_PFN_LOC_PMEM },
-	/* order matters, successful aligns at the end */
-	.aligns = { 1, SZ_1G, SZ_4K, SZ_2M, },
 };
 
 static struct dax dax_settings = {
@@ -233,8 +231,6 @@ static struct dax dax_settings = {
 		   8, 9,  10, 11, 12, 13, 14, 15
 	},
 	.locs = { NDCTL_PFN_LOC_RAM, NDCTL_PFN_LOC_PMEM },
-	/* order matters, successful aligns at the end */
-	.aligns = { 1, SZ_1G, SZ_4K, SZ_2M, },
 };
 
 struct namespace {
@@ -698,7 +694,7 @@ static int validate_dax(struct ndctl_dax *dax)
 
 static int __check_dax_create(struct ndctl_region *region,
 		struct ndctl_namespace *ndns, struct namespace *namespace,
-		enum ndctl_pfn_loc loc, unsigned long align, uuid_t uuid)
+		enum ndctl_pfn_loc loc, uuid_t uuid)
 {
 	struct ndctl_dax *dax_seed = ndctl_region_get_dax_seed(region);
 	enum ndctl_namespace_mode mode;
@@ -711,20 +707,18 @@ static int __check_dax_create(struct ndctl_region *region,
 		return -ENXIO;
 
 	devname = ndctl_dax_get_devname(dax);
-	fprintf(stderr, "%s: %s align: %ld\n", __func__, devname, align);
 	ndctl_dax_set_uuid(dax, uuid);
 	ndctl_dax_set_location(dax, loc);
-	ndctl_dax_set_align(dax, align);
+	/*
+	 * nfit_test uses vmalloc()'d resources so the only feasible
+	 * alignment is PAGE_SIZE
+	 */
+	ndctl_dax_set_align(dax, SZ_4K);
 	ndctl_dax_set_namespace(dax, ndns);
 	rc = ndctl_dax_enable(dax);
-	if (align == SZ_1G) {
-		if (rc == 0) {
-			fprintf(stderr, "%s: expected dax enable failure with align: %lx\n",
-					devname, align);
-			return -ENXIO;
-		}
-		ndctl_dax_delete(dax);
-		return 0;
+	if (rc) {
+		fprintf(stderr, "%s: failed to enable dax\n", devname);
+		return rc;
 	}
 
 	mode = ndctl_namespace_get_mode(ndns);
@@ -777,28 +771,22 @@ static int check_dax_create(struct ndctl_region *region,
 		struct ndctl_namespace *ndns, struct namespace *namespace)
 {
 	struct dax *dax_s = namespace->dax_settings;
-	unsigned int i, j;
 	void *buf = NULL;
+	unsigned int i;
 	int rc = 0;
 
 	if (!dax_s)
 		return 0;
 
 	for (i = 0; i < ARRAY_SIZE(dax_s->locs); i++) {
-		fprintf(stderr, "%s: %ld\n", __func__, ARRAY_SIZE(dax_s->aligns));
-		for (j = 0; j < ARRAY_SIZE(dax_s->aligns); j++) {
-			/*
-			 * The kernel enforces invalidating the previous
-			 * info block when the current uuid is does not
-			 * validate with the contents of the info block.
-			 */
-			dax_s->uuid[0]++;
-			rc = __check_dax_create(region, ndns, namespace,
-					dax_s->locs[i], dax_s->aligns[j],
-					dax_s->uuid);
-			if (rc)
-				break;
-		}
+		/*
+		 * The kernel enforces invalidating the previous info
+		 * block when the current uuid is does not validate with
+		 * the contents of the info block.
+		 */
+		dax_s->uuid[0]++;
+		rc = __check_dax_create(region, ndns, namespace,
+				dax_s->locs[i], dax_s->uuid);
 		if (rc)
 			break;
 	}
@@ -808,8 +796,7 @@ static int check_dax_create(struct ndctl_region *region,
 
 static int __check_pfn_create(struct ndctl_region *region,
 		struct ndctl_namespace *ndns, struct namespace *namespace,
-		void *buf, enum ndctl_pfn_loc loc, unsigned long align,
-		uuid_t uuid)
+		void *buf, enum ndctl_pfn_loc loc, uuid_t uuid)
 {
 	struct ndctl_pfn *pfn_seed = ndctl_region_get_pfn_seed(region);
 	enum ndctl_namespace_mode mode;
@@ -826,17 +813,16 @@ static int __check_pfn_create(struct ndctl_region *region,
 	devname = ndctl_pfn_get_devname(pfn);
 	ndctl_pfn_set_uuid(pfn, uuid);
 	ndctl_pfn_set_location(pfn, loc);
-	ndctl_pfn_set_align(pfn, align);
+	/*
+	 * nfit_test uses vmalloc()'d resources so the only feasible
+	 * alignment is PAGE_SIZE
+	 */
+	ndctl_pfn_set_align(pfn, SZ_4K);
 	ndctl_pfn_set_namespace(pfn, ndns);
 	rc = ndctl_pfn_enable(pfn);
-	if (align == SZ_1G) {
-		if (rc == 0) {
-			fprintf(stderr, "%s: expected pfn enable failure with align: %lx\n",
-					devname, align);
-			return -ENXIO;
-		}
-		ndctl_pfn_delete(pfn);
-		return 0;
+	if (rc) {
+		fprintf(stderr, "%s: failed to enable pfn\n", devname);
+		return rc;
 	}
 
 	mode = ndctl_namespace_get_mode(ndns);
@@ -917,8 +903,8 @@ static int check_pfn_create(struct ndctl_region *region,
 		struct ndctl_namespace *ndns, struct namespace *namespace)
 {
 	struct pfn *pfn_s = namespace->pfn_settings;
-	unsigned int i, j;
 	void *buf = NULL;
+	unsigned int i;
 	int rc = 0;
 
 	if (!pfn_s)
@@ -928,19 +914,14 @@ static int check_pfn_create(struct ndctl_region *region,
 		return -ENXIO;
 
 	for (i = 0; i < ARRAY_SIZE(pfn_s->locs); i++) {
-		for (j = 0; j < ARRAY_SIZE(pfn_s->aligns); j++) {
-			/*
-			 * The kernel enforces invalidating the previous
-			 * info block when the current uuid is does not
-			 * validate with the contents of the info block.
-			 */
-			pfn_s->uuid[0]++;
-			rc = __check_pfn_create(region, ndns, namespace, buf,
-					pfn_s->locs[i], pfn_s->aligns[j],
-					pfn_s->uuid);
-			if (rc)
-				break;
-		}
+		/*
+		 * The kernel enforces invalidating the previous info
+		 * block when the current uuid is does not validate with
+		 * the contents of the info block.
+		 */
+		pfn_s->uuid[0]++;
+		rc = __check_pfn_create(region, ndns, namespace, buf,
+				pfn_s->locs[i], pfn_s->uuid);
 		if (rc)
 			break;
 	}
diff --git a/test/mmap.sh b/test/mmap.sh
index e66fb1369434..fa2658a6c57c 100755
--- a/test/mmap.sh
+++ b/test/mmap.sh
@@ -3,6 +3,8 @@ MNT=test_mmap_mnt
 FILE=image
 DEV=""
 TEST=./mmap
+NDCTL="../ndctl/ndctl"
+json2var="s/[{}\",]//g; s/:/=/g"
 
 err() {
 	rc=1
@@ -46,7 +48,10 @@ set -e
 mkdir -p $MNT
 trap 'err $LINENO' ERR
 
-DEV=$(./dax-dev)
+dev=$(./dax-dev)
+json=$($NDCTL list -N -n $dev)
+eval $(echo $json | sed -e "$json2var")
+DEV="/dev/${blockdev}"
 
 mkfs.ext4 $DEV
 mount $DEV $MNT -o dax

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
