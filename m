Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89C92C82
	for <nvdimm@lists.linux.dev>; Wed, 17 Nov 2021 10:23:59 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH9Glpu020722;
	Wed, 17 Nov 2021 10:22:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=/nLgI5uFgU0rSo1b/hM/8d7/6hkOjhsLEiJ8RclFHeg=;
 b=cQyiMZ4yz4dETzF9Ugu86m63sPHp9MYXo0y/EIAo57jnVaWiZSZ76Sl+D+4xLcIGSXzs
 2SlaEmnmZYD3yRSpx9ZO2UfUEVeNacDgF6zyxt71m2fH176atgxuniOfzYyyT9qAxakC
 GQpD6W/WSah9lZhH+67XM+ZeT+haL3lJetVBDX5DjMIrRP+Hghr8Krfb+S2xLrIEm23o
 spKac7Pz7iSCz+fne4Aru6/SA06QkQ3hn4tRn1+muuYjpuXNiaLZotgZhvbYZToRMbjX
 AZv2IisDkSDFA8gSEpgQwedqy4LFny/FK0H5uMiwwfASXrftU9UkZ9vX0DfmNcM8dPVV hg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3cbhv5ffdp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Nov 2021 10:22:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AHAAHqd091997;
	Wed, 17 Nov 2021 10:22:33 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
	by userp3030.oracle.com with ESMTP id 3ca2fxj3t7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Nov 2021 10:22:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=erhQYiWeJ5PODSQiY5G2vBjWfMSDbkIzILXDwzmme6VzMpL6wSSUlXpNlxCOWZReiQt6prtMP7+tc4+NVI54mcVJcWE0LFm9PIMl5Z01NZJMMblx3dv38CraWlxK+BmVppyPQsnDiBlE+m8p1K5CymAc/rei305Ghecx3ji6veHi15H7Egugx5nc+Tz3ANNcLte1n0Lz/M6tVt1mOic25L0ggvHbO+zGwC0LM33Op2ImLYSex6oCW5KpqlIILl24/w8eHz9+E8pOrYs7y3Gzk/PLnvVAN/GQC4cj8J1kZVz/eN54OiRfdCe9OSeLRXUEiY3xz5qlI7Dh2k5AcE2Diw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/nLgI5uFgU0rSo1b/hM/8d7/6hkOjhsLEiJ8RclFHeg=;
 b=oM3/Z7mPHR3l5NJRskLDtwoPhn8ZK3pSEdLLzbIG6hBJw1v2BL+ZnhNlSH0andtCnuD8mR6caPVx/CjTEXT/NwhwzGHehnHxUwYBKKlSQ9+cqndHM4Y1vxYIwMB93WVFwaojpo/ZNQ8dzKf4a55w1pfjcJXjOuOZofkBLx/qzDS8lJ1EZ1Vd4a+G/TY6x7P7zYyHA1lX21yd6Wwhzld3k0bIIq17GN/+qr7SF+bbluc2IdfuqEEqup2Ic5N6QS32RRGj8AVmwES5o1M6BE5DnDAnEnw1pb1Bd8Z3IhCFndNVwnGSMwQl5Wh0NRP+hQyPTK8hEe/N6hK5LhSoFfgc1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nLgI5uFgU0rSo1b/hM/8d7/6hkOjhsLEiJ8RclFHeg=;
 b=zbIp2zf/iykaLrdiPPKiaOgbyycn60dCpwXJVDP87kWAXNI79AjvuttDIRdTrzKqi6c7m4imv4UW23tQP7b7vUYxQzK6r3Qp1y2aEtefsmH2JkrRALRZn/gVfhR8OjbLLyEhBoO80uezdMMFjpWjiHoXhMHJXMSkouxQUx426BQ=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL0PR10MB2802.namprd10.prod.outlook.com (2603:10b6:208:33::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.25; Wed, 17 Nov
 2021 10:22:31 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4690.027; Wed, 17 Nov 2021
 10:22:31 +0000
Message-ID: <fb89c889-6638-9426-c94b-c11b74ff7aab@oracle.com>
Date: Wed, 17 Nov 2021 11:22:23 +0100
Subject: Re: [PATCH v5 8/8] device-dax: compound devmap support
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
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
References: <20211112150824.11028-1-joao.m.martins@oracle.com>
 <20211112150824.11028-9-joao.m.martins@oracle.com>
 <20211117094308.GC8429@lst.de>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20211117094308.GC8429@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0091.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::44) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.34.134] (138.3.203.6) by AM0PR10CA0091.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.25 via Frontend Transport; Wed, 17 Nov 2021 10:22:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e2f24af-d765-4853-9a77-08d9a9b429c0
