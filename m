Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBA22F43
	for <nvdimm@lists.linux.dev>; Fri, 11 Feb 2022 12:39:01 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BB6SOP023128;
	Fri, 11 Feb 2022 12:37:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=eNU0UKXg8fSw6lnCPJ5itAjAGzm6BMHXuiwURhjX3Ss=;
 b=hYWPmk8Aq9kvIvtuy+g3uyENKiZd9VPGSPYZF2mhn2HR0WVU8Xebl6yCAGZpXUVOonuj
 BD0QgHmZ+OHhI2EINeeeDg0uWzc5cj7WK59S74txlZEBOwyVTznKDmvaWiiCGU/Lk5+x
 9dzEERoFU4bjzz4utgDnXE9uYNuRE1IRw4u5tU+0hz5J/GNdTJ/7+w+hBoH/WZ+W46QP
 nWFlVt7UKqMa/TBbNDhE0JlgtVAxORkMdGSEx1fDpDIg3Sb44CJCjZ8K2BhNMSceaS3B
 5h1r9RkRdSRGl74NS39of67uf157J+edAOQuuO6S3n7PBY9OT571+lj+tk8i4WizqnWw iw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3e5pmv84xs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Feb 2022 12:37:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21BCZv51070200;
	Fri, 11 Feb 2022 12:37:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
	by aserp3020.oracle.com with ESMTP id 3e1h2c5fqt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Feb 2022 12:37:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I3SUpY56IIxkE9IKzzI0z3oTIGBF6MqmJ13kAxUN5mGTXru/gdGG0e2Ef44jwGDM7v0q6PPa4aARK+TYNjrxSaUIxDsMBAYwMvCBSv9UdFroPTnjX35Q04rglaEuYMMs1FcDNb8v6O3P3GeoyT2kCEnjwSqWkJsz89bKCn7Pa+gTiLoWpGAzPHV1vSh0rsecLyTnlcF2ueeP/PppblMOPP5Bi7R0yFKYQXkkEeGPtKkRcsQSTAtgpefRbSXsBcM9n6sqENOEGK8G0lUPGodKaaVGOsdkvSBVm5hN4S0NJRgtl5Ps3lJWuGQEgnhn4cQlTHS7GjrTTkTB9JoMAbWvxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eNU0UKXg8fSw6lnCPJ5itAjAGzm6BMHXuiwURhjX3Ss=;
 b=PuiQ3Gy+IX6/O6AZ2gyWgkp6LOf04DRhcGHSaM8ed3iwgwmJ21I0WHZel2GErU8jv/Yg/JTwx68tSSz5ofx8lq9PYBUmzJOSx3/Ec8+XRzmKsN/ogQiQDM4pdhE2yhGRBdzFjMrSFME/ZfSINUywQNMNh9sSTrl1HlRTM/weTAEf9K2yYQKqhASPUi5S6OnECFy9ZPxCy3dvZ0wKQ6Jxo4qH7z9LvYGuR6utQfxgDTv2ZVfAksKaZoE/NRCAoEZeb9EwWC7flVw2n8lN5c1opa1IQZTal/gllw+0H9xbWGr3LPyi/fQBD+Dy9oHsspIgD934HQCkCSg4MhPNeP+vXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eNU0UKXg8fSw6lnCPJ5itAjAGzm6BMHXuiwURhjX3Ss=;
 b=JIZ12Pq+KIBKXQPlEHyjL5muZJDz5uMQBLxfTS3gyiz19Y9NJEpNfBCGryM4ejMsj8yRLxDOJzeSc26WQjUvQX+xJ1U/KYFFCcqHPhiVeapxiJhy3hTykdDcsTPpc1tHWdNKdhyHX8kc6PKwXGPgCS7Y+zHPTsTmVWNymLktyKE=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH2PR10MB4311.namprd10.prod.outlook.com (2603:10b6:610:79::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Fri, 11 Feb
 2022 12:37:52 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a%5]) with mapi id 15.20.4975.011; Fri, 11 Feb 2022
 12:37:52 +0000
Message-ID: <eb11c213-3ba2-4649-2ea3-d8abdf5a6fb0@oracle.com>
Date: Fri, 11 Feb 2022 12:37:44 +0000
Subject: Re: [PATCH v5 1/5] mm/sparse-vmemmap: add a pgmap argument to section
 activation
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
References: <20220210193345.23628-1-joao.m.martins@oracle.com>
 <20220210193345.23628-2-joao.m.martins@oracle.com>
 <CAMZfGtUwL-whhTeLydS9+H9weJ5sztAcrTi5ZK1ayNzSBMYtnQ@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <CAMZfGtUwL-whhTeLydS9+H9weJ5sztAcrTi5ZK1ayNzSBMYtnQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0220.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b53e3918-43f0-432d-76ba-08d9ed5b51b3
