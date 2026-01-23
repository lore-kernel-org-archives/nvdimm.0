Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D1C366543
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769167898; cv=none; b=G2Hvq5eMRLSM+b4nvNQoAhJtt9XLpoVen0RKj5IMIlZ90b6IcYMWCXObtIDGY2JBLqWlsEOtY3Xrmo5FaFIm7Awo43z7Yq4JS/mqJpCc71sEZ1Mw9haYJ0xyHuprIdwNs9TAnqsPiTR1rKsIl+R8wTUt1JihDoVgPMExdrte9Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769167898; c=relaxed/simple;
	bh=cQ74lHFeHeEdE+a1RS3IKKo9RhHGG1MmhaDslbqhTl0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=JURB/5OiEOiTNzxulhxN86LFhuI84pHs2lNd0baOEqaSY1QF6FavirQKo9dTb29B1LkIfIW5o7Fn1z486Y/2NUIn5NskqOW9IRYa6zPl3IqhQD9OEx/JniuuFgPvv8qD4u68bDRThAUzdsAeikPyv6Hs67qmCQ6ZMPqhegFHegc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=E1td/0yE; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="E1td/0yE"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260123113133epoutp02e2014bf78a663ef2794be5d1dd0750b5~NWNNqwGnJ0146201462epoutp02J
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260123113133epoutp02e2014bf78a663ef2794be5d1dd0750b5~NWNNqwGnJ0146201462epoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769167893;
	bh=vEaz7qTizm8glHr7yEMSFLmH7n6xVHbo0062LSuKaUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E1td/0yEwiLuRz85zCKwQ+EPI7K+r15QiLzFT+47u65fO4i+FFhtR5Xodx5HxZZfq
	 AvSrqFI5mCJFekFLwtjFvj9JVQ4yN83rwpdLUKXjrtqiALlBHpiJ6/5r8X3UdHyLvT
	 shQStNEVCH2woTdSFYVYHcx1qZUf4RXM1Ylkt+no=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260123113133epcas5p29d0a743f45f5612bc1c8071ed3b96437~NWNNTudRV1735017350epcas5p2V;
	Fri, 23 Jan 2026 11:31:33 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.93]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dyG3S42yDz2SSKb; Fri, 23 Jan
	2026 11:31:32 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260123113132epcas5p368496769470a9163183a1d5a967442e2~NWNMJKtns1446414464epcas5p3q;
	Fri, 23 Jan 2026 11:31:32 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260123113130epsmtip2a702a8ef6f1cbb4b8e13ea6e7525e173~NWNLB7Ii12621526215epsmtip20;
	Fri, 23 Jan 2026 11:31:30 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V6 06/18] nvdimm/label: Preserve region label during
 namespace creation
Date: Fri, 23 Jan 2026 17:01:00 +0530
Message-Id: <20260123113112.3488381-7-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260123113112.3488381-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260123113132epcas5p368496769470a9163183a1d5a967442e2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260123113132epcas5p368496769470a9163183a1d5a967442e2
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
	<CGME20260123113132epcas5p368496769470a9163183a1d5a967442e2@epcas5p3.samsung.com>

During namespace creation we scan labels present in LSA using
scan_labels(). Currently scan_labels() is only preserving
namespace labels into label_ent list.

In this patch we also preserve region label into label_ent list

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/namespace_devs.c | 47 +++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 657004021c95..8411f4152319 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1994,9 +1994,32 @@ static struct device **scan_labels(struct nd_region *nd_region)
 
 	if (count == 0) {
 		struct nd_namespace_pmem *nspm;
+		for (i = 0; i < nd_region->ndr_mappings; i++) {
+			struct cxl_region_label *region_label;
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
+				region_label = le->region_label;
+				if (!region_label)
+					continue;
+
+				/* Preserve region labels if present */
+				list_move_tail(&le->list, &list);
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
@@ -2008,7 +2031,7 @@ static struct device **scan_labels(struct nd_region *nd_region)
 	} else if (is_memory(&nd_region->dev)) {
 		/* clean unselected labels */
 		for (i = 0; i < nd_region->ndr_mappings; i++) {
-			struct list_head *l, *e;
+			struct nd_label_ent *le, *e;
 			LIST_HEAD(list);
 			int j;
 
@@ -2019,10 +2042,24 @@ static struct device **scan_labels(struct nd_region *nd_region)
 			}
 
 			j = count;
-			list_for_each_safe(l, e, &nd_mapping->labels) {
+			list_for_each_entry_safe(le, e, &nd_mapping->labels,
+						 list) {
+				/* Preserve region labels */
+				if (uuid_equal(&le->label_uuid,
+					       &cxl_region_uuid)) {
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

