Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794600238;
	b=hrjY0VNcOotZ5sz/GyKmvWQv/6sTy+7TB+O2WVkIQeXPeh/ljmtTZbaKIKoc97nj1p3g
	 UT+Bg5CYgPgF04PcSU3Ya8Ll7PZaxD4VdgWF5l2Y6r3NKGbhG5m2P06Kz78YeCJWtkrms
	 14OneNp8uj0uKMaDtEVHADmSMCdtu7+HqLbJK7ozhsnR9HLDsyO6yfBWr5zgUSlptP3/O
	 9Pf9rwE5NJJIqAr/ik2FctZg1Wbc4p4on46WGNkFFacpo4883U9UcmFqjAMiIn1sHfcJP
	 Q1MjO7I8FvKR9f5KwQD+nemSrWiFnTei3trAqYIMXl6TQHRt0NZpd2TNdEf6l53eS+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794600238;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=A3el8S04EFqA+bkIJ/B4fePgF2ZgOcyTw3ueW29faVU=;
	b=Xw8eODIdMwon4wuDAr+iodgv1jblD2HeJ2BkPmE/l60H4VOBDf8W9Dcx5r+BQ5Yrhx1E
	 xHmif593IghNunnhgwNB+/TbweQslgt2hZ1IaL4Tfb0mN1eDvI/dbDyNPxDO5dszhtHyc
	 l5UrZTdpua/opacKLKCzXAzkwBVkMq2nAW7c4zUpz4JVF0IfV1D0sMeSFQNRE+ZI708vd
	 LleEjoK2/Cm7YdPw32D6DOBMpglSitjwfthojaKDJp9U/wkgJ015GVNao1buffe77C/uH
	 aENUNMq8xXRhF1uqnpIs1PFRIFyo2tW2ZuEcf58/JyFCnW7+7cSOkK+VFYGEDf2SIFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=baylibre.com;
	spf=pass smtp.mailfrom=baylibre.com;
	dkim=pass header.d=baylibre.com header.i=@baylibre.com header.a=rsa-sha256 header.s=google header.b=kNuA9oSe;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E93E606A327
	for <nvdimm@lists.linux.dev>; Fri, 13 Nov 2026 20:03:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E93E606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.a=rsa-sha256 header.s=google header.b=kNuA9oSe
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-490c3ae81d3so661248f8f.2
        for <nvdimm@lists.linux.dev>; Fri, 13 Nov 2026 12:03:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1794600236; x=1795205036; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=A3el8S04EFqA+bkIJ/B4fePgF2ZgOcyTw3ueW29faVU=;
        b=kNuA9oSeq+C2XLAZhHTK9QqXFvdJpELxmsLjF3EMtN1Lmg5nqB+PGmMnybOLlq3ISz
         C6QC/q6a3y9rWaaVpoFz11A43o5lRPtu74FR67tVi5/2RgeK2cg7eJT3Dn/niyIEeKLR
         1POVy/CinSHy8bBrej30ylWqx7fjnewQb5k3AZW+xHNlFNb4Vq9qiyKu2nNQX3P5kgCj
         Wnq+PQY458T6fruoVfNXiz3OcOAp57HbypM5xo/iv7Z9LMQz7gKCgVefdBRDsF+xQ0bg
         CmRgc/kLmDoZp7/Y/LEMg6DmnPPiHcxuBb8v/Aifx5Vra/UiaRsaPORkEmKfeqk6f2+Q
         YyaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794600236; x=1795205036;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A3el8S04EFqA+bkIJ/B4fePgF2ZgOcyTw3ueW29faVU=;
        b=ZeDbtgKPJVcCYpgI/XI1Wno2YvCQcz5NS1Ea+VxZY8fUgIw0+d4pd8r3qG9GEaknVg
         OMFUplj+uNsa+hUwQ/CrJ0CAzrcYjB5KuCFCb+yGj70KCrZi7k894w2UNH6MbIEnLZlm
         HFkAtejy8PeqG+4zPd8mEGd6uTLz1ANxCGkmfDY7omPDTYlREilFa92NqoIekLRdTeh8
         /vY1Fto+sEM+S5oSH20dF9PJq33i9TtlFM2sioZqkPw2gDOtZaqfPUq5hg83zWrlYaPd
         JFEQ+CTyKv+rnHiuZGUkC6KBze/P3HEO+rGkgBWwdV8F5+djlDlB4KADiZcxUzAlIvZh
         ujAw==
