Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA5D2C9D
	for <nvdimm@lists.linux.dev>; Fri,  5 Nov 2021 16:15:17 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A5Fvd5I000636;
	Fri, 5 Nov 2021 16:15:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=zJIRgaontw5yKsbj2n5t1FbNwwVDZs2cP1wbOC0XX6s=;
 b=IBUh8kVYavp8pYBomLKH6f8KaAUJxlSPqaRb6AWq50mKfcJ5pm4KFs9IAmk4luVjF8DS
 bCIAEcw9Sm4amJ6wCQ8y/e4qNJEOdlro48lkt4g8P4gxl0PcWK/5od07+C9ZeR3tSozO
 a+kWJg98D8CeLzqSxvFemZ4sRDA60ClldLQsZUem6COxg2U0BrDlKpzXMdpFOQMScPlW
 uWq1OPEyHLW/fM6BVFju+BsdUd2TVLs6qY9uoCBF7sxet61vlzBKqSdRZ715kF60M4su
 sG5C3lx0m1s40kWC4oA2PxfrKDI/Uai4uz2ThGhyMxQ4/HafT/eKrCh0VesSuEqmbE9u qA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c4t7hufys-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Nov 2021 16:15:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A5G643i179587;
	Fri, 5 Nov 2021 16:15:07 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
	by aserp3020.oracle.com with ESMTP id 3c4t5sjyy8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Nov 2021 16:15:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=abprV6Lm6Owh8KY1jPs0KisH8UDkD4PhOFFWimMiKnsn4KR9ThubzECSHmX49uanypHvZwxE+btjbJs+TFUVbwsebp+DYBcdFnJ7y4j1l9YANO9YQZTmYV9+gHFbHfnI4s301vc2oCC8dnx/9fM/Z6g9oXMJM7ppUl6Rd7m1zgBNUxSiK/TXotvbqryVLFFxUanBaFxjbN0wjbPvFEQMRbmb/BEswYDwRnBSBi/i8Vbl4OIDql0vU5EwMhSKNimoYPRoF42Y5cNPiWC6OMMCfNRMJWgHaGB2v9p7J3BZLeG8WS5n0lpttBjzGKvAVK6gYe6TJomnoMiOZLqjm3QHyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zJIRgaontw5yKsbj2n5t1FbNwwVDZs2cP1wbOC0XX6s=;
 b=QqROHDqQh7/+HKamIV9n7jnmj3t+7bAObWk6sSUQhw/o4Su5aXC2979afyjQARkt/klJgtpG1/rF5wq0V1BameAsj3muzJapRWWQafQm/FYlsJRxF7t67106ZASHlyNmKHUZAhn29PWwQWtyQV/7gIi8K/gWA4bEINYljzH2+GWeKm48QUQP6PFjpro69hDCnSwSk6LfLfaML7lHvwlrMb2wJFCrwKksVjh4EnHDspPwX1zZ01UuW+poe/hQdvsJlfXO9r65Ee84/iTrZvqInN2+sXPtD8/BuBJPwsBuJ8HFGhPSGTM6UU/p2GihYLCP/Y7f+VwCLpwncvDqMcl/3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJIRgaontw5yKsbj2n5t1FbNwwVDZs2cP1wbOC0XX6s=;
 b=CRQc7DYLXm/9+dp4rd0BmpYWxS7FrgZksYL7/ytVEtYf9Dfa29xV3aObfXz8r5PjeaQFYCPtxGci7eetyuyeE+QE59ymKkahKSl+439S5j4GCvHcf8P52motb7kIhrLCj3l/KONQcq6wwsPrjBv0T225//JgbmScwKY+QhRX/bo=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3789.namprd10.prod.outlook.com (2603:10b6:208:181::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Fri, 5 Nov
 2021 16:15:04 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 16:15:04 +0000
Message-ID: <26aab723-1d1b-2f10-3844-0e70e67dbbe1@oracle.com>
Date: Fri, 5 Nov 2021 16:14:55 +0000
Subject: Re: [PATCH v4 06/14] device-dax: ensure dev_dax->pgmap is valid for
 dynamic devices
