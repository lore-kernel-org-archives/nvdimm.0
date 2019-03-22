Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <20190322132108.25501-1-sakari.ailus@linux.intel.com>
In-Reply-To: <20190322132108.25501-1-sakari.ailus@linux.intel.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 22 Mar 2019 14:37:18 +0100
Message-ID: <CAMuHMdVmqqjVx7As9AAywYxYXG=grijF5rF77OBn6TUjM9+xKw@mail.gmail.com>
Subject: Re: [PATCH 0/2] Remove support for deprecated %pf and %pF in vsprintf
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Petr Mladek <pmladek@suse.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, Linux MMC List <linux-mmc@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-um@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, netdev <netdev@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>, sparclinux <sparclinux@vger.kernel.org>, xen-devel@lists.xenproject.org, ceph-devel <ceph-devel@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Linux MM <linux-mm@kvack.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Lars Ellenberg <drbd-dev@lists.linbit.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Sakari,

On Fri, Mar 22, 2019 at 2:25 PM Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> The printk family of functions supports %ps and %pS conversion specifiers
> to print function names. Yet the deprecated %pf and %pF conversion
> specifiers with equivalent functionality remain supported. A number of
> users of %pf and %pF remain.
>
> This patchsets converts the existing users of %pf and %pF to %ps and %pS,
> respectively, and removes support for the deprecated %pf and %pF.
>
> The patches apply cleanly both on 5.1-rc1 as well as on Linux-next. No new
> %pf or %pF users have been added in the meantime so the patch is
> sufficient as itself on linux-next, too.

Do you know in which commit they became deprecated, so the backporters
know how far this can be backported safely?

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
