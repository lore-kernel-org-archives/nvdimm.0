Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <5415797A.7000700@plexistor.com>
Date: Sun, 14 Sep 2014 14:18:18 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [Linux-nvdimm] [PATCH v2] pmem: Initial version of persistent
 memory driver
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>	<1409173922-7484-2-git-send-email-ross.zwisler@linux.intel.com>	<540F2977.7010006@plexistor.com>	<CAPcyv4gZBdtup+DuaYL2zOhP9KcRzDAq6vLih0tbpL+abGQv-g@mail.gmail.com>	<541050E5.60502@gmail.com>	<CAPcyv4hfNX4Q75AERfF4g5MVvG82j3tXWcunWiGpBgDS2+7_1Q@mail.gmail.com>	<54108ECA.6090200@plexistor.com>	<CAPcyv4gqyiTaSJY56ZrJh05kwh9O9sXNKOz40fGu5s_=eY=U6Q@mail.gmail.com>	<54117D3A.3010305@plexistor.com> <CAPcyv4io2P1TiXdnhQJMiWsYE5Rz+BiiAHqKZhDe5gh88PEWUA@mail.gmail.com>
In-Reply-To: <CAPcyv4io2P1TiXdnhQJMiWsYE5Rz+BiiAHqKZhDe5gh88PEWUA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Boaz Harrosh <openosd@gmail.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 09/11/2014 07:31 PM, Dan Williams wrote:
<>
> 
> The point I am getting at is not requiring a priori knowledge of the
> physical memory map of a system.  Rather, place holder variables to
> enable simple dynamic discovery.
> 

"simple dynamic discovery" does not yet exist and when the DDR4 NvDIMM
will be released then we still have those DDR3 out there which will
not work with the new discovery, which I need to support as well.

And ... The submitted API will always need to exist for the emulation
case for the developer who wants to do memmap= at Kernel command line.
Which does not have any "dynamic-discovery" because it is not a real
device.

And my point was that the "dynamic-discovery" can be d-coupled from
pmem, and be driven via udev. Each technology/ARCH may have its own
"dynamic-discovery" method and drivers, yet all load a generic pmem driver.

<>
> Why start on step 2 when we haven't got agreement on step 1?
> 

So what you are saying that you do not agree with pmem driver at all?

Because my patch came to better the one range global memory parameters
of prd_start= , prd_size=, prd_nr= interface submitted by Ross to a
simple map= Interface that can take us a very long way. Does cover all
of today's usage including emulated memmap= at Kernel command line.

I have not seen any objections to Ross's pmem driver in general from
you. Only to my patch which changes the API to the better, and actually
let us support all existing and future flat technologies. Yet, yes, do
not have a "dynamic discovery". Which is out of scope for pmem right now.
(And I hope will always be)

I really do not understand what you are suggesting? Are you just saying
NACK on pmem.c. It does not do its job? how can we make it does its job
then?

Thanks
Boaz

