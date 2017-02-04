Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7094F820A8
 for <linux-nvdimm@lists.01.org>; Sat,  4 Feb 2017 15:25:58 -0800 (PST)
Subject: [ndctl PATCH 2/2] test: expand device-dax test for all alignments
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 04 Feb 2017 15:21:53 -0800
Message-ID: <148625051318.27070.9028819445346684784.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148625050793.27070.3913104369267731411.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148625050793.27070.3913104369267731411.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Add 4K and 1G alignment testing in addition to the default 2M.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test.h            |    2 +
 test/dax-pmd.c    |   12 ++++---
 test/device-dax.c |   86 ++++++++++++++++++++++++++++++++++++-----------------
 3 files changed, 65 insertions(+), 35 deletions(-)

diff --git a/test.h b/test.h
index 079f02317d5d..5d17398c02f4 100644
--- a/test.h
+++ b/test.h
@@ -22,7 +22,7 @@ int nfit_test_init(struct kmod_ctx **ctx, struct kmod_module **mod,
 struct ndctl_ctx;
 int test_parent_uuid(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 int test_multi_pmem(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
-int test_dax_directio(int dax_fd, void *dax_addr, off_t offset);
+int test_dax_directio(int dax_fd, unsigned long align, void *dax_addr, off_t offset);
 int test_dpa_alloc(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 int test_dsm_fail(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 int test_libndctl(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
diff --git a/test/dax-pmd.c b/test/dax-pmd.c
index 831b1f0a6572..a422e999896a 100644
--- a/test/dax-pmd.c
+++ b/test/dax-pmd.c
@@ -19,7 +19,7 @@
 #define faili(i) fprintf(stderr, "%s: failed at: %d: %d\n", __func__, __LINE__, i)
 #define TEST_FILE "test_dax_data"
 
-int test_dax_directio(int dax_fd, void *dax_addr, off_t offset)
+int test_dax_directio(int dax_fd, unsigned long align, void *dax_addr, off_t offset)
 {
 	int i, rc = -ENXIO;
 	void *buf;
@@ -28,7 +28,7 @@ int test_dax_directio(int dax_fd, void *dax_addr, off_t offset)
 		return -ENOMEM;
 
 	for (i = 0; i < 3; i++) {
-		void *addr = mmap(dax_addr, 2*HPAGE_SIZE,
+		void *addr = mmap(dax_addr, 2*align,
 				PROT_READ|PROT_WRITE, MAP_SHARED, dax_fd,
 				offset);
 		int fd2;
@@ -43,7 +43,7 @@ int test_dax_directio(int dax_fd, void *dax_addr, off_t offset)
 				DEFFILEMODE);
 		if (fd2 < 0) {
 			faili(i);
-			munmap(addr, 2*HPAGE_SIZE);
+			munmap(addr, 2*align);
 			break;
 		}
 
@@ -94,7 +94,7 @@ int test_dax_directio(int dax_fd, void *dax_addr, off_t offset)
 			break;
 		}
 
-		munmap(addr, 2*HPAGE_SIZE);
+		munmap(addr, 2*align);
 		addr = MAP_FAILED;
 		unlink(TEST_FILE);
 		close(fd2);
@@ -164,8 +164,8 @@ static int test_pmd(int fd)
 	m_align = ALIGN(base, HPAGE_SIZE) - ((unsigned long) base);
 	p_align = ALIGN(ext->fe_physical, HPAGE_SIZE) - ext->fe_physical;
 
-	rc = test_dax_directio(fd, (char *) base + m_align, ext->fe_logical
-			+ p_align);
+	rc = test_dax_directio(fd, HPAGE_SIZE, (char *) base + m_align,
+			ext->fe_logical + p_align);
 
  err_extent:
  err_mmap:
diff --git a/test/device-dax.c b/test/device-dax.c
index f5ab3898f78c..891fd55d6440 100644
--- a/test/device-dax.c
+++ b/test/device-dax.c
@@ -41,27 +41,34 @@ static int reset_device_dax(struct ndctl_namespace *ndns)
 	return create_namespace(argc, argv, ctx);
 }
 
-static int setup_device_dax(struct ndctl_namespace *ndns)
+static int setup_device_dax(struct ndctl_namespace *ndns, unsigned long __align)
 {
 	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
+	char align[32];
 	const char *argv[] = {
-		"__func__", "-v", "-m", "dax", "-M", "dev", "-f", "-e", "",
+		"__func__", "-v", "-m", "dax", "-M", "dev", "-f", "-a", align,
+		"-e", "",
 	};
 	int argc = ARRAY_SIZE(argv);
 
 	argv[argc - 1] = ndctl_namespace_get_devname(ndns);
+	sprintf(align, "%ld", __align);
 	return create_namespace(argc, argv, ctx);
 }
 
-static int setup_pmem_memory_mode(struct ndctl_namespace *ndns)
+static int setup_pmem_memory_mode(struct ndctl_namespace *ndns,
+		unsigned long __align)
 {
 	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
+	char align[32];
 	const char *argv[] = {
-		"__func__", "-v", "-m", "memory", "-M", "dev", "-f", "-e", "",
+		"__func__", "-v", "-m", "memory", "-M", "dev", "-f", "-a",
+		align, "-e", "",
 	};
 	int argc = ARRAY_SIZE(argv);
 
 	argv[argc - 1] = ndctl_namespace_get_devname(ndns);
+	sprintf(align, "%ld", __align);
 	return create_namespace(argc, argv, ctx);
 }
 
@@ -70,28 +77,35 @@ static void sigbus(int sig, siginfo_t *siginfo, void *d)
 	siglongjmp(sj_env, 1);
 }
 
-#define VERIFY_SIZE SZ_4M
+#define VERIFY_SIZE(x) (x * 2)
 #define VERIFY_BUF_SIZE 4096
 
-static int verify_data(struct daxctl_dev *dev, char *dax_buf, int salt,
-	struct ndctl_test *test)
+/*
+ * This timeout value derived from an Intel(R) Xeon(R) CPU E5-2690 v2 @
+ * 3.00GHz where the loop, for the align == 2M case, completes in 7500us
+ * when cached and 200ms when uncached.
+ */
+#define VERIFY_TIME(x) (suseconds_t) ((ALIGN(x, SZ_2M) / SZ_4K) * 30)
+
+static int verify_data(struct daxctl_dev *dev, char *dax_buf,
+		unsigned long align, int salt, struct ndctl_test *test)
 {
 	struct timeval tv1, tv2, tv_diff;
-	int i;
+	unsigned long i;
 
 	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 9, 0)))
 		return 0;
 
 	/* verify data and cache mode */
 	gettimeofday(&tv1, NULL);
-	for (i = 0; i < VERIFY_SIZE; i += VERIFY_BUF_SIZE) {
+	for (i = 0; i < VERIFY_SIZE(align); i += VERIFY_BUF_SIZE) {
 		unsigned int *verify = (unsigned int *) (dax_buf + i), j;
 
 		for (j = 0; j < VERIFY_BUF_SIZE / sizeof(int); j++)
 			if (verify[j] != salt + i + j)
 				break;
 		if (j < VERIFY_BUF_SIZE / sizeof(int)) {
-			fprintf(stderr, "%s: @ %#x expected %#x got %#x\n",
+			fprintf(stderr, "%s: @ %#lx expected %#x got %#lx\n",
 					daxctl_dev_get_devname(dev), i,
 					verify[j], salt + i + j);
 			return -ENXIO;
@@ -100,13 +114,10 @@ static int verify_data(struct daxctl_dev *dev, char *dax_buf, int salt,
 	gettimeofday(&tv2, NULL);
 	timersub(&tv2, &tv1, &tv_diff);
 	tv_diff.tv_usec += tv_diff.tv_sec * 1000000;
-	if (tv_diff.tv_usec > 15000) {
+	if (tv_diff.tv_usec > VERIFY_TIME(align)) {
 		/*
 		 * Checks whether the kernel correctly mapped the
-		 * device-dax range as cacheable.  The numbers were
-		 * derived from an Intel(R) Xeon(R) CPU E5-2690 v2 @
-		 * 3.00GHz where the loop completes in 7500us when
-		 * cached and 200ms when uncached.
+		 * device-dax range as cacheable.
 		 */
 		fprintf(stderr, "%s: verify loop took too long usecs: %ld\n",
 				daxctl_dev_get_devname(dev), tv_diff.tv_usec);
@@ -115,14 +126,15 @@ static int verify_data(struct daxctl_dev *dev, char *dax_buf, int salt,
 	return 0;
 }
 
-static int test_device_dax(int loglevel, struct ndctl_test *test,
-		struct ndctl_ctx *ctx)
+static int __test_device_dax(unsigned long align, int loglevel,
+		struct ndctl_test *test, struct ndctl_ctx *ctx)
 {
+	unsigned long i;
 	struct sigaction act;
 	struct ndctl_dax *dax;
 	struct ndctl_pfn *pfn;
 	struct daxctl_dev *dev;
-	int i, fd, rc, *p, salt;
+	int fd, rc, *p, salt;
 	struct ndctl_namespace *ndns;
 	struct daxctl_region *dax_region;
 	char *buf, path[100], data[VERIFY_BUF_SIZE];
@@ -148,8 +160,11 @@ static int test_device_dax(int loglevel, struct ndctl_test *test,
 	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 7, 0)))
 		return 77;
 
+	if (align > SZ_2M && !ndctl_test_attempt(test, KERNEL_VERSION(4, 11, 0)))
+		return 77;
+
 	/* setup up memory mode pmem device and seed with verification data */
-	rc = setup_pmem_memory_mode(ndns);
+	rc = setup_pmem_memory_mode(ndns, align);
 	if (rc < 0 || !(pfn = ndctl_namespace_get_pfn(ndns))) {
 		fprintf(stderr, "%s: failed device-dax setup\n",
 				ndctl_namespace_get_devname(ndns));
@@ -166,7 +181,7 @@ static int test_device_dax(int loglevel, struct ndctl_test *test,
 
 	srand(getpid());
 	salt = rand();
-	for (i = 0; i < VERIFY_SIZE; i += VERIFY_BUF_SIZE) {
+	for (i = 0; i < VERIFY_SIZE(align); i += VERIFY_BUF_SIZE) {
 		unsigned int *verify = (unsigned int *) data, j;
 
 		for (j = 0; j < VERIFY_BUF_SIZE / sizeof(int); j++)
@@ -183,7 +198,7 @@ static int test_device_dax(int loglevel, struct ndctl_test *test,
 	close(fd);
 
 	/* switch the namespace to device-dax mode and verify data via mmap */
-	rc = setup_device_dax(ndns);
+	rc = setup_device_dax(ndns, align);
 	if (rc < 0) {
 		fprintf(stderr, "%s: failed device-dax setup\n",
 				ndctl_namespace_get_devname(ndns));
@@ -209,26 +224,26 @@ static int test_device_dax(int loglevel, struct ndctl_test *test,
 		goto out;
 	}
 
-	buf = mmap(NULL, VERIFY_SIZE, PROT_READ, MAP_PRIVATE, fd, 0);
+	buf = mmap(NULL, VERIFY_SIZE(align), PROT_READ, MAP_PRIVATE, fd, 0);
 	if (buf != MAP_FAILED) {
 		fprintf(stderr, "%s: expected MAP_PRIVATE failure\n", path);
 		rc = -ENXIO;
 		goto out;
 	}
 
-	buf = mmap(NULL, VERIFY_SIZE, PROT_READ, MAP_SHARED, fd, 0);
+	buf = mmap(NULL, VERIFY_SIZE(align), PROT_READ, MAP_SHARED, fd, 0);
 	if (buf == MAP_FAILED) {
 		fprintf(stderr, "%s: expected MAP_SHARED success\n", path);
 		return -ENXIO;
 	}
 
-	rc = verify_data(dev, buf, salt, test);
+	rc = verify_data(dev, buf, align, salt, test);
 	if (rc)
 		goto out;
 
 	/* upgrade to a writable mapping */
 	close(fd);
-	munmap(buf, VERIFY_SIZE);
+	munmap(buf, VERIFY_SIZE(align));
 	fd = open(path, O_RDWR);
 	if (fd < 0) {
 		fprintf(stderr, "%s: failed to open(O_RDWR) device-dax instance\n",
@@ -237,7 +252,7 @@ static int test_device_dax(int loglevel, struct ndctl_test *test,
 		goto out;
 	}
 
-	buf = mmap(NULL, VERIFY_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
+	buf = mmap(NULL, VERIFY_SIZE(align), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
 	if (buf == MAP_FAILED) {
 		fprintf(stderr, "%s: expected PROT_WRITE + MAP_SHARED success\n",
 				path);
@@ -251,7 +266,7 @@ static int test_device_dax(int loglevel, struct ndctl_test *test,
 	if (ndctl_test_attempt(test, KERNEL_VERSION(4, 9, 0))) {
 		int fd2;
 
-		rc = test_dax_directio(fd, NULL, 0);
+		rc = test_dax_directio(fd, align, NULL, 0);
 		if (rc) {
 			fprintf(stderr, "%s: failed dax direct-i/o\n",
 					ndctl_namespace_get_devname(ndns));
@@ -294,7 +309,7 @@ static int test_device_dax(int loglevel, struct ndctl_test *test,
 	}
 
 	rc = EXIT_SUCCESS;
-	p = (int *) (buf + (1UL << 20));
+	p = (int *) (buf + align);
 	*p = 0xff;
 	if (ndctl_test_attempt(test, KERNEL_VERSION(4, 9, 0))) {
 		/* after 4.9 this test will properly get sigbus above */
@@ -308,6 +323,21 @@ static int test_device_dax(int loglevel, struct ndctl_test *test,
 	return rc;
 }
 
+static int test_device_dax(int loglevel, struct ndctl_test *test,
+		struct ndctl_ctx *ctx)
+{
+	unsigned long i, aligns[] = { SZ_4K, SZ_2M, SZ_1G };
+	int rc;
+
+	for (i = 0; i < ARRAY_SIZE(aligns); i++) {
+		rc = __test_device_dax(aligns[i], loglevel, test, ctx);
+		if (rc && rc != 77)
+			break;
+	}
+
+	return rc;
+}
+
 int __attribute__((weak)) main(int argc, char *argv[])
 {
 	struct ndctl_test *test = ndctl_test_new(0);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
