Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 789A7820AE
 for <linux-nvdimm@lists.01.org>; Thu, 16 Feb 2017 12:48:38 -0800 (PST)
Received: by mail-oi0-x22f.google.com with SMTP id s131so1315499oie.1
 for <linux-nvdimm@lists.01.org>; Thu, 16 Feb 2017 12:48:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <58A607F2.6030904@hpe.com>
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
 <58A607F2.6030904@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 16 Feb 2017 12:48:37 -0800
Message-ID: <CAPcyv4gpmz-1E23pHdoy49k+CWXBb-m-7PRbBOb18xTgyhcbUw@mail.gmail.com>
Subject: Re: [PATCH 1/3] Allow all supported HPE DSM functions to be called
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Feb 16, 2017 at 12:13 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
> On 02/16/2017 02:35 PM, Dan Williams wrote:
>> On Thu, Feb 16, 2017 at 10:51 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
>>>> Right, and NVDIMM_FAMILY_HPE2 has one too, and we have the kernel
>>>> option to disable all vendor specific passthroughs if an environment
>>>> only wants to run commands with publicly documented effects.
>>>
>>>
>>> Ok, I can add some to the HPE1 family too.  :-)
>>
>> Sure, and then the pushback would be "no, just use HPE2 or INTEL". We
>> have two kernel-supported methods for sending an opaque
>> vendor-specific command. Why would the kernel need to support a third?
>
> I can't use Intel's because I have an NVDIMM-N and your spec is not
> for NVDIMM-N.

I don't understand this comment in the context of a vendor specific
tunnel. There's nothing NVDIMM-N specific about the DSM payload
format. I'm saying override the default family temporarily just to use
the vendor-specific tunnel, not implement the full "INTEL" definition.
This can be used as a stop-gap when you find you need to support a new
command on a legacy kernel.

>>>> There's also nothing on the kernel side stopping any vendor from
>>>> implementing the "HPE2" or "INTEL" vendor specific interfaces in their
>>>> BIOS, the interfaces are not exclusive.
>>>
>>>
>>> I'm sure that many vendors will implement the INTEL interfaces when
>>> there are devices using the 0x0201 RFIC.  However, those aren't sufficient
>>> for NVDIMM-N devices.
>>>
>>> As for HPE2, it may be short lived.  I'm not sure it's in the wild and
>>> if it's not, perhaps we can remove it.  Still checking.
>>
>> This is an example of why the kernel does not add kernel enabling for
>> future "maybe" cases. The fact that this patch wants to allow the
>> kernel to maybe support a command that doesn't exist yet is a clear
>> reason to say no.
>
> The kernel often has code for devices that aren't available yet,
> like NVDIMMs with 0x201. Sometimes things change or eventually get deprecated.
> The Intel DSM spec has changed over time as well. But as I said, I'm still checking.

I'm not sure that's a good example because block-apertures are
described by ACPI, and the kernel has no specific enabling around the
format-interface-code. Whereas this patch to expand the dsm_mask is
planning ahead for DSMs that may not ever be defined.

[..]
>> Module options are specified at module load time so you don't
>> necessarily need a reboot.
>
> Reloading nfit has been a problem for me with dependencies between
> other modules but perhaps I've just not gotten the sequence right.
> Does it work for you?

Yes:

    ndctl disable-region all
    modprobe -r nfit

It's best to unmount any filesystems mounted on nvdimm namespaces
before disabling regions. There's an ongoing effort to make if safe
[1], but not all filesystems are prepared for their backing device to
disappear.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2016-January/003797.html

