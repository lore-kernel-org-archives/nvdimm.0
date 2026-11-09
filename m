Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794237810;
	b=1XQmaQcjrw8Er74YsDAf8HkMxMBFhykICSwNio7yOLRlB4ZEQmZ6LNDc8BH0LQhDg8OG
	 sJwQRWgBC2fHPPzdmYM5xbB1ckTSRd9cLfeQiRWDs+jtYzKIvxWl6gsVHV1SXrQS+AQXO
	 8A15yMcs1dqJelR9hiWCa6+zQyWX3dDkIO6I4OqS3JVR311NtvfcpAs/13td7sIMuMPq6
	 9C/rzT7XJT34NoDCA/i3eBf+35QSuOCLVhGHA6umgAjTd2TB19gjeeq6bv8ybRMmO54cC
	 1w/yhd8tyshLlxeiSVjcGljqBUeLprUXsKIPNcEQQsgIXqewY1HGfH8NCDtl/X8/Ncw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794237810;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 Content-Transfer-Encoding:Content-Type:Date:Message-Id:From:Subject:
	 Cc:To:X-Mailer:References:In-Reply-To:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
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
	bh=lWBVRsItqOFVEXk4jblww9a+NbSWxgiAM4QNfdfhZvY=;
	b=fKqsDKqI/TDtUA3ykTefI0o0Fna+3N53z280YYypwLv4ywJ6H8C4c+eRk0eb6vtLhj+5
	 DnbkAX8FZvw5Y3tf5lNgqC8tdRprRjudtgm2zIvlJlmXsR0J4J0irUMWGLU/gBDxYvXnp
	 bN2cr3J/JX79aXdw3rU0sW/8Ug1Suh74ZtCAtqhtzjr5YIBXBuMOo3+0J00Wt9kK6N9gt
	 TQ+UN5rlPfH0BsFZzS0mv0G5zdXssCRsp4JGKDPp1wXawYN/cmcZAJgghq0fg6VAJ/89H
	 Fa5l44x3uK9IIKRcxrm4JuN3KFIn+YiEGCDGeJWKgN7IW/QC9cTju9knfvufeNqhE6Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=pAaqTudR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.18
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011018.outbound.protection.outlook.com [40.93.194.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DE5606A31C;
	Mon,  9 Nov 2026 15:23:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46DE5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=pAaqTudR
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E/dgMP2cuZQpIHl5ZCIowVXBR06t5lw0TZQXggTAE8wNjmKtfcdMUz7xR0QONrnoy0hm6lCAb8aAnP2hAB9N3DuU8xMIm1UPKY9j7nnb1ovo6lCY2rRnZ7CLuCWEUbZmZgIpMf2TxAfNbRzHTmYB1YHmkKh5oef8EGNHwOz4eiBFkPuZWSet2IcQNjNBN7LBiXvdbfIc8pTV1e3M4nbojMpSaMou60u7yhpC++DX1dxXlmdyk+PJV7g6yiaHqIg1xESLpk/l695RQwsHWlN9cs/jX+2PbTtEpGjy1MzgGE54hOK1/zHuIUh+2BLSjyN9RUJfeeiQaGJlSp+LHMikiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lWBVRsItqOFVEXk4jblww9a+NbSWxgiAM4QNfdfhZvY=;
 b=ascjqKUG3fpptyY44i3O2YLnCvKlHdVWQDxtOtf3n5Y1q8/GBasFjQOrYmzoWnMhDUNPXLUDHqsRwsGLJSVAm/edh2Q6w5ltYZsCjO4T36LWENyJzPsHv1UsUmo4yEhQ/F8rSw4pQNnxFIE7OqjjD2Cc4DbiHbCM6Ftprij18QSk0Zg/y/olBGaTn0q/B3NA0UD80/ubwPLxCo7rYXO7hm0j4kkQUlhbZw0JyG91OVoDXQKirgXe1tUphbRM39Qa4s+ENP24CkjNQaMd/RRr7DwzRCa36weYDt62iiVvMEPho96/ufrrjsC+XpwTMoxsQTTsIzdjd7+zHoB83EuoDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWBVRsItqOFVEXk4jblww9a+NbSWxgiAM4QNfdfhZvY=;
 b=pAaqTudRb9QHLtULMQ+DEjG5LDA4KnSAPuEltor0I/R8yEIlSR7FSrB2OucCFoGio3CVDANmL4RmNkDxTZC0NH5Ob0eh9VDqJ6r0f8nzT7ZkSrwqxTRP+0LIdq2SdOh0e3coIv/M8lenKabHzaK3TX2jqvcpv2WmTVxCDzR619765PBJojnH0P1YhPN9P6a04gFtf3YrJS19wAGP67ciDUmyxSrXl/u9D18wHrpA4MxI9CdRwpXQJW5duMgTqXvnV0Zs/N9feNUTpkDFSutap9dnr0+q8eTjiloViYk8EU1g+JxZXDejVQdL1AgwWdsY3+/wou26/mymj9fOU5HAUQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ5PPFA5F0E981D.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::99d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Mon, 9 Nov
 2026 15:23:25 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0592.010; Mon, 9 Nov 2026
 15:23:24 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 09 Nov 2026 10:23:22 -0500
Message-Id: <DMQS7VAR4FU6.2R9WGTKDC3AQI@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH] mm/truncate: unmap DAX entries before invalidating them
Cc: "David Hildenbrand" <david@kernel.org>, "Alistair Popple"
 <apopple@nvidia.com>, "John Groves" <John@Groves.net>, "Miklos Szeredi"
 <miklos@szeredi.hu>, "Darrick J. Wong" <djwong@kernel.org>, "Carlos
 Maiolino" <cem@kernel.org>, <nvdimm@lists.linux.dev>, <linux-mm@kvack.org>
