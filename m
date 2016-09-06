Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A0F791A1E68
 for <linux-nvdimm@lists.01.org>; Tue,  6 Sep 2016 09:52:29 -0700 (PDT)
Subject: [PATCH 2/5] dax: fix offset to physical address translation
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 06 Sep 2016 09:49:31 -0700
Message-ID: <147318057109.30325.17721163157375660986.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147318056046.30325.5100892122988191500.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147318056046.30325.5100892122988191500.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In pgoff_to_phys() 'pgoff' is already relative to base of the dax
device, so we only need to compare if the current offset is within the
current resource extent.  Otherwise, we are double accounting the
resource start offset when translating pgoff to a physical address.

Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 29f600f2c447..4653f84cabe7 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -357,16 +357,18 @@ static int check_vma(struct dax_dev *dax_dev, struct vm_area_struct *vma,
 static phys_addr_t pgoff_to_phys(struct dax_dev *dax_dev, pgoff_t pgoff,
 		unsigned long size)
 {
+	phys_addr_t phys, offset;
 	struct resource *res;
-	phys_addr_t phys;
 	int i;
 
+	offset = pgoff * PAGE_SIZE;
 	for (i = 0; i < dax_dev->num_resources; i++) {
 		res = &dax_dev->res[i];
-		phys = pgoff * PAGE_SIZE + res->start;
-		if (phys >= res->start && phys <= res->end)
+		if (offset < resource_size(res)) {
+			phys = offset + res->start;
 			break;
-		pgoff -= PHYS_PFN(resource_size(res));
+		}
+		offset -= resource_size(res);
 	}
 
 	if (i < dax_dev->num_resources) {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
