Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C055221A18AAA
 for <linux-nvdimm@lists.01.org>; Wed, 14 Jun 2017 10:21:03 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 0/3] DAX common 4k zero page
Date: Wed, 14 Jun 2017 11:22:08 -0600
Message-Id: <20170614172211.19820-1-ross.zwisler@linux.intel.com>
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
mapping->page_tree radix tree.  This has two major drawbacks:

1) It consumes memory unnecessarily.  For every 4k page that is read via a
DAX mmap() over a hole, we allocate a new page cache page.  This means that
if you read 1GiB worth of pages, you end up using 1GiB of zeroed memory.

2) The fact that we had to check for both DAX exceptional entries and for
page cache pages in the radix tree made the DAX code more complex.

This series solves these issues by following the lead of the DAX PMD code
and using a common 4k zero page instead.  This reduces memory usage for
some workloads, and it also simplifies the code in fs/dax.c, removing about
100 lines of code.

My hope is to have this reviewed and merged in time for v4.13 via the MM
tree, so if you could spare some review cycles I'd be grateful.

---
Changes since v1:
 - Leave vm_insert_mixed() instact with previous functionality and add
   vm_insert_mixed_mkwrite() as a peer so it is more readable/greppable.
   (Dan)

Ross Zwisler (3):
  mm: add vm_insert_mixed_mkwrite()
  dax: relocate dax_load_hole()
  dax: use common 4k zero page for dax mmap reads

 Documentation/filesystems/dax.txt |   5 +-
 fs/dax.c                          | 265 ++++++++++++--------------------------
 fs/ext2/file.c                    |  25 +---
 fs/ext4/file.c                    |  32 +----
 fs/xfs/xfs_file.c                 |   2 +-
 include/linux/dax.h               |  13 +-
 include/linux/mm.h                |   2 +
 include/trace/events/fs_dax.h     |   2 -
 mm/memory.c                       |  49 ++++++-
 9 files changed, 141 insertions(+), 254 deletions(-)

-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
