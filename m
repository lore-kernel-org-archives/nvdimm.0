Received: from esa2.hc1455-7.c3s2.iphmx.com (esa2.hc1455-7.c3s2.iphmx.com [207.54.90.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601437495
	for <nvdimm@lists.linux.dev>; Thu, 23 Nov 2023 02:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="140613235"
X-IronPort-AV: E=Sophos;i="6.04,220,1695654000"; 
   d="scan'208";a="140613235"
Received: from unknown (HELO yto-r4.gw.nic.fujitsu.com) ([218.44.52.220])
  by esa2.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 11:31:20 +0900
Received: from yto-m4.gw.nic.fujitsu.com (yto-nat-yto-m4.gw.nic.fujitsu.com [192.168.83.67])
	by yto-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id C84A3D3EB2
	for <nvdimm@lists.linux.dev>; Thu, 23 Nov 2023 11:31:17 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by yto-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id 12EC914EDE
	for <nvdimm@lists.linux.dev>; Thu, 23 Nov 2023 11:31:17 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id A39FEE20D9
	for <nvdimm@lists.linux.dev>; Thu, 23 Nov 2023 11:31:16 +0900 (JST)
Received: from FNSTPC.g08.fujitsu.local (unknown [10.167.226.45])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 4F48E1A0071;
	Thu, 23 Nov 2023 10:31:16 +0800 (CST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH 2/3] test/cxl-region-sysfs.sh: use operator '!=' to compare hexadecimal value
Date: Thu, 23 Nov 2023 10:30:57 +0800
Message-ID: <20231123023058.2963551-2-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231123023058.2963551-1-lizhijian@fujitsu.com>
References: <20231123023058.2963551-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28014.004
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28014.004
X-TMASE-Result: 10--8.353400-10.000000
X-TMASE-MatchedRID: /2NGPvLZz+PDmO1DJUuxWVRF81tbZq+Ql9q75JzWJRNM+b8yxBqvA78F
	Hrw7frluf146W0iUu2uHLV03CrWr2cVM5J3Ud/0Uzr16YOzjZ10CtGYG0znilEty8cifGH0Uqzl
	QyGeIJ2Xi8zVgXoAltuJ5hXsnxp7jC24oEZ6SpSkj80Za3RRg8IU0y08TmYjc55tJ6KD5Hlpawv
	BGQOevA0Lbc95R1vNyGSCvLi0tcps=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Fix errors:
line 111: [: 0x80000000: integer expression expected
line 112: [: 0x3ff110000000: integer expression expected
line 141: [: 0x80000000: integer expression expected
line 143: [: 0x3ff110000000: integer expression expected

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 test/cxl-region-sysfs.sh | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/test/cxl-region-sysfs.sh b/test/cxl-region-sysfs.sh
index ded7aa1..89f21a3 100644
--- a/test/cxl-region-sysfs.sh
+++ b/test/cxl-region-sysfs.sh
@@ -108,8 +108,8 @@ do
 
 	sz=$(cat /sys/bus/cxl/devices/$i/size)
 	res=$(cat /sys/bus/cxl/devices/$i/start)
-	[ $sz -ne $region_size ] && err "$LINENO: decoder: $i sz: $sz region_size: $region_size"
-	[ $res -ne $region_base ] && err "$LINENO: decoder: $i base: $res region_base: $region_base"
+	[ "$sz" != "$region_size" ] && err "$LINENO: decoder: $i sz: $sz region_size: $region_size"
+	[ "$res" != "$region_base" ] && err "$LINENO: decoder: $i base: $res region_base: $region_base"
 done
 
 # validate all switch decoders have the correct settings
@@ -143,9 +143,9 @@ do
 
 	res=$(decimal_to_hex $(echo $decoder | jq -r ".resource"))
 	sz=$(decimal_to_hex $(echo $decoder | jq -r ".size"))
-	[ $sz -ne $region_size ] && err \
+	[ "$sz" != "$region_size" ] && err \
 	"$LINENO: decoder: $i sz: $sz region_size: $region_size"
-	[ $res -ne $region_base ] && err \
+	[ "$res" != "$region_base" ] && err \
 	"$LINENO: decoder: $i base: $res region_base: $region_base"
 done
 
-- 
2.41.0

