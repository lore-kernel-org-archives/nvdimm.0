Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com
 [15.241.140.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 20E101A1E2A
 for <linux-nvdimm@lists.01.org>; Wed, 26 Oct 2016 08:51:53 -0700 (PDT)
From: Brian Boylston <brian.boylston@hpe.com>
Subject: [PATCH v2 0/3] use nocache copy in copy_from_iter_nocache()
Date: Wed, 26 Oct 2016 10:50:18 -0500
Message-Id: <20161026155021.20892-1-brian.boylston@hpe.com>
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
To: linux-nvdimm@lists.01.org
Cc: oliver.moreno@hpe.com, x86@kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>

Currently, copy_from_iter_nocache() uses "nocache" copies only for
iovecs; bvecs and kvecs use normal copies.  This requires
x86's arch_copy_from_iter_pmem() to issue flushes for bvecs and kvecs,
which has a negative impact on performance when splice()ing from a pipe
to a pmem-backed file on a DAX-mounted file system.

This patch set enables nocache copies in copy_from_iter_nocache() for
bvecs and kvecs for arches that support it (x86 initially).  This provides
a 2-3X improvement in splice() pipe-to-DAX-file throughput.

The first patch introduces memcpy_nocache(), which defaults to just
memcpy(), but for which an x86-specific implementation is provided.

For this patch, I sought to use a static inline function for x86, but
I could not find an obvious header file to put it in.
The build seemed to work when I put it in arch/x86/include/asm/uaccess.h,
but that didn't feel completely right.  I also tried
arch/x86/include/asm/pmem.h, but that doesn't feel right either and it
didn't build.  So, I offer it here in arch/x86/lib/misc.c for discussion.

The second patch updates copy_from_iter_nocache() to use the new
memcpy_nocache().

The third patch removes the flushes from x86's arch_copy_from_iter_pmem().

For testing, I ran fio with the posixaio, mmap, sync, psync, vsync, pvsync,
and splice engines, against both ext4 and xfs.  Only the splice engine
showed any change in performance.  For example, for xfs:

Unpatched 4.8:

Run status group 2 (all jobs):
  WRITE: io=37602MB, aggrb=641724KB/s, minb=641724KB/s, maxb=641724KB/s, mint=60001msec, maxt=60001msec

Run status group 3 (all jobs):
  WRITE: io=36244MB, aggrb=618553KB/s, minb=618553KB/s, maxb=618553KB/s, mint=60001msec, maxt=60001msec

With this patch set:

Run status group 2 (all jobs):
  WRITE: io=128055MB, aggrb=2134.3MB/s, minb=2134.3MB/s, maxb=2134.3MB/s, mint=60001msec, maxt=60001msec

Run status group 3 (all jobs):
  WRITE: io=122586MB, aggrb=2043.8MB/s, minb=2043.8MB/s, maxb=2043.8MB/s, mint=60001msec, maxt=60001msec

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <x86@kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Brian Boylston <brian.boylston@hpe.com>
Reviewed-by: Toshi Kani <toshi.kani@hpe.com>
Reported-by: Oliver Moreno <oliver.moreno@hpe.com>

Changes in v2:
  - Split into multiple patches (Toshi Kani)
  - Introduce memcpy_nocache() (Al Viro)
  - Use nocache for kvecs as well

Brian Boylston (3):
  introduce memcpy_nocache()
  use a nocache copy for bvecs and kvecs in copy_from_iter_nocache()
  x86: remove unneeded flush in arch_copy_from_iter_pmem()

 arch/x86/include/asm/pmem.h      | 19 +------------------
 arch/x86/include/asm/string_32.h |  3 +++
 arch/x86/include/asm/string_64.h |  3 +++
 arch/x86/lib/misc.c              | 12 ++++++++++++
 include/linux/string.h           | 15 +++++++++++++++
 lib/iov_iter.c                   | 14 +++++++++++---
 6 files changed, 45 insertions(+), 21 deletions(-)

-- 
2.8.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
