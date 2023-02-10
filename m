Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112C9624
	for <nvdimm@lists.linux.dev>; Fri, 10 Feb 2023 01:04:16 +0000 (UTC)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
	by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20230210010415usoutp01b7d025530d62a69085735646c9e6219b~CUPxIfwOS2881828818usoutp01Z;
	Fri, 10 Feb 2023 01:04:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20230210010415usoutp01b7d025530d62a69085735646c9e6219b~CUPxIfwOS2881828818usoutp01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1675991055;
	bh=0EEQh5W2Bvjs4G7zvzoGd3VEHHVppgdIbvBei+EY+PI=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=cFunXDSav1Kfj9l0+1sDygf8el8C+F3rBdv4Z8VNPiAZj0+MejyVr6xhd4HxqweYx
	 I/aVAGjf+xByioI1BZ4TfM3QeGP1NHV2UX9AhRIMqFzGD8s0QPvmsKeEeplA4vbgXx
	 KOIan2k912pOlOjkAgF/pNaYiR6+25FwMpQZTFJs=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
	[203.254.195.112]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20230210010415uscas1p1096a85fbcd4d7552fd23df46288c01b2~CUPw7o1MQ3177231772uscas1p1B;
	Fri, 10 Feb 2023 01:04:15 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
	ussmges3new.samsung.com (USCPEMTA) with SMTP id D6.E6.12196.F0895E36; Thu, 
	9 Feb 2023 20:04:15 -0500 (EST)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
	[203.254.195.92]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20230210010415uscas1p1211243c08bc794b314f7b20bdad93267~CUPwlRDQJ2996429964uscas1p1L;
	Fri, 10 Feb 2023 01:04:15 +0000 (GMT)
X-AuditID: cbfec370-83dfe70000012fa4-8e-63e5980f4552
Received: from SSI-EX2.ssi.samsung.com ( [105.128.2.145]) by
	ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id 65.01.11346.E0895E36; Thu, 
	9 Feb 2023 20:04:15 -0500 (EST)
Received: from SSI-EX2.ssi.samsung.com (105.128.2.227) by
	SSI-EX2.ssi.samsung.com (105.128.2.227) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.1.2375.24; Thu, 9 Feb 2023 17:04:09 -0800
Received: from SSI-EX2.ssi.samsung.com ([105.128.2.227]) by
	SSI-EX2.ssi.samsung.com ([105.128.2.227]) with mapi id 15.01.2375.024; Thu,
	9 Feb 2023 17:04:09 -0800
From: Fan Ni <fan.ni@samsung.com>
To: Vishal Verma <vishal.l.verma@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, Gregory Price
	<gregory.price@memverge.com>, Jonathan Cameron
	<Jonathan.Cameron@Huawei.com>, Davidlohr Bueso <dave@stgolabs.net>, Dan
	Williams <dan.j.williams@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 3/7] cxl: add core plumbing for creation of ram
 regions
Thread-Topic: [PATCH ndctl 3/7] cxl: add core plumbing for creation of ram
	regions
