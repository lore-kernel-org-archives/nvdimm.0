Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com
 [IPv6:2607:f8b0:4864:20::643])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 80E592112500D
 for <linux-nvdimm@lists.01.org>; Mon, 10 Sep 2018 16:43:43 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id u11-v6so10451422plq.5
 for <linux-nvdimm@lists.01.org>; Mon, 10 Sep 2018 16:43:43 -0700 (PDT)
Subject: [PATCH 1/4] mm: Provide kernel parameter to allow disabling page
 init poisoning
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Mon, 10 Sep 2018 16:43:41 -0700
Message-ID: <20180910234341.4068.26882.stgit@localhost.localdomain>
In-Reply-To: <20180910232615.4068.29155.stgit@localhost.localdomain>
References: <20180910232615.4068.29155.stgit@localhost.localdomain>
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
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: pavel.tatashin@microsoft.com, mhocko@suse.com, dave.hansen@intel.com, jglisse@redhat.com, akpm@linux-foundation.org, mingo@kernel.org, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

From: Alexander Duyck <alexander.h.duyck@intel.com>

On systems with a large amount of memory it can take a significant amount
of time to initialize all of the page structs with the PAGE_POISON_PATTERN
value. I have seen it take over 2 minutes to initialize a system with
over 12GB of RAM.

In order to work around the issue I had to disable CONFIG_DEBUG_VM and then
the boot time returned to something much more reasonable as the
arch_add_memory call completed in milliseconds versus seconds. However in
doing that I had to disable all of the other VM debugging on the system.

In order to work around a kernel that might have CONFIG_DEBUG_VM enabled on
a system that has a large amount of memory I have added a new kernel
parameter named "page_init_poison" that can be set to "off" in order to
disable it.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---
 Documentation/admin-guide/kernel-parameters.txt |    8 ++++++++
 include/linux/page-flags.h                      |    8 ++++++++
 mm/debug.c                                      |   16 ++++++++++++++++
 mm/memblock.c                                   |    5 ++---
 mm/sparse.c                                     |    4 +---
 5 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 64a3bf54b974..7b21e0b9c394 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3047,6 +3047,14 @@
 			off: turn off poisoning (default)
 			on: turn on poisoning
 
+	page_init_poison=	[KNL] Boot-time parameter changing the
+			state of poisoning of page structures during early
+			boot. Used to verify page metadata is not accessed
+			prior to initialization. Available with
+			CONFIG_DEBUG_VM=y.
+			off: turn off poisoning
+			on: turn on poisoning (default)
+
 	panic=		[KNL] Kernel behaviour on panic: delay <timeout>
 			timeout > 0: seconds before rebooting
 			timeout = 0: wait forever
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 74bee8cecf4c..d00216cf00f8 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -162,6 +162,14 @@ static inline int PagePoisoned(const struct page *page)
 	return page->flags == PAGE_POISON_PATTERN;
 }
 
+#ifdef CONFIG_DEBUG_VM
+void page_init_poison(struct page *page, size_t size);
+#else
+static inline void page_init_poison(struct page *page, size_t size)
+{
+}
+#endif
+
 /*
  * Page flags policies wrt compound pages
  *
diff --git a/mm/debug.c b/mm/debug.c
index 38c926520c97..c5420422c0b5 100644
--- a/mm/debug.c
+++ b/mm/debug.c
@@ -175,4 +175,20 @@ void dump_mm(const struct mm_struct *mm)
 	);
 }
 
+static bool page_init_poisoning __read_mostly = true;
+
+static int __init page_init_poison_param(char *buf)
+{
+	if (!buf)
+		return -EINVAL;
+	return strtobool(buf, &page_init_poisoning);
+}
+early_param("page_init_poison", page_init_poison_param);
+
+void page_init_poison(struct page *page, size_t size)
+{
+	if (page_init_poisoning)
+		memset(page, PAGE_POISON_PATTERN, size);
+}
+EXPORT_SYMBOL_GPL(page_init_poison);
 #endif		/* CONFIG_DEBUG_VM */
diff --git a/mm/memblock.c b/mm/memblock.c
index 237944479d25..a85315083b5a 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1444,10 +1444,9 @@ void * __init memblock_virt_alloc_try_nid_raw(
 
 	ptr = memblock_virt_alloc_internal(size, align,
 					   min_addr, max_addr, nid);
-#ifdef CONFIG_DEBUG_VM
 	if (ptr && size > 0)
-		memset(ptr, PAGE_POISON_PATTERN, size);
-#endif
+		page_init_poison(ptr, size);
+
 	return ptr;
 }
 
diff --git a/mm/sparse.c b/mm/sparse.c
index 10b07eea9a6e..67ad061f7fb8 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -696,13 +696,11 @@ int __meminit sparse_add_one_section(struct pglist_data *pgdat,
 		goto out;
 	}
 
-#ifdef CONFIG_DEBUG_VM
 	/*
 	 * Poison uninitialized struct pages in order to catch invalid flags
 	 * combinations.
 	 */
-	memset(memmap, PAGE_POISON_PATTERN, sizeof(struct page) * PAGES_PER_SECTION);
-#endif
+	page_init_poison(memmap, sizeof(struct page) * PAGES_PER_SECTION);
 
 	section_mark_present(ms);
 	sparse_init_one_section(ms, section_nr, memmap, usemap);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
