Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C966568
	for <nvdimm@lists.linux.dev>; Fri,  5 Nov 2021 14:10:23 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A5DvBOc009152;
	Fri, 5 Nov 2021 14:10:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=f8EIomlj2G1BHkCZpjXM9kTHKBuY9foQWBc08MpKu/8=;
 b=qpmd913beoUVCNE7D9fs/WeJopVbmRu+UDgbZGuU4CALttaM864A/LQlktjSUiRjYXiX
 6lxkcUBBupvqoALyRWbfKQ94QE6N2YVPX7p8Yb6ZMPUoEA/j33RZJa3pckzxIibkz75w
 2i6GBT9gQsn6Ni8TTfVl/PS3X5U+zvvlwktHVFpRC40OlXX8qMhEYqHYvMo+q+b/ewF7
 4c461cwc1EgkQ0X9hw+CNpdR2P3QuwRQWHtFbn1XA3s12H1qSbSS+zgi+tq55Z9+diCv
 XD5CWaZmKnt5xjTFJ2V7r7wHxATYEUjT6PZoWPRN49g1FhjFPksIbN/SeiSqWQvWsDJn Uw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c4t7htskt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Nov 2021 14:10:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A5E7Ad4130845;
	Fri, 5 Nov 2021 14:10:15 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
	by userp3030.oracle.com with ESMTP id 3c4t5d16e2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Nov 2021 14:10:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B/0XUTMA7T5ai2h6DeOhfL+cnPLhSG4VaZ1egXpGX3l7EIvpoedpptqXBmr2LSI9yIE8d4NRTr8PBk+XXcGwTWR3fhAsurtk5UwVWkOTDSW2PoslRHarxy46Wg+lhbVOY0nk4/929FcMZIOhcGbgRLcuneY9qKDJkqjUAbn5O37IdAHVU6mLvabX0SgcIK807mviqBPXSs+oTLrEZgZe8Jyte+qoZ+VwAY0X4Ahk05PF59Ebf8p8sjUrNZCUKFHyBVH91/jW+76Lfj5EXNrHMEKfpHwTo2bpXgIobeBSdL2s4c3okeDhn168/kju+1jpuacHA5WW/NlheyQXHAdN6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f8EIomlj2G1BHkCZpjXM9kTHKBuY9foQWBc08MpKu/8=;
 b=GZ9dDU7iaHQY7WNj/ATXAsYqX+odo3idlLf2iJY/yD/ACcBD+0m/PIH2vjRwetRfV3qtLz8cIN+uUNLuFqC4K8MAqch1x2nKmjjeymSAmyJjpTnUGcO9fG086IYPUaRvZuOwlbO37ulIExMywC8x17pUbi12weFo0+a8pzFqtkTbLcL8GXEe+REQdgu8eZFr10kkBVl/K/Rh7ak8Va5jGb3R5B7G3pVGg0377/wO0T9fQfs95vuZFf7CBnulr+h0gdRZC28HpMVpuj9enFeg/RhAdqvdSM8rh+820s2oHkXZH0UyNqStQ2UMk4XGKQ9vwrLM7+hIh6ZAreD9x4zW3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f8EIomlj2G1BHkCZpjXM9kTHKBuY9foQWBc08MpKu/8=;
 b=k5p2l4AQD8f8G6LEuFjjXcmE7KBbacCbQHuHDbh6s6gBIcJlOYT5UuQnJT+5+aGvQPxR9JrkAdJQhSaIF+Y4Z2MscsGnWsnswgWS9O3IbEgDuf9+AOoWEX3iw+BY9t6KM+wXQIABtE3FW1SoVgbqqqeoNd+j0wZcJVUtj06kZKg=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5313.namprd10.prod.outlook.com (2603:10b6:208:331::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Fri, 5 Nov
 2021 14:10:12 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 14:10:12 +0000
Message-ID: <bfc9f754-e927-f6fa-7da8-2811fe5c8808@oracle.com>
Date: Fri, 5 Nov 2021 14:10:03 +0000
Subject: Re: [PATCH v4 07/14] device-dax: compound devmap support
Content-Language: en-US
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
 <20210827145819.16471-8-joao.m.martins@oracle.com>
 <CAPcyv4jqdPaLPOydb_GWvVP4d+hRkcu7CnP_Ud-CQXHcqTLWKw@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <CAPcyv4jqdPaLPOydb_GWvVP4d+hRkcu7CnP_Ud-CQXHcqTLWKw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0011.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ad::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.160.24] (138.3.204.24) by LO4P265CA0011.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:2ad::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Fri, 5 Nov 2021 14:10:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9b2ca3f-c4c5-4d43-df41-08d9a065fb44
