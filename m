Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1432838176.23540.9.camel@misato.fc.hp.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150428182455.35812.14950.stgit@dwillia2-desk3.amr.corp.intel.com>
	<1430771187.23761.237.camel@misato.fc.hp.com>
	<CAPcyv4hx28msZ+SQ3chRKPqm3bEXBVvZhz6W3OB2CL9PKDMb0g@mail.gmail.com>
	<1432838176.23540.9.camel@misato.fc.hp.com>
Date: Thu, 28 May 2015 12:59:56 -0700
Message-ID: <CAPcyv4hAGG6hJ8O+ODWH9c89PtXJSZCAyhHze7PGEuraQmuMSw@mail.gmail.com>
Subject: Re: [Linux-nvdimm] [PATCH v2 08/20] libnd, nd_acpi: regions
 (block-data-window, persistent memory, volatile memory)
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hp.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 28, 2015 at 11:36 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> On Sat, 2015-05-09 at 16:55 -0700, Dan Williams wrote:
>> On Mon, May 4, 2015 at 1:26 PM, Toshi Kani <toshi.kani@hp.com> wrote:
>> > On Tue, 2015-04-28 at 14:24 -0400, Dan Williams wrote:
>  :
>> >
>> > The libnd does not support memdev->flags, which contains "Memory Device
>> > State Flags" defined in Table 5-129 of ACPI 6.0.  In case of major
>> > errors, we should only allow a failed NVDIMM be accessed with read-only
>> > for possible data recovery (or not allow any access when the data is
>> > completely lost), and should not let users operate normally over the
>> > corrupted data until the error is dealt properly.
>>
>> I agree with setting read-only access when these flags show that the
>> battery is not ready to persist new writes, but I don't think we
>> should block access in the case where the restore from flash failed.
>> If the data is potentially corrupted we should log that fact, but
>> otherwise enable access.  I.e. potentially corrupt data is better than
>> unavailable data.  It's up to filesystem or application to maintain
>> its own checksums to catch data corruption.
>>
>> > Can you set memdev->flags to nd_region(_desc) so that the pmem driver
>> > can check the status in nd_pmem_probe()?  nd_pmem_probe() can then set
>> > the disk read-only or fail probing, and log errors accordingly.
>>
>> Will do.
>
> I do not see this change in v4.  Is this part of the pending changes
> behind this release?

Yes, I was holding it off until we had an upstream acceptance baseline
set.  That is on hold pending Christoph's review.  He's looking to
come back next Wednesday with deeper review comments.  The runway to
land this in v4.2 is running short...
