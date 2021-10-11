Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C08072
	for <nvdimm@lists.linux.dev>; Mon, 11 Oct 2021 15:54:05 +0000 (UTC)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19BFlNCF004397;
	Mon, 11 Oct 2021 15:53:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=6O39QZ1WioSKUv4y8wxG00KOKIz6vagdHZdwBTh9inc=;
 b=f/u7ZokBlfEpfNcLmr2VVsdpK7fi9pTLRpR8qeWccIIJ7qLaLXjE8ifVC2b/ZZMqDCQO
 FzGWm47Ytqhsuq99PXXd+FJoWBy7ol2VNyhQvbIVSy+QnxRPmhqAu+4zeZ5bnRk6zJue
 DbIq11RscmKB0m/3AvpmF2p8UegUCFNT9LNcf73wI30tBtlv+VVU54BnCSlBUHnKMJUR
 QXIvnnBeewJo9W2SyOA/ji/wVGavkFzJXHdRlNVEcGbhMr/669ovHile3D67La/u+cxx
 h2r2/OxtcYrxd8WDZMSB/m+ISVjQ9NpF2fQmVHvmAiyGOv2N5B/xP2P3NCpIiu00xuKS bg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bmq3b8j54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Oct 2021 15:53:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19BFoKfs042664;
	Mon, 11 Oct 2021 15:53:39 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
	by aserp3030.oracle.com with ESMTP id 3bkyxq4q82-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Oct 2021 15:53:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GGDgoikHVGJUcFYQxXnjKlPwJXeq4SV2julEdoH12V2tnh5XSmlFRPMeQnMEe/EynVc9ZwCGzPt9k3mSD/sV8jGClHpy5QFm9PT/kUOoewCxqXuWfKuUUHWBu7VdKH92mthUU81Oob1THifbA+9uADN+Jtr8aa3h7PfrD+ykfCj0znlmJmgrIoR9CLQb0X8V9rrxc7WXoH3MnRc15ylfIvesMpiXM2QHgYtsWLIhi2qj2A5UAOmHYWxGoIRpz3ikRassSJ61MUbB8o2wvqWaIzGH3cl2mCKUcjZ7Xwccrg86mAcgBWt2Pgl7ZSUDj+y+CquNAtxDzUAxdk4HK51+QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6O39QZ1WioSKUv4y8wxG00KOKIz6vagdHZdwBTh9inc=;
 b=Deb2Yc6JUmGHIUfOPJWuRzoyM+Hvgn+gEBwSJF21FHiihqxULb51k/TQYgsv3lWuC7S3Ki5wt2kN7aBZY0EbeyyglbpUgQLu8QtJbrYUm/HF9lBF2t791Mgd+t0lxrOfS4I9d6otjiAFDrfBhH1gBVVl6q5qUJK0MSZMV/NcBys7j0/n49Z2onHRxrVlqIi2cfqcV1JTewWFZQXLUI8XR0aYAsP0GD7SRmUqS7wPJzolWp5NPf5nlDprAY2gTlNbURVc6IDTXmooE41xwehxtVnnDE0J4GkMe+PBcvvfPP4nvomUJ3gw7A2vzZNmmNUSX6VTjKswdd/iR/b70bsmuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6O39QZ1WioSKUv4y8wxG00KOKIz6vagdHZdwBTh9inc=;
 b=WQfNR32EsC4eC40UwFa7dHFIuKSi7T5wL6AFFP3mADGNrI3r8eV42J8Mp+F3AkJQpwwEhdHUi7qUOha+ixY8xOpfsSsMHDZ5kAbXBM0l0a90mpu+mNnEf+NHJ8F1046GFYMKdLtbDeVhHuhPNC8CuA3iQ3mHxHK1Kb4s/fTZqZ4=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL0PR10MB3028.namprd10.prod.outlook.com (2603:10b6:208:77::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Mon, 11 Oct
 2021 15:53:37 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 15:53:37 +0000
Message-ID: <01bf81a4-04f0-2ca3-0391-fceb1e557174@oracle.com>
Date: Mon, 11 Oct 2021 16:53:29 +0100
Subject: Re: [PATCH v4 08/14] mm/gup: grab head page refcount once for group
 of subpages
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
References: <20210827145819.16471-1-joao.m.martins@oracle.com>
 <20210827145819.16471-9-joao.m.martins@oracle.com>
 <20211008115448.GA2976530@nvidia.com>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20211008115448.GA2976530@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0103.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.209.41] (138.3.204.41) by LO2P265CA0103.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:c::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend Transport; Mon, 11 Oct 2021 15:53:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 741c65e3-ec0c-4ff7-74b3-08d98ccf49b2
