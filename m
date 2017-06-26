Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0329521A00AC6
 for <linux-nvdimm@lists.01.org>; Mon, 26 Jun 2017 12:31:21 -0700 (PDT)
Date: Mon, 26 Jun 2017 13:31:16 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH] libnvdimm, btt: BTT updates for UEFI 2.7 format
Message-ID: <20170626193115.GA4947@omniknight.lm.intel.com>
References: <20170624021736.26632-1-vishal.l.verma@intel.com>
 <CAPcyv4iny0uz1=7tQhQKwYQ=Cg0ETDQcnwnNHddJuYZQsHrVBg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iny0uz1=7tQhQKwYQ=Cg0ETDQcnwnNHddJuYZQsHrVBg@mail.gmail.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 06/25, Dan Williams wrote:
> On Fri, Jun 23, 2017 at 7:17 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> > The UEFI 2.7 specification defines an updated BTT metadata format,
> > bumping the revision to 2.0. Add support for the new format, while
> > retaining compatibility for the old 1.1 format.
> >
> > New BTTs will be created using the newest (2.0 as of this writing)
> > format.
> >
> > Cc: Toshi Kani <toshi.kani@hpe.com>
> > Cc: Linda Knippers <linda.knippers@hpe.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > ---
> >  drivers/nvdimm/btt.c      | 28 ++++++++++++++++++++--------
> >  drivers/nvdimm/btt.h      |  7 +++++++
> >  drivers/nvdimm/btt_devs.c | 44 +++++++++++++++++++++++++++++++++++++++-----
> >  drivers/nvdimm/nd.h       |  1 +
> >  4 files changed, 67 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> > index 983718b..629c376 100644
> > --- a/drivers/nvdimm/btt.c
> > +++ b/drivers/nvdimm/btt.c
> [..]
> > @@ -576,8 +576,10 @@ static struct arena_info *alloc_arena(struct btt *btt, size_t size,
> >         arena->internal_lbasize = roundup(arena->external_lbasize,
> >                                         INT_LBASIZE_ALIGNMENT);
> >         arena->nfree = BTT_DEFAULT_NFREE;
> > -       arena->version_major = 1;
> > -       arena->version_minor = 1;
> > +
> > +       /* New BTTs will always be v2.0 */
> > +       arena->version_major = 2;
> > +       arena->version_minor = 0;
> 
> I don't think this is correct. The v2.0 format is generally more
> dangerous than v1.1 because its info block can coexist with other
> nvdimm info-blocks and fs-super-blocks. So we should always default to
> v1.1 unless explicitly forced into v2.0 mode with the claim-class /
> address-abstraction-guid set in the v1.2 namespace label. Without that
> indicator to tie break ambiguous situations we can't use the v2.0
> format which is strictly for inter-OS / UEFI compatibility.

Hm, I tend to agree, but in that case, shouldn't the holder class for
BTTs automatically default to BTT instead of NONE, i.e. add the address
abstraction guid by default, thus creating v2 BTTs. I feel it might come
as more of a surprise if we continue to create v1.1 BTTs by default when
the spec states 2.0..
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
