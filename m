Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42365328973
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758115851; cv=none; b=cILXpU51cE26Do6/dqF2oUqGtjyNhBsAv12V83wR6ySanXUw2YVR8E6fMUOKJOhf8Dk0qlXgd+bb+uHbN1Ad1Qgu9k8cZvCNfd/1HYbhM4R6xqBZJ0pmSDC2yZ1JfY8ir1qI658klMt3y8XAr+/+C2+UscuSdp0RDmIPgw8v0wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758115851; c=relaxed/simple;
	bh=WBnAmooK9dbHr1obbST6yNo1GwSVNRQTXn1AF3hPqHo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=RXJV9R19rcgbs4W2uk4Q496kZIs1sIjEo3TYzFO4wR2Ugv9gmaR+dEc/j52KaHxQrFj7ZSSfCkq/1CSM444xQztwf++LsYS88zd9/VeR/nykIMisoipL/1U1vhRiuxTIajDGHRW7sxt6I/XVyL2pHAi87lX1sb4a7nqdJZjR8mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=MUBMW9pV; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MUBMW9pV"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250917133047epoutp010c977f653d6fb0ed58db9eae57ea8574~mFQxxptlz2069720697epoutp01p
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250917133047epoutp010c977f653d6fb0ed58db9eae57ea8574~mFQxxptlz2069720697epoutp01p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758115847;
	bh=jKNEAlEwR61MDjdL+446RjbQx5LOJGoeYbxBJtUMFuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MUBMW9pVCAVRLed6y895Lzh+IhPDt8q7yO0eU7l6YJxHmkLYrM/FMTJvtBtOKnKc/
	 Bjol/rMb98Qrb0/0sKvFJLHxq+vX2RGNcrrPVAg4ThIYHO8ndc0TwdMJZuADodUb7i
	 lzRqJ0BKkL/PymQxm7VE7rNtNhbzjSTuEZBAWDBs=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250917133047epcas5p3686be3e09219ebd926f95b5ed65810be~mFQxePe4k1910319103epcas5p35;
	Wed, 17 Sep 2025 13:30:47 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.90]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cRfm62rnkz3hhT3; Wed, 17 Sep
	2025 13:30:46 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250917133045epcas5p296904c722653caa296113c54cb18cf42~mFQwI38qu0995709957epcas5p2e;
	Wed, 17 Sep 2025 13:30:45 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250917133044epsmtip18f0896df2a72d206934abe8a5a960cf6~mFQvFj0hA0457804578epsmtip1X;
	Wed, 17 Sep 2025 13:30:44 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V3 11/20] nvdimm/region_label: Preserve cxl region
 information from region label
Date: Wed, 17 Sep 2025 18:59:31 +0530
Message-Id: <20250917132940.1566437-12-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917132940.1566437-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917133045epcas5p296904c722653caa296113c54cb18cf42
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917133045epcas5p296904c722653caa296113c54cb18cf42
References: <20250917132940.1566437-1-s.neeraj@samsung.com>
	<CGME20250917133045epcas5p296904c722653caa296113c54cb18cf42@epcas5p2.samsung.com>

Preserve region information from region label during nvdimm_probe. This
preserved region information is used for creating cxl region to achieve
region persistency across reboot.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/dimm.c     |  4 ++++
 drivers/nvdimm/label.c    | 41 +++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd-core.h  |  2 ++
 drivers/nvdimm/nd.h       |  1 +
 include/linux/libnvdimm.h | 14 +++++++++++++
 5 files changed, 62 insertions(+)

diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
index bda22cb94e5b..30fc90591093 100644
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
index 935a0df5b47e..3250e3ecd973 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -473,6 +473,47 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
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
+		union nd_lsa_label *nd_label;
+		struct cxl_region_label *region_label;
+		uuid_t rg_type, region_type;
+
+		nd_label = (union nd_lsa_label *) to_label(ndd, slot);
+		region_label = &nd_label->region_label;
+		uuid_parse(CXL_REGION_UUID, &region_type);
+		import_uuid(&rg_type, nd_label->region_label.type);
+
+		/* TODO: Currently preserving only one region */
+		if (uuid_equal(&region_type, &rg_type)) {
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
index c985f91728dd..2d0f6dd64c52 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -593,6 +593,7 @@ void nvdimm_set_locked(struct device *dev);
 void nvdimm_clear_locked(struct device *dev);
 int nvdimm_security_setup_events(struct device *dev);
 bool nvdimm_check_region_label_format(struct device *dev);
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

