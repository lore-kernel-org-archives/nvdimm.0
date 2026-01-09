Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CA7355058
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 08:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767949004; cv=none; b=k1K0plgDXNq4hWWY6badRNj6xoQ6GPIBuny1Kk/MX5V7ioEUbF9atZrDIslBFmB5Uxflu4fNtCt919NUwYxffp/ea6Y86hsUO1Og34Ve78KiP/yNeeiZl9XYkX6R1JrnbGmwDQS96j4uR1k4Ri/LmBdPlNMoOfGuYmbqE07Qx2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767949004; c=relaxed/simple;
	bh=C/wgMdLsD2tb2QyXAAXoSur5L4DO3Kxja0XkyIF7z5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aE6L5RvxWKss35zgmvGGJ2iBTHWAvocQPyzkJqM08b/B4MCriHpK3bUM0ghxOD+pUCrdZgu2qxO89WRSAwRiqg3OsO9ajLGeu/dKUSywkHZJ3h1WSGbe31Hy7cYL1B5qJoKqNyuphkKBKvc3Aj1HfcIfU1Q5p5xe1nfQ5t21Sdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mSHOQ+Ut; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mSHOQ+Ut"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767949001; x=1799485001;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C/wgMdLsD2tb2QyXAAXoSur5L4DO3Kxja0XkyIF7z5I=;
  b=mSHOQ+UtK9Mq12WIb1u5m3jluSYK4xPEhycGOnEHfohr0YZH96sjtAHL
   K5FSoJui0sBEZAoFi+0pc5dXGAC6nONGFbAQvB0dS+dyTtYjp3FC3rQS/
   pjVbPpJWG1iOh2AmXKZYeQPUkfLJgXE7pLhfO/BUbBQ2KxPycPC/hQT9f
   9ZjseyUV4gtVg/re4SLI9ruO7WLQIzU9SpTelZbZyDp+VVh/5osIhfB67
   Bn4+59ksnziMQUW2Lv5P77qbQoRBwD0JUqUoKETRcjtdB+27ao0vwsovC
   +aA1CaRGlgoLXDAIjExN8pr6kh/9hpOdxxtn2c2kCvz5zNM9cDpBSI2c6
   Q==;
X-CSE-ConnectionGUID: z7VKgRCFQ8SgvRIHHv5OIQ==
X-CSE-MsgGUID: QaiCpuWGSfC9qHi97i3qmA==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="79625986"
X-IronPort-AV: E=Sophos;i="6.21,212,1763452800"; 
   d="scan'208";a="79625986"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 00:56:37 -0800
X-CSE-ConnectionGUID: 8PUErSNTSXWuxfOhJ4T+jw==
X-CSE-MsgGUID: Y+RkkjyNTbKjIVGeE7szXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,212,1763452800"; 
   d="scan'208";a="202538604"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO fdugast-desk.intel.com) ([10.245.244.83])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 00:56:34 -0800
From: Francois Dugast <francois.dugast@intel.com>
To: intel-xe@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Alistair Popple <apopple@nvidia.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [PATCH v3 2/7] fs/dax: Use folio_split_unref helper
Date: Fri,  9 Jan 2026 09:54:22 +0100
Message-ID: <20260109085605.443316-3-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260109085605.443316-1-francois.dugast@intel.com>
References: <20260109085605.443316-1-francois.dugast@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Matthew Brost <matthew.brost@intel.com>

Use folio_split_unref helper to split a folio into individual upon final
put of a fsdax page.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Suggested-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Francois Dugast <francois.dugast@intel.com>
---
 fs/dax.c | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 289e6254aa30..90ec68785f40 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -381,7 +381,6 @@ static void dax_folio_make_shared(struct folio *folio)
 static inline unsigned long dax_folio_put(struct folio *folio)
 {
 	unsigned long ref;
-	int order, i;
 
 	if (!dax_folio_is_shared(folio))
 		ref = 0;
@@ -391,29 +390,7 @@ static inline unsigned long dax_folio_put(struct folio *folio)
 	if (ref)
 		return ref;
 
-	folio->mapping = NULL;
-	order = folio_order(folio);
-	if (!order)
-		return 0;
-	folio_reset_order(folio);
-
-	for (i = 0; i < (1UL << order); i++) {
-		struct dev_pagemap *pgmap = page_pgmap(&folio->page);
-		struct page *page = folio_page(folio, i);
-		struct folio *new_folio = (struct folio *)page;
-
-		ClearPageHead(page);
-		clear_compound_head(page);
-
-		new_folio->mapping = NULL;
-		/*
-		 * Reset pgmap which was over-written by
-		 * prep_compound_page().
-		 */
-		new_folio->pgmap = pgmap;
-		new_folio->share = 0;
-		WARN_ON_ONCE(folio_ref_count(new_folio));
-	}
+	folio_split_unref(folio);
 
 	return ref;
 }
-- 
2.43.0