X-MS-TrafficTypeDiagnostic: BL0PR10MB3028:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BL0PR10MB3028E6D2ADEB5CDB05B14BA3BBB59@BL0PR10MB3028.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	kq15AP7ZSl92FgOgf3T6HHldcX1xKVLedPqwa/2Crcai9q4r2jWjXrGazRsIo1iYxozyv1pNdABaaLb4BdNeiH9hywtAunl/JELbstn8SEug/afV1wRwoeFOFUfPYpOfBgQVETHyODZl8khL3nJZcSrVgh+BnMZrz3wrsbDwidzKyHGmiIPnUcnLw0PnVaIaygYF8om1DDliJprGJI9MgT3D5zJbkyIQGM2qQ6rlK7D+rXDN90MPorhbE3DGUNADUUnqXutQPgf+WBVcZyLqur4UA9rWBjiMb1jdgexE8R5MiBuxTjtqsQ4fJMRrJiRsCevut4+SSscbgavg3pNu3cws3bLGhjphw32neEsP+ssGzmEz8XqMtei4a7lzodl1tVwW/vp8lCQ2DqKlW5KClWQA7NKkr5YAxa5GNO0C3sDA1E0VliUUHdGhKyU4zXjh1aJ2J3SQceJ5+sndirTBkhS6EOiCsElBJeBFXgsbz0fXeTbIqttZFGcy89mAzUsD4i6yo8xsr9HF2dlPLXboMN5wYCKldLClTWgrRdbmf5mfWMjUWo2PWaE0/qwZ8DFS8CZHlHAqYQbkp8hq0gEBpImiTRx1EiRwru0VizYIAWpCydDlsf299TOWPmr4PBNs7ES9utmKBFPaa8TgQhjhlVJN135+SzO6iSOFADJtLIifIK0IFt7NMV9uLiV2mhdLqAdGq1YvJnxBsYQre1myNg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(7416002)(5660300002)(4326008)(26005)(508600001)(956004)(2616005)(31686004)(36756003)(6916009)(53546011)(8676002)(8936002)(16576012)(54906003)(38100700002)(83380400001)(31696002)(6486002)(66556008)(66476007)(2906002)(316002)(186003)(86362001)(66946007)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?WXBiTWpCRnNhY2JpUkRoMjJQbE5td2R1NHVteG9ocnVJVmxQNnZBdlhFTURT?=
 =?utf-8?B?RGl4TmF0SHpCa1BmMkhHa3ZmWmlnQU9wV2dya3hia2t2bENNTDFzTlF5SU5p?=
 =?utf-8?B?UzBKQU56WUIrVk56ZGVDWUowTjFJVlBlRk0wSTg0L0p6MTYrYWdaOEFnaDVt?=
 =?utf-8?B?MHpiV0NPazdRYSs2L2lwOUNzSHVMMDNvYTNySXlHZC9Ub0o1dXQvWWRJNkJj?=
 =?utf-8?B?N3V5MTZPTnhpdjFWamRVaU0rMFlOcEpVQlB4b2sxdHpjaUVERWpNSG4wS05H?=
 =?utf-8?B?WFRlT21rNWlwYXNtQ0FaZU1vMDU4cjcveCt6a1A0NDRXRlNrOVd5Sm9OL3hH?=
 =?utf-8?B?K1FLWUg0U3RIZHdhZHBYT2srcXczSFFCMVBxZ2F1d2d5NVBzanlCM2dOOVBx?=
 =?utf-8?B?bXpXZDBSMFhNcHlZS1pOeXh0SFAxaWFwcVRWeENOeDltMTVlN1F3U2JpV0tP?=
 =?utf-8?B?ZjZjOWZ3WjBSeGFZT0NXS3hwWElBZHVKdFppNStRZ1NVNGJadEg0NFg5OHdx?=
 =?utf-8?B?YlljK0VseW5kcWg1Y3JPZFZiTXNuQVZDNU90MTRRa0h0T2JXL3NQZHE4aWx4?=
 =?utf-8?B?aWZlc0JOeSt2N3FRcnh0eTRCRE9NMnVhQ2NlWU9WckJ3ZDhlM2VrakJUdGpn?=
 =?utf-8?B?NmZneXJjU29kSkFpS2t1aEdWMmx0bUp0ekpYeGYrRzFvNDZlUExHbEw4L09u?=
 =?utf-8?B?aXg3ZFdvVm5kU0Ira1o1SU5mUm5yNE1nVUJFVlBObE5sSlUyRjY1TkI3d0xu?=
 =?utf-8?B?YUdqMjBZR293dzIyMDl3WWlRNjJvL2pENTJhZVB3dTVVTDZod3BqSDRyV2Vi?=
 =?utf-8?B?UnYwNFA2ZDVsa2dOdG1OZElaa3VnSEJxc1VRYk9VbDY0dVQxNFlZWjY0a1hQ?=
 =?utf-8?B?aWt4dEtab1JjR2doUVlFbVdXajR2ZFlSN3dUNWN6L2p0ZW4vUldYMjNQcEsz?=
 =?utf-8?B?YXdKZ1hxVktmTURVNVYvMm5zWHlmNkVITEpCNy90T0dnbEkwbmN3bEhGb1hn?=
 =?utf-8?B?VUtEL2tqNFBEUVorOVRWSWVjWjYwY0ovSEFJVUF4c20rSmdWZ1JSOWtURWg5?=
 =?utf-8?B?UGl1amhjMU44MUxjdFU0V1FMaWVZU0FPNzlNRitjNjZsNEVWUk1BUzZVNHBm?=
 =?utf-8?B?SXRHUEp0dXR0emIreXBwM2xIMDUrcndrSFhud3RxMlBydTBEc2xsYjFOR2U0?=
 =?utf-8?B?bjF6UUE4U213QUI5cGNLQzdHRmRGV3Ryekx2d0NUbkJhc1UzV0pDU0tFSmRx?=
 =?utf-8?B?S0VJdGgxcHV3dlpGbjMrL1pkUmtJb0kxbGVMOHNleXZTbGtBZ0kyVkh3MmhE?=
 =?utf-8?B?UjAxTkNSRzU2L3dJeTZGai9OY2Vza0grMTA1OG1wWHVWaXhIL3FTcWlDMllY?=
 =?utf-8?B?bDBFVTdCQldkS05nTlBYQ3pZMDlpa1B3MFM4R2xadFl0MGxFdEFPSGdweEll?=
 =?utf-8?B?T2ZxdW5vNTJjbHczTS81U08zaU9jdnRsSXc4MWhJaUdZNHQrSy9YYlhQSlU1?=
 =?utf-8?B?TXRrbEgrdnR5NHk3Tnp1cmFjTmZYZ2xWSXZDTEk0MjV6K3o1TjlUa3ZjZFNy?=
 =?utf-8?B?dzZSQUdpTWo4a1haYTNqSEdlTlJFRFUvRU5LZGpIdytTbmlBdnA0Mlp4Mjg5?=
 =?utf-8?B?SmpkMUtZWnNuT3dlNC9iVGswWnVWUy9RQ0pjeFBVN0VKV2t6bFRXUWs4M1Yy?=
 =?utf-8?B?cnNRa1lIQWdyMi8yTjJiT3dCcnJQSUFDdG5yZXVSeS9tQnVXR2V2cFRpOUlN?=
 =?utf-8?Q?cvMJ6x/4hGJs9XVu+5ly4X0fhBVrUhgDplJi2qO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 741c65e3-ec0c-4ff7-74b3-08d98ccf49b2
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 15:53:37.5233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VHIBmb5L7fg+3JeCSagumpameaYT4cJQzNkCLMghrqCL1x+y1gFTyjrBgeiOGRkZxLWqdHnr25FV+V/UFloDu9EFR06vjA2DPNcl4cBfJxI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3028
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10134 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110110093
X-Proofpoint-GUID: zjTj9hM2j-I_jokQ9KocjJe1qiEM4XpK
X-Proofpoint-ORIG-GUID: zjTj9hM2j-I_jokQ9KocjJe1qiEM4XpK

