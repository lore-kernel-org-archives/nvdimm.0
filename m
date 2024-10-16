Received: from esa12.hc1455-7.c3s2.iphmx.com (esa12.hc1455-7.c3s2.iphmx.com [139.138.37.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E7B12E4A
	for <nvdimm@lists.linux.dev>; Wed, 16 Oct 2024 03:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.37.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729047871; cv=none; b=BL1F61xJuxXXCDmafsPX7uPLYNtdy11nZqxNLvRci9VWBnl2FKnyFu3l56fKta8tTm6fKP25CY7hsPt+esT87RmrI1NxHrdHgkjQraXiEhaInT4cQni4DcC0qh46/4yfJaSqDRJ3HHfaMntPuCD8xsQ6r3VMfXNoLXULLJOdp70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729047871; c=relaxed/simple;
	bh=V9XEDtH8WDYY6bGc+86z7aqIoQ03QWEFqV8kc1x/5bI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aGdRA9ClosScBYSrJpZoPnvT8V5CoxUSgU4zJe53gWjm91/eaSDSOlO/2+3kgvgLDTr+mkCrg/qcZP3tWQmYFxXXCsE0IE0y/Hkgthx+yvOaZVi9YV1Ablj9KUUHSmD8FbcUg8+xFmmCMPMTgJ15sAHwmwCuaxdMLQzyadDA5I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=JwrLc1wW; arc=none smtp.client-ip=139.138.37.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="JwrLc1wW"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1729047870; x=1760583870;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=V9XEDtH8WDYY6bGc+86z7aqIoQ03QWEFqV8kc1x/5bI=;
  b=JwrLc1wWNDIGOVVdQOH5Krn1SCK0iujP3jGVVA3tUb3mtHQDEyANe25r
   hj9rXFW/NxrQCQGtfvOm8YuCbkINSXmqVpDBsv/960Uhv3zgQwCYjphjy
   wdsPvf9EYOXkTu2v6lfxyJtBIGAIjbc8N+pqXWibuvuymHi0haDMF8TWp
   DXGLgxOCDzH2+/dnCjDstXJIM8EzD2UEgY9WNUh32CAgx4MbYrSK3Qiy4
   zjKNu7C6jbQZoUmCMRWqp+19rmzAKjZ5k0y8YpU+pBglm6tEAdvcqVg+O
   TaiJJWwjsEwXF70mHnBPzUJC8nIT+4/BX5HZjrHP8UvfT8nwyr6wIZciq
   Q==;
X-CSE-ConnectionGUID: zucJMbR5Rxe1jMR9sNEaFA==
X-CSE-MsgGUID: fqeoap14RFaPMeZw5zxbXg==
X-IronPort-AV: E=McAfee;i="6700,10204,11225"; a="155864118"
X-IronPort-AV: E=Sophos;i="6.11,206,1725289200"; 
   d="scan'208";a="155864118"
Received: from unknown (HELO oym-r3.gw.nic.fujitsu.com) ([210.162.30.91])
  by esa12.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2024 12:03:18 +0900
Received: from oym-m4.gw.nic.fujitsu.com (oym-nat-oym-m4.gw.nic.fujitsu.com [192.168.87.61])
	by oym-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id 132BDC53D6
	for <nvdimm@lists.linux.dev>; Wed, 16 Oct 2024 12:03:16 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by oym-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id 51C4AD5302
	for <nvdimm@lists.linux.dev>; Wed, 16 Oct 2024 12:03:15 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id D6AA940A57
	for <nvdimm@lists.linux.dev>; Wed, 16 Oct 2024 12:03:14 +0900 (JST)
Received: from iaas-rdma.. (unknown [10.167.135.44])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 4A8EA1A000B;
	Wed, 16 Oct 2024 11:03:14 +0800 (CST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH] test/monitor.sh: Fix 2 bash syntax errors
Date: Wed, 16 Oct 2024 11:03:58 +0800
Message-ID: <20241016030358.983042-1-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28734.004
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28734.004
X-TMASE-Result: 10--1.652000-10.000000
X-TMASE-MatchedRID: x/N1Pl+vn8bCS1NeCvs3qIdlc1JaOB1TqMXw4YFVmwiWMZBmiy+fzzl3
	2fTh8s1mPs0ZDS8itpdeWwXKQGp3JC7SL1WWCs3qEXjPIvKd74BMkOX0UoduuZXP+fN7LWAf/sv
	dVly7w9nhfIRFx1/VL/vQCPiy8IEcHxPMjOKY7A+u65UDD0aDgsRB0bsfrpPIcSqbxBgG0w5ayq
	C8OLb67mqAt5Et9doFroSY4RRy04jMEQ14+GxXQPRAIX3uQWntyeuDUOSOxiIO1pEmt7SpDq84h
	lON7yhVCyemwOQVRipbjBuldNvkMkoq97WSHdFjfupJaud1uZCfRs6uIbkFVw==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

$ grep -w line build/meson-logs/testlog.txt
test/monitor.sh: line 99: [: too many arguments
test/monitor.sh: line 99: [: nmem0: binary operator expected
test/monitor.sh: line 149: 40.0: syntax error: invalid arithmetic operator (error token is ".0")

- monitor_dimms could be a string with multiple *spaces*, like: "nmem0 nmem1 nmem2"
- inject_value is a float value, like 40.0, need to convert to integer.

Some features have not been really verified due to these errors

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 test/monitor.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/test/monitor.sh b/test/monitor.sh
index c5beb2c..544e57b 100755
--- a/test/monitor.sh
+++ b/test/monitor.sh
@@ -96,7 +96,7 @@ test_filter_region()
 	while [ $i -lt $count ]; do
 		monitor_region=$($NDCTL list -R -b $smart_supported_bus | jq -r .[$i].dev)
 		monitor_dimms=$(get_monitor_dimm "-r $monitor_region")
-		[ ! -z $monitor_dimms ] && break
+		[ ! -z "$monitor_dimms" ] && break
 		i=$((i + 1))
 	done
 	start_monitor "-r $monitor_region"
@@ -147,6 +147,7 @@ test_filter_dimmevent()
 
 	inject_value=$($NDCTL list -H -d $monitor_dimms | jq -r .[]."health"."temperature_threshold")
 	inject_value=$((inject_value + 1))
+	inject_value=${inject_value%.*}
 	start_monitor "-d $monitor_dimms -D dimm-media-temperature"
 	inject_smart "-m $inject_value"
 	check_result "$monitor_dimms"
-- 
2.44.0

