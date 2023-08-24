Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBAE7F
	for <nvdimm@lists.linux.dev>; Thu, 24 Aug 2023 21:30:43 +0000 (UTC)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OJEYVo027002;
	Thu, 24 Aug 2023 21:30:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=A0JTtVvvMAgmq8HLqOfIcgOvJoTSQQn9eL+/VgQYzE0=;
 b=vRKqLjpc5HoE+PGGMugaXNTrYB1JExrUo+2oHiLrvhhjmk5x3zyUNAChkqXopy28eoQ8
 dIVVPPaJkGPE08rJFhF/sGKB/6EBDhFO1cNjPp9sDeXEFXCQAOWNAUqZNbDZrbIdKVqN
 tgi9brY5tR/gmGey7KeT8pQdoaqbs2KExeT0rYGTPgVu8XgICW8luAvK0iXqMaW4xwaW
 s9CXJilK2PxmFFCkEky+wquNShZPK8o/SSANOB9KRq1/r1zN0iIAqFL5a4K+uU6mWyYJ
 x9rB5hvKi8wBFng0Pfb31//Ea5W/4cknIzMCyTeXeh5UHVcRb+FOs29pCdV4FtSmcvWU Ew== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sn20dd4nj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Aug 2023 21:30:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37OK5rqI036104;
	Thu, 24 Aug 2023 21:30:27 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sn1ywh7wu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Aug 2023 21:30:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MvC11/W1046O7c0okPB1O4tvb007q+RTkezjCWI3onD7Na6YJy3jsMQmZE2TpcTOMrOhvklHHMb0tOU0EDlosMr2SnzobeIQCLonx7VTkxIT7BS0dO4dodiXgbWAaiZ+oPo4X89wdQzKyXtwFBA7uiynv8bk9VxMCqc7wMaiDCi4toFs+XqyHYK5pajqZxSkDEr3+0PgFoLlRTBgeYhF5j5c17/YEiA8S2bNme1/0UZknvVv5jLPq5xmdxs41rU3xu4s0QehToGZFwtBSJVTQFwSL0RrZkQrg9PlDjkIJYv2/Ap3E6P6vDmbsV7FMEmyVHUMwuHE8w7B1iYm+y3X1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A0JTtVvvMAgmq8HLqOfIcgOvJoTSQQn9eL+/VgQYzE0=;
 b=WhFCGVMfVS3PSE9WDfpjyF1Ed+/YnfFI4oZSdb4VJkVKindbXF8nLEEaVXf1CsKUG8/MMlQRECqw2a1/IEmDxKNNex9XTtZLjGFfIdMoGwE0NYYMCSawYlJG9s3euSP/WXFBvOsun277aDaPHO9ILDerip7o4E0pwy4GZoYQKp0t7HLEH/ivBO2N0bbZa4k3o2dHdPuHKbC8ejjqQrxQvSLslh1eFWOupdoCG7zZir8Ntd3XkTWZ1NEOHnS7MuT88iYuS+oKn+GEdulBr5FAquNxw0y+9Mqky/8099wwqnTQKIWw72l8zh++3aETOEftpUqbmyM6DpleMgR4KLQcEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0JTtVvvMAgmq8HLqOfIcgOvJoTSQQn9eL+/VgQYzE0=;
 b=XgrOZsQc/KSD3RcCV1IS0TDWPm2VoGdLm7MaZZKvCe1bUWr4fuwVvlHJfWOPgWFnCNjPsx8v/RLXfdKzk6jUMS99SccOMtSAtclfo/y0uhwNTpUw4qQFY0J8TUvHGoOZh00VBDlI9vEPU2x4eFoyPaSeTRr14Ng+rbeEgNaR9aA=
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by IA0PR10MB6819.namprd10.prod.outlook.com (2603:10b6:208:438::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Thu, 24 Aug
 2023 21:30:24 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::df9b:4211:cbe:cfc9]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::df9b:4211:cbe:cfc9%6]) with mapi id 15.20.6699.020; Thu, 24 Aug 2023
 21:30:24 +0000
