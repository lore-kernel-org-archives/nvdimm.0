Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.162.58
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793805744;
	b=17arcoRXceiTOz8tK1CcpvrwZveNB9WqEEGAX2dl3UZ9gc+jPDhO6srTA+TZy7CJSm5U
	 t7swbDD+fDhK9DekGKKDc0RH2pEUCTN5ud2KQIdfhIBtx9apYIrJahdK6tE4MgEunsIwa
	 IjIoQSMpadVfftjQ5qaIo/gpcpTMTR//EuXwwEatWg1MSD0F6vVbwDfZ/SRY3oGWxh6K0
	 wpCNg8H4rKFm7OszW1GN9ZmrJB0IloIXDNKlQvwR0xuVbpKIhU23/+kGUc78ifFx74pDK
	 tsbqM9OMfvSfZAOO45PwvrFC73osIypeXAmkszvZIRiehIjhfzBqZXMJOZ6cffUhFAA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793805744;
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
	bh=mLNRWR+KHxm7LDIN7X2OjTchk0jtyXX5Al0UXel3aEg=;
	b=mIo+YWF8qp6AHcYJN1w0tQmObktt2g6KB8AQbc5A1lwKPYFR5z1EdRWSp+4Q3yIaIEci
	 WoIiOOICS6vWKtal9IktHvUhhii+bLCldfa1Sbs5GmIngFGkMGZ6nPFN24/YGWpsdr0gc
	 TexOL654R+ODrGIpu4Uib7UccLWHDxDl+BI2MmJ5EaUE6wWJgfofLp77BECrNo9/eJRTY
	 3//nZ8mGPHCEYzA2KrUEBd5eacWkt4aevm9AtgNwLzm0z1tH4topWYDhfm3E16/jRZKej
	 nKOl/4E0epEDmtIlLQb1eV7KjVICdNjwd7ePoOJta5nMFIJWjBUptFP0vC72ARVqKHw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=FIHncxW5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.162.58
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013058.outbound.protection.outlook.com [40.107.162.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CF1606A32D
	for <nvdimm@lists.linux.dev>; Wed,  4 Nov 2026 15:22:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0CF1606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=FIHncxW5
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y+HdYVxKLu2UF2O3t54bQekm74cfdOXhumLF0RdaYQGyzU3WLsgDAKJSPNQQekAPItjuwxbWNbiai/STX7wawMfyLa/9zCvRNYcW35rpcyYjQW2dKifCSHAsB9Gd0/JTgyvtZ7wB/QVsSjnDKeRT8c0YkztVW8tcGjmT+/Cup0BVnLzBepHtkg1emE3pWyJ0WdCfcUAKQ3E/eg3uz/6AWTSi/oefHIR5mZll1L8sRMsSmurn6PtB+/SQZQWyrbBzy/4G/fRW/DyrNAIN0dBVne3Ptrh1o+IkON9gJ3u66SnHn2EYHdy/NloaAXMpA3WIh6UVuTKK+MfrrCyPI17Hsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mLNRWR+KHxm7LDIN7X2OjTchk0jtyXX5Al0UXel3aEg=;
 b=HbSKUtuEEMqFPPe9OIz5N4qiPONtCfefApf1X4lLwl2+6wXz8lXMg9plfnXPqC9Uh6PJAuX5JSr/5WnwZgj4WO+pOYI9lCnaiyALdjBTQm5QrNbA3QtSX0S+uRjnAm/xkhxBsliO7SrWWYGWFVwrTJi36DPWmGW+kT86SJJe32+TYinnq3bj4mspthBAN4gFsSqUheG3j1yaXAtqxxLol0cinYnEjTudf+YtJ+pQT85vvduRtajOUN3iFMXKUPOvRBZ8/l9pvh2AMN0NeSKamR94JqDIyiA5T/c/+y4bWlAvPgjr8WOrNE3+YloTcUt5VQMvgSV1UT018W3rCBS/Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mLNRWR+KHxm7LDIN7X2OjTchk0jtyXX5Al0UXel3aEg=;
 b=FIHncxW53G3vgkQlbcgIh/XdBe4a7/rD3yx6pjxVYaort7dwypJLb5aqontt87czpifAA02nwznzS+RpNFqGvxNfBE5Twbx7uT1+fnV+z/wFyIc8RLisWW8Vk13Hh6LD2WlxdUaU1CWj8jJgfi/OXrMPVrbQ6WaSH0BXjn3uPkf+qFbVcNByk7ZEgTKekgk/clBSbEapkUl86niEoRezNYGn/caSGi0Ed2S8bc3iC0bp453pXF1McQgn/oBoz0sNWNXJuImsMxQkeqing420fmkA2c9qJMyu/4muoYIHmKHPhGZdjQueFsU4vI35SXvUmo6QaRntRsApov680+KaUA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com (2603:10a6:290:76::14)
 by DU6PR04MB11135.eurprd04.prod.outlook.com (2603:10a6:10:5c3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Wed, 4 Nov 2026
 15:22:21 +0000
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b]) by MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b%6]) with mapi id 15.21.0592.007; Wed, 4 Nov 2026
 15:22:20 +0000
