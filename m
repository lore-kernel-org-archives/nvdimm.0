Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6A595211E82E1
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 06:53:58 -0700 (PDT)
Date: Fri, 22 Mar 2019 15:53:50 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH 0/2] Remove support for deprecated %pf and %pF in vsprintf
Message-ID: <20190322135350.2btpno7vspvewxvk@paasikivi.fi.intel.com>
References: <20190322132108.25501-1-sakari.ailus@linux.intel.com>
 <CAMuHMdVmqqjVx7As9AAywYxYXG=grijF5rF77OBn6TUjM9+xKw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAMuHMdVmqqjVx7As9AAywYxYXG=grijF5rF77OBn6TUjM9+xKw@mail.gmail.com>
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
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Petr Mladek <pmladek@suse.com>, scsi <linux-scsi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-pci <linux-pci@vger.kernel.org>, linux-um@lists.infradead.org, Linux PM list <linux-pm@vger.kernel.org>, Linux MMC List <linux-mmc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, netdev <netdev@vger.kernel.org>, sparclinux <sparclinux@vger.kernel.org>, xen-devel@lists.xenproject.org, ceph-devel <ceph-devel@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Linux MM <linux-mm@kvack.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Lars Ellenberg <drbd-dev@lists.linbit.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Geert,

On Fri, Mar 22, 2019 at 02:37:18PM +0100, Geert Uytterhoeven wrote:
> Hi Sakari,
> 
> On Fri, Mar 22, 2019 at 2:25 PM Sakari Ailus
> <sakari.ailus@linux.intel.com> wrote:
> > The printk family of functions supports %ps and %pS conversion specifiers
> > to print function names. Yet the deprecated %pf and %pF conversion
> > specifiers with equivalent functionality remain supported. A number of
> > users of %pf and %pF remain.
> >
> > This patchsets converts the existing users of %pf and %pF to %ps and %pS,
> > respectively, and removes support for the deprecated %pf and %pF.
> >
> > The patches apply cleanly both on 5.1-rc1 as well as on Linux-next. No new
> > %pf or %pF users have been added in the meantime so the patch is
> > sufficient as itself on linux-next, too.
> 
> Do you know in which commit they became deprecated, so the backporters
> know how far this can be backported safely?

That appears to be 04b8eb7a4ccd
("symbol lookup: introduce dereference_symbol_descriptor()"), the same
patch that made %p[fF] and %p[sS] functionally equivalent.

But my personal opinion would be not to backport the patch for two reasons:
the sheer number of files it touches (those format strings change for
various reasons) and the meager benefits it has on older kernels as any
backported patch using %s or %S still works as such. Porting a patch
forward should have no issues either as checkpatch.pl has been complaining
of the use of %pf and %pF for a while now.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
