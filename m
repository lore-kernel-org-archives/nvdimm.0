Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D288317BA1
	for <nvdimm@lists.linux.dev>; Sat,  5 Jul 2025 01:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751677877; cv=none; b=G7AoS/Tg4u2zZDdPsQZqq9cnszaLm3dnLXtWgeIHPJs/9c4RZr9sWQ2Rs8Ffx5gpUghkC2pO2u/7h/Dpi2FOKJwbdGoH5aGS1WLaVkKxvKZr2BwKHX6LHM6KTtorjF1S1Q5c8bJl+LvjJCiOw7R56PwmUfmPb/0YX2d9AmPpYAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751677877; c=relaxed/simple;
	bh=TGLHtQniPFFRkVhKxL21veKIv8ziGCFBrUf3ZmavJfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eXXyae6o2SmdDDHMXXC6zsxCXEUDl6vHCsye8CjgcRrcbFDsUWLNMm5dgT9HfiAWO88VTMxLeG1+3OFFSUsX22R3pGNo0o/24BbD2XgKYBGzJ16q5DzEWfm9NPL3FELYYy4wVC3BBZL21Nr/nA4gqLhmDq6QC8V61ONtb4cNAoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FQlfSuVL; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FQlfSuVL"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-acb5ec407b1so233670966b.1
        for <nvdimm@lists.linux.dev>; Fri, 04 Jul 2025 18:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751677874; x=1752282674; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X/RMW5ROGAxC4jVB3NK6djzooskyVRPZCJn8BCZVKk8=;
        b=FQlfSuVLwGRl0RVqqN+b4rcGwGUyKS3zXNRoBMxdI2urigDDrWkIwypDWQeSVT2QoD
         bYBUmRSV7pwRYOO9Sl35fTQBnkHu4NJa1BrFKiyeK67einRk0K/L3NI7XMF5R+jTzqAe
         Aqjcc4gr1SjaNjsJJiXbONl8aoo0GvwH0uYIwASavy1EumYcbeVpSimcHRrzFg/utynt
         Pw1MtKMqnmk64pXnKBh23a18I8dBbHDQxwf2FCFhX2rX5yfItKJhsoitDoARClawCa0u
         S72hAnfuw+I0ES/6Th8dDprBKFWXuqd1C6qJ58KY1NhZWbzhdI8j50u9v0fWz+PzCCGx
         cb7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751677874; x=1752282674;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X/RMW5ROGAxC4jVB3NK6djzooskyVRPZCJn8BCZVKk8=;
        b=AC3N8znnKP0F15PNsL+knm+Z/vsHn/rM8aLu1IRr2fXHi8d9xxNn3XKMQWNuo7466/
         tT6g6gSuUzRtH2oj05oIaYw8+PqVL3j/cGIUStM2LLxxFltLjQ4vHVECq56URPJKam76
         tY9f4/H2qUJ0Wm95ascPibFUkZSVKXV/xphEU4BKt7RjuZC5DeiQqH+voueB2zKoS1Hk
         rGhz0OI50ws1AIvalEt6qGfTQ1PW9VYn4g/ysgBNTdK7OyLavuA0LyPqU3SntOuZSz7u
         I44Fwrf9m5ynaKPhJ9sxE+AB5t65pJuVo9YUp4wC34496C14vc1xG+nnAx/6v6M55wJp
         emWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJ0o9hr9Ajg2WTJnqkI4xxkTYc9CRgvO7XcUydqr38If4KYiuJTsXpdK3XUHmZztmm15aG6nM=@lists.linux.dev
X-Gm-Message-State: AOJu0YysRkjaJutR+YMbeZlJZrQPXSc+opqewVmmumQxfl4ODMZiMfaq
	A4wCZFDT5GiIfLSavXZgublk5nHL0LeB83BmsADjjfDkVc0BnePUKxlg
X-Gm-Gg: ASbGncs1rQ0RKkpmcY1xxrOTeQ5M8VSBVKNFEV+3YgTrnqR1VYqIb6TkmjZMH0/j94X
	qv+TCYC3dpqDaqLJZhJqjabMrnlj4pLxBJTDpcu6FoUs28+SjFJKt6yxcv5fjAIPLFHSOP2rhWz
	u3MCDzjTyCLAk7GpoTvnJfYHj8OJJBnLcTD6THpZ0X9BRGwlGYrmBGuVHRG+58hOxRvJWODtWS/
	gpTsSfrI35Ucn6MqYKK13jdcp73+sgmulwfivSbETJp/1D6UnYC9X1L6iPUlEezqoao3wMEUVvR
	YBFuQsUJeWvOfVnbtQyXDBZUgBpjrlQDT0t0MwS/EV8NdwoVNyvv97RTyRhqH0cP+1PQBbSs
X-Google-Smtp-Source: AGHT+IHUSIHx+BqSNZT+kZlLiCbHuIOKR1i5aqY9CMhhNpFb/R2602F6DzC/dMa+aAfLN+gs6Hk14g==
X-Received: by 2002:a17:907:1b1d:b0:ae3:cb50:2c6b with SMTP id a640c23a62f3a-ae3fbd141camr471008866b.38.1751677873862;
        Fri, 04 Jul 2025 18:11:13 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae3f6ac35e0sm263535366b.73.2025.07.04.18.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jul 2025 18:11:13 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 1F3A241F3D86; Sat, 05 Jul 2025 08:11:05 +0700 (WIB)
Date: Sat, 5 Jul 2025 08:11:04 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>, John Groves <John@groves.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Miklos Szeredi <miklos@szeredb.hu>,
	Bernd Schubert <bschubert@ddn.com>,
	John Groves <jgroves@micron.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC V2 18/18] famfs_fuse: Add documentation
Message-ID: <aGh7qBzEJMFf_srS@archie.me>
References: <20250703185032.46568-1-john@groves.net>
 <20250703185032.46568-19-john@groves.net>
 <aGcf4AhEZTJXbEg3@archie.me>
 <87ecuwk83h.fsf@trenco.lwn.net>
 <aGdQM-lcBo6T5Hog@archie.me>
 <aGgkVA81Zms8Xgel@casper.infradead.org>
 <aGhjv37uw3w4nZ2C@archie.me>
 <aGhnFu8C9wVPiXBq@casper.infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vhvcLO43juMxDsjQ"
Content-Disposition: inline
In-Reply-To: <aGhnFu8C9wVPiXBq@casper.infradead.org>


--vhvcLO43juMxDsjQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 05, 2025 at 12:43:18AM +0100, Matthew Wilcox wrote:
> On Sat, Jul 05, 2025 at 06:29:03AM +0700, Bagas Sanjaya wrote:
> > I'm looking for any Sphinx warnings, but if there's none, I check for
> > better wording or improving the docs output.
>=20
> That's appreciated.  Really.  But what you should be looking for is
> unclear or misleading wording.  Not "this should be 'may' instead of
> 'might'".  The review you give is often closer to nitpicking than
> serious review.

Thanks for the tip!

--=20
An old man doll... just what I always wanted! - Clara

--vhvcLO43juMxDsjQ
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaGh7pQAKCRD2uYlJVVFO
o/GiAP4tesyMBf5QzSsvVBV5gxPDNwesiOtgDt+HtxlS18HLLwD/XWPRGBM1yZhx
4w3Fe2lF6lFmlIekyWjwIMJ0Qkci4A8=
=hztl
-----END PGP SIGNATURE-----

--vhvcLO43juMxDsjQ--
