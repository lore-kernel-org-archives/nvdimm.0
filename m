Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794854140;
	b=CAIsopBmuXEt4xLmRysWckDQA590ysEj8Weh4yQGYvLnzVLFjUaj0QPVEwhtCa53QcRO
	 b+vFgxfbyWL0R3JS+Cwm3h1LnUbwkxR3Mvxsxzm0QYjjO+HglPKNp7eXOvxneblmUu1h1
	 jBhJk6y2zIigTZkLhALd4dKmvpL/88pvRZavatj9lofRSzZCaBNfsrnTCJ78lMxLuTNyW
	 nGqvq9tBfuiZe/DDmxvvtoBLNUVqZgsSs59urVcED1pnMJt9lJAN36hJln2h1tzuY7TeC
	 +WLBSR47zXj762En5+UZCDJ/T//4X+Ad3GTkNqG9x7hC/n0yYMIyhClYKf+26dgL5Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794854140;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=EPargW/ndTMk8W5T5ryrw8EEtwPYjCnMb9VWPm+Ydmo=;
	b=SPAo51VD5AJCqlxnQQs/lV4+FS8qgPKvHey0/rAQ6+mwtgp3g25llOjYM8Xuna7EEAPk
	 ckDNG0ltjiAvUPA6JzIzUnENDZD6eqdAlFlndzVS5EfSi4E1F/fxCPdeC6Qoqm2bYKqWV
	 itvJJy8yu7etPrq9G5lkZ4hq/6ZTjNJFB+b6Dvvx/apfLNrFyzLu0mkzeoDlEsWAQPS4+
	 ELTTMl6wf637eHndBeS2roFMYjfnfoUoAa3zuIZ5XamouvbAWKFNUJGCU+J2FVU8bY3qM
	 /bin5ya3Ce6StKeMc9eBJrGSotBprOt0HViCz68gHrn+7dh3lw4Kh6tsM1hoM152CiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=baylibre.com;
	spf=pass smtp.mailfrom=baylibre.com;
	dkim=pass header.d=baylibre.com header.i=@baylibre.com header.a=rsa-sha256 header.s=google header.b=JVnc7vnk;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6455B606A322
	for <nvdimm@lists.linux.dev>; Mon, 16 Nov 2026 18:35:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6455B606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.a=rsa-sha256 header.s=google header.b=JVnc7vnk
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48b001cd92bso2536746f8f.2
        for <nvdimm@lists.linux.dev>; Mon, 16 Nov 2026 10:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1794854138; x=1795458938; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EPargW/ndTMk8W5T5ryrw8EEtwPYjCnMb9VWPm+Ydmo=;
        b=JVnc7vnk8KMuBuMAIYlao+O+HkhtuCh18paQChxsIjaSIkCzpFqsBkjD4Wcg+3pPhh
         pZzEuUX4GiZsACto0TJEj/T0zoYff38gcgB9ChD0MpKv9flt+PNwVvugvEtc484ontGg
         O31qiCV5a8JAmGByI7SStf7m/YapkILQ2AOyn5KNgnFKdGM5DYgfvI8lPG1qr5EOB1TZ
         ZJCwg633Zpe4qszKX6SJWYffHLrrmv3MZF1c3zojaoKi15U8UdySdMXiib1Hd7YwkcFq
         Q9sqlpbgjrxpymc3ab8IhwQQtQo3u4GpB9qx2GwnRL1hIQmrG0CySJBwSWJX5iqlB806
         RuTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794854138; x=1795458938;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EPargW/ndTMk8W5T5ryrw8EEtwPYjCnMb9VWPm+Ydmo=;
        b=fcavGsR4jfBk+oCeA2nx0vm4ReAOWQ9lts+Une8semyjUU431MhcKdRjGDFWoJBndU
         kCZs5vLtK8Ti9Ti4hIxQVFOOEEyPs2UywUfSOdQFTDoMj5m94J0tx4SeiRIIKqMk7q4U
         tbgueeCAdqFz8JZFfsJIqLgaQaq3C2u3f1VTO8aUtvcmcKdG7hJhU868ny5PgTUhwSSP
         wyzC5bdKsOjkBB0kjABQ3Gw6ml47/1b4abxXY7SHWr9WdbJQv0hJDVeGl6IOwONPj0Y6
         XUjmklteSa5z46+KasOyJsyoZT0p8PP9MaY0RqaPrDI/mBWzqIoHEHwW6//tEy938YqD
         PFbw==
