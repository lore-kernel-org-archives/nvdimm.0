Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6262E7F3A
	for <nvdimm@lists.linux.dev>; Mon, 25 May 2026 15:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779723659; cv=none; b=ja0UlkRwSzpaFkXvkNUkBAmWvt+nPykz+e7B5zQVH3j1fsskDBbhFPcpd34KQKk3kX3d9+k0BadmZlw1nBgk1doCohTh4JJW859A8hYeU44oMO2dJShvCbpt+0YfQ4ApGDh9m+owP9x/hNi8KtlyQ8Ux8SRPLXxBjf+HzLe+QgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779723659; c=relaxed/simple;
	bh=zdlGbnUa+EDORnMtp3NC8KdtU3yYgZNr5qtrULnD2Gg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MCYcP5zUgW8ys38Ozib8WdlLxtu5oBus5zNX0Cj/uDmg3aVR7/Jjcg/dq14aytTMjK3bkHAHic5wJdS+2dRl2tiM7mZYmn+XRVTluWfVmi5Y29xhNg6TdiQVwLnY7jVVDA5izQ9vfH9CbVTU44U8Jd494MBdM31G7jpKSdvL2fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gjPyqHsi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gjPyqHsi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C459C1F00A3A
	for <nvdimm@lists.linux.dev>; Mon, 25 May 2026 15:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779723657;
	bh=W9eec48RDS+uVSFgBbs286K44Gv/qZyKOHPTF1TQTN8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gjPyqHsiFxUE+M/mXXfPDnGcSh14REJBLWWH4dMrXPJ50bM2SZBGaIqZuBbliiDlW
	 v1SJleW17IQMo0Ie/FzdVoTiCsYKnE2yv6Soakrr4rGTTxrOyG/qlUliqlvO6pbtEc
	 uqnpfZ/lW4FchWyVs2dtvE+OcOjK9SEFsGpp/+G/ZZ00Ckb4DoR8SjqOcUKCrkHwAr
	 03p4+BBHxvMtrYSCzutcCPhiLxyoNGXcihW+z4cE0cKemA7EnU32UbGCQzVA6hAMDV
	 Y/zBbpTghuPBwJa3ImQMiDcl1Z8u0gqGzYNSSqTzxoyubtsPAyP/9WseyF8XQ9oBFw
	 cB2M2ndHUEfng==
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5a995ab70d1so11909912e87.3
        for <nvdimm@lists.linux.dev>; Mon, 25 May 2026 08:40:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9+peDrdmZczeLC5x/VWXjEyev+4XxM/J899Vgk/otfoHRHFWPCA+zjBixAT2PfLH+6qvBaY9o=@lists.linux.dev
X-Gm-Message-State: AOJu0YwSUmy5GgcZE++QunnsI5I5KHMDXvsv9BSoyAcuyr93GjlqrhFr
	D6VP3rig8fC3sSH9znntYQFKgX92s45ZGftXzLDMwwwlcNU6dc3x01vLQQVzOWfJisks8brGRaZ
	xBfDE/4PB4nP5IXGo3lcWp8tt/bqaIIo=
X-Received: by 2002:a05:6512:39d0:b0:5a8:f243:eea6 with SMTP id
 2adb3069b0e04-5aa323d4962mr4768209e87.24.1779723656201; Mon, 25 May 2026
 08:40:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <4739447.LvFx2qVVIh@rafael.j.wysocki> <3048737.e9J7NaK4W3@rafael.j.wysocki>
In-Reply-To: <3048737.e9J7NaK4W3@rafael.j.wysocki>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 25 May 2026 17:40:43 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0hnWNMp67N6k5csA-JAEqkmPB30Mjy0NmzhmyxvWWZG+Q@mail.gmail.com>
X-Gm-Features: AVHnY4KMMMHl87hZ7JVgd59XMtJD9vALY1FG3qET9YC7DAmXg6ESk0pSlWkz4rE
Message-ID: <CAJZ5v0hnWNMp67N6k5csA-JAEqkmPB30Mjy0NmzhmyxvWWZG+Q@mail.gmail.com>
Subject: Re: [PATCH v1 02/17] ACPI: NFIT: core: Use devm_acpi_install_notify_handler()
To: Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Hans de Goede <hansg@kernel.org>, 
	Armin Wolf <w_armin@gmx.de>, Dan Williams <djbw@kernel.org>, nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 21, 2026 at 4:13=E2=80=AFPM Rafael J. Wysocki <rafael@kernel.or=
g> wrote:
>
> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
>
> Now that devm_acpi_install_notify_handler() is available, use it in
> acpi_nfit_probe() instead of a custom devm action removing an ACPI
> notify handler installed via acpi_dev_install_notify_handler().
>
> Also drop the explicit ACPI_COMPANION() check against NULL that is
> not necessary any more becuase devm_acpi_install_notify_handler()
> carries out an equivalent check internally and use ACPI_HANDLE() to
> retrieve the platform device's ACPI handle.
>
> No intentional functional impact.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/nfit/core.c | 24 +++---------------------
>  1 file changed, 3 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 9304ac996d41..5cab62f618c8 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -3298,14 +3298,6 @@ static void acpi_nfit_notify(acpi_handle handle, u=
32 event, void *data)
>         device_unlock(dev);
>  }
>
> -static void acpi_nfit_remove_notify_handler(void *data)
> -{
> -       struct acpi_device *adev =3D data;
> -
> -       acpi_dev_remove_notify_handler(adev, ACPI_DEVICE_NOTIFY,
> -                                      acpi_nfit_notify);
> -}
> -
>  void acpi_nfit_shutdown(void *data)
>  {
>         struct acpi_nfit_desc *acpi_desc =3D data;
> @@ -3342,22 +3334,12 @@ static int acpi_nfit_probe(struct platform_device=
 *pdev)
>         struct acpi_nfit_desc *acpi_desc;
>         struct device *dev =3D &pdev->dev;
>         struct acpi_table_header *tbl;
> -       struct acpi_device *adev;
>         acpi_status status =3D AE_OK;
>         acpi_size sz;
>         int rc =3D 0;
>
> -       adev =3D ACPI_COMPANION(&pdev->dev);
> -       if (!adev)
> -               return -ENODEV;
> -
> -       rc =3D acpi_dev_install_notify_handler(adev, ACPI_DEVICE_NOTIFY,
> -                                            acpi_nfit_notify, dev);
> -       if (rc)
> -               return rc;
> -
> -       rc =3D devm_add_action_or_reset(dev, acpi_nfit_remove_notify_hand=
ler,
> -                                       adev);
> +       rc =3D devm_acpi_install_notify_handler(dev, ACPI_DEVICE_NOTIFY,
> +                                             acpi_nfit_notify, dev);
>         if (rc)
>                 return rc;
>
> @@ -3388,7 +3370,7 @@ static int acpi_nfit_probe(struct platform_device *=
pdev)
>         acpi_desc->acpi_header =3D *tbl;
>
>         /* Evaluate _FIT and override with that if present */
> -       status =3D acpi_evaluate_object(adev->handle, "_FIT", NULL, &buf)=
;
> +       status =3D acpi_evaluate_object(ACPI_HANDLE(dev), "_FIT", NULL, &=
buf);
>         if (ACPI_SUCCESS(status) && buf.length > 0) {
>                 union acpi_object *obj =3D buf.pointer;
>
> --

I would appreciate feedback on this, but the change is
straightforward, so in the absence of any I'll pick it up assuming no
objections.
