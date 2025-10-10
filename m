Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4A02848BF
	for <nvdimm@lists.linux.dev>; Fri, 10 Oct 2025 11:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760097149; cv=none; b=r79GiTLbOph0GGUnGSMU4pC63ZdrsfsLVEofC5lZpL99X0NAA3L8iPrnSEvOUWsu5yVO8Yj07VDCFzFMGon2IGY0cy+IRf9W6KpfFn9MeFAjwpNQRGutrFnR6xODTORn2+8VNwlky5FbEd366dpfnEJ0kTTtjZc86dNsJcJm6Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760097149; c=relaxed/simple;
	bh=+0dKcnwIVno+hkUXRxbEwxfPr+TJS6i2O49YXACKdz4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=XI+C5G43YkPKC695XKA7iMacloH/wjMuiDUNonIUX+7sZ4Ig6gMB5tExngcOLn305NZyQs+d3TTvqj+ef2lMv7Eci6uE+A9JY7gqAw1hbgDGhD7TuzouIoMBf/0DtrLyjtyojH73bFZ3T6e4VNr+xUujoQ68kLEGREE0J4gJRlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=E63/5S2Z; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="E63/5S2Z"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20251010115218epoutp048cf5554542dfd9124873b7d4635f340b~tHwWnJGuW0393403934epoutp04E
	for <nvdimm@lists.linux.dev>; Fri, 10 Oct 2025 11:52:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20251010115218epoutp048cf5554542dfd9124873b7d4635f340b~tHwWnJGuW0393403934epoutp04E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760097138;
	bh=KWpR7Wn4Vq3N6fuaGujgbrwuOlrBVpfR/WZGIgn1Wig=;
	h=From:To:Cc:Subject:Date:References:From;
	b=E63/5S2ZC8hm0AkNUPCOtOd2iDK8BxRYiYImuUVKK+K8kUQOKrA2VQG+Ith1fN+g4
	 kEWeB9CM6BiOGn1pJEmeCuNHR3W/LcrCk2h7Ny3MfL48uQ0OYQwZpFC+SNyU1iYCOH
	 XNYT2/Aj9UgKV6pHD5a/7UNRQazOaCMkHIUmWUdU=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20251010115217epcas5p2906c83744e290b556539261aadeb78b6~tHwWFmAUr1978119781epcas5p2z;
	Fri, 10 Oct 2025 11:52:17 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.91]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cjlTs206pz3hhT4; Fri, 10 Oct
	2025 11:52:17 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20251010115216epcas5p2f9983debbf80d5eb864f8ea481295306~tHwUy27rL1286512865epcas5p2Z;
	Fri, 10 Oct 2025 11:52:16 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251010115215epsmtip1a8b86eec5234671ef0801a06fab92109~tHwTlCT782317023170epsmtip1R;
	Fri, 10 Oct 2025 11:52:14 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: nvdimm@lists.linux.dev, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH] nvdimm/label: Update mutex_lock() with guard() in
 __pmem_label_update
Date: Fri, 10 Oct 2025 17:22:05 +0530
Message-Id: <20251010115205.3694850-1-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251010115216epcas5p2f9983debbf80d5eb864f8ea481295306
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251010115216epcas5p2f9983debbf80d5eb864f8ea481295306
References: <CGME20251010115216epcas5p2f9983debbf80d5eb864f8ea481295306@epcas5p2.samsung.com>

Reduce __pmem_label_update() complexity by modifying locking from
mutex_lock/unlock() with guard()

Link: https://lore.kernel.org/linux-cxl/20250623100520.00003f34@huawei.com/
Suggested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 04f4a049599a..e5325e37bccc 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -935,7 +935,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
 		return rc;
 
 	/* Garbage collect the previous label */
-	mutex_lock(&nd_mapping->lock);
+	guard(mutex)(&nd_mapping->lock);
 	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
 		if (!label_ent->label)
 			continue;
@@ -947,22 +947,24 @@ static int __pmem_label_update(struct nd_region *nd_region,
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
+	if (rc)
+		return rc;
+
+	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
+		if (label_ent->label)
+			continue;
+
+		label_ent->label = nd_label;
+		nd_label = NULL;
+		break;
 	}
-	mutex_unlock(&nd_mapping->lock);
+	dev_WARN_ONCE(&nspm->nsio.common.dev, nd_label,
+			"failed to track label: %d\n",
+			to_slot(ndd, nd_label));
+	if (nd_label)
+		return -ENXIO;
 
-	return rc;
+	return 0;
 }
 
 static int init_labels(struct nd_mapping *nd_mapping, int num_labels)

base-commit: 46037455cbb748c5e85071c95f2244e81986eb58
-- 
2.34.1