X-MS-TrafficTypeDiagnostic: BL0PR10MB2802:
X-Microsoft-Antispam-PRVS: 
	<BL0PR10MB28025F1CC5815CD692797928BB9A9@BL0PR10MB2802.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	y+2jYxq/CFaeyFNVFI2FPPVeyDHAPjNG1jib1M/s7vngNixFx3cy8sKosT1kCrdufPDEAYH26+iZAk7iD33+M8vaCc1lgdm1HF9053TSijfn5AljooKC0Pac6165ol5INELRofJglyhlQ+ja6i5yftzwFgrBOzCBPqo8nkb8Xn77zPJkncND+fU8mkVzgQ8ZDldiWQWRcOPuoBoODLbI5F2lab6npjL/wMmXuOnmOdh6nKK6Zd1Y7YSqd0hWr454TIipuESoof+MxIR7gs0SNEBhnP1RLc1o2IAcZZyJ2q/LwCzTszjOFGgWqXdFy8RV1hCpMK6MA0hmgp1FvNMX5x9E/Wp8xnI/TvvEA7cxq6aZLY4sr36gHYENtbPcsTUAaP4zxg+w4Cgu+M+I1tAHABYREqtZGt6VZ04og2A9SHC6xBEWVeLF9Z8GFeOQ7sQKHdk60k8ViyECrviEgW6JkpKWzPoHwE49yuMuM/v7aN0kuVPArRL1gkACO6TyyKg0UPeC7EjBqUpFN7a5EcMfh5+4zccdqI7r8BkNYPAjDuejfC9i5V4i9pVuTFGi28NN3t+1LYKQjEsAgJsIN/QH2bI9F8u3EYoZD52FMUjlYZ1y2TJBXhlcg/2M/b2oHK5L0/o12wdActV08HAPTGOXDXJ9/id9zQWt9HyxQ5hfQ740DSTv+TOD2HpJm/tv4daHzUWGfQivxuk+NW6cRCQgFpY+eO9csCWrdtl8L9A3+wCPHEQBP9quMjIGRurX58pqmSnTxp1p1Tqtcbz2AyR6dvP8l0jc1kzj3jzTULfzw3o=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(508600001)(186003)(16576012)(31696002)(316002)(66556008)(66476007)(7416002)(54906003)(6486002)(26005)(36756003)(31686004)(53546011)(83380400001)(966005)(4326008)(38100700002)(6916009)(8936002)(2906002)(86362001)(2616005)(956004)(5660300002)(8676002)(6666004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?R0FJMU15WjZ5YVVYNG5IUlBicW9SdEpselhSQWpzWUNhWmxOOU5zeHhRWEdB?=
 =?utf-8?B?OXpMbVlRMnVpNXlROFJiUm9CVXNxdWZ4TzhHQUEzNG9McXVxMlFWYS9Va1pH?=
 =?utf-8?B?c0dRYU5ybVRBVlF5M0NIVkZlc2g1VXlkM2k1Tlloc3N0VUtnNW0xY2MrL2xE?=
 =?utf-8?B?dG5mV29jZnJCZ3RYVWZDK0I5aUxpTVgzSm1jdklhYkxud2pGd20rUGFHeVVP?=
 =?utf-8?B?VllDUVVOc3ZVMGJtTUVZa21TLzF4bWhndWltQW9CbnpmOUYxYUVBRUtHMS9U?=
 =?utf-8?B?S2o2elBOcXFGdDBZdHhwdWl1MzYzN0hEUWFSR1p1S0Ywa0dIUWovUmEvSG9i?=
 =?utf-8?B?MURVNk9uTDlYdXUzQ2NXOFE1emNpdkpvTVlQR1kyZysxbWlOa1RiYVBZVU1Q?=
 =?utf-8?B?ZjM2c1pUNXZhNm9yOXJRcTl6TEVFWmhGRUpYZzZtdFJMbmtFTlB0Uit6K3Zn?=
 =?utf-8?B?elFzb2FuQmVra2ZjaWdDdHQ2VGNIekVzcXdKamVZQUNXV1N2TDZJVGh5YmF1?=
 =?utf-8?B?SEJQZ0xUaFJMMVZKTU9kWU5tbVNjWkh4N1FlZm05Y3B4WmkrK09Sdk5ETE4y?=
 =?utf-8?B?SXIvZXRxU0l3RHlUdFNTTXQzb2VMVVRkTk9KNWhQU2VVbk5NZlh4NFVZck9F?=
 =?utf-8?B?QTYvOW1FRm5uRytVNmNUZGpzRENGM3QwU2lwYWhYcXBIL0ltcklaV1dua0NR?=
 =?utf-8?B?ekRRNGRKTjZsbTZNa0Q3bkNqRVFlNjNuZXdVZTlDb2VhZ0lQOTV4Ri9BY0Rz?=
 =?utf-8?B?WTltRUNMT0dRWWd6MTZETnRYd28yNzRzbSthbGdid0k4cUIxMFhQZ2xKMmtY?=
 =?utf-8?B?a1JMZDBSbUFHd01TZTc1N0ZLM0E3K2pXdnFJYndNR1d0K0dmTVNZTmM0azFK?=
 =?utf-8?B?OGhsRlMxQmEySElwaURtMGVxQXZTNGVxVWx0Wi9kcTVTaXVNajRGZkd1THhL?=
 =?utf-8?B?UUlBdG11N21UZ0JnMUNwV0RTWUlmaFExKzYwZzdUUzAvTWczK1NDSm9ZRXlm?=
 =?utf-8?B?cjNkUGhKRzFRVks5Vm85YmxnemZTWGs3S1JaTlNlR2NBU1ZlcUNGWUZyMU05?=
 =?utf-8?B?Uzl0dnpDeVEzYnNoeVhiRm5SNEwyekRnRGRVaVdrbWVDUUNEbDJzUmpyRXJw?=
 =?utf-8?B?VXJvaGhLajRxMHBMVGFrclRLZklwZ25LT3BReGFWRkhPaXZxazZBQkQ1WnRi?=
 =?utf-8?B?aHgweDRhLzNMR3R3SEx6SkY5UDNNOHhibEprUUg1ZzFPazYrSExPVTFJdG8w?=
 =?utf-8?B?UlpoeDA5UW1aM1U2Y0VGcjM4YkJJYkw0Y1BaZG5Mc3NQQ09YT3EwelR0N3Uw?=
 =?utf-8?B?U0d6NWJpSjRaY3NOMlRMYWJidUJnb2t5TVNLZCswSnZkZXh3K3llSFE1VCsw?=
 =?utf-8?B?cHJsVnlObWtxNWR4bVhrenYxS01IRERtK3dXdGh5YlpVWUU1MlVGWms4S2xO?=
 =?utf-8?B?cElobm1BVHVkUXdtZ0dwUTk2Z0tQS2QxVUVVcXgrNlNzcU1kOGdoYldxZWNs?=
 =?utf-8?B?WjlWbTAzd0ZjZHJ6TmEzZHhuQXJQdW5PT0JUSlh0WE53TnB0RW5ib3pFRlpJ?=
 =?utf-8?B?NUg2RUlYNnZEWHBYanltdWFhQlhJREg4L1FzL1d3R2dzMmNNL0ZFRGFFVzFJ?=
 =?utf-8?B?L1NyaHE1emNQOTgwMWk0L2hDZGFDYldCOVhuYkM2T0llaStzQU1Ycy9HL0pT?=
 =?utf-8?B?b25PZkQvVElxZDRReURVY0JiaWErc1NJYytJakNCKzlzWFd1bmgxVGc5M1p2?=
 =?utf-8?B?cDZodnhCUG80YW9FUERwNU1TelNjd3dSWG1XVjY1aHBZSzNTUlJZUnBEcWsx?=
 =?utf-8?B?aFdHT3BBQis4ZkpZTktvcVBXbXlkZmlWMWNZZFk1WnV6cWtldXpiUy96N0hx?=
 =?utf-8?B?cE1jS211THFNcW9xeHFUVmk4RkhNR0FmbFBzNGZrZzV3SkZqY0NPTzRyQndM?=
 =?utf-8?B?QWVSb0RwYmpubVQrRVNzak41bFB4SUgxTUdlNkJOdldaZE4rb2k0aFpqWEM0?=
 =?utf-8?B?OHV1Q3lNWUxFbHRIazUrTXZQOEFhQ0M0YTFLWk5BVlV6UXRvNzBwemZwSU8r?=
 =?utf-8?B?eGZ4S2RoOFd2MXVYRkhIMmRjTjVGMWxNakg4L3p3dFNoV3FMYkxFYi8wcnNn?=
 =?utf-8?B?aEhkWEZGWHEvNTltUHFBaU1tY21LY1ZySUR6Y0wxaXFsbUE2eWs1Y25Rc0tW?=
 =?utf-8?B?Q1BlL3ZBRTJaYkpDMm14RGVHSVZ0RG5EZ1R0RnZKWjdqeHFkbTNNMmxTV254?=
 =?utf-8?B?bm8yaDZFbWhTMlBNRFRJd2gzNFBRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e2f24af-d765-4853-9a77-08d9a9b429c0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 10:22:31.2388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1xakjKn6WI8//XMH0jw2D544p7YIjUfHygcNJT6LKpBzQSzxwgwjs96Fx6BNOh4NBO1P25GeDCv8jPcBbicFELs7mMkh0icSIU1h3UIL3tk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2802
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170052
X-Proofpoint-ORIG-GUID: PF407dLKZ1YBGcVX5CS6e-R9g1Zw750w
X-Proofpoint-GUID: PF407dLKZ1YBGcVX5CS6e-R9g1Zw750w

On 11/17/21 10:43, Christoph Hellwig wrote:
> On Fri, Nov 12, 2021 at 04:08:24PM +0100, Joao Martins wrote:
>> Use the newly added compound devmap facility which maps the assigned dax
>> ranges as compound pages at a page size of @align.
>>
>> dax devices are created with a fixed @align (huge page size) which is
>> enforced through as well at mmap() of the device. Faults, consequently
>> happen too at the specified @align specified at the creation, and those
>> don't change throughout dax device lifetime. MCEs unmap a whole dax
>> huge page, as well as splits occurring at the configured page size.
>>
>> Performance measured by gup_test improves considerably for
>> unpin_user_pages() and altmap with NVDIMMs:
>>
>> $ gup_test -f /dev/dax1.0 -m 16384 -r 10 -S -a -n 512 -w
>> (pin_user_pages_fast 2M pages) put:~71 ms -> put:~22 ms
>> [altmap]
>> (pin_user_pages_fast 2M pages) get:~524ms put:~525 ms -> get: ~127ms put:~71ms
>>
>>  $ gup_test -f /dev/dax1.0 -m 129022 -r 10 -S -a -n 512 -w
>> (pin_user_pages_fast 2M pages) put:~513 ms -> put:~188 ms
>> [altmap with -m 127004]
>> (pin_user_pages_fast 2M pages) get:~4.1 secs put:~4.12 secs -> get:~1sec put:~563ms
>>
>> .. as well as unpin_user_page_range_dirty_lock() being just as effective
>> as THP/hugetlb[0] pages.
>>
>> [0] https://lore.kernel.org/linux-mm/20210212130843.13865-5-joao.m.martins@oracle.com/
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  drivers/dax/device.c | 57 ++++++++++++++++++++++++++++++++++----------
>>  1 file changed, 44 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
>> index a65c67ab5ee0..0c2ac97d397d 100644
>> --- a/drivers/dax/device.c
>> +++ b/drivers/dax/device.c
>> @@ -192,6 +192,42 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
>>  }
>>  #endif /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
>>  
>> +static void set_page_mapping(struct vm_fault *vmf, pfn_t pfn,
>> +			     unsigned long fault_size,
>> +			     struct address_space *f_mapping)
>> +{
>> +	unsigned long i;
>> +	pgoff_t pgoff;
>> +
>> +	pgoff = linear_page_index(vmf->vma, ALIGN(vmf->address, fault_size));
>> +
>> +	for (i = 0; i < fault_size / PAGE_SIZE; i++) {
>> +		struct page *page;
>> +
>> +		page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
>> +		if (page->mapping)
>> +			continue;
>> +		page->mapping = f_mapping;
>> +		page->index = pgoff + i;
>> +	}
>> +}
> 
> No need to pass f_mapping here, it must be vmf->vma->vm_file->f_mapping.
> 
Hmmm good point -- If I keep this structure yeah I will nuke @f_mapping.

Should I move the @mapping setting to before vmf_insert_pfn*() (as Jason suggests)
then the @f_mapping argument might be useful to clear it on @rc != VM_FAULT_NOPAGE.

>> +static void set_compound_mapping(struct vm_fault *vmf, pfn_t pfn,
>> +				 unsigned long fault_size,
>> +				 struct address_space *f_mapping)
>> +{
>> +	struct page *head;
>> +
>> +	head = pfn_to_page(pfn_t_to_pfn(pfn));
>> +	head = compound_head(head);
>> +	if (head->mapping)
>> +		return;
>> +
>> +	head->mapping = f_mapping;
>> +	head->index = linear_page_index(vmf->vma,
>> +			ALIGN(vmf->address, fault_size));
>> +}
> 
> Same here.
> 
/me nods

>>  	if (rc == VM_FAULT_NOPAGE) {
>> -		unsigned long i;
>> -		pgoff_t pgoff;
>> +		struct dev_pagemap *pgmap = dev_dax->pgmap;
> 
> If you're touching this anyway:  why not do an early return here for
> the error case to simplify the flow?
> 
Yeah. I was thinking in doing that i.e. calling set_compound_mapping() earlier
or even inside set_page_mapping(). Albeit this would need a new argument (the dev_dax).
