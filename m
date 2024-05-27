Received: from esa8.hc1455-7.c3s2.iphmx.com (esa8.hc1455-7.c3s2.iphmx.com [139.138.61.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBB317BA9
	for <nvdimm@lists.linux.dev>; Mon, 27 May 2024 06:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.61.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716792426; cv=none; b=Y8Clu1BL3UKTykzkL7YLfngWu2lFneSfSUe4XeBS22wVwM//0JeGFKuj+L7tqHj2CzIlR5e2kB2AzcMEjV/NRJx3GNRaTkB+tHqASzZWSCG9JJe0/eAA32fagvnFJJfnJryWIbAZk875wzgEvQuYz2nmMhsfEJHI/2qOvnZvhIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716792426; c=relaxed/simple;
	bh=bdUw/+pxGWn6VpzszcP5+rE2zaaTYowILkv+vtGKLbU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=N3pjlgBRudOxm64+efIPmnCVDVx5JcsaukcLL1vijofxZsiKfRlmq+V2mRejhChRY5PsCSiostqPW/VpRUl/RG237czV9Q9+NEb+UG5EG/K+EmAv5W7QnEcH5w+5m9FM9fDy/3sQXKYpZOlQw0b3WcXU5jaBI8NmYEtOiDdlfnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=P4j+syZm; arc=none smtp.client-ip=139.138.61.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="P4j+syZm"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1716792424; x=1748328424;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bdUw/+pxGWn6VpzszcP5+rE2zaaTYowILkv+vtGKLbU=;
  b=P4j+syZmEWFBsd2XlQOsvvMBKkF9hAlt7eVgUPEvlPSpIG4l0X10uMbH
   ZvjmIty9ZrXlS27IlDmkyY+6yhmVx/19gPWXb+RpEmHASV2YH+yxWkSnr
   L93nKu+U3Z8D3Oe7QEoLMychquZDu6kkEX6O/2bgieEQ+1Ij5HPA3wwE0
   n4bFJW/afNbxPc/kDcQrTtO5i4hGf0d13LIAr4MiKt4r7HtBIP3QdGRJ1
   GUPm0gqbfUeroFtkWb+scfPhOS9PT6KcjwfAq/eZ7Gkg215IlUcnEzVSg
   WpvHHHm+gFtoseWSZRJu3kwSLNZPMue6wiX4xuvHDLmz+m0GfESQZQ835
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11084"; a="148392552"
X-IronPort-AV: E=Sophos;i="6.08,191,1712588400"; 
   d="scan'208";a="148392552"
Received: from unknown (HELO oym-r2.gw.nic.fujitsu.com) ([210.162.30.90])
  by esa8.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2024 15:45:52 +0900
Received: from oym-m4.gw.nic.fujitsu.com (oym-nat-oym-m4.gw.nic.fujitsu.com [192.168.87.61])
	by oym-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id 04232D424E
	for <nvdimm@lists.linux.dev>; Mon, 27 May 2024 15:45:51 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by oym-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id 39C7AD5319
	for <nvdimm@lists.linux.dev>; Mon, 27 May 2024 15:45:50 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id BCA5F200877BB
	for <nvdimm@lists.linux.dev>; Mon, 27 May 2024 15:45:49 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 2C8951A000A;
	Mon, 27 May 2024 14:45:49 +0800 (CST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Li Zhijian <lizhijian@fujitsu.com>,
	Fan Ni <fan.ni@samsung.com>
Subject: [ndctl PATCH 1/2] daxctl: Fix create-device parameters parsing
Date: Mon, 27 May 2024 14:45:38 +0800
Message-Id: <20240527064539.819487-1-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28412.005
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28412.005
X-TMASE-Result: 10--6.845500-10.000000
X-TMASE-MatchedRID: Eprm7pA/VZ56aArAc+gIexFbgtHjUWLyjlRp8uau9oYrGdGOV/v5a338
	DhskX88zh6y6sVpgqH1BCdSPDWIImy/7QU2czuUNnVTWWiNp+v9y4VFP6muDhlFexdJHJX6CxBr
	X76geXlQNSHV1uiGbXqGCpFd/1kOasEBAuoaUqK9KzjuZtPtIBH607foZgOWyNY1fmgSVSVWjxY
	yRBa/qJXcsDK2xBHh7jaPj0W1qn0Q7AFczfjr/7LJkK1neENRzxjphkvwGSk/LlI3DYJpWSvG59
	X/ZQeFMAQs4Mp06gUs=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Previously, the extra parameters will be ignored quietly, which is a bit
weird and confusing.
[0] $ daxctl create-device region0
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

[0] https://github.com/moking/moking.github.io/wiki/cxl%E2%80%90test%E2%80%90tool:-A-tool-to-ease-CXL-test-with-QEMU-setup%E2%80%90%E2%80%90Using-DCD-test-as-an-example#convert-dcd-memory-to-system-ram

Cc: Fan Ni <fan.ni@samsung.com>
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
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

