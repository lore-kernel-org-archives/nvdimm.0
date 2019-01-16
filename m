Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 80A77211AEA44
 for <linux-nvdimm@lists.01.org>; Tue, 15 Jan 2019 22:52:11 -0800 (PST)
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: [PATCH] libnvdimm,
 namespace: check nsblk->uuid immediately after its allocation
Date: Wed, 16 Jan 2019 14:51:44 +0800
Message-Id: <20190116065144.3499-1-richardw.yang@linux.intel.com>
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
Cc: zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

When creating nd_namespace_blk, its uuid is copied from nd_label->uuid.
In case the memory allocation fails, it goes to the error branch.

This check is better to be done immediately after memory allocation,
while current implementation does this after assigning claim_class.

This patch moves the check immediately after uuid allocation.

Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
---
 drivers/nvdimm/namespace_devs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 681af3a8fd62..9471b9ca04f5 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -2240,11 +2240,11 @@ static struct device *create_namespace_blk(struct nd_region *nd_region,
 	nsblk->lbasize = __le64_to_cpu(nd_label->lbasize);
 	nsblk->uuid = kmemdup(nd_label->uuid, NSLABEL_UUID_LEN,
 			GFP_KERNEL);
+	if (!nsblk->uuid)
+		goto blk_err;
 	if (namespace_label_has(ndd, abstraction_guid))
 		nsblk->common.claim_class
 			= to_nvdimm_cclass(&nd_label->abstraction_guid);
-	if (!nsblk->uuid)
-		goto blk_err;
 	memcpy(name, nd_label->name, NSLABEL_NAME_LEN);
 	if (name[0])
 		nsblk->alt_name = kmemdup(name, NSLABEL_NAME_LEN,
-- 
2.19.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
