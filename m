Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 91D1821184E78
 for <linux-nvdimm@lists.01.org>; Mon, 29 Oct 2018 10:34:35 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id k19-v6so7836451oic.11
 for <linux-nvdimm@lists.01.org>; Mon, 29 Oct 2018 10:34:35 -0700 (PDT)
MIME-Version: 1.0
References: <98c35e19-13b9-0913-87d9-b3f1ab738b61@linux.intel.com>
 <20181010185242.GP5873@dhcp22.suse.cz> <20181011085509.GS5873@dhcp22.suse.cz>
 <6f32f23c-c21c-9d42-7dda-a1d18613cd3c@linux.intel.com>
 <20181017075257.GF18839@dhcp22.suse.cz>
 <971729e6-bcfe-a386-361b-d662951e69a7@linux.intel.com>
 <20181029141210.GJ32673@dhcp22.suse.cz>
 <84f09883c16608ddd2ba88103f43ec6a1c649e97.camel@linux.intel.com>
 <20181029163528.GL32673@dhcp22.suse.cz>
 <18dfc5a0db11650ff31433311da32c95e19944d9.camel@linux.intel.com>
 <20181029172415.GM32673@dhcp22.suse.cz>
In-Reply-To: <20181029172415.GM32673@dhcp22.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 29 Oct 2018 10:34:22 -0700
Message-ID: <CAPcyv4goFsZR=O-P_KGrjV8hz0H=nqgYPGSGGLEnmtcagoTYrA@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] mm: Defer ZONE_DEVICE page initialization to the
 point where we init pgmap
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
Cc: Pasha Tatashin <pavel.tatashin@microsoft.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, rppt@linux.vnet.ibm.com, alexander.h.duyck@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 29, 2018 at 10:24 AM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Mon 29-10-18 10:01:28, Alexander Duyck wrote:
> > On Mon, 2018-10-29 at 17:35 +0100, Michal Hocko wrote:
[..]
> > > You are already doing per-page initialization so I fail to see a larger
> > > unit to operate on.
> >
> > I have a patch that makes it so that we can work at a pageblock level
> > since all of the variables with the exception of only the LRU and page
> > address fields can be precomputed. Doing that is one of the ways I was
> > able to reduce page init to 1/3 to 1/4 of the time it was taking
> > otherwise in the case of deferred page init.
>
> You still have to call set_page_links for each page. But let's assume we
> can do initialization per larger units. Nothing really prevent to hide
> that into constructor as well.

A constructor / indirect function call makes sense when there are
multiple sub-classes of object initialization, on the table I only see
3 cases: typical hotplug, base ZONE_DEVICE, ZONE_DEVICE + HMM. I think
we can look to move the HMM special casing out of line, then we're
down to 2. Even at 3 cases we're better off open-coding than a
constructor for such a low number of sub-cases to handle. I do not
foresee more cases arriving, so I struggle to see what the constructor
buys us in terms of code readability / maintainability?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
