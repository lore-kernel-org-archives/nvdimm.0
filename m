Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0AE31A81D
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758115849; cv=none; b=QoJ+5GYi7Q/lMghlADhhvk45L4CZqNlZCYGFYJEq7hvIwS1Ij7ACRZl4YRAmIenQW2sfh0dCIYs4z0gAsl5PIrqvaXqa4gOX+a+0Px5kinptQ6FRocabSPWoNBEp9h6dBx/tmaMbixQUhN6kXi0HwZxzaVcwk6AA7AO8/2mD/3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758115849; c=relaxed/simple;
	bh=RcHk8WZ2UuIHppAX6L+eQPaLFn6Vtz8ivz7q2719PHk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=rBdhsxvLfDWKWorgFeTzhtE3AJOutLvoSuIBpjHkZ6An3wmXR9tpSu0TPgnPEGG70NAqpURAcO/Ug5NXcHnZ+pypP38PCW/L8eARzdaJOyiG+K1f1mpaSQmkiCO0ZMzZA/geJyqDn13QU8bquasMPE8vqbdm729ytuKKcLB3Hyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=cBg2vNEH; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cBg2vNEH"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250917133045epoutp033820cbb4958c453055fd4797595daa50~mFQvTPDjj2740227402epoutp03d
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250917133045epoutp033820cbb4958c453055fd4797595daa50~mFQvTPDjj2740227402epoutp03d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758115845;
	bh=ifsQ5LfCM0vfQYRmAKPl7bTVrf062dIvEHubp+A3f7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cBg2vNEHrm+BGNBEHEiiLj91rm1NUH/2d24NqUJjQHzPzBsReH2dzmCRnx1m0Lbil
	 Ei7lqKdfwks3NJkRFX0mcZLUuM9pX3EadPg7hJtnH8U/n84BK98UYtUMXgUTf30xTn
	 MTznli0chsHfwkPDl20YshJrEc1ss6v4mbjM0mI8=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250917133044epcas5p30c6cd6e0ae2dd5a1472318c71b3e7321~mFQvEZAw23266332663epcas5p3R;
	Wed, 17 Sep 2025 13:30:44 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.86]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cRfm35Lvmz6B9m5; Wed, 17 Sep
	2025 13:30:43 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250917133043epcas5p32a39aeb5ce521debb447c15e24a407af~mFQtkWu2C3265832658epcas5p3P;
	Wed, 17 Sep 2025 13:30:43 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250917133042epsmtip19625634c49ede5e05e64871501039dbb~mFQshWxf-0238602386epsmtip1X;
	Wed, 17 Sep 2025 13:30:41 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V3 09/20] nvdimm/namespace_label: Skip region label during
 ns label DPA reservation
Date: Wed, 17 Sep 2025 18:59:29 +0530
Message-Id: <20250917132940.1566437-10-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917132940.1566437-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917133043epcas5p32a39aeb5ce521debb447c15e24a407af
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917133043epcas5p32a39aeb5ce521debb447c15e24a407af
References: <20250917132940.1566437-1-s.neeraj@samsung.com>
	<CGME20250917133043epcas5p32a39aeb5ce521debb447c15e24a407af@epcas5p3.samsung.com>

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

