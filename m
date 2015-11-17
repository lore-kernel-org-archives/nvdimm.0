Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH 2/8] dax: disable pmd mappings
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 17 Nov 2015 12:16:03 -0800
Message-ID: <20151117201603.15053.77916.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20151117201551.15053.32709.stgit@dwillia2-desk3.jf.intel.com>
References: <20151117201551.15053.32709.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Dave Chinner <david@fromorbit.com>, stable@vger.kernel.org, linux-block@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, willy@linux.intel.com, ross.zwisler@linux.intel.com, akpm@linux-foundation.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

While dax pmd mappings are functional in the nominal path they trigger
kernel crashes in the following paths:

 BUG: unable to handle kernel paging request at ffffea0004098000
 IP: [<ffffffff812362f7>] follow_trans_huge_pmd+0x117/0x3b0
 [..]
 Call Trace:
  [<ffffffff811f6573>] follow_page_mask+0x2d3/0x380
  [<ffffffff811f6708>] __get_user_pages+0xe8/0x6f0
  [<ffffffff811f7045>] get_user_pages_unlocked+0x165/0x1e0
  [<ffffffff8106f5b1>] get_user_pages_fast+0xa1/0x1b0

 kernel BUG at arch/x86/mm/gup.c:131!
 [..]
 Call Trace:
  [<ffffffff8106f34c>] gup_pud_range+0x1bc/0x220
  [<ffffffff8106f634>] get_user_pages_fast+0x124/0x1b0

 BUG: unable to handle kernel paging request at ffffea0004088000
 IP: [<ffffffff81235f49>] copy_huge_pmd+0x159/0x350
 [..]
 Call Trace:
  [<ffffffff811fad3c>] copy_page_range+0x34c/0x9f0
  [<ffffffff810a0daf>] copy_process+0x1b7f/0x1e10
  [<ffffffff810a11c1>] _do_fork+0x91/0x590

All of these paths are interpreting a dax pmd mapping as a transparent
huge page and making the assumption that the pfn is covered by the
memmap, i.e. that the pfn has an associated struct page.  PTE mappings
do not suffer the same fate since they have the _PAGE_SPECIAL flag to
cause the gup path to fault.  We can do something similar for the PMD
path, or otherwise defer pmd support for cases where a struct page is
available.  For now, 4.4-rc and -stable need to disable dax pmd support
by default.

For development the "depends on BROKEN" line can be removed from
CONFIG_FS_DAX_PMD.

Cc: <stable@vger.kernel.org>
Cc: Jan Kara <jack@suse.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/Kconfig |    6 ++++++
 fs/dax.c   |    4 ++++
 2 files changed, 10 insertions(+)

diff --git a/fs/Kconfig b/fs/Kconfig
index da3f32f1a4e4..6ce72d8d1ee1 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -46,6 +46,12 @@ config FS_DAX
 	  or if unsure, say N.  Saying Y will increase the size of the kernel
 	  by about 5kB.
 
+config FS_DAX_PMD
+	bool
+	default FS_DAX
+	depends on FS_DAX
+	depends on BROKEN
+
 endif # BLOCK
 
 # Posix ACL utility routines
diff --git a/fs/dax.c b/fs/dax.c
index d1e5cb7311a1..43671b68220e 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -541,6 +541,10 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	unsigned long pfn;
 	int result = 0;
 
+	/* dax pmd mappings are broken wrt gup and fork */
+	if (!IS_ENABLED(CONFIG_FS_DAX_PMD))
+		return VM_FAULT_FALLBACK;
+
 	/* Fall back to PTEs if we're going to COW */
 	if (write && !(vma->vm_flags & VM_SHARED))
 		return VM_FAULT_FALLBACK;

