Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1440623522.14237.57.camel@hp.com>
References: <1440606024-29873-1-git-send-email-toshi.kani@hp.com>
	<1440606024-29873-3-git-send-email-toshi.kani@hp.com>
	<CAPcyv4ifkE4kZ3fc3qqwQwBa1QabMcZotLJm+gXALZbNKYQ3aQ@mail.gmail.com>
	<1440623522.14237.57.camel@hp.com>
Date: Thu, 27 Aug 2015 01:16:41 +0200
Message-ID: <CAJZ5v0g2AF7P=T-L_DJqLbOSAoqWcgZseTbeMCx9yChkNgFJOw@mail.gmail.com>
Subject: Re: [PATCH 2/2]: acpica/nfit: Rename not-armed bit definition
From: "Rafael J. Wysocki" <rafael@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hp.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Rafael J Wysocki <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Elliott, Robert (Server Storage)" <elliott@hp.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 26, 2015 at 11:12 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> On Wed, 2015-08-26 at 10:16 -0700, Dan Williams wrote:
>> On Wed, Aug 26, 2015 at 9:20 AM, Toshi Kani <toshi.kani@hp.com> wrote:
>> > ACPI 6.0 NFIT Memory Device State Flags in Table 5-129 defines
>> > bit 3 as follows.
>> >
>> >   Bit [3] set to 1 to indicate that the Memory Device is observed
>> >   to be not armed prior to OSPM hand off. A Memory Device is
>> >   considered armed if it is able to accept persistent writes.
>> >
>> > This bit is currently defined as ACPI_NFIT_MEM_ARMED, which can be
>> > confusing as if the Memory Device is armed when this bit is set.
>> >
>> > Change the name to ACPI_NFIT_MEM_NOT_ARMED per the spec.
>> >
>> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
>> > Cc: Dan Williams <dan.j.williams@intel.com>
>> > Cc: Bob Moore <robert.moore@intel.com>
>> > Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> > ---
>> >  drivers/acpi/nfit.c              |    6 +++---
>> >  drivers/acpi/nfit.h              |    2 +-
>> >  include/acpi/actbl1.h            |    2 +-
>>
>> This file "include/acpi/actbl1.h" is owned by the ACPICA project so
>> any changes need to come through them.  But that said, I'm not sure we
>> need friendly names at this level.
>
> I think the name is misleading, but I agree with the process and this patch2
> can be dropped.  It'd be nice if the ACPICA project can pick it up later
> when they have a chance, though.

A good way to cause that to happen would be to send a patch to the
ACPICA development list + maintainers as per MAINTAINERS.

Thanks,
Rafael
