Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 430C981EAE
 for <linux-nvdimm@lists.01.org>; Wed, 14 Dec 2016 23:04:08 -0800 (PST)
Subject: [PATCH] dax: clarify driver_data ownership
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Dec 2016 22:59:59 -0800
Message-ID: <148178519905.7385.6307065431345873736.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Johannes points out that the warning in alloc_dax_region() seems to
imply that multiple devices might claim a dax region. In fact it's a
warning to driver developers that the dax core wants to own the
driver_data pointer for the hosting device of a dax_region. Add a
clarification.

Reported-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index d1641e69a088..c7b23d52f945 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -359,8 +359,13 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 {
 	struct dax_region *dax_region;
 
+	/*
+	 * The DAX core assumes that it can store its private data in
+	 * parent->driver_data. This WARN is a reminder / safeguard for
+	 * developers of device-dax drivers.
+	 */
 	if (dev_get_drvdata(parent)) {
-		dev_WARN(parent, "dax core found drvdata already in use\n");
+		dev_WARN(parent, "dax core failed to setup private data\n");
 		return NULL;
 	}
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
