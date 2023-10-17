Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5CB41212
	for <nvdimm@lists.linux.dev>; Tue, 17 Oct 2023 10:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-57bf04841ccso1152740eaf.0
        for <nvdimm@lists.linux.dev>; Tue, 17 Oct 2023 03:56:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697540166; x=1698144966;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2R8cNjbejuukXKtHRF4WxJOF67p0UWK9QqgSbWSP+S4=;
        b=MdgBev6iVqymLrWRHr3jYTWtgfV/4x4yYGaWfu22+uo9hjRI9c0d8jJBXWHN7rKlSm
         2ZWOg9QrsSbqkEJuyMLxEzQ5aLIzXFMtcZVDlrXbidTqeLKzQ7f8HR+KHYz+czgFfXse
         8LbbS8A2l6qhCYCzeJWCsCAxXRIj8Ui+wjtyr3fbRRcoSpHEC19HRdzw/ZWFBgIJMJu+
         +Allkf4LbPzWV1bFaHdmhaF/kBu4FSpRyIEEOiHl9Ivs8cmpWprs5m9fNGcwLeIFr2F5
         UxhUCcI6DY9u4+sFtJPg1J4DJ7qPwKDlTmYFh7OwBWIdFVbmDZshpvfGMaODwvwrfcVl
         N2Kw==
X-Gm-Message-State: AOJu0Yxh8mpYFREnlxbYKmeRG1p9bydPoC3RL4Y2RKRFShwRx97alsGA
	Crtwvncr9gwE8xt0CMT6KY08iK3dBoTyvLPxuAU=
X-Google-Smtp-Source: AGHT+IEfBzk6kHctuvtvEO6iaHmDTVyNkDdlSP5TpEAs5YPycEgAbsuHo3Cv5HznZ/vS26o/uxbqzusJyj7c1EZWsy4=
X-Received: by 2002:a4a:ee94:0:b0:581:5990:dbb8 with SMTP id
 dk20-20020a4aee94000000b005815990dbb8mr1758159oob.0.1697540166076; Tue, 17
 Oct 2023 03:56:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231006173055.2938160-1-michal.wilczynski@intel.com>
 <20231006173055.2938160-6-michal.wilczynski@intel.com> <e651d5e5-50a9-4884-8263-ce9d0d705b52@intel.com>
In-Reply-To: <e651d5e5-50a9-4884-8263-ce9d0d705b52@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 17 Oct 2023 12:55:55 +0200
Message-ID: <CAJZ5v0gTUNV4vSF7RxQf9XB8gfOSwOX=+pg7jZVw_yTYbRdp5Q@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] ACPI: NFIT: Replace acpi_driver with platform_driver
To: "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, "Williams, Dan J" <dan.j.williams@intel.com>, 
	rafael.j.wysocki@intel.com, andriy.shevchenko@intel.com, lenb@kernel.org, 
	vishal.l.verma@intel.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 17, 2023 at 12:45=E2=80=AFPM Wilczynski, Michal
<michal.wilczynski@intel.com> wrote:
>
>
> On 10/6/2023 7:30 PM, Michal Wilczynski wrote:
> > NFIT driver uses struct acpi_driver incorrectly to register itself.
> > This is wrong as the instances of the ACPI devices are not meant
> > to be literal devices, they're supposed to describe ACPI entry of a
> > particular device.
> >
> > Use platform_driver instead of acpi_driver. In relevant places call
> > platform devices instances pdev to make a distinction with ACPI
> > devices instances.
> >
> > NFIT driver uses devm_*() family of functions extensively. This change
> > has no impact on correct functioning of the whole devm_*() family of
> > functions, since the lifecycle of the device stays the same. It is stil=
l
> > being created during the enumeration, and destroyed on platform device
> > removal.
> >
> > Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
>
> Hi Dan,
> Rafael already reviewed this patch series and merged patches
> that he likes. We're waiting on your input regarding two NFIT
> commits in this series.

I actually haven't looked at the NFIT patches in this series myself
and this is not urgent at all IMV.

Thanks!
