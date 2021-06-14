Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D332FB8
	for <nvdimm@lists.linux.dev>; Mon, 14 Jun 2021 18:42:33 +0000 (UTC)
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15EIduQG071550;
	Mon, 14 Jun 2021 18:41:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=rGgz294hPoTaTqslCZ7SpGfxmMmudFEXQQ87O3Fo+zg=;
 b=g1fV7QrMw/jq+Ihvlt1XIarY76cb0Z1+35dSci9NAugVDrs1KTyQ3nRoOcZwZqllQYtE
 5BrQB9iO9DYi7o3EISOuHS7rT8SaM1KOKhdX+m3k07bLcQ9gFLQVVL17nKsonozkePer
 2+IUISidVXCGtIp2TXosu3zScH090Jjl7XkLtjT6uJmNFXYwFJ2PS+yEJSz6gJSwx7NK
 V/NpadW/bYhkaVWHKKbNr+Cto8kIbh5NmIvw1qFkPxzzr8+FhwSFfKnufyCOQstDxu+d
 WUSsJYpMoEJ9GNNUcNa/QD1QYv1yivSsoZ+/9Tw2oC4Lurn3+HAEhKHpBVTax1cAqw8N AA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2130.oracle.com with ESMTP id 394jeccb5c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jun 2021 18:41:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15EIZPga079122;
	Mon, 14 Jun 2021 18:41:54 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
	by userp3020.oracle.com with ESMTP id 395hk2m66w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jun 2021 18:41:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CaTjs0+nC/WBKiUEESutB/fRSeRQ1/2FBXty+UxXRdMiL+DZBV6/EU1vTzVzP4DAG+exnhkFta/v3rBqrfAChUQimmTE8Z5yfegf5ToPKANVQaGzvLef3KX9sf7zTE6jFF30OWq37SPT9oCYRy9Loc/t+PN+P4+H3+DKTdijpA4Bzc2XQCnizXcYyqmJYiK4bMLtukm5lXt6WXiJH7slhtZqkZ94vWprQ7HBPcW8iqJISMyCP2+XKNUFkskDFAhLBKh50tviPmg/dymp/qKZgh+xWPMae/NOZC+Out6vtPKwxoESClYjzTpNpZ1OlzZTfV2cAj2oC2fQ1byncIS+9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGgz294hPoTaTqslCZ7SpGfxmMmudFEXQQ87O3Fo+zg=;
 b=hNZO7hEOz7RN9sR2r6X7jPxRSDYLXlq5tsECnixu9OWFDObSHKdZYjwsGPUjiv+wsm+w4XRyg2VXHAM+E6tbcomZMYmmM6kB+2W4oTiW3Yk7WYrlC0MU2Io/alr6+m0e1QoJzZtqIKX1y6yGsho7BpAmhCIsG1utGvmZg/GWFpyE6nCQnA6Z4OfnwA0xa0Zc0ov+9SyA7HxB4QreDSD39TG/ESBcBjZE5GZFRKqw8R0ijc8+ngBYkr+9ILZe/nK8Yrvgvd4urlbIRvUHIKdPjn7bi5bdMoDnnjPnmH3v+215YsorU+7z/XUW8T0hkByGPTF8u88sk5D91DJJUX1XeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGgz294hPoTaTqslCZ7SpGfxmMmudFEXQQ87O3Fo+zg=;
 b=wMwEibgZXlQxZ2pxSoPUJa6RwkGAuMY74v8BKIbjkqOrDYUbMmx3n5JuHi/qD2VDBpxsQfnBkEMkIn01/qpBvj+fEe6dseDA/mpw84C9C7ORsR6OidwlAIFpxHehmC57qCuV/Un7doD8dZ99COQhuTXtUULYtmZdIwtiGkr//OI=
Authentication-Results: linux-foundation.org; dkim=none (message not signed)
 header.d=none;linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL0PR10MB3028.namprd10.prod.outlook.com (2603:10b6:208:77::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Mon, 14 Jun
 2021 18:41:52 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582%5]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 18:41:52 +0000
