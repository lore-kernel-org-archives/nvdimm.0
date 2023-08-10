Received: from esa7.hc1455-7.c3s2.iphmx.com (esa7.hc1455-7.c3s2.iphmx.com [139.138.61.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD15610E1
	for <nvdimm@lists.linux.dev>; Thu, 10 Aug 2023 05:41:17 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="106574499"
X-IronPort-AV: E=Sophos;i="6.01,161,1684767600"; 
   d="scan'208";a="106574499"
Received: from unknown (HELO oym-r1.gw.nic.fujitsu.com) ([210.162.30.89])
  by esa7.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 14:40:05 +0900
Received: from oym-m4.gw.nic.fujitsu.com (oym-nat-oym-m4.gw.nic.fujitsu.com [192.168.87.61])
	by oym-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id 553D7D29E8
	for <nvdimm@lists.linux.dev>; Thu, 10 Aug 2023 14:40:03 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by oym-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id 4E985D6170
	for <nvdimm@lists.linux.dev>; Thu, 10 Aug 2023 14:40:02 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.215.54])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id B4E3C2007CAA2;
	Thu, 10 Aug 2023 14:40:01 +0900 (JST)
From: Xiao Yang <yangx.jy@fujitsu.com>
To: vishal.l.verma@intel.com,
	nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	Xiao Yang <yangx.jy@fujitsu.com>
Subject: [NDCTL PATCH 2/2] daxctl: Force to offline memory by param.force
Date: Thu, 10 Aug 2023 13:39:58 +0800
Message-Id: <20230810053958.14992-2-yangx.jy@fujitsu.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230810053958.14992-1-yangx.jy@fujitsu.com>
References: <20230810053958.14992-1-yangx.jy@fujitsu.com>
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
X-TMASE-Result: 10--2.193800-10.000000
X-TMASE-MatchedRID: BlFNdihulaZshf/+m2ScwM2CuVPkCNzu2FA7wK9mP9fgmDZo451ggv7L
	3VZcu8PZIvrftAIhWmLy9zcRSkKatQ719kpOO37Puce7gFxhKa19LQinZ4QefCP/VFuTOXUTae6
	hIZpj4MuOhzOa6g8KrWor42kTLgBu28VS3sAnFx3m/04kAXeiCpaV+lyn9ScL3NhLOCFbUh8OUB
	5Fhd8SNSWTCXYZzv7nN3T10+hc2IUrAtd165OQjhXBt/mUREyAj/ZFF9Wfm7hNy7ppG0IjcFQqk
	0j7vLVUewMSBDreIdk=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Try to make daxctl reconfigure-device with system-ram mode
offline memory when both param.no_online and param.force
are set but daxctl_dev_will_auto_online_memory returns true.

Signed-off-by: Xiao Yang <yangx.jy@fujitsu.com>
---
 daxctl/device.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/daxctl/device.c b/daxctl/device.c
index ba31eb6..dfa7f79 100644
--- a/daxctl/device.c
+++ b/daxctl/device.c
@@ -83,7 +83,7 @@ OPT_STRING('m', "mode", &param.mode, "mode", "mode to switch the device to"), \
 OPT_BOOLEAN('N', "no-online", &param.no_online, \
 	"don't auto-online memory sections"), \
 OPT_BOOLEAN('f', "force", &param.force, \
-		"attempt to offline memory sections before reconfiguration"), \
+		"attempt to offline memory sections for reconfiguration"), \
 OPT_BOOLEAN('C', "check-config", &param.check_config, \
 		"use config files to determine parameters for the operation")
 
@@ -734,8 +734,13 @@ static int reconfig_mode_system_ram(struct daxctl_dev *dev)
 			return rc;
 	}
 
-	if (param.no_online)
+	if (param.no_online) {
+		if (param.force && daxctl_dev_will_auto_online_memory(dev)) {
+			rc = dev_offline_memory(dev);
+			return rc;
+		}
 		return 0;
+	}
 
 	return dev_online_memory(dev);
 }
-- 
2.40.1

