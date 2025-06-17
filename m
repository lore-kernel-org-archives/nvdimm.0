Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609672EA487
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750165211; cv=none; b=MVy98dJiT6HiFKJIH7vAyaLAEWvRhNoqhUS5DEtesJa5ipALxnL4ydRFvFjAzznRHCTpc3ysoPIq7Y4LbuqZ+E7oFzdiqjuYSHeaqhG6cMmoKzEv0VfeHeMjd4GYUPP745hVCtMa0bTeHS/SwoFyybBFK/M7CfC4CBS/2Uz/brs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750165211; c=relaxed/simple;
	bh=j5fYYrJFbdmQndWFB0X+vKTJVa3trAmqQolQem1wkCQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=NFnXlf1TZi70z9iZ3IZRVZhmdJntr9sYWSXEpic++G0k/FggwwPm2zdWuOacULaBuxqK+0O5UbhlQX9aMwI9EHAjgmvt8Ax3bt0NZ5Cvu4FHBbGYfyWi7LL2iEW0sq295oJ21Q2prnUzC0GDSf7sHkwvL4PqbBOuIhgmkCaWwLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=oxbp+/vn; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="oxbp+/vn"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250617130004epoutp04ceffa6e32fb08c4c074b539a2cce30e3~J1fsKPnOQ2038020380epoutp04J
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:00:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250617130004epoutp04ceffa6e32fb08c4c074b539a2cce30e3~J1fsKPnOQ2038020380epoutp04J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750165204;
	bh=zwHKJhTenaRrfNtqibe+tIGIDTAOmGg01RziKYhx/ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxbp+/vn6Mil9d/Qdoy5oK1AO+loTOhtuyFAp8jCSuoGFYSUdcfhe4BG8n6jkO8aE
	 vbAOa6xd98LRMLMYLHSVrU+FU8O4To3LQM8GI1V08tpGHW7ogLBAv4Zziu+IlsfVSh
	 B0WRihZLzCOuF0XCi9ire0oyALAfOjPzwOUs7gf8=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250617130003epcas5p2350399615f477e4c34e918558cacc9fc~J1frsd8Aa1907619076epcas5p2F;
	Tue, 17 Jun 2025 13:00:03 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bM6R765Sfz3hhTD; Tue, 17 Jun
	2025 13:00:03 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250617124011epcas5p2264e30ec58977907f80d311083265641~J1OUxA5bs0264902649epcas5p2i;
	Tue, 17 Jun 2025 12:40:11 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250617124008epsmtip2be9767b3d0aafc8fc6e02b07c23593cd~J1OSOQ44e2488624886epsmtip2I;
	Tue, 17 Jun 2025 12:40:08 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: dan.j.williams@intel.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, s.neeraj@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: [RFC PATCH 02/20] nvdimm/label: Prep patch to accommodate cxl lsa
 2.1 support
Date: Tue, 17 Jun 2025 18:09:26 +0530
Message-Id: <700072760.81750165203833.JavaMail.epsvc@epcpadp1new>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250617123944.78345-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250617124011epcas5p2264e30ec58977907f80d311083265641
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124011epcas5p2264e30ec58977907f80d311083265641
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124011epcas5p2264e30ec58977907f80d311083265641@epcas5p2.samsung.com>

In order to accommodate cxl lsa 2.1 format region label, renamed
nd_namespace_label to nd_lsa_label.

No functional change introduced.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c          | 79 ++++++++++++++++++---------------
 drivers/nvdimm/label.h          | 12 ++++-
 drivers/nvdimm/namespace_devs.c | 74 +++++++++++++++---------------
 drivers/nvdimm/nd.h             |  2 +-
 4 files changed, 92 insertions(+), 75 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 48b5ba90216d..30bccad98939 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -271,7 +271,7 @@ static void nd_label_copy(struct nvdimm_drvdata *ndd,
 	memcpy(dst, src, sizeof_namespace_index(ndd));
 }
 
