Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 672A91A1DEE
 for <linux-nvdimm@lists.01.org>; Mon, 29 Aug 2016 12:12:07 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v4 RESEND 0/2] Align mmap address for DAX pmd mappings
Date: Mon, 29 Aug 2016 13:11:19 -0600
Message-Id: <1472497881-9323-1-git-send-email-toshi.kani@hpe.com>
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
To: akpm@linux-foundation.org
Cc: jack@suse.cz, mawilcox@microsoft.com, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org, tytso@mit.edu, kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com
List-ID: <linux-nvdimm@lists.01.org>

When CONFIG_FS_DAX_PMD is set, DAX supports mmap() using pmd page
size.  This feature relies on both mmap virtual address and FS
block (i.e. physical address) to be aligned by the pmd page size.
Users can use mkfs options to specify FS to align block allocations.
However, aligning mmap address requires code changes to existing
applications for providing a pmd-aligned address to mmap().

For instance, fio with "ioengine=mmap" performs I/Os with mmap() [1].
It calls mmap() with a NULL address, which needs to be changed to
provide a pmd-aligned address for testing with DAX pmd mappings.
Changing all applications that call mmap() with NULL is undesirable.

This patch-set extends filesystems to align an mmap address for
a DAX file so that unmodified applications can use DAX pmd mappings.

[1]: https://github.com/axboe/fio/blob/master/engines/mmap.c

RESEND:
 - Rebased to 4.8.0-rc4, and drop blk as BLK_DEV_DAX was removed.

v4:
 - Use loff_t for offset and cast before shift (Jan Kara)
 - Remove redundant paranthesis (Jan Kara)
 - Allow integration with huge page cache support (Matthew Wilcox)
 - Prepare for PUD mapping support (Mike Kravetz, Matthew Wilcox)

v3:
 - Check overflow condition to offset + length. (Matthew Wilcox)
 - Remove indent by using gotos. (Matthew Wilcox)
 - Define dax_get_unmapped_area to NULL when CONFIG_FS_DAX is unset.
   (Matthew Wilcox)
 - Squash all filesystem patches together. (Matthew Wilcox)

v2:
 - Change filesystems to provide their get_unmapped_area().
   (Matthew Wilcox)
 - Add more description about the benefit. (Matthew Wilcox)

---
Toshi Kani (2):
 1/2 thp, dax: add thp_get_unmapped_area for pmd mappings
 2/2 ext2/4, xfs, blk: call thp_get_unmapped_area() for pmd mappings

---
 fs/ext2/file.c          |  1 +
 fs/ext4/file.c          |  1 +
 fs/xfs/xfs_file.c       |  1 +
 include/linux/huge_mm.h |  7 +++++++
 mm/huge_memory.c        | 43 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 53 insertions(+)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
