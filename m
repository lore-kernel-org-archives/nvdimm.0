Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150508005536.312c3eff@canb.auug.org.au>
References: <20150506200219.40425.74411.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150506200459.40425.80269.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150508005536.312c3eff@canb.auug.org.au>
Date: Thu, 7 May 2015 17:21:39 -0700
Message-ID: <CAPcyv4iO=HGPBewkHiyDTZXJ+PHd86afhhaCw2jr91nyDQM18Q@mail.gmail.com>
Subject: Re: [PATCH v2 01/10] arch: introduce __pfn_t for persistent memory i/o
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Rik van Riel <riel@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Ingo Molnar <mingo@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 7, 2015 at 7:55 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Dan,
>
> On Wed, 06 May 2015 16:04:59 -0400 Dan Williams <dan.j.williams@intel.com> wrote:
>>
>> diff --git a/include/asm-generic/pfn.h b/include/asm-generic/pfn.h
>> new file mode 100644
>> index 000000000000..91171e0285d9
>> --- /dev/null
>> +++ b/include/asm-generic/pfn.h
>> @@ -0,0 +1,51 @@
>> +#ifndef __ASM_PFN_H
>> +#define __ASM_PFN_H
>> +
>> +#ifndef __pfn_to_phys
>> +#define __pfn_to_phys(pfn)      ((dma_addr_t)(pfn) << PAGE_SHIFT)
>
> Why dma_addr_t and not phys_addr_t?  i.e. it could use a comment if it
> is correct.

Hmm, this was derived from:

#define page_to_phys(page)    ((dma_addr_t)page_to_pfn(page) << PAGE_SHIFT)

in arch/x86/include/asm/io.h

The primary users of __pfn_to_phys() is dma_map_page().  I'll add a
comment to that effect.
