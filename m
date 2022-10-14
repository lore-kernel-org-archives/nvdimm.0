Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F249442C
	for <nvdimm@lists.linux.dev>; Fri, 14 Oct 2022 23:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665791835; x=1697327835;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3wvSjSkW/zXAYAgI4UeAUQfAuIeQwEc+TBBp6c7MzGs=;
  b=OdrGxEFdl9Cn+s8dQP8NcueISs1haXuhIkQh1PGmttSE0Ey8mvswYoqO
   tma2NziZrQv65+HhRfVodLAinj8bzjPWddO1jfrtz6jnNbels+PEQSj/U
   Ru+deuIfnlVdDC28XnirFrPxHw56tEwcmhcFPOrJWDw1e7qItx/xi9mGy
   2MCnzMqy7GJC+WMMqalfSFg4Xh2PZWaCbLHZLzsIXnqc3+UTBaLzSMgE4
   bTxTae0ALhCPnWHCsPbJ3ld4ROAl/Gx5TJeXOl9ZB4u/t/US/vr1tc0Gb
   trHdBuOH7B7O/kkv2IPjcUhM3mGabUg0aNMlNYxu/QmKEkXauelFlXpiG
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="391802328"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="391802328"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:57:14 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="658759536"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="658759536"
Received: from uyoon-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.90.112])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:57:14 -0700
Subject: [PATCH v3 03/25] fsdax: Include unmapped inodes for page-idle
 detection
From: Dan Williams <dan.j.williams@intel.com>
To: linux-mm@kvack.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
 david@fromorbit.com, nvdimm@lists.linux.dev, akpm@linux-foundation.org,
 linux-fsdevel@vger.kernel.org
Date: Fri, 14 Oct 2022 16:57:14 -0700
Message-ID: <166579183407.2236710.2161472385123143060.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166579181584.2236710.17813547487183983273.stgit@dwillia2-xfh.jf.intel.com>
References: <166579181584.2236710.17813547487183983273.stgit@dwillia2-xfh.jf.intel.com>
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

