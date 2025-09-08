Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0A72EDD64
	for <nvdimm@lists.linux.dev>; Mon,  8 Sep 2025 12:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757334868; cv=none; b=TvHNJeh2UQNvJn0ozQxcrvuNkwiGtWbWteQ+xM56j/BUMBiq5GoQeUfp/TZC+YPVnIJIn3TVLTU15a32dDhJAyr0LykUfRAMIkU3wzoRoZXvC5Ov5VIkkzP7KQMmNlTzIFm2trUAOeKpnAGaS/WHfC1aL4ydQFUe2dGOIRhKuEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757334868; c=relaxed/simple;
	bh=XIIzZzslMJ2iD0U7qq+AYISp6T9//dbYYl2DW9E/cAI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EFEUnh3P2jkhdlpbRPTzrDiwnkcRI/ar6z9S14S2ha9JGZs0OSljTcYgzqw4t60XvueHdFW/KgvhHOGPbwuHXfpDj2qMIwN2ZG9wDn1FyXgm7r71eyrLKn0OKQcJ/5k5AfpK1sY424zzieEAHzPXR4sNzISgorQer5okeT4DIL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cL5w85KQbztTjG;
	Mon,  8 Sep 2025 20:33:28 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 3BF3A1402CC;
	Mon,  8 Sep 2025 20:34:24 +0800 (CST)
Received: from kwepemq500007.china.huawei.com (7.202.195.21) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 8 Sep 2025 20:34:24 +0800
Received: from huawei.com (10.67.174.117) by kwepemq500007.china.huawei.com
 (7.202.195.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 8 Sep
 2025 20:34:23 +0800
From: Lin Yujun <linyujun809@h-partners.com>
To: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>, <linyujun809@h-partners.com>,
	<santosh@fossix.org>
CC: <nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] ndtest: Fix incorrect handling for return value of device_create_with_groups.
Date: Mon, 8 Sep 2025 20:23:31 +0800
Message-ID: <20250908122331.1315530-1-linyujun809@h-partners.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500007.china.huawei.com (7.202.195.21)

The return value of device_create_with_groups will not
be an null pointer, use IS_ERR() to fix incorrect handling
return value of device_create_with_groups.

Fixes: 9399ab61ad82 ("ndtest: Add dimms to the two buses")
Signed-off-by: Lin Yujun <linyujun809@h-partners.com>
---
 tools/testing/nvdimm/test/ndtest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
index 68a064ce598c..7d722f2f7d62 100644
--- a/tools/testing/nvdimm/test/ndtest.c
+++ b/tools/testing/nvdimm/test/ndtest.c
@@ -745,11 +745,11 @@ static int ndtest_dimm_register(struct ndtest_priv *priv,
 
 	dimm->dev = device_create_with_groups(&ndtest_dimm_class,
 					     &priv->pdev.dev,
 					     0, dimm, dimm_attribute_groups,
 					     "test_dimm%d", id);
-	if (!dimm->dev) {
+	if (IS_ERR(dimm->dev)) {
 		pr_err("Could not create dimm device attributes\n");
 		return -ENOMEM;
 	}
 
 	return 0;
-- 
2.34.1

