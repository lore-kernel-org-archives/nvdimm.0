Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 6BD5B1A2288
 for <linux-nvdimm@lists.01.org>; Fri, 15 Apr 2016 14:33:51 -0700 (PDT)
Date: Fri, 15 Apr 2016 15:32:21 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [GIT PULL] libnvdimm fixes for v4.6-rc4
Message-ID: <20160415213221.GB16052@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

to receive 2 fixes.

1) Fix memcpy_from_pmem() to fallback to memcpy() for architectures where
CONFIG_ARCH_HAS_PMEM_API=n.

2) Add a comment explaining why we write data twice when clearing poison in
pmem_do_bvec().

This has passed a boot test on an X86_32 config.  This was the architecture
where issue #1 above was first noticed.

----------------------------------------------------------------
Dan Williams (1):
	  libnvdimm, pmem: clarify the write+clear_poison+write flow

Toshi Kani (1):
	  pmem: fix BUG() error in pmem.h:48 on X86_32

 drivers/nvdimm/pmem.c | 14 ++++++++++++++
 include/linux/pmem.h  | 22 ++++++++++++++++------
 2 files changed, 30 insertions(+), 6 deletions(-)

commit 0a370d261c805286cbdfa1f96661322a28cce860
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Apr 14 19:40:47 2016 -0700

	libnvdimm, pmem: clarify the write+clear_poison+write flow
    
	The ACPI specification does not specify the state of data after a clear
	poison operation.  Potential future libnvdimm bus implementations for
	other architectures also might not specify or disagree on the state of
	data after clear poison.  Clarify why we write twice.
    
	Reported-by: Jeff Moyer <jmoyer@redhat.com>
	Reported-by: Vishal Verma <vishal.l.verma@intel.com>
	Signed-off-by: Dan Williams <dan.j.williams@intel.com>
	Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
	Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
	Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
	Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 8e09c54..f798899 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -103,6 +103,20 @@ static int pmem_do_bvec(struct pmem_device *pmem, struct page *page,
 			flush_dcache_page(page);
 		}
 	} else {
+		/*
+		 * Note that we write the data both before and after
+		 * clearing poison.  The write before clear poison
+		 * handles situations where the latest written data is
+		 * preserved and the clear poison operation simply marks
+		 * the address range as valid without changing the data.
+		 * In this case application software can assume that an
+		 * interrupted write will either return the new good
+		 * data or an error.
+		 *
+		 * However, if pmem_clear_poison() leaves the data in an
+		 * indeterminate state we need to perform the write
+		 * after clear poison.
+		 */
 		flush_dcache_page(page);
 		memcpy_to_pmem(pmem_addr, mem + off, len);
 		if (unlikely(bad_pmem)) {

commit cba2e47abcbd80e3f46f460899290402f98090ec
Author: Toshi Kani <toshi.kani@hpe.com>
Date:   Tue Apr 12 18:10:52 2016 -0600

	pmem: fix BUG() error in pmem.h:48 on X86_32
    
	After 'commit fc0c2028135c ("x86, pmem: use memcpy_mcsafe()
	for memcpy_from_pmem()")', probing a PMEM device hits the BUG()
	error below on X86_32 kernel.
    
	 kernel BUG at include/linux/pmem.h:48!
    
	memcpy_from_pmem() calls arch_memcpy_from_pmem(), which is
	unimplemented since CONFIG_ARCH_HAS_PMEM_API is undefined on
	X86_32.
    
	Fix the BUG() error by adding default_memcpy_from_pmem().
    
	Acked-by: Dan Williams <dan.j.williams@intel.com>
	Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
	Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
	Cc: Dan Williams <dan.j.williams@intel.com>
	Cc: Ross Zwisler <ross.zwisler@linux.intel.com>

diff --git a/include/linux/pmem.h b/include/linux/pmem.h
index ac6d872..57d146f 100644
--- a/include/linux/pmem.h
+++ b/include/linux/pmem.h
@@ -72,6 +72,18 @@ static inline void arch_invalidate_pmem(void __pmem *addr, size_t size)
 }
 #endif
 
+static inline bool arch_has_pmem_api(void)
+{
+	return IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API);
+}
+
+static inline int default_memcpy_from_pmem(void *dst, void __pmem const *src,
+		size_t size)
+{
+	memcpy(dst, (void __force *) src, size);
+	return 0;
+}
+
 /*
  * memcpy_from_pmem - read from persistent memory with error handling
  * @dst: destination buffer
@@ -83,12 +95,10 @@ static inline void arch_invalidate_pmem(void __pmem *addr, size_t size)
 static inline int memcpy_from_pmem(void *dst, void __pmem const *src,
 		size_t size)
 {
-	return arch_memcpy_from_pmem(dst, src, size);
-}
-
-static inline bool arch_has_pmem_api(void)
-{
-	return IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API);
+	if (arch_has_pmem_api())
+		return arch_memcpy_from_pmem(dst, src, size);
+	else
+		return default_memcpy_from_pmem(dst, src, size);
 }
 
 /**
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