X-MS-TrafficTypeDiagnostic: BLAPR10MB5313:
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB5313BDD4573C97A0AA7D5AA1BB8E9@BLAPR10MB5313.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	T9h3QC+QZ4CuBkT2/tBRiytRs/ivQDhxwkfbFnocjTq2kZcLubw7uL4HpDTZhj2+vLL8DUuAUrtaWFmemdL1ZHXLCEht4QYnunQahpIzI8CXFmwF3P0Zzz15BxBfy0iUTLzyQT5SSkZQyeKJid7nLG93mK3j71fITjy4TJ3bn89QGgusAVk2ZC84OYf0cVIxBPvoGWD+0k+vN3IYHXiVmv9lV9BPMoGxCMtDuRkyq9pB9CbFqcmmpUCU5/qs1G0LzLjzQsCV6qxDx/HoUwpy/VCl5lymZUKMVNP+kYmHLJEkrvHnx9Xp63esmuuJsI9Rh66Stm5BZU+4k/hVpm9DIbx1kwIRM8FwoWYjoqM7jWX0zgtu//4fxdKk0fZFIhBGGrJVfOz+S5gpPR3jzhZt6ZHVf2gfBwCCqLbB5FEdGjTLdmzSxvvMkE5EcbBccVFDu2qLY0EfzIO12+9uwbfZLDj4K/s0mJm2xu0qP88gXxNQm4413guGqrK49Y6QiMfgsRXMY4QDboAk0tj9jvPpZcIKO7kWvL9CQiKSnctaZ/M7UdaLjKuYTPDB31zNdN6J2U109zdCjMTFG13GJ4Jm/PF7m7ZieHSLyNa9jv6a1eF+zusvdzvDwk3u1qPpOlMx/+neYlXfVMb7K6pVXvsP8ysidXcSp9rwBK9XMtvgS9qhRaPJFB4Kd2YgOXtVHZxy4SSZpeiNnqqxydmrcQVyBw1HUnr46iUU1KGRDtw6Afg1FzuxsqMg5IGG4LClyXzJBfMn3o5pvU4/bKVV/H8evQUvC3+IaVjv/7773GFvcPc=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(186003)(54906003)(8676002)(31686004)(6916009)(66946007)(83380400001)(7416002)(53546011)(16576012)(316002)(26005)(6666004)(36756003)(6486002)(66556008)(38100700002)(956004)(966005)(508600001)(86362001)(8936002)(31696002)(2616005)(66476007)(2906002)(5660300002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MnovZmNDSzdMNUlHczVmbFYvY3RacW12K01ZcUVvUG5SQ0dBbTZyRks1TlJD?=
 =?utf-8?B?Qks2Q0xFT2FtMEI5M2c4dFVlb1U1ZDNVWjQ2NE9naTFNV0t5RXI0UVUweWp0?=
 =?utf-8?B?YlRybGt0MGtmTDBpbExiRXE2alZBTUhOMTBOMXl3MEVpc3B3Z05DWElHakxR?=
 =?utf-8?B?SW82ZXJwNCs3NklPUko2WjdzWWpMckx0Z2JuM0xOVndxdVFUZHVEZVh5cFhv?=
 =?utf-8?B?QUhrVnlVRUdlR3BRelZaNFA5S2IrNVpQWUxRRTBkMGdpSWZtVzZNZFBqbGZY?=
 =?utf-8?B?bmlCMGFzRjkrRjNqMlNBNkZBQ2VaRTFpYzYxWi9YSThHSUdDcko1ZlN5MXhX?=
 =?utf-8?B?VXlxODE1Q2FnR1pWaUR6NHozenQ5Z1NRbG1FRFRzeVJFSms5OEMyelNDaDVR?=
 =?utf-8?B?VSs4RklkTTE1UE9aeWIyUlFGVHVVQU1Ld25qaWttQy8rN081a3hoS0xWVkIv?=
 =?utf-8?B?RWhOQWhidUlFN0htdCsyZVBFNCtiUDFlcEJ2SmE1TjNON3ZmM1hqRkYzVStz?=
 =?utf-8?B?RGlRWExQNis0czZxMEJ6eStFY0tzMDZZbzJzR1JTWXQySFI4M0RKSEJaWmN0?=
 =?utf-8?B?T3NzK1owY3BXbklldGUzVEh6TDVvUjVPeTYvM0NNTUVxS0gxM2JsSWNISkxa?=
 =?utf-8?B?T3RNYU4wRTYwbTVlbXY1ODNOSnlZdzBIcG90UjlzTXNEaVJWQlJaMk9PQnQ0?=
 =?utf-8?B?ekl5UkVUTEE2NFNQMGphaU41bERBRWVYYWNYc0Vzd0xnMFhkSlZhQ2FXWW9l?=
 =?utf-8?B?RHpYdFRHWWVNTDhZejg5d0lOU09zNi9BenlSK1NES0IwVjd1S2Q2NGVTeVpB?=
 =?utf-8?B?Y2xVSE4vQXF6dE10cFBSNlI0RURjd1JEU1hITEg5ZDNSakhzN0I1TEZFODZo?=
 =?utf-8?B?bEhDbEdTbTE1UDhXcWp1ZkU2WWh6V25BZEQ1VTFvcEVLL1JCQWMxdTdyaFBq?=
 =?utf-8?B?TWE4bHlyWmdBQjhUVHJqSTNEeGl5aitMU2UxUndSR3BjTXY2ZWZxd095UlZ3?=
 =?utf-8?B?YlNxZGJ4Nis2SS9xekR2d091L3pWOXhBbEVJN0Y0NGV6SFV3UDhDVzBKbjl3?=
 =?utf-8?B?VEVmc05SbUpxKytiUXNrUWM5OERUUWxHMndxRWNOUGhicVpZYWk4aWhMak43?=
 =?utf-8?B?R01nM2h6UEtUYXI1SWpDTFd3bXhHVFFzaWpFYUhhUTV1WHd3Z0FiWXhHa0hQ?=
 =?utf-8?B?bkVKeFdlWTFFY3I3cFBWR2ZSaDVVZThlN1lBNnNYZEFhR3JUb0NYc1gyUHFm?=
 =?utf-8?B?S01XTHFBL2U2ZW9EeEZZVTVhaHZCVnVISERFemtyODRVMmNmZ2NaVVN6cmF6?=
 =?utf-8?B?RUVMc1RTOW1BdHRaKy8wWk45WXNkMElDSUR1enVHendFQmhFelBURnVFbm1M?=
 =?utf-8?B?UWphUWRoMEV2OHI3SVMveFJSYVQxWklEaXhvSlIzQ2NIQ3BFdEVPQ3NDb0w3?=
 =?utf-8?B?Mk1CV2N6YWQ5NE1obTdEZ2RLZjBPdHp1cjVOVklaSmF5WjBSc2txd3FZeUpl?=
 =?utf-8?B?cWxpQzdJSGpDSjlHU2k1WkY3a3V2WngwR0diU3owZktQQ0tKb05DTVlFTHNQ?=
 =?utf-8?B?dVRzYitVUXVCakZsUlU3YUk4ODE5R1BKM1B4VHM2b2VhNlBMUTBhS1NaSHRG?=
 =?utf-8?B?RFRpR3pqQjdOUnpkN1FxZVpPSWNIRmVrcy9YMm1nQjBMYWl1MW1MWklrT1dF?=
 =?utf-8?B?Zjl3VzhGVlA3emdQUXJYVlRtY0lRYjdjZ1plUVlLSFZHaDFkV1hlM1pnYmR5?=
 =?utf-8?B?Wis3RGt1cFNndmFzVzR0N1BhY1RpVXZyWkN5aEpOeEk1Q3VpTFVkQ2NqUG1L?=
 =?utf-8?B?QzRmS1dLZE55V3dqNFdOK3FtcE1CSnBDTHdSb1hSTHFQRWN5ZzIwRlM0NU1D?=
 =?utf-8?B?UDRXd1drUlVGNC9vWGw0OVB5QkkzZDdTMGI3ci9NSS8xVlI5aUl5SXRvSTJJ?=
 =?utf-8?B?QU1CTEpUdmJrckFpdmsvUmVsY3hoUXRCWHpGZ0VuSnBzbjlXampJMzJKR1dJ?=
 =?utf-8?B?bWxxczEyMC9YN2gwUTZDNjFHZTVOYjFHNUE3emhmemx5MVc2ZU9BLy9WMmdi?=
 =?utf-8?B?cUlVVTdMWUhFZVZYUjhuaFFhR0dCektIYUI5RVVTMFVoZzkyc3FsRnRBc01s?=
 =?utf-8?B?blVDejZFWWFOQ2gybkEyODJjV1RnUnE3ZU1vM2JYN29PcUdOUGVqMnFtOGlF?=
 =?utf-8?B?ck5VYU1ub3c2WVkySW1CZ3lPL0t3QllqKzd6KzFSMXlKUjJhcktiZzREWXpP?=
 =?utf-8?B?QTNkU240cndZV01Edkd2Mm45R0d3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9b2ca3f-c4c5-4d43-df41-08d9a065fb44
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 14:10:11.9333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8bWmz09My/QAA/fpzzpXYUPBXMBqix3BPUFrnnTI/JDitDSssX+HXCe+jRlvfO8W8uLd4fJnj8nxiW+imvEYEUI/x5T2NH6283wqve1T/mM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5313
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111050082
X-Proofpoint-GUID: PAH1_pCcGNex6HQlgsC4Su7sng9apwKB
X-Proofpoint-ORIG-GUID: PAH1_pCcGNex6HQlgsC4Su7sng9apwKB

