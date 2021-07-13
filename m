Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1961168
	for <nvdimm@lists.linux.dev>; Tue, 13 Jul 2021 00:14:37 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16D06uNT030364;
	Tue, 13 Jul 2021 00:14:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=4AuBRWBQEVIzm4AykxZTpRugSDDkVaPUYFuqh3XIYXU=;
 b=P1pdO/6jPVagGILV40C43g4XmgDSpebpse56I7ebuvdZBhKGrO5/lf5Na8qpDUcc0x3a
 k1fwmcH0fDuwedA1e0PfaddJM/l8R1PeK3BCuOI3tAuUpBd7dGXlyq8GQ/GEd1GwzPNs
 F+OWkDL5mz4T0VFdNeel5B5rUzngQ4RoBSl/3mCEMOAntbHjJDx0IyPYhr0yGkwtz6ml
 U5e5tQEKuDsmjl7qR+Del0+jl5HOWN30G+t1167Snk/7d+ZuzNHR+WYkhdWBk+/4r29o
 aMP+dIWzQTqIS+EDsONd05JqWnbqRMzIkQV9aphzU4XQsn1EC0nDPanz0iPjeR+DjTBD uA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 39rqm0s4u4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jul 2021 00:14:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16D06TRc169871;
	Tue, 13 Jul 2021 00:14:24 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2048.outbound.protection.outlook.com [104.47.73.48])
	by userp3030.oracle.com with ESMTP id 39q0p2415k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jul 2021 00:14:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mpyJkjxHYk5jXPaSH+HmAxD2tIelVeXgDCNfsABHtpvYRVfT3OlEqLt7OKGyKzmoW9gaBlCV5ljYa3IMw9hUEWB3EvBxXIzTI+SglDxklZ2Ep/vbydAlDKVJ1Uc4Oeiw/YgTYg3/bzr1J2J5T9WrTvrqpPeN+GCf6y57a48L/6NT/m5bNjIu1kfBxaxFzwinxstnRgxhMQGVeFVqu9Yw+FjCLPoAtzeJM3iKqkAgRO/wyIphXp2lfUWNZt2fKuXC/4kdzaaaM1FBfGCXvksda+fWXDxp5OE3Fo11OlFyeRHCfZxztOOD8Dv2GTja2c/SuCyil+j5xfEoYWObz+tW0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4AuBRWBQEVIzm4AykxZTpRugSDDkVaPUYFuqh3XIYXU=;
 b=HzQJ1s+hp9YJ9p2U2VpZ0NwbgcsGHeBj+Rnb5Z27yucGb/n6KWtxHcYq65qIvFIIB1zCQx3CAwvegKRZAlqcri/SVR+marUsohRwqbD5KAK61S7R73Hjlg1V97ZmtGtnMx3NYlVwcUQJERI/aKJZC6TWLFP9+iziFrAonLkTcE8yQfI0OcI7az7OmCtUIH4p2q2Tap50dSSxthRR6davbUe1MdWICFieT6cVbHdNGdNP26o/UGo0d4sJLX1MihhOtQSIHnBAeZtlQgGdXEQfkAtN28q7l/Zeptu/y/0vBZ1OI+/zbrQULfmlJBGHv9h30sNFs7OWJ947v4E/sxvZAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4AuBRWBQEVIzm4AykxZTpRugSDDkVaPUYFuqh3XIYXU=;
 b=oaVsJGWeRVibuT9q8nGdw6c5KMOKPY/sglM5/LI/BLw1yhTNJDHJSX1uLQfsoboTS13ss0eRbi6PhMUWDe36gpdsNSELQovfHlNuK1ymGrTeG9E9G0c0W36R9xThponqgdIj2Urc8O6oS2W3X6yIkq1Mkg9ZK6gX7YAcxsrZbJo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BYAPR10MB3095.namprd10.prod.outlook.com (2603:10b6:a03:157::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Tue, 13 Jul
 2021 00:14:22 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d2a:558d:ab4a:9c2a]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d2a:558d:ab4a:9c2a%5]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 00:14:22 +0000
Subject: Re: [External] [PATCH v2 07/14] mm/hugetlb_vmemmap: move comment
 block to Documentation/vm
To: Joao Martins <joao.m.martins@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev,
        linux-doc@vger.kernel.org
References: <20210617184507.3662-1-joao.m.martins@oracle.com>
 <20210617184507.3662-8-joao.m.martins@oracle.com>
 <CAMZfGtXSJE2ZsSOBW7Ef0VtP=+Q=cULSw9urqZGSG_WbGTiaSA@mail.gmail.com>
 <7f7313c6-f101-1726-f049-61091567f9c3@oracle.com>