X-MS-TrafficTypeDiagnostic: CH2PR10MB4311:EE_
X-Microsoft-Antispam-PRVS: 
	<CH2PR10MB4311664831D29DE73DFFBDABBB309@CH2PR10MB4311.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	OaRvZg1nKpppqgN/DgIuHv76hQj6vZ6mEpiWFvEHDPoXMTyRa3pAS9FLrqVGwQGzfVEwNFOy9LqyS4mHR/VdRZpN6UgDiwStwvpPhd69L9S7A0Ri2pudud4ieoHP5kmXP7xQITuEsDSnERYGwsH+fHvDNXF9by493bV8h23F9Wem/aoTeI/Y/cHCeUolGb2PsSNm9yQeQzac/XHjCD+YDgf9NFzpPd24itCDGj19KqYTXd33YowTY4LlXyT1uOwFOXXJNkg/2OBlFdyVP34UQQFNRUfATnppgpoMMhUpymK7BGiWYpqYXc17FWywyKI8DaTlFVlgfzaLAZzfqI7cGE00uS81xOvFMVfkU5U+oUK0er0uCGSFdvZkMwgmRdySB2ZGQHCPrjSDp6JV6ZscFWUl9khHtLAcvZkX6RLHVx+rlrefOn342RR0WEs6gfoqWNhulwADbqGzvq9CyHO7YucV5aLJaf2oWUN/wCCn0twSw57RYYuLhMayXRAbdHI/dJHF/y0iisipcBrFaBQb11Jd+fmS1OmPLFtx+e4KvTTQe99gamf3jLod99ct+Vb2o5jCvWVJDV5jNxf+2hzY+NaQJJ0cG8X66KNYT6kEl3yFeaB63SC5kvLWrqKgo+6+SeuIpR3JAFfUHdoxNRSzlwVY+7Cb2Dmj7bHJxcoCwMENrO4mLzpf1bo1T002eTbdUq+X4W53xUXMjelwjDyoHSYsLqfKN4JXNLPgh5Wlnmng1PzL6tnfNQkoZAKTkeT6tekKCWcSktBakVQMYDIyW/EFH8KCR7Hqo+sIaWQHf2M=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(5660300002)(31686004)(2616005)(31696002)(508600001)(6512007)(8936002)(966005)(6486002)(36756003)(83380400001)(53546011)(186003)(26005)(6506007)(6666004)(2906002)(86362001)(38100700002)(6916009)(54906003)(316002)(4326008)(66946007)(66556008)(66476007)(8676002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?OGlLMi9oeXM2NEVkSGpnUXBWaVYvYU5SMGlKRit2NEdib2ZlYmI5WUpGaTls?=
 =?utf-8?B?YWRmK2o1c2ZFMHdBWlZ1b0RYSklhek01dHpmQTdhMmp4TWFvSTFSMGJCREZ3?=
 =?utf-8?B?UFlEQlFMVXNzWmtreHd4UFg5VkJGY2dnMUVuZWdIZ3ZGTVAvdFA0VWhOU3A1?=
 =?utf-8?B?WnN2L2tuK2RZTTlUaDFuWVJrd3I2VlZOQUdaczNuVEhHNjlBT1ZqR3pqeVVs?=
 =?utf-8?B?THRQV1VrcTZKRjNIVnhSZ0VHZ2JmUDZFd1FkWmZnZ25kaHJ3NEU3Ry81bEQ1?=
 =?utf-8?B?RktlVGZMOVVFRGI1dVdoMFVGMEFqS0ZLN1JkbzFaNkRUMlFBeXBERHZ2cjJt?=
 =?utf-8?B?ME5BcUJNbDB3UnBIQnZydTVucGJlY3cvNGpQcUlmMXhBeWV5WVdhc1dvRWMx?=
 =?utf-8?B?YkZNckhGUExrN3ZiUGt0L3JsUVhJeWwrMkkrcEROYVpueUZxOGZidzhIaFJ0?=
 =?utf-8?B?c2p0dU5US2V6a0hLL0ZqYktrSDhyamhWR3g5cEhpa281eDM5d1BuczJDZmNV?=
 =?utf-8?B?bzBOTXdnWS91UUVES3Y5ZTVLWXRKOTlzWG1YcGFBMG9NYXdlVkNUYTFaLzZr?=
 =?utf-8?B?RWUweEdXYU9pakZnemE1akt6cit1Nm9jR0lUYTkwRUh1MkdRUDNCMmNuNXA0?=
 =?utf-8?B?SVVrdlBYckxmQzB0R2U4OWttRGM1UTQ5WDJNbDlXdUlMZmxKNk5iQVNGZTA4?=
 =?utf-8?B?cE90ck5NUkpoQlVRUnJPak9GcTk4NVJkOS9HeEpuTzBXOHQySW0wcmZvd2My?=
 =?utf-8?B?NlI2WGFPdnBxaTBIT2I3dXgxbkE2Z2k5SGtpMk9YcktYMkJ2Y1VmRHg2Vy9H?=
 =?utf-8?B?SUpQYURWZHJScGwxcnRsWWpqeGxMV2RRRnE5cHNrTis2aUVnOWNsbCs2aW0z?=
 =?utf-8?B?YnBHbG5ZWDhsUURzdVhkYzJ2ZStYWExEYXY4em01Y2Z5ekl3NjROR1Nwd2FR?=
 =?utf-8?B?RmhINElsRjBpUWpuaDNlT3VMSVp2eVpRY0daTVppZUJVdnhDT2x0eEVyMlRr?=
 =?utf-8?B?OTRSbndMR3J1RC9DcllkZnIwR0FMNFdaS3liUXUrc3Z5VUZhUWFQSWZLamk0?=
 =?utf-8?B?TGNkNDJlSGpEYXY3ZUVHSWJHSmNpaWtyMGVxUlhwcXJRc0t0dlNUVGY1QTQ4?=
 =?utf-8?B?R2VBM1YveC9CbTQwSVhUaEFjNmNuR2R4K1BaUWJxaENieG1SNFJJMENycTVs?=
 =?utf-8?B?OTRnNEprUC9EVms0Wng3ZityR3ZMVnBMNmhqazNheE9RMWxhVmFPSTBSMkl2?=
 =?utf-8?B?TW5BVFVsY1YxNU1zRVptZXBHSUJIWUZqc0lvciszUFl1bmdkTDUycGw5dGc5?=
 =?utf-8?B?Tk84RGFNWENaSXdueW41ekF0QWtXU1hIZTFGUjRudW1qd0FqV0w4VG9kOEdN?=
 =?utf-8?B?T1kyWlhMNzAzWnYxaDNzZ3ZHdjZPL05UVCtWcE5ud3N4Yk5rK2NuN3YyQWFF?=
 =?utf-8?B?QTNIWWhPcVRpVTFWRzZuRlN4YkVyNTZvMExHUW5yS3BCV01pbnNlLzNWZmlW?=
 =?utf-8?B?R2c1MjhTWlBzQWZOSDEvZW1DNFpvcDFtRVJ5Q0NLVk9uUC9sekFzT1JHQ3A2?=
 =?utf-8?B?YWxXRy8wSGlKcjFJa0srcUhpZ1dZOUpsbzYwZ0pBamN4M252bmU3NExqQitJ?=
 =?utf-8?B?NFBZQzBSRGN4M1hMRDZtcEs2ZStNMTErOS80d3o0ZVRXblJCYndma2JSL1VV?=
 =?utf-8?B?TUZ4Rm9GMzN2SjFDV29QWWhYSjcxUGM3Tjc3MTdrTjFTcEU1L2RzRHQ4OVRr?=
 =?utf-8?B?SCsyNFRrYVlhcm5aLytDdGZuN2V3Qlk4MzFOWkJtQ3BlWVRjL0sydUdDdC9Q?=
 =?utf-8?B?U2x6NyttSU5xakl2cjFwdmtsMm5aeC9kQm91ck9MNVZYdDFTVXdlUi9yU3k0?=
 =?utf-8?B?UUtHMDVEc2NPNzZvWmpneTlCNCsyQ1lVT3ZZSEE4SXZxaUZ6WnNoMzV0NUp2?=
 =?utf-8?B?VmxoR0JVYWk2ZEhRT0xyemNyTmtIWW5nU2tWbWVRUGNEUHF3RjVieDVnc3Zz?=
 =?utf-8?B?VlJXZVkySVJ0RzU5K0dXSWNWT3NXSTk4bmFHTHB4VWpVckxsVW5KSHd0c0l0?=
 =?utf-8?B?QjYxT0tML2FGT09kNXFCb2VRNWZLbnluNXBPUnlqc3ZWelJUc2xnQytsdDZK?=
 =?utf-8?B?NEQ4OXpPRjdaTzNUS1VpY2hVdWlMWXZJdVM1VGdvWmJKZHNubUdnRDBMMDl0?=
 =?utf-8?B?UGhYenptdGNsQmk4Z2gwUmUyUjJOWVN4MVAzMytYVmM5bkJ1Vm5LU3BVZHM3?=
 =?utf-8?B?VE00Ykg3YjkxOS9CNU9wUVB5bVpRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b53e3918-43f0-432d-76ba-08d9ed5b51b3
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 12:37:52.2233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F8OXRC5rIiFmMrYPD+Re5LIdF7DjybgRyWXlFRVyGgN0GoGWSobsYqR3uEeqmQTYN/AUqccT67E+AG+uZOH/JatpNTqpTg7QaVT5h++t3/8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4311
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10254 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202110072
X-Proofpoint-GUID: 0TcfcDWQRszi0bT3zd4-CqeeQ9cql--f
X-Proofpoint-ORIG-GUID: 0TcfcDWQRszi0bT3zd4-CqeeQ9cql--f

On 2/11/22 08:03, Muchun Song wrote:
> On Fri, Feb 11, 2022 at 3:34 AM Joao Martins <joao.m.martins@oracle.com> wrote:
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
>> vmemmap_shift in which memmap metadata is created for and also to let
>> sparse-vmemmap fetch pgmap ranges to co-relate to a given section and pick
>> whether to just reuse tail pages from past onlined sections.
>>
>> While at it, fix the kdoc for @altmap for sparse_add_section().
>>
>> [*] https://lore.kernel.org/linux-mm/20210319092635.6214-1-osalvador@suse.de/
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> 
> Reviewed-by: Muchun Song <songmuchun@bytedance.com>

Thank you!
