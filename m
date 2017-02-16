Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-BY2-obe.outbound.protection.outlook.com
 (mail-by2nam01on070e.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe42::70e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 719FE820EA
 for <linux-nvdimm@lists.01.org>; Thu, 16 Feb 2017 12:13:45 -0800 (PST)
Subject: Re: [PATCH 1/3] Allow all supported HPE DSM functions to be called
References: <cover.1486750246.git.linda.knippers@hpe.com>
 <5d86cd3620ca9eb3cda38cce0401b2984526cad7.1486750247.git.linda.knippers@hpe.com>
 <CAPcyv4gRNeuQFwDtwGzBbs+CKZnkYibCMm0UXCD2ZWyOZN0GJg@mail.gmail.com>
 <58A1F84A.2090605@hpe.com>
 <CAPcyv4iW8Kwvm9dFgM7se6kQ7ZOXqX89hz7=FhOrpAbcCEcgAQ@mail.gmail.com>
 <58A4E20F.8040302@hpe.com>
 <CAPcyv4iog-kV3-Bu2KYzC7hxkAO82mbUfY-nyYdEXReJC8nioQ@mail.gmail.com>
 <58A4F63D.70908@hpe.com>
 <CAPcyv4i8GSU13GZBta+YH0NfVcDztLy2SjfNJmtdpjs+7igULQ@mail.gmail.com>
 <56cd91c8-a5d8-7339-2ff2-f2e706691c8b@hpe.com>
 <CAPcyv4ggMwddnkHxAkLkSHLpM6h6t3zJQ3mr2P4t+6xPZx0dxw@mail.gmail.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <58A607F2.6030904@hpe.com>
Date: Thu, 16 Feb 2017 15:13:38 -0500
MIME-Version: 1.0
In-Reply-To: <CAPcyv4ggMwddnkHxAkLkSHLpM6h6t3zJQ3mr2P4t+6xPZx0dxw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 02/16/2017 02:35 PM, Dan Williams wrote:
> On Thu, Feb 16, 2017 at 10:51 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
>>> Right, and NVDIMM_FAMILY_HPE2 has one too, and we have the kernel
>>> option to disable all vendor specific passthroughs if an environment
>>> only wants to run commands with publicly documented effects.
>>
>>
>> Ok, I can add some to the HPE1 family too.  :-)
> 
> Sure, and then the pushback would be "no, just use HPE2 or INTEL". We
> have two kernel-supported methods for sending an opaque
> vendor-specific command. Why would the kernel need to support a third?

I can't use Intel's because I have an NVDIMM-N and your spec is not
for NVDIMM-N.

>>> There's also nothing on the kernel side stopping any vendor from
>>> implementing the "HPE2" or "INTEL" vendor specific interfaces in their
>>> BIOS, the interfaces are not exclusive.
>>
>>
>> I'm sure that many vendors will implement the INTEL interfaces when
>> there are devices using the 0x0201 RFIC.  However, those aren't sufficient
>> for NVDIMM-N devices.
>>
>> As for HPE2, it may be short lived.  I'm not sure it's in the wild and
>> if it's not, perhaps we can remove it.  Still checking.
> 
> This is an example of why the kernel does not add kernel enabling for
> future "maybe" cases. The fact that this patch wants to allow the
> kernel to maybe support a command that doesn't exist yet is a clear
> reason to say no.

The kernel often has code for devices that aren't available yet,
like NVDIMMs with 0x201. Sometimes things change or eventually get deprecated.
The Intel DSM spec has changed over time as well. But as I said, I'm still checking.

> 
>>>>> Customers are
>>>>> already prepared to need new kernels for new enabling.
>>>>
>>>>
>>>> This may not be new enabling.  It could be hardware they already have
>>>> but there is a FW update or a management feature or some error recovery
>>>> that gets turned on.
>>>>
>>>
>>> I consider new platform functionality hardware or firmware as new
>>> enabling.
>>
>>
>> A customer may not see it that way.
>>
>>>>> It's a similar coordination we do for new device-ids for drivers, but we
>>>>> still allow
>>>>> for overriding the default via the "new_id" interface in sysfs.
>>>>>
>>>>> Look at the reaction we got from the community the last time this
>>>>> subject was brought up [1].
>>>>
>>>>
>>>> I actually think we handled that objection in the next few messages.
>>>>
>>>
>>> I think we placated it with the strict checking, but the fact that the
>>> kernel continues to have 4 nvdimm-family-types is still a point of
>>> contention.
>>
>>
>> We will likely end up supporting a 5th one as we move to a standard.
>>
>>>>> That reaction stems from the historical
>>>>> divergence of storage management interfaces requiring Linux to have a
>>>>> vendor-specific toolkit per device. Requiring a kernel change to make
>>>>> a command supported by default is a good thing because it affords
>>>>> ongoing opportunities to find commonalities between vendors and
>>>>> support common tooling.
>>>>
>>>>
>>>> A good thing for who?  Not for the distro or the customer.  I don't
>>>> see how this is different than Intel adding new features through your
>>>> generic
>>>> vendor-specific function, which would not require a kernel spin.
>>>
>>>
>>> A distro would rather carry one utility that handles multiple vendors.
>>> The kernel would rather carry support code for one generic interface
>>> than multiple interfaces.
>>
>>
>> We'd all like that - but we don't have that yet.
>>
>>> A kernel spin is not required with the proposed module parameter.
>>
>>
>> True, but configuring boot options and a reboot are required.
> 
> Module options are specified at module load time so you don't
> necessarily need a reboot. 

