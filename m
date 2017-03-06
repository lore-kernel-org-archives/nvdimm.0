Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0E2F18029A
 for <linux-nvdimm@lists.01.org>; Mon,  6 Mar 2017 15:06:19 -0800 (PST)
Subject: [PATCH] ndctl: add 1G dev-dax unit test
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 06 Mar 2017 16:06:18 -0700
Message-ID: <148884157819.14798.2071077521120270964.stgit@djiang5-desk3.ch.intel.com>
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

Adding unit test for device DAX 1G PUD support. This is patterned after
device-dax.c that tests the PMD support.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 test/Makefile.am     |   17 +++
 test/device-dax-1g.c |  336 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 353 insertions(+)
 create mode 100644 test/device-dax-1g.c

diff --git a/test/Makefile.am b/test/Makefile.am
index cd2226f..f08ca1c 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -27,6 +27,7 @@ TESTS +=\
 	dax-dev \
 	dax.sh \
 	device-dax \
+	device-dax-1g \
 	mmap.sh
 
 check_PROGRAMS +=\
@@ -34,7 +35,9 @@ check_PROGRAMS +=\
 	pmem-ns \
 	dax-dev \
 	dax-pmd \
+	dax-pud \
 	device-dax \
+	device-dax-1g \
 	mmap
 endif
 
@@ -72,6 +75,7 @@ dax_dev_SOURCES = dax-dev.c $(testcore)
 dax_dev_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
 
 dax_pmd_SOURCES = dax-pmd.c
+dax_pud_SOURCES = dax-pud.c
 mmap_SOURCES = mmap.c
 dax_errors_SOURCES = dax-errors.c
 daxdev_errors_SOURCES = daxdev-errors.c \
@@ -91,6 +95,19 @@ device_dax_LDADD = \
 		$(JSON_LIBS) \
 		../libutil.a
 
+device_dax_1g_SOURCES = \
+		device-dax-1g.c \
+		dax-dev.c \
+		dax-pmd.c \
+		$(testcore) \
+		../ndctl/builtin-xaction-namespace.c \
+		../util/json.c
+device_dax_1g_LDADD = \
+		$(LIBNDCTL_LIB) \
+		$(KMOD_LIBS) \
+		$(JSON_LIBS) \
+		../libutil.a
+
 multi_pmem_SOURCES = \
 		multi-pmem.c \
 		$(testcore) \
