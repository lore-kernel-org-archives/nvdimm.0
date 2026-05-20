Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D602371063
	for <nvdimm@lists.linux.dev>; Wed, 20 May 2026 03:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779249395; cv=none; b=Ot5vBkY64vhVQlIvC1aTf11r5gBY+Jr2cLqzSx47XKCzaQUJQElHglWG2x6j0ledi/IFPHkGtTX9Fu1diEcupXpZ7go6fDYWS/Kcg3qveJFerNWpJrkVPA0aDYXI6/V4BqGVBJvarHGwcBQrlSEl+zsuT6U7wzpa0pO1fT9sukQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779249395; c=relaxed/simple;
	bh=OYwWmGW4VJ45HybR3KWpW+Ex8/FpANhlftj9FMzMwWE=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=pHz67XEU3TCGdj2ZW4JdEwGkcdIZrRChOflofogItuPQ5d6SBkAzJZF1PUN25Gqs9kC9fETDPWOiLoSzE8S+huMutEtymgnkyoj/4QBeOmLiT+58kvVwMo57wU46g0rRee/thQPiQblG8VoDIUvFVUfg5Rvd8eJv1qrtwIHDv14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yi5WmgT9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yi5WmgT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7F61F00893;
	Wed, 20 May 2026 03:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779249391;
	bh=Lf4BSX3FaLVLxFUZXG4X89++fzsTeeUiOreKare3NAE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Yi5WmgT9qNmzIgl56d/8FR7Zec2qjm/QGuwMJJVK/eiZ+iHrkP+HTlejkd27p2kMs
	 DgRek713kzBYXkFUfqP7Jel+kY3sGBrncvmxsixNR9U5P/LCYZ3sXQprVSU/Mngp1E
	 ajBqr+C/NOFBlMlWtjS5VsbgJ+1sCQELS67yBdY+gLcFMx5dONa2l/arBIveDdJyG4
	 ltUJzugmZROiOzyn8SO0XGE70UjwmnzjoJkR6WAK92GGycDY9b+qRwyhUnxD4c2jIq
	 IoL5HB0CBtL6ZIK1RjNQXGqX5VItFd4xKyeLgH6ADIXSLXGtTST5sSwBklLZUV1DX8
	 lWUP2/lYIyb1g==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id B4533F40088;
	Tue, 19 May 2026 23:56:30 -0400 (EDT)
Received: from phl-imap-16 ([10.202.2.88])
  by phl-compute-02.internal (MEProxy); Tue, 19 May 2026 23:56:30 -0400
X-ME-Sender: <xms:7jANagnWq9yfpj9HU2UuHzAfR7RJZP1GNX34AMbOM3A4JVdf6PZC7g>
    <xme:7jANaqoLUVFcEpaXUlGrNV5q5fiZf9Y40Jxh1ROH0D4n0h7yrMiIrsLgeQSfwLUDP
    CxKJBDizbi0-KYnDIviUwzNKVCIh_hhT6dreG457Gkmj8GTX_G6YLV5>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddugeefiedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdejnecuhfhrohhmpedfffgrnhcu
    hghilhhlihgrmhhsfdcuoegujhgsfieskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpeegueekjeehudehheduffekgfehvddtgfeutdeukeeihefhleeuieeuuedtteeh
    ieenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepughjsgifodhmvghsmhhtphgruhhthhhpvghr
    shhonhgrlhhithihqddujeejvdeftdegheehqdeffeefleegtdegjedqughjsgifpeepkh
    gvrhhnvghlrdhorhhgsehfrghsthhmrghilhdrtghomhdpnhgspghrtghpthhtohepudeg
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegsvghnjhgrmhhinhdrtghhvggrth
    hhrghmsegrmhgurdgtohhmpdhrtghpthhtohepshhmihhtrgdrkhhorhgrlhgrhhgrlhhl
    ihgthhgrnhhnrggsrghsrghpphgrsegrmhgurdgtohhmpdhrtghpthhtohepthhomhgrsh
    iirdifohhlshhkihesfhhujhhithhsuhdrtghomhdprhgtphhtthhopehjohhnrghthhgr
    nhdrtggrmhgvrhhonheshhhurgifvghirdgtohhmpdhrtghpthhtoheprghlihhsohhnrd
    hstghhohhfihgvlhgusehinhhtvghlrdgtohhmpdhrtghpthhtohepuggrnhdrjhdrfihi
    lhhlihgrmhhssehinhhtvghlrdgtohhmpdhrtghpthhtohepuggrvhgvrdhjihgrnhhgse
    hinhhtvghlrdgtohhmpdhrtghpthhtoheprghruggssehkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehnvhguihhmmheslhhishhtshdrlhhinhhugidruggvvh
