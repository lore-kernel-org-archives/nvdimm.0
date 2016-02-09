Return-Path: <owner-linux-mm@kvack.org>
Message-ID: <1455034131.2925.79.camel@hpe.com>
Subject: Re: [PATCH] x86/mm/vmfault: Make vmalloc_fault() handle large pages
From: Toshi Kani <toshi.kani@hpe.com>
Date: Tue, 09 Feb 2016 09:08:51 -0700
In-Reply-To: <20160209132645.55971eff@md1em3qc>
References: <1454976038-22486-1-git-send-email-toshi.kani@hpe.com>
	 <20160209091003.GA10774@gmail.com>	<20160209105325.0ce9a104@md1em3qc>
	 <20160209102235.GA9885@gmail.com> <20160209132645.55971eff@md1em3qc>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: owner-linux-mm@kvack.org
To: Henning Schild <henning.schild@siemens.com>, Ingo Molnar <mingo@kernel.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, bp@alien8.de, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2016-02-09 at 13:26 +0100, Henning Schild wrote:
> On Tue, 9 Feb 2016 11:22:35 +0100
> Ingo Molnar <mingo@kernel.org> wrote:
> 
> > * Henning Schild <henning.schild@siemens.com> wrote:
> > 
> > > On Tue, 9 Feb 2016 10:10:03 +0100
> > > Ingo Molnar <mingo@kernel.org> wrote:
> > >   
> > > > * Toshi Kani <toshi.kani@hpe.com> wrote:
> > > >   
> > > > > Since 4.1, ioremap() supports large page (pud/pmd) mappings in
> > > > > x86_64 and PAE. vmalloc_fault() however assumes that the vmalloc
> > > > > range is limited to pte mappings.
> > > > > 
> > > > > pgd_ctor() sets the kernel's pgd entries to user's during
> > > > > fork(), which makes user processes share the same page tables
> > > > > for the kernel ranges.  When a call to ioremap() is made at
> > > > > run-time that leads to allocate a new 2nd level table (pud in
> > > > > 64-bit and pmd in PAE), user process needs to re-sync with the
> > > > > updated kernel pgd entry with vmalloc_fault().
> > > > > 
> > > > > Following changes are made to vmalloc_fault().    
> > > > 
> > > > So what were the effects of this shortcoming? Were large page
> > > > ioremap()s unusable? Was this harmless because no driver used this
> > > > facility?  
> > > 
> > > Drivers do use huge ioremap()s. Now if a pre-existing mm is used to
> > > access the device memory a #PF and the call to vmalloc_fault would
> > > eventually make the kernel treat device memory as if it was a
> > > pagetable.
> > > The results are illegal reads/writes on iomem and dereferencing
> > > iomem content like it was a pointer to a lower level pagetable.
> > > - #PF if you are lucky

#PF -> vmalloc_fault -> oops

> > > - funny modification of arbitrary memory possible
> > > - can be abused with uio or regular userland ??   
> 
> Looking over the code again i am not sure the last two are even
> possible, it is just the pointer deref that can cause a #PF.
> If the pointer turns out to "work" the code will just read and
> eventually BUG().

The last two case are not possible.

> > Ok, so this is a serious live bug exposed to drivers, that also
> > requires a Cc: stable tag.

Yes, the fix should go to stable as well.

Thanks,
-Toshi

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
