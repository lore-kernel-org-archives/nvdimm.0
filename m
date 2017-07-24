Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C554820958995
 for <linux-nvdimm@lists.01.org>; Mon, 24 Jul 2017 10:04:19 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v5 0/5] DAX common 4k zero page
Date: Mon, 24 Jul 2017 11:06:11 -0600
Message-Id: <20170724170616.25810-1-ross.zwisler@linux.intel.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Jonathan Corbet <corbet@lwn.net>, Steven Rostedt <rostedt@goodmis.org>, linux-doc@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Changes since v4:
 - Added static __vm_insert_mixed() to mm/memory.c that holds the common
   code for both vm_insert_mixed() and vm_insert_mixed_mkwrite() so we
   don't have duplicate code and we don't have to pass boolean flags
   around.  (Dan & Jan)

 - Added a comment for the PFN sanity checking done in the mkwrite case of
   insert_pfn().

 - Added Jan's reviewed-by tags.

This series has passed a full xfstests run on both XFS and ext4.

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

Ross Zwisler (5):
  mm: add vm_insert_mixed_mkwrite()
  dax: relocate some dax functions
  dax: use common 4k zero page for dax mmap reads
  dax: remove DAX code from page_cache_tree_insert()
  dax: move all DAX radix tree defs to fs/dax.c

 Documentation/filesystems/dax.txt |   5 +-
 fs/dax.c                          | 345 ++++++++++++++++----------------------
 fs/ext2/file.c                    |  25 +--
 fs/ext4/file.c                    |  32 +---
 fs/xfs/xfs_file.c                 |   2 +-
 include/linux/dax.h               |  45 -----
 include/linux/mm.h                |   2 +
 include/trace/events/fs_dax.h     |   2 -
 mm/filemap.c                      |  13 +-
 mm/memory.c                       |  50 +++++-
 10 files changed, 196 insertions(+), 325 deletions(-)

-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
