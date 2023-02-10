Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29746624
	for <nvdimm@lists.linux.dev>; Fri, 10 Feb 2023 01:23:16 +0000 (UTC)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
	by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20230210011551usoutp02f32f0d41bd84e46a00829cb1f175bcd2~CUZ5FaOtd0197901979usoutp02e;
	Fri, 10 Feb 2023 01:15:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20230210011551usoutp02f32f0d41bd84e46a00829cb1f175bcd2~CUZ5FaOtd0197901979usoutp02e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1675991751;
	bh=AbQR1VY9QdqIcFLz+i+cMgqouNzFZZoubVyXb1a9rbg=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=nR5+Ha9jMGB6fJYvEv/jovxK5zshfaUuVw68RTzlAdhUKlGJ/+6Ofo0C62jD0Pa3C
	 Eb/N1B8EFW4Nlf6ftM1TNk5JL7w8wn5fEdJRLf72IZSPjT8bxdTduSG4cXXhFvdH3/
	 jmity0AJUty/4fGfbnmGPCj09lg/TpwpTDT88P2c=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
	[203.254.195.109]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20230210011550uscas1p20dac8c01f88dea79481ad0bcc27aa596~CUZ4LlHi_2964629646uscas1p2W;
	Fri, 10 Feb 2023 01:15:50 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
	ussmges1new.samsung.com (USCPEMTA) with SMTP id EB.14.06976.6CA95E36; Thu, 
	9 Feb 2023 20:15:50 -0500 (EST)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
	[203.254.195.92]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20230210011549uscas1p22e24988115febfcd61d10e8036eb427e~CUZ3TBC8J1558415584uscas1p2y;
	Fri, 10 Feb 2023 01:15:49 +0000 (GMT)
X-AuditID: cbfec36d-afdff70000011b40-40-63e59ac6cdfc
Received: from SSI-EX1.ssi.samsung.com ( [105.128.2.146]) by
	ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id EF.41.11346.5CA95E36; Thu, 
	9 Feb 2023 20:15:49 -0500 (EST)
Received: from SSI-EX2.ssi.samsung.com (105.128.2.227) by
	SSI-EX1.ssi.samsung.com (105.128.2.226) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.1.2375.24; Thu, 9 Feb 2023 17:15:48 -0800
Received: from SSI-EX2.ssi.samsung.com ([105.128.2.227]) by
	SSI-EX2.ssi.samsung.com ([105.128.2.227]) with mapi id 15.01.2375.024; Thu,
	9 Feb 2023 17:15:48 -0800
From: Fan Ni <fan.ni@samsung.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
	"gregory.price@memverge.com" <gregory.price@memverge.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"Jonathan.Cameron@Huawei.com" <Jonathan.Cameron@Huawei.com>,
	"dave@stgolabs.net" <dave@stgolabs.net>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 3/7] cxl: add core plumbing for creation of ram
 regions
Thread-Topic: [PATCH ndctl 3/7] cxl: add core plumbing for creation of ram
	regions
