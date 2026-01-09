Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B736935CB68
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962717; cv=none; b=rhtaF0IqRtCYGPvnDAn3mjwGWDg2motKTeWLmAjOC8rgVGi9yEjUGDdVMHlhYanRhhcfEqRj4zoGFYRvEaxFRw5TmAWqLT64YNbtRTdjqg9B47k+6vBHViL67MLv8u98NW89PLiElJwDW4Z6ud9bZbUMTcUC0bM4FZ0cKGLLdow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962717; c=relaxed/simple;
	bh=eJ84zPDSdkNcOPjEXDOFVSn7BD2jw9zWo/Q+6BRmSXg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Ir0cHW9ofGdKg6ziPXXm8SPGNfjZIw2xjD3cx6s/G/vhfPPjue67ncEMhSUb3M82MQErSuwu7j4GHKdmfr8+mJB1oZ2nzPkGjHABwO/u1vf79nzVboYLwy4IqCk0EmOTz85Ue5sk51NN2T2qzqUonHEFXxH0kAlyVrMV33FMwEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=I0jgdHcM; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="I0jgdHcM"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260109124513epoutp01650d0c213c9cdfcf23fe5eb9b9895733~JELikIEqd0753707537epoutp01A
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:45:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260109124513epoutp01650d0c213c9cdfcf23fe5eb9b9895733~JELikIEqd0753707537epoutp01A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767962713;
	bh=p94qzV25B2KBKjmHgA84WrlOtxJ8Ue2QOEDO24cUz2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0jgdHcMUdCSQv9Oeuz9jO3Jn+5+LqZH7s2JnlBSVfH0J7mFh5sxuKEmSdfwp9tMa
	 oWmf/F22QIYW3ySGSGTZQpzXwCKoGG2BYoMicHPsnY8t0dniXo3o61cP62gBMnr9Iz
	 JOGBIz+vDEIuCt0ZxzvhVE44U7rcOz3K3Tb/fX3c=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260109124513epcas5p1950c48a778b42bc6a9136c8e0113ea82~JELiJbAhk2895828958epcas5p1a;
	Fri,  9 Jan 2026 12:45:13 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.86]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dnhLw58Hdz2SSKX; Fri,  9 Jan
	2026 12:45:12 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260109124512epcas5p4a6d8c2b9c6cf7cf794d1a477eaee7865~JELhEoIFR1015010150epcas5p46;
	Fri,  9 Jan 2026 12:45:12 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260109124505epsmtip19eb0b7448f062ca1f42cc18fd95e9813~JELaZEb8o0972509725epsmtip1V;
	Fri,  9 Jan 2026 12:45:04 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V5 04/17] nvdimm/label: Include region label in slot
 validation
Date: Fri,  9 Jan 2026 18:14:24 +0530
Message-Id: <20260109124437.4025893-5-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260109124437.4025893-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260109124512epcas5p4a6d8c2b9c6cf7cf794d1a477eaee7865
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260109124512epcas5p4a6d8c2b9c6cf7cf794d1a477eaee7865
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124512epcas5p4a6d8c2b9c6cf7cf794d1a477eaee7865@epcas5p4.samsung.com>

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
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c | 94 ++++++++++++++++++++++++++++--------------
 1 file changed, 64 insertions(+), 30 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 17e2a1f5a6da..9854cb45fb62 100644
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
+		if (slot != __le32_to_cpu(region_label->slot))
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
-- 
2.34.1