Content-Language: en-US
From: Joao Martins <joao.m.martins@oracle.com>
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
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <20210827145819.16471-1-joao.m.martins@oracle.com>
 <20210827145819.16471-7-joao.m.martins@oracle.com>
 <CAPcyv4hPV9Vur1uvga7S4krQAmKZK5jrBrdOuK1AFHVE8Zk1DA@mail.gmail.com>
 <f33c2037-4bee-3564-75c0-c87f99325c02@oracle.com>
In-Reply-To: <f33c2037-4bee-3564-75c0-c87f99325c02@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0445.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::18) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.160.24] (138.3.204.24) by LO4P123CA0445.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a9::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Fri, 5 Nov 2021 16:15:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97a9a770-7b74-4545-ce8c-08d9a0776cb7
X-MS-TrafficTypeDiagnostic: MN2PR10MB3789:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB3789399DB029C99BF20B93DFBB8E9@MN2PR10MB3789.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	EJ/vyJacaBpXvOg0msSg8EsKWRVDg+gAIptMPxOBH/94dOOSkH2Y5ofig85hU0pEHbJY9FCeknaGi+mOKFJGBs0PHlIWB4a6kTcqBZHK/CEGwAMzhzpLM8qLM3nMmWL/GZNloeTwIey/gJhPjNVfEmXk1qH/Bur30eYVrpEG0P8SnlqTQGv2OKELoP4my/Kz7wWKYd6lN7wtp01XpdkrxVAcEcL7fhEINzhE1fuNsD5CDqu13BJ2oZRQphaqvaWsNq5CgBzCRaTrKgI8U49CLYz8eu6Ld94pwpe0rpXtTtNejVfEzzhGg5x4EYvRZStvensiUBZey7oYbJL2XHOdKjp5cIKnaaTbA3+M8CJHbxG/w48d7ykeMg5bJjlMhoMKdDKW+501unhrllAr+02L121E9FiiR0i+K071nfHbTcs8u5vIu9PcbHehPC4wRUYipYdheSgLsJzlnG2jfsHff1QeHbzRl0LMUsV9/EF12G5Y+1L1ln3VBS12S9v/BlyJ2z03bet++JzwPevuQFU/6AB46L2qu5WIZpAJHJYCUmzcQn2koilRbrRoKeZPiZwUQNaOpsr8z0HWjogzLbQMvEZ18Y8DmFwFkyQNuBQw8OD6iH0DkrMhsnyu9JmLwBnFq5oQPi4jGilIlj8rH1+0SkyJOFxV0UvNqIHuBXUITsz5u28MT9WySHqM6Ux9EqxxMUUPQr/8DsdurTFKOnytZg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(16576012)(6666004)(66946007)(6916009)(316002)(7416002)(38100700002)(54906003)(31686004)(36756003)(4326008)(86362001)(31696002)(53546011)(5660300002)(66556008)(2906002)(508600001)(186003)(8676002)(956004)(6486002)(2616005)(8936002)(83380400001)(26005)(66476007)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MGJwRitzcTVsU09VbTRxYmNwY3dZNUhMS2RlTFVvdUJWL3l3SWsvTERudFRq?=
 =?utf-8?B?UFAwQ0dBVHB6bGp0L1VJeG85bnV5UFZJWUwxVjdPL2hBVDhFREVzRFBWbkNa?=
 =?utf-8?B?cDBjQ2t0QXFPRmtYS3dNQ0o3ZytQVVVYdmdpQ25xUjhkdHNPbGlRWkp3R254?=
 =?utf-8?B?NUxuQThkZm1iS2ZnY1JjbUl0UU0rQ2tUN08wS0RZRmhlTW9CY1lCN1M2b1VW?=
 =?utf-8?B?bXpENXlCYjZjc2FNN0tMcGQvaVVqbFpYcmJnUUJnTEF6T0NFM3N5eEhmdUcz?=
 =?utf-8?B?Vkx1L25UVUxhcGdpMi8rcXA3MlQwZkpFQjB6MjI0Z25tWVhUSXM2L3F1Wnpa?=
 =?utf-8?B?UHJidllKSE1XVEZsK1dqZlVlVXFmYStVR1VJYmd5SnJaaUFRRUgwbjJNUmpi?=
 =?utf-8?B?djJrcXVzUGoxWm1kSEp5VWV1R2tJbWp6YUVnYUVPUGZlYXZFNndyQ2dZQ245?=
 =?utf-8?B?Ukx4Yko5NVpERkZQZDdWbGhwWWxzUGV1V3lkSXVVSmlZYzMvMlNQWFVnc1hH?=
 =?utf-8?B?Umw4RHlkcngySGpSM040RU10a3hVL0ZKT1lMMWVnQ01UWEh6UkFNZERqQXZ4?=
 =?utf-8?B?akhuK0Qyai9vS2V4TVdiTXNUaEZNK1pzWGlqeUVDdEZnV1NrL0hvZjZKWlJK?=
 =?utf-8?B?TGxvd21SNlFGcmpUa2R3RWVJKzBjZ1FLeFdLQldkYVFCZS9xOWdVN0M3cEZ3?=
 =?utf-8?B?VjZjWjlRQ0tNdWNBM2lkTE1xMGVFTysyMDFWSnUxWURMVERmbUtlM1MvZ0pw?=
 =?utf-8?B?ZDZRL3loK3gzemNobkpuYmhOclhndlZuU0pxSmRMQ2FtZ3pqMlUwWFY0cWdk?=
 =?utf-8?B?L2JKb0NHanh4bXBydVBxeHZYNzdzMWtGQ2dIenl0SVgxL2FHdVBseTdjT3FC?=
 =?utf-8?B?ckhXWXhzN04rUm1lWUhoOE5McTc3N3psR3AwZk1IbEJzQlRqckFBcThWdSti?=
 =?utf-8?B?MGNlTlJ5akI2ajY3UVlQMnkzTHE3MHhEcTJ1WjFOaTdneEhnOWFSYmM2aG9J?=
 =?utf-8?B?RkRPOTV3VEtxaFI3WDhwc2s0N0taUW44cHlSTG1sZ05nM2hNN2ZJZVUvRjBs?=
 =?utf-8?B?MEwrMktCRlJBUk1iQTVCMDdtQmNGY0dma2dMZEFUaW1WYm1BK0tZY0Z5OXlR?=
 =?utf-8?B?eVFQOXdUd0VFZ21hd2dvZC9GUU1MVWxTclRnUG1FRFc5WTZmRDVSMW5od2tH?=
 =?utf-8?B?RC9RcFQyYk12ZUxsZElxbkJRZThYZTlUbWRtc2xVdUVHVVorK3lOM2YwVGti?=
 =?utf-8?B?cnluTzgzdTNzVVVHVzErV3lqSXRJaGErWU9GV1VSZGVldzNvdU15WjVXVXp2?=
 =?utf-8?B?Sm9NT3lGbXl2NVVGNzREa2J0UWhUZjlobTY3RmRZUmw5TVFKL3hZaGpnYVZX?=
 =?utf-8?B?U2NWMnFLWkg2bHVqVUdCUGt0WjVucE42aUZ5SEJPZHQ3RGErd3BCdUt0aHpH?=
 =?utf-8?B?cGVhdkdoblYyYTlyRDRabmM2dWFWTFIrOXdiRDVJVGZmOUM1TkdicHFMSFJQ?=
 =?utf-8?B?SnVJdXdvOUQzSmJzREZmUmJCOC9MaU1OdzZZa0pOZ2o1S2RUeXo5aDV0UlVF?=
 =?utf-8?B?dWRxbUdVZ0o3TlFHT2V3ZUVMVW1KWVd2aTFvelNpRGdHeWROb3M0enNTdWlM?=
 =?utf-8?B?WTdOdnRmSXFPVVhSa3ZXRE0wZDdqUzlIcGdqaTJxVUl3ZFpwb2tJUFJCczRI?=
 =?utf-8?B?b0RFWnpVb0tIdUpUNDZKUEZuRHRDMHA1U0ZDeElWcDFPRlZaV1Jvd3g3RnNm?=
 =?utf-8?B?Q1dGOWJQWU9aZkxISjZzd1UzQno2djZMY2ZObGpyVHA5T012WHFXRTI5MENH?=
 =?utf-8?B?OTJLb3h5UnB4MnFQd3B1TWdOYlkvUjZsNjRGZzRRQ1Y1SVpXVlJiOG9veFho?=
 =?utf-8?B?NFFXcW9YVkNIdjlCSmJVSnd1Tk5WZkc3VFcyYnh0dFd4RVRaQXJDMEpvT3JR?=
 =?utf-8?B?WnF4TE5QU3dQa3o1a2JKWUZjdVZmME43aGx5L3hDVHZScWxSbTNmUmN0eG5m?=
 =?utf-8?B?R2VKZ1Z0ajVEUkRzTHo2SFFjVkNFYmJXN3lsSnBQaXQ1cWVHOGx5aGV5M0hN?=
 =?utf-8?B?SWU4clo1enZ3aUR5V2F6eEFUaDd1L0tDanNqL3ZoUFRFNFFsekNlZWs0V2Zi?=
 =?utf-8?B?VmdEMWdidGZ5WUFHVGxhQ1NNTHMwQXZPRThYTlpvU0E0T21uYitiYjk3TVMz?=
 =?utf-8?B?VUxpRXd4eXU2MXRINjlXVHcvRGxGZElOY0MrTEIxN05lLzRzNjFoL3JSNlE2?=
 =?utf-8?B?ZUlxYzlXNlpackVURFBUbk4ycXVnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97a9a770-7b74-4545-ce8c-08d9a0776cb7
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 16:15:03.9195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZuGnBoN4x0A1wR81jH1I4YAygoWHcbRqfdOuIseDc0Q8ZxmO5dbjVj7qztgCVgwwyVQGXFEpWRkFenzL9MoRudejVGQBi8FtYHngXUxd7ME=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3789
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10159 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111050091
X-Proofpoint-GUID: QKLpAcf4C8YI4_a-_XNvyE73vrRVXcRR
X-Proofpoint-ORIG-GUID: QKLpAcf4C8YI4_a-_XNvyE73vrRVXcRR

