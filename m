Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06FFA29;
	Mon, 18 Apr 2022 16:46:50 +0000 (UTC)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
	by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220418163713usoutp01b4f5998fb2dee5945068d8fd3683dbe1~nCvSFfe2h0440104401usoutp01f;
	Mon, 18 Apr 2022 16:37:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220418163713usoutp01b4f5998fb2dee5945068d8fd3683dbe1~nCvSFfe2h0440104401usoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1650299833;
	bh=Z0wvz+w3MM7V1gqBpZNdd8vqXrtxWYIC+eAFu1GlgMo=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=Qk9jQzcQ3rjMqaSWT4JUhGUkv8t+oULyiPN4fAHAGFNE9AyjsDrXnrEPQAKApHFV5
	 qRz9Mg4NB+lz1d/wuhz13rGmPFCUPcyvbF+qGL42katElqIMnfMkbtbx1UdQPqLrzi
	 o6H3k7pTXtQbn5tBFo9Jp5qFXlyvTjyzrPLurT6E=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
	[203.254.195.109]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20220418163713uscas1p1308663154db1a06390013f6b48d9150c~nCvR5nZK-2934229342uscas1p1q;
	Mon, 18 Apr 2022 16:37:13 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
	ussmges1new.samsung.com (USCPEMTA) with SMTP id D6.4B.09760.9B39D526; Mon,
	18 Apr 2022 12:37:13 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
	[203.254.195.91]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20220418163713uscas1p17b3b1b45c7d27e54e3ecb62eb8af2469~nCvRmzjVZ3041230412uscas1p1o;
	Mon, 18 Apr 2022 16:37:13 +0000 (GMT)
X-AuditID: cbfec36d-51bff70000002620-11-625d93b9a164
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.145]) by
	ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id A3.D7.09672.8B39D526; Mon,
	18 Apr 2022 12:37:13 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
	SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.1.2375.7; Mon, 18 Apr 2022 09:37:12 -0700
Received: from SSI-EX3.ssi.samsung.com ([fe80::ddc9:3655:8940:70fb]) by
	SSI-EX3.ssi.samsung.com ([fe80::ddc9:3655:8940:70fb%4]) with mapi id
	15.01.2375.007; Mon, 18 Apr 2022 09:37:12 -0700
From: Adam Manzanares <a.manzanares@samsung.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: Ben Widawsky <ben.widawsky@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Alison Schofield
	<alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>, Vishal Verma
	<vishal.l.verma@intel.com>, "mcgrof@kernel.org" <mcgrof@kernel.org>
