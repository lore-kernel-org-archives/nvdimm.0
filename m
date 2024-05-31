Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2107.outbound.protection.outlook.com [40.107.93.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5511F959
	for <nvdimm@lists.linux.dev>; Fri, 31 May 2024 14:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.107
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717165436; cv=fail; b=EdKVDhjTC8/mm2YEEqHEQrUKju/b0UZqlM5Bpjs752HugzWxCfKMvLqNf0Qv0MdbHwgpxPESWzsAo8OiszXeeaSDhIVXevKX7bB88YBCHV3GlPrD2ruobvLLTeDUgxmeW5uZU4K/yQOrlk9/DWMeV3w3GgJazC+1LBEi4y5KFTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717165436; c=relaxed/simple;
	bh=oP+BFIYw0crJC6AerN5WSCF40UQK+EJRNTBVxvnShzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uGRPSFE1PNq45f3YMVyF5TEbsz15Smtdoe4hXnR24qO0bWXfnjBjQeHtqGZF3ndSl8arXaWATwkW7XTKuScsVRSQx2Hq8F4X+8vSjLdCinxv+kjNUQAyXgDYvBHx+rGJlFKMfYcq2SYSDNy2lGmUk5W9xi2UBhF6gSnC7AnQBbA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=memverge.com; spf=pass smtp.mailfrom=memverge.com; dkim=pass (1024-bit key) header.d=memverge.com header.i=@memverge.com header.b=di4SGgMD; arc=fail smtp.client-ip=40.107.93.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=memverge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=memverge.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=memverge.com header.i=@memverge.com header.b="di4SGgMD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FgUZKTbAIHx5Ae2Wi9k6zj54LTPwArRw17kR1Q0uj7EKn6EmmMa1WHqu9fpg+yJdhRctZlQyemUPnWqiFNkF6IRMhVGTY9lPFC0GvAG81fFnEwD80mDi1sW9+0ZFvDLFEjFfATOnYHCXe86dFYrO5pPdRHAeAAe2qRNXOL1q7RKUv6P34LkTEXSrsKjB7L/26lFUV5U8GUrSeLjqcjGDTQLOC6P8z9nxTUzVNjjCLlwHcS+id+2k2oc3oCdeFyN8kNWM/Mn3vdAKwiodkvgRR0rqbMDCDKVuhALDH/v7L4iuBSQuqKW4oa5yGkOsoF5WINMdOtRsYKI+RjzhAlZgLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=waV6iEa7vFVwHio4JfoyFRmDoERH3djmQBYt5ePHlLM=;
 b=m2dhQvVXvjhbKTCqxKgoRM65JaY5py6HhJA2zAXOGAZUJyf31Xbpf0CP3T3uT6GC0XdEXRexaOV6z2wROzFHBXzEbwqkkGezSDukp5BEYk47uzBgfbSB1yjKzYbARssL272fH9yLXRHCDiDUDLZBnL7uDz2zJB5MzYgAZpNzZfVKowiv+WZqazFUFj0brHypv3h168OeKfeihoDxzbFZRpOAyXER/FvOvRYqE7TVHohABq37Y7EbdQefK9hjNZ3wSWg7u9dkCDsy5V/6QbDgnaQGKTDc2uRZGbTNDo+xySlcgnwtWUNIzCcPyzqF0+hEGanqISRKQFEgZEyDw6zVlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=memverge.com; dmarc=pass action=none header.from=memverge.com;
 dkim=pass header.d=memverge.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=memverge.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=waV6iEa7vFVwHio4JfoyFRmDoERH3djmQBYt5ePHlLM=;
 b=di4SGgMD8VkRYdhX0okjAsbwh1DZVOob79EmV5gdkcCaiOUuDQYjd9+Tni61khF3fa1wGfERpRysTds1bh42aE21I7yfruOsmODOC0NFySCPCySK/lBO9bQrff116wGqwtAGnshxvonOycj8zyK9XdWIkGmBEoJYQwkiUK3MTOI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=memverge.com;
Received: from SJ0PR17MB5512.namprd17.prod.outlook.com (2603:10b6:a03:394::19)
 by CH3PR17MB6666.namprd17.prod.outlook.com (2603:10b6:610:132::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Fri, 31 May
 2024 14:23:51 +0000
Received: from SJ0PR17MB5512.namprd17.prod.outlook.com
 ([fe80::5d53:b947:4cab:2cc8]) by SJ0PR17MB5512.namprd17.prod.outlook.com
 ([fe80::5d53:b947:4cab:2cc8%5]) with mapi id 15.20.7633.021; Fri, 31 May 2024
 14:23:51 +0000
Date: Fri, 31 May 2024 10:23:47 -0400
From: Gregory Price <gregory.price@memverge.com>
To: Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	John Groves <John@groves.net>, axboe@kernel.dk,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Subject: Re: [PATCH RFC 0/7] block: Introduce CBD (CXL Block Device)
Message-ID: <Zlndc8NI0eK3MmuR@memverge.com>
References: <20240508131125.00003d2b@Huawei.com>
 <ef0ee621-a2d2-e59a-f601-e072e8790f06@easystack.cn>
 <20240508164417.00006c69@Huawei.com>
 <3d547577-e8f2-8765-0f63-07d1700fcefc@easystack.cn>
 <20240509132134.00000ae9@Huawei.com>
 <a571be12-2fd3-e0ee-a914-0a6e2c46bdbc@easystack.cn>
 <664cead8eb0b6_add32947d@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <8f161b2d-eacd-ad35-8959-0f44c8d132b3@easystack.cn>
 <ZldIzp0ncsRX5BZE@memverge.com>
 <5db870de-ecb3-f127-f31c-b59443b4fbb4@easystack.cn>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5db870de-ecb3-f127-f31c-b59443b4fbb4@easystack.cn>
X-ClientProxiedBy: SJ0PR03CA0284.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::19) To SJ0PR17MB5512.namprd17.prod.outlook.com
 (2603:10b6:a03:394::19)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR17MB5512:EE_|CH3PR17MB6666:EE_
X-MS-Office365-Filtering-Correlation-Id: af8599d2-1dcc-4765-623f-08dc817d4b08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Rzl4MUNYbENWS0M0emErZllCWVJEUXhNT21LeG1GcFd1QU83aU1taW9icGN5?=
 =?utf-8?B?cG9nY0xjTm51YUR6N3MvUndHaUpyTjRjMnF4K0tqUmdBRFUrZ0NOdi9LckR6?=
 =?utf-8?B?dWN2VW9udzVSZ0lsNVV6UDBHOW5BQ3UvWHY0SXpSY1pnb1F0SVpQSXFLT213?=
 =?utf-8?B?emREclVEK3hoYW54d2xjaWRIVTJWMWlHejlxRkpVeTR6N3ZzTjcwY1FEV2Vz?=
 =?utf-8?B?VGpZSW1oNm92ZXNReGYzUjZpSnlHOFhidkdDWUkyVEpKNGhINGcxcmVEckJt?=
 =?utf-8?B?dUNYL3JSMXQvUXhQZzR1VWJScXoyVjhYWG5QN0Z4eTk4VU0zdzZzNkhmVHdw?=
 =?utf-8?B?Vy90Q0ttOGlocjVLQ3ZHaVJCTXYwNSsxQUtvcWJCZ21sdWZnZWZJaDBIcURD?=
 =?utf-8?B?WkxUalgxSUlKejlQSERRMG41UlFERlJRcFhjc1c3Z0lRQlBJWGRmeVJxS01J?=
 =?utf-8?B?cDB1VE01SnBnaWI5VmVOYUZCMFdPaVYzMG9wSUVoeXdFNFlvOE1ZNE4reTdC?=
 =?utf-8?B?NGViUFNiQ2VMUHo2WTFYeEFhM09OWU5qTlVWdndrbWZhMzB2cDBxU0grY1o5?=
 =?utf-8?B?eVFrOUxJNHd4c2hxZ0hOVG83MzJxQ1lhS0pocVRSTmVaaTcyT0lkRlFsSjBt?=
 =?utf-8?B?TGlaSU56ZTNLWVl6bUlwWFV1SDMyNUxPWGVRaUhMd1c4b0tORDVHRnprRHM0?=
 =?utf-8?B?RUhuMFl0NHZEaDBZSy9QeFlRR0c2RzVPVUpCNVBIRzNuQTdMVDZabE5UWHQy?=
 =?utf-8?B?LzhCRXVhOGtodUxnc0QyelowZWZ4eGVZdDRsK09GTWVSS05sb3RZRmx0aTdo?=
 =?utf-8?B?WG5Na2ZpOVdyMkZzeUovS2RrYUw5V1FJakRwUWduL1Y3dmZBTW1RSWpRb0ZS?=
 =?utf-8?B?NDFQSXNWU0ZJS3dWdmw5SVVtZzJsQlp4L3c4Z1dvSVRObTNMb3k1SXpRUDdU?=
 =?utf-8?B?SGRleUk5YmR6V2VvejNkbnZQOHh4TU9qS090L0dFOTZCTWw5QW0wdkRjSVNx?=
 =?utf-8?B?d09nRW9uUFZ5elVLZXFZR1VLUVhKajE4L1NCTlFrYXlSemt3YjEzdkJqTlBp?=
 =?utf-8?B?S21xK0lXTnVxVUgxRHFtU3dnSk14MjJGWldOaHJpWkxGamZGM1lpM3UxVi9a?=
 =?utf-8?B?MEs3ckRlQ09oWW9PVC9uOFpBQm5UMHk1bGJUazhZZ3VIeHl1UEtUWjFIdDJz?=
 =?utf-8?B?VGthQk5UQXBnQ004Y3RyQlZHL1pld1BUYkhkMWtGcnZiL250NWRsdVNTWGQ4?=
 =?utf-8?B?c1RxUHAwaXVmUVZFZnNvai9FWFlDR1J3YUZRRkZkbE1jZnNZcitwUklxd2pl?=
 =?utf-8?B?SG9YWjkvRzJkQk1mZ0tCUG11VG5rSUp0WTFhN1MzSWlMOWlXanpLQ1QzMzZ5?=
 =?utf-8?B?dURJNjZLY242SCsxWXZ4VFA1RlBHbENBOFdMei8rOERLUHFOakhQelJ4MnZR?=
 =?utf-8?B?MFNvUFBCWlpGL3FGY1lrNlFidUs3UVZDeG9CYU5NS1ZnbFdCRWpUR0cxaTdH?=
 =?utf-8?B?VXRnMnBBTXlDWU0zY0Z1Z29kRUpoaXRZdFdoZjdOc0hoZmdqa2c4MjgwMFdM?=
 =?utf-8?B?YnlqcTU5MkU3c29oTU9YZWNkdlNmbHNCcWxmcU10UGJWTUlEUWJFWlhjS2pF?=
 =?utf-8?B?d0RFdDBNSE5DUmU4SjNDcE9wVkk5R3VxMlQxTlNUdk5vNWM3SGNjdHFzbFNF?=
 =?utf-8?B?S29JZmttZzd3RFdxb1Z0bldhQjRXL0s3cWlYSHNLQ3hpcXVrVWN1Zmp3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR17MB5512.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q0NVL2JBbU83Q0o5V2Y0M2tKMlcwREs0dW1rZFROcGZXTVU0dlJycDdDU0Ru?=
 =?utf-8?B?TXY4Y1VDNjltSTV6M0dYYmhDWk9zeVp1ZGRwb3RPc0lTd3ZrSjl4dTY2Y29N?=
 =?utf-8?B?c2FCS2xwMTRkTW5GbVMwR2NSVExsK2drdFB5NFFRRG85S3dsUUNXQXBVUFlJ?=
 =?utf-8?B?c0xLakd0SDRTMGtJWVpLT2YxbDBSUzNCTVNOQ2o5UzFzS2NBMTdpazJCMUMz?=
 =?utf-8?B?aTcyalpMc3ltLzJ6aXB1M0VvVWFFVitnS2l0Mm5LK1ZoQlpXNEkzSkptd3pO?=
 =?utf-8?B?ODJLSzhNWnJmT05KQloxWXFLSGNOWnllUzUzOFo5SHNOSXF2QWE5U3FiYXp4?=
 =?utf-8?B?dmE3WDFlcS9talh4SEoyT3U0bm9IUUJwaTNtWUY2Y2FaSGZkM2J2ektyeDEy?=
 =?utf-8?B?STdrV1F2Q2gzVzJvMHRWTVNxYVJyN0VrSEFYa0I5WDRLRmgyUWQ0c1IrdUxk?=
 =?utf-8?B?QjZNYjhteVQyWm15UGpHMUpwUlA1SE4zYUN3VC9FdjJ6YUgwaENLbW9WYUE1?=
 =?utf-8?B?S3VFT2JmL082N0lXNFJvTjZ5ZUhVRkkzUzJEZmVWNXZMbW5BZ3A4N09xTmdM?=
 =?utf-8?B?SVkyR2ZLbUliaW4vL0hsK0NtTTQyK0dwRmhCMG8ySHdUeGdsSTZ3UklHMnhO?=
 =?utf-8?B?Q1FKZ2hQbndDQnlOVXBLL1lSckNVVlpUaFZoeFVqTHVDdndCTExNdHdPWXZC?=
 =?utf-8?B?ZmhHd0RnY3VyazRGbjBtL0wwQitLNmNNV1JBTTFZNlVyOVh4WXNVK0ZQeXho?=
 =?utf-8?B?aXV1Yy9vRi9EV2dUUGh1Vm1GU3FMbkZWMENKUkpEejhIaXlaOGhXWmtIV0Uv?=
 =?utf-8?B?c1lnVWVVQ2ZURXgwTk1DVGpuTUd0SkZ3bTJ0NFZ6RjBSeVZmODZEejJ1WlVK?=
 =?utf-8?B?MG1sUVBBLzdJRzJNVkdjZG9ydTEyVGNDK0hERzJlRDN5NkU1VmxnSFlVWk9C?=
 =?utf-8?B?Ty82Mlh5N3FubERLWGFKM2pMMVpHOFBlRnpzVnoybzZrZUp5K1gvMDRId3Ji?=
 =?utf-8?B?UlphTWttTTNSLy80MmhnckthSm9EOUVGTWtzcnJyVnBNaUNvc3FQNG9Od2Mz?=
 =?utf-8?B?dVgwLytqNkdIYUlIRHpocnBpZzBKRmxqbXk0YUlrMzI3NndidEc0MEFSM2Rv?=
 =?utf-8?B?SnE5Uit6dDdaODEvemdYL3Z2TjhTdGJYL2hudEIxMGlSclFOcTNTREpmN1M4?=
 =?utf-8?B?dWJONmVBWDJnd0hlSU56RFFhRENSUU1NaGlncXVINzJ2MnBRamZJMzcyeHdp?=
 =?utf-8?B?bVNxTWNWbTdEQ1dhOWREaGxFSG9OeXlRc09aUzdwZUF5L1VaaGxFcUU2Z1Zt?=
 =?utf-8?B?SHRzbW9NOWk1RzdKQnJ5RGUyU2FxNFR0VHZPSjluR3dtQk56ZGxlWjUxdVox?=
 =?utf-8?B?VWhCQldKUUFXTTFhRTlJZHFjc0pXTEl2ZmJ5d1Y1ZTJYeWtnaEpHYTlTOXJT?=
 =?utf-8?B?LzVSQ1M3OWJ1K1BtOHNld2lwN0VKNTJnQVdsYmdYM0orVUZYc09EeDdFUDJy?=
 =?utf-8?B?M3ZRYnZlY2RYOVBHckhaeUF2dEN0TzJTNytJa0d4REpxUmM0c1VleGd6Rld1?=
 =?utf-8?B?RUdvblJOSWRyWGdqTkp1dWg1QkFHK0FiWGFuWnYyanZvbHhLYU4vOVplSExD?=
 =?utf-8?B?bFU5cy80azAyVVFCd0p3SnBoeW42M2JKV0JCNjVpY2F2RWwvWGtKL3dSYlNL?=
 =?utf-8?B?NXptbjdNMDdVK1ZySVduVmNpRzVjRlNGL1NaWVZoWW9laUtobG1HOHF6dnlU?=
 =?utf-8?B?djF3Vm5OYVVtRGltTW1UUUE4UlhVZGp1L0FoeXI0TEhzZnIwUVM4WStWSzR3?=
 =?utf-8?B?M0pTUk45Y1VpdUtnTDVVMnE3QTA2T1Jib1JlenB2VFJvYldCSmFxSGtpTVpJ?=
 =?utf-8?B?WUFhbUg1VnlkTmtmcHRYaTZ6Szg0azNrdjZFaGNHc1BEeGFkajJubFRoU3F6?=
 =?utf-8?B?L29KQWV3dE5TZFJUZFpVWUpsOGx5SDJXQjBPZDNjbGZ4ZFU1QmhEL1gydGhm?=
 =?utf-8?B?NEE4Sm5xTU43NklIS3dHRkZ3dkErZ0lZZW1DdENuUm5XWDh1WWk3UFI0bk1Y?=
 =?utf-8?B?Zms2UDdlOGNhR2p5RlZqcS9EMk94b1hMZkN6SnY3RFFtVTlWLy9rcUNrWHZB?=
 =?utf-8?B?TlJhTTBoNWNiajA3dmpSWklBY1VMMmsvcVBkbXhyRXNraCtndnFnc3NEWkJk?=
 =?utf-8?B?Z2c9PQ==?=
X-OriginatorOrg: memverge.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af8599d2-1dcc-4765-623f-08dc817d4b08
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR17MB5512.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 14:23:51.1316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5c90cb59-37e7-4c81-9c07-00473d5fb682
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +U6Cg99HFHH8M1MbVofZginPuV42yn52sXdWcjrWN0Vb9SAZO1v+ne96OsbS4B99RhLIssqcLWukQHNo3xDSSEVeBFL5FWPmTK8a76zgbgc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR17MB6666

On Thu, May 30, 2024 at 02:59:38PM +0800, Dongsheng Yang wrote:
> 
> 
> 在 2024/5/29 星期三 下午 11:25, Gregory Price 写道:
> > 
> > There are some (FAMFS, for example). The coherence state of these
> > systems tend to be less volatile (e.g. mappings are read-only), or
> > they have inherent design limitations (cacheline-sized message passing
> > via write-ahead logging only).
> 
> Can you explain more about this? I understand that if the reader in the
> writer-reader model is using a readonly mapping, the interaction will be
> much simpler. However, after the writer writes data, if we don't have a
> mechanism to flush and invalidate puncturing all caches, how can the
> readonly reader access the new data?

This is exactly right, so the coherence/correctness of the data needs to
be enforced in some other way.

Generally speaking, the WPQs will *eventually* get flushed.  As such,
the memory will *eventually* become coherent.  So if you set up the
following pattern, you will end up with an "eventually coherent" system

1) Writer instantiates the memory to be used
2) Writer calculates and records a checksum of that data into memory
3) Writer invalidates everything
4) Reader maps the memory
5) Reader reads the checksum and calculates the checksum of the data
   a) if the checksums match, the data is coherent
   b) if they don't, we must wait longer for the queues to flush

This is just one example of a system design which enforces coherence by
placing the limitation on the system that the data will never change
once it becomes coherent.

Whatever the case, regardless of the scheme you come up with, you will
end up with a system where the data must be inspected and validated
before it can be used.  This has the limiting factor of performance:
throughput will be limited by how fast you can validate the data.

~Gregory
