Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2132.outbound.protection.outlook.com [40.107.244.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E955A15AAD6
	for <nvdimm@lists.linux.dev>; Wed, 29 May 2024 15:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.132
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716996314; cv=fail; b=UFdNk7tKSvBxMkGroQM935csSF1BvzSB1L42fbfdAlzkEVaLI6vYr4S3VQgTAG1A9FtW2XjpQCzWj+TCmP+LIi2RRHbgnGJwpKHrCqUCvE/sOLpZSxbTLk2emdBXGz+NYqx7T9ojqzzaA3oU0MAtBHBkLE902BF64OJlX9ObttA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716996314; c=relaxed/simple;
	bh=KH2c4x0rbCeNTduzQmJZ8txWN8YsItNWfXJoY1VYlO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JDSFMYIRrgGaiXzBwXbWKJ31OnPrfVFUnX3e7ZpzSpPz88N57QB3qqaNiEJ7NctMVq4KrDv40BrhCbUkTlJdot8iKkJSTc9rl3AVi8Gd3lit9NEwZ0/f/5r6aV4OqOam4m1G+qnrXX2TRkLD/VyiazFg4+15p0usdSXhIXYECRk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=memverge.com; spf=pass smtp.mailfrom=memverge.com; dkim=pass (1024-bit key) header.d=memverge.com header.i=@memverge.com header.b=TRZUOGk8; arc=fail smtp.client-ip=40.107.244.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=memverge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=memverge.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=memverge.com header.i=@memverge.com header.b="TRZUOGk8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DxwTMhg0t5wyWhYRC7m5FN/3G21kCUnsW6gEk8z2eS6hF9d0EJzJSMQiuKVK7IaErXTsbW6BsoConG/LiIPrl3EWAUD0AQ6ALhkpSPdtCQO1sV2jRAzHvGaoUFlMZY4M15T1xEIzL+6oYuG5CWHprSqBZYCeAa5i23CVau6qrXUGd1iA3AqTGSJjBrItNh96gBavuZAc5nGn0fscz66icUNsGGDZawxVQyPwJxaTDqNPPRxI442y+eFdneGJUUqOr+Tmmm58en2QMkXy/52Nm4TcoxN6fn62QfT/67g8hZ4Y2J8JlN1YMdiv1K0sjIvZWd2YDF792OT+WTWQ5E0P4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NgOSYUjd83CH8Lz94T09tCCA7wOcti4rZ4mNYFqGyHA=;
 b=JCyK4N4oI2koBsb91HGCGdU9fQRfRG4jdv9ZLPBAh9K8uMqjn5JrNN4oEfwuDjirD8wG/L6Dy9tfRgpMhUQIQ/u6McbeBg8iuraRLlVYrotWr04cuYqOUqtpOrJxY1OkXdnvKhRpTEAVWFXxVh8allRni/Fv11QjZAYUYxnymLiozk5Pz7YStIYGNPoIWzZSBW+EqUuKqDYyRerGoXvg/xk9dbUaMGhyXnlxIIb6/r5MSfh5t5q8OZ6V85jHz1QqndOZqP1mNNrCuXFskeeFBvbzipCc2X+6KjTQG+lyDZM1kD9Zsus5YiVvbMnS7UFGWWW4JPlPOgY9zefqgkThEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=memverge.com; dmarc=pass action=none header.from=memverge.com;
 dkim=pass header.d=memverge.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=memverge.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NgOSYUjd83CH8Lz94T09tCCA7wOcti4rZ4mNYFqGyHA=;
 b=TRZUOGk8Xj8keJA2CdKYWVyYmRxeWG3A/rPIbTmC90TpmH3dXBROvJPloQ8g8KNHvxy2GUBFt4/z55qzRIRUjIg2d3vdKg4fQGs5w7LbbyS0LaoxWTaFylGm1umHfWdV7mgz+ukQ7cOeA2onpelP4QBvIV3DgYThhV9QPFxDdtg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=memverge.com;
Received: from MW4PR17MB5515.namprd17.prod.outlook.com (2603:10b6:303:126::5)
 by PH0PR17MB4623.namprd17.prod.outlook.com (2603:10b6:510:83::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Wed, 29 May
 2024 15:25:09 +0000
Received: from MW4PR17MB5515.namprd17.prod.outlook.com
 ([fe80::a27e:e0a5:9b63:297f]) by MW4PR17MB5515.namprd17.prod.outlook.com
 ([fe80::a27e:e0a5:9b63:297f%6]) with mapi id 15.20.7611.030; Wed, 29 May 2024
 15:25:09 +0000
Date: Wed, 29 May 2024 11:25:02 -0400
From: Gregory Price <gregory.price@memverge.com>
To: Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	John Groves <John@groves.net>, axboe@kernel.dk,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Subject: Re: [PATCH RFC 0/7] block: Introduce CBD (CXL Block Device)
Message-ID: <ZldIzp0ncsRX5BZE@memverge.com>
References: <20240503105245.00003676@Huawei.com>
 <5b7f3700-aeee-15af-59a7-8e271a89c850@easystack.cn>
 <20240508131125.00003d2b@Huawei.com>
 <ef0ee621-a2d2-e59a-f601-e072e8790f06@easystack.cn>
 <20240508164417.00006c69@Huawei.com>
 <3d547577-e8f2-8765-0f63-07d1700fcefc@easystack.cn>
 <20240509132134.00000ae9@Huawei.com>
 <a571be12-2fd3-e0ee-a914-0a6e2c46bdbc@easystack.cn>
 <664cead8eb0b6_add32947d@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <8f161b2d-eacd-ad35-8959-0f44c8d132b3@easystack.cn>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8f161b2d-eacd-ad35-8959-0f44c8d132b3@easystack.cn>
X-ClientProxiedBy: BY3PR05CA0047.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::22) To MW4PR17MB5515.namprd17.prod.outlook.com
 (2603:10b6:303:126::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR17MB5515:EE_|PH0PR17MB4623:EE_
X-MS-Office365-Filtering-Correlation-Id: 67490fab-22f1-4781-1a0c-08dc7ff386a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bE9HSGJWdEFRRE5Wd1FUbTZaVXRSa1RBelZCNlcvL0NYWnAxbjNsZU8rdm9t?=
 =?utf-8?B?UFhvWFplbzB6RmdYVlU2N3ZhQTF0bWpJWXVGcTQ1bUdlZXp1dFVDbmp0KzRl?=
 =?utf-8?B?emVPbmJsVkhqcFhvalZ1Yi8vWEVjb3lpTEkwOHdHN3NSUVFmT3dQd1hKWk9t?=
 =?utf-8?B?ZnhPZjU3K0dpOUUxNlNMK0I4ZjB6VnBFSlJJU3dwZEwwaGJCd08zZVBqT1ky?=
 =?utf-8?B?MkU2SUptL1BIczllbm82MFk3NDNDRXJOVEFVYkxsd2NTWDJCMFYyNEtEb08z?=
 =?utf-8?B?SEQvYVdTUmh3MGF1d0lCSjFxTVYxVEErSUp6cWZrREQ3cDB5YkpSZk9idUlD?=
 =?utf-8?B?REtoNUJwTEQ3NThmMXBpYU9aekNUcGJPM2h4Ums4ZUdyTkxUZTN0M1VGUUkw?=
 =?utf-8?B?aEIvK0wrR2twSUgvcXEramp1SXY2UzhMS2VyTzFZU1lVYlNUUjVRcjdGUGl2?=
 =?utf-8?B?MkxJTEVhbzNvK3hRdWFJNXdaZDZGNm1KWW93ckxwMEpDc0NaNkp2REQrNXVU?=
 =?utf-8?B?YTZXU2xrYmFmbm9JNkN1cmhTclpsUFBuajk1M0RBc1UyU0dURWFMbnNUWWNK?=
 =?utf-8?B?OTZ0UnoreEkyODMwRUpvNVRUZGdmR25SM0xsYVB4d2xZSURGTkNyV3BiT1Jx?=
 =?utf-8?B?cVpSNkZnQ05QWFNFT1RLSkZtMjhDakFEcWZCTk1BRVQwYXRkL0h5SDBwaEhL?=
 =?utf-8?B?cHhEbnh1SHdEM1Q3Q2ZrUDY5TEhlNmRUOTFFWVU3cW1FVktOb3I1V3dvaUhq?=
 =?utf-8?B?ZXR4UTk2WGc5elFTR1c0TU9EbzlTWTI5QVYvNWV6K3VVM3pNWHlFbXZkaHVr?=
 =?utf-8?B?MVBuTkF6bi91c0RHdUtYWUlrVXdodUkyR2dueGU4a3RQMXMzUVZEdEExRm1z?=
 =?utf-8?B?aHA2NmFPcVFuL20wZkZPNEhhWWZzSnNGZWcwSGRqMnNUZFplU0Rvaktiai80?=
 =?utf-8?B?b0JsMEtxc0hZY2ZFaHZDMzFscXV1UFQxYnNqTkxmWmZGcVk3UUphU1VYSHNu?=
 =?utf-8?B?bTZDWm9JSnVtbTNNL1lTSFlYVlBQQzFFbWdkNldGcWZITXBKeWJPVnNGTWlD?=
 =?utf-8?B?UjF2RE8yYUZzNTZRcm9lMWJicU5sTzFlSHZOWTRjaHBTWUJjNzAzYkZWa1lq?=
 =?utf-8?B?aGdiVzVoL0ptWEhmdjg1VWtTMkMyMkJySXpEazNVQmhRYUFybnVhaDMzdVBC?=
 =?utf-8?B?dUFkZzQ4eWxSaU84WVZvMnhET1RYd0ZqMm1wdGpsRnNDd212aU5wOUxLLzFU?=
 =?utf-8?B?ajZEODVQcG1MMWlrc3NUdVBGNktzSTMxVHRnNVB0TjVnTGsrdEdPYjhHSUlp?=
 =?utf-8?B?b3VVVExkSVB2bmlUZ2JHTEdWT0hBS3k4dE12L1dvemxCaGo0WFUrSGhkNTRl?=
 =?utf-8?B?WUJrK2g4bGlOU3o0SzViWjZHbENUZEFjekFoTTZLMlFGSWhNWUVkR1EvNUZ2?=
 =?utf-8?B?Um1nd25rSFAxbnE4M3dtWkF4amJBT3QyM3V4bzRVM0pWZXRFRytqZkFFRFRk?=
 =?utf-8?B?QlVINVJpU2w2TXlkSWd1ekV3SUxhRzdZN3BrdWpBV3VxeDBwZllvSE1oMllj?=
 =?utf-8?B?UlMrZ3dzSnA4ejkzRjVyaWtsczF1MTNYSWcvQmN4RVFBRVlmemtRVnVFdW8z?=
 =?utf-8?B?OHczMGRkUnJKbWRLL1dCRmJiam9OUklzWnhVNlBuOFhVaHdXa29WMFg3ZC9S?=
 =?utf-8?Q?GZZx6EQiowMPv7b2Cx0e?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR17MB5515.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WEtrRHh1bzhkSitPc3BJM1AvWGh5ZHpCZkgxOGFiUmxGc1lydy9LUE50Ulp5?=
 =?utf-8?B?VVpjakxGdFBHTDVwM2E2ZzR0VkxkSVlRbWlKSll4ZS9YeFdBVmpHWG94QVNB?=
 =?utf-8?B?RkU5d2kya3IvZ054VnZwZ1VLdGQvTU9taXEwZHNGTzQ0eGFzdFdncThGcHEw?=
 =?utf-8?B?eTM3WnVRRFZ5Z0M0ajZ3N1h2THBDVWRtQ25aMHp5VWV0enR5TjBtSXNhTDcw?=
 =?utf-8?B?bU9HQ3RzYmppSHZjY3pxT3dob2NUcmZEc1lrYVNSa1VZRzZWTjhId0x5UGxu?=
 =?utf-8?B?alZwMU1rSFE0MGJJemwvUElwWWNtTWR5cjhEZGs2VEdVYWlXcjNHN0dIVE54?=
 =?utf-8?B?Qm9mR2Z5UG0wOVBtZ09BYWdNMlVRbi9BaG4xdkIwNVhQdG9ZZVlFdVRjbERx?=
 =?utf-8?B?L3hiZkg5S0ZaUFpscTZmbXhMOW1ScVQydTUrSkc3eE5DRE5ZdTRmZ0RSQ2VR?=
 =?utf-8?B?L2h3b2tJaWppVU5rOTdXV0FNZVFyVnBaY0xodGVVc0k1emFUaXNGaWRmd2o3?=
 =?utf-8?B?NUViS3p5eVMwYVlzNzJXN3ExdHZyYTJvdWFPVTBIWDVQOW5HR043SVVDY1Nz?=
 =?utf-8?B?K1V5WFFnMmR5TGRLa2ZEbVYyNVJ6eXBlb3haS0NEQTFOL2plWE92Q003b2gy?=
 =?utf-8?B?SVF1VGtHZFdWOTBhOHZJclUvM3RWREZleS83dHVFQ3MzOFdueVNvc3JJVkpm?=
 =?utf-8?B?Z2pEU2ZFYjRKeFBYcGRCV3MzMVBxWVQ0YkxXdDJ1eE9raFJiMkZPMGxxSWx6?=
 =?utf-8?B?eEEwTTVDR2RtZTh6Yk5zelQzYkFmTURGakhLdXRUb2xpOVQyNjgrRVQvK3hV?=
 =?utf-8?B?Y0k4b2hYVnVQTWM3S29Ca0JQUDV5Zi9ZeHhzdVNITXFwUVlBWUVaWEs0aHR0?=
 =?utf-8?B?LzVrQ2xLY25vTWVvUC90RUlyaVhmdjBGWDlDRDFPb2hrOTNxS1djMHJiWGpr?=
 =?utf-8?B?Qk5xNXpzUy9qK0pOWnNPeWR0T01jVFQ1UkY0dzdTM1B6bjlodWtuU1Z4cUQx?=
 =?utf-8?B?bHlDenpuNkdKU3l2bWl6NHNXS0hSR2pHbzN1THlFQk5CbEhKaW5wRUZNckFv?=
 =?utf-8?B?QzFUM3Z0NjIwL3hnaDBIdlM1bDg3Rzl3cFZlZGU4L2szVjY1MllxWXN6QW5r?=
 =?utf-8?B?QTA3TjNsT2JaWWFkOXFDajBLY21uK1Jwbm5OQnJRb0xkV2ZTMmtMd09WNnAw?=
 =?utf-8?B?bE9yYjkrV1grbDRTaFl1ZVZJTjh3ajZVcFRZOVJlekF5MDVCdk1FK0NiNnBr?=
 =?utf-8?B?aUNQK3gvL3NDSkNDR3hXc3FBY1ZwV2pVN1FNbUJveU0rS1VpTkx6cDNvMXly?=
 =?utf-8?B?NEYzQnZvUDl2cWttYjQ1UUlrbjNaZGFtYUZ4WnR2eENQTWdpdzFXK3pnb2JF?=
 =?utf-8?B?amFkcDlWVUlhbTVjVnhkUVd5R2RINTg0MWh3WHNqZ091bUd3dlNkMjUrdElP?=
 =?utf-8?B?d1o3cDZBbGIyQTdmQldETlprUUcrNFA2bFVGK0JrRnRpMWFKalVXdGpTdzAv?=
 =?utf-8?B?anNWYlpYN3ZlMS91ODJlRXlsdUIrWnpTY1REL1g0L2M3UWMvMnkxM1dWYlVi?=
 =?utf-8?B?aVZNVWNzcUU2TjBzOGpMaWdPOG5jc3BZSHoxOTFvZDliSDk4NFFIVFVZVXNj?=
 =?utf-8?B?WnNaeStBdU1EdVB5amFYSFRTYWdPdndZR0xnVEI1WG9Yb2ZaaHlFRXg4cWNP?=
 =?utf-8?B?WDFlY2U3RkpKM2V6cm16QlZVTzRXUjFTYm1CYW0zbDZTNDJSK2VLeTJZMldi?=
 =?utf-8?B?dUZPdXZKSDdTSW1TLzQ4SHZGQ2NrZ2lOVWRHbEhEZStZTTluRmVrSEc1Uk1N?=
 =?utf-8?B?SlVOVG16OFlveFQvL3F1YU9jaU12Nk02VjhKQ3JJQm41eTRLRG43dzJMWjAx?=
 =?utf-8?B?UTlGV0E2SlpQVENyRzJXZHcwa3E0YmVpVzZpY0ZZaUg0YmdGVnU4V0tvaUhr?=
 =?utf-8?B?WC94dEREY3FmeXVBdFNZUlovQlhGTGR4KzcwVVVQSThBWVdZc1MrdFd5d3NS?=
 =?utf-8?B?cXJPeEJRQXN4QWNsOVRkUklzVXZ3Yyt2LzEvbUJGRzBoRldrUjViUVc1NEhR?=
 =?utf-8?B?R1lBQkEyY3E4alJwY0VzQWZLYTNwOERENHU2cUpUKzlYQUU0a0RxVzFiZVUw?=
 =?utf-8?B?YnR2OW9pNlYydG43OTRPR3Fwb1hMS1Y0SGd5Wlp2S2p1SlZpcFRDR1FMeTN1?=
 =?utf-8?B?b3c9PQ==?=
X-OriginatorOrg: memverge.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67490fab-22f1-4781-1a0c-08dc7ff386a3
X-MS-Exchange-CrossTenant-AuthSource: MW4PR17MB5515.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2024 15:25:09.3714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5c90cb59-37e7-4c81-9c07-00473d5fb682
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tdkv43Z5hizUY6haSuXiKQekXQjCozgMEhYOrROnJO1Mm0eAlMMr4ksYYR4ZkYeiJY1wxGXEwKzN7t7xPePVR5Ssjka0BczRZdfGHQYEADo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR17MB4623

On Wed, May 22, 2024 at 02:17:38PM +0800, Dongsheng Yang wrote:
> 
> 
> 在 2024/5/22 星期三 上午 2:41, Dan Williams 写道:
> > Dongsheng Yang wrote:
> > 
> > What guarantees this property? How does the reader know that its local
> > cache invalidation is sufficient for reading data that has only reached
> > global visibility on the remote peer? As far as I can see, there is
> > nothing that guarantees that local global visibility translates to
> > remote visibility. In fact, the GPF feature is counter-evidence of the
> > fact that writes can be pending in buffers that are only flushed on a
> > GPF event.
> 
> Sounds correct. From what I learned from GPF, ADR, and eADR, there would
> still be data in WPQ even though we perform a CPU cache line flush in the
> OS.
> 
> This means we don't have a explicit method to make data puncture all caches
> and land in the media after writing. also it seems there isn't a explicit
> method to invalidate all caches along the entire path.
> 
> > 
> > I remain skeptical that a software managed inter-host cache-coherency
> > scheme can be made reliable with current CXL defined mechanisms.
> 
> 
> I got your point now, acorrding current CXL Spec, it seems software managed
> cache-coherency for inter-host shared memory is not working. Will the next
> version of CXL spec consider it?
> > 

Sorry for missing the conversation, have been out of office for a bit.

It's not just a CXL spec issue, though that is part of it. I think the
CXL spec would have to expose some form of puncturing flush, and this
makes the assumption that such a flush doesn't cause some kind of
race/deadlock issue.  Certainly this needs to be discussed.

However, consider that the upstream processor actually has to generate
this flush.  This means adding the flush to existing coherence protocols,
or at the very least a new instruction to generate the flush explicitly.
The latter seems more likely than the former.

This flush would need to ensure the data is forced out of the local WPQ
AND all WPQs south of the PCIE complex - because what you really want to
know is that the data has actually made it back to a place where remote
viewers are capable of percieving the change.

So this means:
1) Spec revision with puncturing flush
2) Buy-in from CPU vendors to generate such a flush
3) A new instruction added to the architecture.

Call me in a decade or so.


But really, I think it likely we see hardware-coherence well before this.
For this reason, I have become skeptical of all but a few memory sharing
use cases that depend on software-controlled cache-coherency.

There are some (FAMFS, for example). The coherence state of these
systems tend to be less volatile (e.g. mappings are read-only), or
they have inherent design limitations (cacheline-sized message passing
via write-ahead logging only).

~Gregory
