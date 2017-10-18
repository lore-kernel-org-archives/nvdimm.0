Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 558A521F38858
 for <linux-nvdimm@lists.01.org>; Wed, 18 Oct 2017 11:18:24 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2] dev/dax: fix uninitialized variable build warning
Date: Wed, 18 Oct 2017 12:21:55 -0600
Message-Id: <20171018182155.6054-1-ross.zwisler@linux.intel.com>
In-Reply-To: <CAPcyv4gNYekwo1DQ9fOCzdtixvAUn5YnZY0wKfxQaeRppwdUPQ@mail.gmail.com>
References: <CAPcyv4gNYekwo1DQ9fOCzdtixvAUn5YnZY0wKfxQaeRppwdUPQ@mail.gmail.com>
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
http://kisskb.ellerman.id.au/kisskb/buildresult/13181373/log/

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/dax/device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index e9f3b3e..6833ada 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -222,7 +222,8 @@ __weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
 		unsigned long size)
 {
 	struct resource *res;
-	phys_addr_t phys;
+	/* gcc-4.6.3-nolibc for i386 complains that this is uninitialized */
+	phys_addr_t uninitialized_var(phys);
 	int i;
 
 	for (i = 0; i < dev_dax->num_resources; i++) {
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
