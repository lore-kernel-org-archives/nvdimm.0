Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com
 [IPv6:2607:f8b0:4864:20::544])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7A20021CB74A7
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 13:24:38 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id m1so3375487pgq.8
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 13:24:38 -0800 (PST)
MIME-Version: 1.0
References: <CAGXu5jKUP9o-ZgW5Wa5-9DHeQNZ5VA3cLBCJ0P7AVkTQ5tqHtQ@mail.gmail.com>
 <CAPcyv4iZZEM3D8vta_sge7a4iMgPZ5a1AnunXa4DKUaWauZk1g@mail.gmail.com>
 <CAGXu5j+z_yRPgE0HO=Sjo_VwwDDPJ+VLxbxwKgbb2cUAB5jmwg@mail.gmail.com>
 <CAPcyv4jhFGMzBrWHS_9q0Fe2MersRXz31VG3H2dJfujx1CJGhQ@mail.gmail.com>
 <CAGXu5jKrhvUduv_XUYF94YM=bBfPGNkPrZ_EkvRKB0pDY_6uOw@mail.gmail.com>
 <CAPcyv4jQ1Og_mEVjb77xdM263MugzK7_yrR_zi498JFrOrhSrg@mail.gmail.com>
 <CAPcyv4if2YwyYSn9XLKHQXX2oe+nX2idvNx79M2s1j4FMftkBg@mail.gmail.com>
In-Reply-To: <CAPcyv4if2YwyYSn9XLKHQXX2oe+nX2idvNx79M2s1j4FMftkBg@mail.gmail.com>
From: Dexuan-Linux Cui <dexuan.linux@gmail.com>
Date: Wed, 16 Jan 2019 13:24:26 -0800
Message-ID: <CAA42JLYcpY_f4CJY5XU9zmbLWw6ivyWsp1rgfDWnovCUvcDCVg@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Dexuan Cui <decui@microsoft.com>, Kees Cook <keescook@chromium.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 8, 2019 at 4:49 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Tue, Jan 8, 2019 at 4:02 PM Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > On Tue, Jan 8, 2019 at 3:55 PM Kees Cook <keescook@chromium.org> wrote:
> > >
> > > On Tue, Jan 8, 2019 at 3:54 PM Dan Williams <dan.j.williams@intel.com> wrote:
> > > >
> > > > On Tue, Jan 8, 2019 at 3:34 PM Kees Cook <keescook@chromium.org> wrote:
> > > > >
> > > > > On Tue, Jan 8, 2019 at 3:28 PM Dan Williams <dan.j.williams@intel.com> wrote:
> > > > > > Ah, thanks for the report! The key difference is that you don't define
> > > > > > a "label area", so the driver bails out early and never initializes
> > > > > > the security state.
> > > > > >
> > > > > > This should fix it up.
> > > > > >
> > > > > > diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> > > > > > index 4890310df874..636cdb06ee17 100644
> > > > > > --- a/drivers/nvdimm/dimm_devs.c
> > > > > > +++ b/drivers/nvdimm/dimm_devs.c
> > > > > > @@ -514,7 +514,7 @@ static umode_t nvdimm_visible(struct kobject
> > > > > > *kobj, struct attribute *a, int n)
> > > > > >
> > > > > >         if (a != &dev_attr_security.attr)
> > > > > >                 return a->mode;
> > > > > > -       if (nvdimm->sec.state < 0)
> > > > > > +       if (!nvdimm->sec.ops || nvdimm->sec.state < 0)
> > > > > >                 return 0;
> > > > > >         /* Are there any state mutation ops? */
> > > > > >         if (nvdimm->sec.ops->freeze || nvdimm->sec.ops->disable
> > > > >
> > > > > Okay, cool. I wasn't sure if that test needed a deeper check. :)
> > > > >
> > > > > Fixes: 37833fb7989a9 ("acpi/nfit, libnvdimm: Add freeze security
> > > > > support to Intel nvdimm")
> > > > > Tested-by: Kees Cook <keescook@chromium.org>
> > > > >
> > > >
> > > > Actually, looking closer this should have been avoided by the fact
> > > > that __nvdimm_create() initializes the security state early and that
> > > > nvdimm->sec.state should have saved us.
> > > >
> > > > I'll dig a bit deeper with your qemu config.
> > >
> > > Maybe something goes weird with pstore stealing the region?
> >
> > No, pstore is off the hook. I was just able to reproduce locally and
> > I'm not doing anything with pstore.
>
> Huh, this fixes it:
>
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index 5440f11b0907..7315977b64da 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -160,6 +160,7 @@ static inline struct nd_blk_region_desc *to_blk_region_desc(
>  }
>
>  enum nvdimm_security_state {
> +       NVDIMM_SECURITY_ERROR = -1,
>         NVDIMM_SECURITY_DISABLED,
>         NVDIMM_SECURITY_UNLOCKED,
>         NVDIMM_SECURITY_LOCKED,
>
> Apparently I was wrong to think an enum was a signed int without
> actually making a signed value a possibility. I would have a expected
> the compiler to give me a "statement has no effect" for testing for a
> negative value against an effectively unsigned quantity.

Thanks for the one-line patch! It fixed the same crash for me.

-- Dexuan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
