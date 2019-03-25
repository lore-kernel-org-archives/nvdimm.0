Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6AA53211E95A9
 for <linux-nvdimm@lists.01.org>; Mon, 25 Mar 2019 08:13:12 -0700 (PDT)
Date: Mon, 25 Mar 2019 17:13:00 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH 0/2] Remove support for deprecated %pf and %pF in vsprintf
Message-ID: <20190325151259.2w22y4ijqilrbaxj@kekkonen.localdomain>
References: <20190322132108.25501-1-sakari.ailus@linux.intel.com>
 <CAMuHMdVmqqjVx7As9AAywYxYXG=grijF5rF77OBn6TUjM9+xKw@mail.gmail.com>
 <20190322135350.2btpno7vspvewxvk@paasikivi.fi.intel.com>
 <20190322170550.GX9224@smile.fi.intel.com>
 <20190324211008.lypghym3gqcp62th@mara.localdomain>
 <20190324211932.GK9224@smile.fi.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190324211932.GK9224@smile.fi.intel.com>
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
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Petr Mladek <pmladek@suse.com>, scsi <linux-scsi@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>, linux-um@lists.infradead.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux MMC List <linux-mmc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, netdev <netdev@vger.kernel.org>, sparclinux <sparclinux@vger.kernel.org>, xen-devel@lists.xenproject.org, ceph-devel <ceph-devel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Lars Ellenberg <drbd-dev@lists.linbit.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Andy,

On Sun, Mar 24, 2019 at 11:19:32PM +0200, Andy Shevchenko wrote:
> On Sun, Mar 24, 2019 at 11:10:08PM +0200, Sakari Ailus wrote:
> > On Fri, Mar 22, 2019 at 07:05:50PM +0200, Andy Shevchenko wrote:
> > > On Fri, Mar 22, 2019 at 03:53:50PM +0200, Sakari Ailus wrote:
> > > 
> > > > Porting a patch
> > > > forward should have no issues either as checkpatch.pl has been complaining
> > > > of the use of %pf and %pF for a while now.
> > > 
> > > And that's exactly the reason why I think instead of removing warning on
> > > checkpatch, it makes sense to convert to an error for a while. People are
> > > tending read documentation on internet and thus might have outdated one. And
> > > yes, the compiler doesn't tell a thing about it.
> > > 
> > > P.S. Though, if majority of people will tell that I'm wrong, then it's okay to
> > > remove.
> > 
> > I wonder if you wrote this before seeing my other patchset.
> 
> Yes, I wrote it before seeing another series.
> 
> > What I think could be done is to warn of plain %pf (without following "w")
> > in checkpatch.pl, and %pf that is not followed by "w" in the kernel.
> > Although we didn't have such checks to begin with. The case is still a
> > little bit different as %pf used to be a valid conversion specifier whereas
> > %pO likely has never existed.
> > 
> > So, how about adding such checks in the other set? I can retain %p[fF] check
> > here, too, if you like.
> 
> Consistency tells me that the warning->error transformation in checkpatch.pl
> belongs this series.

All other invalid pointer conversion specifiers currently result into a
warning only. I see that as an orthogonal change to this set. I found
another issue in checkpatch.pl that may require some discussion; would you
be ok with addressing this in another set?

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
