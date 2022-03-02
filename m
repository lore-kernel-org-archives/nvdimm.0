Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85B07C
	for <nvdimm@lists.linux.dev>; Wed,  2 Mar 2022 10:57:52 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2227rW1A016190;
	Wed, 2 Mar 2022 10:57:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=a/xxjHZ5uZeIbNOkR4wp5DjV0/d5E0n3+ktZvq0c8dw=;
 b=RswhWb8Fpjv2hxSCzeULRdbZ3k/i3qjEpvlMZDdO7YqfmwPscgJQwO5up7v08mEtaoWk
 wq3eZ/43jdo5uWFzDLsjaC258/zQMV202Zq5JB0tPMbj9mr19WC+Dlj3uxNWxcufJwJd
 PPmruOz3mOobh2CWU24Oyd9J+fl4PvssWZA5W5i8pr5JTbZGZJmD+HN6KuNThWXWcCkf
 K0xIntHlJoI/QdB+7XBhQnfmxfwsRntnV6+gI7tKeVuLHwIBS+GDoxB6dernkzZktQxi
 N3K8o42ZS62riQx2vfwBF0DBlNHp/FRSn4anijCv5+fu/iB/9iwWXygxhmFZ5CJGe40H CA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ehbk9c1v3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Mar 2022 10:57:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 222AtNlh128238;
	Wed, 2 Mar 2022 10:57:47 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
	by userp3020.oracle.com with ESMTP id 3efdnq0pwv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Mar 2022 10:57:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8VVNFLfa3GsA0SH+PMwS0N8wRpKqHq5e5AkNrc1bL1WHewHvS/LiFW45qScnh6O9oUtevwNh2A73vW5hT/KMvaVx/vfsdeWDVDdba1ocPxeFRPPz48bMQeJBqIQc6ZVtrnDOK9WqVvxOEER4UE5K+dcSvyQOQr/aWfwDU6Tgm7cTEgTgp1hbkfkTE2Rfd/CVTT9pmySWS3YSyU6xyg04wEi34+yghSPkwdGXT1H7igNubTQC7rLEq6LGvKUwWZJMkVz3/Wi3EdPu2e6Jdp+07OdheYWQRYLl61PVSOiBk+XZaRKgrPWYKVLi2h6qnEqMEfGAGxb9DzqK2JEyVwIQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a/xxjHZ5uZeIbNOkR4wp5DjV0/d5E0n3+ktZvq0c8dw=;
 b=QT/5e5hTbBESRsj0tq/DaMZEQrl2CalDqJj8FJvwYOYfqRw+kRmm4mmdphZ++Xyny7Dj5QPJR7YCjhsy/EhnV4eAfRgFAmy1OLDjztTW235/ETV769O9KSVHWZTQYxz+cpSL2qVUOMKkCTfZvkYDxhjMLjUJG7FJh934q27zeUtnMOunOW2Mz/IdH6tgoPdr46Zh+asoD56zCLh75uvgRAXCxWyqHoEl7z+Iabz07cYY1TkeU3k5aFZ/koXU3UklREoTCMnD7LV9qt1YAUP2zoIVyQwpNpiaXxv3uP4+tb+/MjoWk9ncVO7Yuev0exUZs6CA+erBG1VLU9QaZ/LgjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a/xxjHZ5uZeIbNOkR4wp5DjV0/d5E0n3+ktZvq0c8dw=;
 b=cF5mM3sPHNwcJLhikyg7zxDs41Tu1ZkexEuAX8IvGXa3Y1TK7e/P/v3CL3+7lHfhjRYIDUiIU53/iezpISpYSIfOh4d84F/1NVyrfEwwMs0VGK8YkwGZYeTkf4OpvzTGSwTLwWMHfSbEK72TD/gNzRxtiG8alImeT2mrKS3fpxk=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM6PR10MB2540.namprd10.prod.outlook.com (2603:10b6:5:b9::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Wed, 2 Mar
 2022 10:57:45 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%5]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 10:57:45 +0000
