Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 257E41A1E14
 for <linux-nvdimm@lists.01.org>; Fri,  9 Sep 2016 18:44:36 -0700 (PDT)
Subject: [ndctl PATCH 1/3] test, device-dax: /proc/self/smaps
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 09 Sep 2016 18:41:32 -0700
Message-ID: <147347169244.15190.840534533992093250.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Until recently the kernel would crash when walking smaps with
pmd_devmap() entries in the page table.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/device-dax.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/test/device-dax.c b/test/device-dax.c
index a14e2a95db7e..04d53da544cd 100644
--- a/test/device-dax.c
+++ b/test/device-dax.c
@@ -60,12 +60,12 @@ static int test_device_dax(int loglevel, struct ndctl_test *test,
 		struct ndctl_ctx *ctx)
 {
 	int fd, rc, *p;
-	char *buf, path[100];
 	struct sigaction act;
 	struct ndctl_dax *dax;
 	struct daxctl_dev *dev;
 	struct ndctl_namespace *ndns;
 	struct daxctl_region *dax_region;
+	char *buf, path[100], data[4096];
 
 	memset (&act, 0, sizeof(act));
 	act.sa_sigaction = sigbus;
@@ -123,14 +123,36 @@ static int test_device_dax(int loglevel, struct ndctl_test *test,
 	p = (int *) (buf + (1UL << 20));
 	*p = 0;
 
+	/*
+	 * Prior to 4.8-final these tests cause crashes, or are
+	 * otherwise not supported.
+	 */
 	if (ndctl_test_attempt(test, KERNEL_VERSION(4, 9, 0))) {
-		/* prior to 4.8-final this crashes */
+		int fd2;
+
 		rc = test_dax_directio(fd, NULL, 0);
 		if (rc) {
 			fprintf(stderr, "%s: failed dax direct-i/o\n",
 					ndctl_namespace_get_devname(ndns));
 			return rc;
 		}
+
+		fd2 = open("/proc/self/smaps", O_RDONLY);
+		if (fd2 < 0) {
+			fprintf(stderr, "%s: failed smaps open\n",
+					ndctl_namespace_get_devname(ndns));
+			return -ENXIO;
+		}
+
+		do {
+			rc = read(fd2, data, sizeof(data));
+		} while (rc > 0);
+
+		if (rc) {
+			fprintf(stderr, "%s: failed smaps retrieval\n",
+					ndctl_namespace_get_devname(ndns));
+			return -ENXIO;
+		}
 	}
 
 	rc = reset_device_dax(ndns);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
