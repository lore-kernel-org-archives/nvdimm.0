Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB5A72
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 13:15:41 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16FDBYjH022082;
	Thu, 15 Jul 2021 13:15:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=QpQGe/19lZQUBIZmPmCt5/YhlNaDPuy7ID8wmCd+wiQ=;
 b=DHnf9bbz0e39kTvNjTlfNtLLOGbtLGzsCi9M1JWw2idzlcm1t/Yquk8UJdKq2ExQzkaG
 zqf8jwlo2OvQLgoyOaHFXga5lIP/aoniElWHtkBrNPpI9GdnOgoKXRvzZcLPV0CQF4yl
 jAsGJQc1xv2UyyXB52we39UYh7PAvVGZJ0OL6UzeQHO/H1gQ+sAYh+TOSB1vnHJTwDXO
 WTGhdikUCL9+65Hylr2qWgxXs3xRFAzYeeLvsKq+7yVXYwUWyFw5Yn9lahjRCgCayKV8
 KlPjGB1Jt2k36IBp2NrG/+A9hLChKJq8Ul8O62TH0WzBlUQERlGl9wm+H0aIxf49I3RM 0A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=QpQGe/19lZQUBIZmPmCt5/YhlNaDPuy7ID8wmCd+wiQ=;
 b=Cj1eXNDjRgJnXSo2e4WJf5zbEFNGKiMW2/mvpMgsaSvGeYAjKTbWRsl+MDWtLSsCFxMU
 C6pOxVXzJ5puLw2DdYDTkgH7C0yDrDKq26tED47aFat4ewmtUt3ZboZnQRMa2OxNzInb
 gQwgvy+YKI3t/kifI/vxeknu8wvuNHWTfjzfdldqFq1M5OOH/if7s6nlFTLSEra083F8
 s0AzDC7A4IuMboaKpSXB2aU3Fq+bsTSzVlMQpY9LsG/x4yLYFT9SuHoTwj9RHWB9jJY3
 0C8TRJJsFIaVbmxcGT6MHjEACPW7/mifCMKGr0isWBL7bxWCF/uZy7RUoBaq4EF4EXZv xw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 39t77uscxr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jul 2021 13:15:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16FDB18v119730;
	Thu, 15 Jul 2021 13:15:30 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
	by aserp3030.oracle.com with ESMTP id 39qyd2twqe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jul 2021 13:15:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZgZJ2ju5nirxyrZkmHTgz83CQnPNuI64lzxZWSMVtbVv8ngEs2g55vdZOAm1MA51iSRcyPvMpfAJzUDxaTeewSH7cqyPmGapLXTMBuDN/8IVCJT99cZb6F+VtoSLmAnfsV88AwMYrghTL4Aoek18AjBdwtPp+vMA8Wb5FK6i68K58HPI7MsjDP+xDjs5qMqPbkPGVIemCcuYVNNA3cZTC4H6k8mBdzEkUPX+9eef2qtqdpqyt+IenD28sJk032SI02snjbKq4Wyz6EnizM77Z9kIlKjK3Mg1YFwHPoV3bzxD8loD5pxnmylhmhpvzUkA/pZOLYMJpRIOfigE0TiL1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QpQGe/19lZQUBIZmPmCt5/YhlNaDPuy7ID8wmCd+wiQ=;
 b=OMnEeRSZhDWx/ENIY9ishmebq7KVCmnOy2sa6DntCPwropBUCJ85NFAdxRR5DCHlJZBRQNZkBLrXI0x14Oj/6e4MIixPZL39WhtuORd4SLzZD0ZLPqC7jrXlXZ9hdVlzwPoKjG3xJgkfkQKMC8kEpZlw1UQfy7iajagaDY+ERxCzEfHo+jHGdavzEWl0Uii4DrfDGKT4sni4vnaJPdDTZM9Adi8v31oxGz+qo0B14ttCrsmGWD6L6/9s1P06KbWZraSfyf4SCd4p575ArZ1LIT9SiY7taRU2crUVsuwcKUfaS5uySB1wD3v0RDQKAE1KssX/KZSkC7AGEgqePGUOPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QpQGe/19lZQUBIZmPmCt5/YhlNaDPuy7ID8wmCd+wiQ=;
 b=OGWKYkI5hrTuhwtcyqhsjJvf37Ey50Rglxo4zybcGQca49FUZmgfkg2Tz2ZAAfVq++ujTDT3WauBURpzQy57T88+SBQrwIaACAkeOeMXljRpiX6lCnudQXtgEMdPX+gdv6w7AKalZZdEdfXu+9pSxdC8hUW5jSsXeNeFnmmmZOo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4818.namprd10.prod.outlook.com (2603:10b6:208:30e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Thu, 15 Jul
 2021 13:15:27 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4331.024; Thu, 15 Jul 2021
 13:15:27 +0000
Subject: Re: [PATCH v3 04/14] mm/memremap: add ZONE_DEVICE support for
 compound pages
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev,
        linux-doc@vger.kernel.org
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714193542.21857-5-joao.m.martins@oracle.com>
 <YO/aVLL2WlWkKXia@infradead.org>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <27a729be-2a63-b4f9-6db2-9ba7ec98244c@oracle.com>
Date: Thu, 15 Jul 2021 14:15:10 +0100
In-Reply-To: <YO/aVLL2WlWkKXia@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0095.apcprd02.prod.outlook.com
 (2603:1096:4:90::35) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by SG2PR02CA0095.apcprd02.prod.outlook.com (2603:1096:4:90::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21 via Frontend Transport; Thu, 15 Jul 2021 13:15:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 438d1a98-17b9-4603-a9f5-08d947929cef
X-MS-TrafficTypeDiagnostic: BLAPR10MB4818:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB48181B034BA2C59803E2B942BB129@BLAPR10MB4818.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	CzZXUup7+cF/4OtKd3pTcDQ38HqNIfFI5zb21IyWuK3ieDqGSw4X9tuB5bfL+Bu64rEjxtpB8fq8naUXaBPAuEVZj391+DuZaQJpXEFaxqWAimXyB8JNDpRFPC2lFcmTWLV2UzopCZNNGcgAdRU/fWG5174S/CQZ/JTq3Zy7Ookg/17vv3UBdS2LKWL88JN80a8aC8RyX6Z/+1JZ+mIRm9vhccCzp1lOK9X8N75o1aR443XuV6rjO4q6Dzt0aR9uSTk8RrgdWsoV8nePt7LwEWIWZNljOtSegCLd2Y8+B8yXgRalq5a5lSDcsYok/YWOlw4MqLGWCM44Rjvu1IY4b5//xMs1xgHeKPbHvOt2NObzQsLcIp3nM8Q108QXaUFz0coC+1/pMqprqyCz/Bbk0TupyF/0+bfAGeY0eTycN5lra5s8OFmURoIEkkzbNisXSShTpcwFnBzl1Q2eW3zNiPpWahO0l30f2TqCSsFitougseGHh3pRhGiRM84AYkVaNxnIcQNefFZ6XljqGj7Afaa82WGnJgz7ypLiPhlqQeLfH4UYksGo2MKfEa3TathhN51WT/y1T0ZQt4afLkmOgXIxf3zpP8h6VsPkQIU/Pyvp5TEq/LYTBDddx44IsEAhOc3kbaxe2mOVnuTE+5bsQnw1+7ofMKNyo1Il6yQ1zNC441POj2mm/GpEp82SMXmxy/ySvXV6E5Cf34kVrDKO1Q==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(86362001)(36756003)(4326008)(8676002)(54906003)(316002)(478600001)(8936002)(16576012)(31696002)(2906002)(6916009)(53546011)(2616005)(956004)(31686004)(186003)(7416002)(66556008)(66476007)(6666004)(66946007)(26005)(38100700002)(5660300002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bGtWS3VNeU5NcFkxa0J3bG5YWW1hZk9xQnNiSzMrODNPeXJZc3NhNnpRNUVH?=
 =?utf-8?B?OFM2VkU0d3JMa0lXS1kyUWl4cm9zU3pFK0pGZGVUU2d3aXFTQ0tZYUJsdmRn?=
 =?utf-8?B?ZHBTWXQrY0diOTdSeVVnQjVJYUpjTVpEdFVuN0xORVh3QnRkaTg1NGR2N1Rv?=
 =?utf-8?B?d2tVMmJzbzdBN1Y5Sk41a2RyY0ZQSmdlS0hmcXlnRTlBVEx3MG14Z1g0OVk5?=
 =?utf-8?B?TWNXUWZYampIVisvb3JBWFRSNGdhU2J2aUtkOERJUEQxam11cjY3MWI4NVNh?=
 =?utf-8?B?WHpId3g1eS9tMzd2QUJNN2hkOTVxN0JSbnFsVURBcWYxT3hRTmE2eit1S0lj?=
 =?utf-8?B?WStYdldiSzdoY0FYcTcxdnVNczJhcjVUOXdFZGUrMXlPV1RNV3JBNjEyY3Y5?=
 =?utf-8?B?WmZjZUQ4cUNMTlVud2pNbnJQVEl5YkZDQTR0ZmJ6cmNpbmpma0h4a013ejVY?=
 =?utf-8?B?dnp3QUYvekE4ZGNkWi9GbTBoN3NIK3hPQStubWoxcERkbzVrcmNaVmZ5VWpD?=
 =?utf-8?B?L1dNRTBub1pUUTFIbTJmUFh0NXdvdjhod1VLS0F1UnpXbTZkWXpsKzNPMXFB?=
 =?utf-8?B?TmFpWmRxM1Fpa1J4R1IrNGNRQzlYSFJ5NEY5bGhFbFVadUZqanBVT0t6N0dF?=
 =?utf-8?B?ZGZxK3BJWFdVVFZUVkRqQmJldW1wakVrcnNkZFF5SFNOY3pxV1hndWZDUHBG?=
 =?utf-8?B?dXNzTmtkS2ovWTFuU0JVZ1A0MDJYZnhFQUxYc0RSR3BMRUVabXBFdUVETklR?=
 =?utf-8?B?aGlKN3BCMlExc000Q0tRVGZGbGU1WXMxQnZUZmdXdE5GMDUrZkpjaTRDVUha?=
 =?utf-8?B?dWpCVGc3NEN6Y0ZPMVM4VFlaUFRIMjZXUFpPZWMyL25YT2x6dlFreWw3WUpW?=
 =?utf-8?B?Z0NmeE9zK1FXV3JUVnJ2SkZRc2ZMT25ORExkVEpuUkpOT01Rc0dpTlArL3A3?=
 =?utf-8?B?OFRkSklvOE1BazNoTTJ6SFRXNnZ0cllidTRORnZlUEx5aFl2WWNJUGF3bEFy?=
 =?utf-8?B?YTFsanlFdXpHK1FpU0F4dGVRcVNuWVZZNVRFRGdmVmhwbDNvWlFCdUVEOEJY?=
 =?utf-8?B?Y29zbnF6eVdSNnVpYkFoVmZSR3JnQ2NvOW5ScEVyd3l2dWNwaFErVXNYeWRL?=
 =?utf-8?B?cHBBN0toa1ZTL1BjL2h2dndRb053cFQ4TTlaVjQyTG5mbXUvZGNLN0lOd09O?=
 =?utf-8?B?a2hYRDdDR1lpNVhTeGVWRnp3RjRLNmJUQUZPQVdhL2htdWR5MVlSTVg2MVNJ?=
 =?utf-8?B?ZENTWjA4bFV3TzBQSHRjYzhWT1J2S1NNRHJWcmhHbjV6RUg5bzBIK2NZa04w?=
 =?utf-8?B?TGI1SzYvWi9ZNzFUcXR4a3ZKNFY2b2UvT3dkR3grTms5clplR0Rkek9jR0oy?=
 =?utf-8?B?aFo5aWM3U2xSZ3lheXB5Z09OU0FxQzMxb1lEbUZDclBLUGN4blNtVGFSeXJB?=
 =?utf-8?B?cFNLdEZRa3BNOU16V0lSWkVMMFltK0JaZ1gyanZ2ZTM3Uk9NT1czVUhnajlp?=
 =?utf-8?B?U1E2a09kNjF5d3lJU2IreHNCVXc0TkhmdDZHN0VWcXB5L0lKUGo0ZlJsNmc1?=
 =?utf-8?B?Zng0VWMzZTdZOVlFTWJtcmltWklLTTg4NDFaV0U5OTNZMm5GcXkzUUNqM2lM?=
 =?utf-8?B?aVdPTlV3U0RndEd0T3kxdWMvTy9TaHJTTmZEdzZGUTZMditXaFZKeWliUGI1?=
 =?utf-8?B?V1QxRlRReGY4d0tWMFp4Y3Mzb29yWFJ0RUtYVExjRFJsNURQN0FUNnZHTlha?=
 =?utf-8?Q?EyFVaLT10jUqXh0D3Ib7Stq2MBIiyKpnkAhLhm/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 438d1a98-17b9-4603-a9f5-08d947929cef
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 13:15:27.5406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eyhFFyqHTJOCggTCjHgV9qvdOu4+7ChoTTQ9FdmiKrVM24MteAlpN+5taMAnWlJzFPzXayL2/LsCifohthGSrFQybCT0GQXiEKXPIW7IDSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4818
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107150095
X-Proofpoint-GUID: 8jrFAiaWVetPR7dBn2fIgooHlScISeMJ
X-Proofpoint-ORIG-GUID: 8jrFAiaWVetPR7dBn2fIgooHlScISeMJ

On 7/15/21 7:48 AM, Christoph Hellwig wrote:
>> +static inline unsigned long pgmap_geometry(struct dev_pagemap *pgmap)
>> +{
>> +	if (!pgmap || !pgmap->geometry)
>> +		return PAGE_SIZE;
>> +	return pgmap->geometry;
> 
> Nit, but avoiding all the negations would make this a little easier to
> read:
> 
> 	if (pgmap && pgmap->geometry)
> 		return pgmap->geometry;
> 	return PAGE_SIZE
> 
Nicer indeed.

But this might be removed, should we follow Dan's suggestion on geometry representing nr
of pages.


>> +	if (pgmap_geometry(pgmap) > PAGE_SIZE)
>> +		percpu_ref_get_many(pgmap->ref, (pfn_end(pgmap, range_id)
>> +			- pfn_first(pgmap, range_id)) / pgmap_pfn_geometry(pgmap));
>> +	else
>> +		percpu_ref_get_many(pgmap->ref, pfn_end(pgmap, range_id)
>> +				- pfn_first(pgmap, range_id));
> 
> This is a horrible undreadable mess, which is trivially fixed by a
> strategically used local variable:
> 
> 	refs = pfn_end(pgmap, range_id) - pfn_first(pgmap, range_id);
> 	if (pgmap_geometry(pgmap) > PAGE_SIZE)
> 		refs /= pgmap_pfn_geometry(pgmap);
> 	percpu_ref_get_many(pgmap->ref, refs);
> 
> 
Yeap, much readable, thanks for the suggestion.
