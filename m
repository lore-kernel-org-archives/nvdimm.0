Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F2534A1
	for <nvdimm@lists.linux.dev>; Wed,  4 Aug 2021 04:32:44 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="299433077"
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="299433077"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:38 -0700
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="511702717"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:38 -0700
From: ira.weiny@intel.com
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>,
	Dave Hansen <dave.hansen@intel.com>,
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
Subject: [PATCH V7 15/18] kmap: Add stray access protection for devmap pages
Date: Tue,  3 Aug 2021 21:32:28 -0700
Message-Id: <20210804043231.2655537-16-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
In-Reply-To: <20210804043231.2655537-1-ira.weiny@intel.com>
References: <20210804043231.2655537-1-ira.weiny@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

Enable PKS protection for devmap pages.  The devmap protection facility
wants to co-opt kmap_{local_page,atomic}() to mediate access to PKS
protected pages.

kmap() allows for global mappings to be established, while the PKS
facility depends on thread-local access. For this reason kmap() is not
supported, but it leaves a policy decision for what to do when kmap()
is attempted on a protected devmap page.

Neither of the 2 current DAX-capable filesystems (ext4 and xfs) perform
such global mappings.  The bulk of device drivers that would handle
devmap pages are not using kmap().  Any future filesystems that gain DAX
support, or device drivers wanting to support devmap protected pages
will need to move to kmap_local_page().  In the meantime to handle these
kmap() users call pgmap_protection_flag_invalid() to flag and invalid
use of any potentially protected pages.  This allows better debugging of
invalided uses vs catching faults later on when the address is used.

Direct-map exposure is already mitigated by default on HIGHMEM systems
because by definition HIGHMEM systems do not have large capacities of
memory in the direct map.  Therefore, to reduce complexity HIGHMEM
systems are not supported.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 include/linux/highmem-internal.h | 5 +++++
 mm/Kconfig                       | 1 +
 2 files changed, 6 insertions(+)

diff --git a/include/linux/highmem-internal.h b/include/linux/highmem-internal.h
index 7902c7d8b55f..f88bc14a643b 100644
--- a/include/linux/highmem-internal.h
+++ b/include/linux/highmem-internal.h
@@ -142,6 +142,7 @@ static inline struct page *kmap_to_page(void *addr)
 static inline void *kmap(struct page *page)
 {
 	might_sleep();
+	pgmap_protection_flag_invalid(page);
 	return page_address(page);
 }
 
@@ -157,6 +158,7 @@ static inline void kunmap(struct page *page)
 
 static inline void *kmap_local_page(struct page *page)
 {
+	pgmap_mk_readwrite(page);
 	return page_address(page);
 }
 
@@ -175,12 +177,14 @@ static inline void __kunmap_local(void *addr)
 #ifdef ARCH_HAS_FLUSH_ON_KUNMAP
 	kunmap_flush_on_unmap(addr);
 #endif
+	pgmap_mk_noaccess(kmap_to_page(addr));
 }
 
 static inline void *kmap_atomic(struct page *page)
 {
 	preempt_disable();
 	pagefault_disable();
+	pgmap_mk_readwrite(page);
 	return page_address(page);
 }
 
@@ -199,6 +203,7 @@ static inline void __kunmap_atomic(void *addr)
 #ifdef ARCH_HAS_FLUSH_ON_KUNMAP
 	kunmap_flush_on_unmap(addr);
 #endif
+	pgmap_mk_noaccess(kmap_to_page(addr));
 	pagefault_enable();
 	preempt_enable();
 }
diff --git a/mm/Kconfig b/mm/Kconfig
index 201d41269a36..4184d0a7531d 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -794,6 +794,7 @@ config DEVMAP_ACCESS_PROTECTION
 	bool "Access protection for memremap_pages()"
 	depends on NVDIMM_PFN
 	depends on ARCH_HAS_SUPERVISOR_PKEYS
+	depends on !HIGHMEM
 	select GENERAL_PKS_USER
 	default y
 
-- 
2.28.0.rc0.12.gb6a658bd00c9

