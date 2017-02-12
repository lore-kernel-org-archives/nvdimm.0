Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5B8A882071
 for <linux-nvdimm@lists.01.org>; Sun, 12 Feb 2017 14:38:22 -0800 (PST)
Subject: [PATCH 1/2] mm, devm_memremap_pages: hold device_hotplug lock over
 mem_hotplug_{begin, done}
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 12 Feb 2017 14:34:16 -0800
Message-ID: <148693885680.16345.17802627926777862337.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148693885124.16345.14319993365448440148.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148693885124.16345.14319993365448440148.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: akpm@linux-foundation.org
Cc: Michal Hocko <mhocko@suse.com>, linux-nvdimm@lists.01.org, Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

The mem_hotplug_{begin,done} lock coordinates with
{get,put}_online_mems() to hold off "readers" of the current state of
memory from new hotplug actions. mem_hotplug_begin() expects exclusive
access, via the device_hotplug lock, to set mem_hotplug.active_writer.
Calling mem_hotplug_begin() without locking device_hotplug can lead to
corrupting mem_hotplug.refcount and missed wakeups / soft lockups.

Cc: <stable@vger.kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Logan Gunthorpe <logang@deltatee.com>
Fixes: f931ab479dd2 ("mm: fix devm_memremap_pages crash, use mem_hotplug_{begin, done}")
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 kernel/memremap.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/memremap.c b/kernel/memremap.c
index e6476a8e8b6a..16640415c150 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -264,9 +264,12 @@ static void devm_memremap_pages_release(struct device *dev, void *data)
 	}
 
 	/* pages are dead and unused, undo the arch mapping */
+	lock_device_hotplug();
 	mem_hotplug_begin();
 	arch_remove_memory(res->start, resource_size(res));
 	mem_hotplug_done();
+	unlock_device_hotplug();
+
 	untrack_pfn(NULL, PHYS_PFN(res->start), resource_size(res));
 	pgmap_radix_release(res);
 	dev_WARN_ONCE(dev, pgmap->altmap && pgmap->altmap->alloc,
@@ -374,9 +377,11 @@ void *devm_memremap_pages(struct device *dev, struct resource *res,
 	if (error)
 		goto err_pfn_remap;
 
+	lock_device_hotplug();
 	mem_hotplug_begin();
 	error = arch_add_memory(nid, res->start, resource_size(res), true);
 	mem_hotplug_done();
+	unlock_device_hotplug();
 	if (error)
 		goto err_add_memory;
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
