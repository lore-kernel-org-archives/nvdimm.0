Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 239AC21A07093
 for <linux-nvdimm@lists.01.org>; Wed, 27 Mar 2019 11:03:47 -0700 (PDT)
From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 061/262] mm/resource: Return real error codes from
 walk failures
Date: Wed, 27 Mar 2019 13:58:36 -0400
Message-Id: <20190327180158.10245-61-sashal@kernel.org>
In-Reply-To: <20190327180158.10245-1-sashal@kernel.org>
References: <20190327180158.10245-1-sashal@kernel.org>
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
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, Michal Hocko <mhocko@suse.com>, linux-nvdimm@lists.01.org, Takashi Iwai <tiwai@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, Huang Ying <ying.huang@intel.com>, linux-mm@kvack.org, Jerome Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Borislav Petkov <bp@suse.de>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Ross Zwisler <zwisler@kernel.org>, Paul Mackerras <paulus@samba.org>, Fengguang Wu <fengguang.wu@intel.com>, linuxppc-dev@lists.ozlabs.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

From: Dave Hansen <dave.hansen@linux.intel.com>

[ Upstream commit 5cd401ace914dc68556c6d2fcae0c349444d5f86 ]

walk_system_ram_range() can return an error code either becuase
*it* failed, or because the 'func' that it calls returned an
error.  The memory hotplug does the following:

	ret = walk_system_ram_range(..., func);
        if (ret)
		return ret;

and 'ret' makes it out to userspace, eventually.  The problem
s, walk_system_ram_range() failues that result from *it* failing
(as opposed to 'func') return -1.  That leads to a very odd
-EPERM (-1) return code out to userspace.

Make walk_system_ram_range() return -EINVAL for internal
failures to keep userspace less confused.

This return code is compatible with all the callers that I
audited.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
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
Cc: Borislav Petkov <bp@suse.de>
Cc: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Keith Busch <keith.busch@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/resource.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 915c02e8e5dd..ca7ed5158cff 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -382,7 +382,7 @@ static int __walk_iomem_res_desc(resource_size_t start, resource_size_t end,
 				 int (*func)(struct resource *, void *))
 {
 	struct resource res;
-	int ret = -1;
+	int ret = -EINVAL;
 
 	while (start < end &&
 	       !find_next_iomem_res(start, end, flags, desc, first_lvl, &res)) {
@@ -462,7 +462,7 @@ int walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 	unsigned long flags;
 	struct resource res;
 	unsigned long pfn, end_pfn;
-	int ret = -1;
+	int ret = -EINVAL;
 
 	start = (u64) start_pfn << PAGE_SHIFT;
 	end = ((u64)(start_pfn + nr_pages) << PAGE_SHIFT) - 1;
-- 
2.19.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
