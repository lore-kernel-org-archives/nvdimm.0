Received: from fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com [35.158.23.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02E13EB100;
	Tue, 11 Aug 2026 19:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=35.158.23.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786477157; cv=fail; b=Aaj5voHrCZ+q174lkzEJ5MsFiBd85XDhjwNmzPNjLNT038AUrBCv19A/fNXcgZbpho3tqQ5Q0JPn0KpNMKKfAlMIMTk7zPIeXflZAHfIaCFuWyiYfOIrAGeEpyCJkwm7gPzCVoKEK6GWmM+xezQdTuyntgE61sGVGR8TbHal8qo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786477157; c=relaxed/simple;
	bh=clhqFhxe43HjxLrmM70uctPVK8n8jlM4UjOhp2O+SiE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Vp1x8TScOCPTRSmVardlxhli2Y8GkKnJvh1n9bzR5uNVOnl8UuCqJ749MLzleQwgAE9XR8cl8lB3HNdhig9d8xlJPSKHUBjBioTwaJLxMaKw3qn59VJyTlrJI8bLAHIQ7a8ewBSyzOe37J1YC4E1j5Tj2hWj2T5yGWCQOvde2Mo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=qWn+5QP2; arc=fail smtp.client-ip=35.158.23.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="qWn+5QP2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1786477156; x=1818013156;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=clhqFhxe43HjxLrmM70uctPVK8n8jlM4UjOhp2O+SiE=;
  b=qWn+5QP2e9MzDa+8p5mmlBrj5qK+prE7BwcaEOfPCCqQPfD3I5YrDMvv
   0SWZkErGAZQsXUPOLF1i2rjWjhlLZTCm2Kyetg4gAGSKrBLpeRp0yZQV4
   L4FaWRpfALvfP6xky+IXojohV9i8wmN4Mz5F3oZAN5zG12tHS265GsLSW
   64zjnQgEtf3KGcphK3Alz5bRoiF6NJcmoWVgyKOMeu/6yoiBvb15p381G
   72wH6yfDtPsVfKXFwJhfYfRWw4klQT0zKya8MkR69VUM9Ho2L4K6HLiUU
   4FBlQmdSQqS9FU78o0cnUiuD/eTSW4B7qjbAzPu9J+pqpY7S9jkKbQsKS
   Q==;
X-CSE-ConnectionGUID: mUaYkykFR2+OWxeoCvmQxg==
X-CSE-MsgGUID: pgfhdobtSIajdyh3t9weYQ==
X-IronPort-AV: E=Sophos;i="6.25,218,1779148800"; 
   d="scan'208";a="17740146"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2026 19:39:11 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.236:9237]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.5.30:2525] with esmtp (Farcaster)
 id 9c524804-f29f-4650-b1c5-7133a4900679; Tue, 11 Aug 2026 19:39:11 +0000 (UTC)
