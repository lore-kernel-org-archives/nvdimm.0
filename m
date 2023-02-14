Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA0E2CA6
	for <nvdimm@lists.linux.dev>; Tue, 14 Feb 2023 06:57:08 +0000 (UTC)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
	by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20230214065707usoutp02daac5ac7fa751767e5ea96b9845d1c5b~Dno-ehuhM1999219992usoutp02a;
	Tue, 14 Feb 2023 06:57:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20230214065707usoutp02daac5ac7fa751767e5ea96b9845d1c5b~Dno-ehuhM1999219992usoutp02a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1676357827;
	bh=f0aYirtpGCbdrGcI1B/Q5XaonHuAxu+3fFwOoNKmqys=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=L7qKeZSWC+AMnDuP1VXWdMBV/ihHLzDSTwNyQVL0W04f8ybgFz/dkoB2X1VFwOkTf
	 5PzfPqhlGhEvD/ONhYypSg27Sz3/WPviWwbwv7DEZC+GWQDjZlnP+CIvsvf1PyFlVU
	 Fb2ntIuVdjIXqwy/8OJgdh67NWlOqi8xwSBB26NA=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
	[203.254.195.112]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20230214065706uscas1p1508163355ffa673e7a7ea5eae461ad07~Dno-VkASe0102101021uscas1p1W;
	Tue, 14 Feb 2023 06:57:06 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
	ussmges3new.samsung.com (USCPEMTA) with SMTP id 45.4F.12196.2C03BE36; Tue,
	14 Feb 2023 01:57:06 -0500 (EST)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
	[203.254.195.92]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20230214065705uscas1p16dfd8ec62fdd1ffc75d468b9e491ba81~Dno_FEevs1891118911uscas1p1Y;
	Tue, 14 Feb 2023 06:57:05 +0000 (GMT)
X-AuditID: cbfec370-83dfe70000012fa4-50-63eb30c27d33
Received: from SSI-EX1.ssi.samsung.com ( [105.128.2.145]) by
	ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id FF.65.11346.1C03BE36; Tue,
	14 Feb 2023 01:57:05 -0500 (EST)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
	SSI-EX1.ssi.samsung.com (105.128.2.226) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.1.2375.24; Mon, 13 Feb 2023 22:57:04 -0800
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
	SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Mon,
	13 Feb 2023 22:57:04 -0800
From: Adam Manzanares <a.manzanares@samsung.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, Fan Ni
	<fan.ni@samsung.com>, "dave@stgolabs.net" <dave@stgolabs.net>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] daxctl: Skip over memory failure node status
