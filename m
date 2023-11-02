Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B326521344
	for <nvdimm@lists.linux.dev>; Thu,  2 Nov 2023 18:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NaPhALI8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698949683; x=1730485683;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=hEIpF+H2iWRMoZGPvwzbL8B1g/l212Q9ts7SomwLAKg=;
  b=NaPhALI8Hye6ucPWiPju/KFndawb48i8nIgxCGmSIySfB0eD662kPHos
   /PKqiZiStXJTA54tVyKogiINpZgfzSNHt7qeUaIvgXIL3t5TaD6NZvLkx
   lN4M5FemujZPe+908yiqIqCWeiogsJwZje/xB7gJYN9Ue5JArPq6HW5vf
   wo0ckJV240j+mh8vQOAPEuVuAT62WbgOTUJFYWfTayQ5ThWSdOCxxDjaf
   RTcDj+x2skNhnCYJO4ey/vjYgBVDFjICca2ip/aQu0/V1IA3uMbtS2gO/
   Z45eQIVmUKIaMd+BrAwYETlKb5vjOeD9Zl3PG7xutUv/aqFA3/NMfMn9M
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10882"; a="7421166"
X-IronPort-AV: E=Sophos;i="6.03,272,1694761200"; 
   d="scan'208";a="7421166"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2023 11:28:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10882"; a="761359766"
X-IronPort-AV: E=Sophos;i="6.03,272,1694761200"; 
   d="scan'208";a="761359766"
Received: from fmahinh-mobl.amr.corp.intel.com (HELO [192.168.1.200]) ([10.212.91.244])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2023 11:27:59 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Thu, 02 Nov 2023 12:27:13 -0600
Subject: [PATCH v9 1/3] mm/memory_hotplug: replace an open-coded kmemdup()
 in add_memory_resource()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231102-vv-kmem_memmap-v9-1-973d6b3a8f1a@intel.com>
References: <20231102-vv-kmem_memmap-v9-0-973d6b3a8f1a@intel.com>
In-Reply-To: <20231102-vv-kmem_memmap-v9-0-973d6b3a8f1a@intel.com>
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
 Jeff Moyer <jmoyer@redhat.com>, Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.13-dev-26615
X-Developer-Signature: v=1; a=openpgp-sha256; l=1362;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=hEIpF+H2iWRMoZGPvwzbL8B1g/l212Q9ts7SomwLAKg=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDKnOr/SE+M5/Pnlbz3jL1YSMg7Nu7bl+5ORtPldBhUmGz
 ROWXhW53FHKwiDGxSArpsjyd89HxmNy2/N5AhMcYeawMoEMYeDiFICJXLrIyPCL1zjxRFvOwtmm
 jQ3Wxd8WuLmzzEqWf/DYJ1tS/camoDRGhmlrip4sCDs402uF3nl5XoumU5fU++aHhK2znla0dZK
 0KhMA
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
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 mm/memory_hotplug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index f8d3e7427e32..6be7de9efa55 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1439,11 +1439,11 @@ int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 	if (mhp_flags & MHP_MEMMAP_ON_MEMORY) {
 		if (mhp_supports_memmap_on_memory(size)) {
 			mhp_altmap.free = memory_block_memmap_on_memory_pages();
-			params.altmap = kmalloc(sizeof(struct vmem_altmap), GFP_KERNEL);
+			params.altmap = kmemdup(&mhp_altmap,
+						sizeof(struct vmem_altmap),
+						GFP_KERNEL);
 			if (!params.altmap)
 				goto error;
-
-			memcpy(params.altmap, &mhp_altmap, sizeof(mhp_altmap));
 		}
 		/* fallback to not using altmap  */
 	}

-- 
2.41.0