Message-ID: <b2b0fce8-b7f8-420e-0945-ab9581b23d9a@oracle.com>
Date: Thu, 24 Aug 2023 14:30:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] mm: Convert DAX lock/unlock page to lock/unlock folio
Content-Language: en-US
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev,
        Dan Williams <dan.j.williams@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>, linux-mm@kvack.org
References: <20230822231314.349200-1-willy@infradead.org>
 <df52b1f7-7645-b9cd-4cea-d3e08897c297@oracle.com>
 <ZOeq4HJwCULHPtaU@casper.infradead.org>
From: Jane Chu <jane.chu@oracle.com>
In-Reply-To: <ZOeq4HJwCULHPtaU@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0036.prod.exchangelabs.com (2603:10b6:a02:80::49)
 To SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4429:EE_|IA0PR10MB6819:EE_
X-MS-Office365-Filtering-Correlation-Id: a3e1580f-1297-476c-1a26-08dba4e953ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	zjiihVP2NYm5KCJ/5pLXWo8NhCLNmHDvZYQLj1Ix1MDphqz7jhdjbilYY7rR2wefa5/I7NEhPFajw9lmFTwS4QnnIpcZ+RST+lQUAiixPqPXNrBlJPaDXaxlEoxKfcspcU6LxfUHADgqYFKSqzyTicse0w8ET/cvJGtF5o+28XEl7VxrI5o6AbJs4+hRwWOUO9ACVuS4Tw2jjBbd0ap+t226Th+KT7skjhtQY6/cLJYifJLACoO6Uh877i1aI/wrcFIZ3TFrsoML20CfkLqhuG7lh9uKT/Lc9x+UvB396iVCLgu6cI6gbkiIdOCmdtJEybAtF2cG+d9kleeHP6HjVUF2VfosWWz5DOdtHFPPD5lvu9JuVZkhU1dgngCpAdQP/xSYy0KRzbno57qVT65TM3kZUB8Lf133zkTEd4zI+BC5JqAzFQcwXhmquhFvqnjeCQ91TbBRW1kNI+X5eW6+IyGCgk5s/OPZF1jDDt0SNmZINpsLGKT/ErrwR5bxkMDy+05e0+zbqcRo/aAz8YvtexBbMbaF8/0MkUnHGyuuovjn8Smt1quqNWc5Czd4XTFwtY1Ti6+2ElmEXVJRg6JTr1kW+UIBFmxs91QBUTsH4ZAFIpMFK5vQf/oWOqVP39kz3Ah8Vgr7bTTM3VfI6xsK6A==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(136003)(39860400002)(366004)(186009)(451199024)(1800799009)(6512007)(26005)(83380400001)(53546011)(2616005)(41300700001)(66946007)(66476007)(66556008)(54906003)(2906002)(6916009)(316002)(5660300002)(44832011)(4326008)(8936002)(8676002)(478600001)(6486002)(6666004)(6506007)(31696002)(86362001)(38100700002)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?WjQ5Vm8waUlCUWV0L2t1VmRkNlllMWtFaGF1RFR5aFBaemorMUp3elIrbnhC?=
 =?utf-8?B?UDR6OHpndWlhellsZHdpYmF2ZngwQXN2T0xwMDQvKzlyY0ZCVldtSmRkUUxW?=
 =?utf-8?B?ZHdTNmNyUU1mNWoyWTRGWi9KN2c2RW4zSTBhK0xoQzhUdjVYTitROEdoZE5B?=
 =?utf-8?B?NGFuRmJNdTVPQ3gwQ1ByanFibGFKeUl3MG5jcURRemFLa2VUbGNBTk9lbGpM?=
 =?utf-8?B?OFc2bDJlVG1IYVFHdVNGeW1OajFEbkRFWUpQY1NsRUptaVlLamxJYmQ5cU1j?=
 =?utf-8?B?TmIyV1RGdkUrZmI2R2NPMGdmS0c2cU1MbUxmRWRTcDBuRU1TN3BHNXJNM3FX?=
 =?utf-8?B?aHNLbzVhMTc2amcrbU9tNkxKMmU4VHRpTXdPWjhTc1pXaWFORnQ1bFdXQTJR?=
 =?utf-8?B?ckZWcFJlTmVYWHllWjJJeVUxL1BNMFlCQmU3eDltek5mL2ZCMVVXN1hJUEFF?=
 =?utf-8?B?Y1F2UENqMWFheFRyUmZtWDNSdEZka003bVlMeFlXYXdzS2tmcTJmNGF3QTlY?=
 =?utf-8?B?OEZxbFYwYTJBUzVuaDFoVVRnbGlQSE41NU9iU2hPYkFjQVZmcjhwWjArVk1a?=
 =?utf-8?B?RitPV1NTT0FzbGl2M0xwTWlidEk1dWliTThRbzJpNHVjS1V3TmZiVWlhTE5P?=
 =?utf-8?B?NWZSdmVTRTlRK1J3NTU4bzR6S2NTaUQrejVINGRoQWN5VzBFR3g4UllKSTdn?=
 =?utf-8?B?bnRWSmpPWEZFWFp3NTVjZ0pUa0ttZlZncGk2c3NrbGtiTTVYUXIrU0JONEVU?=
 =?utf-8?B?OTZ3TDNpSzE1WTUrYnRNNE1MVW5FS0lkeHJaZFovVEs3NzBhWW0zQ1lLdEpp?=
 =?utf-8?B?ekxzRDRyS1FFYmRpV0VoOVBxWUFCVFVwRTVpNWdTTlVBbkY5VzBKOXZoMmZk?=
 =?utf-8?B?ekxXM2syTUpWZWpJZk4yN1BQSFJubmttVVZwY2EzeUw5NGdVNVFTZk5jYVZa?=
 =?utf-8?B?Mm41Y294Njl1M3lUVWdvZDAzeGlIdDFtcTdrdVNCNFBkOGJOY0lrS0FsTVlY?=
 =?utf-8?B?TjIzS1J6eDhUUWtJM1dObTZzQzYrMjFkMlp5NVVpb2txYktTRHAzWW42dG4v?=
 =?utf-8?B?djZiMTk2QW90N0ZpazdZSVh3T3B5Z0h5anVCQW0rR1BUVXZUV0VVajE0dTBP?=
 =?utf-8?B?TktFWG1pWXI0QXg4aWV3dzJ2R1lxZDRPYWcyYStabWx5WDFLbTFWUEgzRENV?=
 =?utf-8?B?Sk1xNkQ5QUpORjAwSjdWdW55dlNweUxRYjFRSUtvN29Od0V2ZVpEQ3FZRFAy?=
 =?utf-8?B?cUVWUWUyZUVzUGV6cmtRTVVjVUZRUS9PRHVIL2dCSy9RSjJhQnZEUW11VGc3?=
 =?utf-8?B?UHlJa2FmeDB5OXM2QklFQmVCa0g1TzRBYXhQVW1TZnYrVjkzN2pWSmpBYlpa?=
 =?utf-8?B?RFMwS1R6b0F0a2YrdTZ6TWwvVzZkSyszSGhOTHB2UFd3VWtkU3ZRVFQxVGRW?=
 =?utf-8?B?RnJCRnY2U2tqWC9vNzExUEQ5ckF4Y002NjBnbW1tM2dZdUg3NVN6bEZHeTFT?=
 =?utf-8?B?S3NLT2pOM24vcGJEQzV5ZDBzZ2hMT0FUSDU1T3pPdWNKU0NFd2pWMTgzTmZm?=
 =?utf-8?B?eFVoWWRxNm54N2VzNTJ5aFI4UWpKNEwydWlLajcweHFwcnZ4Y3hFQmJnc2tI?=
 =?utf-8?B?bDYzYlFPTGxYeGNvck95VGJzSG45YXBmNmU1M0N0cWQ5amMzaXM2U3k5TGNO?=
 =?utf-8?B?cG8zWUhtYXg2cjVhZWt3ZkoyZGN6ZUkxdlV3TXJXbmF1TVJLQ3pFTFBFSTl3?=
 =?utf-8?B?MDBTV05LcUphV01TWmM1WjQrUTFvWUtWVGtGSlZFb1lKWGRRUzNweG4vaGYw?=
 =?utf-8?B?ZVVSdHBKeUZtdjVyaUxGbjdCSC9NMndJeG82dGswd0hXenowUS9iNUVPS2xq?=
 =?utf-8?B?YVdhVUF5V0tBN0d5QVZQWk9MdjQxVVV3bzVwMkhIKzRzbUQzQnZxdUFFUjE4?=
 =?utf-8?B?RWliR2VHVjhtNUdweHRmZ1hod2JGVThMTEZtb0ZJMk02ZXo3aTRHVUVoc1Az?=
 =?utf-8?B?U1RSbHhiWFlvOGpkR2ZRSTUxTkxraGM4ejVMRGpFQVc1YlN6cWZsV0ZlQUNR?=
 =?utf-8?B?N09iMGtCcmNNNUN5eDlwWXZ2MFZ1b0ZGeTlVYXhnS3lobG9RZkpQK0JmZWp3?=
 =?utf-8?Q?qdey8ba0CX+ikCGMDUDsYkfsa?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	9vPiEpaQKHr90vT/1I+ACApDRa/di0SWfAukGsNMXgTQZzZDrL8Kf97j5wycDTXT33FFZBGA9MaaOHKli/7SIHGM56BBfMsEP/xB8Vg9SGm4Ourm7PzfQtguA9IDPfxn6vU2tBPPDzJGHiENx39u8pdLdf2TAjDUsk927A/rx6lsHmHWXbwpE8x18cRKH+ChSieBicKTsSmfm6tm0WHXieqX364tPS/ZXI3oEIkHAdrgmTVKOtsMlhaKMUai72vZ0jh9ylpQjQb9e8qZuohVjL5wwWkDxu+ErlFq0FdxuApHZzUwi9TjcHr3Jj0ldML0RCfFlmkQu6NklEkdvKX5UnFIZ7CedIPgs2ijQR89XXFJBLha/qedvVBmRGOlLhJnGtc7A+mHce1BDL4YkKRPq1FoS0ZMzgJcSgiPdz6UaWpVVt58d+fqb4EUUAcXc6BbpOe8cxY88eDpnKkc3Owp2i5EEUBuFxAd8ppF0OsFxS9bgyihl0I5NhDMnS5tqA6od2lZszEAlcTQe3X10m9hoIPta6HuZWTtR2V+VQYKTJzGSfkp7NKzBZ0AvJZgrf0p0xUS59JO8QncAPZbzSmtg0QhShVN+3FKc2MLiSIF6ba94nWXul50ZjRyMLFAsx77ZwkD8xHJVmF3/QSAH2hjm6QNqNpgxV98RzwHH8SrfIGCCPp5tIkHBsd4lTHHL1mf16U2t4cNMiMFDqZg6EDMAGSEa8rW09Df+nw6MuPvXjg7B/GwRdJf9+Hhpeg//B+c/xiStss0OWQg6WHFClVDeKx5eLJ0a0SzMJo9n8lKSvgmnklNoE14Wtn6gHDkTDPxu9d2GPV6WuW7ka/m1Z7PdBehUHVaI9Hg0TW66VDBPGeMIJMfmgvBgLdEMTdW8/2pSkQZ8pl2roFSFUauv0OC0O5sRj185u2leI84AuILAJY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3e1580f-1297-476c-1a26-08dba4e953ec
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2023 21:30:24.6982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rgKoTICQym/N50oUk4ONh6fgjKdBTfqTtTFDRgWqSSJo0EI2yPV7fqCoCAZgdIE1AtvgONKoqX4Iv3iiaZTbEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6819
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-24_18,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308240187
X-Proofpoint-GUID: gap7aUPGmodGjd4L8jo2ulM9aajCE5OG
X-Proofpoint-ORIG-GUID: gap7aUPGmodGjd4L8jo2ulM9aajCE5OG

