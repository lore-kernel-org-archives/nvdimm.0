Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7B92FB8
	for <nvdimm@lists.linux.dev>; Wed,  4 Aug 2021 04:32:39 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="201011706"
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="201011706"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:35 -0700
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="521680204"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:34 -0700
From: ira.weiny@intel.com
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH V7 00/18] PKS/PMEM: Add Stray Write Protection
Date: Tue,  3 Aug 2021 21:32:13 -0700
Message-Id: <20210804043231.2655537-1-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

NOTE: x86 maintainers, I'm submitting this for ack/review by Dave Hansen and
Dan Williams.  Feel free to ignore it but we have had a lot of internal debate
on a number of design decisions so we would like to have the remaining reviews
public such that everyone can see the remaining debate/decisions.

Furthermore, this gives a public reference for Rick to build other PKS use
cases on.


PKS/PMEM Stray write protection
===============================

This series is broken into 2 parts.

	1) Introduce Protection Key Supervisor (PKS)
	2) Use PKS to protect PMEM from stray writes

Introduce Protection Key Supervisor (PKS)
-----------------------------------------

PKS enables protections on 'domains' of supervisor pages to limit supervisor
mode access to pages beyond the normal paging protections.  PKS works in a
similar fashion to user space pkeys, PKU.  As with PKU, supervisor pkeys are
checked in addition to normal paging protections and Access or Writes can be
disabled via a MSR update without TLB flushes when permissions change.

Also like PKU, a page mapping is assigned to a domain by setting pkey bits in
the page table entry for that mapping.

Access is controlled through a PKRS register which is updated via WRMSR/RDMSR.

XSAVE is not supported for the PKRS MSR.  Therefore the implementation
saves/restores the MSR across context switches and during exceptions.  Nested
exceptions are supported by each exception getting a new PKS state.

For consistent behavior with current paging protections, pkey 0 is reserved and
configured to allow full access via the pkey mechanism, thus preserving the
default paging protections.

Other keys, (1-15) are statically allocated by kernel users adding an entry to
'enum pks_pkey_consumers' and adding a corresponding default value in
consumer_defaults in create_initial_pkrs_value().  This patch series allocates
a single key for use by persistent memory stray write protection.  When the
number of users grows larger the sharing of keys will need to be resolved
depending on the needs of the users at that time.

More usage details can be found in the documentation.

The following are key attributes of PKS.

	1) Fast switching of permissions
		1a) Prevents access without page table manipulations
		1b) No TLB flushes required
	2) Works on a per thread basis

PKS is available with 4 and 5 level paging.  Like PKRU it consumes 4 bits from
the PTE to store the pkey within the entry.


Use PKS to protect PMEM from stray writes
-----------------------------------------

DAX leverages the direct-map to enable 'struct page' services for PMEM.  Given
that PMEM capacity may be an order of magnitude higher capacity than System RAM
it presents a large vulnerability surface to stray writes.  Such a stray write
becomes a silent data corruption bug.

Given that PMEM access from the kernel is limited to a constrained set of
locations (PMEM driver, Filesystem-DAX, and direct-I/O), it is amenable to PKS
protection.  Set up an infrastructure for extra device access protection. Then
implement the protection using the new Protection Keys Supervisor (PKS) on
architectures which support it.

Because PMEM pages are all associated with a struct dev_pagemap the flag of
protecting memory can be stored there.  All PMEM is protected by the same pkey.
So a single flag is all that is needed to indicate protection.

General access in the kernel is supported by modifying the kmap infrastructure
which can detect if a page is PMEM and pks protected.  If so kmap_local_page()
and kmap_atomic() can enable access until their unmap's are called.

Because PKS is a thread local mechanism and because kmap was never really
intended to create a long term mapping,

This implementation avoids supporting the kmap()/kunmap() for a number of
reasons.  First, kmap was never really intended to create long term mappings.
Second, no known kernel users of pmem use kmap.  Third, PKS is a thread local
mechanism.

Originally this series modified many of the kmap call sites to indicate they
were thread local.[1]  And an attempt to support kmap()[2] was made.  But now
that kmap_local_page() has been developed[3] and in more wide spread use,
kmap() should be safe to leave unsupported and is considered an invalid access.

Handling invalid access to these pages is configurable via a new module
parameter memremap.pks_fault_mode.  2 modes are suported.

	'relaxed' (default) -- WARN_ONCE, disable the protection and allow
	                       access

	'strict' -- prevent any unguarded access to a protected dev_pagemap
		    range

The fault handler detects the PMEM fault and applies the above configuration to
the faulting thread.  The kmap call is a special case.  It is considered an
invalid access but uses the configuration early before any access such that the
kmap code path can be better evaluated and fixed.


[1] https://lore.kernel.org/lkml/20201009195033.3208459-1-ira.weiny@intel.com/

[2] https://lore.kernel.org/lkml/87mtycqcjf.fsf@nanos.tec.linutronix.de/

