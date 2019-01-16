Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 78D60211B8182
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 10:25:42 -0800 (PST)
Subject: [PATCH 3/4] dax/kmem: let walk_system_ram_range() search child
 resources
From: Dave Hansen <dave.hansen@linux.intel.com>
Date: Wed, 16 Jan 2019 10:19:04 -0800
References: <20190116181859.D1504459@viggo.jf.intel.com>
In-Reply-To: <20190116181859.D1504459@viggo.jf.intel.com>
Message-Id: <20190116181904.D24AF5FE@viggo.jf.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dave@sr71.net
Cc: thomas.lendacky@amd.com, mhocko@suse.com, linux-nvdimm@lists.01.org, tiwai@suse.de, Dave Hansen <dave.hansen@linux.intel.com>, ying.huang@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bp@suse.de, baiyaowei@cmss.chinamobile.com, zwisler@kernel.org, bhelgaas@google.com, fengguang.wu@intel.com, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>


From: Dave Hansen <dave.hansen@linux.intel.com>

In the process of onlining memory, we use walk_system_ram_range()
to find the actual RAM areas inside of the area being onlined.

However, it currently only finds memory resources which are
"top-level" iomem_resources.  Children are not currently
searched which causes it to skip System RAM in areas like this
(in the format of /proc/iomem):

a0000000-bfffffff : Persistent Memory (legacy)
  a0000000-afffffff : System RAM

Changing the true->false here allows children to be searched
as well.  We need this because we add a new "System RAM"
resource underneath the "persistent memory" resource when
we use persistent memory in a volatile mode.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ross Zwisler <zwisler@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Huang Ying <ying.huang@intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/kernel/resource.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/resource.c~mm-walk_system_ram_range-search-child-resources kernel/resource.c
--- a/kernel/resource.c~mm-walk_system_ram_range-search-child-resources	2018-12-20 11:48:42.824771932 -0800
+++ b/kernel/resource.c	2018-12-20 11:48:42.827771932 -0800
@@ -445,6 +445,9 @@ int walk_mem_res(u64 start, u64 end, voi
  * This function calls the @func callback against all memory ranges of type
  * System RAM which are marked as IORESOURCE_SYSTEM_RAM and IORESOUCE_BUSY.
  * It is to be used only for System RAM.
+ *
+ * This will find System RAM ranges that are children of top-level resources
+ * in addition to top-level System RAM resources.
  */
 int walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 			  void *arg, int (*func)(unsigned long, unsigned long, void *))
@@ -460,7 +463,7 @@ int walk_system_ram_range(unsigned long
 	flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
 	while (start < end &&
 	       !find_next_iomem_res(start, end, flags, IORES_DESC_NONE,
-				    true, &res)) {
+				    false, &res)) {
 		pfn = (res.start + PAGE_SIZE - 1) >> PAGE_SHIFT;
 		end_pfn = (res.end + 1) >> PAGE_SHIFT;
 		if (end_pfn > pfn)
_
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
