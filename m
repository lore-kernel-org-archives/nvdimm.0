Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from na01-bn1-obe.outbound.protection.outlook.com
 (mail-bn1on0763.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fc10::763])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DFC3A1A1F3F
 for <linux-nvdimm@lists.01.org>; Tue,  5 Apr 2016 06:40:36 -0700 (PDT)
From: Prashant Tawade <ptawade@inphi.com>
Subject: DDR4 NVDIMM
Date: Tue, 5 Apr 2016 13:40:33 +0000
Message-ID: <CY1PR14MB0409CDF34EDEDB29959E2406B19E0@CY1PR14MB0409.namprd14.prod.outlook.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi,

I am testing the DDR4 NVDIMM on Debian 4.5.0-rc7. I enabled X86_PMEM_LEGACY, ACPI_NFIT and ACPI_NFIT_DEBUG with "make menuconfig". BIOS displays the following message
Just added 4G of Persistent (ADR) memory at =0x100000000
Just added 4G of Persistent (ADR) memory at =0x200000000
Just added 4G of Persistent (ADR) memory at =0x300000000
Just added 0x80000000 of Persistent (ADR) memory at =0x480000000
But, I do not see any persistent or protected memory with "dmesg | grep e820". There are no debug messages with any errors showing on screen or in the kernel log. How do I debug this?

Where does the data hand-off from BIOS/UEFI to kernel taking place?  How do I trace the debug path for X86_PMEM_LEGACY and how does it work with/without ACPI_NFIT enabled?

Prashant
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
