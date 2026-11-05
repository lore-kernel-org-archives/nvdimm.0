Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793909953;
	b=Q8hK040Y/Novv2h2Cvxz4Uler9AxI9CL7KCsCzRefMyD4ISwhBtciklhZfPET+peNuy4
	 TV8hyIxx9RGRplhAK/gPo8Ls0+PkK4KjGpXXqMjXjXYZfRaY4RaQ2WBZ9Zgwz2xdQfSKB
	 p2upYf26F81qznjS8p87jkf96OTiGrCoaYSIKBZpbulmdVOjHI6kSY6ksdnSpFe6Y6jFH
	 d4clbqiW5GhfY8TvQrfthwjaD20GisAUEvCroCF0eGCq3Cs1vYHmg+SiuYslKz17Eji/A
	 qKzMIhZB4XaOLJUTogLveg2FpKIdozCAlCN2PYE385Qct4Yv1Mv9r/J0eIg2CsyV3ng==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793909953;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 Content-Transfer-Encoding:Content-Type:Date:Message-Id:Cc:To:From:
	 Subject:X-Mailer:References:In-Reply-To:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=YhQfeST11Y/BHVIVIEBo0tfRd8bdlsiSxx+qW7Nnol0=;
	b=GG7Rk3yiDQSwO8SE8YpHAiTeZgzvQPqM/CrChmb0r+0NjwgKWOtltLFp24CPnVhJY9YI
	 zt3taMWMIRZMe55QdpNbgJowD+mYKmZMXgc6yKtczm+4C7FvjX40ELkJ9hwYeHH2e0fbk
	 OzNX97HSXMDWumq3qOqdsT7f5GNG5OhxJPqcaFiG1cMOrNWVTT+mi8d0PrSa6TbTOOANZ
	 gDB8uAHGX5axzm0wyUihfXS35Il22osCtTgZeVX3QZRtkdm963nK5eyhKBDfV2PcXSZ4s
	 1xeHQih6YzWUKC7PuCmuojlxmVAobWKE91oWxBQ4GyANAdVAzj6KEIQ9KKLWGMvr6Lg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=nGOEMyVC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.54
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012054.outbound.protection.outlook.com [52.101.43.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C414606A32E
	for <nvdimm@lists.linux.dev>; Thu,  5 Nov 2026 20:19:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C414606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=nGOEMyVC
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XAsDjy7PKtByYe4FjFCN72wBzp3f+wN8xVbZzSItQ5YBubPmUWUtLnqCTIZ61wWTaF3o0JZ78SxM8Vu+dftCOjUuiawlm/0LdMpgpx4d1GKU5Dn2vP0v9gccT9qxBBgwLFYwIy1rJq7aCWgCt3oOt3Ds7+DXVP5VkBvGHqEfkG7ToLIaYaq6735xQTzDhsZRXA/B/fndRUaje2ubBb6EUcJ/PoeuWVbPJsL26bZzXAfN1cPpM6KaKSUL+nyqp3D5ZOmOCIl8QKEjDDGpxsB7US6dzms2SKHNRtSo6YF8cIxlWrImvutswZLsK8Rk2/fqAhuf9X0Enor0TEgV/FPvbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YhQfeST11Y/BHVIVIEBo0tfRd8bdlsiSxx+qW7Nnol0=;
 b=SwAtgYDSINXW7YUe0urFJL7qw0PucvQDFB/tfToVYVf1Q9ig3YT3CKGRXhu5xVx6drLn69idxdlxxxRVlJWAPakiTFTqupUN63e7ZIh/w0fTcIlgtW/S24bMHwG7brvfyXrgzrM4mqpUndHkc1JYnpV6wl6eCiEljlItSy2/ndLIu3ldGRuKnGEWv0BdELhBTxzFk+shEi8715SYXoV42H2fH6MgT+qr+7hCn5TIuxCZlNXRE6MM9s7GklNisMgsDH4cAnAmGHPtyQ6XGhGA3Wrq3sNLO9N1biMGorvVMwa58DRjT7dZjHtpMQny9daSYNAAV8SmY/IVcFW+xuuu+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YhQfeST11Y/BHVIVIEBo0tfRd8bdlsiSxx+qW7Nnol0=;
 b=nGOEMyVCTY3hWYyEeB0ZQkawBbC+PVxIJdWQij3YWVkTR27hshpflSaarAy75vAxf6NxOfXrQoo/q7bx3IGoq29uMedwyl17KL6YRKYKpPrMRF2uKFjOmoCcxVZH0DaXo9fNpjdGQwxpFh0VWENShMQ00J3D6YFkEFPYhP6aBAncg0lekgZyNkudLdSgLBrnPIORauC0Xvjfe9nnh45ImN9QnSnBkAhOo3yzYb32JIdNKPhVlXCJRcoT1TXVOxVbMNQgEJfrevM4WhtuF63QDgDEn/oaHxUedo9tRfpuIy+9gOiJqoH4uga9wBuzHjxZ3r/98xHyrbT2jVcRMdvmYQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA3PR12MB121967.namprd12.prod.outlook.com (2603:10b6:806:58a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 20:19:10 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0592.007; Thu, 5 Nov 2026
 20:19:10 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 05 Nov 2026 15:19:08 -0500
Message-Id: <DMNK05HCXYUJ.578OO1NG15LZ@nvidia.com>
Cc: <linux-mm@kvack.org>, <nvdimm@lists.linux.dev>,
 <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <stable@vger.kernel.org>
To: "Konstantin Khorenko" <khorenko@virtuozzo.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Alistair Popple" <apopple@nvidia.com>,
 "Dan Williams" <djbw@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 1/2] mm/huge_memory: take a reference on a folio PUD
 copied by fork
X-Mailer: aerc 0.22.0
References: <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-0-2828fe5a51ed@virtuozzo.com> <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-1-2828fe5a51ed@virtuozzo.com>
In-Reply-To: <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-1-2828fe5a51ed@virtuozzo.com>
X-ClientProxiedBy: YQZPR01CA0110.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::10) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
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
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA3PR12MB121967:EE_
X-MS-Office365-Filtering-Correlation-Id: 87368f27-205c-457e-171c-08df3b7a0ced
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|7416014|1800799024|22082099003|18002099003|10067099003|11063799006|4143699003|261102123227099003|261021123027099003|261021121427099003|56012099006|261009223027099003|261022075727099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	H3WQd3y2ntoTLgTO1jRdBEw7IvhEscrI0s/Bjn5ft6ZP7QTZ4epXB3nSutP9A//E54tgGQZ0kOKpnrP5QXFZWlHK8dY2GVmmuuEVDHXUNrx21bB28/Ky8LVF7ncAcw5X6Ac35zwNuAch3EoiItWLJRQUnTs69gPaHt0aLQZCiQAc7dEPAMuDSMaFbraTy6NzSY7/l6kTyRhlB5nQ5wlVFCoMxP3469xzFDpAPfA83VL/Kq0XEaF7BQ5eaTJohdnp+uiIXx5ffnj2gE+jYRYt8iYiXddLSEaorIvKrevBpn/uSk+0m8iI+MpAM7Jc5up/YK+Y19nbW9Eni17tCUlzfxJRVtK1ex5rBPsahbhwdRRr546ejaUyg2ghTq651DzpVl/stDoA48x4HsEi8jkaK328NnRKWImpx479yALoHunjZauEisGhvA0ODndntba2eN+2398bwjOgSD59bnuYJWm2m5isCYcNPpgL1wXIPYeb+R/LoQXQJas2VWm4yjQ6HKxpi/JMmpfftcl6nkS97aYUEzvzMlnvTiU7+gJfPnXZ+2MRbx4eka4iujAsEJOB11G00rGoMfvCua46EyL0DXgNIy3cDE+GDG2Ok3ZeCSzwH4FPU9d++CTtOp3s2BEeidTD142ea/BNA2ekWhUhqYoQy3tmgw0+dpi2fPcDUSU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(7416014)(1800799024)(22082099003)(18002099003)(10067099003)(11063799006)(4143699003)(261102123227099003)(261021123027099003)(261021121427099003)(56012099006)(261009223027099003)(261022075727099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MWg2VS9VVWdNWlFCTC8rNEJ6S0Q3eU82TFpibW5naTFEaWFoaEwydElYMytH?=
 =?utf-8?B?QjBITkQvQzBsYlhjMnBXRkdFZTUvdTZNZ2NmTmxjWVZiVC9BM1hpWWh2MlZm?=
 =?utf-8?B?Z2dheXpja2EzNDVOdys1MHU1VkYycHV2NnpvN0xLdU9iR21UZ3RMYVNzVVd0?=
 =?utf-8?B?M2pENDJPQi9oajM5RHl0bXh2cWpXN0lKNlg5Y0ZycXhkYlFhTWtwQkI3OGY4?=
 =?utf-8?B?WHpXYWE3VmEzcGtUQlRLUkV5Tys0QW9FTFNlTWhpZWFMYnNlVFpQcmI4With?=
 =?utf-8?B?anl1VnhPQTJFVEFibStKU2xMdWhSNFkxYUVjY01aTUQwOTl6bXdId2lUZVJz?=
 =?utf-8?B?T2RoaXFuc25FQUpjQmtSc2Z3dm1HQlQydlBzRExFcXM2REN3OGZtSDhEMyt6?=
 =?utf-8?B?TUxQaVAxMHBBc1RLVk5MRFNuU3R0NVFpZDYxMWNTZi9KV1c3MUZDQjgrdW5q?=
 =?utf-8?B?d2ZyeGhnSDlmb0hIZVhIbkIvd1J4VmtLZUNUVW1kcGNwUWVnQmI1ZTVBVTZo?=
 =?utf-8?B?MEdSQldrZ0ZjNmx4M3dZTDV6c2hKV3lhYWVaWkNRNy9PdTdFenBweGVCdjB3?=
 =?utf-8?B?eUhtSVZvREdqbkFOWGhCQ2Fidk9rak05SlRWWDZpdllOdjRQd0NxN256STRz?=
 =?utf-8?B?aUNoSkpuM0hZdXJaUVphZjVtcHAva3ZQOWF0RTZjNWEzYndzZW5nbEg3a0k1?=
 =?utf-8?B?YitFNVAxaE94ZDNGUDhqLzRtaHBYeE9QME9ESjZQbXMveTJZSEptSmQ3QUx4?=
 =?utf-8?B?UWN0VkIvMXBTWDVRbkx3WWFOdVBEYldsSkFwQ0pkaldJcFhSSnNDQ21nYnIy?=
 =?utf-8?B?dEFnSi9MMUZ4V1psYlM4RWNHK0JmaGVSalZrT3R1Qy8vTVVXdTNFbytXNjVw?=
 =?utf-8?B?bjFhakM1MzFDcjBjWDM5aFZ6cUVoVmtsUUpyLzQ1Z1JhNngybm9POUJJdkdN?=
 =?utf-8?B?Nnp2R21KakhoN08waGdISEt1ZmNkVXRYSjlnYXprSjkwVURhOHR3NExrRnZ3?=
 =?utf-8?B?L0Z2WThTMmYzaHliN0lxQzJsQlFCV2xBTzdVTGxtN0JSZklwSWlBdURPTks1?=
 =?utf-8?B?bCtGamZIZ1pWSS9WMEpKdkd3NUxvMlAwa243Z00xRHhYYVJwSDhheHVpR1Z4?=
 =?utf-8?B?N1Z6NG0vWDUwQkZ5MGx6eUFONXVRSFN4N283WGZVV0pTOERFcTF6QUNyUk1u?=
 =?utf-8?B?ZmxQRDU3d3d1Z3cvOU9LYkxhT2NmeWZHK0w5K0hxekFJWjRpWVlGeXh2elJy?=
 =?utf-8?B?bEJEc240dzMrazVMYi9QSFpUOUhqQ0dOeHFkUkhxeGVGNEVGOVRUSmJOeVRj?=
 =?utf-8?B?MklGMTdaSkNHSE1QVEZySHdrREtHOFhENDNsbmNGWjVMRWU0dEQwYzJYeVZu?=
 =?utf-8?B?Y3Fqak1DYlFxVDY1WGZkdDFXbUU4dElyRG1nYll6UHQvbGl0RmZDVEZzNWs0?=
 =?utf-8?B?NDdqd2trbS9RMDBPckxYcDVxeVNpSTJRQnVJdjQwaEphcDZkNnFmY281TGNO?=
 =?utf-8?B?N3BzVldVbmJqemVRcEFQWERBKzUxbnI4Vk1BS3JFakdKNG5CWm1rWTViaE1Z?=
 =?utf-8?B?OUs4aE5yanBSVTZDRDBqQTlKRS9jOXJHK1ljT1VMWkp0b01OU2FwRkswTVFY?=
 =?utf-8?B?OVJUdFFBQ0dBYXVuNkZMbiswUjlxQXFmYTU3OS9TalNNendNNkl1WlVkN0Nu?=
 =?utf-8?B?S1pTV1ErbVJBY1UyeVBQK1JEWGhlMXg3eTk3OGhDZkpjOTZCNWpTOTdMTzh6?=
 =?utf-8?B?QXNDenZtUDM2VWliVTRaWmNPRkwydkRkMjEwNTl0V0c1dnJOaUQ5MTNKaG9E?=
 =?utf-8?B?N3BlbDNhbXJVU3dPSVFiS21IeDdjUFRSN3RvL1VlSjluWmQ1cVZWWWdkWUVh?=
 =?utf-8?B?MTB2Z29ocXA1bUM1RWJuWVN6dGt6VGtBNW56WUcvTXBrczhZRFdoNkE3ZU1o?=
 =?utf-8?B?ejQ1VmplV2haaGxMTUk5SjczSHNsbUtHTkY5WFF3OFlNeXJzUmV3eUdDQk9I?=
 =?utf-8?B?YSs4TG94N09pZ1VPOTJpQk82ZEhWVTlGelZqRkFGSk8zSHY0V2NPc3FhNUVU?=
 =?utf-8?B?WFFrWmpwNitPSGpmenJxNGFUSTF6aU56c2RPL2JtRlBkR3d0VGZkR2FVejhh?=
 =?utf-8?B?VndhZXhheFpjUkJua2NQUFZhcG5TYnJpZ3REL1MyWlQzQUw0S2x4Q24wUSsr?=
 =?utf-8?B?TUhTT1hjL3RNLzdoSWtmbk9xUjc1M2ZuZENRajNhSFFjdHRhS0IxZlRwdXNk?=
 =?utf-8?B?TGQrOFRaYUZvUTEvMGVnbDAxbmFWc0VZQlhCaHVxTyttVWszNTc3T1pWdUp5?=
 =?utf-8?Q?J0jcDiU/n10r0EJabo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87368f27-205c-457e-171c-08df3b7a0ced
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 20:19:10.0238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2/LYHRrSTJ+BMJh7KZ9PiEiWJVDcoxU4oAscORJc8uZYV2gjj7ul4I3dts/wMsc6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB121967

