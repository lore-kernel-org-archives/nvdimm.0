Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 00C0721A0480F
 for <linux-nvdimm@lists.01.org>; Sat,  8 Apr 2017 00:52:47 -0700 (PDT)
Date: Sat, 8 Apr 2017 15:52:43 +0800
From: Baoquan He <bhe@redhat.com>
Subject: Re: KASLR causes intermittent boot failures on some systems
Message-ID: <20170408075243.GA26009@x1>
References: <x49shlk700k.fsf@segfault.boston.devel.redhat.com>
 <20170408040837.GD4111@x1>
 <CAA9_cmcB2Ctxya6yNj6535WashWArsEr2kf1b3bq82=Dsy5fmA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAA9_cmcB2Ctxya6yNj6535WashWArsEr2kf1b3bq82=Dsy5fmA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, thgarnie@google.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

Thanks!

On 04/08/17 at 12:02am, Dan Williams wrote:
> > I got below problem when configure ndctl, didn't find a package named
> > libkmod:
> >
> > ~~~~~~~~~
> > configure: error: Package requirements (libkmod) were not met:
> >
> > No package 'libkmod' found
> 
> kmod-devel provides that dependency. Otherwise ndctl is included in
> Fedora or you can find EPEL 7 packages here:
> 
> https://copr.fedorainfracloud.org/coprs/djbw/ndctl/

I have installed kmod-devel, still the configure error occured. But it
worked for me with the epel repo you provided to install ndctl.

Seems it can't be reproduced on my beaker machine with 18G memory. I did
steps as Jeff said, and reboot more than 5 times, no crash seen.

Below is the abstracted part of boot log.



[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-4.11.0-rc5+ root=/dev/mapper/fedora-root ro rd.lvm.lv=fedora/root rd.lvm.lv=fedora/swap console=ttyS0,115200n81 LANG=en_US.UTF-8 memmap=15G!4G crashkernel=384M
[    0.000000] x86/fpu: x87 FPU will use FXSAVE
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bf337fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf338000-0x00000000bf3b8fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3b9000-0x00000000bf3b9fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf3ba000-0x00000000bf3ccfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf3cd000-0x00000000bf3cdfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3ce000-0x00000000bf3defff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf3df000-0x00000000bf3e1fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3e2000-0x00000000bf446fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf447000-0x00000000bf451fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf452000-0x00000000bf45cfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf45d000-0x00000000bf47afff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf47b000-0x00000000bf67dfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf67e000-0x00000000bf7fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c0000000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x00000004bfffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: user-defined physical RAM map:
[    0.000000] user: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] user: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] user: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] user: [mem 0x0000000000100000-0x00000000bf337fff] usable
[    0.000000] user: [mem 0x00000000bf338000-0x00000000bf3b8fff] ACPI NVS
[    0.000000] user: [mem 0x00000000bf3b9000-0x00000000bf3b9fff] ACPI data
[    0.000000] user: [mem 0x00000000bf3ba000-0x00000000bf3ccfff] reserved
[    0.000000] user: [mem 0x00000000bf3cd000-0x00000000bf3cdfff] ACPI NVS
[    0.000000] user: [mem 0x00000000bf3ce000-0x00000000bf3defff] reserved
[    0.000000] user: [mem 0x00000000bf3df000-0x00000000bf3e1fff] ACPI NVS
[    0.000000] user: [mem 0x00000000bf3e2000-0x00000000bf446fff] reserved
[    0.000000] user: [mem 0x00000000bf447000-0x00000000bf451fff] ACPI data
[    0.000000] user: [mem 0x00000000bf452000-0x00000000bf45cfff] ACPI NVS
[    0.000000] user: [mem 0x00000000bf45d000-0x00000000bf47afff] reserved
[    0.000000] user: [mem 0x00000000bf47b000-0x00000000bf67dfff] ACPI NVS
[    0.000000] user: [mem 0x00000000bf67e000-0x00000000bf7fffff] usable
[    0.000000] user: [mem 0x00000000c0000000-0x00000000cfffffff] reserved
[    0.000000] user: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] user: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] user: [mem 0x0000000100000000-0x00000004bfffffff] persistent (type 12)
[    0.000000] SMBIOS 2.4 present.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
