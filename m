Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3D329ACC5
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753877813; cv=none; b=dFdWLMuDE4cwgHXb06potLjxN9xF/DRXeqGgg8OtBmUTL5sBZzJgPuX3Ns758/9EMD2rezINoj5BVNrjwjIWI58IRtUIxwruje//USVFzp+aSByMkKHlrGbR4Lc4g/r2UVC0XmSDB1hEIGKQovcXMtdQPBljs9Htp0jTXt6+VLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753877813; c=relaxed/simple;
	bh=j6v1lTtIK5YR42k3gkQt6crKvDmap74Vg9EwZ8ukQkg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=XCSt6dD/2GZ5n3DPKLNhNrjzhmeRXPCXqntbHciZLqssa483zxKXXnXJUfQyRB7X53Sj2YZklDUEbS87P69bXc+9USO/8C6UVsTqEeSBfL5SLjW5jzNxOpu7x3rTN8qDxQNADU8xYhFHYKRjBbKZ9gGCsD9FSjOT1f7Dh8bTsOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=HzAlbIZM; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="HzAlbIZM"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250730121649epoutp03159fea95386a30664bc4d6aa862d52a5~XBpM6zwbI3204132041epoutp03v
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:16:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250730121649epoutp03159fea95386a30664bc4d6aa862d52a5~XBpM6zwbI3204132041epoutp03v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753877809;
	bh=SynpQZR8CRRv+AfAgPqGhWh2B4HWCZ75IT35ux6lIyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HzAlbIZMpefwm6vglhg6PbjxwpFRjz3tBXntDMHreNCAGFkbyv/9oiadJEvP4KL0O
	 RW7qtwCKhMUOdk3tyi4TEY23+Kp0w2K+kHtwuQ46vxnJ+vVB+j9Ksa4DZgVW5WW59r
	 VhxHWy0vDRf8YKOaO5KmMxt2l5trRmKodjbkFLac=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250730121648epcas5p1296bfabda8aa2b3f94e44e83c685fa28~XBpMoQOAU1762517625epcas5p1b;
	Wed, 30 Jul 2025 12:16:48 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.90]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4bsWRM6xF0z2SSKZ; Wed, 30 Jul
	2025 12:16:47 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250730121232epcas5p4cd632fe09d1bc51499d9e3ac3c2633b3~XBld_A80h0910609106epcas5p4K;
	Wed, 30 Jul 2025 12:12:32 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250730121231epsmtip1927d4472b43de9d959cfa100d3615d2e~XBlc7HC1g0197501975epsmtip16;
	Wed, 30 Jul 2025 12:12:31 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V2 08/20] nvdimm/label: Include region label in slot
 validation
Date: Wed, 30 Jul 2025 17:41:57 +0530
Message-Id: <20250730121209.303202-9-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250730121209.303202-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250730121232epcas5p4cd632fe09d1bc51499d9e3ac3c2633b3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121232epcas5p4cd632fe09d1bc51499d9e3ac3c2633b3
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121232epcas5p4cd632fe09d1bc51499d9e3ac3c2633b3@epcas5p4.samsung.com>

slot validation routine validates label slot by calculating label
checksum. It was only validating namespace label. This changeset also
validates region label if present.

Also validate and calculate lsa v2.1 namespace label checksum

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c | 55 ++++++++++++++++++++++++++++++++++--------
 drivers/nvdimm/nd.h    | 19 +++++++++++++++
 2 files changed, 64 insertions(+), 10 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index fd02b557612e..c4748e30f2b6 100644
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
@@ -395,14 +407,27 @@ static bool slot_valid(struct nvdimm_drvdata *ndd,
 		struct nd_lsa_label *lsa_label, u32 slot)
 {
 	bool valid;
+	char *label_name;
 	struct nd_namespace_label *nd_label = &lsa_label->ns_label;
+	struct cxl_region_label *rg_label = &lsa_label->rg_label;
 
 	/* check that we are written where we expect to be written */
-	if (slot != nsl_get_slot(ndd, nd_label))
-		return false;
-	valid = nsl_validate_checksum(ndd, nd_label);
+	if (is_region_label(ndd, lsa_label)) {
+		label_name = "rg";
+		if (slot != rgl_get_slot(rg_label))
+			return false;
+		valid = rgl_validate_checksum(ndd, rg_label);
+	} else {
+		label_name = "ns";
+		if (slot != nsl_get_slot(ndd, nd_label))
+			return false;
+		valid = nsl_validate_checksum(ndd, nd_label);
+	}
+
 	if (!valid)
-		dev_dbg(ndd->dev, "fail checksum. slot: %d\n", slot);
+		dev_dbg(ndd->dev, "%s label checksum fail. slot: %d\n",
+			label_name, slot);
+
 	return valid;
 }
 
@@ -580,18 +605,28 @@ int nd_label_active_count(struct nvdimm_drvdata *ndd)
 	for_each_clear_bit_le(slot, free, nslot) {
 		struct nd_lsa_label *lsa_label;
 		struct nd_namespace_label *nd_label;
+		struct cxl_region_label *rg_label;
+		u32 lslot;
+		u64 size, dpa;
 
 		lsa_label = to_label(ndd, slot);
 		nd_label = &lsa_label->ns_label;
+		rg_label = &lsa_label->rg_label;
 
 		if (!slot_valid(ndd, lsa_label, slot)) {
-			u32 label_slot = nsl_get_slot(ndd, nd_label);
-			u64 size = nsl_get_rawsize(ndd, nd_label);
-			u64 dpa = nsl_get_dpa(ndd, nd_label);
+			if (is_region_label(ndd, lsa_label)) {
+				lslot = __le32_to_cpu(rg_label->slot);
+				size = __le64_to_cpu(rg_label->rawsize);
+				dpa = __cpu_to_le64(rg_label->dpa);
+			} else {
+				lslot = nsl_get_slot(ndd, nd_label);
+				size = nsl_get_rawsize(ndd, nd_label);
+				dpa = nsl_get_dpa(ndd, nd_label);
+			}
 
 			dev_dbg(ndd->dev,
 				"slot%d invalid slot: %d dpa: %llx size: %llx\n",
-					slot, label_slot, dpa, size);
+					slot, lslot, dpa, size);
 			continue;
 		}
 		count++;
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 6585747154c2..4145c7df2a8f 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -331,6 +331,20 @@ static inline bool nsl_region_uuid_equal(struct nd_namespace_label *ns_label,
 	return uuid_equal(&tmp, uuid);
 }
 
+static inline bool is_region_label(struct nvdimm_drvdata *ndd,
+				   struct nd_lsa_label *nd_label)
+{
+	uuid_t ns_type, region_type;
+
+	if (!ndd->cxl)
+		return false;
+
+	uuid_parse(CXL_REGION_UUID, &region_type);
+	import_uuid(&ns_type, nd_label->ns_label.cxl.type);
+	return uuid_equal(&region_type, &ns_type);
+
+}
+
 static inline bool rgl_uuid_equal(struct cxl_region_label *rg_label,
 				  const uuid_t *uuid)
 {
@@ -340,6 +354,11 @@ static inline bool rgl_uuid_equal(struct cxl_region_label *rg_label,
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