Subject: Re: [PATCH v1 09/11] mm/page_alloc: reuse tail struct pages for
 compound pagemaps
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux MM <linux-mm@kvack.org>, Linux NVDIMM <nvdimm@lists.linux.dev>,
        Ira Weiny <ira.weiny@intel.com>, Matthew Wilcox <willy@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20210325230938.30752-1-joao.m.martins@oracle.com>
 <20210325230938.30752-10-joao.m.martins@oracle.com>
 <CAPcyv4gtSqfmuAaX9cs63OvLkf-h4B_5fPiEnM9p9cqLZztXpg@mail.gmail.com>
 <840290bd-55cc-e77a-b13d-05c6fd361865@oracle.com>
 <CAPcyv4hJtqVGoA3ppCMfVQ4ZnWUa7jKtp=Huxu9mcSk4huq_7Q@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <0c6a4dab-296d-94b2-f885-2371292f9e0d@oracle.com>
Date: Mon, 14 Jun 2021 19:41:45 +0100
In-Reply-To: <CAPcyv4hJtqVGoA3ppCMfVQ4ZnWUa7jKtp=Huxu9mcSk4huq_7Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [94.61.1.144]
X-ClientProxiedBy: AM0PR02CA0217.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::24) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by AM0PR02CA0217.eurprd02.prod.outlook.com (2603:10a6:20b:28f::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22 via Frontend Transport; Mon, 14 Jun 2021 18:41:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aea1f4a6-5a95-4bf4-42d0-08d92f6413a3
X-MS-TrafficTypeDiagnostic: BL0PR10MB3028:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BL0PR10MB3028F4B604A460EA070B8F95BB319@BL0PR10MB3028.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	OTp/VnjwIYWtHF5rK5gmXZaMqwBNlZ0hfzrD8M35w9CFLymUk6LA7GgkliCMInLxixj0VtoHQCkWmj0SmwoVpleqf0xmfMbuqUw7Mo1IoOa/nHO6lZMyfRMuB4H8u/pPyoVSibLCP8NcjmYkpF4q25slotfwfIaVFGzRyUntYeSkoEQ+yvqFI8Z1QSf3JwepHejbL/iFMb6NZQnbrwgYctiBd51Z86KLFl7xmfWBdtqB5E0VtoQZPO5XInItG/rauv4HgZ7UTMymglvrMzY0pepkyopsJJhQD7CPFg0wUttewSEaoNIc+Pr03svQ7PLrlBqrT5Tw2j0MiWSn7lfT5pvJxSexdFJ/2IfGbmw9QU/PI7ejnxItwDPYF8ROlBz3BhrCkw3yoLsu9cSRj3tDySFaZQSAdf1ZIqhzZeb2HT3b7FWSQyQrkHFknWjt2KXzBkwipys0zA6GwPhxkcyijlNgjVQL5hyLtoBRh5j32YffFadNaovgq0kB1OeD7y12GzcmsgLCIT+/6FrOXhT5DkHjm6jZs34UeK09hozXJIun89WiD9aIJBO0molYq5g3X9vmpyTMW9Bk57lPjfyA/wru1bjFPppEX7ZKh6pVtcqJKTUALFe7iCDFGYXpSwdTu9O39WqN99A48N/JkVh914LqJKoM4/1snF4iT7yt05I=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(39860400002)(376002)(346002)(6486002)(66476007)(66556008)(316002)(186003)(16526019)(4326008)(66946007)(8936002)(36756003)(5660300002)(83380400001)(2616005)(31696002)(54906003)(956004)(38100700002)(8676002)(16576012)(31686004)(478600001)(53546011)(86362001)(26005)(2906002)(6916009)(6666004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?VzcwMVh5TFMyTDJ1aVV3eWNSRGsxM3Jydm5XcEIwUlg4MDRQSzdONHE5T1JN?=
 =?utf-8?B?eHhBdEFCSTllQWhQa3d4YkpscjV0SjdkbkpNZmtoakVHYXJWWDJrYmJTMmlE?=
 =?utf-8?B?UzJpU0poK1NobTdVZHVxOUNiQ1ppN1hDZEpFbmFMWUhteEhBK0JHWmZUczdj?=
 =?utf-8?B?eVRnYnNPZVdRbHRKR1pJRXdua3pqZGlpWEh3TkRNZVBNRVdhUzZPRkpsK3pk?=
 =?utf-8?B?VUdjV2pVa3hMcmpieENsbGRJeXlZdHVmT0RCOVphdUxUcTJYNWdBSnU1M1hs?=
 =?utf-8?B?dGxlRDNBL1lraXRqSjdZcjgyclErWllMZHVmMXRYTjNlRTBWSlRKL3pnclh2?=
 =?utf-8?B?NHNQWlFqWXRKSnExb0NJRTc1aTlvWkQwK1I4eGo4RFRVbU5QazZyWWtTUFQz?=
 =?utf-8?B?SGFJbUI2SWZwQUIxKzAxYUlWSEdWdjliSk51dktyaVIwSWJYM2VSNy9aTWdC?=
 =?utf-8?B?azlVMDZHSjFLc2lzczM4bWZJaThGQUh3dlVpWTgzVXlidGMzL3ZVSFFhYXRV?=
 =?utf-8?B?dnhUWncrSzlXYWVlRUw3T0g4bzNhSGZpenoydjNVQVZuZlEzeHZqME8vWDAr?=
 =?utf-8?B?ejVuWW9GbEx3Q3hvT253eWlXc3RmY0EyMlRvckRPMEdsODREVUlnN2RSaWE5?=
 =?utf-8?B?ZFk5djlIVFNKYTAycGZNYnhabVlQcHUrQXhJdk5BRWlEc0ZKY1BUdmwxMUVN?=
 =?utf-8?B?S1RNMURhT3hhS2tMOEY0dVgvWHd1UUNuR0JtU1NxRm1lS2ZlVjIweW82V05W?=
 =?utf-8?B?Z0hjUTBaTnhOcVVwZ3dYU0VsTUViSlRWdi9wUnhMR0U0dkV4SWo4S3d0bjFK?=
 =?utf-8?B?Q055dXVodW5WMUx5a1RFNDc0TllpZSswN2hWVi9LRmlsenE5SFZQUXRhVmlX?=
 =?utf-8?B?eUVZUmo3STFCSExIb0xCYmFteVVwK1gvb0FxV0dLdkdnSVJlQWVOU0Q0bko5?=
 =?utf-8?B?T0NoQUVLeVNOeTU2UkIrd1JIeUxERHFJMXozZ1RFVloyWlhxaWxZZnUzY1Zz?=
 =?utf-8?B?V1IvNm9hVVVSQzFPbUUyOWFXWkpUTFdJT3YvRWo2SDNFN1UwTkZiZVJESWtl?=
 =?utf-8?B?ZStFZTRBMW11TGREY0tWblRPY1lWNk9NY2E1QWpyVjNYeTczYXhXanNFbEFM?=
 =?utf-8?B?aEsyRFZicHJpOFgyQ0FvVWtxbkNuWWdrQXRXeEZCQkFWMnFyVENkZ1RmUkFW?=
 =?utf-8?B?RURXTnVNclFpSzFtc0Z2TVBHOUx5czBDaTNUMXpKTFpIcU1XTjhsczRLdVhQ?=
 =?utf-8?B?bGpJTGhjZXVNRlpyVlNFMVRDYUdjVU9XWmRZaHZTVTZRU1QzeTA0WXBRQm1Y?=
 =?utf-8?B?QXRaSk1kNDJRdFRFSE1aNi9sZ0FEUXhjUXhnNDZXcmxLOUpEKzlxMTlyc3cv?=
 =?utf-8?B?eDNaWTJpQkE2UDZ6OHIwU1FHajloUGhrc3F1VHJrZlo0eFFIeldoY2MvV0Fz?=
 =?utf-8?B?bElCMTVGd2VZSlEwa0srbWFHbkpVa1Zqcnh5V2xCT09zYkNMd09EL091cVM4?=
 =?utf-8?B?dEZuR3hzcnBPb3Z4YXZRSU9Sbm04c1RMVW1mNUxXUEN2dmlPbU9EdEREY3c3?=
 =?utf-8?B?aWRWSXR4NktaWS9heHlZWVp3VjF4UnNnMVpsT2Z3OWwyNVBidkNhNlB4SHRy?=
 =?utf-8?B?MHd2N0NVZVpRYjkrM3R1OFVGQVhNYnRWQThsTE5MWTFKQVM1NkVsS3pNaVc4?=
 =?utf-8?B?WnhqUXpDNWJueWdRc1E1V3FtUGp0blhES0xTNlJwWGw2NGNtN1RpcmtUYjlR?=
 =?utf-8?Q?2YMGe+b+pdKNDRTACOiws/V+GHqEX4+gWLD5jc4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aea1f4a6-5a95-4bf4-42d0-08d92f6413a3
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 18:41:52.4099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V0j1HNOWR3eUYNJA4R8ck10X2a+TsA0LFjrVN7IJ6A/GkM4+AjAdnyhLinkWKSoPy8cI4TO/rCS6CaSDmauOaQ7m6gJI+rM8KtfINC6sU6c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3028
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10015 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106140117
X-Proofpoint-ORIG-GUID: Vn2lLAxu97NuWuF_IU8fLrNk_bsiUysY
X-Proofpoint-GUID: Vn2lLAxu97NuWuF_IU8fLrNk_bsiUysY
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10015 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 phishscore=0
 bulkscore=0 clxscore=1015 mlxlogscore=999 adultscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106140117



On 6/7/21 8:32 PM, Dan Williams wrote:
> On Mon, Jun 7, 2021 at 6:49 AM Joao Martins <joao.m.martins@oracle.com> wrote:
> [..]
>>> Given all of the above I'm wondering if there should be a new
>>> "compound specific" flavor of this routine rather than trying to
>>> cleverly inter mingle the old path with the new. This is easier
>>> because you have already done the work in previous patches to break
>>> this into helpers. So just have memmap_init_zone_device() do it the
>>> "old" way and memmap_init_compound() handle all the tail page init +
>>> optimizations.
>>>
>> I can separate it out, should be easier to follow.
>>
>> Albeit just a note, I think memmap_init_compound() should be the new normal as metadata
>> more accurately represents what goes on the page tables. That's regardless of
>> vmemmap-based gains, and hence why my train of thought was to not separate it.
>>
>> After this series, all devmap pages where @geometry matches @align will have compound
>> pages be used instead. And we enable that in device-dax as first user (in the next patch).
>> altmap or not so far just differentiates on the uniqueness of struct pages as the former
>> doesn't reuse base pages that only contain tail pages and consequently makes us initialize
>> all tail struct pages.
> 
> I think combining the cases into a common central routine makes the
> code that much harder to maintain. A small duplication cost is worth
> it in my opinion to help readability / maintainability.
> 
I am addressing this comment and taking a step back. By just moving the tail page init to
memmap_init_compound() this gets a lot more readable. Albeit now I think having separate
top-level loops over pfns, doesn't bring much improvement there.

Here's what I have by moving just tails init to a separate routine. See your original
suggestion after the scissors mark. I have a slight inclination towards the first one, but
no really strong preference. Thoughts?

[...]

static void __ref memmap_init_compound(struct page *page, unsigned long pfn,
                                        unsigned long zone_idx, int nid,
                                        struct dev_pagemap *pgmap,
                                        unsigned long nr_pages)
{
        unsigned int order_align = order_base_2(nr_pages);
        unsigned long i;

        __SetPageHead(page);

        for (i = 1; i < nr_pages; i++) {
                __init_zone_device_page(page + i, pfn + i, zone_idx,
                                        nid, pgmap);
                prep_compound_tail(page, i);

                /*
                 * The first and second tail pages need to
                 * initialized first, hence the head page is
                 * prepared last.
                 */
                if (i == 2)
                        prep_compound_head(page, order_align);
        }
}

void __ref memmap_init_zone_device(struct zone *zone,
                                   unsigned long start_pfn,
                                   unsigned long nr_pages,
                                   struct dev_pagemap *pgmap)
{
        unsigned long pfn, end_pfn = start_pfn + nr_pages;
        struct pglist_data *pgdat = zone->zone_pgdat;
        struct vmem_altmap *altmap = pgmap_altmap(pgmap);
        unsigned long pfns_per_compound = pgmap_pfn_geometry(pgmap);
        unsigned long zone_idx = zone_idx(zone);
        unsigned long start = jiffies;
        int nid = pgdat->node_id;

        if (WARN_ON_ONCE(!pgmap || zone_idx(zone) != ZONE_DEVICE))
                return;

        /*
         * The call to memmap_init_zone should have already taken care
         * of the pages reserved for the memmap, so we can just jump to
         * the end of that region and start processing the device pages.
         */
        if (altmap) {
                start_pfn = altmap->base_pfn + vmem_altmap_offset(altmap);
                nr_pages = end_pfn - start_pfn;
        }

        for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
                struct page *page = pfn_to_page(pfn);

                __init_zone_device_page(page, pfn, zone_idx, nid, pgmap);

                if (pfns_per_compound == 1)
                        continue;

                memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
                                     pfns_per_compound);
        }

        pr_info("%s initialised %lu pages in %ums\n", __func__,
                nr_pages, jiffies_to_msecs(jiffies - start));
}


