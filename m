Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EEF18BBAE
	for <nvdimm@lists.linux.dev>; Tue, 20 May 2025 21:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747775341; cv=none; b=nV4N4HGvAhkNixDvMATOwQbgzdqoH0xKLtUxeZ9x2oJmZlAVFObvfvXtgoLkwDFfDFu5ftwjC4irPcfB2RBkyPlPt22rSNiDnePPhjeIiixfVUDLmO6f60LDw09xx9Mtw6cpaON3M0EZdH5SdSa6idd4FP5f3RutsOJwteseJ4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747775341; c=relaxed/simple;
	bh=ihB+rwt5XDis//1sTiN024h8VjUw07QCmCpDrWYU5hw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I1fhLG/6uncehJyywz8cAZ0aqw+dAvi9HFyGrU3QuWf4vjT9r2FgwzpXaD1NMdk42JH/plNZgGNT1FCMEIVhHOEDJk8cYKQMoPDSgmBM24TiV7JaPb4lnLgJCVyjErvbWFzxu79Dnle8OmtD7xhfOMdojZGBZPcINr+jmPeNdbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pdp7.com; spf=none smtp.mailfrom=pdp7.com; dkim=pass (2048-bit key) header.d=pdp7-com.20230601.gappssmtp.com header.i=@pdp7-com.20230601.gappssmtp.com header.b=2+UQxni8; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pdp7.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=pdp7.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pdp7-com.20230601.gappssmtp.com header.i=@pdp7-com.20230601.gappssmtp.com header.b="2+UQxni8"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7424ccbef4eso6111877b3a.2
        for <nvdimm@lists.linux.dev>; Tue, 20 May 2025 14:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pdp7-com.20230601.gappssmtp.com; s=20230601; t=1747775339; x=1748380139; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ihB+rwt5XDis//1sTiN024h8VjUw07QCmCpDrWYU5hw=;
        b=2+UQxni8F9X1/XIY32rEmfzYyDR2J2+TD1ekkpXqTWUgsBdZ4GpL1SZtRs0E9oh4cd
         XPULqdA2bzbs90T3SC/6k3biXPOoMBtD/GOSV+P6E45TmCsNDXwKfvIiggPp5eUF88C8
         I3bxbyKdCEizFPpdUxxIJEuBe+j8V0Lx71Lggk1n0laqRcdA8ugHYwlKuh4ttXCtzQUJ
         L57TQoAGRJZU+SLbEdMpr6Zn14x85A682mh5kPjPInFptUR8VAensH2h+paxBXITvOHU
         IZaWEbQYJYBgBNaKqAq6nzD2PmfAeYgiyblijHSJylSsbJECf+/QfGotvmiaJ/cMZM4v
         IEug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747775339; x=1748380139;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ihB+rwt5XDis//1sTiN024h8VjUw07QCmCpDrWYU5hw=;
        b=xQxBYM5xcI9ELfErHiBMrUdz1/4Oymdg7zvOBY5Jtq7UY/dGFkQkRA1+Ya0i+h/JQx
         rqTWtRVnpfD9BWeKdv6gLgxLvGUMgwSCLZupoW0cOEFvaxIqN32eElV5j51DYcEkCBs1
         6MqRcxwYq0g06pELHWcqutJOcFwi8aau8BfE7JGrg/W64kqau77Qo5RdhouYcre2m3+2
         PToeMucAEwIUxp1tWJiw4PtzBmcariLRSCmMrKQYRkNyVymqGn3rp3FD0UVijXYbWKMa
         K6EnY4nYfUSXRNjfnC0LZSBhMAd1+3knhItWeN1wE+czjf5Lw25pM7iuQzszQvgR0851
         RWkg==
X-Forwarded-Encrypted: i=1; AJvYcCXB9pB4bbG4yonIok7y3WPgMvDLvs6n65BWFzyB0n6BVN6NhNSYqze4EOEGm28Ez11c44//Gdo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxrfh0OLhCM6F5afyZJKQ26M/7wz3N+jR46J/uigNtFn8KcxXwj
	sI4Z+ORWC8TSRnrXUcrO37+sgTqrazKDvbmlrGcwzzY0AOXF3P3I4xAhehMwW9//wak=
