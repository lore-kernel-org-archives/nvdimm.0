Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2793B2AF0E
	for <nvdimm@lists.linux.dev>; Sat, 26 Oct 2024 01:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729905229; cv=none; b=JC5Rf//+jpCfpuC2/1KH07qw9DENiesqShnr0p1UHoks71mi89tC8djlsbVY3zifzNOzGWBBVnFoZRHJB6KuuGFV2GZfs/nxqn8k70/8irDmAqoLcmYRGGnGYgOFyOHZcFOMCapNdoW8kMP2Sjv37N28rbxe1UvEeV4dMTdniqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729905229; c=relaxed/simple;
	bh=Y/XuX765bGGu7TL5YDoQnr/Vu9W1Qtv7aT4fkiSdRrw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MVYIvjkDY2qB8q7MFL8LmQRJUntV1lItqmoPx2flZ+dW7F6/QZ13Z814Nmg03+xDKJ8lFOKxHfEBHoRewqq7CeNJr7BsWQuUkQ8xaD2P+tzD/DA8h+/G4R/y+Ryfje/P4TiplWMAU7AfZiHJ6u9i2XF/98ED7+xv5zVaw1jwP04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Xb1q44LtMzQsJG
	for <nvdimm@lists.linux.dev>; Sat, 26 Oct 2024 09:12:48 +0800 (CST)
Received: from kwepemk200016.china.huawei.com (unknown [7.202.194.82])
	by mail.maildlp.com (Postfix) with ESMTPS id 6384F18006C
	for <nvdimm@lists.linux.dev>; Sat, 26 Oct 2024 09:13:43 +0800 (CST)
Received: from huawei.com (10.67.174.78) by kwepemk200016.china.huawei.com
 (7.202.194.82) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 26 Oct
 2024 09:13:42 +0800
From: Yi Yang <yiyang13@huawei.com>
To: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>
CC: <nvdimm@lists.linux.dev>, <wangweiyang2@huawei.com>
Subject: [PATCH] nvdimm: fix possible null-ptr-deref in nd_dax_probe()
Date: Sat, 26 Oct 2024 01:06:22 +0000
Message-ID: <20241026010622.2641355-1-yiyang13@huawei.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemk200016.china.huawei.com (7.202.194.82)

It will cause null-ptr-deref when nd_dax_alloc() returns NULL, fix it by
add check for nd_dax_alloc().

Fixes: c5ed9268643c ("libnvdimm, dax: autodetect support")
Signed-off-by: Yi Yang <yiyang13@huawei.com>
---
 drivers/nvdimm/dax_devs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvdimm/dax_devs.c b/drivers/nvdimm/dax_devs.c
index 6b4922de3047..70a7e401f90d 100644
--- a/drivers/nvdimm/dax_devs.c
+++ b/drivers/nvdimm/dax_devs.c
@@ -106,6 +106,10 @@ int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns)
 
 	nvdimm_bus_lock(&ndns->dev);
 	nd_dax = nd_dax_alloc(nd_region);
+	if (!nd_dax) {
+		nvdimm_bus_unlock(&ndns->dev);
+		return -ENOMEM;
+	}
 	nd_pfn = &nd_dax->nd_pfn;
 	dax_dev = nd_pfn_devinit(nd_pfn, ndns);
 	nvdimm_bus_unlock(&ndns->dev);
-- 
2.25.1

