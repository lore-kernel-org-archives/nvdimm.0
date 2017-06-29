Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9FBFA21B02B9D
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 10:57:51 -0700 (PDT)
Subject: [PATCH v4 00/16] pmem: stop abusing copy_user_nocache(),
 and other reworks
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Jun 2017 10:52:57 -0700
Message-ID: <149875877608.10031.17813337234536358002.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, viro@zeniv.linux.org.uk, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, hch@lst.de, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v3 [1]:

* Remove default copy_from_iter() fallback in the dax core (Christoph).

* Don't abuse block/queue sysfs for cache-flush control, introduce a
  dax-specific interface (Christoph).

* Don't export clean_cache_range() export an arch_wb_cache_pmem() wrapper
  instead (Christoph). This also allows us to remove asm/pmem.h along
  with include/linux/pmem.h.

[1]: https://lkml.org/lkml/2017/6/9/842

The changes above are constrained to the last 4 patches of the series.
Patch1 still needs Al's review.

---

A few months back, in the course of reviewing the memcpy_nocache()
proposal from Brian, Linus proposed that the pmem specific
memcpy_to_pmem() routine be moved to be implemented at the driver level
[2]:

   "Quite frankly, the whole 'memcpy_nocache()' idea or (ab-)using
    copy_user_nocache() just needs to die. It's idiotic.

    As you point out, it's also fundamentally buggy crap.

    Throw it away. There is no possible way this is ever valid or
    portable. We're not going to lie and claim that it is.

    If some driver ends up using 'movnt' by hand, that is up to that
    *driver*. But no way in hell should we care about this one whit in
    the sense of <linux/uaccess.h>."

This feedback also dovetails with another fs/dax.c design wart of being
hard coded to assume the backing device is pmem. We call the pmem
specific copy, clear, and flush routines even if the backing device
driver is one of the other 3 dax drivers (axonram, dccssblk, or brd).
There is no reason to spend cpu cycles flushing the cache after writing
to brd, for example, since it is using volatile memory for storage.

Moreover, the pmem driver might be fronting a volatile memory range
published by the ACPI NFIT, or the platform might have arranged to flush
cpu caches on power fail. This latter capability is a feature that has
appeared in embedded storage appliances (pre-ACPI-NFIT nvdimm
platforms).

Now, the comment about completely avoiding uaccess.h is augmented by
Al's recent assertion:

   "And for !@#!@# sake, comments like this
    +        * On x86_64 __copy_from_user_nocache() uses non-temporal stores
    +        * for the bulk of the transfer, but we need to manually flush
    +        * if the transfer is unaligned. A cached memory copy is used
    +        * when destination or size is not naturally aligned. That is:
    +        *   - Require 8-byte alignment when size is 8 bytes or larger.
    +        *   - Require 4-byte alignment when size is 4 bytes.
    mean only one thing: this should live in arch/x86/lib/usercopy_64.c,
    right next to the actual function that does copying.  NOT in
    drivers/nvdimm/x86.c.  At the very least it needs a comment in usercopy_64.c
    with dire warnings along the lines of "don't touch that code without
    looking into <filename>:pmem_from_user().."

So, this series proceeds to keep all the usercopy code centralized. The
change set:

1/ Moves what was previously named "the pmem api" out of the global
   namespace and into the libnvdimm sub-system that needs to be
   concerned with architecture specific persistent memory considerations.

2/ Arranges for dax to stop abusing __copy_user_nocache() and implements
   formal _flushcache helpers that use 'movnt' on x86_64.

3/ Makes filesystem-dax cache maintenance optional by arranging for dax
   to call driver specific copy and flush operations only if the driver
   publishes them.

4/ Allows filesytem-dax cache-flushing to be controlled by a new
   'dax/write_cache' sysfs attribute. The pmem driver is updated to
   clear the flag by default when pmem is driving volatile memory. ACPI
   6.2 defines a mechanism to detect if the platform handles cpu cache
   flushing for pmem and will be used to set the default for this flag.

[2]: https://lists.01.org/pipermail/linux-nvdimm/2017-January/008364.html

This series is based on v4.12-rc4 and passes the current ndctl
regression suite.

---

Dan Williams (16):
      x86, uaccess: introduce copy_from_iter_flushcache for pmem / cache-bypass operations
      dm: add ->copy_from_iter() dax operation support
      filesystem-dax: convert to dax_copy_from_iter()
      dax, pmem: introduce an optional 'flush' dax_operation
      dm: add ->flush() dax operation support
      filesystem-dax: convert to dax_flush()
      x86, dax: replace clear_pmem() with open coded memset + dax_ops->flush
      x86, dax, libnvdimm: remove wb_cache_pmem() indirection
      x86, libnvdimm, pmem: move arch_invalidate_pmem() to libnvdimm
      x86, libnvdimm, pmem: remove global pmem api
      libnvdimm, pmem: fix persistence warning
      libnvdimm, nfit: enable support for volatile ranges
      dax: remove default copy_from_iter fallback
      dax: convert to bitmask for flags
      libnvdimm, pmem, dax: export a cache control attribute
      libnvdimm, pmem: disable dax flushing when pmem is fronting a volatile region


 MAINTAINERS                       |    4 -
 arch/powerpc/sysdev/axonram.c     |    8 ++
 arch/x86/Kconfig                  |    1 
 arch/x86/include/asm/pmem.h       |  136 -----------------------------------
 arch/x86/include/asm/string_64.h  |    5 +
 arch/x86/include/asm/uaccess_64.h |   11 +++
 arch/x86/lib/usercopy_64.c        |  134 +++++++++++++++++++++++++++++++++++
 arch/x86/mm/pageattr.c            |    6 ++
 drivers/acpi/nfit/core.c          |   15 +++-
 drivers/block/brd.c               |    8 ++
 drivers/dax/super.c               |  118 +++++++++++++++++++++++++++++--
 drivers/md/dm-linear.c            |   30 ++++++++
 drivers/md/dm-stripe.c            |   40 ++++++++++
 drivers/md/dm.c                   |   45 ++++++++++++
 drivers/nvdimm/bus.c              |    8 +-
 drivers/nvdimm/claim.c            |    6 +-
 drivers/nvdimm/core.c             |    2 -
 drivers/nvdimm/dax_devs.c         |    2 -
 drivers/nvdimm/dimm_devs.c        |   10 ++-
 drivers/nvdimm/namespace_devs.c   |   14 +---
 drivers/nvdimm/nd-core.h          |    9 ++
 drivers/nvdimm/pfn_devs.c         |    4 +
 drivers/nvdimm/pmem.c             |   40 +++++++++-
 drivers/nvdimm/pmem.h             |   14 ++++
 drivers/nvdimm/region_devs.c      |   43 +++++++----
 drivers/s390/block/dcssblk.c      |    8 ++
 fs/dax.c                          |    9 +-
 include/linux/dax.h               |   12 +++
 include/linux/device-mapper.h     |    6 ++
 include/linux/libnvdimm.h         |    2 +
 include/linux/pmem.h              |  142 -------------------------------------
 include/linux/string.h            |    6 ++
 include/linux/uio.h               |   15 ++++
 lib/Kconfig                       |    3 +
 lib/iov_iter.c                    |   22 ++++++
 35 files changed, 597 insertions(+), 341 deletions(-)
 delete mode 100644 arch/x86/include/asm/pmem.h
 delete mode 100644 include/linux/pmem.h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
