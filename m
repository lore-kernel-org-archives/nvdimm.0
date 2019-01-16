From: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] mm/resource: return real error codes from walk
 failures
Date: Wed, 16 Jan 2019 14:38:21 -0600
Message-ID: <CAErSpo63av+jnkSY-V_ZNKy1LDX7rGZ6rK1bWbTf3fgrhXqrwQ@mail.gmail.com>
References: <20190116181859.D1504459@viggo.jf.intel.com>
 <20190116181901.CAF85066@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190116181901.CAF85066-LXbPSdftPKxrdx17CPfAsdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: thomas.lendacky-5C7GfCeVMHo@public.gmane.org, dave-gkUM19QKKo4@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, baiyaowei-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org, zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Wed, Jan 16, 2019 at 12:25 PM Dave Hansen
<dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
>
>
> From: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>
> walk_system_ram_range() can return an error code either becuase *it*
> failed, or because the 'func' that it calls returned an error.  The
> memory hotplug does the following:
>
>         ret = walk_system_ram_range(..., func);
>         if (ret)
>                 return ret;
>
> and 'ret' makes it out to userspace, eventually.  The problem is,
> walk_system_ram_range() failues that result from *it* failing (as
> opposed to 'func') return -1.  That leads to a very odd -EPERM (-1)
> return code out to userspace.
>
> Make walk_system_ram_range() return -EINVAL for internal failures to
> keep userspace less confused.
>
> This return code is compatible with all the callers that I audited.
>
> Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Ross Zwisler <zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
>
> Signed-off-by: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>
>  b/kernel/resource.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff -puN kernel/resource.c~memory-hotplug-walk_system_ram_range-returns-neg-1 kernel/resource.c
> --- a/kernel/resource.c~memory-hotplug-walk_system_ram_range-returns-neg-1      2018-12-20 11:48:41.810771934 -0800
> +++ b/kernel/resource.c 2018-12-20 11:48:41.814771934 -0800
> @@ -375,7 +375,7 @@ static int __walk_iomem_res_desc(resourc
>                                  int (*func)(struct resource *, void *))
>  {
>         struct resource res;
> -       int ret = -1;
> +       int ret = -EINVAL;
>
>         while (start < end &&
>                !find_next_iomem_res(start, end, flags, desc, first_lvl, &res)) {
> @@ -453,7 +453,7 @@ int walk_system_ram_range(unsigned long
>         unsigned long flags;
>         struct resource res;
>         unsigned long pfn, end_pfn;
> -       int ret = -1;
> +       int ret = -EINVAL;

Don't you want a similar change in the powerpc version in arch/powerpc/mm/mem.c?

>
>         start = (u64) start_pfn << PAGE_SHIFT;
>         end = ((u64)(start_pfn + nr_pages) << PAGE_SHIFT) - 1;
> _