Thread-Index: AQHZPOuUxRarl1GRc0+x0qZV9Jxml67H5UQAgAABZgA=
Date: Fri, 10 Feb 2023 01:15:48 +0000
Message-ID: <20230210011534.GA902201@bgt-140510-bm03>
In-Reply-To: <4bfa274f616bc6167439d5a822b60bf4c7121f0e.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <6E42BBA7EF3EBB46A424B8E3AA4FB87B@ssi.samsung.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsWy7djX87rHZj1NNnj4X9Zi+tQLjBarb65h
	tGhoesRisWrhNTaL87NOsVis/PGH1eLWhGNMDuweLUfesnos3vOSyePF5pmMHhs//mf3mDq7
	3uPzJrkAtigum5TUnMyy1CJ9uwSujP49z9gKWrgqTpxuZm9g/MzexcjBISFgIvG1s6CLkZND
	SGAlo8SrK2JdjFxAdiuTxPXnn1lhavZeF4WIr2WU2HV0GyuE85FR4t6JThYIZymjxMxHM5lA
	RrEJKErs69rOBmKLCBhIbJ+1lhGkiFngOJPE22PzwRLCAsESnyfOZ4QoCpF48/8pO4RtJbGu
	5wQriM0ioCpxdMElMJtXwFSi8/9DFhCbU8BdYsIpiF5GATGJ76fWgC1mFhCXuPVkPpgtISAo
	sWj2HmYIW0zi366HbBC2osT97y/ZIer1JG5MncIGYdtJnH98kQXC1pZYtvA1M8ReQYmTM5+w
	QPRKShxccQPsYwmBFxwSO1tnMEIkXCQmX+tjh7ClJaavucwCCbtkiVUfuSDCORLzl2yBmmMt
	sfDPeqYJjCqzkJw9C8lJs5CcNAvJSbOQnLSAkXUVo3hpcXFuemqxYV5quV5xYm5xaV66XnJ+
	7iZGYJI6/e9w7g7GHbc+6h1iZOJgPMQowcGsJML7feLjZCHelMTKqtSi/Pii0pzU4kOM0hws
	SuK8hrYnk4UE0hNLUrNTUwtSi2CyTBycUg1MrbnpicZdySafXsgnL31xQ+nH2ufiZxcf43L7
	cnyZb9rmb1Ma4935PY/l1DakNf1OLIq6uXqv8r3Eq6vYl/maprwLEz/0f9Mjpm/Nmdev3/Hx
	+jmJidNE1SOu2L3r4byIz2v+5fvERkxTdJ95K6zRpcCIu+DbLMWiB42GF0+G/Pr9KPbCRUX1
	+n3mfo5law8HXxGM1WhdtuKWadHcnD0LwkNkL/zrTz+T3p55V/qh7EbR2cyn2vyO2KjHFbhx
	qL0NUK/9t1XEb1NqWvmJj3/lY1i3+/XsUXvrkex3jK+/N8PYM7kut/pdauKOfXZ1rk6Mi38/
	lj46wf1y2+SshLYY1Rnm3Rcf3a6w33vi6nMlluKMREMt5qLiRABNqBhRwQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsWS2cA0SfforKfJBoumKVpMn3qB0WL1zTWM
	Fg1Nj1gsVi28xmZxftYpFouVP/6wWtyacIzJgd2j5chbVo/Fe14yebzYPJPRY+PH/+weU2fX
	e3zeJBfAFsVlk5Kak1mWWqRvl8CV0b/nGVtBC1fFidPN7A2Mn9m7GDk4JARMJPZeF+1i5OIQ
	EljNKPFn+nc2COcjo8TZzj9QzlJGicMfe1i7GDk52AQUJfZ1bWcDsUUEDCS2z1rLCFLELHCU
	SWLOpk0sIAlhgWCJzxPnM4KsEBEIkdj23wii3kpiXc8JsDksAqoSRxdcArN5BUwlOv8/ZIFY
	doBJYum0p4wgCU4Bd4kJp+aD2YwCYhLfT61hArGZBcQlbj2ZD2ZLCAhILNlznhnCFpV4+fgf
	K4StKHH/+0t2iHo9iRtTp7BB2HYS5x9fZIGwtSWWLXzNDHGEoMTJmU9YIHolJQ6uuMEygVFi
	FpJ1s5CMmoVk1Cwko2YhGbWAkXUVo3hpcXFuekWxcV5quV5xYm5xaV66XnJ+7iZGYJSf/nc4
	ZgfjvVsf9Q4xMnEwHmKU4GBWEuH9PvFxshBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFej9iJ8UIC
	6YklqdmpqQWpRTBZJg5OqQamFW2TZgnVHtl4f80szknxR1l0bt+aM3fH1QWbzn2a+36uyMwH
	MVNtkjuE9oc/Z5nbkDP/q1Ka7Ktbs+1mvDsZvmzPg4nPe39lvFjbfNZ4g87n182u4cfPcBTl
	dAX+iDYz1Yjij9y0JrNHs7fKWOpr/x2XiaaT1xfUlP/n51GJ3BJxcdWkY4vFWz7afz+xs4HN
	cFruk7/ZEceur0taKJSfpc33b5L2Lbsn7x91v/4sJLl6ffJdg/VHgh3/XPjVJvLz45NmxSe6
	hy/yxh4WeZld67Tjc2b7sYcvl2fWPHvVuOuB+fOQc4GtWwvfbfBS0uD8M32G+0oek4XTuRkF
	OSJWVhhfmWUcuqTl3QRzte4LTU+UWIozEg21mIuKEwFRvMhTYQMAAA==
X-CMS-MailID: 20230210011549uscas1p22e24988115febfcd61d10e8036eb427e
CMS-TYPE: 301P
X-CMS-RootMailID: 20230210010415uscas1p1211243c08bc794b314f7b20bdad93267
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
	<20230120-vv-volatile-regions-v1-3-b42b21ee8d0b@intel.com>
	<CGME20230210010415uscas1p1211243c08bc794b314f7b20bdad93267@uscas1p1.samsung.com>
	<20230210010409.GB883957@bgt-140510-bm03>
	<4bfa274f616bc6167439d5a822b60bf4c7121f0e.camel@intel.com>

On Fri, Feb 10, 2023 at 01:10:44AM +0000, Verma, Vishal L wrote:

> On Fri, 2023-02-10 at 01:04 +0000, Fan Ni wrote:
> > On Tue, Feb 07, 2023 at 12:16:29PM -0700, Vishal Verma wrote:
> > > Add support in libcxl to create ram regions through a new
> > > cxl_decoder_create_ram_region() API, which works similarly to its pme=
m
> > > sibling.
> > >=20
> > > Enable ram region creation in cxl-cli, with the only differences from
> > > the pmem flow being:
> > > =A0 1/ Use the above create_ram_region API, and
> > > =A0 2/ Elide setting the UUID, since ram regions don't have one
> > >=20
> > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> >=20
> > Reviewed-by: Fan Ni <fan.ni@samsung.com>
>=20
> Hi Fan,
>=20
> Would you mind responding on v2 of this series - b4 doesn't want to
> pick up trailers from v1 now that v2 has been sent out.
Ah, almost missed v2. Will response on that. Thanks.
>=20
> >=20
> > One minor thing, there exists some code format inconsistency in
> > cxl/region.c file (not introduced by the patch). For exmaple,
> > the "switch" sometimes is followed with a space but sometime not.
>=20
> Ah thanks, I'll take a look and send separate cleanup patches.
>=20
>=20
> =
