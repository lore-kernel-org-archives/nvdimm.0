Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA18120FB
	for <nvdimm@lists.linux.dev>; Fri, 16 Sep 2022 03:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663299328; x=1694835328;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3wvSjSkW/zXAYAgI4UeAUQfAuIeQwEc+TBBp6c7MzGs=;
  b=Mb9F74okTHTmaV/cHLI1gJbR1l4CoGfOhappm4V4iOTjYZ05X1urdOxD
   G2jrazMPdOsV2GSYMOIkN9WmnSm+cQqfdIdd5WaZ+SaO/fnlc9HXW9JLp
   uakhy241zwgKOOFyVDT03ccpJIv8JuM28nkgIUUXFvfhlTogHY0j10Fp6
   VGBij8x4GFIbJphhHxw4IPvexqQntK3357LnqBEBMQEo1coN36sqMkU1r
   HoVxWPgIzcaUzFeIIMHB0I2MjHTos3uSC8jFQVmD0V5wwWDfjTn6pf3og
   f9/ImlqTDD2i7N/F5iFIr8d2IDbUg8zIuPIDWPcHRYvXyzc+79kIAZUTp
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="298895380"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="298895380"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:35:28 -0700
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="792961807"
Received: from colinlix-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.29.52])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:35:27 -0700
Subject: [PATCH v2 03/18] fsdax: Include unmapped inodes for page-idle
 detection
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Date: Thu, 15 Sep 2022 20:35:27 -0700
Message-ID: <166329932730.2786261.8645669907699123863.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166329930818.2786261.6086109734008025807.stgit@dwillia2-xfh.jf.intel.com>
References: <166329930818.2786261.6086109734008025807.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

A page can remain pinned even after it has been unmapped from userspace
/ removed from the rmap. In advance of requiring that all
dax_insert_entry() events are followed up 'break layouts' before a
truncate event, make sure that 'break layouts' can find unmapped
entries.

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index e762b9c04fb4..76bad1c095c0 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -698,7 +698,7 @@ struct page *dax_layout_busy_page_range(struct address_space *mapping,
 	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
 		return NULL;
 
-	if (!dax_mapping(mapping) || !mapping_mapped(mapping))
+	if (!dax_mapping(mapping))
 		return NULL;
 
 	/* If end == LLONG_MAX, all pages from start to till end of file */

