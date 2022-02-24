Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC90184D
	for <nvdimm@lists.linux.dev>; Thu, 24 Feb 2022 10:09:38 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21O7iKlj014635;
	Thu, 24 Feb 2022 10:09:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=80STcLBOAxrzJlqhZiLGrtPMeT0NbjJfUrvROYqse0c=;
 b=mryXM/HggMS4/uLE9BNQHJBD2IFpy0CceCEzZdnDPnKBQYeY5kbxyvQFlANsmYcn5ScK
 Jt7KhCYj9wvVobWRNIrrJ2WfmR393Kr5Fw807ToXRmj8mo1XWGkGGEFAjob75Lv/M1f2
 kJuwS0zzeVLiYspCqlrz2MEAjy4ZbIkdq7Mbs/dFkm/POWbExEqXUwXHiZdepfjP8tfN
 Lg5s+eHnC0r3HjPAJ5TtMGY7U6acVweQuWCpfBByjm5Pwl9OgGD+Rz2fM8FVX0vYN/bp
 45F0/oCXaDvUB+f02w50cgb6yrm6Nx7o7uYu+0gGffphI6zpMcqAsPJBdp6CunQyEojS 6Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ecvar6j0f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Feb 2022 10:09:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OA6wmG034870;
	Thu, 24 Feb 2022 10:09:34 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by userp3020.oracle.com with ESMTP id 3eat0qjm5u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Feb 2022 10:09:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GdOHOTZEK7aHVqYgz+F7z67G9gf3zXmWccaWmO4mHP0BYBALUgchHQkytftfXHXU6u9xG2Eow2pSZCKmI/cYFie7iQuqEn90CTcS9lY/yFwvj3GCgp6gsI47llcBtFTxN5/761Ug0XADNyQ6l/TtOk7O8kiiHKH0bVsa6YMfpETr/8mpEvfIwy+wAkx/xkUTYqnKMkMihPAhrN+pEbJn40GoamKGNTx2TURlaKluDaQzwlAOExvkoUZE6LKlHzmJ1MMJ8CSJpC5MDGtxYHndPQa9xgaCSVHBEyevILiFCxCQyja+EuxhXAMT8lgZkKy1deVEMRvfoSdCxPG45oXYUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=80STcLBOAxrzJlqhZiLGrtPMeT0NbjJfUrvROYqse0c=;
 b=OwDbGzBD7Y0LR8+D42mskPEwnH6OpST/NQ6nAzm/KRmxx0lMAd1OrDfthCC6x1UHzOa7wUwTQs52Ajyc8Jo5eKuUAU9T1L0jGohw6T/J5u8y5cOEFcjZgvv0WMFYPYXqrlSUfd7u2LrsgCHQ4yucQEDSVqlGs0SLryLCz6pG3QONtU9ALh6tl4Zpn7pg3hW/CxPo/yR4n1DLnzybuencyx8d0I+14WkQRfvsmteILYsgTfQnCp4iw9yjv7RxGl5rMJVMa2OAp01wP8YUm0Mu6hBq+4K6+IyQgjFSxx8PDwhEwUnx3aVZXD/I3Wk26iFyrOBcKgFG94xa61B3GZCwMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=80STcLBOAxrzJlqhZiLGrtPMeT0NbjJfUrvROYqse0c=;
 b=GeLFO1FctX/1pD8VxmrTJFe6BuAecK01KblTVQL57VpO5Pk2jOJQ3UjmJj467RKprm7UWNJNkSh9WMbthoXiVTZHAeurLgJkRcGn5Ab0yPZ7bcLq1yCDWVfWhOIm8uYlu1MoDIcJLyucTRsY2tcZYSe5HL37bkwdffcmahbPtKY=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4948.namprd10.prod.outlook.com (2603:10b6:208:307::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Thu, 24 Feb
 2022 10:09:31 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%6]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 10:09:31 +0000
