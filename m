Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3B435C1A8
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962709; cv=none; b=MeG9OLAPmRLwK72inDU3h/awquFFdYlTyHutz5yx4BrDPq3KjkjeemXdiPchB1cyq+6pwTfTNbXTX3qKHx8K5olNE0d1iR/FVaL2RkHaTgZqdjnO0CFJnKpuFdk3356M5G9KMAZ6TliqkxcI5rKHSkwMr4/d/J90fWHxvSuIQw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962709; c=relaxed/simple;
	bh=2w4QHGOCw++q1kvhal2TldeR8J4oIxIGDuYaRPud1Nw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=WGHoclDD9pfPeeDCJwx0o7SJVo1w4XMI5h0z6ptuJk2XQaIKTWTCG2bwQXR++2PSS98pedHDsIh9S5KH9AlfQZJsDIiM3HVPeorxAeqn2lCGv8JBL1l5b3Iqp31cTZORiZbLN4xtG/bUQqmFsMsfJycUhZf5ZGOEWYLDbX5Fvc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=i3i2U3mj; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="i3i2U3mj"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260109124505epoutp0290d08ea0db4b78409350df84927074b6~JELaf1mNu2083220832epoutp02b
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:45:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260109124505epoutp0290d08ea0db4b78409350df84927074b6~JELaf1mNu2083220832epoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767962705;
	bh=6Ls7B2htQErg67j/Et/0NeQpLttPeWzT3//fPeN7TuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i3i2U3mjbV8qmvXWRYo4ebCaXhqrzLtQC1YI51TxBvPrnWqHuF6gEB+16WupzPaMU
	 a8swdxtYOCZBIOLATCX8emsNmUZhCk2k6ixjWjx1+/AwkNxXZb6f4rU1I0ncPGikrg
	 Jn6oGsEGhD/gYdbrFZryYZ4yQ+lPlEeqwLDS0uVM=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260109124504epcas5p2527ba909dbc68df57a3829797f6755ff~JELaDQdvK0900109001epcas5p2z;
	Fri,  9 Jan 2026 12:45:04 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.89]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dnhLm0g3Zz6B9m5; Fri,  9 Jan
	2026 12:45:04 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260109124503epcas5p27010aaf98c7c3735852cbb18bd68458e~JELY9rDMK2073820738epcas5p2L;
	Fri,  9 Jan 2026 12:45:03 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260109124457epsmtip17bdcc41e92c2e42498b48bdb89cccfdf~JELTdsLR00972509725epsmtip1Q;
	Fri,  9 Jan 2026 12:44:57 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V5 03/17] nvdimm/label: Add namespace/region label support
 as per LSA 2.1
Date: Fri,  9 Jan 2026 18:14:23 +0530
Message-Id: <20260109124437.4025893-4-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260109124437.4025893-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260109124503epcas5p27010aaf98c7c3735852cbb18bd68458e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260109124503epcas5p27010aaf98c7c3735852cbb18bd68458e
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124503epcas5p27010aaf98c7c3735852cbb18bd68458e@epcas5p2.samsung.com>

Modify __pmem_label_update() to update region labels into LSA

CXL 3.2 Spec mentions CXL LSA 2.1 Namespace Labels at section 9.13.2.5
Modified __pmem_label_update() using setter functions to update
namespace label as per CXL LSA 2.1

Create export routine nd_region_label_update() used for creating
region label into LSA. It will be used later from CXL subsystem

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c          | 360 ++++++++++++++++++++++++++------
 drivers/nvdimm/label.h          |  17 +-
 drivers/nvdimm/namespace_devs.c |  20 +-
 drivers/nvdimm/nd.h             |  51 +++++
 include/linux/libnvdimm.h       |   8 +
 5 files changed, 386 insertions(+), 70 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 0a9b6c5cb2c3..17e2a1f5a6da 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -22,8 +22,8 @@ static uuid_t nvdimm_btt2_uuid;
 static uuid_t nvdimm_pfn_uuid;
 static uuid_t nvdimm_dax_uuid;
 
