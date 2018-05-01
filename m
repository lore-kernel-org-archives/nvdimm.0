Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 767DE2007E7E3
 for <linux-nvdimm@lists.01.org>; Tue,  1 May 2018 13:55:06 -0700 (PDT)
Subject: [PATCH 0/6] use memcpy_mcsafe() for copy_to_iter()
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 01 May 2018 13:45:09 -0700
Message-ID: <152520750404.36522.15462513519590065300.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: tony.luck@intel.com, Peter Zijlstra <peterz@infradead.org>, x86@kernel.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

Currently memcpy_mcsafe() is only deployed in the pmem driver when
reading through a /dev/pmemX block device. However, a filesystem in dax
mode mounted on a /dev/pmemX block device will bypass the block layer
and the driver for reads. The filesystem-dax (fsdax) read case uses
dax_direct_access() and copy_to_iter() to bypass the block layer.

The result of the bypass is that the kernel treats machine checks during
read as system fatal (reboot) when they could simply be flagged as an
I/O error, similar to performing reads through the pmem driver. Prevent
this fatal condition by deploying memcpy_mcsafe() in the fsdax read
path.

The main differences between this copy_to_user_mcsafe() and
copy_user_generic_unrolled() are:

* Typical tail/residue handling after a fault retries the copy
  byte-by-byte until the fault happens again. Re-triggering machine
  checks is potentially fatal so the implementation uses source alignment
  and poison alignment assumptions to limit the residue copying to known
  good bytes.

* SMAP coordination is handled external to the assembly with
  __uaccess_begin() and __uaccess_end().

* ITER_KVEC and ITER_BVEC can now end prematurely with an error.

The new MCSAFE_DEBUG facility is proposed as a way to unit test the
exception handling without requiring an ACPI EINJ capable platform.

Thanks to Tony Luck for his review, test, and implementation ideas on
initial versions of this patchset.

---

Dan Williams (6):
      x86, memcpy_mcsafe: update labels in support of write fault handling
      x86, memcpy_mcsafe: return bytes remaining
      x86, memcpy_mcsafe: add write-protection-fault handling
      x86, memcpy_mcsafe: define copy_to_iter_mcsafe()
      dax: use copy_to_iter_mcsafe() in dax_iomap_actor()
      x86, nfit_test: unit test for memcpy_mcsafe()


 arch/x86/Kconfig.debug              |    3 +
 arch/x86/include/asm/mcsafe_debug.h |   50 ++++++++++
 arch/x86/include/asm/string_64.h    |    8 +-
 arch/x86/include/asm/uaccess_64.h   |   14 +++
 arch/x86/lib/memcpy_64.S            |  178 ++++++++++++++++++++++++++++-------
 arch/x86/lib/usercopy_64.c          |   12 ++
 drivers/nvdimm/claim.c              |    3 -
 drivers/nvdimm/pmem.c               |    6 +
 fs/dax.c                            |   20 ++--
 include/linux/string.h              |    4 -
 include/linux/uio.h                 |   10 ++
 lib/iov_iter.c                      |   59 ++++++++++++
 tools/testing/nvdimm/test/nfit.c    |   48 +++++++++
 13 files changed, 360 insertions(+), 55 deletions(-)
 create mode 100644 arch/x86/include/asm/mcsafe_debug.h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
