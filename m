Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D7C3D21102F22
 for <linux-nvdimm@lists.01.org>; Tue, 19 Jun 2018 12:53:24 -0700 (PDT)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH v3 1/2] acpi/nfit: Update nfit driver to comply with ACPI
 6.1
Date: Tue, 19 Jun 2018 19:53:11 +0000
Message-ID: <AT5PR8401MB1169CBD96EE6C152A24D9FD3AB700@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <1461620099-11933-1-git-send-email-toshi.kani@hpe.com>
 <1461620099-11933-2-git-send-email-toshi.kani@hpe.com>
 <CAA9_cmenbY9GStibRjO0BfTq0kzzzqThiLeOygJsT9L03BFsBQ@mail.gmail.com>
 <1529350667.14039.119.camel@hpe.com>
 <CAPcyv4jbctFgCob58sjQZ8msGOT7GBe=+Z_2P6YvNrrK-ztMag@mail.gmail.com>
 <AT5PR8401MB1169FA8B55B36BAE8DF0F6EBAB710@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <CAPcyv4goV+VR15qpio-wqDpDS3nXsfYEbTSk1Ws6DPp6ECKcRQ@mail.gmail.com>
 <AT5PR8401MB1169ECE7D26644D39DB735D5AB700@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <CAPcyv4joz7OemcKvJMJVhqKEVgSMpfLbm2DRP9B=S3vRPUAGkQ@mail.gmail.com>
In-Reply-To: <CAPcyv4joz7OemcKvJMJVhqKEVgSMpfLbm2DRP9B=S3vRPUAGkQ@mail.gmail.com>
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
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Dan Williams
> Sent: Tuesday, June 19, 2018 10:29 AM
> Subject: Re: [PATCH v3 1/2] acpi/nfit: Update nfit driver to comply with
> ACPI 6.1
...
> >
> > Here are some examples (kernel 4.17):

Note that these values were as reported on a little-endian system.

> Ok, so the lowest significant byte of the Micron id is supposed to be
> 0x2c and this text representation matches that. So the bytes are being
> endian swapped when written to the SPD?

SPD byte 320 is 0x80. That's the bank number byte (with odd parity).
SPD byte 321 is 0x2c. That's the manufacturer code byte (with odd parity).

If treated as a single 2-byte value, that is:
* 0x802c (32812 in decimal) if interpreted as big-endian 
* 0x2c80 (11392 in decimal) if interpreted as little-endian

Reviewing the _show() functions in drivers/acpi/nfit/core.c:
  BE device:0x314e
  NE dsm_mask:0x3c76
  NE family:1
  N/A flags:smart_notify
  LE format:0x0101
  N/A formats:1
  BE handle:0x1
  BE id:802c-0f-1612-122f8255 [SPD bytes 320-328]
  NE phys_id:0x16
  BE rev_id:0x3100
  BE serial:0x122f8255
  BE subsystem_device:0x3141
  BE subsystem_rev_id:0x0100
  BE subsystem_vendor:0x8034 [Cypress Semiconductor]
  BE vendor:0x802c [Micron]

(BE=fixed big-endian, LE=fixed little-endian, NE=native-endian,
 N/A=not applicable)

BE and LE will print the same regardless of the endianness
of the system, while NE will vary.

Reviewing the NE sysfs files:

phys_id:
This NFIT field reports an SMBIOS handle (instance ID), a LE number
from 0..n (0x103 on one of my systems).  dmidecode shows handles
like this:
  Handle 0x0016, DMI type 17, 40 bytes
  Memory Device
        Array Handle: 0x000A

On a big-endian system, I think we'll see
  phys_id:0x1600
which means 5632 decimal, which is misleading. Fixed LE would
be better.

dsm_mask:
The code that parses _DSM function 0 output, acpi_check_dsm(),
correctly interprets the bitmask as little-endian for internal
calculations.  I think a big-endian system will print 
dsm_mask:0x763c, which is confusing. Fixed LE would be better.  
The override_dsm_mask module parameter needs to match.

family:
This is an internal value, so NE is fine.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