X-Forwarded-Encrypted: i=1; AL+hErFs21MtLcRLhgCqpTQU18N29itLvSYQFFNkrJJ9eHnQz2gWWElE97+9XRTNhnO9A2/aAqZUS3s=@lists.linux.dev
X-Gm-Message-State: APuU4Z8HqtAwS3tx2btyzxAPAzqz/VgY5fbOqitXex+9xsRsg/qsyWSy
	wlGT4CxStM+jtbdbUcW5bk/bFlAmtN0xx3nPgE32DgCliWTBscl8TWbjvivWhT1xinY=
X-Gm-Gg: AYBFou278DAqIG7QzbBtYNbhaOWDoDiRmC/kmXN/jFqfCCcifYO2YF0xo6525Z1jSNM
	6fFnOGv8pNulds22CcgYXSLFuyWF2EdDUAwRpRuhnmdpK0+vQHXjpeH8Hsx7N/m29PwOX0A6OgA
	OtC+u/f4hD/d7bI9EOMUWWmYZclhn7kr+e05tHhodtpkN5jZzsKp+NdPZf0J41EEg2IbJ25lVO7
	6apCwPmfGj+qG3ZpUYhJDAd+RoydpNiIa3NkWpiQiosdiM+wKGm51BTn/14cNl6B5+dp18ZhqOi
	m3HPjEipy/Ku50IOEpuXUWWznz3a+DyqTM6NAXaA2u0+Ou0ZPhEN5TF24AbgOoyou4vgeYyNKMz
	jM1v63ER5GprRM9a6i2lMiY6ruj/WrDuweP7L9SlkARrlFU3tXrdDerk6Z1TUbRnIW/Nr709N3u
	eSz3xXxeZTo67oCQaM34agwabVZiR8gVh4j+OeBag2umReHzTY6m9zuwJQbfkfZ1m8gyEz68PLc
	shw1ANkp8Zd7yvMnfUS2F+1XdmjZbvF7tHfxkp1R6SFkxu60c1JAqjN0VmljCI1Zfd1ohHO0SEz
	ZzE1USajB/ybL9fX3YodvZSpHNdhlikPfYazyjtznnGcZCWhsnJ1I14g
X-Received: by 2002:a05:600c:4e13:b0:4ba:38a9:85e3 with SMTP id 5b1f17b1804b1-4bb55a47fabmr74738355e9.12.1794600235768;
        Fri, 13 Nov 2026 12:03:55 -0800 (PST)
Received: from localhost ([2a02:8071:56d1:2de0:1d24:d58d:2b65:c291])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4bb55ae5299sm94406885e9.11.2026.11.13.12.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 12:03:54 -0800 (PST)
Date: Fri, 13 Nov 2026 21:03:53 +0100
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
Message-ID: <avdryC3GOqVNVF8s@monoceros>
References: <cover.1794567577.git.ukleinek@kernel.org>
 <CAJZ5v0jC5YXsLgB6Qd55KNCU0oCsN86X5WpRfL+Ycz0MJ8vGqA@mail.gmail.com>
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
	protocol="application/pgp-signature"; boundary="4g7esaq7hdzrtwtt"
Content-Disposition: inline
In-Reply-To: <CAJZ5v0jC5YXsLgB6Qd55KNCU0oCsN86X5WpRfL+Ycz0MJ8vGqA@mail.gmail.com>


