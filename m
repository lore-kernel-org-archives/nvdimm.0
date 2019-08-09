Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8549F21309D3D
 for <linux-nvdimm@lists.01.org>; Fri,  9 Aug 2019 01:25:14 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
 by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x798MW3m043883
 for <linux-nvdimm@lists.01.org>; Fri, 9 Aug 2019 04:22:43 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
 by mx0b-001b2d01.pphosted.com with ESMTP id 2u92w7ng0n-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Fri, 09 Aug 2019 04:22:43 -0400
Received: from localhost
 by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <aneesh.kumar@linux.ibm.com>;
 Fri, 9 Aug 2019 09:22:42 +0100
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH] nvdimm: Initialize bad block for volatile namespaces
Date: Fri,  9 Aug 2019 13:52:33 +0530
MIME-Version: 1.0
Message-Id: <20190809082233.32520-1-aneesh.kumar@linux.ibm.com>
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
To: dan.j.williams@intel.com
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

We do check for a bad block during namespace init and that use
region bad block list. We need to initialize the bad block
for volatile regions for this to work. We also observe a lockdep
warning as below because the lock is not initialized correctly
since we skip bad block init for volatile regions.

 INFO: trying to register non-static key.
 the code is fine but needs lockdep annotation.
 turning off the locking correctness validator.
 CPU: 2 PID: 1 Comm: swapper/0 Not tainted 5.3.0-rc1-15699-g3dee241c937e #149
 Call Trace:
 [c0000000f95cb250] [c00000000147dd84] dump_stack+0xe8/0x164 (unreliable)
 [c0000000f95cb2a0] [c00000000022ccd8] register_lock_class+0x308/0xa60
 [c0000000f95cb3a0] [c000000000229cc0] __lock_acquire+0x170/0x1ff0
 [c0000000f95cb4c0] [c00000000022c740] lock_acquire+0x220/0x270
 [c0000000f95cb580] [c000000000a93230] badblocks_check+0xc0/0x290
 [c0000000f95cb5f0] [c000000000d97540] nd_pfn_validate+0x5c0/0x7f0
 [c0000000f95cb6d0] [c000000000d98300] nd_dax_probe+0xd0/0x1f0
 [c0000000f95cb760] [c000000000d9b66c] nd_pmem_probe+0x10c/0x160
 [c0000000f95cb790] [c000000000d7f5ec] nvdimm_bus_probe+0x10c/0x240
 [c0000000f95cb820] [c000000000d0f844] really_probe+0x254/0x4e0
 [c0000000f95cb8b0] [c000000000d0fdfc] driver_probe_device+0x16c/0x1e0
 [c0000000f95cb930] [c000000000d10238] device_driver_attach+0x68/0xa0
 [c0000000f95cb970] [c000000000d1040c] __driver_attach+0x19c/0x1c0
 [c0000000f95cb9f0] [c000000000d0c4c4] bus_for_each_dev+0x94/0x130
 [c0000000f95cba50] [c000000000d0f014] driver_attach+0x34/0x50
 [c0000000f95cba70] [c000000000d0e208] bus_add_driver+0x178/0x2f0
 [c0000000f95cbb00] [c000000000d117c8] driver_register+0x108/0x170
 [c0000000f95cbb70] [c000000000d7edb0] __nd_driver_register+0xe0/0x100
 [c0000000f95cbbd0] [c000000001a6baa4] nd_pmem_driver_init+0x34/0x48
 [c0000000f95cbbf0] [c0000000000106f4] do_one_initcall+0x1d4/0x4b0
 [c0000000f95cbcd0] [c0000000019f499c] kernel_init_freeable+0x544/0x65c
 [c0000000f95cbdb0] [c000000000010d6c] kernel_init+0x2c/0x180
 [c0000000f95cbe20] [c00000000000b954] ret_from_kernel_thread+0x5c/0x68

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 drivers/nvdimm/region.c      | 4 ++--
 drivers/nvdimm/region_devs.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index 37bf8719a2a4..0f6978e72e7c 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -34,7 +34,7 @@ static int nd_region_probe(struct device *dev)
 	if (rc)
 		return rc;
 
-	if (is_nd_pmem(&nd_region->dev)) {
+	if (is_memory(&nd_region->dev)) {
 		struct resource ndr_res;
 
 		if (devm_init_badblocks(dev, &nd_region->bb))
@@ -123,7 +123,7 @@ static void nd_region_notify(struct device *dev, enum nvdimm_event event)
 		struct nd_region *nd_region = to_nd_region(dev);
 		struct resource res;
 
-		if (is_nd_pmem(&nd_region->dev)) {
+		if (is_memory(&nd_region->dev)) {
 			res.start = nd_region->ndr_start;
 			res.end = nd_region->ndr_start +
 				nd_region->ndr_size - 1;
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 20e265a534f8..8ce275e88492 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -632,7 +632,7 @@ static umode_t region_visible(struct kobject *kobj, struct attribute *a, int n)
 	if (!is_memory(dev) && a == &dev_attr_dax_seed.attr)
 		return 0;
 
-	if (!is_nd_pmem(dev) && a == &dev_attr_badblocks.attr)
+	if (!is_memory(dev) && a == &dev_attr_badblocks.attr)
 		return 0;
 
 	if (a == &dev_attr_resource.attr) {
-- 
2.21.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
