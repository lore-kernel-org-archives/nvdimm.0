Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: Re: [PATCH 2/2]: acpica/nfit: Rename not-armed bit definition
References: <1440606024-29873-1-git-send-email-toshi.kani@hp.com>
 <1440606024-29873-3-git-send-email-toshi.kani@hp.com>
 <CAPcyv4ifkE4kZ3fc3qqwQwBa1QabMcZotLJm+gXALZbNKYQ3aQ@mail.gmail.com>
From: Linda Knippers <linda.knippers@hp.com>
Message-ID: <55DE1A8E.9000303@hp.com>
Date: Wed, 26 Aug 2015 15:59:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAPcyv4ifkE4kZ3fc3qqwQwBa1QabMcZotLJm+gXALZbNKYQ3aQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Toshi Kani <toshi.kani@hp.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Rafael J Wysocki <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 8/26/2015 1:16 PM, Dan Williams wrote:
> On Wed, Aug 26, 2015 at 9:20 AM, Toshi Kani <toshi.kani@hp.com> wrote:
>> ACPI 6.0 NFIT Memory Device State Flags in Table 5-129 defines
>> bit 3 as follows.
>>
>>   Bit [3] set to 1 to indicate that the Memory Device is observed
>>   to be not armed prior to OSPM hand off. A Memory Device is
>>   considered armed if it is able to accept persistent writes.
>>
>> This bit is currently defined as ACPI_NFIT_MEM_ARMED, which can be
>> confusing as if the Memory Device is armed when this bit is set.
>>
>> Change the name to ACPI_NFIT_MEM_NOT_ARMED per the spec.
>>
>> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Cc: Bob Moore <robert.moore@intel.com>
>> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> ---
>>  drivers/acpi/nfit.c              |    6 +++---
>>  drivers/acpi/nfit.h              |    2 +-
>>  include/acpi/actbl1.h            |    2 +-
> 
> This file "include/acpi/actbl1.h" is owned by the ACPICA project so
> any changes need to come through them.  But that said, I'm not sure we
> need friendly names at this level.
> 
> What I usually say about sysfs name changes to be more human friendly
> is "sysfs is not a UI", i.e. it's not necessarily meant to be user
> friendly.  As long as the names for the flags are distinct then
> wrapping descriptive / accurate names around them is the role of
> libndctl and userspace management software.

I think there's a difference between unfriendly and misleading or confusing.
If names didn't matter at all we could just call them bit0, bit1, bit2,...

> Similar feedback for patch1 in the sense that I don't think we need to
> update the sysfs naming.  For example the API to retrieve the state of
> the "arm" flag in libndctl is ndctl_dimm_failed_arm().

It would be so nice for scripts and humans if the sysfs names made as
much sense.

-- ljk

> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
> 

