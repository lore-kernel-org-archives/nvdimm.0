Received: from esa9.hc1455-7.c3s2.iphmx.com (esa9.hc1455-7.c3s2.iphmx.com [139.138.36.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C3418AE1
	for <nvdimm@lists.linux.dev>; Wed,  9 Aug 2023 15:47:56 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="115950278"
X-IronPort-AV: E=Sophos;i="6.01,159,1684767600"; 
   d="scan'208";a="115950278"
Received: from unknown (HELO yto-r3.gw.nic.fujitsu.com) ([218.44.52.219])
  by esa9.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 00:46:42 +0900
Received: from yto-m3.gw.nic.fujitsu.com (yto-nat-yto-m3.gw.nic.fujitsu.com [192.168.83.66])
	by yto-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id 26C9AE428A
	for <nvdimm@lists.linux.dev>; Thu, 10 Aug 2023 00:46:41 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by yto-m3.gw.nic.fujitsu.com (Postfix) with ESMTP id 5A453D9688
	for <nvdimm@lists.linux.dev>; Thu, 10 Aug 2023 00:46:40 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.215.54])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id AC18E200501B6;
	Thu, 10 Aug 2023 00:46:39 +0900 (JST)
From: Xiao Yang <yangx.jy@fujitsu.com>
To: vishal.l.verma@intel.com,
	nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	Xiao Yang <yangx.jy@fujitsu.com>
Subject: [NDCTL PATCH] daxctl: Remove unused mem_zone variable
Date: Wed,  9 Aug 2023 23:46:36 +0800
Message-Id: <20230809154636.11887-1-yangx.jy@fujitsu.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27804.000
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27804.000
X-TMASE-Result: 10--1.324500-10.000000
X-TMASE-MatchedRID: wzvsWxCP1hZlJTodqNqEzhFbgtHjUWLywTlc9CcHMZerwqxtE531VIPc
	XuILVCbaRuz+B9qwyFIQMsrEt9MpLGfwTtWE8r6mBe3KRVyu+k1JXeUbJfbZl5soi2XrUn/J8m+
	hzBStantdY+ZoWiLImydET58jp62SQdP5uqvPxk5qdc/uc0ZG4Uhx88+6GIDS2VMt2uxVmsV+rD
	4aHMnLq/mptzwfUCHPKq8qdRk8TPgOncV1svvHP/1hA9bmXgujwGC8e6520fKw0PJt06oJaHpaQ
	l5xviY7wxgWdRvK9Un9g+oMf9KM6Q==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

mem_zone variable has never been used so remove it.

Signed-off-by: Xiao Yang <yangx.jy@fujitsu.com>
---
 daxctl/device.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/daxctl/device.c b/daxctl/device.c
index d2d206b..360ae8b 100644
--- a/daxctl/device.c
+++ b/daxctl/device.c
@@ -59,7 +59,6 @@ enum memory_zone {
 	MEM_ZONE_MOVABLE,
 	MEM_ZONE_NORMAL,
 };
-static enum memory_zone mem_zone = MEM_ZONE_MOVABLE;
 
 enum device_action {
 	ACTION_RECONFIG,
@@ -469,8 +468,6 @@ static const char *parse_device_options(int argc, const char **argv,
 				align = __parse_size64(param.align, &units);
 		} else if (strcmp(param.mode, "system-ram") == 0) {
 			reconfig_mode = DAXCTL_DEV_MODE_RAM;
-			if (param.no_movable)
-				mem_zone = MEM_ZONE_NORMAL;
 		} else if (strcmp(param.mode, "devdax") == 0) {
 			reconfig_mode = DAXCTL_DEV_MODE_DEVDAX;
 			if (param.no_online) {
@@ -494,9 +491,6 @@ static const char *parse_device_options(int argc, const char **argv,
 			align = __parse_size64(param.align, &units);
 		/* fall through */
 	case ACTION_ONLINE:
-		if (param.no_movable)
-			mem_zone = MEM_ZONE_NORMAL;
-		/* fall through */
 	case ACTION_DESTROY:
 	case ACTION_OFFLINE:
 	case ACTION_DISABLE:
-- 
2.40.1

