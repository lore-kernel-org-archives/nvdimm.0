Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 52E8C1A1DF4
 for <linux-nvdimm@lists.01.org>; Wed, 16 Mar 2016 17:55:31 -0700 (PDT)
Subject: [ndctl PATCH 3/5] Revert "ndctl: fix error handling in ND_BLK &
 PMEM tests"
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 16 Mar 2016 17:54:45 -0700
Message-ID: <20160317005445.3025.6166.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160317005429.3025.395.stgit@dwillia2-desk3.jf.intel.com>
References: <20160317005429.3025.395.stgit@dwillia2-desk3.jf.intel.com>
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

This reverts commit 289f98097a25abd71fac7d8324e89abb4abfb19d.

For pass/fail we only care about these routines returning non-zero.  The
current opportunistic conversion of negative libndctl return values runs
the risk of a -EBADFD causing a false positive "skip test" indication.
It also makes these tests follow the same error reporting scheme as the
other tests.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/blk_namespaces.c  |   77 +++++++++++++++++++++++++-----------------------
 test/pmem_namespaces.c |   46 +++++++++++++++--------------
 2 files changed, 64 insertions(+), 59 deletions(-)

diff --git a/test/blk_namespaces.c b/test/blk_namespaces.c
index 41c5ce0b1bd7..f3e7a5592e2a 100644
--- a/test/blk_namespaces.c
+++ b/test/blk_namespaces.c
@@ -82,21 +82,22 @@ static struct ndctl_namespace *create_blk_namespace(int region_fraction,
 static int disable_blk_namespace(struct ndctl_namespace *ndns)
 {
 	if (ndctl_namespace_disable_invalidate(ndns) < 0)
-		return ENODEV;
+		return -ENODEV;
 
 	if (ndctl_namespace_delete(ndns) < 0)
-		return ENODEV;
+		return -ENODEV;
 
 	return 0;
 }
 
 static int ns_do_io(const char *bdev)
 {
+	int fd, i;
+	int rc = 0;
 	const int page_size = 4096;
 	const int num_pages = 4;
 	unsigned long num_dev_pages, num_blocks;
 	off_t addr;
-	int fd, i, rc;
 
 	void *random_page[num_pages];
 	void *blk_page[num_pages];
@@ -120,13 +121,13 @@ static int ns_do_io(const char *bdev)
 
 	/* read random data into random_page */
 	if ((fd = open("/dev/urandom", O_RDONLY)) < 0) {
-		rc = errno;
 		err("open");
+		rc = -ENODEV;
 		goto err_free_all;
 	}
 
-	if (read(fd, random_page[0], page_size * num_pages) < 0) {
-		rc = errno;
+	rc = read(fd, random_page[0], page_size * num_pages);
+	if (rc < 0) {
 		err("read");
 		close(fd);
 		goto err_free_all;
@@ -134,10 +135,9 @@ static int ns_do_io(const char *bdev)
 
 	close(fd);
 
-	/* figure out our dev size */
 	if ((fd = open(bdev, O_RDWR|O_DIRECT)) < 0) {
-		rc = errno;
 		err("open");
+		rc = -ENODEV;
 		goto err_free_all;
 	}
 
@@ -145,48 +145,45 @@ static int ns_do_io(const char *bdev)
 	num_dev_pages = num_blocks / 8;
 
 	/* write the random data out to each of the segments */
-	if (pwrite(fd, random_page[0], page_size, 0) < 0) {
-		rc = errno;
+	rc = pwrite(fd, random_page[0], page_size, 0);
+	if (rc < 0) {
 		err("write");
 		goto err_close;
 	}
 
 	/* two pages that span the region discontinuity */
 	addr = page_size * (num_dev_pages/2 - 1);
-
-	if (pwrite(fd, random_page[1], page_size*2, addr) < 0) {
-		rc = errno;
+	rc = pwrite(fd, random_page[1], page_size*2, addr);
+	if (rc < 0) {
 		err("write");
 		goto err_close;
 	}
 
 	addr = page_size * (num_dev_pages - 1);
-
-	if (pwrite(fd, random_page[3], page_size, addr) < 0) {
-		rc = errno;
+	rc = pwrite(fd, random_page[3], page_size, addr);
+	if (rc < 0) {
 		err("write");
 		goto err_close;
 	}
 
 	/* read back the random data into blk_page */
-	if (pread(fd, blk_page[0], page_size, 0) < 0) {
-		rc = errno;
+	rc = pread(fd, blk_page[0], page_size, 0);
+	if (rc < 0) {
 		err("read");
 		goto err_close;
 	}
 
 	/* two pages that span the region discontinuity */
 	addr = page_size * (num_dev_pages/2 - 1);
-	if (pread(fd, blk_page[1], page_size*2, addr) < 0) {
-		rc = errno;
+	rc = pread(fd, blk_page[1], page_size*2, addr);
+	if (rc < 0) {
 		err("read");
 		goto err_close;
 	}
 
 	addr = page_size * (num_dev_pages - 1);
-
-	if (pread(fd, blk_page[3], page_size, addr) < 0) {
-		rc = errno;
+	rc = pread(fd, blk_page[3], page_size, addr);
+	if (rc < 0) {
 		err("read");
 		goto err_close;
 	}
@@ -194,9 +191,11 @@ static int ns_do_io(const char *bdev)
 	/* verify the data */
 	if (memcmp(random_page[0], blk_page[0], page_size * num_pages)) {
 		fprintf(stderr, "Block data miscompare\n");
-		rc = EIO;
+		rc = -EIO;
+		goto err_close;
 	}
 
+	rc = 0;
  err_close:
 	close(fd);
  err_free_all:
@@ -218,8 +217,8 @@ int test_blk_namespaces(int log_level)
 	struct ndctl_region *region, *blk_region = NULL;
 	struct ndctl_dimm *dimm;
 
-	rc = -ndctl_new(&ctx);
-	if (rc)
+	rc = ndctl_new(&ctx);
+	if (rc < 0)
 		return rc;
 
 	ndctl_set_log_priority(ctx, log_level);
@@ -229,17 +228,18 @@ int test_blk_namespaces(int log_level)
 		fprintf(stderr, "%s: failed to find NFIT-provider\n", comm);
 		rc = 77;
 		goto err_nobus;
-	} else
+	} else {
 		fprintf(stderr, "%s: found provider: %s\n", comm,
 				ndctl_bus_get_provider(bus));
+	}
 
 	/* get the system to a clean state */
         ndctl_region_foreach(bus, region)
                 ndctl_region_disable_invalidate(region);
 
         ndctl_dimm_foreach(bus, dimm) {
-                rc = -ndctl_dimm_zero_labels(dimm);
-                if (rc) {
+                rc = ndctl_dimm_zero_labels(dimm);
+                if (rc < 0) {
                         fprintf(stderr, "failed to zero %s\n",
                                         ndctl_dimm_get_devname(dimm));
                         return rc;
@@ -253,12 +253,13 @@ int test_blk_namespaces(int log_level)
 			break;
 		}
 
-	rc = ENODEV;
 	if (!blk_region || ndctl_region_enable(blk_region) < 0) {
 		fprintf(stderr, "%s: failed to find block region\n", comm);
+		rc = -ENODEV;
 		goto err_cleanup;
 	}
 
+	rc = -ENODEV;
 	ndns[0] = create_blk_namespace(4, blk_region);
 	if (!ndns[0]) {
 		fprintf(stderr, "%s: failed to create block namespace\n", comm);
@@ -272,7 +273,7 @@ int test_blk_namespaces(int log_level)
 	}
 
 	rc = disable_blk_namespace(ndns[0]);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: failed to disable block namespace\n", comm);
 		goto err_cleanup;
 	}
@@ -280,30 +281,32 @@ int test_blk_namespaces(int log_level)
 	ndns[0] = create_blk_namespace(2, blk_region);
 	if (!ndns[0]) {
 		fprintf(stderr, "%s: failed to create block namespace\n", comm);
-		rc = ENODEV;
+		rc = -ENODEV;
 		goto err_cleanup;
 	}
 
 	rc = disable_blk_namespace(ndns[1]);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: failed to disable block namespace\n", comm);
 		goto err_cleanup;
 	}
 
+	rc = -ENODEV;
 	ndns[1] = create_blk_namespace(2, blk_region);
 	if (!ndns[1]) {
 		fprintf(stderr, "%s: failed to create block namespace\n", comm);
-		rc = ENODEV;
 		goto err_cleanup;
 	}
 
 	/* okay, all set up, do some I/O */
+	rc = -EIO;
 	sprintf(bdev, "/dev/%s", ndctl_namespace_get_block_device(ndns[0]));
-	rc = ns_do_io(bdev);
-	if (rc)
+	if (ns_do_io(bdev))
 		goto err_cleanup;
 	sprintf(bdev, "/dev/%s", ndctl_namespace_get_block_device(ndns[1]));
-	rc = ns_do_io(bdev);
+	if (ns_do_io(bdev))
+		goto err_cleanup;
+	rc = 0;
 
  err_cleanup:
 	if (blk_region) {
diff --git a/test/pmem_namespaces.c b/test/pmem_namespaces.c
index 17c301947fa4..24f307df0c81 100644
--- a/test/pmem_namespaces.c
+++ b/test/pmem_namespaces.c
@@ -60,10 +60,10 @@ static struct ndctl_namespace *create_pmem_namespace(struct ndctl_region *region
 static int disable_pmem_namespace(struct ndctl_namespace *ndns)
 {
 	if (ndctl_namespace_disable_invalidate(ndns) < 0)
-		return ENODEV;
+		return -ENODEV;
 
 	if (ndctl_namespace_delete(ndns) < 0)
-		return ENODEV;
+		return -ENODEV;
 
 	return 0;
 }
@@ -73,8 +73,9 @@ static int ns_do_io(const char *bdev)
 	unsigned long num_dev_pages, num_blocks;
 	const int page_size = 4096;
 	const int num_pages = 2;
-	int fd, i, rc;
 	off_t addr;
+	int rc = 0;
+	int fd, i;
 
 	void *random_page[num_pages];
 	void *pmem_page[num_pages];
@@ -98,13 +99,13 @@ static int ns_do_io(const char *bdev)
 
 	/* read random data into random_page */
 	if ((fd = open("/dev/urandom", O_RDONLY)) < 0) {
-		rc = errno;
 		err("open");
+		rc = -ENODEV;
 		goto err_free_all;
 	}
 
-	if (read(fd, random_page[0], page_size * num_pages) < 0) {
-		rc = errno;
+	rc = read(fd, random_page[0], page_size * num_pages);
+	if (rc < 0) {
 		err("read");
 		close(fd);
 		goto err_free_all;
@@ -114,8 +115,8 @@ static int ns_do_io(const char *bdev)
 
 	/* figure out our dev size */
 	if ((fd = open(bdev, O_RDWR|O_DIRECT)) < 0) {
-		rc = errno;
 		err("open");
+		rc = -ENODEV;
 		goto err_free_all;
 	}
 
@@ -123,29 +124,29 @@ static int ns_do_io(const char *bdev)
 	num_dev_pages = num_blocks / 8;
 
 	/* write the random data out to each of the segments */
-	if (pwrite(fd, random_page[0], page_size, 0) < 0) {
-		rc = errno;
+	rc = pwrite(fd, random_page[0], page_size, 0);
+	if (rc < 0) {
 		err("write");
 		goto err_close;
 	}
 
 	addr = page_size * (num_dev_pages - 1);
-	if (pwrite(fd, random_page[1], page_size, addr) < 0) {
-		rc = errno;
+	rc = pwrite(fd, random_page[1], page_size, addr);
+	if (rc < 0) {
 		err("write");
 		goto err_close;
 	}
 
 	/* read back the random data into pmem_page */
-	if (pread(fd, pmem_page[0], page_size, 0) < 0) {
-		rc = errno;
+	rc = pread(fd, pmem_page[0], page_size, 0);
+	if (rc < 0) {
 		err("read");
 		goto err_close;
 	}
 
 	addr = page_size * (num_dev_pages - 1);
-	if (pread(fd, pmem_page[1], page_size, addr) < 0) {
-		rc = errno;
+	rc = pread(fd, pmem_page[1], page_size, addr);
+	if (rc < 0) {
 		err("read");
 		goto err_close;
 	}
@@ -153,10 +154,11 @@ static int ns_do_io(const char *bdev)
 	/* verify the data */
 	if (memcmp(random_page[0], pmem_page[0], page_size * num_pages)) {
 		fprintf(stderr, "PMEM data miscompare\n");
-		rc = EIO;
+		rc = -EIO;
 		goto err_close;
 	}
 
+	rc = 0;
  err_close:
 	close(fd);
  err_free_all:
@@ -178,8 +180,8 @@ int test_pmem_namespaces(int log_level)
 	char bdev[50];
 	int rc;
 
-	rc = -ndctl_new(&ctx);
-	if (rc)
+	rc = ndctl_new(&ctx);
+	if (rc < 0)
 		return rc;
 
 	ndctl_set_log_priority(ctx, log_level);
@@ -198,8 +200,8 @@ int test_pmem_namespaces(int log_level)
                 ndctl_region_disable_invalidate(region);
 
         ndctl_dimm_foreach(bus, dimm) {
-                rc = -ndctl_dimm_zero_labels(dimm);
-                if (rc) {
+                rc = ndctl_dimm_zero_labels(dimm);
+                if (rc < 0) {
                         fprintf(stderr, "failed to zero %s\n",
                                         ndctl_dimm_get_devname(dimm));
                         return rc;
@@ -215,14 +217,14 @@ int test_pmem_namespaces(int log_level)
 
 	if (!pmem_region || ndctl_region_enable(pmem_region) < 0) {
 		fprintf(stderr, "%s: failed to find PMEM region\n", comm);
-		rc = ENODEV;
+		rc = -ENODEV;
 		goto err;
 	}
 
+	rc = -ENODEV;
 	ndns = create_pmem_namespace(pmem_region);
 	if (!ndns) {
 		fprintf(stderr, "%s: failed to create PMEM namespace\n", comm);
-		rc = ENODEV;
 		goto err;
 	}
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