To: <sashiko-reviews@lists.linux.dev>, "Dan Williams" <djbw@kernel.org>,
 "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>
X-Mailer: aerc 0.22.0
References: <20261106-fix-dax-invalidate-mapped-v1-1-292ce5958d67@nvidia.com> <sashiko-outbox-203344@kernel.org>
In-Reply-To: <sashiko-outbox-203344@kernel.org>
X-ClientProxiedBy: YQBP288CA0009.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:6a::7) To IA0PR12MB8374.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ5PPFA5F0E981D:EE_
X-MS-Office365-Filtering-Correlation-Id: b6e622c7-2d1b-4cad-f67b-08df3e756520
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|22082099003|18002099003|4143699003|11063799006|56012099006|10067099003|261028144727099003|261026121527099003|261102123227099003|261022105027099003|261022075727099003|261021121427099003|261026140227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	GCZl1VtKcoAqyOHP5yxkuQkNidl0nZPEsSrC3l6XAjf9AJGWH+8j4hGtBzm94OBSvlLxTvOvLyVQaJaTTHPyXgPQWPP4ZQZjmGOjz0lasP8wvGapaFWY5seN9mqCvEZnxdNr7DOpJ/yJTwyAF4vFSDrzLDBReq9tn9ybciYYyAJMHo7d6dOBGRl4SBQU/z6uZUT3qL2Qf4AzndQhXfSIKdswIsDndHloobNmh+KzXBN4OXrvqIC3ue0UxT0ynWV/75X/GwrXwB1qLkzSpOLG8CzoRXriBUs9PIhuWYiridjnrOJUoVc9xXpYQDS5xbgJfeyAqIlYZ1DAGu+67iFBLg67rwYk4LPuhe2nEgeMhsX3HT21owzXKMXGTeno9Z8AQJRDJ4CXbY26qqVzKmIvIaIUX+BktFEF3O+Eu60Dkwr7SV+Sjl0XIKuQyg6229fspc3hceFdXPojDL3X0okXUlQNX3my2eK1Q3fIDAd6RNlCp8kz/a0ddrC0Dw03AWHU77lMZA3tjZBmVLhoT5Z0V4+YwCVc+EV+0NdZBvC2Ynkldn2whC8gh8gGwNUQNcVLK92SZaLIc9a+49nJZNlZJjI8k0WTd/tPGgf7SJMgt4n5WQDwU2Bm4dKCOhMCYOhX9KuX/nFNFp66Zl6d95fEaAGmdNZJg228/0O/MYcsxt4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006)(10067099003)(261028144727099003)(261026121527099003)(261102123227099003)(261022105027099003)(261022075727099003)(261021121427099003)(261026140227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VkJ2MVJjU05GYWVOQUNSL1EzbVdMWWhKamI3Uzdhelk5cVRXZXdnTmZZcEIr?=
 =?utf-8?B?a095NzVEcUJYVWhKOTJvSndKaHV5KzdjeDNkb2VaLzFLbkhRQlU2SkFyL0RP?=
 =?utf-8?B?a0NaeENGSEJ6TDZVN1kyRVExOTN1QTJlY0k0Tm0rYjR4Ui9IcHVxdjRwRk14?=
 =?utf-8?B?Y0U3ZTg2UEFIbWszUU1nWmZCZHlFb082UWVkQ0k1VDhXOXp6RURQZmZidkpQ?=
 =?utf-8?B?cVk1eDFka0MxclFVeGtyT2dDQ1czUmZiQ2swNFhVMTBNc2dGZzJ5UlNjeHl2?=
 =?utf-8?B?Zkp5ZDBiZXhTQ0tZVkFXYWlDeExta24xclpuNzkxSURjQjBGZ0c5b0pDai9r?=
 =?utf-8?B?b1V1OVNlekRUWUphMnhjcitueUw3K3FOSzB0azJEUkdjRkYxRXZ4Q0hIZ2p3?=
 =?utf-8?B?QjJFdldyTjgxeHUyVGZoZWV2bFVYODRRcko1a2pQRmV5blRiZTdGaVVqUnlH?=
 =?utf-8?B?eG0zamdhSVpIWnJRUGVRM1ZmWkJ2VDVNSVRVcFBqRXcxZnhtZnNEd2FaM3Z4?=
 =?utf-8?B?VUQrTXc1aENabzVvazV0WW5lSThhWmc4WHJLRGZkdk91dDlBMktMamdTQ0Y5?=
 =?utf-8?B?dkpaK1JFVnFobXRDVmZwSmxsRlhTWE16WGRmN1M2NTRIUUQvZ09ENUdldzJa?=
 =?utf-8?B?Q2lCRUIyWnJxLzhyQTBOVXZ5NkVndWMvcDUwOXdId1Y2M2dDeXlERUh6YjA5?=
 =?utf-8?B?cmU3OUplQlA4Z1lGcFl2VEg2YUxFUm5mMG96ZnN6cXVvdENBKzZrcWI3MWhO?=
 =?utf-8?B?dDM1TElUQ3dnZGdqQlVIejlFMWRmWlpZdVRmRk84U0FRN0tES09scGhnTFBN?=
 =?utf-8?B?QmkvREt5ei9DVUpRQmZYbWpvNE5NdDhScnVNRTMwaktpWnlVTjhCVTU5QkhK?=
 =?utf-8?B?aFdGNmkwTUFXZUdFTy9KUkRTRmpST2tUaEVYMXZscGtoTGZHREkwNHlxU3h2?=
 =?utf-8?B?QTU2bEMxYmdtcm1pbnVpT3J4citNakRGSUIwUnpnd3ZTL3BVUTI3V1JoSHUx?=
 =?utf-8?B?SjBSVVFGelkvQW50UG5SWHA4SUE4elF1WU11N1BLbjZ2QjZQVmFoVTFIVStm?=
 =?utf-8?B?Q0VNL0dBNE5xNFhMUzI0UXJNUlpCMGRwOWFUWGJSeFNITDZKUDc3cElYcTdK?=
 =?utf-8?B?by9mTmVpVnRYM3BqNHQ3TU9XRGt3aDc1YzNtUm1MZER4d1A0Mkk4bWpxV0pU?=
 =?utf-8?B?YmFFZ2w1UStLUVYwaGgyeE8yRWk1YnFrZDdHTDgwWjErdklJTFp6SndZRElB?=
 =?utf-8?B?WDFoalovZithNlRNOFFXcVFqd0dDNEd5ayt3R0kxd0hIczQwcVJJY3kxSTdu?=
 =?utf-8?B?ZzVvc2J2M09VL0M4M0tORXhCRW9ENkpwR3VJcnBPZ0tyZUErWjhWakVia3g4?=
 =?utf-8?B?b0xod3ZkZmJnM255T0FLS3FzWEZwMzVIcVJDQ0IzVmxEaWxIdmVEczlOSWlI?=
 =?utf-8?B?TGxiVkd2MTJQeWhMVlYrWkEzSnhCUEQvd2JJcE8zcm1hSmJIbGE4d0R0T3Ry?=
 =?utf-8?B?SzlkbWdaS2pVR0pUa21hVEZ0aW1vRlFkRFJqTUZ6aHRHVVVqM3d6MnJwdzRG?=
 =?utf-8?B?R3hhTGFCOFpmZlpSMkRoZEpRU1MraWNkaGRHMlNZZXRoSXlINUZOMHU3am5n?=
 =?utf-8?B?YXd2SDJLdXF0L05mdk9SY093OTh4dXU0V3ZhNzJacnV4aUEzTVVhbUx4Vy9P?=
 =?utf-8?B?L09mdlQxSC8rUVBGRHpZTHVpMjM2L0pxVVRlUWROTlR4TlprOHFNS0ZVT2NE?=
 =?utf-8?B?a2IycnU5Nnh0dlNCNDJjZWhjTnU5TE5TbjRMaFFWUFdwNFZkMDNlUGc0WWc0?=
 =?utf-8?B?V1pqdlhrUmljZXk2OERMWll5WXIwK1NESTV5TGxBRlhEWHdsdHdaTUp3eWNG?=
 =?utf-8?B?emt4Rm5tVXptRkxtVFJ3L0pyMFlFajZsbThzSmdneVAzbkVGOVZBdHBqZnR3?=
 =?utf-8?B?T1Z1Z2ZaUk9MU2VtUGlmRkwrVHFYTFBNenlNTXBKS1JsNHZwRVFhdXVJM0J4?=
 =?utf-8?B?ZFJEbG9BL1F0SlNoN0lqOGttRUVBQmRzU2pZTnRIcFZVTGN4dTFOL3BjOUJT?=
 =?utf-8?B?K3UvcXVBU3dLRXJ1c3lFWHQrRUpoQUlZd2RDMVRxNHphUGxyUzh0K3BaU2FT?=
 =?utf-8?B?ZU1YZlljdWNNYkxhNkdyYVZWMTRjQlAyS1FZOFdlSTBGaVVBOVF3QnBYaVZ3?=
 =?utf-8?B?YmFwcGQzRWQyT2JWNWQraDh1ZnRXbkR5SHJqN3VWY0tJZmFWQjN2TENmSk5r?=
 =?utf-8?B?aHFCVjA2TTBqbytHYWh0N05jdzd5S2EwTFlMcnJBOWRWaGJlQ0hINldPT3Fq?=
 =?utf-8?Q?+uzNIZ9XJWVB6VeG1T?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6e622c7-2d1b-4cad-f67b-08df3e756520
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 15:23:24.0519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 48++xzEQCOzDbXSAuUFzQ9vHXzYcrUAkb5G/1OknaPUbo94xQ75xAB6WduyTmYSv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFA5F0E981D

On Sat Nov 7, 2026 at 4:43 PM EST,  wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential
> issues to consider:
> - [High] mm/truncate: unmap full DAX_PMD range in
>   invalidate_inode_pages2_range()
> - [High] fs/dax: premature disassociation of shared folios in
>   dax_can_disassociate()
> - [High] fs/dax: stale i_pages entry when __dax_invalidate_entry() skips
>   busy folio
> - [Medium] dax: cross-file TOCTOU and data race on folio->share in
>   dax_can_disassociate()
> --
>
> commit cd725b6545b68d39f6ee84c70fd91581edad91be
> Author: Zi Yan <ziy@nvidia.com>
>
> mm/truncate: unmap DAX entries before invalidating them
>
> This commit unmaps DAX ranges before invalidating entries in
> invalidate_inode_pages2_range() and skips disassociating clean DAX entrie=
s
> whose last association still has elevated folio references.
>
>> diff --git a/fs/dax.c b/fs/dax.c
>> index 94ba41273347c..e448552d8080d 100644
>> --- a/fs/dax.c
>> +++ b/fs/dax.c
>> @@ -527,6 +527,24 @@ static struct page *dax_busy_page(void *entry)
>>  		return NULL;
>>  }
>> =20
>> +/*
>> + * Determine if an entry can be disassociated. It cannot be if it is it=
s folio's
>> + * last association and the folio still has a reference.
>> + */
>> +static bool dax_can_disassociate(void *entry)
>> +{
>> +	struct folio *folio;
>> +
>> +	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
>> +		return true;
>> +
>> +	folio =3D dax_to_folio(entry);
>> +	if (dax_folio_is_shared(folio) && folio->share > 1)
>> +		return true;
>> +
>> +	return !folio_ref_count(folio);
>> +}
>
> [Severity: High]
> Can returning true whenever folio->share > 1 allow a shared PMD folio to =
be
> dissolved while it is still PMD-mapped?
>

