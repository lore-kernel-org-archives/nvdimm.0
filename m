Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <58A10B25.6030508@jp.fujitsu.com>
Date: Mon, 13 Feb 2017 10:25:57 +0900
From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] fix devm_memremap_pages() mem hotplug locking
References: <148693885124.16345.14319993365448440148.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148693885124.16345.14319993365448440148.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, akpm@linux-foundation.org
Cc: Michal Hocko <mhocko@suse.com>, linux-nvdimm@lists.01.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

On Sun, 12 Feb 2017 14:34:11 -0800 Dan Williams wrote:
> Ben notes that commit f931ab479dd2 "mm: fix devm_memremap_pages crash,
> use mem_hotplug_{begin, done}" is incomplete and broken. Writes to
> mem_hotplug.active_writer need to be coordinated under the device
> hotplug lock. Otherwise, we can potentially corrupt mem_hotplug.refcount
> leading to soft lockups.

I think mem_hotplug_{begin,done} is not suitable to exclude devm_memremap_pages()
because it seems that memory hotplug is not related to this context.
How about using pgmap_lock instead?

Like this:

diff --git a/kernel/memremap.c b/kernel/memremap.c
index 9ecedc2..e9b9cfa 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -246,9 +246,9 @@ static void devm_memremap_pages_release(struct device *dev, void *data)
  	/* pages are dead and unused, undo the arch mapping */
  	align_start = res->start & ~(SECTION_SIZE - 1);
  	align_size = ALIGN(resource_size(res), SECTION_SIZE);
-	mem_hotplug_begin();
+	mutex_lock(&pgmap_lock);
  	arch_remove_memory(align_start, align_size);
-	mem_hotplug_done();
+	mutex_unlock(&pgmap_lock);
  	untrack_pfn(NULL, PHYS_PFN(align_start), align_size);
  	pgmap_radix_release(res);
  	dev_WARN_ONCE(dev, pgmap->altmap && pgmap->altmap->alloc,
@@ -360,9 +360,9 @@ void *devm_memremap_pages(struct device *dev, struct resource *res,
  	if (error)
  		goto err_pfn_remap;
  
-	mem_hotplug_begin();
+	mutex_lock(&pgmap_lock);
  	error = arch_add_memory(nid, align_start, align_size, true);
-	mem_hotplug_done();
+	mutex_unlock(&pgmap_lock);
  	if (error)
  		goto err_add_memory;
  
-- 
1.8.3.1
