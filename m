Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37211624
	for <nvdimm@lists.linux.dev>; Fri, 10 Feb 2023 00:48:08 +0000 (UTC)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
	by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20230210004800usoutp013e0fbed2ead7679c0d7349e3957cfc78~CUBlLM1Ds1883818838usoutp01p;
	Fri, 10 Feb 2023 00:48:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20230210004800usoutp013e0fbed2ead7679c0d7349e3957cfc78~CUBlLM1Ds1883818838usoutp01p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1675990080;
	bh=Mt5Xpnv9VP1UGo5HGLzB0EqMKVyiGbFxTRZgxxhYt04=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=rOL23rd+NeAG+tSjR5ij1gTPLmH2RP2TD85xb7n+37EE6dRZyIKq/Z0y4fr0XY1lC
	 gjNr6MWDzB9SGYqXgfYdJlcBloAtQ4dVsYmkO7kMDvnQnEaPb5yqtay5OeJQUVKBce
	 irtItCE6/R616gmWNruKLz2+uWbjHKBPn2MF2biM=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
	[203.254.195.109]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20230210004800uscas1p25b7e0c0ca7ea3712ae0237efd59189d0~CUBlDKJLR0481004810uscas1p21;
	Fri, 10 Feb 2023 00:48:00 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
	ussmges1new.samsung.com (USCPEMTA) with SMTP id 57.62.06976.04495E36; Thu, 
	9 Feb 2023 19:48:00 -0500 (EST)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
	[203.254.195.91]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20230210004800uscas1p1b66223937b4d5519341a61ef304e1a44~CUBklChAA1758017580uscas1p1b;
	Fri, 10 Feb 2023 00:48:00 +0000 (GMT)
X-AuditID: cbfec36d-d99ff70000011b40-f0-63e594403ee7
Received: from SSI-EX1.ssi.samsung.com ( [105.128.2.145]) by
	ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id 70.00.17110.F3495E36; Thu, 
	9 Feb 2023 19:48:00 -0500 (EST)
Received: from SSI-EX2.ssi.samsung.com (105.128.2.227) by
	SSI-EX1.ssi.samsung.com (105.128.2.226) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.1.2375.24; Thu, 9 Feb 2023 16:47:58 -0800
Received: from SSI-EX2.ssi.samsung.com ([105.128.2.227]) by
	SSI-EX2.ssi.samsung.com ([105.128.2.227]) with mapi id 15.01.2375.024; Thu,
	9 Feb 2023 16:47:58 -0800
From: Fan Ni <fan.ni@samsung.com>
To: Vishal Verma <vishal.l.verma@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, Gregory Price
	<gregory.price@memverge.com>, Jonathan Cameron
	<Jonathan.Cameron@Huawei.com>, Davidlohr Bueso <dave@stgolabs.net>, Dan
	Williams <dan.j.williams@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 2/7] cxl: add a type attribute to region listings
