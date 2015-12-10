Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151210002442.GA104756@tevye.fc.hp.com>
References: <cover.1449089647.git.jerry.hoemann@hpe.com>
	<f8e838fb666b7d05e5e1f7527d643181c6f6ba4d.1449089647.git.jerry.hoemann@hpe.com>
	<CAPcyv4gFNnsbyTy8u-_jBF9JPYH_0a9dNX_R1oj2EH2sdrb=-g@mail.gmail.com>
	<20151210002442.GA104756@tevye.fc.hp.com>
Date: Wed, 9 Dec 2015 16:48:55 -0800
Message-ID: <CAPcyv4guEsT0KKivDkKP3YiW=8Ps8cDkjzY0seQuec3mkg0wMg@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] nvdimm: Add IOCTL pass thru functions
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Jerry Hoemann <Jerry.Hoemann@hpe.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, jmoyer <jmoyer@redhat.com>, Dmitry Krivenok <krivenok.dmitry@gmail.com>, Linda Knippers <linda.knippers@hpe.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 9, 2015 at 4:24 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
>
> On Tue, Dec 08, 2015 at 06:10:20PM -0800, Dan Williams wrote:
>> On Wed, Dec 2, 2015 at 1:05 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
>> > Add ioctl command ND_CMD_CALL_DSM to acpi_nfit_ctl and __nd_ioctl which
>> > allow kernel to call a nvdimm's _DSM as a passthru without using the
>> > marshaling code of the nd_cmd_desc.
>> >
>> > Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
>> > ---
>> >  drivers/acpi/nfit.c  | 109 ++++++++++++++++++++++++++++++++-------------------
>> >  drivers/nvdimm/bus.c |  61 +++++++++++++++++++++-------
>> >  2 files changed, 115 insertions(+), 55 deletions(-)
>> >
>>
>> In general I'd like to see this patch remove the need to sprinkle "if
>> (dsm_call)" throughout the implementation ... specific examples below:
>
>
>  The current code is exporting a very different interface
>  for calling _DSM from the pass thru I'm proposing.
>
>  The current code explicitly knows the calling structure of each _DSM function.
>  It knows the number and size of each input and output field.  For variable
>  size output functions the current kernel code knows which field describes
>  the size of the output.  The current code knows the dsm_mask for the _DSM.
>
>  For the pass thru that I'm proposing the kernel wouldn't need to know any
>  of this.  The information needed to make the _DSM call would be passed in by
>  the caller.  [ Yes, there are cases where some calls are made from within
>  the kernel.  But it would be those callers who use the data that needs to
>  know about the data. ]

The kernel only needs to know that this ioctl command has one
variable-size input and one variable-size output buffer that need to
be read out of the envelope.  That can be represented with the current
field buffer size helpers.

>
>  So the use of dsm_call marks where there is a fundamental difference
>  in the two approaches.  This is one reason why I didn't try to integrate
>  these functions in my original submittal.
>
>  You previously expressed an interest in converting the user application
>  to use a pass thru mode and deprecate the current ioctl.  Is this something
>  you're still interested in doing?

Yes, still very much interested in this path.  But the code will need
to be around for quite awhile now that it has appeared in a released
kernel and a released version of ndctl.  So anything that makes the
code more maintainable in the interim is beneficial.

>  If yes, the work we need to do to integrate these two different approaches
>  will just need to be undone.  Further if we deprecate the current IOCTLs,
>  then the nd_cmd_desc tables and related nd_cmd_in_size and nd_cmd_out_size
>  could then be removed.

I'm not seeing this as a large amount of work.  Do you want to hand
off this task to me?

>> > diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
>> > index c1b8d03..e509145 100644
>> > --- a/drivers/acpi/nfit.c
>> > +++ b/drivers/acpi/nfit.c
>> > @@ -75,7 +75,11 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
>
>  ...
>
>> > +       __u64 rev = 1, func = cmd;
>>
>> Why __u64 and not int for these?  acpi_evaluate_dsm() takes an int for
>> both so a bigger type here will be truncated down.
>
>
> ACPI defines arguments to a _DSM as 64 bit quantities. We want the interface
> exported to the user to follow the ACPI spec.  The variables above collect
> the value of rev or func from the two different sources (wrapper or legacy)
> and then passes to acpi_evaluate_dsm which defines the parameters as simple
> ints.
>
> So, going from user interface to call of acpi_evaluate_dsm there will be
> a truncation somewhere.
>
> Looking at acpi_evaluate_dsm(), it uses union acpi_object and fills in
> .integer.value for both rev and func.  These are defined as u64.
>
> So patching acpi_evaluate_dsm to make the rev and func parameters u64 might
> be do'able, but we'd still have potential sign issues with other callers
> to acpi_evaluate_dsm which look to be using simple ints in the call.
>
> Do you want me to look at patching acpi_evaluate_dsm (and possibly
> its callers) as part of this patch set?

Yes, updating the acpi_evaluate_dsm() definition seems the best choice.

>
>
> ...
>
>
>
>> >
>> >         /* fail write commands (when read-only) */
>> >         if (read_only)
>> > -               switch (ioctl_cmd) {
>> > -               case ND_IOCTL_VENDOR:
>> > -               case ND_IOCTL_SET_CONFIG_DATA:
>> > -               case ND_IOCTL_ARS_START:
>> > +               switch (cmd) {
>> > +               case ND_CMD_VENDOR:
>> > +               case ND_CMD_SET_CONFIG_DATA:
>> > +               case ND_CMD_ARS_START:
>> > +               case ND_CMD_CALL_DSM:
>>
>> I agree with your comment in the cover letter that this change should
>> be a separate patch.
>
>   Will do.
>
>>
>> It bothers me that we'll block all ND_CMD_CALL_DSM in the read_only
>> case.  Let's leave ND_CMD_CALL_DSM out of this selection for now.
>
>   Not thrilled here either, but it is the conservative approach for
>   the kernel.
>
>   Since ND_CMD_CALL_DSM is a pass thru,  the kernel
>   doesn't have the knowledge whether the call being made
>   is "read only" or not.  Having ND_CMD_CALL_DSM in
>   the switch doesn't prevent the user from making such
>   calls, it only requires s/he opens the device for write.

Ok let's keep it for now.
