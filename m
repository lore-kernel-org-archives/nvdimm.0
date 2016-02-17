Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1455749760.2925.291.camel@hpe.com>
Subject: Re: [PATCH 3/3] ACPI: Change NFIT driver to set PMEM type to iomem
 entry
From: Toshi Kani <toshi.kani@hpe.com>
Date: Wed, 17 Feb 2016 15:56:00 -0700
In-Reply-To: <CAPcyv4hSJCzUdt-7SjWoT49NSSnv4nzpC=K0rq1E6DWTb6ctkA@mail.gmail.com>
References: <1454439311-23690-1-git-send-email-toshi.kani@hpe.com>
	 <1454439311-23690-4-git-send-email-toshi.kani@hpe.com>
	 <CAPcyv4ik0GRYkYdaKvu4rPC9a+Q-e93uCZMpx1W8=Cvwwdh6jw@mail.gmail.com>
	 <1455316203.2925.132.camel@hpe.com>
	 <CAPcyv4i=TpX=V6mN0zrsqvUyonKY1WkbP=wJ0QqjQtj_kiSJQw@mail.gmail.com>
	 <1455674441.2925.204.camel@hpe.com>	<1455732020.2925.255.camel@hpe.com>
	 <CAPcyv4hSJCzUdt-7SjWoT49NSSnv4nzpC=K0rq1E6DWTb6ctkA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2016-02-17 at 11:34 -0800, Dan Williams wrote:
> On Wed, Feb 17, 2016 at 10:00 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> > On Tue, 2016-02-16 at 19:00 -0700, Toshi Kani wrote:
> > > On Fri, 2016-02-12 at 15:32 -0800, Dan Williams wrote:
> > > > On Fri, Feb 12, 2016 at 2:30 PM, Toshi Kani <toshi.kani@hpe.com>
> > > > wrote:
 :
> > > Here are three options I can think of.
> > > 
> > > 1) Set pmem type to "reserved" (This patch-set)
> > >  - Add a new iomem_set_desc(), which sets a given type to a top-level
> > > entry.  Change the ACPI NFIT driver to call it to set pmem type to
> > > "reserved" entry.
> > >  - region_intersects() finds a pmem entry by checking top-level
> > > entries (no change).
> > > 
> > > 2) Change region_intersects() to check children's type
> > >  - Add a new request_region_ext(), which is an extension to
> > > request_region() to allow specifying a type of resource.  It puts a
> > > new child entry under "reserved".  Change the pmem driver to call
> > > this func.
> > >  - Change region_intersects() to check children's type for finding
> > > this child pmem entry.
> > > 
> > > 3) Pmem driver to call insert_resource()
> > >  - Change the pmem driver to call insert_resource(), which puts a new
> > > pmem entry as the parent of "reserved".
> > >  - region_intersects() finds a pmem entry by checking top-level
> > > entries (no change).
> > >  - Add a new release_resource_self(), which releases a given entry
> > > and keeps its children if any.  Change the pmem driver to call it for
> > > release.
> > 
> > Thinking further, 3) needs to be modified as follows.  insert_resource(
> > ) should only be allowed for producers of resource (ex. nfit), not
> > consumers (ex. pmem).  It also needs to export insert_resource().
> > 
> > 3) NFIT driver to call insert_resource()
> >  - Change the ACPI nfit driver to call insert_resource() when a target
> > range is not marked as PMEM (i.e. "reserved") or not present in iomem.
> >  This puts a new PMEM entry as the parent of "reserved".
> >  - region_intersects() finds a pmem entry by checking top-level entries
> > (no change).
> >  - Add a new release_resource_self(), which releases a given entry and
> > keeps its children if any.  Change the nfit driver to call it for
> > release.
> > 
> > > This patch-set implements 1).  The pmem type is set to "reserved" for
> > > its life-cycle.  This option is simplest.
> > > 
> > > For 2), the changes to region_intersects() may be too complex for
> > > maintenance.
> > 
> > I should have said "region_intersects() may be overly complicated for
> > this purpose and maintenance".
> > 
> > > Here are a few examples when region_intersects() is called
> > > with addr [1-10] where iomem has entry P and its children.
> > > 
> > > Case A: P is fully covered by children C1 & C2.  region_intersects()
> > > ignores P's type, but checks C1 and C2's.
> > > 
> > >   P [1-10] + C1 [1-5]
> > >            + C2 [6-10]
> > > 
> > > Case B: C2 is fully covered by C3, but P is not.  region_intersects()
> > > ignores C2's type, but checks P, C1, C3's.
> > > 
> > >   P [1-10] + C1 [1-2]
> > >            + C2 [6-10] + C3 [6-10]
> > > 
> > > I think region_intersects() will need to construct a flat table from
> > > the tree while making recursive calls to walk thru all children.
> > > 
> > > 3) is similar to 2), but avoids the changes to region_intersects()
> > > since insert_resource() inserts a new entry as the parent to
> > > "reserved".
> > 
> > 3) is actually similar to 1) as both options change the producer side.
> > 
> > >  However, a new interface is necessary to put "reserved" back to top-
> > > level when releasing the added entry.
> > > 
> > > My recommendation is go with either 1) or 3).  What do you think?
> > 
> > I think we should modify the producer side, so 1) or 3) are still my
> > recommendation.
> > 
> 
> I think 3 is the most promising option.  It aligns the acpi/nfit
> driver closer with the acpi/pci_root driver that is also doing
> insert_resource() for each root bridge, and removing those resources
> when the bridge is disabled/removed.
> 
> I'd still want to maintain the ability of nfit to be built as a
> module, so we would need to split the resource registration into a
> separate built-in object file from nfit.ko.

Sounds good.  I will implement 3), and add an ACPI built-in wrapper
function to call insert_resource().

Thanks!
-Toshi
