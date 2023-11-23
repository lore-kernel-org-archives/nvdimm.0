Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974DA6128
	for <nvdimm@lists.linux.dev>; Thu, 23 Nov 2023 02:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="128301617"
X-IronPort-AV: E=Sophos;i="6.04,220,1695654000"; 
   d="scan'208";a="128301617"
Received: from unknown (HELO yto-r1.gw.nic.fujitsu.com) ([218.44.52.217])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 11:31:19 +0900
Received: from yto-m1.gw.nic.fujitsu.com (yto-nat-yto-m1.gw.nic.fujitsu.com [192.168.83.64])
	by yto-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id ACCABD66C3
	for <nvdimm@lists.linux.dev>; Thu, 23 Nov 2023 11:31:17 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by yto-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id EAC07D2BA4
	for <nvdimm@lists.linux.dev>; Thu, 23 Nov 2023 11:31:16 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id 80BC23478C
	for <nvdimm@lists.linux.dev>; Thu, 23 Nov 2023 11:31:16 +0900 (JST)
Received: from FNSTPC.g08.fujitsu.local (unknown [10.167.226.45])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id F0AEB1A0070;
	Thu, 23 Nov 2023 10:31:15 +0800 (CST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH 1/3] test/cxl-region-sysfs.sh: covert size and resource to hex before test
Date: Thu, 23 Nov 2023 10:30:56 +0800
Message-ID: <20231123023058.2963551-1-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.41.0
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
X-TMASE-Result: 10--2.693700-10.000000
X-TMASE-MatchedRID: 6dKu2vg/m/jQVDF+NEc7OKqHmm/V4M/PwTlc9CcHMZerwqxtE531VICu
	qghmtWfXc/72aFsOO+2vgQVzBNg7CEkjllSXrjtQFEUknJ/kEl5lVdRvgpNpe/oLR4+zsDTt+gm
	Vy5VdZkkoFZWCCVaZXTTuNTcutxmE5oGtlhFa2n9GqDYEsb/9xYcKB/WDLZ7j94QVgFklbyC+NW
	PBbd+wipp1uSErN3/v1yS0S/9EZEGGk+xUaqdMDwHEKwHwYevbwUSxXh+jiUgkww/gwY7hMA==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

size and resource are both decimal

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 test/cxl-region-sysfs.sh | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/test/cxl-region-sysfs.sh b/test/cxl-region-sysfs.sh
index 8636392..ded7aa1 100644
--- a/test/cxl-region-sysfs.sh
+++ b/test/cxl-region-sysfs.sh
@@ -123,6 +123,11 @@ readarray -t switch_decoders < <(echo $json | jq -r ".[].decoder")
 [ ${#switch_decoders[@]} -ne $nr_switch_decoders ] && err \
 "$LINENO: expected $nr_switch_decoders got ${#switch_decoders[@]} switch decoders"
 
+decimal_to_hex()
+{
+	printf "0x%x" $1
+}
+
 for i in ${switch_decoders[@]}
 do
 	decoder=$(echo $json | jq -r ".[] | select(.decoder == \"$i\")")
@@ -136,8 +141,8 @@ do
 	[ $ig -ne $((r_ig << depth)) ] && err \
 	"$LINENO: decoder: $i ig: $ig switch_ig: $((r_ig << depth))"
 
-	res=$(echo $decoder | jq -r ".resource")
-	sz=$(echo $decoder | jq -r ".size")
+	res=$(decimal_to_hex $(echo $decoder | jq -r ".resource"))
+	sz=$(decimal_to_hex $(echo $decoder | jq -r ".size"))
 	[ $sz -ne $region_size ] && err \
 	"$LINENO: decoder: $i sz: $sz region_size: $region_size"
 	[ $res -ne $region_base ] && err \
-- 
2.41.0

