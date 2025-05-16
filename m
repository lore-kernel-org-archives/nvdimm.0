Received: from esa7.hc1455-7.c3s2.iphmx.com (esa7.hc1455-7.c3s2.iphmx.com [139.138.61.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64FF21D5B3
	for <nvdimm@lists.linux.dev>; Fri, 16 May 2025 05:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.61.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747372487; cv=none; b=Iy2UaGaG2ymmwg7bYegNJiX5vL58p1fRtyyK88ykA/xTmQNQffjBJa2pDTgyUsWBsIoerk6PVuEkvh331SGGOu6wb2aE9EAvRUzZvb3OFi1S9nw4bUIZc33geunP3RyJ2mcHOIFAzfchUmUqx70euDXi2lgAzWHBg9gK8819urU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747372487; c=relaxed/simple;
	bh=lX8IBABKB+hcZ5K9brK2O4tRa1tSiyuPsl1Qt280K1w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ol88HdBWNfDZN5gEW0ePuyknllMUoZuATLDbyybz8awJIoYTYEGNmrOsIs9KPaJjxPK28/aAfnvNcqaeWBGAZc7p2qoMxF74M00hssCFpRUQe/msOdfI6I+EhKyUDwOwxtkcF/+ZJ9gcCYZfdw17Dm9BAD/ERLGELEijga6xxLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=QNPyE8b8; arc=none smtp.client-ip=139.138.61.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="QNPyE8b8"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1747372485; x=1778908485;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lX8IBABKB+hcZ5K9brK2O4tRa1tSiyuPsl1Qt280K1w=;
  b=QNPyE8b8IPrtbZnBz7kMkJMI1qAwL1N2nXqp7LpWeWYNcGmqNSN6aJoF
   TubQxs1XiLwLAqFTDN9AlBQ/C/gj/fmhlY14H0kg/LYJd7OaJQWeNcjq+
   JMexj0Bte521smSTU53+YHvY1nA12c0RTwqaEnLUUpcZlaNnQhzngYCdl
   uXIdtkVkrL3n8P/aKR6P855uyj7fuXLjI5eEoFPAOCXZvv7waDPl0s7Tn
   1r7tDUqTqwq3ZO/xvII//kjS9XqvtkLgGVtICnkalbDVEOsx+pOMU71gj
   bBE/u50dpjQIDjAg0gX5CZxZhvIqKSep1Ry+wxPN+dHXhFicaKmUcgSQp
   g==;
X-CSE-ConnectionGUID: XYx1PVKTRdmLkBlw5ZroUw==
X-CSE-MsgGUID: TIO+2xYJS3CFNg/5Pidjcw==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="178545615"
X-IronPort-AV: E=Sophos;i="6.15,293,1739804400"; 
   d="scan'208";a="178545615"
Received: from unknown (HELO yto-r2.gw.nic.fujitsu.com) ([218.44.52.218])
  by esa7.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 14:14:35 +0900
Received: from yto-m4.gw.nic.fujitsu.com (yto-nat-yto-m4.gw.nic.fujitsu.com [192.168.83.67])
	by yto-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id 4B8B7C68A8
	for <nvdimm@lists.linux.dev>; Fri, 16 May 2025 14:14:33 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by yto-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id 00186141A1
	for <nvdimm@lists.linux.dev>; Fri, 16 May 2025 14:14:32 +0900 (JST)
Received: from iaas-rpma.. (unknown [10.167.135.44])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 52FCE1A009A;
	Fri, 16 May 2025 13:14:32 +0800 (CST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	linux-kernel@vger.kernel.org,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [PATCH 2/2] nvdimm/btt: Fix memleaks in btt_init()
Date: Fri, 16 May 2025 13:13:18 +0800
Message-Id: <20250516051318.509064-2-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250516051318.509064-1-lizhijian@fujitsu.com>
References: <20250516051318.509064-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Call free_arenas() to release the arena instances in btt->arena_list
in the error paths.

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 drivers/nvdimm/btt.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index a11e4e7e9a52..a85448273a9a 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1597,7 +1597,7 @@ static struct btt *btt_init(struct nd_btt *nd_btt, unsigned long long rawsize,
 	if (btt->init_state != INIT_READY && nd_region->ro) {
 		dev_warn(dev, "%s is read-only, unable to init btt metadata\n",
 				dev_name(&nd_region->dev));
-		return NULL;
+		goto out;
 	} else if (btt->init_state != INIT_READY) {
 		btt->num_arenas = (rawsize / ARENA_MAX_SIZE) +
 			((rawsize % ARENA_MAX_SIZE) ? 1 : 0);
@@ -1607,25 +1607,29 @@ static struct btt *btt_init(struct nd_btt *nd_btt, unsigned long long rawsize,
 		ret = create_arenas(btt);
 		if (ret) {
 			dev_info(dev, "init: create_arenas: %d\n", ret);
-			return NULL;
+			goto out;
 		}
 
 		ret = btt_meta_init(btt);
 		if (ret) {
 			dev_err(dev, "init: error in meta_init: %d\n", ret);
-			return NULL;
+			goto out;
 		}
 	}
 
 	ret = btt_blk_init(btt);
 	if (ret) {
 		dev_err(dev, "init: error in blk_init: %d\n", ret);
-		return NULL;
+		goto out;
 	}
 
 	btt_debugfs_init(btt);
 
 	return btt;
+
+out:
+	free_arenas(btt);
+	return NULL;
 }
 
 /**
-- 
2.47.0

