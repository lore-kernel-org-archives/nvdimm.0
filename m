Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7EA761A1DF6
 for <linux-nvdimm@lists.01.org>; Wed,  3 Aug 2016 07:23:18 -0700 (PDT)
Date: Wed, 3 Aug 2016 16:23:12 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] libnvdimm: Fix memory leak in error path.
Message-ID: <20160803142312.ev2wbuqpeigidtwk@c203.arch.suse.de>
References: <1470232916-82917-1-git-send-email-jthumshirn@suse.de>
 <CAPcyv4iWknDGXGsbOFutvWxxhC+reMBMfGYO01R5+_MCBHXd5A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iWknDGXGsbOFutvWxxhC+reMBMfGYO01R5+_MCBHXd5A@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux NVDIMM Mailing List <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 03, 2016 at 07:12:51AM -0700, Dan Williams wrote:
> On Wed, Aug 3, 2016 at 7:01 AM, Johannes Thumshirn <jthumshirn@suse.de> w=
rote:
> > If either device_register() or nvdimm_bus_create_ndclt() fails we leak =
the
> > memory allocated for nvdimm_bus. Call kfree(nvdimm_bus) in the error pa=
th so
> > it's not leaked.
> >
> > Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> > ---
> >  drivers/nvdimm/core.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
> > index be89764..8578365 100644
> > --- a/drivers/nvdimm/core.c
> > +++ b/drivers/nvdimm/core.c
> > @@ -366,6 +366,7 @@ struct nvdimm_bus *__nvdimm_bus_register(struct dev=
ice *parent,
> >         return nvdimm_bus;
> >   err:
> >         put_device(&nvdimm_bus->dev);
> > +       kfree(nvdimm_bus);
> >         return NULL;
> >  }
> >  EXPORT_SYMBOL_GPL(__nvdimm_bus_register);
> > --
> =

> This routine as moved to drivers/nvdimm/bus.c and I don't think this
> is valid since device_register() initialize the reference count, and
> the call to put_device() will trigger nvdimm_bus_release().

Which is correct...

Sorry for the unnecessary patch.

Johannes
-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
