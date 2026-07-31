Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AC931B823;
	Fri, 31 Jul 2026 09:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785488571; cv=none; b=azFnHKOfhiG6qQVJzV30Q0g5zBQGxtOU+VADme+9dJqAFr7KWGdWH+6jEYJej5XlYTWKb7n9O6H3WjGMLv/Uzv9cX+BA3n6J7/B0qepozO8we57yV7QntTsYI2x6MSknJdCdjF4QAo3SddFMFQEeWkcKmPDDfPfB2t6/8Mkhsx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785488571; c=relaxed/simple;
	bh=P14bfGxoPWHl1rAdz1lnxCQeMeF1pZ4FnpVUjDGMzMQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LQ8mMfVzgLz1j3Q2t+wdK6V71C6XuoKciO9aoiDuBdUWYsnCn50Vb3ep0aSWSbb5N06pEJ0iDrPOF+OBnp37HkYdw54cO9OIGZqdtLI67Eu0nN8fHlfPpreCex8n64xG0tHOAhenAGYGrcgZmxaoFBSc4s3W7QN3GDpqFFyWCco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WhpWPsrl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WhpWPsrl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8DE1F000E9;
	Fri, 31 Jul 2026 09:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785488570;
	bh=rcuTaSngrhRo5JoSt23fJ5BPj3sihfw5XRO4Bo6ueN0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WhpWPsrlbEJnWFivUUj2KsvdCHDFGTmfxOtKXq7ntpeEGSTRqJ55WCiodfBZehDtb
	 w2YPvZwoy4/ZfvQ02nV33xMcmsne/7tMm9fWFUwcGJqyhcZf+z4aeoiWYtOJ4ZK8JF
	 5qDVISzrVECKgha5753ovG2qijFdsHfwt2TWZ6y7s5YsFVefs/rb8sjxdUkizaPs0w
	 jfnqOejwt3Ui1IQEbdwqesgYyPu16CC5PYflA57584lDTFFGTX+LhHBtGJgJrkOkWl
	 inBdKQZodOSQ4mzMEJT9AWjQLYQ3PYjH+1U2SA5/N7SNiOfryMFaqPcsm5mXVOtYq/
	 dvPpoxDp4luKw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 3/8] cxl/cdat: Gather DSMAS data for DCD partitions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260731084901.1512819-4-anisa.su@samsung.com>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-4-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 09:02:49 +0000
Message-Id: <20260731090250.0C8DE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] The commit message claims to extract and store the 'read only' a=
ttribute from DSMAS tables, but this logic is completely missing from the c=
ode.
- [Medium] Spurious `dev_warn` on valid overlapping CDAT DSMAS entries for =
DCD partitions.
--

--- Patch [3]: [PATCH v12 3/8] cxl/cdat: Gather DSMAS data for DCD partitio=
ns ---
commit 2a6d0666da69329a29cf2ac94ee05e10012974cc
Author: Ira Weiny <iweiny@kernel.org>

cxl/cdat: Gather DSMAS data for DCD partitions

This commit extracts additional DCD partition information from DSMAS CDAT
tables. It matches DCD partitions with DSMAS tables to store performance
and shareable attributes.

>     cxl/cdat: Gather DSMAS data for DCD partitions
>    =20
>     Additional DCD partition (AKA region) information is contained in the
>     DSMAS CDAT tables, including performance, read only, and shareable
>     attributes.

[Severity: Medium]
The commit message states that the read only attribute is being extracted,
but I am not seeing the logic for it in the patch below.

> diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
> index 5c9f072625135..37136b2cf7e48 100644
> --- a/drivers/cxl/core/cdat.c
> +++ b/drivers/cxl/core/cdat.c
[ ... ]
> @@ -74,6 +75,7 @@ static int cdat_dsmas_handler(union acpi_subtable_heade=
rs *header, void *arg,
>  		return -ENOMEM;
> =20
>  	dent->handle =3D dsmas->dsmad_handle;
> +	dent->shareable =3D dsmas->flags & ACPI_CDAT_DSMAS_SHAREABLE;

[Severity: Medium]
Is the parsing for ACPI_CDAT_DSMAS_READ_ONLY missing from cdat_dsmas_handle=
r()?
The code only appears to extract the shareable flag.

[ ... ]
> @@ -266,15 +268,26 @@ static void cxl_memdev_set_qos_class(struct cxl_dev=
_state *cxlds,
>  		bool found =3D false;
> =20
>  		for (int i =3D 0; i < cxlds->nr_partitions; i++) {
> +			enum cxl_partition_mode mode =3D cxlds->part[i].mode;
>  			struct resource *res =3D &cxlds->part[i].res;
> +			u8 handle =3D cxlds->part[i].handle;
>  			struct range range =3D {
>  				.start =3D res->start,
>  				.end =3D res->end,
>  			};
> =20
>  			if (range_contains(&range, &dent->dpa_range)) {
> +				if (mode =3D=3D CXL_PARTMODE_DYNAMIC_RAM_1 &&
> +				    dent->handle !=3D handle) {
> +					dev_warn(dev,
> +						 "Dynamic RAM perf mismatch; %pra (%u) vs %pra (%u)\n",
> +						 &range, handle, &dent->dpa_range,
> +						 dent->handle);
> +					continue;
> +				}

[Severity: Medium]
Could this trigger spurious warnings on valid hardware configurations?

The CDAT specification allows overlapping DSMAS ranges with different handl=
es
to support multiple memory types or sharing characteristics for the same DPA
space.=20

If a compliant device provides multiple valid DSMAS entries that overlap
the partition's range but have different handles, won't iterating over them=
=20
incorrectly flag the unselected ones as a perf mismatch?

[ ... ]
> diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
> index 87c2bd73df21d..baf0132c70a34 100644
> --- a/include/cxl/cxl.h
> +++ b/include/cxl/cxl.h
> @@ -141,11 +141,15 @@ enum cxl_partition_mode {
>   * @res: shortcut to the partition in the DPA resource tree (cxlds->dpa_=
res)
>   * @perf: performance attributes of the partition from CDAT
>   * @mode: operation mode for the DPA capacity, e.g. ram, pmem, dynamic...
> + * @handle: DSMAS handle intended to represent this partition
> + * @shareable: Is the partition sharable (from its CDAT DSMAS entry)
>   */
>  struct cxl_dpa_partition {
>  	struct resource res;
>  	struct cxl_dpa_perf perf;
>  	enum cxl_partition_mode mode;
> +	u8 handle;
> +	bool shareable;
>  };

[Severity: Medium]
Does struct cxl_dpa_partition also need a read_only boolean field added here
to match the commit message description?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731084901.1512=
819-1-anisa.su@samsung.com?part=3D3