On 11/5/21 12:09, Joao Martins wrote:
> On 11/5/21 00:31, Dan Williams wrote:
>> On Fri, Aug 27, 2021 at 7:59 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>>>
>>> Right now, only static dax regions have a valid @pgmap pointer in its
>>> struct dev_dax. Dynamic dax case however, do not.
>>>
>>> In preparation for device-dax compound devmap support, make sure that
>>> dev_dax pgmap field is set after it has been allocated and initialized.
>>>
>>> dynamic dax device have the @pgmap is allocated at probe() and it's
>>> managed by devm (contrast to static dax region which a pgmap is provided
>>> and dax core kfrees it). So in addition to ensure a valid @pgmap, clear
>>> the pgmap when the dynamic dax device is released to avoid the same
>>> pgmap ranges to be re-requested across multiple region device reconfigs.
>>>
>>> Suggested-by: Dan Williams <dan.j.williams@intel.com>
>>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>>> ---
>>>  drivers/dax/bus.c    | 8 ++++++++
>>>  drivers/dax/device.c | 2 ++
>>>  2 files changed, 10 insertions(+)
>>>
>>> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
>>> index 6cc4da4c713d..49dbff9ba609 100644
>>> --- a/drivers/dax/bus.c
>>> +++ b/drivers/dax/bus.c
>>> @@ -363,6 +363,14 @@ void kill_dev_dax(struct dev_dax *dev_dax)
>>>
>>>         kill_dax(dax_dev);
>>>         unmap_mapping_range(inode->i_mapping, 0, 0, 1);
>>> +
>>> +       /*
>>> +        * Dynamic dax region have the pgmap allocated via dev_kzalloc()
>>> +        * and thus freed by devm. Clear the pgmap to not have stale pgmap
>>> +        * ranges on probe() from previous reconfigurations of region devices.
>>> +        */
>>> +       if (!is_static(dev_dax->region))
>>> +               dev_dax->pgmap = NULL;
>>>  }
>>>  EXPORT_SYMBOL_GPL(kill_dev_dax);
>>>
>>> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
>>> index 0b82159b3564..6e348b5f9d45 100644
>>> --- a/drivers/dax/device.c
>>> +++ b/drivers/dax/device.c
>>> @@ -426,6 +426,8 @@ int dev_dax_probe(struct dev_dax *dev_dax)
>>>         }
>>>
>>>         pgmap->type = MEMORY_DEVICE_GENERIC;
>>> +       dev_dax->pgmap = pgmap;
>>
>> So I think I'd rather see a bigger patch that replaces some of the
>> implicit dev_dax->pgmap == NULL checks with explicit is_static()
>> checks. Something like the following only compile and boot tested...
>> Note the struct_size() change probably wants to be its own cleanup,
>> and the EXPORT_SYMBOL_NS_GPL(..., DAX) probably wants to be its own
>> patch converting over the entirety of drivers/dax/. Thoughts?
>>
> It's a good idea. Certainly the implicit pgmap == NULL made it harder
> than the necessary to find where the problem was. So turning those checks
> into explicit checks that differentiate static vs dynamic dax will help
> 
> With respect to this series converting those pgmap == NULL is going to need
> to made me export the symbol (provided dax core and dax device can be built
> as modules). So I don't know how this can be a patch converting entirety of
> dax. Perhaps you mean that I would just EXPORT_SYMBOL() and then a bigger
> patch introduces the MODULE_NS_IMPORT() And EXPORT_SYMBOL_NS*() separately.
> 
To be clear by "then a bigger patch" I actually meant that the
EXPORT_SYMBOL_NS()/MODULE_NS_IMPORT() would be a separate patch not included
this series. For this series I would just use EXPORT_SYMBOL().