-static uuid_t cxl_region_uuid;
-static uuid_t cxl_namespace_uuid;
+uuid_t cxl_region_uuid;
+uuid_t cxl_namespace_uuid;
 
 static const char NSINDEX_SIGNATURE[] = "NAMESPACE_INDEX\0";
 
@@ -278,15 +278,38 @@ static struct nd_namespace_label *nd_label_base(struct nvdimm_drvdata *ndd)
 	return base + 2 * sizeof_namespace_index(ndd);
 }
 
+static unsigned long find_slot(struct nvdimm_drvdata *ndd,
+			       unsigned long label)
+{
+	unsigned long base;
+
+	base = (unsigned long)nd_label_base(ndd);
+	return (label - base) / sizeof_namespace_label(ndd);
+}
+
+static int to_lsa_slot(struct nvdimm_drvdata *ndd,
+		       union nd_lsa_label *lsa_label)
+{
+	return find_slot(ndd, (unsigned long) lsa_label);
+}
+
 static int to_slot(struct nvdimm_drvdata *ndd,
-		struct nd_namespace_label *nd_label)
+		   struct nd_label_ent *label_ent)
+{
+	if (uuid_equal(&cxl_region_uuid, &label_ent->label_uuid))
+		return find_slot(ndd, (unsigned long) label_ent->region_label);
+	else
+		return find_slot(ndd, (unsigned long) label_ent->label);
+}
+
+static union nd_lsa_label *to_lsa_label(struct nvdimm_drvdata *ndd, int slot)
 {
 	unsigned long label, base;
 
-	label = (unsigned long) nd_label;
 	base = (unsigned long) nd_label_base(ndd);
+	label = base + sizeof_namespace_label(ndd) * slot;
 
-	return (label - base) / sizeof_namespace_label(ndd);
+	return (union nd_lsa_label *) label;
 }
 
 static struct nd_namespace_label *to_label(struct nvdimm_drvdata *ndd, int slot)
@@ -381,6 +404,16 @@ static void nsl_calculate_checksum(struct nvdimm_drvdata *ndd,
 	nsl_set_checksum(ndd, nd_label, sum);
 }
 
+static void region_label_calculate_checksum(struct nvdimm_drvdata *ndd,
+				   struct cxl_region_label *region_label)
+{
+	u64 sum;
+
+	region_label->checksum = __cpu_to_le64(0);
+	sum = nd_fletcher64(region_label, sizeof_namespace_label(ndd), 1);
+	region_label->checksum = __cpu_to_le64(sum);
+}
+
 static bool slot_valid(struct nvdimm_drvdata *ndd,
 		struct nd_namespace_label *nd_label, u32 slot)
 {
@@ -584,7 +617,7 @@ int nd_label_active_count(struct nvdimm_drvdata *ndd)
 	return count;
 }
 
-struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
+union nd_lsa_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
 {
 	struct nd_namespace_index *nsindex;
 	unsigned long *free;
@@ -601,7 +634,7 @@ struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
 			continue;
 
 		if (n-- == 0)
-			return to_label(ndd, slot);
+			return to_lsa_label(ndd, slot);
 	}
 
 	return NULL;
@@ -737,9 +770,9 @@ static int nd_label_write_index(struct nvdimm_drvdata *ndd, int index, u32 seq,
 }
 
 static unsigned long nd_label_offset(struct nvdimm_drvdata *ndd,
-		struct nd_namespace_label *nd_label)
+		union nd_lsa_label *lsa_label)
 {
-	return (unsigned long) nd_label
+	return (unsigned long) lsa_label
 		- (unsigned long) to_namespace_index(ndd, 0);
 }
 
