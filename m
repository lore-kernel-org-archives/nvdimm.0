Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB28B29B76F
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753877827; cv=none; b=TvBNCf2ZuAUKSKEaYhiAr6GOM6skfHhbeLXlqX17y1ef7EDgJ/NIf2oDa4qRsYBLGA/X4Fgy+yY3yCVGurx4ogBrdvDQRwQR0E7wATH4M1WywkvCQp0OVdKVV1lDeBzLeup4y/Mw1bHY8/u15f3wGssVuV7aVOAFZsYGhwD7EIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753877827; c=relaxed/simple;
	bh=B1BlkrpMw/y0riLZV2nqpxsZJMcBkNmEpMBZvcnhEhY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=CVhI+i8UjJ/SdT2PWiuJgk4ZIDZgfWGBJWZLSxsRnRF/LoxR7sdI+wWV/lKhJmVY6I1AA+ccLCAIzGz7gknLVNLjKMPLjLU2mUVBhkO1xdkmA4s00ZeiixrzIj8a8gC6I8oBG7+5Sx3+iOijXcFiB51B9nlg9iW34PdQe2MK4qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=lDFc1Hdr; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="lDFc1Hdr"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250730121703epoutp028410c2116fe4d75917e2c96b0b3968c7~XBpahwjV11755217552epoutp02o
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:17:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250730121703epoutp028410c2116fe4d75917e2c96b0b3968c7~XBpahwjV11755217552epoutp02o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753877823;
	bh=MuHZrmyLZ5UzKUMtPDtMozgeExUPPhlprWycEMNaFyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDFc1HdrO4bYZ2kqNUUDnt84II+jwqncQ3ult92eGTBAPuopIDFSvj5yoBnRpMur5
	 HxVYmLvL9Rq78uucfadU4Q2SH1xDLa5sBDvXPV5IBE4zmHmjBbLIIhJ/zXZ66MpIcO
	 q4ssHHYLFuhvNUA/HC6ELxzxs9+lvMz7W6fPbd6Y=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250730121703epcas5p4088f0f1a4b3fb8e428cc65d70eaee53e~XBpaOwbA90771107711epcas5p4r;
	Wed, 30 Jul 2025 12:17:03 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.93]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4bsWRf4bv6z6B9m8; Wed, 30 Jul
	2025 12:17:02 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250730121236epcas5p4b8939ed1bfff468c965a9dbd6bc261b6~XBlhzccnz0910609106epcas5p4Q;
	Wed, 30 Jul 2025 12:12:36 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250730121235epsmtip12e690e7f29b26df3d68b39d43915790c~XBlgwSscL0289802898epsmtip1Y;
	Wed, 30 Jul 2025 12:12:35 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V2 11/20] nvdimm/region_label: Export routine to fetch
 region information
Date: Wed, 30 Jul 2025 17:42:00 +0530
Message-Id: <20250730121209.303202-12-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250730121209.303202-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250730121236epcas5p4b8939ed1bfff468c965a9dbd6bc261b6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121236epcas5p4b8939ed1bfff468c965a9dbd6bc261b6
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121236epcas5p4b8939ed1bfff468c965a9dbd6bc261b6@epcas5p4.samsung.com>

cxl region information preserved from LSA need to be exported so as to
use by cxl driver for cxl region re-creation

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/dimm_devs.c | 18 ++++++++++++++++++
 include/linux/libnvdimm.h  |  2 ++
 2 files changed, 20 insertions(+)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 6149770c1b27..dece150580c4 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -280,6 +280,24 @@ void *nvdimm_provider_data(struct nvdimm *nvdimm)
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

