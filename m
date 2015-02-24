Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54EC3FE2.20502@plexistor.com>
Date: Tue, 24 Feb 2015 11:09:54 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3 v3] resource: Add new flag IORESOURCE_MEM_WARN
References: <54EB1D33.3050107@plexistor.com> <54EB206E.4010009@plexistor.com> <CALCETrXBwJdAarXVgO7VaEkTHtnO=-+n7mXy02PbS+sLqNiMyA@mail.gmail.com> <54EC38CA.6050607@plexistor.com> <20150224090742.GC19930@gmail.com>
In-Reply-To: <20150224090742.GC19930@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Ross Zwisler <ross.zwisler@linux.intel.com>, X86 ML <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On 02/24/2015 11:07 AM, Ingo Molnar wrote:
> 
> * Boaz Harrosh <boaz@plexistor.com> wrote:
> 
>> --- a/kernel/resource.c
>> +++ b/kernel/resource.c
>> @@ -1075,8 +1075,13 @@ struct resource * __request_region(struct resource *parent,
>>  			break;
>>  		if (conflict != parent) {
>>  			parent = conflict;
>> -			if (!(conflict->flags & IORESOURCE_BUSY))
>> +			if (!(conflict->flags & IORESOURCE_BUSY)) {
>> +				if (conflict->flags & IORESOURCE_MEM_WARN)
>> +					pr_warn("request unknown region [mem %#010llx-%#010llx] %s\n",
>> +						conflict->start, conflict->end,
>> +						conflict->name);
> 
> Maybe:
> 
>    'request region with unknown memory type [mem ...]'?
> 
> The driver (we hope!) very well knows about the region so 
> it's not totally unknown.
> 

OK makes sense I will fix that too

> Thanks,
> 
> 	Ingo
> 

