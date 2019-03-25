Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <20190322132108.25501-1-sakari.ailus@linux.intel.com> <20190322132108.25501-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20190322132108.25501-3-sakari.ailus@linux.intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 25 Mar 2019 10:30:01 +0100
Message-ID: <CAJZ5v0i8JiQGk25yZKQqTzCCY+nrfoKXOH8nM6eNPhkN-i+y9w@mail.gmail.com>
Subject: Re: [PATCH 2/2] vsprintf: Remove support for %pF and %pf in favour of
 %pS and %ps
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Petr Mladek <pmladek@suse.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, sparclinux@vger.kernel.org, linux-um@lists.infradead.org, xen-devel@lists.xenproject.org, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Linux PM <linux-pm@vger.kernel.org>, drbd-dev@lists.linbit.com, linux-block@vger.kernel.org, linux-mmc <linux-mmc@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux PCI <linux-pci@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 22, 2019 at 2:21 PM Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
>
> %pS and %ps are now the preferred conversion specifiers to print function
> %names. The functionality is equivalent; remove the old, deprecated %pF
> %and %pf support.

Are %pF and %pf really not used any more in the kernel?

If that is not the case, you need to convert the remaining users of
them to using %ps or %pS before making support for them go away
completely.

That said, checkpatch can be made treat %pf/F as invalid format right away IMO.
