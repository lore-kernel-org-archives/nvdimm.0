Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9430E2EA495
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750165212; cv=none; b=FY7/V9dNIycdsy37vp1L82pwVuzq94xWh3MeRW2RDXHGxTi9DeEXYQXjkRX6Jpod+CzZqllAa/xI7rCa1dLwkDTGAXDarNN/sieg0i9DoU+XowrvtTjpEu6RptGmOriksvXinBEHLKigepE3VFbOi1ckXvNG1MLQUi058fFp0/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750165212; c=relaxed/simple;
	bh=z5fxDXe+5ZZ/gJ0Rsqi71QFDsI6asZuTO64TmhTNpxE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=W7k3ivP/DVofLKJqLSMII5aPX6GX8YvFw1MPaYS1pM9brsu14j8vIxtxENO+/3fpK7KJ8IUaSTuSX7elRVR9NYQTO/nCYT+cWfnVCKJv9Cj29AI9+C5rkrIO5Wx7lIeDIkbDoDYFICdZOrUiEpmcp1/LD4l9/I5w2bjZm5tRgvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=mTu51itU; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mTu51itU"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250617130005epoutp015a2dfe015e0499d87bfcfb761131fd51~J1ftEbUho0669606696epoutp01d
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:00:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250617130005epoutp015a2dfe015e0499d87bfcfb761131fd51~J1ftEbUho0669606696epoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750165205;
	bh=jvB3e+JAq4PqZt4kGvVf2gWFtHrsQk5KtlLBOQVZQXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mTu51itUyU+NV6DEmhHkcVPhk6/4l3gJVkblCQvzu8ogjvzCRT3fAsOq+tnz0xkYN
	 Jlo51IExxJLItYbRNu9J+fFEpFNlO/smizQJSdMm7qfTDJ0/ClfrdjqqLTpimBoZjR
	 ZG4GUrxzDb6Jhr7fnBhDVqDhZmgXEiYo7tI1YXaY=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250617130004epcas5p166f569f7de3716ce57c4e5d29b043575~J1fskvFRE0551805518epcas5p14;
	Tue, 17 Jun 2025 13:00:04 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4bM6R85kSPz6B9m7; Tue, 17 Jun
	2025 13:00:04 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250617124028epcas5p2bb45182c91359a16efc5b1561927abce~J1OlPt45x0929709297epcas5p2c;
	Tue, 17 Jun 2025 12:40:28 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250617124026epsmtip2e47f2ff5c61a2d7efbf6724986284891~J1OivnCml2545625456epsmtip2c;
	Tue, 17 Jun 2025 12:40:25 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: dan.j.williams@intel.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, s.neeraj@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: [RFC PATCH 08/20] nvdimm/label: Include region label in slot
 validation
Date: Tue, 17 Jun 2025 18:09:32 +0530
Message-Id: <148912029.181750165204802.JavaMail.epsvc@epcpadp1new>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250617123944.78345-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250617124028epcas5p2bb45182c91359a16efc5b1561927abce
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124028epcas5p2bb45182c91359a16efc5b1561927abce
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124028epcas5p2bb45182c91359a16efc5b1561927abce@epcas5p2.samsung.com>

slot validation routine validates label slot by calculating label
checksum. It was only validating namespace label. This changeset also
validates region label if present.

