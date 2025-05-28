Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380AD28DF55
	for <nvdimm@lists.linux.dev>; Wed, 28 May 2025 18:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748456012; cv=none; b=m2lijC6k4YhsjnkUPjwBjfE4Y1dJytGufDwFR7yRiUgyWok/inFWie2kDY74ASoTSYXPded3ixNAtPqWOIJE7uJEX5IPsg+maJSuJ4FG2f3nVu9nsF1hQ5o9HqhkjdkZc4cMSqaE+hQASwybyCudMVA0SNIGbrLrpNh9NOEYDdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748456012; c=relaxed/simple;
	bh=U4kfnRSN59WkHY9Ler2V9T7GAxjBXkqvdf0hrH9hz68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OD79UrZleR89cAmSEMZi9bLujZVMk/K3alt/Glk3496TEpNMW7rCqEYtSzBrRO/RMfUFaNIJd99R/hP8OSFqxisxeMJjGsZQB4rhv/UMIF5n9ew8pyDWjM59CoehxspsyeN4N/DolfhX1nzqxMxGgILH73fJBN2a4pLipxqEW+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pdp7.com; spf=none smtp.mailfrom=pdp7.com; dkim=pass (2048-bit key) header.d=pdp7-com.20230601.gappssmtp.com header.i=@pdp7-com.20230601.gappssmtp.com header.b=Q/gcVIUJ; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pdp7.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=pdp7.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pdp7-com.20230601.gappssmtp.com header.i=@pdp7-com.20230601.gappssmtp.com header.b="Q/gcVIUJ"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7426c44e014so9337b3a.3
        for <nvdimm@lists.linux.dev>; Wed, 28 May 2025 11:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pdp7-com.20230601.gappssmtp.com; s=20230601; t=1748456010; x=1749060810; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VfQ5QF4QrPtGjwJGXo+I+tvoV3Ek+wsqmkmzYgFTPno=;
        b=Q/gcVIUJlsj2U5UjjsKO1ixVeN5EthjKbQJaav8NeiUG+uIuQaPa7Yfvjm7Lg9zLLx
         6oGBliDOjRk6pu1frwr+uhU7Uu9KrdhBpa+9AsErI/ma+ED2hpORMDP8yGo6IedAAl2u
         NadPhHP9fI4Po75x1LQYKeEdpgs8R5LJDNOY9Wbu5UZ8+ehQGbpsiNRKJmeHG8j6zrlF
         Mb2Qn5bNQBs098otBENahfdF/1i561o1/JgWKeQJnAmHr5ZmW54/wYDw1Lu3+11jesfy
         qiK69mFu3aENF/j6985RF1Ex70NBLmEGWJKQVRyY8pEiyWKjsTjQxgsaGPpkTjlhld1U
         2m3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748456010; x=1749060810;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VfQ5QF4QrPtGjwJGXo+I+tvoV3Ek+wsqmkmzYgFTPno=;
        b=vhsYEFHBT2pbuKCuIrCp2scESgBGl28cAN3Ov2TW4yF3jhdEiFLbOnYbbSy3BUkUaw
         cLBDY9NFrGF9xLCO3kaDjYEMNBOUPyMCwdZlSzB04DDsdEzicGmiRmSpt3rnfIUMFBsU
         8wbZVqS7p0JPeXop/bJK0MvImbt+BOAo/IhzEHxAF8RI9ust/hLrdvw6UpqN1JfW6vZJ
         vixlqGDMh5Sxib9xOJLk+S2t2Fkjy7UZT5DkkoYM4fZKDQojZQOVW3kmySU+tESRxtnh
         76FJxvZMJCjYHUdLQcKABZ7kT4ZT+v6D3A0DUL5Za8GH4hWOEks3CAM4pgAebp/iisW/
         zmjQ==
