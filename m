Return-Path: <owner-linux-mm@kvack.org>
Date: Tue, 9 Feb 2016 10:53:25 +0100
From: Henning Schild <henning.schild@siemens.com>
Subject: Re: [PATCH] x86/mm/vmfault: Make vmalloc_fault() handle large pages
Message-ID: <20160209105325.0ce9a104@md1em3qc>
In-Reply-To: <20160209091003.GA10774@gmail.com>
References: <1454976038-22486-1-git-send-email-toshi.kani@hpe.com>
	<20160209091003.GA10774@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Toshi Kani <toshi.kani@hpe.com>, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, bp@alien8.de, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 9 Feb 2016 10:10:03 +0100
Ingo Molnar <mingo@kernel.org> wrote:

> * Toshi Kani <toshi.kani@hpe.com> wrote:
> 
> > Since 4.1, ioremap() supports large page (pud/pmd) mappings in
> > x86_64 and PAE. vmalloc_fault() however assumes that the vmalloc
> > range is limited to pte mappings.
> > 
> > pgd_ctor() sets the kernel's pgd entries to user's during fork(),
> > which makes user processes share the same page tables for the
> > kernel ranges.  When a call to ioremap() is made at run-time that
> > leads to allocate a new 2nd level table (pud in 64-bit and pmd in
> > PAE), user process needs to re-sync with the updated kernel pgd
> > entry with vmalloc_fault().
> > 
> > Following changes are made to vmalloc_fault().  
> 
> So what were the effects of this shortcoming? Were large page
> ioremap()s unusable? Was this harmless because no driver used this
> facility?

Drivers do use huge ioremap()s. Now if a pre-existing mm is used to
access the device memory a #PF and the call to vmalloc_fault would
eventually make the kernel treat device memory as if it was a
pagetable.
The results are illegal reads/writes on iomem and dereferencing iomem
content like it was a pointer to a lower level pagetable.
- #PF if you are lucky
- funny modification of arbitrary memory possible
- can be abused with uio or regular userland ?? 

Henning
  
> If so then the changelog needs to spell this out clearly ...



> Thanks,
> 
> 	Ingo

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