X-Forwarded-Encrypted: i=1; AL+hErEEa+yUaim0v6BLGa9ZYbUUfnjmHLVjzZUX5dNIzYuTLtbVZUx0G0VbJtLQwC7jkFGjzprS+Es=@lists.linux.dev
X-Gm-Message-State: APuU4Z/NBhImabzi+C7bDW4+aLASW8OSBXRP2OhBuu6fvx3LyfYyc+3K
	H/1QbVs+aFJNiAJr3Y7p5jE1DrnZiE0gY4G6cbVnkbEbSO5dSsFmgl6hlAdnR6l/EpI=
X-Gm-Gg: AZFdTZeg4eW9G8r6mCtB/n5bOF5Xl8kyMDAP3m80dY//4f9TY2MunI/20A4mfrGmeKu
	vQ7K2hZKgulSq0yQeE1Gu1v2Pbl5NOIOxMmW8E5LIb8eVLRbCxSUW+GOMaYxIwDF+xRWl/56FNT
	JaNNvekgD3Wa+2rbf/YU1pT6B6zHFKjAmbF5lC0QR75s/W6KDutrg7rxhrYFPauehcSS3r90EtQ
	VAZ6Zh1ZFq/yad7cQXm8lRlWcY0fe/XHJT2QkDrinoSEiToLC2gz7HiSXEvAf+6kmSQiZdd/zD9
	FMW/BrpJmcSeRWRlG9SSU2xE4iIYXIO5UBLDaxfqxTsDwBbfagV71OWduxTQnrGjPWoNcTk4aWn
	i/s6YC4PDxkN2vKpvu+wzvbpNUnFejf0YZessv9Hww0+bPhPjKBQ4JqjXElw95ks8RGG8eJ1wwg
	OxpPK0JtQKQgEtsAQDPug+luSC9hMzkd7bcSUE1mhhFB8FqUdIu3GPfhcIHGqb5AdowJF+Pwas4
	2WW0Hc5EEQG1L4lxk/bmc/zRa3OkEwpSGSAcBTuGwMBGPgNAoDe4T68fIbI6+cw4CQWHr9LPjgX
	fq5joiSCVl5cn2I6ptwlSKnvLB4SBYw3Dnuhy3eSDeCFZ1Csjg4G+Ba4PuIUloL6XZFFfW+CqBq
	5SKDRww0eeGhgqQLZfwrUTfV6LRe0m66Ss7vYrw==
X-Received: by 2002:a05:6000:491c:b0:48b:118e:7454 with SMTP id ffacd0b85a97d-49c70a0f0cbmr22973182f8f.31.1794854137742;
        Mon, 16 Nov 2026 10:35:37 -0800 (PST)
Received: from localhost (p200300f65f19a90439293c698a65b414.dip0.t-ipconnect.de. [2003:f6:5f19:a904:3929:3c69:8a65:b414])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-49c5fe373casm23015553f8f.30.2026.11.16.10.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 10:35:37 -0800 (PST)
Date: Mon, 16 Nov 2026 19:35:35 +0100
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
To: "Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Cc: Len Brown <lenb@kernel.org>, Lorenzo Pieralisi <lpieralisi@kernel.org>, 
	Hanjun Guo <guohanjun@huawei.com>, Sudeep Holla <sudeep.holla@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, Ira Weiny <iweiny@kernel.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Zhang Rui <rui.zhang@intel.com>, 
	"Mario Limonciello (AMD)" <superm1@kernel.org>, Saranya Gopal <saranya.gopal@intel.com>, 
	Gergo Koteles <soyer@irl.hu>, Jakob Riemenschneider <riemenschneiderjakob@gmail.com>, 
	Yauhen Kharuzhy <jekhor@gmail.com>, Pawel Zalewski <pzalewski@thegoodpenguin.co.uk>, 
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, nvdimm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Kai-Heng Feng <kaihengf@nvidia.com>, Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, 
	Mauro Carvalho Chehab <mchehab@kernel.org>, Shuai Xue <xueshuai@linux.alibaba.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Chu Guangqing <chuguangqing@inspur.com>, Andy Shevchenko <andy@kernel.org>, 
	Mika Westerberg <westeri@kernel.org>
