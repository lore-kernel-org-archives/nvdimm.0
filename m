Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by ml01.01.org (Postfix) with ESMTP id 00AB5202E292C
 for <linux-nvdimm@lists.01.org>; Fri, 16 Aug 2019 04:20:47 -0700 (PDT)
From: Jia He <justin.he@arm.com>
Subject: [PATCH 1/2] drivers/dax/kmem: use default numa_mem_id if target_node
 is invalid
Date: Fri, 16 Aug 2019 19:18:43 +0800
Message-Id: <20190816111844.87442-2-justin.he@arm.com>
In-Reply-To: <20190816111844.87442-1-justin.he@arm.com>
References: <20190816111844.87442-1-justin.he@arm.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Cc: Jia He <justin.he@arm.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

In some platforms(e.g arm64 guest), the NFIT info might not be ready.
Then target_node might be -1. But if there is a default numa_mem_id(),
we can use it to avoid unnecessary fatal EINVL error.

devm_memremap_pages() also uses this logic if nid is invalid, we can
keep the same page with it.

Signed-off-by: Jia He <justin.he@arm.com>
---
 drivers/dax/kmem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index a02318c6d28a..ad62d551d94e 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -33,9 +33,9 @@ int dev_dax_kmem_probe(struct device *dev)
 	 */
 	numa_node = dev_dax->target_node;
 	if (numa_node < 0) {
-		dev_warn(dev, "rejecting DAX region %pR with invalid node: %d\n",
-			 res, numa_node);
-		return -EINVAL;
+		dev_warn(dev, "DAX %pR with invalid node, assume it as %d\n",
+				res, numa_node, numa_mem_id());
+		numa_node = numa_mem_id();
 	}
 
 	/* Hotplug starting at the beginning of the next block: */
-- 
2.17.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
