Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23F032896A
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758116503; cv=none; b=GYBu9QeTCXsz/o3+YVcFyvUjV0nKaLk9KiLGzyV90yi05OpGteJ9I7mH5eGmyvbAPwm+eiLWTqgcGsRn/WxgXEz4e2nPBZi6z0l4txioo23D6I2eWR8O568BBSv7OCgWj+CcumM6SkEisMDGjhZ370frRKZ1vKVKttrnhANUxs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758116503; c=relaxed/simple;
	bh=zf5v0P2isE0qmAmZVojJgSZzamCbh8gBkuc7+76jBBk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=O/To4pqKsx4DuqR+GSDeOLyt5LZePI3xnYynY4IFm8KdFM2Ndw1JymXTRrqAjlgYzeeuJypSmmnSiHBYCC1gG/4lIEz15HI0Gt4J72PWBF/FzI0MSAxM6uXBNCvJt7w0tQEqu++rUgZpIDRBeYPO7KXHbtEmTsQKMEw1b6s90qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=e8SWOGLv; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="e8SWOGLv"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250917134138epoutp03b418066e56dbf330b8196a9c224e22a3~mFaQJr1VJ0946809468epoutp03C
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:41:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250917134138epoutp03b418066e56dbf330b8196a9c224e22a3~mFaQJr1VJ0946809468epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758116498;
	bh=VbBlpRaiPk+6zIQaFNB8aIo/sNFkPAmn9Rc+w20AuEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8SWOGLvAmFqsUC4uSd1lfIoT05oKa3MdSuNsp46UlRLlgS6IXdt8tKglbplPeXMx
	 loAVyMMv3JNrHBURiy/jYPgAOBnc4qM+pSdvudG3NqAVBxC6EMapkFaBC2SEvUQZrL
	 E2cpa4O7BwTbwLoMjnl/wH6yYvawPj3xsAguwoc4=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250917134138epcas5p2be817d11fd58f21c7c873dad49881e95~mFaP4hlBN0928509285epcas5p2F;
	Wed, 17 Sep 2025 13:41:38 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.94]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cRg0d3H72z3hhT4; Wed, 17 Sep
	2025 13:41:37 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250917134136epcas5p118f18ce5139d489d90ac608e3887c1fc~mFaN5iUaH3225232252epcas5p14;
	Wed, 17 Sep 2025 13:41:36 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250917134134epsmtip29428fbe4650670d0dee40f007158e69b~mFaMQBR6-0833808338epsmtip2E;
	Wed, 17 Sep 2025 13:41:34 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com, Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V3 04/20] nvdimm/label: Update mutex_lock() with
 guard(mutex)()
Date: Wed, 17 Sep 2025 19:11:00 +0530
Message-Id: <20250917134116.1623730-5-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917134116.1623730-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917134136epcas5p118f18ce5139d489d90ac608e3887c1fc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917134136epcas5p118f18ce5139d489d90ac608e3887c1fc
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134136epcas5p118f18ce5139d489d90ac608e3887c1fc@epcas5p1.samsung.com>

Updated mutex_lock() with guard(mutex)()

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 668e1e146229..3235562d0e1c 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -948,7 +948,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
 		return rc;
 
 	/* Garbage collect the previous label */
-	mutex_lock(&nd_mapping->lock);
+	guard(mutex)(&nd_mapping->lock);
 	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
 		if (!label_ent->label)
 			continue;
@@ -960,20 +960,20 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	/* update index */
 	rc = nd_label_write_index(ndd, ndd->ns_next,
 			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
-	if (rc == 0) {
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
-			rc = -ENXIO;
-	}
-	mutex_unlock(&nd_mapping->lock);
+	if (rc)
+		return rc;
+
+	list_for_each_entry(label_ent, &nd_mapping->labels, list)
+		if (!label_ent->label) {
+			label_ent->label = nd_label;
+			nd_label = NULL;
+			break;
+		}
+	dev_WARN_ONCE(&nspm->nsio.common.dev, nd_label,
+			"failed to track label: %d\n",
+			to_slot(ndd, nd_label));
+	if (nd_label)
+		rc = -ENXIO;
 
 	return rc;
 }
@@ -998,9 +998,8 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
 		label_ent = kzalloc(sizeof(*label_ent), GFP_KERNEL);
 		if (!label_ent)
 			return -ENOMEM;
-		mutex_lock(&nd_mapping->lock);
+		guard(mutex)(&nd_mapping->lock);
 		list_add_tail(&label_ent->list, &nd_mapping->labels);
-		mutex_unlock(&nd_mapping->lock);
 	}
 
 	if (ndd->ns_current == -1 || ndd->ns_next == -1)
@@ -1039,7 +1038,7 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
 	if (!preamble_next(ndd, &nsindex, &free, &nslot))
 		return 0;
 
-	mutex_lock(&nd_mapping->lock);
+	guard(mutex)(&nd_mapping->lock);
 	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
 		struct nd_namespace_label *nd_label = label_ent->label;
 
@@ -1061,7 +1060,6 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
 		nd_mapping_free_labels(nd_mapping);
 		dev_dbg(ndd->dev, "no more active labels\n");
 	}
-	mutex_unlock(&nd_mapping->lock);
 
 	return nd_label_write_index(ndd, ndd->ns_next,
 			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
-- 
2.34.1

