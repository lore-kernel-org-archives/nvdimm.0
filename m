Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1833379E6
	for <nvdimm@lists.linux.dev>; Fri, 30 Jun 2023 10:53:04 +0000 (UTC)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-94ea38c90ccso47836566b.1
        for <nvdimm@lists.linux.dev>; Fri, 30 Jun 2023 03:53:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688122383; x=1690714383;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/A56lQbaSYx6f8A8Kd9myuvvjZF2IChmVUGzObphlZg=;
        b=ZdFvqpiuaBIFoK+EHC+AVj0ITz1u18OJU/hrEXmkJJnNqyisBkhGKNrT3vwgTBeJHx
         accw5qfhZ56VLkfCx34I+C7VttP2nJTwvson5nMZuaR/s1BDrOBrcHLIp15jVMhFMHzG
         SSzs8OKtamUv+cZ06XpghulPgpFsFnj3w+iUf0VuyVBcwd0TnuD92s2rHxsDeUexHiAg
         8ziht1x4IbRTDfBeI18jHgdixmmeho35wRtnvfMkrFi5HWUfcR0+rbS7Qsjylz5mrIfs
         08J2XhpxM2j5yMVe7j5YENb/8fMsIwNBKG8hr/9/CtrAgMeWacrsskwdleubFgZqUXje
         ufoA==
X-Gm-Message-State: ABy/qLZj8sb30vk0NJ00s1RYpfSUbClzUlHfXZrhMxc5Mg6QZ1ZoBX1u
	T9h6YfcEiCEJsXuNS8k6LjZZCwXkX6zY4cnusfE=
X-Google-Smtp-Source: ACHHUZ4WgWkFA9uBFLQ4chY9yS0DrCbDHKg+qJki1rTD/526fTFWs9/rOjn0MfGzEAyJcN8v4XUfb+eUTcSmoaBkahQ=
X-Received: by 2002:a17:906:35c5:b0:988:8220:2af0 with SMTP id
 p5-20020a17090635c500b0098882202af0mr1588637ejb.5.1688122383089; Fri, 30 Jun
 2023 03:53:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230616165034.3630141-1-michal.wilczynski@intel.com>
 <20230616165034.3630141-8-michal.wilczynski@intel.com> <CAJZ5v0jjwk+jVsULD8nyguc7p00Sn3Hyxq7=PLNzpj-Fz6H6sg@mail.gmail.com>
 <aad9608b-34fa-1405-1fc4-5eb8d7d1647f@intel.com>
In-Reply-To: <aad9608b-34fa-1405-1fc4-5eb8d7d1647f@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 30 Jun 2023 12:52:52 +0200
Message-ID: <CAJZ5v0jVsWatCmnN9=H18CzhoekgZOgnEisDJYfb-F=M3cOX1A@mail.gmail.com>
Subject: Re: [PATCH v5 07/10] acpi/nfit: Move acpi_nfit_notify() before acpi_nfit_add()
To: "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, linux-acpi@vger.kernel.org, dan.j.williams@intel.com, 
	vishal.l.verma@intel.com, lenb@kernel.org, dave.jiang@intel.com, 
	ira.weiny@intel.com, rui.zhang@intel.com, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 30, 2023 at 11:48=E2=80=AFAM Wilczynski, Michal
<michal.wilczynski@intel.com> wrote:
>
>
>
> On 6/29/2023 6:06 PM, Rafael J. Wysocki wrote:
> > On Fri, Jun 16, 2023 at 6:51=E2=80=AFPM Michal Wilczynski
> > <michal.wilczynski@intel.com> wrote:
> >> To use new style of installing event handlers acpi_nfit_notify() needs
> >> to be known inside acpi_nfit_add(). Move acpi_nfit_notify() upwards in
> >> the file, so it can be used inside acpi_nfit_add().
> >>
> >> Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
> >> ---
> >>  drivers/acpi/nfit/core.c | 14 +++++++-------
> >>  1 file changed, 7 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> >> index 07204d482968..aff79cbc2190 100644
> >> --- a/drivers/acpi/nfit/core.c
> >> +++ b/drivers/acpi/nfit/core.c
> >> @@ -3312,6 +3312,13 @@ void acpi_nfit_shutdown(void *data)
> >>  }
> >>  EXPORT_SYMBOL_GPL(acpi_nfit_shutdown);
> >>
> >> +static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
> >> +{
> >> +       device_lock(&adev->dev);
> >> +       __acpi_nfit_notify(&adev->dev, adev->handle, event);
> >> +       device_unlock(&adev->dev);
> >> +}
> >> +
> >>  static int acpi_nfit_add(struct acpi_device *adev)
> >>  {
> >>         struct acpi_buffer buf =3D { ACPI_ALLOCATE_BUFFER, NULL };
> >> @@ -3446,13 +3453,6 @@ void __acpi_nfit_notify(struct device *dev, acp=
i_handle handle, u32 event)
> >>  }
> >>  EXPORT_SYMBOL_GPL(__acpi_nfit_notify);
> >>
> >> -static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
> >> -{
> >> -       device_lock(&adev->dev);
> >> -       __acpi_nfit_notify(&adev->dev, adev->handle, event);
> >> -       device_unlock(&adev->dev);
> >> -}
> >> -
> >>  static const struct acpi_device_id acpi_nfit_ids[] =3D {
> >>         { "ACPI0012", 0 },
> >>         { "", 0 },
> >> --
> > Please fold this patch into the next one.  By itself, it is an
> > artificial change IMV.
>
> I agree with you, but I got told specifically to do that.
> https://lore.kernel.org/linux-acpi/e0f67199-9feb-432c-f0cb-7bdbdaf9ff63@l=
inux.intel.com/

Whether or not this is easier to review is kind of subjective.

If there were more code to move, I would agree, but in this particular
case having to review two patches instead of just one is a bit of a
hassle IMV.
