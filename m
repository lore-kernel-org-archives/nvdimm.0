Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t5425.austin.hp.com (g1t5425.austin.hp.com [15.216.225.55])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CABA91A2024
 for <linux-nvdimm@lists.01.org>; Thu, 14 Apr 2016 09:57:15 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v3 0/2] Align mmap address for DAX pmd mappings
Date: Thu, 14 Apr 2016 10:48:29 -0600
Message-Id: <1460652511-19636-1-git-send-email-toshi.kani@hpe.com>
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
To: akpm@linux-foundation.org, dan.j.williams@intel.com, viro@zeniv.linux.org.uk
Cc: tytso@mit.edu, linux-nvdimm@lists.01.org, jack@suse.cz, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org, kirill.shutemov@linux.intel.com
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
 1/2 dax: add dax_get_unmapped_area for pmd mappings
 2/2 ext2/4, xfs, blk: call dax_get_unmapped_area() for DAX pmd mappings

---
 fs/block_dev.c      |  1 +
 fs/dax.c            | 43 +++++++++++++++++++++++++++++++++++++++++++
 fs/ext2/file.c      |  1 +
 fs/ext4/file.c      |  1 +
 fs/xfs/xfs_file.c   |  1 +
 include/linux/dax.h |  3 +++
 6 files changed, 50 insertions(+)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
