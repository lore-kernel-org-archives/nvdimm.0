Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7FE612095D9C2
 for <linux-nvdimm@lists.01.org>; Fri, 21 Jul 2017 15:38:04 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v4 0/5] DAX common 4k zero page
Date: Fri, 21 Jul 2017 16:39:50 -0600
Message-Id: <20170721223956.29485-1-ross.zwisler@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, linux-doc@vger.kernel.org, David Airlie <airlied@linux.ie>, Dave Chinner <david@fromorbit.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, Christoph Hellwig <hch@lst.de>, linux-samsung-soc@vger.kernel.org, Joonyoung Shim <jy0922.shim@samsung.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>, Kyungmin Park <kyungmin.park@samsung.com>, Krzysztof Kozlowski <krzk@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-ext4@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-arm-msm@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Inki Dae <inki.dae@samsung.com>, linux-nvdimm@lists.01.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-arm-kernel@lists.infradead.org, Theodore Ts'o <tytso@mit.edu>, Jonathan Corbet <corbet@lwn.net>, Seung-Woo Kim <sw0312.kim@samsung.com>, linux-xfs@vger.kernel.org, Rob Clark <robdclark@gmail.com>, Kukjin Kim <kgene@kernel.org>, linux-fsdevel@vger.kernel.org, freedreno@lists.freedesktop.org
List-ID: <linux-nvdimm@lists.01.org>

Changes since v3:
 - Rebased onto the current linux/master which is based on v4.13-rc1.

 - Instead of adding vm_insert_mkwrite_mixed() and duplicating code from
   vm_insert_mixed(), instead just add a 'mkwrite' parameter to
   vm_insert_mixed() and update all call sites.  (Vivek)

 - Added a sanity check to the mkwrite case of insert_pfn() to be sure the
   pfn for the pte we are about to make writable matches the pfn for our
   fault. (Jan)

 - Fixed up some changelog wording for clarity. (Jan)

---

When servicing mmap() reads from file holes the current DAX code allocates
a page cache page of all zeroes and places the struct page pointer in the
mapping->page_tree radix tree.  This has three major drawbacks:

1) It consumes memory unnecessarily.  For every 4k page that is read via a
DAX mmap() over a hole, we allocate a new page cache page.  This means that
if you read 1GiB worth of pages, you end up using 1GiB of zeroed memory.

2) It is slower than using a common zero page because each page fault has
more work to do.  Instead of just inserting a common zero page we have to
allocate a page cache page, zero it, and then insert it.

3) The fact that we had to check for both DAX exceptional entries and for
page cache pages in the radix tree made the DAX code more complex.

This series solves these issues by following the lead of the DAX PMD code
and using a common 4k zero page instead.  This reduces memory usage and
decreases latencies for some workloads, and it simplifies the DAX code,
removing over 100 lines in total.

This series has passed my targeted testing and a full xfstests run on both
XFS and ext4.

Ross Zwisler (5):
  mm: add mkwrite param to vm_insert_mixed()
  dax: relocate some dax functions
  dax: use common 4k zero page for dax mmap reads
  dax: remove DAX code from page_cache_tree_insert()
  dax: move all DAX radix tree defs to fs/dax.c

 Documentation/filesystems/dax.txt       |   5 +-
 drivers/dax/device.c                    |   2 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.c |   3 +-
 drivers/gpu/drm/gma500/framebuffer.c    |   2 +-
 drivers/gpu/drm/msm/msm_gem.c           |   3 +-
 drivers/gpu/drm/omapdrm/omap_gem.c      |   6 +-
 drivers/gpu/drm/ttm/ttm_bo_vm.c         |   2 +-
 fs/dax.c                                | 342 +++++++++++++-------------------
 fs/ext2/file.c                          |  25 +--
 fs/ext4/file.c                          |  32 +--
 fs/xfs/xfs_file.c                       |   2 +-
 include/linux/dax.h                     |  45 -----
 include/linux/mm.h                      |   2 +-
 include/trace/events/fs_dax.h           |   2 -
 mm/filemap.c                            |  13 +-
 mm/memory.c                             |  27 ++-
 16 files changed, 181 insertions(+), 332 deletions(-)

-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
