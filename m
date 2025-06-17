Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5695F199947
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750165646; cv=none; b=YFiV2mjkXr5HUuXP79sFNbtzVPsyUnir2rW19Xlm7Fq1IjaS4xJgbyyX11puDObg9ylQo9IskOOBUV6wy2EJddhtCA7FaHSbyFfIyqT6uQnG4yZ5CIejN6LtmUFG563KCye3G3mYe7v832LR+FkKW9rS9fOdKytGWddNnBWmnLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750165646; c=relaxed/simple;
	bh=SXglxYJm3kykRFcg2mUYP7HlJ5JimJdAoRTYsOeEBZI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=iykUhOgnFgAENk1ATPZuxPL/nYRcKdl+lt0uc9etM963TYyMksGKqae6pqi9mK0/nl0t0syAR3SpUtTzhwJNiOCW+Kj/eLIScblU9yIyrNCcxeOSqe48/tIeuAmbaqY9TyKYTBasTDUNcoRt300P7jBcf+hhjNaCgd3yjkorBzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=D99vWlnB; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="D99vWlnB"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250617130004epoutp020f2a14b87d3b42adb80436cf5a4de66f~J1fspq5Rb2363023630epoutp02r
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:00:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250617130004epoutp020f2a14b87d3b42adb80436cf5a4de66f~J1fspq5Rb2363023630epoutp02r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750165204;
	bh=7H8FItXHZnyaOwFyXZ68yq7arH/yEadM3eU/M988Hms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D99vWlnBuQS6VtWd9bIUNMC3DAZldtNdAPLKbd1OtgkzB2LBWXKpx0oilkOmZ7POL
	 Lps5xjANSHjVodw10VFjFZgHrWQSBc9Xz6UVqMwSg4U4vdK7kJPEVhn89j/yjTzuW8
	 cS0fxxkwWlQqZqny+ntCbMDDALW7KE+5sFad5LOE=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250617130004epcas5p10ae12ee0b4673ae2da3d20c4d7aaef2b~J1fsEYvNb2452824528epcas5p1k;
	Tue, 17 Jun 2025 13:00:04 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bM6R81s4Sz3hhTB; Tue, 17 Jun
	2025 13:00:04 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250617124013epcas5p3c241c626448fcf7851a100fdf2816160~J1OXewFJB2103821038epcas5p3S;
	Tue, 17 Jun 2025 12:40:13 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250617124011epsmtip20589d4013bbfae3a6988883eb57982fe~J1OU-Of5k2544925449epsmtip2k;
	Tue, 17 Jun 2025 12:40:11 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: dan.j.williams@intel.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, s.neeraj@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: [RFC PATCH 03/20] nvdimm/namespace_label: Add namespace label
 changes as per CXL LSA v2.1
Date: Tue, 17 Jun 2025 18:09:27 +0530
Message-Id: <1279309678.121750165204255.JavaMail.epsvc@epcpadp1new>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250617123944.78345-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250617124013epcas5p3c241c626448fcf7851a100fdf2816160
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124013epcas5p3c241c626448fcf7851a100fdf2816160
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124013epcas5p3c241c626448fcf7851a100fdf2816160@epcas5p3.samsung.com>

CXL 3.2 Spec mentions CXL LSA 2.1 Namespace Labels at section 9.13.2.5
Modified __pmem_label_update function using setter functions to update
namespace label as per CXL LSA 2.1

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c |  3 +++
 drivers/nvdimm/nd.h    | 27 +++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 30bccad98939..d5cfaa99f976 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -923,6 +923,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	memset(nd_label, 0, sizeof_namespace_label(ndd));
 
 	ns_label = &nd_label->ns_label;
+	nsl_set_type(ndd, ns_label);
 	nsl_set_uuid(ndd, ns_label, nspm->uuid);
 	nsl_set_name(ndd, ns_label, nspm->alt_name);
 	nsl_set_flags(ndd, ns_label, flags);
@@ -934,7 +935,9 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	nsl_set_lbasize(ndd, ns_label, nspm->lbasize);
 	nsl_set_dpa(ndd, ns_label, res->start);
 	nsl_set_slot(ndd, ns_label, slot);
+	nsl_set_alignment(ndd, ns_label, 0);
 	nsl_set_type_guid(ndd, ns_label, &nd_set->type_guid);
+	nsl_set_region_uuid(ndd, ns_label, NULL);
 	nsl_set_claim_class(ndd, ns_label, ndns->claim_class);
 	nsl_calculate_checksum(ndd, ns_label);
 	nd_dbg_dpa(nd_region, ndd, res, "\n");
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 2ead96ac598b..07d665f18bf6 100644
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


