Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
 [150.101.137.145])
 by ml01.01.org (Postfix) with ESMTP id C889920945BB0
 for <linux-nvdimm@lists.01.org>; Sun,  1 Oct 2017 14:56:43 -0700 (PDT)
Date: Mon, 2 Oct 2017 08:59:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 0/4] dax: require 'struct page' and other fixups
Message-ID: <20171001215959.GF15067@dastard>
References: <150664806143.36094.11882924009668860273.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171001075701.GB11554@lst.de>
 <CAPcyv4gKYOdDP_jYJvPaozaOBkuVa-cf8x6TGEbEhzNfxaxhGw@mail.gmail.com>
 <20171001211147.GE15067@dastard>
 <CAPcyv4hLgGb0sO1=qGxt83zumKt82RA8dUr=_1Gaqew7hxajXg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hLgGb0sO1=qGxt83zumKt82RA8dUr=_1Gaqew7hxajXg@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Oct 01, 2017 at 02:22:08PM -0700, Dan Williams wrote:
> On Sun, Oct 1, 2017 at 2:11 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Sun, Oct 01, 2017 at 10:58:06AM -0700, Dan Williams wrote:
> >> On Sun, Oct 1, 2017 at 12:57 AM, Christoph Hellwig <hch@lst.de> wrote:
> >> > While this looks like a really nice cleanup of the code and removes
> >> > nasty race conditions I'd like to understand the tradeoffs.
> >> >
> >> > This now requires every dax device that is used with a file system
> >> > to have a struct page backing, which means not only means we'd
> >> > break existing setups, but also a sharp turn from previous policy.
> >> >
> >> > Unless I misremember it was you Intel guys that heavily pushed for
> >> > the page-less version, so I'd like to understand why you've changed
> >> > your mind.
> >>
> >> Sure, here's a quick recap of the story so far of how we got here:
> >>
> >> * In support of page-less I/O operations envisioned by Matthew I
> >> introduced pfn_t as a proposal for converting the block layer and
> >> other sub-systems to use pfns instead of pages [1]. You helped out on
> >> that patch set with some work on the DMA api. [2]
> >>
> >> * The DMA api conversion effort came to a halt when it came time to
> >> touch sparc paths and DaveM said [3]: "Generally speaking, I think
> >> that all actual physical memory the kernel operates on should have a
> >> struct page backing it."
> >>
> >> * ZONE_DEVICE was created to solve the DMA problem and in developing /
> >> testing that discovered plenty of proof for Dave's assertion (no fork,
> >> no ptrace, etc). We should have made the switch to require struct page
> >> at that point, but I was persuaded by the argument that changing the
> >> dax policy may break existing assumptions, and that there were larger
> >> issues to go solve at the time.
> >>
> >> What changed recently was the discussions around what the dax mount
> >> option means and the assertion that we can, in general, make some
> >> policy changes on our way to removing the "experimental" designation
> >> from filesystem-dax. It is clear that the page-less dax path remains
> >> experimental with all the way it fails in several kernel paths, and
> >> there has been no patches for several months to revive the effort.
> >> Meanwhile the page-less path continues to generate maintenance
> >> overhead. The recent gymnastics (new ->post_mmap file_operation) to
> >> make sure ->vm_flags are safely manipulated when dynamically changing
> >> the dax mode of a file was the final straw for me to pull the trigger
> >> on this series.
> >>
> >> In terms of what breaks by changing this policy it should be noted
> >> that we automatically create pages for "legacy" pmem devices, and the
> >> default for "ndctl create-namespace" is to allocate pages. I have yet
> >> to see a bug report where someone was surprised by fork failing or
> >> direct-I/O causing a SIGBUS. So, I think the defaults are working, it
> >> is unlikely that there are environments dependent on page-less
> >> behavior.
> >
> > Does this imply that the hardware vendors won't have
> > tens of terabytes of pmem in systems in the near to medium term?
> > That's what we were originally told to expect by 2018-19 timeframe
> > (i.e. 5 years in), and that's kinda what we've been working towards.
> > Indeed, supporting systems with a couple of orders of magnitude more
> > pmem than ram was the big driver for page-less DAX mappings in the
> > first place. i.e. it was needed to avoid the static RAM overhead of
> > all the static struct pages for such large amounts of physical
> > memory.
> >
> > If we decide that we must have struct pages for pmem, then we're
> > essentially throwing away the ability to support the very systems
> > the hardware vendors were telling us we needed to design the pmem
> > infrastructure for.  If that reality has changed, then I'd suggest
> > that we need to determine what the long term replacement for
> > pageless IO on large pmem systems will be before we throw what we
> > have away.
> 
> No, we can support large pmem with struct page capacity reserved from
> pmem itself rather than ram. A 1.5% capacity tax does not appear to be
> prohibitive.

The "capacity tax" had nothing to do with it - the major problem
with self hosting struct pages was that page locks can be hot and
contention on them will rapidly burn through write cycles on the
pmem. That's still a problem, yes?

I don't want to have to ask about all the issues one by one, so I'll
ask you to explain in one go: what has changed (both hardware and
software!) since we last discussed these problems with self hosting
and make it a viable solution?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
