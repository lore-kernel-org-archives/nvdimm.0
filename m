Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCB02C9D
	for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 11:48:14 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VATUsv003697;
	Mon, 31 Jan 2022 11:48:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=MpRftg/tOkFaC3VntNgpA8RLaH7Z8SytYIYMrS+7wTs=;
 b=X21Ql8eMhBozwXCggHOgLSgYN6xVRcnaEFrA2jSD1DzhLMSE0jn2NjQW5/iceMgGpb3p
 2k6P4cTHRQygSolXkWaad2x/7U3C5g798UxYE/ZnI27IqsHAx2UeUQ+VcR24u+AWs6RR
 sK3+Ra2YJMLJJKy7yDJVtdxnNeA0amw2QVgE5uUvlyYTaeELbmyFvDkfWWXWY0G+JpdG
 7ys1xNC4dKTSk1swaZoGwYFCxOTdYk3vfaXHS/OlV7onjlkDZ5uVrK1sFiKhdbZsb49Z
 00ApQLHoLvo48Mm2UUczdkqGU6aaa6fwWiKqj33QcIEVZ5NUUAxkoOJBisuksGCRF2/l 1w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3dvv0d3wpf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Jan 2022 11:48:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20VBf4Rr020554;
	Mon, 31 Jan 2022 11:48:05 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by aserp3020.oracle.com with ESMTP id 3dvwd44e63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Jan 2022 11:48:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NUeo4KHQ+e3O4HIJdb4ZWwSm91HhxORDBZ7dmiXdpd4PydAQVmMNOn3Y/5f+YIQmkG+yZDoKGQqAf2iVimzF594Z9fvfZB0rhndL0l5Z/2ec2ozfu/yF3H6gFjgmDWQ1CNzAhgB6vUhmdiByzTs/wWxlWMfHh/fgsGzMRaEfCEcnE8NCauScZ4sIW7RVMv7icT0Z3bClEIDcMrq5nXmPt19gWyylZG01zh1YvvYCj49+LpUZYDBYc+LLXLxTtCWd6sS2JgRYXYHJcqIENSRrE5l7wqeg/liWujlVZNoY5iDi9OQBzBsNKy1bSTd+V7iGKkuay5B59GD/c4yQEjXYPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MpRftg/tOkFaC3VntNgpA8RLaH7Z8SytYIYMrS+7wTs=;
 b=Za4pEcQ/pGRC4usruPvFsONMXeuajwlAz31k45F1Y2TiYigDTDydMpPm5owNkoYq8jfXn/PHM70Wq2M7/q8xHzL4wb7icj+jNG4m1EOrDoVmelgnOc6z6tAW7oJSH13zcqKEr5suVtVL43hLtIboQVu/CB5JUqUVPasDvl2FDLluj/ErpRTDdijhy72THS8msMqqr40rSkXgO37snUJcJ8kML6LLm5E6uxLvpRlnfUpHru5oIazNBvrKrmSenE2/ZaY/ZW+hzXqdXI80S8PhitGRyTjgUxrXUJu96RVkjruGfAV8Xo6RztjBgVdHlMfY3gw7TwyIIFlH2EiHxddG3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MpRftg/tOkFaC3VntNgpA8RLaH7Z8SytYIYMrS+7wTs=;
 b=L+2b6NdRevJSxq1IOHEbsZzhgmm7/u2z/GGX0xDp1I+yhsYwVV4rgMoUeRTBHSXWxqmfz2s3lwO+/TtqTek+icHOsBlr/T+yKid0aZNAir6ab/IYTtI1jHaDL9xWVOS8RMSkLpTzA1Zay2qfU8mF9Lrpkhfgsu7f0B7B9+Geo1Y=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN0PR10MB5031.namprd10.prod.outlook.com (2603:10b6:408:117::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Mon, 31 Jan
 2022 11:48:03 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 11:48:03 +0000
Message-ID: <1e004a06-9e13-dffa-b274-17033406ef6c@oracle.com>
Date: Mon, 31 Jan 2022 11:47:56 +0000
Subject: Re: [ndctl PATCH v5 04/16] util: add the struct_size() helper from
 the kernel
Content-Language: en-US
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Ben Widawsky <ben.widawsky@intel.com>, nvdimm@lists.linux.dev,
        linux-cxl@vger.kernel.org
References: <20211111204436.1560365-1-vishal.l.verma@intel.com>
 <20211111204436.1560365-5-vishal.l.verma@intel.com>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20211111204436.1560365-5-vishal.l.verma@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0427.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::18) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6565ec6-9422-475c-aacc-08d9e4af89b6