Message-ID: <961d9b1f-2012-ea30-0d3c-f797b222ae72@oracle.com>
Date: Thu, 24 Feb 2022 10:09:25 +0000
Subject: Re: [ndctl PATCH] util/size.h: fix build for older compilers
Content-Language: en-US
To: Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
References: <20220224052805.2462449-1-vishal.l.verma@intel.com>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220224052805.2462449-1-vishal.l.verma@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0462.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::17) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60bed72b-7155-46a9-b644-08d9f77dbfca
X-MS-TrafficTypeDiagnostic: BLAPR10MB4948:EE_
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB4948F3029245FE9449540940BB3D9@BLAPR10MB4948.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	GO7YE7afxr0Jwue7FnFD0tUwJC6re1pg/5G+SWa1x4IuMMi1mplpJTHMGZNoUKmyRnxKXuE3lJwpBMGfxrV0BZLE/q/Fzj0yeB6DbYzYt86pTAouCMTBvSynuq04dsETzM/ZJMuiQuJQrpuJkqDr1gl+2bdv6y0h+6lTG06NYA+ucwJdDprGD7Rx9En3R0XVRjr+WRYl6a4JwLpvlMObfWHTE+cptbhvhb0SUgAqeSaH1m5u63B50SI4KlyjRGgQPWFCfAArAbYLA/99gpQk3F7hCPELohFz/+VaosswsdgKbDvYSjITzL8ftWySZO2uGBLzWeQqQcPJbWbU9n22p3E6G8HtBCmQ6XLPK9totLZ+2e2iyZQQDORMXbQip6VCEaWV6IbOMocTBnl19BppNh+uB4bPnz5PFEY7Wr8pDZ+p8PVNN2UtIuJ4wK60zU93BVYH6kJ5pso63e6CEZVYZv8DbZiDKjAi0KhrAggzMGI7COdPu9xVleD9qzVMIhAWy4chondLmz4wleSvkLNqQAXuo3Z8LtG/mUg8FVDB4Losp4E194YoCzdbcb3vQFjYX4j/TJWxLXH3GRRGwJTTgo2UEDsD+1fT+OxXdxAN14Rj+ORmc5/2F/ZX/p7y5UDakxBRBHcstHg7jOzRh0e6UgX6FxzzFWyt6HBqC7wMeekpIXe5F2PkbiA4Y8dmHnHoHvQjCiaYvYPVOYGw/44r3g==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(66476007)(53546011)(6512007)(86362001)(4326008)(6666004)(66946007)(6506007)(8676002)(8936002)(508600001)(6486002)(83380400001)(5660300002)(36756003)(26005)(316002)(186003)(2906002)(31686004)(31696002)(38100700002)(2616005)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?d1BtNnVyTTQ4OEpyRTVRdUJGUG1USTBJbnUwNjZxZHlxRHdreHMzdzUzLzhG?=
 =?utf-8?B?bUdEMW1WcVBYbmtJMnNwYkxMTGg2UHpMZzJCYzV5ZUJUOUZiS1pGeTByRFJp?=
 =?utf-8?B?aWxjd01jL0hZWS9YQXZlUmxRZzlDMWc4Q1JiNTRIVklUaDhDaUZDZDVBL09R?=
 =?utf-8?B?WVZIaXBUQmdBeWZhZEdtWHNxWEF1SWhWU1pFR0J0aVpmM1JOUy9GRURWYUVs?=
 =?utf-8?B?M3kyUHZsamFlQkRrVVBYMC9LVlkyUENNblh3MWlHS1kvSjJVU1ZDS2pnTTc5?=
 =?utf-8?B?VkVSbTBsMy9lQmFRQzR4MjdtUktQUjdQUzFGSDc1WnNVc0psblBjOGlhUGFN?=
 =?utf-8?B?RVc1VHJ5V0gyN3hSUmd6R2gvZFcvaWhRanVSY0hsNnRwSWlDZ0RJTGtrd3Vq?=
 =?utf-8?B?eWVxcnU1N3hQMEZORXhRaExKZ0xwaWFrRDM1SncyMGluTFczZlZjRzZCUkhp?=
 =?utf-8?B?TGNiVHArc2tMSFBsd0x2QTk2MCtXYXN5UllpbHVzVGU1c280czhsRmhmbWVM?=
 =?utf-8?B?YWh2alplMWVUVWNaUkEyZ015NFE0S1JRSTgzVWRTVXpURm9pNTlzM09PbmZM?=
 =?utf-8?B?bGIwVkxLZHZNZExhRExkRWZIL2NoeGprZFRFWTkxcUtOM1dodnBZdWxmRFd5?=
 =?utf-8?B?eVB5WEV5SU8xUDRVc1lFNUROcVNMSS9IelZwQmFqTmpGZ3p0cVJHQUlUZ0NN?=
 =?utf-8?B?Zkk2UFozSG9wR3FMVXdQd2tBbnZGZXFkazZqSFVrR3BGcWVybzhVdHAyVldl?=
 =?utf-8?B?Ty9TTlB1dmZyeVFKVDZsWEpDY0twblF3MHZTNzZZVFM3Z3NNaG9VSVRCS1J4?=
 =?utf-8?B?M2hXbXFRbk12WldwajZUQ2hYV05DLzVuN1prMFo3Tmt4TGtHdHVKTERVdk5Y?=
 =?utf-8?B?Qis5WTFmM1NPRU51d3ZhZkl5TyszNHJZVms0ZGRzOGUvWjg2WXVyQURDN055?=
 =?utf-8?B?ZEpkREVIZGJ2NWlvQlptM25mRmM4aTVZc1lPbGR1bVUxZVJ0dWhvMTV0NjV6?=
 =?utf-8?B?d1VWa0gzRUhGQStCZ0ZLVmtoWml4cDFiU05WTjk3Wk54NkJaWEJGM3FjQk5Y?=
 =?utf-8?B?d3NLaFVsY0hSRXk1eTZDTnE2WTBMbjNyQXFqWGM1K2FPNzd0WkZsM0VLVTdx?=
 =?utf-8?B?ZlAwMG02blV6b21ucUQxMWdvOEI3TElJZjRjM1F3a2o2VkwzTVdyRVJ4US9h?=
 =?utf-8?B?VjVzU25SUnVhQ0gxTlZLL2JiOStSNGJlcjJIRkZ1bmswZGVjaGtOd3NXWmlz?=
 =?utf-8?B?Y2RmZlRBSFFnY0pGWFhYa083Qkd6TE5NYnpkNDlhemw4YmN6VEhwNUZtdW1i?=
 =?utf-8?B?QnpFZVNPa0l4eFdtTVNydEMzUThuUVlaYVUrNzYzd1N3R21nTjBMYVFUMzRr?=
 =?utf-8?B?S3gvZDdmK1pqanFUZHBpL3V4aGtIdE5NZXdBaEJwd1R5YnZad1FRU0REQlRK?=
 =?utf-8?B?eWZVRnk5Y3VTaUs4TUFCeGRYa0FHc0x1emFIbGtVSHRreWFkNVZoZzN0dzlK?=
 =?utf-8?B?NVZtMDdzRFFEcGtVMTVsRy9UKzlibkFUOWZGTm83dWJzSDFGVGV3VHVtWFVr?=
 =?utf-8?B?SS9Hb1AxeVVaMU1GQXd1OTY5em5FeXNrM2cwWG43dnA5dG5ZZWNWVjl0NGdD?=
 =?utf-8?B?R25JN2xXaHVxZXR2Mk4wRWJMOGw5R1FvQmVFcnZTM2VuTmc2b3V4QVNwSW1K?=
 =?utf-8?B?Z09MWHo3Q2dRdXI0c280YlNOWjdxNE5jQVZrQWpCT2lKNGx0YVAzMzBWWmlq?=
 =?utf-8?B?V0htaEpyWUtCWTVmVUNRcWxDWlhlWkkwMzltcHBXbDZKYVJOMkhZaytuR1RV?=
 =?utf-8?B?cXBjbGRaR2lMTWVxc05uWFFEZnZSYWpzU2xmL2VHSFc4OEthQmR6Wlh5azhO?=
 =?utf-8?B?Y2dVU3EzRXVzMkxjYi9sL0dUWk04SnpKeVVqQ0xlMWpvNjZZbGpkUGg4UHNq?=
 =?utf-8?B?cHlZTGN4TkFkTW9GSFZFOURlZG41T3RYNEZTZ3d6cFFvWDNNVERJZmszWnVY?=
 =?utf-8?B?NTIxOXJpTE9EUGxyS3kyRHRmb2IwWVZ1dncrN1gweGVzenllL0tPamlpUmxh?=
 =?utf-8?B?ZWpZWXBMY3N5cjJzS3cwdFRIUkVUM3ZjWnVsdFdkQ0g5UndvWGpsaDl0MHd1?=
 =?utf-8?B?S25vcTZXVHBlV2tHNkk5anp2UlJCemNaSzFmZmdTVWNONVRBNnNUczI2NnBw?=
 =?utf-8?B?VW94Y3dYaXFaem9CclY2bVoreVEzeUFTYUtXaWtESGg1UkljRU5EQTB3TXBk?=
 =?utf-8?Q?0KqfgFgV9x0BSnZMXepevEd2pPG747wuT9vA7VsQZE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60bed72b-7155-46a9-b644-08d9f77dbfca
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 10:09:31.4403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4UxaV79b8twykYosziDbg50V2TLXs1B7QMaZSEsMCHK7SP+xBEZpa6RZEyw9rrTBExUTDURHxaLTXVSpp4kP2JH5MWciKUIe4UTi4WFTjb0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4948
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240060
X-Proofpoint-GUID: 9cF-pzhiieeTWWT6yllf-Cnzk-qZHZgj
X-Proofpoint-ORIG-GUID: 9cF-pzhiieeTWWT6yllf-Cnzk-qZHZgj



