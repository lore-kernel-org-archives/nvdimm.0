Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AA479E6
	for <nvdimm@lists.linux.dev>; Fri, 30 Jun 2023 11:01:01 +0000 (UTC)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-991f9148334so48490466b.1
        for <nvdimm@lists.linux.dev>; Fri, 30 Jun 2023 04:01:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688122859; x=1690714859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SwNNfkXcsdEjK6snSksErOen+E6g37LU4cCW5pLNENE=;
        b=iKbhLNQy1Qijca6xGA7Zi09yVp609adhZMLvcLXonjpQoIf0qm36SBhUdmGajT8stX
         hgJ9jMPV4QrJqV7IxA2nklQ74qu0oKtjsswJAd9Zhf2A7kSmG3yGsRICkF1Eh6lMHed2
         sfvXs49gXJXqoTAkUNh1ZARGXRTV7uf4kFOabkFoc8hFpmwXQ6V7Pd8Nz0oBCn+16oOV
         6qoO05DCgLlDdbALxwUHCa0FOqcd2VuLIxzbhAh71GeYbTTW6VJHxWw44MUSQqdj7vOl
         EspA9NsDYx6tHSNM+E0jSK2Vr4fdRDpC3jLWpL2I6PNTBl+B/QpnMEdCErS0KfqMFwQO
         mg5w==
X-Gm-Message-State: ABy/qLYUsx+QZkYshtG4fsXeYDed6MDbYTCfbnfGtAy5IJk2NBUYeTeZ
	dXEgKYaJqZl3lIu59dKgoOzbI3ao/XRscFjQ7HkXa1HD
X-Google-Smtp-Source: APBJJlGK4UDcNmucxCHKV3pZgbCuIjN9vNC4LfEB1wY5GDUITfZC3itQ/WtMXIfcasxAJH0vSWVFHewGzBbf/wuenwk=
X-Received: by 2002:a17:906:594b:b0:987:f332:5329 with SMTP id
 g11-20020a170906594b00b00987f3325329mr1488661ejr.1.1688122859289; Fri, 30 Jun
 2023 04:00:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230616165034.3630141-1-michal.wilczynski@intel.com>
 <20230616165034.3630141-10-michal.wilczynski@intel.com> <CAJZ5v0gcokw72q5uX-3pbBEZtJdCaWHN1vat8yPNQ3SXMgeD4g@mail.gmail.com>
 <d4ebf8ba-6f95-d20c-d7fb-e97b6535f71f@intel.com>
In-Reply-To: <d4ebf8ba-6f95-d20c-d7fb-e97b6535f71f@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 30 Jun 2023 13:00:48 +0200
Message-ID: <CAJZ5v0hXCA3cdqRms2RaQtzH8PnBNsm++nakQS5sSa0EHboa-Q@mail.gmail.com>
Subject: Re: [PATCH v5 09/10] acpi/nfit: Move handler installing logic to driver
To: "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, linux-acpi@vger.kernel.org, dan.j.williams@intel.com, 
	vishal.l.verma@intel.com, lenb@kernel.org, dave.jiang@intel.com, 
	ira.weiny@intel.com, rui.zhang@intel.com, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 30, 2023 at 11:55=E2=80=AFAM Wilczynski, Michal
<michal.wilczynski@intel.com> wrote:
>
>
>
> On 6/29/2023 6:18 PM, Rafael J. Wysocki wrote:
> > On Fri, Jun 16, 2023 at 6:51=E2=80=AFPM Michal Wilczynski
> > <michal.wilczynski@intel.com> wrote:
> >> Currently logic for installing notifications from ACPI devices is
> >> implemented using notify callback in struct acpi_driver. Preparations
> >> are being made to replace acpi_driver with more generic struct
> >> platform_driver, which doesn't contain notify callback. Furthermore
> >> as of now handlers are being called indirectly through
> >> acpi_notify_device(), which decreases performance.
> >>
> >> Call acpi_dev_install_notify_handler() at the end of .add() callback.
> >> Call acpi_dev_remove_notify_handler() at the beginning of .remove()
> >> callback. Change arguments passed to the notify function to match with
> >> what's required by acpi_install_notify_handler(). Remove .notify
> >> callback initialization in acpi_driver.
> >>
> >> Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >> Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
> >> ---
> >>  drivers/acpi/nfit/core.c | 24 ++++++++++++++++++------
> >>  1 file changed, 18 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> >> index 95930e9d776c..a281bdfee8a0 100644
> >> --- a/drivers/acpi/nfit/core.c
> >> +++ b/drivers/acpi/nfit/core.c
> >> @@ -3312,11 +3312,13 @@ void acpi_nfit_shutdown(void *data)
> >>  }
> >>  EXPORT_SYMBOL_GPL(acpi_nfit_shutdown);
> >>
> >> -static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
> >> +static void acpi_nfit_notify(acpi_handle handle, u32 event, void *dat=
a)
> >>  {
> >> -       device_lock(&adev->dev);
> >> -       __acpi_nfit_notify(&adev->dev, adev->handle, event);
> >> -       device_unlock(&adev->dev);
> > It's totally not necessary to rename the ACPI device variable here.
> >
> > Just add
> >
> > struct acpi_device *adev =3D data;
> >
> > to this function.
>
> Sure, is adev a preferred name for acpi_device ?

In new code, it is.

In the existing code, it depends.  If you do a one-line change, it is
better to retain the original naming (for the sake of clarity of the
change itself).  If you rearrange it completely, you may as well
change the names while at it.  And there is a spectrum in between.

>  I've seen a mix of different naming
> in drivers, some use device, adev, acpi_dev and so on. I suppose it's not=
 a big deal, but
> it would be good to know.

Personally, I prefer adev, but this isn't a very strong preference.

Using "device" as a name of a struct acpi_device object (or a pointer
to one of these for that matter) is slightly misleading IMV, because
those things represent AML entities rather than actual hardware.
