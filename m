Received: from esa11.hc1455-7.c3s2.iphmx.com (esa11.hc1455-7.c3s2.iphmx.com [207.54.90.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FF615D1
	for <nvdimm@lists.linux.dev>; Fri, 19 Jul 2024 01:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721354343; cv=none; b=qV9uu9DTA77sG2/6GxoO+6wtbgLSuYb+V5/h0WMocoFnW2ZHYnAQIss0A/X9xsnEGSnYyvkfB9bN8LV90DQ55weddfWBzATRoUtKwP2gt998WBZ5+uP9A7ekluMMO5TJBfpH79Va7c3kPc85UzJx0Y5ieXGA57y7YIA6inrigY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721354343; c=relaxed/simple;
	bh=cGDvTByA6KTed0UxScYm3+Rd0JNJ+VCZM7hXObyA1MA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PVT/fa6MKKkFrHPkmWk84M/o3lw3DIbJ9kZhKu/DsouKtF46gK8jLmtRxR21UrQb0e6aU+VDaUWvxFEZyfR6h8H2A/YHhF6fCJd2gGOYj99054U0+J5X8LZ7724WY2vmp/Wl2RFouseTDop2R8tWXspF1u9lJ6gFA305tYjFzlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=bJ1BOdqr; arc=none smtp.client-ip=207.54.90.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="bJ1BOdqr"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1721354341; x=1752890341;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cGDvTByA6KTed0UxScYm3+Rd0JNJ+VCZM7hXObyA1MA=;
  b=bJ1BOdqrhfOGjJzakrkze9Z98QE6X8rwVGQJ+CQmeL45ZjyXa745Wcek
   xrfGgoVYCR1ePP9jtEUETdG0S8IXvBR8wfB4x7OzoJKQ5SEFl4sRmBjzr
   dWMkKTOzpizuiZ+IhOpASMePUObBC/p96P/4cdS2wHcJ91KQq4XziCuhw
   vc2uSjsy8p/QsNJMI7j3HLy8GrSGa4Tqxl1VVHni08eU1SY/HoWwcVUDz
   +PzpJwbdNWmKpGZuHDsveJWwK5F7BaTL2mzZDzLiuUygxOas8K9hvjfcX
   KemtcJpvhRp18RwdUsmpBmxBhZ8108sHZPSNrTTvu1dTX0+G0PFXgEzld
   Q==;
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="147249308"
X-IronPort-AV: E=Sophos;i="6.09,219,1716217200"; 
   d="scan'208";a="147249308"
Received: from unknown (HELO yto-r1.gw.nic.fujitsu.com) ([218.44.52.217])
  by esa11.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2024 10:58:52 +0900
Received: from yto-m1.gw.nic.fujitsu.com (yto-nat-yto-m1.gw.nic.fujitsu.com [192.168.83.64])
	by yto-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id 21379DB3CD
	for <nvdimm@lists.linux.dev>; Fri, 19 Jul 2024 10:58:49 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by yto-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id 61AD2D1988
	for <nvdimm@lists.linux.dev>; Fri, 19 Jul 2024 10:58:48 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id EF1C9224979
	for <nvdimm@lists.linux.dev>; Fri, 19 Jul 2024 10:58:47 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 736D31A000C;
	Fri, 19 Jul 2024 09:58:47 +0800 (CST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	linux-kernel@vger.kernel.org,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [PATCH v2 2/2] nvdimm: Remove dead code for ENODEV checking in scan_labels()
Date: Fri, 19 Jul 2024 09:58:36 +0800
Message-Id: <20240719015836.1060677-2-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240719015836.1060677-1-lizhijian@fujitsu.com>
References: <20240719015836.1060677-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28538.002
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28538.002
X-TMASE-Result: 10--6.042500-10.000000
X-TMASE-MatchedRID: wJuAbHRzrYfH3ZCJRIiNpAXGi/7cli9jG3SoAWcU42VD0XHWdCmZPCXj
	tnu2lwmLkPI1/ZdqoS0pVSN22QMNpsyvuTCA7wzlolVO7uyOCDXBOVz0Jwcxl6vCrG0TnfVUIb5
	NpqK++5qbpZ8QUEHE+lcnoO4Nx+lojejKCMx4rt64u3nS+3EEDpki3iIBA3o/vy9ABIQaa1mjxY
	yRBa/qJcFwgTvxipFa9xS3mVzWUuA4wHSyGpeEeiw2x397pFEmTHLkTUFitAOaKHuLVl3J1P0zo
	l91xrHXEgajmqqPXvQ=
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
index 28c9afc01dca..21020cd16117 100644
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
@@ -1974,9 +1968,6 @@ static struct device **scan_labels(struct nd_region *nd_region)
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

