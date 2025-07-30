Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50440DF71
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753877832; cv=none; b=smczYzuzFiglYm36xQVDsxffFtdECXeWXKezZHJYI5/Kj3GSk6NIGnBFghtwfcpmXVpmZI+cdIsHPvKfORDYch/hBhAJpj2T3L66SweTUMu7HYGCWcZUrHrmBbROoUnwKpwaGo+QFvCmpVaPqSP/Br7c96KT9bfAVk4TpURAJdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753877832; c=relaxed/simple;
	bh=BcitnlvJ5aSoftu58NbIs+V95tY6G+Bo5ZRyxzDbsAE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=dl4UqZkaWW57uuSRq0Zzd24PFuITdWgCEWU9k5BeTrW+9rAqjt3+ccCz4/lC3V/g2JTVkd/oG5r3vnXT26EzQuvQyqWcDyrX2dGzDarXK1en01rZNB04+YZTJX2LXKA5nhvMnozqxI/uxgAulok7Hfn2VW3RPKBqgEO3qba2900=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=F5hJ78ax; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="F5hJ78ax"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250730121708epoutp0237d9cf3f41496570ce849879074f5671~XBpe8DyAt1892218922epoutp02N
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:17:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250730121708epoutp0237d9cf3f41496570ce849879074f5671~XBpe8DyAt1892218922epoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753877828;
	bh=n9JIZxmzSPM6pM2glW1Y9V4+eP1YDq4rEXGoGIMPsfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5hJ78axlkGwfAw41mgGnaV/l9Am/uwQKqsy3NcfXybJjdG8BF/5NwhnjVyOXzWpO
	 eOn2sMtdmKV/pBZHy5AqTNuaAy0YvZUMyqrrWpRf11aN+/XjAlYkV/8Cf8eT8G0cpT
	 eZtkICrbAYmUoZvOQu8M+8RcjvF0K2e/YgoQkxmo=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250730121708epcas5p20ecbd80c2255bb28932c3631591d4a13~XBpeaNj1b2413024130epcas5p2A;
	Wed, 30 Jul 2025 12:17:08 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.92]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4bsWRl0sMkz6B9m5; Wed, 30 Jul
	2025 12:17:07 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250730121238epcas5p212dcce5cc5713173913ee154d5098a2c~XBljFTZu_0097600976epcas5p2O;
	Wed, 30 Jul 2025 12:12:38 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250730121237epsmtip13c8287fd090107c3e59f03af1f42d134~XBliCVJ7b0197501975epsmtip18;
	Wed, 30 Jul 2025 12:12:36 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V2 12/20] nvdimm/namespace_label: Skip region label during
 namespace creation
Date: Wed, 30 Jul 2025 17:42:01 +0530
Message-Id: <20250730121209.303202-13-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250730121209.303202-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250730121238epcas5p212dcce5cc5713173913ee154d5098a2c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121238epcas5p212dcce5cc5713173913ee154d5098a2c
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121238epcas5p212dcce5cc5713173913ee154d5098a2c@epcas5p2.samsung.com>

During namespace creation skip presence of region label if present.
Also preserve region label into labels list if present.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/namespace_devs.c | 50 +++++++++++++++++++++++++++++----
 1 file changed, 45 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index e5c2f78ca7dd..8edd26407939 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1985,6 +1985,10 @@ static struct device **scan_labels(struct nd_region *nd_region)
 		if (!lsa_label)
 			continue;
 
+		/* skip region labels if present */
+		if (is_region_label(ndd, lsa_label))
+			continue;
+
 		nd_label = &lsa_label->ns_label;
 
 		/* skip labels that describe extents outside of the region */
@@ -2025,9 +2029,30 @@ static struct device **scan_labels(struct nd_region *nd_region)
 
 	if (count == 0) {
 		struct nd_namespace_pmem *nspm;
+		for (i = 0; i < nd_region->ndr_mappings; i++) {
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
+				struct nd_lsa_label *nd_label = le->label;
+
+				/* preserve region labels if present */
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
@@ -2039,7 +2064,7 @@ static struct device **scan_labels(struct nd_region *nd_region)
 	} else if (is_memory(&nd_region->dev)) {
 		/* clean unselected labels */
 		for (i = 0; i < nd_region->ndr_mappings; i++) {
-			struct list_head *l, *e;
+			struct nd_label_ent *le, *e;
 			LIST_HEAD(list);
 			int j;
 
@@ -2050,10 +2075,25 @@ static struct device **scan_labels(struct nd_region *nd_region)
 			}
 
 			j = count;
-			list_for_each_safe(l, e, &nd_mapping->labels) {
+			list_for_each_entry_safe(le, e, &nd_mapping->labels,
+						 list) {
+				struct nd_lsa_label *nd_label = le->label;
+
+				/* preserve region labels */
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
+				/* preserve selected ns label */
+				list_move_tail(&le->list, &list);
 			}
 			nd_mapping_free_labels(nd_mapping);
 			list_splice_init(&list, &nd_mapping->labels);
-- 
2.34.1

