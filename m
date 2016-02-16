Return-Path: <owner-linux-mm@kvack.org>
Message-ID: <1455636108.2925.135.camel@hpe.com>
Subject: Re: [PATCH v2] x86/mm/vmfault: Make vmalloc_fault() handle large
 pages
From: Toshi Kani <toshi.kani@hpe.com>
Date: Tue, 16 Feb 2016 08:21:48 -0700
In-Reply-To: <20160213115418.GB15973@pd.tnic>
References: <1455236836-24579-1-git-send-email-toshi.kani@hpe.com>
	 <20160213115418.GB15973@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: owner-linux-mm@kvack.org
To: Borislav Petkov <bp@alien8.de>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, henning.schild@siemens.com, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Sat, 2016-02-13 at 12:54 +0100, Borislav Petkov wrote:
> On Thu, Feb 11, 2016 at 05:27:16PM -0700, Toshi Kani wrote:
> > The following oops was observed when a read syscall was made to
> > a pmem device after a huge amount (>512GB) of vmalloc ranges was
> > allocated by ioremap() on a x86_64 system.
> > 
> >  BUG: unable to handle kernel paging request at ffff880840000ff8
> >  IP: [<ffffffff810664ae>] vmalloc_fault+0x1be/0x300
> >  PGD c7f03a067 PUD 0
> >  Oops: 0000 [#1] SM
> >    :
> >  Call Trace:
> >  [<ffffffff81067335>] __do_page_fault+0x285/0x3e0
> >  [<ffffffff810674bf>] do_page_fault+0x2f/0x80
> >  [<ffffffff810d6d85>] ? put_prev_entity+0x35/0x7a0
> >  [<ffffffff817a6888>] page_fault+0x28/0x30
> >  [<ffffffff813bb976>] ? memcpy_erms+0x6/0x10
> >  [<ffffffff817a0845>] ? schedule+0x35/0x80
> >  [<ffffffffa006350a>] ? pmem_rw_bytes+0x6a/0x190 [nd_pmem]
> >  [<ffffffff817a3713>] ? schedule_timeout+0x183/0x240
> >  [<ffffffffa028d2b3>] btt_log_read+0x63/0x140 [nd_btt]
> >    :
> >  [<ffffffff811201d0>] ? __symbol_put+0x60/0x60
> >  [<ffffffff8122dc60>] ? kernel_read+0x50/0x80
> >  [<ffffffff81124489>] SyS_finit_module+0xb9/0xf0
> >  [<ffffffff817a4632>] entry_SYSCALL_64_fastpath+0x1a/0xa4
> 
> Please remove those virtual addresses and offsets here as they're
> meaningless and leave only the callstack.

Will do.

 :
> > ---
> > When this patch is accepted, please copy to stable up to 4.1.
> 
> You can do that yourself when submitting by adding this to the CC-list
> above.
> 
> Cc: <stable@vger.kernel.org> # 4.1..

I see.  I will add it to the next version.

> Rest looks ok to me.

Great!  Thanks,
-Toshi


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
