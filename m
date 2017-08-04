Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ua0-x230.google.com (mail-ua0-x230.google.com
 [IPv6:2607:f8b0:400c:c08::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 50E552095D8FF
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 11:07:04 -0700 (PDT)
Received: by mail-ua0-x230.google.com with SMTP id q25so10523204uah.1
 for <linux-nvdimm@lists.01.org>; Fri, 04 Aug 2017 11:09:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <74521a9d-45fa-7e29-d9f9-960c478306ec@arm.com>
References: <cover.1500397441.git.robin.murphy@arm.com>
 <ba8c28bcffc3bc856163441793bb4ef0fefa0f75.1500397441.git.robin.murphy@arm.com>
 <20170804152542.7h3mbyxnhjwroddc@armageddon.cambridge.arm.com>
 <74521a9d-45fa-7e29-d9f9-960c478306ec@arm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 4 Aug 2017 11:09:16 -0700
Message-ID: <CAPcyv4i0=Na5Y5pZDAk5=K9nirfyo-eQJRuikETF82VuS_xY=Q@mail.gmail.com>
Subject: Re: [PATCH 5/6] arm64: Implement pmem API support
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
To: Robin Murphy <robin.murphy@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 4, 2017 at 10:43 AM, Robin Murphy <robin.murphy@arm.com> wrote:
> On 04/08/17 16:25, Catalin Marinas wrote:
>> Two minor comments below.
>>
>> On Tue, Jul 25, 2017 at 11:55:42AM +0100, Robin Murphy wrote:
>>> --- a/arch/arm64/Kconfig
>>> +++ b/arch/arm64/Kconfig
>>> @@ -960,6 +960,17 @@ config ARM64_UAO
>>>        regular load/store instructions if the cpu does not implement the
>>>        feature.
>>>
>>> +config ARM64_PMEM
>>> +    bool "Enable support for persistent memory"
>>> +    select ARCH_HAS_PMEM_API
>>> +    help
>>> +      Say Y to enable support for the persistent memory API based on the
>>> +      ARMv8.2 DCPoP feature.
>>> +
>>> +      The feature is detected at runtime, and the kernel will use DC CVAC
>>> +      operations if DC CVAP is not supported (following the behaviour of
>>> +      DC CVAP itself if the system does not define a point of persistence).
>>
>> Any reason not to have this default y?
>
> Mostly because it's untested, and not actually useful without some way
> of describing persistent memory regions to the kernel (I'm currently
> trying to make sense of what exactly ARCH_HAS_MMIO_FLUSH is supposed to
> mean in order to enable ACPI NFIT support).

This is related to block-aperture support described by the NFIT where
a sliding-memory-mapped window can be programmed to access different
ranges of the NVDIMM. Before the window is programmed to a new
DIMM-address we need to flush any dirty data through the current
window setting to media. See the call to mmio_flush_range() in
acpi_nfit_blk_single_io(). I think it's ok to omit ARCH_HAS_MMIO_FLUSH
support, and add a configuration option to compile out the
block-aperture support.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