Reloading nfit has been a problem for me with dependencies between
other modules but perhaps I've just not gotten the sequence right.
Does it work for you?

> However, I'm now of the opinion that
> allowing the family to be changed is a more complete solution to both
> problems.
> 
>>>>> I hope the need for the vendor-specific tunnels goes away over time
>>>>> and Linux can generically support the most common management tasks
>>>>> with generic infrastructure.
>>>>
>>>>
>>>> We totally agree.  In case you're wondering, we don't have a new
>>>> DSM queued up just waiting to be exposed by this patch.  However, cases
>>>> have come up where we have considered the need for a new DSM function
>>>> outside of pure test environments.  So far we have come up with other
>>>> approaches but at some point, the right approach will be to add a new DSM
>>>> function and I'd really like to not have to spin the kernel and all that
>>>> goes along with that when it happens. It's not good for customers.
>>>>
>>>
>>> I don't understand why a module option is unacceptable when that is
>>> the proposed solution to the kernel picking the wrong "default"
>>> family.
>>
>>
>> The difference is that picking the default family is primarily for
>> testing while the other case it's not.  Testers do all sorts of things
>> that customers won't like.
>>
>>> In fact, thinking about it further, I'd be more open to a patch that
>>> allows overriding a DIMM's family via sysfs.
>>
>>
>> Sorry if this is a dumb question but will that work at boot time?  Today
>> there are DSMs that are called during initialization.
> 
> The only DIMM-level DSMs that are called during initialization are
> label management, those aren't the DSMs we are talking about here.
> 
>> There could also
>> be DSMs called based on whether NFIT device flag bit 4 is set, although
>> we don't currently do that.
> 
> Sorry, I'm not sure to which NFIT bit this is referring? I'm not sure
> it matters if the kernel is never going to initiate and consume the
> result of the DSM like it does label data.

There's a state flag that says there was a health status change prior
to the OSPM handoff.  We could eventually want to call that to know more
about whether the NVDIMM is viable for use as there is more information there
than in the basic state flags.  We don't do that today though, just
thinking about the future.

> 
>>> That way we can
>>> potentially have cross usage of these different interfaces and it's
>>> less awkward for tooling to use than a module option.
>>
>>
>> For testing purposes, being able to switch DSM families without a reboot
>> would be really nice.  You could even expose the GUID and allow it, the
>> family, and the dsm mask to be overridden. Would be helpful when testing
>> that new standard DSM we all aspire to.
>>
>> This approach would touch a lot more code and require a lot more testing
>> than my relatively simple patches because today these things are configured
>> at boot time rather than run time.  I wonder about ordering and consistency
>> checking.  For example, if someone changed the family would you
>> automatically change the mask or is that two operations?  I assume you'd
>> check
>> that the family is actually supported for the device?  With sysfs, different
>> devices could have different families, where with the module parameter
>> option
>> there's one default that's applied to all devices for which that family is
>> supported.
>>
>> At this point I'd probably prefer the simplicity of the module parameter
>> because I know I can do it and test it.  If the only way you'll take the
>> patch is to add a second parameter then I'll do that, but I still don't
>> see the point.
> 
> Let's do the work to allow the family to be switched so that tooling
> can override the kernel default, because it does seem valid for a DIMM
> to support multiple DSM-family types and that gives more than one path
> to use a vendor specific passthrough.

I am fairly certain that for production use we wouldn't expect management
tools to use more than one DSM family at a time. Tools using DSMs
from one family wouldn't switch to using a new family for one operation
and then switch back for another operation.

We haven't talked about the 4th DSM family and what their plans are but
I won't be shocked if they create new functions.  That family is very
hardware specific and hardware specs also evolve.

-- ljk

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
