Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <5458AC75.3030207@plexistor.com>
Date: Tue, 04 Nov 2014 12:37:41 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] pmem: Initial version of persistent memory driver
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com> <1409173922-7484-2-git-send-email-ross.zwisler@linux.intel.com> <94D0CD8314A33A4D9D801C0FE68B4029593548AB@G9W0745.americas.hpqcorp.net> <100D68C7BA14664A8938383216E40DE04082985D@FMSMSX114.amr.corp.intel.com>
In-Reply-To: <100D68C7BA14664A8938383216E40DE04082985D@FMSMSX114.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@kernel.dk>, "Kani, Toshimitsu" <toshi.kani@hp.com>, "Knippers, Linda" <linda.knippers@hp.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Matthew Wilcox <willy@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 11/03/2014 06:19 PM, Wilcox, Matthew R wrote:
<>
>>> +config BLK_DEV_PMEM_COUNT
>>> +	int "Default number of PMEM disks"
>>> +	default "4"
>>
>> For real use I think a default of 1 would be better.
> 
> For real use, you need at least two to run xfstests.  This whole configuration mechanism is going away soon anyway.
> 
>>> +	size_t page_offset = sector >> PAGE_SECTORS_SHIFT;
>>> +	size_t offset = page_offset << PAGE_SHIFT;
>>> +
>>
>> Since page_offset is only used to calculate offset, they
>> could be joined to avoid relying on the compiler to
>> optimize it away:
>> 	size_t offset = sector >> PAGE_SECTORS_SHIFT << PAGE_SHIFT;
> 
> If you insist on doing the compiler's job for it, why not:
> 
> 	size_t offset = sector >> (PAGE_SECTORS_SHIFT - PAGE_SHIFT);
> 
> I actually think the original is clearer.
> 

I wish you guys would actually review the correct code.

In the actual good driver that has any shape of proper code all these issue
are gone.

* config defaults gone, multiple-devices multiple-memory ranges fully supported
  hot plug style.
* above shifts cruft completely gone it is left overs from brd.c and
  its page usage.
* getgeo fixed to do what we realy want by the only application on earth
  that still uses it, fdisk. All other partitioners do not call it at all.

Why are we reviewing dead code ?

Cheers
Boaz

