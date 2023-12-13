Received: from esa7.hc1455-7.c3s2.iphmx.com (esa7.hc1455-7.c3s2.iphmx.com [139.138.61.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D8D1EA77
	for <nvdimm@lists.linux.dev>; Wed, 13 Dec 2023 08:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="121884038"
X-IronPort-AV: E=Sophos;i="6.04,272,1695654000"; 
   d="scan'208";a="121884038"
Received: from unknown (HELO yto-r2.gw.nic.fujitsu.com) ([218.44.52.218])
  by esa7.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 17:26:05 +0900
Received: from yto-m2.gw.nic.fujitsu.com (yto-nat-yto-m2.gw.nic.fujitsu.com [192.168.83.65])
	by yto-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id C8CDCD6187
	for <nvdimm@lists.linux.dev>; Wed, 13 Dec 2023 17:26:03 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by yto-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id 03E1AD5E8D
	for <nvdimm@lists.linux.dev>; Wed, 13 Dec 2023 17:26:03 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id 942922646D6
	for <nvdimm@lists.linux.dev>; Wed, 13 Dec 2023 17:26:02 +0900 (JST)
Received: from FNSTPC.g08.fujitsu.local (unknown [10.167.226.45])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 275021A0074;
	Wed, 13 Dec 2023 16:26:02 +0800 (CST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH v3 2/2] test/cxl-region-sysfs.sh: Fix cxl-region-sysfs.sh: line 107: [: missing `]'
Date: Wed, 13 Dec 2023 16:25:56 +0800
Message-ID: <20231213082556.1401741-2-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231213082556.1401741-1-lizhijian@fujitsu.com>
References: <20231213082556.1401741-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28054.005
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28054.005
X-TMASE-Result: 10--12.942100-10.000000
X-TMASE-MatchedRID: k/L/ofNtQd05rof3b4z0VFhRyidsElYkLL6mJOIs/vZ4YeSlHZYFonNZ
	68PxzmeRdeMDTgepT/+OtOlauyE0EKPDXg0LeBewEXjPIvKd74BMkOX0UoduuZyka59saICoWFC
	ZbvPiXUVz/vZoWw477XegIXkiA/apHxPMjOKY7A/+HHE8LDNSg8RB0bsfrpPIfiAqrjYtFiSmyT
	u8BALsYNYqCJn+NGph+1h/I5+Pvo9jbs4248fyen7cGd19dSFd
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Currently the cxl-region-sysfs.sh test runs to completion and passes,
but with syntax errors in the log. It turns out that because the test is
checking for a positive condition as a failure, that also happens to
mask the syntax errors. Fix the syntax and note that this also happens
to unblock a test case that was being hidden by this error.

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
V3: update changelog per Dan's comments
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