Thread-Topic: [PATCH ndctl 2/7] cxl: add a type attribute to region listings
Thread-Index: AQHZPOlRNlvbzTcc4Eiy6Y5XXc/N8Q==
Date: Fri, 10 Feb 2023 00:47:57 +0000
Message-ID: <20230210004738.GA883957@bgt-140510-bm03>
In-Reply-To: <20230120-vv-volatile-regions-v1-2-b42b21ee8d0b@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B78DF59F19B26A49BE47C1807B5BF688@ssi.samsung.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsWy7djX87oOU54mG3xo1rSYPvUCo8Xqm2sY
	LRqaHrFYrFp4jc3i/KxTLBYrf/xhtbg14RiTA7tHy5G3rB6L97xk8nixeSajx8aP/9k9ps6u
	9/i8SS6ALYrLJiU1J7MstUjfLoErY/vUt+wFXZoV0zfPY29gfKzYxcjJISFgInGx7xFLFyMX
	h5DASkaJ67M62CCcViaJfZd+M8JUXXjazgyRWMsocbV/JSuE85FRYsvL5UwQzlJGiTl7NrCB
	tLAJKErs69oOZosIaEtMWPYBrINZYAGTxPxPH8HmCgt4S3xcfZUJoshH4t7KbywQtp7Ewbc3
	wWpYBFQlWn7MBBvEK2Aq8XRiBzOIzSngLjF36UawXkYBMYnvp9aA2cwC4hK3nsxngrhbUGLR
	7D3MELaYxL9dD9kgbEWJ+99fskPU60gs2P2JDcK2k1i2uIcZwtaWWLbwNTPEXkGJkzOfsED0
	SkocXHEDHGISAnc4JPb9boAGkovEocn/oGxpib93lwEdwQFkJ0us+sgFEc6RmL9kC9Qca4mF
	f9YzTWBUmYXk7FlITpqF5KRZSE6aheSkBYysqxjFS4uLc9NTiw3zUsv1ihNzi0vz0vWS83M3
	MQJT1el/h3N3MO649VHvECMTB+MhRgkOZiUR3u8THycL8aYkVlalFuXHF5XmpBYfYpTmYFES
	5zW0PZksJJCeWJKanZpakFoEk2Xi4JRqYHLyvtpy81hnrtviBQccT+741KD2/maF4LPLFdWV
	i8sfnlm96NeJ+ZNqDn1clfc0YsvOaVeeNx6dPmf5Dd2fWuYxCyq6BQI/FBYu/bP6adO56SqX
	mxw2F/z7lPz92Oltt3WX28+a4O166krTDcm8AO3svR57Wxis5O7Ev3nFO+N83m4Hub+JJx+L
	3FJiSMvXSVRYw1VhYfv0x4HpHIJK049sj/VddybT4HXIscyHF35MyIz7uOjPwotmwv+FDSyU
	mqafKzQ2L371YvWnItmzRwI5So4+eH3v4O10wz0hy3in2Pt2Sn3P5HH7lVVkWft3h8k5mX1M
	x5OSPsjbu32pdClbY1VZwPayaP6E/WfKfpzNVmIpzkg01GIuKk4EAEd9vqXEAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsWS2cA0UddhytNkg4nfOS2mT73AaLH65hpG
	i4amRywWqxZeY7M4P+sUi8XKH39YLW5NOMbkwO7RcuQtq8fiPS+ZPF5snsnosfHjf3aPqbPr
	PT5vkgtgi+KySUnNySxLLdK3S+DK2D71LXtBl2bF9M3z2BsYHyt2MXJySAiYSFx42s4MYgsJ
	rGaU+DcruouRC8j+yCixYfkjJghnKaPEma2zwarYBBQl9nVtZwOxRQS0JSYs+8AKUsQsMI9J
	4sK5a4wgCWEBb4mPq68yQRT5SNxb+Y0FwtaTOPj2JlgNi4CqRMuPmWCDeAVMJZ5O7IA6o5lR
	4tSKSBCbU8BdYu7SjWBzGAXEJL6fWgNmMwuIS9x6Mp8J4gUBiSV7zjND2KISLx//Y4WwFSXu
	f3/JDlGvI7Fg9yc2CNtOYtniHmYIW1ti2cLXzBA3CEqcnPmEBaJXUuLgihssExglZiFZNwvJ
	qFlIRs1CMmoWklELGFlXMYqXFhfnplcUG+WllusVJ+YWl+al6yXn525iBEb56X+Ho3cw3r71
	Ue8QIxMH4yFGCQ5mJRHe7xMfJwvxpiRWVqUW5ccXleakFh9ilOZgURLnfRk1MV5IID2xJDU7
	NbUgtQgmy8TBKdXAZPg1V9Bd7krWvZwPkzocnLOVzX6EHt+VpeHy4WOoy7+K9bPm8cQHnfSf
	IW34RrGlqiTls7Dhqb98GQf59RINTK/KKfKl338l+ldD957/8dw5B8tNTjJKlpqXtsvPFFmQ
	/vaGsoT/cTtnU37LP9E5yQuXTenYeGF12Marm1aqPvB1u/qkepuzXfGD+X/v+jvnfJJas+eD
	ubiTwcQ/n/S/WuvF2c+KP8xzvexygOfNtMOddecmuDde//2kSOPUHZ1507ldZ00QMfjDIuYQ
	rr3VJKA39WhEQO+J172RUw9pcqWKBZr+81gXt92nTKW8wMRt5ay/IvIxz+2iK3a4fN/AdKoh
	Z99rnrW8EXGLz15TYinOSDTUYi4qTgQAJy4vbWEDAAA=
X-CMS-MailID: 20230210004800uscas1p1b66223937b4d5519341a61ef304e1a44
CMS-TYPE: 301P
X-CMS-RootMailID: 20230210004800uscas1p1b66223937b4d5519341a61ef304e1a44
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
	<20230120-vv-volatile-regions-v1-2-b42b21ee8d0b@intel.com>
	<CGME20230210004800uscas1p1b66223937b4d5519341a61ef304e1a44@uscas1p1.samsung.com>

On Tue, Feb 07, 2023 at 12:16:28PM -0700, Vishal Verma wrote:
> In preparation for enumerating and creating 'volatile' or 'ram' type
> regions, add a 'type' attribute to region listings, so these can be
> distinguished from 'pmem' type regions easily. This depends on a new
> 'mode' attribute for region objects in sysfs. For older kernels that
> lack this, region listings will simply omit emitting this attribute,
> but otherwise not treat it as a failure.
>=20
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Fan Ni <fan.ni@samsung.com>

