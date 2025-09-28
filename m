Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4941B4F08
	for <nvdimm@lists.linux.dev>; Sun, 28 Sep 2025 01:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759023091; cv=none; b=f0ZbmlNMOGT9+4A+srSBcYRWB/Bu05+r2KlC+ztKAqkpNdP2+DouR67Wb4tvVVwX56cAGmbsx6BQno4rxdZxpeYzDUm9uhm0ig4zFRrhu96LsX2FIR6lnzMP5EvL+VWXRIL477QrsP3kJOL8a/DKZwlR7HJa9SHByXE5wVPDyB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759023091; c=relaxed/simple;
	bh=wiVx8Eh8sdquqL75jnMJSQvFD99gEpPAxNZxBJFxFfo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mVm+GBnF25jNduT5B7aFQiEPN7CDZlIW7975OSt4gq35uzR2nmyGHuB/1SfBRyWfAel/TH56+84/WqIEBYchDLO2zE4kvdf6uL4UdN7xUT+Y62JfUdFJOKO3mHi/ZIxdvC9qB3329VtMtaxIbJ7grrqm+RFmd7ZeFsEqg6+pmWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=KyMn1NVo; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="KyMn1NVo"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1759023080; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=w7qIFaXWsgPPDvlUWsVnBfr1Mt30/fBDJ089QcbsNk0=;
	b=KyMn1NVob53PHvdH9xmbAQUv2CMeTclP64oS5h1DIFjcQkHSScST6wz/mcchJl1aa3mJ6jSA9JF0MRhL5tULt5ZWk6jnV3b+Y3SPshS70uTFgJR3MeEN5NbE84fAezwtHBJfIPGsL7H3VrqijyYy81pWagErTn2TTCZIq0t6eYI=
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0WowaYS9_1759023071 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 28 Sep 2025 09:31:19 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: dan.j.williams@intel.com
Cc: vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] nvdimm: Remove duplicate linux/slab.h header
Date: Sun, 28 Sep 2025 09:31:10 +0800
Message-ID: <20250928013110.1452090-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

./drivers/nvdimm/bus.c: linux/slab.h is included more than once.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=25516
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/nvdimm/bus.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index ad3a0493f474..87178a53ff9c 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -13,7 +13,6 @@
 #include <linux/async.h>
 #include <linux/ndctl.h>
 #include <linux/sched.h>
-#include <linux/slab.h>
 #include <linux/cpu.h>
 #include <linux/fs.h>
 #include <linux/io.h>
-- 
2.43.5

