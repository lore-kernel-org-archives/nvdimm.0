Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22d.google.com (mail-ot0-x22d.google.com
 [IPv6:2607:f8b0:4003:c0f::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 31AB381EE2
 for <linux-nvdimm@lists.01.org>; Mon, 13 Feb 2017 10:30:50 -0800 (PST)
Received: by mail-ot0-x22d.google.com with SMTP id 32so75094888oth.3
 for <linux-nvdimm@lists.01.org>; Mon, 13 Feb 2017 10:30:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <58A1F84A.2090605@hpe.com>
References: <cover.1486750246.git.linda.knippers@hpe.com>
 <5d86cd3620ca9eb3cda38cce0401b2984526cad7.1486750247.git.linda.knippers@hpe.com>
 <CAPcyv4gRNeuQFwDtwGzBbs+CKZnkYibCMm0UXCD2ZWyOZN0GJg@mail.gmail.com>
 <58A1F84A.2090605@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 13 Feb 2017 10:30:48 -0800
Message-ID: <CAPcyv4iW8Kwvm9dFgM7se6kQ7ZOXqX89hz7=FhOrpAbcCEcgAQ@mail.gmail.com>
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

On Mon, Feb 13, 2017 at 10:17 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
> On 02/13/2017 12:28 PM, Dan Williams wrote:
>> On Mon, Feb 13, 2017 at 8:27 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
>>> As it is today, we can't enable or test new functions in firmware without
>>> changing the kernel.
>>>
>>> With this patch we allow function 0 for the HPE DSM families,
>>> as is already allowed with the MS family. We now only restrict
>>> the functions to the currently documented set if the module parameter
>>> "disable_vendor_specific" is set.  Since the module parameter
>>> description says "Limit commands to the publicly specified set",
>>> this approach seems correct.
>>>
>>
>> My concern is that this makes the kernel less strict by default. Given
>> this is only a test capability lets add a module option to override
>> the default dsm_mask.
>
> This part isn't strictly a test capability.  It's also to allow older
> kernels to be supported with newer NVDIMM hardware, firmware, and management tools.
> We shouldn't need a customer to update their production kernel just to support
> an NVDIMM management tool.
>
> As for less secure by default, the default is to allow undocumented
> functions of the "vendor specific" type.  How is the really different?
>

It's about pushing back on undocumented BIOS interfaces as much as
possible. The kernel has the documented set enabled by default,
including the documented vendor-specifc function code. There is the
option to disable the vendor-specific tunnel to restrict the kernel to
only allowing commands with publicly documented effects. With a new
"default_dsm_mask" parameter the default kernel policy can be
overridden by the system owner.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
