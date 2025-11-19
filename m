Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C8D2DF12F
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763538803; cv=none; b=ZLGDPj2EwjIslZWhr2q3DBh38bt5ap8C6LE2YPgzfYn1QXrdFfUZZWi7SuG39Ma5bgRVsFuiy/sr4aLqG5bkqsnsDwk5uWJzcuroq00iapw4cn756C4rnTALwE1dEAFGkKAMB0c5dAXlAslg7GQkjoE44sfvtEGZOeCRL1dW22M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763538803; c=relaxed/simple;
	bh=Yqw1K860oHVedQqAJVS3TE0A6Qg36ZdNGkGWr4rs7qA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=vCGvJDsO8weYON60QDys2p0DqZGxHaJElSS9bm+yFiS2a1hE8s2bzJlzc3OefVW7rD626w/G1AGXsbAtdosuT7BOS4XonuVO9wG1xUbYJJ4BMFOd3O3h+BBEN0MXVaSRg2zrvFfIGUMRLR6ZIxql6aIW1GEo5CiMVjl9u38UqKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=YbJmSbwt; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YbJmSbwt"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251119075319epoutp0373b41fa84c4472be329178af57472509~5WTG21KN33019930199epoutp03h
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251119075319epoutp0373b41fa84c4472be329178af57472509~5WTG21KN33019930199epoutp03h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1763538799;
	bh=4x+K7Cx6L38kqLC/vl+6BzQLovRHHs/YI6/d6xMJlvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YbJmSbwt6Dh6G8ntsOS6Hyq/kNByY//Xn6T7zH1s3k+f40eLe5pEfj11q3rRGGa9O
	 /z6jaBCetWP0tIBIvYimkE8dm0ko7QOduoBrBLKsTnhQEYCvI8YVASxp8Gkoy72yjm
	 zxJTUFi73VORNVAfIpxp2k5g024f4pGHq2ocycEk=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20251119075318epcas5p3c97d3948f67f3a25a2ec5ef6fe22be18~5WTGhPi8M0354903549epcas5p3V;
	Wed, 19 Nov 2025 07:53:18 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.94]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dBDHd5ptJz6B9mJ; Wed, 19 Nov
	2025 07:53:17 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20251119075317epcas5p41468e3c1602d89e634f48a7b67454663~5WTFJWikK0332303323epcas5p4M;
	Wed, 19 Nov 2025 07:53:17 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251119075316epsmtip1e04e10307a6a9263f1b79d6ed3a98df6~5WTECN61X2604526045epsmtip1S;
	Wed, 19 Nov 2025 07:53:15 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V4 06/17] nvdimm/label: Preserve region label during
 namespace creation
Date: Wed, 19 Nov 2025 13:22:44 +0530
Message-Id: <20251119075255.2637388-7-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251119075255.2637388-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251119075317epcas5p41468e3c1602d89e634f48a7b67454663
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251119075317epcas5p41468e3c1602d89e634f48a7b67454663
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075317epcas5p41468e3c1602d89e634f48a7b67454663@epcas5p4.samsung.com>

During namespace creation we scan labels present in LSA using
scan_labels(). Currently scan_labels() is only preserving
namespace labels into label_ent list.

In this patch we also preserve region label into label_ent list

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/namespace_devs.c | 47 +++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index b1abbe602a5e..9450200b4470 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1999,9 +1999,32 @@ static struct device **scan_labels(struct nd_region *nd_region)
 
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
@@ -2013,7 +2036,7 @@ static struct device **scan_labels(struct nd_region *nd_region)
 	} else if (is_memory(&nd_region->dev)) {
 		/* clean unselected labels */
 		for (i = 0; i < nd_region->ndr_mappings; i++) {
-			struct list_head *l, *e;
+			struct nd_label_ent *le, *e;
 			LIST_HEAD(list);
 			int j;
 
@@ -2024,10 +2047,24 @@ static struct device **scan_labels(struct nd_region *nd_region)
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

