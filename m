From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: [PATCH 5.0 057/246] mm/resource: Return real error codes from walk
 failures
Date: Thu,  4 Apr 2019 10:45:57 +0200
Message-ID: <20190404084621.174666333@linuxfoundation.org>
References: <20190404084619.236418459@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190404084619.236418459-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Yaowei Bai <baiyaowei-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org>, Ross Zwisler <zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

5.0-stable review patch.  If anyone has any objections, please let me know.

------------------

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

Signed-off-by: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Reviewed-by: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org> (powerpc)
Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ross Zwisler <zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: Yaowei Bai <baiyaowei-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org>
Cc: Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>
Cc: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
Cc: Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
Cc: Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
