Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93027361DD3
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769167897; cv=none; b=k4CzT9Ovl0Vhl7dQW+Y2gNrvMpDAKqwGuxVT2SWx8XVIVI7ZctVrVn9xEkNyIIwZc1KxGMcYr6DxvNvgEWOWbF4N/sxJt/iZy/tMinQ4TOmRxBbGqhGvWsvuud9MUozGdQOj126VHYVbHAooMQMpHgRjho3QsDcRCtvBG8XN97Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769167897; c=relaxed/simple;
	bh=Hc/LE7S7ygoxfL1UA2Iyub7zUbzQXaayt+Tz65QkZn8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=stkrs0+M4b/QYBI/nLl4L5x8+6/h1BDt+1OXwJzjQUgptTrfKCk4EW7d0AALMSdPwPM80lLoRzrmVWuSRgw+LoJy/YahQhYIDw7SlRTE64HEhUgBCLenfm3Srj1vJJD7Si0bXQ2gVyg9pqFE8JiFDa0mLgsCIE6EdxazRoSIbxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=qVk48t7r; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qVk48t7r"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260123113132epoutp02817a4cdc91eeb2bbbdcfe8fc1f539690~NWNMhXgV70069700697epoutp02Z
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260123113132epoutp02817a4cdc91eeb2bbbdcfe8fc1f539690~NWNMhXgV70069700697epoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769167892;
	bh=Je8+tDbOogLpQy7XjpQXu4atLQSWU6GOTBA3BV7GROo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qVk48t7rNumOt8D0O9yoskYMiaceW+RmkLVQrS4jMP8nRuJ8Jay9MZ1LsY+ClSZsq
	 ote5Nc+XWjKV11kRD4sxTuHlfNr7K41W7hEY32rhE8otFemV7F8Eo47q4QQJsQlApa
	 FDP6WHxMx8WHVLrg3UWrhT/cl77701GhJrnxYweo=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260123113132epcas5p41fd35b87847b41fdbf7a52442830c77a~NWNMSjANm1464914649epcas5p4Q;
	Fri, 23 Jan 2026 11:31:32 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.91]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dyG3R3jTyz6B9mB; Fri, 23 Jan
	2026 11:31:31 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260123113130epcas5p4af26a172d155a1c8b78d33945f495452~NWNKynEhY1479614796epcas5p4M;
	Fri, 23 Jan 2026 11:31:30 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260123113129epsmtip25f735015777e2fb8aa9661dc713ff0e3~NWNJs7vBO2355523555epsmtip2k;
	Fri, 23 Jan 2026 11:31:29 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V6 05/18] nvdimm/label: Skip region label during ns label
 DPA reservation
Date: Fri, 23 Jan 2026 17:00:59 +0530
Message-Id: <20260123113112.3488381-6-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260123113112.3488381-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260123113130epcas5p4af26a172d155a1c8b78d33945f495452
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260123113130epcas5p4af26a172d155a1c8b78d33945f495452
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
	<CGME20260123113130epcas5p4af26a172d155a1c8b78d33945f495452@epcas5p4.samsung.com>

CXL 3.2 Spec mentions CXL LSA 2.1 Namespace Labels at section
9.13.2.5. If Namespace label is present in LSA during
nvdimm_probe() then dimm-physical-address(DPA) reservation is
required. But this reservation is not required by cxl region
label. Therefore if LSA scanning finds any region label, skip it.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 5a4599c5e5a8..f18b04f63dcc 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -471,6 +471,13 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
 		lsa_label = to_lsa_label(ndd, slot);
 		nd_label = &lsa_label->ns_label;
 
+		/*
+		 * If the LSA label is a region label then it doesn't
+		 * require a dimm-physical-address(DPA) reservation.
+		 */
+		if (is_region_label(ndd, lsa_label))
+			continue;
+
 		if (!slot_valid(ndd, lsa_label, slot))
 			continue;
 
-- 
2.34.1

