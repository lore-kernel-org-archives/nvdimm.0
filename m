Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E138C2FB2
	for <nvdimm@lists.linux.dev>; Fri,  9 Aug 2024 03:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723173358; cv=none; b=ol8R+VZ6Bgrq+5f15bm8/bH7JVM63kKoRvxu8uVK+yUObTR2BT/U2wVjjp4cC0ByPY3nSvgBoAc3FvtBgLIIffoUMmE2W9xw6T+WqODsKkZ2idhF3blvrcp20fyzBBNx14KXC8MjvH5f39wmHx5s7ek7fcqlFYtxqevgAQQFbsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723173358; c=relaxed/simple;
	bh=Oh5lejLIb/SrEcRALkzm4fLHV3Xhgsmvct6vupFhCXM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KJbMLTU6kyDUUhW0dqHbwVxQPN63aUmFdRdQzKnDmsC/czSZQKqozBBXqwz9e3XCrCP7YzlRK60DsvVkUkzxzRVnKnaGif6XIf/nmOpYmrrlJQpF2Lz8ePcBxpHTz1rx9QH9wkSmw3xAFUOcO7FxE+SQ/HiINHpx5Vdgh4bsbs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Wg8Df1rTZzyP5D;
	Fri,  9 Aug 2024 11:15:30 +0800 (CST)
Received: from kwepemm000013.china.huawei.com (unknown [7.193.23.81])
	by mail.maildlp.com (Postfix) with ESMTPS id 47D261800FF;
	Fri,  9 Aug 2024 11:15:53 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm000013.china.huawei.com
 (7.193.23.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 9 Aug
 2024 11:15:52 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>, <hch@lst.de>,
	<alison.schofield@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] nvdimm/pmem: Set dax flag for all 'PFN_MAP' cases
Date: Fri, 9 Aug 2024 11:11:55 +0800
Message-ID: <20240809031155.2837271-1-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm000013.china.huawei.com (7.193.23.81)

The dax is only supported on pfn type pmem devices since commit
f467fee48da4 ("block: move the dax flag to queue_limits"). Trying
to mount DAX filesystem fails with this error:
 mount: : wrong fs type, bad option, bad superblock on /dev/pmem7,
          missing codepage or helper program, or other error.
 dmesg(1) may have more information after failed mount system call.
 dmesg: EXT4-fs (pmem7): DAX unsupported by block device.

Fix the problem by adding dax flag setting for the missed case.

Fixes: f467fee48da4 ("block: move the dax flag to queue_limits")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Tested-by: Ira Weiny <ira.weiny@intel.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
---
 v1->v2: Update commit msg according to Alison's suggestion, add error
         message.
 drivers/nvdimm/pmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 1ae8b2351654..210fb77f51ba 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -498,7 +498,7 @@ static int pmem_attach_disk(struct device *dev,
 	}
 	if (fua)
 		lim.features |= BLK_FEAT_FUA;
-	if (is_nd_pfn(dev))
+	if (is_nd_pfn(dev) || pmem_should_map_pages(dev))
 		lim.features |= BLK_FEAT_DAX;
 
 	if (!devm_request_mem_region(dev, res->start, resource_size(res),
-- 
2.39.2

