Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0F472
	for <nvdimm@lists.linux.dev>; Thu, 25 Nov 2021 11:42:42 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1APAXupr032756;
	Thu, 25 Nov 2021 11:42:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=WxCUOT23AsgmvEuXL5bSMEw6HIpiD8JsOSc0n2SmUJI=;
 b=w0z5Gewye3aqb9NzTn0FYOGoqYXiSPig6Eme3Y2NGV9Asw6t3xEB/WdeM6XTSBJvWasz
 FSUCW6gvL69n7ZvtwMyrDc+grBWH3aAlH64xeWihfz+7Cq0sHEi4ioJyjBFh5Nzcn0P1
 fXAHIE3MDxMP8dGO7svOUJXssE8pxErd6x2oCN4fSlCv4FxV2t/qIZkggBKpfttAJJIL
 cfvmZYCHaohzYIu0/Xvjm/EgSwS3NVSjIOL30NMR9urzxMq9aFL7VoV1lFsBnYi7+b57
 3jdEnEv9TmNBMw5IZDBJVzQ8mGKP1PzJM22VLufBl8WAPJYcRRMxw0J7NDgPmcLmZsGj HA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3chkfkf3fy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Nov 2021 11:42:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1APBfRHq194645;
	Thu, 25 Nov 2021 11:42:34 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by aserp3020.oracle.com with ESMTP id 3ceru8jk6n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Nov 2021 11:42:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oMmbz0D7qXH/8zp4AquxsEbp87QJht4F/mjOzh1P8v8gvcrlSVfltIFAJHNqJWMMfQH7AIBKQSrPnft9GRbBVHv1Gnr6eXfW8SYuKj+UTvJp1LT3LKNr5r1WFp2K55k2YtOjSDbfyWAwc4Hdv3S8LTA9iVHXauGxn3yGiP28gwDslSwauJ4I8OYfZyxchoStoU0LuaiLQQLEi947bhPwaFnSahzYqzABSd4eUHrudWmPm1f2TmM8wloUabDEz+ZZuKiBzOy57rPr3aXXd0J353UCKWFa3m2QHPF/W8D49CtpvzCUva2wfaxgY6tY6Q7p26OI2il30gJghg9P3ZI7bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WxCUOT23AsgmvEuXL5bSMEw6HIpiD8JsOSc0n2SmUJI=;
 b=ZW2f3CTg77mCYL9Hhad+Eu5fhINGSbyX5ROU9Oqv6EqB2x7gBpAZ0fOAbETbVvgr2FCMgq5lkhwVUc7htDiDuY5hFt+gi/jk3zi7C5LdzDGUwaaR29/Fi0kcSx1iNpzb49mSV8ozfWXLg1dfpYYtwZFEoOmAv71rTxhYxgEpiIknXsdM1OeJielCyihBn1qZ2HfXv9e1bVrMgMhq6685gyaE+JBYn/xienjVTF5WyfX0uxBhTKdwieSn3f6qEJZ77ED94onBEc8bwYbVpryXflI1eCzbMjtlkODXLxRUMuYtM9OifUFLfJ65oqtIy6D1rKVXcRaBGofhcDMGbZsEfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WxCUOT23AsgmvEuXL5bSMEw6HIpiD8JsOSc0n2SmUJI=;
 b=I1s+Rxrdu5afcn+3FF96mStnoz+S7gbMw9f8RoL+yxD9HucfYS+s9Lo9Y1VPctLhu15rf61sYFRGqN0HZjwb5NRI0L6kDrx4J3e8ZiTXGTWP38nF5IUc53DgIvzBTiWzuFNW001V//eSCJUW8evPGvRKVpaFG2K+wIM2LAXxdoU=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5155.namprd10.prod.outlook.com (2603:10b6:208:320::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.19; Thu, 25 Nov
 2021 11:42:32 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%7]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 11:42:32 +0000
Message-ID: <0439eb48-1688-a4f4-5feb-8eb2680d652f@oracle.com>
Date: Thu, 25 Nov 2021 11:42:22 +0000
Subject: Re: [PATCH v6 09/10] device-dax: set mapping prior to
 vmf_insert_pfn{,_pmd,pud}()
