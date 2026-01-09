Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8122635B135
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962726; cv=none; b=IhTXlmc8UrCq/wPAwZpIc92y8ha4e+ZDf9JEeThfqw4rFm10L5PRVCsJRKevO5v62BURWbU9bNF6pFRL270TvUW2LrFfzY1FDPixKT4+c//5+teEQDG004t+krQ/EaiF+KaKmqL8tGe+6F59TO+HuQmt+N7dDbyeS6liZ5rVeJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962726; c=relaxed/simple;
	bh=AoRGNftAmC02ctoU04552onWjzNbxK1TWIBQGzW2rDE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=RNlAb7c1knUo8YjXCuS3zBcZR4E4wBCqIR7SLNPFbR1whN5BfzBexzDMqmbkDYeLpYftVcv53Citr7oRWaknA2Eq0Sl+ILQoK/psyvlquS97szCc52qSwul+PPRisZ5mLkI2GY6nCvmP1Ad2mxjCDy6/Hl66jOd60WqWXdTzRH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=tWlQ03Gw; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="tWlQ03Gw"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260109124522epoutp022f5aa9df35ca121724f12927c7c899de~JELq3D82U2083220832epoutp02l
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:45:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260109124522epoutp022f5aa9df35ca121724f12927c7c899de~JELq3D82U2083220832epoutp02l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767962722;
	bh=fcU13rdpIdlC2DLF99ubTX7jfe8rJBe3xxejaA55RRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tWlQ03GwgKuzNTd4+iLJjRTKkycFxuLjBYd/QI6l7g5jxQTtfSbTKFOtSVAk6B3id
	 U/CAO3yfqzret+03CTAA85cgQpl8DkXE0YUuCBfBlnOr9sjrvtuTP21gaRw91fENPk
	 p4Wp21gKIlMfxi22cX+zl5Ei/x4KPQhiO2MEudI0=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260109124522epcas5p1b3f49faa514c9ea4fdcff0d77e69fe8c~JELqpVNkI1268212682epcas5p17;
	Fri,  9 Jan 2026 12:45:22 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.91]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dnhM56Sp8z2SSKY; Fri,  9 Jan
	2026 12:45:21 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260109124521epcas5p299cea0eaef023816e18f5fd32d053224~JELpioP_v3225732257epcas5p20;
	Fri,  9 Jan 2026 12:45:21 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260109124520epsmtip1f2c89d44e5102b9892bc8e7882bcadf8~JELoYYipz0977809778epsmtip1m;
	Fri,  9 Jan 2026 12:45:20 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V5 08/17] nvdimm/label: Preserve cxl region information from
 region label
Date: Fri,  9 Jan 2026 18:14:28 +0530
Message-Id: <20260109124437.4025893-9-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260109124437.4025893-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260109124521epcas5p299cea0eaef023816e18f5fd32d053224
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260109124521epcas5p299cea0eaef023816e18f5fd32d053224
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124521epcas5p299cea0eaef023816e18f5fd32d053224@epcas5p2.samsung.com>

Preserve region information from region label during nvdimm_probe. This
preserved region information is used for creating cxl region to achieve
region persistency across reboot.
This patch supports interleave way == 1, it is therefore it preserves
only one region into LSA

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/dimm.c     |  4 ++++
 drivers/nvdimm/label.c    | 36 ++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd-core.h  |  2 ++
 drivers/nvdimm/nd.h       |  1 +
 include/linux/libnvdimm.h | 14 ++++++++++++++
 5 files changed, 57 insertions(+)

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
index 2ad148bfe40b..7adb415f0926 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -494,6 +494,42 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
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
+		uuid_t *region_uuid = (uuid_t *)&region_label->type;
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
index 92a8eabe0792..86837de7f183 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -580,6 +580,7 @@ void nvdimm_set_locked(struct device *dev);
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

