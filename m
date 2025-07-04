Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F353E1DF26E
	for <nvdimm@lists.linux.dev>; Fri,  4 Jul 2025 23:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751672184; cv=none; b=So2hFB5CpcBve/TBgxRTCn9TmewShjhKyLa9KXSFYhTtCF0YzTarU/U5dMSEo+LyLDLaXMW34bWwNEEWG5z1UzqxiZJlsGYwyvQEGYRyr1i+dfh4NzampR1Ta2NXXzR+qUKIp8BNjgnUSciCP6v5e36fxlanO9DfF4V1zyMcvl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751672184; c=relaxed/simple;
	bh=JCpe8NhiKEj2zPnP8azgWkKGslF6NDrVquXo+ef/qfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GP/bAsqfn/+FsT9P12iYrvW3hLffNoYLyH/QLGbT3tQ8m+UmPlCf7W374vMvyvxTOq83X0McZb/4PPKxZeAdunkiSERcm9zZwgM3P9bawBUaragpWF4eaX7y4w14r3+YadaS9mpgxQZDfPvfrIYoKk4rdVTEFCMs2vp4inAnYpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nNWanVdT; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nNWanVdT"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-af6a315b491so1189091a12.1
        for <nvdimm@lists.linux.dev>; Fri, 04 Jul 2025 16:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751672182; x=1752276982; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KW4ZkVJLizEOMZlm6FbGon5OHPMCQ+a5mWweGHJG9kk=;
        b=nNWanVdT31tr8CKAN0oeDTciJyJiBk6n1e/S2tgUYATCV09KJraQAPKQ8rHLw/TDEc
         InRVjP94+43KCVAdoxWRcxa7z+s24v0FGy0yCpImPdiOcddhOlAhzt+y5qpidpOu9Ysh
         74MUJpNeuhoh8qUCKoNz0x/QZ0zYVh5OObYEXSCebCip5cn/mOMiH6sLg0TNKLc7dWzI
         J8oO5SZ/kEvtqlDdLeYcAFKQw4BbS9lKRUYEHGdW7TssaFwiscQbRIk9UQlE7YzqeAhp
         nAnrbwSl8U0L/eDoNGV55GArYjBgpWqilh2wdRtgboiRTzulIiurkRddj71jenmE1nhQ
         Y0Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751672182; x=1752276982;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KW4ZkVJLizEOMZlm6FbGon5OHPMCQ+a5mWweGHJG9kk=;
        b=L57j1OR0LUFDuceAol3J4RG6ruMjybQVDvLZMT8oMUDTB4bdSx0euNGI5HlhbtXwPX
         o7s2+401FtLyX8kwvWXpaRBW0XVQTZdHv1Ki0hoLVg6JDz/LlNCnfdJXGPT90NVtsw4z
         Orqrqan3P5CiJjFkQ5K/lE6Is5jZuWz11weTYBBUio/9ZYDZ77AtLmcwsnwFUQRzCFaU
         nJJQ1bzPr4Bp8j55aEhwFygCPE4YtLQqV4/ew9+X2amagBHM7nT9ce8p+UZerMj7FuYO
         x9KWVfe8xR0IGhJkl0GX4dJA6ULlvkQ458ZVveX1GCAGx7wbUEBZvQIT89IkI91mulng
         RXFw==
X-Forwarded-Encrypted: i=1; AJvYcCXNXo1tsjgBJ58cuchcaqPr8HsL5KeyqgxNVtjgoWuOqxKkSy575Wlw9GDBDVe0M6e5GEHjt8c=@lists.linux.dev
X-Gm-Message-State: AOJu0YxMz+bhf+20FWbSmaf7DvwgJNiwrvfQDQgBF3wA0hWNyENFlBDZ
	bFvBMVShtS8c5Ss35Ip1svhI4kXm7aUNaYf2xhRHsX4oO0AZzjTpNepr
