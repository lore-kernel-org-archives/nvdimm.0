Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498BB7A;
	Fri, 15 Apr 2022 20:57:10 +0000 (UTC)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
	by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220415205054usoutp02a6724ca69cc982e85f6353434051425e~mLQ6QPQ_e2793527935usoutp02Z;
	Fri, 15 Apr 2022 20:50:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220415205054usoutp02a6724ca69cc982e85f6353434051425e~mLQ6QPQ_e2793527935usoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1650055854;
	bh=rbPH910LIobk7Uf+bxHj1FGQoCQLyXIdRimZ7RIZzf4=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=ID874J2826YFkiRJ0/yahd8+alg0rAlq3iSAk8aWlIeFxNrpxHH2aljOyLu7VsnI+
	 j9B6RW0H4rah7sCqmj3YTI2Bpi191oxD5TyKNGihW8litJMOk2nz4ni0u5Z4ghvaZo
	 10CJclwaZUSvWM032UZXvEhOB9FMBnIZP8rr3n34=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
	[203.254.195.109]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20220415205052uscas1p12c16360da29ef841fdc737753598c39e~mLQ5MhkMj1327213272uscas1p1F;
	Fri, 15 Apr 2022 20:50:52 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
	ussmges1new.samsung.com (USCPEMTA) with SMTP id 88.8E.09760.CAAD9526; Fri,
	15 Apr 2022 16:50:52 -0400 (EDT)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
	[203.254.195.92]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20220415205052uscas1p209e03abf95b9c80b2ba1f287c82dfd80~mLQ47mUSg2505025050uscas1p22;
	Fri, 15 Apr 2022 20:50:52 +0000 (GMT)
X-AuditID: cbfec36d-51bff70000002620-8b-6259daacff88
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.145]) by
	ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id 06.B4.09665.CAAD9526; Fri,
	15 Apr 2022 16:50:52 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
	SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.1.2242.4; Fri, 15 Apr 2022 13:50:51 -0700
Received: from SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36]) by
	SSI-EX3.ssi.samsung.com ([fe80::4031:294d:7626:e900%4]) with mapi id
	15.01.2242.008; Fri, 15 Apr 2022 13:50:51 -0700
From: Adam Manzanares <a.manzanares@samsung.com>
To: Ben Widawsky <ben.widawsky@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, Alison Schofield <alison.schofield@intel.com>,
	"Dan Williams" <dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal Verma
	<vishal.l.verma@intel.com>
Subject: Re: [RFC PATCH 01/15] cxl/core: Use is_endpoint_decoder
Thread-Topic: [RFC PATCH 01/15] cxl/core: Use is_endpoint_decoder
Thread-Index: AQHYUQp+buRaSuq+ck6p5yfWSKlchg==
Date: Fri, 15 Apr 2022 20:50:51 +0000
Message-ID: <20220415205034.GA67162@bgt-140510-bm01>
In-Reply-To: <20220413183720.2444089-2-ben.widawsky@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <60C9E0E4E632524F8632FB28E5FB8218@ssi.samsung.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTcRjG+59zdnY2Wp1W6JtSmhTRbU0JOnQZ2U3TDwsKpKLL1INaOm1z
	TiUqyQilcFpSLcpLsdyaXVyapFkunal5Ic1KlPKSZmm4tCytlfMs2Lffy/s85/3x51C42MLz
	omKUiaxKqYj1I4VEme178xpz575wqfm+lOnuayWZzIEsnLmc24qYpx8HCcZU0EEyLfoGgjH+
	/M1j2l68QkynzoZtEQSn14zwgm9WDmHBnyxXUfBYyeLdxH7hpkg2NiaJVa2VHRFGGx1T/IRv
	dHLJjUn8NEqbk4kEFNDroL1nHGUiISWmjQiqLBkEN5zFwFbbwvufytb14tyiGEFv4QseN9gR
	jJ8pd22eIbAa2ghnhaSlMFX3AHfyAnoFjNxqnzmC02k4DN6rRs7FfHoLtJhySC4UCF23x/gc
	S6B0qnm6TFEEvQzstqNOFE1r3K3wdSYEtAw+v0ufOYVoD5hoMGNOxmlP6OzPwzjreVB4rRLn
	2AMcj3tIjpfA+4khPpdfDfkV30iOZVDdNIw4XgWGgi8zXdH0d+qv9hNcdyFUF72deSKg+ylo
	HX7tOrYdsmxdLvaGy+Y2V+gcglFdFY8bdAi6Rn65NDaCI6ODr0NL9W7mejcrvZuV3s1K72aV
	j3gm5KlRq+OiWLW/ktVK1Io4tUYZJYmIjytB0/9Vo+N5XDkq77RLrAijkBUBhfstEL3LCgsX
	iyIVKamsKv6wShPLqq3ImyL8PEWGmPsKMR2lSGSPsWwCq/q/xSiB12ms6Id9vCdv1Gqa7Svz
	/Rj2daQu6oiP43pzn3E49FzDfqlSZnievLW/Km3jm/oBYe6cQ3QA2Vu4eK9kp3bwg6B81phY
	Nd5N270s25om1zcl+T8qlQbOLn25aDOCNadiNdqvObLI1IiciZDi7g3xEVTlrg0ng8oS6wIe
	YaNkYo7/q4sBjZMGOb/gV6RhuyY0+Xx8WGPfvuboHcezr/lUyU35Bz8dGAw6E22pv5KV6aN9
	c6kjdFNRTVl47p6hJ+tfzmViaitO1AaS2fLwh/IfbX1/ij206Gc7eIb8DdptTJfLv6ckrVhV
	k7r8c8i91gvYgHdhcf2dRQn85IwD5pTJ+XvtIj9CHa3wX4mr1Ip/REBbdcYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsWS2cA0UXfNrcgkg/ePpS3uPr7AZtH1rJ/Z
	YvrUC4wW+58+Z7FYtfAam8X5WadYLFb++MNqcfnEJUaLWxOOMTlwerQcecvqsXjPSyaPF5tn
	Mnp83iQXwBLFZZOSmpNZllqkb5fAlbHy32/2gk8CFZvm/WJuYGzk62Lk5JAQMJGYOOERcxcj
	F4eQwGpGiflnZzJBOB8ZJf7O3MAI4RxglPjS8JQNpIVNwEDi9/GNzCC2iICmxNslV8CKmAUa
	mSWerz/ICJIQFnCQOL9qEhtEkaPEneWf2SFsPYmtv88BNXNwsAioSnw8lgVi8gKdsW63AkiF
	kEChxM/9Z1lAbE4BO4lXN1vAbEYBMYnvp9YwgdjMAuISt57MZ4L4QEBiyZ7zzBC2qMTLx/9Y
	IWxFifvfX7JD1OtILNj9iQ3CtpM4ePYNI4StLbFs4WuwXl4BQYmTM5+wQPRKShxccYNlAqPE
	LCTrZiEZNQvJqFlIRs1CMmoBI+sqRvHS4uLc9Ipi47zUcr3ixNzi0rx0veT83E2MwCg//e9w
	zA7Ge7c+6h1iZOJgPMQowcGsJMJ7sz88SYg3JbGyKrUoP76oNCe1+BCjNAeLkjivR+zEeCGB
	9MSS1OzU1ILUIpgsEwenVANT6PWXosFrHZcWVk3ylMgSPrZ2hoMUT/BswdDZa1l3xKxxqj1x
	oepd95wvH/Ob3Nu2hYemaS//vdVxqabhvqMpyQwR16Zt3X9yT9IVN94DXyLeTHZQ/pautm35
	e9u563ckeLL8X5ZUlPXA5YHLrA0bT89z9Qj+KZlp3yDbvIQ5uf/ihUsH/+hHndh13sGkdwr7
	GUOz15xChaI1txX+FZzfarE5yeTM3YbAvY3uOxa+uHxQmIPnVKj7+p//nmZ2bt/Ya/dPbFJQ
	9dJLclXLdH8w7cnm45LVtC1okUty9ZgZGdvwKMBzf/IOkSmmGj/EmY4sD/porz1p6sMJm1OO
	fzn5K2jGhU1na9aqJnf/3Ju0QImlOCPRUIu5qDgRABol7ihhAwAA