> ---
>  Documentation/cxl/lib/libcxl.txt |  1 +
>  cxl/lib/private.h                |  1 +
>  cxl/lib/libcxl.c                 | 11 +++++++++++
>  cxl/libcxl.h                     |  1 +
>  cxl/json.c                       |  5 +++++
>  cxl/lib/libcxl.sym               |  5 +++++
>  6 files changed, 24 insertions(+)
>=20
> diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/lib=
cxl.txt
> index f9af376..dbc4b56 100644
> --- a/Documentation/cxl/lib/libcxl.txt
> +++ b/Documentation/cxl/lib/libcxl.txt
> @@ -550,6 +550,7 @@ int cxl_region_get_id(struct cxl_region *region);
>  const char *cxl_region_get_devname(struct cxl_region *region);
>  void cxl_region_get_uuid(struct cxl_region *region, uuid_t uu);
>  unsigned long long cxl_region_get_size(struct cxl_region *region);
> +enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region);
>  unsigned long long cxl_region_get_resource(struct cxl_region *region);
>  unsigned int cxl_region_get_interleave_ways(struct cxl_region *region);
>  unsigned int cxl_region_get_interleave_granularity(struct cxl_region *re=
gion);
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index f8871bd..306dc3a 100644
> --- a/cxl/lib/private.h
> +++ b/cxl/lib/private.h
> @@ -149,6 +149,7 @@ struct cxl_region {
>  	unsigned int interleave_ways;
>  	unsigned int interleave_granularity;
>  	enum cxl_decode_state decode_state;
> +	enum cxl_decoder_mode mode;
>  	struct kmod_module *module;
>  	struct list_head mappings;
>  };
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 4205a58..83f628b 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -561,6 +561,12 @@ static void *add_cxl_region(void *parent, int id, co=
nst char *cxlregion_base)
>  	else
>  		region->decode_state =3D strtoul(buf, NULL, 0);
> =20
> +	sprintf(path, "%s/mode", cxlregion_base);
> +	if (sysfs_read_attr(ctx, path, buf) < 0)
> +		region->mode =3D CXL_DECODER_MODE_NONE;
> +	else
> +		region->mode =3D cxl_decoder_mode_from_ident(buf);
> +
>  	sprintf(path, "%s/modalias", cxlregion_base);
>  	if (sysfs_read_attr(ctx, path, buf) =3D=3D 0)
>  		region->module =3D util_modalias_to_module(ctx, buf);
> @@ -686,6 +692,11 @@ CXL_EXPORT unsigned long long cxl_region_get_resourc=
e(struct cxl_region *region)
>  	return region->start;
>  }
> =20
> +CXL_EXPORT enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *=
region)
> +{
> +	return region->mode;
> +}
> +
>  CXL_EXPORT unsigned int
>  cxl_region_get_interleave_ways(struct cxl_region *region)
>  {
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index d699af8..e6cca11 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -273,6 +273,7 @@ const char *cxl_region_get_devname(struct cxl_region =
*region);
>  void cxl_region_get_uuid(struct cxl_region *region, uuid_t uu);
>  unsigned long long cxl_region_get_size(struct cxl_region *region);
>  unsigned long long cxl_region_get_resource(struct cxl_region *region);
> +enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region);
>  unsigned int cxl_region_get_interleave_ways(struct cxl_region *region);
>  unsigned int cxl_region_get_interleave_granularity(struct cxl_region *re=
gion);
>  struct cxl_decoder *cxl_region_get_target_decoder(struct cxl_region *reg=
ion,
> diff --git a/cxl/json.c b/cxl/json.c
> index 0fc44e4..f625380 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -827,6 +827,7 @@ void util_cxl_mappings_append_json(struct json_object=
 *jregion,
>  struct json_object *util_cxl_region_to_json(struct cxl_region *region,
>  					     unsigned long flags)
>  {
> +	enum cxl_decoder_mode mode =3D cxl_region_get_mode(region);
>  	const char *devname =3D cxl_region_get_devname(region);
>  	struct json_object *jregion, *jobj;
>  	u64 val;
> @@ -853,6 +854,10 @@ struct json_object *util_cxl_region_to_json(struct c=
xl_region *region,
>  			json_object_object_add(jregion, "size", jobj);
>  	}
> =20
> +	jobj =3D json_object_new_string(cxl_decoder_mode_name(mode));
> +	if (jobj)
> +		json_object_object_add(jregion, "type", jobj);
> +
>  	val =3D cxl_region_get_interleave_ways(region);
>  	if (val < INT_MAX) {
>  		jobj =3D json_object_new_int(val);
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index 6bc0810..9832d09 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -242,3 +242,8 @@ global:
>  	cxl_target_get_firmware_node;
>  	cxl_dport_get_firmware_node;
>  } LIBCXL_3;
> +
> +LIBCXL_5 {
> +global:
> +	cxl_region_get_mode;
> +} LIBCXL_4;
>=20
> --=20
> 2.39.1
>=20
> =
