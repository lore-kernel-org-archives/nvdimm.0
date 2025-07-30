Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082A8298CA6
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753877790; cv=none; b=iCuhbCEd8QUS08IU/2uHhp5qCvnQ18dqhJpoEHqbPNVgLju0XDGpM1/u1SKgoiwy9W9qp8hRDotcbSukWtyiSkX/T26XYxqwEDrraNeBWP6RywSZFhm9UFfpcguC/OZ6g4Znq/Xq+AMTz54Rd7VBTQaqDvuaSjzhsxyJT4N3iro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753877790; c=relaxed/simple;
	bh=ubgQ77Ay9iLzCeDRVGVIN0XHYiPcFRo6Uc0d9fBKo8U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=XRSmMlA8tYWR0mInOU8cEjRGHSqVTz9OqiutOMEVZnkjKEGPdOgfKd8R0KFnQ3PZNj+6oeVM4TjrpzelSm+W1JdBludRC0K+3zyNnwIEj84VnYH9VsCeCio+2zkCwj3tUL8M7zR6er4R4V4Nm9SwTlW+4eES3MrbilEB2eI+o+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=rjw199OU; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="rjw199OU"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250730121627epoutp022e6d7e05639a5d36cd6b022d8b3c1a89~XBo4J0ZPW1755417554epoutp02m
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:16:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250730121627epoutp022e6d7e05639a5d36cd6b022d8b3c1a89~XBo4J0ZPW1755417554epoutp02m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753877787;
	bh=U5/emIoN12tQSoOtVhYi+OjopbJ5LcpFDZlMrYvElV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjw199OU3p43UN3lSmazdYZmB8gwIQ9BJctZYL3guApkKcJClADmWktnyNV41+oF9
	 rIyIeLonB22J//baY7OHfL1IKdDVL0BSSbEShOp6RyhdrY20JeqvmoHWbxpvACGLO/
	 KzDYUiC5E5C4m/tPumDpoq2BWRS03spZamtRaTqM=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250730121626epcas5p118487c64a85208c010b705b3ee14028c~XBo3oACP-1597315973epcas5p1i;
	Wed, 30 Jul 2025 12:16:26 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.89]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4bsWQx3QzLz6B9m5; Wed, 30 Jul
	2025 12:16:25 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250730121225epcas5p2742d108bd0c52c8d7d46b655892c5c19~XBlXiFU-O2146721467epcas5p2g;
	Wed, 30 Jul 2025 12:12:25 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250730121224epsmtip13253f60e17e0bf37ddbc56e42f1609e2~XBlWdw6At0197501975epsmtip13;
	Wed, 30 Jul 2025 12:12:24 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V2 03/20] nvdimm/namespace_label: Add namespace label
 changes as per CXL LSA v2.1
Date: Wed, 30 Jul 2025 17:41:52 +0530
Message-Id: <20250730121209.303202-4-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250730121209.303202-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250730121225epcas5p2742d108bd0c52c8d7d46b655892c5c19
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121225epcas5p2742d108bd0c52c8d7d46b655892c5c19
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121225epcas5p2742d108bd0c52c8d7d46b655892c5c19@epcas5p2.samsung.com>

CXL 3.2 Spec mentions CXL LSA 2.1 Namespace Labels at section 9.13.2.5
Modified __pmem_label_update function using setter functions to update
namespace label as per CXL LSA 2.1

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c |  3 +++
 drivers/nvdimm/nd.h    | 27 +++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 75bc11da4c11..3f8a6bdb77c7 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -933,6 +933,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	memset(lsa_label, 0, sizeof_namespace_label(ndd));
 
 	nd_label = &lsa_label->ns_label;
+	nsl_set_type(ndd, nd_label);
 	nsl_set_uuid(ndd, nd_label, nspm->uuid);
 	nsl_set_name(ndd, nd_label, nspm->alt_name);
 	nsl_set_flags(ndd, nd_label, flags);
@@ -944,7 +945,9 @@ static int __pmem_label_update(struct nd_region *nd_region,
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
index 61348dee687d..651847f1bbf9 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -295,6 +295,33 @@ static inline const u8 *nsl_uuid_raw(struct nvdimm_drvdata *ndd,
 	return nd_label->efi.uuid;
 }
 
+static inline void nsl_set_type(struct nvdimm_drvdata *ndd,
+				struct nd_namespace_label *ns_label)
+{
+	uuid_t tmp;
+
+	if (ndd->cxl) {
+		uuid_parse(CXL_NAMESPACE_UUID, &tmp);
+		export_uuid(ns_label->cxl.type, &tmp);
+	}
+}
+
+static inline void nsl_set_alignment(struct nvdimm_drvdata *ndd,
+				     struct nd_namespace_label *ns_label,
+				     u32 align)
+{
+	if (ndd->cxl)
+		ns_label->cxl.align = __cpu_to_le16(align);
+}
+
+static inline void nsl_set_region_uuid(struct nvdimm_drvdata *ndd,
+				       struct nd_namespace_label *ns_label,
+				       const uuid_t *uuid)
+{
+	if (ndd->cxl)
+		export_uuid(ns_label->cxl.region_uuid, uuid);
+}
+
 bool nsl_validate_type_guid(struct nvdimm_drvdata *ndd,
 			    struct nd_namespace_label *nd_label, guid_t *guid);
 enum nvdimm_claim_class nsl_get_claim_class(struct nvdimm_drvdata *ndd,
-- 
2.34.1

