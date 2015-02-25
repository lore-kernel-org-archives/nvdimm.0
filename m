Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54EDDF46.8020303@plexistor.com>
Date: Wed, 25 Feb 2015 16:42:14 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/3 v2] e820: Fix handling of NvDIMM chips
References: <54EB1D33.3050107@plexistor.com> <20150225102240.GC7134@gmail.com>
In-Reply-To: <20150225102240.GC7134@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On 02/25/2015 12:22 PM, Ingo Molnar wrote:
> 
> * Boaz Harrosh <boaz@plexistor.com> wrote:
> 
>> List of patches:
>>  [PATCH 1/3] e820: Don't let unknown DIMM type come out BUSY
>> 	The main fix
>>
>>  [PATCH 2/3] resource: Add new flag IORESOURCE_WARN (64bit)
>> 	Warn in request_resource
>>
>>  [PATCH 3A/3] e820: Add the unknown-12 Memory type (DDR3-NvDIMM)
>> 	Please accept this simple patch
>>
>>  [PATCH 3B/3] e820: dynamic unknown-xxx names (for DDR3-NvDIMM)
>> 	Else we need this crap
> 
> Please also include your nvdimm driver in your next 
> submission (even if that is not part of the submission 
> yet), so that we can see how the driver makes use of the 
> new facility.
> 
> There's quite a bit of confusion about what means what, 
> people are not of one opinion, and it's easier to see and 
> check the fine code instead of making assumptions.
> 

Hi Ingo

Sure, I will send it as RFC as part of the next send.
Ingo, did we please decide on the [PATCH 3A/3]?

> Thanks,
> 
> 	Ingo
> 

Thanks very much
Boaz