This is related to the issue 1 I mentioned in the patch coment area.

>
> [Severity: Medium]
> Can concurrent invalidations on two files sharing a folio race on
> folio->share in dax_can_disassociate()?

This is the issue 3 I mentioned in the patch comment area.

>
>> @@ -853,9 +871,14 @@ static int __dax_invalidate_entry(struct address_sp=
ace *mapping,
>>  	entry =3D get_next_unlocked_entry(&xas, 0);
>>  	if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
>>  		goto out;
>> +	/*
>> +	 * Removing the last association of a folio releases the folio, so mak=
e
>> +	 * sure the folio has no reference.
>> +	 */
>>  	if (!trunc &&
>>  	    (xas_get_mark(&xas, PAGECACHE_TAG_DIRTY) ||
>> -	     xas_get_mark(&xas, PAGECACHE_TAG_TOWRITE)))
>> +	     xas_get_mark(&xas, PAGECACHE_TAG_TOWRITE) ||
>> +	     !dax_can_disassociate(entry)))
>>  		goto out;
>>  	dax_disassociate_entry(entry, mapping, trunc);
>>  	xas_store(&xas, NULL);
>
> [Severity: High]
> What happens when dax_can_disassociate() returns false during a CoW write=
 and
> leaves the old DAX entry in mapping->i_pages?
>

