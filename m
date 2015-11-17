Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151117165645.GB91690@tevye.fc.hp.com>
References: <cover.1447698598.git.jerry.hoemann@hpe.com>
	<CAPcyv4j_KcwztL3ACRafSFGEiaspCuM_+CwkcSeymVk5s5vYWg@mail.gmail.com>
	<20151116211011.GC10480@tevye.fc.hp.com>
	<CAPcyv4jhORsskTr_SPpNO=zJf9V7_zrYNnNn61SMWApnv7TK0g@mail.gmail.com>
	<20151117165645.GB91690@tevye.fc.hp.com>
Date: Tue, 17 Nov 2015 09:05:28 -0800
Message-ID: <CAPcyv4gryw5GT2CLHvgirGMudDrQBJaBojwbjxhgkPqR5Te5pg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] nvdimm: Add an IOCTL pass thru for DSM calls
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Jerry Hoemann <Jerry.Hoemann@hpe.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, jmoyer <jmoyer@redhat.com>, Dmitry Krivenok <krivenok.dmitry@gmail.com>, Linda Knippers <linda.knippers@hpe.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 17, 2015 at 8:56 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> On Mon, Nov 16, 2015 at 05:29:41PM -0800, Dan Williams wrote:
>> On Mon, Nov 16, 2015 at 1:10 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
>> > On Mon, Nov 16, 2015 at 11:00:20AM -0800, Dan Williams wrote:
>> >> On Mon, Nov 16, 2015 at 10:38 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
>> >> >
>> >>
>
> ...
>
>> >> Let's not do the _intel vs _passthru split.  I want to convert the
>> >> existing commands over to this new interface and deprecate the old
>> >> ioctl-command formats.  I.e. it isn't the case that this will be a
>> >> always be a blind "passthru" mechanism, the kernel will need to crack
>> >> open this payload in some circumstances.
>> >
>> >
>> > I'm confused.
>> >
>> > In this version there is only 1 ioctl 'N'.  The pass thru is using
>> > number 100.  This is what I thought you wanted from prior comments.
>>
>> It is indeed, I like that change.
>>
>> > The split are for internal functions that deal specifically w/
>> > the argument marshaling code and copy-in/copy-out.  These mechanisms
>> > are different.
>> >
>> > I understand that you want to switch over, but don't you (at least for
>> > the time being) need to keep the old marshaling code for the current
>> > use case?   I was assuming a sequence like:
>> >         1. The pass thru code gets submitted.
>> >         2. The current tools are converted over to using the pass thru,
>> >         3. The marshaling code using nd_cmd_in_size etc., would then
>> >                 be removed.
>> >
>> > Are you wanting to make one big change and not in separate steps?
>>
>> I want to do it in separate steps, I'd just like to see cmd number 100
>> added to the existing __nd_ioctl and acpi_nfit_ctl routines.  That
>
>    Why?

Because there's no need for the intel vs passthru distinction, it's
just yet another command.

>> plus quibbling about the name "ND_CMD_PASSTHRU".  Given the plans to
>> eventually replace the existing commands we can call it something like
>> 'ND_DSM_GENERIC'.
>
>
>   No problem.  I'll change the name for ndn_passthru_pkg in a similar fashion.
>
>
>   Question:     Are you planning to add other CMDs to the IOCTL in the future?
>                 (eg. ones not directly related to calling _dsm?)
>
>                 Or, is the ultimate goal to have an IOCTL that supports
>                 only the generic DSM call?

I'm not ruling out the possibility that there may be a non-DSM command
in the future, but I don't see any need for that on the horizon.  Why
would it matter?
