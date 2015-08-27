Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <55DF2E26.30701@hp.com>
References: <1440606024-29873-1-git-send-email-toshi.kani@hp.com>
	<1440606024-29873-3-git-send-email-toshi.kani@hp.com>
	<CAPcyv4ifkE4kZ3fc3qqwQwBa1QabMcZotLJm+gXALZbNKYQ3aQ@mail.gmail.com>
	<1440623522.14237.57.camel@hp.com>
	<CAPcyv4he-kQ7ZoNXNH29ARG9_eX4fR-1yzuqT750z2yUDFxEUw@mail.gmail.com>
	<1440625466.14237.62.camel@hp.com>
	<CAPcyv4iy-_foyLcBGr9TSoR=9gmkS1c7g1c=TKVommdtfPCumA@mail.gmail.com>
	<55DF21FC.8020106@hp.com>
	<CAPcyv4grdxvWnLE1v7xPx0bw7K_CbZooWzN4_ToGS98gkrU_Hg@mail.gmail.com>
	<55DF2E26.30701@hp.com>
Date: Thu, 27 Aug 2015 08:54:30 -0700
Message-ID: <CAPcyv4h8iu+4yWvREyocdfFKDEo6QsV_17z=kougVBZNCeRjaQ@mail.gmail.com>
Subject: Re: [PATCH 2/2]: acpica/nfit: Rename not-armed bit definition
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Linda Knippers <linda.knippers@hp.com>
Cc: Toshi Kani <toshi.kani@hp.com>, Rafael J Wysocki <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Elliott, Robert (Server Storage)" <elliott@hp.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 27, 2015 at 8:35 AM, Linda Knippers <linda.knippers@hp.com> wrote:
> On 8/27/2015 11:30 AM, Dan Williams wrote:
>> On Thu, Aug 27, 2015 at 7:43 AM, Linda Knippers <linda.knippers@hp.com> wrote:
>>> I don't see why we can't fix the names so they make sense now before there
>>> is hardware in the market.  People doing testing and debugging look at stuff
>>> in /sys and they write their own scripts too, not necessarily in python.
>>
>> The practical concern at this point is that it is too late in the 4.2
>> development cycle, in my opinion, to push for a cosmetic change like
>> this.  We also have versions of libndctl starting to leak into
>> distributions.  Changing this in 4.3 means breaking the ABI from 4.2
>> and managing both ways in future versions of the library as well as
>> getting all distributions to update.  Not insurmountable, but also
>> something I don't want to take on just for a few characters in a sysfs
>> file.  I think this is better fixed with documentation which I still
>> owe to the the Documentation/ABI/ directory.
>
> Is there any distribution that is going to enable this with 4.2?  I know
> we're using it for testing now but there is still quite a bit of work
> queued up for 4.3 and more still left to be done.

I'm not happy that this is confusing folks, and it is unfortunate that
the polarity is reversed.

However, I'm more concerned about the fact that I'd be knowingly
breaking ABI from 4.2 to 4.3.  I originally thought "no one" was using
e820 type-12 for enumerating nvdimm resources, but I got shouted down
when trying to convert that exclusively to the ACPI 6 definition.  The
Linus edict of "we don't break released ABI" is ringing in my ears.
The current name is also consistent with the current / released ACPICA
definition.
