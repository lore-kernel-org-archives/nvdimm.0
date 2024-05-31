Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58452D7B8
	for <nvdimm@lists.linux.dev>; Fri, 31 May 2024 06:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717137021; cv=none; b=lRcDbLjtiS/Zaa2qJml756FSt+dlLMXCUcCjU/z7wha4TXX7tFP7JoAcEA/pagIdT15y/AQKSlIqpiVIpTi98Vi20mvT4ZHPl7772EW5jf6LTcGIlcni7LNnWSDLvSs9BLTbTxUw59SMi73N6vNr6LP04e+YFy2liG3l27PbWYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717137021; c=relaxed/simple;
	bh=iLJEIxVeTZ+1G/KbkNITGWV5+C/+pptGIjjsrmHWuB0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iSlco3DyuZwqQZb8hliYNVN7fOeH1rB22a3YXCf4Lv+el4vw1pqbD2ks+HXq0SKtXPFTyXDAfOw7vDR+a8qLY5mUy6e52g8raaGH+EQTVx8RuSl60N2LaYYfEBxgkVywE7XfObRhByB7uY2CRVArzpzZfVg+c4JkrzLPb7ukqy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=BHIpDbIG; arc=none smtp.client-ip=68.232.139.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="BHIpDbIG"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1717137019; x=1748673019;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iLJEIxVeTZ+1G/KbkNITGWV5+C/+pptGIjjsrmHWuB0=;
  b=BHIpDbIG+VlEVi0MOxWjyiokOTPTkrkLxqx4tWlxHIZJsJrk1+PEgi4j
   hXeePhMEmTXpeF4AbBx0ur/qJlQGzswNnSMi6Qnk6xA5KEzpijXxfVDre
   1p71PksLM/py+AaSvn05GZW59KIX8Q5UUjbjhITCiVIkey9CWfXrS4ICr
   Dd5tiJQPfL7n6UwYcermA5ZtGq6J0ijvC4hlk2tuBC4aKluVxVwrnc9EA
   MjeTef04Uv9qHuKp+2IXmWkVZbNLGkP8DdQCnJLOcLz+thz02ny0k+hXT
   9el/2RYOGT15kzr/Edgj6DeiZzgZVYRYQng1bOEN+ucb2qQMplwLGJQZ2
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="160185612"
X-IronPort-AV: E=Sophos;i="6.08,203,1712588400"; 
   d="scan'208";a="160185612"
Received: from unknown (HELO yto-r1.gw.nic.fujitsu.com) ([218.44.52.217])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 15:30:10 +0900
Received: from yto-m1.gw.nic.fujitsu.com (yto-nat-yto-m1.gw.nic.fujitsu.com [192.168.83.64])
	by yto-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id 7EAD8DBCF3
	for <nvdimm@lists.linux.dev>; Fri, 31 May 2024 15:30:08 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by yto-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id AADE2CFA5C
	for <nvdimm@lists.linux.dev>; Fri, 31 May 2024 15:30:07 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id 3B3A220094AE0
	for <nvdimm@lists.linux.dev>; Fri, 31 May 2024 15:30:07 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 67DFB1A000A;
	Fri, 31 May 2024 14:30:06 +0800 (CST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Li Zhijian <lizhijian@fujitsu.com>,
	Fan Ni <fan.ni@samsung.com>
Subject: [ndctl PATCH v2 1/2] daxctl: Fix create-device parameters parsing
Date: Fri, 31 May 2024 14:29:58 +0800
Message-Id: <20240531062959.881772-1-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28420.005
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28420.005
X-TMASE-Result: 10--6.622300-10.000000
X-TMASE-MatchedRID: 2FW4hmrwT1x6aArAc+gIexFbgtHjUWLyjlRp8uau9oYrGdGOV/v5a338
	DhskX88zh6y6sVpgqH1BCdSPDWIImy/7QU2czuUNEhGH3CRdKUX5UnqVnIHSz3Kidlm+PMQk2c5
	16rvzqru1cNZAaGmKfhsK4Gmn0aQ5NtwF1IC9LrV2o0eWLPgBZ3EJxqEF0kDO31GU/N5W5BDmn1
	MY2amWUWsRPSp/FWsq7Gwv1cOg4ZMfE8yM4pjsDwtuKBGekqUpI/NGWt0UYPAWEy2WCnvw5FISD
	qSv2ueapXz6cJSyyW3qGTW8xB7wNWEoVHihj+TK
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Previously, the extra parameters will be ignored quietly, which is a bit
weird and confusing.
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
---
V2:
Remove the external link[0] in case it get disappeared in the future.
[0] https://github.com/moking/moking.github.io/wiki/cxl%E2%80%90test%E2%80%90tool:-A-tool-to-ease-CXL-test-with-QEMU-setup%E2%80%90%E2%80%90Using-DCD-test-as-an-example#convert-dcd-memory-to-system-ram
---
 daxctl/device.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/daxctl/device.c b/daxctl/device.c
index 839134301409..ffabd6cf5707 100644
--- a/daxctl/device.c
+++ b/daxctl/device.c
@@ -363,7 +363,8 @@ static const char *parse_device_options(int argc, const char **argv,
 		NULL
 	};
 	unsigned long long units = 1;
-	int i, rc = 0;
+	int rc = 0;
+	int i = action == ACTION_CREATE ? 0 : 1;
 	char *device = NULL;
 
 	argc = parse_options(argc, argv, options, u, 0);
@@ -402,7 +403,7 @@ static const char *parse_device_options(int argc, const char **argv,
 			action_string);
 		rc = -EINVAL;
 	}
-	for (i = 1; i < argc; i++) {
+	for (; i < argc; i++) {
 		fprintf(stderr, "unknown extra parameter \"%s\"\n", argv[i]);
 		rc = -EINVAL;
 	}
-- 
2.29.2