Subject: Re: [PATCH v1 0/4] ACPI: Use named initializers for acpi_device_id
 arrays
Message-ID: <avtL3i7n9cUARCd1@monoceros>
References: <cover.1794567577.git.ukleinek@kernel.org>
 <CAJZ5v0jC5YXsLgB6Qd55KNCU0oCsN86X5WpRfL+Ycz0MJ8vGqA@mail.gmail.com>
 <avs5thXfoZA4TBnE@monoceros>
 <CAJZ5v0iSJVszOCLCuK+ifCzTgx1RgDAExaYUbij=jaWmaTsb8Q@mail.gmail.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nqnngouwa55krefe"
Content-Disposition: inline
In-Reply-To: <CAJZ5v0iSJVszOCLCuK+ifCzTgx1RgDAExaYUbij=jaWmaTsb8Q@mail.gmail.com>


--nqnngouwa55krefe
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v1 0/4] ACPI: Use named initializers for acpi_device_id
 arrays
MIME-Version: 1.0

Hello Rafael,

On Mon, Nov 16, 2026 at 07:15:48PM +0100, Rafael J. Wysocki (Intel) wrote:
> On Mon, Nov 16, 2026 at 6:16=E2=80=AFPM Uwe Kleine-K=C3=B6nig (The Capabl=
e Hub)
> <u.kleine-koenig@baylibre.com> wrote:
> >
> > Hey Rafael,
> >
> > On Fri, Nov 13, 2026 at 05:17:30PM +0100, Rafael J. Wysocki (Intel) wro=
te:
> > > > Uwe Kleine-K=C3=B6nig (The Capable Hub) (4):
> > > >   ACPI: Unify acpi_device_id list terminators
> > > >   ACPI: Drop unused .driver_data initializers in acpi_device_id arr=
ays
> > > >   ACPI: Use named initializers for acpi_device_id arrays
> > > >   ACPI: Unify *_device_id list terminators
> > >
> > > All patches applied as 7.5 material, thanks!
> >
> > While rebasing these patches (as part of my wip tree that contains a lot
> > more similar patches) to next-20261113 I hit some merge conflicts. If
> > you tell me where you applied it, I can take a look and provide my merge
> > conflict resolution to allow double checking.
>=20
> I've rebased a couple of patches on some material merged previously.
>=20
> Please see
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git/commi=
t/?h=3Dlinux-next&id=3D58d4ba8979133c41cd491dff1dab40626daa924a

OK, it seems you already rebased on top of the commits that made my
rebase a bit bumpy and you did the same resolutions as me. :thumbsup:

Best regards
Uwe

--nqnngouwa55krefe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmr7TPUACgkQj4D7WH0S
/k6vZQgAjLzcTYkt9CbkThW0RlljMQXJxP5fmZNoFevLodwamfhpt+348ZmhBkWR
pva0yzF64v2uFwtmOgge+e1azRuruDvxfilctoJgbCV+g8N8GlaVkT6OU7mHXpNB
C/esmpj/xKsGPaZnrbRAXqxJ+/KWjGuW2Tc4/CLmjidnaqdHoi6we+/W/YDZe/zD
hK5ahEuQfANr2sXtQMET7/79wAiZ0mquQalFQaDDF2whSgyu7dWdt3+ahdFOS9u3
DTc/gz1Yiu4f/sTzP8Hh7Gr6y/CnHyaILNhtxA3YnnMqLmQnPEONbSnbua34q36a
S4dDn9kuuyzsCa5pFr4vhDplKXzROA==
=5qsj
-----END PGP SIGNATURE-----

--nqnngouwa55krefe--
