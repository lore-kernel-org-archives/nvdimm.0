Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lf0-x235.google.com (mail-lf0-x235.google.com
 [IPv6:2a00:1450:4010:c07::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 13BDF1A1E00
 for <linux-nvdimm@lists.01.org>; Fri, 10 Jun 2016 01:49:06 -0700 (PDT)
Received: by mail-lf0-x235.google.com with SMTP id f6so20825841lfg.0
 for <linux-nvdimm@lists.01.org>; Fri, 10 Jun 2016 01:48:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4i1cq7nqkp=auataYX7oMRFms2z1M94rFxq1fXGAcvHLg@mail.gmail.com>
References: <1465494142-1456010-1-git-send-email-yigal@plexistor.com>
 <CAPcyv4i1cq7nqkp=auataYX7oMRFms2z1M94rFxq1fXGAcvHLg@mail.gmail.com>
From: Yigal Korman <yigal@plexistor.com>
Date: Fri, 10 Jun 2016 11:48:22 +0300
Message-ID: <CACTTzNZDi6fykiPw1zTAVPkwX0NkQnGO2HsaVNDi32ww4X48AQ@mail.gmail.com>
Subject: Re: [PATCH] efi: kernel param for legacy NVDIMM support
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
Cc: linux-efi@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Matt Fleming <matt@codeblueprint.co.uk>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 9, 2016 at 11:27 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Thu, Jun 9, 2016 at 10:42 AM, Yigal Korman <yigal@plexistor.com> wrote:
> > The 'efi_legacy_pmem' parameter will convert EFI persistent memory range
> > (type 14) into E820 legacy NVDIMM (type 12) memory range.
> >
> > Background:
> >
> > In contrast with the NVDIMM E820 types where we can clearly distinguish
> > between old NVDIMMs (type-12) and ACPI 6.0 NVDIMMs (type-7), the EFI
> > memory types for NVDIMMs are the same before ACPI 6.0 and after
> > (type-14).
> > This means that old NVDIMMs under EFI aren't supported even though
> > they work fine if booted with BIOS (E820).
> >
> > So allow the user to explicitly request the kernel to identify NVDIMMs
> > as legacy under EFI.
> >
>
> I'm concerned with the potential for this command line parameter to
> collide with NFIT defined ranges.  At a minimum it should confirm that
> there is not already an NFIT describing the same address ranges.
>

That's a valid concern, but not related to this patch directly, the
same might happen today when an 'memmap=XX!YY' kernel parameter
collides with an NFIT on the same range.

Or, albeit a far fetched scenario, a platform vendor will decide to
provide an NFIT for a non-ACPI 6.0 and leave the old E820 type-12.

> However, we have the ability to override / inject ACPI tables and
> methods from the kernel.  Why not use that facility to custom craft an
> NFIT when the BIOS fails to provide one?  That way EFI type-14
> maintains a constant interpretation as just a reserved memory range
> with no other side effects.

That might be an interesting way to implement memmap=XX!YY in general
and can also replace the funny code in arch/x86/kernel/pmem.c.

But, it's more complex and probably has its own caveats, this patch is
simpler and straight forward, providing direct value.

Thanks,
Yigal
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
