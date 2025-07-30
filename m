Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498BA29DB96
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753877849; cv=none; b=jVBz0DSxyd71gFPMeSyeaW5pij+xwUqZ9qKrR/oQfI6+QtMxD8BkDNPAPa5ismatlODPmggRDi/EEU4TelIt2QdxBMvN8pxpfSxH0VKPSy7TmyecBmRjIy3Z6SrtbrvbJ8MzdNGTgzNSvmrYr4zY/CPMJC+hpCoXOsiDHblzFcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753877849; c=relaxed/simple;
	bh=8YmJS8hx8WgRPxcUiztDRTumHUEa4XkmtXjbqIT74Go=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=RT9TLYLeYa0S4bYIhpQw7aFFuG+W+sA0VVIHijT8JnfQmqeJhoyhlaqivB81kcsAFIKta24gtSsDWeGYmVrm7JGlZfp2wIS+JEGkWzr9lreu9MbjUgua+eKQhhhfCx+2vi8JUpahJGpGdvZY/efAaDABg7b/Ope8ffNtUcZQTn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=kyIn3AmU; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="kyIn3AmU"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250730121726epoutp012518b96a920e101843420309d4c78605~XBpvj4__b1980419804epoutp01R
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:17:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250730121726epoutp012518b96a920e101843420309d4c78605~XBpvj4__b1980419804epoutp01R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753877846;
	bh=kG0Vn+WVegBfoS656K/tyDycjWLLAWBKsbbUuaA8KMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kyIn3AmUkdDHldZjPee1UmD5B1ZnBI3CsGUWUy0feHmij/oQ2iFBGISRMB3OVc4W9
	 CumABXLH7MJ72OFR90YQtOmXWLFmz+ToqkiJPiVdqJfCyrFwJ15BYH6X/9r1oXDZ0b
	 5ca+AsWQICclH3eCKmcU5DXe87GO+Ci6aF+9N698=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250730121725epcas5p45b6cfc6db74bdbf4389c4288cfc2bd8b~XBpu_6vOe0773207732epcas5p4H;
	Wed, 30 Jul 2025 12:17:25 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.94]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4bsWS46S3Fz6B9m5; Wed, 30 Jul
	2025 12:17:24 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250730121243epcas5p4c40126a3cf5c8019b36eb8287c3ec2c8~XBloOwOKS0910609106epcas5p4Z;
	Wed, 30 Jul 2025 12:12:43 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250730121242epsmtip12bdc71955106fc2fbe7c3fde57cda3a1~XBlnMOYEI0440404404epsmtip1-;
	Wed, 30 Jul 2025 12:12:42 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V2 16/20] cxl/mem: Preserve cxl root decoder during mem
 probe
Date: Wed, 30 Jul 2025 17:42:05 +0530
Message-Id: <20250730121209.303202-17-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250730121209.303202-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250730121243epcas5p4c40126a3cf5c8019b36eb8287c3ec2c8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121243epcas5p4c40126a3cf5c8019b36eb8287c3ec2c8
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121243epcas5p4c40126a3cf5c8019b36eb8287c3ec2c8@epcas5p4.samsung.com>

Saved root decoder info is required for cxl region persistency

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/cxlmem.h | 1 +
 drivers/cxl/mem.c    | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 751478dfc410..72dfcf4671f2 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -59,6 +59,7 @@ struct cxl_memdev {
 	struct cxl_nvdimm_bridge *cxl_nvb;
 	struct cxl_nvdimm *cxl_nvd;
 	struct cxl_port *endpoint;
+	struct cxl_root_decoder *cxlrd;
 	int id;
 	int depth;
 	u8 scrub_cycle;
diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
index 54501616ff09..1a0da7253a24 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -152,6 +152,8 @@ static int cxl_mem_probe(struct device *dev)
 		return -ENXIO;
 	}
 
+	cxlmd->cxlrd = cxl_find_root_decoder_by_port(parent_port);
+
 	if (dport->rch)
 		endpoint_parent = parent_port->uport_dev;
 	else
-- 
2.34.1

