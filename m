Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062DE6E615
	for <nvdimm@lists.linux.dev>; Tue, 16 Apr 2024 21:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713304020; cv=none; b=M18rlT4uFpXG/YzxHpqEIj2nkyTD3G4vE8u2lKQjh3NihspYpN6DDDA5EMmDRxFkux9zVLeoXdEnn1hVsUGGcAACVhWa4bV6vaJKpdCOhhHz+xkb0TF/YvuDfYplWfzGxmqQhYy/ARI5z99XsxTyeFHy819jf0YjyLvr61jXhdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713304020; c=relaxed/simple;
	bh=psiSCf8lZOYgQBeohr4J/sdl0OC+/xsZnCHQ3I57Cyc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lmT5LvPxHEP7ov2qEmJzzFGjglEEn5NE5QssRb0wvVP+DdNRgE7+nnz++b6gy7Z4+T9XkUGsYDgw/+qvDKdKLhMnF+id8GShBuVsJaKhsqVVsp+T/dyofFYREHPSkqpGMz8oxatBnUOoSCctPfGj3eimuRYou+LS3p5pxbiGmkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OuXQsL5a; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OuXQsL5a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713304019; x=1744840019;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=psiSCf8lZOYgQBeohr4J/sdl0OC+/xsZnCHQ3I57Cyc=;
  b=OuXQsL5an0xCpfWqQ62JmBbHTRFzE0r0ho2d7zkxVK6BihaLMu5HuTRL
   7tg42XFT45tgAIZMO6OU9G5SWsiwA150pcwITqXBA6KRVkcGAT0REVP2u
   ltvLhfGqu8LTszccSBa1ziHmL45bzFTbp7x9EQLMNVgm+eA4M4BXysQBI
   U2y/1xFhvBezPZXZTRtJC4WLSF+jNaHNm0K8dDei3+GkWopWOqm4E7pMM
   ohWG94WWJqUt4X7o/Q4v/lRqBrrg/0xxaWIwCkG2sWQJCiyxaZC6KsXpM
   29aVbhQGGZx1ORKOjSD35pUWBHBRzKnwanPvHBJUx4j201P91QVdHHgcX
   A==;
X-CSE-ConnectionGUID: +Y+IsBbESluf42qQP9B8rA==
X-CSE-MsgGUID: pUiFf4Y1QjKVmRdm0GU4+w==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="12553104"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="12553104"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:46:42 -0700
X-CSE-ConnectionGUID: 07RsA2yoRfu9UMmVybWr+A==
X-CSE-MsgGUID: YivqiNc6SxGhJL2ATRp77A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22464263"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.212.14.216])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:46:42 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 16 Apr 2024 15:46:19 -0600
Subject: [PATCH v2 4/4] dax/bus.c: Use the right locking mode (read vs
 write) in size_show
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240416-vv-dax_abi_fixes-v2-4-d5f0c8ec162e@intel.com>
References: <20240416-vv-dax_abi_fixes-v2-0-d5f0c8ec162e@intel.com>
In-Reply-To: <20240416-vv-dax_abi_fixes-v2-0-d5f0c8ec162e@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.14-dev-5ce50
X-Developer-Signature: v=1; a=openpgp-sha256; l=980;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=psiSCf8lZOYgQBeohr4J/sdl0OC+/xsZnCHQ3I57Cyc=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDGlyH/cz7pX0cJ375bC3otT2ot7lH8M3hFf7VJ0Qrb998
 9M9TcEDHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZiI/DuGP3zLNh9X/5/4Jm55
 1eN3wkqiEVnBof/1RB6m3fG4t2fZKhuG/wlvHFblPBLLiJ75/QdXs/WBmVsZJzb/j1u505jhodO
 NTF4A
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

In size_show(), the dax_dev_rwsem only needs a read lock, but was
acquiring a write lock. Change it to down_read_interruptible() so it
doesn't unnecessarily hold a write lock.

Cc: Dan Williams <dan.j.williams@intel.com>
Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/dax/bus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index db183eb5ce3a..66095e60a279 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -939,11 +939,11 @@ static ssize_t size_show(struct device *dev,
 	unsigned long long size;
 	int rc;
 
-	rc = down_write_killable(&dax_dev_rwsem);
+	rc = down_read_interruptible(&dax_dev_rwsem);
 	if (rc)
 		return rc;
 	size = dev_dax_size(dev_dax);
-	up_write(&dax_dev_rwsem);
+	up_read(&dax_dev_rwsem);
 
 	return sysfs_emit(buf, "%llu\n", size);
 }

-- 
2.44.0