X-Gm-Gg: ASbGncsLdx8FjYxn8gln/VQTbudo5cRo/vzY9XTLkyhu3B1OhxZkwsnK562JkOpi1L9
	b2rbGaVaFbCANGOQqpifuUvu3NNygZ5/M0NG29tnKLMxlxuSY/mIQcAwqJ3l/mrrOm8yqUKb+7G
	VWnG5rLm2adMxPZJRvgJM2L8jhH0SFPiosXWu9BL+sGW7nrF8ATIFsyLiRDPZ8RfLTVxPxl00gB
	ewyxzyqAiiQbwwIxztif0PINSVSoSQx3UGcmc2q9eP1v6f3Gj7XYHoHdAR7C2QGEpNEh+YCWap6
	hZNipjsaZJKbHG1CAgxcSPfcO2wzIrFVRukal9E7iQf8+2U/KHUfR4duCfTnApApFA+LmYW7
X-Google-Smtp-Source: AGHT+IE4IRYdu9IVNI0Qi70rnYU18p+ftbhSiwCIQTDS0BZ3EOaU16ZkHZIPPf80+LxTA19o+gzvyQ==
X-Received: by 2002:a17:90b:3d8d:b0:2ff:6167:e92d with SMTP id 98e67ed59e1d1-31aac52f963mr5107707a91.32.1751672182068;
        Fri, 04 Jul 2025 16:36:22 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c845c4e19sm30681285ad.255.2025.07.04.16.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jul 2025 16:36:21 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id D71E34206889; Sat, 05 Jul 2025 06:36:18 +0700 (WIB)
Date: Sat, 5 Jul 2025 06:36:18 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>, John Groves <John@groves.net>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC V2 18/18] famfs_fuse: Add documentation
Message-ID: <aGhlckJrNJE1Au10@archie.me>
References: <20250703185032.46568-1-john@groves.net>
 <20250703185032.46568-19-john@groves.net>
 <CAOQ4uxj0Q5bnMNyOEA96H9yP=mPoM5LsyzEuKu184cDKaQuJpg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="PGzdml3OhylUUifk"
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj0Q5bnMNyOEA96H9yP=mPoM5LsyzEuKu184cDKaQuJpg@mail.gmail.com>


--PGzdml3OhylUUifk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 04, 2025 at 10:27:03AM +0200, Amir Goldstein wrote:
> On Thu, Jul 3, 2025 at 8:51=E2=80=AFPM John Groves <John@groves.net> wrot=
e:
> >
> > Add Documentation/filesystems/famfs.rst and update MAINTAINERS
> >
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  Documentation/filesystems/famfs.rst | 142 ++++++++++++++++++++++++++++
> >  Documentation/filesystems/index.rst |   1 +
> >  MAINTAINERS                         |   1 +
> >  3 files changed, 144 insertions(+)
> >  create mode 100644 Documentation/filesystems/famfs.rst
>=20
>=20
> Considering "Documentation: fuse: Consolidate FUSE docs into its own
> subdirectory"
> https://lore.kernel.org/linux-fsdevel/20250612032239.17561-1-bagasdotme@g=
mail.com/
>=20
> I wonder if famfs and virtiofs should be moved into fuse subdir?
> To me it makes more sense, but it's not a clear cut.
>=20

I guess these can stay in their place as-is for now. However, if we later h=
ave
more fuse-based filesystems (at least 3 or 4), placing them in
Documentation/filesystems/fuse-based might make sense (fuse subdir documents
fuse framework itself, though).

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--PGzdml3OhylUUifk
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaGhlbQAKCRD2uYlJVVFO
o4hrAPwIkZyEF8E7JsHO+OKP5L0TvZjbT8oSivNiKmNfaE5ezAEA2d4o2XYkIwSK
r1OLeL7fnBcdD125WPePOhWuuw5xoAc=
=gU4v
-----END PGP SIGNATURE-----

--PGzdml3OhylUUifk--
