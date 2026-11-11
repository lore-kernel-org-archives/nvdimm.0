Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.38
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794367916;
	b=Fs2UcA84zz/bSxVakPuuhuMUN7Bir7XzuISXFF5TCVKmwXukQ5vRkyvXB/5zITpNocwW
	 n12J/i+ZxBYRw0yhDCq9HLqvLQCJW90F1L07jmPwTQEuTHqVj3/GPWarZ+lJ3C2KbnB8p
	 1Z/0V2/cM0oBn6mbtMh50syYaM7Hz45EijNdYU3dpbC7khQs8ae/8XiLWtW59n/k1Hdjy
	 O16wPFVuXNFkplOtThwi8rSGIDhwwTmk0Bd5rRCJbI3DRgskW67lRGNm51f+gz9B2DjUO
	 FH4V9ddvjK8Dqj6a1v+o8U75twU4r1FYvpIs2a1ssr+GwXNyVPLgGKneIWq3MCuRBdQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794367916;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=kooArh77QB5w+99tLWzmygRpijr+w2tyrJKISw8sgks=;
	b=KOlpD0OqhbTAVbvWIF1gPlhgBITXffycgh4oh5zGPI0WoNaxQ2MK3dbAN1Z+XQ1ZuaxU
	 0NAQAfVl1/CvlY8xtmVblNCwkh3ZROLxA4X3NjrPmcqcSLdvKqCwhgY0MZ+7LVWWvKYlS
	 GVjjS8vFrtuXR4hKbIaEAOBpRNzy2g71LlK0IwGwFw8UXY6kPdDg9IjbSCev3Zjl/7sjL
	 XBQ4Evud53mUVQwZBDNlAlmBHns4sr6MYEQHrXbv28/YqSYpM1li77e1Yh7F3oVXVLeJn
	 ePzrLXoVg+Y+6JMZNEfqzKL4kMAoe7BS8gGXIkbJbC28eN9qwUnCR2ZL3jdNz8om53A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=I9xFrDLB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.38
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010038.outbound.protection.outlook.com [52.101.56.38])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921B5606A31C
	for <nvdimm@lists.linux.dev>; Wed, 11 Nov 2026 03:31:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 921B5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=I9xFrDLB
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TRNdT1zG8qScCNlH+d83uqf5s+OaxXIJ+JvIXaFgYPbkuqjSxSlHTcdtPVO3BL4Y/MOf+zdg8yawyYJgnuZp+LhrCr03khJypwrwHL7e/NYsmx2ScS5L5+l0Eczx5XDBR7TUmHvDzcD6n3hOHMOcJOeAWnEILTQ1Q6LA426QvqgBZFSdTtavGXlS9dyFeM+68Gs3vfZ6JVIFkqG/F6agJ3OalKELe9jzTjf8jdzigzL/QFzk9ygkyv3o6lrJQDLfr0KQ3hIAiIAXLmFnFespshJl6V3AyFb7/W+6YvBYzBhUqNIRKeA4U46Y+cWXJ2zwyMFuYUjLfiKyXjIXgdvLpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kooArh77QB5w+99tLWzmygRpijr+w2tyrJKISw8sgks=;
 b=KGTglWYzrz/xMWettIthg7pAyYrf0qK2lf3HWERNaEWwwk5xMZu2A/JhUMBM1pq+nP8UCQYPSHT2MrzRNvWswYHxs75L1dR2SOEj+zY5vSk6kAH8Mfs7KJcvKVlTTZrBwS1TNoGm0ewb/fN7CP5os+qpnEAsyxViWiYTnz80eDyWxBVRteUgoPkqD5du+9djmakyIgJxp2g2F6+ZRTtv1B6E/tUAeV/Odv+mX6rlUf/xssgpaYLplYwq1YC4ogASzIw8OioXDZ08ejDn32O1UbaTthSuKBxUJJgRmA4T5d+6oMmiviqOi6geGDNHH1UxGH5HZU0nloHlv6QDStjGCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kooArh77QB5w+99tLWzmygRpijr+w2tyrJKISw8sgks=;
 b=I9xFrDLBLku6s3HIDdQiYOeJDQFc6QLsyMEKeGSzWJrFi6ku/eJhO4m6V9XH5Xb3JfGnHpXeK50LI4sw4IiHIX8AL7iSiCNWjvj1hrrMw5DLwykqg9U7LqXz/4Y5XvvW+qobUzR2Crdq9ZCcIx5C2s6OhNTmkWdFv1ckAVbi4nXwEjdJbv91eCTWwVQmlFKDj0bLaGvchc181nsl6+Zy/iS1ERK8BG5p3zV8tyLvbJSVUSQGGc+32IbI0Rce+0xWQWHOqHzz62dEZKv9UPxb4FaYl9e+jQOhTVaMVDfCud+U96LEpeW6bbsJ6Or3jBbQ2OkOgX3O110FHe5YaZd8YQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by MN0PR12MB5714.namprd12.prod.outlook.com
 (2603:10b6:208:371::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Wed, 11 Nov
 2026 03:31:48 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0615.007; Wed, 11 Nov 2026
 03:31:48 +0000
Date: Wed, 11 Nov 2026 14:31:43 +1100
From: Alistair Popple <apopple@nvidia.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alison Schofield <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Davidlohr Bueso <dave@stgolabs.net>, 
	Jonathan Cameron <jic23@kernel.org>, Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>, 
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: Re: [PATCH v2] MAINTAINERS: Update CXL, NVDIMM, DAX, and others for
 djbw
Message-ID: <avPgrbIgj70rdWaL@nvdebian.thelocal>
References: <20261110210152.3494345-1-dave.jiang@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110210152.3494345-1-dave.jiang@intel.com>
X-ClientProxiedBy: SY5P300CA0044.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:1fd::19) To SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|MN0PR12MB5714:EE_
X-MS-Office365-Filtering-Correlation-Id: b0a3d9fc-91da-4fec-aa39-08df3fa451b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|261009223027099003|10067099003|261028144727099003|261102123227099003|261026140227099003|261026121527099003|261021123027099003|261021121427099003|261022105027099003|56012099006|11063799006|21046099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	pnuNUzoYxVm88bXRZFj8NUHKvCFKw3XYOBeLBL56QeW3mEIYQeHdQmBXFLWIrx4KnkeYZaYwi4ywHIEMsyVE+HaIwb5+goVSysryk92lXkcICWaKe5pXValRwiSUc59RcV2x86hlJVVHqJeq4D5v5A8Nubwy27P2Seu26sdp+q0/opQ2CV7l4YWL8oV9XbAVgKmnw6vs8HFIsVjxAmkMKt+NwYxnqhp/Cp1YG+NoTWStOLvB8dx9BZuwey9il2IXLJRiq0KkkexhLXMQpthBzZqdYGTAiRKyoRN7YYr79AQwQwTS1mYuYSYOV4Y7uWaAnGNtSRHfuzOsNuWuXEJil23MI4KUBYGIsNevgpOFDNvc+Yv1hiuoLOgV301tO9vyqk2ruHOffjjDEkLKve02T6FVbOgBzCMp50HgplMcrH+kAEfjcQi2A4aZU8iHCaQoQkrte2Az2qMd/07sm72zD2IZJTonWFMsFakG91968DONKyPNwbXSgSV1VxIH90hZaVyPI1BmhzTLtyFwnlv5R3VFLmcCrhbxhwSjWYe0D737zuNTEIKEUM8iWgRhuN/CmMdgZdx6Rk0qI5Zy4vYpwLBALM7U2W9IjgHXb5SNObFqynLmWDUeZq4xBHdG3F8/B/XjVT8njL0dILQNcvZrEg5L4NbVQ+0EeuAOPDcdC/0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(261009223027099003)(10067099003)(261028144727099003)(261102123227099003)(261026140227099003)(261026121527099003)(261021123027099003)(261021121427099003)(261022105027099003)(56012099006)(11063799006)(21046099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BNEQMmRRqm053KnEt5putjgmEiKhY6ReJjM0z3h+gRpWXMdAbb6Svsb9UK+D?=
 =?us-ascii?Q?ZWoEu6j+21NDPrEhJafFm3UQXq621Wa9u1XLH/dSjckLI9KH2o4qxsEiXkcv?=
 =?us-ascii?Q?v3l9H64JtD/XhfrBzmsimSGAyb51r3FCO8FJFUNQjA/gXoQqPWaWFy9C/iQ8?=
 =?us-ascii?Q?qUlZSYuKvgyImFb0rnmY5lgk9yKv5s1DFvuUZewZ67VnHt4OvmMD/GSubLfv?=
 =?us-ascii?Q?RWPedp1pnksmr6osvvTbZBQM6gPuZr5dU/BKASXmq3/mND0hCFNJinY8g7NL?=
 =?us-ascii?Q?zRP8lLQnSuYF+6o2/mM8gMMVSTtDDnmAUZIr0jbjic3L9D/mAV4n+sqUEzsl?=
 =?us-ascii?Q?GaJpLvylSJ6hRfJV9C/hnDCilTan2sv5g0YMm92Mkr0cZnrAc8ZXyB5GdWPS?=
 =?us-ascii?Q?BkAGdlv9E02HtkVAmk0dz89WGffvamy+Vd5OTMHvJfAriLxYOnmXhCfvVWAb?=
 =?us-ascii?Q?O2HeL+jZ3/lZIyJGs56YxdoM4UjxlRABkSYXyCc5Mr6eLPl5GKat0Ba6hsjw?=
 =?us-ascii?Q?UCA+jkKD2TAnUDakQZGMvChgfH6d08UZk1Wtssv2txOSfObIq+QQs6PjzF4l?=
 =?us-ascii?Q?34lpuT9imzcUdx0N9zkr9zRwImfXcAsqdj4UqT/Bztf5w3GN/5WRJ+KZW6c5?=
 =?us-ascii?Q?15X91QNEHsxm89/AnaE4fB3zcBpvB8rzRQiPq6Ca7D6Z80JCzMh2NVAkzToi?=
 =?us-ascii?Q?8Pm7QfuYkDQfDYWKOMdiM1qxcl+ogjJIPymBn5XjXWP3AnttNlrcV8CjPmhq?=
 =?us-ascii?Q?IvQ6/AVKfYGV0IP1pCDlrbQcG4hl9ufV0l1G59o/WmqQ5M90zutTEtFnlES/?=
 =?us-ascii?Q?86ai7Uqa75L7cxQlcQFKfEkBabMa3UOQK8xI0q6tRZSKgyFEAEKeFdtuI6fv?=
 =?us-ascii?Q?EqOJ0rM7tz/gqlvZdMp/GLs4ZH42AZfcgikFWSHC1hEziNJwcuL69etaVbz0?=
 =?us-ascii?Q?+eZ04ObJjTts2EPED3Vycz4QXbnC4CjW666u0JNAZXhROSSIJYNVllcXIwE/?=
 =?us-ascii?Q?+nRiqKjW1W18EJTU+acR+6Nctvu7O1RnFWlBdEC0gqO1ekNzNXAu4CzCk0FA?=
 =?us-ascii?Q?pxcFV8RC5OCN+eyiuwxaNz4aykKwMvsg/6FQ5nHdBFtosx54moxs2hlpMIEB?=
 =?us-ascii?Q?WHRAvqACCTXecdLtqWb++95fGLrl47e+qjKv23xlCeNnC9ERaSRK3UlzeNvr?=
 =?us-ascii?Q?nRjDqNn4wEDrka2OawWwdGVjSA6hbvm1WwskMqdCwy0W/eN5WJwjWgxQba4B?=
 =?us-ascii?Q?Fv7HwOd9Yo0zS9fZu51rqXJvhC52PqASHHptUjX3cgeIti4j+5Wr/6FKKlkk?=
 =?us-ascii?Q?LusgpGvO/D+hQ74ABrtkRao0LVdj9Vy69ijAeMQl4MbMtTO/EZ09x2E1N0aU?=
 =?us-ascii?Q?tbHyh6CdSTEv0DRONzZwBFfChXk/yh6Lk58dTQwhSoVrODhDINqSV34MQAt9?=
 =?us-ascii?Q?5DDz4OTWwIlU5NfDTgYai5T0UuN4PS/+NNOF8NZuEvYM7fAIkxmW7taLKuGP?=
 =?us-ascii?Q?kY65dlKc6mXA08P9MvUERjpzcNko5BmOEExa1C8/C8R4wSA6dlPIRO6vAvZA?=
 =?us-ascii?Q?wBTxl0BVvJkahLQJcab+jkxu4la0BA/Mak8pxnF7VUZqREYTADC1SPwpbxWR?=
 =?us-ascii?Q?4IKGJdSppA6JHX5hfHDuel/Ih7kDGyEuAb59kB2gpn0N/do12vOsO3OZL/Jn?=
 =?us-ascii?Q?oKd7dTTkT9CZDXRRQKyljGABWFKiQGlGM2PMPXvtkQvQuuH190Jvs2NZn8Q3?=
 =?us-ascii?Q?CNcOA9iJ1A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0a3d9fc-91da-4fec-aa39-08df3fa451b3
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 03:31:48.8614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bqu4tGsUqwSrMZDIX3U65DEWcW4YIl2Zv2huEV+4t3OFsIMOtC0dnqYBnkM3wo9Xd7JQav0LJmy7Uch/g+pK0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5714

On 2026-11-11 at 08:01 +1100, Dave Jiang <dave.jiang@intel.com> wrote...
> Dan is no longer with us. Removing entries in MAINTAINERS to prevent
> people from keep emailing his address.
> 
> Frank will take over for async_tx until the feature is removed.
> 
> Alistair will take over on fsdax with Alison continue to wrangle patches
> for DAX overall patches.

Thanks! As mentioned I've previously reworked a bunch of the FS DAX code so
happy to help here.

Acked-by: Alistair Popple <apopple@nvidia.com>

> Cc: Alison Schofield <alison.schofield@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: Frank Li <Frank.Li@kernel.org>
> Cc: Alistair Popple <apopple@nvidia.com>
> Acked-by: Davidlohr Bueso <dave@stgolabs.net>
> Acked-by: Vishal Verma <vishal.l.verma@intel.com>
> Acked-by: Alison Schofield <alison.schofield@intel.com>
> Acked-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> 
> ---
> 
> v2:
> - Add Frank as reviewer for async_tx.
> - Alistair has been working on fsdax and agreed to be maintainer.
> ---
>  MAINTAINERS | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 93abbb315065..58bdd5eff5c2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4294,7 +4294,7 @@ S:	Maintained
>  F:	crypto/rsa*
>  
>  ASYNCHRONOUS TRANSFERS/TRANSFORMS (IOAT) API
> -R:	Dan Williams <djbw@kernel.org>
> +R:	Frank Li <Frank.li@oss.nxp.com>
>  S:	Odd fixes
>  W:	http://sourceforge.net/projects/xscaleiop
>  F:	Documentation/crypto/async-tx-api.rst
> @@ -6726,7 +6726,6 @@ M:	Jonathan Cameron <jic23@kernel.org>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  M:	Alison Schofield <alison.schofield@intel.com>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
> -M:	Dan Williams <djbw@kernel.org>
>  R:	Ira Weiny <iweiny@kernel.org>
>  R:	Li Ming <ming.li@zohomail.com>
>  R:	Richard Cheng <icheng@nvidia.com>
> @@ -7621,7 +7620,6 @@ S:	Maintained
>  F:	scripts/dev-needs.sh
>  
>  DEVICE DIRECT ACCESS (DAX)
> -M:	Dan Williams <djbw@kernel.org>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  M:	Alison Schofield <alison.schofield@intel.com>
> @@ -10315,12 +10313,12 @@ F:	include/linux/fcntl.h
>  F:	include/uapi/linux/fcntl.h
>  
>  FILESYSTEM DIRECT ACCESS (DAX)
> -M:	Dan Williams <djbw@kernel.org>
> +M:	Alistair Popple <apopple@nvidia.com>
>  R:	Matthew Wilcox <willy@infradead.org>
>  R:	Jan Kara <jack@suse.cz>
>  L:	linux-fsdevel@vger.kernel.org
>  L:	nvdimm@lists.linux.dev
> -S:	Supported
> +S:	Maintained
>  F:	fs/dax.c
>  F:	include/linux/dax.h
>  F:	include/trace/events/fs_dax.h
> @@ -13455,7 +13453,6 @@ F:	drivers/platform/x86/intel/hid.c
>  
>  INTEL I/OAT DMA DRIVER
>  M:	Dave Jiang <dave.jiang@intel.com>
> -R:	Dan Williams <djbw@kernel.org>
>  L:	dmaengine@vger.kernel.org
>  S:	Supported
>  Q:	https://patchwork.kernel.org/project/linux-dmaengine/list/
> @@ -15278,7 +15275,6 @@ K:	libie
>  
>  LIBNVDIMM BTT: BLOCK TRANSLATION TABLE
>  M:	Vishal Verma <vishal.l.verma@intel.com>
> -M:	Dan Williams <djbw@kernel.org>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  M:	Alison Schofield <alison.schofield@intel.com>
>  L:	nvdimm@lists.linux.dev
> @@ -15288,7 +15284,6 @@ P:	Documentation/nvdimm/maintainer-entry-profile.rst
>  F:	drivers/nvdimm/btt*
>  
>  LIBNVDIMM PMEM: PERSISTENT MEMORY DRIVER
> -M:	Dan Williams <djbw@kernel.org>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  M:	Alison Schofield <alison.schofield@intel.com>
> @@ -15307,7 +15302,6 @@ F:	Documentation/devicetree/bindings/pmem/pmem-region.yaml
>  F:	drivers/nvdimm/of_pmem.c
>  
>  LIBNVDIMM: NON-VOLATILE MEMORY DEVICE SUBSYSTEM
> -M:	Dan Williams <djbw@kernel.org>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  M:	Alison Schofield <alison.schofield@intel.com>
> 
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> -- 
> 2.54.0
> 