This is related to the issue 1 I mentioned in the patch comment area.

>
>> diff --git a/mm/truncate.c b/mm/truncate.c
>> index 9e9bf029635cf..b03cd99c4bba8 100644
>> --- a/mm/truncate.c
>> +++ b/mm/truncate.c
>> @@ -732,6 +732,15 @@ int invalidate_inode_pages2_range(struct address_sp=
ace *mapping,
>>  	if (mapping_empty(mapping))
>>  		return 0;
>> =20
>> +	/*
>> +	 * Invalidating a DAX entry can release its folio, so unmap DAX entrie=
s
>> +	 * before invalidating them. dax_invalidate_mapping_entry_sync() skips
>> +	 * the last association of a folio that still has references, e.g.
>> +	 * because it was faulted in again in the meantime.
>> +	 */
>> +	if (dax_mapping(mapping))
>> +		unmap_mapping_pages(mapping, start, end - start + 1, false);
>> +
>>  	folio_batch_init(&fbatch);
>>  	index =3D start;
>
> [Severity: High]
> Does unmapping only [start, end] leave PTE mappings in place when [start,=
 end]
> partially overlaps an order-9 DAX_PMD entry in mapping->i_pages?
>

It sounds like it is similar to the issue 4, where PTE mapping and PMD
mapping are not properly handled. I am not sure how PTE mappings could
overlap with an DAX_PMD entry.


It will take me some time to figure out proper fixes for all these
issues. Feel free to take them over if you have more confidence on the
code base.

--=20
Best Regards,
Yan, Zi