X-MS-TrafficTypeDiagnostic: BN0PR10MB5031:EE_
X-Microsoft-Antispam-PRVS: 
	<BN0PR10MB5031EB90E4A796D73E9A96FABB259@BN0PR10MB5031.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:397;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	lZySQRy7hcRt3H77AouFyIVdb6u2xRFuuU6HmUUAgR59XmyUOOzPGEtvwThUhE1NoniyxXnVA9EHQ2YXaabXu40Qp2wQpMYWeNvssPSNZrd5twmsaOzRsdjMJEN8EDtTZuW6bEPkqEOD5hXPvl9YDgpuR7a2e26d6+eE+/Tbn494YqeBJBTx6QhBIPsm8TYH59L1TU6k/2aAuzUnDhVZvDJlGaiFXOSUczsfuDWuxHQUCE2bi5iv1tNoSNhsCFIkLjoRKvMv1G6EvwsL/FdLZniFz1dGSgugD8WGbT6FFMnKLyuV9GTVQhRbJuvSPl2s55wqZBqrlGvjHsa7DGlRFq+tf2+9UeZhVJpFoANQKuT6JaKRVPUXNL/M/G/LcxL9lRd1bPx68JnnCBwwN+h2gkCS5+NtCHCj6vrYiSoPyW7rKwMAm7BiXqMSY2n7lUZbVmkkmjQgcnhq3824e68UcOU+qCSRMUjzwXgcajSn5Sj8FkedJtgz8JRqfnT+z2Ql4W6t0a1dicTGU1QISmtsenoKkZYwdeRwcWsX5xwlLx+LLMSwq7yX/u1skTSgLBb4D7LatCrK++IM6zaEtjL0KAufCnKDKsJdlJwk5MpJ43qJUGfmCunZ02VgVE7UdNMUKc9xfo3ho8QBEyU/TqmlzxGyjm0Fhp83ciMIHDWM20O0glstlotKUYNW9FTRxxcPIzr2wdXXe0vLa1gd58k5BQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(31686004)(83380400001)(6916009)(316002)(54906003)(38100700002)(31696002)(53546011)(8936002)(8676002)(5660300002)(186003)(6506007)(26005)(6512007)(86362001)(36756003)(6486002)(66476007)(66556008)(2906002)(66946007)(4326008)(2616005)(508600001)(45980500001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?di9ZejhSMUdUUkR1WTJVMVBCVi82emN4bFNaZXljeSs1UlMyTU8raXh0ZGpq?=
 =?utf-8?B?dWlSQk5FTHlXZXdmZHNsM1NyWUIrUWdBNzc2RzBaWHpFdEkrNXRBZjdGUUVn?=
 =?utf-8?B?Sm1KUlkwOUFTYTk4dWhreGFvQWY0TkR6Y1A5VWRjRnhWN3JTZXhkc2o4aHBS?=
 =?utf-8?B?QnZ0Yk16c2I4T2x2RmRqbDJncEZNaXAybzVnRUhHV0d0b3FseG84SmplS2hi?=
 =?utf-8?B?OGMxRThhRjkyalk0TTdjQzU0ZUlDVG9rZVpKVExsQi9iVFc1RmtLWFI5UjdU?=
 =?utf-8?B?V1FlL2cxYUJ5bDFWQlFJWnMrNDV6MC9ZVzFqY1FXejhNdXVCMkpRdUlRajkw?=
 =?utf-8?B?TjY4YzhRajV4S1REcUNsNE5KakFzdHJyMHNQUWRoY0lxbDNFc05BN0Jxdk91?=
 =?utf-8?B?elk3eDBIcXArNFFsdHNnWWs0eG5SQmlqVHphaE95eVo5MEw3UEJvclpQc1l0?=
 =?utf-8?B?NmhXWDB2Mm0yNHBrU3lxSjJ1YU1UL1BVMHlqOHNlNk1OUVRtTWFMa3F0U21I?=
 =?utf-8?B?aW5lYVh1U0p2VC92MGR6QytwLy9jV09oSDMzOEFGN0hBNVdObkQxMnVNVFRI?=
 =?utf-8?B?RkVCQWk5M1dmeDFUMFdxUzNvRThNZkJuVnpkeGFTVDVBc1VTVE81Y3pYV1Z5?=
 =?utf-8?B?SGRHaTNjNEI3ancyRXJyQ2dmZGFEdTFJb1VhL0VyZnovRkxZYnY5TmVNRlNL?=
 =?utf-8?B?UlB5SmswVzVYd1BxODhQbkZwc1N5VjVKdkM2WE9qOXRXTUlCRWp3YVVIODNN?=
 =?utf-8?B?QkxWODNzYkJzS2xKWnFlTm95TU9LOEtJNkhRaDExbU1ydEo5Qy90RmJkRXRP?=
 =?utf-8?B?VGgwQXN4VXk3OFpJcGxQN0crNUlMRjNNUEJzVWFZTGRBU09Ka3BKMVFpc2l2?=
 =?utf-8?B?eml4U2c4VUhVT0tpMFpWczVtQnZjaFBPa3hkcjhuL21UZjJOTm9uU0JtK0Nn?=
 =?utf-8?B?STFKZlB5MmdyZ1hBUGExaDB0Q2NyMzdBTkNWamluNWRXdUtWaDJwOWZrakpE?=
 =?utf-8?B?WVdXN1lHdGdKR3dxQ2NNZWI3OHVzU1lsM2NLK2wza3ViMWdzZ3VuUHQrZ3NK?=
 =?utf-8?B?UnlodzFVdHBYd0FYWHhadjFMU3Y4czJWY0FuQ1V0aWZpNXhrTWttUC9FaU1T?=
 =?utf-8?B?UXg4eDQvSm43VGUyaXhsVmJkY0U5QWFqN3J3NitpY0R1d2dyZ3ZQczl3cytC?=
 =?utf-8?B?Q00xY013NkFDa0xJb0VkSTlGV2tiWll5UGoxTmcxNFE4ejAyRXN6RVNaa3FN?=
 =?utf-8?B?SHJDL0RYeXZWTWVKZnlHbldpVGVvWXJEc28yd01WczgreXVhSVhmS3hKdTFz?=
 =?utf-8?B?ZXdIcDJvLzZVUzA2RE1wNUdGWWllT2NQSEN6bWxmS25ETlJsMHAvUHJ6dVE5?=
 =?utf-8?B?b2JZN1MwLzNXT2VMR0pNMUF3M2pnK0VvL2VIckorUko5d2o2aUNZS3FyUTgw?=
 =?utf-8?B?NDFWT2FHQVJJMDFQOVltU1A0QUF1VkhnSkszNS92eFlFcFo4UThLQlY5QkZC?=
 =?utf-8?B?cXBSTnUrZXU1YWREa1RoQmZLbzBYcGVaZTNpWGtlQjZJWW84UFN0dDhpanht?=
 =?utf-8?B?bDdnOGpxWDdvMVk3NVZOeHhqbnkzbDR1K21yeVJ2Q1J2NFpwMGt2VFlIVi9h?=
 =?utf-8?B?aDRycGQwaDJXV29uNWVray9GSUJXcTB5NmpMN2xBWVNidEVNRzdsRHBGa3dZ?=
 =?utf-8?B?SjNhZFpZQkJ3MnJyREphNFVIb2JUc2EyTHU1bnlPc1ZTb0I0QVRiaE8wenNV?=
 =?utf-8?B?MWRSOGFuNEVaNGN0b1BhUFRhNURDczgyME5JWUF5OEFqY1IrQ3pwZW0xUlhs?=
 =?utf-8?B?ci9vaXJxbCtNVkNVTHYzYzhubmhjamhBaTk5ZFpxaGpybmhVRlEyby9mcFlL?=
 =?utf-8?B?WkZCMVhhb0tvSmlwYUwzODgxbU9vS21PZzFiNVhaVjlLMmwwMmYxQk8ycUVw?=
 =?utf-8?B?UDRHUGF3WEt6eWg1Wk1LaEQwSTR1cTBzbHVqWjB1bXRiR0JKZ29Nc0ZnZ3Iz?=
 =?utf-8?B?MHMxcXVVWWdxOEk5cFNsTUE0R3FQVi9yQjFxY09TVnlwTEFpY0Q0WVVnaXR0?=
 =?utf-8?B?bERySVYzSG95cXpLajRyMnlyenU5RVRwTVhOUWsxdUV6d3MvOXBtVFpILytE?=
 =?utf-8?B?N1VsMitGUzlrdzZhd1NYSUViVXJKMnQ3R2lUVHU3alJUdHVSVjB6VlcyVmUz?=
 =?utf-8?B?cm4wTm5vRTVBa1hoTDB4RmNhTloxeW9DS05wc2FEdGVQSVNwRkRhWXRqNXlO?=
 =?utf-8?B?VlVpVklzTFJzTGdhTHlOZEloYkZBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6565ec6-9422-475c-aacc-08d9e4af89b6
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 11:48:03.2838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uBNQGG4AC569/PQ1BaZ3ndAUh00cGobg27lYMDh/VR16UTnCdpUdWvT4rkDbBeT1WrUv6kvcCJvvYi5WsCt/Rpfj0zB/kQgOrI1mU9z1swU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5031
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10243 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201310078
X-Proofpoint-ORIG-GUID: Ff6tsP-EAlS0fK2U57tKuf7-lICcyHv_
X-Proofpoint-GUID: Ff6tsP-EAlS0fK2U57tKuf7-lICcyHv_

Hey Vishal,

On 11/11/21 20:44, Vishal Verma wrote:
> Add struct_size() from include/linux/overflow.h which calculates the
> size of a struct with a trailing variable length array.

[...]

> +/*
> + * Helpers for struct_size() copied from include/linux/overflow.h (GPL-2.0)
> + *
> + * For simplicity and code hygiene, the fallback code below insists on
> + * a, b and *d having the same type (similar to the min() and max()
> + * macros), whereas gcc's type-generic overflow checkers accept
> + * different types. Hence we don't just make check_add_overflow an
> + * alias for __builtin_add_overflow, but add type checks similar to
> + * below.
> + */
> +#define check_add_overflow(a, b, d) (({	\
> +	typeof(a) __a = (a);			\
> +	typeof(b) __b = (b);			\
> +	typeof(d) __d = (d);			\
> +	(void) (&__a == &__b);			\
> +	(void) (&__a == __d);			\
> +	__builtin_add_overflow(__a, __b, __d);	\
> +}))
> +
> +#define check_mul_overflow(a, b, d) (({	\
> +	typeof(a) __a = (a);			\
> +	typeof(b) __b = (b);			\
> +	typeof(d) __d = (d);			\
> +	(void) (&__a == &__b);			\
> +	(void) (&__a == __d);			\
> +	__builtin_mul_overflow(__a, __b, __d);	\
> +}))
> +

