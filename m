Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 1DEFD1A1E43
 for <linux-nvdimm@lists.01.org>; Sat,  4 Jun 2016 13:53:36 -0700 (PDT)
Subject: [PATCH 00/13] deprecate pcommit
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 04 Jun 2016 13:52:32 -0700
Message-ID: <146507355220.8347.12117020810872172684.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org, david@fromorbit.com, Adrian Hunter <adrian.hunter@intel.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, linux-kernel@vger.kernel.org, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Platforms supporting NVDIMMs are now required to provide persistence
guarantees once pmem stores are accepted by the memory subsystem.  This
is usually achieved by a platform-level feature known as ADR
(Asynchronous DRAM Refresh) that flushes any memory subsystem write
pending queues on power loss/shutdown.

The 'pcommit' instruction (which has not shipped on any product) is no
longer needed and is deprecated.

---

Dan Williams (13):
      driver core, libnvdimm: disable manual unbind of dimms while region active
      nfit: always associate flush hints
      libnvdimm: introduce nvdimm_flush()
      libnvdimm, nfit: move flush hint mapping to dimm driver
      tools/testing/nvdimm: simulate multiple flush hints per-dimm
      libnvdimm: cycle flush hints per-cpu
      libnvdimm, pmem: use REQ_FUA, REQ_FLUSH for nvdimm_flush()
      fs/dax: remove wmb_pmem()
      libnvdimm, pmem: use nvdimm_flush() for namespace I/O writes
      pmem: kill wmb_pmem()
      Revert "KVM: x86: add pcommit support"
      x86/insn: remove pcommit
      pmem: kill __pmem address space


 Documentation/filesystems/Locking                  |    2 
 arch/powerpc/sysdev/axonram.c                      |    4 -
 arch/x86/include/asm/cpufeatures.h                 |    1 
 arch/x86/include/asm/pmem.h                        |   77 +++----------
 arch/x86/include/asm/special_insns.h               |   46 --------
 arch/x86/include/asm/vmx.h                         |    1 
 arch/x86/include/uapi/asm/vmx.h                    |    4 -
 arch/x86/kvm/cpuid.c                               |    2 
 arch/x86/kvm/cpuid.h                               |    8 -
 arch/x86/kvm/vmx.c                                 |   32 +----
 arch/x86/lib/x86-opcode-map.txt                    |    2 
 drivers/acpi/nfit.c                                |  106 +++++++++++-------
 drivers/acpi/nfit.h                                |    3 -
 drivers/base/base.h                                |    1 
 drivers/base/bus.c                                 |   12 ++
 drivers/base/core.c                                |    1 
 drivers/base/dd.c                                  |    2 
 drivers/block/brd.c                                |    4 -
 drivers/nvdimm/claim.c                             |    2 
 drivers/nvdimm/dimm.c                              |    7 +
 drivers/nvdimm/dimm_devs.c                         |   27 ++++-
 drivers/nvdimm/namespace_devs.c                    |    1 
 drivers/nvdimm/nd-core.h                           |    1 
 drivers/nvdimm/nd.h                                |   15 +++
 drivers/nvdimm/pmem.c                              |   44 +++++---
 drivers/nvdimm/region_devs.c                       |   74 ++++++++++++-
 drivers/s390/block/dcssblk.c                       |    6 +
 fs/dax.c                                           |   13 +-
 include/linux/blkdev.h                             |    6 +
 include/linux/compiler.h                           |    2 
 include/linux/device.h                             |   20 +++
 include/linux/libnvdimm.h                          |   10 ++
 include/linux/nd.h                                 |    2 
 include/linux/pmem.h                               |  117 ++++----------------
 scripts/checkpatch.pl                              |    1 
 tools/objtool/arch/x86/insn/x86-opcode-map.txt     |    2 
 tools/perf/arch/x86/tests/insn-x86-dat-32.c        |    2 
 tools/perf/arch/x86/tests/insn-x86-dat-64.c        |    2 
 tools/perf/arch/x86/tests/insn-x86-dat-src.c       |    4 -
 .../perf/util/intel-pt-decoder/x86-opcode-map.txt  |    2 
 tools/testing/nvdimm/test/nfit.c                   |   55 ++++++---
 41 files changed, 357 insertions(+), 366 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
