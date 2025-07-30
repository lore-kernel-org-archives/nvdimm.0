Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0762F29AAF3
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753877808; cv=none; b=jsaJnPiGe0i5WBgFPfsrnCc/xNLHBiu+XrO8H+LKavo0gDf3ye2FxOH6/8W5e6ekGpOB3Th7VFnNt4zURUmSOdkAMV9NSk33GM7/vC3f8mVlejHSdjfre5KgsPGKSniQx51n7CRSMYtaFmG2pLnPH2nY7QFkbOc1VcUBadfwC/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753877808; c=relaxed/simple;
	bh=ZRCrkNJDO2PC3b9ZNmoYzvpgYNXI+WY/f0h4p/88ZkM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=uf4s4rjPr1wgHCLRYIv82Ymmn6bbpaZWy4hjOGnImu3Zvmzx/k98lPvZy52n3flBVPMCiysMPvQecHBnaFCpVesXmgDu0Lyj3sdS8lAJSWzdXpZuU/IBXyKThiiRBGkjVWEuNri56ktUpWTeukiDABHIztGq6C8UfZGueROEJLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=VXAofIXt; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="VXAofIXt"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250730121645epoutp029e513bfdff801d851913950431c33aa1~XBpJH_M2X1892218922epoutp02G
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:16:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250730121645epoutp029e513bfdff801d851913950431c33aa1~XBpJH_M2X1892218922epoutp02G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753877805;
	bh=T7BIWAapAhWvOfBB49SbVlMNokBpyallrCxttGotF+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXAofIXtaxSLbcjcKfB3da0JPWikHAf0AzNbOwVJEpANlPLXvlw/M/ZbWGdaxvNkk
	 fBq+LxbJQ1Ec+brw9PZVAKzitsrHTdEYYkekJpShuocRpUxm6jzHBfdGoQqDfjpa7E
	 HoT6OeQSGbwcU8Hq0cenXmRLrLEQOF3kG6/2wuXo=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250730121644epcas5p2c32bba500cd3bd7c0f7c4dbc8df97c45~XBpI1N-XJ2418524185epcas5p2T;
	Wed, 30 Jul 2025 12:16:44 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.95]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4bsWRH6p3jz6B9m6; Wed, 30 Jul
	2025 12:16:43 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250730121231epcas5p2c12cb2b4914279d1f1c93e56a32c3908~XBlcsRj-H2146721467epcas5p2r;
	Wed, 30 Jul 2025 12:12:31 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250730121230epsmtip1475d92b8baf2091b2cf7dd28aa1ee4ec~XBlbp5udN0289802898epsmtip1V;
	Wed, 30 Jul 2025 12:12:30 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V2 07/20] nvdimm/namespace_label: Update namespace
 init_labels and its region_uuid
Date: Wed, 30 Jul 2025 17:41:56 +0530
Message-Id: <20250730121209.303202-8-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250730121209.303202-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250730121231epcas5p2c12cb2b4914279d1f1c93e56a32c3908
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121231epcas5p2c12cb2b4914279d1f1c93e56a32c3908
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121231epcas5p2c12cb2b4914279d1f1c93e56a32c3908@epcas5p2.samsung.com>

nd_mapping->labels maintains the list of labels present into LSA.
init_labels() prepares this list while adding new label into LSA
and updates nd_mapping->labels accordingly. During cxl region
creation nd_mapping->labels list and LSA was updated with one
region label. Therefore during new namespace label creation
pre-include the previously created region label, so increase
num_labels count by 1.

Also updated nsl_set_region_uuid with region uuid with which
namespace is associated with.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index be18278d6cea..fd02b557612e 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -957,7 +957,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	nsl_set_slot(ndd, nd_label, slot);
 	nsl_set_alignment(ndd, nd_label, 0);
 	nsl_set_type_guid(ndd, nd_label, &nd_set->type_guid);
-	nsl_set_region_uuid(ndd, nd_label, NULL);
+	nsl_set_region_uuid(ndd, nd_label, &nd_set->uuid);
 	nsl_set_claim_class(ndd, nd_label, ndns->claim_class);
 	nsl_calculate_checksum(ndd, nd_label);
 	nd_dbg_dpa(nd_region, ndd, res, "\n");
@@ -1129,7 +1129,8 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 				count++;
 		WARN_ON_ONCE(!count);
 
-		rc = init_labels(nd_mapping, count);
+		/* Adding 1 to pre include the already added region label */
+		rc = init_labels(nd_mapping, count + 1);
 		if (rc < 0)
 			return rc;
 
-- 
2.34.1

