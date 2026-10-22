Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792698981;
	b=Qxw9BjOANlOBSwuvVmlW0oa9L4zLRLjVvF9Tvf6TCTcJiGxMvkJ6WHSOTXKH8u3p6Ia/
	 mtLSMU+MB55A0NzkI9WhRAAJkmIVHxo16T6NQY1H/wJR8zyClHwQ9cIeOpHNc4sgR0gOd
	 AL3yhVbu5sN2/Eu5/YJ60ty/wczktke/OabSUm2vB4loWe6HVWlmSCOJlr9/szdfbmtJ+
	 BFqLYYmkhNKmfaRRrn45Hy0gMer/mSbnMPCuY/3PMlwZK0EjlRzfqgnhHBjQVq57WOrdV
	 8oq1wWG+xlQ/kEeVKg7AOYm9C8/ZAEPlVAuhHipKu38djVw4adMngMf5SrgIglRz2Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792698981;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=EhyvqJjUNvLM3IYOU6HrPv2kngNqu0LYz4/UaVvixc0=;
	b=nGa8tbL/jppJfz6waHB+ifoWo7uj2w6xGHdMfkWKqlkGohCYbMNmZlLr7fEmr5N3neol
	 R20lZtkN0JaHNFRkwNfoGOVhl+qM4mWXgAx1mYweXH7T92X8PzQlwx2RFNMxNzlgB5v2X
	 nNkT+9ZEVcfiVT2OJvWUh1OLfAumyHYlXJxwuzBCqwRUrQdsEzp066SMbp6LCiiR5FOuQ
	 0wk3C1WtOPn/BKCqOcTxhIRL1pIBj9CTyQelb8xM76UceOiqeWgSAeMVHjhRaiFTPOzWP
	 KQ4F6mE1xt99rQlRhOtUBNWwHb1NQwVoQFaTiSkfNZROXqQhPYaalyeNK5mi3VXsLqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=gzz43lve;
	arc=none smtp.remote-ip=192.198.163.10
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E137B606A324
	for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 19:56:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E137B606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=gzz43lve
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792698980; x=1824234980;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kBFh7VoO0oFkUYjxiMattY/W4neqxRpKpx0aq7KlNZM=;
  b=gzz43lve2de7ixjnuAP/MKV4tgvWt9rFRLRKdmRBpQWn6JK+di8zrFNs
   VqEpe9h6GgrRpDyXtqjQ5nJvhITCmZo+numW0+PUqgG0uT4B3ScnOneMI
   mP+Sg9GGTUrFjTikQnLhYA4a6E+Dhqshez0xZ4eIwe15hHCeDElGfzsMC
   LLJudgCOAVhM8zMUQBO51YSmBjFvhE+965EXeTKyt3aewlAC2RRhzSG05
   zgklcto1E6mXaCyg3BJ+kH6KKj02cyCdyXio4ZBOaLgvwdpEuxeQCaG5Y
   2UK1B7Qd52GAyQ+/68SX4aoaHGu/HUrHUkPvjCYdtEq9FDz3M89xosMDo
   g==;
X-CSE-ConnectionGUID: wDOY0vnrTF6Kei2D4dUlwQ==
X-CSE-MsgGUID: vwwwsgqyQeeMzefVWlFrJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11943"; a="1356738"
X-IronPort-AV: E=Sophos;i="6.27,172,1787036400"; 
   d="scan'208";a="1356738"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2026 12:56:19 -0700
X-CSE-ConnectionGUID: wNmxUdMfRfeInwl50pZSpg==
X-CSE-MsgGUID: ZTHky2oURcaTAx+k2V8IDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,172,1787036400"; 
   d="scan'208";a="3839591"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.111.215])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2026 12:56:19 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	Gregory Price <gourry@gourry.net>
Cc: Alison Schofield <alison.schofield@intel.com>,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 3/4] libdaxctl: match memory blocks against each dax device mapping
Date: Thu, 22 Oct 2026 12:56:12 -0700
Message-ID: <45bcae14b4f665af8427ebe38afdb9eff282bacd.1792695259.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1792695259.git.alison.schofield@intel.com>
References: <cover.1792695259.git.alison.schofield@intel.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

memblock_in_dev() treats a DAX device as one contiguous physical address
range, even when the device has multiple ranges separated by gaps. This
misses blocks in later ranges and may incorrectly include blocks belonging
to another device.

Memory block counts and per-block online/offline operations use this
lookup, so daxctl may operate on memory outside the requested device.

Match blocks against each individual mapping, retaining the single-range
fallback for older kernels.

Fixes: e8bf803e359b ("libdaxctl: add a 'daxctl_memory' object for memory based operations")
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 daxctl/lib/libdaxctl.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index f7cbf3fa12e7..b6b411dd916a 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -1615,6 +1615,7 @@ static int memblock_in_dev(struct daxctl_memory *mem, const char *memblock)
 	const char *devname = daxctl_dev_get_devname(dev);
 	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
 	int rc, path_len = mem->buf_len;
+	struct daxctl_mapping *mapping;
 	unsigned long memblock_size;
 	char buf[SYSFS_ATTR_SIZE];
 	unsigned long phys_index;
@@ -1654,8 +1655,18 @@ static int memblock_in_dev(struct daxctl_memory *mem, const char *memblock)
 	}
 	memblock_res = phys_index * memblock_size;
 
-	if (memblock_res >= dev_start && memblock_res <= dev_end)
-		return 1;
+	rc = mappings_init(dev);
+	if (rc < 0)
+		return rc;
+
+	/* kernels without mappingN report a single range */
+	if (list_empty(&dev->mappings))
+		return memblock_res >= dev_start && memblock_res <= dev_end;
+
+	daxctl_mapping_foreach(dev, mapping)
+		if (memblock_res >= mapping->start &&
+		    memblock_res <= mapping->end)
+			return 1;
 
 	return 0;
 }
-- 
2.37.3