On 2/24/22 05:28, Vishal Verma wrote:
> Add a fallback for older compilers that lack __builtin_add_overflow()
> and friends. Commit 7aa7c7be6e80 ("util: add the struct_size() helper from the
> kernel") which added these helpers from the kernel neglected to copy
> over the fallback code.
> 
> Fixes: 7aa7c7be6e80 ("util: add the struct_size() helper from the kernel")
> Reported-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Joao Martins <joao.m.martins@oracle.com>

You might wanna want this to get to v72.y branch considering the breakage exists
there. Thanks for the followup!


> ---
>  util/size.h | 163 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 159 insertions(+), 4 deletions(-)
> 
> diff --git a/util/size.h b/util/size.h
> index e72467f..1cb0669 100644
> --- a/util/size.h
> +++ b/util/size.h
> @@ -6,6 +6,7 @@
>  #include <stdbool.h>
>  #include <stdint.h>
>  #include <util/util.h>
> +#include <ccan/short_types/short_types.h>
>  
>  #define SZ_1K     0x00000400
>  #define SZ_4K     0x00001000
> @@ -43,23 +44,177 @@ static inline bool is_power_of_2(unsigned long long v)
>   * alias for __builtin_add_overflow, but add type checks similar to
>   * below.
>   */
> -#define check_add_overflow(a, b, d) (({	\
> +#define is_signed_type(type)       (((type)(-1)) < (type)1)
> +#define __type_half_max(type) ((type)1 << (8*sizeof(type) - 1 - is_signed_type(type)))
> +#define type_max(T) ((T)((__type_half_max(T) - 1) + __type_half_max(T)))
> +#define type_min(T) ((T)((T)-type_max(T)-(T)1))
> +
> +#if GCC_VERSION >= 50100
> +#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
> +#endif
> +
> +#if __clang__ && \
> +    __has_builtin(__builtin_mul_overflow) && \
> +    __has_builtin(__builtin_add_overflow)
> +#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
> +#endif
> +
> +#if COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW
> +
> +#define check_add_overflow(a, b, d) ({		\
>  	typeof(a) __a = (a);			\
>  	typeof(b) __b = (b);			\
>  	typeof(d) __d = (d);			\
>  	(void) (&__a == &__b);			\
>  	(void) (&__a == __d);			\
>  	__builtin_add_overflow(__a, __b, __d);	\
> -}))
> +})
>  
> -#define check_mul_overflow(a, b, d) (({	\
> +#define check_sub_overflow(a, b, d) ({		\
> +	typeof(a) __a = (a);			\
> +	typeof(b) __b = (b);			\
> +	typeof(d) __d = (d);			\
> +	(void) (&__a == &__b);			\
> +	(void) (&__a == __d);			\
> +	__builtin_sub_overflow(__a, __b, __d);	\
> +})
> +
> +#define check_mul_overflow(a, b, d) ({		\
>  	typeof(a) __a = (a);			\
>  	typeof(b) __b = (b);			\
>  	typeof(d) __d = (d);			\
>  	(void) (&__a == &__b);			\
>  	(void) (&__a == __d);			\
>  	__builtin_mul_overflow(__a, __b, __d);	\
> -}))
> +})
> +
> +
> +#else /* !COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW */
> +
> +/* Checking for unsigned overflow is relatively easy without causing UB. */
> +#define __unsigned_add_overflow(a, b, d) ({	\
> +	typeof(a) __a = (a);			\
> +	typeof(b) __b = (b);			\
> +	typeof(d) __d = (d);			\
> +	(void) (&__a == &__b);			\
> +	(void) (&__a == __d);			\
> +	*__d = __a + __b;			\
> +	*__d < __a;				\
> +})
> +#define __unsigned_sub_overflow(a, b, d) ({	\
> +	typeof(a) __a = (a);			\
> +	typeof(b) __b = (b);			\
> +	typeof(d) __d = (d);			\
> +	(void) (&__a == &__b);			\
> +	(void) (&__a == __d);			\
> +	*__d = __a - __b;			\
> +	__a < __b;				\
> +})
> +/*
> + * If one of a or b is a compile-time constant, this avoids a division.
> + */
> +#define __unsigned_mul_overflow(a, b, d) ({		\
> +	typeof(a) __a = (a);				\
> +	typeof(b) __b = (b);				\
> +	typeof(d) __d = (d);				\
> +	(void) (&__a == &__b);				\
> +	(void) (&__a == __d);				\
> +	*__d = __a * __b;				\
> +	__builtin_constant_p(__b) ?			\
> +	  __b > 0 && __a > type_max(typeof(__a)) / __b : \
> +	  __a > 0 && __b > type_max(typeof(__b)) / __a;	 \
> +})
> +
> +/*
> + * For signed types, detecting overflow is much harder, especially if
> + * we want to avoid UB. But the interface of these macros is such that
> + * we must provide a result in *d, and in fact we must produce the
> + * result promised by gcc's builtins, which is simply the possibly
> + * wrapped-around value. Fortunately, we can just formally do the
> + * operations in the widest relevant unsigned type (u64) and then
> + * truncate the result - gcc is smart enough to generate the same code
> + * with and without the (u64) casts.
> + */
> +
> +/*
> + * Adding two signed integers can overflow only if they have the same
> + * sign, and overflow has happened iff the result has the opposite
> + * sign.
> + */
> +#define __signed_add_overflow(a, b, d) ({	\
> +	typeof(a) __a = (a);			\
> +	typeof(b) __b = (b);			\
> +	typeof(d) __d = (d);			\
> +	(void) (&__a == &__b);			\
> +	(void) (&__a == __d);			\
> +	*__d = (u64)__a + (u64)__b;		\
> +	(((~(__a ^ __b)) & (*__d ^ __a))	\
> +		& type_min(typeof(__a))) != 0;	\
> +})
> +
> +/*
> + * Subtraction is similar, except that overflow can now happen only
> + * when the signs are opposite. In this case, overflow has happened if
> + * the result has the opposite sign of a.
> + */
> +#define __signed_sub_overflow(a, b, d) ({	\
> +	typeof(a) __a = (a);			\
> +	typeof(b) __b = (b);			\
> +	typeof(d) __d = (d);			\
> +	(void) (&__a == &__b);			\
> +	(void) (&__a == __d);			\
> +	*__d = (u64)__a - (u64)__b;		\
> +	((((__a ^ __b)) & (*__d ^ __a))		\
> +		& type_min(typeof(__a))) != 0;	\
> +})
> +
> +/*
> + * Signed multiplication is rather hard. gcc always follows C99, so
> + * division is truncated towards 0. This means that we can write the
> + * overflow check like this:
> + *
> + * (a > 0 && (b > MAX/a || b < MIN/a)) ||
> + * (a < -1 && (b > MIN/a || b < MAX/a) ||
> + * (a == -1 && b == MIN)
> + *
> + * The redundant casts of -1 are to silence an annoying -Wtype-limits
> + * (included in -Wextra) warning: When the type is u8 or u16, the
> + * __b_c_e in check_mul_overflow obviously selects
> + * __unsigned_mul_overflow, but unfortunately gcc still parses this
> + * code and warns about the limited range of __b.
> + */
> +
> +#define __signed_mul_overflow(a, b, d) ({				\
> +	typeof(a) __a = (a);						\
> +	typeof(b) __b = (b);						\
> +	typeof(d) __d = (d);						\
> +	typeof(a) __tmax = type_max(typeof(a));				\
> +	typeof(a) __tmin = type_min(typeof(a));				\
> +	(void) (&__a == &__b);						\
> +	(void) (&__a == __d);						\
> +	*__d = (u64)__a * (u64)__b;					\
> +	(__b > 0   && (__a > __tmax/__b || __a < __tmin/__b)) ||	\
> +	(__b < (typeof(__b))-1  && (__a > __tmin/__b || __a < __tmax/__b)) || \
> +	(__b == (typeof(__b))-1 && __a == __tmin);			\
> +})
> +
> +
> +#define check_add_overflow(a, b, d)					\
> +	__builtin_choose_expr(is_signed_type(typeof(a)),		\
> +			__signed_add_overflow(a, b, d),			\
> +			__unsigned_add_overflow(a, b, d))
> +
> +#define check_sub_overflow(a, b, d)					\
> +	__builtin_choose_expr(is_signed_type(typeof(a)),		\
> +			__signed_sub_overflow(a, b, d),			\
> +			__unsigned_sub_overflow(a, b, d))
> +
> +#define check_mul_overflow(a, b, d)					\
> +	__builtin_choose_expr(is_signed_type(typeof(a)),		\
> +			__signed_mul_overflow(a, b, d),			\
> +			__unsigned_mul_overflow(a, b, d))
> +
> +#endif
>  
>  /*
>   * Compute a*b+c, returning SIZE_MAX on overflow. Internal helper for
> 
> base-commit: 3e4a66f0dfb02046f6d3375d637840b6da9c71d1