> The struct_size, yeah, should be a separate patch much like commit 7d18dd75a8af
> ("device-dax/kmem: use struct_size()").
> 
This cleanup would still be included as a predecessor patch, as I will be
touching this area in this patch.

> minor comment below on your snippet.
> 
>>
>> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
>> index 6cc4da4c713d..67ab7e05b340 100644
>> --- a/drivers/dax/bus.c
>> +++ b/drivers/dax/bus.c
>> @@ -134,6 +134,12 @@ static bool is_static(struct dax_region *dax_region)
>>         return (dax_region->res.flags & IORESOURCE_DAX_STATIC) != 0;
>>  }
>>
>> +bool static_dev_dax(struct dev_dax *dev_dax)
>> +{
>> +       return is_static(dev_dax->region);
>> +}
>> +EXPORT_SYMBOL_NS_GPL(static_dev_dax, DAX);
>> +
>>  static u64 dev_dax_size(struct dev_dax *dev_dax)
>>  {
>>         u64 size = 0;
>> @@ -363,6 +369,8 @@ void kill_dev_dax(struct dev_dax *dev_dax)
>>
>>         kill_dax(dax_dev);
>>         unmap_mapping_range(inode->i_mapping, 0, 0, 1);
>> +       if (static_dev_dax(dev_dax))
>> +               dev_dax->pgmap = NULL;
>>  }
> 
> Here you probably meant !static_dev_dax() per my patch.
> 
>>  EXPORT_SYMBOL_GPL(kill_dev_dax);
>>
>> diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
>> index 1e946ad7780a..4acdfee7dd59 100644
>> --- a/drivers/dax/bus.h
>> +++ b/drivers/dax/bus.h
>> @@ -48,6 +48,7 @@ int __dax_driver_register(struct dax_device_driver *dax_drv,
>>         __dax_driver_register(driver, THIS_MODULE, KBUILD_MODNAME)
>>  void dax_driver_unregister(struct dax_device_driver *dax_drv);
>>  void kill_dev_dax(struct dev_dax *dev_dax);
>> +bool static_dev_dax(struct dev_dax *dev_dax);
>>
>>  #if IS_ENABLED(CONFIG_DEV_DAX_PMEM_COMPAT)
>>  int dev_dax_probe(struct dev_dax *dev_dax);
>> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
>> index dd8222a42808..87507aff2b10 100644
>> --- a/drivers/dax/device.c
>> +++ b/drivers/dax/device.c
>> @@ -398,31 +398,43 @@ int dev_dax_probe(struct dev_dax *dev_dax)
>>         void *addr;
>>         int rc, i;
>>
>> -       pgmap = dev_dax->pgmap;
>> -       if (dev_WARN_ONCE(dev, pgmap && dev_dax->nr_range > 1,
>> -                       "static pgmap / multi-range device conflict\n"))
>> +       if (static_dev_dax(dev_dax) && dev_dax->nr_range > 1) {
>> +               dev_warn(dev, "static pgmap / multi-range device conflict\n");
>>                 return -EINVAL;
>> +       }
>>
>> -       if (!pgmap) {
>> -               pgmap = devm_kzalloc(dev, sizeof(*pgmap) + sizeof(struct range)
>> -                               * (dev_dax->nr_range - 1), GFP_KERNEL);
>> +       if (static_dev_dax(dev_dax)) {
>> +               pgmap = dev_dax->pgmap;
>> +       } else {
>> +               if (dev_dax->pgmap) {
>> +                       dev_warn(dev,
>> +                                "dynamic-dax with pre-populated page map!?\n");
>> +                       return -EINVAL;
>> +               }
>> +               pgmap = devm_kzalloc(
>> +                       dev, struct_size(pgmap, ranges, dev_dax->nr_range - 1),
>> +                       GFP_KERNEL);
>>                 if (!pgmap)
>>                         return -ENOMEM;
>>                 pgmap->nr_range = dev_dax->nr_range;
>> +               dev_dax->pgmap = pgmap;
>> +               for (i = 0; i < dev_dax->nr_range; i++) {
>> +                       struct range *range = &dev_dax->ranges[i].range;
>> +
>> +                       pgmap->ranges[i] = *range;
>> +               }
>>         }
>>
> This code move is probably not needed unless your point is to have a more clear
> separation on what's initialization versus the mem region request (that's
> applicable to both dynamic and static).
> 
>>         for (i = 0; i < dev_dax->nr_range; i++) {
>>                 struct range *range = &dev_dax->ranges[i].range;
>>
>> -               if (!devm_request_mem_region(dev, range->start,
>> -                                       range_len(range), dev_name(dev))) {
>> -                       dev_warn(dev, "mapping%d: %#llx-%#llx could
>> not reserve range\n",
>> -                                       i, range->start, range->end);
>> -                       return -EBUSY;
>> -               }
>> -               /* don't update the range for static pgmap */
>> -               if (!dev_dax->pgmap)
>> -                       pgmap->ranges[i] = *range;
>> +               if (devm_request_mem_region(dev, range->start, range_len(range),
>> +                                           dev_name(dev)))
>> +                       continue;
>> +               dev_warn(dev,
>> +                        "mapping%d: %#llx-%#llx could not reserve range\n", i,
>> +                        range->start, range->end);
>> +               return -EBUSY;
>>         }
>>
>>         pgmap->type = MEMORY_DEVICE_GENERIC;
>> @@ -473,3 +485,4 @@ MODULE_LICENSE("GPL v2");
>>  module_init(dax_init);
>>  module_exit(dax_exit);
>>  MODULE_ALIAS_DAX_DEVICE(0);
>> +MODULE_IMPORT_NS(DAX);
> 
