Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1455674441.2925.204.camel@hpe.com>
Subject: Re: [PATCH 3/3] ACPI: Change NFIT driver to set PMEM type to iomem
 entry
From: Toshi Kani <toshi.kani@hpe.com>
Date: Tue, 16 Feb 2016 19:00:41 -0700
In-Reply-To: <CAPcyv4i=TpX=V6mN0zrsqvUyonKY1WkbP=wJ0QqjQtj_kiSJQw@mail.gmail.com>
References: <1454439311-23690-1-git-send-email-toshi.kani@hpe.com>
	 <1454439311-23690-4-git-send-email-toshi.kani@hpe.com>
	 <CAPcyv4ik0GRYkYdaKvu4rPC9a+Q-e93uCZMpx1W8=Cvwwdh6jw@mail.gmail.com>
	 <1455316203.2925.132.camel@hpe.com>
	 <CAPcyv4i=TpX=V6mN0zrsqvUyonKY1WkbP=wJ0QqjQtj_kiSJQw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Andrew Morton <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2016-02-12 at 15:32 -0800, Dan Williams wrote:
> On Fri, Feb 12, 2016 at 2:30 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
> > On Fri, 2016-02-12 at 11:41 -0800, Dan Williams wrote:
> > > On Tue, Feb 2, 2016 at 10:55 AM, Toshi Kani <toshi.kani@hpe.com> wro
 :
> > > Hmm, if we set the type on driver load, should we clear the type on
> > > driver unload?
> > 
> > I think this type update should stay for the life-cycle of this iomem
> > entry itself since this range is PMEM even after the driver is
> > unloaded.  This is an extension of the boot-time iomem table
> > initialization from e820/EFI, which allows ACPI to set a correct
> > type.  This is independent from driver's resource allocations.
> > 
> > > Actually it might be more straightforward to specify a type at
> > > request_region() time.  That way it gets released at
> > > release_region().  We're already setting a resource name at
> > > request_region time, adding a type annotation at the time seems
> > > appropriate.
> > 
> > I first considered simply setting "namespaceX.X" as PMEM.  However,
> > region_intersects() and its friends only check the top-level entries,
> > not their children, of the iomem table.  And I think a child should
> > have the same type as the parent as I fixed it in patch 1/3.
> 
> Did we investigate updating region_intersects() to check children?
> When a child sub-divides a region with different types it may be the
> wrong answer to check the parent.  Is there a problem with moving
> checking to the child?

Here are three options I can think of.

1) Set pmem type to "reserved" (This patch-set)
 - Add a new iomem_set_desc(), which sets a given type to a top-level
entry.  Change the ACPI NFIT driver to call it to set pmem type to
"reserved" entry.
 - region_intersects() finds a pmem entry by checking top-level entries (no
change).

2) Change region_intersects() to check children's type
 - Add a new request_region_ext(), which is an extension to
request_region() to allow specifying a type of resource.  It puts a new
child entry under "reserved".  Change the pmem driver to call this func.
 - Change region_intersects() to check children's type for finding this
child pmem entry.

3) Pmem driver to call insert_resource()
 - Change the pmem driver to call insert_resource(), which puts a new pmem
entry as the parent of "reserved".
 - region_intersects() finds a pmem entry by checking top-level entries (no
change).
 - Add a new release_resource_self(), which releases a given entry and
keeps its children if any.  Change the pmem driver to call it for release.


This patch-set implements 1).  The pmem type is set to "reserved" for its
life-cycle.  This option is simplest.

For 2), the changes to region_intersects() may be too complex for
maintenance.  Here are a few examples when region_intersects() is called
with addr [1-10] where iomem has entry P and its children.

Case A: P is fully covered by children C1 & C2.  region_intersects()
ignores P's type, but checks C1 and C2's.
  
  P [1-10] + C1 [1-5]
           + C2 [6-10]

Case B: C2 is fully covered by C3, but P is not.  region_intersects()
ignores C2's type, but checks P, C1, C3's.

  P [1-10] + C1 [1-2]
           + C2 [6-10] + C3 [6-10]

I think region_intersects() will need to construct a flat table from the
tree while making recursive calls to walk thru all children.

3) is similar to 2), but avoids the changes to region_intersects() since
insert_resource() inserts a new entry as the parent to "reserved".
 However, a new interface is necessary to put "reserved" back to top-level
when releasing the added entry.

My recommendation is go with either 1) or 3).  What do you think?

Thanks,
-Toshi
