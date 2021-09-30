Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD8372
	for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 18:15:39 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18UHKURL018050;
	Thu, 30 Sep 2021 18:15:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=cQIINkeQvpSJHOuc54LQnP5wMmsrDd9cbxzfvsb/LkA=;
 b=iPC4maesj7CSv1LSXUCzRi7lKc9xaxwp8x1DMi7SvmsYQf944VnsdG4jLu/7HLZmVXIb
 x/8SHXXZDE//5NszKr7nNsKQ/CkYm9XJnYdu3vz1b4NJxLBcGpU0G2/DosPvYAK6LjC/
 rtIdP4k1zMI8q6l0VyGeq7HjCDHfwyvJQvOLXsBGUcOENzP75QGqaFgG8veFvKninGHw
 nZ8PFfk9AeTnX9Tf9+9lRSCL6m9/vhR5ClQE/AnOAbpamXm/vGyqZebUcJU5+4baYdS5
 Raz+4PiKR33N37T51m4aqGY9INHZqfF50vZkWZS6Up8PaZ8Rj5VgcRe5Wx45liV6lGjP Qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bdcquatwp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Sep 2021 18:15:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18UIBobK038133;
	Thu, 30 Sep 2021 18:15:28 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by aserp3020.oracle.com with ESMTP id 3bceu7g28s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Sep 2021 18:15:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jOQB6TKCi5BZUQINmX+Vz96AvM6/2ynKwrr7MhkOa128EfH00ZzH7Vb/qFE3REn5p7VzcCcDwy42mHzXMvVuVDxnNEZ2QyTyUP4yrxXAo6mMvb2qvEvEnDTXu3NFqSdLH2aZ0BLXfiX+UmarnxhhvfgmjpPs+nbnzRyuE92Zs2fnTfM5FEsMcQjwhC4Q4cubPhrwGCoL7y1aHue76TZWBh6MGwTwuCtL4/SYsketZDU2dAzLn7rkRRB1BX7qoeccSa40jfWpyvgAuKsNyKwX9qfQNCC4Z24ndtfcULflahOpiBN1VXK+eIdSDmkNv1T0D6kbeXK7UkiCOw8XXXF2WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=cQIINkeQvpSJHOuc54LQnP5wMmsrDd9cbxzfvsb/LkA=;
 b=UdpCfLrKzfSVziQfFpkJHMT1UWHM00pOzvjt8ZevAd4K/jF9Bi905vvDYWDHRS/ARYIj1IVlZf4Zmua1P748VYVQj6UZzIsWKcRA+kLu1oXoH4hb6Af0R30kCzvPMwNpa/EjFneBiHlHo1HW5sfU5azoObmLdF2XKkHio7E1vQ19zSU4Z65LtuRrl3LQZCvcR1Yd6Ofruroi7o4xX1mZqEb5cBVXhWDsgXwSMavVULJv5CfO6zmluKrbkMCZ4v3ZJfXuJ6v2fteeuwojB4IvNZP1krPrJeLUnbmFAluVQy3TfeBRXMHbLWKzbgKdNC6svXhSDd7EyWLSF+TNO+vIwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQIINkeQvpSJHOuc54LQnP5wMmsrDd9cbxzfvsb/LkA=;
 b=zSPiLgL2khvadFsEI+7aU3Yx4DGpBme7lUC8RiiGSiVOBm0g1nI87Znub4KKzVf9vV+C1h9ceXR6pPoWZZ6S0bW9PE33f76BlOxn0LTQD1eIEldglCQy8Lu4VQ+cyjr8MITgh8cVMsj98xWaD0mrr1pHP3favCg+qw2wY6Xx9Qk=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by SJ0PR10MB5485.namprd10.prod.outlook.com (2603:10b6:a03:3ab::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17; Thu, 30 Sep
 2021 18:15:26 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::401:1df2:3e9a:66c]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::401:1df2:3e9a:66c%6]) with mapi id 15.20.4566.014; Thu, 30 Sep 2021
 18:15:26 +0000
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
To: Dan Williams <dan.j.williams@intel.com>, Borislav Petkov <bp@alien8.de>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Luis Chamberlain
 <mcgrof@suse.com>,
        Tony Luck <tony.luck@intel.com>
References: <162561960776.1149519.9267511644788011712.stgit@dwillia2-desk3.amr.corp.intel.com>
 <YT8n+ae3lBQjqoDs@zn.tnic>
 <CAPcyv4hNzR8ExvYxguvyu6N6Md1x0QVSnDF_5G1WSruK=gvgEA@mail.gmail.com>
 <YUHN1DqsgApckZ/R@zn.tnic>
 <CAPcyv4hABimEQ3z7HNjaQBWNtq7yhEXe=nbRx-N_xCuTZ1D_-g@mail.gmail.com>
