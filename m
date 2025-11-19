Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475162F361E
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763538800; cv=none; b=edgWQ/Q8hyNBUj1DadLuhnu4jRLQlAciWNzEYDf8F3YakWUMvl/tjy6clggVwzYLW+39OPdUZ19nicuVQ4d82+Nl7LAwlH66b2sD12FnC1I9TRoPT5/Fn0VzsRr9PGzq1AGO5at22g3FvQELbHaNzubrgx/2fl8+iZbcUDWnrqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763538800; c=relaxed/simple;
	bh=ypMhn0Q0GMQSRpsgJClAhQxdV8HA9KvCwIobkNtECag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=r4oUtd+Ez8XL0mMRRPGk6AA+jt0WtGsnU0991fkgrPnGwXMAm8U5tXt1ldxqxkmT4OOFF8XmpKX3+EUprAy6OJZsUZU1WQ1jDGgOuvZGpRv1Et8Ivji2bYnQaSmc37USWs+FEUUrX2LJfBmOIt7KpsMCjtqTUa2vV5Ihd5xN/4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QkEYtrig; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QkEYtrig"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251119075315epoutp03332f058cf3d11ae73a5501decb02b699~5WTDRuZw23019930199epoutp03f
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251119075315epoutp03332f058cf3d11ae73a5501decb02b699~5WTDRuZw23019930199epoutp03f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1763538795;
	bh=JoE3B/f5qTuEWVTLKcRVyuWCSq09YuW6AptM39kalGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QkEYtrighD6kRsK4T6Er2aOQrLxOTnVzmXtWbUo47VtrQpTn1g3VK2YrtB1JDw+bm
	 oS+A7yVsQfpzjqA2IfJ8u7KKOZd4vI/ySIJsIIKSl1uTWc3sxkfqq/rSf8We8hIy8l
	 5uLdcy9smWC3RzfvNKmccc6+ZqQQc+Anb4TFaaPo=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20251119075314epcas5p4a84690f4df31dee3ede003d5c6209768~5WTC2EUtE0334103341epcas5p4E;
	Wed, 19 Nov 2025 07:53:14 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.86]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dBDHY5M1cz2SSKm; Wed, 19 Nov
	2025 07:53:13 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20251119075313epcas5p2db0de2ac270e4676b12730e10281ef83~5WTBXxxkl0175501755epcas5p2A;
	Wed, 19 Nov 2025 07:53:13 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251119075311epsmtip11482b0fd17a1d14c79056d2ee5a4ff1f~5WS-thM6e2605226052epsmtip1Q;
	Wed, 19 Nov 2025 07:53:11 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V4 04/17] nvdimm/label: Include region label in slot
 validation
Date: Wed, 19 Nov 2025 13:22:42 +0530
Message-Id: <20251119075255.2637388-5-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251119075255.2637388-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251119075313epcas5p2db0de2ac270e4676b12730e10281ef83
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251119075313epcas5p2db0de2ac270e4676b12730e10281ef83
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075313epcas5p2db0de2ac270e4676b12730e10281ef83@epcas5p2.samsung.com>

Prior to LSA 2.1 Support, label in slot means only namespace
label. But with LSA 2.1 a label can be either namespace or
region label.

Slot validation routine validates label slot by calculating
label checksum. It was only validating namespace label.
This changeset also validates region label if present.

In previous patch to_lsa_label() was introduced along with
to_label(). to_label() returns only namespace label whereas
to_lsa_label() returns union nd_lsa_label*

In this patch We have converted all usage of to_label()
to to_lsa_label()

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c | 94 ++++++++++++++++++++++++++++--------------
 drivers/nvdimm/nd.h    |  5 +++
 2 files changed, 69 insertions(+), 30 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 0d587a5b9f7e..6ccc51552822 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -312,16 +312,6 @@ static union nd_lsa_label *to_lsa_label(struct nvdimm_drvdata *ndd, int slot)
 	return (union nd_lsa_label *) label;
 }
 
