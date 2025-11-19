Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F20431B133
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763538808; cv=none; b=AclPDAXPPwdHI5IkNgJXJ8/2aee523+Qupp25M+BY2wQT2ipcWuGvu5IQgtpW1IngbMGJMXiMl0u8SEvum2ecdCsSewNljB13tK8m5xqyTLg2gucJzCx0meWhhIUzEq70VyZKF/1d/RBk8iWFeqx3RHvItldOlkAOi115lHqFoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763538808; c=relaxed/simple;
	bh=oAcaU2hpucQZNGlisFd1k5yBX0F8qMiXFExPoQHvt8E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Lq0Zv5BmbHxIGgV6YIuV3I23ZxX2KQXQkDv4HV5OJU9lh35h7ag+9x/mHlxc4FeE547JFqWWvnKQrzasZxfozgqF18FjZel/63bPvYZdmqTLaLWiG1Nrzlk5wMRl63Yp04epJIsTaVWY0xDXG04B8wRzyrr6axpVV7RnjKHy/4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ci1r5zCi; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ci1r5zCi"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251119075323epoutp03e1e45390cb78050643776f1e2529ada1~5WTLOD5gS2947829478epoutp03V
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251119075323epoutp03e1e45390cb78050643776f1e2529ada1~5WTLOD5gS2947829478epoutp03V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1763538803;
	bh=SkwP4HhOpRTbS1pQ24chsgXJFLDk7ZKuo9B0djks+YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ci1r5zCiA4bFeeNRW1OvNOb3dNUgiCL+eBZRXSzoRpAo1DsBpWEDdh/5sBrJw/adj
	 ygwRX1KFomI/33OdBfZceoEtoAHkjSraGkmfErTkQbV7ra2A631+B4rc4qf2oCc3Rc
	 BwH45h3I9oTdisSnyrdR6WNHzhlLz2UPv+a6SCZg=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20251119075322epcas5p4c069d89c40b91a90d194960f64210a66~5WTKP5G7M0334103341epcas5p4S;
	Wed, 19 Nov 2025 07:53:22 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.93]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dBDHj56QMz6B9m7; Wed, 19 Nov
	2025 07:53:21 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20251119075321epcas5p19665a54028ce13d8c1af3f00c0834fc7~5WTIyWZw-2708227082epcas5p1M;
	Wed, 19 Nov 2025 07:53:21 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251119075319epsmtip170c5bc491ea2854fec5450bbbba71ab7~5WTHeoRgi2565625656epsmtip1W;
	Wed, 19 Nov 2025 07:53:19 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V4 08/17] nvdimm/label: Preserve cxl region information from
 region label
Date: Wed, 19 Nov 2025 13:22:46 +0530
Message-Id: <20251119075255.2637388-9-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251119075255.2637388-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251119075321epcas5p19665a54028ce13d8c1af3f00c0834fc7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251119075321epcas5p19665a54028ce13d8c1af3f00c0834fc7
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075321epcas5p19665a54028ce13d8c1af3f00c0834fc7@epcas5p1.samsung.com>

Preserve region information from region label during nvdimm_probe. This
preserved region information is used for creating cxl region to achieve
region persistency across reboot.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/dimm.c     |  4 ++++
 drivers/nvdimm/label.c    | 40 +++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd-core.h  |  2 ++
 drivers/nvdimm/nd.h       |  1 +
 include/linux/libnvdimm.h | 14 ++++++++++++++
 5 files changed, 61 insertions(+)

diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
index 07f5c5d5e537..590ec883903d 100644
--- a/drivers/nvdimm/dimm.c
+++ b/drivers/nvdimm/dimm.c
@@ -107,6 +107,10 @@ static int nvdimm_probe(struct device *dev)
 	if (rc)
 		goto err;
 
+	/* Preserve cxl region info if available */
+	if (ndd->cxl)
+		nvdimm_cxl_region_preserve(ndd);
+
 	return 0;
 
  err:
diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index da55ecd95e2f..0f8aea61b504 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -490,6 +490,46 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
 	return 0;
 }
 
+int nvdimm_cxl_region_preserve(struct nvdimm_drvdata *ndd)
+{
+	struct nvdimm *nvdimm = to_nvdimm(ndd->dev);
+	struct cxl_pmem_region_params *p = &nvdimm->cxl_region_params;
+	struct nd_namespace_index *nsindex;
+	unsigned long *free;
+	u32 nslot, slot;
+
+	if (!preamble_current(ndd, &nsindex, &free, &nslot))
+		return 0; /* no label, nothing to preserve */
+
+	for_each_clear_bit_le(slot, free, nslot) {
+		union nd_lsa_label *lsa_label;
+		struct cxl_region_label *region_label;
+		uuid_t *region_uuid;
+
+		lsa_label = to_lsa_label(ndd, slot);
+		region_label = &lsa_label->region_label;
+		region_uuid = (uuid_t *) &region_label->type;
+
+		/* TODO: Currently preserving only one region */
+		if (uuid_equal(&cxl_region_uuid, region_uuid)) {
+			nvdimm->is_region_label = true;
+			import_uuid(&p->uuid, region_label->uuid);
+			p->flags = __le32_to_cpu(region_label->flags);
+			p->nlabel = __le16_to_cpu(region_label->nlabel);
+			p->position = __le16_to_cpu(region_label->position);
+			p->dpa = __le64_to_cpu(region_label->dpa);
+			p->rawsize = __le64_to_cpu(region_label->rawsize);
+			p->hpa = __le64_to_cpu(region_label->hpa);
+			p->slot = __le32_to_cpu(region_label->slot);
+			p->ig = __le32_to_cpu(region_label->ig);
+			p->align = __le32_to_cpu(region_label->align);
+			break;
+		}
+	}
+
+	return 0;
+}
+
 int nd_label_data_init(struct nvdimm_drvdata *ndd)
 {
 	size_t config_size, read_size, max_xfer, offset;
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index bfc6bfeb6e24..a73fac81531e 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -46,6 +46,8 @@ struct nvdimm {
 	} sec;
 	struct delayed_work dwork;
 	const struct nvdimm_fw_ops *fw_ops;
+	bool is_region_label;
+	struct cxl_pmem_region_params cxl_region_params;
 };
 
 static inline unsigned long nvdimm_security_flags(
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index b241a0b2e314..281d30dd9ba0 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -600,6 +600,7 @@ void nvdimm_set_locked(struct device *dev);
 void nvdimm_clear_locked(struct device *dev);
 int nvdimm_security_setup_events(struct device *dev);
 bool nvdimm_region_label_supported(struct device *dev);
+int nvdimm_cxl_region_preserve(struct nvdimm_drvdata *ndd);
 #if IS_ENABLED(CONFIG_NVDIMM_KEYS)
 int nvdimm_security_unlock(struct device *dev);
 #else
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index bbf14a260c93..07ea2e3f821a 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -108,6 +108,20 @@ struct nd_cmd_desc {
 	int out_sizes[ND_CMD_MAX_ELEM];
 };
 
+struct cxl_pmem_region_params {
+	uuid_t uuid;
+	u32 flags;
+	u16 nlabel;
+	u16 position;
+	u64 dpa;
+	u64 rawsize;
+	u64 hpa;
+	u32 slot;
+	u32 ig;
+	u32 align;
+	int nr_targets;
+};
+
 struct nd_interleave_set {
 	/* v1.1 definition of the interleave-set-cookie algorithm */
 	u64 cookie1;
-- 
2.34.1