On 8/24/2023 12:09 PM, Matthew Wilcox wrote:
> On Thu, Aug 24, 2023 at 11:24:20AM -0700, Jane Chu wrote:
>>
>> On 8/22/2023 4:13 PM, Matthew Wilcox (Oracle) wrote:
>> [..]
>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>> index a6c3af985554..b81d6eb4e6ff 100644
>>> --- a/mm/memory-failure.c
>>> +++ b/mm/memory-failure.c
>>> @@ -1717,16 +1717,11 @@ static int mf_generic_kill_procs(unsigned long long pfn, int flags,
>>>    		struct dev_pagemap *pgmap)
>>>    {
>>>    	struct page *page = pfn_to_page(pfn);
>>
>> Looks like the above line, that is, the 'page' pointer is no longer needed.
> 
> So ...
> 
> It seems to me that currently handling of hwpoison for DAX memory is
> handled on a per-allocation basis but it should probably be handled
> on a per-page basis eventually?

My recollection is that since the inception of 
memory_failure_dev_pagemap(), dax poison handling is kind of on per-page 
basis in that, the .si_addr points to the subpage vaddr, though the 
.si_lsb indicates the user mapping size.

> 
> If so, we'd want to do something like this ...
> 
> +++ b/mm/memory-failure.c
> @@ -1755,7 +1755,9 @@ static int mf_generic_kill_procs(unsigned long long pfn, int flags,
>           * Use this flag as an indication that the dax page has been
>           * remapped UC to prevent speculative consumption of poison.
>           */
> -       SetPageHWPoison(&folio->page);
> +       SetPageHWPoison(page);
> +       if (folio_test_large(folio))
> +               folio_set_has_hwpoisoned(folio);
> 
>          /*
>           * Unlike System-RAM there is no possibility to swap in a
> @@ -1766,7 +1768,8 @@ static int mf_generic_kill_procs(unsigned long long pfn, int flags,
>          flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
>          collect_procs(&folio->page, &to_kill, true);
> 
> -       unmap_and_kill(&to_kill, pfn, folio->mapping, folio->index, flags);
> +       unmap_and_kill(&to_kill, pfn, folio->mapping,
> +                       folio->index + folio_page_idx(folio, page), flags);
>   unlock:
>          dax_unlock_folio(folio, cookie);
>          return rc;
> 

This change make sense to me.
mf_generic_kill_procs() is the generic version if DAX-FS does not 
register/provide dax_dev->holder_ops->notify_failure. Currently only 
DAX-XFS does the registration and utilizes the specific version: 
mf_dax_kill_procs().

> But this is a change in current behaviour and I didn't want to think
> through the implications of all of this.  Would you like to take on this
> project?  ;-)
> 
Sure, be happy to.

> 
> My vague plan for hwpoison in the memdesc world is that poison is always
> handled on a per-page basis (by means of setting page->memdesc to a
> hwpoison data structure).  If the allocation contains multiple pages,
> then we set a flag somewhere like the current has_hwpoisoned flag.

Could you elaborate on "by means of setting page->memdesc to a hwpoison 
data structure" please?

As for the PG_has_hwpoisoned flag, I see one reference for now -
$ git grep folio_test_has_hwpoisoned
mm/shmem.c:                 folio_test_has_hwpoisoned(folio)))
$ git grep folio_clear_has_hwpoisoned
<none>

A dax thp page is a thp page that is potentially recoverable from 
hwpoison(s). If a dax thp page has multiple hwpoisons, only when the 
last poisoned subpage is recovered, could we call 
folio_clear_has_hwpoisoned() - this implies keeping track of the number 
of poisoned subpages per thp somehow, any thoughts on the best thing to 
do?  hmm, maybe add a field in pgmap? or add a query to the driver to 
return whether there is any hwpoison in a given range?

thanks!
-jane




