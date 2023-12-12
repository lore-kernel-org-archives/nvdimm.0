Received: from esa7.hc1455-7.c3s2.iphmx.com (esa7.hc1455-7.c3s2.iphmx.com [139.138.61.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D733171A9
	for <nvdimm@lists.linux.dev>; Tue, 12 Dec 2023 07:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="121724065"
X-IronPort-AV: E=Sophos;i="6.04,269,1695654000"; 
   d="scan'208";a="121724065"
Received: from unknown (HELO oym-r3.gw.nic.fujitsu.com) ([210.162.30.91])
  by esa7.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 16:42:38 +0900
Received: from oym-m1.gw.nic.fujitsu.com (oym-nat-oym-m1.gw.nic.fujitsu.com [192.168.87.58])
	by oym-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id 7CF95D64AA
	for <nvdimm@lists.linux.dev>; Tue, 12 Dec 2023 16:42:36 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by oym-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id B58B4D88C2
	for <nvdimm@lists.linux.dev>; Tue, 12 Dec 2023 16:42:35 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id 588622235D3
	for <nvdimm@lists.linux.dev>; Tue, 12 Dec 2023 16:42:35 +0900 (JST)
Received: from FNSTPC.g08.fujitsu.local (unknown [10.167.226.45])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id D8FD81A0072;
	Tue, 12 Dec 2023 15:42:34 +0800 (CST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	Li Zhijian <lizhijian@fujitsu.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [ndctl PATCH v2 2/2] test/cxl-region-sysfs.sh: Fix cxl-region-sysfs.sh: line 107: [: missing `]'
Date: Tue, 12 Dec 2023 15:42:28 +0800
Message-ID: <20231212074228.1261164-2-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231212074228.1261164-1-lizhijian@fujitsu.com>
References: <20231212074228.1261164-1-lizhijian@fujitsu.com>
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
X-TMASE-Result: 10--8.334700-10.000000
X-TMASE-MatchedRID: t6JJoekIeTgLv9prS13LlikMR2LAnMRpa9qiaDSLgo3AuQ0xDMaXkH4q
	tYI9sRE/Zcz/Uu/FtYPtjxM/SvQjtaWgCWYvFMxF30kDaWZBE1R9LQinZ4QefCP/VFuTOXUT3n8
	eBZjGmUzkwjHXXC/4IzsAVzN+Ov/stcNle00JMl/25rmwZaliDg3eW8MLx6PslF/WROKYytd08J
	Rkzff5pg==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

A space is missing before ']'

Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 test/cxl-region-sysfs.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/cxl-region-sysfs.sh b/test/cxl-region-sysfs.sh
index 6a5da6d..db1a163 100644
--- a/test/cxl-region-sysfs.sh
+++ b/test/cxl-region-sysfs.sh
@@ -104,7 +104,7 @@ do
 	iw=$(cat /sys/bus/cxl/devices/$i/interleave_ways)
 	ig=$(cat /sys/bus/cxl/devices/$i/interleave_granularity)
 	[ $iw -ne $nr_targets ] && err "$LINENO: decoder: $i iw: $iw targets: $nr_targets"
-	[ $ig -ne $r_ig] && err "$LINENO: decoder: $i ig: $ig root ig: $r_ig"
+	[ $ig -ne $r_ig ] && err "$LINENO: decoder: $i ig: $ig root ig: $r_ig"
 
 	sz=$(cat /sys/bus/cxl/devices/$i/size)
 	res=$(cat /sys/bus/cxl/devices/$i/start)
-- 
2.41.0

