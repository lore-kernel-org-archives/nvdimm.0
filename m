Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B8F001A1E59
 for <linux-nvdimm@lists.01.org>; Mon, 19 Sep 2016 14:41:10 -0700 (PDT)
Subject: [ndctl PATCH 5/6] libdaxctl: fix deref-before-null-check in
 daxctl_new_region
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 19 Sep 2016 14:38:07 -0700
Message-ID: <147432108766.39548.6131939956705403033.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147432105652.39548.8883834720654751375.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147432105652.39548.8883834720654751375.stgit@dwillia2-desk3.amr.corp.intel.com>
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

If ->region_path is not set, do not attempt to take its length.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 daxctl/lib/libdaxctl.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index ecdb99640115..8f1b88e06ac6 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -217,14 +217,19 @@ DAXCTL_EXPORT struct daxctl_region *daxctl_new_region(struct daxctl_ctx *ctx,
 	region->id = id;
 	region->refcount = 1;
 	uuid_copy(region->uuid, uuid);
+
 	region->region_path = strdup(path);
+	if (!region->region_path) {
+		free(region);
+		return NULL;
+	}
+
 	list_head_init(&region->devices);
 	region->buf_len = strlen(region->region_path) + REGION_BUF_SIZE;
 	region->region_buf = calloc(1, region->buf_len);
-
-	if (!region->region_path || !region->region_buf) {
+	if (!region->region_buf) {
 		daxctl_region_unref(region);
-		region = NULL;
+		return NULL;
 	}
 
 	dbg(ctx, "%s: %s\n", __func__, daxctl_region_get_devname(region));

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