diff --git a/test/device-dax-1g.c b/test/device-dax-1g.c
new file mode 100644
index 0000000..0d1a92d
--- /dev/null
+++ b/test/device-dax-1g.c
@@ -0,0 +1,336 @@
+#include <fcntl.h>
+#include <stdio.h>
+#include <errno.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <syslog.h>
+#include <string.h>
+#include <signal.h>
+#include <setjmp.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <util/size.h>
+#include <linux/falloc.h>
+#include <linux/version.h>
+#include <ndctl/libndctl.h>
+#include <daxctl/libdaxctl.h>
+#include <ccan/array_size/array_size.h>
+
+#include <builtin.h>
+#include <test.h>
+
+#define PUD_SIZE (1 << 30)
+static sigjmp_buf sj_env;
+
+static int create_namespace(int argc, const char **argv, void *ctx)
+{
+	builtin_xaction_namespace_reset();
+	return cmd_create_namespace(argc, argv, ctx);
+}
+
+static int reset_device_dax(struct ndctl_namespace *ndns)
+{
+	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
+	const char *argv[] = {
+		"__func__", "-v", "-m", "raw", "-f", "-e", "",
+	};
+	int argc = ARRAY_SIZE(argv);
+
+	argv[argc - 1] = ndctl_namespace_get_devname(ndns);
+	return create_namespace(argc, argv, ctx);
+}
+
+static int setup_device_dax(struct ndctl_namespace *ndns)
+{
+	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
+	const char *argv[] = {
+		"__func__", "-v", "-m", "dax", "-M", "mem", "-f",
+		"-a", "0x40000000", "-e", "",
+	};
+	int argc = ARRAY_SIZE(argv);
+
+	argv[argc - 1] = ndctl_namespace_get_devname(ndns);
+	return create_namespace(argc, argv, ctx);
+}
+
+static int setup_pmem_memory_mode(struct ndctl_namespace *ndns)
+{
+	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
+	const char *argv[] = {
+		"__func__", "-v", "-m", "memory", "-M", "dev", "-f",
+		"-a", "0x40000000", "-e", "",
+	};
+	int argc = ARRAY_SIZE(argv);
+
+	argv[argc - 1] = ndctl_namespace_get_devname(ndns);
+	return create_namespace(argc, argv, ctx);
+}
+
+static void sigbus(int sig, siginfo_t *siginfo, void *d)
+{
+	siglongjmp(sj_env, 1);
+}
+
+#define VERIFY_SIZE SZ_1G
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
+	if (tv_diff.tv_usec > 15000*512) {
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
+static int test_device_dax(int loglevel, struct ndctl_test *test,
+		struct ndctl_ctx *ctx)
+{
+	struct sigaction act;
+	struct ndctl_dax *dax;
+	struct ndctl_pfn *pfn;
+	struct daxctl_dev *dev;
+	int i, fd, rc, *p, salt;
+	struct ndctl_namespace *ndns;
+	struct daxctl_region *dax_region;
+	char *buf, path[100], data[VERIFY_BUF_SIZE];
+
+	memset (&act, 0, sizeof(act));
+	act.sa_sigaction = sigbus;
+	act.sa_flags = SA_SIGINFO;
+
+	if (sigaction(SIGBUS, &act, 0)) {
+		perror("sigaction");
+		return 1;
+	}
+
+	ndctl_set_log_priority(ctx, loglevel);
+
+	ndns = ndctl_get_test_dev(ctx);
+	if (!ndns) {
+		fprintf(stderr, "%s: failed to find suitable namespace\n",
+				__func__);
+		return 77;
+	}
+
+	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 7, 0)))
+		return 77;
+
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
+	/* device DAX 1G needs 4.11 */
+	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 11, 0)))
+		return 77;
+
+	/* switch the namespace to device-dax mode and verify data via mmap */
+	rc = setup_device_dax(ndns);
+	if (rc < 0) {
+		fprintf(stderr, "%s: failed device-dax setup\n",
+				ndctl_namespace_get_devname(ndns));
+		goto out;
+	}
+
+	dax = ndctl_namespace_get_dax(ndns);
+	dax_region = ndctl_dax_get_daxctl_region(dax);
+	dev = daxctl_dev_get_first(dax_region);
+	if (!dev) {
+		fprintf(stderr, "%s: failed to find device-dax instance\n",
+				ndctl_namespace_get_devname(ndns));
+		rc = -ENXIO;
+		goto out;
+	}
+
+	sprintf(path, "/dev/%s", daxctl_dev_get_devname(dev));
+	fd = open(path, O_RDONLY);
+	if (fd < 0) {
+		fprintf(stderr, "%s: failed to open(O_RDONLY) device-dax instance\n",
+				daxctl_dev_get_devname(dev));
+		rc = -ENXIO;
+		goto out;
+	}
+
+	buf = mmap(NULL, VERIFY_SIZE, PROT_READ, MAP_PRIVATE, fd, 0);
+	if (buf != MAP_FAILED) {
+		fprintf(stderr, "%s: expected MAP_PRIVATE failure\n", path);
+		rc = -ENXIO;
+		goto out;
+	}
+
+	buf = mmap(NULL, VERIFY_SIZE, PROT_READ, MAP_SHARED, fd, 0);
+	if (buf == MAP_FAILED) {
+		fprintf(stderr, "%s: expected MAP_SHARED success\n", path);
+		return -ENXIO;
+	}
+
+	rc = verify_data(dev, buf, salt, test);
+	if (rc)
+		goto out;
+
+	/* upgrade to a writable mapping */
+	close(fd);
+	munmap(buf, VERIFY_SIZE);
+	fd = open(path, O_RDWR);
+	if (fd < 0) {
+		fprintf(stderr, "%s: failed to open(O_RDWR) device-dax instance\n",
+				daxctl_dev_get_devname(dev));
+		rc = -ENXIO;
+		goto out;
+	}
+
+	buf = mmap(NULL, VERIFY_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
+	if (buf == MAP_FAILED) {
+		fprintf(stderr, "%s: expected PROT_WRITE + MAP_SHARED success\n",
+				path);
+		return -ENXIO;
+	}
+
+	/*
+	 * Prior to 4.11-final these tests cause crashes, or are
+	 * otherwise not supported.
+	 */
+	if (ndctl_test_attempt(test, KERNEL_VERSION(4, 11, 0))) {
+		int fd2;
+
+		rc = test_dax_directio(fd, PUD_SIZE, NULL, 0);
+		if (rc) {
+			fprintf(stderr, "%s: failed dax direct-i/o\n",
+					ndctl_namespace_get_devname(ndns));
+			goto out;
+		}
+
+		fd2 = open("/proc/self/smaps", O_RDONLY);
+		if (fd2 < 0) {
+			fprintf(stderr, "%s: failed smaps open\n",
+					ndctl_namespace_get_devname(ndns));
+			rc = -ENXIO;
+			goto out;
+		}
+
+		do {
+			rc = read(fd2, data, sizeof(data));
+		} while (rc > 0);
+
+		if (rc) {
+			fprintf(stderr, "%s: failed smaps retrieval\n",
+					ndctl_namespace_get_devname(ndns));
+			rc = -ENXIO;
+			goto out;
+		}
+	}
+
+	rc = reset_device_dax(ndns);
+	if (rc < 0) {
+		fprintf(stderr, "%s: failed to reset device-dax instance\n",
+				ndctl_namespace_get_devname(ndns));
+		goto out;
+	}
+
+	/* test fault after device-dax instance disabled */
+	if (sigsetjmp(sj_env, 1)) {
+		/* got sigbus, success */
+		close(fd);
+		rc = 0;
+		goto out;
+	}
+
+	rc = EXIT_SUCCESS;
+	p = (int *) (buf + (1UL << 20));
+	*p = 0xff;
+	if (ndctl_test_attempt(test, KERNEL_VERSION(4, 9, 0))) {
+		/* after 4.9 this test will properly get sigbus above */
+		rc = EXIT_FAILURE;
+		fprintf(stderr, "%s: failed to unmap after reset\n",
+				daxctl_dev_get_devname(dev));
+	}
+	close(fd);
+ out:
+	reset_device_dax(ndns);
+	return rc;
+}
+
+int __attribute__((weak)) main(int argc, char *argv[])
+{
+	struct ndctl_test *test = ndctl_test_new(0);
+	struct ndctl_ctx *ctx;
+	int rc;
+
+	if (!test) {
+		fprintf(stderr, "failed to initialize test\n");
+		return EXIT_FAILURE;
+	}
+
+	rc = ndctl_new(&ctx);
+	if (rc < 0)
+		return ndctl_test_result(test, rc);
+
+	rc = test_device_dax(LOG_DEBUG, test, ctx);
+	ndctl_unref(ctx);
+	return ndctl_test_result(test, rc);
+}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
