Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305D219C
	for <nvdimm@lists.linux.dev>; Tue, 18 Jul 2023 04:31:14 +0000 (UTC)
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230718043112epoutp031135546ce427ffcf47c4f38eaf261bab~y2-kCEyo61021510215epoutp039
	for <nvdimm@lists.linux.dev>; Tue, 18 Jul 2023 04:31:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230718043112epoutp031135546ce427ffcf47c4f38eaf261bab~y2-kCEyo61021510215epoutp039
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1689654672;
	bh=mwZKY97E+xgRXJPuEMJNv00KvQtQlPp6tPiG7mpebaE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cG6rSknSo4eVELnOMrWe1h9R4QCCH1J63KhjAD3hhqbwlX4vmF/9waMRyW5smtqaY
	 g5/FW6e/2XS/jiyVS98CkUVizyZLpdgZkFi61f1oRQ0O3N6VRsPiSNWL9Fz1izvAcC
	 Y+0k/Xs9qcMQO+xdND2nBJgm2GpT98hHUuROzB3I=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20230718043112epcas2p220c85cf8def50b30c56960f047adb520~y2-jcSIH52856628566epcas2p23;
	Tue, 18 Jul 2023 04:31:12 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.89]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4R4mH320fvz4x9Px; Tue, 18 Jul
	2023 04:31:11 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
	epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
	BA.BC.32606.F8516B46; Tue, 18 Jul 2023 13:31:11 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
	20230718043110epcas2p19410befa3f55c2f1192d0177e88c14a3~y2-iQ4HE92985929859epcas2p1Q;
	Tue, 18 Jul 2023 04:31:10 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20230718043110epsmtrp1a4c4091b2b9d530b81142decbdd911a9~y2-iPn1Xr2259822598epsmtrp1t;
	Tue, 18 Jul 2023 04:31:10 +0000 (GMT)
