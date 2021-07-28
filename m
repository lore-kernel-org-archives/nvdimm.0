Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741813483
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 15:56:35 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SFuEue000386;
	Wed, 28 Jul 2021 15:56:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=XNDnpw8pmQoDbTGAzOUXpn50CUR3nvBVdN8mLeL/1Zw=;
 b=Nl4iLGnWnxxex3XJkO0UULnowSympKJ9WZsV7sb9ihaznlZ24moh+Ty04UznowNiYZ7G
 wYwO+m6Nn67LALheqRGxqE8Gc9F43VHakH7zU+Jkn8pTlVW60UxOde5Y9qfaQ0pruO5s
 jtlAJceMv8aaMO5GmHwQdW7Zi3qFxlA9A1pETTSccZGLqDmOFHrv+gNckzhGBknyqPod
 uBkX+ybEouWUz4yrmgerdv4u7OONlMgQHFLKYlY52UweqNcrpbSzQ7IoysQWXogAI2If
 9tnKXihURrjM/RAVJeuiO0beG9XAcZGDZ+SzNHOCcNMneVzAv/4yLv84+47lI0ac9D4/ Ug== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=XNDnpw8pmQoDbTGAzOUXpn50CUR3nvBVdN8mLeL/1Zw=;
 b=LBgL8u9E+l7zgnoe2h3N8DmgM11dmlizogn3heacanmPAIaEZVYK8pxL06WvDMPuMWU4
 wDFr69D8sXGQ6MR2GJXARm1lV+aNveeQyomBcV77qg5gg1FHO7tpZ8LB0V2FfDeqENNh
 eLwBpO7ZsasGX6g/dbaeH7ETsKddT/lTkvS6NCYdAuSoE/e3KYV4JY+l0l+lMhIFzytP
 rVAPuEGI1R0WeH19KYeXAtmJIGkmPlNieQjXAeThK4RcjHBqqgmSCWx43cGxtLgDxBPg
 zQswN7jU8BactJyhFxKW95qrw4LWBdiCeTLzC8bAkHggFUtlwfmXy8phIXoCuNTBPrCs pg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a2358cwxv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 15:56:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16SFtlbJ180310;
	Wed, 28 Jul 2021 15:56:29 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
	by aserp3030.oracle.com with ESMTP id 3a234cr6wv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 15:56:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fU7mO3cq+6grewldo3Qq1ifHvtor8aPn8Yq7+NuuvK9JKioiyyWLuzGAcI4Pdw7Vp2sVIrycTlCZub94dSsA/y6sWU7kWZj4pcavkkCHGqZRf7wRz51xXUXyzbniGGS4jPE6BThp8+4FnoMrNHxi+1LygKL7hOGgl8NcGYgfCO+nO2gc9WjDLL0CCcU5gJaJzlcvaEHIMrIW9nQMXwwFqWgt8Q8duXR4fTv2+dqcUtEXgO++Sbr/0ZRUaObFiALvbH5Rf9wjP/fn9vwyLfRZqv0VUfdsM5O8qNah1qautpDOnFxmg+5PI8j6Cz9pBWIqMkwBP/igw0In5kK/0nebvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNDnpw8pmQoDbTGAzOUXpn50CUR3nvBVdN8mLeL/1Zw=;
 b=eaazHvmED6fbrCm0ziIW90AKoIvwCezY95//jpio9U7vHZnVmvUfaLQ1c2F0/z2u7j/H+u3cU8UOaJsRUe5huVytvHpsMHlQrQMua+n3bwvfM4+ujYj3SNQeHW1lWZQEbFd28S7Dzh3+wmbuiylfvpmPTuFxx1Pxj0vFama91V73dlDuM6DB96jEAtWiMjcZTeUqNfHD+YGJC4LiN+5Sh3xjNTxdSnFzfdkt0ylDoQwX5z4oRAZLpFKn7pltvMR0QrGnrLjy9anfginJSo5WVoh+gTthNs9ysgA+ROUU9eHCl2aIbaHfIURaK1lsY66s/a/jQSdPPF5HvCPmB+tHKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNDnpw8pmQoDbTGAzOUXpn50CUR3nvBVdN8mLeL/1Zw=;
 b=k+V2nNt64ka6GQZApCn2ndWfkQuXCvQnVQuQ+rTw21g9S4Zq7Vo+50bkPBhDWPCv+FngJqvaVFOhvAZ3l+IZRCjeAMHVU6OqsX2R2vW16OEjOgyqPwK3HdeXOYwPx3Wh4KrVw2kIAgnRMc4j88SjB3mR6Kp3V8uai0gwolDDhpg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3965.namprd10.prod.outlook.com (2603:10b6:208:1b8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Wed, 28 Jul
 2021 15:56:26 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4373.020; Wed, 28 Jul 2021
 15:56:26 +0000
Subject: Re: [PATCH v3 10/14] device-dax: use ALIGN() for determining pgoff
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux MM <linux-mm@kvack.org>, Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi
 <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714193542.21857-11-joao.m.martins@oracle.com>
 <CAPcyv4hxn4_E0dJdLgzskzcJUsQ=0cb5KHM9_yiMLOeNq7muoA@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <6d3b5d7d-8a72-f2d1-81c5-3afe43d9d278@oracle.com>
Date: Wed, 28 Jul 2021 16:56:20 +0100
In-Reply-To: <CAPcyv4hxn4_E0dJdLgzskzcJUsQ=0cb5KHM9_yiMLOeNq7muoA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0136.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::15) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO4P123CA0136.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:193::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Wed, 28 Jul 2021 15:56:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 131651f8-d96a-4043-9cbb-08d951e04148
X-MS-TrafficTypeDiagnostic: MN2PR10MB3965:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB3965D30D66B67424B1E8B6A2BBEA9@MN2PR10MB3965.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	iRMnv8mNfZLC/3mwsbxAnIB89nr+olaFMZoa6mFwX66IWxCJ3QnC9+K5fN14E5dgl+JmucpINRQXOPe1XumsNLqPUQO1x+VUmrN1/DejRjSBx6FRwe+A4Wbwj/8ldHHocH5m/xyB7SuHc/lNph+81rCFJM7TJKW1uNSqTw/HUza4JyP4kf5GqEfQNmMbiYp6elPmVGH5uLkj9rocSJWflV7LgYTzenMtUnKKNMIMWphaiIpmZE1omfwocqXF9EI8lECzjpl6FXy6ZPg38D8kbSK7as28cKL3TBq7csABVEOwPwdNg2Y23HZ7YThvMnQkvOnEQDwGLPXmL9zwupXITVHcxWFdu3GX2JjtJ+8o85LrpQRQie1RMlbP9cfnMU3/LX83wysbQsUbpyzs0RkFX6caQQvpqRtezpVem2Hd0hwUSyKkZiu76LjE4KrgFNOi5A3bGB9CdGzgRTVHgPbMcVmm3IaRdSYYmjVeHjazhXRnoA9kh31eD0HeRkARbBQtLzHfRfPaH8SsbasNQejT4AKK3/Z9qwjJlQRQc0jZV84h/QDiN8HEkOuvxmMwSaNgP7tvt9Al45+Uudfhstyfwi1TDqoF6FLDkp22uiVFhiSBY2MhkYDyc7SVTF6RoPKtD26eiJBZFZZZa6QmHAU4RYdhX/bVxKrlL94fsWrHp6s2+cNT6oozrqVuTF99MnCEunyKoLMEYCr1v0mNBcdYrg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(39860400002)(396003)(346002)(366004)(186003)(66946007)(53546011)(7416002)(26005)(36756003)(38100700002)(66556008)(6486002)(31686004)(4326008)(66476007)(83380400001)(6916009)(8936002)(8676002)(478600001)(16576012)(316002)(54906003)(2616005)(956004)(5660300002)(31696002)(2906002)(86362001)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?VGFFZGw1U2RJajZnSEpSa2dMY1RxT0VMUW1IYnYvNGJZZ05SOG5UNTI5K0FM?=
 =?utf-8?B?bnduWTY1L1JPMEYxajJsWFRFRE9SV3B3K1F0eWNINkx1alJsSzlJQ3dJV1Br?=
 =?utf-8?B?dGdQUVVaWkhzR3JjV2RHeVlpVjdmNXlObklYMHVRV216dXNwV3hRUTdISzBZ?=
 =?utf-8?B?UGd6THp6ODM2a1FoTEw0V1NYQy9TUjM1Ni82U3JpeTBEaEZHLy9Bb1g5SXk2?=
 =?utf-8?B?cXJhMEQrNGoydDJsdStNQ1lNZG8vdHdrWUNLeVV5Ti85cExsZmtkZGNtOFZu?=
 =?utf-8?B?dFB5RzhlNjM5UlBSWGVqZE1tdnBpR0FUTXB2ZGxPTmJidnpWRlR6UWpKWUth?=
 =?utf-8?B?SnVHS2wyNDlOdG5XbGlIbnNmNlFBR2NmT2RHYWY1eHUzbTZYeXBTMUl0ZEF2?=
 =?utf-8?B?Zi9WemdwL1VuZEV4MXlUR3RpZWJyZmhiWDVWbWNtR09LT3lnRFpuVCtCc1dW?=
 =?utf-8?B?Z1RMUVBHcmxpZFJtbEU4L0ZnZEROVVcxa2RRd0F0bkVxZ2d4bVdDMWRqYlVt?=
 =?utf-8?B?RmtEbEdaMG0xSGVURkFPRFI2R2RJRjFmM1ovYlp4ekwzVG13VGZUb0t1Q2E3?=
 =?utf-8?B?RWhGaWMvSUFwRHh6cGh5cnlsaURwbDV6TFBlR0ROWWlPRkxPQlpjZEgySE9k?=
 =?utf-8?B?VkpFT2VWRkEzSGhEZ29EdW1DQk1vblVPc0t1aFpxczBuRG9sY3RYYU4zSXRJ?=
 =?utf-8?B?bFphNGRwaXhSUU9zMmFWVEpQTDdncVBrVHMzcUxNUmorckJyNWVJNWxUN25z?=
 =?utf-8?B?ekpzVmpURFA5R0lBb0NHN3ExWjJ0Nm1hbjNLWVlORUtYNHdydG5XTjZldmQ0?=
 =?utf-8?B?WGFsK1Q0SFJzM001WXRJV2FwT2JwSDRYNFllSk5RYktQMzVGTFFZa2J2M1Y0?=
 =?utf-8?B?amtsSDhjMXhJWENldlZmNkM3WFV5MFZiNE5kbktqNGxKTkU4ZTRCbkVqeEFE?=
 =?utf-8?B?OFE4dS9PamhNT2Z4ZTVOR3hVOFJSSGYwUXhaNEFCYTBMeXpHRmpPNGh5cEt3?=
 =?utf-8?B?ZXVwNFpWeFlIYTM3Sk94UXRhYkZkR1RZZE1FVDk5eTMwMGY4Y1paUlhkcjV5?=
 =?utf-8?B?TjRRa1hIR0RvNEFjMVF3d01sTldpcGhtU1ZrRFAweDZTTTZ1TzBXTFMxMFBM?=
 =?utf-8?B?TXMwdm9HdjY2Y2JOSUs1cW4vRksvS0dQTFdyc05VODF1MzB3aUF2Y0Y0NWRW?=
 =?utf-8?B?Z1diMGRHNFRGbVAxRE1ZaXVXaUZNUmJHdWRvRmFoNWNaZGd0ZnY0N01KTFFh?=
 =?utf-8?B?UHROV3BHM1NkRVZ5ZWh0RnZTU1BFaUdGYy9oeUtBU3pYMnI5ZU1YNytDYytz?=
 =?utf-8?B?NnoyZDRNVW9obmt3NmswT2ZqMXNOcHN0OExPM3JqTGNYbFlYb0RPa0FycUFU?=
 =?utf-8?B?elFkYzBCU2NSUXVrb2dsVmhqTlR0dzVJclhuYU1YQmkxOHFnZGVWWVNZTjEz?=
 =?utf-8?B?SW5Rck14cFd0blNwV3dkeithZldJWS91cS9pdWcwZkY5Nnlab25sZGpTQkVX?=
 =?utf-8?B?QkErRE01Uk5HbmV0ekpQazlGd0hQWUpQQkxUQjl5Z1VDS2VmMWhpb2hpTjVT?=
 =?utf-8?B?OWZnOW1CaldnRlliRnp5TVoySHBucTQyQmV3a1huRldlRGVyODV5SE5EZm5L?=
 =?utf-8?B?QkUrZisxcEkrVmFCZVZIRVZQOE9lV1FadjArLy9zaTVHc1I0WDBQV0JscXhL?=
 =?utf-8?B?bjYzUWowb21JcTh6a3E2cVdhSVUwV0RwWFpvVFR4cTFrV1ZwemVIRTMzN00x?=
 =?utf-8?Q?rsIVfJm/5XdaZSnBiUF90AANKJaw6lwDL0E18Yt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 131651f8-d96a-4043-9cbb-08d951e04148
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 15:56:26.0602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dR1sMHWmsLrKuTdRnCb4pavBp+z3kQ40CWyKtjjn5rTUibTylpJ5qk0hI55PXuSSU9wzrLpF5aWLtWqW0+g7A9q0wby/5BVbWS1UJQ8rHKw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3965
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280089
X-Proofpoint-GUID: BqPHwotgrFL3D5Jw-s_s_0iQtbsyvKjv
X-Proofpoint-ORIG-GUID: BqPHwotgrFL3D5Jw-s_s_0iQtbsyvKjv



On 7/28/21 8:29 AM, Dan Williams wrote:
> On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> Rather than calculating @pgoff manually, switch to ALIGN() instead.
> 
> Looks good,
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> 
Thanks!
>>
>> Suggested-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>  drivers/dax/device.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
>> index dd8222a42808..0b82159b3564 100644
>> --- a/drivers/dax/device.c
>> +++ b/drivers/dax/device.c
>> @@ -234,8 +234,8 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
>>                  * mapped. No need to consider the zero page, or racing
>>                  * conflicting mappings.
>>                  */
>> -               pgoff = linear_page_index(vmf->vma, vmf->address
>> -                               & ~(fault_size - 1));
>> +               pgoff = linear_page_index(vmf->vma,
>> +                               ALIGN(vmf->address, fault_size));
>>                 for (i = 0; i < fault_size / PAGE_SIZE; i++) {
>>                         struct page *page;
>>
>> --
>> 2.17.1
>>
