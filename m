Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B108BF1
	for <nvdimm@lists.linux.dev>; Tue,  7 Feb 2023 22:17:28 +0000 (UTC)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
	by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20230207220733usoutp01b8a4f3faf31c35f4fcd05a11556c250c~Bqi6Efy2D1427714277usoutp01W;
	Tue,  7 Feb 2023 22:07:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20230207220733usoutp01b8a4f3faf31c35f4fcd05a11556c250c~Bqi6Efy2D1427714277usoutp01W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1675807653;
	bh=EnEhYqDsHFGeq32EGpMdDkmR1ncbLh9sFp6iQxRPUNc=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=OWo8zTSAdchR/GTiMZMfz4Mtg7WsvIGqlwqeOHnHS8VoljQoSTDuZJSRORS4jt6cB
	 Kgp23Y3XTg+Hdmlc/5uYcIFw5lGQyjV2RiJuI73UssmjBFQ1rIYCp1EZytttyp3af6
	 N7QhrueS4g+t5unSJJl08SdLc+zTNzxMe6KhZMtI=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
	[203.254.195.111]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20230207220733uscas1p2003853da12417b97a5bf7117662128f3~Bqi59ZoV_0486704867uscas1p2b;
	Tue,  7 Feb 2023 22:07:33 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
	ussmges2new.samsung.com (USCPEMTA) with SMTP id 17.B2.49129.4ABC2E36; Tue, 
	7 Feb 2023 17:07:32 -0500 (EST)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
	[203.254.195.89]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20230207220732uscas1p28eab99f743962581e50c2657b2e2132e~Bqi5qXTZT0485204852uscas1p2B;
	Tue,  7 Feb 2023 22:07:32 +0000 (GMT)
X-AuditID: cbfec36f-eddff7000001bfe9-34-63e2cba480d0
Received: from SSI-EX2.ssi.samsung.com ( [105.128.2.146]) by
	ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id D6.C1.11378.4ABC2E36; Tue, 
	7 Feb 2023 17:07:32 -0500 (EST)
Received: from SSI-EX2.ssi.samsung.com (105.128.2.227) by
	SSI-EX2.ssi.samsung.com (105.128.2.227) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.1.2375.24; Tue, 7 Feb 2023 14:07:31 -0800
Received: from SSI-EX2.ssi.samsung.com ([105.128.2.227]) by
	SSI-EX2.ssi.samsung.com ([105.128.2.227]) with mapi id 15.01.2375.024; Tue,
	7 Feb 2023 14:07:31 -0800
From: Fan Ni <fan.ni@samsung.com>
To: Vishal Verma <vishal.l.verma@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, Gregory Price
	<gregory.price@memverge.com>, Jonathan Cameron
	<Jonathan.Cameron@Huawei.com>, Davidlohr Bueso <dave@stgolabs.net>, Dan
	Williams <dan.j.williams@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 1/7] cxl/region: skip region_actions for region
 creation
Thread-Topic: [PATCH ndctl 1/7] cxl/region: skip region_actions for region
	creation