@@ -823,11 +856,15 @@ static void reap_victim(struct nd_mapping *nd_mapping,
 		struct nd_label_ent *victim)
 {
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
-	u32 slot = to_slot(ndd, victim->label);
+	u32 slot = to_slot(ndd, victim);
 
 	dev_dbg(ndd->dev, "free: %d\n", slot);
 	nd_label_free_slot(ndd, slot);
-	victim->label = NULL;
+
+	if (uuid_equal(&cxl_region_uuid, &victim->label_uuid))
+		victim->region_label = NULL;
+	else
+		victim->label = NULL;
 }
 
 static void nsl_set_type_guid(struct nvdimm_drvdata *ndd,
@@ -884,26 +921,20 @@ enum nvdimm_claim_class nsl_get_claim_class(struct nvdimm_drvdata *ndd,
 	return guid_to_nvdimm_cclass(&nd_label->efi.abstraction_guid);
 }
 
-static int __pmem_label_update(struct nd_region *nd_region,
-		struct nd_mapping *nd_mapping, struct nd_namespace_pmem *nspm,
-		int pos, unsigned long flags)
+static int namespace_label_update(struct nd_region *nd_region,
+				  struct nd_mapping *nd_mapping,
+				  struct nd_namespace_pmem *nspm,
+				  int pos, u64 flags,
+				  struct nd_namespace_label *ns_label,
+				  struct nd_namespace_index *nsindex,
+				  u32 slot)
 {
 	struct nd_namespace_common *ndns = &nspm->nsio.common;
 	struct nd_interleave_set *nd_set = nd_region->nd_set;
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
-	struct nd_namespace_label *nd_label;
-	struct nd_namespace_index *nsindex;
-	struct nd_label_ent *label_ent;
 	struct nd_label_id label_id;
 	struct resource *res;
-	unsigned long *free;
-	u32 nslot, slot;
-	size_t offset;
 	u64 cookie;
-	int rc;
-
-	if (!preamble_next(ndd, &nsindex, &free, &nslot))
-		return -ENXIO;
 
 	cookie = nd_region_interleave_set_cookie(nd_region, nsindex);
 	nd_label_gen_id(&label_id, nspm->uuid, 0);
@@ -916,33 +947,150 @@ static int __pmem_label_update(struct nd_region *nd_region,
 		return -ENXIO;
 	}
 
+	nsl_set_type(ndd, ns_label);
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
+	nsl_set_alignment(ndd, ns_label, 0);
+	nsl_set_type_guid(ndd, ns_label, &nd_set->type_guid);
+	nsl_set_region_uuid(ndd, ns_label, &nd_set->uuid);
+	nsl_set_claim_class(ndd, ns_label, ndns->claim_class);
+	nsl_calculate_checksum(ndd, ns_label);
+	nd_dbg_dpa(nd_region, ndd, res, "\n");
+
+	return 0;
+}
+
+static void region_label_update(struct nd_region *nd_region,
+				struct cxl_region_label *region_label,
+				struct nd_mapping *nd_mapping,
+				int pos, u64 flags, u32 slot)
+{
+	struct nd_interleave_set *nd_set = nd_region->nd_set;
+	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+
+	/* Set Region Label Format identification UUID */
+	uuid_copy((uuid_t *)region_label->type, &cxl_region_uuid);
+
+	/* Set Current Region Label UUID */
+	export_uuid(region_label->uuid, &nd_set->uuid);
+
+	region_label->flags = __cpu_to_le32(flags);
+	region_label->nlabel = __cpu_to_le16(nd_region->ndr_mappings);
+	region_label->position = __cpu_to_le16(pos);
+	region_label->dpa = __cpu_to_le64(nd_mapping->start);
+	region_label->rawsize = __cpu_to_le64(nd_mapping->size);
+	region_label->hpa = __cpu_to_le64(nd_set->res->start);
+	region_label->slot = __cpu_to_le32(slot);
+	region_label->ig = __cpu_to_le32(nd_set->interleave_granularity);
+	region_label->align = __cpu_to_le32(0);
+
+	/* Update fletcher64 Checksum */
+	region_label_calculate_checksum(ndd, region_label);
+}
+
+static bool is_label_reapable(struct nd_interleave_set *nd_set,
+			       struct nd_namespace_pmem *nspm,
+			       struct nvdimm_drvdata *ndd,
+			       struct nd_label_ent *label_ent,
+			       enum label_type ltype,
+			       unsigned long *flags)
+{
+	switch (ltype) {
+	case NS_LABEL_TYPE:
+		if (test_and_clear_bit(ND_LABEL_REAP, flags) ||
+		    nsl_uuid_equal(ndd, label_ent->label, nspm->uuid))
+			return true;
+
+		break;
+	case RG_LABEL_TYPE:
+		if (region_label_uuid_equal(label_ent->region_label,
+		    &nd_set->uuid))
+			return true;
+
+		break;
+	}
+
+	return false;
+}
+
+static bool is_label_present(struct nd_label_ent *label_ent,
+			     enum label_type ltype)
+{
+	switch (ltype) {
+	case NS_LABEL_TYPE:
+		if (label_ent->label)
+			return true;
+
+		break;
+	case RG_LABEL_TYPE:
+		if (label_ent->region_label)
+			return true;
+
+		break;
+	}
+
+	return false;
+}
+
+static int __pmem_label_update(struct nd_region *nd_region,
+			       struct nd_mapping *nd_mapping,
+			       struct nd_namespace_pmem *nspm,
+			       int pos, unsigned long flags,
+			       enum label_type ltype)
+{
+	struct nd_interleave_set *nd_set = nd_region->nd_set;
+	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+	struct nd_namespace_index *nsindex;
+	struct nd_label_ent *label_ent;
+	union nd_lsa_label *lsa_label;
+	unsigned long *free;
+	struct device *dev;
+	u32 nslot, slot;
+	size_t offset;
+	int rc;
+
+	if (!preamble_next(ndd, &nsindex, &free, &nslot))
+		return -ENXIO;
+
 	/* allocate and write the label to the staging (next) index */
 	slot = nd_label_alloc_slot(ndd);
 	if (slot == UINT_MAX)
 		return -ENXIO;
 	dev_dbg(ndd->dev, "allocated: %d\n", slot);
 
-	nd_label = to_label(ndd, slot);
-	memset(nd_label, 0, sizeof_namespace_label(ndd));
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
-	nd_dbg_dpa(nd_region, ndd, res, "\n");
+	lsa_label = to_lsa_label(ndd, slot);
+	memset(lsa_label, 0, sizeof_namespace_label(ndd));
+
+	switch (ltype) {
+	case NS_LABEL_TYPE:
+		dev = &nspm->nsio.common.dev;
+		rc = namespace_label_update(nd_region, nd_mapping,
+				nspm, pos, flags, &lsa_label->ns_label,
+				nsindex, slot);
+		if (rc)
+			return rc;
+
+		break;
+	case RG_LABEL_TYPE:
+		dev = &nd_region->dev;
+		region_label_update(nd_region, &lsa_label->region_label,
+				nd_mapping, pos, flags, slot);
+
+		break;
+	}
 
 	/* update label */
-	offset = nd_label_offset(ndd, nd_label);
-	rc = nvdimm_set_config_data(ndd, offset, nd_label,
+	offset = nd_label_offset(ndd, lsa_label);
+	rc = nvdimm_set_config_data(ndd, offset, lsa_label,
 			sizeof_namespace_label(ndd));
 	if (rc < 0)
 		return rc;
@@ -950,10 +1098,11 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	/* Garbage collect the previous label */
 	mutex_lock(&nd_mapping->lock);
 	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
-		if (!label_ent->label)
+		if (!is_label_present(label_ent, ltype))
 			continue;
-		if (test_and_clear_bit(ND_LABEL_REAP, &label_ent->flags) ||
-		    nsl_uuid_equal(ndd, label_ent->label, nspm->uuid))
+
+		if (is_label_reapable(nd_set, nspm, ndd, label_ent, ltype,
+					&label_ent->flags))
 			reap_victim(nd_mapping, label_ent);
 	}
 
@@ -961,16 +1110,21 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	rc = nd_label_write_index(ndd, ndd->ns_next,
 			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
 	if (rc == 0) {
-		list_for_each_entry(label_ent, &nd_mapping->labels, list)
-			if (!label_ent->label) {
-				label_ent->label = nd_label;
-				nd_label = NULL;
-				break;
-			}
-		dev_WARN_ONCE(&nspm->nsio.common.dev, nd_label,
-				"failed to track label: %d\n",
-				to_slot(ndd, nd_label));
-		if (nd_label)
+		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
+			if (is_label_present(label_ent, ltype))
+				continue;
+
+			if (ltype == NS_LABEL_TYPE)
+				label_ent->label = &lsa_label->ns_label;
+			else
+				label_ent->region_label = &lsa_label->region_label;
+
+			lsa_label = NULL;
+			break;
+		}
+		dev_WARN_ONCE(dev, lsa_label, "failed to track label: %d\n",
+			      to_lsa_slot(ndd, lsa_label));
+		if (lsa_label)
 			rc = -ENXIO;
 	}
 	mutex_unlock(&nd_mapping->lock);
@@ -978,7 +1132,8 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	return rc;
 }
 
-static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
+static int init_labels(struct nd_mapping *nd_mapping, int num_labels,
+		       enum label_type ltype)
 {
 	int i, old_num_labels = 0;
 	struct nd_label_ent *label_ent;
@@ -998,6 +1153,16 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
 		label_ent = kzalloc(sizeof(*label_ent), GFP_KERNEL);
 		if (!label_ent)
 			return -ENOMEM;
+
+		switch (ltype) {
+		case NS_LABEL_TYPE:
+			uuid_copy(&label_ent->label_uuid, &cxl_namespace_uuid);
+			break;
+		case RG_LABEL_TYPE:
+			uuid_copy(&label_ent->label_uuid, &cxl_region_uuid);
+			break;
+		}
+
 		mutex_lock(&nd_mapping->lock);
 		list_add_tail(&label_ent->list, &nd_mapping->labels);
 		mutex_unlock(&nd_mapping->lock);
@@ -1041,19 +1206,19 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
 
 	mutex_lock(&nd_mapping->lock);
 	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
-		struct nd_namespace_label *nd_label = label_ent->label;
-
-		if (!nd_label)
+		if (label_ent->label)
 			continue;
 		active++;
-		if (!nsl_uuid_equal(ndd, nd_label, uuid))
+		if (!nsl_uuid_equal(ndd, label_ent->label, uuid))
 			continue;
 		active--;
-		slot = to_slot(ndd, nd_label);
+		slot = to_slot(ndd, label_ent);
 		nd_label_free_slot(ndd, slot);
 		dev_dbg(ndd->dev, "free: %d\n", slot);
 		list_move_tail(&label_ent->list, &list);
-		label_ent->label = NULL;
+
+		if (uuid_equal(&cxl_namespace_uuid, &label_ent->label_uuid))
+			label_ent->label = NULL;
 	}
 	list_splice_tail_init(&list, &nd_mapping->labels);
 
@@ -1067,6 +1232,19 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
 			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
 }
 
