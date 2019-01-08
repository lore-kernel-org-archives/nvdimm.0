Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com
 [IPv6:2607:f8b0:4864:20::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6AC8C21962301
 for <linux-nvdimm@lists.01.org>; Tue,  8 Jan 2019 15:54:02 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id w13so4850597oiw.9
 for <linux-nvdimm@lists.01.org>; Tue, 08 Jan 2019 15:54:02 -0800 (PST)
MIME-Version: 1.0
References: <CAGXu5jKUP9o-ZgW5Wa5-9DHeQNZ5VA3cLBCJ0P7AVkTQ5tqHtQ@mail.gmail.com>
 <CAPcyv4iZZEM3D8vta_sge7a4iMgPZ5a1AnunXa4DKUaWauZk1g@mail.gmail.com>
 <CAGXu5j+z_yRPgE0HO=Sjo_VwwDDPJ+VLxbxwKgbb2cUAB5jmwg@mail.gmail.com>
In-Reply-To: <CAGXu5j+z_yRPgE0HO=Sjo_VwwDDPJ+VLxbxwKgbb2cUAB5jmwg@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 8 Jan 2019 15:53:50 -0800
Message-ID: <CAPcyv4jhFGMzBrWHS_9q0Fe2MersRXz31VG3H2dJfujx1CJGhQ@mail.gmail.com>
Subject: Re: nvdimm crash at boot
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
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 8, 2019 at 3:34 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Tue, Jan 8, 2019 at 3:28 PM Dan Williams <dan.j.williams@intel.com> wrote:
> > Ah, thanks for the report! The key difference is that you don't define
> > a "label area", so the driver bails out early and never initializes
> > the security state.
> >
> > This should fix it up.
> >
> > diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> > index 4890310df874..636cdb06ee17 100644
> > --- a/drivers/nvdimm/dimm_devs.c
> > +++ b/drivers/nvdimm/dimm_devs.c
> > @@ -514,7 +514,7 @@ static umode_t nvdimm_visible(struct kobject
> > *kobj, struct attribute *a, int n)
> >
> >         if (a != &dev_attr_security.attr)
> >                 return a->mode;
> > -       if (nvdimm->sec.state < 0)
> > +       if (!nvdimm->sec.ops || nvdimm->sec.state < 0)
> >                 return 0;
> >         /* Are there any state mutation ops? */
> >         if (nvdimm->sec.ops->freeze || nvdimm->sec.ops->disable
>
> Okay, cool. I wasn't sure if that test needed a deeper check. :)
>
> Fixes: 37833fb7989a9 ("acpi/nfit, libnvdimm: Add freeze security
> support to Intel nvdimm")
> Tested-by: Kees Cook <keescook@chromium.org>
>

Actually, looking closer this should have been avoided by the fact
that __nvdimm_create() initializes the security state early and that
nvdimm->sec.state should have saved us.

I'll dig a bit deeper with your qemu config.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
