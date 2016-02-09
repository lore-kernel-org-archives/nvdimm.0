Return-Path: <owner-linux-mm@kvack.org>
Message-ID: <1455033795.2925.74.camel@hpe.com>
Subject: Re: [PATCH] x86/mm/vmfault: Make vmalloc_fault() handle large pages
From: Toshi Kani <toshi.kani@hpe.com>
Date: Tue, 09 Feb 2016 09:03:15 -0700
In-Reply-To: <20160209091003.GA10774@gmail.com>
References: <1454976038-22486-1-git-send-email-toshi.kani@hpe.com>
	 <20160209091003.GA10774@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: owner-linux-mm@kvack.org
To: Ingo Molnar <mingo@kernel.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, bp@alien8.de, henning.schild@siemens.com, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2016-02-09 at 10:10 +0100, Ingo Molnar wrote:
> * Toshi Kani <toshi.kani@hpe.com> wrote:
> 
> > Since 4.1, ioremap() supports large page (pud/pmd) mappings in x86_64
> > and PAE.  vmalloc_fault() however assumes that the vmalloc range is
> > limited to pte mappings.
> > 
> > pgd_ctor() sets the kernel's pgd entries to user's during fork(), which
> > makes user processes share the same page tables for the kernel
> > ranges.  When a call to ioremap() is made at run-time that leads to
> > allocate a new 2nd level table (pud in 64-bit and pmd in PAE), user
> > process needs to re-sync with the updated kernel pgd entry with
> > vmalloc_fault().
> > 
> > Following changes are made to vmalloc_fault().
> 
> So what were the effects of this shortcoming? Were large page ioremap()s
> unusable? Was this harmless because no driver used this facility?
>
> If so then the changelog needs to spell this out clearly ...

Large page support of ioremap() has been used for persistent memory
mappings for a while.

In order to hit this problem, i.e. causing a vmalloc fault, a large mount
of ioremap allocations at run-time is required.  The following example
repeats allocation of 16GB range.

# cat /proc/vmallocinfo | grep memremap
0xffffc90040000000-0xffffc90440001000 17179873280 memremap+0xb4/0x110
phys=480000000 ioremap
0xffffc90480000000-0xffffc90880001000 17179873280 memremap+0xb4/0x110
phys=480000000 ioremap
0xffffc908c0000000-0xffffc90cc0001000 17179873280 memremap+0xb4/0x110
phys=c80000000 ioremap
0xffffc90d00000000-0xffffc91100001000 17179873280 memremap+0xb4/0x110
phys=c80000000 ioremap
0xffffc91140000000-0xffffc91540001000 17179873280 memremap+0xb4/0x110 
phys=480000000 ioremap
  :
0xffffc97300000000-0xffffc97700001000 17179873280 memremap+0xb4/0x110
phys=c80000000 ioremap
0xffffc97740000000-0xffffc97b40001000 17179873280 memremap+0xb4/0x110
phys=480000000 ioremap
0xffffc97b80000000-0xffffc97f80001000 17179873280 memremap+0xb4/0x110
phys=c80000000 ioremap
0xffffc97fc0000000-0xffffc983c0001000 17179873280 memremap+0xb4/0x110
phys=480000000 ioremap

The last ioremap call above crossed a 512GB boundary (0x8000000000), which
allocated a new pud table and updated the kernel pgd entry to point it.
 Because user process's page table does not have this pgd entry update, a
read/write syscall request to the range will hit a vmalloc fault.  Since
vmalloc_fault() does not handle a large page properly, this causes an Oops
as follows.

 BUG: unable to handle kernel paging request at ffff880840000ff8
 IP: [<ffffffff810664ae>] vmalloc_fault+0x1be/0x300
 PGD c7f03a067 PUD 0 
 Oops: 0000 [#1] SM
   :
 Call Trace:
 [<ffffffff81067335>] __do_page_fault+0x285/0x3e0
 [<ffffffff810674bf>] do_page_fault+0x2f/0x80
 [<ffffffff810d6d85>] ? put_prev_entity+0x35/0x7a0
 [<ffffffff817a6888>] page_fault+0x28/0x30
 [<ffffffff813bb976>] ? memcpy_erms+0x6/0x10
 [<ffffffff817a0845>] ? schedule+0x35/0x80
 [<ffffffffa006350a>] ? pmem_rw_bytes+0x6a/0x190 [nd_pmem]
 [<ffffffff817a3713>] ? schedule_timeout+0x183/0x240
 [<ffffffffa028d2b3>] btt_log_read+0x63/0x140 [nd_btt]
   :
 [<ffffffff811201d0>] ? __symbol_put+0x60/0x60
 [<ffffffff8122dc60>] ? kernel_read+0x50/0x80
 [<ffffffff81124489>] SyS_finit_module+0xb9/0xf0
 [<ffffffff817a4632>] entry_SYSCALL_64_fastpath+0x1a/0xa4

Note that this issue is limited to 64-bit.  32-bit only uses index 3 of the
pgd entry to cover the entire vmalloc range, which is always valid.

I will add this information to the change log.

Thanks,
-Toshi

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
