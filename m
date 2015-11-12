Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <56448FDE.4020404@plexistor.com>
Date: Thu, 12 Nov 2015 15:10:54 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH] nvdimm: proper NID in e820_pmem_probe
References: <5643B043.3010103@plexistor.com> <CAPcyv4jCg58-Je4hW=O4TT9ESeJTV-GFEUidLD9n60-z9w9V2Q@mail.gmail.com> <5643BB8D.4080202@plexistor.com>
In-Reply-To: <5643BB8D.4080202@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Stable Tree <stable@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

From: Dan Williams <dan.j.williams@intel.com>

[Boaz]
What I see is that in the call to arch_add_memory() nid==0 regardless of the
real NID the memory is actually on.

[Dan]
In the case of NFIT numa node should already be set, and in the
case of the memmap=ss!nn or e820-type-12 we can set the numa node
like this:

[Needed for v4.3]
CC: Stable Tree <stable@vger.kernel.org>
Tested-by: Boaz Harrosh <boaz@plexistor.com>
---
 drivers/nvdimm/e820.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/e820.c b/drivers/nvdimm/e820.c
index 8282db2..e40df8f 100644
--- a/drivers/nvdimm/e820.c
+++ b/drivers/nvdimm/e820.c
@@ -48,7 +48,7 @@ static int e820_pmem_probe(struct platform_device *pdev)
 		memset(&ndr_desc, 0, sizeof(ndr_desc));
 		ndr_desc.res = p;
 		ndr_desc.attr_groups = e820_pmem_region_attribute_groups;
-		ndr_desc.numa_node = NUMA_NO_NODE;
+		ndr_desc.numa_node = memory_add_physaddr_to_nid(p->start);
 		set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
 		if (!nvdimm_pmem_region_create(nvdimm_bus, &ndr_desc))
 			goto err;
-- 
1.9.3


