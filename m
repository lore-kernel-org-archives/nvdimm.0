Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF5678F2E
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750165647; cv=none; b=q+VGuuqhLmGxeXntnRoGcbuT27pDH15i9XtW+sxLZs9yB8I0mgIICE1jVaxwnEoyRWD4UYSU+EPU5I8nUqVsfhOvLfKg94W7kJ6R0XhRYxhJKOdOGIT4GWuW+iHvjkttWVgPrbrDid0IBxN23XRQJ2uGPXqjKAQ3vbw5Va3Cb7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750165647; c=relaxed/simple;
	bh=j36Zta3izKvKxPSQvXAlWrAFcq3pvsGWqUpxUn+IHaA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Xn4eNAUuyfC1tPt5fGdnsMhAjSlkLKGfj+V+PK2QN75czd3AsbM4HsK4tZrjf8KXytB8Djo5FZnBf3khOBPC1mK2w8c7tLrYxad7BUAXSb60roFl9ybVyjWPy+mg1/DEDBolFQ51jZIOBZrKTKoF+5w9HAOkfVJ79t8Of4c5ufg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QCxAKO3r; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QCxAKO3r"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250617130006epoutp0253cd2f0a7d11963d93783e5f6b1a8b17~J1fuIizBr2353723537epoutp02J
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:00:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250617130006epoutp0253cd2f0a7d11963d93783e5f6b1a8b17~J1fuIizBr2353723537epoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750165206;
	bh=p/dqSkNurVPjaHecprDGz3Q7UCZTQntvnPImFH09uak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QCxAKO3rqCs6zXqbnXeRbqOr/kswRZw7Je1feadMowKqEQCakrclqiNF1C1KWztJb
	 M5JOd0ZmGi1sn053MrJZGxe1G1QbvJXYbvE8GhlLglSJTHAztwF/v+EquRsvJcYZJF
	 nnlViZtVLCx9UzTMYvMlo2zU43vhObpuePjaOfmI=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250617130005epcas5p1eb3c1872102cbf29b2677c75d352e79d~J1fthDYmL2452824528epcas5p1r;
	Tue, 17 Jun 2025 13:00:05 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bM6R95pvkz3hhT7; Tue, 17 Jun
	2025 13:00:05 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250617124037epcas5p2efa5e8ac19df70cdeb7330404eed385f~J1OtftcNc0930409304epcas5p2u;
	Tue, 17 Jun 2025 12:40:37 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250617124034epsmtip26c7fab31e6dc2ec8ac78c94bee6a01dd~J1Oq-xB2b2558225582epsmtip2C;
	Tue, 17 Jun 2025 12:40:34 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: dan.j.williams@intel.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, s.neeraj@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: [RFC PATCH 11/20] nvdimm/region_label: Export routine to fetch
 region information
Date: Tue, 17 Jun 2025 18:09:35 +0530
Message-Id: <1353170030.261750165205802.JavaMail.epsvc@epcpadp1new>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250617123944.78345-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250617124037epcas5p2efa5e8ac19df70cdeb7330404eed385f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124037epcas5p2efa5e8ac19df70cdeb7330404eed385f
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124037epcas5p2efa5e8ac19df70cdeb7330404eed385f@epcas5p2.samsung.com>

cxl region information preserved from LSA need to be exported so as to
use by cxl driver for cxl region re-creation

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/dimm_devs.c | 18 ++++++++++++++++++
 include/linux/libnvdimm.h  |  2 ++
 2 files changed, 20 insertions(+)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index e8f545f889fd..0edcb6b558e5 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -283,6 +283,24 @@ void *nvdimm_provider_data(struct nvdimm *nvdimm)
 }
 EXPORT_SYMBOL_GPL(nvdimm_provider_data);
 
+bool nvdimm_has_cxl_region(struct nvdimm *nvdimm)
+{
+	if (nvdimm)
+		return nvdimm->is_region_label;
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(nvdimm_has_cxl_region);
+
+void *nvdimm_get_cxl_region_param(struct nvdimm *nvdimm)
+{
+	if (nvdimm)
+		return &nvdimm->cxl_region_params;
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(nvdimm_get_cxl_region_param);
+
 static ssize_t commands_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index cdabb43a8a7f..9a5d17c4b89b 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -325,6 +325,8 @@ int nvdimm_in_overwrite(struct nvdimm *nvdimm);
 bool is_nvdimm_sync(struct nd_region *nd_region);
 int nd_region_label_update(struct nd_region *nd_region);
 int nd_region_label_delete(struct nd_region *nd_region);
+bool nvdimm_has_cxl_region(struct nvdimm *nvdimm);
+void *nvdimm_get_cxl_region_param(struct nvdimm *nvdimm);
 
 static inline int nvdimm_ctl(struct nvdimm *nvdimm, unsigned int cmd, void *buf,
 		unsigned int buf_len, int *cmd_rc)
-- 
2.34.1


