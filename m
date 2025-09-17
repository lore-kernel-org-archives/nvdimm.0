Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0BB3161AA
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758115837; cv=none; b=V0XfBrPgOLvbOtk8znHaBtliq2h4sg7gNk3UbMjLQGP0Bth27pkS8q6etEgxJBdUwKV/Y8Im23tZeMZ37WLfHfOTB9SuwN0HIRZEnmrjLZ39Y0+n+FTHNrGomZeNJ2yEm+gpNcI1+p6is3z0IJFaNFHGYfgOMcypqPJTiiaAcZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758115837; c=relaxed/simple;
	bh=jE8XefBKHoH4o8xanFWc0C2cpGJEqVbjQVeCi5HEx6c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=sDwsZNU3TduWmfxww4f4dL6naMmPiwp+DqddOYDQj21ZCL83eUj+4DUEyHOeC0L91z4C9yH5bH7JzfYgd09W+WhJJsffY1vGxRlQcj5haiFvdI1TynlpNT+9mu67MPlnYA4oWEzNo3PqHN5M3IKSg+CEut6sUvjlqveLghMXN34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=rbTIJuJa; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="rbTIJuJa"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250917133034epoutp01d43af143e68066148323fe10e3b8ad04~mFQlESA7E2275422754epoutp01O
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250917133034epoutp01d43af143e68066148323fe10e3b8ad04~mFQlESA7E2275422754epoutp01O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758115834;
	bh=rqMArwoFuPVor1N9q2bx2CVy1q2vuGySReKFqLZxQOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rbTIJuJanmMRr980oa3QFtJJg1o3klHtoVRdc6n/P/jY56+0+fjVn1WzMsvHuCkXl
	 F0br5ZEYeVzPUu5RdYyvTZPKZrwCLtS3ybx6/waliHzSDRQy4HEYy1yRwt+AvysYQh
	 J8ltA6FNvZS5JEBJM3m8AdH0Jd0s0zj9/Jm60LO0=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250917133033epcas5p45edac11adaa06fc75f3e45df2642ed4b~mFQk106F_1259712597epcas5p4P;
	Wed, 17 Sep 2025 13:30:33 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.87]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cRflr6KPRz3hhT4; Wed, 17 Sep
	2025 13:30:32 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250917133031epcas5p44cb316383361b7b671a15a2d6d7386d1~mFQi-XOnn1259712597epcas5p4N;
	Wed, 17 Sep 2025 13:30:31 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250917133030epsmtip1d2021157cee1fb7ebdc702d252040fa5~mFQh24ux30522305223epsmtip1a;
	Wed, 17 Sep 2025 13:30:30 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V3 03/20] nvdimm/label: Modify nd_label_base() signature
Date: Wed, 17 Sep 2025 18:59:23 +0530
Message-Id: <20250917132940.1566437-4-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917132940.1566437-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917133031epcas5p44cb316383361b7b671a15a2d6d7386d1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917133031epcas5p44cb316383361b7b671a15a2d6d7386d1
References: <20250917132940.1566437-1-s.neeraj@samsung.com>
	<CGME20250917133031epcas5p44cb316383361b7b671a15a2d6d7386d1@epcas5p4.samsung.com>

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

