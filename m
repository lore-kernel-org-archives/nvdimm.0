Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC15A14B95A
	for <nvdimm@lists.linux.dev>; Mon, 19 Aug 2024 06:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.36.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724048485; cv=none; b=no1ZuPQMufpn3R5vN70iZCCMTA2tBULNSv0izLTIle412xj/UjsdK6hDbwY8T4zL7kKGVVFR1n66GftfoTXWmiXUVDYXm8/wBYybRRArDjXSGUxlHwf+Z0EmIkV8F+581iuZh3FqeJVbJekew6plu4Xz0sIbaivjDIXEC5a5FKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724048485; c=relaxed/simple;
	bh=a+0n0CXtNrarF+xG7qvVujI92Un+hGrjPuUZFryzKII=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sJvbiJzUDpCpkhTfTX2W8htmdjRpUuFR7/M/dgiesSALQ/ip7gUU0sLdPkg3Mnq/Xs9oSKzCYga5xKiXIPFmM/uXTU5/NdrCxlFBe5SLzOqH5CobUYtdjXdq06laqU3TtsYaLtdErQTLxQmqL7whYuOIzUamqDdZ4Ews8oSLrpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=IzBJo4bK; arc=none smtp.client-ip=139.138.36.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="IzBJo4bK"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1724048482; x=1755584482;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a+0n0CXtNrarF+xG7qvVujI92Un+hGrjPuUZFryzKII=;
  b=IzBJo4bKYCXu2FHltgYf+tHpsNwkmEVG25Tk1U/3MMlgmVfnSLgnwRaF
   AmC1XIkrbdHEXQqfcdKYaPU55F3xQhkVkAcnMvc0vzhGTxoOmm7us9Bn7
   Qec8snkhLvcbNTSEzBuayWp7Q9T8zXkFLyRqlmYrAcX4OMcON4NPUrnHR
   cRZpv+qqPAHlwUy0KWh1VHEKVxfrRtZQzWLhNx6pz0wU31vttD0BDTErY
   Q+CdN7+h70PWuAuGu+Sm0AT3eb5aFNvqq9i3qloZ3XG7xdPfRS6vY5/rh
   t32gsmuJcb9PGTnBci5L2F2+Ss+22aVsVQpYH87ppTJYQCBeQUrgeMOJB
   Q==;
X-CSE-ConnectionGUID: Lv+EWqQDQCudYNRS4ecyFQ==
X-CSE-MsgGUID: 05ea5DQtRuCuK8JZ0ggbCw==
X-IronPort-AV: E=McAfee;i="6700,10204,11168"; a="158346490"
X-IronPort-AV: E=Sophos;i="6.10,158,1719846000"; 
   d="scan'208";a="158346490"
Received: from unknown (HELO oym-r2.gw.nic.fujitsu.com) ([210.162.30.90])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2024 15:21:14 +0900
Received: from oym-m2.gw.nic.fujitsu.com (oym-nat-oym-m2.gw.nic.fujitsu.com [192.168.87.59])
	by oym-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id 0924BD425D
	for <nvdimm@lists.linux.dev>; Mon, 19 Aug 2024 15:21:12 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by oym-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id 5831BBF3D7
	for <nvdimm@lists.linux.dev>; Mon, 19 Aug 2024 15:21:11 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id E317F2007CDD6
	for <nvdimm@lists.linux.dev>; Mon, 19 Aug 2024 15:21:10 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 5D8191A000C;
	Mon, 19 Aug 2024 14:21:10 +0800 (CST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	linux-kernel@vger.kernel.org,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [PATCH v3 2/2] nvdimm: Remove dead code for ENODEV checking in scan_labels()
Date: Mon, 19 Aug 2024 14:20:45 +0800
Message-Id: <20240819062045.1481298-2-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240819062045.1481298-1-lizhijian@fujitsu.com>
References: <20240819062045.1481298-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28604.005
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28604.005
X-TMASE-Result: 10--6.042500-10.000000
X-TMASE-MatchedRID: wJuAbHRzrYfH3ZCJRIiNpAXGi/7cli9jG3SoAWcU42VD0XHWdCmZPCXj
	tnu2lwmLkPI1/ZdqoS0pVSN22QMNpsyvuTCA7wzlolVO7uyOCDXBOVz0Jwcxl6vCrG0TnfVUIb5
	NpqK++5qbpZ8QUEHE+lcnoO4Nx+lojejKCMx4rt64u3nS+3EEDpki3iIBA3o/vy9ABIQaa1mjxY
	yRBa/qJcFwgTvxipFa9xS3mVzWUuA4wHSyGpeEeqvNPRcWGGWSbTId9Q2wfGKa7xgiZswm8wNo2
	tfYpsrJuhQI4KJ0drQ=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

The only way create_namespace_pmem() returns an ENODEV code is if
select_pmem_id(nd_region, &uuid) returns ENODEV when its 2nd parameter
is a null pointer. However, this is impossible because &uuid is always
valid.

Furthermore, create_namespace_pmem() is the only user of
select_pmem_id(), it's safe to remove the 'return -ENODEV' branch.

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
V2:
  new patch.
  It's found when I'm Reviewing/tracing the return values of create_namespace_pmem()
---
 drivers/nvdimm/namespace_devs.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 35d9f3cc2efa..55cfbf1e0a95 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1612,9 +1612,6 @@ static int select_pmem_id(struct nd_region *nd_region, const uuid_t *pmem_id)
 {
 	int i;
 
-	if (!pmem_id)
-		return -ENODEV;
-
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
@@ -1790,9 +1787,6 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
 	case -EINVAL:
 		dev_dbg(&nd_region->dev, "invalid label(s)\n");
 		break;
-	case -ENODEV:
-		dev_dbg(&nd_region->dev, "label not found\n");
-		break;
 	default:
 		dev_dbg(&nd_region->dev, "unexpected err: %d\n", rc);
 		break;
@@ -1980,9 +1974,6 @@ static struct device **scan_labels(struct nd_region *nd_region)
 			case -EAGAIN:
 				/* skip invalid labels */
 				continue;
-			case -ENODEV:
-				/* fallthrough to seed creation */
-				break;
 			default:
 				goto err;
 			}
-- 
2.29.2