X-CMS-MailID: 20220415205052uscas1p209e03abf95b9c80b2ba1f287c82dfd80
CMS-TYPE: 301P
X-CMS-RootMailID: 20220415205052uscas1p209e03abf95b9c80b2ba1f287c82dfd80
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
	<20220413183720.2444089-2-ben.widawsky@intel.com>
	<CGME20220415205052uscas1p209e03abf95b9c80b2ba1f287c82dfd80@uscas1p2.samsung.com>

On Wed, Apr 13, 2022 at 11:37:06AM -0700, Ben Widawsky wrote:
> Save some characters and directly check decoder type rather than port
> type. There's no need to check if the port is an endpoint port since we
> already know the decoder, after alloc, has a specified type.
>=20
> Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> ---
>  drivers/cxl/core/hdm.c  | 2 +-
>  drivers/cxl/core/port.c | 2 +-
>  drivers/cxl/cxl.h       | 1 +
>  3 files changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> index 0e89a7a932d4..bfc8ee876278 100644
> --- a/drivers/cxl/core/hdm.c
> +++ b/drivers/cxl/core/hdm.c
> @@ -197,7 +197,7 @@ static int init_hdm_decoder(struct cxl_port *port, st=
ruct cxl_decoder *cxld,
>  	else
>  		cxld->target_type =3D CXL_DECODER_ACCELERATOR;
> =20
> -	if (is_cxl_endpoint(to_cxl_port(cxld->dev.parent)))
> +	if (is_endpoint_decoder(&cxld->dev))
>  		return 0;
> =20
>  	target_list.value =3D
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index 2ab1ba4499b3..74c8e47bf915 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -272,7 +272,7 @@ static const struct device_type cxl_decoder_root_type=
 =3D {
>  	.groups =3D cxl_decoder_root_attribute_groups,
>  };
> =20
> -static bool is_endpoint_decoder(struct device *dev)
> +bool is_endpoint_decoder(struct device *dev)
>  {
>  	return dev->type =3D=3D &cxl_decoder_endpoint_type;
>  }
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 990b6670222e..5102491e8d13 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -340,6 +340,7 @@ struct cxl_dport *cxl_find_dport_by_dev(struct cxl_po=
rt *port,
> =20
>  struct cxl_decoder *to_cxl_decoder(struct device *dev);
>  bool is_root_decoder(struct device *dev);
> +bool is_endpoint_decoder(struct device *dev);
>  bool is_cxl_decoder(struct device *dev);
>  struct cxl_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
>  					   unsigned int nr_targets);
> --=20
> 2.35.1
>=20
>


Looks good.

Reviewed by: Adam Manzanares <a.manzanares@samsung.com>=
