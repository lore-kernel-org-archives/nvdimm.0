Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <5513BA8C.2040105@plexistor.com>
Date: Thu, 26 Mar 2015 09:51:40 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/8] pmem: Initial version of persistent memory driver
References: <54F82CE0.4040502@plexistor.com> <54F830D4.7030205@plexistor.com> <54F84420.40209@plexistor.com> <CALCETrXsQsoa0qfzM-o+kz6Af2EtvJR7Er6OwxjZ5JegMYxpFg@mail.gmail.com> <54FD901A.3030905@plexistor.com> <CALCETrVt9KiWsT37Z_90gBREK1NoSJ2ruT48uv-7QWumYz+TNg@mail.gmail.com> <94D0CD8314A33A4D9D801C0FE68B40295A84453E@G9W0745.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295A84453E@G9W0745.americas.hpqcorp.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Andy Lutomirski <luto@amacapital.net>
Cc: Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Dan Williams <dan.j.williams@intel.com>, Ingo Molnar <mingo@redhat.com>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-kernel <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>, "Kani, Toshimitsu" <toshi.kani@hp.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On 03/26/2015 06:00 AM, Elliott, Robert (Server Storage) wrote:
> 
> 
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>> owner@vger.kernel.org] On Behalf Of Andy Lutomirski
>> Sent: Wednesday, March 18, 2015 1:07 PM
>> To: Boaz Harrosh
>> Cc: Matthew Wilcox; Ross Zwisler; X86 ML; Thomas Gleixner; Dan Williams;
>> Ingo Molnar; Roger C. Pao; linux-nvdimm; linux-kernel; H. Peter Anvin;
>> Christoph Hellwig
>> Subject: Re: [PATCH 1/8] pmem: Initial version of persistent memory driver
>>
>> On Mar 9, 2015 8:20 AM, "Boaz Harrosh" <boaz@plexistor.com> wrote:
>>>
>>> On 03/06/2015 01:03 AM, Andy Lutomirski wrote:
>>> <>
>>>>
>>>> I think it would be nice to have control over the caching mode.
>>>> Depending on the application, WT or UC could make more sense.
>>>>
>>>
>>> Patches are welcome. say
>>>         map=sss@aaa:WT,sss@aaa:CA, ...
>>>
>>> But for us, with direct_access(), all benchmarks show a slight advantage
>>> for the cached mode.
>>
>> I'm sure cached is faster.  The question is: who flushes the cache?
>>
>> --Andy
> 
> Nobody.
> 
> Therefore, pmem as currently proposed (mapping the memory with
> ioremap_cache, which uses _PAGE_CACHE_MODE_WB) is unsafe unless the
> system is doing something special to ensure L1, L2, and L3 caches are
> flushed on power loss.
> 
> I think pmem needs to map the memory as UC or WT by default, providing
> WB and WC only as an option for users confident that those attributes
> are safe to use in their system.
> 
> Even using UC or WT presumes that ADR is in place.
> 

I will add command line options for these modes per range. (Unless you
care to send a patch before me)

Thanks this is a good idea
Boaz

