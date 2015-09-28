Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Tue, 29 Sep 2015 07:35:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] dax: fix deadlock in __dax_fault
Message-ID: <20150928213548.GX3902@dastard>
References: <1443040800-5460-1-git-send-email-ross.zwisler@linux.intel.com>
 <20150924025225.GT3902@dastard>
 <20150924155029.GA6008@linux.intel.com>
 <20150925025357.GU3902@dastard>
 <20150926031745.GA560@linux.intel.com>
 <20150928005904.GY19114@dastard>
 <CAPcyv4jfT2fvYPGFBgxynNAvJ4KoKX=_TZbpB4ieTQV25mmFkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jfT2fvYPGFBgxynNAvJ4KoKX=_TZbpB4ieTQV25mmFkQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 28, 2015 at 05:13:50AM -0700, Dan Williams wrote:
> On Sun, Sep 27, 2015 at 5:59 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, Sep 25, 2015 at 09:17:45PM -0600, Ross Zwisler wrote:
> >> On Fri, Sep 25, 2015 at 12:53:57PM +1000, Dave Chinner wrote:
> [..]
> >> Does this sound like a reasonable path forward for v4.3?  Dave, and Jan, can
> >> you guys can provide guidance and code reviews for the XFS and ext4 bits?
> >
> > IMO, it's way too much to get into 4.3. I'd much prefer we revert
> > the bad changes in 4.3, and then work towards fixing this for the
> > 4.4 merge window. If someone needs this for 4.3, then they can
> > backport the 4.4 code to 4.3-stable.
> >
> 
> If the proposal is to step back and get a running start at these fixes
> for 4.4, then it is worth considering what the state of allocating
> pages for DAX mappings will be in 4.4.

Oh, do tell. I haven't seen any published design, code, etc, and I
certainly haven't planned any time in the 4.4 window to do a
complete audit, rework and test of the XFS DAX code. So if you want
a working DAX implementation in the short term, we need to fix what
we have and not do wholesale changes to infrastructure that put us
back to square 1.

And, quite frankly, I'm not enabling any new DAX behaviour/subsystem
in XFS until I've had time to review, test and fix it so it works
without deadlocking or corrupting data.

> It's already that case that
> allocating struct page for DAX mappings is the only solution on the
> horizon for enabling a get_user_pages() solution for persistent
> memory.  We of course need to get the page-less DAX path fixed up, but
> the near-term path to full functionality and safety is when struct
> page is available to enable the typical synchronization mechanics.

And we do so at the expense of medium to long term complexity and
maintenance. I'm no fan of using struct pages to track terabytes to
petabytes of persistent memory, and I'm even less of a fan of having
to simultaneously support both struct page and pfn based DAX
subsystems...

> That said, it's not clear that saves us any work given the axonram and
> dcssblk DAX drivers do not currently allocate struct page, and pmem
> optionally allocates struct page.

Precisely my point.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
