Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B51A4D
	for <nvdimm@lists.linux.dev>; Fri,  4 Mar 2022 12:22:12 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 224AGbG3028284;
	Fri, 4 Mar 2022 12:21:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=sWb/8yd5UqCwtoc5H7TAGxUIwmkpgpr1u0yyz2x9Kkk=;
 b=DsBkQknJp0FYT0kTHb+5kLQDkDzQTJO1bVNbGBHDJVDitpgcdwpUBq5j3/9UcGRYaTWC
 TfoOMlCNHBpptJb8nlagbgSU8zEmM6n+LPsymr6GQLqUpEUNoRbm7PoVun4uUuehQaM2
 O40u4bmAfVa5RoISnMGA3/Lk+P0cWhOuijpUutY9f6QYNdQOIle4gw3A93jYw8kaTa2X
 JGW6AItLZu5DfqHfi6f7NNcMUjkmlGCurtC/NfC+LVD9IWxMa5pVhK0waM5zCv8kMgbX
 RHGryCLzSLdYTt29pVZDSMottQpEWCwYS2oaXAjRLuzmcJJDxstIcIbm0itrouo9JHIU tA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ek4hw1n1j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Mar 2022 12:21:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 224CG8E7112341;
	Fri, 4 Mar 2022 12:21:53 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2168.outbound.protection.outlook.com [104.47.73.168])
	by userp3030.oracle.com with ESMTP id 3ek4ju8bjs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Mar 2022 12:21:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ifZaifjnf/nJNX3Idlcp3GHXIzKO5GbN/GKQiyqb1k/iZQcDcBvMdeS4dSjdDlncc6vZLNKQMQbD4w3T/TNonQ2I+28JRhh9GtR0WsdddtRH44StpYJBgaLkEOdvn1P86p746d09brsBb+EKYhZx+X1QWEQyPMEYgtiaESyzqPtO1Yqi/uEK7P411WVG/SfYBdrOq4kx+V8pkRxCILEpebXavTOvPnDS229o11M45pcLVDV7e/Vm/kAML2pthFCKD0PoPS6DRZ5nUICGETekAms6gJh6Xc20JTCiFzfkI5F9J/b00gWHjsj7pQ6vRP5Z/qyj8/XM249Lq+VEGwxRJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sWb/8yd5UqCwtoc5H7TAGxUIwmkpgpr1u0yyz2x9Kkk=;
 b=miXEjTG8XWoey+Zsne85fDBC7+jv3h75FODFnv8eYDDn9vaMIbEpIdEUQg+ZMIL71JH1nGTstufJFV/NE24WiAVD/suoqwuJP0hYBm5Fo5v5bUpMt/F6+duSYIIRKmO9zXdCiMdFgbWQQGIDCZSffCmEDf93ItXsV574UgsXcbzO1dkFNs68dPX9uIeETK621RR03Oq7lvhjejcf9amSUjXvNqg/jNA66d5wmOsalFsqSiGQUj56MVQtZF1kGC/GyAQ0nWkXrzofqMe7uVbHHN1c4su0YHuNxX8DTZbLArx+b554lhchLK/k/4dlocVXvLyDMlI9ary4OJiSvjZEGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWb/8yd5UqCwtoc5H7TAGxUIwmkpgpr1u0yyz2x9Kkk=;
 b=xbzDVAz/4Aua/vX/POMGcVLj6cAWvrb19SRKqwwIYaDK4+7L1VeuQ3n0YgRUomtLLfDxiFjtYxbHAswKESQzf0z9Cu8CZcM0LRnk5mObm2KXJizbvlx2VkdYfXsiPCk3438Xvb6HiqfKDFxohYQ+VrxSb74+vGbS2ypsEtGaBFY=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN6PR1001MB2370.namprd10.prod.outlook.com (2603:10b6:405:31::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 4 Mar
 2022 12:21:50 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%5]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 12:21:50 +0000
