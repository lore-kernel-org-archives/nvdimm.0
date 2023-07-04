Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3266FA8
	for <nvdimm@lists.linux.dev>; Tue,  4 Jul 2023 17:19:51 +0000 (UTC)
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2b58330576fso19009701fa.1
        for <nvdimm@lists.linux.dev>; Tue, 04 Jul 2023 10:19:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688491189; x=1691083189;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=djFoL9yA4A3P0CFXEsgPw3vyPD7HgfIIM4MzWUQV+Cw=;
        b=JAzFfQmACiDAM7Fw22tTOF93S6OKaUxsWsVp+CKqUmTdfhXhAzYmaRRUQLuC31mCNV
         e0MAIV7Ywa6Ni3U9hf7dImvOUixm3/kKHSEwx2EF7h6fCLZubgOhBxPiQmk3w4B/mp5d
         ppuTjvXAeRJCs25yAYXhCzgFkSHflnobYkIEtSU+JBSGbLxsFYXIO5JszitDH/GeJ9m8
         CZlAsOhMiKlpl/hhlZEcsJj7nw7wrPOTLLWhFDD1x9oUyAL+6ypiMM3a8FjVWwuzLYZ5
         GmI2VDly6LCn5UH+T/ZZfiJD1UtBfVi4Ez6cYxTlWiYelPzJUvXnEP093v5DnFhemA7r
         mHJw==
X-Gm-Message-State: ABy/qLbfnDWrQ/3akYr18gLKVfVKNCvvAVmtXkrIwdqK0qU53sPem5MM
	O4bgNgwLJAX7+fVIj76FZXQHRZE91pWwQjsT/UI=
X-Google-Smtp-Source: APBJJlFfoGZ7F1/ydLXS47EzcnpnC24NMO96NIFrzxf26OgEU6tONYZkEEZo9c5+C481ZPBt678CcegoWndFSWEMq7s=
X-Received: by 2002:a05:651c:1a29:b0:2b6:af68:6803 with SMTP id
 by41-20020a05651c1a2900b002b6af686803mr11320995ljb.4.1688491188712; Tue, 04
 Jul 2023 10:19:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230703130125.997208-1-ben.dooks@codethink.co.uk>
In-Reply-To: <20230703130125.997208-1-ben.dooks@codethink.co.uk>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 4 Jul 2023 19:19:37 +0200
Message-ID: <CAJZ5v0icycz_6=h40WP1Yxu0QWFZT7fqKezax=ekb2mrbx5j8A@mail.gmail.com>
Subject: Re: [PATCH] ACPICA: actbl2: change to be16/be32 types for big endian data
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: acpica-devel@lists.linuxfoundation.org, linux-acpi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lenb@kernel.org, nvdimm@lists.linux.dev, 
	Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 3, 2023 at 3:01=E2=80=AFPM Ben Dooks <ben.dooks@codethink.co.uk=
