Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB8829ACF6
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753877819; cv=none; b=oXRKT5GCtHatdYhQuQ5dl18gq09TY1eeBTegZi1OIG/y62PLTSrObfmhSSz06P1jjo7bUqpRzK7fORKGteUftxhc4Ffr/J0z/68ELX6dPSDMSILjunjcuTp0X7lXxPwi74MbdY5heMMlPxSiymJATpiOFBd0UuC6ife+8OcFan0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753877819; c=relaxed/simple;
	bh=x0Z2ILurDCvn3GfhXRXpdWuzleMMLe6kVmKk+oP3BKA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=KUZFI5MqO2dzyNQ7XbgJd99TMyv7xGS2Y2jvbVLchRncgbC8UQLYjFZAyXh4yaG5uZdKkcfE97+F+HOYj3e2ahzvij8GDnrrrWymV8vaDBGgW58b23SHcEeFZTiPldsImbS9kcUdu/jRixdOtDlCvuVhCY+LC/FufR498UUlYKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Y97i2Inl; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Y97i2Inl"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250730121655epoutp04bf9b0e2528c2d6daa784df6e481e4c86~XBpSxMxZu1257912579epoutp04W
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:16:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250730121655epoutp04bf9b0e2528c2d6daa784df6e481e4c86~XBpSxMxZu1257912579epoutp04W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753877815;
	bh=2PqU+CyrXyozcs0kynv08iU3+ORaGVNKWsW8Db7mtdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y97i2InlwIfqqnQAnO6fn4zZ9h+lW763o3PCbqmlEzV4ozbAVKO7o4DtzYcc5+0SZ
	 A9eHiti67zryOD3iNNZ31lf/ifgvoMzYDwbP0kopMPILCzbHI416T/RMCK2n6WLX+c
	 Z2VIpz82nH+fOIdsUEYH3FV780hgmNOdh/9pSg0k=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250730121655epcas5p291a57c3d0d01c3ebbac4d51ca56638e6~XBpSdjEtD2419124191epcas5p2p;
	Wed, 30 Jul 2025 12:16:55 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.91]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4bsWRV2BFMz6B9m5; Wed, 30 Jul
	2025 12:16:54 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250730121234epcas5p2605fbec7bc95f6096550792844b8f8ee~XBlfQgQJS0097800978epcas5p2B;
	Wed, 30 Jul 2025 12:12:34 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250730121232epsmtip137e525c5ce4722df799cc72cd2c5d722~XBleMx_yp0289802898epsmtip1X;
	Wed, 30 Jul 2025 12:12:32 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V2 09/20] nvdimm/namespace_label: Skip region label during
 ns label DPA reservation
Date: Wed, 30 Jul 2025 17:41:58 +0530
Message-Id: <20250730121209.303202-10-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250730121209.303202-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250730121234epcas5p2605fbec7bc95f6096550792844b8f8ee
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121234epcas5p2605fbec7bc95f6096550792844b8f8ee
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121234epcas5p2605fbec7bc95f6096550792844b8f8ee@epcas5p2.samsung.com>

If Namespace label is present in LSA during nvdimm_probe then DPA
reservation is required. But this reservation is not required by region
label. Therefore if LSA scanning finds any region label, skip it.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index c4748e30f2b6..064a945dcdd1 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -452,6 +452,10 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
 		lsa_label = to_label(ndd, slot);
 		nd_label = &lsa_label->ns_label;
 
+		/* skip region label, dpa reservation for ns label only */
+		if (is_region_label(ndd, lsa_label))
+			continue;
+
 		if (!slot_valid(ndd, lsa_label, slot))
 			continue;
 
-- 
2.34.1

