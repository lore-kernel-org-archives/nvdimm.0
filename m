Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 64E6E1A1E82
 for <linux-nvdimm@lists.01.org>; Sun, 13 Mar 2016 12:44:03 -0700 (PDT)
Received: by mail-oi0-x232.google.com with SMTP id d205so119665576oia.0
 for <linux-nvdimm@lists.01.org>; Sun, 13 Mar 2016 12:43:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160313191543.GA68634@tevye.fc.hp.com>
References: <cover.1457730736.git.jerry.hoemann@hpe.com>
 <833a627a8cff27a72f946fa9432cacf2a855e485.1457730736.git.jerry.hoemann@hpe.com>
 <CAPcyv4gBg5g2Zj6xE0RC0k68t+x8KY9zaJprRC4UYP3HAX3oew@mail.gmail.com>
 <20160311232941.GA139754@tevye.fc.hp.com>
 <CAPcyv4gZOLDC1qEj8rchfc5TjyfGVC_X7hYypBZsc-xYLatmsA@mail.gmail.com>
 <20160313191543.GA68634@tevye.fc.hp.com>
Date: Sun, 13 Mar 2016 12:43:45 -0700
Message-ID: <CAPcyv4g281FWL2M8Phnks_GfUiAaBbO4=4pF0ucVDrsMfWrqHw@mail.gmail.com>
Subject: Re: [RFC v6 2/8] nvdimm: Add wrapper for IOCTL pass thru
From: Dan Williams <dan.j.williams@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Jerry Hoemann <Jerry.Hoemann@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Mar 13, 2016 at 12:15 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> On Fri, Mar 11, 2016 at 03:48:55PM -0800, Dan Williams wrote:
>> On Fri, Mar 11, 2016 at 3:29 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
>> > On Fri, Mar 11, 2016 at 02:04:04PM -0800, Dan Williams wrote:
>> >> On Fri, Mar 11, 2016 at 1:16 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
>> >> > +
>> >> > +
>> >> > +struct nd_cmd_pkg {
>> >> > +       __u32   ncp_type;
>> >>
>> >> I think 'family' is more clear, to signify the class of commands that
>> >> the 'command' parameter references.
>> >
>> >
>> > Oh, family of commands for a DSM.  I was thinking you wanted
>> > family of DSM for a given nvdimm type which didn't seem quite
>> > right.
>> >
>> > I'll change.
>> >
>> >
>> >>                                        Also let's drop the ncp_ prefix,
>> >> it's non-idiomatic with the rest of the definitions in this file.
>> >
>> >
>> > I like field names with prefixes that refer back to the structure they're
>> > defined in.  It makes reading code easier.  (e.g. how many times is
>> > "size" defined in a struct?)
>>
>> True, I do appreciate that aspect.
>>
>> > would you be okay with a prefix "nd_"?  it doesn't quite tie as closely
>> > to the struct, but it should make them unique w/in the kernel.
>>
>> That sounds like a reasonable compromise.
>
> Will do.
>
>>
>> >>
>> >> > +       __u32   ncp_rev;
>> >>
>> >> Why do we need a separate revision field?  A revision change
>> >> effectively selects a different 'family' of commands, so I don't think
>> >> we need to reflect that ACPI-specific aspect of the commands at this
>> >> level.
>> >
>> >  To be clear, if/when a DSM specification is extended in the future, with
>> >  a new command added (all other commands remaining) and the revision to
>> >  the DSM is incremented, you want to have a new family defined/used
>> >  by the ioctl interface?
>> >
>> >  I should be able to do this.
>>
>> Yes, to date we've handled extending and changing command sets within
>> the same revision.
>>
>> >> > +       __u64   ncp_command;
>> >> > +       __u32   ncp_size_in;                    /* size of input payload */
>> >> > +       __u32   ncp_size_out;                   /* size of user buffer   */
>> >>
>> >> What's "user" in this context?  How about "/* size of output payload */"
>> >
>> > Yes, a confusing name.
>> >
>> > This is total space (including input portion) that the user
>> > space caller has set aside for the output of the DSM call.
>> >
>> > The kernel when copying out to user space will not exceed
>> > the size given.
>> >
>> > Need to convey that both of these are INPUT parameter the caller
>> > is passing.
>> >
>> >
>> >>
>> >> > +       __u32   ncp_reserved2[9];               /* reserved must be zero */
>> >> > +       __u32   ncp_pot_size;                   /* potential output size */
>> >>
>> >> It's not 'potential'' it's the 'actual' output size written by the
>> >> kernel/firmware, right?
>> >
>> >
>> > No, it is potential.
>> >
>> > Going though multiple version of the spec, I would see dsm calls
>> > where the amount of the data the dsm returned was not something that
>> > the caller could know apriori.
>> >
>> > So, the interface returns the amount of data that will fit in
>> > the space provided and tell the user app in ncp_pot_size the
>> > amount of data it wants to return.  If what the dsm call wants to
>> > return fits in the space provided, it is what is written.  If what
>> > the DSM would want to return is greater, it is the greater.
>>
>> The case where firmware output overflows the provided buffer the
>> implementation considers that a fatal error.  All the variable output
>> commands indicate (explicitly or implicitly) a maximum output payload
>> size, so an overflow means the driver and the firmware are
>> incompatible.
>
> Not wrong, just a different calling paradigm.
>
> In addition to allowing user applications to query/size buffers
> for the call, I have also found the information on how much data
> firmware wants to return a useful diagnostic in diagnosing
> firmware problems.
>
> Also note, The upper limit on the amount of data the interface returns is
> still in place.  I am not allowing for arbitrarily large returns.
>
>
>
>>
>> > This allows for idempotent calls to be redone with appropriately
>> > sized buffer.
>>
>> I'd prefer we keep the status quo of just failing or otherwise
>> refusing to support commands that exhibit this behavior.
>
> I don't know what the final spec will look like.  It might be
> an issue, it might not.  I would just prefer to have a flexible
> kernel interface in place that will handle such situations so
> we don't have to revisit it in the future.

In Linux kernel development it has been my experience that we don't
code for potential future eventualities.  We code the most pragmatic
minimal interface and evolve it over time if need be.  The expectation
is that occasional revisiting is less overhead than maintaining unused
functionality indefinitely.

Take this call_dsm interface as an example.  We've been able to boil
down the interface to something manageable rather than the
free-for-all that was originally proposed.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
