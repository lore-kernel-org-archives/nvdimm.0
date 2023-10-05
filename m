Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8DF30CF0
	for <nvdimm@lists.linux.dev>; Thu,  5 Oct 2023 15:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-6bc57401cb9so246975a34.0
        for <nvdimm@lists.linux.dev>; Thu, 05 Oct 2023 08:31:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696519871; x=1697124671;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EIqSfRMSRKJRwJKJLS1bgWTZkIifEaqxcnA16z0GR9w=;
        b=Sk5bwPENTXZ2tYeZoRCq3C6ErX+zs2W1TtmqJV7s2QotP4UulCCJBCdKMeRqBmsHxP
         7Ejqu4B2KTN14ftAHsD/I7etp3soycebDKJnKSe2YrURKSCm55DhKsH+8rT/NiQXyUJO
         yBfqLpjZD4NIrQzMr9J1isprge1a1R2XDaXrFV+yZOUfuAKCMbiZK/YuziBnrAAKnwZF
         Xi4vhUUtbirH/BmiGJz9oxlZD/wPqeMnhrX8g6fLU2ITjCATU/WK8vlZftMT3G+UI0x6
         zOyCuRRcckZJn5TkabpdiutkKZhoL11vF3MeggVBnkJSss2z/HR0hRoe736iLTTcIIEe
         ddYw==
X-Gm-Message-State: AOJu0YyR56FS8uwuCIMQ4W/kOqNtH4AsX3jgwDBH7JtiTxgXBa0Xqxfv
	4KXwSeujDbrP0MrFLoHhKjYEzol7T2Q0QATiO1U=
X-Google-Smtp-Source: AGHT+IHDV/XcgF/e3ZMaC9LY+KPzvu5uksCsiPtALvCoi4FvhB2ghcQlvr7hlEj+qWVm8VcQwv/RiLo/W7LFxTxJ7/A=
X-Received: by 2002:a05:6871:80d:b0:1d0:e371:db33 with SMTP id
 q13-20020a056871080d00b001d0e371db33mr6312295oap.3.1696519870713; Thu, 05 Oct
 2023 08:31:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230925144842.586829-1-michal.wilczynski@intel.com>
 <20230925144842.586829-2-michal.wilczynski@intel.com> <CAJZ5v0jyjH48XZ6vytncodYhsS6ODYg2yaZBPfRWb_qm99FMuA@mail.gmail.com>
 <f8b9cfb4-aa0f-44c0-84fe-613f005a2baf@intel.com> <CAJZ5v0jF_okRNkYySRQTSKBohaFk52V7Tcm=a1kVFaY6MWD4Hg@mail.gmail.com>
 <86a68f57-0e5e-4a92-8cfe-93249ba78a72@intel.com>
In-Reply-To: <86a68f57-0e5e-4a92-8cfe-93249ba78a72@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Thu, 5 Oct 2023 17:30:59 +0200
Message-ID: <CAJZ5v0jSa7FpJKsDRAhVMGy=pTi-aD5JPU4K3Rb-G3igrd6WRQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/9] ACPI: bus: Make notify wrappers more generic
To: "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, linux-acpi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	rafael.j.wysocki@intel.com, andriy.shevchenko@intel.com, lenb@kernel.org, 
	dan.j.williams@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com, 
	rui.zhang@intel.com, Andy Shevchenko <andy.shevchenko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 5, 2023 at 2:05=E2=80=AFPM Wilczynski, Michal
<michal.wilczynski@intel.com> wrote:
> On 10/5/2023 12:57 PM, Rafael J. Wysocki wrote:
> > On Thu, Oct 5, 2023 at 10:10=E2=80=AFAM Wilczynski, Michal
> > <michal.wilczynski@intel.com> wrote:

[cut]

> >>>
> >>> That said, why exactly is it better to use acpi_handle instead of a
> >>> struct acpi_device pointer?
> >> I wanted to make the wrapper as close as possible to the wrapped funct=
ion.
> >> This way it would be easier to remove it in the future i.e if we ever =
deem
> >> extra synchronization not worth it etc. What the ACPICA function need =
to
> >> install a wrapper is a handle not a pointer to a device.
> >> So there is no need for a middle man.
> > Taking a struct acpi_device pointer as the first argument is part of
> > duplication reduction, however, because in the most common case it
> > saves the users of it the need to dereference the struct acpi_device
> > they get from ACPI_COMPANION() in order to obtain the handle.
>
> User don't even have to use acpi device anywhere, as he can choose
> to use ACPI_HANDLE() instead on 'struct device*' and never interact
> with acpi device directly.

Have you actually looked at this macro?  It is a wrapper around
ACPI_COMPANION().

So they may think that they don't use struct acpi_device pointers, but
in fact they do.

> >
> > Arguably, acpi_handle is an ACPICA concept and it is better to reduce
> > its usage outside ACPICA.
>
> Use of acpi_handle is deeply entrenched in the kernel. There is even
> a macro ACPI_HANDLE() that returns acpi_handle. I would say it's
> way too late to limit it to ACPICA internal code.

So there is a difference between "limiting to ACPICA" and "reducing".
It cannot be limited to ACPICA, because the code outside ACPICA needs
to evaluate ACPI objects sometimes and ACPI handles are needed for
that.

And this observation doesn't invalidate the point.

> >
> >>> Realistically, in a platform driver you'll need the latter to obtain
> >>> the former anyway.
> >> I don't want to introduce arbitrary limitations where they are not nec=
essary.
> > I'm not sure what you mean.  This patch is changing existing functions.
>
> That's true, but those functions aren't yet deeply entrenched in the
> kernel yet, so in my view how they should look like should still be
> a subject for discussion, as for now they're only used locally in
> drivers/acpi, and my next patchset, that would remove .notify in
> platform directory would spread them more, and would
> make them harder to change. For now we can change how they
> work pretty painlessly.

