Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AA48121BADAB9
 for <linux-nvdimm@lists.01.org>; Mon, 29 Oct 2018 10:45:52 -0700 (PDT)
Date: Mon, 29 Oct 2018 18:45:49 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v5 4/4] mm: Defer ZONE_DEVICE page initialization to the
 point where we init pgmap
Message-ID: <20181029174549.GN32673@dhcp22.suse.cz>
References: <20181011085509.GS5873@dhcp22.suse.cz>
 <6f32f23c-c21c-9d42-7dda-a1d18613cd3c@linux.intel.com>
 <20181017075257.GF18839@dhcp22.suse.cz>
 <971729e6-bcfe-a386-361b-d662951e69a7@linux.intel.com>
 <20181029141210.GJ32673@dhcp22.suse.cz>
 <84f09883c16608ddd2ba88103f43ec6a1c649e97.camel@linux.intel.com>
 <20181029163528.GL32673@dhcp22.suse.cz>
 <18dfc5a0db11650ff31433311da32c95e19944d9.camel@linux.intel.com>
 <20181029172415.GM32673@dhcp22.suse.cz>
 <CAPcyv4goFsZR=O-P_KGrjV8hz0H=nqgYPGSGGLEnmtcagoTYrA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4goFsZR=O-P_KGrjV8hz0H=nqgYPGSGGLEnmtcagoTYrA@mail.gmail.com>
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
Cc: Pasha Tatashin <pavel.tatashin@microsoft.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Linux MM <linux-mm@kvack.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, rppt@linux.vnet.ibm.com, alexander.h.duyck@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon 29-10-18 10:34:22, Dan Williams wrote:
> On Mon, Oct 29, 2018 at 10:24 AM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > On Mon 29-10-18 10:01:28, Alexander Duyck wrote:
> > > On Mon, 2018-10-29 at 17:35 +0100, Michal Hocko wrote:
> [..]
> > > > You are already doing per-page initialization so I fail to see a larger
> > > > unit to operate on.
> > >
> > > I have a patch that makes it so that we can work at a pageblock level
> > > since all of the variables with the exception of only the LRU and page
> > > address fields can be precomputed. Doing that is one of the ways I was
> > > able to reduce page init to 1/3 to 1/4 of the time it was taking
> > > otherwise in the case of deferred page init.
> >
> > You still have to call set_page_links for each page. But let's assume we
> > can do initialization per larger units. Nothing really prevent to hide
> > that into constructor as well.
> 
> A constructor / indirect function call makes sense when there are
> multiple sub-classes of object initialization, on the table I only see
> 3 cases: typical hotplug, base ZONE_DEVICE, ZONE_DEVICE + HMM. I think
> we can look to move the HMM special casing out of line, then we're
> down to 2. Even at 3 cases we're better off open-coding than a
> constructor for such a low number of sub-cases to handle. I do not
> foresee more cases arriving, so I struggle to see what the constructor
> buys us in terms of code readability / maintainability?

I haven't dreamed of ZONE_DEVICE and HMM few years back. But anyway,
let me note that I am not in love with callbacks. I find them to be a
useful abstraction. I can be convinced (by numbers) that special casing
inside the core hotplug code is really beneficial. But let's do that at
a single place.

All I am arguing against throughout this thread is the
memmap_init_zone_device and the whole code duplication just because zone
device need something special.

-- 
Michal Hocko
SUSE Labs
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
