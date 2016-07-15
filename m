Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from invmail3.skhynix.com (exvmail3.skhynix.com [166.125.252.90])
 by ml01.01.org (Postfix) with ESMTP id 0782D1A1EC9
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jul 2016 19:47:21 -0700 (PDT)
From: Kwangwoo Lee <kwangwoo.lee@sk.com>
Subject: [PATCH v3 0/3]  support pmem on arm64
Date: Fri, 15 Jul 2016 11:46:19 +0900
Message-Id: <1468550782-14454-1-git-send-email-kwangwoo.lee@sk.com>
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
To: linux-arm-kernel@lists.infradead.org, linux-nvdimm@lists.01.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Cc: Kwangwoo Lee <kwangwoo.lee@sk.com>, linux-kernel@vger.kernel.org, Woosuk Chung <woosuk.chung@sk.com>
List-ID: <linux-nvdimm@lists.01.org>

This patch set add supporting the pmem driver on arm64 architecture which
can be used on NVDIMM(Non-Volatile DIMM). It has been tested on QEMU with
NVDIMM ACPI/NFIT support on AArch64 VIRT platform.

Until the changes of pmem codes posted to nvdimm list is merged which assums
supporting ADR(Asynchronous DRAM Refresh) or direct flushing based on the
flush hint provided by ACPI/NFIT, this pmem implementation on arm64 can be
a solution to evaluate pmem on arm64 architecture.

Change log:

v3)
do not use a access helper in arch_memcpy_to_pmem().
split cache related codes with different patch set.
fix some comments in pmem.h.

v2)
rewrite functions under the mapping information MEMREMAP_WB.
rewrite the comments for arm64 in pmem.h
add __clean_dcache_area() to clean the cache lines to the PoC.

v1)
add pmem support codes.

Kwangwoo Lee (3):
  arm64: mm: add __clean_dcache_area()
  arm64: mm: add mmio_flush_range() to support pmem
  arm64: pmem: add pmem support codes

 arch/arm64/Kconfig                  |   2 +
 arch/arm64/include/asm/cacheflush.h |   3 +
 arch/arm64/include/asm/pmem.h       | 143 ++++++++++++++++++++++++++++++++++++
 arch/arm64/mm/cache.S               |  18 +++++
 4 files changed, 166 insertions(+)
 create mode 100644 arch/arm64/include/asm/pmem.h

-- 
2.5.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
