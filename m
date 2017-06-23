Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F17B121BBC43C
 for <linux-nvdimm@lists.01.org>; Fri, 23 Jun 2017 00:13:28 -0700 (PDT)
From: "Huang, Ying" <ying.huang@intel.com>
Subject: [PATCH -mm -v2 09/12] memcg, THP,
 swap: Avoid to duplicated charge THP in swap cache
Date: Fri, 23 Jun 2017 15:13:00 +0800
Message-Id: <20170623071303.13469-10-ying.huang@intel.com>
In-Reply-To: <20170623071303.13469-1-ying.huang@intel.com>
References: <20170623071303.13469-1-ying.huang@intel.com>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-nvdimm@lists.01.org, Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Huang Ying <ying.huang@intel.com>

For a THP (Transparent Huge Page), tail_page->mem_cgroup is NULL.  So
to check whether the page is charged already, we need to check the
head page.  This is not an issue before because it is impossible for a
THP to be in the swap cache before.  But after we add delaying
splitting THP after swapped out support, it is possible now.

Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 99e96ae59cd3..123564bcdd77 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5407,7 +5407,7 @@ int mem_cgroup_try_charge(struct page *page, struct mm_struct *mm,
 		 * in turn serializes uncharging.
 		 */
 		VM_BUG_ON_PAGE(!PageLocked(page), page);
-		if (page->mem_cgroup)
+		if (compound_head(page)->mem_cgroup)
 			goto out;
 
 		if (do_swap_account) {
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
