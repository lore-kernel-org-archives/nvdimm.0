Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A0A3321A6
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763538826; cv=none; b=abykCygv/aEJqo+TfVW6SPEjN3dEbeUkqTGJzeTQIxm9QfEkwpJHjnTu5R8TasaQw5MhF06RGf2E9SgQA9ZAzLnPwYqOuQtmEUXpik2b0J+vaoCHMYcIImei/ddhpujgDxR3nZLz9l6mhea1yZMUvEBeUvjhAtnmC6uscFDOVqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763538826; c=relaxed/simple;
	bh=AfBioUf1IVGmsSD9OMFKz6qxSlMnB+8ca3YxyO/ofIg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=lSyzwI9Vm5TOI7T1iT9pa5Wi8c93LsmplacTvsEnmESAFNoXQR1WpjNY/VHEI+La+c4snydyLEETnJM4SDMhObqBX0zSBDoW8hBt6FlbZDYQj7bDAei6D4SnH+TbaLZ7EIWrj23jwBjBbt3K1qZYyv8zYmlYqs7O7XNZ6UL70Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=hY77iF0e; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="hY77iF0e"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251119075342epoutp03f42bb0c649ef019f5776e33a93c2b9d8~5WTc6am-52947829478epoutp03f
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251119075342epoutp03f42bb0c649ef019f5776e33a93c2b9d8~5WTc6am-52947829478epoutp03f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1763538822;
	bh=r0m+fwZmxBJRaLlXaZy9HJnLDXtt5ZcCqrXivVZfU+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hY77iF0erohl6xADWuqvn/YGgcnhyaFJrGvaCQM+qqZN7UtJ8bLSPPEw+p4lt1cxX
	 Jo387QyIlHJlt+mMaYKN0zzfsdkgO5HzHID50Vntv9QgGZZuSRQOZEKYFuGrcHdZ6W
	 G7NE7e3Z/Altz1oCp3whEqiIyChJwDaz0DicKjpQ=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20251119075342epcas5p4dd7beb63b638e948d29f40cdf11d0b33~5WTcTUDLS0326403264epcas5p42;
	Wed, 19 Nov 2025 07:53:42 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.89]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dBDJ50yVKz3hhTH; Wed, 19 Nov
	2025 07:53:41 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20251119075340epcas5p42d0fa80388af654dff0da088fb3e978c~5WTa9Nc1d1043810438epcas5p4K;
	Wed, 19 Nov 2025 07:53:40 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251119075339epsmtip142b837a41fae8a18ee46218eb6f63495~5WTZ33uH82573225732epsmtip1I;
	Wed, 19 Nov 2025 07:53:39 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V4 17/17] cxl/pmem: Add CXL LSA 2.1 support in cxl pmem
Date: Wed, 19 Nov 2025 13:22:55 +0530
Message-Id: <20251119075255.2637388-18-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251119075255.2637388-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251119075340epcas5p42d0fa80388af654dff0da088fb3e978c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251119075340epcas5p42d0fa80388af654dff0da088fb3e978c
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075340epcas5p42d0fa80388af654dff0da088fb3e978c@epcas5p4.samsung.com>

Add support of CXL LSA 2.1 using NDD_REGION_LABELING flag. It creates
cxl region based on region information parsed from LSA

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/pmem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index a6eba3572090..5970d1792be8 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -135,6 +135,7 @@ static int cxl_nvdimm_probe(struct device *dev)
 		return rc;
 
 	set_bit(NDD_LABELING, &flags);
+	set_bit(NDD_REGION_LABELING, &flags);
 	set_bit(NDD_REGISTER_SYNC, &flags);
 	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
 	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
@@ -155,6 +156,7 @@ static int cxl_nvdimm_probe(struct device *dev)
 		return -ENOMEM;
 
 	dev_set_drvdata(dev, nvdimm);
+	create_pmem_region(nvdimm);
 	return devm_add_action_or_reset(dev, unregister_nvdimm, nvdimm);
 }
 
-- 
2.34.1

