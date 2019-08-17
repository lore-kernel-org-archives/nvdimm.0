Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 20966202B75FA
 for <linux-nvdimm@lists.01.org>; Fri, 16 Aug 2019 20:59:41 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id q20so10647274otl.0
 for <linux-nvdimm@lists.01.org>; Fri, 16 Aug 2019 20:57:56 -0700 (PDT)
MIME-Version: 1.0
References: <1565991345.8572.28.camel@lca.pw>
 <CAPcyv4i9VFLSrU75U0gQH6K2sz8AZttqvYidPdDcS7sU2SFaCA@mail.gmail.com>
 <0FB85A78-C2EE-4135-9E0F-D5623CE6EA47@lca.pw>
In-Reply-To: <0FB85A78-C2EE-4135-9E0F-D5623CE6EA47@lca.pw>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 16 Aug 2019 20:57:40 -0700
Message-ID: <CAPcyv4h9Y7wSdF+jnNzLDRobnjzLfkGLpJsML2XYLUZZZUPsQA@mail.gmail.com>
Subject: Re: devm_memremap_pages() triggers a kasan_add_zero_shadow() warning
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
To: Qian Cai <cai@lca.pw>
Cc: Linux MM <linux-mm@kvack.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kasan-dev@googlegroups.com, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 16, 2019 at 8:34 PM Qian Cai <cai@lca.pw> wrote:
>
>
>
> > On Aug 16, 2019, at 5:48 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > On Fri, Aug 16, 2019 at 2:36 PM Qian Cai <cai@lca.pw> wrote:
> >>
> >> Every so often recently, booting Intel CPU server on linux-next triggers this
> >> warning. Trying to figure out if  the commit 7cc7867fb061
> >> ("mm/devm_memremap_pages: enable sub-section remap") is the culprit here.
> >>
> >> # ./scripts/faddr2line vmlinux devm_memremap_pages+0x894/0xc70
> >> devm_memremap_pages+0x894/0xc70:
> >> devm_memremap_pages at mm/memremap.c:307
> >
> > Previously the forced section alignment in devm_memremap_pages() would
> > cause the implementation to never violate the KASAN_SHADOW_SCALE_SIZE
> > (12K on x86) constraint.
> >
> > Can you provide a dump of /proc/iomem? I'm curious what resource is
> > triggering such a small alignment granularity.
>
> This is with memmap=4G!4G ,
>
> # cat /proc/iomem
[..]
> 100000000-155dfffff : Persistent Memory (legacy)
>   100000000-155dfffff : namespace0.0
> 155e00000-15982bfff : System RAM
>   155e00000-156a00fa0 : Kernel code
>   156a00fa1-15765d67f : Kernel data
>   157837000-1597fffff : Kernel bss
> 15982c000-1ffffffff : Persistent Memory (legacy)
> 200000000-87fffffff : System RAM

Ok, looks like 4G is bad choice to land the pmem emulation on this
system because it collides with where the kernel is deployed and gets
broken into tiny pieces that violate kasan's. This is a known problem
with memmap=. You need to pick an memory range that does not collide
with anything else. See:

    https://nvdimm.wiki.kernel.org/how_to_choose_the_correct_memmap_kernel_parameter_for_pmem_on_your_system

...for more info.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
