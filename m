Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 5F0651A1DF2
 for <linux-nvdimm@lists.01.org>; Tue, 16 Aug 2016 10:24:33 -0700 (PDT)
Subject: [ndctl PATCH 8/8] test,
 device-dax: check mappings invalidated on namespace reconfiguration
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 16 Aug 2016 10:22:09 -0700
Message-ID: <147136812987.27902.7097669727543459420.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147136808681.27902.14029119240021638000.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147136808681.27902.14029119240021638000.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Validate that the kernel does not leak mappings past the end of life of
the namespace device.  I.e. ndctl_dax_delete() == "mappings return
SIGBUS".

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/device-dax.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/test/device-dax.c b/test/device-dax.c
index 7b624ea5bc8f..1a67a27ab134 100644
--- a/test/device-dax.c
+++ b/test/device-dax.c
@@ -5,6 +5,8 @@
 #include <stdlib.h>
 #include <syslog.h>
 #include <string.h>
+#include <signal.h>
+#include <setjmp.h>
 #include <sys/stat.h>
 #include <sys/mman.h>
 #include <sys/types.h>
@@ -17,6 +19,8 @@
 #include <ndctl/builtin.h>
 #include <test.h>
 
+static sigjmp_buf sj_env;
+
 static int create_namespace(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	builtin_xaction_namespace_reset();
@@ -47,16 +51,31 @@ static int setup_device_dax(struct ndctl_namespace *ndns)
 	return create_namespace(argc, argv, ctx);
 }
 
+static void sigbus(int sig, siginfo_t *siginfo, void *d)
+{
+	siglongjmp(sj_env, 1);
+}
+
 static int test_device_dax(int loglevel, struct ndctl_test *test,
 		struct ndctl_ctx *ctx)
 {
 	int fd, rc, *p;
 	char *buf, path[100];
+	struct sigaction act;
 	struct ndctl_dax *dax;
 	struct daxctl_dev *dev;
 	struct ndctl_namespace *ndns;
 	struct daxctl_region *dax_region;
 
+	memset (&act, 0, sizeof(act));
+	act.sa_sigaction = sigbus;
+	act.sa_flags = SA_SIGINFO;
+
+	if (sigaction(SIGBUS, &act, 0)) {
+		perror("sigaction");
+		return 1;
+	}
+
 	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 7, 0)))
 		return 77;
 
@@ -105,8 +124,18 @@ static int test_device_dax(int loglevel, struct ndctl_test *test,
 		return rc;
 	}
 
+	/* test fault after device-dax instance disabled */
+	if (sigsetjmp(sj_env, 1)) {
+		/* got sigbus, success */
+		close(fd);
+		return 0;
+	}
+
+	*p = 0xff;
+	fprintf(stderr, "%s: failed to unmap after reset\n",
+			daxctl_dev_get_devname(dev));
 	close(fd);
-	return 0;
+	return EXIT_FAILURE;
 }
 
 int __attribute__((weak)) main(int argc, char *argv[])

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
