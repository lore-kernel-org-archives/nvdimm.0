Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDBD35CB86
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962723; cv=none; b=d3mbYVOnzTTBD1aPwHrOJwL7G2BV7wdp0ITmTKkRFG3USIdHM+uMcEpFkvCWrVzIcDrmLV+Gyg2Qje6XC2NeeU1RJOobNeG6K5sJPUvZnbXtcpCil6QSonYxVtBHy7rtoQKylSAoIPZEEsCEbqVelmmXKoDUDyhiL+3a+dCZYks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962723; c=relaxed/simple;
	bh=Vl6QRqBDVWeDPdvPoeu6lPZ41lV+RQ4xt5L2bqTpzrs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=GIJigtV6dE6l0xJ4RoFW+FfPU0l4FElb0vm/t1Ov25+WXqPxyu8ZX8UWxqWrxPTmlOnpDFE7gOVLWUb8J1mH1QMGnYWvYx4MCabyKral/B9If8BUjts2Q5G6oGljirj5gjVkWiuQg9pplIgv+B/4ethUNf0jZiDm04btYFB4lpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=OPlbjTXk; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="OPlbjTXk"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260109124520epoutp0362e0712830415ea5cb2591dfab2d20b7~JELodQL1N0570105701epoutp03a
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:45:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260109124520epoutp0362e0712830415ea5cb2591dfab2d20b7~JELodQL1N0570105701epoutp03a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767962720;
	bh=c7T6ZJ4KXocop9UUK8AuZEyn63B7t7oAxoInpDQTVkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OPlbjTXktLc/wSdAnMvrJcYcPFwUsunYhy9N5+7H81c/S1o19b8KaRce7iY0zAQy6
	 zCFsEJaoU3z24Jpau0kAj9wy4HW4v0/UIq9xTdOmfe5gVtawFG4E2pGadGK989xGyv
	 tISvhY1EyUmlRF4/Cf7Kk2Cj6cY5L+NXFOZ3Y+cU=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260109124519epcas5p309bfdb17e5d9533261b40c7991c631c8~JELn09XOe2029020290epcas5p3q;
	Fri,  9 Jan 2026 12:45:19 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.93]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dnhM26510z3hhT4; Fri,  9 Jan
	2026 12:45:18 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260109124518epcas5p26832d0b4ae4017cb3afbd613bf58eabd~JELmzoVZa2073820738epcas5p2W;
	Fri,  9 Jan 2026 12:45:18 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260109124517epsmtip14cf401a10c2622402698c0de1eb6b24d~JELlvXoOr0972509725epsmtip1Y;
	Fri,  9 Jan 2026 12:45:17 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V5 06/17] nvdimm/label: Preserve region label during
 namespace creation
Date: Fri,  9 Jan 2026 18:14:26 +0530
Message-Id: <20260109124437.4025893-7-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260109124437.4025893-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260109124518epcas5p26832d0b4ae4017cb3afbd613bf58eabd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260109124518epcas5p26832d0b4ae4017cb3afbd613bf58eabd
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124518epcas5p26832d0b4ae4017cb3afbd613bf58eabd@epcas5p2.samsung.com>

During namespace creation we scan labels present in LSA using
scan_labels(). Currently scan_labels() is only preserving
namespace labels into label_ent list.

In this patch we also preserve region label into label_ent list

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

