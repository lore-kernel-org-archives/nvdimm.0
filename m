Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C09B5211CFFC9
 for <linux-nvdimm@lists.01.org>; Mon,  4 Mar 2019 12:26:43 -0800 (PST)
Subject: [PATCH] libnvdimm/namespace: Clean up holder_class_store()
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 04 Mar 2019 12:14:04 -0800
Message-ID: <155173044436.4154095.17954771880753980013.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Use sysfs_streq() in place of open-coded strcmp()'s that check for an
optional "\n" at the end of the input.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/namespace_devs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 3677b0c4a33d..17fb7f931f0c 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1506,13 +1506,13 @@ static ssize_t __holder_class_store(struct device *dev, const char *buf)
 	if (dev->driver || ndns->claim)
 		return -EBUSY;
 
-	if (strcmp(buf, "btt") == 0 || strcmp(buf, "btt\n") == 0)
+	if (sysfs_streq(buf, "btt"))
 		ndns->claim_class = btt_claim_class(dev);
-	else if (strcmp(buf, "pfn") == 0 || strcmp(buf, "pfn\n") == 0)
+	else if (sysfs_streq(buf, "pfn"))
 		ndns->claim_class = NVDIMM_CCLASS_PFN;
-	else if (strcmp(buf, "dax") == 0 || strcmp(buf, "dax\n") == 0)
+	else if (sysfs_streq(buf, "dax"))
 		ndns->claim_class = NVDIMM_CCLASS_DAX;
-	else if (strcmp(buf, "") == 0 || strcmp(buf, "\n") == 0)
+	else if (sysfs_streq(buf, ""))
 		ndns->claim_class = NVDIMM_CCLASS_NONE;
 	else
 		return -EINVAL;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
