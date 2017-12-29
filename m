Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8B6C62034B42F
 for <linux-nvdimm@lists.01.org>; Thu, 28 Dec 2017 23:49:29 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/17] mm: don't export arch_add_memory
Date: Fri, 29 Dec 2017 08:53:51 +0100
Message-Id: <20171229075406.1936-3-hch@lst.de>
In-Reply-To: <20171229075406.1936-1-hch@lst.de>
References: <20171229075406.1936-1-hch@lst.de>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, x86@kernel.org, linux-kernel@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, linuxppc-dev@lists.ozlabs.org
List-ID: <linux-nvdimm@lists.01.org>

Only x86_64 and sh export this symbol, and it is not used by any
modular code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/sh/mm/init.c     | 1 -
 arch/x86/mm/init_64.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index bf726af5f1a5..afc54d593a26 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -498,7 +498,6 @@ int arch_add_memory(int nid, u64 start, u64 size, bool want_memblock)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(arch_add_memory);
 
 #ifdef CONFIG_NUMA
 int memory_add_physaddr_to_nid(u64 addr)
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 4a837289f2ad..8acdc35c2dfa 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -796,7 +796,6 @@ int arch_add_memory(int nid, u64 start, u64 size, bool want_memblock)
 
 	return add_pages(nid, start_pfn, nr_pages, want_memblock);
 }
-EXPORT_SYMBOL_GPL(arch_add_memory);
 
 #define PAGE_INUSE 0xFD
 
-- 
2.14.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
