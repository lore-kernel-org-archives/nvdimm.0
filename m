Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C46112194EB7D
 for <linux-nvdimm@lists.01.org>; Tue, 26 Mar 2019 11:32:03 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id f10so12436886otb.6
 for <linux-nvdimm@lists.01.org>; Tue, 26 Mar 2019 11:32:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190325215527.12574-1-pakki001@umn.edu>
 <5fa84f18-7253-2543-57e4-6a9e2b2da716@codeaurora.org>
In-Reply-To: <5fa84f18-7253-2543-57e4-6a9e2b2da716@codeaurora.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Mar 2019 11:31:51 -0700
Message-ID: <CAPcyv4jMrU4n1fOv31TOZ-8Re4-7mwG_C_d6WzxZbjnu91UVeQ@mail.gmail.com>
Subject: Re: [PATCH v4] nvdimm: btt_devs: fix a NULL pointer dereference
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
To: Mukesh Ojha <mojha@codeaurora.org>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Kangjie Lu <kjlu@umn.edu>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Aditya Pakki <pakki001@umn.edu>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 26, 2019 at 3:23 AM Mukesh Ojha <mojha@codeaurora.org> wrote:
>
>
> On 3/26/2019 3:25 AM, Aditya Pakki wrote:
> > In case kmemdup fails, the fix releases resources and returns to
> > avoid the NULL pointer dereference.
> >
> > Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> >
> > ---
> > v3: Move kfree(nd_btt) to goto block.
> > v2: Replace incorrect kfree with ida_simple_remove, suggested by
> > Johannes Thumshirn
> > v1: Free nd_btt->id in case of failure and avoid double free, suggested
> > by Dan Williams
> > ---
> >   drivers/nvdimm/btt_devs.c | 18 +++++++++++++-----
> >   1 file changed, 13 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
> > index b72a303176c7..9486acc08402 100644
> > --- a/drivers/nvdimm/btt_devs.c
> > +++ b/drivers/nvdimm/btt_devs.c
> > @@ -198,14 +198,15 @@ static struct device *__nd_btt_create(struct nd_region *nd_region,
> >               return NULL;
> >
> >       nd_btt->id = ida_simple_get(&nd_region->btt_ida, 0, 0, GFP_KERNEL);
> > -     if (nd_btt->id < 0) {
> > -             kfree(nd_btt);
> > -             return NULL;
> > -     }
> > +     if (nd_btt->id < 0)
> > +             goto out_nd_btt;
> >
> >       nd_btt->lbasize = lbasize;
> > -     if (uuid)
> > +     if (uuid) {
> >               uuid = kmemdup(uuid, 16, GFP_KERNEL);
> > +             if (!uuid)
> > +                     goto out_put_id;
> > +     }
> >       nd_btt->uuid = uuid;
> >       dev = &nd_btt->dev;
> >       dev_set_name(dev, "btt%d.%d", nd_region->id, nd_btt->id);
> > @@ -220,6 +221,13 @@ static struct device *__nd_btt_create(struct nd_region *nd_region,
> >               return NULL;
> >       }
> >       return dev;
> > +
> > +out_put_id:
> > +     ida_simple_remove(&nd_region->btt_ida, nd_btt->id);
> > +
> > +out_nd_btt:
> > +     kfree(nd_btt);
> > +     return NULL;
> >   }
> >
> >   struct device *nd_btt_create(struct nd_region *nd_region)
>
>
> you have to take care of this below if block(true) as well as you are
> touching the function.
>   if (ndns && !__nd_attach_ndns(&nd_btt->dev, ndns, &nd_btt->ndns)) {

No, once the device is successfully initialized then put_device()
takes care of the rest.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