Message-ID: <e8be0c0b-a74f-1e19-9a67-082d014ef4c1@oracle.com>
Date: Wed, 2 Mar 2022 10:57:35 +0000
Subject: Re: [ndctl PATCH] util/size.h: Fix build error for GCC < 10
Content-Language: en-US
To: Vaibhav Jain <vaibhav@linux.ibm.com>, nvdimm@lists.linux.dev,
        Vishal Verma <vishal.l.verma@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>,
        Tarun Sahu <tsahu@linux.ibm.com>
References: <20220226113955.526036-1-vaibhav@linux.ibm.com>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220226113955.526036-1-vaibhav@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0291.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::8) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6910036-798e-4d9b-5451-08d9fc3b7b38
X-MS-TrafficTypeDiagnostic: DM6PR10MB2540:EE_
X-Microsoft-Antispam-PRVS: 
	<DM6PR10MB254061FC5D997C7EAB7BF5EBBB039@DM6PR10MB2540.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Wsy4WrrOrKNUGMNtUWENeGjk/+TDsjLINfoCczLPw2DK1QJdguQ0oVLDBxe1lSqj/O7ObzZEpxrizZ5f0I2unYL4yhjOC5X67CJ7fl1ZL6zj2hhs7mNJlh6OsB22H0WkA3lMDwIw6zxCo8MK8cWJrhQZ1Ghv22Y99TQsGzXKq53kp6PwvG73i00pWXyxNHewe+iVk6lu5TG3YblNKtVl1JSrunIaUogkzOPRtZbg7Eene6UU8K8gY/SM2JNTWw9kkRG0auQlqjhAdo31/tdXGeZPWwy5jyCDOMvrCqGF4KryGdYW0MmLqsuL+18Fzb0//PF8qSpBh1mmAOKDbhFR/+4R7l8MshzRZ4k/mN5Nl3J7QO9EIIsZfFvioV9X35SHN96KnUnvs6Y1Pd3TG3z3cXl8LV/4SnAHTFN3pJPdwfV45wxNa6Q24kFHqW/d969tO9Vzm/qaIe2nJJx0sDD6IY5r5rw/h3LcYBJvhZlnMOG71ubRG1rg3lN9rT4JpaaC/42aJ8vgE16nDFjtWJ6pdjkpg8omInd6lSX3dcQD3MbzyvaIvPGwRrNiE+XLfpW7rDJjIbapil3UsCteEYk2mxB0hEtooHg5wfNCM0EwM5OwPa6SZEwVRbcA73UgydW842XkVFxoUf/jwneMZYf9oHmjn4s58xv9NsMBM2E2z9dKiTB9ikrY4Rps6o3J7q3+/Mn4hmifyjLqngVo7sdQhg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(6666004)(53546011)(4326008)(38100700002)(36756003)(6512007)(31686004)(508600001)(83380400001)(110136005)(54906003)(316002)(86362001)(8936002)(2616005)(5660300002)(2906002)(66946007)(26005)(186003)(66556008)(66476007)(8676002)(31696002)(6506007)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Y0NMazdjaEJmcG42QVJnRkE5dEIrZkJ5dmw4VDI5dUlsTWFtM2V1UVZ1ZjRY?=
 =?utf-8?B?NXIvSU93ZmR0eGROT21paTFYazN5SFlzTENSMGZqaUlOb1QrV25IUTdWY2Za?=
 =?utf-8?B?S1hoYUJkSTNZWSt3NVRnMTFJbk4wWnpzQ1FxcUw4UFNhTmpqQnoyV2hRWFRY?=
 =?utf-8?B?L0hHMHZmKzN0K2VUdmhMVmhRNWFPNjlJSHN5RjRpSldhaXB3WHgyMzJWM2NO?=
 =?utf-8?B?STRtb245dFZRUWJVVWdWN2x4Y0YweGJrVFlSTFVuOTRrNXJVN0p3eHIxSjF3?=
 =?utf-8?B?SThCamhKak4rb0Fsb0p4Z1JwSkhoUTJIVkFzTUdOWFk0NGVCMHVsNEdRbURD?=
 =?utf-8?B?THRKMGY4bVVlVXdYeTZKRTQrbFk2T1F6eUk0bFZyYnZoSnRUaE5pNmFDKzBi?=
 =?utf-8?B?UUdGbzUvUlZQd3JIOGs0UFlST2N2a01UZWQzSDlTOGRvSmxPOHE3MWltNnMv?=
 =?utf-8?B?bXJJL3VHS212b2l2T0t6bEM1dXpZMHF1NzRtYThFVXUxaHk2RTF3YnVpM29Y?=
 =?utf-8?B?K3NqR3UvV0xqbzI5S1ZEbXllbmtoZVpzMzU4QjRKUUlRdUZGaGwwMXVET0Zr?=
 =?utf-8?B?S0RWOUdrYUlSOHVWSm41MmNFZlVXck1tSHBsRVJMaXVUYmpXc1V0TTV4bXVB?=
 =?utf-8?B?SmhQQ2RYRWxYUVFKNHRZQUYvZG42bGFEYjdqWkNIdzdrSlNsT2NMNXZKVCtE?=
 =?utf-8?B?b1RLYlRneko5MDBhTFVvTXQ3dC9QU1E4ZkorSk02WXNRN21lbFRPTlVSaGdT?=
 =?utf-8?B?WjFlOWlJVS9KelYwM2hva0VuU1BoVXJaNzJzV1hjL1JRcFBLbGxYc3VxeXc2?=
 =?utf-8?B?RnBCdGVJcHcxanlCMUdtTjRyemFaeURHd29ZVW4rYTJrVWFMTzRMd3pKTm1h?=
 =?utf-8?B?cFhvSFhVQU5ObklvanBBeWtCUWVESW5vdnFQQmRuaHA4RldtNEI1aGd1NnZv?=
 =?utf-8?B?dnQ0L1FiQ1YzUkh1YUZQYzRQTDZLeHR1WlNGYmlxaFBqTUdtOElyRldqQUpV?=
 =?utf-8?B?b1F3MFRWNDV5WTNJUk9pQ0lXTjE3U2RBbWZzK2ZvZHlCNkJ3aDhqd2pqUVJ4?=
 =?utf-8?B?WjNVTCtjZDBZL3NBb0ZxeFhlT2dDZmx4L1ZFdXBxOFBJanI2R0k4emhiQTEv?=
 =?utf-8?B?OGg5cXdWVzBiS2lhaStwZi84dmxyUkhWaUVCMno0T25hb0l1WTVOTFJrVUpW?=
 =?utf-8?B?WjRXQXhzRmdXejllRW81b2hHSzB4N2NKS0QzaktVT0toTWt5S2srZ2tweStM?=
 =?utf-8?B?UFQvN2p6NXRLblBHQ1g1ZmVFbXpsdjUwSy9pZ1lDN09UcEpUeUphTDdjb2Ew?=
 =?utf-8?B?NE41S3FuSnF0SW1oaVdqblM4VWEzNFI0bWhDdVhrMUJNb0N3bnhVa0ttam1B?=
 =?utf-8?B?bkVPOFdNQjQ3VWluRlBCeTV5SyttQ0VCb3o5RzBmTU9FaTQ0eVlPd1plL1Zs?=
 =?utf-8?B?UnBHUGNnUWtCVFhzQUUrek1FbnBJYzJJeE1Gb2Y2NDFxaVkyNStGWHFTSUc3?=
 =?utf-8?B?VWV5a0VrNUhvU1pXMVArVTdvcTZWdkZPWHgrNTNzamYxVlRISGNuUC9wWXdB?=
 =?utf-8?B?V2MvTEJOaWVyWlhJb0pZK3VUc0JmZHJOVXo2d3BDWitiQVZpazl5YTJTQUt2?=
 =?utf-8?B?ZHA4WDRjSmVhWXJneVVqUW1uUXVsZ2VTVVhRSkl2NExJVlh0YkExdllBMTl2?=
 =?utf-8?B?VmxFQnJVSHFWNUFadm1sRCtVWm1YRk9EWFA0c1ViOVF3NXVSTkNhSDcycmJu?=
 =?utf-8?B?YWJQRlFTL2ovNndidkJ0QzExNEhlcXoremJJK2xmMjFlVVg0aTAzTnR6ZHRU?=
 =?utf-8?B?cEl5SjU3UHRlTEt4SmY2NXg1RGJEbWJQVk8zYVQyaEJjcEdkMjNpc1BzWmVT?=
 =?utf-8?B?MUpNNTRnVUppYnZUTFR3Mi9FSXRNUnNmUjRKQkFOUTh6T3Y2czRPTEsxLzBR?=
 =?utf-8?B?WlJoOEc3d0pOOE42YWVER2VxSTY2ZSs1aFdMSzdQKytacGkwMkZWOHpuQmdL?=
 =?utf-8?B?ZlJlMTNFNkRwbjE0QlBvbWVUVmVBdUM5YVZWaTZrMGJHYUpSck10eXV0TWhk?=
 =?utf-8?B?ZFVia1NzQnMwTktRdXdWRThwYUJRSDBoOFpkY0puckNJV0wxMEkyaHc3Tnc2?=
 =?utf-8?B?aTFEYlVlcTlJYjA3NWJQaWs5WnNQaWFkT01hQ3Jtd0c1NS9CZ08xR1NpaDlW?=
 =?utf-8?B?MEMxT21PcjdrNW0za2xlT3FLYnZqbk1Xd3RWTnZtbi9yMjBJbHkrSXNIQyt1?=
 =?utf-8?B?NlExSHpVSkFQMnZxcjk2RDNReUNRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6910036-798e-4d9b-5451-08d9fc3b7b38
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 10:57:45.2382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: alcbJ7CPKeJoPZ2smFF8bwnC8rCeMj40DqLhXwzHUxoMFezEK0aH7DbgDmysqPLcafhRnIzQ68lcRX3dCtZF76rltH3e8a3tsv5W8rvcEDs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2540
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10273 signatures=685966
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020046
X-Proofpoint-GUID: 1eftwYgonMFqaUsZnCnhthXsKDdIXGTq
X-Proofpoint-ORIG-GUID: 1eftwYgonMFqaUsZnCnhthXsKDdIXGTq

