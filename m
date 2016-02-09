Return-Path: <owner-linux-mm@kvack.org>
Date: Tue, 9 Feb 2016 10:10:03 +0100
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] x86/mm/vmfault: Make vmalloc_fault() handle large pages
Message-ID: <20160209091003.GA10774@gmail.com>
References: <1454976038-22486-1-git-send-email-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1454976038-22486-1-git-send-email-toshi.kani@hpe.com>
Sender: owner-linux-mm@kvack.org
To: Toshi Kani <toshi.kani@hpe.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, bp@alien8.de, henning.schild@siemens.com, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>


* Toshi Kani <toshi.kani@hpe.com> wrote:

> Since 4.1, ioremap() supports large page (pud/pmd) mappings in x86_64 and PAE.  
> vmalloc_fault() however assumes that the vmalloc range is limited to pte 
> mappings.
> 
> pgd_ctor() sets the kernel's pgd entries to user's during fork(), which makes 
> user processes share the same page tables for the kernel ranges.  When a call to 
> ioremap() is made at run-time that leads to allocate a new 2nd level table (pud 
> in 64-bit and pmd in PAE), user process needs to re-sync with the updated kernel 
> pgd entry with vmalloc_fault().
> 
> Following changes are made to vmalloc_fault().

So what were the effects of this shortcoming? Were large page ioremap()s unusable? 
Was this harmless because no driver used this facility?

If so then the changelog needs to spell this out clearly ...

Thanks,

	Ingo

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
