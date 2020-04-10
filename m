Return-Path: <SRS0=eaei=52=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45AD2C2BA19
	for <linux-nvdimm@archiver.kernel.org>; Fri, 10 Apr 2020 03:15:47 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E569920A8B
	for <linux-nvdimm@archiver.kernel.org>; Fri, 10 Apr 2020 03:15:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E569920A8B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id C8D9C10113FDC;
	Thu,  9 Apr 2020 20:16:35 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=45.249.212.191; helo=huawei.com; envelope-from=wubo40@huawei.com; receiver=<UNKNOWN> 
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 3D6D1100DBB0B
	for <linux-nvdimm@lists.01.org>; Thu,  9 Apr 2020 20:16:33 -0700 (PDT)
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
	by Forcepoint Email with ESMTP id 3CA6BFADAEDEE277DF86
	for <linux-nvdimm@lists.01.org>; Fri, 10 Apr 2020 11:15:39 +0800 (CST)
Received: from [127.0.0.1] (10.173.221.252) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Fri, 10 Apr 2020
 11:15:29 +0800
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>
From: Wu Bo <wubo40@huawei.com>
Subject: [PATCH] nvdimm: cleanup resources when the initialization fails
Message-ID: <c9f9975c-b4ae-1234-56ed-dce4b052080d@huawei.com>
Date: Fri, 10 Apr 2020 11:15:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Language: en-US
X-Originating-IP: [10.173.221.252]
X-CFilter-Loop: Reflected
Message-ID-Hash: LUDQWMXGIMFSKXLX3XQR6YNFSVYZYDOI
X-Message-ID-Hash: LUDQWMXGIMFSKXLX3XQR6YNFSVYZYDOI
X-MailFrom: wubo40@huawei.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-nvdimm@lists.01.org, liuzhiqiang26@huawei.com, linfeilong@huawei.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/LUDQWMXGIMFSKXLX3XQR6YNFSVYZYDOI/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit

From: Wu Bo <wubo40@huawei.com>

When the initialization fails, add the cleanup resources
in pmem_attach_disk() function

Signed-off-by: Wu Bo <wubo40@huawei.com>
---
  drivers/nvdimm/pmem.c | 44 +++++++++++++++++++++++++++++++-------------
  1 file changed, 31 insertions(+), 13 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 2df6994..f235a59 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -383,7 +383,7 @@ static int pmem_attach_disk(struct device *dev,
         struct device *gendev;
         struct gendisk *disk;
         void *addr;
-       int rc;
+       int rc = -ENOMEM;
         unsigned long flags = 0UL;

         pmem = devm_kzalloc(dev, sizeof(*pmem), GFP_KERNEL);
@@ -392,14 +392,14 @@ static int pmem_attach_disk(struct device *dev,

         rc = devm_namespace_enable(dev, ndns, nd_info_block_reserve());
         if (rc)
-               return rc;
+               goto out_free_pmem;

         /* while nsio_rw_bytes is active, parse a pfn info block if 
present */
         if (is_nd_pfn(dev)) {
                 nd_pfn = to_nd_pfn(dev);
                 rc = nvdimm_setup_pfn(nd_pfn, &pmem->pgmap);
                 if (rc)
-                       return rc;
+                       goto out_free_pmem;
         }

         /* we're attaching a block device, disable raw namespace access */
@@ -417,12 +417,13 @@ static int pmem_attach_disk(struct device *dev,
         if (!devm_request_mem_region(dev, res->start, resource_size(res),
                                 dev_name(&ndns->dev))) {
                 dev_warn(dev, "could not reserve region %pR\n", res);
-               return -EBUSY;
+               rc = -EBUSY;
+               goto out_free_pmem;
         }

         q = blk_alloc_queue(pmem_make_request, dev_to_node(dev));
         if (!q)
-               return -ENOMEM;
+               goto out_realease_mem_region;

         pmem->pfn_flags = PFN_DEV;
         pmem->pgmap.ref = &q->q_usage_counter;
@@ -447,14 +448,16 @@ static int pmem_attach_disk(struct device *dev,
         } else {
                 if (devm_add_action_or_reset(dev, pmem_release_queue,
                                         &pmem->pgmap))
-                       return -ENOMEM;
+                       goto out_cleanup_queue;
                 addr = devm_memremap(dev, pmem->phys_addr,
                                 pmem->size, ARCH_MEMREMAP_PMEM);
                 memcpy(&bb_res, &nsio->res, sizeof(bb_res));
         }

-       if (IS_ERR(addr))
-               return PTR_ERR(addr);
+       if (IS_ERR(addr)) {
+               rc = PTR_ERR(addr);
+               goto out_cleanup_queue;
+       }
         pmem->virt_addr = addr;

         blk_queue_write_cache(q, true, fua);
@@ -468,7 +471,7 @@ static int pmem_attach_disk(struct device *dev,

         disk = alloc_disk_node(0, nid);
         if (!disk)
-               return -ENOMEM;
+               goto out_cleanup_queue;
         pmem->disk = disk;

         disk->fops              = &pmem_fops;
@@ -479,7 +482,7 @@ static int pmem_attach_disk(struct device *dev,
         set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
                         / 512);
         if (devm_init_badblocks(dev, &pmem->bb))
-               return -ENOMEM;
+               goto out_put_disk;
         nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_res);
         disk->bb = &pmem->bb;

@@ -487,8 +490,8 @@ static int pmem_attach_disk(struct device *dev,
                 flags = DAXDEV_F_SYNC;
         dax_dev = alloc_dax(pmem, disk->disk_name, &pmem_dax_ops, flags);
         if (IS_ERR(dax_dev)) {
-               put_disk(disk);
-               return PTR_ERR(dax_dev);
+               rc = PTR_ERR(dax_dev);
+               goto out_badblock_exit;
         }
         dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
         pmem->dax_dev = dax_dev;
@@ -497,7 +500,7 @@ static int pmem_attach_disk(struct device *dev,

         device_add_disk(dev, disk, NULL);
         if (devm_add_action_or_reset(dev, pmem_release_disk, pmem))
-               return -ENOMEM;
+               goto out_free_dax;

         revalidate_disk(disk);

@@ -507,6 +510,21 @@ static int pmem_attach_disk(struct device *dev,
                 dev_warn(dev, "'badblocks' notification disabled\n");

         return 0;
+
+out_free_dax:
+       del_gendisk(disk);
+       put_dax(dax_dev);
+out_badblock_exit:
+       badblocks_exit(&pmem->bb);
+out_put_disk:
+       put_disk(disk);
+out_cleanup_queue:
+       blk_cleanup_queue(q);
+out_realease_mem_region:
+       devm_release_mem_region(dev, res->start, resource_size(res));
+out_free_pmem:
+       devm_kfree(dev, pmem);
+       return rc;
  }

  static int nd_pmem_probe(struct device *dev)
--
1.8.3.1
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