On 2/26/22 11:39, Vaibhav Jain wrote:
> Building with GCC 8.4.1 results in following build error for 'util/size.c':
> 
> ../util/size.h:57:16: error: missing binary operator before token "("
>    __has_builtin(__builtin_mul_overflow) && \
> 
> This is caused due to missing '__has_builtin' preprocessor operator in GCC
> versions < 10.0.0. The patch updates the check for CLANG's availability of
> __builtin_{mul,add}_overflow to prevent preprocessor from evaluating the
> expression "___has_builtin(__builtin_mul_overflow) &&
> __has_builtin(__builtin_add_overflow)".
> 
> Fixes:10653a171bc0("util/size.h: fix build for older compilers")
> Reported-by: Tarun Sahu <tsahu@linux.ibm.com>
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>

Reviewed-by: Joao Martins <joao.m.martins@oracle.com>

> ---
>  util/size.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/util/size.h b/util/size.h
> index 1cb06690261b..02baa77fe649 100644
> --- a/util/size.h
> +++ b/util/size.h
> @@ -53,11 +53,12 @@ static inline bool is_power_of_2(unsigned long long v)
>  #define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
>  #endif
>  
> -#if __clang__ && \
> -    __has_builtin(__builtin_mul_overflow) && \
> +#if __clang__
> +#if __has_builtin(__builtin_mul_overflow) && \
>      __has_builtin(__builtin_add_overflow)
>  #define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
>  #endif
> +#endif
>  
>  #if COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW
>  
