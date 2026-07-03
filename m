Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1ED3D25C2
	for <nvdimm@lists.linux.dev>; Fri,  3 Jul 2026 14:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783087579; cv=none; b=t3fHznhREZCxdrrV7N3Vt27mQb1Mne7fnhTjCBRwudalQIGqVxjOUhbm03PAwxEdTrWwUKqmUYpv0caCRi2jJS3vU0WKMPRf5ynV9xW7y93n85N5BfJRUuehhNGrGa14dqAr7ucmpMXXtQ7Z17YniB54oCp1HOvW9mYgu/noLhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783087579; c=relaxed/simple;
	bh=wyqNjMaqnyGnSB8z7l+zYYA5NUJWruTBqnor+x4r1qU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FT+FvT8rq1WFMRTKjzTxb/OAwWg3TWZ0bipYnAm/2rMPoVjRAAfRuWSzFTx51vmeThsuvuQPKqj3q2TT1Lnz/ppMe2Z17x2G+19NTSmAwehx+5ghbdafkM79/hU0nfm8DU8uXWFNYT3oo/rmyUmDbf6M5WxtScMz8EhICJqy/iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JhNX0kyC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JhNX0kyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103981F000E9;
	Fri,  3 Jul 2026 14:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783087578;
	bh=ArvNEBWKJ0Cgy1PDOVudURuagJpnqBDRwV4a5iaMye0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JhNX0kyClSo4+we2qEc7Cch6tSogGxKnV6sBBf39W4ybG5ngysLPmzd6rN2Tt5Rph
	 IVxT6SJGpeJTW5ETYj+MAPapknqXFjZW3fYGwWwEu2XhmeTT+XcZ9SJ6uW8gt8/78Q
	 1fsa4Kc/eYhoVMsCqQNqnC1T3wzL37RfLXrOXk6PPKlyP1x4ydYqIxssVLyYyj8EnG
	 O/rM26nqz/RH5W7L76pa/hItnkDm0Qs1G8/mdFgKMYOAO0F9kVGm3FAGuk2nswrFlE
	 Oh4EtI8h/WvSbJ60A5SlRU+Tvxt/EoUnU0ZTfWy4UfZOHvNsvF0WwFlcm6XF2+8uD0
	 NA9Ovs1JgfEFg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] nvdimm: ndtest: remove redundant NULL check before
 vfree()
Reply-To: sashiko-reviews@lists.linux.dev
To: mdshahid03@gmail.com
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20260703135513.75840-1-mdshahid03@gmail.com>
References: <20260703135513.75840-1-mdshahid03@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 14:06:17 +0000
Message-Id: <20260703140618.103981F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Use-after-free / list corruption in ndtest_alloc_resource() error =
path.
- [High] Missing error check in ndtest_nvdimm_init() leads to NULL pointer =
dereference.
--

commit 96f1b7f6e50c7c8c92043b84b02d39517266ebe3
Author: Mohammad Shahid <mdshahid03@gmail.com>

nvdimm: ndtest: remove redundant NULL check before vfree()

vfree() safely handles NULL pointers, so the explicit NULL check
before calling vfree() is unnecessary. This was reported by
ifnullfree.cocci.

> diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/te=
st/ndtest.c
> index 8e3b6be53839b..2051ad5d4882d 100644
> --- a/tools/testing/nvdimm/test/ndtest.c
> +++ b/tools/testing/nvdimm/test/ndtest.c
> @@ -376,8 +376,7 @@ static void *ndtest_alloc_resource(struct ndtest_priv=
 *p, size_t size,
>  buf_err:
>  	if (__dma && size >=3D DIMM_SIZE)
>  		gen_pool_free(ndtest_pool, __dma, size);
> -	if (buf)
> -		vfree(buf);
> +	vfree(buf);
>  	kfree(res);

[Severity: High]
This isn't a bug introduced by this patch, but could this error path cause
list corruption or a use-after-free?

Earlier in ndtest_alloc_resource(), res is added to the p->resources list:

	spin_lock(&ndtest_lock);
	list_add(&res->list, &p->resources);
	spin_unlock(&ndtest_lock);

If devm_add_action() fails, execution falls through to buf_err, where
kfree(res) is called. However, res is not removed from the p->resources
list before being freed.

When the driver core subsequently invokes devres_release_all() on failure,
the cleanup function ndtest_release_resource() for any previously
successful allocations will traverse and modify this corrupted list,
resulting in a use-after-free.

Would it make sense to call list_del() before freeing res here?


[Severity: High]
This is a pre-existing issue, but while looking at this file, I noticed a
potential NULL pointer dereference in ndtest_nvdimm_init():

tools/testing/nvdimm/test/ndtest.c:ndtest_nvdimm_init() {
    ...
    ndtest_dimm_register(p, d, id);
    ...
}

If ndtest_dimm_register() fails, such as due to an allocation failure for
the dimm device, it returns an error but leaves d->nvdimm as NULL. Because
ndtest_nvdimm_init() ignores this error, it successfully returns.

Later, ndtest_create_region() passes the NULL nvdimm pointer to
nvdimm_pmem_region_create(), which dereferences it inside
nd_region_create(), causing a crash.

Should the return value of ndtest_dimm_register() be checked to prevent
this?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703135513.7584=
0-1-mdshahid03@gmail.com?part=3D1
