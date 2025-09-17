Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C2332898E
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758116504; cv=none; b=h3a6KBbpLTTWRMmDqOCXsG29g4pKHOl2JjRu0hfeNnmK1ECqUnLInwESn+UIyrBG7IrksUe/ywUsD0dT7bYJ3exYU5pBMUiUjrOCL93fX/NIVERh9od0IBPcCt4WetOPphsLjGg0jkpYnbqHr9YpftxRuQ1xgVtxeOC3fEvkLcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758116504; c=relaxed/simple;
	bh=RkAsuDKxc8445mRlXvsnxqnd4Yo1V+gjETT/kjelF7E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=VM7wBZc0fPqm8cGgE6KK0f7maTZRubJBzOnBlPfY9kJwaR/LdbB1oT5t17nTnmxhTSrTLl1m3yiRrQ40xeqszL3pdjaGtxRISCf//33sg7Pzi25N+tv9LZpeXBvN9KpR4VrhCru/QzbON7z6cqEBuogVuos/cqKYcM7rtCUVMwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=fTs5Jtxs; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fTs5Jtxs"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250917134140epoutp02922c14f93bcdf784ab93603287942815~mFaRaq6eR1572615726epoutp02B
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:41:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250917134140epoutp02922c14f93bcdf784ab93603287942815~mFaRaq6eR1572615726epoutp02B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758116500;
	bh=L8I4pczPLL+3fGYbV4VkM8e4qH7d3Y7IhMKieoHkqSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fTs5JtxsiQRaFXydTJiV4zst3ukA041MWmAvs+0zMxGqNVzul1nrZhfFtq0ChexiV
	 Y1u5ta6nD0WXipTFpwXJpmDFkATx3lEoSEKQ6de1rViBZBO0Sp9+F7Mr8c5ZBeUMY/
	 0EO9hCN1oTieZ5sNfuG7PUYBF9FTIU8Rgx5zC4p0=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250917134139epcas5p17de75f6f34fd82c902ad860ef9d803e0~mFaQ6us6f1744017440epcas5p1J;
	Wed, 17 Sep 2025 13:41:39 +0000 (GMT)
Received: from epdlp11prp10 (unknown [182.195.38.95]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cRg0f4z8Gz6B9m8; Wed, 17 Sep
	2025 13:41:38 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250917134138epcas5p2b02390404681df79c26f7a1a0f0262b8~mFaPqep2X1122211222epcas5p2B;
	Wed, 17 Sep 2025 13:41:38 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250917134136epsmtip2937729757e7b83a96e66fb422f807226~mFaOH1cRi0779307793epsmtip2-;
	Wed, 17 Sep 2025 13:41:36 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com, Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V3 05/20] nvdimm/namespace_label: Add namespace label
 changes as per CXL LSA v2.1
Date: Wed, 17 Sep 2025 19:11:01 +0530
Message-Id: <20250917134116.1623730-6-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917134116.1623730-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917134138epcas5p2b02390404681df79c26f7a1a0f0262b8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917134138epcas5p2b02390404681df79c26f7a1a0f0262b8
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134138epcas5p2b02390404681df79c26f7a1a0f0262b8@epcas5p2.samsung.com>

CXL 3.2 Spec mentions CXL LSA 2.1 Namespace Labels at section 9.13.2.5
Modified __pmem_label_update function using setter functions to update
namespace label as per CXL LSA 2.1

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c |  3 +++
 drivers/nvdimm/nd.h    | 23 +++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 3235562d0e1c..182f8c9a01bf 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -924,6 +924,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
 
 	nd_label = to_label(ndd, slot);
 	memset(nd_label, 0, sizeof_namespace_label(ndd));
+	nsl_set_type(ndd, nd_label);
 	nsl_set_uuid(ndd, nd_label, nspm->uuid);
 	nsl_set_name(ndd, nd_label, nspm->alt_name);
 	nsl_set_flags(ndd, nd_label, flags);
@@ -935,7 +936,9 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	nsl_set_lbasize(ndd, nd_label, nspm->lbasize);
 	nsl_set_dpa(ndd, nd_label, res->start);
 	nsl_set_slot(ndd, nd_label, slot);
+	nsl_set_alignment(ndd, nd_label, 0);
 	nsl_set_type_guid(ndd, nd_label, &nd_set->type_guid);
+	nsl_set_region_uuid(ndd, nd_label, NULL);
 	nsl_set_claim_class(ndd, nd_label, ndns->claim_class);
 	nsl_calculate_checksum(ndd, nd_label);
 	nd_dbg_dpa(nd_region, ndd, res, "\n");
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 158809c2be9e..e362611d82cc 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -295,6 +295,29 @@ static inline const u8 *nsl_uuid_raw(struct nvdimm_drvdata *ndd,
 	return nd_label->efi.uuid;
 }
 
+static inline void nsl_set_type(struct nvdimm_drvdata *ndd,
+				struct nd_namespace_label *ns_label)
+{
+	if (ndd->cxl && ns_label)
+		uuid_parse(CXL_NAMESPACE_UUID, (uuid_t *) ns_label->cxl.type);
+}
+
+static inline void nsl_set_alignment(struct nvdimm_drvdata *ndd,
+				     struct nd_namespace_label *ns_label,
+				     u32 align)
+{
+	if (ndd->cxl)
+		ns_label->cxl.align = __cpu_to_le32(align);
+}
+
+static inline void nsl_set_region_uuid(struct nvdimm_drvdata *ndd,
+				       struct nd_namespace_label *ns_label,
+				       const uuid_t *uuid)
+{
+	if (ndd->cxl && uuid)
+		export_uuid(ns_label->cxl.region_uuid, uuid);
+}
+
 bool nsl_validate_type_guid(struct nvdimm_drvdata *ndd,
 			    struct nd_namespace_label *nd_label, guid_t *guid);
 enum nvdimm_claim_class nsl_get_claim_class(struct nvdimm_drvdata *ndd,
-- 
2.34.1