X-Farcaster-Flow-ID: 9c524804-f29f-4650-b1c5-7133a4900679
Received: from EX19EXOEUA001.ant.amazon.com (10.252.50.110) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Tue, 11 Aug 2026 19:39:11 +0000
Received: from BEUP281CU002.outbound.protection.outlook.com (10.252.50.44) by
 EX19EXOEUA001.ant.amazon.com (10.252.50.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45
 via Frontend Transport; Tue, 11 Aug 2026 19:39:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sPHBiksfcYquggQ24++eNYBCPjQpMS9fGP5w+QU+ODhFeIthZwZvol1N7sUXrttVy97spkyAmB3w9vnb/kA+XJ5lsJ3qCW1nYQRWdRsd22GV7BDkbZsRoZjjkDqwOOPnWUAWkbxyhD6GOZV+EYf13u1bC7M2nnbBn4uAFdg7/H5XTq5/zfPLJMqAfOXzBojpzAe9lDhMOqR3Vt4YLPBYk4G06sWcvccFJbg8bQs1zlzAPhKliQ/kpQS/ID7TZpmc/xZlu42V/jAnM3Q1AhH9p+D68WPcnFC3I8QIkDfh183NpyxVYFPPB3n86ZpSVSEeAVhDE9m2WIdStu3Jvs8xIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=clhqFhxe43HjxLrmM70uctPVK8n8jlM4UjOhp2O+SiE=;
 b=l0sine5eK3O1KgE/BwwOi44vBoxsbf/ZmtLZjcdXNLwpo+TjpcQU1qrvn9lGo6fQH6T5Z7THQVQyq4i4kjU0r7zCw6T/Q91mzCgrOAQoTL4RQdJU8uXWPpz+X+pUYcYFlyzlJLATyTs2UcQejfTEu9ISsN6F+Re5xZvkKz3XYo6Oy000KLGdIgQ2ABDp+wCMO8hJ2r7lLNYxFtEbzqd2nMZPZ76gknLsPEoO/3kkkvIfwg6EpDAHDnZk/bh+aqeZDh7TyK1E6WOh+O3M0pd6X4e+By8hWm4Bm+bIgPnwOkpcGvOgCHUKAi0dQZqeNmynOeERvi6yxYPE7cbntrCj9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.de; dmarc=pass action=none header.from=amazon.de;
 dkim=pass header.d=amazon.de; arc=none
Received: from BE3P281MB6244.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:103::21)
 by FR2P281MB1671.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:8e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Tue, 11 Aug
 2026 19:39:01 +0000
Received: from BE3P281MB6244.DEUP281.PROD.OUTLOOK.COM
 ([fe80::6854:a8a7:80a6:2c71]) by BE3P281MB6244.DEUP281.PROD.OUTLOOK.COM
 ([fe80::6854:a8a7:80a6:2c71%6]) with mapi id 15.21.0315.008; Tue, 11 Aug 2026
 19:39:01 +0000
From: "Graf (AWS), Alexander" <graf@amazon.de>
To: Stefan Hajnoczi <stefanha@redhat.com>
CC: Jason Wang <jasowangio@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>,
	Alex Williamson <alex@shazbot.org>, David Airlie <airlied@redhat.com>,
	"Dmitry Osipenko" <dmitry.osipenko@collabora.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	=?utf-8?B?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>, Feng Liu
	<feliu@nvidia.com>, Gerd Hoffmann <kraxel@redhat.com>, Halil Pasic
	<pasic@linux.ibm.com>, Jens Axboe <axboe@kernel.dk>, Jiri Pirko
	<jiri@resnulli.us>, Jonathan Corbet <corbet@lwn.net>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nh-open-source@amazon.com" <nh-open-source@amazon.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, Pankaj Gupta
	<pankaj.gupta.linux@gmail.com>, "Paolo Bonzini" <pbonzini@redhat.com>, Parav
 Pandit <parav@nvidia.com>, Shuah Khan <skhan@linuxfoundation.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [RFC PATCH 00/12] virtio: support devices that own their
 virtqueue memory
Thread-Topic: [RFC PATCH 00/12] virtio: support devices that own their
 virtqueue memory
Thread-Index: AQHdKCvtDU5a/eUH/0KGzQdKr73+dLaXwDWAgAGBjQA=
Date: Tue, 11 Aug 2026 19:39:01 +0000
Message-ID: <235f84ba-0327-4dd4-8f37-e566bf000656@amazon.com>
References: <20260809182010.32931-1-graf@amazon.com>
 <20260810203901.GA35278@fedora>