X-ME-Proxy: <xmx:7jANakhaQIct7-HcyDQh8Uys7wpXa4e7QFzi4zl6DeyKCBJ-bmeG2A>
    <xmx:7jANasdESi0dWC1NCP28lLBSKgUX_GtnbBZAOSfMx-slJWtoeyob7Q>
    <xmx:7jANatIXCZBblrz8LlnkrOwQ6a-nq_tzhE7gzrH2cBpeXFRjo7a8Nw>
    <xmx:7jANaplDiMSFS8x-QBz0m3L-tG-9XWYTw3KXvWpQ88susceytl1ibg>
    <xmx:7jANaleur3pSS5wx0W7GXKSDYWCwv4zBOLV7VZDQlkebo4W8TlDyGTgd>
Feedback-ID: i67ae4b3e:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 9341A2CC0083; Tue, 19 May 2026 23:56:30 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Tue, 19 May 2026 20:56:11 -0700
From: "Dan Williams" <djbw@kernel.org>
To: "Tomasz Wolski" <tomasz.wolski@fujitsu.com>,
 smita.koralahallichannabasappa@amd.com,
 "Alison Schofield" <alison.schofield@intel.com>,
 "Dan J Williams" <dan.j.williams@intel.com>
Cc: icheng@nvidia.com, linux-cxl@vger.kernel.org,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
 nvdimm@lists.linux.dev, ardb@kernel.org, benjamin.cheatham@amd.com,
 "Dave Jiang" <dave.jiang@intel.com>,
 "Jonathan Cameron" <jonathan.cameron@huawei.com>
Message-Id: <ec26d3de-d556-4ab9-a333-d69d1e6cdda7@app.fastmail.com>
In-Reply-To: <20260519101832.31988-1-tomasz.wolski@fujitsu.com>
References: <20260519101832.31988-1-tomasz.wolski@fujitsu.com>
Subject: Re: [PATCH v2] dax/bus: Upgrade resource conflict message to dev_err() in
 alloc_dax_region()
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On Tue, May 19, 2026, at 3:18 AM, Tomasz Wolski wrote:
> The dax_region resource conflict in alloc_dax_region() indicates a
> serious configuration problem =E2=80=94 two subsystems (e.g. dax_hmem =
and
> dax_cxl) are attempting to register overlapping address ranges. This is
> not a transient or debug-level condition; it represents a genuine
> resource conflict that an administrator needs to be aware of.
>
> Switch from request_resource() + dev_dbg() to
> request_resource_conflict() + dev_err() so that the conflict is visible
> by default and the colliding resource is identified in the message.
>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Link:=20
> https://lore.kernel.org/linux-cxl/69c1a8d1c0fa9_7ee3100a1@dwillia2-mob=
l4.notmuch/
> Signed-off-by: Tomasz Wolski <tomasz.wolski@fujitsu.com>
> ---
>  drivers/dax/bus.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 68437c05e21d..66413c6c2ba0 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -637,7 +637,7 @@ struct dax_region *alloc_dax_region(struct device=20
> *parent, int region_id,
>  		unsigned long flags)
>  {
>  	struct dax_region *dax_region;
> -	int rc;
> +	struct resource *conflict;
>=20
>  	/*
>  	 * The DAX core assumes that it can store its private data in
> @@ -670,10 +670,11 @@ struct dax_region *alloc_dax_region(struct devic=
e=20
> *parent, int region_id,
>  		.flags =3D IORESOURCE_MEM | flags,
>  	};
>=20
> -	rc =3D request_resource(&dax_regions, &dax_region->res);
> -	if (rc) {
> -		dev_dbg(parent, "dax_region resource conflict for %pR\n",
> -			&dax_region->res);
> +	conflict =3D request_resource_conflict(&dax_regions, &dax_region->re=
s);

Just report the request_resource() failure. This case does not warrant e=
xporting request_resource _conflict(). Historically one driver can not m=
ess with another driver's resource beyond conflict detection.
