Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <5643B043.3010103@plexistor.com>
Date: Wed, 11 Nov 2015 23:16:51 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [RFC 1/1] memremap: devm_memremap_pages has wrong nid
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


The pmem dev as received in devm_memremap_pages() does not have
its dev->numa_node properly initialized yet.

What I see is that all pmem devices will call arch_add_memory
with nid==0 regardless of the real nid the memory is actually
on. Needless to say that after that all the NUMA page and zone
members (at page->flags) come out wrong.

If I do the below code it will all work properly.

RFC because probably we want to fix dev->numa_node before the
call to devm_memremap_pages.

This is on top of v4.3. I will please need the final fix for Stable@

Thanks
Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 kernel/memremap.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/memremap.c b/kernel/memremap.c
index 9d6b555..9409e23 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -183,9 +183,7 @@ void *devm_memremap_pages(struct device *dev, struct resource *res)
 
 	memcpy(&page_map->res, res, sizeof(*res));
 
-	nid = dev_to_node(dev);
-	if (nid < 0)
-		nid = 0;
+	nid = memory_add_physaddr_to_nid(res->start);
 
 	error = arch_add_memory(nid, res->start, resource_size(res), true);
 	if (error) {
-- 
1.9.3