Subject: Re: [RFC PATCH 02/15] cxl/core/hdm: Bail on endpoint init fail
Thread-Topic: [RFC PATCH 02/15] cxl/core/hdm: Bail on endpoint init fail
Thread-Index: AQHYU0KNF8z/Gs91PkuWbFzC2yfYtA==
Date: Mon, 18 Apr 2022 16:37:12 +0000
Message-ID: <20220418163702.GA85141@bgt-140510-bm01>
In-Reply-To: <CAPcyv4hKGEy_0dMQWfJAVVsGu364NjfNeup7URb7ORUYLSZncw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <469CE4F1A4A8F344B33B1C8385464CAA@ssi.samsung.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsWy7djX87o7J8cmGaybpWBx9/EFNouuZ/3M
	FtOnXmC02P/0OYvFqoXX2CzOzzrFYnFjwlNGi5U//rBaXD5xidHi1oRjTA5cHi1H3rJ6LN7z
	kslj06pONo8Xm2cyenzeJBfAGsVlk5Kak1mWWqRvl8CV0X9jN2NBo0DF75P9TA2Ml7i7GDk5
	JARMJP7fPcTexcjFISSwklGi6eR7JginlUmi4fEpIIcDrKrjZTlEfC2jxPWuXkYI5yOjxIvW
	AywQzgFGiS03ZrCAzGUTMJD4fXwjM4gtIqAtMXHOQTCbWWAOs8TEi6IgtrCAu8SJvg5GiBoP
	iS//jrBC2HoSm/9dZQOxWQRUJS4/usAEYvMCXfH7ez9YPadAIFDvEbCZjAJiEt9PrWGCmC8u
	cevJfCaI3wQlFs3ewwxhi0n82/WQDcJWlLj//SU7RL2OxILdn9ggbDuJ7/+WMELY2hLLFr5m
	htgrKHFy5hMWiF5JiYMrbkDZLzgkGh9pQdguErvXrISKS0v8vbsMHIwSAu2MEh8m7GOFcCYw
	Stx5+xPqCmuJf53X2CcwqsxCcvgsJEfNQnLULCRHzUJy1AJG1lWM4qXFxbnpqcWGeanlesWJ
	ucWleel6yfm5mxiBCez0v8O5Oxh33Pqod4iRiYPxEKMEB7OSCG/PkugkId6UxMqq1KL8+KLS
	nNTiQ4zSHCxK4rzLMjckCgmkJ5akZqemFqQWwWSZODilGpiWV//n3CZjsCLlwW3vvzzM1Sk/
	/uTXBOZunNjPI5p8hsv+Xc2fe3cc2+v4Aw6/P8Z0Mi3u+zXXXQ8syq48T7po/ppPZ9MbmTPa
	wQevvLzDs+pVXYXGJoNdtfKni+rVI2WfB1zLOy4n2mi+76vnC7YWxhRjh9smHyvibUVEQpuj
	b3Ue/L0319BOIYY538w268jMy5umJF6XlHYosb+16emJ78vnTtr3ui5XPNX8X5fsq9ZP9u58
	yqdjrviszalJqos1Sby4KUtF3DxwLmv4ysMfH9fE6v/Ju1/2K9SfJWlBQvpkloAdvGnu5fmN
	ra/jdM9OnLLZNPHGo+d7U/1uHkgNnm0yMU+ixWPWjbTqXiWW4oxEQy3mouJEADm9jSXPAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsWS2cA0UXfn5Ngkg44fHBZ3H19gs+h61s9s
	MX3qBUaL/U+fs1isWniNzeL8rFMsFjcmPGW0WPnjD6vF5ROXGC1uTTjG5MDl0XLkLavH4j0v
	mTw2repk83ixeSajx+dNcgGsUVw2Kak5mWWpRfp2CVwZ/Td2MxY0ClT8PtnP1MB4ibuLkYND
	QsBEouNleRcjF4eQwGpGiRUTf7NCOB8ZJX6tvQ3lHAByPuxl7mLk5GATMJD4fXwjmC0ioC0x
	cc5BMJtZYA6zxMSLoiC2sIC7xIm+DkaIGg+JL/+OsELYehKb/11lA7FZBFQlLj+6wARi8wJd
	8ft7PyPEsh2MEv3bb4I1cAoEAg06AraAUUBM4vupNUwQy8Qlbj2ZD2ZLCAhILNlznhnCFpV4
	+fgfK4StKHH/+0t2iHodiQW7P7FB2HYS3/8tYYSwtSWWLXzNDHGEoMTJmU9YIHolJQ6uuMEy
	gVFiFpJ1s5CMmoVk1Cwko2YhGbWAkXUVo3hpcXFuekWxUV5quV5xYm5xaV66XnJ+7iZGYOyf
	/nc4egfj7Vsf9Q4xMnEwHmKU4GBWEuHtWRKdJMSbklhZlVqUH19UmpNafIhRmoNFSZz3ZdTE
	eCGB9MSS1OzU1ILUIpgsEwenVAMTg45ibifv5usbeWTrX2v1mGrc/zsjfp7P/5nv5Pe7zSnZ
	zWVQM/vFYebJ6eULPhyzuapkIdO8/k7AgXdOl87NFGdS/3jmYPThpkaJrGknYu18fZ2vfc0T
	63Jkm9cueOdYxYLwspU/Dt7o2yc837iqc+7krlw5we959iJpnmLfJ7cpK4rZ74hsyt/+dePV
	nke8uyMcXazcujtuv0stuHqoNcXYODNDZtk2c+tNwvsk31TmqG47KZswJX/Nm2easSZyye/3
	vJ2z+tmf+WfntNyVeek0N2SFQ8G86T+WnHF4mbQ4WXmDi7ntr+pr6xlvJfLNUGDQO7SwlFNm
	f8Qnfp/zjnVPrq7daHfOz8Np+awrSizFGYmGWsxFxYkAdOfDS2wDAAA=
X-CMS-MailID: 20220418163713uscas1p17b3b1b45c7d27e54e3ecb62eb8af2469
CMS-TYPE: 301P
X-CMS-RootMailID: 20220418163713uscas1p17b3b1b45c7d27e54e3ecb62eb8af2469
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
	<20220413183720.2444089-3-ben.widawsky@intel.com>
	<CAPcyv4hKGEy_0dMQWfJAVVsGu364NjfNeup7URb7ORUYLSZncw@mail.gmail.com>
	<CGME20220418163713uscas1p17b3b1b45c7d27e54e3ecb62eb8af2469@uscas1p1.samsung.com>

On Wed, Apr 13, 2022 at 02:31:42PM -0700, Dan Williams wrote:
> On Wed, Apr 13, 2022 at 11:38 AM Ben Widawsky <ben.widawsky@intel.com> wr=
ote:
> >
> > Endpoint decoder enumeration is the only way in which we can determine
> > Device Physical Address (DPA) -> Host Physical Address (HPA) mappings.
> > Information is obtained only when the register state can be read
> > sequentially. If when enumerating the decoders a failure occurs, all
> > other decoders must also fail since the decoders can no longer be
> > accurately managed (unless it's the last decoder in which case it can
> > still work).
>=20
> I think this should be expanded to fail if any decoder fails to
> allocate anywhere in the topology otherwise it leaves a mess for
> future address translation code to work through cases where decoder
> information is missing.
>=20
> The current approach is based around the current expectation that
> nothing is enumerating pre-existing regions, and nothing is performing
> address translation.

Does the qemu support currently allow testing of this patch? If so, it woul=
d=20
be good to reference qemu configurations. Any other alternatives would be=20
welcome as well.=20

+Luis on cc.

>=20
> >
> > Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> > ---
> >  drivers/cxl/core/hdm.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> > index bfc8ee876278..c3c021b54079 100644
> > --- a/drivers/cxl/core/hdm.c
> > +++ b/drivers/cxl/core/hdm.c
> > @@ -255,6 +255,8 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxl=
hdm)
> >                                       cxlhdm->regs.hdm_decoder, i);
> >                 if (rc) {
> >                         put_device(&cxld->dev);
> > +                       if (is_endpoint_decoder(&cxld->dev))
> > +                               return rc;
> >                         failed++;
> >                         continue;
> >                 }
> > --
> > 2.35.1
> >
> =
