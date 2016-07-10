Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id D4B761A1E10
 for <linux-nvdimm@lists.01.org>; Sat,  9 Jul 2016 20:27:23 -0700 (PDT)
Subject: [PATCH v2 00/17] replace pcommit with ADR or directed flushing
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 09 Jul 2016 20:24:29 -0700
Message-ID: <146812106839.32932.2870621200867047059.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, x86@kernel.org, linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>, linux-acpi@vger.kernel.org, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, linux-fsdevel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Changes since v1 [1]:

1/ Move flush address data from nvdimm_drvdata to nd_region_data (Greg,
   Toshi)

2/ Add more detail to cover letter and patch descriptions (Linda, Jeff)

3/ Account for s/REQ_FLUSH/REQ_PREFLUSH/ rename pending in -next.

4/ Add a directed flush at pmem ->remove() and ->shutdown() time.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2016-June/005897.html

---

The pcommit instruction, which has not shipped on any product, is
deprecated. Instead, the expectation is that platforms implement either
ADR, or provide one or more flush addresses per nvdimm. ADR
(Asynchronous DRAM Refresh) flushes data in posted write buffers to the
memory controller on a power-fail event. Flush addresses are defined in
ACPI 6.x as an NVDIMM Firmware Interface Table (NFIT) sub-structure:
"Flush Hint Address Structure". A flush hint is an mmio address that
when written and fenced assures that all previous posted writes
targeting a given dimm have been flushed to media.

Code paths that previously called wmb_pmem() instead must arrange for a
flush request to be sent to the pmem driver. Towards this end, the pmem
driver is converted to advertise itself as having a write cache to
indicate to a filesystem that a flush request must occur before writes
are guaranteed to be on media.  See "[PATCH v2 08/17] libnvdimm:
introduce nvdimm_flush() and nvdimm_has_flush()" for details.

---

Dan Williams (17):
      nfit: always associate flush hints
      nfit: don't override return value of nfit_mem_init
      libnvdimm: introduce devm_nvdimm_memremap(), convert nfit_spa_map() users
      libnvdimm, nfit: remove nfit_spa_map() infrastructure
      libnvdimm, nfit: move flush hint mapping to region-device driver-data
      tools/testing/nvdimm: simulate multiple flush hints per-dimm
      libnvdimm: keep region data alive over namespace removal
      libnvdimm: introduce nvdimm_flush() and nvdimm_has_flush()
      libnvdimm: cycle flush hints
      libnvdimm, pmem: use REQ_FUA, REQ_FLUSH for nvdimm_flush()
      libnvdimm, pmem: flush posted-write queues on shutdown
      fs/dax: remove wmb_pmem()
      libnvdimm, pmem: use nvdimm_flush() for namespace I/O writes
      pmem: kill wmb_pmem()
      Revert "KVM: x86: add pcommit support"
      x86/insn: remove pcommit
      pmem: kill __pmem address space


 Documentation/filesystems/Locking                  |    2 
 arch/powerpc/sysdev/axonram.c                      |    4 
 arch/x86/include/asm/cpufeatures.h                 |    1 
 arch/x86/include/asm/pmem.h                        |   77 ++-----
 arch/x86/include/asm/special_insns.h               |   46 ----
 arch/x86/include/asm/vmx.h                         |    1 
 arch/x86/include/uapi/asm/vmx.h                    |    4 
 arch/x86/kvm/cpuid.c                               |    2 
 arch/x86/kvm/cpuid.h                               |    8 -
 arch/x86/kvm/vmx.c                                 |   32 ---
 arch/x86/lib/x86-opcode-map.txt                    |    2 
 drivers/acpi/nfit.c                                |  230 +++-----------------
 drivers/acpi/nfit.h                                |   25 --
 drivers/block/brd.c                                |    4 
 drivers/nvdimm/bus.c                               |   16 +
 drivers/nvdimm/claim.c                             |    2 
 drivers/nvdimm/core.c                              |  122 +++++++++++
 drivers/nvdimm/dimm_devs.c                         |    5 
 drivers/nvdimm/nd-core.h                           |    4 
 drivers/nvdimm/nd.h                                |   10 +
 drivers/nvdimm/pmem.c                              |   59 ++++-
 drivers/nvdimm/pmem.h                              |    4 
 drivers/nvdimm/region.c                            |   19 +-
 drivers/nvdimm/region_devs.c                       |  148 ++++++++++++-
 drivers/s390/block/dcssblk.c                       |    6 -
 fs/dax.c                                           |   13 -
 include/linux/blkdev.h                             |    6 -
 include/linux/compiler.h                           |    2 
 include/linux/libnvdimm.h                          |   16 +
 include/linux/nd.h                                 |    3 
 include/linux/pmem.h                               |  117 ++--------
 scripts/checkpatch.pl                              |    1 
 tools/objtool/arch/x86/insn/x86-opcode-map.txt     |    2 
 tools/perf/arch/x86/tests/insn-x86-dat-32.c        |    2 
 tools/perf/arch/x86/tests/insn-x86-dat-64.c        |    2 
 tools/perf/arch/x86/tests/insn-x86-dat-src.c       |    4 
 .../perf/util/intel-pt-decoder/x86-opcode-map.txt  |    2 
 tools/testing/nvdimm/pmem-dax.c                    |    2 
 tools/testing/nvdimm/test/nfit.c                   |   55 +++--
 39 files changed, 505 insertions(+), 555 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