X-Forwarded-Encrypted: i=1; AJvYcCWY2/VfpTKc0TVUfduYjrJYu52zkR0jtDVRH8ig5YfojFIDgxjHAeckacJHXJzHlEeARv1hp9s=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5EXWcY6P/VE8VSvN45ZnjDPjvFP29DbdMnAyS7sLRDN6AOWig
	Hcui3Yb6kLrLiji27qh/eDqVH5OxQBCDlr9bRB0kO1LH48rvsxBMJ3MH8hckKY5KpVN4zNMejbK
	fqorEiLc=
X-Gm-Gg: ASbGncsHaEQtzuTt5Qq2ZlGgaaoBnf+sNE09MuYuXxiSWtiUE5UGQNzwWablC8emO/I
	b4IVxSf9wvaQVskfBaiSL26rWFmKZU1l06LU0fFqKhAu742xK9VTVL39d6PSGL5jCOG3wZE0kvx
	+6cv00d4+LaNhJcvQJGD607uBy9SCek3VvsrrOt8+7ZICdVaJ0BL8PPQOg2blOLBCvyXeChDksQ
	Fhur7N0BMkljzfOUm/DI8T4BYL3BX7hNe21BxTMbFv9u2M40cBfX8twPpDkX1U40H4FQszgvQF/
	ibbxf4/IVjaX7CvVivXoWGPjJ+wXQ66ZHSKjedYG2LfWoClcQw14JaRiTQ69D4A=
X-Google-Smtp-Source: AGHT+IGoXH5nWNXVter/7FoojUs8PwU60p8upKHgzmtsaMD1s8dITxfPj8ze1St+uUzaNtQ6OA7rQA==
X-Received: by 2002:a05:6a21:46c4:b0:1f5:6abb:7cbb with SMTP id adf61e73a8af0-21aad87d03emr5439458637.23.1748456010381;
        Wed, 28 May 2025 11:13:30 -0700 (PDT)
Received: from x1 (97-120-251-212.ptld.qwest.net. [97.120.251.212])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-746e345fe8dsm1571589b3a.174.2025.05.28.11.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 May 2025 11:13:29 -0700 (PDT)
Date: Wed, 28 May 2025 11:13:28 -0700
From: Drew Fustini <drew@pdp7.com>
To: Conor Dooley <conor@kernel.org>
Cc: Oliver O'Halloran <oohall@gmail.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, nvdimm@lists.linux.dev,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v2] dt-bindings: pmem: Convert binding to YAML
Message-ID: <aDdSSNeiveSrM9NE@x1>
References: <20250520021440.24324-1-drew@pdp7.com>
 <20250528-repulsive-osmosis-d473fbc61716@spud>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="39RrpW82KPLL21NE"
Content-Disposition: inline
In-Reply-To: <20250528-repulsive-osmosis-d473fbc61716@spud>


--39RrpW82KPLL21NE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025 at 02:43:27PM +0100, Conor Dooley wrote:
> On Tue, May 27, 2025 at 11:17:04PM -0700, Drew Fustini wrote:
> > Convert the PMEM device tree binding from text to YAML. This will allow
> > device trees with pmem-region nodes to pass dtbs_check.
> >=20
> > Signed-off-by: Drew Fustini <drew@pdp7.com>
> > ---
> > v2 resend:
> >  - actually put v2 in the Subject
> >  - add Conor's Acked-by
> >    - https://lore.kernel.org/all/20250520-refract-fling-d064e11ddbdf@sp=
ud/
>=20
> I guess this is the one you mentioned on irc?
> Acked-by: Conor Dooley <conor.dooley@microchip.com>

Thanks, yeah, I've become too used to `b4 send --reflect` and managed to bo=
th
duplicate the message id and not actually include your tag when using
git send-email - d'oh! ;)

Drew

--39RrpW82KPLL21NE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSy8G7QpEpV9aCf6Lbb7CzD2SixDAUCaDdSOAAKCRDb7CzD2Six
DHbhAP9XlQng+snuCwTSEULcb16UVf5k2n1W3hLLrDVfGt4ZTAD/ZE3wUuc6HIbm
UMX2OND4pLWeegQhzQyiJYCOPJ/k8wg=
=3wuH
-----END PGP SIGNATURE-----

--39RrpW82KPLL21NE--