X-AuditID: b6c32a47-9cbff70000007f5e-86-64b6158fd24b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	14.40.30535.E8516B46; Tue, 18 Jul 2023 13:31:10 +0900 (KST)
Received: from jehoon-Precision-7920-Tower (unknown [10.229.83.133]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20230718043110epsmtip265889be4536db37c5d8430041028bec2~y2-iDxMrQ1014610146epsmtip2g;
	Tue, 18 Jul 2023 04:31:10 +0000 (GMT)
Date: Tue, 18 Jul 2023 13:34:08 +0900
From: Jehoon Park <jehoon.park@samsung.com>
To: Nathan Fontenot <nafonten@amd.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Ira
	Weiny <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>, Dave
	Jiang <dave.jiang@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, Jonathan
	Cameron <jonathan.cameron@huawei.com>, Kyungsan Kim
	<ks0204.kim@samsung.com>, Junhyeok Im <junhyeok.im@samsung.com>
Subject: Re: [ndctl PATCH RESEND 1/2] cxl: Update a revision by CXL 3.0
 specification
Message-ID: <20230718043408.GA4295@jehoon-Precision-7920-Tower>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <f9caa859-0f65-a658-d144-0332cd4f0833@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBJsWRmVeSWpSXmKPExsWy7bCmhW6/6LYUg0vnuS3uPr7AZjF96gVG
	ixM3G9ksVt9cw2ix/+lzFotVC6+xWSw+OoPZ4ugeDovzs06xWEyduJ7ZYuWPP6wWtyYcY3Lg
	8Wi99JfNo+XIW1aPxXteMnm82DyT0aNvyypGj6mz6z0+b5ILYI/KtslITUxJLVJIzUvOT8nM
	S7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBulNJoSwxpxQoFJBYXKykb2dTlF9a
	kqqQkV9cYquUWpCSU2BeoFecmFtcmpeul5daYmVoYGBkClSYkJ2xYdlBpoJlQhUzZ5U2MP7l
	62Lk5JAQMJH4cuImaxcjF4eQwA5Giam9V9ggnE+MEptWrWWBcL4xSuy+cpMdpqW/+x9U1V5G
	iYeT/jJCOD8ZJXasbwbKcHCwCKhKzFkWANLAJqAtcX/7BjYQW0RATWLnqllg+5gFljNLbO6/
	yQKSEBYIl+j79wqsiFfAXmLW70usELagxMmZT8BqOAWsJX51tIBdISqgLHFg23EmkEESAms5
	JPY8WAB1novE3zmLWCBsYYlXx7dAxaUkXva3Qdn5Ej9P3mKFsAskPn35AFVvLPHu5nOwOLNA
	psSUlr/MIM9IAC07cosFIswn0XH4LztEmFeio00IolNVouv4B0YIW1ri8JWjzBC2h0TX2sWs
	8CA992gR4wRG+VlIXpuFZBuErSOxYPcntllAK5iBZi3/xwFhakqs36W/gJF1FaNYakFxbnpq
	sVGBMTyyk/NzNzGCk7CW+w7GGW8/6B1iZOJgPMQowcGsJML7fdWmFCHelMTKqtSi/Pii0pzU
	4kOMpsB4msgsJZqcD8wDeSXxhiaWBiZmZobmRqYG5krivPda56YICaQnlqRmp6YWpBbB9DFx
	cEo1MBVGmTHIe7quORto6DTB/pLgqvDGNdFfGhOEEx7wHj3UdMJqfV+8wcGmz7oWNlYJHL0i
	y9LDgvb5f5BtjbqebsQVeLl74vngqas3XNAOmebKsmi6QpmYz+uUY1/6i/Ry7E9nq6zRS+9W
	8f+2jtW2IrDdzdiqbva3C1MeJcrccL8zee0ZjzU/tAXLd3VKb5v4xUQlsve0UPrbmKCNuvOe
	Xwg7OjWxyD1iGfuxk/PLJBfFhxdP+Om4eU7d4qUln/Zt+diQvjRYom5akRW75TZmg+jeg/0u
	u/i37ls9Z3bycUMbK53cs35Z9j+Cg8oVTT89q1O3329ktWrXft0c24fCWz69a71wMt94ukbJ
	dbNlSizFGYmGWsxFxYkA2nOcQ0sEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWy7bCSvG6f6LYUg92ndS3uPr7AZjF96gVG
	ixM3G9ksVt9cw2ix/+lzFotVC6+xWSw+OoPZ4ugeDovzs06xWEyduJ7ZYuWPP6wWtyYcY3Lg
	8Wi99JfNo+XIW1aPxXteMnm82DyT0aNvyypGj6mz6z0+b5ILYI/isklJzcksSy3St0vgynjX
	08Zc8Ji/4vSvOUwNjJd5uhg5OSQETCT6u/+xdTFycQgJ7GaU2Nw0nRUiIS1xr/kKO4QtLHG/
	5QgrRNF3RomWSZeYuxg5OFgEVCXmLAsAqWET0Ja4v30DG4gtIqAmsXPVLLB6ZoH1zBJTvzYy
	giSEBcIl+v69AiviFbCXmPX7EtTQT4wSPSuusUMkBCVOznzCAmIzC2hJ3Pj3kglkGTPQRcv/
	cYCEOQWsJX51tICViwooSxzYdpxpAqPgLCTds5B0z0LoXsDIvIpRMrWgODc9t9iwwCgvtVyv
	ODG3uDQvXS85P3cTIziOtLR2MO5Z9UHvECMTB+MhRgkOZiUR3u+rNqUI8aYkVlalFuXHF5Xm
	pBYfYpTmYFES5/32ujdFSCA9sSQ1OzW1ILUIJsvEwSnVwLRCdu52zZn6ToJV2nmlcr/FTc80
	9ohu1vE2TmjevqO0c5m0axnTOjnj7mUnLNPLlD297nrYalzNeVcYKRPDaLHVj8GpvOfARLtD
	BVKWc8+fzE0N/RGvdvYvj9dNxebdvCc9DFskEv8pZh0wOBy27IHaoUlz7u/SP/1lp4RDo7B6
	xBPRlvWJDk2B+Tvqf85bYRPtVD1p5RehNz5PvS4q35yxb1O60sVXFes533Hc13oZ/q+4eN2y
	Td1CqlVqOisPREmb3nu5op9v1cmzByfblF0VdIx6NclEs/H78gWby9+FqKfYaQdXsDL8my/U
	m2fr0xc597varlNP58i46G5bvmrLafdYecEfmzukPvoeVGIpzkg01GIuKk4EAM2aBe0SAwAA
X-CMS-MailID: 20230718043110epcas2p19410befa3f55c2f1192d0177e88c14a3
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----2j3H-Fw6krGnjZ2m1MtWJM9EKml9p4nros7n7Ewr29Rn8TKb=_10e09c_"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230717062624epcas2p2c5a14cb450b04ccc0ccd2292312d9636
References: <20230717062908.8292-1-jehoon.park@samsung.com>
	<CGME20230717062624epcas2p2c5a14cb450b04ccc0ccd2292312d9636@epcas2p2.samsung.com>
	<20230717062908.8292-2-jehoon.park@samsung.com>
	<f9caa859-0f65-a658-d144-0332cd4f0833@amd.com>

------2j3H-Fw6krGnjZ2m1MtWJM9EKml9p4nros7n7Ewr29Rn8TKb=_10e09c_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Mon, Jul 17, 2023 at 08:18:55AM -0500, Nathan Fontenot wrote:
> On 7/17/23 01:29, Jehoon Park wrote:
> > Update the value of device temperature field when it is not implemented.
> > (CXL 3.0 8.2.9.8.3.1)
> > 
> > Signed-off-by: Jehoon Park <jehoon.park@samsung.com>
> > ---
> >  cxl/json.c        | 2 +-
> >  cxl/lib/private.h | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/cxl/json.c b/cxl/json.c
> > index 9a4b5c7..3661eb9 100644
> > --- a/cxl/json.c
> > +++ b/cxl/json.c
> > @@ -155,7 +155,7 @@ static struct json_object *util_cxl_memdev_health_to_json(
> >  	}
> >  
> >  	field = cxl_cmd_health_info_get_temperature(cmd);
> > -	if (field != 0xffff) {
> > +	if (field != 0x7fff) {
> 
> Should you also update this field check to use CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL
> instead of using 0x7fff directly?
> 
> -Nathan
>

Hi, Nathan

I agree with your suggestion since it is more understandable. However, the
constant macro is defined in "cxl/lib/private.h" which should be included only
under "cxl/lib/" (as I understand properly). To use the macro in json.c,
we have to define it somewhere under "cxl/" e.g. libcxl.h, json.h, ...

I'm not sure about this approach is right, so I followed existing
implementation that used NOT_IMPL value directly.

Jehoon

> >  		jobj = json_object_new_int(field);
> >  		if (jobj)
> >  			json_object_object_add(jhealth, "temperature", jobj);
> > diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> > index d49b560..e92592d 100644
> > --- a/cxl/lib/private.h
> > +++ b/cxl/lib/private.h
> > @@ -324,7 +324,7 @@ struct cxl_cmd_set_partition {
> >  #define CXL_CMD_HEALTH_INFO_EXT_CORRECTED_PERSISTENT_WARNING		(1)
> >  
> >  #define CXL_CMD_HEALTH_INFO_LIFE_USED_NOT_IMPL				0xff
> > -#define CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL			0xffff
> > +#define CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL			0x7fff
> >  
> >  static inline int check_kmod(struct kmod_ctx *kmod_ctx)
> >  {

------2j3H-Fw6krGnjZ2m1MtWJM9EKml9p4nros7n7Ewr29Rn8TKb=_10e09c_
Content-Type: text/plain; charset="utf-8"


------2j3H-Fw6krGnjZ2m1MtWJM9EKml9p4nros7n7Ewr29Rn8TKb=_10e09c_--
