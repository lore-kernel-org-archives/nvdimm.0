Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1863642.qegEO3HtMW@vostro.rjw.lan>
References: <20150611183830.25175.51256.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150611201018.25175.78715.stgit@dwillia2-desk3.amr.corp.intel.com>
	<1863642.qegEO3HtMW@vostro.rjw.lan>
Date: Wed, 17 Jun 2015 14:35:23 -0700
Message-ID: <CAPcyv4jZLtnu-iNdNDM5zd8-iAp5q82n3b0ZEbohmjvqpEAKcA@mail.gmail.com>
Subject: Re: [PATCH v6 02/21] libnvdimm, nfit: initial libnvdimm
 infrastructure and NFIT support
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Ingo Molnar <mingo@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, "Rafael J. Wysocki" <rafael@kernel.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Robert Moore <robert.moore@intel.com>, Linux ACPI <linux-acpi@vger.kernel.org>, jmoyer <jmoyer@redhat.com>, Lv Zheng <lv.zheng@intel.com>, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 17, 2015 at 2:59 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Thursday, June 11, 2015 04:10:18 PM Dan Williams wrote:
>> A struct nvdimm_bus is the anchor device for registering nvdimm
>> resources and interfaces, for example, a character control device,
>> nvdimm devices, and I/O region devices.  The ACPI NFIT (NVDIMM Firmware
>> Interface Table) is one possible platform description for such
>> non-volatile memory resources in a system.  The nfit.ko driver attaches
>> to the "ACPI0012" device that indicates the presence of the NFIT and
>> parses the table to register a struct nvdimm_bus instance.
>>
>> Cc: <linux-acpi@vger.kernel.org>
>> Cc: Lv Zheng <lv.zheng@intel.com>
>> Cc: Robert Moore <robert.moore@intel.com>
>> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> Acked-by: Jeff Moyer <jmoyer@redhat.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>

Thanks Rafael!

> [cut]
>
>> +
>> +static struct acpi_driver acpi_nfit_driver = {
>> +     .name = KBUILD_MODNAME,
>> +     .ids = acpi_nfit_ids,
>> +     .flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,
>
> But this flag is not needed for now IMO.

Indeed, I'll fold the removal in to a v7 when I add the acks and a few
other straggling bug fixes.