Thread-Index: AQHZPOuUxRarl1GRc0+x0qZV9Jxmlw==
Date: Fri, 10 Feb 2023 01:04:09 +0000
Message-ID: <20230210010409.GB883957@bgt-140510-bm03>
In-Reply-To: <20230120-vv-volatile-regions-v1-3-b42b21ee8d0b@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7BE46873DDDD9B4C8AF59EEB9C39DE2B@ssi.samsung.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsWy7djX87r8M54mG9zslrCYPvUCo8Xqm2sY
	LRqaHrFYrFp4jc3i/KxTLBYrf/xhtbg14RiTA7tHy5G3rB6L97xk8nixeSajx8aP/9k9ps6u
	9/i8SS6ALYrLJiU1J7MstUjfLoEr4+vD46wFE4wrJk94wtzA2KbZxcjJISFgIjH1VQtbFyMX
	h5DASkaJWZuXsEM4rUwSZ1b9YIapenhmHzNEYi2jxPy7T1khnI+MEg/WPWCCcJYySlz69I0J
	pIVNQFFiX9d2NhBbREBbYsKyD2AdzAILmCTmf/rICJIQFgiW+DxxPiNEUYjEm/9P2SFsPYmO
	21fA4iwCqhJb77wEG8QrYCpxrfMZC4jNKeAuseHnJjCbUUBM4vupNWCLmQXEJW49mc8Ecbeg
	xKLZe6B+EJP4t+shG4StKHH/+0t2iHodiQW7PwHFOYBsO4m93xwhwtoSyxa+ZoZYKyhxcuYT
	FohWSYmDK25A2Q84JBZ2R0LYLhKtk59BrZWWmL7mMgvISAmBZIlVH7kgwjkS85dsgWq1llj4
	Zz3TBEaVWUiOnoXkoFkIB81CctAsJActYGRdxSheWlycm55abJyXWq5XnJhbXJqXrpecn7uJ
	EZikTv87XLCD8datj3qHGJk4GA8xSnAwK4nwfp/4OFmINyWxsiq1KD++qDQntfgQozQHi5I4
	r6HtyWQhgfTEktTs1NSC1CKYLBMHp1QDU+PKI0Uv6iz8Pq2ocNvGxPLazE84cMtdjY+TE46e
	F2i6WVCy7aXnXbOy4qi4/XtMTuUe4g6YuqK3xV2Lxe31acv4k6LaTzZNMeT1E9fV+P0ickvG
	3f3pnCfV1rWqTF+Z3uRq9k2f+/Pizeu+NEsIfGP7dUFSpMbuWd/S95MLbSye3Wa3PH5z465K
	J0ONdaEv1b5rS3sLfBdh3dlfque+wMZ+Bu/5kADB+YraP7vPLH2saGEplT81dVaYfHnYWbu+
	tY/M9mY3OvwxkVS4du7a3YVvDgS7Kh1xr69d78PKLqt/s+zhhQm6QVHMnE9OqAr26eXdvLNq
	+q6F5uzZcqUcj9+sCLtz5kBHjWGX/ecgJZbijERDLeai4kQABZtB+cEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWS2cA0UZd/xtNkg+k/WC2mT73AaLH65hpG
	i4amRywWqxZeY7M4P+sUi8XKH39YLW5NOMbkwO7RcuQtq8fiPS+ZPF5snsnosfHjf3aPqbPr
	PT5vkgtgi+KySUnNySxLLdK3S+DK+PrwOGvBBOOKyROeMDcwtml2MXJySAiYSDw8s4+5i5GL
	Q0hgNaPEok8zWSCcj4wSbXPesUE4Sxklmm7dYgRpYRNQlNjXtZ0NxBYR0JaYsOwDK0gRs8A8
	JokL566BFQkLBEt8njgfyOYAKgqR2PbfCKJeT6Lj9hWwEhYBVYmtd16CzeEVMJW41vkManMz
	o8TGzodgCU4Bd4kNPzexgNiMAmIS30+tYQKxmQXEJW49mc8E8YOAxJI955khbFGJl4//sULY
	ihL3v79kh6jXkViw+xMbyD3MAnYSe785QoS1JZYtfM0McYOgxMmZT1ggWiUlDq64wTKBUWIW
	km2zkEyahTBpFpJJs5BMWsDIuopRvLS4ODe9otg4L7Vcrzgxt7g0L10vOT93EyMwxk//Oxyz
	g/HerY96hxiZOBgPMUpwMCuJ8H6f+DhZiDclsbIqtSg/vqg0J7X4EKM0B4uSOK9H7MR4IYH0
	xJLU7NTUgtQimCwTB6dUA5O5S9LbF2cSi3qYikNa2LVM1jAKcQa8XsB3WDRAji8zteNg1D2Z
	rj8HNtgnui7K3ZmwdmN/36e877IOrSVp4oda2MpVnoeqL9yTEBPpz3ufPWJD073q2VPZTBbv
	eDpXLn9X/5dG63nTpNS89E5Jt3f933ja+M2BWR9/O77QFXy2Oi3ml5Rrw2238v9KG/9Etq/S
	uRWT72Zb3v0gb1rn/lSDmJuXP/m81WO6+j7uz85M12ef+/LNOq+GuDHqvdwWsKwubNXH6rUq
	pyuNQ6LMe28Vu3rM/CWw6LTp9V+l94If2VlM55Ur8RLdIJP/Z4tvlJ+ydhzfzdxPgV7cP4qu
	HWh+xRihe2TNzJLOdQGRSizFGYmGWsxFxYkAbEgRoGADAAA=
X-CMS-MailID: 20230210010415uscas1p1211243c08bc794b314f7b20bdad93267
CMS-TYPE: 301P
X-CMS-RootMailID: 20230210010415uscas1p1211243c08bc794b314f7b20bdad93267
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
	<20230120-vv-volatile-regions-v1-3-b42b21ee8d0b@intel.com>
	<CGME20230210010415uscas1p1211243c08bc794b314f7b20bdad93267@uscas1p1.samsung.com>

On Tue, Feb 07, 2023 at 12:16:29PM -0700, Vishal Verma wrote:
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
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Fan Ni <fan.ni@samsung.com>

One minor thing, there exists some code format inconsistency in
cxl/region.c file (not introduced by the patch). For exmaple,
the "switch" sometimes is followed with a space but sometime not.

> ---
>  Documentation/cxl/cxl-create-region.txt |  3 ++-
>  cxl/lib/libcxl.c                        | 22 +++++++++++++++++++---
>  cxl/libcxl.h                            |  1 +
>  cxl/region.c                            | 32 +++++++++++++++++++++++++++=
+----
>  cxl/lib/libcxl.sym                      |  1 +
>  5 files changed, 51 insertions(+), 8 deletions(-)
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
> index 38aa142..0945a14 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -380,7 +380,22 @@ static void collect_minsize(struct cxl_ctx *ctx, str=
uct parsed_params *p)
>  		struct json_object *jobj =3D
>  			json_object_array_get_idx(p->memdevs, i);
>  		struct cxl_memdev *memdev =3D json_object_get_userdata(jobj);
> -		u64 size =3D cxl_memdev_get_pmem_size(memdev);
> +		u64 size;
> +
> +		switch(p->mode) {
> +		case CXL_DECODER_MODE_RAM:
> +			size =3D cxl_memdev_get_ram_size(memdev);
> +			break;
> +		case CXL_DECODER_MODE_PMEM:
> +			size =3D cxl_memdev_get_pmem_size(memdev);
> +			break;
> +		default:
> +			/*
> +			 * This will 'poison' ep_min_size with a 0, and
> +			 * subsequently cause the region creation to fail.
> +			 */
> +			size =3D 0;
> +		}
> =20
>  		if (!p->ep_min_size)
>  			p->ep_min_size =3D size;
> @@ -589,8 +604,15 @@ static int create_region(struct cxl_ctx *ctx, int *c=
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
> @@ -602,10 +624,12 @@ static int create_region(struct cxl_ctx *ctx, int *=
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