On 11/5/21 00:38, Dan Williams wrote:
> On Fri, Aug 27, 2021 at 7:59 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> Use the newly added compound devmap facility which maps the assigned dax
>> ranges as compound pages at a page size of @align. Currently, this means,
>> that region/namespace bootstrap would take considerably less, given that
>> you would initialize considerably less pages.
>>
>> On setups with 128G NVDIMMs the initialization with DRAM stored struct
>> pages improves from ~268-358 ms to ~78-100 ms with 2M pages, and to less
>> than a 1msec with 1G pages.
>>
>> dax devices are created with a fixed @align (huge page size) which is
>> enforced through as well at mmap() of the device. Faults, consequently
>> happen too at the specified @align specified at the creation, and those
>> don't change through out dax device lifetime.
> 
> s/through out/throughout/
> 
>> MCEs poisons a whole dax huge page, as well as splits occurring at the configured page size.
> 
> A clarification here, MCEs trigger memory_failure() to *unmap* a whole
> dax huge page, the poison stays limited to a single cacheline.
> 
Ah, yes. I'll fix it for v5.

> Otherwise the patch looks good to me.
> 
Thanks!

Btw, does 'looks good' == Reviewed-by (with the commit message clarification above) or is
it that 'should be good with the ammend above and you get the tag in the next round' ?

Asking as IIRC you mentioned this too some other time(s) (in the simpler sparse-vmemmap
patches) hence just clarifying to understand your expected 'process' better.

Also, I will be splitting this series as mentioned in the other discussion ...

https://lore.kernel.org/linux-mm/20211019160136.GH3686969@ziepe.ca/

... So this patch and the previous one should be the last two patches of the series
and the rest (gup, sparse-vmemmmap) will go in parallel.
