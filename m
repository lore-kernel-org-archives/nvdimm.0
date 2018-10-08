Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 45DBB21DF8098
 for <linux-nvdimm@lists.01.org>; Mon,  8 Oct 2018 16:34:35 -0700 (PDT)
Subject: [mm PATCH] memremap: Fix reference count for pgmap in
 devm_memremap_pages
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Mon, 08 Oct 2018 16:34:33 -0700
Message-ID: <20181008233404.1909.37302.stgit@localhost.localdomain>
In-Reply-To: <CAPcyv4jX5WYmMYzGCBrnaqT7tqHGSVPwm7Dpi-XpuM9ns84+0w@mail.gmail.com>
References: <CAPcyv4jX5WYmMYzGCBrnaqT7tqHGSVPwm7Dpi-XpuM9ns84+0w@mail.gmail.com>
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
To: linux-mm@kvack.org, akpm@linux-foundation.org, dan.j.williams@intel.com
Cc: pavel.tatashin@microsoft.com, mhocko@suse.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, dave.hansen@intel.com, jglisse@redhat.com, alexander.h.duyck@linux.intel.com, mingo@kernel.org, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

In the earlier patch "mm: defer ZONE_DEVICE page initialization to the
point where we init pgmap" I had overlooked the reference count that was
being held per page on the pgmap. As a result on running the ndctl test
"create.sh" we would call into devm_memremap_pages_release and encounter
the following percpu reference count error and hang:
  WARNING: CPU: 30 PID: 0 at lib/percpu-refcount.c:155
  percpu_ref_switch_to_atomic_rcu+0xf3/0x120

This patch addresses that by performing an update for all of the device
PFNs in a single call. In my testing this seems to resolve the issue while
still allowing us to retain the improvements seen in memory initialization.

Reported-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 kernel/memremap.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/memremap.c b/kernel/memremap.c
index 6ec81e0d7a33..9eced2cc9f94 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -218,6 +218,7 @@ void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
 	memmap_init_zone_device(&NODE_DATA(nid)->node_zones[ZONE_DEVICE],
 				align_start >> PAGE_SHIFT,
 				align_size >> PAGE_SHIFT, pgmap);
+	percpu_ref_get_many(pgmap->ref, pfn_end(pgmap) - pfn_first(pgmap));
 
 	devm_add_action(dev, devm_memremap_pages_release, pgmap);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
