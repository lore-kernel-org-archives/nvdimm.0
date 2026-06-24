Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6025623BD06
	for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 04:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782275491; cv=none; b=uOdWUl4FqfNP4Tt8wZFRo9FQnm6XO3WxdjOsx8QCBrV5k4RvFrWUF6f5GR7LCYk/1/1tjog+4oExx5woNRIZPeO1SNK6Q3UYU2Y5dohj5LpU4La9p011T0mqVCYXXYt0t5FlDntuF4FZvO3sIF4558AQYDwtORSIODPUiHlLQ74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782275491; c=relaxed/simple;
	bh=W2UZCvG8Lp2t7/oubCaMYOFplj4HCeKAvAITk7qhAMY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ds9uQAU5cz3scoUpCGN1beTYUk93FHXK8fE2b8nobC4jw1v60pccCyvKK2hfJzagphnPMGxxps/okxsQRbl/IAw+o7Ue+Ac/bISCtY+THV+p2W+SLl6sIJCbiVnBHypMHW/Lu+QHLC+Otpee9T8HtqxDn4oDXfWWmifTGdQuy3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E0pY8qBH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E0pY8qBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3111F000E9;
	Wed, 24 Jun 2026 04:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782275490;
	bh=7iSFKqMf9mgLaXwLbkd4aC2LwZhiqzRUpVJd1jBXGec=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E0pY8qBHOS67ZIitLZFIRcDJoDqPMQ6notVO7dnYXTgIy4VQP8sObpfkLQp2IP860
	 KpSr7mf2O97LCqfQlvMuQGsmcQXBcVn/ASYXz9+q/0fMXVp+8J3sZ2aEy5nqqodl91
	 CP60pxdn2Bk74I33IGhOiIMUWYP5byn5Adv/r+go7VByy1juSNM0CEzR80Y7rRZ7RB
	 ICKUVU6kqCC0m59nnrLKGpd6HfxkfcnOBxHd2c4IHFulx3xCa+4b7j3mlxOumJ3Z+K
	 4mcYzWqSDhwDWkf2jT1Fjqq5961Nq1E7U1WhDRvdGnShTt1/CZesjc9eBdUTwxslCN
	 6InlM8Gdccfog==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] libnvdimm/labels: Prevent integer overflow in
 __nd_label_validate()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas via B4 Relay" <devnull+hexlabsecurity.proton.me@kernel.org>
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20260623-b4-disp-1f2c537a-v2-1-59af73f1f090@proton.me>
References: <20260623-b4-disp-1f2c537a-v2-0-59af73f1f090@proton.me>
 <20260623-b4-disp-1f2c537a-v2-1-59af73f1f090@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 04:31:29 +0000
Message-Id: <20260624043129.DD3111F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The expression `1 << (7 + nsindex[i]->labelsize)` invokes C undefi=
ned behavior if the untrusted `nsindex[i]->labelsize` is maliciously large.
--

commit 1590d4e94c2716631030a170a8e554c454f824c4
Author: Bryam Vargas <hexlabsecurity@proton.me>

libnvdimm/labels: Prevent integer overflow in __nd_label_validate()

This commit fixes an out-of-bounds write in nd_label_data_init() by
evaluating the product of nslot and label_size as a 64-bit value. This
prevents a crafted nslot from bypassing the config area bounds check
due to a 32-bit integer overflow.

> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 4218e3ac4a2ab..ec12ce72cfe2c 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c

[Severity: High]
This is a pre-existing issue, but while looking at __nd_label_validate(),
is it possible for the labelsize shift to invoke undefined behavior?

The labelsize field is read directly from the untrusted label storage
medium:

drivers/nvdimm/label.c:__nd_label_validate() {
        ...
        if (version >=3D 102)
                labelsize =3D 1 << (7 + nsindex[i]->labelsize);
        else
        ...
}

If a malicious or corrupted medium provides a value of 25 or greater for
nsindex[i]->labelsize, 7 + labelsize evaluates to 32 or more. Because 1
is a 32-bit signed integer, shifting it by 31 bits causes a signed
integer overflow, and shifting by 32 or more bits exceeds the type width.

Could this trigger a kernel panic on systems with undefined behavior
sanitizers enabled, or lead to unpredictable behavior due to compiler
optimizations?

> @@ -202,7 +202,7 @@ static int __nd_label_validate(struct nvdimm_drvdata =
*ndd)
>  		}
> =20
>  		nslot =3D __le32_to_cpu(nsindex[i]->nslot);
> -		if (nslot * sizeof_namespace_label(ndd)
> +		if ((u64)nslot * sizeof_namespace_label(ndd)
>  				+ 2 * sizeof_namespace_index(ndd)
>  				> ndd->nsarea.config_size) {
>  			dev_dbg(dev, "nsindex%d nslot: %u invalid, config_size: %#x\n",

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623-b4-disp-1f=
2c537a-v2-0-59af73f1f090@proton.me?part=3D1
