Return-Path: <owner-linux-mm@kvack.org>
Date: Fri, 7 Jun 2019 12:54:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v9 11/12] libnvdimm/pfn: Fix fsdax-mode namespace
 info-block zero-fields
Message-Id: <20190607125430.81e63cd56590ab3fea37a635@linux-foundation.org>
In-Reply-To: <CAPcyv4hHs75hYs+Ye+NHHiU31C6CnBqCFdo=2c5seN7kvxKOrw@mail.gmail.com>
References: <155977186863.2443951.9036044808311959913.stgit@dwillia2-desk3.amr.corp.intel.com>
	<155977193862.2443951.10284714500308539570.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20190606144643.4f3363db9499ebbf8f76e62e@linux-foundation.org>
	<CAPcyv4hHs75hYs+Ye+NHHiU31C6CnBqCFdo=2c5seN7kvxKOrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: stable <stable@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Oscar Salvador <osalvador@suse.de>, Michal Hocko <mhocko@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 6 Jun 2019 15:06:26 -0700 Dan Williams <dan.j.williams@intel.com> wrote:

> On Thu, Jun 6, 2019 at 2:46 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Wed, 05 Jun 2019 14:58:58 -0700 Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > > At namespace creation time there is the potential for the "expected to
> > > be zero" fields of a 'pfn' info-block to be filled with indeterminate
> > > data. While the kernel buffer is zeroed on allocation it is immediately
> > > overwritten by nd_pfn_validate() filling it with the current contents of
> > > the on-media info-block location. For fields like, 'flags' and the
> > > 'padding' it potentially means that future implementations can not rely
> > > on those fields being zero.
> > >
> > > In preparation to stop using the 'start_pad' and 'end_trunc' fields for
> > > section alignment, arrange for fields that are not explicitly
> > > initialized to be guaranteed zero. Bump the minor version to indicate it
> > > is safe to assume the 'padding' and 'flags' are zero. Otherwise, this
> > > corruption is expected to benign since all other critical fields are
> > > explicitly initialized.
> > >
> > > Fixes: 32ab0a3f5170 ("libnvdimm, pmem: 'struct page' for pmem")
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >
> > The cc:stable in [11/12] seems odd.  Is this independent of the other
> > patches?  If so, shouldn't it be a standalone thing which can be
> > prioritized?
> >
> 
> The cc: stable is about spreading this new policy to as many kernels
> as possible not fixing an issue in those kernels. It's not until patch
> 12 "libnvdimm/pfn: Stop padding pmem namespaces to section alignment"
> as all previous kernel do initialize all fields.
> 
> I'd be ok to drop that cc: stable, my concern is distros that somehow
> pickup and backport patch 12 and miss patch 11.

Could you please propose a changelog paragraph which explains all this
to those who will be considering this patch for backports?
