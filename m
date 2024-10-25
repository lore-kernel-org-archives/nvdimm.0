Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEB81F7550
	for <nvdimm@lists.linux.dev>; Fri, 25 Oct 2024 12:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729860177; cv=none; b=JBdrFnINZ6rliFaz5jygYh+hQ4WeW8vDw6mA9Ak+T0CFTfwUCzjAfEH4AW9wk9plHhL/eX+jkhw9OhbMnqleM4xW949TIRawYjidimsA+8qPoLTvfvV+joogrynpK4iTDgxP+vevt6fYQJVcFQR96umP+Z4Xj3TVTFHw8vUELdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729860177; c=relaxed/simple;
	bh=+tqTq/G1/ysY58iREiKY56dAmZ2o9or0upQiNmVDoqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CGCx7KzUqdaNAciqTJ6tx+rTTBTPIhysAlmsnVwnQn/98JU0H4d3wnv88xjoRFXmdLvzQJ2eNJo5ktb3oaMdPyOgxyRDMKUQn97KXARw9rkiHQ6s/i1mj075aLZ8P/smUmeO1mL2f3tTI1P2pmFfK1Jz09iishyUILW+xEXlgWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MFkw3jnZ; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MFkw3jnZ"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-20c6f492d2dso20510955ad.0
        for <nvdimm@lists.linux.dev>; Fri, 25 Oct 2024 05:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729860175; x=1730464975; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PXTiO9n5CgwqjEtYBHWc1ytJOpeHUyS3SdTPf/Kt7Nc=;
        b=MFkw3jnZYblO3PvHlt6H8kk5hrdWlHDRot6bfuADV/K9ZFURpnEVE5+Qg7vcmw7mNs
         DlfbpvexKOnTYklPxMNZYC5zFbQ/cj63gm6esw2M1cKMzZ1NQhYaIk1Orw2D2j3HBRlz
         UNOEkoduODW/KxsYNsgtS0mHt+o7VEZOLDBK7Qy+wgxu1H3hGMCoMbCb8LN8+UIQgmjK
         yVQv7RUJ4XFwmeF3BiGkvFnXI+SdNh7hpvOVzQML/CGFS+igVAmKxRbH5p00O6CwwQ7D
         rMq4N3wmRCNDuhZQTy6yT0WG8HgMQdsT561yYHiPHoBviWN1Nj7/cAclRrr8Jq43sqKO
         li1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729860175; x=1730464975;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PXTiO9n5CgwqjEtYBHWc1ytJOpeHUyS3SdTPf/Kt7Nc=;
        b=jtFfRTUPdt2YR+M19RS+/773MDeOxDD80p1lo3z1udD2Kl8TPViS3vzn76KNpKfeoX
         5LdCz0lVdPzbK08BPTsJ7K3L4+zbtZcP6izUTfeApZcRqIviDVwZkNjQjgdWhtsoYZRj
         FCZcoys7kMb2eohouY/qlMsxeZjUAvue8fvssJYRxLST1ja/mkM79p5AJnFmUH9jBl6l
         T30Sanlvz7QPbRJgTc5lioVcQnwBl4Xw3+JkYv6uYkhMteqlm9gsQgELnTGdNitPY1t8
         Casa2KhsXCUkshk+ewM+q4rOLFlH5tpflECUteJ9QH6Jyk4kNJUuPCp6hhopwafDUA8o
         ZKNA==
X-Forwarded-Encrypted: i=1; AJvYcCUmIUxWQJIsqKJYzDS/4kQdJBbTFBUJY6W5XIdS0LSS4Y/kxz7EHnlNla4vxTSqkcjtdvPxW34=@lists.linux.dev
X-Gm-Message-State: AOJu0YyGNcMk8lb4v/ElDhrWKOK6naXbSPLx/Mr09hAyRBYZudHGZ3FI
	Alnwvby7QxiB4dMLQQ/c9cjuuWCd+iw7cUEuNmi8aThabsdKy5pn
X-Google-Smtp-Source: AGHT+IFugZWGDU61tJUvNQ7vNEQVOF43NuD6yJ1b66g5NnSDW8T63LnxQXz5w07qCPMB6kK0Aauktg==
X-Received: by 2002:a17:902:f54c:b0:20c:8dff:b4ed with SMTP id d9443c01a7336-20fa9e09978mr128430245ad.16.1729860174882;
        Fri, 25 Oct 2024 05:42:54 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-210bc044f00sm8753685ad.260.2024.10.25.05.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2024 05:42:53 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id B1BDB442B53F; Fri, 25 Oct 2024 19:42:51 +0700 (WIB)
Date: Fri, 25 Oct 2024 19:42:51 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Fan Ni <fan.ni@samsung.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH v4 02/28] printk: Add print format (%pra) for struct range
Message-ID: <ZxuSS2L6RsaQ4bFJ@archie.me>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
 <20241007-dcd-type2-upstream-v4-2-c261ee6eeded@intel.com>
 <ZwiIy-pIo_BPLtua@archie.me>
 <67117a4de6083_37703294fb@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9Cc/Ioko7b9fu/7q"
Content-Disposition: inline
In-Reply-To: <67117a4de6083_37703294fb@iweiny-mobl.notmuch>


--9Cc/Ioko7b9fu/7q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 17, 2024 at 03:57:50PM -0500, Ira Weiny wrote:
> Bagas Sanjaya wrote:
> > On Mon, Oct 07, 2024 at 06:16:08PM -0500, Ira Weiny wrote:
> > > +Struct Range
> > > +------------
> > > +
> > > +::
> > > +
> > > +	%pra    [range 0x0000000060000000-0x000000006fffffff]
> > > +	%pra    [range 0x0000000060000000]
> > > +
> > > +For printing struct range.  struct range holds an arbitrary range of=
 u64
> > > +values.  If start is equal to end only 1 value is printed.
> >=20
> > Do you mean printing only start value in start=3Dequal case?
>=20
> Yes I'll change the verbiage.
>=20
> Ira
>=20
> diff --git a/Documentation/core-api/printk-formats.rst b/Documentation/co=
re-api/printk-formats.rst
> index 03b102fc60bb..e1ebf0376154 100644
> --- a/Documentation/core-api/printk-formats.rst
> +++ b/Documentation/core-api/printk-formats.rst
> @@ -240,7 +240,7 @@ Struct Range
>         %pra    [range 0x0000000060000000]
>=20
>  For printing struct range.  struct range holds an arbitrary range of u64
> -values.  If start is equal to end only 1 value is printed.
> +values.  If start is equal to end only print the start value.
>=20
>  Passed by reference.

That's nice, thanks!

--=20
An old man doll... just what I always wanted! - Clara

--9Cc/Ioko7b9fu/7q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZxuSRQAKCRD2uYlJVVFO
o5iXAP9xrOjWpF4wyXjCWIt8cPZkXj4PRmYPrb4rdo1tJKdsaQD/YSgjVnNC9gAL
Uwspgtau9BhYzixhiBXjAblLFPAHiQ8=
=+JhN
-----END PGP SIGNATURE-----

--9Cc/Ioko7b9fu/7q--