Also validate and calculate lsa v2.1 namespace label checksum

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c | 52 ++++++++++++++++++++++++++++++++++--------
 drivers/nvdimm/nd.h    | 21 +++++++++++++++++
 2 files changed, 63 insertions(+), 10 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 108100c4bf44..22e13db1ca20 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -359,7 +359,7 @@ static bool nsl_validate_checksum(struct nvdimm_drvdata *ndd,
 {
 	u64 sum, sum_save;
 
-	if (!ndd->cxl && !efi_namespace_label_has(ndd, checksum))
+	if (!efi_namespace_label_has(ndd, checksum))
 		return true;
 
 	sum_save = nsl_get_checksum(ndd, nd_label);
@@ -374,13 +374,25 @@ static void nsl_calculate_checksum(struct nvdimm_drvdata *ndd,
 {
 	u64 sum;
 
-	if (!ndd->cxl && !efi_namespace_label_has(ndd, checksum))
+	if (!efi_namespace_label_has(ndd, checksum))
 		return;
 	nsl_set_checksum(ndd, nd_label, 0);
 	sum = nd_fletcher64(nd_label, sizeof_namespace_label(ndd), 1);
 	nsl_set_checksum(ndd, nd_label, sum);
 }
 
+static bool rgl_validate_checksum(struct nvdimm_drvdata *ndd,
+				  struct cxl_region_label *rg_label)
+{
+	u64 sum, sum_save;
+
+	sum_save = rgl_get_checksum(rg_label);
+	rgl_set_checksum(rg_label, 0);
+	sum = nd_fletcher64(rg_label, sizeof_namespace_label(ndd), 1);
+	rgl_set_checksum(rg_label, sum_save);
+	return sum == sum_save;
+}
+
 static void rgl_calculate_checksum(struct nvdimm_drvdata *ndd,
 				   struct cxl_region_label *rg_label)
 {
@@ -395,13 +407,25 @@ static bool slot_valid(struct nvdimm_drvdata *ndd,
 		struct nd_lsa_label *nd_label, u32 slot)
 {
 	bool valid;
+	char *label_name;
 
 	/* check that we are written where we expect to be written */
-	if (slot != nsl_get_slot(ndd, &nd_label->ns_label))
-		return false;
-	valid = nsl_validate_checksum(ndd, &nd_label->ns_label);
+	if (is_region_label(ndd, nd_label)) {
+		label_name = "rg";
+		if (slot != rgl_get_slot(&nd_label->rg_label))
+			return false;
+		valid = rgl_validate_checksum(ndd, &nd_label->rg_label);
+	} else {
+		label_name = "ns";
+		if (slot != nsl_get_slot(ndd, &nd_label->ns_label))
+			return false;
+		valid = nsl_validate_checksum(ndd, &nd_label->ns_label);
+	}
+
 	if (!valid)
-		dev_dbg(ndd->dev, "fail checksum. slot: %d\n", slot);
+		dev_dbg(ndd->dev, "%s label checksum fail. slot: %d\n",
+			label_name, slot);
+
 	return valid;
 }
 
@@ -577,17 +601,25 @@ int nd_label_active_count(struct nvdimm_drvdata *ndd)
 
 	for_each_clear_bit_le(slot, free, nslot) {
 		struct nd_lsa_label *nd_label;
+		u32 lslot;
+		u64 size, dpa;
 
 		nd_label = to_label(ndd, slot);
 
 		if (!slot_valid(ndd, nd_label, slot)) {
-			u32 label_slot = nsl_get_slot(ndd, &nd_label->ns_label);
-			u64 size = nsl_get_rawsize(ndd, &nd_label->ns_label);
-			u64 dpa = nsl_get_dpa(ndd, &nd_label->ns_label);
+			if (is_region_label(ndd, nd_label)) {
+				lslot = __le32_to_cpu(nd_label->rg_label.slot);
+				size = __le64_to_cpu(nd_label->rg_label.rawsize);
+				dpa = __cpu_to_le64(nd_label->rg_label.dpa);
+			} else {
+				lslot = nsl_get_slot(ndd, &nd_label->ns_label);
+				size = nsl_get_rawsize(ndd, &nd_label->ns_label);
+				dpa = nsl_get_dpa(ndd, &nd_label->ns_label);
+			}
 
 			dev_dbg(ndd->dev,
 				"slot%d invalid slot: %d dpa: %llx size: %llx\n",
-					slot, label_slot, dpa, size);
+					slot, lslot, dpa, size);
 			continue;
 		}
 		count++;
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 1e5a68013735..ca8256b31472 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -331,6 +331,22 @@ static inline bool nsl_region_uuid_equal(struct nd_namespace_label *ns_label,
 	return uuid_equal(&tmp, uuid);
 }
 
+static inline bool is_region_label(struct nvdimm_drvdata *ndd,
+				   struct nd_lsa_label *nd_label)
+{
+	uuid_t ns_type, region_type;
+
+	if (ndd->cxl) {
+		uuid_parse(CXL_REGION_UUID, &region_type);
+		import_uuid(&ns_type, nd_label->ns_label.cxl.type);
+		if (uuid_equal(&region_type, &ns_type))
+			return true;
+		else
+			return false;
+	} else
+		return false;
+}
+
 static inline bool rgl_uuid_equal(struct cxl_region_label *rg_label,
 				  const uuid_t *uuid)
 {
@@ -340,6 +356,11 @@ static inline bool rgl_uuid_equal(struct cxl_region_label *rg_label,
 	return uuid_equal(&tmp, uuid);
 }
 
+static inline u32 rgl_get_slot(struct cxl_region_label *rg_label)
+{
+	return __le32_to_cpu(rg_label->slot);
+}
+
 static inline u64 rgl_get_checksum(struct cxl_region_label *rg_label)
 {
 	return __le64_to_cpu(rg_label->checksum);
-- 
2.34.1


