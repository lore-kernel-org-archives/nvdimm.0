Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6D57A2095D2CE
 for <linux-nvdimm@lists.01.org>; Wed, 18 Oct 2017 08:36:36 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/2] dev/dax: fix uninitialized variable build warning
Date: Wed, 18 Oct 2017 09:40:05 -0600
Message-Id: <20171018154006.15431-1-ross.zwisler@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-kernel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Fix this build warning:

warning: 'phys' may be used uninitialized in this function
[-Wuninitialized]

As reported here:

https://lkml.org/lkml/2017/10/16/152

This should have no functional change because you can only get into the if
statement in dax_pgoff_to_phys() that is complaining about 'phys' being
uninitialized if you broke out early in the above loop, in which case
'phys' will be set.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/dax/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index e9f3b3e..4aca0a2 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -222,7 +222,7 @@ __weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
 		unsigned long size)
 {
 	struct resource *res;
-	phys_addr_t phys;
+	phys_addr_t phys = 0;
 	int i;
 
 	for (i = 0; i < dev_dax->num_resources; i++) {
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