-static struct nd_namespace_label *to_label(struct nvdimm_drvdata *ndd, int slot)
-{
-	unsigned long label, base;
-
-	base = (unsigned long) nd_label_base(ndd);
-	label = base + sizeof_namespace_label(ndd) * slot;
-
-	return (struct nd_namespace_label *) label;
-}
-
 #define for_each_clear_bit_le(bit, addr, size) \
 	for ((bit) = find_next_zero_bit_le((addr), (size), 0);  \
 	     (bit) < (size);                                    \
@@ -382,7 +372,7 @@ static bool nsl_validate_checksum(struct nvdimm_drvdata *ndd,
 {
 	u64 sum, sum_save;
 
-	if (!ndd->cxl && !efi_namespace_label_has(ndd, checksum))
+	if (!efi_namespace_label_has(ndd, checksum))
 		return true;
 
 	sum_save = nsl_get_checksum(ndd, nd_label);
@@ -397,13 +387,25 @@ static void nsl_calculate_checksum(struct nvdimm_drvdata *ndd,
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
@@ -415,16 +417,34 @@ static void region_label_calculate_checksum(struct nvdimm_drvdata *ndd,
 }
 
 static bool slot_valid(struct nvdimm_drvdata *ndd,
-		struct nd_namespace_label *nd_label, u32 slot)
+		       union nd_lsa_label *lsa_label, u32 slot)
 {
+	struct cxl_region_label *region_label = &lsa_label->region_label;
+	struct nd_namespace_label *nd_label = &lsa_label->ns_label;
+	enum label_type type;
 	bool valid;
+	static const char * const label_name[] = {
+		[RG_LABEL_TYPE] = "region",
+		[NS_LABEL_TYPE] = "namespace",
+	};
 
 	/* check that we are written where we expect to be written */
-	if (slot != nsl_get_slot(ndd, nd_label))
-		return false;
-	valid = nsl_validate_checksum(ndd, nd_label);
+	if (is_region_label(ndd, lsa_label)) {
+		type = RG_LABEL_TYPE;
+		if (slot != region_label_get_slot(region_label))
+			return false;
+		valid = region_label_validate_checksum(ndd, region_label);
+	} else {
+		type = NS_LABEL_TYPE;
+		if (slot != nsl_get_slot(ndd, nd_label))
+			return false;
+		valid = nsl_validate_checksum(ndd, nd_label);
+	}
+
 	if (!valid)
-		dev_dbg(ndd->dev, "fail checksum. slot: %d\n", slot);
+		dev_dbg(ndd->dev, "%s label checksum fail. slot: %d\n",
+			label_name[type], slot);
+
 	return valid;
 }
 
@@ -440,14 +460,16 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
 	for_each_clear_bit_le(slot, free, nslot) {
 		struct nd_namespace_label *nd_label;
 		struct nd_region *nd_region = NULL;
+		union nd_lsa_label *lsa_label;
 		struct nd_label_id label_id;
 		struct resource *res;
 		uuid_t label_uuid;
 		u32 flags;
 
-		nd_label = to_label(ndd, slot);
+		lsa_label = to_lsa_label(ndd, slot);
+		nd_label = &lsa_label->ns_label;
 
-		if (!slot_valid(ndd, nd_label, slot))
+		if (!slot_valid(ndd, lsa_label, slot))
 			continue;
 
 		nsl_get_uuid(ndd, nd_label, &label_uuid);
@@ -598,18 +620,30 @@ int nd_label_active_count(struct nvdimm_drvdata *ndd)
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
+		lsa_label = to_lsa_label(ndd, slot);
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
@@ -627,10 +661,10 @@ union nd_lsa_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
 		return NULL;
 
 	for_each_clear_bit_le(slot, free, nslot) {
-		struct nd_namespace_label *nd_label;
+		union nd_lsa_label *lsa_label;
 
-		nd_label = to_label(ndd, slot);
-		if (!slot_valid(ndd, nd_label, slot))
+		lsa_label = to_lsa_label(ndd, slot);
+		if (!slot_valid(ndd, lsa_label, slot))
 			continue;
 
 		if (n-- == 0)
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 5fd69c28ffe7..30c7262d8a26 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -346,6 +346,11 @@ region_label_uuid_equal(struct cxl_region_label *region_label,
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

