Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EB4328988
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758116511; cv=none; b=JlnhM+Eu0eOxNqlVPLAiKlIaQfqHE/19dOtHorM+Az4CrX2Uav3gZ7mb1V7kFOwhjlaXSE8x+2dzLl8u9XMQZzX6Zg63K5k8YmVDxd3SPhOgdkTvrtK+oPuVDqVOccsDz1gAMefi7QX35O1PmHJ3pBJtzyrCYv75sSarebogY/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758116511; c=relaxed/simple;
	bh=vHuAadVlS3FOglAGf+BTtp47I18dR2Liu7MyC/Wl1sk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=robfeyTIIChXYcxknd4BT3gR/O0O1KibGELFcwjPvkKZEHXpJ1WpLzoF/8ZQtAli0fQkV5mhttsQrmdAAh/gKbDCIsuUlj8pU8eafJ59pGXDP1Q/r+gjtgb/6/Nnb785ZnQOArcChEB+H15j0qtg7ZrfoXhTrZKuVaqK92Gs5ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=s/2U3K6s; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="s/2U3K6s"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250917134147epoutp02aa2c2d982fda63632d8ea64b9e185cb9~mFaX9L0SO1573515735epoutp02I
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:41:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250917134147epoutp02aa2c2d982fda63632d8ea64b9e185cb9~mFaX9L0SO1573515735epoutp02I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758116507;
	bh=EEuNV6QTBvuCr9tgJGSp5/94eDUJ6AJpAamfaAzmqdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/2U3K6siid4Fn6rISDPVml6jPlEBsmuXpK6912gJnuPZIzYNc2YzX0cNmo7f0p/a
	 G/Ift52BaV9bg12VdNEr3CngKrwNt9puaIvvhhEODG3pzwuQFoY2/9cyQvHGlA4Lit
	 xL72efsT+v2OZ6wUmMWkuPPC2QtUbjd6LBVG69pg=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250917134146epcas5p2041885921056859cc482db8a63dca955~mFaXeI2zm1141811418epcas5p2L;
	Wed, 17 Sep 2025 13:41:46 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.87]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cRg0n4bhtz6B9m6; Wed, 17 Sep
	2025 13:41:45 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250917134144epcas5p498fb4b005516fca56e68533ce017fba0~mFaVxGMat2679026790epcas5p4U;
	Wed, 17 Sep 2025 13:41:44 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250917134142epsmtip2c2cff03d8d4f3aed14eeab47426ba8cd~mFaT7qXR70862908629epsmtip2C;
	Wed, 17 Sep 2025 13:41:42 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com, Neeraj Kumar <s.neeraj@samsung.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>
Subject: [PATCH V3 08/20] nvdimm/label: Include region label in slot
 validation
Date: Wed, 17 Sep 2025 19:11:04 +0530
Message-Id: <20250917134116.1623730-9-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917134116.1623730-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917134144epcas5p498fb4b005516fca56e68533ce017fba0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917134144epcas5p498fb4b005516fca56e68533ce017fba0
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134144epcas5p498fb4b005516fca56e68533ce017fba0@epcas5p4.samsung.com>

Slot validation routine validates label slot by calculating label
checksum. It was only validating namespace label. This changeset also
validates region label if present.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 drivers/nvdimm/label.c | 72 ++++++++++++++++++++++++++++++++----------
 drivers/nvdimm/nd.h    |  5 +++
 2 files changed, 60 insertions(+), 17 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index d33db96ba8ba..5e476154cf81 100644
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
 
+static bool region_label_validate_checksum(struct nvdimm_drvdata *ndd,
+				struct cxl_region_label *region_label)
+{
+	u64 sum, sum_save;
+
+	sum_save = region_label_get_checksum(region_label);
+	region_label_set_checksum(region_label, 0);
+	sum = nd_fletcher64(region_label, sizeof_namespace_label(ndd), 1);
+	region_label_set_checksum(region_label, sum_save);
+	return sum == sum_save;
+}
+
 static void region_label_calculate_checksum(struct nvdimm_drvdata *ndd,
 				   struct cxl_region_label *region_label)
 {
@@ -392,16 +404,30 @@ static void region_label_calculate_checksum(struct nvdimm_drvdata *ndd,
 }
 
 static bool slot_valid(struct nvdimm_drvdata *ndd,
-		struct nd_namespace_label *nd_label, u32 slot)
+		       union nd_lsa_label *lsa_label, u32 slot)
 {
+	struct cxl_region_label *region_label = &lsa_label->region_label;
+	struct nd_namespace_label *nd_label = &lsa_label->ns_label;
+	char *label_name;
 	bool valid;
 
 	/* check that we are written where we expect to be written */
-	if (slot != nsl_get_slot(ndd, nd_label))
-		return false;
-	valid = nsl_validate_checksum(ndd, nd_label);
+	if (is_region_label(ndd, lsa_label)) {
+		label_name = "rg";
+		if (slot != region_label_get_slot(region_label))
+			return false;
+		valid = region_label_validate_checksum(ndd, region_label);
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
 
@@ -424,7 +450,7 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
 
 		nd_label = to_label(ndd, slot);
 
-		if (!slot_valid(ndd, nd_label, slot))
+		if (!slot_valid(ndd, (union nd_lsa_label *) nd_label, slot))
 			continue;
 
 		nsl_get_uuid(ndd, nd_label, &label_uuid);
@@ -575,18 +601,30 @@ int nd_label_active_count(struct nvdimm_drvdata *ndd)
 		return 0;
 
 	for_each_clear_bit_le(slot, free, nslot) {
+		struct cxl_region_label *region_label;
 		struct nd_namespace_label *nd_label;
-
-		nd_label = to_label(ndd, slot);
-
-		if (!slot_valid(ndd, nd_label, slot)) {
-			u32 label_slot = nsl_get_slot(ndd, nd_label);
-			u64 size = nsl_get_rawsize(ndd, nd_label);
-			u64 dpa = nsl_get_dpa(ndd, nd_label);
+		union nd_lsa_label *lsa_label;
+		u32 lslot;
+		u64 size, dpa;
+
+		lsa_label = (union nd_lsa_label *) to_label(ndd, slot);
+		nd_label = &lsa_label->ns_label;
+		region_label = &lsa_label->region_label;
+
+		if (!slot_valid(ndd, lsa_label, slot)) {
+			if (is_region_label(ndd, lsa_label)) {
+				lslot = __le32_to_cpu(region_label->slot);
+				size = __le64_to_cpu(region_label->rawsize);
+				dpa = __le64_to_cpu(region_label->dpa);
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
@@ -607,7 +645,7 @@ struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
 		struct nd_namespace_label *nd_label;
 
 		nd_label = to_label(ndd, slot);
-		if (!slot_valid(ndd, nd_label, slot))
+		if (!slot_valid(ndd, (union nd_lsa_label *) nd_label, slot))
 			continue;
 
 		if (n-- == 0)
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 046063ea08b6..c985f91728dd 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -344,6 +344,11 @@ region_label_uuid_equal(struct cxl_region_label *region_label,
 	return uuid_equal((uuid_t *) region_label->uuid, uuid);
 }
 
+static inline u32 region_label_get_slot(struct cxl_region_label *region_label)
+{
+	return __le32_to_cpu(region_label->slot);
+}
+
 static inline u64
 region_label_get_checksum(struct cxl_region_label *region_label)
 {
-- 
2.34.1