Date: Wed, 4 Nov 2026 10:22:12 -0500
From: Frank Li <Frank.li@oss.nxp.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Jonathan Cameron <jic23@kernel.org>, Vinod Koul <vkoul@kernel.org>,
	Frank Li <Frank.Li@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Update CXL, NVDIMM, DAX, and others for djbw
Message-ID: <autNpAFXuBVywP8Q@lizhi-Precision-Tower-5810>
References: <20261103201547.4079847-1-dave.jiang@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103201547.4079847-1-dave.jiang@intel.com>
X-ClientProxiedBy: PH8PR07CA0035.namprd07.prod.outlook.com
 (2603:10b6:510:2cf::22) To MI3PR04MB12438.eurprd04.prod.outlook.com
 (2603:10a6:290:76::14)
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
X-MS-TrafficTypeDiagnostic: MI3PR04MB12438:EE_|DU6PR04MB11135:EE_
X-MS-Office365-Filtering-Correlation-Id: e03616e6-359d-4466-2373-08df3a876b80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|19092799006|11063799006|261022105027099003|56012099006|261009223027099003|261021123027099003|261102123227099003|261021121427099003|261026121527099003|261026140227099003|261028144727099003|10067099003|21046099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	7hrm8u/CuUTZydDlBlDw9hPDvQUiKoWpagh5DL+nYPon39nfD5S8GheDBARv+M3dtQZ5Zx/bmyXYl9jfltC3V5Evovm4h0hbXAh0rfjjpAHgORavtVBCLIx36wl4ClhS+vhA45ehIBWP7CndTDklS/TzKX2DNp+Mq9iiuQWBWe8xIq9fo8YELky7beU/hIXyCdMC5RTnEblBKGU4j8iSUhmiuWEqlgpWDIkSEcWVzcY/k8dwSPKTt0LIc3VyaY04HSmJENwrNqdTAVnyPcY3oA5GZsTRiTkdrEG5v/9IF/MYnNXgVWY4Y1xjmRVBb56Dx2OrkyvxGw6GCZc6VQ2jIzWoHoBuHEtIdlfwoQVbhF/bVwWJFJnmYwBaZM7hMQNIOt2/qiGrF2qfTJw2JnPmHsFUwJOZ/+bdeztwfWuEn/NWdWAdN4s0k+VH04AR7jQ7OJoqgFGJ2GD7FwDGXF5EuVTXUy2YJ9ob8kdl5qGkMeDl374aLFDd9zvE9AnsfhQ7FkmUmu1IwYNmsBAPHy1q2tVJVuzh7+5RntZYADABcJwjM0SHbEw7IjyYBJVUJc8pqyXRqeKQJ0jQ+T/XnyKIxB4QsXQWuDt/9jKlf8sa4hpuaapAvvqqWPZIlTVYMlB8
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MI3PR04MB12438.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(19092799006)(11063799006)(261022105027099003)(56012099006)(261009223027099003)(261021123027099003)(261102123227099003)(261021121427099003)(261026121527099003)(261026140227099003)(261028144727099003)(10067099003)(21046099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KSH8aM0QNWBq2fziEcFAdlHQeC0J9Mvu+tEHW5grUvtgUnH87AzKMfrWArfn?=
 =?us-ascii?Q?4+32yL/np9vTVZhIoU43TnQL8D8N6D7mFKDc4kkPtQoBYLMFqz9Ofx48+Cfn?=
 =?us-ascii?Q?jW5sFwXa35V1QsnDB1j0XmtZBajjpib1qL68O9TKtTcEwhWaQQpEZuiDaQIF?=
 =?us-ascii?Q?Mzec3SJfcrrzWDVX6r0lGSOtYHZBBNtbFMo3ziUnVIsT02t9VuQAw23Y0Y4h?=
 =?us-ascii?Q?ZdrVzg1SXCpDpyZcQerc11wiss091zhoMpCAdNh4jUc7fT7WVIybZ/c67ds9?=
 =?us-ascii?Q?sWIZ0mb6IW9tOKXXMc3BkCpttlhRK6GUxNgsu3bqUmN0tiyU6x6ztoGmOdqo?=
 =?us-ascii?Q?NYNmQC6Kum6Y/p2wqeimlq1YWYIMAiu54IkB3s5Q/ldwD3PZ0C+0NwfzxUyy?=
 =?us-ascii?Q?vhZnFg17Kh6RGRIrGNPoyrYwmcAF5x7IlgU4Q+EpdreStu7pd4i6NK5VBkia?=
 =?us-ascii?Q?st0tmrkyyaJB2kKmWHoqtOg210sLypiu6DkzAV09tlFqlLxRioM3yfpHP6Lm?=
 =?us-ascii?Q?wKtyHuhDM7Ud9j9+W9wjqKJaB8apU5gAJx/54+apPLjM747RcqILdWh0f9LG?=
 =?us-ascii?Q?VLrT7kqB628wDfosLGojf/mS6a6jj6N4+yD5h2jZNv4QHPQvpg7o/wnP8NfK?=
 =?us-ascii?Q?o+ASpFKMFy8j4SXxEwwPIvYGkOBEQ30XYKRSHAchbARcxCyW0dyRV5WdvKwy?=
 =?us-ascii?Q?S6recPxpIi20qWOYly/3HSIDHttKzusWlcpBejpQqxO43UEsjsF7i/ohc3tG?=
 =?us-ascii?Q?MwWkNdU4LBQptjeD9/ARqSMIuIUUFMkh+J5KMwVDxqiMWRstOQH/ENHj+vmA?=
 =?us-ascii?Q?J2PYYgzP8ifuzoCD0JmpM2e+dk5sDOVSweiaksksOoQjJ2evbj/aR7sLWShE?=
 =?us-ascii?Q?qxUrCQSa2D3zcaYGmiPzxoq5wYwo+JUoV91iOvl2+INOZCGx30zxBuGn34FL?=
 =?us-ascii?Q?/YsdKuEQJ4rCGEV2cRyzL1uRiBQ3GldYwu8esF5G7+FvyL3QxyNyPWlKZjcD?=
 =?us-ascii?Q?YsPeNz2qjqyA4M2E3o9hjDMqQ4t3Ej+RgKDO3/uotn3J6Pn7I/ByLGrAuJHK?=
 =?us-ascii?Q?GUnqctM6VqVJaYhq0tO56ijc6nENCfLIxTzI0mBPKy++MKsYRrp/3SrYOecH?=
 =?us-ascii?Q?UGh6WtYLyDDQvLUrHnrb1cFw5k4h6bjVaOTPOHHOaZdSpUS6Ftv2HGFOIpht?=
 =?us-ascii?Q?5+KigvFnwBjJ8nB8cOyLI0NrvggmSJEdc6l44JQ1cUGnprr+LNexI2ML+Fhe?=
 =?us-ascii?Q?6D6sBqle/f5rFG2RzW2udIqP4j59vR+DHxF8SHEuvwXu9cKF9hPhY1lhkdnx?=
 =?us-ascii?Q?/RBjlkgAzjj5HTAfKgtSC/Hswblc+TFd1CfD04u/5DcuF57hy+hvANlpj1b1?=
 =?us-ascii?Q?E3rgBpwwxRLG/HB3JxN/hhrBBpUXQF6L7ltmfZ0XK8GVk0GcihbyAw9Gl9pA?=
 =?us-ascii?Q?oR9dRQK16GUTdlwpwbopt4o4tw30Vq6otZ7ba7p6fUr1sfbEMoRsjqYhQpny?=
 =?us-ascii?Q?r63jT+qjHfqxKqOe5NXqKyXEztKAuRnnF8309kDY1jpQesMJIKvR/SpgmrK1?=
 =?us-ascii?Q?BPoCboNYunHJECQpInFMXLfqjR2IetjpmFuI66gY2Llryh8gkGRLCvHmjw0Q?=
 =?us-ascii?Q?ka2LQiKyZ+8znKe2QKUpWkgtaflHVxQIihFrNmLrKRRxrampdt2HGKQg12Gi?=
 =?us-ascii?Q?jWSLBkg4VhC8+UXM1JDVi0xosEDec444k2xGy+pZcqhuVcdde3g0vWwnsQK+?=
 =?us-ascii?Q?JXmC6+2ADa+M3m60XHWqtIdws7vpkMCUSLF0Cg3xukvTpsU7Txab?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e03616e6-359d-4466-2373-08df3a876b80
X-MS-Exchange-CrossTenant-AuthSource: MI3PR04MB12438.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 15:22:20.9172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mKnY3dkuyiAnx8aVAEa9Y/GXANU5f8P661nAgsdAqKanpeOu8OqO3SCEJK/YlhOe1kpmJUK4N3tciF1p+4Bi/abI3MHGaJhxKQ9FlejyUas/Ywsjqo8sDcqd9+a/TmDt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU6PR04MB11135

On Tue, Nov 03, 2026 at 01:15:47PM -0700, Dave Jiang wrote:
> Dan is no longer with us. Removing entries in MAINTAINERS to prevent
> people from keep emailing his address.
>
> async_tx will be essentially orphaned. There has been discussion of
> deprecation for the feature on the dmaengine mailing list.
>
> fsdax will no longer have a maintainer. But there are reviewers still
> and Alison Schofield will continue to wrangle patches for DAX overall.
>
> Cc: Alison Schofield <alison.schofield@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: Frank Li <Frank.Li@kernel.org>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>
> ---
> For FSDAX, Jan or Willy if you guys want to step up and be the
> maintainer please let me know and I'll update the entry. Thanks.
> ---
>  MAINTAINERS | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 14e4daf8ea8a..32b86033b5f1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4285,8 +4285,7 @@ S:	Maintained
>  F:	crypto/rsa*
>
>  ASYNCHRONOUS TRANSFERS/TRANSFORMS (IOAT) API
> -R:	Dan Williams <djbw@kernel.org>
> -S:	Odd fixes
> +S:	Orphan

Can you put my name here now until it is full removed. I have some cleanup
patch need be merged in case take more time to remove it totally.

Frank

>  W:	http://sourceforge.net/projects/xscaleiop
>  F:	Documentation/crypto/async-tx-api.rst
>  F:	crypto/async_tx/
> @@ -6715,7 +6714,6 @@ M:	Jonathan Cameron <jic23@kernel.org>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  M:	Alison Schofield <alison.schofield@intel.com>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
> -M:	Dan Williams <djbw@kernel.org>
>  R:	Ira Weiny <iweiny@kernel.org>
>  R:	Li Ming <ming.li@zohomail.com>
>  R:	Richard Cheng <icheng@nvidia.com>
> @@ -7610,7 +7608,6 @@ S:	Maintained
>  F:	scripts/dev-needs.sh
>
>  DEVICE DIRECT ACCESS (DAX)
> -M:	Dan Williams <djbw@kernel.org>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  M:	Alison Schofield <alison.schofield@intel.com>
> @@ -10304,12 +10301,11 @@ F:	include/linux/fcntl.h
>  F:	include/uapi/linux/fcntl.h
>
>  FILESYSTEM DIRECT ACCESS (DAX)
> -M:	Dan Williams <djbw@kernel.org>
>  R:	Matthew Wilcox <willy@infradead.org>
>  R:	Jan Kara <jack@suse.cz>
>  L:	linux-fsdevel@vger.kernel.org
>  L:	nvdimm@lists.linux.dev
> -S:	Supported
> +S:	Odd Fixes
>  F:	fs/dax.c
>  F:	include/linux/dax.h
>  F:	include/trace/events/fs_dax.h
> @@ -13444,7 +13440,6 @@ F:	drivers/platform/x86/intel/hid.c
>
>  INTEL I/OAT DMA DRIVER
>  M:	Dave Jiang <dave.jiang@intel.com>
> -R:	Dan Williams <djbw@kernel.org>
>  L:	dmaengine@vger.kernel.org
>  S:	Supported
>  Q:	https://patchwork.kernel.org/project/linux-dmaengine/list/
> @@ -15267,7 +15262,6 @@ K:	libie
>
>  LIBNVDIMM BTT: BLOCK TRANSLATION TABLE
>  M:	Vishal Verma <vishal.l.verma@intel.com>
> -M:	Dan Williams <djbw@kernel.org>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  M:	Alison Schofield <alison.schofield@intel.com>
>  L:	nvdimm@lists.linux.dev
> @@ -15277,7 +15271,6 @@ P:	Documentation/nvdimm/maintainer-entry-profile.rst
>  F:	drivers/nvdimm/btt*
>
>  LIBNVDIMM PMEM: PERSISTENT MEMORY DRIVER
> -M:	Dan Williams <djbw@kernel.org>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  M:	Alison Schofield <alison.schofield@intel.com>
> @@ -15296,7 +15289,6 @@ F:	Documentation/devicetree/bindings/pmem/pmem-region.yaml
>  F:	drivers/nvdimm/of_pmem.c
>
>  LIBNVDIMM: NON-VOLATILE MEMORY DEVICE SUBSYSTEM
> -M:	Dan Williams <djbw@kernel.org>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  M:	Alison Schofield <alison.schofield@intel.com>
>
> base-commit: abf8c33470f78e2226ee3dcdc69004660020ab47
> --
> 2.54.0
>