> wrote:
>
> Some of the fields in struct acpi_nfit_control_region are used in big
> endian format, and thus are generatng warnings from spare where the
> member is passed to one of the conversion functions.
>
> Fix the following sparse warnings by changing the data types:
>
> drivers/acpi/nfit/core.c:1403:41: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1403:41: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1403:41: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1403:41: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1412:41: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1412:41: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1412:41: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1412:41: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1421:41: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1421:41: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1421:41: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1421:41: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1430:41: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1430:41: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1430:41: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1430:41: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1440:25: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1440:25: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1440:25: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1440:25: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1449:41: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1449:41: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1449:41: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1449:41: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1468:41: warning: cast to restricted __le16
> drivers/acpi/nfit/core.c:1502:41: warning: cast to restricted __le16
> drivers/acpi/nfit/core.c:1527:41: warning: cast to restricted __be32
> drivers/acpi/nfit/core.c:1527:41: warning: cast to restricted __be32
> drivers/acpi/nfit/core.c:1527:41: warning: cast to restricted __be32
> drivers/acpi/nfit/core.c:1527:41: warning: cast to restricted __be32
> drivers/acpi/nfit/core.c:1527:41: warning: cast to restricted __be32
> drivers/acpi/nfit/core.c:1527:41: warning: cast to restricted __be32
> drivers/acpi/nfit/core.c:1792:33: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1792:33: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1792:33: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1792:33: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1794:33: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1794:33: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1794:33: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1794:33: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1795:33: warning: cast to restricted __be32
> drivers/acpi/nfit/core.c:1795:33: warning: cast to restricted __be32
> drivers/acpi/nfit/core.c:1795:33: warning: cast to restricted __be32
> drivers/acpi/nfit/core.c:1795:33: warning: cast to restricted __be32
> drivers/acpi/nfit/core.c:1795:33: warning: cast to restricted __be32
> drivers/acpi/nfit/core.c:1795:33: warning: cast to restricted __be32
> drivers/acpi/nfit/core.c:1798:33: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1798:33: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1798:33: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1798:33: warning: cast to restricted __be16
> drivers/acpi/nfit/core.c:1799:33: warning: cast to restricted __be32
> drivers/acpi/nfit/core.c:1799:33: warning: cast to restricted __be32
> drivers/acpi/nfit/core.c:1799:33: warning: cast to restricted __be32
> drivers/acpi/nfit/core.c:1799:33: warning: cast to restricted __be32
> drivers/acpi/nfit/core.c:1799:33: warning: cast to restricted __be32
> drivers/acpi/nfit/core.c:1799:33: warning: cast to restricted __be32
>
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>

First off, this falls under the ACPICA rule mentioned before.

Second, all ACPI is little-endian by the spec, so I'm not sure what is
going on here.

> ---
>  drivers/acpi/nfit/core.c |  8 ++++----
>  include/acpi/actbl2.h    | 18 +++++++++---------
>  2 files changed, 13 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 07204d482968..0fcc247fdfac 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -2194,15 +2194,15 @@ static const struct attribute_group *acpi_nfit_re=
gion_attribute_groups[] =3D {
>  /* enough info to uniquely specify an interleave set */
>  struct nfit_set_info {
>         u64 region_offset;
> -       u32 serial_number;
> +       __be32 serial_number;
>         u32 pad;
>  };
>
>  struct nfit_set_info2 {
>         u64 region_offset;
> -       u32 serial_number;
> -       u16 vendor_id;
> -       u16 manufacturing_date;
> +       __be32 serial_number;
> +       __be16 vendor_id;
> +       __be16 manufacturing_date;
>         u8 manufacturing_location;
>         u8 reserved[31];
>  };
> diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
> index 0029336775a9..c1df59aa8855 100644
> --- a/include/acpi/actbl2.h
> +++ b/include/acpi/actbl2.h
> @@ -1716,18 +1716,18 @@ struct acpi_nfit_smbios {
>  struct acpi_nfit_control_region {
>         struct acpi_nfit_header header;
>         u16 region_index;
> -       u16 vendor_id;
> -       u16 device_id;
> -       u16 revision_id;
> -       u16 subsystem_vendor_id;
> -       u16 subsystem_device_id;
> -       u16 subsystem_revision_id;
> +       __be16 vendor_id;
> +       __be16 device_id;
> +       __be16  revision_id;
> +       __be16 subsystem_vendor_id;
> +       __be16 subsystem_device_id;
> +       __be16 subsystem_revision_id;
>         u8 valid_fields;
>         u8 manufacturing_location;
> -       u16 manufacturing_date;
> +       __be16 manufacturing_date;
>         u8 reserved[2];         /* Reserved, must be zero */
> -       u32 serial_number;
> -       u16 code;
> +       __be32 serial_number;
> +       __le16 code;
>         u16 windows;
>         u64 window_size;
>         u64 command_offset;
> --
> 2.40.1
>
