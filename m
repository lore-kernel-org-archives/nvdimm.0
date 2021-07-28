Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2D972
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 09:43:57 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16S9ge6r022907;
	Wed, 28 Jul 2021 09:43:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8/qCf85EZbT428YSvaFRgZmYMT5BHUbtBKx4taOJmD4=;
 b=P8zvpEcTfwmK2TY6CVZwPlaYOiUxUc5ox4iXAbzBwi5mwJsX4UmW2Oo/PFEarxE4UeCa
 ASjnbS+NJLKv6d+3EH79Yg6LSYrRsdGDCMVGu7DO8TmT00sPKwuDkZvW/+AzQCjSdODo
 j92fRS2Htv3RLeQxwfCLohEa6EjUREmfZV0a2qWT3oXraiiPlw8sSxJrkzslMVgx5Rhz
 rGPb6pdQVLCMCF6r8sbLeFti52sTgvdOFkW8/JlFBfo07qBT9DnP7d8RqnfcaKoF3m7T
 7NrRQ8BtOm/2I/4N12cwG5p7WSsubbl7mUO8PWHVNodIhBD3eAcwX8I7pJFZgPGNFEPw lA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=8/qCf85EZbT428YSvaFRgZmYMT5BHUbtBKx4taOJmD4=;
 b=Wg/VoKyv1N+psnT8R05r4IWKubnm/u/BL3ifecYo2CHaR/GR4mvW1rycuCYyhSawTqD1
 oZWbInODY+B9ffFNDCXeeMev9EuUHebNIdn8EmrA7/M2PxIQJKInJdG3/pyff/vlDipT
 TVuPVgTlgUEmR1QuzzB5l3QGXCDaubg3vqmB9lDWiyKeSu41AcdcCsPaP+NaLddLkn3y
 1sDTBN9Ag5tjmEt5hXzvenNWBsOC95EeOvDtUnT0I9OHHMlkoHPPrwymmE/IgpbzU4IF
 xioO7u4eyL6BEAH5OgqMKtjEjQ/bgKGbeeHB9WJUQw7bZmCzk+GLYR/yg+iWgOqzfMEK 9A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a2jkfaa0g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 09:43:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16S9ZksQ051191;
	Wed, 28 Jul 2021 09:43:43 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
	by aserp3030.oracle.com with ESMTP id 3a234c311m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 09:43:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRkhZCo37n6dp2FdLlMUJfQ49Y5g1FrW+8RuHF/P3Lces3fP5S7i6ji9PkZrjxVWSREFkmOWx0RSQCdkVwcmgdDBFKV5d8fXEqQ85r0ecjJVTngyHwvKAXv8GtHEUaOsjPyxvd8e9WHzQC2LS9AP3W0pjSX0XqBMTdJ4LuksuHm57BBVs8EUf1OTsPyXeL33U9GMx3WJU53D94hNRTC/jZmo8H3ONqLsoR8KenpW/lZ/AShstlsXKQuR6cpDB4GCkaC00Sq+7/JOcV94PGds68zTPEQpEG/ypn1ua4m0jvEFIpN9TZnCQWAmkeh/BBN+53n+bfHKXuxj4QmxjknbYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/qCf85EZbT428YSvaFRgZmYMT5BHUbtBKx4taOJmD4=;
 b=adsiFjtT5GBa8HpVj0SXfiwlLErQD3iSKoeJaihXr3nVopGQcmKBB+Fsl1KtwCpBLo+8OmGpJOV16kHML29+C1ecmsiLOwcro2FV7KRMTiB8hIfmW3eHGcLTaVmc3U319Um4YKHTHWCLBd4+yM9OhGv/Gc1ltyHudx+MdXX3FLO1IigRibOYjdfg+hT309mN2+PQ5/oQz2o7O+AtY8IQ+V32XD188kmOCUjGW9MA0Fxg69D4gDKjfEmFfZ1SKZZOBmfWol2YcWehAJVBXHt2az64BDOo/VS9ZNfmMMRoZIvPJ/HcdnZK0DZ6c+frH5LjdAc5aGc30WcdoZ9S5E9Pmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/qCf85EZbT428YSvaFRgZmYMT5BHUbtBKx4taOJmD4=;
 b=uQrcezVmypa3JGvqzA14JKTiUHZxfVq/+CzGbRtr3bblGyRuJm0WkSf+y2qWKztpeCyABnNNWWtkx6hB+zovWEVaNf8u5JduagOftykfqb3Aq15iaFS0WKYFDcuQxYFO6+3QD6OX4CfEBgamX+/VQlw+RO/WT9V4EOZ295EFVhc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3919.namprd10.prod.outlook.com (2603:10b6:208:1be::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Wed, 28 Jul
 2021 09:43:40 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4373.018; Wed, 28 Jul 2021
 09:43:40 +0000
Subject: Re: [PATCH v3 05/14] mm/sparse-vmemmap: add a pgmap argument to
 section activation
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
 <20210714193542.21857-6-joao.m.martins@oracle.com>
 <CAPcyv4j2TZXUUi3zoJwTZ-gnNpnh4sQPC-gRXmVwNoF4N6qnxA@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <eb42d05d-7a58-a56e-a9af-55d01255c422@oracle.com>
Date: Wed, 28 Jul 2021 10:43:33 +0100
In-Reply-To: <CAPcyv4j2TZXUUi3zoJwTZ-gnNpnh4sQPC-gRXmVwNoF4N6qnxA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0033.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::21) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LNXP265CA0033.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:5c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 09:43:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd7ae2b6-d701-4cbe-0283-08d951ac2e76
X-MS-TrafficTypeDiagnostic: MN2PR10MB3919:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB3919010224C4B0EF558314E8BBEA9@MN2PR10MB3919.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	WHBSnxlzw0pEPE6EhiK/v2uIraMHA4RQwKog/hnOGuwISPWXj+7PtLTS7Pl+Lj/CAXgSTRvL1VxnXMmHecUmlttAJLMmSL78TYLKKOD6rG5IEbe91RvBbDaZNF8V+0liFYxggUSXBFKX4jRizbntx8MVCLtvRTtHeOzgYc40uYpG1arlvNStgaLOkXszZCsSr4XXI5A2qTuYrSbRcpN6jHeNJ+075tinSHzEbch4bnLlLwwr7kfXGpJazgdayC8Fz09zevus/lSX3w6DD35Iah0hqPpKnvReqKzGwM761cMbsjh16P/hM93lPx2gd2SMYNg+A46BklUUdFAe+rEq8cfE1idxSluI/q1luB0j5jhoudt98u2cx7V32//JmyqBTLMFzZMmRlaSQaTsN0+PAKO29TKvu+WuXcY7H9edYoA/8+unIWxaAhl4EcR8wYFbA/mxoF5LRoo0AHUm/sOofG+0TCnO4r1sdp3xgxKl5e5wl3mSm/urKhVodVhXDUn0jWODGUVkFSycgCcOkBsJAN0RIHgmKwuzW7j+iqrv/NypN1hUW/0jR4LClKrrr0+IX/XuC4iZQNI+fKeW9kXULmM829yS7HmcqKJoqqcV5Wm2aPayf9fm549eof7tufPMXntC9N8sX9YJ5Vp7rgNYEd5bn9VunUAl4Qxy18EDNTeRUxn+OACjF5Wha3jThzgSQ7UWZJAmnTPBDziB5RHYOAY3I35RhZLGe3F0J0AROmBEQvTJhIV6Q2uYxhhqqLtoLDyfYG46JBNA3iyrGGvtdSeX2C4Nqafe1fItbX/hr2A=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(366004)(136003)(376002)(31696002)(478600001)(6486002)(86362001)(8936002)(2906002)(66946007)(8676002)(38100700002)(66556008)(6916009)(66476007)(31686004)(966005)(4326008)(53546011)(316002)(16576012)(2616005)(7416002)(36756003)(26005)(956004)(186003)(54906003)(5660300002)(6666004)(83380400001)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?WHF1MXhiRUNOYWJVSk1vMzBIYzB1d20yTmdmUFRvNEErSVNoNHJiYjUzZG56?=
 =?utf-8?B?bzMyRyt6dW1pYytDdWxVR1loWldPQnR1d2szcVl0RHVyckpHeGVIUy8xU283?=
 =?utf-8?B?MjJhbUluWGUzQS9Qa3NQbXJOcnlHSkpHZUZQLzNMYkJQWFhvbXpOdVdHd1hS?=
 =?utf-8?B?NDhmZG5CbCt5Uk5EdG14NzlPeFJTYnphekl3Uk1xdGlyUDk2NUNQRFhWRk1Q?=
 =?utf-8?B?QVJvSExvWFdpTXE0UGNDeTNxeFY1WFRFS1FxSjZzeU5Vak1DZWFYUHk0am9u?=
 =?utf-8?B?aEE5VmVFYkxSMWN2RlVvcjMrMlN5YklSV1A0Z2xCdHAwODNMelZBQU9Lc0Z3?=
 =?utf-8?B?ZCs3R29wZGdVc2JvMy9QTTh6T2VQMXBjSHFzL1JtS0lHd08wM1dRVUJVQ3RP?=
 =?utf-8?B?bFZBV0N3TkJqMmhPb3A2MisxOVEweURybnk0c0lSUThuYUdDd1hwVHN2anNk?=
 =?utf-8?B?L0dWZHRrRkJ1bElkUjdvd3k5YWNha1Bta0liWjk0K25vMXR2emNsZm00Kzgx?=
 =?utf-8?B?OVMvQzk3SDQ0VnJaTGUvL3N6Ui9iaE9zNncxelNkem5HYldNdnhuVm1qejAz?=
 =?utf-8?B?OTJCbVlxYzM2WUZ2TEpoNTdrSlZhazdSTUNNdmlrbWVLZzFVMHAzSHR6YjY0?=
 =?utf-8?B?SXJqbktuaVZnVUw3MzNQeDR1ekd4dW5iUGVJcjRWV2xXRXAyemRzRmJ3aHln?=
 =?utf-8?B?azU5ZytDWXBkQTQ4V1JaNFFqNXpxbktWQWZUR1lCOGpZSVZrek4zYzVZMDc4?=
 =?utf-8?B?cy8waXk5YWlpZHNaVU9ZNlYxYlVmTlYydlNxMlU3R05UQVhTWUNnSXAyNyt0?=
 =?utf-8?B?c3l4amowVTJHejJLdlJlZFRSbUpWenBkY2ZoVFQyMEpYRXU1bkNMZUhwa01W?=
 =?utf-8?B?VW93VmpVTFZUTVR3Rjc0Z3c1UTF1RmIvMFZnVnBJTExOT0hFSm9NcE92Z0Yy?=
 =?utf-8?B?OS9QZ3NJdHg0T3h6ZTIxUmY4ZmFRUlAyeS9DOUtCV1lZVE5WMmtRRFpBY002?=
 =?utf-8?B?UElWUGgxc2pIclJjTHNGd2pyTC9EbWR5c1o3c25ka2pnbjJ4aVEvV1N0Ynoz?=
 =?utf-8?B?d0FnTVJjSE9aUDNueWw0MWV6ZGw4ci9xRzV3K3p5ZVhYMWxSN01NSVI1NENZ?=
 =?utf-8?B?eHlGeENqMmI4MnNDb1RMcHRlNWF3eGhhWEt2YzJkTFlYV2pVcTluYjZkMG5S?=
 =?utf-8?B?Z0VhbFRqK2RsbWhOelFvUDhrNFNUbGN3aVROc3RFTWVMMnZiZDMyUmRoVXhL?=
 =?utf-8?B?S20xZWIrcktzV1pjcXltQmdnQzFzT3d4M1lURUZROVlkV0h6YW9YZXluNmVa?=
 =?utf-8?B?UEVHWWRFMFIrc1pQd29GTmRDVmd1WFZacTBnT01OQW1rbTF0QkZXNjVKSlc3?=
 =?utf-8?B?bGRHRElKYkNLK1BJZzJDa2l5MlBzWFB3TkQyWTVUR0dYYVVmaTkzaTN2YzFH?=
 =?utf-8?B?NFNhTnRERm9sQzN1dzV5bmxBZmkwVUxVOHlQemlsRS96MWd2dnE2SmF6RG05?=
 =?utf-8?B?NTRMT0UrWFgzTnI0dmwxLzVMcG5NQ2E4UGozZkdJYitTVmsyMnlJTnNNY3dy?=
 =?utf-8?B?QXBOMFZmTEY3REhYTnVCZzR1Y0JQOGRTRlFQTlcrR05TMnhRWDE0T3gxNU16?=
 =?utf-8?B?aTF1TjYrT1BHNlMwbi92N2JBUFkrNFZ5QncydS82VDlVbUNHL1piNnBGOVNX?=
 =?utf-8?B?VzY4YUZDNjhmSTFEd0lLQS9LTUtORDhKTjJxNGFoZlFSVm1yYzhtdEwzOFQ3?=
 =?utf-8?Q?iO1edXM7lpgnaOpJaH9hANirGtPmbJdxTsvyTJ9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd7ae2b6-d701-4cbe-0283-08d951ac2e76
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 09:43:40.7905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pa9glpBuBgxJ9jN2LqjZOxHl1N3QP3yx2jB2B29zDvgqO+RZ2IyDI2C7ym0+JqPXl+z1EF/WXNxkhFkbZkR2mD0y5nLE19wmKjdzJkHBcqE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3919
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10058 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280054
X-Proofpoint-GUID: kQOzVuihOknf6IkzO9kThi8nzxVBZYbB
X-Proofpoint-ORIG-GUID: kQOzVuihOknf6IkzO9kThi8nzxVBZYbB