Thread-Index: AQHZO0CTg1B8Uw6T8kqhvQqHMVP2oQ==
Date: Tue, 7 Feb 2023 22:07:31 +0000
Message-ID: <20230207220723.GA702843@bgt-140510-bm03>
In-Reply-To: <20230120-vv-volatile-regions-v1-1-b42b21ee8d0b@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <068E3469EEAA044093780C5E03D1D10B@ssi.samsung.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf0yMcRzHfZ/nfjxdLo+j+qiJrthIlx9lNwlhczJjRg3LeVzPEtdd7orY
	rLTKFDk/jrlm3SXR42gSUsSVWlKdtZK7Gbll6wfWaXaWRHdPpv/e38/7/f58X/vuS+AiMzeA
	SFGl0xoVpRTzBJxHzT86wsteOxRLT9+MlF7Vv0HSOzYzkmbnODhSxvSWJ7UaWjnSip9jXKld
	14yt48tyX37lym48HcBk/Q+uIdl95x++TF+cJRupCtrO2yNYnUQrU47Smog1+wUH7XkML+2h
	T2bHCyIbdXgXIC8CyEgwNlVzCpCAEJEVCIyFFj57yMPgfG42/1+qxW7issZdBD/q3uPswYmg
	quvzZOUmgtpmF+au8MhgqC94zHPr2WQY6MqHPXWcNGJQ8t2J3MYscic8Y9pxNrQLzrV9QayW
	wD37/Yk5QXDIUHCMbndLIRkFF3qT3AkvchNcGbBw3RqRfuBqNXuuxUl/sPeVYCz1TCgtfoqz
	2g/Gaz/xWB0MH10DfDa/BIx133nu9Ti5Bnp0gew4DMpNQ56qcGLNq2t9HLY6Byy333meC8he
	Aq5bSxBrbIRbwwVcVgdCd4/eQw+kAhingB0roaSsenJPNJjGKjEdCjVMoTZMITL8JzJMITJM
	ITIiLoP8M7Ta1GRau1xFH5NoqVRthipZolCnVqGJD/V6vFFdg3rsTkkDwgjUgIDAxbOFUS96
	FSJhEnX8BK1RyzUZSlrbgAIJjthfuCzmlUJEJlPp9GGaTqM1/1yM8ArIxhJe7s03c+WjRSOL
	29Y3NM61tUYckPn2YxuKE/vy5L6NS4ZyNjC30nxiB+txZmf5PuSz2aZb2Y5qEw6d3JZYVJcw
	ovZzxo5dvevQ7KYWnpD8ivWmZLiqLj7FtWjFjmnm+PLiy7+ehO/zWxUWMOyaMb2ik0qv7jpw
	FmuJG5q1QOy4+GH9YFymv9X2rTQvf91YGvO+o7VRHH6xJcJ6KjPfoam8FG55HkVa2zb3n+yK
	FIf8DN7K/Pk6nwga7URq+W6lqVe9NmaG/Mxery1NohWhASG2jEdH6gubfhfanNKjOvk50/N7
	el+X2SKiutvfxObqx/WXovn8eUlfarJEH7MMYo72ILVsMa7RUn8BkopwLL8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWS2cA0SXfJ6UfJBis/KVtMn3qB0WL1zTWM
	Fg1Nj1gsVi28xmZxftYpFouVP/6wWtyacIzJgd2j5chbVo/Fe14yebzYPJPRY+PH/+weU2fX
	e3zeJBfAFsVlk5Kak1mWWqRvl8CVcat1FVvBVr6Kcwc4GhjPcXcxcnJICJhInLi1kLWLkYtD
	SGA1o8Sfa33MEM5HRomWCZsZIZyljBKndnezgrSwCShK7OvazgZiiwhoS0xY9gGsnVlgHpPE
	hXPXGEESwgIhEntXnWWGKAqVePR5MSOErSex7tZGoDgHB4uAisSjXwEgJq+AqcTEBykQu5oZ
	JZ7uvAI2n1PAXWLay4NgexkFxCS+n1rDBGIzC4hL3HoynwniBQGJJXvOM0PYohIvH/9jhbAV
	Je5/f8kOUa8jsWD3JzaQXcwCdhLXJ0hDhLUlli18DdbKKyAocXLmExaIVkmJgytusExglJiF
	ZNssJJNmIUyahWTSLCSTFjCyrmIULy0uzk2vKDbMSy3XK07MLS7NS9dLzs/dxAiM79P/Dkfu
	YDx666PeIUYmDsZDjBIczEoivKYHHiQL8aYkVlalFuXHF5XmpBYfYpTmYFES5xVynRgvJJCe
	WJKanZpakFoEk2Xi4JRqYJqjWrTXJ1H5lsD+I70nLibHJv1J1ogLFzqx7FbPlnlGzjcChNe9
	tdOQkQi8MkNR5lhWP8uZ/+XxKisiOGT/nbnMqsOvuyqc84TF11evP+l1f2vYcmPrm09LVUPq
	W9kj9tQ2iH8K/JOxUcvP8ojND7Y1HbJ2Lu+mqahPMzRKebA27GpYZWlsZwZ/0m2xnPDOneEP
	/k+fdDzvKKel2va3czc/q/mq/JntwAfuAz1JZkHPjBX//WdSdngqMEXystOv8tgpSwpWtp9c
	8ULm0e6nG/5F2aXsO3fBP2nzcgtpRYmKD7o/A54dDmLdrGsSVq2zfSfv4bAugT1lqqYBUasb
	o1lnlnAEFn1W9vZKzZ65QImlOCPRUIu5qDgRABZseKteAwAA
X-CMS-MailID: 20230207220732uscas1p28eab99f743962581e50c2657b2e2132e
CMS-TYPE: 301P
X-CMS-RootMailID: 20230207220732uscas1p28eab99f743962581e50c2657b2e2132e
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
	<20230120-vv-volatile-regions-v1-1-b42b21ee8d0b@intel.com>
	<CGME20230207220732uscas1p28eab99f743962581e50c2657b2e2132e@uscas1p2.samsung.com>

On Tue, Feb 07, 2023 at 12:16:27PM -0700, Vishal Verma wrote:
> Commit 3d6cd829ec08 ("cxl/region: Use cxl_filter_walk() to gather create-=
region targets")
> removed the early return for create-region, and this caused a
> create-region operation to unnecessarily loop through buses and root
> decoders only to EINVAL out because ACTION_CREATE is handled outside of
> the other actions. This results in confising messages such as:
s/confising/confusing/
>=20
>   # cxl create-region -t ram -d 0.0 -m 0,4
>   {
>     "region":"region7",
>     "resource":"0xf030000000",
>     "size":"512.00 MiB (536.87 MB)",
>     ...
>   }
>   cxl region: decoder_region_action: region0: failed: Invalid argument
>   cxl region: region_action: one or more failures, last failure: Invalid =
argument
>   cxl region: cmd_create_region: created 1 region
>=20
> Since there's no need to walk through the topology after creating a
> region, and especially not to perform an invalid 'action', switch
> back to retuening early for create-region.
s/retuening/returning/
>=20
> Fixes: 3d6cd829ec08 ("cxl/region: Use cxl_filter_walk() to gather create-=
region targets")
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  cxl/region.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/cxl/region.c b/cxl/region.c
> index efe05aa..38aa142 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -789,7 +789,7 @@ static int region_action(int argc, const char **argv,=
 struct cxl_ctx *ctx,
>  		return rc;
> =20
>  	if (action =3D=3D ACTION_CREATE)
> -		rc =3D create_region(ctx, count, p);
> +		return create_region(ctx, count, p);
> =20
>  	cxl_bus_foreach(ctx, bus) {
>  		struct cxl_decoder *decoder;
>=20
> --=20
> 2.39.1
>=20
> =
