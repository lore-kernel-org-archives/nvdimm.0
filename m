Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC446F2E3
	for <nvdimm@lists.linux.dev>; Tue,  3 Sep 2024 14:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725373841; cv=none; b=VRrFIcc/HJvQvUszdnbYHLOhoxz+jICxVHW8n7aoucCsXwskPj0o9VFD4o26dn5k36kRdkd0P64nYawd2GnEO1sQ8wS1lwkqdIQ4Q6ChWHE9Ocj1OWA//WBIfEqVdFx7gJd8qEMIiLKGb51Tz9ZxZVhoxhHDT/3H9IH/uaV/J+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725373841; c=relaxed/simple;
	bh=tSu+WCZ6bGxxA/P2Jhh5qVG+oF/8xvO/COA9gAP+Mr8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TyeaLc+L9BAbpyzkA9I8nLjgLiOaTsV87OgZX9EdkHzy+nWhBDfkMUrrLRtHykzcE+W3anRi2B1SCwboDUPCznFjkE00OeGhwRlWssFSsf9cAmXhWItc0z97Q4ZvO4YhGf/lJs2JlPF/8qv7TUO/hmt2Kblx9xG9du57yzBSKNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Wyp106bDyzyQws
	for <nvdimm@lists.linux.dev>; Tue,  3 Sep 2024 22:29:40 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (unknown [7.221.188.25])
	by mail.maildlp.com (Postfix) with ESMTPS id 7A2D61400CA
	for <nvdimm@lists.linux.dev>; Tue,  3 Sep 2024 22:30:37 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemd500012.china.huawei.com
 (7.221.188.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.34; Tue, 3 Sep
 2024 22:30:36 +0800
From: Li Zetao <lizetao1@huawei.com>
To: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>
CC: <lizetao1@huawei.com>, <nvdimm@lists.linux.dev>
Subject: [PATCH -next] nvdimm: Remove redundant null pointer checks
Date: Tue, 3 Sep 2024 22:39:11 +0800
Message-ID: <20240903143911.2005193-1-lizetao1@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemd500012.china.huawei.com (7.221.188.25)

Since the debugfs_create_dir() never returns a null pointer, checking
the return value for a null pointer is redundant, and using IS_ERR is
safe enough.

Signed-off-by: Li Zetao <lizetao1@huawei.com>
---
 drivers/nvdimm/btt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 423dcd190906..4592c86d5eac 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -227,7 +227,7 @@ static void arena_debugfs_init(struct arena_info *a, struct dentry *parent,
 
 	snprintf(dirname, 32, "arena%d", idx);
 	d = debugfs_create_dir(dirname, parent);
-	if (IS_ERR_OR_NULL(d))
+	if (IS_ERR(d))
 		return;
 	a->debugfs_dir = d;
 
@@ -1703,7 +1703,7 @@ static int __init nd_btt_init(void)
 	int rc = 0;
 
 	debugfs_root = debugfs_create_dir("btt", NULL);
-	if (IS_ERR_OR_NULL(debugfs_root))
+	if (IS_ERR(debugfs_root))
 		rc = -ENXIO;
 
 	return rc;
-- 
2.34.1