From: Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <dacf10bd-f221-9339-a025-723943dddea6@oracle.com>
Date: Mon, 12 Jul 2021 17:14:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <7f7313c6-f101-1726-f049-61091567f9c3@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0036.namprd16.prod.outlook.com (2603:10b6:907::49)
 To BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.112] (50.38.35.18) by MW2PR16CA0036.namprd16.prod.outlook.com (2603:10b6:907::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Tue, 13 Jul 2021 00:14:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7672bd15-570e-4ec1-78e7-08d945932a9a
X-MS-TrafficTypeDiagnostic: BYAPR10MB3095:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BYAPR10MB30952AE79A5647D501FEBE01E2149@BYAPR10MB3095.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	EwNI8p3iHgNe/QEwPksBljmumKlcCmM9IqkUtfjofdvsDsFlF1KyeRl0BmozoUQtPLVY8u6dDCy8bkcPRdyHb/FXKFc/GNrthawZzYWZBLP5jfDZorm4KX4EYkHorXau1CoxIvwYXzExFp7qSyGS5P3jcbmYZCxxZiBKC8I0EKGEKI9HiRJhRhluDhPX6+dyWO2YVjTSL5wrFWA3p1lz6yt0N99MRYJK51CfQBbK/dXdOgOq4Zaf6+TgUsRQfu7RxygPLxImNkfyHhB6AprzKXNT1fCjvY7tyHF0uXcFcXnFBNRg+ZfuO4Xu+RMNChv8eod0NlT+rjcij9sUdmsvAzCcMpmqBtMbT1FfgVe+6QYG2MNyKqkvHLZyl7x2YNUZc+3ImaVCLQdXoI7JdKUbtM0s2vGKyBtDSMkrSWo+YlAGVoFiara+uaLFmazU/jHsRIa/4aQqR4Ujv5weuzgViK61bzjdX6piJHgAM68pHYVOR7oRq6F/QbjtXzuXMAa/3bwVAn+Jrgq450nFF+VcMiWtBRGQZAeRVC77tX33ZKYC9zqf4j77lL9lvzpJrN45dT23AV+lx1yfYFkCg0tf/jbZuuoOPeeyaUIuKcfYocp0ssrDZXlS4tCV8dnQ9BqjoVa2vWW5QzI2IQ7hXGLkgCT/Nv0O1896JZHZbrjxD+yLSyFuYAtDXQ6bKFC8J/EIo3IRrTqGiRgt/rJv8NicEMgLvHTGKXYqIm/BEroIEPR3biaE/bnBzP6F/0sFxTE0pJ9PM40vA/f8d181JDeloA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(39850400004)(366004)(376002)(8676002)(44832011)(2906002)(6486002)(53546011)(66476007)(8936002)(5660300002)(66556008)(66946007)(36756003)(31686004)(86362001)(83380400001)(186003)(2616005)(956004)(478600001)(110136005)(7416002)(38100700002)(4326008)(52116002)(38350700002)(31696002)(16576012)(54906003)(316002)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RmdxaUc3WStBRmJxQU4vMTdYZXBxTkd4T1lvdjVnRng1SjlCa1dFYnpjcUdQ?=
 =?utf-8?B?RjkyV3dBZ1NlZTF3SVMyanprOHVwMHk2YVpNaitVaDEwQ2JFRDlkV0hFcU10?=
 =?utf-8?B?V0dhTlFvVHNuTVlxMDhSNGpVa3N5U2ZvVGh1citTSUk2RnVzT3RKdzgxSXE4?=
 =?utf-8?B?K1E2RWxieWpUb1Z3bVVoZ0dNcTFoT2FkZWhhdWNCYjl1eS9SVG8xVXhrdGJa?=
 =?utf-8?B?L0FNZzByclpUcGpWNTZaOERXcjRlemtSenFiVkc0YzlIZVhQOHBLL3lsTitF?=
 =?utf-8?B?bVp1VldpT3NwUS9mVjV4Szl0dzJ4T3JNWkZRYVhCcEJxTkhjSE45N2lLQ1Vk?=
 =?utf-8?B?YlFXb0M0V29UQVV2YzhjeDJSUVdYTWZ1amt3K0kzdTJRMXVieDQ5blBINmZh?=
 =?utf-8?B?eHAzNmVFMWpLQlNRcDRJVWFGR3ZnR21vTFpTa3pWcCtiRjJSMmptNUM5UnZR?=
 =?utf-8?B?emxDSUtzSjM5WHozd09YRjBvWTAzVVF6bE1FSWwzUGw4VGNsNjZheVFLblBq?=
 =?utf-8?B?ajkwa1V1dXFRU2hWZmlheENYclArWFFlMFFqd3hIK2hucVpHVlNISEFjcklo?=
 =?utf-8?B?cXpVNlJOd2FGcDBWKzNUeGZkaTBRQktLS2ZObkZYd2RwbXpWd3pPUnd6bVlE?=
 =?utf-8?B?MTBtRW9zTnYxRGVhdjg3UXlWTkQ5T01WL0ZYek9sbCs2Yis0dVN4NnB6OTNj?=
 =?utf-8?B?SkNmZ05rWW5zb0gwZGl5eWVtMGZxZmRKeFR1b2g5MlhWVUJ4VEhib1RwalFL?=
 =?utf-8?B?dnREYUZqMTFtZzFYVmlzNWM1NHM1YVFlTHo5bG96M1Fpd2J2d0dOOTh0b0Fk?=
 =?utf-8?B?SkZFRnp1TFp5T3RHTVl1OFNqWDZxU2xGbm5HV0Vla2RDTUc2bDJVbHJiNkQ1?=
 =?utf-8?B?SVFpNk5QRmNwNjhZN0hoSmhPd1Z1Z2NBaENaOXNiTXdnNEN3M3VkcVh4U2Jr?=
 =?utf-8?B?elRBdnpsdUw2R3lzZUljK1Ftbzlrc09rR2Z4TUppWWdFbHFTdHpac1pqRldM?=
 =?utf-8?B?bGFSbWwxcU5kSEpOZXovc2RoMmxPUC94bHhWcmVITEN5R1UyV1hzd2RuM1B2?=
 =?utf-8?B?amYyaUJjUHY1ZGVKcFJnNUtLUG1rdGhaaWVJbE9abFk0SGVmYjNkYnVTRTl3?=
 =?utf-8?B?TEs4bnlOeHZxUjZZOUpZaFRORE5GL0docWJuZ052Ly9IcXNEWklvdGg3dHQy?=
 =?utf-8?B?MDQ1bU5zSVRTdHZkbWpPZmMwL084cmthUzRCZXZ1ajdnVWxOSkZPQWtjQzhy?=
 =?utf-8?B?eUxac1M5cXZkRWx4NVdMTmZFQlI5LzVBZTE3b2xZd2dXV2xjRk5VaUN4dkwx?=
 =?utf-8?B?alZMM0pxM1pGVkk1emFuSS9YNmJxa3p0MlI3K1MrdGJNYmRpMU1ORzQreGd4?=
 =?utf-8?B?MUZaYWNvQU0vUXdJeVJhVlF3VndWdDRxamVBOTNXZXJIZ0FQNXVwd0dPak9z?=
 =?utf-8?B?a3BvbzJYUjhYS1A4NmdNZjF6MDdkSUpZMElCNXdrem52TFVvS3U4SnY5QlF2?=
 =?utf-8?B?MEwrN2hVNHIyVzFsTjNqRzJYb2pGTnVRaWJmT2s2c0o1RER3UXVHVG4yejJJ?=
 =?utf-8?B?anhhN2dPK2wySk9QWit6a2ZtMlA4VXBwMzY3YUpoZEQxTk1qS1BZSVliZWZ3?=
 =?utf-8?B?eisrOVZIVFo2WE52LzRyU0tmOVF3dkxtbTk5TTVLOEhZc1NNZnBtalZwNFgv?=
 =?utf-8?B?N2Rkb2Fxb2VjN1RJNktiUzJncS9LN21naExJZWl3aHJXMk5xd2ladzJtSnRp?=
 =?utf-8?Q?q9kRjQZFvwZcSpr1bZgbl9A8ZxpBy6VCtVesmjg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7672bd15-570e-4ec1-78e7-08d945932a9a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 00:14:22.8335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OkkX+RrORQxm2Yfm7Ik9tISD7elN0WT+JYI/twfM2wXJImp3gLr6wDCm7VR8am0T12Jm1U3Tmx3/G4nnK1mbYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3095
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10043 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107120163
X-Proofpoint-GUID: rz3lXfreGtw7IMzqChX2A8prEkGyMN3S
X-Proofpoint-ORIG-GUID: rz3lXfreGtw7IMzqChX2A8prEkGyMN3S

On 6/21/21 6:42 AM, Joao Martins wrote:
> On 6/21/21 2:12 PM, Muchun Song wrote:
>> On Fri, Jun 18, 2021 at 2:46 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>>>
>>> In preparation for device-dax for using hugetlbfs compound page tail
>>> deduplication technique, move the comment block explanation into a
>>> common place in Documentation/vm.
>>>
>>> Cc: Muchun Song <songmuchun@bytedance.com>
>>> Cc: Mike Kravetz <mike.kravetz@oracle.com>
>>> Suggested-by: Dan Williams <dan.j.williams@intel.com>
>>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>>> ---
>>>  Documentation/vm/compound_pagemaps.rst | 170 +++++++++++++++++++++++++
>>>  Documentation/vm/index.rst             |   1 +
>>>  mm/hugetlb_vmemmap.c                   | 162 +----------------------
>>>  3 files changed, 172 insertions(+), 161 deletions(-)
>>>  create mode 100644 Documentation/vm/compound_pagemaps.rst
>>
>> IMHO, how about the name of vmemmap_remap.rst? page_frags.rst seems
>> to tell people it's about the page mapping not its vmemmap mapping.
>>
> 
> Good point.
> 
> FWIW, I wanted to avoid the use of the word 'remap' solely because that might be
> implementation specific e.g. hugetlbfs remaps struct pages, whereas device-dax will
> populate struct pages already with the tail dedup.
> 
> Me using 'compound_pagemaps' was short of 'compound struct page map' or 'compound vmemmap'.
> 
> Maybe one other alternative is 'tail_dedup.rst' or 'metadata_dedup.rst' ? That's probably
> more generic to what really is being done.
> 
> Regardless, I am also good with 'vmemmap_remap.rst' if that's what folks prefer.
> 

How about vmemmap_dedup?

I do think it is a good idea to move this to a common documentation file
if Device DAX is going to use the same technique.
-- 
Mike Kravetz
