Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2093.outbound.protection.outlook.com [40.92.53.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FEA42501
	for <nvdimm@lists.linux.dev>; Thu,  1 Jun 2023 17:54:08 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dtxJEgqba//9mqV6KIrWHEW8ph8fyjf0sQ9AxssUliCNvBIm7SNBzU8Rh8O1fHgg8tG/KPRx5HHLLNF9Sh7QuUk5KNdgNUPSUrg/MBLeV7O+AnIwzC4GFC+zhnu8W0EJGVaWfGDy1oPyPSTy3CGnmY7Yo80CmcmtwhidQGagEzDMZ/VoG4AD9KLWUNCPXR11Lib27wfX3nKlxEkuffLZ6CMLdVsIFPRy8NWUYbMSmk20lXJpggjclMyISIJ5MfFuEQBY2t4w9D/iKI/r1WZpWQD2v1KQzHCjv4lBky0CSlbduMReS3RxQ5Stemi7JExm/R0CSpb/mHXljfgOkE+2DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sE4dHhJQhtZ55iRRQ98yjaaU4q2IRPeQ2vNGJhVC5uY=;
 b=l6A6XoEHh/vJy4cqDtESSuAB933ROUyqNpMd/Fy4qKIjHbikRniAPrPVRWwjUDOIwNLONGTC0qMUSi45rt8KdNVMPvz4T1hYxXWGxXqtmSjKl6+nTx0NraEjZlr4vwCG2LmZ8HIfm02SIWwd17+TS8qe58AMhpk8v6oVVXz0bCVubaYmq7Grz+ScqMEkBan/wO6fiPoFpbezBoPPB7qXD5jWij6wsDZfD36g13QbiCP3/8I17YfsUQACHff89LwNLMviF2uK7BOEBHfUVDXSiXZgrwOoSE1zZcBsmZ2uYRY5WfZ4OBz1rrpVrVDuYxPa4AhFP2S04daVzWIel0/RAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sE4dHhJQhtZ55iRRQ98yjaaU4q2IRPeQ2vNGJhVC5uY=;
 b=I0cwetdOs2DRlPiK/CvhVVCgIL3wRUT6qyfgDmGs/SimPyQ67feIkYnHVCcLilo2zf7f6C9UO3veSB7he8F2c3cLkI6pH3p0gw6MyG3U1J1pZVT3lQcw8mH5l8JjKqSO3dlZ8n8mIY7Irg3nLdLDzKSYCnM8sEWEsXGm8TheGL8N7osEP5UAAxwV5nXG/ShHDBJN/whnknzIAbQXHz9QuFrelDar01isvKsP1rFxFCFdI65FKXIgLREkQLXJJz5XE3epRnAfKxWcLKjIbjB54LKNFyzJMj48xEEbGbqTLRshEK24wOCmcOnASsgi/Nhh/7b3L22p27qXIv6nvZYt2A==
Received: from SG2PR06MB3397.apcprd06.prod.outlook.com (2603:1096:4:7a::17) by
 TYZPR06MB5274.apcprd06.prod.outlook.com (2603:1096:400:1ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Thu, 1 Jun
 2023 17:54:04 +0000
Received: from SG2PR06MB3397.apcprd06.prod.outlook.com
 ([fe80::248c:58fd:97db:5425]) by SG2PR06MB3397.apcprd06.prod.outlook.com
 ([fe80::248c:58fd:97db:5425%7]) with mapi id 15.20.6433.018; Thu, 1 Jun 2023
 17:54:04 +0000
Date: Thu, 1 Jun 2023 10:53:51 -0700
From: Fan Ni <nifan@outlook.com>
To: Li Zhijian <lizhijian@fujitsu.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	vishal.l.verma@intel.com, a.manzanares@samsung.com,
	dave@stgolabs.net, nmtadam.samsung@gmail.com, fan.ni@samsung.com
Subject: Re: [ndctl PATCH] cxl/region: Fix memdevs leak
Message-ID:
 <SG2PR06MB3397FB13DCA701D16A7A9EB3B2499@SG2PR06MB3397.apcprd06.prod.outlook.com>
References: <20230531022718.7691-1-lizhijian@fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230531022718.7691-1-lizhijian@fujitsu.com>
X-TMN: [PJIQp+TEbWI1MuYcbD4HmydNmo84vHET3juxqttyYrk=]
X-ClientProxiedBy: BYAPR02CA0060.namprd02.prod.outlook.com
 (2603:10b6:a03:54::37) To SG2PR06MB3397.apcprd06.prod.outlook.com
 (2603:1096:4:7a::17)
X-Microsoft-Original-Message-ID: <ZHjbL375k5msCzeJ@outlook.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SG2PR06MB3397:EE_|TYZPR06MB5274:EE_
X-MS-Office365-Filtering-Correlation-Id: e9d4f3ed-b3ab-42cb-42ea-08db62c93047
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	W9IIT0XC4JFrCNIm+2y1dEI/kGEyoeHNF9kB1LrgWartw7PXanribesE4RcApvjFIXqZS/E2i6Nvzh+Mc+NilP9qjurLgG+EY/1AQRCOiMNkYu69uepsnhIjkYu1dlPz4b+MaBl+kA5RP1TfLwrlCOER8uDsUgaMeWUhcpTYuwa2qVvF6g1GPF1AqNk5wtoIeYLL6K9EXNISN9PWuYM4odTh0LJr/6nElr6Ex8eBH7SjNe/UngsBk04+DAMnY6uj6vc8D0jntW+Sn9hYV7ut7BLz0+DUKR5eJqqeOIkHxyQeNAdUAoIxIEvoViBVAloi2li0VnBsA9We+vpuu7JJNeZ2gk+OJNjwTQ+ZqMJY2c5IGG01aqgKupwV2kdTH7NRQ0ukRgHMAxsJDqEFCyMghljB1LeLPpmmTIhmXkjE1w+bCKDMvHRJ5Fv0adiE3dj71499QqJYMGScA2AYxqzI2OzTg1N01sKURbc3+WPq8h/WKNyOshSHtp60r6bODMUZ8CtpNOKagsmvyKSeRd4SZwbVd1Z180s6BExjNnhkgjqe8cVC0hJMGQ7q5QsikPBAMBgAnFK0CasOl0hOGJzeyDz3x6u8H3pUsNTPbjI9cao0D8wGO/DlpTdhSSMz+YMk
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OFNKNEgyNUZyYVUwUGJrWTBoMm54amhGVnA0MmdjRDN1anFKT1E0QVBya0lr?=
 =?utf-8?B?cFBUYWRJOVZ5aSt4VWVHTFhzZ1JYZVdWUUhxcVUyVXdKaXBjTlNVdStTTE1i?=
 =?utf-8?B?VGRyL0ZNV2xuRXRldncvd1BVd0xHUG85OXdiUWtPSlh1UUdiSzM1SEFFR2tZ?=
 =?utf-8?B?M0QrbjcvbWtWTlN3aU56MDl3VS9nSGEybGdNQllZSVB4c2x5czE4Wmc0MUor?=
 =?utf-8?B?K3F6K1dsN2orL0FFV091cXp6YTBsK1JBd3NZaGtuN1RWWU4rSkx2ZmxiVzZi?=
 =?utf-8?B?ZjRvNjJNYU5KNnNvUGVWWlF4Sm5mcGdMcVN4d1lwY2ZvR2hxWTRSVWFpUWdi?=
 =?utf-8?B?N1JuUUdIdmY5M3ZSc2xPOExMT20vMWlDV1ZsbEtHVFpPV3N6Z0ovZ3B0Q01m?=
 =?utf-8?B?TkhtQ0owZUNxbkFPQ0haWmRtcUkyOUhERW9rU2hrWWxFUS82WUNvOXNzTWJp?=
 =?utf-8?B?YWtNQndwVGZZWjlNS3hMN2drTzBya0ZpMmk3NGUzSzNyanJmVktzd09MMkdX?=
 =?utf-8?B?ckZOK3UzanNrLzRnMDlIZzRXS2hwZVlHVVV3R2dYeTE0U08zRjQ1MHBwNC9D?=
 =?utf-8?B?T1NlSzI1YXdjU3hxMlRzbE5aeDNiZ25MNWR2NjZPYjNHQmgwNXNXa0xLRWlC?=
 =?utf-8?B?VlhBb0VXS3RyV05PVEVKQWJYenYrZThuNHF5d09vV0g4Y3JJUGtpK0phcDc2?=
 =?utf-8?B?WEZPbXdxaEtaNzB4dnlCUXhNOFovenV6Y0ZSRmNvVlZ4K1dCSG9HR1F0YVpr?=
 =?utf-8?B?aDdSbUJYWTFKNW1DdEhZM2dHSCtNVFQ0VlZKdHBxUWtPMC9ZcXYydFpMOFdl?=
 =?utf-8?B?N1dlU09NTnlsOUluWnJsSHd2WEtnLzdtRHg2NGlxNysrNGJjN1YxcHovWXNP?=
 =?utf-8?B?d21idmNVdkF0NFJqd1R1bG1tZlhOVmg1V2tFbTFrbFhTNkNNdDJwUHlWanl0?=
 =?utf-8?B?NGk2TS9NZzg5dVR6VVFyV0JlTjU1SzhrV1FIQU9BQjl2bVYzbmZnQVBMbXNn?=
 =?utf-8?B?VE9haEtCNDBUU3NTdmhOZDJLUGFVZlpObk91R1l2Q09BSFdHOTJjVUtTUXQ1?=
 =?utf-8?B?NGgvUEhzTGJkelFsYk5sc2RGUHNjeFhhRHl5QWN3WFdQREFUU01TbGNxU09B?=
 =?utf-8?B?bjRoeFEyWVlsTlY1bXNDYitjaFFwRDlXbFJHSU5qMnZyQTJNOWxFMGVaY0Z5?=
 =?utf-8?B?cldOTGNlOWhqWnNPa3hEVFFaYTR2WFZtR0l6cGhXbjB4SGszLzZIMDFqdFBs?=
 =?utf-8?B?Rk1oYWhVUTFkQkxqVkl3MjdZVzBzaXBHT3FWL2thZm16alhvRFhkczRYZ3E5?=
 =?utf-8?B?ekw3REFzUTdKUkczQkdQMVAxbSt5WHlaQlV4K2IrQ3AxQmNId0tKQmF5dUNN?=
 =?utf-8?B?WGNEU2hDS2k2T0dDVUR6ZkYxRWhwWXRQM2dobDA0UUpOQWJrOWFGVG1zN2p4?=
 =?utf-8?B?RktmRlNheGhDbXhTd0FLTThrc2dWNXo3NFR2UVV3dTVleG1pYy9EZ3RoR2FH?=
 =?utf-8?B?Q3o2WjArSGJlOVJDMExicTdHVm84NFVNdzd6aG5rSDRpNVpmR1FLZnd2dVhk?=
 =?utf-8?B?NnFZMDluQTFUUFdvQi9jRTR1T05vQ0hJaTZHV3NLUmJ0TDM4SFNuOG85ZDBI?=
 =?utf-8?Q?2E+ghBgcM/iTMd3xyQoRgoCKDLbtU+U1aMSIFaNAh3+I=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9d4f3ed-b3ab-42cb-42ea-08db62c93047
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3397.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 17:54:04.6224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB5274

The 05/31/2023 10:27, Li Zhijian wrote:
> p.memdevs should be released in error path
> 
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> ---

Make sense to me.

Fan

>  cxl/region.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/cxl/region.c b/cxl/region.c
> index 07ce4a319fd0..7f60094e8b49 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -300,11 +300,11 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
>  		if (p->mode == CXL_DECODER_MODE_RAM && param.uuid) {
>  			log_err(&rl,
>  				"can't set UUID for ram / volatile regions");
> -			return -EINVAL;
> +			goto err;
>  		}
>  		if (p->mode == CXL_DECODER_MODE_NONE) {
>  			log_err(&rl, "unsupported type: %s\n", param.type);
> -			return -EINVAL;
> +			goto err;
>  		}
>  	} else {
>  		p->mode = CXL_DECODER_MODE_PMEM;
> @@ -314,21 +314,21 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
>  		p->size = parse_size64(param.size);
>  		if (p->size == ULLONG_MAX) {
>  			log_err(&rl, "Invalid size: %s\n", param.size);
> -			return -EINVAL;
> +			goto err;
>  		}
>  	}
>  
>  	if (param.ways <= 0) {
>  		log_err(&rl, "Invalid interleave ways: %d\n", param.ways);
> -		return -EINVAL;
> +		goto err;
>  	} else if (param.ways < INT_MAX) {
>  		p->ways = param.ways;
>  		if (!validate_ways(p, count))
> -			return -EINVAL;
> +			goto err;
>  	} else if (count) {
>  		p->ways = count;
>  		if (!validate_ways(p, count))
> -			return -EINVAL;
> +			goto err;
>  	} else
>  		p->ways = p->num_memdevs;
>  
> @@ -336,7 +336,7 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
>  		if (param.granularity <= 0) {
>  			log_err(&rl, "Invalid interleave granularity: %d\n",
>  				param.granularity);
> -			return -EINVAL;
> +			goto err;
>  		}
>  		p->granularity = param.granularity;
>  	}
> @@ -346,18 +346,22 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
>  			log_err(&rl,
>  				"size (%lu) is not an integral multiple of interleave-ways (%u)\n",
>  				p->size, p->ways);
> -			return -EINVAL;
> +			goto err;
>  		}
>  	}
>  
>  	if (param.uuid) {
>  		if (uuid_parse(param.uuid, p->uuid)) {
>  			error("failed to parse uuid: '%s'\n", param.uuid);
> -			return -EINVAL;
> +			goto err;
>  		}
>  	}
>  
>  	return 0;
> +
> +err:
> +	json_object_put(p->memdevs);
> +	return -EINVAL;
>  }
>  
>  static int parse_region_options(int argc, const char **argv,
> -- 
> 2.29.2
> 

-- 
Fan Ni <nifan@outlook.com>
