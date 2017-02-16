Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM02-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam02on0708.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe44::708])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9472881F4E
 for <linux-nvdimm@lists.01.org>; Thu, 16 Feb 2017 10:52:04 -0800 (PST)
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
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <56cd91c8-a5d8-7339-2ff2-f2e706691c8b@hpe.com>
Date: Thu, 16 Feb 2017 13:51:48 -0500
MIME-Version: 1.0
In-Reply-To: <CAPcyv4i8GSU13GZBta+YH0NfVcDztLy2SjfNJmtdpjs+7igULQ@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 2/15/2017 9:03 PM, Dan Williams wrote:
> On Wed, Feb 15, 2017 at 4:45 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
>> On 02/15/2017 07:29 PM, Dan Williams wrote:
>>> On Wed, Feb 15, 2017 at 3:19 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
>>>> On 02/13/2017 01:30 PM, Dan Williams wrote:
>>>>> On Mon, Feb 13, 2017 at 10:17 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
>>>>>> On 02/13/2017 12:28 PM, Dan Williams wrote:
>>>>>>> On Mon, Feb 13, 2017 at 8:27 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
>>>>>>>> As it is today, we can't enable or test new functions in firmware without
>>>>>>>> changing the kernel.
>>>>>>>>
>>>>>>>> With this patch we allow function 0 for the HPE DSM families,
>>>>>>>> as is already allowed with the MS family. We now only restrict
>>>>>>>> the functions to the currently documented set if the module parameter
>>>>>>>> "disable_vendor_specific" is set.  Since the module parameter
>>>>>>>> description says "Limit commands to the publicly specified set",
>>>>>>>> this approach seems correct.
>>>>>>>>
>>>>>>>
>>>>>>> My concern is that this makes the kernel less strict by default. Given
>>>>>>> this is only a test capability lets add a module option to override
>>>>>>> the default dsm_mask.
>>>>>>
>>>>>> This part isn't strictly a test capability.  It's also to allow older
>>>>>> kernels to be supported with newer NVDIMM hardware, firmware, and management tools.
>>>>>> We shouldn't need a customer to update their production kernel just to support
>>>>>> an NVDIMM management tool.
>>>>>>
>>>>>> As for less secure by default, the default is to allow undocumented
>>>>>> functions of the "vendor specific" type.  How is the really different?
>>>>>>
>>>>>
>>>>> It's about pushing back on undocumented BIOS interfaces as much as
>>>>> possible.
>>>>
>>>> I'm not looking to propagate a bunch of undocumented interfaces.  I'm
>>>> looking to avoid having distros release new kernels and customers update
>>>> their systems because there's a new documented interface, especially when the only
>>>> thing that needs to change is the mask.  As you've experienced, the standardization
>>>> process takes a long time and I'm anticipating that between now and
>>>> eventual standardization, there will be at least one new DSM that's needed.
>>>> I'm sure we'll document it too, but that won't help a customer running an
>>>> older kernel.
>>>>
>>>>> The kernel has the documented set enabled by default,
>>>>> including the documented vendor-specifc function code.
>>>>
>>>> Ok, so if I update my document to say that undefined values are vendor-specific,
>>>> we're good?  Or shall I define the unused values that way explicitly?
>>>>
>>>>> There is the option to disable the vendor-specific tunnel to restrict the kernel to
>>>>> only allowing commands with publicly documented effects.
>>>>
>>>> My patch respects that option.
>>>>
>>>>> With a new "default_dsm_mask" parameter the default kernel policy can be
>>>>> overridden by the system owner.
>>>>
>>>> It can, although it means customers would have to add kernel parameters, which
>>>> they try to avoid.  I assume that's why the module parameter for a stricter
>>>> policy isn't the default since customers using Intel management tools would need to
>>>> add a parameter to allow the use of the vendor-specific function.
>>>>
>>>> I'm not trying to be difficult here, but I really don't see the difference
>>>> between a documented function with undocumented behavior and an
>>>> undocumented function with undocumented behavior.
>>>
>>> The difference is that it is slightly more painful to require a kernel
>>> module override. Disabling these commands by default has some effect
>>> of pushing back on the creation of new interfaces.
>>
>> Intel's vendor-specific function, which can expose new interfaces,
>> requires no override.
>>
>
> Right, and NVDIMM_FAMILY_HPE2 has one too, and we have the kernel
> option to disable all vendor specific passthroughs if an environment
> only wants to run commands with publicly documented effects.