+static int find_region_label_count(struct nd_mapping *nd_mapping)
+{
+	struct nd_label_ent *label_ent;
+	int region_label_cnt = 0;
+
+	guard(mutex)(&nd_mapping->lock);
+	list_for_each_entry(label_ent, &nd_mapping->labels, list)
+		if (uuid_equal(&cxl_region_uuid, &label_ent->label_uuid))
+			region_label_cnt++;
+
+	return region_label_cnt;
+}
+
 int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 		struct nd_namespace_pmem *nspm, resource_size_t size)
 {
@@ -1075,6 +1253,7 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+		int region_label_cnt;
 		struct resource *res;
 		int count = 0;
 
@@ -1090,12 +1269,20 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 				count++;
 		WARN_ON_ONCE(!count);
 
-		rc = init_labels(nd_mapping, count);
+		region_label_cnt = find_region_label_count(nd_mapping);
+		/*
+		 * init_labels() scan labels and allocate new label based
+		 * on its second parameter (num_labels). Therefore to
+		 * allocate new namespace label also include previously
+		 * added region label
+		 */
+		rc = init_labels(nd_mapping, count + region_label_cnt,
+				 NS_LABEL_TYPE);
 		if (rc < 0)
 			return rc;
 
 		rc = __pmem_label_update(nd_region, nd_mapping, nspm, i,
-				NSLABEL_FLAG_UPDATING);
+				NSLABEL_FLAG_UPDATING, NS_LABEL_TYPE);
 		if (rc)
 			return rc;
 	}
