Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4D12421CB74C0
 for <linux-nvdimm@lists.01.org>; Wed, 28 Jun 2017 15:01:07 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v3 0/5] DAX common 4k zero page
Date: Wed, 28 Jun 2017 16:01:47 -0600
Message-Id: <20170628220152.28161-1-ross.zwisler@linux.intel.com>
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
Cc: linux-xfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jonathan Corbet <corbet@lwn.net>, Steven Rostedt <rostedt@goodmis.org>, linux-doc@vger.kernel.org, linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

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

Andrew, I'm still hoping to get this merged for v4.13 if possible. I I have
addressed all of Jan's feedback, but he is on vacation for the next few
weeks so he may not be able to give me Reviewed-by tags.  I think this
series is relatively low risk with clear benefits, and I think we should be
able to address any issues that come up during the v4.13 RC series.

This series has passed my targeted testing and a full xfstests run on both
XFS and ext4.

---
Changes since v2:
 - If we call insert_pfn() with 'mkwrite' for an entry that already exists,
   don't overwrite the pte with a brand new one.  Just add the appropriate
   flags. (Jan)

 - Keep put_locked_mapping_entry() as a simple wrapper for
   dax_unlock_mapping_entry() so it has naming parity with
   get_unlocked_mapping_entry(). (Jan)

 - Remove DAX special casing in page_cache_tree_insert(), move
   now-private definitions from dax.h to dax.c. (Jan)

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
 mm/memory.c                       |  57 ++++++-
 10 files changed, 205 insertions(+), 323 deletions(-)

-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
