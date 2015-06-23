Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <5589AC14.4080003@sgi.com>
Date: Tue, 23 Jun 2015 11:57:24 -0700
From: Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] mm, x86: Remove region_is_ram() call from ioremap
References: <1434750245-6304-1-git-send-email-toshi.kani@hp.com> <1434750245-6304-3-git-send-email-toshi.kani@hp.com> <55883605.5020706@sgi.com> <20150623090154.GA3402@gmail.com>
In-Reply-To: <20150623090154.GA3402@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Toshi Kani <toshi.kani@hp.com>, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org, roland@purestorage.com, dan.j.williams@intel.com, x86@kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Clive Harding <clive@sgi.com>, Russ Anderson <rja@sgi.com>, Mel Gorman <mgorman@suse.de>
List-ID: <linux-nvdimm@lists.01.org>



On 6/23/2015 2:01 AM, Ingo Molnar wrote:
> 
> * Mike Travis <travis@sgi.com> wrote:
> 
>> <<<
>> We have a large university system in the UK that is experiencing
>> very long delays modprobing the driver for a specific I/O device.
>> The delay is from 8-10 minutes per device and there are 31 devices
>> in the system.  This 4 to 5 hour delay in starting up those I/O
>> devices is very much a burden on the customer.
>> ...
>> The problem was tracked down to a very slow IOREMAP operation and
>> the excessively long ioresource lookup to insure that the user is
>> not attempting to ioremap RAM.  These patches provide a speed up
>> to that function.
>>>>>
>>
>> The speed up was pretty dramatic, I think to about 15-20 minutes
>> (the test was done by our local CS person in the UK).  I think this
>> would prove the function was working since it would have fallen
>> back to the previous page_is_ram function and the 4 to 5 hour
>> startup.
> 
> Btw., I think even 15-20 minutes is still in the 'ridiculously slow' category.
> Any chance to fix all of this properly, not just hack by hack?
> 
> Thanks,
> 
> 	Ingo
> 


The current primary cause of the slow start up now lies within
the loading of the kernel and other software to 31 Co-processors
in a serial fashion.  We have suggested to the vendor that they
look at booting and starting these in parallel.

The problem is there are not a whole lot of systems that can
handle more than 4 of them let alone 32.  So it's mostly the
interaction between the customers and the vendor directing
these optimizations.

Any speed up of the kernel startup helps here as well.

[off topic]
Btw, this ~20 minutes time is just for the start up of the
co-processors.  The entire system takes much longer as this is
a huge UV system.  Most of the time is still due to memory
initialization.  Mel's "defer page init" patches help here
tremendously, though it's not clear they will trickle back
down to SLES11 which the customer is running.

Thanks,
Mike
