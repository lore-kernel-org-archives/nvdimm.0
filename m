Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 6F0EF1A1F3D
 for <linux-nvdimm@lists.01.org>; Tue,  8 Mar 2016 15:37:43 -0800 (PST)
Subject: [ndctl PATCH 6/8] ndctl: make test/dax-dev more robust
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 08 Mar 2016 15:36:59 -0800
Message-ID: <20160308233659.18628.6462.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160308233628.18628.13786.stgit@dwillia2-desk3.jf.intel.com>
References: <20160308233628.18628.13786.stgit@dwillia2-desk3.jf.intel.com>
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

Accept a pfn-enabled configuration for the test device to make the test
suite more reliable when restarting after a failure or forced
termination.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/dax-dev.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/test/dax-dev.c b/test/dax-dev.c
index 074fc9616743..3209eb148ed9 100755
--- a/test/dax-dev.c
+++ b/test/dax-dev.c
@@ -32,6 +32,7 @@ static int emit_e820_device(int loglevel, struct ndctl_test *test)
 	const char *bdev;
 	struct ndctl_ctx *ctx;
 	struct ndctl_bus *bus;
+	struct ndctl_pfn *pfn;
 	struct ndctl_region *region;
 	struct ndctl_namespace *ndns;
 	enum ndctl_namespace_mode mode;
@@ -61,7 +62,11 @@ static int emit_e820_device(int loglevel, struct ndctl_test *test)
 	if (mode >= 0 && mode != NDCTL_NS_MODE_MEMORY)
 		goto out;
 
-	bdev = ndctl_namespace_get_block_device(ndns);
+	pfn = ndctl_namespace_get_pfn(ndns);
+	if (pfn)
+		bdev = ndctl_pfn_get_block_device(pfn);
+	else
+		bdev = ndctl_namespace_get_block_device(ndns);
 	if (!bdev)
 		goto out;
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