Ok, I can add some to the HPE1 family too.  :-)

> There's also nothing on the kernel side stopping any vendor from
> implementing the "HPE2" or "INTEL" vendor specific interfaces in their
> BIOS, the interfaces are not exclusive.

I'm sure that many vendors will implement the INTEL interfaces when
there are devices using the 0x0201 RFIC.  However, those aren't sufficient
for NVDIMM-N devices.

As for HPE2, it may be short lived.  I'm not sure it's in the wild and
if it's not, perhaps we can remove it.  Still checking.

>>> Customers are
>>> already prepared to need new kernels for new enabling.
>>
>> This may not be new enabling.  It could be hardware they already have
>> but there is a FW update or a management feature or some error recovery
>> that gets turned on.
>>
>
> I consider new platform functionality hardware or firmware as new enabling.

A customer may not see it that way.

>>> It's a similar coordination we do for new device-ids for drivers, but we still allow
>>> for overriding the default via the "new_id" interface in sysfs.
>>>
>>> Look at the reaction we got from the community the last time this
>>> subject was brought up [1].
>>
>> I actually think we handled that objection in the next few messages.
>>
>
> I think we placated it with the strict checking, but the fact that the
> kernel continues to have 4 nvdimm-family-types is still a point of
> contention.

We will likely end up supporting a 5th one as we move to a standard.

>>> That reaction stems from the historical
>>> divergence of storage management interfaces requiring Linux to have a
>>> vendor-specific toolkit per device. Requiring a kernel change to make
>>> a command supported by default is a good thing because it affords
>>> ongoing opportunities to find commonalities between vendors and
>>> support common tooling.
>>
>> A good thing for who?  Not for the distro or the customer.  I don't
>> see how this is different than Intel adding new features through your generic
>> vendor-specific function, which would not require a kernel spin.
>
> A distro would rather carry one utility that handles multiple vendors.
> The kernel would rather carry support code for one generic interface
> than multiple interfaces.

We'd all like that - but we don't have that yet.

> A kernel spin is not required with the proposed module parameter.

True, but configuring boot options and a reboot are required.

>>> I hope the need for the vendor-specific tunnels goes away over time
>>> and Linux can generically support the most common management tasks
>>> with generic infrastructure.
>>
>> We totally agree.  In case you're wondering, we don't have a new
>> DSM queued up just waiting to be exposed by this patch.  However, cases
>> have come up where we have considered the need for a new DSM function
>> outside of pure test environments.  So far we have come up with other
>> approaches but at some point, the right approach will be to add a new DSM
>> function and I'd really like to not have to spin the kernel and all that
>> goes along with that when it happens. It's not good for customers.
>>
>
> I don't understand why a module option is unacceptable when that is
> the proposed solution to the kernel picking the wrong "default"
> family.

The difference is that picking the default family is primarily for
testing while the other case it's not.  Testers do all sorts of things
that customers won't like.

> In fact, thinking about it further, I'd be more open to a patch that
> allows overriding a DIMM's family via sysfs.

Sorry if this is a dumb question but will that work at boot time?  Today
there are DSMs that are called during initialization.  There could also
be DSMs called based on whether NFIT device flag bit 4 is set, although
we don't currently do that.

> That way we can
> potentially have cross usage of these different interfaces and it's
> less awkward for tooling to use than a module option.

For testing purposes, being able to switch DSM families without a reboot
would be really nice.  You could even expose the GUID and allow it, the
family, and the dsm mask to be overridden. Would be helpful when testing
that new standard DSM we all aspire to.

This approach would touch a lot more code and require a lot more testing
than my relatively simple patches because today these things are configured
at boot time rather than run time.  I wonder about ordering and consistency
checking.  For example, if someone changed the family would you automatically 
change the mask or is that two operations?  I assume you'd check
that the family is actually supported for the device?  With sysfs, different
devices could have different families, where with the module parameter option
there's one default that's applied to all devices for which that family is
supported.

At this point I'd probably prefer the simplicity of the module parameter
because I know I can do it and test it.  If the only way you'll take the
patch is to add a second parameter then I'll do that, but I still don't
see the point.

-- ljk
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
