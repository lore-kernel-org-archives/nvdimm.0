Received: from esa4.hc1455-7.c3s2.iphmx.com (esa4.hc1455-7.c3s2.iphmx.com [68.232.139.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9350219D8B9
	for <nvdimm@lists.linux.dev>; Thu,  6 Jun 2024 03:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717645993; cv=none; b=CPzGJO1PQ86UnTq7eG3z7X5Roe1EmIp28tif5xC7VoOKwQKa2e3no8isQFD9wp6ptlOQmv0QJByUPi2wo/ACeHIL+VmNSxoefOhHqp3B+o+WgfPIb09PncJZDz4X3XZn+Fdf5A0YbAlrbsLZGBvJ1S4ZDsoMJxhpKQFEt+6KWxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717645993; c=relaxed/simple;
	bh=pfwN24pMokjgAHOp1BB69eIt/t2Yel77P+50tad7Y+A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eT2tMxIMovFituDKpKcGJAnP6Dh0pW8XDo+IS3B+Pq5Z/r7BjF9E8fmOBAlbtAjvRi3BVCHTUvCwmgAyFsWBHbc2XaQVEy2pARN5hQXWbjIZ/WKI1eTnQbtnTmG74rEAweGz5VVFwHhxW5vFVV0cS3r0qafmhiZ0Arq0BOqCXvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=I8JcKBeG; arc=none smtp.client-ip=68.232.139.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="I8JcKBeG"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1717645991; x=1749181991;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pfwN24pMokjgAHOp1BB69eIt/t2Yel77P+50tad7Y+A=;
  b=I8JcKBeGHN0AaX5uwQLhkgJIWPVjf+dhCPxVSLwkr7bUd5xB/jnmnLeH
   FxSffY4ks4HuAhH5uhc/rBlAu0jA83qj2g4JHfDvUJMYsWzD2ALerpGg4
   0hsj+c4qydRBZ2W3Wzz1RDGa8E9xLvz/8upnbxL69bTf5wd8EBQmhKL8a
   v4xfnxk797jrIiwZX9OUOy2ZmvrUJQnodiHAoslO3qdKsA3j3xZs5H2XS
   Rnarzmcn++YMb9iSaNBiIeS0ROkqS6YSktzoAzjQh5OkpvsvQhPEm06WT
   iSVvnVcy2ic+69LwjU5CeAZYgxYkoQsSMhTavlgnI46OHyn4x/koxlUwJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11094"; a="162228236"
X-IronPort-AV: E=Sophos;i="6.08,218,1712588400"; 
   d="scan'208";a="162228236"
Received: from unknown (HELO oym-r2.gw.nic.fujitsu.com) ([210.162.30.90])
  by esa4.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 12:52:00 +0900
Received: from oym-m2.gw.nic.fujitsu.com (oym-nat-oym-m2.gw.nic.fujitsu.com [192.168.87.59])
	by oym-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id 23F9CD7AD6
	for <nvdimm@lists.linux.dev>; Thu,  6 Jun 2024 12:51:58 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by oym-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id 69709BF3EF
	for <nvdimm@lists.linux.dev>; Thu,  6 Jun 2024 12:51:57 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id F02B8E2B25
	for <nvdimm@lists.linux.dev>; Thu,  6 Jun 2024 12:51:56 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 7424E1A000C;
	Thu,  6 Jun 2024 11:51:56 +0800 (CST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Li Zhijian <lizhijian@fujitsu.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v3 2/2] daxctl: Remove unused options in create-device usage message
Date: Thu,  6 Jun 2024 11:51:49 +0800
Message-Id: <20240606035149.1030610-2-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240606035149.1030610-1-lizhijian@fujitsu.com>
References: <20240606035149.1030610-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28434.004
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28434.004
X-TMASE-Result: 10-2.789500-10.000000
X-TMASE-MatchedRID: D7uj3L7FQ3IZHQl0dvECsQvBTB90+he+MVx/3ZYby78lTfGXXk+l8879
	PlJmAmXDoKHWBVnoJHPmn3xyPJAJoh2P280ZiGmROWUWxTQJdI8mLcCO64Exkpsoi2XrUn/J8m+
	hzBStansUGm4zriL0oQtuKBGekqUpnH7sbImOEBRFzth5Inra65DPQ/OWjuSi09eMkkde1DbbJi
	uAbwHBJyPzf07AeiJ8Q1mBwk8ucWczUbs4+5aCjfBsDwidnGiRczTonAH5/C2bDRBqS2n66yzP5
	xAyz9Oenvkw4sh/+PcMX5CwH5DTUmgGZNLBHGNe
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

RECONFIG_OPTIONS and ZONE_OPTIONS are not implemented for create-device
and they will be ignored by create-device. Remove them so that the usage
message is identical to the manual.

Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
V3:
  Collect reviewed-by tags.
  update subject # Aliso

V2: make the usage match the manual because the usage is wrong.
---
 daxctl/device.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/daxctl/device.c b/daxctl/device.c
index 6ea91eb45315..dc166d593336 100644
--- a/daxctl/device.c
+++ b/daxctl/device.c
@@ -98,8 +98,6 @@ OPT_BOOLEAN('\0', "no-movable", &param.no_movable, \
 static const struct option create_options[] = {
 	BASE_OPTIONS(),
 	CREATE_OPTIONS(),
-	RECONFIG_OPTIONS(),
-	ZONE_OPTIONS(),
 	OPT_END(),
 };
 
-- 
2.29.2

