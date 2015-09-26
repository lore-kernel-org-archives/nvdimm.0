Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 2/3] devm_memremap_pages: use numa_mem_id
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 25 Sep 2015 21:17:47 -0400
Message-ID: <20150926011747.2848.12543.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20150926011243.2848.82422.stgit@dwillia2-desk3.jf.intel.com>
References: <20150926011243.2848.82422.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tj@kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-nvdimm@lists.01.org, hch@lst.de, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hint to closest numa node for the placement of newly allocated pages.
As that is where the device's other allocations will originate by
default when it does not specify a NUMA node.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 kernel/memremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/memremap.c b/kernel/memremap.c
index 72b0c66628b6..86a5cdeb18f2 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -175,7 +175,7 @@ void *devm_memremap_pages(struct device *dev, struct resource *res)
 
 	nid = dev_to_node(dev);
 	if (nid < 0)
-		nid = 0;
+		nid = numa_mem_id();
 
 	error = arch_add_memory(nid, res->start, resource_size(res), true);
 	if (error) {

