Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4DD2036E9;
	Wed, 28 May 2025 13:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748439812; cv=none; b=Hc39Hkz9CAZMh0TstuBkKFynv2O8FhW53PW1sK0X4Topu6zc12/DSyNbuSmix3HQ/xKrODW6u0kWBqQGQwjsRY6gxD3s2kUCiyJ74GmIDzsZXuJPoH3WMX4PO0nrgZjv4/hyMIH1kG0NxMShdytHi/NSXEOqmCm9VLf8KQdVkp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748439812; c=relaxed/simple;
	bh=vGq1HLmqALcNndq/cJJqVAuCSHa0StLEkf2aGzgkQAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jGtOZKi+9DFgD6M6hkuOc/lL6c0D0Cvfzm2g9ixBfBZqs0u0qKvsMPvv9TXls4PF9iaCiFSHeZG3VzjPplip8sfoiJFeRG5AZyW8tvKqT4F/zkbYABJBKqYVb62z0XW8vA00dcgaF9lmgtxMkbix3JJYzEOT9mhNQEeVPsGj1z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cNLQj2/2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cNLQj2/2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0003C4CEE7;
	Wed, 28 May 2025 13:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748439811;
	bh=vGq1HLmqALcNndq/cJJqVAuCSHa0StLEkf2aGzgkQAQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cNLQj2/2JUOfB2qDCAd+SDA0xzg1qDYDxvANL1nXVK2Z+5pepxh+ZXhYn8Vv4P++l
	 qHbXKCBahtH7aTtpv0xAAolaiIZj5TnUcDGs9LDsEMIb+Kw61bUtPcj1pN+8QTChHe
	 kL+2bJAftqGMyF4gGEgt+QFaPrJZG6k6/2d+o0ZK3yndspvsIUtcP/UMP1povs9h/y
	 WPmH70NjGmrr07yaRO0f0R7ZoOvHG48tXD951zJSaWTiRcqD5TxGzvxaHEFrjs7eNy
	 ckLouls9V0EHDvNKvjoRvBD2LqsJVQOSUSxLuMo3eh4WiSxSi0LE/aXjH0y3SkqqEY
	 LlNuwpOFTfrpw==
Date: Wed, 28 May 2025 14:43:27 +0100
From: Conor Dooley <conor@kernel.org>
To: Drew Fustini <drew@pdp7.com>
Cc: Oliver O'Halloran <oohall@gmail.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, nvdimm@lists.linux.dev,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v2] dt-bindings: pmem: Convert binding to YAML
Message-ID: <20250528-repulsive-osmosis-d473fbc61716@spud>
References: <20250520021440.24324-1-drew@pdp7.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="y1QSOGp96aDgzao8"
Content-Disposition: inline
In-Reply-To: <20250520021440.24324-1-drew@pdp7.com>


--y1QSOGp96aDgzao8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 27, 2025 at 11:17:04PM -0700, Drew Fustini wrote:
> Convert the PMEM device tree binding from text to YAML. This will allow
> device trees with pmem-region nodes to pass dtbs_check.
>=20
> Signed-off-by: Drew Fustini <drew@pdp7.com>
> ---
> v2 resend:
>  - actually put v2 in the Subject
>  - add Conor's Acked-by
>    - https://lore.kernel.org/all/20250520-refract-fling-d064e11ddbdf@spud/

I guess this is the one you mentioned on irc?
Acked-by: Conor Dooley <conor.dooley@microchip.com>

--y1QSOGp96aDgzao8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaDcS/wAKCRB4tDGHoIJi
0t39AP4vyfGKrHVY+bMT/PuBxs9qpgknPf0LIFJyfN2eoUZWEwEA8dr+FIxtNK1p
vEPMaK/ldN2T0lMdbk0tXTjE6+2fPg4=
=Z0xj
-----END PGP SIGNATURE-----

--y1QSOGp96aDgzao8--
