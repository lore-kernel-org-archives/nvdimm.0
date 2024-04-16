Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2802F5A0F9
	for <nvdimm@lists.linux.dev>; Tue, 16 Apr 2024 21:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713304019; cv=none; b=L0b1vzKncsOnBSb7nyKXNZJTInt1ShOrujoowvtdfKBbjSi3ZdILlVFjjKKKL1ckgcmV7v5tS1DxDL4ltEbTKB1mVOg7oq56tq2MCL58QCYlBe4mnp8HC+pGytFPM9cctqRTVrXhsKxJkHpsSz+H0zHfwstfcuPJhuO7RFmiWtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713304019; c=relaxed/simple;
	bh=6NKueYWbYilwLzm6MjvNGh3MReMQfTip+ZRQnpWHoXo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Aze6n2adZfYDQCy8UY+2St+mkV8WnbycwhgA046dRu86zBLHxOVSgLudclxVnYUwEwxaRJaNB3vA/9jYWbqDmRZukCBUSJHTEzoUQYVw+HaihZ1Y9xjJIOEwg16j9JeNnEqivwR7u5kEarL/7CbZJiynh8Lpa1zMgi28LfdI6sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PtaaT1K1; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PtaaT1K1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713304018; x=1744840018;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=6NKueYWbYilwLzm6MjvNGh3MReMQfTip+ZRQnpWHoXo=;
  b=PtaaT1K1jfAriL6p57wGLjyljKgJfGwPfq76hub6wUU/erPoUPBsbo15
   fupCiiLwOYOQ9x8zadet7c4uUJcUKEeCJ8+kvkhHbwEC/MYdFdvEwfMOC
   05KN0LQKG9xuKS45S5y/LeCX846QPpkPjcl8xazqZ9qqACANK4uZpCSUk
   AhI49ld78SjjBkNoFjI6sEd1DH0fH+HnyQMlIDDHWEYuvtoJPSf1zV5A0
   MoEMXdgEprPLbh19InJ81qlHzH5FGDAcuNm/PknjcVD/XJuux/DfVq1ac
   jwUZnEO+3vgjK4Vb9CGM3zdJm9YNtCuq2z/pbdNbr1P+xxlbxtJ6V7qsz
   w==;
X-CSE-ConnectionGUID: NHGzGzhzRuygpVZYjk8L8g==
X-CSE-MsgGUID: QBMth8NBTjeqgfEcdqAiug==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="12553095"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="12553095"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:46:41 -0700
X-CSE-ConnectionGUID: LGzV/oikTnWcdEcJ9oelEA==
X-CSE-MsgGUID: /IHr+JCsTxqXKXpgmhSDhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22464247"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.212.14.216])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:46:41 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 16 Apr 2024 15:46:17 -0600
Subject: [PATCH v2 2/4] dax/bus.c: fix locking for unregister_dax_dev /
 unregister_dax_mapping paths
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240416-vv-dax_abi_fixes-v2-2-d5f0c8ec162e@intel.com>
References: <20240416-vv-dax_abi_fixes-v2-0-d5f0c8ec162e@intel.com>
In-Reply-To: <20240416-vv-dax_abi_fixes-v2-0-d5f0c8ec162e@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.14-dev-5ce50
X-Developer-Signature: v=1; a=openpgp-sha256; l=3520;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=6NKueYWbYilwLzm6MjvNGh3MReMQfTip+ZRQnpWHoXo=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDGlyH/enyV98tmMC+0yHnLWTp0uWbraz8j0qZn/esdHYy
 npx0zWzjlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAEzEbCMjQ8PDvw4XrybZf125
 7XfaN/P1v1b6h32zlnnH4MHleGTHmVkM/7TzZp0N61T7+uvK3aknHi353rLU68rbOyWTCucncRQ
 uvskJAA==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Commit c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
