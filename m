Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D057220D4FC;
	Wed,  7 Oct 2026 20:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791405194; cv=none; b=CYwqKCxI561Jn1w1n1GeehyvF0eowV/bakBnLnzte5Aaj3rCcJfRV5xCO8qKDzXFG9quQderDhGnArEenqc+gnqmf0yupceLQNK33gOEB8TuwNP/KNEVTFjanw8NYJnC24ReARlCiJmaZNQv6EAC5xLT/xqQT9LLiDqjCSRvA+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791405194; c=relaxed/simple;
	bh=MhIu2NOoSkfEFCjY3hTzYBQbJJbbFlHDS6dbbeF4ug4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=OhcErjQ/poQlfvcnFV4p2vbP70IeZ5uV6Qh1jqQbOV+QoLaxUfMePx3PIo+zl45NPFAjgSj3NIY8CeaIakMqGzZtqCxN4e/Gc09y58lxq+hvhSSXHopiBZZA1qVxgdaQGd0aXFc+U2Evc6MA5fyr7Qi+wzwx3ur1f/gI0KGEWME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=awS3NHLv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="awS3NHLv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485D01F000FF;
	Wed,  7 Oct 2026 20:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791405193;
	bh=Xw2sLl6i+LCz86hbvB72yFfcT9GOKnoFoTIqZ3vjGe4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=awS3NHLvM/cC/g25HIWwuEEkbnEztZAWFb+6SBKvwhkIp24dk/m5Mnj4Av8VSSZ2K
	 lfSYBfKdWRKU19A331sDQZZbMDmD1szLa1fMHd/tuOJcyVsad6ohJEeeNLs51DP00T
	 QuhoGE+jnt1ovq+Y3gkaC3lmA0LBw0wAnc+iNeZrgwDWIyPJLzVzyoXD/m77339mz5
	 aSrtydSzztCcZbvppyUhtBW+hJm7JaANyhuOs5a4QkjCjhVFxhbMKbu6m5Jgasc6Eb
	 J8be4pypD60llvLEZjPRJx4lVxX1XmstFVN5+hEFnnLOp/jeIegjc2SrpRIfT/hjJ1
	 z5hYa29SkwmQQ==
Message-ID: <sashiko-outbox-163342@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v15 3/8] cxl/cdat: Gather DSMAS data for DCD partitions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20261007201828.952-4-anisa.su@samsung.com>
References: <20261007201828.952-1-anisa.su@samsung.com>
 <20261007201828.952-4-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 20:33:12 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] cxl: Ineffective DCD disablement leaves partially configured parti=
tions exposed
- [Medium] cxl: QoS class 0 incorrectly overwrites CXL_QOS_CLASS_INVALID
- [Low] cxl: Lockless modification of DPA partition attributes exposes torn=
 reads
--

commit 6722908eab4fa5c8dd9820d34f1ec3beb729c8f0
Author: Ira Weiny <iweiny@kernel.org>

cxl/cdat: Gather DSMAS data for DCD partitions

Additional DCD partition (AKA region) information is contained in the
DSMAS CDAT tables, including performance, shareable and read-only
attributes. Match DCD partitions with DSMAS tables and store the meta
data.

> diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
> index 5c9f072625135..07aedff657d9e 100644
> --- a/drivers/cxl/core/cdat.c
> +++ b/drivers/cxl/core/cdat.c
[ ... ]
> @@ -219,6 +226,13 @@ static int cxl_port_perf_data_calculate(struct cxl_p=
ort *port,
>  	xa_for_each(dsmas_xa, index, dent) {
>  		int qos_class;
> =20
> +		/* No DSLBIS for this DSMAS; nothing to hand the QTG _DSM */
> +		if (!dent->cdat_coord[ACCESS_COORDINATE_CPU].read_bandwidth &&
> +		    !dent->cdat_coord[ACCESS_COORDINATE_CPU].write_bandwidth &&
> +		    !dent->cdat_coord[ACCESS_COORDINATE_CPU].read_latency &&
> +		    !dent->cdat_coord[ACCESS_COORDINATE_CPU].write_latency)
> +			continue;

[Severity: Medium]
When this continue statement is taken, dent->qos_class remains 0 (from
kzalloc_obj zero-initialization).

If at least one other entry succeeds, cxl_memdev_apply_dsmas() will be call=
ed
with CXL_DSMAS_APPLY_FLAGS_PERF, which unconditionally calls update_perf_en=
try()
and overwrites part->perf.qos_class (previously CXL_QOS_CLASS_INVALID) with=
 0.

Since 0 is a valid QoS class in CXL, does this falsely advertise a QoS clas=
s of
0 to userspace for partitions lacking DSLBIS performance coordinates?

> +
>  		cxl_coordinates_combine(dent->coord, dent->cdat_coord, ep_c);
>  		dent->entries =3D 1;
>  		rc =3D cxl_root->ops.qos_class(cxl_root,
[ ... ]
> @@ -255,35 +269,90 @@ static void update_perf_entry(struct device *dev, s=
truct dsmas_entry *dent,
>  		dent->coord[ACCESS_COORDINATE_CPU].write_latency);
>  }
> =20
> -static void cxl_memdev_set_qos_class(struct cxl_dev_state *cxlds,
> -				     struct xarray *dsmas_xa)
> +/*
> + * A DCD shall describe its DC partition in a DSMAS entry (CXL r4.0 9.13=
.3).
> + * Without one the partition's attributes are unknown, so disable DCD.
> + */
> +static void cxl_dcd_dsmas_missing(struct cxl_dev_state *cxlds, const cha=
r *why)
> +{
> +	struct cxl_memdev_state *mds;
> +
> +	if (cxlds->type !=3D CXL_DEVTYPE_CLASSMEM)
> +		return;
> +
> +	mds =3D to_cxl_memdev_state(cxlds);
> +	if (!cxl_dcd_supported(mds) ||
> +	    !cxl_part_size(cxlds, CXL_PARTMODE_DYNAMIC_RAM))
> +		return;
> +
> +	dev_warn(cxlds->dev, "DC partition has no valid DSMAS entry (%s), disab=
ling DCD\n",
> +		 why);
> +	cxl_disable_dcd(mds);

[Severity: High]
Does clearing the mds->dcd_supported flag effectively disable the partition?

Since cxl_configure_dcd() and cxl_dpa_setup() have already executed during
cxl_pci_probe(), the DCD partition is permanently added to cxlds->part and =
its
DPA resource is registered.

Because mds->dcd_supported is never evaluated again during region creation =
or
sysfs access, does the partition remain fully exposed and usable by userspa=
ce
without valid DSMAS attributes?

> +}
> +
> +enum cxl_dsmas_apply {
> +	CXL_DSMAS_APPLY_FLAGS,		/* shareable etc.; no QTG data */
> +	CXL_DSMAS_APPLY_FLAGS_PERF,	/* perf coordinates and qos_class */
> +};
> +
> +/*
> + * DSMAS flags such as shareable are properties of the CDAT entry and are
> + * applied regardless; perf data is applied only if the QTG lookup produ=
ced
> + * recommendations.
> + */
> +static void cxl_memdev_apply_dsmas(struct cxl_dev_state *cxlds,
> +				   struct xarray *dsmas_xa,
> +				   enum cxl_dsmas_apply attrs)
>  {
>  	struct device *dev =3D cxlds->dev;
>  	struct dsmas_entry *dent;
> +	bool dc_matched =3D false;
>  	unsigned long index;
> =20
>  	xa_for_each(dsmas_xa, index, dent) {
>  		bool found =3D false;
> =20
>  		for (int i =3D 0; i < cxlds->nr_partitions; i++) {
> -			struct resource *res =3D &cxlds->part[i].res;
> +			struct cxl_dpa_partition *part =3D &cxlds->part[i];
[ ... ]
> +			if (attrs =3D=3D CXL_DSMAS_APPLY_FLAGS_PERF)
> +				update_perf_entry(dev, dent, &part->perf);
> +			if (part->mode =3D=3D CXL_PARTMODE_DYNAMIC_RAM) {
> +				part->shareable =3D dent->shareable;
> +				part->read_only =3D dent->read_only;
> +				dc_matched =3D true;
> +			}

[Severity: Low]
Are these partition attributes being modified locklessly?

The CXL memdev and its sysfs attributes are registered and visible during
cxl_pci_probe(), while this CDAT parsing happens later in
cxl_endpoint_port_probe().

If part->perf, part->shareable, and part->read_only are updated without hol=
ding
the cxl_rwsem.dpa lock, can concurrent userspace sysfs readers observe
intermediate, torn, or partially updated performance states?

> +			break;
>  		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007201828.952-=
1-anisa.su@samsung.com?part=3D3
