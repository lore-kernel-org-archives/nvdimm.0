Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF6D1A76C2
	for <nvdimm@lists.linux.dev>; Wed, 31 Jul 2024 12:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722428943; cv=none; b=El0piXw9AA1xHZSwTX9YshvTHKPweS3En6JtghWoEfodONFPsTE6kCfZsnHwio6EkcmCjuNsbkdhASXlMJyLTQSSnJZdomY81/PQhCQR7KzBZEz58+TpYLI1fBY32gOf2SUYRpyzS+c3nxy/670LsL9Cbh+3iB2wfkLNdaIZcy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722428943; c=relaxed/simple;
	bh=tQkEMLicAtzugyMacODmoLe4eruRUJj7jwiJTgB10z8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oc5Mf6kromdRfKBakCWPP77TFbK6Ol/yIUHtk1rl9ZV2zsBr2djzYjbZsph4a1iLfYD/xtdL2Hpp2COXkh0GtXcJZM2ObHuVZD4vdTQX0hRDykhF6279xrQgH9cAN7hgUo8WfsWQ/+6rVwI7Q2gwMYRTsv2bPnmk7Vpc7kgRfhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WYrvF6NC4zgYWY;
	Wed, 31 Jul 2024 20:27:05 +0800 (CST)
Received: from kwepemm000013.china.huawei.com (unknown [7.193.23.81])
	by mail.maildlp.com (Postfix) with ESMTPS id 6A483180101;
	Wed, 31 Jul 2024 20:28:56 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm000013.china.huawei.com
 (7.193.23.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 31 Jul
 2024 20:28:55 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <hch@lst.de>, <ira.weiny@intel.com>,
	<dlemoal@kernel.org>, <hare@suse.de>, <axboe@kernel.dk>
CC: <nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] nvdimm/pmem: Set dax flag for all 'PFN_MAP' cases
Date: Wed, 31 Jul 2024 20:25:30 +0800
Message-ID: <20240731122530.3334451-1-chengzhihao1@huawei.com>
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

The dax is only supportted on pfn type pmem devices since commit
f467fee48da4 ("block: move the dax flag to queue_limits"), fix it
by adding dax flag setting for the missed case.

Fixes: f467fee48da4 ("block: move the dax flag to queue_limits")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
---
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

