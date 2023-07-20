Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBEC168D9
	for <nvdimm@lists.linux.dev>; Thu, 20 Jul 2023 07:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689837272; x=1721373272;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=Xs/UipfGvLxTajC0Rm3FutNPJhFtxOc43qHe7lqOerY=;
  b=bUeN6fN0cv7YOcO3ih7DI1fIE0P6Awzp+LlCOwXLxfWzIhl95xLbTgCZ
   VBbx7Y4/8+YExshfqn17POQLsdFp5OtfaeF8kQLsSlWvPnigHzQa8Aa2T
   MMy2poFQHQticz/IU30cs+tJQw6N/NaQNUyxweYmbwTTv3u5klQ7BzDYU
   P15trxOdCdZAAYnzpfi0VFV3QxWef0R+b5xgeJsW9rWHNAATW77QkDKoc
   580eDLLQ1sMdgDIYKiY5VBvppEs7Nm0b2anVlEiJ9n6FHZiNgztKvZbU7
   VJ8TlPTrr3UG0vTHGffpJ512aeSUpLGEOUzN0U319+4tHeFQw8PLQNC4G
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="430423997"
X-IronPort-AV: E=Sophos;i="6.01,218,1684825200"; 
   d="scan'208";a="430423997"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 00:14:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="794334963"
X-IronPort-AV: E=Sophos;i="6.01,218,1684825200"; 
   d="scan'208";a="794334963"
Received: from mfgalan-mobl1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.213.172.204])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 00:14:29 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Thu, 20 Jul 2023 01:14:22 -0600
Subject: [PATCH v2 1/3] mm/memory_hotplug: Export symbol
 mhp_supports_memmap_on_memory()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230720-vv-kmem_memmap-v2-1-88bdaab34993@intel.com>
References: <20230720-vv-kmem_memmap-v2-0-88bdaab34993@intel.com>
In-Reply-To: <20230720-vv-kmem_memmap-v2-0-88bdaab34993@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
 Huang Ying <ying.huang@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, 
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>, 
 Jeff Moyer <jmoyer@redhat.com>, Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1866;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=Xs/UipfGvLxTajC0Rm3FutNPJhFtxOc43qHe7lqOerY=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDCk77l05/3bRlO0HRGt3l/1Y+qNe3Wzlkv+flP2CnC4d+
 27Ly+NwoaOUhUGMi0FWTJHl756PjMfktufzBCY4wsxhZQIZwsDFKQATub2SkaFxwmNetUNtifs0
 jJyK+GWuXObfuVZ0f0vNtFhNozqZlQyMDPfzRPRPe0x/19WUOsF+g+UCnWtP3jSX3VjY1NJxc8p
 rIzYA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

In preparation for dax drivers, which can be built as modules,
to use this interface, export it with EXPORT_SYMBOL_GPL(). Add a #else
case for the symbol for builds without CONFIG_MEMORY_HOTPLUG.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 include/linux/memory_hotplug.h | 5 +++++
 mm/memory_hotplug.c            | 1 +
 2 files changed, 6 insertions(+)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 013c69753c91..fc5da07ad011 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -355,6 +355,11 @@ extern int arch_create_linear_mapping(int nid, u64 start, u64 size,
 				      struct mhp_params *params);
 void arch_remove_linear_mapping(u64 start, u64 size);
 extern bool mhp_supports_memmap_on_memory(unsigned long size);
+#else
+static inline bool mhp_supports_memmap_on_memory(unsigned long size)
+{
+	return false;
+}
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 3f231cf1b410..e9bcacbcbae2 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1284,6 +1284,7 @@ bool mhp_supports_memmap_on_memory(unsigned long size)
 	       IS_ALIGNED(vmemmap_size, PMD_SIZE) &&
 	       IS_ALIGNED(remaining_size, (pageblock_nr_pages << PAGE_SHIFT));
 }
+EXPORT_SYMBOL_GPL(mhp_supports_memmap_on_memory);
 
 /*
  * NOTE: The caller must call lock_device_hotplug() to serialize hotplug

-- 
2.41.0