On 7/28/21 6:56 AM, Dan Williams wrote:
> On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> In support of using compound pages for devmap mappings, plumb the pgmap
>> down to the vmemmap_populate implementation. Note that while altmap is
>> retrievable from pgmap the memory hotplug code passes altmap without
>> pgmap[*], so both need to be independently plumbed.
>>
>> So in addition to @altmap, pass @pgmap to sparse section populate
>> functions namely:
>>
>>         sparse_add_section
>>           section_activate
>>             populate_section_memmap
>>               __populate_section_memmap
>>
>> Passing @pgmap allows __populate_section_memmap() to both fetch the
>> geometry in which memmap metadata is created for and also to let
>> sparse-vmemmap fetch pgmap ranges to co-relate to a given section and pick
>> whether to just reuse tail pages from past onlined sections.
> 
> Looks good to me, just one quibble below:
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> 
Thank you!
>>
>> [*] https://lore.kernel.org/linux-mm/20210319092635.6214-1-osalvador@suse.de/
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>  include/linux/memory_hotplug.h |  5 ++++-
>>  include/linux/mm.h             |  3 ++-
>>  mm/memory_hotplug.c            |  3 ++-
>>  mm/sparse-vmemmap.c            |  3 ++-
>>  mm/sparse.c                    | 24 +++++++++++++++---------
>>  5 files changed, 25 insertions(+), 13 deletions(-)
>>
>> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
>> index a7fd2c3ccb77..9b1bca80224d 100644
>> --- a/include/linux/memory_hotplug.h
>> +++ b/include/linux/memory_hotplug.h
>> @@ -14,6 +14,7 @@ struct mem_section;
>>  struct memory_block;
>>  struct resource;
>>  struct vmem_altmap;
>> +struct dev_pagemap;
>>
>>  #ifdef CONFIG_MEMORY_HOTPLUG
>>  struct page *pfn_to_online_page(unsigned long pfn);
>> @@ -60,6 +61,7 @@ typedef int __bitwise mhp_t;
>>  struct mhp_params {
>>         struct vmem_altmap *altmap;
>>         pgprot_t pgprot;
>> +       struct dev_pagemap *pgmap;
>>  };
>>
>>  bool mhp_range_allowed(u64 start, u64 size, bool need_mapping);
>> @@ -333,7 +335,8 @@ extern void remove_pfn_range_from_zone(struct zone *zone,
>>                                        unsigned long nr_pages);
>>  extern bool is_memblock_offlined(struct memory_block *mem);
>>  extern int sparse_add_section(int nid, unsigned long pfn,
>> -               unsigned long nr_pages, struct vmem_altmap *altmap);
>> +               unsigned long nr_pages, struct vmem_altmap *altmap,
>> +               struct dev_pagemap *pgmap);
>>  extern void sparse_remove_section(struct mem_section *ms,
>>                 unsigned long pfn, unsigned long nr_pages,
>>                 unsigned long map_offset, struct vmem_altmap *altmap);
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 7ca22e6e694a..f244a9219ce4 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -3083,7 +3083,8 @@ int vmemmap_remap_alloc(unsigned long start, unsigned long end,
>>
>>  void *sparse_buffer_alloc(unsigned long size);
>>  struct page * __populate_section_memmap(unsigned long pfn,
>> -               unsigned long nr_pages, int nid, struct vmem_altmap *altmap);
>> +               unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
>> +               struct dev_pagemap *pgmap);
>>  pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
>>  p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
>>  pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 8cb75b26ea4f..c728a8ff38ad 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -268,7 +268,8 @@ int __ref __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
>>                 /* Select all remaining pages up to the next section boundary */
>>                 cur_nr_pages = min(end_pfn - pfn,
>>                                    SECTION_ALIGN_UP(pfn + 1) - pfn);
>> -               err = sparse_add_section(nid, pfn, cur_nr_pages, altmap);
>> +               err = sparse_add_section(nid, pfn, cur_nr_pages, altmap,
>> +                                        params->pgmap);
>>                 if (err)
>>                         break;
>>                 cond_resched();
>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index bdce883f9286..80d3ba30d345 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -603,7 +603,8 @@ int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
>>  }
>>
>>  struct page * __meminit __populate_section_memmap(unsigned long pfn,
>> -               unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
>> +               unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
>> +               struct dev_pagemap *pgmap)
>>  {
>>         unsigned long start = (unsigned long) pfn_to_page(pfn);
>>         unsigned long end = start + nr_pages * sizeof(struct page);
>> diff --git a/mm/sparse.c b/mm/sparse.c
>> index 6326cdf36c4f..5310be6171f1 100644
>> --- a/mm/sparse.c
>> +++ b/mm/sparse.c
>> @@ -453,7 +453,8 @@ static unsigned long __init section_map_size(void)
>>  }
>>
>>  struct page __init *__populate_section_memmap(unsigned long pfn,
>> -               unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
>> +               unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
>> +               struct dev_pagemap *pgmap)
>>  {
>>         unsigned long size = section_map_size();
>>         struct page *map = sparse_buffer_alloc(size);
>> @@ -552,7 +553,7 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
>>                         break;
>>
>>                 map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
>> -                               nid, NULL);
>> +                               nid, NULL, NULL);
>>                 if (!map) {
>>                         pr_err("%s: node[%d] memory map backing failed. Some memory will not be available.",
>>                                __func__, nid);
>> @@ -657,9 +658,10 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
>>
>>  #ifdef CONFIG_SPARSEMEM_VMEMMAP
>>  static struct page * __meminit populate_section_memmap(unsigned long pfn,
>> -               unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
>> +               unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
>> +               struct dev_pagemap *pgmap)
>>  {
>> -       return __populate_section_memmap(pfn, nr_pages, nid, altmap);
>> +       return __populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
>>  }
>>
>>  static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
>> @@ -728,7 +730,8 @@ static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
>>  }
>>  #else
>>  struct page * __meminit populate_section_memmap(unsigned long pfn,
>> -               unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
>> +               unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
>> +               struct dev_pagemap *pgmap)
>>  {
>>         return kvmalloc_node(array_size(sizeof(struct page),
>>                                         PAGES_PER_SECTION), GFP_KERNEL, nid);
>> @@ -851,7 +854,8 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
>>  }
>>
>>  static struct page * __meminit section_activate(int nid, unsigned long pfn,
>> -               unsigned long nr_pages, struct vmem_altmap *altmap)
>> +               unsigned long nr_pages, struct vmem_altmap *altmap,
>> +               struct dev_pagemap *pgmap)
>>  {
>>         struct mem_section *ms = __pfn_to_section(pfn);
>>         struct mem_section_usage *usage = NULL;
>> @@ -883,7 +887,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
>>         if (nr_pages < PAGES_PER_SECTION && early_section(ms))
>>                 return pfn_to_page(pfn);
>>
>> -       memmap = populate_section_memmap(pfn, nr_pages, nid, altmap);
>> +       memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
>>         if (!memmap) {
>>                 section_deactivate(pfn, nr_pages, altmap);
>>                 return ERR_PTR(-ENOMEM);
>> @@ -898,6 +902,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
>>   * @start_pfn: start pfn of the memory range
>>   * @nr_pages: number of pfns to add in the section
>>   * @altmap: device page map
>> + * @pgmap: device page map object that owns the section
> 
> Since this patch is touching the kdoc, might as well fix it up
> properly for @altmap, and perhaps an alternate note for @pgmap:
> 
> @altmap: alternate pfns to allocate the memmap backing store
> @pgmap: alternate compound page geometry for devmap mappings
> 
Ah, indeed. I fixed it up and also added this to the commit message:

"While at it, fix the kdoc for @altmap for sparse_add_section()."

> 
>>   *
>>   * This is only intended for hotplug.
>>   *
>> @@ -911,7 +916,8 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
>>   * * -ENOMEM   - Out of memory.
>>   */
>>  int __meminit sparse_add_section(int nid, unsigned long start_pfn,
>> -               unsigned long nr_pages, struct vmem_altmap *altmap)
>> +               unsigned long nr_pages, struct vmem_altmap *altmap,
>> +               struct dev_pagemap *pgmap)
>>  {
>>         unsigned long section_nr = pfn_to_section_nr(start_pfn);
>>         struct mem_section *ms;
>> @@ -922,7 +928,7 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
>>         if (ret < 0)
>>                 return ret;
>>
>> -       memmap = section_activate(nid, start_pfn, nr_pages, altmap);
>> +       memmap = section_activate(nid, start_pfn, nr_pages, altmap, pgmap);
>>         if (IS_ERR(memmap))
>>                 return PTR_ERR(memmap);
>>
>> --
>> 2.17.1
>>
