Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74551624
	for <nvdimm@lists.linux.dev>; Fri, 10 Feb 2023 01:18:41 +0000 (UTC)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
	by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20230210011840usoutp0245a11ef3cc8fbf5fdea32ffbbf5c68a7~CUcWDzCQI0769607696usoutp02x;
	Fri, 10 Feb 2023 01:18:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20230210011840usoutp0245a11ef3cc8fbf5fdea32ffbbf5c68a7~CUcWDzCQI0769607696usoutp02x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1675991920;
	bh=Rfbudv6MX4HIJ8dwSDFqw3cXUo/qZEYPj9Ejhb4vGaU=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=ZddwlYhooYe+qTtXjld+0zqz0/MXNpXzuo++MEtkm88DHtbTwEm+T/hXgXagEu5VA
	 Hhk69qHOM4zZlCQxDGzMLweTMx/n/ztDfC9+n9Ni6VLMuoPY1AnenpcmLWOn8hhfRw
	 P8o8CMyGCwAqwNNaGVOZ+tbZzL508/4kO9T4iKd8=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
	[203.254.195.112]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20230210011839uscas1p1e98bb0bec5119c1fd08cee1076f8d584~CUcVryEBB3271632716uscas1p1D;
	Fri, 10 Feb 2023 01:18:39 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
	ussmges3new.samsung.com (USCPEMTA) with SMTP id 14.A7.12196.F6B95E36; Thu, 
	9 Feb 2023 20:18:39 -0500 (EST)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
	[203.254.195.89]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20230210011839uscas1p12745db04893bf5394fa54b0338d75884~CUcVT8zLi0032300323uscas1p16;
	Fri, 10 Feb 2023 01:18:39 +0000 (GMT)
X-AuditID: cbfec370-83dfe70000012fa4-18-63e59b6f7e55
Received: from SSI-EX1.ssi.samsung.com ( [105.128.2.146]) by
	ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id D7.F0.11378.E6B95E36; Thu, 
	9 Feb 2023 20:18:39 -0500 (EST)
Received: from SSI-EX2.ssi.samsung.com (105.128.2.227) by
	SSI-EX1.ssi.samsung.com (105.128.2.226) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.1.2375.24; Thu, 9 Feb 2023 17:18:38 -0800
Received: from SSI-EX2.ssi.samsung.com ([105.128.2.227]) by
	SSI-EX2.ssi.samsung.com ([105.128.2.227]) with mapi id 15.01.2375.024; Thu,
	9 Feb 2023 17:18:38 -0800
From: Fan Ni <fan.ni@samsung.com>
To: Vishal Verma <vishal.l.verma@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, Gregory Price
	<gregory.price@memverge.com>, Jonathan Cameron
	<Jonathan.Cameron@Huawei.com>, Davidlohr Bueso <dave@stgolabs.net>, Dan
	Williams <dan.j.williams@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl v2 3/7] cxl: add core plumbing for creation of ram
 regions
Thread-Topic: [PATCH ndctl v2 3/7] cxl: add core plumbing for creation of
	ram regions
