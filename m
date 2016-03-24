Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 4D27C1A1EE4
 for <linux-nvdimm@lists.01.org>; Wed, 23 Mar 2016 18:27:17 -0700 (PDT)
Subject: [PATCH 10/13] libnvdimm, pmem: clean up resource print / request
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Mar 2016 18:26:13 -0700
Message-ID: <20160324012613.21436.14814.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160324012520.21436.22505.stgit@dwillia2-desk3.jf.intel.com>
References: <20160324012520.21436.22505.stgit@dwillia2-desk3.jf.intel.com>
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

The leading '0x' in front of %pa is redundant, also we can just use %pR
to simplify the print statement.  The request parameters can be directly
taken from the resource as well.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 97bc91b944b7..c9ae1673bb17 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -210,10 +210,9 @@ static struct pmem_device *pmem_alloc(struct device *dev,
 	if (!arch_has_wmb_pmem())
 		dev_warn(dev, "unable to guarantee persistence of writes\n");
 
-	if (!devm_request_mem_region(dev, pmem->phys_addr, pmem->size,
-			dev_name(dev))) {
-		dev_warn(dev, "could not reserve region [0x%pa:0x%zx]\n",
-				&pmem->phys_addr, pmem->size);
+	if (!devm_request_mem_region(dev, res->start, resource_size(res),
+				dev_name(dev))) {
+		dev_warn(dev, "could not reserve region %pR\n", res);
 		return ERR_PTR(-EBUSY);
 	}
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