From: Jane Chu <jane.chu@oracle.com>
Organization: Oracle Corporation
Message-ID: <7183f058-6ac6-5f81-9b46-46cc4e884bef@oracle.com>
Date: Thu, 30 Sep 2021 11:15:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <CAPcyv4hABimEQ3z7HNjaQBWNtq7yhEXe=nbRx-N_xCuTZ1D_-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0098.namprd05.prod.outlook.com
 (2603:10b6:803:42::15) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.39.229.226] (138.3.201.34) by SN4PR0501CA0098.namprd05.prod.outlook.com (2603:10b6:803:42::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.8 via Frontend Transport; Thu, 30 Sep 2021 18:15:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ecd590a8-7e04-4082-1616-08d9843e4726
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5485:
X-Microsoft-Antispam-PRVS: 
	<SJ0PR10MB54854D8710BA83AF21FA5054F3AA9@SJ0PR10MB5485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	KzLNpe923GV74jCu6yr65o87txbOkGKhPSObSe0C5ObeFJ1gE4rph+xW30c1nmX5SL+kI7XTrroI5wF0vLGUV3aZ4KH0pLUDt8mjJvTIEYRDO8vHgWa8mhOfx0AWy6Y/7E+RmThZx3H0mjyn+t4mU2bCEwg+RRs22YKBgBc5QSvvVOgE/P8xKgHGbWv7cEUOXGxFz2tTv9rZ0BBN8Y+rRk/qCl8Q2CmDOfeZIle6quBtraE+v5AGFI5o3m/MJcvl5fJlvVM6EDRNxTF5bzOvtwejDBYq8nO4PiwDugmzY/g/f8LTwo9xmn5cjx8f3x3mcaZlyCon9GyFjjxcDHe1CLUbWu98v6QjRACG2fOJJb4JWJNeX6Nhxtvr+MpxCQXHVdbEmyKHLyeObRtb9spAJoMafnc3cqPc337/Azc813yjff7WHtVU7cMjCSUq/d27wUiwx7yIDf1x/bBNE8mjmXtqqF+947lt6k29pMUXCsRJfU+Azk6IjtLjM6ziVGEzsxZibXrO0qP/nPGHBhUzEquPU7seBAa8KLQb8zBXuzY3HlQwS82rmEHeRdxEliT6O/sX3ukSUd6PFaKkHWZZhO5NllMDrvy1XUlZl/x3PF3tLc6zSpkZTLwMM6xS3m0HaR/KtF/V8Y1qZ3RCObBjyT2KDPyNyxRol1qBmCod3R7ABKHlWODQ6qBkWL8EMXVwoS9zfURvf77cUAnEnxpAXqvS9Kh9tmhcnZH1YK7XENo=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36916002)(8936002)(53546011)(8676002)(83380400001)(38100700002)(4744005)(36756003)(316002)(2906002)(44832011)(508600001)(4326008)(54906003)(110136005)(16576012)(66556008)(31696002)(5660300002)(6666004)(186003)(26005)(86362001)(956004)(2616005)(31686004)(66476007)(6486002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZHR6cnkxUVFhdmZTcllMYzB3Ny9MTDV0ZWk0WUpzcFI4Njl3K2o1QmtKbzQz?=
 =?utf-8?B?S01pYTRTLy9NYlVxK3M3aTIxVDZVc04zSTdRNnJydmQ0SDJrNHhvc3gwYW56?=
 =?utf-8?B?N1RrUVkyOEY1SHlTWklxZHNQaFZvQWpHKytIdEZMSkQvZE1VTlI3UllPaS9N?=
 =?utf-8?B?dGZoNUFyWWQ3RnM4Q1RzeXgwZy9FTWlxMitwcnhyTzljYlVROWFtanJBbHBQ?=
 =?utf-8?B?TlpsNEt5NDJYTFMzdklobjI1QjExV3ppRFlWZm5JUUhWR2NRVGt3K0IrY2o0?=
 =?utf-8?B?bmhzVnhnUVdiYXg1TUZLQlJvQk5lWEFLdjcxa2dpQWVoZU5QUjBINUJkcGtL?=
 =?utf-8?B?eHJHUHVqVm5oeFl1blQyM2UrRFVxQnYvcklHTFloVXpJKzRhbVNsRmpoYjg4?=
 =?utf-8?B?T1k5U2tyQm41WDZIMFk3MlpJaXhsU2tiVlB4M3FQa2x5MmNpaHRPVHVjbTh3?=
 =?utf-8?B?Ly8zSTBuaCtIc09IeFhOTFcvdzNJUTdCOVI3Zm52dVF4STZraWE2TmROL1FN?=
 =?utf-8?B?MFF1ZVo2YjNsV2ZtcEhOTWlnUnVWbTB3TE9GTU9oNzNYdk52eEFwcVE4OW41?=
 =?utf-8?B?ZnRTZmZpWEFIcmpRY3Z5Um1GbkdzNUJLSHlPVVhQRkRZeXNUSmxpU0xKVkt1?=
 =?utf-8?B?ZlN3NGJUVDFHV01BbU81cnNiVjNHOFdTMDRja2R2dUJuL3RkMTJQRVQ3LzRj?=
 =?utf-8?B?UEo2UmpjSG82RHJzeEMyQnJ5WVdqbWhLUnRHc3RudWpOVytaZFZ5TGtiYXo3?=
 =?utf-8?B?VzlCYW9xcjUzdTBqNmdsTGZLZzF0eGp6b2RGWUU0bjd3LzNTMWlrOEM0Y3dW?=
 =?utf-8?B?K2JvTWdMWVdja256YlBPRXhVN0ZvTWZ3cGE1bWhZNGMybDlwblI0VWJBcGND?=
 =?utf-8?B?V1lFaWdRb0ZPVUhMYkhVT3ZEUUhZTnFhWkxuRjZyMjl2dmQvbWV2MXZMbkVF?=
 =?utf-8?B?UUR5WFRIVXRORXVQUXY2cDdrNGJEdzZhdFFuL2NSeHF6bHlhOWVEcGZVQm9R?=
 =?utf-8?B?NEd5WlRoQ3d2cmpxZ3A3ekhIUnhtMjBld3JqVXByNXQ0bEs4S3VzNzBtVXlQ?=
 =?utf-8?B?c0lSNnZXaThzNmhxSU1QbmRMM1ZuOGFSVk9tVmgxbVJ2S1VPZ0oxaUxWRjFD?=
 =?utf-8?B?VWFSYVNaS2xoaktoNFNiTlRNOVNSNGdwOVZHKzJhcXhoN2pmY2FiL01Iem5G?=
 =?utf-8?B?YVRCaFpjdUd3UlNJVDl2M3lnRk81QXJ2Y3drZmZ4MjkvYnU2QUZhWVJONDJT?=
 =?utf-8?B?V05CbkpyVzA5NitkVmpNb1RRVERDd0g1UWhTSnh6cEw0a1g0YVZFaThYZEN4?=
 =?utf-8?B?ckdEdXc5T0pTWGwzTE9FS0xKSXlpQXJYUW9HYnVQYWxSTGx0cEVycU9wVHdD?=
 =?utf-8?B?YkxUYm5tSTlMeUVZcnRyVzgrNTVYVVI0bVA2dThaV2o2Zjg5SDlKL0pDWFV1?=
 =?utf-8?B?K2ZkcjJLYmRIVEdqNjBoQmk0UEt3RzFPU0xiZi9MNDc4SFd6ZmQ3UDhtQnJa?=
 =?utf-8?B?amNZN3pMeVV2aHhpZzNzT3JjVE83NjJQVzRhVm9DZXFtVWZ2UnJTbHRoVlUz?=
 =?utf-8?B?NnJVZmljNkZDalozY1g4Yk4yKzFwbDVFSEpFRzJQc3BVdm1icG0wcU82cFJu?=
 =?utf-8?B?MmlMeU5TQ2Vudzh1NWl6a212b3NVcTZDZU1KdWZCM2hXdldXOWptQTgxcWdW?=
 =?utf-8?B?Y2pEbVN1SlRNdW1XNmlMeGZTYXJ3a1dWbndLUHdxY1pOVHNDQ3ZyWFhrK0RC?=
 =?utf-8?Q?MvB1lT9/9XefTToUghuvMoQw3+gtpDI2u9zxgD6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecd590a8-7e04-4082-1616-08d9843e4726
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 18:15:26.7795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: okx2HLPnZT9O4ACKECU8SPqKbtIAf+2U5nxBfq1vlG9tyEn3QFv6IirEbf99VtTkndsIYCqux2xfT13Jm5Td5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5485
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10123 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109300111
X-Proofpoint-GUID: C0lAJKPZyySFWu2LZ-ZFV6hB8nB48uSz
X-Proofpoint-ORIG-GUID: C0lAJKPZyySFWu2LZ-ZFV6hB8nB48uSz

Hi, Dan,

On 9/16/2021 1:33 PM, Dan Williams wrote:
> The new consideration of
> whole_page() errors means that the code in nfit_handle_mce() is wrong
> to assume that the length of the error is just 1 cacheline. When that
> bug is fixed the badblocks range will cover the entire page in
> whole_page() notification cases.

Does this explain what I saw a while ago: inject two poisons
to the same block, and pwrite clears one poison at a time?

thanks!
-jane


