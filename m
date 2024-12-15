Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BC481E
	for <nvdimm@lists.linux.dev>; Sun, 15 Dec 2024 02:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734231517; cv=none; b=ebhc5Vag04zMzj2/Lqd8qXTrRv4sYoD8OJqqiJehHQyP1x59shYyr2SYBfzbkIwosq5uuekihyh3MSh6Tk9Yj9Xu3VObIL2gzWhOhReIbqpKV1owCsdF58yk91E6M+uFIZgwKyJ7BdWxRqLlR5pRZjQQR38fb+8+LB6MAbKTa/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734231517; c=relaxed/simple;
	bh=KEzX8VvlIPq+LG+kp76tQaRhTCaEVv6DrTm3JB2Q+Z4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fsQ/aIS1F+j4rrjKgIFMQoc6FwtR5uXXP5+B1X0MCGrUQv9T7vQ910ZkGF7gl8F8QtmtbCe/DmBRvMP0D1dHQ/Ob9WBwtVlahBhjUSEmNLL6TUNABKUtnvmrE+7O8f2Icz/6jMeoMkxEfju0p0qWRsdNe+w9D0XMsSBJaEjsYxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bMKG5VfU; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bMKG5VfU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734231516; x=1765767516;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=KEzX8VvlIPq+LG+kp76tQaRhTCaEVv6DrTm3JB2Q+Z4=;
  b=bMKG5VfUE0qMmFrfERkdxSD76AfcCWXcuij19ZXAd0xWjusXFGixUQyZ
   Xf+SBJ/bh8SSjmj5Zb45BKW2511H6iZRGDfJrO7ddDrLKFu5PdC8PzQNl
   kb+X4aYQT/O85pOM0e0qjuG1U7QRVmLGScdBLeqguuegQjY/eNSIoKQoz
   9OOXl6t7tFn4chHqj7pkDZikhyuooykLYE1mds20B92AZrbRdEpEttNc7
   KnTBFa4tsOBQzr226QGvVSXNAiEi6u1CkMDe8HvBpV8BO9HR+Ur+ZUEop
   IHvKtElLcOAD+Szppb40ogoVG+fuH4eopdDK1qf11/B0eB7g7420L/c0v
   w==;
X-CSE-ConnectionGUID: 2LiJGL45RaWvm58ad/t7UA==
X-CSE-MsgGUID: +XrZbhpwTROHZZwrctgYOg==
X-IronPort-AV: E=McAfee;i="6700,10204,11286"; a="52166943"
X-IronPort-AV: E=Sophos;i="6.12,235,1728975600"; 
   d="scan'208";a="52166943"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2024 18:58:36 -0800
X-CSE-ConnectionGUID: mR9ufJZIRd2HwnK0VpkU/w==
X-CSE-MsgGUID: 2BOb2w7BQdGFE+MqSmU9uQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="97309313"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO localhost) ([10.125.111.42])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2024 18:58:35 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Sat, 14 Dec 2024 20:58:29 -0600
Subject: [ndctl PATCH v4 2/9] ndctl/cxl/region: Report max size for region
 creation
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241214-dcd-region2-v4-2-36550a97f8e2@intel.com>
References: <20241214-dcd-region2-v4-0-36550a97f8e2@intel.com>
In-Reply-To: <20241214-dcd-region2-v4-0-36550a97f8e2@intel.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, 
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, 
 Sushant1 Kumar <sushant1.kumar@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1734231510; l=1059;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=KEzX8VvlIPq+LG+kp76tQaRhTCaEVv6DrTm3JB2Q+Z4=;
 b=xySbMWePvvsY6iygYZnDjPocl8XLdj88xQk9YHrTpa4ZhG7wi+ScFSk5yCdvyNC2N9wInJDyX
 xMjGHWQXC9pAlplh60TUKssaPEmDby34oU0i345tIzt6cmS98oCSDmY
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

When creating a region if the size exceeds the max an error is printed.
However, the max available space is not reported which makes it harder
to determine what is wrong.

Add the max size available to the output error.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 cxl/region.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cxl/region.c b/cxl/region.c
index 96aa5931d2281c7577679b7f6165218964fa0425..207cf2d003148992255c715f286bc0f38de2ca84 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -677,8 +677,8 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 	}
 	if (!default_size && size > max_extent) {
 		log_err(&rl,
-			"%s: region size %#lx exceeds max available space\n",
-			cxl_decoder_get_devname(p->root_decoder), size);
+			"%s: region size %#lx exceeds max available space (%#lx)\n",
+			cxl_decoder_get_devname(p->root_decoder), size, max_extent);
 		return -ENOSPC;
 	}
 

-- 
2.47.1

