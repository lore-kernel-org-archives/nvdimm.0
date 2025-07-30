Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DC429B224
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753877824; cv=none; b=FyUsjGYEDoxvoX9vvijMJ1KxxBkFmy5TLikoyjkJr3+AR04IrkD05h5L+F7Z0vym4v6+xZgqQI9Uw9yATi+FBHgVNS0uwBc1egjDnXDBywG1AdH/TKlJznoW/3V73mNsANmEnbIi04v4HighpNDe/Jie/n8YMQUKUt91XSymjjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753877824; c=relaxed/simple;
	bh=cAI4HgAcyANzlqF6vf9n8x36gM4LL99tBVWTms90U/M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=MeYh2m4X798Iu6qS6Lx5xgJm2O2wvnzKJphKEZ5vI7ysdqNkFfpPpJrt2QnTAUNCMevnwqSudBcWqDfmU5wpOfmmycmllLgFwP28yclLS6KCJVuVFcEPK4hDauDMMjvGP0FoXAuse6yipNMPq5tPHdGSarpMAcCljNsYIacorPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=K/awwsZI; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="K/awwsZI"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250730121659epoutp02be481fd7fe31a57df2e7df348f41f06a~XBpWpuSss1755417554epoutp023
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:16:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250730121659epoutp02be481fd7fe31a57df2e7df348f41f06a~XBpWpuSss1755417554epoutp023
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753877819;
	bh=o2Y7bjWvc3s0WVT3hWKqGxRvZqdn+7ukryqyUf18rIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/awwsZIACiP2eEGt2LruQt9CDENWz2wq0bUcV/W5ttqUMYNY61RKJd6gwTtOtxnT
	 GE4UH0UfDXm9aTG+et4LJahPstU3CpgHz6PDlzFnR01F8rI9GWJqUiRw442CxJaztL
	 xaz2MV+FEQVztN5OSaKZz6DbfySysK26XRMnTL90=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250730121659epcas5p32473894abc298838806499dd3b660109~XBpWPU2ka0781707817epcas5p3P;
	Wed, 30 Jul 2025 12:16:59 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.89]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4bsWRZ2P9sz6B9mB; Wed, 30 Jul
	2025 12:16:58 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250730121235epcas5p4494147524e77e99bc16d9b510e8971a4~XBlghH0m60910709107epcas5p4O;
	Wed, 30 Jul 2025 12:12:35 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250730121234epsmtip16992c0bbf3bf81b85aafdf8f9d13bdd3~XBlfeCUPg0197501975epsmtip17;
	Wed, 30 Jul 2025 12:12:34 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V2 10/20] nvdimm/region_label: Preserve cxl region
 information from region label
Date: Wed, 30 Jul 2025 17:41:59 +0530
Message-Id: <20250730121209.303202-11-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250730121209.303202-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250730121235epcas5p4494147524e77e99bc16d9b510e8971a4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121235epcas5p4494147524e77e99bc16d9b510e8971a4
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121235epcas5p4494147524e77e99bc16d9b510e8971a4@epcas5p4.samsung.com>

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
index 064a945dcdd1..bcac05371f87 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -473,6 +473,47 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
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
index 4145c7df2a8f..f78c8fc1de8a 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -598,6 +598,7 @@ void nvdimm_set_locked(struct device *dev);
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

