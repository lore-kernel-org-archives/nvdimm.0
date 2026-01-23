Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9271349AE1
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769167895; cv=none; b=c9VjY/muiWmgI6ryKDEUYRQ9vC57uCSTQ3qPW+yMMtl69M6eYA0mN7aXLYDr8CggH5IgyukG9QyQYQ9VtL/4RMYXtJ9B3VawCQ2pZo5/8UR/PzQ/MA8wLwcKMmUGMHoWmq9+2gIZlXzo9DpV3lbyfvRmaEtxhx8KaAai2m1OFMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769167895; c=relaxed/simple;
	bh=PYZkwLELAugEwacQUtSNEErxPE1uGggbBLL1aLVqmgM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=kqFWKKgnizb48ith1NRrYfKvuvyx4h1uMdT6YwxC9DUd2heD9dLYlYxgNWETIpFH2dO/5WaMLyTkYFH61velJ22Cr0wWImRGQ2ZHCk54QrbcM4ptwAIsMFcqDy5iJvWihOy2K5RLiq0rzA83dGJIi6441aNdCL+Mz5fvtBHHJKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=XCv/vx3z; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XCv/vx3z"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260123113131epoutp03a6b7198ca6db824f7fb86742c62b77f0~NWNLbUdU22123021230epoutp034
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260123113131epoutp03a6b7198ca6db824f7fb86742c62b77f0~NWNLbUdU22123021230epoutp034
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769167891;
	bh=tI9VZASa/xswWxnMaIHEtR5FaxfRWnY49pqQx0aGKSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XCv/vx3zFLOVkaj4dSf+RUENIu8k/sTD2qfFQTYDKQTZtcBlFxrIcfYREhRHP+BWs
	 16xmg6NKps1cYD3ZupsXIa/t8axP4HX5aI9ieuDx5c0Os7liispYlNewTubEVz0bl/
	 jZ79QUMwDWzHCFzT0uS99dK3K4upT5grQNtkBPf0=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260123113130epcas5p45491161bec49e9a1cf1737f0bf34cdb5~NWNKy8ZIw1497514975epcas5p4L;
	Fri, 23 Jan 2026 11:31:30 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.93]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dyG3P6Ryyz3hhT8; Fri, 23 Jan
	2026 11:31:29 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260123113129epcas5p26bb834be2b841296ca1b3fff1a44ab76~NWNJd4ipz1735017350epcas5p2P;
	Fri, 23 Jan 2026 11:31:29 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260123113127epsmtip2d0d404ae6749aca5ebc88a93278017a7~NWNINOwsx2355523555epsmtip2j;
	Fri, 23 Jan 2026 11:31:27 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V6 04/18] nvdimm/label: Include region label in slot
 validation
Date: Fri, 23 Jan 2026 17:00:58 +0530
Message-Id: <20260123113112.3488381-5-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260123113112.3488381-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260123113129epcas5p26bb834be2b841296ca1b3fff1a44ab76
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260123113129epcas5p26bb834be2b841296ca1b3fff1a44ab76
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
	<CGME20260123113129epcas5p26bb834be2b841296ca1b3fff1a44ab76@epcas5p2.samsung.com>

Prior to LSA 2.1 Support, label in slot means only namespace
label. But with LSA 2.1 a label can be either namespace or
region label.

Slot validation routine validates label slot by calculating
label checksum. It was only validating namespace label.
This changeset also validates region label if present.

In previous patch to_lsa_label() was introduced along with
to_label(). to_label() returns only namespace label whereas
to_lsa_label() returns union nd_lsa_label*

Convert all usage of to_label() to to_lsa_label()

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c | 94 +++++++++++++++++++++++++++++-------------
 1 file changed, 65 insertions(+), 29 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 06c6e23abf4e..5a4599c5e5a8 100644
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
+	sum_save = __le64_to_cpu(region_label->checksum);
+	region_label->checksum = __cpu_to_le64(0);
+	sum = nd_fletcher64(region_label, sizeof_namespace_label(ndd), 1);
+	region_label->checksum = __cpu_to_le64(sum_save);
+	return sum == sum_save;
+}
+
 static void region_label_calculate_checksum(struct nvdimm_drvdata *ndd,
 				   struct cxl_region_label *region_label)
 {
@@ -415,16 +417,36 @@ static void region_label_calculate_checksum(struct nvdimm_drvdata *ndd,
 }
 
 static bool slot_valid(struct nvdimm_drvdata *ndd,
-		struct nd_namespace_label *nd_label, u32 slot)
+		       union nd_lsa_label *lsa_label, u32 slot)
 {
+	struct cxl_region_label *region_label;
+	struct nd_namespace_label *nd_label;
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
+		region_label = &lsa_label->region_label;
+		type = RG_LABEL_TYPE;
+		if (slot != __le32_to_cpu(region_label->slot))
+			return false;
+		valid = region_label_validate_checksum(ndd, region_label);
+	} else {
+		nd_label = &lsa_label->ns_label;
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
 
@@ -440,14 +462,16 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
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
@@ -598,14 +622,26 @@ int nd_label_active_count(struct nvdimm_drvdata *ndd)
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
+		u32 label_slot;
+		u64 size, dpa;
+
+		lsa_label = to_lsa_label(ndd, slot);
+
+		if (!slot_valid(ndd, lsa_label, slot)) {
+			if (is_region_label(ndd, lsa_label)) {
+				region_label = &lsa_label->region_label;
+				label_slot = __le32_to_cpu(region_label->slot);
+				size = __le64_to_cpu(region_label->rawsize);
+				dpa = __le64_to_cpu(region_label->dpa);
+			} else {
+				nd_label = &lsa_label->ns_label;
+				label_slot = nsl_get_slot(ndd, nd_label);
+				size = nsl_get_rawsize(ndd, nd_label);
+				dpa = nsl_get_dpa(ndd, nd_label);
+			}
 
 			dev_dbg(ndd->dev,
 				"slot%d invalid slot: %d dpa: %llx size: %llx\n",
@@ -627,10 +663,10 @@ union nd_lsa_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
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
-- 
2.34.1

