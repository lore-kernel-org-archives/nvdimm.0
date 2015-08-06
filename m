Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 0/6] pmem, dax: I/O path enhancements
Date: Thu,  6 Aug 2015 11:43:14 -0600
Message-Id: <1438883000-9011-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Juergen Gross <jgross@suse.com>, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>, Matthew Wilcox <willy@linux.intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Thomas Gleixner <tglx@linutronix.de>, Toshi Kani <toshi.kani@hp.com>, x86@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Patch 5 adds support for the "read flush" _DSM flag, allowing us to change the
ND BLK aperture mapping from write-combining to write-back via memremap_pmem().

Patch 6 updates the DAX I/O path so that all operations that store data (I/O
writes, zeroing blocks, punching holes, etc.) properly synchronize the stores
to media using the PMEM API.  This ensures that the data DAX is writing is
durable on media before the operation completes.

Patches 1-4 are cleanup patches and additions to the PMEM API that make
patches 5 and 6 possible.

Regarding the choice to add both flush_cache_pmem() and wb_cache_pmem() to the
PMEM API, I had initially implemented flush_cache_pmem() as a generic function
flush_io_cache_range() in the spirit of flush_cache_range(), etc., in
cacheflush.h.  I eventually moved it into the PMEM API because a) it has a
common and consistent use of the __pmem annotation, b) it has a clear fallback
method for architectures that don't support it, as opposed to APIs in
cacheflush.h which would need to be added individually to all other
architectures.  It can be argued that the flush API could apply to other uses
beyond PMEM such as flushing cache lines associated with other types of
sliding MMIO windows.  At this point I'm inclined to have it as part of the
PMEM API, and then take on the effort of making it a general cache flusing API
if other users come along.

Ross Zwisler (6):
  pmem: remove indirection layer arch_has_pmem_api()
  x86: clean up conditional pmem includes
  x86: add clwb_cache_range()
  pmem: Add wb_cache_pmem() and flush_cache_pmem()
  nd_blk: add support for "read flush" DSM flag
  dax: update I/O path to do proper PMEM flushing

 arch/x86/include/asm/cacheflush.h | 24 +++++++++--------
 arch/x86/mm/pageattr.c            | 23 ++++++++++++++++
 drivers/acpi/nfit.c               | 18 ++++++-------
 drivers/acpi/nfit.h               |  6 ++++-
 fs/dax.c                          | 55 +++++++++++++++++++++++++++++++--------
 include/linux/pmem.h              | 36 ++++++++++++++++++-------
 6 files changed, 120 insertions(+), 42 deletions(-)

-- 
2.1.0

