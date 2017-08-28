Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym04.jp.fujitsu.com (mgwym04.jp.fujitsu.com [211.128.242.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B098221E47D5B
 for <linux-nvdimm@lists.01.org>; Sun, 27 Aug 2017 18:09:38 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 70AD8AC0097
 for <linux-nvdimm@lists.01.org>; Mon, 28 Aug 2017 10:12:11 +0900 (JST)
Date: Mon, 28 Aug 2017 10:12:08 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [ndctl PATCH 3/4] Make interfaces to use Translate SPA.
In-Reply-To: <CAPcyv4jZqm-9X8201GuRi4fXmr420hhgi-1gMk2=K13c_TDiwQ@mail.gmail.com>
References: <20170818133524.8EB4.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4jZqm-9X8201GuRi4fXmr420hhgi-1gMk2=K13c_TDiwQ@mail.gmail.com>
Message-Id: <20170828101205.9A55.E1E9C6FF@jp.fujitsu.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> On Thu, Aug 17, 2017 at 9:35 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> >
> > This patch makes 3 new interfaces :
> >   - to ask bus has translate SPA feature.
> >   - to call translate SPA.
> >   - to find DIMM by SPA address.
> >
> >
> > Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> > ---
> >  configure.ac                 |  19 ++++++++
> >  ndctl/lib/libndctl-private.h |   7 +++
> >  ndctl/lib/libndctl.c         | 111 +++++++++++++++++++++++++++++++++++++++++++
> >  ndctl/lib/libndctl.sym       |   3 ++
> >  ndctl/libndctl.h.in          |  23 +++++++++
> >  ndctl/ndctl.h                |   5 ++
> >  6 files changed, 168 insertions(+)
> >
> [..]
> > diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> > index b3535f0..4556067 100644
> > --- a/ndctl/lib/libndctl.c
> > +++ b/ndctl/lib/libndctl.c
> [..]
> 
> Sorry I overlooked this function in my last mail:
> 
> > +NDCTL_EXPORT struct ndctl_dimm *ndctl_dimm_get_by_spa(struct ndctl_bus *bus,
> > +               unsigned long long spa)
> > +{
> > +       int rc;
> > +       unsigned int handle;
> > +       unsigned long long dpa;
> > +
> > +       if (!bus || !spa)
> > +               return NULL;
> 
> We can do some sanity checking here to check the resource range and
> see if the DIMM is in that region. See ndctl_region_get_resource() and
> ndctl_dimm_foreach_in_region(). That also allows us to support single
> dimm regions without calling translate spa.
> 

Ok. I'll check it.



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
