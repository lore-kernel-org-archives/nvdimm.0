Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE5631BC88
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758116500; cv=none; b=HxObnhqAh1hEmzwBLNJX1ZrmgM77K7+8xeY8L52cI0jCrHPNpXv4YUSAoe8HWV4/UIYgBffSwtgNwhmXbqIItyB3dcdFVCWcXxlmoajlEu59Rf4kjm0cBwyMvoWQBkxXIFs7wQaoHNK4ffHcaimN7/tTYoFe8JJWK+w7W91rFDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758116500; c=relaxed/simple;
	bh=jE8XefBKHoH4o8xanFWc0C2cpGJEqVbjQVeCi5HEx6c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=bjcbe4HcKVAD891iVaXEInUHPP/AeUhqm79RyIK2aTLe40OMYYt3edza0pBxJaKDRFaep0vzksmAFDtIgFyXcoHMhFd5wqI0JfygzKRMQXYf6Wl+EgVp5x/FjwGyRQyKDnmso9f71p9k4EKeHsBNx4H7Lj6A/x1on5PxJX+DDBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=mmmtrZNz; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mmmtrZNz"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250917134136epoutp01d9e34a74be74b5b9ee0c91d79c807285~mFaNtwTAP3165731657epoutp01C
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:41:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250917134136epoutp01d9e34a74be74b5b9ee0c91d79c807285~mFaNtwTAP3165731657epoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758116496;
	bh=rqMArwoFuPVor1N9q2bx2CVy1q2vuGySReKFqLZxQOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmmtrZNznvpHqa9mO1L1J6KGaTJ8/b/ibrGL5cMRoGvfbUDxCCLX0yq8Y9yGZ9v8K
	 KvYnAwwogvXLQVPqibsfHWFBqoh5cZJGfR5irrjDS1aphgkFEpnFCwG+SjDUdcZN4+
	 x4A5eurzbGOC7Rlzy2TCHMUaCnjJKHGEnwrOTSYU=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250917134135epcas5p1dee91eade89746c8ca55765f8878774a~mFaNXNgaQ3219532195epcas5p1t;
	Wed, 17 Sep 2025 13:41:35 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.89]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cRg0Z5XhWz6B9m6; Wed, 17 Sep
	2025 13:41:34 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250917134134epcas5p3f64af9556015ed9dfb881f852ea854c4~mFaMBBK7T0180501805epcas5p3f;
	Wed, 17 Sep 2025 13:41:34 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250917134133epsmtip21c7d66b792f81a407055c318a9552687~mFaKzBvZV0833108331epsmtip2h;
	Wed, 17 Sep 2025 13:41:32 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com, Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V3 03/20] nvdimm/label: Modify nd_label_base() signature
Date: Wed, 17 Sep 2025 19:10:59 +0530
Message-Id: <20250917134116.1623730-4-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917134116.1623730-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917134134epcas5p3f64af9556015ed9dfb881f852ea854c4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917134134epcas5p3f64af9556015ed9dfb881f852ea854c4
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134134epcas5p3f64af9556015ed9dfb881f852ea854c4@epcas5p3.samsung.com>

nd_label_base() was being used after typecasting with 'unsigned long'. Thus
modified nd_label_base() to return 'unsigned long' instead of 'struct
nd_namespace_label *'

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 0a9b6c5cb2c3..668e1e146229 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -271,11 +271,11 @@ static void nd_label_copy(struct nvdimm_drvdata *ndd,
 	memcpy(dst, src, sizeof_namespace_index(ndd));
 }
 
-static struct nd_namespace_label *nd_label_base(struct nvdimm_drvdata *ndd)
+static unsigned long nd_label_base(struct nvdimm_drvdata *ndd)
 {
 	void *base = to_namespace_index(ndd, 0);
 
-	return base + 2 * sizeof_namespace_index(ndd);
+	return (unsigned long) (base + 2 * sizeof_namespace_index(ndd));
 }
 
 static int to_slot(struct nvdimm_drvdata *ndd,
@@ -284,7 +284,7 @@ static int to_slot(struct nvdimm_drvdata *ndd,
 	unsigned long label, base;
 
 	label = (unsigned long) nd_label;
-	base = (unsigned long) nd_label_base(ndd);
+	base = nd_label_base(ndd);
 
 	return (label - base) / sizeof_namespace_label(ndd);
 }
@@ -293,7 +293,7 @@ static struct nd_namespace_label *to_label(struct nvdimm_drvdata *ndd, int slot)
 {
 	unsigned long label, base;
 
-	base = (unsigned long) nd_label_base(ndd);
+	base = nd_label_base(ndd);
 	label = base + sizeof_namespace_label(ndd) * slot;
 
 	return (struct nd_namespace_label *) label;
@@ -684,7 +684,7 @@ static int nd_label_write_index(struct nvdimm_drvdata *ndd, int index, u32 seq,
 			nd_label_next_nsindex(index))
 		- (unsigned long) to_namespace_index(ndd, 0);
 	nsindex->otheroff = __cpu_to_le64(offset);
-	offset = (unsigned long) nd_label_base(ndd)
+	offset = nd_label_base(ndd)
 		- (unsigned long) to_namespace_index(ndd, 0);
 	nsindex->labeloff = __cpu_to_le64(offset);
 	nsindex->nslot = __cpu_to_le32(nslot);
-- 
2.34.1

