Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B3BC135
	for <nvdimm@lists.linux.dev>; Tue, 17 Oct 2023 05:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eokZnalG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697521508; x=1729057508;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=jE1m85E7fxIhhpuuUBH8EL0PB4Icod+o0o4Ao4dEZ0w=;
  b=eokZnalG4BmYEyPtX0g4tfpHkIoJCMJlCk2V9wKg2KD39gu2ig//YyEe
   00wP8KxrsmD0ETeMmZh/HnwmkKNb+aCeDMVfM0ylY8kDOSxsTmL2x9lcs
   ODfTi2gDjEfUs3R1mxqrqNpQe29zCX1f+2e3LdFBsrTM/FcYNAsNisFWy
   11mZ5PuxNleC+Sgcxfa87c5dEMVOpEs8aC1ew/mgeAAI1B7RVuTnHp+ly
   IFbtGGzS0CSHRY/kp0vLFUtx4L7ApTxMSwwwWg0QUUotoK1o0WitApUbF
   xm68I+y/l5+2Qsg3HBVIyLbX0RZAxvzzJLgXTL66To3wx3f0kw7lCLXeE
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="384580757"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="384580757"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 22:45:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="879694022"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="879694022"
Received: from mjwirth-mobl.amr.corp.intel.com (HELO [192.168.1.200]) ([10.209.151.162])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 22:45:02 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Mon, 16 Oct 2023 23:44:55 -0600
Subject: [PATCH v6 1/3] mm/memory_hotplug: replace an open-coded kmemdup()
 in add_memory_resource()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231016-vv-kmem_memmap-v6-1-078f0d3c0371@intel.com>
References: <20231016-vv-kmem_memmap-v6-0-078f0d3c0371@intel.com>
In-Reply-To: <20231016-vv-kmem_memmap-v6-0-078f0d3c0371@intel.com>
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
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1311;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=jE1m85E7fxIhhpuuUBH8EL0PB4Icod+o0o4Ao4dEZ0w=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDKl68jGKGn4bTxx1ebOqYNu6jh2vbXTSVs2Z/qryjOmFo
 KyTKpUmHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZiIjgvDP8vfOR817jvMuqcp
 dK6592xXD8/HW2dSDdl9X3+bPs/AsZjhv5d+mfdFW7u/SxvW+W/I0nmkLHRYricuNbr191vtRba
 cTAA=
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

