Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F352C7B
	for <nvdimm@lists.linux.dev>; Thu, 24 Feb 2022 16:49:21 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OFN3cW000960;
	Thu, 24 Feb 2022 16:49:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=xr6v7F6v6XZSjpO+ZeIOINh9Kwpbfb7A7o2V0jj3Qm4=;
 b=DmaB9FNZL6rr9Kto2NbMo9uWDTLccVTxYzuqU6r2F2UfMUeVGwTChqiuNer05ntae1Rz
 OoTCA2nK4tsYtgtFkJpAwVnpkRsYgB1bcMZYUkMwLhP6yl0lVDWJh+OYUHDF1KzrdSbA
 +5Yvz2kceabIaV2VIUFYPCs65QYtfnloE/zjN/HA70jK1OshECKAeh8d9BqelrMrSp7f
 QVEJJFGg7B6rBINxXO/Xtz6sYQXIOla1T6q9MyOywrBSf9cU7kNdCQMnfO5T7rs2p9/D
 yYYUA5dqq6VXH31L4/7mn8DiMpFAqnbNu8Opymd4NobjiDxBWEN7o9s8uz5dA9XsKKTO PQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ect7aqyav-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Feb 2022 16:49:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OGUYAt159609;
	Thu, 24 Feb 2022 16:49:12 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
	by aserp3020.oracle.com with ESMTP id 3eb483udr0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Feb 2022 16:49:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i6SuE1QDZhJ1wkyxEZkSgy5tyKHWesUPkIOjZRejT3GoEAaqKviTqo8vaJESWiILU5ovb4Hg1V/5vK7gboFg5b2/yIBMLrQg9cL918/hnkgAYkS8YoQ24S7qjcGyTuYuOQlaZCbDOvrJLpc38g8ZHML1kkHdIrAhXTyMOTQ+fxh1506oKBMh5aHlKaW69RM1BP56ml7BK6ipC/bp0nHaVSLNqFVei+CiUx4JP/WXQkRmCHgqFAgfTsVLmmFR+37o+OBAs5sXugEXiOTr4X1I+akOu+Wg5oR35XwOa2O0FfouJJWvRzeFwXYoKCSYBJVAExXz6Zsp3xwVyCDs78BR6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xr6v7F6v6XZSjpO+ZeIOINh9Kwpbfb7A7o2V0jj3Qm4=;
 b=HtE/F6mx81Eo4nSk5fCPxdn8ythDE6gxBmOl653DlW8fMm5n18cMt6h/Ih4q968PuVRVsoRkiWn/C+jQ5lfQuaTSiMlIWQzHWuUgqdES3nmhcEg7TGqiEYYrg0dAXrVhPlF+Hz6wupviioym+NMRQtiYmvdb1JjW9TONewCFfJUcZ1CG7BkZajL1lK/6O36qNMwpci8ueSh9cbN+nu/pR+vuogPqBYDIzedzHMVXeU56WXZrhmbWsv33w+S0zEPKXcmO+Mclglp8pYs05LBA3on2E61iDdGJUlxm1bpWrbTMvF8J/KfxrehLQzovVE2kxk90ukumTnYeDZ2DtaffOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xr6v7F6v6XZSjpO+ZeIOINh9Kwpbfb7A7o2V0jj3Qm4=;
 b=Z02f+ABUGKJGlaCNm1i934u+TkijvS9WbBJHcJJM7AxwEWS6xBAWKFk6G/U/ei6KvL3srRlp/BCK6+PKjoUFgCTwmGGmtCGWbReRTdq9TKACVVA13ijbg2lSbpOLRhUg68I9raXlru01VDF6OR23s9xNE5ZlEs7wA15sm5NW/s0=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM5PR10MB1659.namprd10.prod.outlook.com (2603:10b6:4:8::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.24; Thu, 24 Feb 2022 16:49:10 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%6]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 16:49:10 +0000
Message-ID: <4ac9b3cd-0158-19e5-2667-b6758cc8badd@oracle.com>
Date: Thu, 24 Feb 2022 16:49:02 +0000
Subject: Re: [PATCH v6 5/5] mm/page_alloc: reuse tail struct pages for
 compound devmaps
Content-Language: en-US
To: Muchun Song <songmuchun@bytedance.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Matthew Wilcox
 <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jane Chu <jane.chu@oracle.com>, Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <20220223194807.12070-1-joao.m.martins@oracle.com>
 <20220223194807.12070-6-joao.m.martins@oracle.com>
 <CAMZfGtVCXDeF=3=0n83Bx_20MHOqWsRoJAtZeE53WMr3FA+j7w@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <CAMZfGtVCXDeF=3=0n83Bx_20MHOqWsRoJAtZeE53WMr3FA+j7w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0452.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::7) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6064879e-a2bb-4beb-ef24-08d9f7b5948a