The introduction of this two macro helpers broke compilation against < gcc 5.1.0 (think
CentOS/OL/RHEL 7 or anything resembling that) and clang 3.4. Particularly because of the
lack of these overflow builtins __builtin_mul_overflow() / __buitin_add_overflow() giving
errors like:

BUILDSTDERR: lib/.libs/libcxl.so: undefined reference to `__builtin_mul_overflow'
BUILDSTDERR: lib/.libs/libcxl.so: undefined reference to `__builtin_add_overflow'

Since you pulled this helper from the kernel, you might wanna pull the compat code too
that was there in commit f0907827a8a9 ("compiler.h: enable builtin overflow checkers and
add fallback code"), particularly something like below.

#if GCC_VERSION >= 50100
#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
#endif

#if __clang__ && \
    __has_builtin(__builtin_mul_overflow) && \
    __has_builtin(__builtin_add_overflow)
#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
#endif

#if COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW

#define check_add_overflow(a, b, d) (({	\
	typeof(a) __a = (a);			\
	typeof(b) __b = (b);			\
	typeof(d) __d = (d);			\
	(void) (&__a == &__b);			\
	(void) (&__a == __d);			\
	__builtin_add_overflow(__a, __b, __d);	\
}))

#define check_mul_overflow(a, b, d) (({	\
	typeof(a) __a = (a);			\
	typeof(b) __b = (b);			\
	typeof(d) __d = (d);			\
	(void) (&__a == &__b);			\
	(void) (&__a == __d);			\
	__builtin_mul_overflow(__a, __b, __d);	\
}))


