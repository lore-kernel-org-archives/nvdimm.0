Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC90C3859C1
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769167918; cv=none; b=aunFpY5VuKh9kc5HRNSVuoopEN4aPeRO35YHfTPAbjyG5w9Ek+aiIqp39ZSqUEJJbqoXgSc+OYQwnmsjplp67opP1oGJbwhAbQgcwPI+bUP8grMZGNnBRf0p9wYIOpx1u16spQHAryL/35VD2blZ5hnyBDSgTo6mKDrzoV3Kvtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769167918; c=relaxed/simple;
	bh=qzPar7obw36NTmPt2/9vP+Zkp3egPZG/7olE6tY06Eg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=sqL6eqb1L1ijFybsznIPjD4mG0o0/RlvOqg3KjqvcqNjcU3TqbU/qEypw1lAEK7W++9ZEpScAu6Hl2TWTlRVDPWbPrqrdHdTsJXnixAHAReDJvFU0aZmwPleh0i54xdJiJTx40Rlm1vpiuX33+zPjq7tiG3dfWlmiIy2VfETApE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=gl+VzFkD; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gl+VzFkD"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260123113152epoutp047ec2b41a34464c29ca546c690c9a0e14~NWNfByJ0R0116901169epoutp04x
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260123113152epoutp047ec2b41a34464c29ca546c690c9a0e14~NWNfByJ0R0116901169epoutp04x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769167912;
	bh=6p1qnXqZOG7pC4bLUPqhPGqIpYVzEFMexCDooS72Qbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gl+VzFkDrt8BbR6DDIkYeizehDF9OFZcBLnMLfprs2HShWIfKqAry8R7V4sS8siE+
	 TDLAxppRzv/c6/Ua1nBZ/SjnYBtL5AwDBwmkkhy8tooIDzVeHf0r/oZfa/rcJX1wkC
	 5erao1LihU0My/Fk4VDF3UIMYRmHREe1DlKd/p2c=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260123113152epcas5p1beb310d63acb5de9d41c9c3e3b880733~NWNevH52J2762827628epcas5p1V;
	Fri, 23 Jan 2026 11:31:52 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.91]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dyG3q2Fdhz2SSKY; Fri, 23 Jan
	2026 11:31:51 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260123113150epcas5p14974b694807b93b27319c33f3003dcba~NWNdrP8M70266802668epcas5p10;
	Fri, 23 Jan 2026 11:31:50 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260123113149epsmtip2ad1a52fe6cbea5b2b91db1b2d727fbf6~NWNcmanMK2685626856epsmtip2m;
	Fri, 23 Jan 2026 11:31:49 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V6 18/18] cxl/pmem: Add CXL LSA 2.1 support in cxl pmem
Date: Fri, 23 Jan 2026 17:01:12 +0530
Message-Id: <20260123113112.3488381-19-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260123113112.3488381-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260123113150epcas5p14974b694807b93b27319c33f3003dcba
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260123113150epcas5p14974b694807b93b27319c33f3003dcba
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
	<CGME20260123113150epcas5p14974b694807b93b27319c33f3003dcba@epcas5p1.samsung.com>

Add support of CXL LSA 2.1 using NDD_REGION_LABELING flag. It creates
cxl region based on region information parsed from LSA

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
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