[...]

--->8-----
Whereas your original suggestion would look more like this:

[...]

static void __ref memmap_init_compound(unsigned long zone_idx, int nid,
                                        struct dev_pagemap *pgmap,
                                        unsigned long start_pfn,
                                        unsigned long end_pfn)
{
        unsigned long pfns_per_compound = pgmap_pfn_geometry(pgmap);
        unsigned int order_align = order_base_2(pfns_per_compound);
        unsigned long i;

        for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
                struct page *page = pfn_to_page(pfn);

                __init_zone_device_page(page, pfn, zone_idx, nid, pgmap);

                __SetPageHead(page);

                for (i = 1; i < pfns_per_compound; i++) {
                        __init_zone_device_page(page + i, pfn + i, zone_idx,
                                                nid, pgmap);
                        prep_compound_tail(page, i);

                        /*
                         * The first and second tail pages need to
                         * initialized first, hence the head page is
                         * prepared last.
                         */
                        if (i == 2)
                                prep_compound_head(page, order_align);
                }
        }
}

static void __ref memmap_init_base(unsigned long zone_idx, int nid,
                                         struct dev_pagemap *pgmap,
                                         unsigned long start_pfn,
                                         unsigned long end_pfn)
{
        for (pfn = start_pfn; pfn < end_pfn; pfn++) {
                struct page *page = pfn_to_page(pfn);

                __init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
        }
}