X-MS-TrafficTypeDiagnostic: DM5PR10MB1659:EE_
X-Microsoft-Antispam-PRVS: 
	<DM5PR10MB1659E770323E9BE8AE1BEC50BB3D9@DM5PR10MB1659.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	qsk7+iiyZCWJxxvbXvt3hAzW+W8/2M7rPH9LG/5zAe7hf7mG8zuO2pZ+MUIOzeYTm1h8bkgwqwu7DZ9LJwZxUAlJhUES7LO6OsqCKn8DI7OiMRjrNOvigGHbJcx1xwjg1BS4f+8GQ31sYM2MOm1amIJFCpt6fP6fHRIxrZwfu9iN4/1JRdtkJ8NwAMkv+7MQMWK93bfX8zN6A4ggxYw4fMF7jslBUFbCzZYetjk73vjj3tLl7GA6xMB1aPV7APsA6pLzb1OT/OTl/Ntf0nOYthws0iTdSbLU0YZVW9BnVTu1sOdx2mbupYIHW659Wi5DyaEzY3wyqMHvhAzCAri8sgw3zHA7vXMlRokWHmH6HeR8CIgqIp4Cgni8DJjznP9e85KBipfyVLEzxpchfrY+ZehCOWwLT6IANUAdiogLCVGE96zzIM6uKW6dQL2qp+1/SAYnxjPAE260bRoOHJ0Z9KlsbaRx8CECocu7AfxHnra034IjFSadXTGZc2YwfOx30YzphY6KyoNPmLYgRfXvUuTB2fv2bmGOIl0zGKAYHQvNfWNOyzQ/uelCus/CggPFmSEtZb7grAa2b6ZxBEgAuQuLGnSTEktfy/e5iczJ9JyX9IcsJpRPJqGWEkr9d0lDNhDpQ290gRFpmnB7PF607UvVSDAkcB+yDPS7YULatEuVpX67nD/ZVEVxLNuVxMlTIYpFrq1vSDgrfKJs1/sjvw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(66946007)(8676002)(66556008)(66476007)(6506007)(53546011)(6666004)(186003)(26005)(83380400001)(2616005)(6512007)(7416002)(4744005)(8936002)(31696002)(5660300002)(2906002)(86362001)(38100700002)(36756003)(6916009)(316002)(54906003)(31686004)(6486002)(508600001)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MHltMWMzenN4TitCOWk4MnRSRXh2MVhxVU1yYWppeEppTG5mcmJ4bHEyaVhK?=
 =?utf-8?B?RGRiK3ZtWXoyU09DSy9GcmQxZ2RZblY1U2RZUXMyU2E3dWc5T0pGVXlzVXFm?=
 =?utf-8?B?UGlZams0OVoyRSt0L3MvRkpiWEpEMHVzZkZ6U3dRV2x3bVV0NUd6eTJrbmZH?=
 =?utf-8?B?THVaanNsbVpUYTlsUVFzUFhqQVY5NlJwWnBEN3BEVUVtMFNja1hBdDRNYXNU?=
 =?utf-8?B?Z3pab1hJbnBLaGVoUXgveDN5NmErWlZqbHV6ZU50eGVvdExTRXdYQmJXUUhT?=
 =?utf-8?B?aFpuRWxhbVFoSXhFdjh1UDJOVTducXJwZU9taENtQkkwVE5Pdlk2SEswR25v?=
 =?utf-8?B?ZEVMNThDUUZjVEtLUjdlUnA4MU9yb0Nac1pNOHhaMHdpZVpHZUExQ1pUOTZY?=
 =?utf-8?B?ZkJGeDNYdm00akdNczdNMnMyZ3RnN0xhalhGUkZKVkt0L2NzU0NjZWdwNTZI?=
 =?utf-8?B?VXBvd2tHTGJkSEhYTEhOUnJucUFtbFBmM092eHEyNnV1R0V6S1dDTmFza0J2?=
 =?utf-8?B?ZTh0MFFSei9JK1NvQ0R4K3p6QVloNVczSXk3ZEg4VEtaMWc0eVFETVdzaU5i?=
 =?utf-8?B?bzBVUE5zZWl4cWRCNGtqam01L2dyZmgwVUlmMm5kYnZpbHM0ejhCSDVyQXRX?=
 =?utf-8?B?SW85MEozTEpoVm1ONWxqbkkxaWFsUjNyTk15TjNiNitQbHFXZy9wTkltaWNv?=
 =?utf-8?B?VDZlS1lNcUh2d0wraUJVS3ZSVmFOVWZMc3IyV1VuNTN0Ui9tZWU3a0Nnbk1J?=
 =?utf-8?B?TnBncmZVZC9IZFpXQjRJQVlnb01MK214VW1URFVMV0VXeno0TG9wbmNzOEkw?=
 =?utf-8?B?NFF1SmJrVDRGQW5qWHhFRzgveDhJam9KbDlHNzhBRWhiaDlCc1pISUNYOXBj?=
 =?utf-8?B?bUxHN1AwUjRtVW5YUUZhWTg4RW90Y0tCZ3YwMk9xem1qRUd3VEE5a0JPVk9l?=
 =?utf-8?B?eVlKb1Z2VWFqUUowc3dKSVd5Wm8rTXgrUnF4MlNvbG83TDVNMEU2WjNvVFZZ?=
 =?utf-8?B?ZU9yQTAyMVBWSzhzTXMyMHBTWHdzTWZQMzVsU2gycEhqQytmL2prcGlHOHRt?=
 =?utf-8?B?RVdFYVNYT05mZEdQdk00R3NicnZ6bStrdWJpNUg5TnhmYllFbDFmSUYxNXhl?=
 =?utf-8?B?NXdXak9TZm50OHRYdjI1RXB2cURsYUJkaGN5NTJ5NDVDNGhOYVY1VVNtcXE3?=
 =?utf-8?B?MlVrb1JKZE53WU5xWmtjenBLamxMaGpKS05SNzRkSzNVaTMycGNrVGozTzVZ?=
 =?utf-8?B?M2s4Q2RNeCtOWkR6YkYxcitJemMwQjNXZFc1cnZRUW56M25rQjg5Y3ZoeSsx?=
 =?utf-8?B?NmNuMU1XU0hyTHNITENWUCtaN0FaZGJqMmxjQUdzUEd1am0xOHJobnEzaE1s?=
 =?utf-8?B?SE5NMU53ZEI0STlCWnowOTdLVVJyUE40aWpNOXdhMkVMbmMrSGFoekUvaERO?=
 =?utf-8?B?eHBUMjFXc2pwR1hoZS9iU3NvSkRUQkVvNkJVeXZ2WFNUUXV3TFVVR1hhc2J2?=
 =?utf-8?B?RjZlNFVHWEF2MDQxVFZVZDJ5ZS9hNHhGK2hTQVlHYm5nTVBNaW0xQnhQb0Iy?=
 =?utf-8?B?aGpNNHNJQmppb2JuVW5FOUlHamRXcEpmVWtXZTBGUFdyODlmNDJsVmhKMnpl?=
 =?utf-8?B?TnF1UDFiVW5rR3BpMlc0RGF2aVlhTkVlcUNQcGcvbXc3dW9EV2hES1VDMVd2?=
 =?utf-8?B?ZmN1U2pCaitzdUpzTjlQQWQ1TXcxeW1NWGJsRkl1bUljK0wvK1Bjam5tSG5v?=
 =?utf-8?B?b21URUcvSG5pRDFJVjJaamVsZDkxN2krekZ3K3lWTG4rczZqdFdhZkgvYVd4?=
 =?utf-8?B?UWt5TXhRZmVpaDNJOCsrZFNVdklIZHJFUkN2QTlmdWUyUjJNNk0vYUNUdC9q?=
 =?utf-8?B?UXhCOTkyUVFDNDkvNUdTWnR2eDk5VGhRT1hEY2J5dUlMSjVCb05oaDdQa1Iy?=
 =?utf-8?B?Q3RTUzh5amo2b3FNc0pxcFRaazk0dTRpVndGQXpSN1k1OGV5dDJnUzQ2Wndl?=
 =?utf-8?B?Q085STU5Vlk1QnlmSEJLdTZyZWY1eGRHbXNPREhyMTlNK1ZrR1dRM09RWHhr?=
 =?utf-8?B?M1NJVVo2MzNTYVg0ZWhwalBCRXRaREpHaGJsdDdjNkZJTkd5VEtub2kvNHVo?=
 =?utf-8?B?ck9kQ2h3MGkzdkpiKzJqQklJaWdJbE82ZHRwblp1Szg3Z2lzWWdpYklaMXlZ?=
 =?utf-8?B?b1ptME1UaWl2L2NHTThyZ1FOcGh0V0szK2o3bXFUOEcrbUtEZmhlODV0ZkNi?=
 =?utf-8?Q?M0QKubd9TjXnU7TR6MK35JLnJOgTu4M5akK3aTHhQM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6064879e-a2bb-4beb-ef24-08d9f7b5948a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 16:49:10.6034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fWwur8X2oqeoz7ldyZxy/AZ6n/eQXhRwhgXnx3/9veU9Gsw+oVh8R/7mitkKuA8rciUruOjtEgNNhaOQuPirMcIjjYwELmDAeuCXpIXnLYg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1659
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10268 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240096
X-Proofpoint-GUID: XbGeHLsbMlmwuLwkvwt5biqHu25wOJVw
X-Proofpoint-ORIG-GUID: XbGeHLsbMlmwuLwkvwt5biqHu25wOJVw

On 2/24/22 15:41, Muchun Song wrote:
> On Thu, Feb 24, 2022 at 3:48 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> Currently memmap_init_zone_device() ends up initializing 32768 pages
>> when it only needs to initialize 128 given tail page reuse. That
>> number is worse with 1GB compound pages, 262144 instead of 128. Update
>> memmap_init_zone_device() to skip redundant initialization, detailed
>> below.
>>
>> When a pgmap @vmemmap_shift is set, all pages are mapped at a given
>> huge page alignment and use compound pages to describe them as opposed
>> to a struct per 4K.
>>
>> With @vmemmap_shift > 0 and when struct pages are stored in ram
>> (!altmap) most tail pages are reused. Consequently, the amount of
>> unique struct pages is a lot smaller that the total amount of struct
> 
> s/that/than/g

Fixed as well.
