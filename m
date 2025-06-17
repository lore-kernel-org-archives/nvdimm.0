Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD162EACF7
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750165212; cv=none; b=RUJf5oLhsPZ8BVtwHVF3QGoMWasIxQkXOcO96iWDrPslfeWP/lVo5zCyOdx6BnjRBTcCf3CD51+wdyGSoWOllLEkVNLnbvVPaUIOk2AbSIk8IkPpllZSf6SZxW1Z68Fw6rfzaMLeAZmTuyTNTmwxJiZSV7cUxW76pCK5PiZe74I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750165212; c=relaxed/simple;
	bh=QPRyqi00g3KJ9J3/BOtH9ar5XWUEC5GSFTuURVygUrE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=SHmmU/u5jsTt5HKGHpxVZbjwp4TqmFvD1TV3SKEw+9IPhOj22q2wnfOmF3vntqEOOSGJxwA2P+YoDb6i02A8d+Q/5PpeP4nLjKtDAXM1//dFPZkLnnhwqN3mPrKVx3hi16c3M12dh4u91qqp4EWyyoIGcfOkk+wgm9c3TB6JLlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=REbDqV+P; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="REbDqV+P"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250617130005epoutp010db2a463a1dfd13653097a4406ed7e69~J1ftXBsg_0668606686epoutp01d
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:00:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250617130005epoutp010db2a463a1dfd13653097a4406ed7e69~J1ftXBsg_0668606686epoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750165205;
	bh=mGOKRZhuRng8+G/QThk2A3VRJikf51QSXgSzCEdjU8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=REbDqV+PmFzICJsQc5XQrgbdJ5p3WtEewJef+wrSjfc5YNp0B6Rreqt/I0b9GmL+x
	 31Yk4EoinjqNaNfFoCpPp+7gj+pfH1BjNlu/ZQ3rVvS51e0zwaoAKSVgsu0tK6xj+B
	 K8LOeoIdeVNgsiBVe0OjmucDkLTwyCT15J0Z1kfE=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250617130005epcas5p20cff7e0ab5ca5607ee6edae7abf2485d~J1fs3AobM1917719177epcas5p2N;
	Tue, 17 Jun 2025 13:00:05 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bM6R90n2qz3hhT4; Tue, 17 Jun
	2025 13:00:05 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250617124031epcas5p3542c2fc6d946f3cdcbc06dbfc65743e2~J1On-HuCs2102821028epcas5p33;
	Tue, 17 Jun 2025 12:40:31 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250617124028epsmtip2fae8871e5bf5e82a4abc397ffd8e6dde~J1Ole78oP2555425554epsmtip2H;
	Tue, 17 Jun 2025 12:40:28 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: dan.j.williams@intel.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, s.neeraj@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: [RFC PATCH 09/20] nvdimm/namespace_label: Skip region label during
 ns label DPA reservation
Date: Tue, 17 Jun 2025 18:09:33 +0530
Message-Id: <306123060.201750165205099.JavaMail.epsvc@epcpadp1new>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250617123944.78345-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250617124031epcas5p3542c2fc6d946f3cdcbc06dbfc65743e2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124031epcas5p3542c2fc6d946f3cdcbc06dbfc65743e2
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124031epcas5p3542c2fc6d946f3cdcbc06dbfc65743e2@epcas5p3.samsung.com>

If Namespace label is present in LSA during nvdimm_probe then DPA
reservation is required. But this reservation is not required by region
label. Therefore if LSA scanning finds any region label, skip it.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 22e13db1ca20..3a870798a90c 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -450,6 +450,10 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
 		nd_label = to_label(ndd, slot);
 		ns_label = &nd_label->ns_label;
 
+		/* skip region label, dpa reservation for ns label only */
+		if (is_region_label(ndd, nd_label))
+			continue;
+
 		if (!slot_valid(ndd, nd_label, slot))
 			continue;
 
-- 
2.34.1


