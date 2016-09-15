Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 811241A1EE1
 for <linux-nvdimm@lists.01.org>; Wed, 14 Sep 2016 23:57:42 -0700 (PDT)
Subject: [PATCH v2 0/3] mm,
 dax: export dax capabilities and mapping size info to userspace
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Sep 2016 23:54:25 -0700
Message-ID: <147392246509.9873.17750323049785100997.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, Dave Hansen <dave.hansen@linux.intel.com>, david@fromorbit.com, linux-kernel@vger.kernel.org, npiggin@gmail.com, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, hch@lst.de, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

In the debate about how to support persistent memory applications that
want to use hardware-platform memory-media persistence
rules/cpu-instructions rather than filesystem data intergrity system
calls [1], one of the consistent requests is to move these applications
to use a device file rather than a filesystem file [2].

While there is still a desire to offer the same syscall overhead
avoidance in filesystem-dax as device-dax, there is performance
optimization work and analysis that still needs to be done.
Optimization/analysis to address filesystem-dax performance being slower
than the typical page-cache path on top of pmem [3], and whether the
performance gains are worth developing new filesytem data integrity
mechanisms.

In the meantime we have device-dax and are missing a way to identify its
capabilities compared to filesytem-dax.  Critically, we want a
persistent memory transaction library, that is handed an address range
to manage, to be able to determine if it is safe to forgo calling
fsync/msync to record newly allocated blocks after a write fault.  This
question is answered by the new VM_SYNC flag.

It is also important to know if the pages behind a mapping are backed by
page cache and need to be synced, or are referencing media directly.  We
have an XFS inode flag that can indicate the inode is DAX enabled, but
nothing for device-dax or other filesystems.  Yes, an application that
maps /dev/dax should assume the mapping is DAX, but it is useful to be
able to tell that from the address range directly, and a common
mechanism across filesystems.

Finally, while developing and debugging the filesystem-dax huge page
support it was frustrating that the only way to unit test and verify the
implementation was via debug print statements.  This series extends
mincore(2) to optionally provide an indication of the hardware mapping
size.  This is hopefully useful to other cases that want to evaluate
transparent-huge-page usage.


Changes since the RFC [4]:

1/ Drop DAX indication out of mincore.  It is a vma capability not a
   per-page property and fits better as a vma flag.  Multiple people
   indicated it would be better if the new syscall published the capability
   as an extent or aggregated over a range, and this facility is already
   provided by smaps.

2/ Add VM_SYNC to explicity disclaim a need to call fsync/msync

3/ Drop the syscall wire-up patch since it is trivial and can be revived
   if we decide to move forward with the new mincore syscall.


[1]: https://lwn.net/Articles/676737/
[2]: https://lists.01.org/pipermail/linux-nvdimm/2016-September/006893.html
[3]: https://lists.01.org/pipermail/linux-nvdimm/2016-August/006497.html
[4]: https://lists.01.org/pipermail/linux-nvdimm/2016-September/006875.html

---

Dan Williams (3):
      mm, dax: add VM_SYNC flag for device-dax VMAs
      mm, dax: add VM_DAX flag for DAX VMAs
      mm, mincore2(): retrieve tlb-size attributes of an address range


 drivers/dax/Kconfig                    |    1 
 drivers/dax/dax.c                      |    2 
 fs/Kconfig                             |    1 
 fs/ext2/file.c                         |    2 
 fs/ext4/file.c                         |    2 
 fs/proc/task_mmu.c                     |    4 +
 fs/xfs/xfs_file.c                      |    2 
 include/linux/mm.h                     |   31 +++++++-
 include/linux/syscalls.h               |    2 
 include/uapi/asm-generic/mman-common.h |    2 
 kernel/sys_ni.c                        |    1 
 mm/mincore.c                           |  130 ++++++++++++++++++++++++--------
 12 files changed, 141 insertions(+), 39 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
