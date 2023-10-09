Received: from esa11.hc1455-7.c3s2.iphmx.com (esa11.hc1455-7.c3s2.iphmx.com [207.54.90.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA6618646
	for <nvdimm@lists.linux.dev>; Mon,  9 Oct 2023 10:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-IronPort-AV: E=McAfee;i="6600,9927,10857"; a="114720652"
X-IronPort-AV: E=Sophos;i="6.03,210,1694703600"; 
   d="scan'208";a="114720652"
Received: from unknown (HELO yto-r2.gw.nic.fujitsu.com) ([218.44.52.218])
  by esa11.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2023 19:35:37 +0900
Received: from yto-m1.gw.nic.fujitsu.com (yto-nat-yto-m1.gw.nic.fujitsu.com [192.168.83.64])
	by yto-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id 68CD6C68E1
	for <nvdimm@lists.linux.dev>; Mon,  9 Oct 2023 19:35:35 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by yto-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id A52EDCFAB6
	for <nvdimm@lists.linux.dev>; Mon,  9 Oct 2023 19:35:34 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id 3B13A200649E7
	for <nvdimm@lists.linux.dev>; Mon,  9 Oct 2023 19:35:34 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.215.54])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id B2C8F1A006F;
	Mon,  9 Oct 2023 18:35:33 +0800 (CST)
From: Xiao Yang <yangx.jy@fujitsu.com>
To: dave.jiang@intel.com,
	nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	Xiao Yang <yangx.jy@fujitsu.com>
Subject: [PATCH] libdaxctl: Add accurate check for daxctl_memory_op(MEM_GET_ZONE)
Date: Mon,  9 Oct 2023 18:35:21 +0800
Message-Id: <20231009103521.1463-1-yangx.jy@fujitsu.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27924.006
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27924.006
X-TMASE-Result: 10-2.746400-10.000000
X-TMASE-MatchedRID: NuUGwdOZh4byRz8Qcki7lXbspjK6JP6qqf/efKFN1nAOkJQR4QWbsOAf
	SNitoKTvvnCllUJsUcsrl+ihTfUqCy/7QU2czuUNA9lly13c/gHQtWdx8wWyB5soi2XrUn/J8m+
	hzBStansUGm4zriL0oQtuKBGekqUpnH7sbImOEBTX1aoH+YbIYXePu1dFcJxWA98Y2YPqyTRLEP
	hl5F28z7HNWK6ZoMeGNMOVrZgLmjTf3Ugo3F3SFsJX5ZE3B+hYAtgaIaH2O4qbDRBqS2n66yzP5
	xAyz9Oenvkw4sh/+PcMX5CwH5DTUmgGZNLBHGNe
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

The return number of daxctl_memory_op(MEM_GET_ZONE) indicates
how many memory blocks have the same memory zone. So It's wrong
to compare mem->zone and zone only when zero is returned.

Signed-off-by: Xiao Yang <yangx.jy@fujitsu.com>
---
 daxctl/lib/libdaxctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index b27a8af..4f9aba0 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -1616,7 +1616,7 @@ static int daxctl_memory_online_with_zone(struct daxctl_memory *mem,
 	 */
 	mem->zone = 0;
 	rc = daxctl_memory_op(mem, MEM_GET_ZONE);
-	if (rc)
+	if (rc < 0)
 		return rc;
 	if (mem->zone != zone) {
 		err(ctx,
-- 
2.40.0

