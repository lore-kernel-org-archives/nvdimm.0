Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E5E7A
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 03:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646884190; x=1678420190;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=01uk1STa+uanKsxMHNVT1kNKcSTu9PKVe8HwVPVDqRs=;
  b=lkklZqPS13onOa+WcMgUi+CCaA39bs7x24SF1Zeplo+rsC6ZteSb76MN
   V8tVyGnvq1GCz+EWdRvzAXfZfdDPMr+dewB3/Oms9if1RUFbcDIv0Uw85
   UcWHPCHykQmqYBT+V1qamMmSe4oLjOh5tpAPfSUbiMZcrAY5M8xzt/OBo
   A4sgUlWGg5ipFHSdAVdvE1b4M0vr4cyIZfv7UhX5e1O/ulCM50iwWVkbT
   iHkXnS49egFjsWbMMrYAU1d1eUiyqiCsYIydeqC/w+jF8G7mv0u0B/3gP
   Urvl2I4EycniZ42LqMfFpE9+c/o5Zh7rMgJFE5+QQdly9LLFRj03xix6H
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="237320840"
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="237320840"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 19:49:22 -0800
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="781317744"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 19:49:21 -0800
Subject: [PATCH 1/6] nvdimm/region: Fix default alignment for small regions
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: robert.hu@linux.intel.com, vishal.l.verma@intel.com, hch@lst.de,
 linux-acpi@vger.kernel.org
Date: Wed, 09 Mar 2022 19:49:21 -0800
Message-ID: <164688416128.2879318.17890707310125575258.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164688415599.2879318.17035042246954533659.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164688415599.2879318.17035042246954533659.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for removing BLK aperture support the NVDIMM unit tests
discovered that the default alignment can be set higher than the
capacity of the region. Fall back to PAGE_SIZE in that case.

Given this has not been seen in the wild, elide notifying -stable.

Fixes: 2522afb86a8c ("libnvdimm/region: Introduce an 'align' attribute")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/region_devs.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 9ccf3d608799..70ad891a76ba 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -1025,6 +1025,9 @@ static unsigned long default_align(struct nd_region *nd_region)
 		}
 	}
 
+	if (nd_region->ndr_size < MEMREMAP_COMPAT_ALIGN_MAX)
+		align = PAGE_SIZE;
+
 	mappings = max_t(u16, 1, nd_region->ndr_mappings);
 	div_u64_rem(align, mappings, &remainder);
 	if (remainder)