X-Gm-Gg: ASbGncukbmtZYXiz6gtW8/hY4QBBz54OmYy5V2WbWouWni+WgS8Welr3Ybu+rhxxFfN
	xDl69syEvhyyQXnRcU1dEzoTiqIgB15tg+q5xFuPP6FycGcpRJ0C0nM1VAkF0aC6jorH2hZ91Lp
	iXuhZve1k9zd1jD/jee4zLlTf8w9U6bP1j08Bm2I5yWVO1QjXJ1xzaskLYkSnvIwLHkKQmfhC1d
	PDHqwalU2r4efdI92D6/GU73rqrJgeTUqbF7o7WOZjG5WOAgA1wHXpHsVM6oAEusMCXbgL7Q1Cb
	vtITBXQdJRu43sWd2l5lhrKHQGKEvg30pL1DBgFaZXgKx9d6XQLGYxaGAo7eGCiWt5b/1igIqg=
	=
X-Google-Smtp-Source: AGHT+IG0jhM90gGAp66mKqR5qQF6fDuQGVKEcTsZXkZTJKrN/agp03BwEkWo8NiFt8QodeRgqFhKrQ==
X-Received: by 2002:a05:6a00:1414:b0:736:450c:fa54 with SMTP id d2e1a72fcca58-742a979528bmr23777834b3a.6.1747775338866;
        Tue, 20 May 2025 14:08:58 -0700 (PDT)
Received: from x1 (97-120-251-212.ptld.qwest.net. [97.120.251.212])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a9829bbesm8361472b3a.89.2025.05.20.14.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 14:08:58 -0700 (PDT)
Date: Tue, 20 May 2025 14:08:56 -0700
From: Drew Fustini <drew@pdp7.com>
To: Conor Dooley <conor@kernel.org>
Cc: Oliver O'Halloran <oohall@gmail.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, nvdimm@lists.linux.dev,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: pmem: Convert binding to YAML
Message-ID: <aCzvaPQ0Z3uunjHz@x1>
References: <20250520021440.24324-1-drew@pdp7.com>
 <aCvnXW12cC97amX3@x1>
 <20250520-refract-fling-d064e11ddbdf@spud>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="OZWMYPezFAgPwp6M"
Content-Disposition: inline
In-Reply-To: <20250520-refract-fling-d064e11ddbdf@spud>


--OZWMYPezFAgPwp6M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2025 at 04:51:42PM +0100, Conor Dooley wrote:
> On Mon, May 19, 2025 at 07:22:21PM -0700, Drew Fustini wrote:
> > On Mon, May 19, 2025 at 07:14:40PM -0700, Drew Fustini wrote:
> > > Convert the PMEM device tree binding from text to YAML. This will all=
ow
> > > device trees with pmem-region nodes to pass dtbs_check.
> > >=20
> > > Signed-off-by: Drew Fustini <drew@pdp7.com>
> > > ---
> > > v2: remove the txt file to make the conversion complete
> >=20
> > Krzysztof/Rob: my apologies, I forgot to add v2 to the Subject. Please
> > let me know if I should resend.
>=20
> I see how it is Drew...
> Acked-by: Conor Dooley <conor.dooley@microchip.com>

Thanks for the Ack and sorry about that :)

Is it now just a matter of Rb from Oliver O'Halloran and this patch
going through the nvdimm tree?

Thanks,
Drew

--OZWMYPezFAgPwp6M
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSy8G7QpEpV9aCf6Lbb7CzD2SixDAUCaCzvUQAKCRDb7CzD2Six
DCUOAP9sDOAZPBBh/QTUuTF1j14KmqDTeNB0fB4FKon6h0DjcAD/ZUEtPbEC3x1+
kIv4K/IlzKAkFPw7HYaorSXa3OynQw8=
=TyR2
-----END PGP SIGNATURE-----

--OZWMYPezFAgPwp6M--
