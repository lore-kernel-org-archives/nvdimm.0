Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5FA2EAD08
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750165213; cv=none; b=DccW/2pZMDEu0cD37mp4nDrHaDmfA50ImTqdpjAJ4kQjZ9w/tKY7tqs4qGrZ0mf6OdamxjMhBPnyoRaiAYXQVGL6jmH9VXNSG0qQXtGn2Vw660SPhsVfcA8fmjWi7wcZaRFt/5mOR5EGEO1ytVSo9HHI5VXTkX6QBONtX4PyRsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750165213; c=relaxed/simple;
	bh=Kqw4NcHeAPFF824Y1FY50dujNkF/2gH0ifUx+2L59+8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=rCxjl8/m2WxEkr83HaJKMnl5qzPIdIoVRJaWXsOnV5LF5LTkyp/RewPQUVwzaz2whS9Nb4bbvFmUJoeB3pBWyabBbYXgDKjTQgnRtziIlbvXnue7v+iIPKSwuv2wSgkP1RlBk36n5iM3eXtqaSrVKpg87bKk8GUV4szVh9qPv8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=fjmRc1QP; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fjmRc1QP"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250617130006epoutp0462d1cb388fe872329d78d932a5429413~J1ftxMVj02038020380epoutp04P
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:00:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250617130006epoutp0462d1cb388fe872329d78d932a5429413~J1ftxMVj02038020380epoutp04P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750165206;
	bh=MXXNuRg7jYTsPdqFM4Uww7As3p/djuanYKaC8skfGMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjmRc1QPPiLUQWILucwVweqLigqv2wo6st7q7y/UJ/hzOND0wqzs8IGLy118DcsyS
	 40IYiLPIPY2HkPBN/w112g7OUdDqdoTZQIce0MaepUvQS4t+jgTdltGrnt6j1IURlN
	 PKF1MQ/7T5BwluW/jM7hL8n8bJDmedLduT0kP5Ho=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250617130005epcas5p2d16b731579b0bebd82a9befd04a22c0c~J1ftNWRNi0820208202epcas5p2s;
	Tue, 17 Jun 2025 13:00:05 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bM6R93Rv0z3hhT9; Tue, 17 Jun
	2025 13:00:05 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250617124034epcas5p2f53c3cc21c51b7c176ad580d5d954c64~J1OqwhE0S0929709297epcas5p2n;
	Tue, 17 Jun 2025 12:40:34 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250617124031epsmtip25394d78db44b00514d4ab4805fc1e200~J1OoOZC9T2555425554epsmtip2I;
	Tue, 17 Jun 2025 12:40:31 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: dan.j.williams@intel.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, s.neeraj@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: [RFC PATCH 10/20] nvdimm/region_label: Preserve cxl region
 information from region label
Date: Tue, 17 Jun 2025 18:09:34 +0530
Message-Id: <680779399.221750165205474.JavaMail.epsvc@epcpadp1new>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250617123944.78345-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250617124034epcas5p2f53c3cc21c51b7c176ad580d5d954c64
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124034epcas5p2f53c3cc21c51b7c176ad580d5d954c64
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124034epcas5p2f53c3cc21c51b7c176ad580d5d954c64@epcas5p2.samsung.com>

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
index 8753b5cd91cc..da4f37f0ae3b 100644
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
index 3a870798a90c..6a94175e6bb6 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -471,6 +471,47 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
 	return 0;
 }
 
+int nvdimm_cxl_region_preserve(struct nvdimm_drvdata *ndd)
+{
+	struct nvdimm *nvdimm = to_nvdimm(ndd->dev);
+	struct cxl_pmem_region_params *params = &nvdimm->cxl_region_params;
+	struct nd_namespace_index *nsindex;
+	unsigned long *free;
+	u32 nslot, slot;
+
+	if (!preamble_current(ndd, &nsindex, &free, &nslot))
+		return 0; /* no label, nothing to preserve */
+
+	for_each_clear_bit_le(slot, free, nslot) {
+		struct nd_lsa_label *nd_label;
+		struct cxl_region_label *rg_label;
+		uuid_t rg_type, region_type;
+
+		nd_label = to_label(ndd, slot);
+		rg_label = &nd_label->rg_label;
+		uuid_parse(CXL_REGION_UUID, &region_type);
+		import_uuid(&rg_type, nd_label->rg_label.type);
+
+		/* REVISIT: Currently preserving only one region */
+		if (uuid_equal(&region_type, &rg_type)) {
+			nvdimm->is_region_label = true;
+			import_uuid(&params->uuid, rg_label->uuid);
+			params->flags = __le32_to_cpu(rg_label->flags);
+			params->nlabel = __le16_to_cpu(rg_label->nlabel);
+			params->position = __le16_to_cpu(rg_label->position);
+			params->dpa = __le64_to_cpu(rg_label->dpa);
+			params->rawsize = __le64_to_cpu(rg_label->rawsize);
+			params->hpa = __le64_to_cpu(rg_label->hpa);
+			params->slot = __le32_to_cpu(rg_label->slot);
+			params->ig = __le32_to_cpu(rg_label->ig);
+			params->align = __le32_to_cpu(rg_label->align);
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
index 86976a9e8a15..71eabf2db389 100644
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
index ca8256b31472..33a87924dfee 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -600,6 +600,7 @@ void nvdimm_set_locked(struct device *dev);
 void nvdimm_clear_locked(struct device *dev);
 int nvdimm_security_setup_events(struct device *dev);
 bool nvdimm_check_cxl_label_format(struct device *dev);
+int nvdimm_cxl_region_preserve(struct nvdimm_drvdata *ndd);
 #if IS_ENABLED(CONFIG_NVDIMM_KEYS)
 int nvdimm_security_unlock(struct device *dev);
 #else
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index b2e16914ab52..cdabb43a8a7f 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -106,6 +106,20 @@ struct nd_cmd_desc {
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


