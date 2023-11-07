Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECF2C8D5
	for <nvdimm@lists.linux.dev>; Tue,  7 Nov 2023 07:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f9Uzek3c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699341799; x=1730877799;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=HZM5+hBI5lAioW4CqYpnGoymfhCO2XjBgbEz0jWhomc=;
  b=f9Uzek3cZB5SUfQ1QXtqAAjWh7aPds4IW9f571evrkt3audQDcnlleq4
   t8UdlewZ9BAvbZSKagox6HJw8fp6xBha21IRb38Khoa/b0bgKFQDkEB3U
   7grcmGy5uptGtveUzOV/b7AbKbaUIONmTiV6SHl1ni4MlPfQQHSOOHoq3
   Myn53cuA1ygVWXSb4Etbz6KqDDoDrM+9KJSmvB8qCcASq6PVHzIi292RM
   gP20NYL1MnAfeRvR3/DD4GxUMBFmc325LO3ztTFyB5ckys+uGMZKkSn6l
   yzz5tVGpems8iyY2ISaYJdHffj0PFHKmvqhkwILyAYiHfxsomD9INjtzS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10886"; a="475689642"
X-IronPort-AV: E=Sophos;i="6.03,282,1694761200"; 
   d="scan'208";a="475689642"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2023 23:23:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10886"; a="712477221"
X-IronPort-AV: E=Sophos;i="6.03,282,1694761200"; 
   d="scan'208";a="712477221"
Received: from pengmich-mobl1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.212.96.119])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2023 23:23:15 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 07 Nov 2023 00:22:41 -0700
Subject: [PATCH v10 1/3] mm/memory_hotplug: replace an open-coded kmemdup()
 in add_memory_resource()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231107-vv-kmem_memmap-v10-1-1253ec050ed0@intel.com>
References: <20231107-vv-kmem_memmap-v10-0-1253ec050ed0@intel.com>
In-Reply-To: <20231107-vv-kmem_memmap-v10-0-1253ec050ed0@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
 Huang Ying <ying.huang@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, 
 Michal Hocko <mhocko@suse.com>, 
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>, 
 Jeff Moyer <jmoyer@redhat.com>, Vishal Verma <vishal.l.verma@intel.com>, 
 Fan Ni <fan.ni@samsung.com>
X-Mailer: b4 0.13-dev-26615
X-Developer-Signature: v=1; a=openpgp-sha256; l=1434;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=HZM5+hBI5lAioW4CqYpnGoymfhCO2XjBgbEz0jWhomc=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDKmeTx/u2KMpofzhr339p/4ulhoHJrGPXanCC7+ECHxYL
 X9h51uhjlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAEzk3ByG/9mrWwovZp29Ejbz
 qvedaOUILZP3Ti4Hb8oszGwJtNc+ncnwz3Bv9Z3235/C8n54lB/yKZB+U/r7tc0txUARf/dFErv
 fcwMA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

A review of the memmap_on_memory modifications to add_memory_resource()
revealed an instance of an open-coded kmemdup(). Replace it with
kmemdup().

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Reported-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 mm/memory_hotplug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index ab41a511e20a..3ed48059a780 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1439,13 +1439,13 @@ int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 	if (mhp_flags & MHP_MEMMAP_ON_MEMORY) {
 		if (mhp_supports_memmap_on_memory(size)) {
 			mhp_altmap.free = memory_block_memmap_on_memory_pages();
-			params.altmap = kmalloc(sizeof(struct vmem_altmap), GFP_KERNEL);
+			params.altmap = kmemdup(&mhp_altmap,
+						sizeof(struct vmem_altmap),
+						GFP_KERNEL);
 			if (!params.altmap) {
 				ret = -ENOMEM;
 				goto error;
 			}
-
-			memcpy(params.altmap, &mhp_altmap, sizeof(mhp_altmap));
 		}
 		/* fallback to not using altmap  */
 	}

-- 
2.41.0