On Thu Nov 5, 2026 at 12:00 PM EST, Konstantin Khorenko wrote:
> Device DAX maps its memory with vmf_insert_folio_pud(), which takes a
> folio reference, adds a PUD rmap and accounts the pages to the mm.
> zap_huge_pud() drops all three, but copy_huge_pud() copies the PUD into
> the child without taking any of them. Each child's unmap then drops
> what the parent took:
>
> - the folio is a reference short, so with two children its refcount
>   drops to zero and free_zone_device_folio() runs while the parent
>   still maps it;
> - the child's file counter goes negative, "Bad rss-counter state" when
>   its mm is freed;
> - the parent's unmap drives the entire mapcount below zero.
>
> fork copies the page tables of a device DAX mapping that has a guard
> region, and commit f807123d578d ("mm: allow guard regions in file-backed
> and read-only mappings") allowed MADV_GUARD_INSTALL there.
>
> Take the reference, the rmap and the counter for a PUD that
> vm_normal_page_pud() resolves to a page, as copy_present_ptes() does for
> a PTE, with a new folio_dup_file_rmap_pud() helper. copy_huge_pud() now
> needs both VMAs, so pass only them and take the mms from them.
>
> Fixes: aed877c2b425 ("device/dax: properly refcount device dax pages when=
 mapping")
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
> ---
>  include/linux/huge_mm.h |  5 ++---
>  include/linux/rmap.h    | 22 ++++++++++++++++++++++
>  mm/huge_memory.c        | 27 +++++++++++++++++++--------
>  mm/memory.c             |  4 +---
>  4 files changed, 44 insertions(+), 14 deletions(-)
>

I assume this supersedes David's version[1], which uses
folio_add_file_rmap_pud().

[1] https://lore.kernel.org/all/20261031-fixes_core-v3-11-d6437171ecc3@kern=
el.org/

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi

