Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C6C35BDBC
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962721; cv=none; b=RIXHsZIYlMs7cw8Uq8cKWRQytTl0gtAbY9ufCxCbcfRke5/0jHbgzxmkP1YHv8fuQofCZqthi2zwPBUY36AkDg3yjgjtAuemwdbqZwyeHnXpLgqjYpeLjkal0Ycg08fgSyakaTu8D/rPHxbmwyQC0F8iW3ZJQnKf4xQrp1v6wmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962721; c=relaxed/simple;
	bh=7wS8SF5L1SMjyiUjc9IW0gH8hSECl7p9MepOxkO2ydE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=bqqyW0xt32TjL+Lqzy4jPDbDv/GxbmBJkZXAKaZHh36LwT8YuQFmFL4CbpeNeMdwergx2HQ0HWhFWXA4GyuYBw2fCHudN1iHB2U45cr/aBeFAXDTDCH3qS/mANrIkprq8rMOIslPKpmpkW0kb9emtA5ze4vGHXNgkI7c7vTBlUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Rq6cst+r; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Rq6cst+r"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260109124518epoutp0190ac661036c2fdedfd625ecff28ab183~JELm0epiG0815508155epoutp01e
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:45:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260109124518epoutp0190ac661036c2fdedfd625ecff28ab183~JELm0epiG0815508155epoutp01e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767962718;
	bh=NbPWNi0pzEvD5YwskenIcUOkOu9snU3PvuKwTqmm89o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rq6cst+rKFHMwiGDdL27HIWw60e2sOi1khkcMICpgUOFbiTKzE0d9jLco8U4B/icl
	 gj6PsaHrO/c1vEf2UpLwBkLyNNtOdCzvOhN0uU45vDRftVQH3y9bxq+coyyVHEKXKO
	 o7vHjFnhtSUmiz8OBhDE8kkH3EVQb4CsADcvLAts=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260109124518epcas5p2ddd891883a94dd91d0232011f23ce8c5~JELmlkLCX2134121341epcas5p2T;
	Fri,  9 Jan 2026 12:45:18 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.92]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dnhM149vFz6B9m4; Fri,  9 Jan
	2026 12:45:17 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260109124517epcas5p3d11e7d0941bcf34c74a789917c8aa0d0~JELlgdbO52082420824epcas5p3W;
	Fri,  9 Jan 2026 12:45:17 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260109124513epsmtip187a144b008f6dc82eb6ca676db476585~JELilYP910977109771epsmtip1l;
	Fri,  9 Jan 2026 12:45:13 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V5 05/17] nvdimm/label: Skip region label during ns label
 DPA reservation
Date: Fri,  9 Jan 2026 18:14:25 +0530
Message-Id: <20260109124437.4025893-6-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260109124437.4025893-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260109124517epcas5p3d11e7d0941bcf34c74a789917c8aa0d0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260109124517epcas5p3d11e7d0941bcf34c74a789917c8aa0d0
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124517epcas5p3d11e7d0941bcf34c74a789917c8aa0d0@epcas5p3.samsung.com>

CXL 3.2 Spec mentions CXL LSA 2.1 Namespace Labels at section
9.13.2.5. If Namespace label is present in LSA during
nvdimm_probe() then dimm-physical-address(DPA) reservation is
required. But this reservation is not required by cxl region
label. Therefore if LSA scanning finds any region label, skip it.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 9854cb45fb62..169692dfa12c 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -469,6 +469,14 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
 		lsa_label = to_lsa_label(ndd, slot);
 		nd_label = &lsa_label->ns_label;
 
+		/*
+		 * Skip region label. If LSA label is region label
+		 * then it don't require dimm-physical-address(DPA)
+		 * reservation. Whereas its required for namespace label
+		 */
+		if (is_region_label(ndd, lsa_label))
+			continue;
+
 		if (!slot_valid(ndd, lsa_label, slot))
 			continue;
 
-- 
2.34.1

