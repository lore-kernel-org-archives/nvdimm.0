Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812D8323E
	for <nvdimm@lists.linux.dev>; Mon,  5 Jun 2023 21:04:12 +0000 (UTC)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
	by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20230605204616usoutp02db76c62a78ecf80b9ad7a146a724db2a~l3joJHji92009120091usoutp02H;
	Mon,  5 Jun 2023 20:46:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20230605204616usoutp02db76c62a78ecf80b9ad7a146a724db2a~l3joJHji92009120091usoutp02H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1685997976;
	bh=UOfbD4teewBkv8DcG1fJicHqsLDcmi3rCDXPNmZv+fA=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=IYBxJuqZ/C1oj7476iDihvpFhNwz0V23Zc/qQPF8LzFEuXmvpUejnvTyjGMgLDqiR
	 z4sIJaRBNWWhGpEzJ8BTuS2yNlMzoNb9Ki7GhsVw1wXIn5mDQbeC/H7JSpXn22P6jG
	 HmoyRmZ0u++ysUPpcBVEEhEySi92rG8aP5nQwuHg=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
	[203.254.195.111]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20230605204616uscas1p2cf331eb4146b351d25fe2e7bb9e14dbb~l3jn53Vuu1908319083uscas1p2t;
	Mon,  5 Jun 2023 20:46:16 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
	ussmges2new.samsung.com (USCPEMTA) with SMTP id 87.16.42611.7994E746; Mon, 
	5 Jun 2023 16:46:15 -0400 (EDT)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
	[203.254.195.92]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20230605204615uscas1p1931142de4b55be03c99f513b51dcb2fc~l3jnmdTkY2079620796uscas1p1j;
	Mon,  5 Jun 2023 20:46:15 +0000 (GMT)
X-AuditID: cbfec36f-249ff7000000a673-61-647e4997c5e9
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.145]) by
	ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id 98.8C.64580.7994E746; Mon, 
	5 Jun 2023 16:46:15 -0400 (EDT)
Received: from SSI-EX2.ssi.samsung.com (105.128.2.227) by
	SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.1.2375.24; Mon, 5 Jun 2023 13:46:13 -0700
Received: from SSI-EX2.ssi.samsung.com ([105.128.2.227]) by
	SSI-EX2.ssi.samsung.com ([105.128.2.227]) with mapi id 15.01.2375.024; Mon,
	5 Jun 2023 13:46:13 -0700
From: Fan Ni <fan.ni@samsung.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, Adam Manzanares
	<a.manzanares@samsung.com>, "dave@stgolabs.net" <dave@stgolabs.net>,
	"nmtadam.samsung@gmail.com" <nmtadam.samsung@gmail.com>, "nifan@outlook.com"
	<nifan@outlook.com>
Subject: Re: [PATCH 2/4] dax: Use device_unregister() in
 unregister_dax_mapping()
Thread-Topic: [PATCH 2/4] dax: Use device_unregister() in
	unregister_dax_mapping()