Content-Language: en-US
To: linux-mm@kvack.org
Cc: Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
References: <20211124191005.20783-1-joao.m.martins@oracle.com>
 <20211124191005.20783-10-joao.m.martins@oracle.com>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20211124191005.20783-10-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0011.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:150::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.177.229] (138.3.204.37) by LO4P123CA0011.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:150::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Thu, 25 Nov 2021 11:42:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 964bc6ca-537f-4dde-1f85-08d9b008aa7f
X-MS-TrafficTypeDiagnostic: BLAPR10MB5155:
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB5155470F6051AE28C2A5BA9ABB629@BLAPR10MB5155.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	3TlGzy4ewPV3CAlD5Onri92jZDCpjnXU8otckIiL3+Jw+TwrA8rukXQBMiIbwJGM+A9LHAkVDhonIWU1y2jYVECv/OzCvSVRIuqkmQE/Uig2NmNYtA0kdz9+RmagfsdKfqRzss7J6neT08LpFzFHM7h1fi0ZhmmEkaZEj0tgT9HtYjZ8LPQtNFuu2H0KjIVxwJjdPZSijp3Zz8TE7IZ/I3KQFZTG5ZnETlv/LH3TktQDU2spJnZlAT1aQREq/K+YC9DE69d55Vo7ZawBxuI+gFcPgE8ISD0/wzdYT27wUZ4xbwEL/8+BDq1Qtj34ZWzoqkTHO/eKWXDxqunjFZUs+1htlqMfH3tn2la1P7hLTvK8Gwh/Nk6boAYNo9T509Fz1qNPyA2ecaJ5j4GuQcyJHpmxU7B6KAZc5iZh6A3qv6VDLKXyteNXSgFE+wlY7/x/9ovXwcfO0CIMODz0s4GJegCtBqCZPwV5FPZTQSeVZe77ov/STZPaAxDgVr4BvWj84RvvzaDj0UUBg2MMXW28ArJSoJRKowqPeglOzMKYOV8VUcFLHH7QOLsr4niCJ0K5E0hhNjh4VCmq7jQB19Fip/KDFakMnvQA3n37wVdwWc/O/8pd+/0sO/KCxCjwJcZzqLJzll1zW4/OI9LbBXnXnFTW7SZCEb6veLNV8O6naaR8hBm+DF9czwQeG02Ok9ESqFpsuQj4lFvm6/loWD/hyg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(186003)(508600001)(31686004)(8676002)(2906002)(6916009)(5660300002)(54906003)(2616005)(31696002)(316002)(956004)(26005)(4326008)(7416002)(16576012)(53546011)(8936002)(38100700002)(86362001)(66556008)(36756003)(66946007)(66476007)(6486002)(6666004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Y0tPLzZmY2xHWGxMQkp1TktpWXdRRnNRVWVIWVVpVGord3BOTHBxK1poWWgw?=
 =?utf-8?B?OForYkpFRGIxNDFUVmxiVkVEcENPWVJDQ1FiV3I5SnNkejNhdm9QYlRVY0Fr?=
 =?utf-8?B?bzVzK1dTbnFrY2tZMDFtbDZGQk1iNzdDVHowVWpNKzN0NWNhTUFMVG44dUp1?=
 =?utf-8?B?TDZwTzNBb2RUUzAySU5NUllOM3E4bzZSV2hBS3BUaHU5NGxVMFgvNkRCY0hR?=
 =?utf-8?B?SDhFT0huamxEaWRnYVpDaDFzUHRRZERGWGdRTFliT1lhL1ZGYzBvN01JUVho?=
 =?utf-8?B?UFRDTE02bmdjK3orcU5uT3VIdE5SVnRDenVrZTZvMU1FUEpkMUp2dEx5dzd4?=
 =?utf-8?B?N0hjTDBPNXIyRU1QeVgzVksvOERMUW1GTjgzVUs3bGR3cjVXbWZCb0RTV2Rh?=
 =?utf-8?B?Z09ZOWU4VExyTTNxVlFaT0lDZDBuL01PclJQTVpmWjBlUjJ3c3ZuRTZ2TmJx?=
 =?utf-8?B?UHRGU3ZrTkZsVldoajFCVWhtRHpYUUY2amRnNlBzajZqRFdZd0E3WkM2NGxQ?=
 =?utf-8?B?d2JaaGd3UFo0TGkzcjlJVDY5SkhJUXdDeGhHU0xLYUs0enA4UWJGWlczSnZj?=
 =?utf-8?B?UG9aWktwWnVRYmt5bEw3SmwwUWVVSXNLMGh6K1FFc3FEeXdhYVkyZFFSa1Na?=
 =?utf-8?B?OGxpYllzQngwRWNHdVlMcEN4VEp6U2I0Yy8yeEdGRG9vZzlwTkxxQnd5cGRI?=
 =?utf-8?B?TzhlTWpHaFNzRkhyQmVvSCs2Z1V4U25RTlQ0S3Rra3BWRHp0TTJRVzkyblVH?=
 =?utf-8?B?dmljQW1OWm1qWjVObmlFVU9hM3poVWpubXFMazdWcVhOOEZzMVhqN29hd3Nz?=
 =?utf-8?B?ZEtJTDA2UGg2bEZ3QmdhNmlVbElaSlY5bWkzNGcwTlgvV1dSZks2UU1DeGlw?=
 =?utf-8?B?UGw0V3BNKzR0VnpoVk9TSWp6dTRnbHpUaDhLMGNJczY0aXhiWUFhNmJhSkVU?=
 =?utf-8?B?bFM5Z2hXcUNCd0hWRldERUlwUW1IWVFNclRVMy96b2dzdUdCNkJXcHl0bkpL?=
 =?utf-8?B?NENpWHJ6YkZJVktZKzVuS0hLY0NKTjFjMG00UVdlSHhvSDZ0K0RIMTNMOWgw?=
 =?utf-8?B?clhqVkZjZTUreUFXci9WN0hYK1FKejYrRG1yUHVxZHpETnh4bEZZa0w1SUg2?=
 =?utf-8?B?eDR2L0p6djBIUzhVU3BtbmE0NFZsSXRGU1JHOE1oblRGT1p1L3BrTklJeW52?=
 =?utf-8?B?M3VxWkdnYVAyc1dUMVhyTHZVdmRoalgzRWNNS0F3c3J4YTUrOWlXNmlFemwv?=
 =?utf-8?B?emdaS0FRSXNwejkzbFlOdUtCcnJtNTErN3IyaW80dEY0L05jVG11bnJ2R2RM?=
 =?utf-8?B?eXU5QUpTZzdEYm8xV0Fsc3ZJYlpFcnhsSmc5R0k0RUVxeldUQTNvTmMrbWJo?=
 =?utf-8?B?Q2xUSTVSbGxqRVJNZmo4ZnVGN2JhY0VYaSsyL0NhbFNReUNxMDVsYVFxcWZ2?=
 =?utf-8?B?akNnY29IdEh1MVl1TUhpTTVuMUZjZzRXTzZZSDZKN0pnN0FqMkd0RzNaT0Zz?=
 =?utf-8?B?cDRKTzJES1djbXZjcGhNT09EZjAyd2JWTkhqamZSWUpRVWFyeFg5cFQya3NG?=
 =?utf-8?B?OXdTTGxhOFdEZFVHeTBsZ2dzQ2ExOThGektVMlAzdXZtYVpyOWZOcnQ1S2cx?=
 =?utf-8?B?SHYyNE5mUmZieDVYa1UwdjZ6WnBsT3hxaGhiSVEwZ3R2Zm9XcXpveTRJOTdP?=
 =?utf-8?B?ZkFTakQveWFtK3h5dWN6RzdDYkxHT0NJUTN6YnVabE9xVHc1TW01RkRJTTZj?=
 =?utf-8?B?R2Roc1pHNlFWUTlvWG55NC81aUZSdkx0V1Q4V2RHdkh5SmllTmM3OWpGTWVZ?=
 =?utf-8?B?R3NYOVVQWmRwM0tjelpCaFZ4SVpCUE1WRS9QdkJtYWVmRWtabVNkcUJWMmtZ?=
 =?utf-8?B?Qmdkclg2Rk1ja3AyVnEzaGVPb0grdjBmaW9VRUU4bS9WSzZsR294Ykh4UlY5?=
 =?utf-8?B?NE1VTnFMbVNUZitIUDJ3d0ZWQjArVUpCSldtaDlrd0JzekZLSmVrUjM4R0dO?=
 =?utf-8?B?b0VCays0MVBhSE81aUprZzdPRExjQ2NKN1UxM0dNdnJudVFaMmdLUUlJdVcr?=
 =?utf-8?B?TktKcXkzV0c2RUlQVHhtMWhONTc2aWZ1M0h3VGxKWDk0alRlVVJaQk5nUWs2?=
 =?utf-8?B?dWJRMXR6cXdFL0l0S29rcGY2cUhBVE5DaHMwc25SZ3BiaGo3eHJGLzliaFJ5?=
 =?utf-8?B?ZnM2U2t0RWtwSmxnUUxqUGlHM2I3aEdGSVRxQ3FlMFk3bUYwOUhpSENzemd5?=
 =?utf-8?Q?m8OMRybC8rX+u5sC14nQuF48v35d9b4Cc2ApFf03UU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 964bc6ca-537f-4dde-1f85-08d9b008aa7f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 11:42:31.8491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GfZDU0Kg9UteWV9GTD8GmmhOKKyvodrptqj8jbPGLq4SW0TlGP7mh1a0VaN5Zk1uuilZagLfP78xcjE/GC7zATuNkaPY+hYHONWE1xVBP9E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5155
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10178 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111250064
X-Proofpoint-GUID: tNLKyvmKE8a6YnqaipuU_FSXBmttTfYk
X-Proofpoint-ORIG-GUID: tNLKyvmKE8a6YnqaipuU_FSXBmttTfYk

On 11/24/21 19:10, Joao Martins wrote:
> Normally, the @page mapping is set prior to inserting the page into a
> page table entry. Make device-dax adhere to the same ordering, rather
> than setting mapping after the PTE is inserted.
> 
> The address_space never changes and it is always associated with the
> same inode and underlying pages. So, the page mapping is set once but
> cleared when the struct pages are removed/freed (i.e. after
> {devm_}memunmap_pages()).
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  drivers/dax/device.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index 9c87927d4bc2..0ef9fecec005 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -121,6 +121,8 @@ static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
>  
>  	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
>  
> +	dax_set_mapping(vmf, *pfn, fault_size);
> +
>  	return vmf_insert_mixed(vmf->vma, vmf->address, *pfn);
>  }
>  
> @@ -161,6 +163,8 @@ static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
>  
>  	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
>  
> +	dax_set_mapping(vmf, *pfn, fault_size);
> +
>  	return vmf_insert_pfn_pmd(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
>  }
>  
> @@ -203,6 +207,8 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
>  
>  	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
>  
> +	dax_set_mapping(vmf, *pfn, fault_size);
> +
>  	return vmf_insert_pfn_pud(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
>  }
>  #else
> @@ -245,8 +251,6 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
>  		rc = VM_FAULT_SIGBUS;
>  	}
>  
> -	if (rc == VM_FAULT_NOPAGE)
> -		dax_set_mapping(vmf, pfn, fault_size);
>  	dax_read_unlock(id);
>  
>  	return rc;
> 
This last chunk is going to spoof out a new warning because @fault_size in
dev_dax_huge_fault stops being used after this patch.
I've added below chunk for the next version (in addition to Christoph comments in
patch 4):

@@ -217,7 +223,6 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
                enum page_entry_size pe_size)
 {
        struct file *filp = vmf->vma->vm_file;
-       unsigned long fault_size;
        vm_fault_t rc = VM_FAULT_SIGBUS;
        int id;
        pfn_t pfn;
@@ -230,23 +235,18 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
        id = dax_read_lock();
        switch (pe_size) {
        case PE_SIZE_PTE:
-               fault_size = PAGE_SIZE;
                rc = __dev_dax_pte_fault(dev_dax, vmf, &pfn);
                break;
        case PE_SIZE_PMD:
-               fault_size = PMD_SIZE;
                rc = __dev_dax_pmd_fault(dev_dax, vmf, &pfn);
                break;
        case PE_SIZE_PUD:
-               fault_size = PUD_SIZE;
                rc = __dev_dax_pud_fault(dev_dax, vmf, &pfn);
                break;
        default:
                rc = VM_FAULT_SIGBUS;
        }
