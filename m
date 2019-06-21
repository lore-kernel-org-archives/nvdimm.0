Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A9EB02129F0FA
 for <linux-nvdimm@lists.01.org>; Fri, 21 Jun 2019 04:45:22 -0700 (PDT)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] libnvdimm, namespace: Drop uuid_t implementation detail
Date: Fri, 21 Jun 2019 14:45:18 +0300
Message-Id: <20190621114518.56321-1-andriy.shevchenko@linux.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Keith Busch <keith.busch@intel.com>, Ira Weiny <ira.weiny@intel.com>, linux-nvdimm@lists.01.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

There is no need for caller to know how uuid_t type is constructed. Thus,
whenever we use it the implementation details are not needed. Drop it for good.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nvdimm/namespace_devs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index a434a5964cb9..2d8d7e554877 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1822,8 +1822,8 @@ static bool has_uuid_at_pos(struct nd_region *nd_region, u8 *uuid,
 					&& !guid_equal(&nd_set->type_guid,
 						&nd_label->type_guid)) {
 				dev_dbg(ndd->dev, "expect type_guid %pUb got %pUb\n",
-						nd_set->type_guid.b,
-						nd_label->type_guid.b);
+						&nd_set->type_guid,
+						&nd_label->type_guid);
 				continue;
 			}
 
@@ -2227,8 +2227,8 @@ static struct device *create_namespace_blk(struct nd_region *nd_region,
 	if (namespace_label_has(ndd, type_guid)) {
 		if (!guid_equal(&nd_set->type_guid, &nd_label->type_guid)) {
 			dev_dbg(ndd->dev, "expect type_guid %pUb got %pUb\n",
-					nd_set->type_guid.b,
-					nd_label->type_guid.b);
+					&nd_set->type_guid,
+					&nd_label->type_guid);
 			return ERR_PTR(-EAGAIN);
 		}
 
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
