Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 891B2210D83F5
 for <linux-nvdimm@lists.01.org>; Tue, 19 Jun 2018 07:31:36 -0700 (PDT)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH v3 1/2] acpi/nfit: Update nfit driver to comply with ACPI
 6.1
Date: Tue, 19 Jun 2018 14:31:28 +0000
Message-ID: <AT5PR8401MB1169ECE7D26644D39DB735D5AB700@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <1461620099-11933-1-git-send-email-toshi.kani@hpe.com>
 <1461620099-11933-2-git-send-email-toshi.kani@hpe.com>
 <CAA9_cmenbY9GStibRjO0BfTq0kzzzqThiLeOygJsT9L03BFsBQ@mail.gmail.com>
 <1529350667.14039.119.camel@hpe.com>
 <CAPcyv4jbctFgCob58sjQZ8msGOT7GBe=+Z_2P6YvNrrK-ztMag@mail.gmail.com>
 <AT5PR8401MB1169FA8B55B36BAE8DF0F6EBAB710@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <CAPcyv4goV+VR15qpio-wqDpDS3nXsfYEbTSk1Ws6DPp6ECKcRQ@mail.gmail.com>
In-Reply-To: <CAPcyv4goV+VR15qpio-wqDpDS3nXsfYEbTSk1Ws6DPp6ECKcRQ@mail.gmail.com>
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
To: 'Dan Williams' <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "Moore, Robert  <robert.moore@intel.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Dan Williams [mailto:dan.j.williams@intel.com]
> Sent: Monday, June 18, 2018 4:47 PM
> To: Elliott, Robert (Persistent Memory) <elliott@hpe.com>
> Cc: Kani, Toshi <toshi.kani@hpe.com>; linux-kernel@vger.kernel.org; linux-
> nvdimm@lists.01.org; Moore, Robert <robert.moore@intel.com>; Li, Juston
> <juston.li@intel.com>; rjw@rjwysocki.net; linux-acpi@vger.kernel.org
> Subject: Re: [PATCH v3 1/2] acpi/nfit: Update nfit driver to comply with
> ACPI 6.1


> Let's take something simple like Vendor ID. What is the Vendor ID for
> these DIMMs and what does Linux print in sysfs?

Here are some examples (kernel 4.17):

$ cd /sys/bus/nd/devices/nmem0/nfit
$ grep -s . *
device:0x314e
dsm_mask:0x3c76
family:1
flags:smart_notify
format:0x0101
formats:1
handle:0x1
id:802c-0f-1612-122f8255	[SPD bytes 320-328, in that order left-to-right]
phys_id:0x16
rev_id:0x3100
serial:0x122f8255
subsystem_device:0x3141
subsystem_rev_id:0x0100
subsystem_vendor:0x8034	[Cypress Semiconductor]
vendor:0x802c		[Micron]

$ cd /sys/bus/nd/devices/nmem1/nfit
$ grep -s . *
device:0x314e
dsm_mask:0x3c76
family:1
flags:smart_notify
format:0x0101
formats:1
handle:0x2
id:802c-0f-1612-122f7f5e
phys_id:0x15
rev_id:0x3100
serial:0x122f7f5e
subsystem_device:0x3141
subsystem_rev_id:0x0100
subsystem_vendor:0x8034
vendor:0x802c

Some corresponding information for those NVDIMM-Ns as reported by dmidecode:

Handle 0x00A8, DMI type 237, 9 bytes
OEM-specific Type
        Header and Data:
                ED 09 A8 00 16 00 01 02 03
        Strings:
                Micron		[Module manufacturer]
                18ASF1G72XF12G1Y11AA	[Module part number]
                122F8255	[Module serial number]

Handle 0x00A7, DMI type 237, 9 bytes
OEM-specific Type
        Header and Data:
                ED 09 A7 00 15 00 01 02 03
        Strings:
                Micron
                18ASF1G72XF12G1Y11AA
                122F7F5E

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
