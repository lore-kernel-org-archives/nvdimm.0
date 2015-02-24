Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54EC3F8C.6050706@plexistor.com>
Date: Tue, 24 Feb 2015 11:08:28 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3 v3] resource: Add new flag IORESOURCE_MEM_WARN
References: <54EB1D33.3050107@plexistor.com> <54EB206E.4010009@plexistor.com> <CALCETrXBwJdAarXVgO7VaEkTHtnO=-+n7mXy02PbS+sLqNiMyA@mail.gmail.com> <54EC38CA.6050607@plexistor.com> <20150224090608.GB19930@gmail.com>
In-Reply-To: <20150224090608.GB19930@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Ross Zwisler <ross.zwisler@linux.intel.com>, X86 ML <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On 02/24/2015 11:06 AM, Ingo Molnar wrote:
> 
> * Boaz Harrosh <boaz@plexistor.com> wrote:
> 
>> --- a/include/linux/ioport.h
>> +++ b/include/linux/ioport.h
>> @@ -255,6 +256,5 @@ static inline bool resource_overlaps(struct resource *r1, struct resource *r2)
>>         return (r1->start <= r2->end && r1->end >= r2->start);
>>  }
>>  
>> -
>>  #endif /* __ASSEMBLY__ */
> 
> While the newline is spurious, it should probably not be 
> removed in this patch.
> 

Rrrr you are right. thanks. I did not notice that I did this.

I will resend.

Boaz

