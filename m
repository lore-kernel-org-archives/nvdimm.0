Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429AB32341D
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758115850; cv=none; b=Ru4DdLQnjjrRixj5ozsevWIoamsZq9EJM059gidT3BA10+EbtkvlsDg8ca97JAMG0bTmZPZ5YMo8H3oKv/lDk9p94on8Ku3qtlBY/YlnWqaxhXUwMFz4oSGwFy7PBzqntSUAN7cXwQPZTEV88XRnv5WR0pSSXqr8pm2NSHAiufg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758115850; c=relaxed/simple;
	bh=dOUtKhv+1IrsvgPjYg1RhVFluP4pKZptnByxb9JFqYA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=csp8xdixVCB9VB4faJEpf1EHrwcf7ERILrMVeDn3KSmlPMQfdsjG6dDQQgSCkXD0BGvbjtMinwcMhZiDo3AP/GyHkBjxhIaj16HHocwDedzeGE6RXVofPDreGuhooxt0ZsgRx0RsD4xtrPTq8MhwNm61FpjzEnEibHULWvJ0Hec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=S6EVGUWt; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="S6EVGUWt"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250917133046epoutp03aae8fe7b79c8cf56a19616973fc33a85~mFQwaowfW2741927419epoutp03i
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250917133046epoutp03aae8fe7b79c8cf56a19616973fc33a85~mFQwaowfW2741927419epoutp03i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758115846;
	bh=1JPrkmrI8goW5KEl6T+7MfqJMEk7a0KIJYoQ6H1XOC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S6EVGUWtUkwYVQKFYEcH8QoQiY7i1PBg8h27Z07koUl0Qs1HLR9PaUQpclu5IY4wq
	 rZODE6LDh4DcqiMtQ0wWdymAD9rfwxPXwfPjfWkZRjlYXYBiqQ+a9qyojXOAN7mmrv
	 Cecqx/3Yc6Yj+YVXLgppXNJB3Nu5SMODh0Czuhl8=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250917133045epcas5p3ba56bb774acf02a4844d59f63e3b04e6~mFQwHOX0V0995409954epcas5p3V;
	Wed, 17 Sep 2025 13:30:45 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.93]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cRfm507sJz3hhT4; Wed, 17 Sep
	2025 13:30:45 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250917133044epcas5p3956bb40aa46867ff824624aca6f91fe0~mFQu2l6-e1910319103epcas5p3t;
	Wed, 17 Sep 2025 13:30:44 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250917133043epsmtip19310e722cf2716a00a08e276617eb8c2~mFQtzFjas0457804578epsmtip1W;
	Wed, 17 Sep 2025 13:30:43 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V3 10/20] nvdimm/namespace_label: Skip region label during
 namespace creation
Date: Wed, 17 Sep 2025 18:59:30 +0530
Message-Id: <20250917132940.1566437-11-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917132940.1566437-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917133044epcas5p3956bb40aa46867ff824624aca6f91fe0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917133044epcas5p3956bb40aa46867ff824624aca6f91fe0
References: <20250917132940.1566437-1-s.neeraj@samsung.com>
	<CGME20250917133044epcas5p3956bb40aa46867ff824624aca6f91fe0@epcas5p3.samsung.com>

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

