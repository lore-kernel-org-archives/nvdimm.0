Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCBD1772D
	for <nvdimm@lists.linux.dev>; Thu, 15 Jun 2023 22:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686866465; x=1718402465;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=U9rnqtpmVZUt30zvfvx/p0VOOSSlAU3FkBQboHUpz0E=;
  b=NpiiJP8H3KMuqGIC9ccjeHAPUbuuOFMMS98t1b8+7F+rr/3Rqse/iVe0
   3Y1gS1h9wwTrZyMmPd7a5YF1KLpOoXsNBuf+5jwgSjHxlnjhh0JrotDX4
   vxteu/YK5eut6MBDWb9o7PH9jQBt1RK2hJuPPqp6YZv+gcMXMMDncIwHG
   bT4ZltmFGtRpNb6XQ8f4uwljQPSTqWieX6YSUlZPLjUNH7yy3Jez1AhKf
   1H9LZ13IxNPIpEvr2AifyHognm+r4ymIcnOF/6Nu9Jq8EkK5GNed60BMq
   1aV2ZUK6+C4VeRWupLgG1uS6TdjaH6RD29VlyW8xTZmncxBhn3+K7yTkH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="343791142"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="343791142"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 15:01:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="715770100"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="715770100"
Received: from smaurice-mobl.amr.corp.intel.com (HELO [192.168.1.200]) ([10.212.120.175])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 15:01:01 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Thu, 15 Jun 2023 16:00:24 -0600
Subject: [PATCH 2/3] mm/memory_hotplug: Export symbol
 mhp_supports_memmap_on_memory()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230613-vv-kmem_memmap-v1-2-f6de9c6af2c6@intel.com>
References: <20230613-vv-kmem_memmap-v1-0-f6de9c6af2c6@intel.com>
In-Reply-To: <20230613-vv-kmem_memmap-v1-0-f6de9c6af2c6@intel.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
 Huang Ying <ying.huang@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.13-dev-02a79
X-Developer-Signature: v=1; a=openpgp-sha256; l=1128;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=U9rnqtpmVZUt30zvfvx/p0VOOSSlAU3FkBQboHUpz0E=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDCndXdJPCib2Sa5SyA1aNe/Q/VXJhzimiG36Itn24UN9e
 H7A1vBbHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZiIryzD/3jW5j0urffjip8t
 rp3lFbThsIdtc7BdjespQffltSv0mBj+ir6LTXEoMz7Re1bMx3xRREVS1t8keY4Wzldm89w9ctL
 5AQ==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

In preparation for the dax/kmem driver, which can be built as a module,
to use this interface, export it with EXPORT_SYMBOL_GPL().

Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 mm/memory_hotplug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index bb3845830922..92922080d3fa 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1328,6 +1328,7 @@ bool mhp_supports_memmap_on_memory(unsigned long size, mhp_t mhp_flags)
 		       IS_ALIGNED(remaining_size, (pageblock_nr_pages << PAGE_SHIFT));
 	return false;
 }
+EXPORT_SYMBOL_GPL(mhp_supports_memmap_on_memory);
 
 /*
  * NOTE: The caller must call lock_device_hotplug() to serialize hotplug

-- 
2.40.1

