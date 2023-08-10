Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFD510FC
	for <nvdimm@lists.linux.dev>; Thu, 10 Aug 2023 05:41:17 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="127267077"
X-IronPort-AV: E=Sophos;i="6.01,161,1684767600"; 
   d="scan'208";a="127267077"
Received: from unknown (HELO oym-r4.gw.nic.fujitsu.com) ([210.162.30.92])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 14:40:05 +0900
Received: from oym-m4.gw.nic.fujitsu.com (oym-nat-oym-m4.gw.nic.fujitsu.com [192.168.87.61])
	by oym-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id B54B7DDC88
	for <nvdimm@lists.linux.dev>; Thu, 10 Aug 2023 14:40:02 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by oym-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id E227CD6166
	for <nvdimm@lists.linux.dev>; Thu, 10 Aug 2023 14:40:01 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.215.54])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id 5AE29200649E0;
	Thu, 10 Aug 2023 14:40:01 +0900 (JST)
From: Xiao Yang <yangx.jy@fujitsu.com>
To: vishal.l.verma@intel.com,
	nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	Xiao Yang <yangx.jy@fujitsu.com>
Subject: [NDCTL PATCH 1/2] daxctl: Don't check param.no_movable when param.no_online is set
Date: Thu, 10 Aug 2023 13:39:57 +0800
Message-Id: <20230810053958.14992-1-yangx.jy@fujitsu.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27804.005
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27804.005
X-TMASE-Result: 10--5.252800-10.000000
X-TMASE-MatchedRID: T/UKjKdt5dO1Hdke1yr59x1kSRHxj+Z5TFQnI+epPIbAuQ0xDMaXkH4q
	tYI9sRE/7wJL2+8U4LEQMsrEt9MpLGfwTtWE8r6mh5kaQXRvR9dAApRfVHzqNJsoi2XrUn/J8m+
	hzBStansUGm4zriL0oQtuKBGekqUpI/NGWt0UYPAib5v3wiVe9VdYGfzWX7ubeHFxVLR7sXq8HT
	8Ap0Ak7Ed5hikrcf0r
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

param.no_movable is used to online memory in ZONE_NORMAL but
param.no_online is used to not online memory. So it's unnecessary
to check param.no_movable when param.no_online is set.

Signed-off-by: Xiao Yang <yangx.jy@fujitsu.com>
---
 daxctl/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/daxctl/device.c b/daxctl/device.c
index 360ae8b..ba31eb6 100644
--- a/daxctl/device.c
+++ b/daxctl/device.c
@@ -711,7 +711,7 @@ static int reconfig_mode_system_ram(struct daxctl_dev *dev)
 	const char *devname = daxctl_dev_get_devname(dev);
 	int rc, skip_enable = 0;
 
-	if (param.no_online || !param.no_movable) {
+	if (param.no_online) {
 		if (!param.force && daxctl_dev_will_auto_online_memory(dev)) {
 			fprintf(stderr,
 				"%s: error: kernel policy will auto-online memory, aborting\n",
-- 
2.40.1