was a bit overzealous in eliminating device_lock() usage, and ended up
removing a couple of lock acquisitions which were needed, and as a
result, fix some of the conditional locking missteps that the above
commit introduced in unregister_dax_dev() and unregister_dax_mapping().

Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
Reported-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/dax/bus.c | 44 ++++++++++----------------------------------
 1 file changed, 10 insertions(+), 34 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 7924dd542a13..4e04b228b080 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -465,26 +465,17 @@ static void free_dev_dax_ranges(struct dev_dax *dev_dax)
 		trim_dev_dax_range(dev_dax);
 }
 
-static void __unregister_dev_dax(void *dev)
+static void unregister_dev_dax(void *dev)
 {
 	struct dev_dax *dev_dax = to_dev_dax(dev);
 
 	dev_dbg(dev, "%s\n", __func__);
 
+	down_write(&dax_region_rwsem);
 	kill_dev_dax(dev_dax);
 	device_del(dev);
 	free_dev_dax_ranges(dev_dax);
 	put_device(dev);
-}
-
-static void unregister_dev_dax(void *dev)
-{
-	if (rwsem_is_locked(&dax_region_rwsem))
-		return __unregister_dev_dax(dev);
-
-	if (WARN_ON_ONCE(down_write_killable(&dax_region_rwsem) != 0))
-		return;
-	__unregister_dev_dax(dev);
 	up_write(&dax_region_rwsem);
 }
 
@@ -560,15 +551,12 @@ static ssize_t delete_store(struct device *dev, struct device_attribute *attr,
 	if (!victim)
 		return -ENXIO;
 
-	rc = down_write_killable(&dax_region_rwsem);
-	if (rc)
-		return rc;
-	rc = down_write_killable(&dax_dev_rwsem);
-	if (rc) {
-		up_write(&dax_region_rwsem);
-		return rc;
-	}
+	device_lock(dev);
+	device_lock(victim);
 	dev_dax = to_dev_dax(victim);
+	rc = down_write_killable(&dax_dev_rwsem);
+	if (rc)
+		return rc;
 	if (victim->driver || dev_dax_size(dev_dax))
 		rc = -EBUSY;
 	else {
@@ -589,11 +577,12 @@ static ssize_t delete_store(struct device *dev, struct device_attribute *attr,
 			rc = -EBUSY;
 	}
 	up_write(&dax_dev_rwsem);
+	device_unlock(victim);
 
 	/* won the race to invalidate the device, clean it up */
 	if (do_del)
 		devm_release_action(dev, unregister_dev_dax, victim);
-	up_write(&dax_region_rwsem);
+	device_unlock(dev);
 	put_device(victim);
 
 	return rc;
@@ -705,7 +694,7 @@ static void dax_mapping_release(struct device *dev)
 	put_device(parent);
 }
 
-static void __unregister_dax_mapping(void *data)
+static void unregister_dax_mapping(void *data)
 {
 	struct device *dev = data;
 	struct dax_mapping *mapping = to_dax_mapping(dev);
@@ -713,25 +702,12 @@ static void __unregister_dax_mapping(void *data)
 
 	dev_dbg(dev, "%s\n", __func__);
 
-	lockdep_assert_held_write(&dax_region_rwsem);
-
 	dev_dax->ranges[mapping->range_id].mapping = NULL;
 	mapping->range_id = -1;
 
 	device_unregister(dev);
 }
 
-static void unregister_dax_mapping(void *data)
-{
-	if (rwsem_is_locked(&dax_region_rwsem))
-		return __unregister_dax_mapping(data);
-
-	if (WARN_ON_ONCE(down_write_killable(&dax_region_rwsem) != 0))
-		return;
-	__unregister_dax_mapping(data);
-	up_write(&dax_region_rwsem);
-}
-
 static struct dev_dax_range *get_dax_range(struct device *dev)
 {
 	struct dax_mapping *mapping = to_dax_mapping(dev);

-- 
2.44.0

