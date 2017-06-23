Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CC2E321BBC421
 for <linux-nvdimm@lists.01.org>; Fri, 23 Jun 2017 00:13:28 -0700 (PDT)
From: "Huang, Ying" <ying.huang@intel.com>
Subject: [PATCH -mm -v2 08/12] memcg, THP,
 swap: Support move mem cgroup charge for THP swapped out
Date: Fri, 23 Jun 2017 15:12:59 +0800
Message-Id: <20170623071303.13469-9-ying.huang@intel.com>
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

PTE mapped THP (Transparent Huge Page) will be ignored when moving
memory cgroup charge.  But for THP which is in the swap cache, the
memory cgroup charge for the swap of a tail-page may be moved in
current implementation.  That isn't correct, because the swap charge
for all sub-pages of a THP should be moved together.  Following the
processing of the PTE mapped THP, the mem cgroup charge moving for the
swap entry for a tail-page of a THP is ignored too.

Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
---
 mm/memcontrol.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 544d47e5cbbd..99e96ae59cd3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4616,8 +4616,11 @@ static enum mc_target_type get_mctgt_type(struct vm_area_struct *vma,
 		if (!ret || !target)
 			put_page(page);
 	}
-	/* There is a swap entry and a page doesn't exist or isn't charged */
-	if (ent.val && !ret &&
+	/*
+	 * There is a swap entry and a page doesn't exist or isn't charged.
+	 * But we cannot move a tail-page in a THP.
+	 */
+	if (ent.val && !ret && (!page || !PageTransCompound(page)) &&
 	    mem_cgroup_id(mc.from) == lookup_swap_cgroup_id(ent)) {
 		ret = MC_TARGET_SWAP;
 		if (target)
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