In-Reply-To: <20260810203901.GA35278@fedora>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amazon.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BE3P281MB6244:EE_|FR2P281MB1671:EE_
x-ms-office365-filtering-correlation-id: 1e4016fa-f33a-4d70-0a9f-08def7e031c6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info: wiMbNP9qCHwkeBr0vRDuvspNfN4d04hnj30MWvBRN4bpcHuzUG0X/hcCGi8qDPeppuli+vHNFVgyDtLwUhBdNlGaFKJ312+QeDDkJ+4gp3sDsLSlNq0+1/V3O+ufTAHLZUuFi7qY54/iWJ6PRTZeJkveHjU0viFh5VanTKLotxBi808kbT6KLtSXf0lcMn0WQY7TQNF3UeBIZNVwaQyeTJFH3pDY1tFrIp+oMkoqSUWLPdM/NDY8W4+d4OS8HKpf5O6+yjBbY0GcZCekp069LzWKxY/LNlBgydNsjQ0IRLDC5eTG78dzGlbhqqKXEj0pGrdo+kcq5/Dymfpp6uel3ijClBBkAKU3PGgWpXSNFioZCav4nKWs3Sx5hjr8oOIFqkiLMnQlCKfsxZJu8YHO/AVq9jliAR9V2vwVv3Qb7im2gV6VwSBEB2We0XHDr00I1W5COGJL8Y+R+Mk3ghzC+RB6l2lSXUTedQfRDqAyzJxRmhDiRIMRtj/8yY2u89m/KUZlFjisZJMd6fiVT3LxDRwsatoWfY754/5nI+tc8vV3eM5DexuEYDEnh/WmSMqFRrgEDXcg3x1HaQKvPF/9vuTRXDgKccn3gMNR9iP8eX6Qtca4LWXW6B8O1C3/DKOKPOmYMF3jCteDK5xfW32O7XxRZ+gcGl2CIFzfEO68zxw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BE3P281MB6244.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZHZkclQ3TDYxWFdqaTlsNW1HWldsR2VHdUUrVHd2ZFVZRlZWL3phVHh5THZt?=
 =?utf-8?B?VktIaTFMa1BKcW55YjRDNlA5NkpaMzdwaXdqbTlSRHUzTlNjTVdqWlRoOThj?=
 =?utf-8?B?SEExVzhIandEZDZkZE9MWSsrR0lyQVUvNGVHU3RiS3ZoQkhqZFdjMWxRUHVV?=
 =?utf-8?B?TmFWV0Q0STQrdm1ac0JRMzhiaW5NR2dpWnp1VDBLa00wdisrR2p3SmhhdlFz?=
 =?utf-8?B?dlR5MnJoK3hUK1JXMnNWVUZlTGFRTkkvYXpEWnFRZ1dxZzVIK2M2dlRLTmdZ?=
 =?utf-8?B?a2l1b2pnSWk1OEZod1p3VEZiRm1zQWZNeHBDMzYzNVAveUdQZnpDd3l1d1hO?=
 =?utf-8?B?cWZVdU1rV1JObEUvK3Q4QkZsZ3VmdFhoUEhPUFNucjBDMGxsK0Q1ZmdSZFdI?=
 =?utf-8?B?c0RpWVlRS2xaamRDaENHdXRLYWRmdXhPbmp0Z0FWK3BlK0N6S21PZUI3aXlu?=
 =?utf-8?B?WEZFUlpMd1F4NkZTanlWRm9Jd25XU09ZS3JZSmlMYXBycENFNlUyVkNqZWJa?=
 =?utf-8?B?RjRlLzBOSzJZZ2JyeEhGU0p3K1g4VUZwVjI5SERoaVBCcFFyV1FNSGZzYWli?=
 =?utf-8?B?S05ULzNxU2tHNTR1bTRvTmJZbGtjK0QyMks0RTNvT0xiMmhaS08vanR5L2ZO?=
 =?utf-8?B?QUFObkxPZjhoaEIzN2xsaVNzY3VDUmphaGF3QkJ0ZjQyUFdURXYwNTB6NktX?=
 =?utf-8?B?MFkva3U5Nk9DK1A3S0xxazd2OS9XNWJzT1Z2Ulc3RGdCN0o0bk5KSGw2dmVn?=
 =?utf-8?B?MTNubEd6UGxoNjk1a29XcTJmV0k4MWo3UExiWFpLazM4OFlUSzNLaklpb0l1?=
 =?utf-8?B?NE0vdnFORnBKVzFGYTJWbEJJaDEwUXZnWmgrTjZ6TGM3QU1OOEtFMnFYWEYy?=
 =?utf-8?B?SSthRFN5dFNHQzZjRnA4SWh2NFpIRTI5T2tUcVFpeWszcmNGRFdkSUlBMXdm?=
 =?utf-8?B?ZGEzN29tTUV1Z0FvbnE5MStHS3Fkdm1xbkdOQ1hJY2kvTFBuR3RiYnBsdmtJ?=
 =?utf-8?B?Ti9YOXRZejJqNGsvVHJwT0VTTndCaEtEdWpCN1NCcFJpbUh4V0JWR205bVlV?=
 =?utf-8?B?SDFGMWVTNm1RTi9kZjk4UlBTWGNBU3ZObkpZSEFIRmNjc3RrdTMxNGEwTExr?=
 =?utf-8?B?czhwaXVMTDFZRlM3N3MyQzk5SkRYZEw3WEFDTUgwM3gvaHVtZWdnSCsxdVJq?=
 =?utf-8?B?WVpWZUtTZUhIc1BjVDdMbHB0L0NtUXNrdDdIVkIxRG5lTnZNdnhqbGU3eHhq?=
 =?utf-8?B?OGNORG13emx4em1ma1JhemRLZ2VoSFg3c2dvNXc5RTNJYXBpY0JsQ2Jlc3lw?=
 =?utf-8?B?SFdOWjdwNEZBMXEzOFpjck1OT3d2ZFlwNkRiTVR6SDYvQ2FrczN2cTZ3R3Zm?=
 =?utf-8?B?NHdkK3l5WEVvTSs2RjZUT3dCckVPb2Fld1VMVnZIbHNPaFBERGVPWk9scVFk?=
 =?utf-8?B?NkxMUkFhSkJQaGdHSTI4a09qT1RFZkQ4V2NqQnZDS1ppSEZidkM1S0FWamQ5?=
 =?utf-8?B?TlVlRFUzbHdvcFFzVEN3N21sSGt0WkJ5ZnV2QkREV0VoV290WTRFRmcxY1p1?=
 =?utf-8?B?Y2NxeXNWcFpVYklYdjI3Q0w0NWM3TDNJODVFZ0hMUGFTTzRtd3pSZkxqWm8x?=
 =?utf-8?B?a0JsRXEwTTlPS0JoMjRxSmx6Z3NkSjhKZTJlamdHNlBQZ0UxZDg1TnJhOXM3?=
 =?utf-8?B?Mk5BVFViSlB0dW9WbVBNc1l1NGd3R3JxbUpUVWZialRHSCtBWUNmd3BZQmxO?=
 =?utf-8?B?YnBJbWZXRTRkUDg0dmpCNFIybjNlbEFNVkljemRYRTZVa2tIT090K0Z4TjMr?=
 =?utf-8?B?bW9OWjF3UHR2aEhISy9DSHl0eFJBZkNGUVluTHd2N0I0MUU0dWNBNHM5TDNP?=
 =?utf-8?B?RUZ3bEtpbmtuUVZDTXF4dEY3VnhVMzl0REkyTG9WOEZ5cmxmZXBGSGwrZEVF?=
 =?utf-8?B?MU9HdExRQjNFYys5Nkx0SU44RDZzUHR4OS9UUUtvVlo2MWtCcEhaM0RvYUpZ?=
 =?utf-8?B?QVR2bDU2ZkR0TDNFeTVzRFBOQUl0Ymd4RW5iNVZBSEVvWEYvdGhCaEM4YUdz?=
 =?utf-8?B?NWRMVkE1UCtGaXcrZ0VGVFJjL2ZLaTVpZnhUQXRHT1JhazlqS1VaaElWZHZF?=
 =?utf-8?B?alg0c0xXYjRybkg4UFROWVZLYU1OWFNoWXFEbjk5aEFEOTZmY3dWdHJRV0xX?=
 =?utf-8?B?UksrN0xNczRGTnNvYnhJQjVveERsT090NzBiUnVjejlkL280dVRObnM4em04?=
 =?utf-8?Q?4mRm/IOIrOozymEFDE+eIXPDSc7Mz27VQyL1cimelU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E09010C422A0D841893AD23F8CDD35BD@DEUP281.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: RajQSfP/AXkYKmVAj6RcvApir/SQTW1U4RIaQp06OuMZetZC8FSEl3IUYFb0PF5y4dSULbFX+6MKpkOa2s+50cTnHihQYkb4cr//sgIMWdv8Lp1UTzKBLGt4CjjVr1qxzXGZZbugIDj9naU587C376UAcbakDCS90530rryEUrFpX6wUGVMBfGaG+qnaqzC2I9zeD6eGTO6bJ8jKYjaXxY4oayT/PYJs0kOrdJQYZTg0ABnFU8TyYZAUGhQxmyoaEkWQ9xs5C0jGg+PGKk23nBN8EYWnvO1o8cJbvYWEWyiRzwKN0QzJLNM1DFqmzFG0iS3BYPhhO18uoRzEOcH1Gg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BE3P281MB6244.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e4016fa-f33a-4d70-0a9f-08def7e031c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2026 19:39:01.2393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CcvW4ppFK++JUT42wOdDo7l0KNGlgrd77+4VwCQ6qN0vbq/J86pFtIWB5HFit/Rw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR2P281MB1671