-static struct nd_namespace_label *nd_label_base(struct nvdimm_drvdata *ndd)
+static struct nd_lsa_label *nd_label_base(struct nvdimm_drvdata *ndd)
 {
 	void *base = to_namespace_index(ndd, 0);
 
@@ -279,7 +279,7 @@ static struct nd_namespace_label *nd_label_base(struct nvdimm_drvdata *ndd)
 }
 
 static int to_slot(struct nvdimm_drvdata *ndd,
-		struct nd_namespace_label *nd_label)
+		struct nd_lsa_label *nd_label)
 {
 	unsigned long label, base;
 
@@ -289,14 +289,14 @@ static int to_slot(struct nvdimm_drvdata *ndd,
 	return (label - base) / sizeof_namespace_label(ndd);
 }
 
-static struct nd_namespace_label *to_label(struct nvdimm_drvdata *ndd, int slot)
+static struct nd_lsa_label *to_label(struct nvdimm_drvdata *ndd, int slot)
 {
 	unsigned long label, base;
 
 	base = (unsigned long) nd_label_base(ndd);
 	label = base + sizeof_namespace_label(ndd) * slot;
 
-	return (struct nd_namespace_label *) label;
+	return (struct nd_lsa_label *) label;
 }
 
 #define for_each_clear_bit_le(bit, addr, size) \
@@ -382,14 +382,14 @@ static void nsl_calculate_checksum(struct nvdimm_drvdata *ndd,
 }
 
 static bool slot_valid(struct nvdimm_drvdata *ndd,
-		struct nd_namespace_label *nd_label, u32 slot)
+		struct nd_lsa_label *nd_label, u32 slot)
 {
 	bool valid;
 
 	/* check that we are written where we expect to be written */
-	if (slot != nsl_get_slot(ndd, nd_label))
+	if (slot != nsl_get_slot(ndd, &nd_label->ns_label))
 		return false;
-	valid = nsl_validate_checksum(ndd, nd_label);
+	valid = nsl_validate_checksum(ndd, &nd_label->ns_label);
 	if (!valid)
 		dev_dbg(ndd->dev, "fail checksum. slot: %d\n", slot);
 	return valid;
@@ -405,7 +405,8 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
 		return 0; /* no label, nothing to reserve */
 
 	for_each_clear_bit_le(slot, free, nslot) {
-		struct nd_namespace_label *nd_label;
+		struct nd_lsa_label *nd_label;
+		struct nd_namespace_label *ns_label;
 		struct nd_region *nd_region = NULL;
 		struct nd_label_id label_id;
 		struct resource *res;
@@ -413,16 +414,17 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
 		u32 flags;
 
 		nd_label = to_label(ndd, slot);
+		ns_label = &nd_label->ns_label;
 
 		if (!slot_valid(ndd, nd_label, slot))
 			continue;
 
-		nsl_get_uuid(ndd, nd_label, &label_uuid);
-		flags = nsl_get_flags(ndd, nd_label);
+		nsl_get_uuid(ndd, ns_label, &label_uuid);
+		flags = nsl_get_flags(ndd, ns_label);
 		nd_label_gen_id(&label_id, &label_uuid, flags);
 		res = nvdimm_allocate_dpa(ndd, &label_id,
-					  nsl_get_dpa(ndd, nd_label),
-					  nsl_get_rawsize(ndd, nd_label));
+					  nsl_get_dpa(ndd, ns_label),
+					  nsl_get_rawsize(ndd, ns_label));
 		nd_dbg_dpa(nd_region, ndd, res, "reserve\n");
 		if (!res)
 			return -EBUSY;
@@ -564,14 +566,14 @@ int nd_label_active_count(struct nvdimm_drvdata *ndd)
 		return 0;
 
 	for_each_clear_bit_le(slot, free, nslot) {
-		struct nd_namespace_label *nd_label;
+		struct nd_lsa_label *nd_label;
 
 		nd_label = to_label(ndd, slot);
 
 		if (!slot_valid(ndd, nd_label, slot)) {
-			u32 label_slot = nsl_get_slot(ndd, nd_label);
-			u64 size = nsl_get_rawsize(ndd, nd_label);
-			u64 dpa = nsl_get_dpa(ndd, nd_label);
+			u32 label_slot = nsl_get_slot(ndd, &nd_label->ns_label);
+			u64 size = nsl_get_rawsize(ndd, &nd_label->ns_label);
+			u64 dpa = nsl_get_dpa(ndd, &nd_label->ns_label);
 
 			dev_dbg(ndd->dev,
 				"slot%d invalid slot: %d dpa: %llx size: %llx\n",
@@ -583,7 +585,7 @@ int nd_label_active_count(struct nvdimm_drvdata *ndd)
 	return count;
 }
 
-struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
+struct nd_lsa_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
 {
 	struct nd_namespace_index *nsindex;
 	unsigned long *free;
@@ -593,7 +595,7 @@ struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
 		return NULL;
 
 	for_each_clear_bit_le(slot, free, nslot) {
-		struct nd_namespace_label *nd_label;
+		struct nd_lsa_label *nd_label;
 
 		nd_label = to_label(ndd, slot);
 		if (!slot_valid(ndd, nd_label, slot))
@@ -731,7 +733,7 @@ static int nd_label_write_index(struct nvdimm_drvdata *ndd, int index, u32 seq,
 }
 
 static unsigned long nd_label_offset(struct nvdimm_drvdata *ndd,
-		struct nd_namespace_label *nd_label)
+		struct nd_lsa_label *nd_label)
 {
 	return (unsigned long) nd_label
 		- (unsigned long) to_namespace_index(ndd, 0);
@@ -885,7 +887,8 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	struct nd_namespace_common *ndns = &nspm->nsio.common;
 	struct nd_interleave_set *nd_set = nd_region->nd_set;
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
-	struct nd_namespace_label *nd_label;
+	struct nd_lsa_label *nd_label;
+	struct nd_namespace_label *ns_label;
 	struct nd_namespace_index *nsindex;
 	struct nd_label_ent *label_ent;
 	struct nd_label_id label_id;
@@ -918,20 +921,22 @@ static int __pmem_label_update(struct nd_region *nd_region,
 
 	nd_label = to_label(ndd, slot);
 	memset(nd_label, 0, sizeof_namespace_label(ndd));
-	nsl_set_uuid(ndd, nd_label, nspm->uuid);
-	nsl_set_name(ndd, nd_label, nspm->alt_name);
-	nsl_set_flags(ndd, nd_label, flags);
-	nsl_set_nlabel(ndd, nd_label, nd_region->ndr_mappings);
-	nsl_set_nrange(ndd, nd_label, 1);
-	nsl_set_position(ndd, nd_label, pos);
-	nsl_set_isetcookie(ndd, nd_label, cookie);
-	nsl_set_rawsize(ndd, nd_label, resource_size(res));
-	nsl_set_lbasize(ndd, nd_label, nspm->lbasize);
-	nsl_set_dpa(ndd, nd_label, res->start);
-	nsl_set_slot(ndd, nd_label, slot);
-	nsl_set_type_guid(ndd, nd_label, &nd_set->type_guid);
-	nsl_set_claim_class(ndd, nd_label, ndns->claim_class);
-	nsl_calculate_checksum(ndd, nd_label);
+
+	ns_label = &nd_label->ns_label;
+	nsl_set_uuid(ndd, ns_label, nspm->uuid);
+	nsl_set_name(ndd, ns_label, nspm->alt_name);
+	nsl_set_flags(ndd, ns_label, flags);
+	nsl_set_nlabel(ndd, ns_label, nd_region->ndr_mappings);
+	nsl_set_nrange(ndd, ns_label, 1);
+	nsl_set_position(ndd, ns_label, pos);
+	nsl_set_isetcookie(ndd, ns_label, cookie);
+	nsl_set_rawsize(ndd, ns_label, resource_size(res));
+	nsl_set_lbasize(ndd, ns_label, nspm->lbasize);
+	nsl_set_dpa(ndd, ns_label, res->start);
+	nsl_set_slot(ndd, ns_label, slot);
+	nsl_set_type_guid(ndd, ns_label, &nd_set->type_guid);
+	nsl_set_claim_class(ndd, ns_label, ndns->claim_class);
+	nsl_calculate_checksum(ndd, ns_label);
 	nd_dbg_dpa(nd_region, ndd, res, "\n");
 
 	/* update label */
@@ -947,7 +952,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
 		if (!label_ent->label)
 			continue;
 		if (test_and_clear_bit(ND_LABEL_REAP, &label_ent->flags) ||
-		    nsl_uuid_equal(ndd, label_ent->label, nspm->uuid))
+		    nsl_uuid_equal(ndd, &label_ent->label->ns_label, nspm->uuid))
 			reap_victim(nd_mapping, label_ent);
 	}
 
@@ -1035,12 +1040,12 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
 
 	mutex_lock(&nd_mapping->lock);
 	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
-		struct nd_namespace_label *nd_label = label_ent->label;
+		struct nd_lsa_label *nd_label = label_ent->label;
 
 		if (!nd_label)
 			continue;
 		active++;
-		if (!nsl_uuid_equal(ndd, nd_label, uuid))
+		if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
 			continue;
 		active--;
 		slot = to_slot(ndd, nd_label);
diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
index 0650fb4b9821..4883b3a1320f 100644
--- a/drivers/nvdimm/label.h
+++ b/drivers/nvdimm/label.h
@@ -183,6 +183,16 @@ struct nd_namespace_label {
 	};
 };
 
+/*
+ * LSA 2.1 format introduces region label, which can also reside
+ * into LSA along with only namespace label as per v1.1 and v1.2
+ */
+struct nd_lsa_label {
+	union {
+		struct nd_namespace_label ns_label;
+	};
+};
+
 #define NVDIMM_BTT_GUID "8aed63a2-29a2-4c66-8b12-f05d15d3922a"
 #define NVDIMM_BTT2_GUID "18633bfc-1735-4217-8ac9-17239282d3f8"
 #define NVDIMM_PFN_GUID "266400ba-fb9f-4677-bcb0-968f11d0d225"
@@ -215,7 +225,7 @@ struct nvdimm_drvdata;
 int nd_label_data_init(struct nvdimm_drvdata *ndd);
 size_t sizeof_namespace_index(struct nvdimm_drvdata *ndd);
 int nd_label_active_count(struct nvdimm_drvdata *ndd);
-struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n);
+struct nd_lsa_label *nd_label_active(struct nvdimm_drvdata *ndd, int n);
 u32 nd_label_alloc_slot(struct nvdimm_drvdata *ndd);
 bool nd_label_free_slot(struct nvdimm_drvdata *ndd, u32 slot);
 u32 nd_label_nfree(struct nvdimm_drvdata *ndd);
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 55cfbf1e0a95..f180f0068c15 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1009,15 +1009,15 @@ static int namespace_update_uuid(struct nd_region *nd_region,
 
 		mutex_lock(&nd_mapping->lock);
 		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
-			struct nd_namespace_label *nd_label = label_ent->label;
+			struct nd_lsa_label *nd_label = label_ent->label;
 			struct nd_label_id label_id;
 			uuid_t uuid;
 
 			if (!nd_label)
 				continue;
-			nsl_get_uuid(ndd, nd_label, &uuid);
+			nsl_get_uuid(ndd, &nd_label->ns_label, &uuid);
 			nd_label_gen_id(&label_id, &uuid,
-					nsl_get_flags(ndd, nd_label));
+					nsl_get_flags(ndd, &nd_label->ns_label));
 			if (strcmp(old_label_id.id, label_id.id) == 0)
 				set_bit(ND_LABEL_REAP, &label_ent->flags);
 		}
@@ -1562,7 +1562,7 @@ static struct device **create_namespace_io(struct nd_region *nd_region)
 static bool has_uuid_at_pos(struct nd_region *nd_region, const uuid_t *uuid,
 			    u64 cookie, u16 pos)
 {
-	struct nd_namespace_label *found = NULL;
+	struct nd_lsa_label *found = NULL;
 	int i;
 
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
@@ -1573,20 +1573,21 @@ static bool has_uuid_at_pos(struct nd_region *nd_region, const uuid_t *uuid,
 		bool found_uuid = false;
 
 		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
-			struct nd_namespace_label *nd_label = label_ent->label;
+			struct nd_lsa_label *nd_label = label_ent->label;
 			u16 position;
 
 			if (!nd_label)
 				continue;
-			position = nsl_get_position(ndd, nd_label);
+			position = nsl_get_position(ndd, &nd_label->ns_label);
 
-			if (!nsl_validate_isetcookie(ndd, nd_label, cookie))
+			if (!nsl_validate_isetcookie(ndd, &nd_label->ns_label,
+						     cookie))
 				continue;
 
-			if (!nsl_uuid_equal(ndd, nd_label, uuid))
+			if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
 				continue;
 
-			if (!nsl_validate_type_guid(ndd, nd_label,
+			if (!nsl_validate_type_guid(ndd, &nd_label->ns_label,
 						    &nd_set->type_guid))
 				continue;
 
@@ -1595,7 +1596,8 @@ static bool has_uuid_at_pos(struct nd_region *nd_region, const uuid_t *uuid,
 				return false;
 			}
 			found_uuid = true;
-			if (!nsl_validate_nlabel(nd_region, ndd, nd_label))
+			if (!nsl_validate_nlabel(nd_region,
+						 ndd, &nd_label->ns_label))
 				continue;
 			if (position != pos)
 				continue;
@@ -1615,7 +1617,7 @@ static int select_pmem_id(struct nd_region *nd_region, const uuid_t *pmem_id)
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
-		struct nd_namespace_label *nd_label = NULL;
+		struct nd_lsa_label *nd_label = NULL;
 		u64 hw_start, hw_end, pmem_start, pmem_end;
 		struct nd_label_ent *label_ent;
 
@@ -1624,7 +1626,7 @@ static int select_pmem_id(struct nd_region *nd_region, const uuid_t *pmem_id)
 			nd_label = label_ent->label;
 			if (!nd_label)
 				continue;
-			if (nsl_uuid_equal(ndd, nd_label, pmem_id))
+			if (nsl_uuid_equal(ndd, &nd_label->ns_label, pmem_id))
 				break;
 			nd_label = NULL;
 		}
@@ -1640,15 +1642,15 @@ static int select_pmem_id(struct nd_region *nd_region, const uuid_t *pmem_id)
 		 */
 		hw_start = nd_mapping->start;
 		hw_end = hw_start + nd_mapping->size;
-		pmem_start = nsl_get_dpa(ndd, nd_label);
-		pmem_end = pmem_start + nsl_get_rawsize(ndd, nd_label);
+		pmem_start = nsl_get_dpa(ndd, &nd_label->ns_label);
+		pmem_end = pmem_start + nsl_get_rawsize(ndd, &nd_label->ns_label);
 		if (pmem_start >= hw_start && pmem_start < hw_end
 				&& pmem_end <= hw_end && pmem_end > hw_start)
 			/* pass */;
 		else {
 			dev_dbg(&nd_region->dev, "%s invalid label for %pUb\n",
 				dev_name(ndd->dev),
-				nsl_uuid_raw(ndd, nd_label));
+				nsl_uuid_raw(ndd, &nd_label->ns_label));
 			return -EINVAL;
 		}
 
@@ -1668,7 +1670,7 @@ static int select_pmem_id(struct nd_region *nd_region, const uuid_t *pmem_id)
  */
 static struct device *create_namespace_pmem(struct nd_region *nd_region,
 					    struct nd_mapping *nd_mapping,
-					    struct nd_namespace_label *nd_label)
+					    struct nd_lsa_label *nd_label)
 {
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 	struct nd_namespace_index *nsindex =
@@ -1689,14 +1691,14 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
 		return ERR_PTR(-ENXIO);
 	}
 
-	if (!nsl_validate_isetcookie(ndd, nd_label, cookie)) {
+	if (!nsl_validate_isetcookie(ndd, &nd_label->ns_label, cookie)) {
 		dev_dbg(&nd_region->dev, "invalid cookie in label: %pUb\n",
-			nsl_uuid_raw(ndd, nd_label));
-		if (!nsl_validate_isetcookie(ndd, nd_label, altcookie))
+			nsl_uuid_raw(ndd, &nd_label->ns_label));
+		if (!nsl_validate_isetcookie(ndd, &nd_label->ns_label, altcookie))
 			return ERR_PTR(-EAGAIN);
 
 		dev_dbg(&nd_region->dev, "valid altcookie in label: %pUb\n",
-			nsl_uuid_raw(ndd, nd_label));
+			nsl_uuid_raw(ndd, &nd_label->ns_label));
 	}
 
 	nspm = kzalloc(sizeof(*nspm), GFP_KERNEL);
@@ -1712,7 +1714,7 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
 	res->flags = IORESOURCE_MEM;
 
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
-		nsl_get_uuid(ndd, nd_label, &uuid);
+		nsl_get_uuid(ndd, &nd_label->ns_label, &uuid);
 		if (has_uuid_at_pos(nd_region, &uuid, cookie, i))
 			continue;
 		if (has_uuid_at_pos(nd_region, &uuid, altcookie, i))
@@ -1729,7 +1731,7 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
 		 * find a dimm with two instances of the same uuid.
 		 */
 		dev_err(&nd_region->dev, "%s missing label for %pUb\n",
-			nvdimm_name(nvdimm), nsl_uuid_raw(ndd, nd_label));
+			nvdimm_name(nvdimm), nsl_uuid_raw(ndd, &nd_label->ns_label));
 		rc = -EINVAL;
 		goto err;
 	}
