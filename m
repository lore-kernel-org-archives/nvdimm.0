Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C542B7E
	for <nvdimm@lists.linux.dev>; Sun,  4 Sep 2022 02:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662257761; x=1693793761;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fnBW3tH05kzrxa7RlM0wu6waCCayGzZFmKPuKurUqcI=;
  b=nVaxccmUSptS/IviQrA8G2Xt+A9EgYBL5YMHmtPs957rs2lIg4fFqVZI
   JgQ/P4hQVb9J7jfMXMjOxS/EL7V1zfQOZgemiAOEhD5ef0D+fnoh9qzSY
   lQd2ypmfPLiKnBdBkqUOVPhGfudzXyft62CurWmo/VmHBeN/5Kcc379Ef
   AKN6Qu8xLlv75MgSFjmRaO3E4If6RrxmVDmqCGcDiP7Pg+GWVzbWcGqpU
   KqhykxZ/3Ks7bAVGfR7Qo1gTBKYxT4pFMHfLGiMi9B++n0SiBdwjki7cx
   mA8N/drGACBQJIHBVxnyjWTQazqpFmJSOQIhHCHNxGHI2nvn/QAqBzefj
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10459"; a="276599665"
X-IronPort-AV: E=Sophos;i="5.93,288,1654585200"; 
   d="scan'208";a="276599665"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2022 19:16:01 -0700
X-IronPort-AV: E=Sophos;i="5.93,288,1654585200"; 
   d="scan'208";a="643384361"
Received: from pg4-mobl3.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.132.198])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2022 19:16:00 -0700
Subject: [PATCH 00/13] Fix the DAX-gup mistake
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: Jason Gunthorpe <jgg@nvidia.com>, Jan Kara <jack@suse.cz>,
 Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>,
 John Hubbard <jhubbard@nvidia.com>, Matthew Wilcox <willy@infradead.org>,
 linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org
Date: Sat, 03 Sep 2022 19:16:00 -0700
Message-ID: <166225775968.2351842.11156458342486082012.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

tl;dr: Move the pin of 'struct dev_pagemap' instances from gup-time to
map time, move the unpin of 'struct dev_pagemap' to truncate_inode_pages()
for fsdax and devdax inodes, and use page_maybe_dma_pinned() to
determine when filesystems can safely truncate DAX mappings vs DMA.

The longer story is that DAX has caused friction with folio development
and other device-memory use cases due to its hack of using a
page-reference count of 1 to indicate that the page is DMA idle. That
situation arose from the mistake of not managing DAX page reference
counts at map time. The lack of page reference counting at map time grew
organically from the original DAX experiment of attempting to manage DAX
mappings without page structures. The page lock, dirty tracking and
other entry management was supported sans pages. However, the page
support was then bolted on incrementally so solve problems with gup,
memory-failure, and all the other kernel services that are missing when
a pfn does not have an associated page structure.

Since then John has led an effort to account for when a page is pinned
for DMA vs other sources that elevate the reference count. The
page_maybe_dma_pinned() helper slots in seamlessly to replace the need
to track transitions to page->_refount == 1.

The larger change in this set comes from Jason's observation that
inserting DAX mappings without any reference taken is a bug. So
dax_insert_entry(), that fsdax uses, is updated to take 'struct
dev_pagemap' references, and devdax is updated to reuse the same.

This allows for 'struct dev_pagemap' manipulation to be self-contained
to DAX-specific paths. It is also a foundation to build towards removing
pte_devmap() and start treating DAX pages as another vm_normal_page(),
and perhaps more conversions of the DAX infrastructure to reuse typical
page mapping helpers. One of the immediate hurdles is the usage of
pmd_devmap() to distinguish large page mappings that are not transparent
huge pages.

---

Dan Williams (13):
      fsdax: Rename "busy page" to "pinned page"
      fsdax: Use page_maybe_dma_pinned() for DAX vs DMA collisions
      fsdax: Delete put_devmap_managed_page_refs()
      fsdax: Update dax_insert_entry() calling convention to return an error
      fsdax: Cleanup dax_associate_entry()
      fsdax: Rework dax_insert_entry() calling convention
      fsdax: Manage pgmap references at entry insertion and deletion
      devdax: Minor warning fixups
      devdax: Move address_space helpers to the DAX core
      dax: Prep dax_{associate,disassociate}_entry() for compound pages
      devdax: add PUD support to the DAX mapping infrastructure
      devdax: Use dax_insert_entry() + dax_delete_mapping_entry()
      mm/gup: Drop DAX pgmap accounting


 .clang-format             |    1
 drivers/Makefile          |    2
 drivers/dax/Kconfig       |    6
 drivers/dax/Makefile      |    1
 drivers/dax/bus.c         |    2
 drivers/dax/dax-private.h |    1
 drivers/dax/device.c      |   73 ++-
 drivers/dax/mapping.c     | 1020 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/dax/super.c       |    2
 fs/dax.c                  | 1049 ++-------------------------------------------
 fs/ext4/inode.c           |    9
 fs/fuse/dax.c             |   10
 fs/xfs/xfs_file.c         |    8
 fs/xfs/xfs_inode.c        |    2
 include/linux/dax.h       |  124 ++++-
 include/linux/huge_mm.h   |   23 -
 include/linux/memremap.h  |   24 +
 include/linux/mm.h        |   58 +-
 mm/gup.c                  |   92 +---
 mm/huge_memory.c          |   54 --
 mm/memremap.c             |   31 -
 mm/swap.c                 |    2
 22 files changed, 1326 insertions(+), 1268 deletions(-)
 create mode 100644 drivers/dax/mapping.c

base-commit: 1c23f9e627a7b412978b4e852793c5e3c3efc555
