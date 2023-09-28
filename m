Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28FA1640A
	for <nvdimm@lists.linux.dev>; Thu, 28 Sep 2023 20:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695933050; x=1727469050;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=cAy0mCyyU34BrYjzihAk6QBEdSFRsmrEsY5ivGjaggs=;
  b=VkB1UUU7MHQf0fpbnFHmwOntxskrezGyHPkCwQVZQeaqxg1gKXs+FUd1
   wC/i+FJllWDxzntNuOPLnuIow1+NZW6T8YlZR9SwBA0mC5msru23/DgkN
   RiyKIQwnCoZ8LSY/wxwOsANyKLkaaVoNIo9GmOLxd+UqPEMei2Q9Lf8o0
   HKzwGhIEGObZy2pHN0yPODrR5B+ls7fURAz8DELX9uGeKRxX+4/8cfe8O
   0KOj2pYB6RaaMmxAK5n+jo5Xe3XwjAhcceB28riQQUf5rGmROJGSTNt+P
   pYuAtvDkvsCZHg+MTystMvTLG72l4U+5vUIkbr2hH/+zzOmN02c5zTbmG
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10847"; a="367229665"
X-IronPort-AV: E=Sophos;i="6.03,185,1694761200"; 
   d="scan'208";a="367229665"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2023 13:30:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10847"; a="815374351"
X-IronPort-AV: E=Sophos;i="6.03,185,1694761200"; 
   d="scan'208";a="815374351"
Received: from bdsebast-mobl1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.212.125.211])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2023 13:30:30 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v4 0/2] mm: use memmap_on_memory semantics for dax/kmem
Date: Thu, 28 Sep 2023 14:30:09 -0600
Message-Id: <20230928-vv-kmem_memmap-v4-0-6ff73fec519a@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFHiFWUC/3XNQQ7CIBAF0KsY1mIoIIIr72GMmdKpJbbUgBKN6
 d0d3Wg0Lmbxf/L+3FnGFDCz9ezOEpaQwxgp6PmM+Q7iAXloKDMppBKmUrwUfhxw2NMNcOJLbZW
 3jdBy5RihGjLyOkH0HbF46XsqTwnbcH192e4odyGfx3R7PS3Vs/27XyoueGsadN5AK73ZhHjGf
 uHHgT2ninzzlRQ/XBK3tm4AaqWdU99cvbkV1Q9XxLUw6ADapbHuk0/T9ACKqImFPwEAAA==
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
 Jonathan Cameron <Jonathan.Cameron@huawei.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3152;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=cAy0mCyyU34BrYjzihAk6QBEdSFRsmrEsY5ivGjaggs=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDKmij4Itwm6bPF8XxpAX828Kx6+++ga1a8WXpk/iy1n0q
 9o+Vd+po5SFQYyLQVZMkeXvno+Mx+S25/MEJjjCzGFlAhnCwMUpABOpamFk2HH85zqnqsfuZSuE
 s9LX79q9c3Vz0pKJW9756Ng/MWt568LI8C+Uf5KPdvLpIs+jV226St8k1mfPY7Ker2L8XCI48fN
 xDgA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

The dax/kmem driver can potentially hot-add large amounts of memory
originating from CXL memory expanders, or NVDIMMs, or other 'device
memories'. There is a chance there isn't enough regular system memory
available to fit the memmap for this new memory. It's therefore
desirable, if all other conditions are met, for the kmem managed memory
to place its memmap on the newly added memory itself.

The main hurdle for accomplishing this for kmem is that memmap_on_memory
can only be done if the memory being added is equal to the size of one
memblock. To overcome this, allow the hotplug code to split an add_memory()
request into memblock-sized chunks, and try_remove_memory() to also
expect and handle such a scenario.

Patch 1 teaches the memory_hotplug code to allow for splitting
add_memory() and remove_memory() requests over memblock sized chunks.

Patch 2 adds a sysfs control for the kmem driver that would
allow an opt-out of using memmap_on_memory for the memory being added.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
Changes in v4:
- Rebase to Aneesh's PPC64 memmap_on_memory series v8 [2].
- Tweak a goto / error path in add_memory_create_devices() (Jonathan)
- Retain the old behavior for dax devices, only default to
  memmap_on_memory for CXL (Jonathan)
- Link to v3: https://lore.kernel.org/r/20230801-vv-kmem_memmap-v3-0-406e9aaf5689@intel.com

[2]: https://lore.kernel.org/linux-mm/20230808091501.287660-1-aneesh.kumar@linux.ibm.com

Changes in v3:
- Rebase on Aneesh's patches [1]
- Drop Patch 1 - it is not needed since [1] allows for dynamic setting
  of the memmap_on_memory param (David)
- Link to v2: https://lore.kernel.org/r/20230720-vv-kmem_memmap-v2-0-88bdaab34993@intel.com

[1]: https://lore.kernel.org/r/20230801044116.10674-1-aneesh.kumar@linux.ibm.com

Changes in v2:
- Drop the patch to create an override path for the memmap_on_memory
  module param (David)
- Move the chunking into memory_hotplug.c so that any caller of
  add_memory() can request this behavior. (David)
- Handle remove_memory() too. (David, Ying)
- Add a sysfs control in the kmem driver for memmap_on_memory semantics
  (David, Jonathan)
- Add a #else case to define mhp_supports_memmap_on_memory() if
  CONFIG_MEMORY_HOTPLUG is unset. (0day report)
- Link to v1: https://lore.kernel.org/r/20230613-vv-kmem_memmap-v1-0-f6de9c6af2c6@intel.com

---
Vishal Verma (2):
      mm/memory_hotplug: split memmap_on_memory requests across memblocks
      dax/kmem: allow kmem to add memory with memmap_on_memory

 drivers/dax/bus.h         |   1 +
 drivers/dax/dax-private.h |   1 +
 drivers/dax/bus.c         |  38 +++++++++++
 drivers/dax/cxl.c         |   1 +
 drivers/dax/hmem/hmem.c   |   1 +
 drivers/dax/kmem.c        |   8 ++-
 drivers/dax/pmem.c        |   1 +
 mm/memory_hotplug.c       | 165 ++++++++++++++++++++++++++++------------------
 8 files changed, 150 insertions(+), 66 deletions(-)
---
base-commit: 25b5b1a0646c3d39e1d885e27c10be1c9e202bf2
change-id: 20230613-vv-kmem_memmap-5483c8d04279

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>

