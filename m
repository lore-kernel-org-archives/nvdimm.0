Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C106119
	for <nvdimm@lists.linux.dev>; Fri, 15 Sep 2023 06:40:11 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="120038323"
X-IronPort-AV: E=Sophos;i="6.02,148,1688396400"; 
   d="scan'208";a="120038323"
Received: from unknown (HELO yto-r4.gw.nic.fujitsu.com) ([218.44.52.220])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2023 15:38:59 +0900
Received: from yto-m2.gw.nic.fujitsu.com (yto-nat-yto-m2.gw.nic.fujitsu.com [192.168.83.65])
	by yto-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id 20B05CD6E4
	for <nvdimm@lists.linux.dev>; Fri, 15 Sep 2023 15:38:57 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by yto-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id 670B0D67B6
	for <nvdimm@lists.linux.dev>; Fri, 15 Sep 2023 15:38:56 +0900 (JST)
Received: from irides.g08.fujitsu.local (unknown [10.167.234.230])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id 9BBA06BD68;
	Fri, 15 Sep 2023 15:38:55 +0900 (JST)
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: djwong@kernel.org,
	chandan.babu@oracle.com,
	dan.j.williams@intel.com
Subject: [PATCH] xfs: drop experimental warning for FSDAX
Date: Fri, 15 Sep 2023 14:38:54 +0800
Message-ID: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27876.005
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27876.005
X-TMASE-Result: 10-3.770200-10.000000
X-TMASE-MatchedRID: 3X/UYH3GrN6NnYpO97f9vU7nLUqYrlslFIuBIWrdOeOjEIt+uIPPOFpw
	gWwusAwSxb0e/VUxknqAMuqetGVetoNN9wL55jx9avP8b9lJtWr6C0ePs7A07fH8XRQwShO7yK/
	j3dj/ulFnEWPN4Hqcfc3wfxGy5AUe7ifjaVYBbyaoRhbNySqdI+9ZcDN3XwTUiH05sAM6asOAKS
	H2EaAQtSwBpS4xRHbkhpPsVGqnTA8BxCsB8GHr28FEsV4fo4lIJMMP4MGO4TA=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

FSDAX and reflink can work together now, let's drop this warning.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 fs/xfs/xfs_super.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 1f77014c6e1a..faee773fa026 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -371,7 +371,6 @@ xfs_setup_dax_always(
 		return -EINVAL;
 	}
 
-	xfs_warn(mp, "DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
 	return 0;
 
 disable_dax:
-- 
2.42.0