@@ -1739,14 +1741,14 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
 	 * that position at labels[0], and NULL at labels[1].  In the process,
 	 * check that the namespace aligns with interleave-set.
 	 */
-	nsl_get_uuid(ndd, nd_label, &uuid);
+	nsl_get_uuid(ndd, &nd_label->ns_label, &uuid);
 	rc = select_pmem_id(nd_region, &uuid);
 	if (rc)
 		goto err;
 
 	/* Calculate total size and populate namespace properties from label0 */
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
-		struct nd_namespace_label *label0;
+		struct nd_lsa_label *label0;
 		struct nvdimm_drvdata *ndd;
 
 		nd_mapping = &nd_region->mapping[i];
@@ -1760,17 +1762,17 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
 		}
 
 		ndd = to_ndd(nd_mapping);
-		size += nsl_get_rawsize(ndd, label0);
-		if (nsl_get_position(ndd, label0) != 0)
+		size += nsl_get_rawsize(ndd, &label0->ns_label);
+		if (nsl_get_position(ndd, &label0->ns_label) != 0)
 			continue;
 		WARN_ON(nspm->alt_name || nspm->uuid);
-		nspm->alt_name = kmemdup(nsl_ref_name(ndd, label0),
+		nspm->alt_name = kmemdup(nsl_ref_name(ndd, &label0->ns_label),
 					 NSLABEL_NAME_LEN, GFP_KERNEL);
-		nsl_get_uuid(ndd, label0, &uuid);
+		nsl_get_uuid(ndd, &label0->ns_label, &uuid);
 		nspm->uuid = kmemdup(&uuid, sizeof(uuid_t), GFP_KERNEL);
-		nspm->lbasize = nsl_get_lbasize(ndd, label0);
+		nspm->lbasize = nsl_get_lbasize(ndd, &label0->ns_label);
 		nspm->nsio.common.claim_class =
-			nsl_get_claim_class(ndd, label0);
+			nsl_get_claim_class(ndd, &label0->ns_label);
 	}
 
 	if (!nspm->alt_name || !nspm->uuid) {
@@ -1887,7 +1889,7 @@ void nd_region_create_btt_seed(struct nd_region *nd_region)
 }
 
 static int add_namespace_resource(struct nd_region *nd_region,
-		struct nd_namespace_label *nd_label, struct device **devs,
+		struct nd_lsa_label *nd_label, struct device **devs,
 		int count)
 {
 	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
@@ -1902,7 +1904,7 @@ static int add_namespace_resource(struct nd_region *nd_region,
 			continue;
 		}
 
-		if (!nsl_uuid_equal(ndd, nd_label, uuid))
+		if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
 			continue;
 		dev_err(&nd_region->dev,
 			"error: conflicting extents for uuid: %pUb\n", uuid);
@@ -1943,15 +1945,15 @@ static struct device **scan_labels(struct nd_region *nd_region)
 
 	/* "safe" because create_namespace_pmem() might list_move() label_ent */
 	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
-		struct nd_namespace_label *nd_label = label_ent->label;
+		struct nd_lsa_label *nd_label = label_ent->label;
 		struct device **__devs;
 
 		if (!nd_label)
 			continue;
 
 		/* skip labels that describe extents outside of the region */
-		if (nsl_get_dpa(ndd, nd_label) < nd_mapping->start ||
-		    nsl_get_dpa(ndd, nd_label) > map_end)
+		if (nsl_get_dpa(ndd, &nd_label->ns_label) < nd_mapping->start ||
+		    nsl_get_dpa(ndd, &nd_label->ns_label) > map_end)
 			continue;
 
 		i = add_namespace_resource(nd_region, nd_label, devs, count);
@@ -2122,7 +2124,7 @@ static int init_active_labels(struct nd_region *nd_region)
 		if (!count)
 			continue;
 		for (j = 0; j < count; j++) {
-			struct nd_namespace_label *label;
+			struct nd_lsa_label *label;
 
 			label_ent = kzalloc(sizeof(*label_ent), GFP_KERNEL);
 			if (!label_ent)
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 304f0e9904f1..2ead96ac598b 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -376,7 +376,7 @@ enum nd_label_flags {
 struct nd_label_ent {
 	struct list_head list;
 	unsigned long flags;
-	struct nd_namespace_label *label;
+	struct nd_lsa_label *label;
 };
 
 enum nd_mapping_lock_class {
-- 
2.34.1


