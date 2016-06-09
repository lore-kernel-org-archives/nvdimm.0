Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22d.google.com (mail-oi0-x22d.google.com
 [IPv6:2607:f8b0:4003:c06::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 681321A1DFA
 for <linux-nvdimm@lists.01.org>; Thu,  9 Jun 2016 13:27:26 -0700 (PDT)
Received: by mail-oi0-x22d.google.com with SMTP id k23so82063177oih.0
 for <linux-nvdimm@lists.01.org>; Thu, 09 Jun 2016 13:27:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1465494142-1456010-1-git-send-email-yigal@plexistor.com>
References: <1465494142-1456010-1-git-send-email-yigal@plexistor.com>
Date: Thu, 9 Jun 2016 13:27:04 -0700
Message-ID: <CAPcyv4i1cq7nqkp=auataYX7oMRFms2z1M94rFxq1fXGAcvHLg@mail.gmail.com>
Subject: Re: [PATCH] efi: kernel param for legacy NVDIMM support
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
To: Yigal Korman <yigal@plexistor.com>
Cc: linux-efi@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Matt Fleming <matt@codeblueprint.co.uk>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 9, 2016 at 10:42 AM, Yigal Korman <yigal@plexistor.com> wrote:
> The 'efi_legacy_pmem' parameter will convert EFI persistent memory range
> (type 14) into E820 legacy NVDIMM (type 12) memory range.
>
> Background:
>
> In contrast with the NVDIMM E820 types where we can clearly distinguish
> between old NVDIMMs (type-12) and ACPI 6.0 NVDIMMs (type-7), the EFI
> memory types for NVDIMMs are the same before ACPI 6.0 and after
> (type-14).
> This means that old NVDIMMs under EFI aren't supported even though
> they work fine if booted with BIOS (E820).
>
> So allow the user to explicitly request the kernel to identify NVDIMMs
> as legacy under EFI.
>

I'm concerned with the potential for this command line parameter to
collide with NFIT defined ranges.  At a minimum it should confirm that
there is not already an NFIT describing the same address ranges.

However, we have the ability to override / inject ACPI tables and
methods from the kernel.  Why not use that facility to custom craft an
NFIT when the BIOS fails to provide one?  That way EFI type-14
maintains a constant interpretation as just a reserved memory range
with no other side effects.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
