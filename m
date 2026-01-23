Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14153783CA
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769167901; cv=none; b=g+ra5wgca6P6XnTjhoF2fna+5eQYSxjDdBRpj3HyBEsanMvmAMHj1golIERhMFQ0xF6a98whPjbZz34Nh4N2BXCW/1VIUfxA1ozhM4W1YuiKMB+/xHfYjW4DXTFuOEFExhPaJazWI+R9wChVey5ha3Lwo4SJSHTKlGB/W0RYo6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769167901; c=relaxed/simple;
	bh=bGIq3h9f5253GBcVTY5bbahGD6vngr120G7OmmB81Rs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=nbOPa1ipFNJear4eYKVMN4RRuSQiegjvJHmVbkvSmoyxlMmfVwinUQLG3YCAjIcb0wk8UnHrBq5qLp+DECNTYC9edYfBPgcLXoXhzEM68yVsau5Dho+HoPqvYQ952P0aEOhnKikdBf0eySqfkbkxzoG0Bc88afSLyMcO2Qj6zZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=KJ07aa0T; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KJ07aa0T"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260123113136epoutp0200c8c522a165168e0a50fe60ab0a0167~NWNQnz2sC0146201462epoutp02L
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260123113136epoutp0200c8c522a165168e0a50fe60ab0a0167~NWNQnz2sC0146201462epoutp02L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769167896;
	bh=ibDapUD922yChN15VjqbeuJ35JsJCtKJGDjUDOa1EuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJ07aa0TZiJqjfA3GAgb/Aa9Gp+WplTwZB/FDnQmCdF7UN91OfjO3P2L2PDNrB6tB
	 exMR1sIqsTEsZ+3SdQXKgb8WMaePqxBmEndOET0DRst2s/B+uxrZLgs8yjR0s3+OT/
	 g09iFZ75jaaPydxsIZkXaY9i41Cpf4PnV0VKdm/E=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260123113136epcas5p196907cb2ba431ed5e4b1b719343e1a8b~NWNQQ_UKu0266702667epcas5p1W;
	Fri, 23 Jan 2026 11:31:36 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.93]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dyG3W5bsHz6B9m6; Fri, 23 Jan
	2026 11:31:35 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260123113135epcas5p2b0e7d9651a5a78b5451daeb6b1e018d8~NWNPK4t-p1670216702epcas5p2f;
	Fri, 23 Jan 2026 11:31:35 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260123113133epsmtip242c314dc055e67241beefe4fa519e91a~NWNN3H5Z42621526215epsmtip22;
	Fri, 23 Jan 2026 11:31:33 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V6 08/18] nvdimm/label: Preserve cxl region information from
 region label
Date: Fri, 23 Jan 2026 17:01:02 +0530
Message-Id: <20260123113112.3488381-9-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260123113112.3488381-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260123113135epcas5p2b0e7d9651a5a78b5451daeb6b1e018d8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260123113135epcas5p2b0e7d9651a5a78b5451daeb6b1e018d8
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
	<CGME20260123113135epcas5p2b0e7d9651a5a78b5451daeb6b1e018d8@epcas5p2.samsung.com>

Preserve region information from region label during nvdimm_probe. This
preserved region information is used for creating cxl region to achieve
region persistency across reboot.
This patch supports interleave way == 1, it is therefore it preserves
only one region into LSA

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/dimm.c     |  4 ++++
 drivers/nvdimm/label.c    | 38 ++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd-core.h  |  2 ++
 drivers/nvdimm/nd.h       |  1 +
 include/linux/libnvdimm.h | 14 ++++++++++++++
 5 files changed, 59 insertions(+)

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
index 014af60d68a1..054dd4e47ab4 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -495,6 +495,44 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
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
+		union nd_lsa_label *lsa_label = to_lsa_label(ndd, slot);
+		struct cxl_region_label *region_label = &lsa_label->region_label;
+		uuid_t region_type_uuid;
+
+		import_uuid(&region_type_uuid, region_label->type);
+
+		/* TODO: Currently preserving only one region */
+		if (uuid_equal(&cxl_region_uuid, &region_type_uuid)) {
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
index ec856601fda0..578a828be918 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -585,6 +585,7 @@ void nvdimm_set_locked(struct device *dev);
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

