Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x241.google.com (mail-ot0-x241.google.com
 [IPv6:2607:f8b0:4003:c0f::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E0C56202E5485
 for <linux-nvdimm@lists.01.org>; Tue, 19 Jun 2018 08:28:40 -0700 (PDT)
Received: by mail-ot0-x241.google.com with SMTP id 92-v6so96954otw.9
 for <linux-nvdimm@lists.01.org>; Tue, 19 Jun 2018 08:28:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AT5PR8401MB1169ECE7D26644D39DB735D5AB700@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <1461620099-11933-1-git-send-email-toshi.kani@hpe.com>
 <1461620099-11933-2-git-send-email-toshi.kani@hpe.com>
 <CAA9_cmenbY9GStibRjO0BfTq0kzzzqThiLeOygJsT9L03BFsBQ@mail.gmail.com>
 <1529350667.14039.119.camel@hpe.com>
 <CAPcyv4jbctFgCob58sjQZ8msGOT7GBe=+Z_2P6YvNrrK-ztMag@mail.gmail.com>
 <AT5PR8401MB1169FA8B55B36BAE8DF0F6EBAB710@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <CAPcyv4goV+VR15qpio-wqDpDS3nXsfYEbTSk1Ws6DPp6ECKcRQ@mail.gmail.com>
 <AT5PR8401MB1169ECE7D26644D39DB735D5AB700@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Jun 2018 08:28:39 -0700
Message-ID: <CAPcyv4joz7OemcKvJMJVhqKEVgSMpfLbm2DRP9B=S3vRPUAGkQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] acpi/nfit: Update nfit driver to comply with ACPI
 6.1
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
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "Moore, Robert  <robert.moore@intel.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 19, 2018 at 7:31 AM, Elliott, Robert (Persistent Memory)
<elliott@hpe.com> wrote:
>
>
>> -----Original Message-----
>> From: Dan Williams [mailto:dan.j.williams@intel.com]
>> Sent: Monday, June 18, 2018 4:47 PM
>> To: Elliott, Robert (Persistent Memory) <elliott@hpe.com>
>> Cc: Kani, Toshi <toshi.kani@hpe.com>; linux-kernel@vger.kernel.org; linux-
>> nvdimm@lists.01.org; Moore, Robert <robert.moore@intel.com>; Li, Juston
>> <juston.li@intel.com>; rjw@rjwysocki.net; linux-acpi@vger.kernel.org
>> Subject: Re: [PATCH v3 1/2] acpi/nfit: Update nfit driver to comply with
>> ACPI 6.1
>
>
>> Let's take something simple like Vendor ID. What is the Vendor ID for
>> these DIMMs and what does Linux print in sysfs?
>
> Here are some examples (kernel 4.17):
>
> $ cd /sys/bus/nd/devices/nmem0/nfit
> $ grep -s . *
> device:0x314e
> dsm_mask:0x3c76
> family:1
> flags:smart_notify
> format:0x0101
> formats:1
> handle:0x1
> id:802c-0f-1612-122f8255[SPD bytes 320-328, in that order left-to-right]
> phys_id:0x16
> rev_id:0x3100
> serial:0x122f8255
> subsystem_device:0x3141
> subsystem_rev_id:0x0100
> subsystem_vendor:0x8034[Cypress Semiconductor]
> vendor:0x802c[Micron]

Ok, so the lowest significant byte of the Micron id is supposed to be
0x2c and this text representation matches that. So the bytes are being
endian swapped when written to the SPD?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