#else /* !COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW */

/* Checking for unsigned overflow is relatively easy without causing UB. */
#define __unsigned_add_overflow(a, b, d) ({	\
	typeof(a) __a = (a);			\
	typeof(b) __b = (b);			\
	typeof(d) __d = (d);			\
	(void) (&__a == &__b);			\
	(void) (&__a == __d);			\
	*__d = __a + __b;			\
	*__d < __a;				\
})
#define __unsigned_sub_overflow(a, b, d) ({	\
	typeof(a) __a = (a);			\
	typeof(b) __b = (b);			\
	typeof(d) __d = (d);			\
	(void) (&__a == &__b);			\
	(void) (&__a == __d);			\
	*__d = __a - __b;			\
	__a < __b;				\
})
/*
 * If one of a or b is a compile-time constant, this avoids a division.
 */
#define __unsigned_mul_overflow(a, b, d) ({		\
	typeof(a) __a = (a);				\
	typeof(b) __b = (b);				\
	typeof(d) __d = (d);				\
	(void) (&__a == &__b);				\
	(void) (&__a == __d);				\
	*__d = __a * __b;				\
	__builtin_constant_p(__b) ?			\
	  __b > 0 && __a > type_max(typeof(__a)) / __b : \
	  __a > 0 && __b > type_max(typeof(__b)) / __a;	 \
})

