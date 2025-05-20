Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BD71DD525;
	Tue, 20 May 2025 15:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747756307; cv=none; b=CJX4Y675/AqMzrg6vPyBUEcpwLf15phZ/I1pdPg7QmXASTxxRu741fmXn0byTf+K++0Ehw55s5l1atHHhBjJ8GgBArBIDgD5rIucnzzVz/tCnSCPmtBhbNjqHTBud1/A96QSe2922CC/UUNyBo/ehozbuHCKZqKcCPJScMiE4Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747756307; c=relaxed/simple;
	bh=IwWJceYu3JkiAc7/L82nbhvxzCuuysjyyIx3+TMwENs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=axOIjBf7AyOldf4n9Y5ZpTGHOMK222FwMh0BPK091IoclpFqi9otxJbG4NxLVTG7ldRX7LLy1WAbs+D3O8fnGfCxr2R8u9WZQU8Bmpe2LQ9BhpH8AgNB7sYZC0j++P/jpCTpNCDe+DGh6eqMRhfey9r2ogCQCiSi8cYBIbhCJg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qwlsqHNe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qwlsqHNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4485CC4CEE9;
	Tue, 20 May 2025 15:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747756306;
	bh=IwWJceYu3JkiAc7/L82nbhvxzCuuysjyyIx3+TMwENs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qwlsqHNeznsHNLLIriL2SvfwXRNNoEIs15W1mFoOE5kJlx+nYNh1X2cm71T3Q/ZVx
	 e0H0Xs8CbTZUdMZ9S35vb7+hOgYQdZ3+0Or8dDXVGNyIkvO/mMNwsNhSSlz/9fkOsU
	 iITZlaS+gfgNF0GU3Xyq5i92f2mWZ2o2pTmCP3OEli9PvWufC1O2RQKmwJy/Q4C8xZ
	 GH0FbAyp28fd4DFxqqdHFdNgtcmSa8OkY/44vX9wmv3Ekv4+0b+RckXATdFi1GferU
	 ezgOmmeV23hBXavTOQAi47jv3ga6css4ae+89nmtxaHg65s/gpLUoFkkPCNoXwwJTl
	 NTW4fx3okZ4iA==
Date: Tue, 20 May 2025 16:51:42 +0100
From: Conor Dooley <conor@kernel.org>
To: Drew Fustini <drew@pdp7.com>
Cc: Oliver O'Halloran <oohall@gmail.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, nvdimm@lists.linux.dev,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: pmem: Convert binding to YAML
Message-ID: <20250520-refract-fling-d064e11ddbdf@spud>
References: <20250520021440.24324-1-drew@pdp7.com>
 <aCvnXW12cC97amX3@x1>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/RmgWgYikgxBfqFB"
Content-Disposition: inline
In-Reply-To: <aCvnXW12cC97amX3@x1>


--/RmgWgYikgxBfqFB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2025 at 07:22:21PM -0700, Drew Fustini wrote:
> On Mon, May 19, 2025 at 07:14:40PM -0700, Drew Fustini wrote:
> > Convert the PMEM device tree binding from text to YAML. This will allow
> > device trees with pmem-region nodes to pass dtbs_check.
> >=20
> > Signed-off-by: Drew Fustini <drew@pdp7.com>
> > ---
> > v2: remove the txt file to make the conversion complete
>=20
> Krzysztof/Rob: my apologies, I forgot to add v2 to the Subject. Please
> let me know if I should resend.

I see how it is Drew...
Acked-by: Conor Dooley <conor.dooley@microchip.com>

--/RmgWgYikgxBfqFB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaCylDgAKCRB4tDGHoIJi
0rXKAP9g+8aPmNDbW0ZawJooRsBArqyl3mivyOOmhI0Jlw4OkQD/e2G4f5aQOLMo
kyN5yDei7EtHuv0vBfpg+PIvrwhuBAU=
=tE++
-----END PGP SIGNATURE-----

--/RmgWgYikgxBfqFB--