X-OriginatorOrg: amazon.de

DQpPbiAxMC4wOC4yNiAyMjozOSwgU3RlZmFuIEhham5vY3ppIHdyb3RlOg0KPiBPbiBTdW4sIEF1
ZyAwOSwgMjAyNiBhdCAwNjoxOTo1OFBNICswMDAwLCBBbGV4YW5kZXIgR3JhZiB3cm90ZToNCj4+
IFZpcnRpbyBkcml2ZXJzIHVzZSBndWVzdCBtZW1vcnkgdG8gYmFjayB2aXJ0cXVldWVzIGFuZCB0
aGVpciBidWZmZXJzLg0KPj4gVGhhdCBtZWFucyBhIFZNTSBuZWVkcyB0byBiZSBhYmxlIHRvIG1h
cCBndWVzdCBtZW1vcnkuIFRoYXQgaXMgb2sgaW4gdGhlDQo+PiBub3JtYWwgdmlydCBjYXNlLiBJ
dCBnZXRzIGlja3kgd2l0aCBjb25maWRlbnRpYWwgY29tcHV0aW5nICh3aGVyZSB3ZSB1c2UNCj4+
IHN3aW90bGIgYXMgd29ya2Fyb3VuZCkgYW5kIGl0IGRlZmVhdHMgdGhlIHB1cnBvc2Ugb2YgaXNv
bGF0ZWQgdmhvc3QtdXNlcg0KPj4gYmFja2luZyBkZXZpY2VzLCBiZWNhdXNlIHRoZXkgZW5kIHVw
IHdpdGggZnVsbCBSQU0gYWNjZXNzIHRvIHRoZSBndWVzdC4NCj4+DQo+PiBTbyBpbnN0ZWFkLCBJ
J20gcHJvcG9zaW5nIGFuIGV4dGVuc2lvbiB0byB2aXJ0aW8gd2hpY2ggYWxsb3dzIGl0IHRvIGdp
dmUNCj4+IGVhY2ggdmlydGlvIGRldmljZSBpdHMgb3duIGRlZGljYXRlZCBtZW1vcnkgcmVnaW9u
IHRvIGNvbW11bmljYXRlIHdpdGggdGhlDQo+PiBob3N0LCBjYWxsZWQgRE1CIChEZXZpY2UgTWVt
b3J5IEJ1ZmZlcikuIEEgdHJ1c3RlZCBoeXBlcnZpc29yIGNhbiBmb3JjZQ0KPj4gRE1CIHRvIGJl
IHByZXNlbnQsIHdoaWNoIHRoZW4gZW5hYmxlcyBzYWZlciwgbW9yZSBpc29sYXRlZCBhbmQgcmVz
aWxpZW50DQo+PiBjb21tdW5pY2F0aW9uIGJldHdlZW4gZ3Vlc3QgYW5kIGhvc3QuDQo+Pg0KPj4g
V2l0aCBETUIsIHRoZSBkZXZpY2UgcHJvdmlkZXMgYSBzaGFyZWQgbWVtb3J5IHJlZ2lvbiB0aGF0
IGJvdGggcGFydGllcw0KPj4gYWdyZWUgaXMgdGhlIGZ1bGwgbWVtb3J5IG1hcCBib3RoIGhhdmUg
YWNjZXNzIHRvLiBBbGwgbWVtb3J5IG9mZnNldHMNCj4+IHRoYXQgcHJldmlvdXNseSB3b3VsZCBo
YXZlIGJlZW4gaW50byBndWVzdCBSQU0sIGFyZSB0aGVuIG9mZnNldHMgaW50bw0KPj4gdGhpcyBz
aGFyZWQgbWVtb3J5IGJ1ZmZlciByZWdpb24uIE9uZSBuaWNlIHByb3BlcnR5IG9mIHRoaXMgaXMg
dGhhdCBpdA0KPj4gaXMgYSBnZW5lcmljIG1lY2hhbmlzbSBpbiB0aGUgdmlydGlvIHRyYW5zcG9y
dCBsYXllciwgc28gaGlnaGVyIGxldmVsDQo+PiBkcml2ZXJzIHdvcmsgdW5tb2RpZmllZC4NCj4g
VGhpcyBpcyBzaW1pbGFyIHRvIFZJUlRJTydzIFNoYXJlZCBNZW1vcnkgUmVnaW9ucy4gQSBwcm9i
bGVtIHdpdGggdGhpcw0KPiBraW5kIG9mIGFwcHJvYWNoIGlzIHRoYXQgZ3Vlc3Qgc29mdHdhcmUg
dGhhdCBkZXBlbmRzIG9uIHplcm8tY29weSwNCj4gT19ESVJFQ1QsIHRoZSBhYmlsaXR5IHRvIG1t
YXAsIGV0YyBtYXkgYnJlYWsgd2hlbiBwYXNzaW5nIGFuIGFkZHJlc3MNCj4gZnJvbSBvbmUgZGV2
aWNlIHRvIGFub3RoZXIgZGV2aWNlLg0KPg0KPiBGb3IgZXhhbXBsZSwgYSBndWVzdCB1c2Vyc3Bh
Y2UgYXBwbGljYXRpb24gd3JpdGluZyB0byBhIHZpcnRpby1ibGsNCj4gZGV2aWNlIHdpdGggT19E
SVJFQ1QgY2FuIHBhc3MgYW55IHNvdXJjZSBtZW1vcnkgYnVmZmVyLiBPbmUgVklSVElPDQo+IGRl
dmljZSB3aWxsIGJlIHVuYWJsZSB0byBhZGRyZXNzIGFub3RoZXIgVklSVElPIGRldmljZSdzIERN
Qi4gVGhpcw0KPiBwcm9ibGVtIGFsc28gZXh0ZW5kcyB0byB2aG9zdC11c2VyIHdoZXJlIG9uZSBi
YWNrLWVuZCBjYW5ub3QgYWNjZXNzDQo+IGFub3RoZXIgYmFjay1lbmQncyBETUIgb3IgU2hhcmVk
IE1lbW9yeSBSZWdpb25zLg0KPg0KPiBNYXliZSB5b3VyIHVzZSBjYXNlIHdpbGwgbmV2ZXIgaGl0
IHRoaXMgcHJvYmxlbSBiZWNhdXNlIHlvdSBjYW4gcmVseSBvbg0KPiB0aGUgZ3Vlc3Qgc29mdHdh
cmUgbmV2ZXIgdG8gYXNzdW1lIHplcm8tY29weS9PX0RJUkVDVC9ldGMgd29ya3MuDQo+IHZpcnRp
b2ZzIGhpdCBpdCB3aXRoIGl0cyBEQVggU2hhcmVkIE1lbW9yeSBSZWdpb25zLg0KDQoNClZpcnRp
b2ZzIGlzIGEgYml0IHRyaWNraWVyLiBJdCBhc3N1bWVzIHJldmVyc2UgbWFwcGluZyBvcmRlciAo
aG9zdCBtYXBzIA0KbWVtb3J5IGludG8gZ3Vlc3QgYWRkcmVzcyBzcGFjZSdzIFNITSByZWdpb24p
IHdoaWNoIGlzIHNvbWV0aGluZyBJJ20gbm90IA0KbG9va2luZyB0byBzdXBwb3J0LiBUaGUgbWFp
biByZWFzb24geW91IGRpZCBydW4gaW50byBpdCBpcyBiZWNhdXNlIHRoZSANCnBhZ2UgY2FjaGUg
aXMgYWN0dWFsbHkgaW1wbGVtZW50ZWQgYnkgdGhlIFNITSByZWdpb24sIHNvIExpbnV4IA0KKHJp
Z2h0ZnVsbHkpIGFzc3VtZXMgdGhhdCBpdCBoYXMgZGlyZWN0IGFjY2VzcyB0byBpdC4NCg0KRm9y
IG5vcm1hbCB2aXJ0aW8gZGV2aWNlIG9wZXJhdGlvbnMgKGxpa2UgT19ESVJFQ1Qgb24gdmlydGlv
LWJsayksIEkgYW0gDQpub3Qgc3VyZSB3aGV0aGVyIHdlIGNhbiBldmVyIHJ1biBpbnRvIGEgY2Fz
ZSB3aGVyZSBhbnl0aGluZyBpbiB0aGUgDQpkcml2ZXIgYXNzdW1lcyB0aGF0IGJvdGggZGV2aWNl
cyBzaGFyZSB0aGUgc2FtZSBJT1ZBIHNwYWNlLiBUaGFua3MgYSBsb3QgDQpmb3IgdGhlIGhlYWRz
LXVwIHRob3VnaCwgSSdsbCB0YWtlIGEgZGVlcGVyIGxvb2sgdG8gbWFrZSBzdXJlIHRoYXQgdGhp
cyANCmlzIHRoZSBjYXNlLiBCdXQgZXZlbiBpZiBpdCBpcywgSU1ITyB3ZSBjYW4gY29uc2lkZXIg
aXQgYSBndWVzdCBidWcgYW5kIA0KZml4IGl0IGluIHRoZSBndWVzdCBjb2RlIHdoZW4gRE1CIGlz
IGFjdGl2ZS4NCg0KDQo+IEknbSBtZW50aW9uZWQgaXQgaW4gY2FzZSB0aGlzIGlzIHNvbWV0aGlu
ZyB5b3Ugd2FudCB0byB0aGluayBhYm91dA0KPiBiZWZvcmUgZGVwbG95aW5nIHRoaXMgYXBwcm9h
Y2guDQo+DQo+PiBJIHdhcyBleHBsb3JpbmcgdG8gdXNlIHN3aW90bGIgaW5zdGVhZCB0byBjcmVh
dGUgaW5kaXZpZHVhbCBwb29scy4gQnV0DQo+PiB0aGF0IGFwcHJvYWNoIGhhcyBtdWx0aXBsZSBk
b3duc2lkZXM6DQo+Pg0KPj4gMS4gU3dpb3RsYiBpcyBhbiBPUyBwcmltaXRpdmUgd2hpY2ggaXMg
bm90IGF2YWlsYWJsZSBpbiBhbGwgT3BlcmF0aW5nDQo+PiBTeXN0ZW1zLiBETUIgaG93ZXZlciBs
aXZlcyBpbiB0aGUgdmlydGlvIHRyYW5zcG9ydCBsYXllciwgd2hpY2ggbWVhbnMgd2UNCj4+IGNh
biBhZGQgc3VwcG9ydCBmb3IgaXQgaW4gYW55IE9TIGluZGVwZW5kZW50IG9mIGdlbmVyaWMgbGF5
ZXJzLiBUaGlzDQo+PiBoZWxwcyB3aXRoIFdpbmRvd3Mgc3VwcG9ydC4NCj4+DQo+PiAyLiBXZSBt
dW5nZSBETUEgc3BhY2UgdG9nZXRoZXIuIERNQiBwcm92aWRlcyBhIHNlcGFyYXRlIERNQSBzcGFj
ZSBwZXINCj4+IHZpcnRpbyBkZXZpY2UuIFRoaXMgbWVhbnMgd2UgY2FuIGZvciBleGFtcGxlIGlt
cGxlbWVudCBhIGRldmljZSBpbg0KPj4gdmhvc3QtdXNlciBhbmQgZ2l2ZSB0aGUgaW1wbGVtZW50
aW5nIHByb2Nlc3Mgb25seSB2aXNpYmlsaXR5IHRvIHRoZSBETUINCj4+IHJlZ2lvbiwgbm90IGFs
bCBvZiBndWVzdCBtZW1vcnkuIFRoYXQgcmVkdWNlcyB0aGUgZXhwb3N1cmUgdGhlDQo+PiB2aG9z
dC11c2VyIHByb3ZpZGVyIGhhcywgaW1wcm92aW5nIHNlY3VyaXR5Lg0KPiBDb25ub3IgS2l0ZSBp
cyB3b3JraW5nIG9uIGEgZGlmZmVyZW50IGFwcHJvYWNoIGZvciB2aG9zdC11c2VyIG1lbW9yeQ0K
PiBpc29sYXRpb24gaGVyZToNCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvcWVtdS1kZXZlbC8y
MDI2MDcyMy12aG9zdC11c2VyLWlzb2xhdGVkLW1lbW9yeS12MS0wLTZiOTdjNDM5ZWIyOEBnbWFp
bC5jb20vVC8jdA0KPg0KPiBJdCBpbnZvbHZlcyBhIGJvdW5jZSBidWZmZXIgYXQgdGhlIFZNTSBs
ZXZlbC4gVW5tb2RpZmllZCB2aG9zdC11c2VyDQo+IGJhY2stZW5kcyBuZXZlciBzZWVzIGd1ZXN0
IFJBTS4gR3Vlc3QgZHJpdmVycyBhcmUgYWxzbyB1bm1vZGlmaWVkLiBUaGUNCj4gY29zdCBvZiBk
b2luZyB0aGlzIGlzIHRoYXQgdGhlIFZNTSBoYXMgdG8gaW50ZXJjZXB0IGtpY2sgYW5kIGNhbGwN
Cj4gZXZlbnRmZHMgaW4gb3JkZXIgdG8gY29weSBiZXR3ZWVuIHRoZSBib3VuY2UgYnVmZmVyIGFu
ZCBndWVzdCBSQU0uDQo+DQo+IEkgZG9uJ3Qgc2VlIERNQiBvciB2aG9zdC11c2VyIG1lbW9yeSBp
c29sYXRpb24gYXMgY29uZmxpY3RpbmcgZmVhdHVyZXMuDQo+IFRoZXJlIGNhbiBiZSB0d28gd2F5
cyBvZiBzb2x2aW5nIHRoZSBzYW1lIHByb2JsZW0gd2l0aCBkaWZmZXJlbnQNCj4gdHJhZGUtb2Zm
cy4gSSBqdXN0IHdhbnRlZCB0byBzaGFyZSBhIGxpbmsgdG8gQ29ubm9yJ3Mgb25nb2luZyB3b3Jr
Lg0KDQoNClRoYW5rcyBhIGJ1bmNoIDopLiBNeSBkZXNpZ24gbW90aXZhdGlvbiBpcyBhIGJpdCBk
aWZmZXJlbnQsIGJ1dCBpdCdzIA0KZ3JlYXQgdG8gc2VlIG1vcmUgcGVvcGxlIGludGVyZXN0ZWQg
aW4gaXNvbGF0aW9uIQ0KDQoNCkFsZXgNCg==
