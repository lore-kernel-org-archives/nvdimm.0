Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 617E71A1E24
 for <linux-nvdimm@lists.01.org>; Fri,  9 Sep 2016 18:44:46 -0700 (PDT)
Subject: [ndctl PATCH 3/3] test, device-dax: address translation
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 09 Sep 2016 18:41:42 -0700
Message-ID: <147347170289.15190.16543786024420919307.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147347168712.15190.17312702584906386275.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147347168712.15190.17312702584906386275.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Validate that data written through /dev/pmemX is retrievable intact
through /dev/daxX.  This tests that pmem and device-dax have the same
device-to-physical address translation.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/device-dax.c |  139 +++++++++++++++++++++++++++++++++++++++++++++++------
 util/size.h       |    1 
 2 files changed, 125 insertions(+), 15 deletions(-)

diff --git a/test/device-dax.c b/test/device-dax.c
index c1409ac8b8b8..82154d5c1fff 100644
--- a/test/device-dax.c
+++ b/test/device-dax.c
@@ -9,7 +9,9 @@
 #include <setjmp.h>
 #include <sys/stat.h>
 #include <sys/mman.h>
+#include <sys/time.h>
 #include <sys/types.h>
+#include <util/size.h>
 #include <linux/falloc.h>
 #include <linux/version.h>
 #include <ndctl/libndctl.h>
@@ -51,21 +53,79 @@ static int setup_device_dax(struct ndctl_namespace *ndns)
 	return create_namespace(argc, argv, ctx);
 }
 
+static int setup_pmem_memory_mode(struct ndctl_namespace *ndns)
+{
+	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
+	const char *argv[] = {
+		"__func__", "-v", "-m", "memory", "-M", "dev", "-f", "-e", "",
+	};
+	int argc = ARRAY_SIZE(argv);
+
+	argv[argc - 1] = ndctl_namespace_get_devname(ndns);
+	return create_namespace(argc, argv, ctx);
+}
+
 static void sigbus(int sig, siginfo_t *siginfo, void *d)
 {
 	siglongjmp(sj_env, 1);
 }
 
+#define VERIFY_SIZE SZ_4M
+#define VERIFY_BUF_SIZE 4096
+
+static int verify_data(struct daxctl_dev *dev, char *dax_buf, int salt,
+	struct ndctl_test *test)
+{
+	struct timeval tv1, tv2, tv_diff;
+	int i;
+
+	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 9, 0)))
+		return 0;
+
+	/* verify data and cache mode */
+	gettimeofday(&tv1, NULL);
+	for (i = 0; i < VERIFY_SIZE; i += VERIFY_BUF_SIZE) {
+		unsigned int *verify = (unsigned int *) (dax_buf + i), j;
+
+		for (j = 0; j < VERIFY_BUF_SIZE / sizeof(int); j++)
+			if (verify[j] != salt + i + j)
+				break;
+		if (j < VERIFY_BUF_SIZE / sizeof(int)) {
+			fprintf(stderr, "%s: @ %#x expected %#x got %#x\n",
+					daxctl_dev_get_devname(dev), i,
+					verify[j], salt + i + j);
+			return -ENXIO;
+		}
+	}
+	gettimeofday(&tv2, NULL);
+	timersub(&tv2, &tv1, &tv_diff);
+	tv_diff.tv_usec += tv_diff.tv_sec * 1000000;
+	if (tv_diff.tv_usec > 15000) {
+		/*
+		 * Checks whether the kernel correctly mapped the
+		 * device-dax range as cacheable.  The numbers were
+		 * derived from an Intel(R) Xeon(R) CPU E5-2690 v2 @
+		 * 3.00GHz where the loop completes in 7500us when
+		 * cached and 200ms when uncached.
+		 */
+		fprintf(stderr, "%s: verify loop took too long usecs: %ld\n",
+				daxctl_dev_get_devname(dev), tv_diff.tv_usec);
+		return -ENXIO;
+	}
+	return 0;
+}
+
 static int test_device_dax(int loglevel, struct ndctl_test *test,
 		struct ndctl_ctx *ctx)
 {
-	int fd, rc, *p;
 	struct sigaction act;
 	struct ndctl_dax *dax;
+	struct ndctl_pfn *pfn;
 	struct daxctl_dev *dev;
+	int i, fd, rc, *p, salt;
 	struct ndctl_namespace *ndns;
 	struct daxctl_region *dax_region;
-	char *buf, path[100], data[4096];
+	char *buf, path[100], data[VERIFY_BUF_SIZE];
 
 	memset (&act, 0, sizeof(act));
 	act.sa_sigaction = sigbus;
@@ -88,11 +148,46 @@ static int test_device_dax(int loglevel, struct ndctl_test *test,
 	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 7, 0)))
 		return 77;
 