@@ -1107,7 +1294,48 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 
-		rc = __pmem_label_update(nd_region, nd_mapping, nspm, i, 0);
+		rc = __pmem_label_update(nd_region, nd_mapping, nspm, i, 0,
+				NS_LABEL_TYPE);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+int nd_pmem_region_label_update(struct nd_region *nd_region)
+{
+	int i, rc;
+
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+		int region_label_cnt;
+
+		/* No need to update region label for non cxl format */
+		if (!ndd->cxl)
+			return 0;
+
+		region_label_cnt = find_region_label_count(nd_mapping);
+		rc = init_labels(nd_mapping, region_label_cnt + 1,
+				 RG_LABEL_TYPE);
+		if (rc < 0)
+			return rc;
+
+		rc = __pmem_label_update(nd_region, nd_mapping, NULL, i,
+				NSLABEL_FLAG_UPDATING, RG_LABEL_TYPE);
+		if (rc)
+			return rc;
+	}
+
+	/* Clear the UPDATING flag per UEFI 2.7 expectations */
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+
+		WARN_ON_ONCE(!ndd->cxl);
+		rc = __pmem_label_update(nd_region, nd_mapping, NULL, i, 0,
+				RG_LABEL_TYPE);
 		if (rc)
 			return rc;
 	}
diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
index 0650fb4b9821..f11f54056353 100644
--- a/drivers/nvdimm/label.h
+++ b/drivers/nvdimm/label.h
@@ -30,6 +30,11 @@ enum {
 	ND_NSINDEX_INIT = 0x1,
 };
 
+enum label_type {
+	RG_LABEL_TYPE,
+	NS_LABEL_TYPE,
+};
+
 /**
  * struct nd_namespace_index - label set superblock
  * @sig: NAMESPACE_INDEX\0
@@ -183,6 +188,15 @@ struct nd_namespace_label {
 	};
 };
 
+/*
+ * LSA 2.1 format introduces region label, which can also reside
+ * into LSA along with only namespace label as per v1.1 and v1.2
+ */
+union nd_lsa_label {
+	struct nd_namespace_label ns_label;
+	struct cxl_region_label region_label;
+};
+
 #define NVDIMM_BTT_GUID "8aed63a2-29a2-4c66-8b12-f05d15d3922a"
 #define NVDIMM_BTT2_GUID "18633bfc-1735-4217-8ac9-17239282d3f8"
 #define NVDIMM_PFN_GUID "266400ba-fb9f-4677-bcb0-968f11d0d225"
@@ -215,7 +229,7 @@ struct nvdimm_drvdata;
 int nd_label_data_init(struct nvdimm_drvdata *ndd);
 size_t sizeof_namespace_index(struct nvdimm_drvdata *ndd);
 int nd_label_active_count(struct nvdimm_drvdata *ndd);
-struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n);
+union nd_lsa_label *nd_label_active(struct nvdimm_drvdata *ndd, int n);
 u32 nd_label_alloc_slot(struct nvdimm_drvdata *ndd);
 bool nd_label_free_slot(struct nvdimm_drvdata *ndd, u32 slot);
 u32 nd_label_nfree(struct nvdimm_drvdata *ndd);
@@ -223,4 +237,5 @@ struct nd_region;
 struct nd_namespace_pmem;
 int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 		struct nd_namespace_pmem *nspm, resource_size_t size);
+int nd_pmem_region_label_update(struct nd_region *nd_region);
 #endif /* __LABEL_H__ */
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 43fdb806532e..657004021c95 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -232,6 +232,13 @@ static ssize_t __alt_name_store(struct device *dev, const char *buf,
 	return rc;
 }
 
