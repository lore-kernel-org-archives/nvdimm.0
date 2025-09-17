Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8CF333A92
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758116514; cv=none; b=FVdvIGy3QMNDc7ah/hemV7bMnyPZ5QfRgaD5yuovXMachsy+6eImhwhJoG6eNzOo7rXCLIsR36CKWVtB5jpDp4iF0dSq+yHjGSHroTErXQR6aC6QvloQ8uDBwCqP97ld11hwFYU+bx8RS7F6/Dtf0Lm3ByDezjgBA8YfCsYe0JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758116514; c=relaxed/simple;
	bh=dOUtKhv+1IrsvgPjYg1RhVFluP4pKZptnByxb9JFqYA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=KcPv8oCRZ4uhRq8puhKJ2afIzIrgN/hv2bUMo2vtnnkGgqxUqWXpUYJDLP8J1+VRbP1Bjuv/3vujJQBo5qtzqnLYVwCIEKV5e7Dn+VKh12451Ive+pMd3+VwHD9TSlYUCw7rQ8L9udYnXrLbOCHIm0tAijoTykSkD8liMC3fbf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QTUJ3py3; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QTUJ3py3"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250917134151epoutp04fbf2b078e82fc46c54083d2294167d26~mFabybn2v0417704177epoutp046
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:41:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250917134151epoutp04fbf2b078e82fc46c54083d2294167d26~mFabybn2v0417704177epoutp046
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758116511;
	bh=1JPrkmrI8goW5KEl6T+7MfqJMEk7a0KIJYoQ6H1XOC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTUJ3py3mkNKyLhp32mJXSg/ni4b3yHZ+UsIovjyT5BlgRZ8raMw0CzUQWbegloaj
	 gxz/5jlq1ks9+tFs2MBioPNjRKzKE6SRNHxbcM919QOE6CWgJcS/QsEnISbIvE2JVf
	 sPynBH3/OHZkdHSBdc223P+xBHWDWZ9o3pX720QQ=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250917134150epcas5p2a52b870fe40d7b8dc0178c5a4636088d~mFaatw9nt2257722577epcas5p29;
	Wed, 17 Sep 2025 13:41:50 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.93]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cRg0s1W6hz2SSKX; Wed, 17 Sep
	2025 13:41:49 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250917134148epcas5p1062c53d38d36040a3e65429543099f6d~mFaZb4YIG3219032190epcas5p1H;
	Wed, 17 Sep 2025 13:41:48 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250917134147epsmtip2469fb38d92cab39f0c31782114a3cbd5~mFaX2fAt40862908629epsmtip2D;
	Wed, 17 Sep 2025 13:41:46 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com, Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V3 10/20] nvdimm/namespace_label: Skip region label during
 namespace creation
Date: Wed, 17 Sep 2025 19:11:06 +0530
Message-Id: <20250917134116.1623730-11-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917134116.1623730-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917134148epcas5p1062c53d38d36040a3e65429543099f6d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917134148epcas5p1062c53d38d36040a3e65429543099f6d
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134148epcas5p1062c53d38d36040a3e65429543099f6d@epcas5p1.samsung.com>

During namespace creation, skip any region labels found. And Preserve
region label into labels list if present.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/namespace_devs.c | 52 +++++++++++++++++++++++++++++----
 1 file changed, 47 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 564a73b1da41..735310e6fc11 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1979,6 +1979,10 @@ static struct device **scan_labels(struct nd_region *nd_region)
 		if (!nd_label)
 			continue;
 
+		/* Skip region labels if present */
+		if (is_region_label(ndd, (union nd_lsa_label *) nd_label))
+			continue;
+
 		/* skip labels that describe extents outside of the region */
 		if (nsl_get_dpa(ndd, nd_label) < nd_mapping->start ||
 		    nsl_get_dpa(ndd, nd_label) > map_end)
@@ -2017,9 +2021,31 @@ static struct device **scan_labels(struct nd_region *nd_region)
 
 	if (count == 0) {
 		struct nd_namespace_pmem *nspm;
+		for (i = 0; i < nd_region->ndr_mappings; i++) {
+			union nd_lsa_label *nd_label;
+			struct nd_label_ent *le, *e;
+			LIST_HEAD(list);
 
-		/* Publish a zero-sized namespace for userspace to configure. */
-		nd_mapping_free_labels(nd_mapping);
+			nd_mapping = &nd_region->mapping[i];
+			if (list_empty(&nd_mapping->labels))
+				continue;
+
+			list_for_each_entry_safe(le, e, &nd_mapping->labels,
+						 list) {
+				nd_label = (union nd_lsa_label *) le->label;
+
+				/* Preserve region labels if present */
+				if (is_region_label(ndd, nd_label))
+					list_move_tail(&le->list, &list);
+			}
+
+			/*
+			 * Publish a zero-sized namespace for userspace
+			 * to configure.
+			 */
+			nd_mapping_free_labels(nd_mapping);
+			list_splice_init(&list, &nd_mapping->labels);
+		}
 		nspm = kzalloc(sizeof(*nspm), GFP_KERNEL);
 		if (!nspm)
 			goto err;
@@ -2031,7 +2057,8 @@ static struct device **scan_labels(struct nd_region *nd_region)
 	} else if (is_memory(&nd_region->dev)) {
 		/* clean unselected labels */
 		for (i = 0; i < nd_region->ndr_mappings; i++) {
-			struct list_head *l, *e;
+			union nd_lsa_label *nd_label;
+			struct nd_label_ent *le, *e;
 			LIST_HEAD(list);
 			int j;
 
@@ -2042,10 +2069,25 @@ static struct device **scan_labels(struct nd_region *nd_region)
 			}
 
 			j = count;
-			list_for_each_safe(l, e, &nd_mapping->labels) {
+			list_for_each_entry_safe(le, e, &nd_mapping->labels,
+						 list) {
+				nd_label = (union nd_lsa_label *) le->label;
+
+				/* Preserve region labels */
+				if (is_region_label(ndd, nd_label)) {
+					list_move_tail(&le->list, &list);
+					continue;
+				}
+
+				/*
+				 * Once preserving selected ns label done
+				 * break out of loop
+				 */
 				if (!j--)
 					break;
-				list_move_tail(l, &list);
+
+				/* Preserve selected ns label */
+				list_move_tail(&le->list, &list);
 			}
 			nd_mapping_free_labels(nd_mapping);
 			list_splice_init(&list, &nd_mapping->labels);
-- 
2.34.1

