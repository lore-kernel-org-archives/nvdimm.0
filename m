Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id B67E11A1E20
 for <linux-nvdimm@lists.01.org>; Tue, 16 Aug 2016 10:24:12 -0700 (PDT)
Subject: [ndctl PATCH 4/8] test: teach test/libndctl about device-dax seeds
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 16 Aug 2016 10:21:49 -0700
Message-ID: <147136810923.27902.10426662850702126937.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Starting the with v4.9 kernel the default number of device-dax instances
per-region will be 2, and seed devices are legitimately zero-sized.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/libndctl.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/test/libndctl.c b/test/libndctl.c
index de2c47c3f91b..30b78a2824f1 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -623,9 +623,9 @@ static int validate_dax(struct ndctl_dax *dax)
 	const char *devname = ndctl_namespace_get_devname(ndns);
 	struct ndctl_region *region = ndctl_dax_get_region(dax);
 	struct daxctl_region *dax_region = NULL;
+	int rc = -ENXIO, fd, count, dax_expect;
+	struct daxctl_dev *dax_dev, *seed;
 	uuid_t uuid, region_uuid;
-	struct daxctl_dev *dax_dev;
-	int rc = -ENXIO, fd, count;
 	char devpath[50];
 
 	dax_region = ndctl_dax_get_daxctl_region(dax);
@@ -663,7 +663,8 @@ static int validate_dax(struct ndctl_dax *dax)
 		goto out;
 	}
 
-	if (daxctl_dev_get_size(dax_dev) <= 0) {
+	seed = daxctl_region_get_dev_seed(dax_region);
+	if (dax_dev != seed && daxctl_dev_get_size(dax_dev) <= 0) {
 		fprintf(stderr, "%s: expected non-zero sized dax device\n",
 				devname);
 		goto out;
@@ -680,9 +681,11 @@ static int validate_dax(struct ndctl_dax *dax)
 	count = 0;
 	daxctl_dev_foreach(dax_region, dax_dev)
 		count++;
-	if (count != 1) {
-		fprintf(stderr, "%s: expected 1 dax device, got %d\n",
-				devname, count);
+	dax_expect = seed ? 2 : 1;
+	if (count != dax_expect) {
+		fprintf(stderr, "%s: expected %d dax device%s, got %d\n",
+				devname, dax_expect, dax_expect == 1 ? "" : "s",
+				count);
 		rc = -ENXIO;
 		goto out;
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
