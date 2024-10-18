Received: from esa2.hc1455-7.c3s2.iphmx.com (esa2.hc1455-7.c3s2.iphmx.com [207.54.90.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D7C5103F
	for <nvdimm@lists.linux.dev>; Fri, 18 Oct 2024 01:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729215055; cv=none; b=RtVHiyIsvmPOXenGHv6seHJz69RadK3qgzg3mIEi6SqOfaFUOLMPG3cf8E+6FfmniBf0ekopwH7Mr0NSqYk8TLJWVobTd5QSmj3yNv9XWEXz9nh/tHgRjaq6PSye8R5ytoO/W0PE9SfDZLkS90Y8EH8/CeRc8OgAZcFu490vais=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729215055; c=relaxed/simple;
	bh=+bBjc/9A+Ua5H7HXqJ8S16MXO9zhPZKhjHJsC2Pwv6k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mioh8r+w5u2cbt8QdQmMZDe7IgUgDoTx8ashro+XL0+JDQv2g+wBeZ/HknFZ+kBagRpqfZTPrAdipslqBu+pns0zL2pO2NjkxkswzC440Q3I8ztLoxuewQrRy6/GEu9VMu8DGscGRUbb2VR8kwfOZqL8wCiclHQkYHyLKJt8VPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=GfdyJg/8; arc=none smtp.client-ip=207.54.90.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="GfdyJg/8"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1729215054; x=1760751054;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+bBjc/9A+Ua5H7HXqJ8S16MXO9zhPZKhjHJsC2Pwv6k=;
  b=GfdyJg/8I9fvZxDYj5hxp0zA3+JnoQ+L81BuPEGi3UoiBPvvtAUML4yk
   9kvyHCpUm8KI2by+P0yovdJdZhGvkCZZB9C+thedR05DTAZTeFnNpfcYF
   8SXfSPeoSoL3YPSkl/kdVWZ4hYcQ9cDFZqPOBTmPAFvY7jkSNVl+hpCH6
   xjJUtD/R4FH0syc6ogA3CyxjkjR6RLUSb5pW08V42Mbv9ZtN8pkDZ+Frw
   Wy0Kp6Mt0h29nDaeWsfXZZZD5xGs7W1x0/A6HL0xdbCrnZoDnlGmznzu7
   RTRgQYx9sxBYM53e+4pKz4YUtWU7XuzEOBMGI0w/rizoOB/Oas30Nvvps
   Q==;
X-CSE-ConnectionGUID: UJzV/hc5TNyQxD3Bokc9Jg==
X-CSE-MsgGUID: +wGhB/zZRE2qtVHMAkEFGw==
X-IronPort-AV: E=McAfee;i="6700,10204,11228"; a="177181817"
X-IronPort-AV: E=Sophos;i="6.11,212,1725289200"; 
   d="scan'208";a="177181817"
Received: from unknown (HELO oym-r1.gw.nic.fujitsu.com) ([210.162.30.89])
  by esa2.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2024 10:29:43 +0900
Received: from oym-m3.gw.nic.fujitsu.com (oym-nat-oym-m3.gw.nic.fujitsu.com [192.168.87.60])
	by oym-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id 53C61CC14C
	for <nvdimm@lists.linux.dev>; Fri, 18 Oct 2024 10:29:40 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by oym-m3.gw.nic.fujitsu.com (Postfix) with ESMTP id 7EA6FD73A6
	for <nvdimm@lists.linux.dev>; Fri, 18 Oct 2024 10:29:39 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id 0D12220050186
	for <nvdimm@lists.linux.dev>; Fri, 18 Oct 2024 10:29:39 +0900 (JST)
Received: from iaas-rdma.. (unknown [10.167.135.44])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 811741A000B;
	Fri, 18 Oct 2024 09:29:38 +0800 (CST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH v3 1/2] test/monitor.sh convert float to integer before increment
Date: Fri, 18 Oct 2024 09:30:19 +0800
Message-ID: <20241018013020.2523845-1-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28738.003
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28738.003
X-TMASE-Result: 10--2.069100-10.000000
X-TMASE-MatchedRID: 3VvmmxedNeKHYSb76u64f1hRyidsElYkGEGBUNvh8GASkNsdBvOYg2Uo
	D5JLGXzAnC7F+qVaTtq9Q4CDyJILGS7SL1WWCs3qEXjPIvKd74BMkOX0UoduueyufIOcfWGpo8W
	MkQWv6iUoTQl7wNH8Pg1fA1QHegDv3QfwsVk0UbvqwGfCk7KUswyi9UGnfc1kmVyPCbGrMTNYtm
	ygm+pbSYfEC2MAyNF/GZ/CA/4y894kJ8AODzlrRdx2pRgSEDDgM0G0VS1whvBTK7SumpFvNiHJp
	2UYVccqxOB8J0pRLhyJxKSZiwBX6QtRTXOqKmFVftwZ3X11IV0=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

The test log reported:
test/monitor.sh: line 149: 40.0: syntax error: invalid arithmetic operator (error token is ".0")

It does stop the test prematurely. We never run the temperature
inject test case of test_filter_dimmevent() because of the inability
to increment the float.

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
V3:
  split as a separate patch
---
 test/monitor.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/test/monitor.sh b/test/monitor.sh
index c5beb2c..7049b36 100755
--- a/test/monitor.sh
+++ b/test/monitor.sh
@@ -146,6 +146,7 @@ test_filter_dimmevent()
 	stop_monitor
 
 	inject_value=$($NDCTL list -H -d $monitor_dimms | jq -r .[]."health"."temperature_threshold")
+	inject_value=${inject_value%.*}
 	inject_value=$((inject_value + 1))
 	start_monitor "-d $monitor_dimms -D dimm-media-temperature"
 	inject_smart "-m $inject_value"
-- 
2.44.0