Thread-Index: AQHZl+7E9FcJ9WhBj0ydpcru30sO0g==
Date: Mon, 5 Jun 2023 20:46:13 +0000
Message-ID: <20230605204613.GB2344865@bgt-140510-bm03>
In-Reply-To: <168577283989.1672036.7777592498865470652.stgit@dwillia2-xfh.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0EA9431CB612054FABAF65C28BE7D60C@ssi.samsung.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsWy7djX87rTPetSDBZfsbaYPvUCo8Xqm2sY
	Lc7POsVi8XzicyaLpUseMVus/PGH1YHNY+esu+wei/e8ZPJ4sXkmo8fm1y+YPabOrvf4vEku
	gC2KyyYlNSezLLVI3y6BK+Nayyr2gq1sFZPm/2BtYFzJ2sXIySEhYCKxb+ZCIJuLQ0hgJaPE
	yqWfoZxWJolvtzYwwlS13N3NDJFYyyjxd1ETO4TzkVFi2+cVjBDOUkaJmde2gw1mE1CU2Ne1
	nQ3EFhHQlpg45yBYO7PAWiaJeTuvMoEkhAWCJY5vOsAEURQisW5mGzuErSfxpecKM4jNIqAi
	MaVzKVgNr4CZxN83n8Bu4hQIl/jz4zwLiM0oICbx/dQasBpmAXGJW0/mM0HcLSixaPYeZghb
	TOLfrodsELaixP3vL9kh6nUkFuz+xAZh20kc7Z8JFdeWWLbwNTPEXkGJkzOfsED0SkocXHGD
	BeQZCYErHBIPP0+FBpKLxIuXM6FsaYnpay4DFXEA2ckSqz5yQYRzJOYv2QI1x1pi4Z/1TBMY
	VWYhOXsWkpNmITlpFpKTZiE5aQEj6ypG8dLi4tz01GKjvNRyveLE3OLSvHS95PzcTYzABHX6
	3+H8HYzXb33UO8TIxMF4iFGCg1lJhHeXV3WKEG9KYmVValF+fFFpTmrxIUZpDhYlcV5D25PJ
	QgLpiSWp2ampBalFMFkmDk6pBiZGzo8R675LX2md/OiqmJL/ku0Zn6RO64YHPd71Nat0WuCp
	OteXfVdvnE2dP/nHjuPJHBxyd5592L3PuNDHa3vweil3tq5y3kPPjKQT7gaGHVs/73XH/GSD
	oKuNXpfYvHfuEQxWW+i2Nd0zcl2Qk+ezY9OzvKfMLP0bu3bOhtXTo2p2bA+5bBl7fmLF+dTT
	Xhn6Xr7tFUc+t1feeeCgXSQZ/17vX92RVR33+Ew5WOWPTFIpbPysutY+tHVxUG7Ps2tvVz27
	f7zbjo1/5frOGV69qrOjLJbJO4e0Mx/zVr9do/Dq9w7VeUGyakG293b6px7hPPki/3VKJM+d
	yzqlyTvitC+urT8qmv3l5apbC28qsRRnJBpqMRcVJwIArpTVcb8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWS2cA0UXe6Z12KwcyJmhbTp15gtFh9cw2j
	xflZp1gsnk98zmSxdMkjZouVP/6wOrB57Jx1l91j8Z6XTB4vNs9k9Nj8+gWzx9TZ9R6fN8kF
	sEVx2aSk5mSWpRbp2yVwZVxrWcVesJWtYtL8H6wNjCtZuxg5OSQETCRa7u5m7mLk4hASWM0o
	0blqApTzkVFi1aW5TBDOUkaJnkN3mUBa2AQUJfZ1bWcDsUUEtCUmzjkI1sEssJZJYt7Oq2BF
	wgLBEsc3HWCCKAqR6H1/B8rWk/jSc4UZxGYRUJGY0rkULM4rYCbx980nRohtSxglHhx+yAKS
	4BQIl/jz4zyYzSggJvH91BqwBmYBcYlbT+YzQTwhILFkz3lmCFtU4uXjf1DPKUrc//6SHaJe
	R2LB7k9sELadxNH+mVBxbYllC18zQxwhKHFy5hMWiF5JiYMrbrBMYJSYhWTdLCSjZiEZNQvJ
	qFlIRi1gZF3FKF5aXJybXlFsnJdarlecmFtcmpeul5yfu4kRGN+n/x2O2cF479ZHvUOMTByM
	hxglOJiVRHh3eVWnCPGmJFZWpRblxxeV5qQWH2KU5mBREuf1iJ0YLySQnliSmp2aWpBaBJNl
	4uCUamDiZ1/S5bMn8NSSgJfrZQpbT7dt9WfeVvOrTpXzUo6O6IcpG2zf35fZtyCtfIHq92Y9
	Y4N03SsGPz2PPKhxcIw001fxXDBbMFJPaUny7Nowz+2Tmf0erW/2eaPmfylwyorrRh7i/Qvd
	bh84db56voLUX2Z+jwWTfmmc8Nh1a13m0UkOnoXsi5QZpnzVeX1wa/79w7w/3j6XdJ59Ntmf
	U1E57pbKzQdvYp9/Djn1P84txPlFpL3zcRd54+cnC4z8U6/PDzvfuOCQRafKHg7P2erlQbL7
	kucznn/0m+XVY9NrersDbDbIzXCuXRP2M9I3InNX3uvE6Tvf8CYu/tiiEzC/xeC56jO7Kaw/
	kwzanIyVWIozEg21mIuKEwFSnQAvXgMAAA==
X-CMS-MailID: 20230605204615uscas1p1931142de4b55be03c99f513b51dcb2fc
CMS-TYPE: 301P
X-CMS-RootMailID: 20230605204615uscas1p1931142de4b55be03c99f513b51dcb2fc
References: <168577282846.1672036.13848242151310480001.stgit@dwillia2-xfh.jf.intel.com>
	<168577283989.1672036.7777592498865470652.stgit@dwillia2-xfh.jf.intel.com>
	<CGME20230605204615uscas1p1931142de4b55be03c99f513b51dcb2fc@uscas1p1.samsung.com>

On Fri, Jun 02, 2023 at 11:13:59PM -0700, Dan Williams wrote:
> Replace an open-coded device_unregister() sequence with the helper.
>=20
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/dax/bus.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index aee695f86b44..c99ea08aafc3 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -657,8 +657,7 @@ static void unregister_dax_mapping(void *data)
>  	dev_dax->ranges[mapping->range_id].mapping =3D NULL;
>  	mapping->range_id =3D -1;
> =20
> -	device_del(dev);
> -	put_device(dev);
> +	device_unregister(dev);
>  }
> =20
>  static struct dev_dax_range *get_dax_range(struct device *dev)
>=20
>=20

Reviewed-by: Fan Ni <fan.ni@samsung.com>