Thread-Index: AQHZPO2aXfycu09640S2/c7YP0dGew==
Date: Fri, 10 Feb 2023 01:18:38 +0000
Message-ID: <20230210011831.GA902178@bgt-140510-bm03>
In-Reply-To: <20230120-vv-volatile-regions-v2-3-4ea6253000e5@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <92FE9F7DA228F143B51C756D57598E58@ssi.samsung.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTcRTH+917t90trNs0PSlFjYJwttQeLHRLeqwFRRZUkoGuedOhTtk0
	s5Ikipa9tLJwZm49ZtpGZGlmOsyF+SKlh+ajl6mltWqFTitczZuw/z6/c77n/D4/+JE438Ly
	J1XqNFqjViQJ2DyismHk6ZKUwgFl8OhvgfhSfjsS3+oyI3H2kT5CXGbsYIvb9M2EuHTsD0vc
	nduARXDkRx/bWfJrNUOY/NPdAiS/43Bx5PmFh+U/y+dFsnfxwuPoJNU+WrNUGstLOFM0QaT2
	hu4/ftaFZ6Mvi3MQlwRqOUxU5GE5iEfyqVIEte9ciDkcwyDXVoKmUvZvRzlMw4Kgp0uHMwcH
	giu2i7g7xaduIBh+I3czm1oA1pz7bDf7UELINX1nuQdwyoBB8Q/Hv7Uk6U3tAHNBJJPZCUbD
	E8SwCJoG6yaZoBbB6J2ByT1e1AqoHhnH3KNcagM8+LbEXUaULzibzZibccoPuvuLMUZ6Flwt
	rMEZ9oWJ6vdshhfAW+cQh8kHgeHhDzbDUqjLyyMYFoLJ+Blnrp0FTQX9BDM7Bx7dfEW4nwJU
	PwnnqnsmfYBaB0VjiUwmAF525uNMWQllDh5TToLi6/f+rwkD45/bWC5aqPew1nsY6T2M9B5G
	eg8jA2KVIb90rTY5ntYuU9MZIq0iWZuujhcpU5LL0b8f1TJhS61C3d0OUT3CSFSPgMQFPl7O
	vA9KvlecIvMArUmJ0aQn0dp6FEASAj+vEEmTkk/FK9LoRJpOpTVTXYzk+mdjisJFfTObwiKP
	Z5w52aeepxvqEa0ajCjgDgnTzMp97bt2X7Gt2yMxS6OtAkvWtcutjhdkVpXKVFIrebZ+Rp0r
	e7ilTWhpOC99LhMEqRTFrPC1nBuVLaf2EqMj0tKPXw14VOv4oTV01uoL2w0V27mr2qMeftdN
	n+6S1Q+Epc99zd7aoY62ZWZs+Xh+tKZflrh6fsmJIgMWbO/9FfhV0iiUUh9MzsHGUy+DY2tV
	Z5+Gyw7tKT18cKNxWsoFfflBb2fnmo2/rLqFdhnhN15plTs3h9vf6Rpvt88e48SFSIY7Qhs2
	Z7aNB2xz0ZsER3w7d5sCQ7ui/HstJdaYaHH0ytMDAkKboAgJxDVaxV/l4ZBZwAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWS2cA0STd/9tNkg/UfOS2mT73AaLH65hpG
	i4amRywWqxZeY7M4P+sUi8XKH39YLW5NOMbkwO7RcuQtq8fiPS+ZPF5snsnosfHjf3aPqbPr
	PT5vkgtgi+KySUnNySxLLdK3S+DK6Jv7j6XgjlFFe/9/5gbGNxpdjJwcEgImEm/ft7B3MXJx
	CAmsZpSY/v4QI4TzkVHixdKnLCBVQgJLGSUO/RAEsdkEFCX2dW1nA7FFBLQlJiz7wArSwCww
	j0niwrlrQN0cHMICYRJrZgZA1IRLXFzRyARh60mcfHaAEcRmEVCV+LbxKdgcXgFTiV1ffzJB
	LG5mlHj8dw4ryBxOAXeJne91QWoYBcQkvp9aAzaHWUBc4taT+UwQHwhILNlznhnCFpV4+fgf
	K4StKHH/+0t2iHodiQW7P7FB2HYSByZOZIGwtSWWLXzNDHGDoMTJmU9YIHolJQ6uuMEygVFi
	FpJ1s5CMmoVk1Cwko2YhGbWAkXUVo3hpcXFuekWxYV5quV5xYm5xaV66XnJ+7iZGYIyf/nc4
	cgfj0Vsf9Q4xMnEwHmKU4GBWEuH9PvFxshBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFeIdeJ8UIC
	6YklqdmpqQWpRTBZJg5OqQYmhskH5j3nCYs8m+6f3FF1JnXZ0SfbOUMeXvnRms+u4v04xH9C
	ybby9+Vhc3p5Qv313LzK+Msn1ux1jp8QrLUzK/Jm/NH9chxLLFgXznDM92R58/yCwcZerwl7
	FDmfMjG288yYKaBckaYzWeXIigV9YiHMTKbXl34z2KH++1PemncPL1kdOP9U3jyn/U7B4yP7
	9/eFWWyv/vZKXuKx99lyRj0mF+Wtbze1rT+R0tdXwlPzurfrsJyX84othot9klamcBrmV7oo
	a8p9WOn8XPCyYMFihimJh5YfbFnY6Bi4uixM7wPH77BL/L8u/lww+fji14sCFc+VMxbpZ4kU
	fNX4lBoScF/1tsOTfdePHlmuxFKckWioxVxUnAgAHLHyDmADAAA=
