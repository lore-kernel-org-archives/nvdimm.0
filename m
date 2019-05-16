Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E3DA421268FA7
 for <linux-nvdimm@lists.01.org>; Wed, 15 May 2019 17:29:16 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [RESEND PATCH] nvdimm: fix some compilation warnings
Date: Thu, 16 May 2019 00:29:15 +0000
Message-ID: <cd6db786ff5758914c77add4d7a9391886038c84.camel@intel.com>
References: <20190514150735.39625-1-cai@lca.pw>
 <CAPcyv4gGwyPf0j4rXRM3JjsjGSHB6bGdZfwg+v2y8NQ6hNVK8g@mail.gmail.com>
 <7ba8164b60be4e41707559ed6623f9462c942735.camel@intel.com>
 <CAPcyv4gLr_WrNOg58C5tfpZTp2wso1C=kHGDkMvH4+sGniLQMQ@mail.gmail.com>
In-Reply-To: <CAPcyv4gLr_WrNOg58C5tfpZTp2wso1C=kHGDkMvH4+sGniLQMQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <5A3A42854626C34E9EAD584400932357@intel.com>
MIME-Version: 1.0
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cai@lca.pw" <cai@lca.pw>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>


On Wed, 2019-05-15 at 17:26 -0700, Dan Williams wrote:
> On Wed, May 15, 2019 at 5:25 PM Verma, Vishal L
> <vishal.l.verma@intel.com> wrote:
> > On Wed, 2019-05-15 at 16:25 -0700, Dan Williams wrote:
> > > > diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> > > > index 4671776f5623..9f02a99cfac0 100644
> > > > --- a/drivers/nvdimm/btt.c
> > > > +++ b/drivers/nvdimm/btt.c
> > > > @@ -1269,11 +1269,9 @@ static int btt_read_pg(struct btt *btt,
> > > > struct bio_integrity_payload *bip,
> > > > 
> > > >                 ret = btt_data_read(arena, page, off, postmap,
> > > > cur_len);
> > > >                 if (ret) {
> > > > -                       int rc;
> > > > -
> > > >                         /* Media error - set the e_flag */
> > > > -                       rc = btt_map_write(arena, premap,
> > > > postmap, 0, 1,
> > > > -                               NVDIMM_IO_ATOMIC);
> > > > +                       btt_map_write(arena, premap, postmap, 0,
> > > > 1,
> > > > +                                     NVDIMM_IO_ATOMIC);
> > > >                         goto out_rtt;
> > > 
> > > This doesn't look correct to me, shouldn't we at least be logging
> > > that
> > > the bad-block failed to be persistently tracked?
> > 
> > Yes logging it sounds good to me. Qian, can you include this in your
> > respin or shall I send a fix for it separately (since we were always
> > ignoring the failure here regardless of this patch)?
> 
> I think a separate fix for this makes more sense. Likely also needs to
> be a ratelimited message in case a storm of errors is encountered.

Yes good point on rate limiting - I was thinking WARN_ONCE but that
might mask errors for distinct blocks, but a rate limited printk should
work best. I'll prepare a patch.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
