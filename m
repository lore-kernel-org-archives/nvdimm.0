Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813D672
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 12:52:37 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16FClnWd026116;
	Thu, 15 Jul 2021 12:52:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=jb6+K7sdFoL35/x8rIafEXc0rkthsH2B0Rl9MHzJSG4=;
 b=AcyaC6NmXsZcrqu8udbzCn1FvJR0u90LRATAkGdCuxIuSO9868G+OSLPqf2aylREbYWn
 f293oQ4U++aY2hAa2wCffm+QZ2GFvuTxMBS0Y9CGRt3j0vY3xY9XYGXcl7g0BaGffbQL
 Zv7nV8EKHVbyfciH71K1Vfn0Aa+e8OYk4OoQTkjjVMUh6Ih6eyIS9RShioJEsrQgJGFX
 dG4PBE/0mgJU6zFVd1ITqndtEBSnnG1PAdvPMW22wGg8uMm2+oeblr2XQp+upzytyjiz
 JD5fTnspHw5i+czaPYHuShY9+gGJA/0nsWN/SzYd/yluj9SIqCOKHEgjpaCd/T3T/Rkw Kw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=jb6+K7sdFoL35/x8rIafEXc0rkthsH2B0Rl9MHzJSG4=;
 b=FT6S5KQHgwXeSgRQ4OpzJhKctHwXzrr0V1O3e2WhnhPB+tgl0B1XK+uZTW4kVwPhtPWt
 Ilifv8OeJpDbZvhWKV5Ba0nwabBLNSB9iX2nEXmNyMvEa2qo+qCkpuhEo1Wws7VCaTzL
 QKUVjtp28KZvG/jh9HoywAyrOhBCe/WPnaTREiQctoBp4zELDX04PWfI5i6xdSQ649aJ
 tsVL5XACuWMs+4/LfiIsZlTslJIuZaFQ8a6jEIKRWeGkZZBv/GMciv4XhP5iGIWI4kZE
 OGGIqMIQ4wmXZk0BgdsNeEOTTWHwTzPB2e65GDMz01afOWQwviAMbORabAKimC8K2IY0 MQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 39tg510mu7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jul 2021 12:52:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16FCj2CO072321;
	Thu, 15 Jul 2021 12:52:29 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2040.outbound.protection.outlook.com [104.47.74.40])
	by userp3020.oracle.com with ESMTP id 39qnb5jq0e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jul 2021 12:52:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nC4ofuTnoiQ6UNvxzjqnkiiUydJUdAYM0DdrfPYtMBUq9R7lqCOUzcmD9YYdrxtbpGhrPT/LTeh+MBvvH/2+uxaVH4ZZuCl40R3IPs7yukgnq4bJpI9AT92aLXt3fAk5W5VQT3etdKQYtswhNBBy5QWhCj8mi/Rc9Jdy30ECYwldzpr3Zrcn+QQsbJeJSte4LPsTL4ZOOTznwFZd9KmQfevFWMpAINb3gjLyzvu0bUOMzq27N6YMSMU9bO868kkDxTm/+bodstJnnld3nwcbNpCPyKD1HVzqJnS5iF1T147VETlxoCXBVVgRGO9fAwmexJbHdgvDRJAU2qtJ7nqZeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jb6+K7sdFoL35/x8rIafEXc0rkthsH2B0Rl9MHzJSG4=;
 b=VADld//KpbQyeiwPoRWw+gih8JW4vOE8AWN2qPGVlatzbLQTSbGn3Z6dzH1JEJK6ZjgpLJ5uqdFip2xtZvUiAjkP6xYxWxlouC8BCURNkdg1grkZL/PtN+ih+r2CRX+AYx6yFnKVjENU2B0a+3Ktm7D/ovWhTEdVphG8um32NAbf0iVMYvUkJkkzzVE5Qgjjs9xZce4VfxQhZ6UrtPyMFGaPpmL4zhedI73vQMuRuOqAWZfRY7Yms9pp+RYFlULhfihNiHr8gEsWtc+/VoePimMRxtubLL86e8KXzLYVfXaCoJ7eP0Ul2e3pFmo2sug7wsoBTwSCVR3NAUOb2Ilfzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jb6+K7sdFoL35/x8rIafEXc0rkthsH2B0Rl9MHzJSG4=;
 b=bMf1Kf6314YMGG/W/vmhejvmAxUNiMKkx98MrO/0vZAfCe/vF/s9dWrPxL7cq9Z11n8Un3LLZz9BeOWVrlUA2SBTKithBUtkQCg/h6xjyh4jfeg7i9K6krncd7vCfsghtgcpIc5rrOz5j9S55thHF9QXhMeEZszJOIvzZpylu/I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4286.namprd10.prod.outlook.com (2603:10b6:208:1d6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22; Thu, 15 Jul
 2021 12:52:27 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4331.024; Thu, 15 Jul 2021
 12:52:27 +0000
Subject: Re: [PATCH v3 04/14] mm/memremap: add ZONE_DEVICE support for
 compound pages
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
 <20210714193542.21857-5-joao.m.martins@oracle.com>
 <CAPcyv4jwd_dzTH1H+cbiKqfK5=Xaa9JY=EVKHhPbjicVZA-URQ@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <d73793a8-7540-c473-0e30-0880341c2baf@oracle.com>
Date: Thu, 15 Jul 2021 13:52:20 +0100
In-Reply-To: <CAPcyv4jwd_dzTH1H+cbiKqfK5=Xaa9JY=EVKHhPbjicVZA-URQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR07CA0090.eurprd07.prod.outlook.com
 (2603:10a6:207:6::24) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by AM3PR07CA0090.eurprd07.prod.outlook.com (2603:10a6:207:6::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.10 via Frontend Transport; Thu, 15 Jul 2021 12:52:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4fdac4f-2bef-48b2-02b5-08d9478f6625
X-MS-TrafficTypeDiagnostic: MN2PR10MB4286:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB42863F37E1CCFFA756173110BB129@MN2PR10MB4286.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	XeaYQQIxpdrO0roh8LioWbRcEPD1feJaEfO+vWzccPz2WokN1891a2w9M5eMULezn6CusyubUGg0KpKi29DWESG9k5cKtPPXSM9+UOe/UVtJi4ca5d5XiIohyCfEAcZiVeO3CFq31UgqCMwOhxUqovVe0pqNAJnYGac2BBYB3v/8xCjbGRZDpAM0Y1TECdsURyUsGSATPdDuk8gtbAP8+AUIZ8/+KDzyB3ixyzF0tSG6LguE5USKsHZYd4CR5Fycn/JRxJf1RHt/ROziMd/5JfIQz9HsAu4HGJOwnPho9SAyDlvyXh6dmBVifRXQUasZkxPQeqf7VbY8VGpb0rpoUW3uusuF50XJQmOGe8GB8cGNuD78e9jWXldhiFMR4eIXd8KPdc5qMkuVq0Y5wyvm9qTMOdxleDCW5+o/hkXcjx4d7hmkUXbJ8zivn0wOJJNq00sPiN6903v0uc7LPVH+82M0oiNWDIbUJcqrxW6ZUD5/6ayKNb3Zvr9xkTqIwki/abSPoMCikLKZm+C7SirLGrzRKqhEcrdsNwrioyhXemwohxS6EtWdWzgbuBi0yZwDVyUs8YxypQc85Zo6YMw3nHhZ1wrHrezsn33bKhVF68BCVNc52oxMIG4DBc6SoaDUMu2ieuJTFeao9k3S5KgST6RlOdg2udl2nI5uGV2yMaac/e5sThmdGCnqfVWM1rsvdFZFerbSYZmI5GWQhYJ86Q==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(376002)(346002)(366004)(53546011)(6916009)(4326008)(83380400001)(5660300002)(66476007)(66556008)(8936002)(8676002)(7416002)(186003)(2616005)(36756003)(31686004)(6666004)(54906003)(38100700002)(316002)(2906002)(6486002)(956004)(16576012)(478600001)(26005)(31696002)(66946007)(86362001)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Q2xMalpTVGRpZzU0V2FYc1duckx3ZU9HZHJaUVpHSTVmNTc1T2dKUTFVWWRT?=
 =?utf-8?B?MDhnTldDcW5NaWp1SVFxSSs0NVNvWGNaeEhSRStEVDl3Y2xGenpSZmZnaCtO?=
 =?utf-8?B?M1VHdzFTbmpUeU1UOWJNd2lsdzZLdFArNGYzaFVQR2xReEdUSzcwUGdRT25j?=
 =?utf-8?B?OVhMVUplckFVQTg1QXBMTDQwUTJ5Z3dONUFRYVVqZlRqTy95S0NrT1llWEph?=
 =?utf-8?B?RXhRRHZyUDhxdjJYbVgwOGMyNEVzWFhrempLL21yZ25aQlY4aXh3dmJvTW9J?=
 =?utf-8?B?TjNhTEtJRXQvcWhYdnV4N20ySHExczI3ZitjeEc5eW1LNW1WazZRRFVvditF?=
 =?utf-8?B?VVlxVktpVE8yRkEySHlqVEhTMDFLMFc3c3NLT0NaTEFjV2lWZTZlVjhCQ0lp?=
 =?utf-8?B?NTh5Snk4OUVPczM0dU5YSnhuSnp0RGRCRW1qUGVFWkRTQ0E0cHR2SGFnVXpF?=
 =?utf-8?B?NHYyTTM3bDZLRzk1N3hZZFBEUi9Ycyttc3F1ZXlmNEtqRTZCUEFwYlEyaDcy?=
 =?utf-8?B?WGd3ZFo5OVdialgyYTQveXlZQmY3YVJGTWlLQXZsdzZBRkR6ZDUwVEh6TnEz?=
 =?utf-8?B?U0lIWXZBamtZL0J2U0hEdTRPOVFxQjNZWmpKMDVHSXR5bHRybEZxS29XL3RV?=
 =?utf-8?B?YTk0TjJjcFdscGFXS2N0Ty9mUkMvOXZUS2l0ZUhlRlZGRXBlcy9kZVdkK1lq?=
 =?utf-8?B?U0hTQ0dzR21iYU50ZTJjTnRpV1oreFc3TEhFUmZ1QmlFWXQ4ZzhCZjdSTG5W?=
 =?utf-8?B?QjRwNzNWRzR1Q3EvWFZEV01uRzJzMlJCQTFJMERMMTBWR0FWdVlTKy9uZnBl?=
 =?utf-8?B?MFJPajBzV1V4UEVEQWpJd00vcXFaSUp6ZXM3WEZBVjBFMGhPV2ZyVzNXakpl?=
 =?utf-8?B?UnpFMVlveGNmTEdzZFVkdWhTWFRuSHJwVVAvMVJMNVRqczNRdmhNaHE2dTh0?=
 =?utf-8?B?SjFIbjRScXNEb0lnSHBRL1h5Yy8yRXJVZkpTbkNjVWhtMUVwYmFKekpISEZK?=
 =?utf-8?B?ZUZLRDdEQlFDQkpNdGhhN1F6bzVzeGlwc1FMMU8rSmtuQ2IyeGRObzhzT3JY?=
 =?utf-8?B?dDQwK2NaVTJ5NFNWa1NodDljRmFmdWJUYldaM05DWmc0cSsxZE00Rk1oVkd3?=
 =?utf-8?B?WVpmVWtTTEJkNTJGS2Uwa2d1T3cveEM4V2s0NmNXeFI5N0YrUTQxeVFQK1BD?=
 =?utf-8?B?ODFLbUt6djk0THlveTdBcWlreEtxT3YwbFlxRmtOc1lYZWNucWZacnBVMHlP?=
 =?utf-8?B?OGltMkpBSG4zVjRVTkJrTzFZcE1xMW5yZDkzbERQd0doR0tFUjBMWHZ6a01k?=
 =?utf-8?B?T01kUFIzcW1EV0xUV1BLa3kxYWlRalduL0I4TEtWRlZYZU5FUTJZcXVDY0Yr?=
 =?utf-8?B?UVUxS1R5K0w3YlJRVG83ajJLemg2RklFNURtKzhnRm93VFhyTllNWU5BWUsv?=
 =?utf-8?B?TW5JS25URjJKMExxK2ZPVG9OZmgxWjNFeUI0UWN0TEs1bEkzRDNmUzdBMnds?=
 =?utf-8?B?VEVzd0MzTXJMWGZCRHpLVlZDU3Y1a01aN0ZDRG16dWNPeG54aG5lVVRaNFl1?=
 =?utf-8?B?SVZCZ3F4ZXNTTUdMQklDSlRnYjlQRDBsWFdxS0loTm9Ud3lIalRDbGNSV0Mz?=
 =?utf-8?B?ZVZ2SzFFOEtlSEZ6b051bnliOU85SERyRGZqZmx2YVd1eDg3SE43QmJJek1a?=
 =?utf-8?B?azM5b3B6V1ZzcUFyenoyU2IraURDMXhQUUlqRTF2RjlTT3pOVXBwR3JyUmhy?=
 =?utf-8?Q?y/pptVqo6Hvr8SSncFGbq3Xk8LXqJgqThWVYRLp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4fdac4f-2bef-48b2-02b5-08d9478f6625
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 12:52:27.0497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rMVUWZhYpfL5yVxb5Sz80QTroFSdBSUI8Iumkecxq9t4rxCxiQY23kqaRdPQhDuTbMZ2hLx/45bEKCZXl0hL6pUa8PhjgwUxBYLe89Z80d4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4286
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107150092
X-Proofpoint-GUID: K8mNQshZhPrQgA4TtYzPDpDAzbYJ9HWu
X-Proofpoint-ORIG-GUID: K8mNQshZhPrQgA4TtYzPDpDAzbYJ9HWu



On 7/15/21 2:08 AM, Dan Williams wrote:
> On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> Add a new align property for struct dev_pagemap which specifies that a
> 
> s/align/@geometry/
> 
Yeap, updated.

>> pagemap is composed of a set of compound pages of size @align,
> 
> s/@align/@geometry/
> 
Yeap, updated.

>> instead of
>> base pages. When a compound page geometry is requested, all but the first
>> page are initialised as tail pages instead of order-0 pages.
>>
>> For certain ZONE_DEVICE users like device-dax which have a fixed page size,
>> this creates an opportunity to optimize GUP and GUP-fast walkers, treating
>> it the same way as THP or hugetlb pages.
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>  include/linux/memremap.h | 17 +++++++++++++++++
>>  mm/memremap.c            |  8 ++++++--
>>  mm/page_alloc.c          | 34 +++++++++++++++++++++++++++++++++-
>>  3 files changed, 56 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
>> index 119f130ef8f1..e5ab6d4525c1 100644
>> --- a/include/linux/memremap.h
>> +++ b/include/linux/memremap.h
>> @@ -99,6 +99,10 @@ struct dev_pagemap_ops {
>>   * @done: completion for @internal_ref
>>   * @type: memory type: see MEMORY_* in memory_hotplug.h
>>   * @flags: PGMAP_* flags to specify defailed behavior
>> + * @geometry: structural definition of how the vmemmap metadata is populated.
>> + *     A zero or PAGE_SIZE defaults to using base pages as the memmap metadata
>> + *     representation. A bigger value but also multiple of PAGE_SIZE will set
>> + *     up compound struct pages representative of the requested geometry size.
>>   * @ops: method table
>>   * @owner: an opaque pointer identifying the entity that manages this
>>   *     instance.  Used by various helpers to make sure that no
>> @@ -114,6 +118,7 @@ struct dev_pagemap {
>>         struct completion done;
>>         enum memory_type type;
>>         unsigned int flags;
>> +       unsigned long geometry;
>>         const struct dev_pagemap_ops *ops;
>>         void *owner;
>>         int nr_range;
>> @@ -130,6 +135,18 @@ static inline struct vmem_altmap *pgmap_altmap(struct dev_pagemap *pgmap)
>>         return NULL;
>>  }
>>
>> +static inline unsigned long pgmap_geometry(struct dev_pagemap *pgmap)
>> +{
>> +       if (!pgmap || !pgmap->geometry)
>> +               return PAGE_SIZE;
>> +       return pgmap->geometry;
>> +}
>> +
>> +static inline unsigned long pgmap_pfn_geometry(struct dev_pagemap *pgmap)
>> +{
>> +       return PHYS_PFN(pgmap_geometry(pgmap));
>> +}
> 
> Are both needed? Maybe just have ->geometry natively be in nr_pages
> units directly, because pgmap_pfn_geometry() makes it confusing
> whether it's a geometry of the pfn or the geometry of the pgmap.
> 
I use pgmap_geometry() largelly when we manipulate memmap in sparse-vmemmap code, as we
deal with addresses/offsets/subsection-size. While using pgmap_pfn_geometry for code that
deals with PFN initialization. For this patch I could remove the confusion.

And actually maybe I can just store the pgmap_geometry() value in bytes locally in
vmemmap_populate_compound_pages() and we can remove this extra helper.

>> +
>>  #ifdef CONFIG_ZONE_DEVICE
>>  bool pfn_zone_device_reserved(unsigned long pfn);
>>  void *memremap_pages(struct dev_pagemap *pgmap, int nid);
>> diff --git a/mm/memremap.c b/mm/memremap.c
>> index 805d761740c4..ffcb924eb6a5 100644
>> --- a/mm/memremap.c
>> +++ b/mm/memremap.c
>> @@ -318,8 +318,12 @@ static int pagemap_range(struct dev_pagemap *pgmap, struct mhp_params *params,
>>         memmap_init_zone_device(&NODE_DATA(nid)->node_zones[ZONE_DEVICE],
>>                                 PHYS_PFN(range->start),
>>                                 PHYS_PFN(range_len(range)), pgmap);
>> -       percpu_ref_get_many(pgmap->ref, pfn_end(pgmap, range_id)
>> -                       - pfn_first(pgmap, range_id));
>> +       if (pgmap_geometry(pgmap) > PAGE_SIZE)
> 
> This would become
> 
> if (pgmap_geometry(pgmap) > 1)
> 
>> +               percpu_ref_get_many(pgmap->ref, (pfn_end(pgmap, range_id)
>> +                       - pfn_first(pgmap, range_id)) / pgmap_pfn_geometry(pgmap));
> 
> ...and this would be pgmap_geometry()
> 
>> +       else
>> +               percpu_ref_get_many(pgmap->ref, pfn_end(pgmap, range_id)
>> +                               - pfn_first(pgmap, range_id));
>>         return 0;
>>
Let me adjust accordingly.

>>  err_add_memory:
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 79f3b38afeca..188cb5f8c308 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -6597,6 +6597,31 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>>         }
>>  }
>>
>> +static void __ref memmap_init_compound(struct page *page, unsigned long pfn,
> 
> I'd feel better if @page was renamed @head... more below:
> 
Oh yeah -- definitely more readable.

>> +                                       unsigned long zone_idx, int nid,
>> +                                       struct dev_pagemap *pgmap,
>> +                                       unsigned long nr_pages)
>> +{
>> +       unsigned int order_align = order_base_2(nr_pages);
>> +       unsigned long i;
>> +
>> +       __SetPageHead(page);
>> +
>> +       for (i = 1; i < nr_pages; i++) {
> 
> The switch of loop styles is jarring. I.e. the switch from
> memmap_init_zone_device() that is using pfn, end_pfn, and a local
> 'struct page *' variable to this helper using pfn + i and a mix of
> helpers (__init_zone_device_page,  prep_compound_tail) that have
> different expectations of head page + tail_idx and current page.
> 
> I.e. this reads more obviously correct to me, but maybe I'm just in
> the wrong headspace:
> 
>         for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
>                 struct page *page = pfn_to_page(pfn);
> 
>                 __init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
>                 prep_compound_tail(head, pfn - head_pfn);
> 
Personally -- and I am dubious given I have been staring at this code -- I find that what
I wrote a little better as it follows more what compound page initialization does. Like
it's easier for me to read that I am initializing a number of tail pages and a head page
(for a known geometry size).

Additionally, it's unnecessary (and a tiny ineficient?) to keep doing pfn_to_page(pfn)
provided ZONE_DEVICE requires SPARSEMEM_VMEMMAP and so your page pointers are all
contiguous and so for any given PFN we can avoid having deref vmemmap vaddrs back and
forth. Which is the second reason I pass a page, and iterate over its tails based on a
head page pointer. But I was at too minds when writing this, so if the there's no added
inefficiency I can rewrite like the above.

>> +               __init_zone_device_page(page + i, pfn + i, zone_idx,
>> +                                       nid, pgmap);
>> +               prep_compound_tail(page, i);
>> +
>> +               /*
>> +                * The first and second tail pages need to
>> +                * initialized first, hence the head page is
>> +                * prepared last.
> 
> I'd change this comment to say why rather than restate what can be
> gleaned from the code. It's actually not clear to me why this order is
> necessary.
> 
So the first tail page stores mapcount_ptr and compound order, and the
second tail page stores pincount_ptr. prep_compound_head() does this:

	set_compound_order(page, order);
	atomic_set(compound_mapcount_ptr(page), -1);
	if (hpage_pincount_available(page))
		atomic_set(compound_pincount_ptr(page), 0);

So we need those tail pages initialized first prior to initializing the head.

I can expand the comment above to make it clear why we need first and second tail pages.

>> +                */
>> +               if (i == 2)
>> +                       prep_compound_head(page, order_align);
>> +       }
>> +}
>> +
>>  void __ref memmap_init_zone_device(struct zone *zone,
>>                                    unsigned long start_pfn,
>>                                    unsigned long nr_pages,
>> @@ -6605,6 +6630,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
>>         unsigned long pfn, end_pfn = start_pfn + nr_pages;
>>         struct pglist_data *pgdat = zone->zone_pgdat;
>>         struct vmem_altmap *altmap = pgmap_altmap(pgmap);
>> +       unsigned int pfns_per_compound = pgmap_pfn_geometry(pgmap);
>>         unsigned long zone_idx = zone_idx(zone);
>>         unsigned long start = jiffies;
>>         int nid = pgdat->node_id;
>> @@ -6622,10 +6648,16 @@ void __ref memmap_init_zone_device(struct zone *zone,
>>                 nr_pages = end_pfn - start_pfn;
>>         }
>>
>> -       for (pfn = start_pfn; pfn < end_pfn; pfn++) {
>> +       for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
>>                 struct page *page = pfn_to_page(pfn);
>>
>>                 __init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
>> +
>> +               if (pfns_per_compound == 1)
>> +                       continue;
>> +
>> +               memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
>> +                                    pfns_per_compound);
> 
> I otherwise don't see anything broken with this patch, so feel free to include:
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> 
> ...on the resend with the fixups.
> 
Thanks.

I will wait whether you still want to retain the tag provided the implied changes
fixing the failure you reported.