Thread-Topic: [ndctl PATCH] daxctl: Skip over memory failure node status
Thread-Index: AQHZP/OehnE/B2wTYkm5lOWEJwqLy67OC4oAgAB9u4A=
Date: Tue, 14 Feb 2023 06:57:04 +0000
Message-ID: <20230214065653.GA437651@bgt-140510-bm01>
In-Reply-To: <63eac7427d994_27392429460@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DA92A76EC414124295E55F63C007390B@ssi.samsung.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sd0xTURTGve+9to+a6rU29CiJg6AhUitDY+NONLHRxEGMGKNohWcZpWCf
	KI5INS5ALaiIlCqiiJbhwGgQkNDKUEDEhVrjwAVYjYoahhX08WrS/37nO+s7N5cmpWbBaDpa
	v5kx6DU6X6GYulH3q3myPdAZEdjZG6zKymxBqqLnxUh139xAqaw9LoHKkV5HzBOoz1V2EuqO
	a9lInZmTrP5ROmYZtVo8K5LRRW9hDFPmrBdH5RfWCBNeCpPanKmUEd0UpCIvGvBUePXRSqUi
	MS3FVgTt3x4I+GAfAfml1UQqogerntT78HoJgnefXSI+6ELw9MYRkhslxQUI9pTs4liIA+F3
	/dVBXYYDIMNiI7kGEn9HcMBmoripI/FCyM1Q8jVqOLHbKOBkGZ4Bp6+v4WQKT4CmB/UijiV4
	GrQX2RHHXngR1PafoDhG2Bu6G4oJjkksB8f7XIK/bASczakkefaG/vI2Ic/j4XV3p4ivV8CZ
	ii4hz3PAevWTe04AFOQ5SX7vCLib/Z7ie0eB7eKzwdcCfIeGLFO6iE8sgKqPJvdiH8gqfuRu
	iIfy/Y/dJpLgiTPNbWIm5LkuE+nIz+zh2+zhyezhyezhyezh6QwSFCJ5IsvGaRk2RM9sVbKa
	ODZRr1VGxMeVon/fp7H/dkIZcji+K+2IoJEdAU36yiQjP3RESCWRmm3bGUP8OkOijmHtyIem
	fOWSoNl3I6RYq9nMxDJMAmP4nyVor9FGImxHgPCe5UtPVSPYmuctPZddG7RXoQi/5RjnXzbQ
	1S6/E33xTVXRz4EN45oduWlLZqOCraFQnRzcFjO2t9KCL/Qq/A9pv3XgrzV95OQPunWbaobP
	b/W7LXGm17cmb5muy449O/TwEVN0rrZPEltOh7W4lh8kj2lNl8LshebgyAYDnC7vPpB5dGWm
	MVQWbmrdXrAtcVZ1ydph3Z/FS883tePaH4vrHBU9STaZdFJFxng0UTlwKS9GJDXKPklesG+F
	+iFy14xF+4KH/Ak0Wazkb4trfkpOx6orE7+cujV3ekh44/GS12FpeWV7pWUnU1Yo+uQ7yaaQ
	gYcxG1JaKjaKWV+KjdIETSINrOYvgwGM+a0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsWS2cA0Ufegwetkg3fnZCymT73AaLH65hpG
	i/OzTrFYrPzxh9Xi1oRjTA6sHov3vGTyeLF5JqPH1Nn1Hp83yQWwRHHZpKTmZJalFunbJXBl
	LFl1hK3gLlvFw9ddLA2MO1m7GDk4JARMJK4el+5i5OIQEljNKDFr1k1WCOcTo8T7S4fYIJxl
	jBLbdq5g7GLk5GATMJD4fXwjM4gtIqAtMXHOQWaQImaBj4wS7Qf7WUDGCgu4S8yfqAdR4yEx
	rbEBbJuIgJXEvK0xIGEWAVWJMxePs4PYvAKmEs9XH2KE2HWJUeJk9yywXZwCXhJH/01jAbEZ
	BcQkvp9awwRiMwuIS9x6Mh/MlhAQkFiy5zwzhC0q8fLxP1YIW1Hi/veX7BD1OhILdn9ig7Dt
	JFZufAU1R1ti2cLXzBBHCEqcnPmEBaJXUuLgihssE4ABgmTdLCSjZiEZNQvJqFlIRi1gZF3F
	KF5aXJybXlFsnJdarlecmFtcmpeul5yfu4kRGLun/x2O2cF479ZHvUOMTByMhxglOJiVRHiF
	n75IFuJNSaysSi3Kjy8qzUktPsQozcGiJM7rETsxXkggPbEkNTs1tSC1CCbLxMEp1cDk4WaW
	xSh6svTc7WzHOfKPkwv2/O+PEdzq0Zp0y+jyjXjVfCevbRPflFUdZ2NO4nh6Ujg3Nboq6Mah
	dzoOOYZNIVMn9QR9//d0TxlrjcOhY1vvqRgIXJ4mfb2/ze9nvlz9XtvqXFtti3qjvwbX24/E
	rHE2f8itG8XaFfHdPin6nQzzz/2vm9k2Lmvg+rjl2btz99fPrDlibLPQ56DKuVDZNc+2eOSw
	Jv9d2X9/8ws2reNzrnsWLltQZNrqL7Hj3lnpl6ELTll0SHxViN5+8zAfQ+mx8zuadxtb3ZBi
	OeGj0M7lxjR5a8buvSWb1zUcFCu0zEucnRkx9eSZxtV6t89+mnDuwMTKvIf1gmJVKzqVWIoz
	Eg21mIuKEwEDilx5TAMAAA==
X-CMS-MailID: 20230214065705uscas1p16dfd8ec62fdd1ffc75d468b9e491ba81
CMS-TYPE: 301P
X-CMS-RootMailID: 20230213213916uscas1p2ee91a53c14ec5ddcb31322212af6cdaa
References: <CGME20230213213916uscas1p2ee91a53c14ec5ddcb31322212af6cdaa@uscas1p2.samsung.com>
	<20230213213853.436788-1-a.manzanares@samsung.com>
	<63eac7427d994_27392429460@dwillia2-xfh.jf.intel.com.notmuch>

On Mon, Feb 13, 2023 at 03:26:58PM -0800, Dan Williams wrote:
> Adam Manzanares wrote:
> > When trying to match a dax device to a memblock physical address
> > memblock_in_dev will fail if the the phys_index sysfs file does
> > not exist in the memblock. Currently the memory failure directory
> > associated with a node is currently interpreted as a memblock.
> > Skip over the memory_failure directory within the node directory.
>=20
> Oh, interesting, I did not know memory_failure() added entries to sysfs.
> My grep-fu is failing me though... I only found node_init_cache_dev()
> that creates a file named "memory_side_cache" under a node. This fix
> will work for that as well, but I am still curious where the memory
> failure file originates.

I found the issue on next-20230119, I have a suspicion your grep-fu will
work fine there.=20
