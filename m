Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtp.nue.novell.com (smtp.nue.novell.com [195.135.221.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D99651A1E06
 for <linux-nvdimm@lists.01.org>; Mon, 18 Jul 2016 23:55:03 -0700 (PDT)
Date: Tue, 19 Jul 2016 14:53:51 +0800
From: joeyli <jlee@suse.com>
Subject: Re: [PATCH v2] tools/testing/nvdimm: add virtual ramdisk range
Message-ID: <20160719065351.GA30398@linux-rxt1.site>
References: <146861130048.16896.9105590813517990661.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160717093614.GM27155@linux-rxt1.site>
 <CAA9_cmenwSpW51J8tF-4hDQ9fNt1hjUZ+jdACzVNvWivuUa8tg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAA9_cmenwSpW51J8tF-4hDQ9fNt1hjUZ+jdACzVNvWivuUa8tg@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jul 17, 2016 at 09:05:19AM -0700, Dan Williams wrote:
> On Sun, Jul 17, 2016 at 2:36 AM, joeyli <jlee@suse.com> wrote:
> > Hi Dan,
> >
> > On Fri, Jul 15, 2016 at 12:35:58PM -0700, Dan Williams wrote:
> >> Test the virtual disk ranges that platform firmware like EDK2/OVMF might
> >> emit.
> >>
> >> Cc: "Lee, Chun-Yi" <jlee@suse.com>
> >> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >> ---
> >> Changes since v1:
> >>
> >> * Move this test range to nfit_test.1 to not break the spa ordering
> >>   expected by the nfit_test.0 tests.
> >>
> >
> > I reviewed and tested this patch by nvdimm testing driver.
> > Please feel free to add
> >         Reviewed-by: Lee, Chun-Yi <jlee@suse.com>
> >
> > But I have a question to run nfit testing driver on OVMF. I always got
> > "coherent allocation failed" as below:
> >
> > [   86.530950] platform nfit_test.0: swiotlb buffer is full (sz: 134217728 bytes)
> > [   86.530954] swiotlb: coherent allocation failed for device nfit_test.0 size=134217728
> > [   86.530956] CPU: 0 PID: 1291 Comm: insmod Tainted: G           OE   4.7.0-rc7-default+ #323
> > [   86.530958] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
> > [   86.530959]  0000000000000000 ffff880234e63bb0 ffffffff81334e5c 0000000008000000
> > [   86.530961]  ffff880232fa5998 ffff880234e63bf0 ffffffff8135eb79 ffff88020000000f
> > [   86.530963]  00000000024002c0 ffff880232fa5998 0000000008000000 ffff880234e63c68
> > [   86.530965] Call Trace:
> > [   86.530971]  [<ffffffff81334e5c>] dump_stack+0x63/0x87
> > [   86.530975]  [<ffffffff8135eb79>] swiotlb_alloc_coherent+0x149/0x160
> > [   86.530978]  [<ffffffff810611d3>] x86_swiotlb_alloc_coherent+0x43/0x50
> > [   86.530981]  [<ffffffffa054db3a>] dma_alloc_attrs.constprop.10+0x5a/0x80 [nfit_test]
> > [   86.530984]  [<ffffffffa00d618c>] nfit_test_init+0x18c/0x1000 [nfit_test]
> > [   86.530985]  [<ffffffffa00d6000>] ? 0xffffffffa00d6000
> > [   86.530988]  [<ffffffff81002190>] do_one_initcall+0x50/0x190
> > [   86.530992]  [<ffffffff811eef00>] ? kmem_cache_alloc_trace+0x170/0x220
> > [   86.530995]  [<ffffffff8118dbfc>] ? do_init_module+0x27/0x1e2
> > [   86.530997]  [<ffffffff8118dc35>] do_init_module+0x60/0x1e2
> > [   86.531000]  [<ffffffff81108fb1>] load_module+0x1411/0x1c20
> > [   86.531002]  [<ffffffff81105cb0>] ? __symbol_put+0x40/0x40
> > [   86.531006]  [<ffffffff812dfbbd>] ? ima_post_read_file+0x3d/0x80
> > [   86.531009]  [<ffffffff811099c9>] SYSC_finit_module+0xa9/0xd0
> > [   86.531011]  [<ffffffff81109a0e>] SyS_finit_module+0xe/0x10
> > [   86.531013]  [<ffffffff81003a62>] do_syscall_64+0x62/0x110
> > [   86.531016]  [<ffffffff81630a61>] entry_SYSCALL64_slow_path+0x25/0x25
> > [   86.531018] platform nfit_test.0: need 128M of free cma
> >
> > I tried to add "swiotlb=65536" and "cma=128M" or "cma=256M", even "cma=2G" kernel
> > parameters, but nfit-test.ko still can NOT allocate DMA success.
> >
> > So, I always add a patch to change the DIMM_SIZE to SZ_1M, that means test0
> > only uses 4M. Then the nfit-test.ko works for testing.
> >
> > Did I miss anything before running the nfit testing driver?
> 
> The CMA dependency is a hassle, so for v4.8 I'm replacing it with vmalloc:
> 
> https://patchwork.kernel.org/patch/9199761/
> https://patchwork.kernel.org/patch/9199763/

Those patches work great!

Thanks a lot!
Joey Lee
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