X-CMS-MailID: 20230210011839uscas1p12745db04893bf5394fa54b0338d75884
CMS-TYPE: 301P
X-CMS-RootMailID: 20230210011839uscas1p12745db04893bf5394fa54b0338d75884
References: <20230120-vv-volatile-regions-v2-0-4ea6253000e5@intel.com>
	<20230120-vv-volatile-regions-v2-3-4ea6253000e5@intel.com>
	<CGME20230210011839uscas1p12745db04893bf5394fa54b0338d75884@uscas1p1.samsung.com>

On Wed, Feb 08, 2023 at 01:00:31PM -0700, Vishal Verma wrote:

> Add support in libcxl to create ram regions through a new
> cxl_decoder_create_ram_region() API, which works similarly to its pmem
> sibling.
>=20
> Enable ram region creation in cxl-cli, with the only differences from
> the pmem flow being:
>   1/ Use the above create_ram_region API, and
>   2/ Elide setting the UUID, since ram regions don't have one
>=20
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Fan Ni <fan.ni@samsung.com>

One minor thing, there exists some code format inconsistency in
cxl/region.c file (not introduced by the patch). For exmaple, the
"switch" sometimes is followed with a space but sometime not.


> ---
>  Documentation/cxl/cxl-create-region.txt |  3 ++-
>  cxl/lib/libcxl.c                        | 22 +++++++++++++++++++---
>  cxl/libcxl.h                            |  1 +
>  cxl/region.c                            | 28 ++++++++++++++++++++++++---=
-
>  cxl/lib/libcxl.sym                      |  1 +
>  5 files changed, 47 insertions(+), 8 deletions(-)
>=20
> diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/=
cxl-create-region.txt
> index 286779e..ada0e52 100644
> --- a/Documentation/cxl/cxl-create-region.txt
> +++ b/Documentation/cxl/cxl-create-region.txt
> @@ -80,7 +80,8 @@ include::bus-option.txt[]
>  -U::
>  --uuid=3D::
>  	Specify a UUID for the new region. This shouldn't usually need to be
> -	specified, as one will be generated by default.
> +	specified, as one will be generated by default. Only applicable to
> +	pmem regions.
> =20
>  -w::
>  --ways=3D::
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 83f628b..c5b9b18 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -2234,8 +2234,8 @@ cxl_decoder_get_region(struct cxl_decoder *decoder)
>  	return NULL;
>  }
> =20
> -CXL_EXPORT struct cxl_region *
> -cxl_decoder_create_pmem_region(struct cxl_decoder *decoder)
> +static struct cxl_region *cxl_decoder_create_region(struct cxl_decoder *=
decoder,
> +						    enum cxl_decoder_mode mode)
>  {
>  	struct cxl_ctx *ctx =3D cxl_decoder_get_ctx(decoder);
>  	char *path =3D decoder->dev_buf;
> @@ -2243,7 +2243,11 @@ cxl_decoder_create_pmem_region(struct cxl_decoder =
*decoder)
>  	struct cxl_region *region;
>  	int rc;
> =20
> -	sprintf(path, "%s/create_pmem_region", decoder->dev_path);
> +	if (mode =3D=3D CXL_DECODER_MODE_PMEM)
> +		sprintf(path, "%s/create_pmem_region", decoder->dev_path);
> +	else if (mode =3D=3D CXL_DECODER_MODE_RAM)
> +		sprintf(path, "%s/create_ram_region", decoder->dev_path);
> +
>  	rc =3D sysfs_read_attr(ctx, path, buf);
>  	if (rc < 0) {
>  		err(ctx, "failed to read new region name: %s\n",
> @@ -2282,6 +2286,18 @@ cxl_decoder_create_pmem_region(struct cxl_decoder =
*decoder)
>  	return region;
>  }
> =20
> +CXL_EXPORT struct cxl_region *
> +cxl_decoder_create_pmem_region(struct cxl_decoder *decoder)
> +{
> +	return cxl_decoder_create_region(decoder, CXL_DECODER_MODE_PMEM);
> +}
> +
> +CXL_EXPORT struct cxl_region *
> +cxl_decoder_create_ram_region(struct cxl_decoder *decoder)
> +{
> +	return cxl_decoder_create_region(decoder, CXL_DECODER_MODE_RAM);
> +}
> +
>  CXL_EXPORT int cxl_decoder_get_nr_targets(struct cxl_decoder *decoder)
>  {
>  	return decoder->nr_targets;
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index e6cca11..904156c 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -213,6 +213,7 @@ cxl_decoder_get_interleave_granularity(struct cxl_dec=
oder *decoder);
>  unsigned int cxl_decoder_get_interleave_ways(struct cxl_decoder *decoder=
);
>  struct cxl_region *cxl_decoder_get_region(struct cxl_decoder *decoder);
>  struct cxl_region *cxl_decoder_create_pmem_region(struct cxl_decoder *de=
coder);
> +struct cxl_region *cxl_decoder_create_ram_region(struct cxl_decoder *dec=
oder);
>  struct cxl_decoder *cxl_decoder_get_by_name(struct cxl_ctx *ctx,
>  					    const char *ident);
>  struct cxl_memdev *cxl_decoder_get_memdev(struct cxl_decoder *decoder);
> diff --git a/cxl/region.c b/cxl/region.c
> index 38aa142..c69cb9a 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -380,7 +380,18 @@ static void collect_minsize(struct cxl_ctx *ctx, str=
uct parsed_params *p)
>  		struct json_object *jobj =3D
>  			json_object_array_get_idx(p->memdevs, i);
>  		struct cxl_memdev *memdev =3D json_object_get_userdata(jobj);
> -		u64 size =3D cxl_memdev_get_pmem_size(memdev);
> +		u64 size =3D 0;
> +
> +		switch(p->mode) {
> +		case CXL_DECODER_MODE_RAM:
> +			size =3D cxl_memdev_get_ram_size(memdev);
> +			break;
> +		case CXL_DECODER_MODE_PMEM:
> +			size =3D cxl_memdev_get_pmem_size(memdev);
> +			break;
> +		default:
> +			/* Shouldn't ever get here */ ;
> +		}
> =20
>  		if (!p->ep_min_size)
>  			p->ep_min_size =3D size;
> @@ -589,8 +600,15 @@ static int create_region(struct cxl_ctx *ctx, int *c=
ount,
>  				param.root_decoder);
>  			return -ENXIO;
>  		}
> +	} else if (p->mode =3D=3D CXL_DECODER_MODE_RAM) {
> +		region =3D cxl_decoder_create_ram_region(p->root_decoder);
> +		if (!region) {
> +			log_err(&rl, "failed to create region under %s\n",
> +				param.root_decoder);
> +			return -ENXIO;
> +		}
>  	} else {
> -		log_err(&rl, "region type '%s' not supported yet\n",
> +		log_err(&rl, "region type '%s' is not supported\n",
>  			param.type);
>  		return -EOPNOTSUPP;
>  	}
> @@ -602,10 +620,12 @@ static int create_region(struct cxl_ctx *ctx, int *=
count,
>  		goto out;
>  	granularity =3D rc;
> =20
> -	uuid_generate(uuid);
>  	try(cxl_region, set_interleave_granularity, region, granularity);
>  	try(cxl_region, set_interleave_ways, region, p->ways);
> -	try(cxl_region, set_uuid, region, uuid);
> +	if (p->mode =3D=3D CXL_DECODER_MODE_PMEM) {
> +		uuid_generate(uuid);
> +		try(cxl_region, set_uuid, region, uuid);
> +	}
>  	try(cxl_region, set_size, region, size);
> =20
>  	for (i =3D 0; i < p->ways; i++) {
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index 9832d09..84f60ad 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -246,4 +246,5 @@ global:
>  LIBCXL_5 {
>  global:
>  	cxl_region_get_mode;
> +	cxl_decoder_create_ram_region;
>  } LIBCXL_4;
>=20
> --=20
> 2.39.1
>=20
> =