void __ref memmap_init_zone_device(struct zone *zone,
                                   unsigned long start_pfn,
                                   unsigned long nr_pages,
                                   struct dev_pagemap *pgmap)
{
        unsigned long pfn, end_pfn = start_pfn + nr_pages;
        struct pglist_data *pgdat = zone->zone_pgdat;
        struct vmem_altmap *altmap = pgmap_altmap(pgmap);
        bool compound = pgmap_geometry(pgmap) > PAGE_SIZE;
        unsigned long zone_idx = zone_idx(zone);
        unsigned long start = jiffies;
        int nid = pgdat->node_id;

        if (WARN_ON_ONCE(!pgmap || zone_idx(zone) != ZONE_DEVICE))
                return;

        /*
         * The call to memmap_init_zone should have already taken care
         * of the pages reserved for the memmap, so we can just jump to
         * the end of that region and start processing the device pages.
         */
        if (altmap) {
                start_pfn = altmap->base_pfn + vmem_altmap_offset(altmap);
                nr_pages = end_pfn - start_pfn;
        }

        if (compound)
                memmap_init_compound(zone_idx, nid, pgmap, start_pfn, end_pfn);
        else
                memmap_init_base(zone_idx, nid, pgmap, start_pfn, end_pfn);

        pr_info("%s initialised %lu pages in %ums\n", __func__,
                nr_pages, jiffies_to_msecs(jiffies - start));
}

