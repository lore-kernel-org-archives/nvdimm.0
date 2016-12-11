Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 61EA682081
 for <linux-nvdimm@lists.01.org>; Sat, 10 Dec 2016 22:39:11 -0800 (PST)
Subject: [ndctl PATCH 5/6] test, daxctl: test dax region apis
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 10 Dec 2016 22:35:02 -0800
Message-ID: <148143810220.11895.9642149313511155250.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148143807638.11895.3823811556889353622.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148143807638.11895.3823811556889353622.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Spot check the new dax_region attributes available starting with kernel
v4.10.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/libndctl.c |   35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/test/libndctl.c b/test/libndctl.c
index 840376c34d32..c6e199dbb078 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -625,9 +625,12 @@ static int validate_dax(struct ndctl_dax *dax)
 	struct ndctl_namespace *ndns = ndctl_dax_get_namespace(dax);
 	const char *devname = ndctl_namespace_get_devname(ndns);
 	struct ndctl_region *region = ndctl_dax_get_region(dax);
-	struct daxctl_region *dax_region = NULL;
+	struct ndctl_ctx *ctx = ndctl_dax_get_ctx(dax);
+	struct ndctl_test *test = ndctl_get_private_data(ctx);
+	struct daxctl_region *dax_region = NULL, *found;
 	int rc = -ENXIO, fd, count, dax_expect;
 	struct daxctl_dev *dax_dev, *seed;
+	struct daxctl_ctx *dax_ctx;
 	uuid_t uuid, region_uuid;
 	char devpath[50];
 
@@ -638,6 +641,35 @@ static int validate_dax(struct ndctl_dax *dax)
 		return -ENXIO;
 	}
 
+	dax_ctx = ndctl_get_daxctl_ctx(ctx);
+	count = 0;
+	daxctl_region_foreach(dax_ctx, found)
+		if (found == dax_region)
+			count++;
+	if (count != 1) {
+		fprintf(stderr, "%s: failed to iterate to single region instance\n",
+				devname);
+		return -ENXIO;
+	}
+
+	if (ndctl_test_attempt(test, KERNEL_VERSION(4, 10, 0))) {
+		if (daxctl_region_get_size(dax_region)
+				!= ndctl_dax_get_size(dax)) {
+			fprintf(stderr, "%s: expect size: %llu != %llu\n",
+					devname, ndctl_dax_get_size(dax),
+					daxctl_region_get_size(dax_region));
+			return -ENXIO;
+		}
+
+		if (daxctl_region_get_align(dax_region)
+				!= ndctl_dax_get_align(dax)) {
+			fprintf(stderr, "%s: expect align: %lu != %lu\n",
+					devname, ndctl_dax_get_align(dax),
+					daxctl_region_get_align(dax_region));
+			return -ENXIO;
+		}
+	}
+
 	rc = -ENXIO;
 	ndctl_dax_get_uuid(dax, uuid);
 	daxctl_region_get_uuid(dax_region, region_uuid);
@@ -2646,6 +2678,7 @@ int test_libndctl(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx)
 	ndctl_set_log_priority(ctx, loglevel);
 	daxctl_ctx = ndctl_get_daxctl_ctx(ctx);
 	daxctl_set_log_priority(daxctl_ctx, loglevel);
+	ndctl_set_private_data(ctx, test);
 
 	kmod_ctx = kmod_new(NULL, NULL);
 	if (!kmod_ctx)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