+	/* setup up memory mode pmem device and seed with verification data */
+	rc = setup_pmem_memory_mode(ndns);
+	if (rc < 0 || !(pfn = ndctl_namespace_get_pfn(ndns))) {
+		fprintf(stderr, "%s: failed device-dax setup\n",
+				ndctl_namespace_get_devname(ndns));
+		goto out;
+	}
+
+	sprintf(path, "/dev/%s", ndctl_pfn_get_block_device(pfn));
+	fd = open(path, O_RDWR);
+	if (fd < 0) {
+		fprintf(stderr, "%s: failed to open pmem device\n", path);
+		rc = -ENXIO;
+		goto out;
+	}
+
+	srand(getpid());
+	salt = rand();
+	for (i = 0; i < VERIFY_SIZE; i += VERIFY_BUF_SIZE) {
+		unsigned int *verify = (unsigned int *) data, j;
+
+		for (j = 0; j < VERIFY_BUF_SIZE / sizeof(int); j++)
+			verify[j] = salt + i + j;
+
+		if (write(fd, data, sizeof(data)) != sizeof(data)) {
+			fprintf(stderr, "%s: failed data setup\n",
+					path);
+			rc = -ENXIO;
+			goto out;
+		}
+	}
+	fsync(fd);
+	close(fd);
+
+	/* switch the namespace to device-dax mode and verify data via mmap */
 	rc = setup_device_dax(ndns);
 	if (rc < 0) {
 		fprintf(stderr, "%s: failed device-dax setup\n",
 				ndctl_namespace_get_devname(ndns));
-		return rc;
+		goto out;
 	}
 
 	dax = ndctl_namespace_get_dax(ndns);
@@ -101,27 +196,35 @@ static int test_device_dax(int loglevel, struct ndctl_test *test,
 	if (!dev) {
 		fprintf(stderr, "%s: failed to find device-dax instance\n",
 				ndctl_namespace_get_devname(ndns));
-		return -ENXIO;
+		rc = -ENXIO;
+		goto out;
 	}
 
 	sprintf(path, "/dev/%s", daxctl_dev_get_devname(dev));
-
 	fd = open(path, O_RDWR);
 	if (fd < 0) {
 		fprintf(stderr, "%s: failed to open device-dax instance\n",
 				daxctl_dev_get_devname(dev));
-		return -ENXIO;
+		rc = -ENXIO;
+		goto out;
 	}
 
-	buf = mmap(NULL, 2UL << 20, PROT_READ|PROT_WRITE, MAP_PRIVATE, fd, 0);
+	buf = mmap(NULL, VERIFY_SIZE, PROT_READ|PROT_WRITE, MAP_PRIVATE, fd, 0);
 	if (buf != MAP_FAILED) {
 		fprintf(stderr, "%s: expected MAP_PRIVATE failure\n", path);
+		rc = -ENXIO;
+		goto out;
+	}
+
+	buf = mmap(NULL, VERIFY_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
+	if (buf == MAP_FAILED) {
+		fprintf(stderr, "%s: expected MAP_SHARED success\n", path);
 		return -ENXIO;
 	}
 
-	buf = mmap(NULL, 2UL << 20, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
-	p = (int *) (buf + (1UL << 20));
-	*p = 0;
+	rc = verify_data(dev, buf, salt, test);
+	if (rc)
+		goto out;
 
 	/*
 	 * Prior to 4.8-final these tests cause crashes, or are
@@ -134,14 +237,15 @@ static int test_device_dax(int loglevel, struct ndctl_test *test,
 		if (rc) {
 			fprintf(stderr, "%s: failed dax direct-i/o\n",
 					ndctl_namespace_get_devname(ndns));
-			return rc;
+			goto out;
 		}
 
 		fd2 = open("/proc/self/smaps", O_RDONLY);
 		if (fd2 < 0) {
 			fprintf(stderr, "%s: failed smaps open\n",
 					ndctl_namespace_get_devname(ndns));
-			return -ENXIO;
+			rc = -ENXIO;
+			goto out;
 		}
 
 		do {
@@ -151,7 +255,8 @@ static int test_device_dax(int loglevel, struct ndctl_test *test,
 		if (rc) {
 			fprintf(stderr, "%s: failed smaps retrieval\n",
 					ndctl_namespace_get_devname(ndns));
-			return -ENXIO;
+			rc = -ENXIO;
+			goto out;
 		}
 	}
 
@@ -159,17 +264,19 @@ static int test_device_dax(int loglevel, struct ndctl_test *test,
 	if (rc < 0) {
 		fprintf(stderr, "%s: failed to reset device-dax instance\n",
 				ndctl_namespace_get_devname(ndns));
-		return rc;
+		goto out;
 	}
 
 	/* test fault after device-dax instance disabled */
 	if (sigsetjmp(sj_env, 1)) {
 		/* got sigbus, success */
 		close(fd);
-		return 0;
+		rc = 0;
+		goto out;
 	}
 
 	rc = EXIT_SUCCESS;
+	p = (int *) (buf + (1UL << 20));
 	*p = 0xff;
 	if (ndctl_test_attempt(test, KERNEL_VERSION(4, 9, 0))) {
 		/* after 4.9 this test will properly get sigbus above */
@@ -178,6 +285,8 @@ static int test_device_dax(int loglevel, struct ndctl_test *test,
 				daxctl_dev_get_devname(dev));
 	}
 	close(fd);
+ out:
+	reset_device_dax(ndns);
 	return rc;
 }
 
diff --git a/util/size.h b/util/size.h
index 64c146480ef0..9befecb28b14 100644
--- a/util/size.h
+++ b/util/size.h
@@ -4,6 +4,7 @@
 #define SZ_1K     0x00000400
 #define SZ_1M     0x00100000
 #define SZ_2M     0x00200000
+#define SZ_4M     0x00400000
 #define SZ_1G     0x40000000
 #define SZ_1T 0x10000000000ULL
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