[3] https://lore.kernel.org/lkml/20210128061503.1496847-1-ira.weiny@intel.com/
    https://lore.kernel.org/lkml/20210210062221.3023586-1-ira.weiny@intel.com/
    https://lore.kernel.org/lkml/20210205170030.856723-1-ira.weiny@intel.com/
    https://lore.kernel.org/lkml/20210217024826.3466046-1-ira.weiny@intel.com/

[4] https://lore.kernel.org/lkml/20201106232908.364581-1-ira.weiny@intel.com/

[5] https://lore.kernel.org/lkml/20210322053020.2287058-1-ira.weiny@intel.com/

[6] https://lore.kernel.org/lkml/20210331191405.341999-1-ira.weiny@intel.com/


Fenghua Yu (1):
  x86/pks: Add PKS kernel API

Ira Weiny (16):
  x86/pkeys: Create pkeys_common.h
  x86/fpu: Refactor arch_set_user_pkey_access()
  x86/pks: Add additional PKEY helper macros
  x86/pks: Add PKS defines and Kconfig options
  x86/pks: Add PKS setup code
  x86/fault: Adjust WARN_ON for PKey fault
  x86/pks: Preserve the PKRS MSR on context switch
  x86/entry: Preserve PKRS MSR across exceptions
  x86/pks: Introduce pks_abandon_protections()
  x86/pks: Add PKS Test code
  memremap_pages: Add access protection via supervisor Protection Keys
    (PKS)
  memremap_pages: Add memremap.pks_fault_mode
  kmap: Add stray access protection for devmap pages
  dax: Stray access protection for dax_direct_access()
  nvdimm/pmem: Enable stray access protection
  devdax: Enable stray access protection

Rick Edgecombe (1):
  x86/pks: Add PKS fault callbacks

 .../admin-guide/kernel-parameters.txt         |  14 +
 Documentation/core-api/protection-keys.rst    | 153 +++-
 arch/x86/Kconfig                              |   1 +
 arch/x86/entry/calling.h                      |  26 +
 arch/x86/entry/common.c                       |  56 ++
 arch/x86/entry/entry_64.S                     |  22 +-
 arch/x86/entry/entry_64_compat.S              |   6 +-
 arch/x86/include/asm/cpufeatures.h            |   1 +
 arch/x86/include/asm/disabled-features.h      |   8 +-
 arch/x86/include/asm/msr-index.h              |   1 +
 arch/x86/include/asm/pgtable_types.h          |  12 +
 arch/x86/include/asm/pkeys.h                  |   2 +
 arch/x86/include/asm/pkeys_common.h           |  19 +
 arch/x86/include/asm/pkru.h                   |  16 +-
 arch/x86/include/asm/pks.h                    |  67 ++
 arch/x86/include/asm/processor-flags.h        |   2 +
 arch/x86/include/asm/processor.h              |  19 +-
 arch/x86/include/uapi/asm/processor-flags.h   |   2 +
 arch/x86/kernel/cpu/common.c                  |   2 +
 arch/x86/kernel/fpu/xstate.c                  |  22 +-
 arch/x86/kernel/head_64.S                     |   7 +-
 arch/x86/kernel/process.c                     |   3 +
 arch/x86/kernel/process_64.c                  |   3 +
 arch/x86/mm/fault.c                           |  82 +-
 arch/x86/mm/pkeys.c                           | 277 +++++-
 drivers/dax/device.c                          |   2 +
 drivers/dax/super.c                           |  54 ++
 drivers/md/dm-writecache.c                    |   8 +-
 drivers/nvdimm/pmem.c                         |  55 +-
 fs/dax.c                                      |   8 +
 fs/fuse/virtio_fs.c                           |   2 +
 include/linux/dax.h                           |   8 +
 include/linux/highmem-internal.h              |   5 +
 include/linux/memremap.h                      |   1 +
 include/linux/mm.h                            |  88 ++
 include/linux/pgtable.h                       |   4 +
 include/linux/pkeys.h                         |  36 +
 include/linux/sched.h                         |   7 +
 init/init_task.c                              |   3 +
 kernel/entry/common.c                         |  14 +-
 kernel/fork.c                                 |   3 +
 lib/Kconfig.debug                             |  13 +
 lib/Makefile                                  |   3 +
 lib/pks/Makefile                              |   3 +
 lib/pks/pks_test.c                            | 864 ++++++++++++++++++
 mm/Kconfig                                    |  26 +
 mm/memremap.c                                 | 158 ++++
 tools/testing/selftests/x86/Makefile          |   2 +-
 tools/testing/selftests/x86/test_pks.c        | 157 ++++
 49 files changed, 2261 insertions(+), 86 deletions(-)
 create mode 100644 arch/x86/include/asm/pkeys_common.h
 create mode 100644 arch/x86/include/asm/pks.h
 create mode 100644 lib/pks/Makefile
 create mode 100644 lib/pks/pks_test.c
 create mode 100644 tools/testing/selftests/x86/test_pks.c

-- 
2.28.0.rc0.12.gb6a658bd00c9

