Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8507C2215239B
 for <linux-nvdimm@lists.01.org>; Mon,  4 Dec 2017 08:56:44 -0800 (PST)
Received: by mail-oi0-x230.google.com with SMTP id t81so12152345oih.13
 for <linux-nvdimm@lists.01.org>; Mon, 04 Dec 2017 09:01:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171204093156.mp36zkcwrxkenixb@dhcp22.suse.cz>
References: <20171130095323.ovrq2nenb6ztiapy@dhcp22.suse.cz>
 <CAPcyv4giMvMfP=yZr=EDRAdTWyCwWydb4JVhT6YSWP8W0PHgGQ@mail.gmail.com>
 <20171130174201.stbpuye4gu5rxwkm@dhcp22.suse.cz>
 <CAPcyv4h5GUueqB-QhbWbn39SBPDE-rOte6UcmAHSWQdVyrF2Rw@mail.gmail.com>
 <20171130181741.2y5nyflyhqxg6y5p@dhcp22.suse.cz>
 <CAPcyv4hwsGQCUcTdpT7UVJyPN0RJz+CAqGNvTSK9Ka1nsypQjA@mail.gmail.com>
 <20171130190117.GF7754@ziepe.ca>
 <20171201101218.mxjyv4fc4cjwhf2o@dhcp22.suse.cz>
 <20171201160204.GI7754@ziepe.ca>
 <CAPcyv4hvk8rfV_=5EX3QPFLZ=LB4=hWG5h4Z42koNYim9DB3FQ@mail.gmail.com>
 <20171204093156.mp36zkcwrxkenixb@dhcp22.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 4 Dec 2017 09:01:12 -0800
Message-ID: <CAPcyv4gpaYwOuq9WJ=WoDeFknw=1ZrGzV0CVDgqLEmUqAuQc9A@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] mm: introduce get_user_pages_longterm
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
To: Michal Hocko <mhocko@kernel.org>
Cc: Linux MM <linux-mm@kvack.org>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Dec 4, 2017 at 1:31 AM, Michal Hocko <mhocko@kernel.org> wrote:
>
> On Fri 01-12-17 08:29:53, Dan Williams wrote:
> > On Fri, Dec 1, 2017 at 8:02 AM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > >
> > > On Fri, Dec 01, 2017 at 11:12:18AM +0100, Michal Hocko wrote:
> > > > On Thu 30-11-17 12:01:17, Jason Gunthorpe wrote:
> > > > > On Thu, Nov 30, 2017 at 10:32:42AM -0800, Dan Williams wrote:
> > > > > > > Who and how many LRU pages can pin that way and how do you prevent nasty
> > > > > > > users to DoS systems this way?
> > > > > >
> > > > > > I assume this is something the RDMA community has had to contend with?
> > > > > > I'm not an RDMA person, I'm just here to fix dax.
> > > > >
> > > > > The RDMA implementation respects the mlock rlimit
> > > >
> > > > OK, so then I am kind of lost in why do we need a special g-u-p variant.
> > > > The documentation doesn't say and quite contrary it assumes that the
> > > > caller knows what he is doing. This cannot be the right approach.
> > >
> > > I thought it was because get_user_pages_longterm is supposed to fail
> > > on DAX mappings?
> >
> > Correct, the rlimit checks are a separate issue,
> > get_user_pages_longterm is only there to avoid open coding vma lookup
> > and vma_is_fsdax() checks in multiple code paths.
>
> Then it is a terrible misnomer. One would expect this is a proper way to
> get a longterm pin on a page.

Yes, I can see that. The "get_user_pages_longterm" symbol name is
encoding the lifetime expectations of the caller vs properly
implementing 'longterm' pinning. However the proper interface to
establish a long term pin does not currently exist needs and
ultimately needs more coordination with userspace. We need a way for
the kernel to explicitly revoke the pin. So, this
get_user_pages_longterm change is only a stop-gap to prevent data
corruption and userspace from growing further expectations that
filesystem-dax supports long term pinning through the legacy
interfaces.

> > > And maybe we should think about moving the rlimit accounting into this
> > > new function too someday?
> >
> > DAX pages are not accounted in any rlimit because they are statically
> > allocated reserved memory regions.
>
> Which is OK, but how do you prevent anybody calling this function on
> normal LRU pages?

I don't, and didn't consider this angle as it's a consideration that
is missing from the existing gup interfaces. It is an additional gap
we need to fill.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
