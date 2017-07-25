Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by ml01.01.org (Postfix) with ESMTP id 353CB21C91254
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jul 2017 03:54:08 -0700 (PDT)
From: Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH 0/6] arm64 pmem support
Date: Tue, 25 Jul 2017 11:55:37 +0100
Message-Id: <cover.1500397441.git.robin.murphy@arm.com>
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
To: will.deacon@arm.com, catalin.marinas@arm.com
Cc: mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi all,

With the latest updates to the pmem API, the arch code contribution
becomes very straightforward to wire up - I think there's about as
much code here to just cope with the existence of our new instruction
as there is to actually make use of it. I don't have access to any
NVDIMMs nor suitable hardware to put them in, so this is written purely
to spec - the extent of testing has been the feature detection on a
v8.2 Fast Model vs. v8.0 systems.

Patch #1 could go in as a fix ahead of the rest; it just needs to come
before patch #5 to prevent that blowing up the build.

Robin.

Robin Murphy (6):
  arm64: mm: Fix set_memory_valid() declaration
  arm64: Convert __inval_cache_range() to area-based
  arm64: Expose DC CVAP to userspace
  arm64: Handle trapped DC CVAP
  arm64: Implement pmem API support
  arm64: uaccess: Implement *_flushcache variants

 Documentation/arm64/cpu-feature-registers.txt |  2 ++
 arch/arm64/Kconfig                            | 12 +++++++
 arch/arm64/include/asm/assembler.h            |  6 ++++
 arch/arm64/include/asm/cacheflush.h           |  4 ++-
 arch/arm64/include/asm/cpucaps.h              |  3 +-
 arch/arm64/include/asm/esr.h                  |  3 +-
 arch/arm64/include/asm/string.h               |  4 +++
 arch/arm64/include/asm/sysreg.h               |  1 +
 arch/arm64/include/asm/uaccess.h              | 12 +++++++
 arch/arm64/include/uapi/asm/hwcap.h           |  1 +
 arch/arm64/kernel/cpufeature.c                | 13 ++++++++
 arch/arm64/kernel/cpuinfo.c                   |  1 +
 arch/arm64/kernel/head.S                      | 18 +++++-----
 arch/arm64/kernel/traps.c                     |  3 ++
 arch/arm64/lib/Makefile                       |  2 ++
 arch/arm64/lib/uaccess_flushcache.c           | 47 +++++++++++++++++++++++++++
 arch/arm64/mm/cache.S                         | 37 ++++++++++++++++-----
 arch/arm64/mm/pageattr.c                      | 18 ++++++++++
 18 files changed, 166 insertions(+), 21 deletions(-)
 create mode 100644 arch/arm64/lib/uaccess_flushcache.c

-- 
2.12.2.dirty

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
