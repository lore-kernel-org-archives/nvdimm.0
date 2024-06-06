Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0327319D8B9
	for <nvdimm@lists.linux.dev>; Thu,  6 Jun 2024 03:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717645930; cv=none; b=cPkdealOERJzjvvqS/R9gFRLOoFFJxuA1qsOh5Ijab+M2YFrYnwl7b9Ne6Ouda3+MiXUApwVw3Y7pWnIlnngNcibHJXF4Z2aBGSTpwaAE34OOZH5U4Pjfp2nshRGJ2Is2HCpFehs0Bk4RB7NuS9SLlUP5b5IfYKf7KFIcJqHEVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717645930; c=relaxed/simple;
	bh=hqdmokjTIO4MUs6Fhm4Qm6/CsaKSesyP+zgp2Iw9hS0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ctpra14dTrld5vetB+jpwyh9CgQtMZeQ2sA6QqFEBAhlb3dKfF+8WHwwWwex5/+s2SdGWuiZWKAuYi8wjFML6tuLEp3UO1klxWX7uwKF2irNNTEdNwzFfyFDMLXCvT9Di8U2TqIdQnqGWh+KMOkaHWULodb883wpAB3Wj8Xqmb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=YAEZeoz+; arc=none smtp.client-ip=68.232.139.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="YAEZeoz+"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1717645928; x=1749181928;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hqdmokjTIO4MUs6Fhm4Qm6/CsaKSesyP+zgp2Iw9hS0=;
  b=YAEZeoz+Of2P3bRmGeGVPOd+lK3lVuw/S4z1dniaibAAT7F3Ibr2r453
   4L6GLXN6uVNWtsQzcwU+9O87SP3S7fSLVTpkBs9S7o1RVedcaqAEiX/KY
   nurF2nWBgr5wyRWZBJJLOmEQwmDr3k6SdUWkV9LQcrIk3I1Wj1BbRsvQ8
   c3djeAz7pr4JTqHjLjrvlb++6e6UWMBGISkNMYVJgwd2Z1u6spRmBsjB+
   cSEikIWOQWvne5snrUqZPboyPc0Jvkm3jfQQV/u1VqI1H3eDZLJQqDH8u
   AN3ccB36GLOb1neqU1Z4w1Xv3XczX6NpCrM6rhqhbhZA6/+2IO967dtD0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11094"; a="161345773"
X-IronPort-AV: E=Sophos;i="6.08,218,1712588400"; 
   d="scan'208";a="161345773"
Received: from unknown (HELO oym-r1.gw.nic.fujitsu.com) ([210.162.30.89])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 12:52:00 +0900
Received: from oym-m3.gw.nic.fujitsu.com (oym-nat-oym-m3.gw.nic.fujitsu.com [192.168.87.60])
	by oym-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id D130CD29E1
	for <nvdimm@lists.linux.dev>; Thu,  6 Jun 2024 12:51:57 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by oym-m3.gw.nic.fujitsu.com (Postfix) with ESMTP id 21588D7465
	for <nvdimm@lists.linux.dev>; Thu,  6 Jun 2024 12:51:57 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id 9B2C6E2B15
	for <nvdimm@lists.linux.dev>; Thu,  6 Jun 2024 12:51:56 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id A265F1A000A;
	Thu,  6 Jun 2024 11:51:55 +0800 (CST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Li Zhijian <lizhijian@fujitsu.com>,
	Fan Ni <fan.ni@samsung.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v3 1/2] daxctl: Fail create-device if extra parameters are present
Date: Thu,  6 Jun 2024 11:51:48 +0800
Message-Id: <20240606035149.1030610-1-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
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
X-TMASE-Result: 10--8.969300-10.000000
X-TMASE-MatchedRID: kr2EN9r3yrhQdboikf/uEBFbgtHjUWLyMrX+p1uNztBJEjJjpEhCn+Af
	SNitoKTvgcDogF3e9CwXWBETjFf6a8OiXRC56ox3KiJEqUFWRggEa8g1x8eqF3hh5KUdlgWipie
	YwslGH4lQHH8z5x0cCG9QOoI2Wy8o6k5u/mZf6RWdVNZaI2n6/3LhUU/qa4OGUV7F0kclfoLEGt
	fvqB5eVA1IdXW6IZteoYKkV3/WQ5qwQEC6hpSor3V7tdtvoibaQRPK6viU2M6bKItl61J/yZ+in
	TK0bC9eKrauXd3MZDUCbdlAfAbarhe7A+M+eX8rLGmfJoFGZYIEDgbVZ+wG+GE15In5LtBA
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Previously, an incorrect index(1) for create-device is causing the 1st
extra parameter to be ignored, which is wrong. For example:
$ daxctl create-device region0
[
  {
    "chardev":"dax0.1",
    "size":268435456,
    "target_node":1,
    "align":2097152,
    "mode":"devdax"
  }
]
created 1 device

where above user would want to specify '-r region0'.

Check extra parameters starting from index 0 to ensure no extra parameters
are specified for create-device.

Cc: Fan Ni <fan.ni@samsung.com>
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
V3:
  - Fix commit message and move the 'i' setting near the usage # Alison
  - collect reviewed tags, no logical changes.

V2:
Remove the external link[0] in case it get disappeared in the future.
[0] https://github.com/moking/moking.github.io/wiki/cxl%E2%80%90test%E2%80%90tool:-A-tool-to-ease-CXL-test-with-QEMU-setup%E2%80%90%E2%80%90Using-DCD-test-as-an-example#convert-dcd-memory-to-system-ram
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 daxctl/device.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/daxctl/device.c b/daxctl/device.c
index 839134301409..6ea91eb45315 100644
--- a/daxctl/device.c
+++ b/daxctl/device.c
@@ -402,7 +402,10 @@ static const char *parse_device_options(int argc, const char **argv,
 			action_string);
 		rc = -EINVAL;
 	}
-	for (i = 1; i < argc; i++) {
+
+	/* ACTION_CREATE expects 0 parameters */
+	i = action == ACTION_CREATE ? 0 : 1;
+	for (; i < argc; i++) {
 		fprintf(stderr, "unknown extra parameter \"%s\"\n", argv[i]);
 		rc = -EINVAL;
 	}
-- 
2.29.2