/*
 * For signed types, detecting overflow is much harder, especially if
 * we want to avoid UB. But the interface of these macros is such that
 * we must provide a result in *d, and in fact we must produce the
 * result promised by gcc's builtins, which is simply the possibly
 * wrapped-around value. Fortunately, we can just formally do the
 * operations in the widest relevant unsigned type (u64) and then
 * truncate the result - gcc is smart enough to generate the same code
 * with and without the (u64) casts.
 */

/*
 * Adding two signed integers can overflow only if they have the same
 * sign, and overflow has happened iff the result has the opposite
 * sign.
 */
#define __signed_add_overflow(a, b, d) ({	\
	typeof(a) __a = (a);			\
	typeof(b) __b = (b);			\
	typeof(d) __d = (d);			\
	(void) (&__a == &__b);			\
	(void) (&__a == __d);			\
	*__d = (u64)__a + (u64)__b;		\
	(((~(__a ^ __b)) & (*__d ^ __a))	\
		& type_min(typeof(__a))) != 0;	\
})

/*
 * Subtraction is similar, except that overflow can now happen only
 * when the signs are opposite. In this case, overflow has happened if
 * the result has the opposite sign of a.
 */
#define __signed_sub_overflow(a, b, d) ({	\
	typeof(a) __a = (a);			\
	typeof(b) __b = (b);			\
	typeof(d) __d = (d);			\
	(void) (&__a == &__b);			\
	(void) (&__a == __d);			\
	*__d = (u64)__a - (u64)__b;		\
	((((__a ^ __b)) & (*__d ^ __a))		\
		& type_min(typeof(__a))) != 0;	\
})

/*
 * Signed multiplication is rather hard. gcc always follows C99, so
 * division is truncated towards 0. This means that we can write the
 * overflow check like this:
 *
 * (a > 0 && (b > MAX/a || b < MIN/a)) ||
 * (a < -1 && (b > MIN/a || b < MAX/a) ||
 * (a == -1 && b == MIN)
 *
 * The redundant casts of -1 are to silence an annoying -Wtype-limits
 * (included in -Wextra) warning: When the type is u8 or u16, the
 * __b_c_e in check_mul_overflow obviously selects
 * __unsigned_mul_overflow, but unfortunately gcc still parses this
 * code and warns about the limited range of __b.
 */

#define __signed_mul_overflow(a, b, d) ({				\
	typeof(a) __a = (a);						\
	typeof(b) __b = (b);						\
	typeof(d) __d = (d);						\
	typeof(a) __tmax = type_max(typeof(a));				\
	typeof(a) __tmin = type_min(typeof(a));				\
	(void) (&__a == &__b);						\
	(void) (&__a == __d);						\
	*__d = (u64)__a * (u64)__b;					\
	(__b > 0   && (__a > __tmax/__b || __a < __tmin/__b)) ||	\
	(__b < (typeof(__b))-1  && (__a > __tmin/__b || __a < __tmax/__b)) || \
	(__b == (typeof(__b))-1 && __a == __tmin);			\
})


#define check_add_overflow(a, b, d)					\
	__builtin_choose_expr(is_signed_type(typeof(a)),		\
			__signed_add_overflow(a, b, d),			\
			__unsigned_add_overflow(a, b, d))

#define check_sub_overflow(a, b, d)					\
	__builtin_choose_expr(is_signed_type(typeof(a)),		\
			__signed_sub_overflow(a, b, d),			\
			__unsigned_sub_overflow(a, b, d))

#define check_mul_overflow(a, b, d)					\
	__builtin_choose_expr(is_signed_type(typeof(a)),		\
			__signed_mul_overflow(a, b, d),			\
			__unsigned_mul_overflow(a, b, d))

#endif