--4g7esaq7hdzrtwtt
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v1 0/4] ACPI: Use named initializers for acpi_device_id
 arrays
MIME-Version: 1.0

On Fri, Nov 13, 2026 at 05:17:30PM +0100, Rafael J. Wysocki (Intel) wrote:
> On Fri, Nov 13, 2026 at 12:14=E2=80=AFPM Uwe Kleine-K=C3=B6nig (The Capab=
le Hub)
> <u.kleine-koenig@baylibre.com> wrote:
> >
> > From: Uwe Kleine-K=C3=B6nig <ukleinek@kernel.org>
> >
> > Hello,
> >
> > this series is about preparing drivers/acpi for a change to struct
> > acpi_device_id. The idea is to replace .driver_data by an anonymous
> > union, see
> > https://lore.kernel.org/all/cover.1780048925.git.u.kleine-koenig@baylib=
re.com/
> > for more details. (The linked example is about platform_device_id, I
> > intend to apply it acpi_device_id and several others, too.)
> >
> > Before this union can be added, all initializers must use named
> > initializers (C99 calls them designated initializers), which IMHO is a
> > nice cleanup that can stand for itself as it makes the code easier to
> > read.
> >
> > Pawel sent a similar series earlier, find it at
> > https://lore.kernel.org/all/20260727-acpi-refactor-v1-0-ff900aa326ee@th=
egoodpenguin.co.uk/.
> > Compared to that the patch splitting is done differently and the base
> > here is newer.
> >
> > I checked for the other *_device_id and for these there is nothing to do
> > below drivers/acpi because the few instances already use named
> > initializers.
> >
> > The last patch in this series is just some cosmetic to align the coding
> > style. If you consider it churn, just drop it.
> >
> > It would be great to get this series in soon, as keeping it up to date
> > for a later resend is an annoying effort. Thanks for your cooperation.
> >
> > Best regards
> > Uwe
> >
> > Uwe Kleine-K=C3=B6nig (The Capable Hub) (4):
> >   ACPI: Unify acpi_device_id list terminators
> >   ACPI: Drop unused .driver_data initializers in acpi_device_id arrays
> >   ACPI: Use named initializers for acpi_device_id arrays
> >   ACPI: Unify *_device_id list terminators
>=20
> All patches applied as 7.5 material, thanks!

That's great, thank you.

I fatfingered my author address in patch 2, so if someone wails that the
author S-o-b is missing and your tree isn't set in stone yet, something lik=
e:

	git filter-branch -f --env-filter 'if test "$GIT_AUTHOR_NAME" =3D "Uwe Kle=
ine-K=C3=B6nig (The Capable Hub)"; then GIT_AUTHOR_EMAIL=3Du.kleine-koenig@=
baylibre.com; fi' next/master..

should fix it. Sorry!

Best regards
Uwe

--4g7esaq7hdzrtwtt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmr3bRsACgkQj4D7WH0S
/k566ggAp3mVFLzwpw2p/Hu9/ihSgiW3Z2Tu9oz8iP6Hksl4NiASgBy6mJoash2/
ZDHfLPzYzE0YsfjakvmDc8blOwPZ2QV69Vx9Fc8fLNJi1PvJ74rqfVIPonGSvdXn
6+2YBRjK+POnqAPEnXAd9cApwIMTQ9NYSvjrWGyQouXTDKMInmgoLfb/tYhLof9q
b9dnQA9vTvGhMcKgdtAHObnpFXb94+Jl4CWWoU0Mk9QgO9AOxkb9TjdpZqPCXbcB
A/FFYcgiErFTmvM7eidmBfW/sKlCCSyQdTjpteEL4Nov/1w7p83cyHBBPnKx/mDk
cN+flW8XminlXyu6kws4p0NQuaFi8w==
=bkIh
-----END PGP SIGNATURE-----

--4g7esaq7hdzrtwtt--