On 10/8/21 12:54, Jason Gunthorpe wrote:
> On Fri, Aug 27, 2021 at 03:58:13PM +0100, Joao Martins wrote:
>> @@ -2252,16 +2265,25 @@ static int __gup_device_huge(unsigned long pfn, unsigned long addr,
>>  			ret = 0;
>>  			break;
>>  		}
>> -		SetPageReferenced(page);
>> -		pages[*nr] = page;
>> -		if (unlikely(!try_grab_page(page, flags))) {
>> -			undo_dev_pagemap(nr, nr_start, flags, pages);
>> +
>> +		head = compound_head(page);
>> +		/* @end is assumed to be limited at most one compound page */
>> +		if (PageHead(head))
>> +			next = end;
>> +		refs = record_subpages(page, addr, next, pages + *nr);
>> +
>> +		SetPageReferenced(head);
>> +		if (unlikely(!try_grab_compound_head(head, refs, flags))) {
> 
> I was thinking about this some more, and this ordering doesn't seem
> like a good idea. We shouldn't be looking at any part of the struct
> page without holding the refcount, certainly not the compound_head()
> 
> The only optimization that might work here is to grab the head, then
> compute the extent of tail pages and amalgamate them. Holding a ref on
> the head also secures the tails.
> 

How about pmd_page(orig) / pud_page(orig) like what the rest of hugetlb/thp
checks do? i.e. we would pass pmd_page(orig)/pud_page(orig) to __gup_device_huge()
as an added @head argument. While keeping the same structure of counting tail pages
between @addr .. @end if we have a head page.

Albeit this lingers on whether it's OK to call PageHead() .. The PageHead policy is for
any page (PF_ANY) so no hidden calls to compound_head() when testing that page flag. but
in the end it accesses struct page flags which is well, still struct page data.

We could also check pgmap for a non-zero geometry (which tells us that pmd_page(orig) does
represent a head page). And that would save us from looking at struct page data today, but
it would introduce problems later whenever we remove the pgmap ref grab in gup_device_huge().

So the only viable might be to do the grab, count tails and fixup-ref like you suggest
above, and take the perf hit of one extra atomic op :(

It's interesting how THP (in gup_huge_pmd()) unilaterally computes tails assuming
pmd_page(orig) is the head page.
