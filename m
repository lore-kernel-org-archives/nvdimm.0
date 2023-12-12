Received: from esa9.hc1455-7.c3s2.iphmx.com (esa9.hc1455-7.c3s2.iphmx.com [139.138.36.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9623D156DE
	for <nvdimm@lists.linux.dev>; Tue, 12 Dec 2023 07:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="131327595"
X-IronPort-AV: E=Sophos;i="6.04,269,1695654000"; 
   d="scan'208";a="131327595"
Received: from unknown (HELO yto-r3.gw.nic.fujitsu.com) ([218.44.52.219])
  by esa9.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 16:42:38 +0900
Received: from yto-m1.gw.nic.fujitsu.com (yto-nat-yto-m1.gw.nic.fujitsu.com [192.168.83.64])
	by yto-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id 40A25D4F51
	for <nvdimm@lists.linux.dev>; Tue, 12 Dec 2023 16:42:36 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by yto-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id 7ECDECFA5A
	for <nvdimm@lists.linux.dev>; Tue, 12 Dec 2023 16:42:35 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id 0EE61220B61
	for <nvdimm@lists.linux.dev>; Tue, 12 Dec 2023 16:42:35 +0900 (JST)
Received: from FNSTPC.g08.fujitsu.local (unknown [10.167.226.45])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 946B21A0070;
	Tue, 12 Dec 2023 15:42:34 +0800 (CST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH v2 1/2] test/cxl-region-sysfs.sh: use '[[ ]]' command to evaluate operands as arithmetic expressions
Date: Tue, 12 Dec 2023 15:42:27 +0800
Message-ID: <20231212074228.1261164-1-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28052.005
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28052.005
X-TMASE-Result: 10--14.299100-10.000000
X-TMASE-MatchedRID: lbdkQWb+CNa807Kcu3J19f7FEhWgo0y8ZHgsiwoRh5SQ/M2woPYElgZN
	LEcrBa0w1jypNY0wtaaH+JfGStEzSQV2NKF6aideEXjPIvKd74BMkOX0UoduuUuzcQ+Ei1EdE4L
	eIK6Wkgpwyt0nJpv88Rt7xe4OdcmOhQKGB0Brm3ueAiCmPx4NwGmRqNBHmBvepuP9zg477pEqtq
	5d3cxkNTNpc4k18Mbt9FzqcgSlnvO7xTDNpo6pbKYak0sSo4uObhFfFP4tDFk=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

It doesn't work for '[ operand1 -ne operand2 ]' where either operand1 or
operand2 is not integer value.
It's tested that bash 4.1/4.2/5.0/5.1 are impacted.

Per bash man page, use '[[ ]]' command to evaluate operands as arithmetic
expressions

Fix errors:
line 111: [: 0x80000000: integer expression expected
line 112: [: 0x3ff110000000: integer expression expected
line 141: [: 0x80000000: integer expression expected
line 143: [: 0x3ff110000000: integer expression expected

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
V2: use '[[ ]]' instead of conversion before comparing in V1
---
 test/cxl-region-sysfs.sh | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/test/cxl-region-sysfs.sh b/test/cxl-region-sysfs.sh
index 8636392..6a5da6d 100644
--- a/test/cxl-region-sysfs.sh
+++ b/test/cxl-region-sysfs.sh
@@ -108,8 +108,8 @@ do
 
 	sz=$(cat /sys/bus/cxl/devices/$i/size)
 	res=$(cat /sys/bus/cxl/devices/$i/start)
-	[ $sz -ne $region_size ] && err "$LINENO: decoder: $i sz: $sz region_size: $region_size"
-	[ $res -ne $region_base ] && err "$LINENO: decoder: $i base: $res region_base: $region_base"
+	[[ $sz -ne $region_size ]] && err "$LINENO: decoder: $i sz: $sz region_size: $region_size"
+	[[ $res -ne $region_base ]] && err "$LINENO: decoder: $i base: $res region_base: $region_base"
 done
 
 # validate all switch decoders have the correct settings
@@ -138,9 +138,9 @@ do
 
 	res=$(echo $decoder | jq -r ".resource")
 	sz=$(echo $decoder | jq -r ".size")
-	[ $sz -ne $region_size ] && err \
+	[[ $sz -ne $region_size ]] && err \
 	"$LINENO: decoder: $i sz: $sz region_size: $region_size"
-	[ $res -ne $region_base ] && err \
+	[[ $res -ne $region_base ]] && err \
 	"$LINENO: decoder: $i base: $res region_base: $region_base"
 done
 
-- 
2.41.0

