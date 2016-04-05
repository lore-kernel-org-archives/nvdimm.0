Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x235.google.com (mail-ob0-x235.google.com
 [IPv6:2607:f8b0:4003:c01::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 977071A1F3F
 for <linux-nvdimm@lists.01.org>; Tue,  5 Apr 2016 08:47:46 -0700 (PDT)
Received: by mail-ob0-x235.google.com with SMTP id bg3so12098293obb.1
 for <linux-nvdimm@lists.01.org>; Tue, 05 Apr 2016 08:47:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CY1PR14MB0409CDF34EDEDB29959E2406B19E0@CY1PR14MB0409.namprd14.prod.outlook.com>
References: <CY1PR14MB0409CDF34EDEDB29959E2406B19E0@CY1PR14MB0409.namprd14.prod.outlook.com>
Date: Tue, 5 Apr 2016 08:47:45 -0700
Message-ID: <CAPcyv4hnUKar2HWAaAaP6kGBgXQy4_6WS6-491HDgS7hrdSKWw@mail.gmail.com>
Subject: Re: DDR4 NVDIMM
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
To: Prashant Tawade <ptawade@inphi.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Post the contents of /proc/iomem.  It is likely theat your BIOS is not
correctly advertising the memory range to Linux.  An NFIT is required
if the BIOS marks the range as E820-type7.  You can check for the
presence of an NFIT here: /sys/firmware/acpi/tables

On Tue, Apr 5, 2016 at 6:40 AM, Prashant Tawade <ptawade@inphi.com> wrote:
> Hi,
>
> I am testing the DDR4 NVDIMM on Debian 4.5.0-rc7. I enabled X86_PMEM_LEGACY, ACPI_NFIT and ACPI_NFIT_DEBUG with "make menuconfig". BIOS displays the following message
> Just added 4G of Persistent (ADR) memory at =0x100000000
> Just added 4G of Persistent (ADR) memory at =0x200000000
> Just added 4G of Persistent (ADR) memory at =0x300000000
> Just added 0x80000000 of Persistent (ADR) memory at =0x480000000
> But, I do not see any persistent or protected memory with "dmesg | grep e820". There are no debug messages with any errors showing on screen or in the kernel log. How do I debug this?
>
> Where does the data hand-off from BIOS/UEFI to kernel taking place?  How do I trace the debug path for X86_PMEM_LEGACY and how does it work with/without ACPI_NFIT enabled?
>
> Prashant
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
