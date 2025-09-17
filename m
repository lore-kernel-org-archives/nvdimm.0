Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A6C332A51
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758116514; cv=none; b=Km/xEB1DiySL/cVJOppaidriwk3kAPLbANXnmyaY8zY6AFy0Gqm3A1o7megvuoT++/ea+Dsa9KQALrsjD9IgPcBXQ3kFKyZDY1uZf9khYiGWJXTINi/UwtY0xYQrdHBxUIEYts8TAxiI7qIRgc5H/DskhIFX7CtMfi9oQ1/ShF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758116514; c=relaxed/simple;
	bh=RcHk8WZ2UuIHppAX6L+eQPaLFn6Vtz8ivz7q2719PHk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=OX8CICqAaVT/RleLrx3y5QF/8gqvCDBs67Mix1DSngon83SgSlJmfHP6U5ZjvL+63xTuhGOrSSPILOcu1rqDfxw3XI/U5iCHR/lFH7flF5kr4Kf6TrUgXsAgplfLwZW2YG+ivnB+yRjTIuWGPmPNJGF634tztWTKMqtP6SXkstQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=MyjYkBUs; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MyjYkBUs"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250917134149epoutp01e750953237725fde1663397d3f3bcc9a~mFaaALHMA3166131661epoutp01G
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:41:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250917134149epoutp01e750953237725fde1663397d3f3bcc9a~mFaaALHMA3166131661epoutp01G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758116509;
	bh=ifsQ5LfCM0vfQYRmAKPl7bTVrf062dIvEHubp+A3f7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MyjYkBUsenyY8VcRmySXyWyF3nOCrXOxzkaYEuX3Scidh4zFV3flrOVpjcfD5dq7O
	 U8SvF4+8MsuFVxl1MNpzy1Tu6OsIcu9WwKSIpjrNJQpnz/YTysAmZR22lvVjg+ozhl
	 Qeylky+++cZYJA6I/qEI6hj6To7kVr9hgST1p02k=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250917134148epcas5p132403067cee9e356d233ccae11a47c72~mFaY-CywK1744617446epcas5p1f;
	Wed, 17 Sep 2025 13:41:48 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.88]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4cRg0q2h11z6B9m4; Wed, 17 Sep
	2025 13:41:47 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250917134146epcas5p2a1f3eb1ece0c000eedd06c3201cb8132~mFaXnoKdr0912409124epcas5p2T;
	Wed, 17 Sep 2025 13:41:46 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250917134145epsmtip2d81b34392bfe8c03acd7631a83afc3be~mFaWM06bE0911709117epsmtip2U;
	Wed, 17 Sep 2025 13:41:44 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com, Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V3 09/20] nvdimm/namespace_label: Skip region label during
 ns label DPA reservation
Date: Wed, 17 Sep 2025 19:11:05 +0530
Message-Id: <20250917134116.1623730-10-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917134116.1623730-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917134146epcas5p2a1f3eb1ece0c000eedd06c3201cb8132
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917134146epcas5p2a1f3eb1ece0c000eedd06c3201cb8132
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134146epcas5p2a1f3eb1ece0c000eedd06c3201cb8132@epcas5p2.samsung.com>

If Namespace label is present in LSA during nvdimm_probe() then DPA
reservation is required. But this reservation is not required by region
label. Therefore if LSA scanning finds any region label, skip it.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 5e476154cf81..935a0df5b47e 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -441,6 +441,7 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
 		return 0; /* no label, nothing to reserve */
 
 	for_each_clear_bit_le(slot, free, nslot) {
+		union nd_lsa_label *lsa_label;
 		struct nd_namespace_label *nd_label;
 		struct nd_region *nd_region = NULL;
 		struct nd_label_id label_id;
@@ -448,9 +449,14 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
 		uuid_t label_uuid;
 		u32 flags;
 
-		nd_label = to_label(ndd, slot);
+		lsa_label = (union nd_lsa_label *) to_label(ndd, slot);
+		nd_label = &lsa_label->ns_label;
 
-		if (!slot_valid(ndd, (union nd_lsa_label *) nd_label, slot))
+		/* Skip region label. DPA reservation is for NS label only */
+		if (is_region_label(ndd, lsa_label))
+			continue;
+
+		if (!slot_valid(ndd, lsa_label, slot))
 			continue;
 
 		nsl_get_uuid(ndd, nd_label, &label_uuid);
-- 
2.34.1