>> However, I'm now of the opinion that
>> allowing the family to be changed is a more complete solution to both
>> problems.
>>
>>>>>> I hope the need for the vendor-specific tunnels goes away over time
>>>>>> and Linux can generically support the most common management tasks
>>>>>> with generic infrastructure.
>>>>>
>>>>>
>>>>> We totally agree.  In case you're wondering, we don't have a new
>>>>> DSM queued up just waiting to be exposed by this patch.  However, cases
>>>>> have come up where we have considered the need for a new DSM function
>>>>> outside of pure test environments.  So far we have come up with other
>>>>> approaches but at some point, the right approach will be to add a new DSM
>>>>> function and I'd really like to not have to spin the kernel and all that
>>>>> goes along with that when it happens. It's not good for customers.
>>>>>
>>>>
>>>> I don't understand why a module option is unacceptable when that is
>>>> the proposed solution to the kernel picking the wrong "default"
>>>> family.
>>>
>>>
>>> The difference is that picking the default family is primarily for
>>> testing while the other case it's not.  Testers do all sorts of things
>>> that customers won't like.
>>>
>>>> In fact, thinking about it further, I'd be more open to a patch that
>>>> allows overriding a DIMM's family via sysfs.
>>>
>>>
>>> Sorry if this is a dumb question but will that work at boot time?  Today
>>> there are DSMs that are called during initialization.
>>
>> The only DIMM-level DSMs that are called during initialization are
>> label management, those aren't the DSMs we are talking about here.
>>
>>> There could also
>>> be DSMs called based on whether NFIT device flag bit 4 is set, although
>>> we don't currently do that.
>>
>> Sorry, I'm not sure to which NFIT bit this is referring? I'm not sure
>> it matters if the kernel is never going to initiate and consume the
>> result of the DSM like it does label data.
>
> There's a state flag that says there was a health status change prior
> to the OSPM handoff.  We could eventually want to call that to know more
> about whether the NVDIMM is viable for use as there is more information there
> than in the basic state flags.  We don't do that today though, just
> thinking about the future.

The kernel passes that status and any health-event notification to
userspace. The kernel doesn't consume it directly because the health
status payload is not standardized across vendors, and it keeps the
kernel focused on the mechanism while the policy of what to do with a
health event is a userspace concern. This is the same scheme the
kernel has for handling health status alerts from disks.

>>>> That way we can
>>>> potentially have cross usage of these different interfaces and it's
>>>> less awkward for tooling to use than a module option.
>>>
>>>
>>> For testing purposes, being able to switch DSM families without a reboot
>>> would be really nice.  You could even expose the GUID and allow it, the
>>> family, and the dsm mask to be overridden. Would be helpful when testing
>>> that new standard DSM we all aspire to.
>>>
>>> This approach would touch a lot more code and require a lot more testing
>>> than my relatively simple patches because today these things are configured
>>> at boot time rather than run time.  I wonder about ordering and consistency
>>> checking.  For example, if someone changed the family would you
>>> automatically change the mask or is that two operations?  I assume you'd
>>> check
>>> that the family is actually supported for the device?  With sysfs, different
>>> devices could have different families, where with the module parameter
>>> option
>>> there's one default that's applied to all devices for which that family is
>>> supported.
>>>
>>> At this point I'd probably prefer the simplicity of the module parameter
>>> because I know I can do it and test it.  If the only way you'll take the
>>> patch is to add a second parameter then I'll do that, but I still don't
>>> see the point.
>>
>> Let's do the work to allow the family to be switched so that tooling
>> can override the kernel default, because it does seem valid for a DIMM
>> to support multiple DSM-family types and that gives more than one path
>> to use a vendor specific passthrough.
>
> I am fairly certain that for production use we wouldn't expect management
> tools to use more than one DSM family at a time. Tools using DSMs
> from one family wouldn't switch to using a new family for one operation
> and then switch back for another operation.

If the kernel makes it safe I don't see why this is a blocker,
especially if the goal is to reduce interface proliferation over time.

> We haven't talked about the 4th DSM family and what their plans are but
> I won't be shocked if they create new functions.  That family is very
> hardware specific and hardware specs also evolve.

Yes, and we can add support for new functions when and if they define
them, not in advance.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
