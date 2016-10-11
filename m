Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Tue, 11 Oct 2016 14:42:16 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [RFC KERNEL PATCH 0/2] Add Dom0 NVDIMM support for Xen
Message-ID: <20161011184215.GB23193@localhost.localdomain>
References: <20161010003523.4423-1-haozhong.zhang@intel.com>
 <dde78bbd-4739-98a1-4b69-2c2dff0a9d71@citrix.com>
 <57FCF26A02000078000F15E0@prv-mh.provo.novell.com>
 <CAPcyv4gD3JTq93ET0SAYOxyPO9c0RTkPKSQKqZLo_8KPn53TiA@mail.gmail.com>
 <20161011165811.GO19349@localhost.localdomain>
 <CAPcyv4jX_xzj=gz=tfoNMx0qFtyeKwqttzCE5GrOi6Kz5anhiQ@mail.gmail.com>
 <76b01877-40e4-1107-5c13-da98c8e1152e@citrix.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <76b01877-40e4-1107-5c13-da98c8e1152e@citrix.com>
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
To: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: Juergen Gross <JGross@suse.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stefano Stabellini <stefano@aporeto.com>, David Vrabel <david.vrabel@citrix.com>, Jan Beulich <jbeulich@suse.com>, xen-devel@lists.xenproject.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 11, 2016 at 07:15:42PM +0100, Andrew Cooper wrote:
> On 11/10/16 18:51, Dan Williams wrote:
> > On Tue, Oct 11, 2016 at 9:58 AM, Konrad Rzeszutek Wilk
> > <konrad.wilk@oracle.com> wrote:
> >> On Tue, Oct 11, 2016 at 08:53:33AM -0700, Dan Williams wrote:
> >>> On Tue, Oct 11, 2016 at 6:08 AM, Jan Beulich <jbeulich@suse.com> wrote:
> >>>>>>> Andrew Cooper <andrew.cooper3@citrix.com> 10/10/16 6:44 PM >>>
> >>>>> On 10/10/16 01:35, Haozhong Zhang wrote:
> >>>>>> Xen hypervisor needs assistance from Dom0 Linux kernel for following tasks:
> >>>>>> 1) Reserve an area on NVDIMM devices for Xen hypervisor to place
> >>>>>>    memory management data structures, i.e. frame table and M2P table.
> >>>>>> 2) Report SPA ranges of NVDIMM devices and the reserved area to Xen
> >>>>>>    hypervisor.
> >>>>> However, I can't see any justification for 1).  Dom0 should not be
> >>>>> involved in Xen's management of its own frame table and m2p.  The mfns
> >>>>> making up the pmem/pblk regions should be treated just like any other
> >>>>> MMIO regions, and be handed wholesale to dom0 by default.
> >>>> That precludes the use as RAM extension, and I thought earlier rounds of
> >>>> discussion had got everyone in agreement that at least for the pmem case
> >>>> we will need some control data in Xen.
> >>> The missing piece for me is why this reservation for control data
> >>> needs to be done in the libnvdimm core?  I would expect that any dax
> >> Isn't it done this way with Linux? That is say if the machine has
> >> 4GB of RAM and the NVDIMM is in TB range. You want to put the 'struct page'
> >> for the NVDIMM ranges somewhere. That place can be in regions on the
> >> NVDIMM that ndctl can reserve.
> > Yes.
> 
> I do not see any sensible usecase for Xen to use NVDIMMs as plain RAM;

I just gave you one. This is the 'usecase' that Linux has to deal with
now that the core kernel folks have pointed out that they don't want
'struct page' for the MMIO regions. This mechanism came about this and
finding a place _somewhere_ to deal with having to have 'struct page'
for the SPA ranges of the NVDIMM.

> NVDIMMs are far more valuable for higher level management in dom0.

Andrew, why are you providing input to this so late?

Haozhong provided an nice design document outlining the problem and
the solution he suggested.

> 
> I certainly think that such a usecase should be out-of-scope for initial
> Xen/NVDIMM support, even if only to reduce the complexity to start with.
> 
> A repeated complain I have of large feature submissions like this is
> that, by trying to solve all potential usecases at one, end up being
> overly complicated to develop, understand and review.

On the other hand - if you don't take these complicated issues from the
start, then you may have to redesign and redevelop this after the first
version which has been set in stone and committed.

> 
> >
> >>> capable file could be mapped and made available to a guest.  This
> >>> includes /dev/ramX devices that are dax capable, but are external to
> >>> the libnvdimm sub-system.
> >> This is more of just keeping track of the ranges if say the DAX file is
> >> extremely fragmented and requires a lot of 'struct pages' to keep track of
> >> when stiching up the VMA.
> > Right, but why does the libnvdimm core need to know about this
> > specific Xen reservation?  For example, if Xen wants some in-kernel
> > driver to own a pmem region and place its own metadata on the device I
> > would recommend something like:
> >
> >     bdev = blkdev_get_by_path("/dev/pmemX",  FMODE_EXCL...);
> >     bdev_direct_access(bdev, ...);
> >
> > ...in other words, I don't think we want libnvdimm to grow new device
> > types for every possible in-kernel user, Xen, MD, DM, etc. Instead,
> > just claim the resulting device.
> 
> I completely agree.
> 
> Whatever ends up happening between Xen and dom0, there should be no
> modifications like this to the nvdimm driver.  I will go so far as to
> say that there shouldn't be any modifications to the nvdimm driver
> (other than perhaps new query hooks so the Xen subsystem in Linux can
> query information to then pass up to Xen, if the existing queryability
> is insufficient).

Haozhong and Jan had been chatting about this in terms of how to keep
track of a guest having non-contingous SPAs of NVDIMM stiched to a guest.

The initial idea was to treat it as MMIO, but of course if you have 1
page ranges over say 1TB you end up consuming tons of memory to keep
track of this (the same way Linux would if you wanted to mmap an file
from DAX fs).

Other solutions were an bitmap, but that can also be cumbersome to deal
with. In the end the suggestion that was proposed was the one that Linux
choose - stash the 'struct page' in the NVDIMM.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