+int nd_region_label_update(struct nd_region *nd_region)
+{
+	guard(nvdimm_bus)(&nd_region->dev);
+	return nd_pmem_region_label_update(nd_region);
+}
+EXPORT_SYMBOL_GPL(nd_region_label_update);
+
 static int nd_namespace_label_update(struct nd_region *nd_region,
 		struct device *dev)
 {
@@ -2122,13 +2129,20 @@ static int init_active_labels(struct nd_region *nd_region)
 		if (!count)
 			continue;
 		for (j = 0; j < count; j++) {
-			struct nd_namespace_label *label;
+			union nd_lsa_label *lsa_label;
 
 			label_ent = kzalloc(sizeof(*label_ent), GFP_KERNEL);
 			if (!label_ent)
 				break;
-			label = nd_label_active(ndd, j);
-			label_ent->label = label;
+
+			lsa_label = nd_label_active(ndd, j);
+			if (is_region_label(ndd, lsa_label)) {
+				label_ent->region_label = &lsa_label->region_label;
+				uuid_copy(&label_ent->label_uuid, &cxl_region_uuid);
+			} else {
+				label_ent->label = &lsa_label->ns_label;
+				uuid_copy(&label_ent->label_uuid, &cxl_namespace_uuid);
+			}
 
 			mutex_lock(&nd_mapping->lock);
 			list_add_tail(&label_ent->list, &nd_mapping->labels);
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index f631bd84d6f0..1b31eee3028e 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -14,6 +14,9 @@
 #include <linux/nd.h>
 #include "label.h"
 
+extern uuid_t cxl_namespace_uuid;
+extern uuid_t cxl_region_uuid;
+
 enum {
 	/*
 	 * Limits the maximum number of block apertures a dimm can
@@ -295,6 +298,52 @@ static inline const u8 *nsl_uuid_raw(struct nvdimm_drvdata *ndd,
 	return nd_label->efi.uuid;
 }
 
+static inline void nsl_set_type(struct nvdimm_drvdata *ndd,
+				struct nd_namespace_label *ns_label)
+{
+	if (!(ndd->cxl && ns_label))
+		return;
+
+	export_uuid(ns_label->cxl.type, &cxl_namespace_uuid);
+}
+
+static inline void nsl_set_alignment(struct nvdimm_drvdata *ndd,
+				     struct nd_namespace_label *ns_label,
+				     u32 align)
+{
+	if (!ndd->cxl)
+		return;
+
+	ns_label->cxl.align = __cpu_to_le32(align);
+}
+
+static inline void nsl_set_region_uuid(struct nvdimm_drvdata *ndd,
+				       struct nd_namespace_label *ns_label,
+				       const uuid_t *uuid)
+{
+	if (!(ndd->cxl && uuid))
+		return;
+
+	export_uuid(ns_label->cxl.region_uuid, uuid);
+}
+
+static inline bool is_region_label(struct nvdimm_drvdata *ndd,
+				   union nd_lsa_label *lsa_label)
+{
+	if (!ndd->cxl)
+		return false;
+
+	return uuid_equal(&cxl_region_uuid,
+			  (uuid_t *)lsa_label->region_label.type);
+}
+
+static inline bool
+region_label_uuid_equal(struct cxl_region_label *region_label,
+			const uuid_t *uuid)
+{
+	return uuid_equal((uuid_t *)region_label->uuid, uuid);
+}
+
 bool nsl_validate_type_guid(struct nvdimm_drvdata *ndd,
 			    struct nd_namespace_label *nd_label, guid_t *guid);
 enum nvdimm_claim_class nsl_get_claim_class(struct nvdimm_drvdata *ndd,
@@ -376,7 +425,9 @@ enum nd_label_flags {
 struct nd_label_ent {
 	struct list_head list;
 	unsigned long flags;
+	uuid_t label_uuid;
 	struct nd_namespace_label *label;
+	struct cxl_region_label *region_label;
 };
 
 enum nd_mapping_lock_class {
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 5696715c33bb..2c213b9dac66 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -117,6 +117,13 @@ struct nd_interleave_set {
 	u64 altcookie;
 
 	guid_t type_guid;
+
+	/* v2.1 region label info */
+	uuid_t uuid;
+	int interleave_ways;
+	int interleave_granularity;
+	struct resource *res;
+	int nr_targets;
 };
 
 struct nd_mapping_desc {
@@ -307,6 +314,7 @@ int nvdimm_has_flush(struct nd_region *nd_region);
 int nvdimm_has_cache(struct nd_region *nd_region);
 int nvdimm_in_overwrite(struct nvdimm *nvdimm);
 bool is_nvdimm_sync(struct nd_region *nd_region);
+int nd_region_label_update(struct nd_region *nd_region);
 
 static inline int nvdimm_ctl(struct nvdimm *nvdimm, unsigned int cmd, void *buf,
 		unsigned int buf_len, int *cmd_rc)
-- 
2.34.1