I see no particular reason to do that, though.

What specifically is a problem with passing struct acpi_device
pointers to the wrappers?  I don't see any TBH.

> >
> >> It is often the case that driver allocates it's own private struct usi=
ng kmalloc
> >> family of functions, and that structure already contains everything th=
at is
> >> needed to remove the handler, so why force ? There are already example=
s
> >> in the drivers that do that i.e in acpi_video the function
> >> acpi_video_dev_add_notify_handler() uses raw ACPICA handler to install
> >> a notify handler and it passes private structure there.
> >> So there is value in leaving the choice of an actual type to the user =
of the
> >> API.
> > No, if the user has a pointer to struct acpi_device already, there is
> > no difference between passing this and passing the acpi_handle from it
> > except for the extra dereference in the latter case.
>
> Dereference would happen anyway in the wrapper, and it doesn't cause
> any harm anyway for readability in my opinion. And of course you don't
> have to use acpi device at all, you can use ACPI_HANDLE() macro.

So one can use ACPI_COMPANION() just as well and it is slightly less overhe=
ad.

> >
> > If the user doesn't have a struct acpi_device pointer, let them use
> > the raw ACPICA handler directly and worry about the synchronization
> > themselves.
>
> As mentioned acpi_device pointer is not really required to use the wrappe=
r.
> Instead we can use ACPI_HANDLE() macro directly. Look at the usage of
> the wrapper in the AC driver [1].

You don't really have to repeat the same argument  several times and I
know how ACPI_HANDLE() works.  Also I don't like some of the things
done by this patch.

Whoever uses ACPI_HANDLE(), they also use ACPI_COMPANION() which is
hidden in the former.

If they don't need to store either the acpi_handle or the struct
acpi_device pointer, there is no reason at all to use the former
instead of the latter.

If they get an acpi_handle from somewhere else than ACPI_HANDLE(),
then yes, they would need to get the ACPI devices from there (which is
possible still), but they may be better off by using the raw ACPICA
interface for events in that case.

> -static void acpi_ac_remove(struct acpi_device *device)
> +static void acpi_ac_remove(struct platform_device *pdev)
>  {
> -       struct acpi_ac *ac =3D acpi_driver_data(device);
> +      struct acpi_ac *ac =3D platform_get_drvdata(pdev);
>
> -       acpi_dev_remove_notify_handler(device->handle, ACPI_ALL_NOTIFY,
> +       acpi_dev_remove_notify_handler(ACPI_HANDLE(ac->dev),
> +                                                                     ACP=
I_ALL_NOTIFY,
>                                                                        ac=
pi_ac_notify);
>
>
>
> [1] - https://lore.kernel.org/all/20230925144842.586829-1-michal.wilczyns=
ki@intel.com/T/#mff1e8ce1e548b3252d896b56d3be0b1028b7402e
>
> >
> > The wrappers are there to cover the most common case, not to cover all =
cases.
>
> In general all drivers that I'm modifying would benefit from not using di=
rect ACPICA
> installers/removers by saving that extra synchronization code that would =
need to be
> provided otherwise, and not having to deal with acpi_status codes.

Yes, that's the common case.

>
> >
> >> To summarize:
> >> I would say the wrappers are mostly unnecessary, but they actually sav=
e
> >> some duplicate code in the drivers, so I decided to leave them, as I d=
on't
> >> want to introduce duplicate code if I can avoid that.
> > What duplicate code do you mean, exactly?
>
> I would need to declare extra acpi_status variable and use ACPI_FAILURE m=
acro
> in each usage of the direct ACPICA installer. Also I would need to call
> acpi_os_wait_events_complete() after calling each direct remove.

I thought you meant some code duplication related to passing struct
acpi_device pointers to the wrappers, but we agree that the wrappers
are generally useful.

> >
> > IMV you haven't really explained why this particular patch is
> > necessary or even useful.
>
> Maybe using an example would better illustrate my point.
> Consider using NFIT driver modification later in this series as an exampl=
e:
>
> 1) With old wrapper it would look:
>
>  static void acpi_nfit_notify(acpi_handle handle, u32 event, void *data)
> {
>     struct acpi_device *adev =3D data;
>     /* Now we need to figure how to get a 'struct device*' from an acpi_d=
evice.
>          Mind this we can't just do &adev->dev, as we're not using that d=
evice anymore.
>          We need to get a struct device that's embedded in the platform_d=
evice that the
>          driver was instantiated with.
>          Not sure how it would look like, but it would require are least =
one extra line here.
>      */
>     device_lock(dev);
>     __acpi_nfit_notify(dev, handle, event);
>     device_unlock(dev);
> }
>
> 2) With new wrapper:
>
> static void acpi_nfit_notify(acpi_handle handle, u32 event, void *data)
> {
>     struct device *dev =3D data;
>
>     device_lock(dev);
>     __acpi_nfit_notify(dev, handle, event);
>     device_unlock(dev);
> }
>
>
> So essentially arbitrarily forcing user to use wrapper that takes acpi de=
vice
> as an argument may unnecessarily increase drivers complexity, and if we
> can help with then we should. That's why this commit exists.

Well, I know what's going on now.

You really want to add a context argument to
acpi_dev_install_notify_handler(), which is quite reasonable, but then
you don't have to change the first argument of it.

I'll send you my version of this patch later today and we'll see.