Message-ID: <4e51d2b2-b2fb-4b69-afee-9f7102822240@oracle.com>
Date: Fri, 4 Mar 2022 12:21:42 +0000
Subject: Re: [PATCH v7 4/5] mm/sparse-vmemmap: improve memory savings for
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
References: <20220303213252.28593-1-joao.m.martins@oracle.com>
 <20220303213252.28593-5-joao.m.martins@oracle.com>
 <CAMZfGtWmRfSzN+U-jxVXu6x3nRxHB2Wxse5y5835ezGzSqAQpA@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <CAMZfGtWmRfSzN+U-jxVXu6x3nRxHB2Wxse5y5835ezGzSqAQpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0027.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::15)
 To BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d2f4319-7793-4b80-8476-08d9fdd98f25
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2370:EE_
X-Microsoft-Antispam-PRVS: 
	<BN6PR1001MB23706EC0A3C7C097E0162500BB059@BN6PR1001MB2370.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	vpyX/lGsaPWEKgIy3eid9u5v66eD6sQNUTHtF9y62Igj/3TUBuw5gGioF+pm5vZlIgrobFRHP27Ka0t01hH6YAUDuH1WwH1QZC05ce7lKO/fllFpAtRO2633Afjv7JGL1nT8iTWQu57BVzAvI9YPwsXLFFNpPEcwC12NaSygijC5p6N6qLuIXp35rcj0yGpUo+KR4M14eTOItZUzS0nb3Sak+amW2HEjVLM8rVQfDNzFPsgV9S/yHUOBQqpnNT2sHGOfNRbhwDRCFhnH3agtkrYlMhN4Xag1IqwjKpYkKGeyss9bgYaolIqPEv9zLbzYtVj6fNG+pwKkoVTT4oWRKR5819p29YbwAC1FTAGE3NbC6ouZf3qv+pYZoLppcFOPrc/Qf1vtCZHxy7qL9nQ6tSNPd6TipKaC0/n3rUmd0DtoIN9KoX32DCx/c7i1leOxEnTLVdhoCaKmoimmBm1Wjxmw6rMSjca+pbT8CzMz/iXx0MBEwFsqENCC7fsdQG1+JtsGtqbSn8uaVsWOIrr1CY2iaSPTc8PMA8ZNj8OQJEoOJ6yNTrek6O1ePN2YcdxFkZKbroYOC2E+cRYpDcgC1ZX7QL60kL4X8aytYQpOk6D0hD/+lOf1lMhpyItUX/7t9VMzmJGMyXm3xMLORC3vbXtssQbLTw20oUvYUE/W2Ud2Ipp3eCzr+Om6swG0AWEl2Az/IJUjh091bIIL8DwSxJGj4Oz1UrnMyXskP3GIaP4=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(31686004)(66946007)(6666004)(66556008)(5660300002)(66476007)(7416002)(31696002)(316002)(6916009)(36756003)(38100700002)(53546011)(6512007)(6506007)(2616005)(8936002)(86362001)(26005)(83380400001)(186003)(8676002)(508600001)(2906002)(4326008)(6486002)(25903002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?UmJtTUwyRFRnamhlYzFpa2FWWCtmd2RmOHlWMndxV04vYmdJdEFXbUY0bERY?=
 =?utf-8?B?Q2dmc0V0cm5TdWFHVU5RenBSbFhoc1NvNHFqTEJSR2NSZGdjRVA4MFJPOSts?=
 =?utf-8?B?N3ZBQXVRdXFjT1hCZC9jekZpZ095NlFIbmkwd1RpY250dXl6TXBsVmkrZkhr?=
 =?utf-8?B?TFFlaGxaaDBsWWlLTkNUUk5YZGFaeVFCTjl3cWNLdFZpdGhEQzhrZU1xYjVE?=
 =?utf-8?B?cmRmaS9TNm52Vi8ycEhTdWdtaldVcGRZdWZTbVNrUFJhaENiQVRTYUhBVHBV?=
 =?utf-8?B?Zis4Qm5ONXZYVTJIZ0dHcjVIMHBDMlhjQWhjU2t5Q1BWZDkvZUpOTGtYM3ZC?=
 =?utf-8?B?ZGNRK3N2R1JaWU53ZlFycTBaQW1lWDA4bUJaRmlndWtyRjY4QzNHZVFCaDI5?=
 =?utf-8?B?WlVVbWQvSlFKZ0xNUDlTSW5ZbytaV1VRZ0dLTVpPR0lRQTNJZTVkVWt6MkNr?=
 =?utf-8?B?UUhmc29KZzZKSURLZW9vUndWbUV2Q3hLRzg0Zms5WTJvZGU3TU5zNm5iZnNt?=
 =?utf-8?B?S0IrZTFIOXh3Zko5TjNyS2RTcjdvTHlYMUtkUnJVWHAyczRnRDR2Vi9HYU12?=
 =?utf-8?B?eVhLOVdWWlQ0b2lqZlo0L3Rha0YzQlNvZXZoWmJXYzk1NkUwTE1BbDE4Ujc1?=
 =?utf-8?B?NTIva0trdHpUbmtyNWdLZDVXdFZkaXFUUDAvc1dDUG9CYXZocVN0NXM4aU9w?=
 =?utf-8?B?WkYySlhKeDhITVpYSW50QUdJanBPa29iTFFWOG5iUUFxTzVCNWltYkdhcTN0?=
 =?utf-8?B?R05reXVxblNxMlhobDE5bGtYcnNtaFVGcXlNTnNINDBKdHpJS2NYQWF5ZkFJ?=
 =?utf-8?B?c2w4TkZRM3doRmdBdWVjY3BUU1h2QWpOTFNFaFdBeGt1UGE2bDdVc3RONnpj?=
 =?utf-8?B?NmUrV3lDeENVRU1yMGMyVkI5WDNER2JUd3BEek5Yeis1eWxTMzJGdXB6RmVL?=
 =?utf-8?B?cThjS3JYQ1Jja1JvQ0QxWExsQ1ZlNjBNVFRxY0JLYVc1VlRUeWRUZjNVMEw1?=
 =?utf-8?B?cVJGeGltUzBlVXZlU25VbEYyRFJCckR1V09BM1YxaCtkanNHdXdNeEF0MmIr?=
 =?utf-8?B?MjRhWlB5SEh2aU5TUXhTcEV4eHBJU2NjVk1TZjhVU2hzdWRLQVN2em9DSTZw?=
 =?utf-8?B?VDlmVG1nVVBndmRpenBiOURoY0MxZWYwNEpkNzR2L0RJMTQxclhUdFA1RGxi?=
 =?utf-8?B?NG5ibzBheWN5U21NcE9ZMm9OMDAwQ2oxU3IvdlMzQnVBVTlSc1lUcWJqc2Vh?=
 =?utf-8?B?VW1vNE4wZkZqQ25TaTlkQ1QrczlXNEM2a2R2eXllSHliQlNpMVhLMnZaZ3l4?=
 =?utf-8?B?UzRGa3lscThMamxMd0phbGkyQ29VNS9YeUY1VTBqb3VtdllQS1BhTWxIREJi?=
 =?utf-8?B?MmRPUzdiSnFmWHk5QWdJQk1JK0JON21oaExTUmQxTU9hb1dlcGEwSTBkYmY4?=
 =?utf-8?B?K21wVjVvUjBDdnh5UFpyVCtjZVpUS3dBYisvN0dZSk51c1o3U1hRWkUwQjBY?=
 =?utf-8?B?UXJPb3FqUnFDQzVsRFZPeDVkWXZGcGZqNnI3MUM1WmVmcWVIZFUybkVoVkVu?=
 =?utf-8?B?SkNpcm1RdkpYS2VtKyszTzVpZUU5UFMzV0duTUd6R1dBcE9RTFBkaCs5M0I5?=
 =?utf-8?B?NHVWZldRb2VHSEdqVWFodHBZeVIvU1d4V2dYejhmUCtnZFBBdENmWVFDWlFj?=
 =?utf-8?B?WFljakZkR2hReXBNeTFiWkJyalErZi9BdmtDMmtZMDRNZ2RqZzE0anZHS3B3?=
 =?utf-8?B?NXIrSmJSNHdvaGpZTmk1TFZXOWJna05xS3B4a0RhQWR2NzRpMkxub0tYNWdE?=
 =?utf-8?B?UklJWUxwZHB1ekdKcC90bCtVM2pBWVlxUjZkeWVtRFg1a2VFaXE1VjZKSkdM?=
 =?utf-8?B?dkpoTkdFamRYREVGSzhMc3dPUEhZdDlERWlTdjB5a281WmV0SVhDZnhvemt3?=
 =?utf-8?B?aG9aYk1oWCtmSk1Bbmo2SmxQbmRzR3BGTitUclhXZktpTk5ySnZaYTBiUnM1?=
 =?utf-8?B?MStBejdsRGxjbW0yVVFiOXVDY0RxMHNuNEJRR3lVOVBSTjIzajlJMWUxK0xh?=
 =?utf-8?B?Y3R1WE1PNnV3T0FkSEUrTUhGRlh3Z2VYNjNIaHZpYVprOStpZ1B5cjZ0cjh5?=
 =?utf-8?B?WmRPdTZRaUFLRFhvMWxvY0YxeDdrMVl4TXpzR1gwL012dWJOTUlRQVJIMVk3?=
 =?utf-8?B?Z01iMFhrNDRyWFRxdlNjNnA0dVZRMjFTaVdnNXlKa2RzOUk1ZmJrY0tWSkRN?=
 =?utf-8?Q?egaWPUbo76NnDS1x0poKb2eFnoFDTJgz7Yo0vBIxuI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d2f4319-7793-4b80-8476-08d9fdd98f25
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 12:21:50.3779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PZpccZw5SWCTO5bFSyOQCXemNQJrHMxVnhWkN/VF8NTYEQ3RrdXEatr+5znYDHXXwVJ4fp7ZsLgHqIE3bTDChK2ir16vxap1hDH21mBMuUg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2370
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10275 signatures=686983
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203040067
X-Proofpoint-ORIG-GUID: f3BATQrCyI2mwuSq6oKaMhjTbBqRWRfV
X-Proofpoint-GUID: f3BATQrCyI2mwuSq6oKaMhjTbBqRWRfV

On 3/4/22 03:09, Muchun Song wrote:
> On Fri, Mar 4, 2022 at 5:33 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>> A compound devmap is a dev_pagemap with @vmemmap_shift > 0 and it
>> means that pages are mapped at a given huge page alignment and utilize
>> uses compound pages as opposed to order-0 pages.
>>
>> Take advantage of the fact that most tail pages look the same (except
>> the first two) to minimize struct page overhead. Allocate a separate
>> page for the vmemmap area which contains the head page and separate for
>> the next 64 pages. The rest of the subsections then reuse this tail
>> vmemmap page to initialize the rest of the tail pages.
>>
>> Sections are arch-dependent (e.g. on x86 it's 64M, 128M or 512M) and
>> when initializing compound devmap with big enough @vmemmap_shift (e.g.
>> 1G PUD) it may cross multiple sections. The vmemmap code needs to
>> consult @pgmap so that multiple sections that all map the same tail
>> data can refer back to the first copy of that data for a given
>> gigantic page.
>>
>> On compound devmaps with 2M align, this mechanism lets 6 pages be
>> saved out of the 8 necessary PFNs necessary to set the subsection's
>> 512 struct pages being mapped. On a 1G compound devmap it saves
>> 4094 pages.
>>
>> Altmap isn't supported yet, given various restrictions in altmap pfn
>> allocator, thus fallback to the already in use vmemmap_populate().  It
>> is worth noting that altmap for devmap mappings was there to relieve the
>> pressure of inordinate amounts of memmap space to map terabytes of pmem.
>> With compound pages the motivation for altmaps for pmem gets reduced.
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> 
> Reviewed-by: Muchun Song <songmuchun@bytedance.com>

Thank you!
