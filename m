Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5555872
	for <nvdimm@lists.linux.dev>; Mon, 29 Nov 2021 17:20:45 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ATHEhh8025169;
	Mon, 29 Nov 2021 17:20:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=z2mXQHaZN/dBWzFXb4SOG+ANGzeeNjA4ZwGiXpvgu8k=;
 b=C49enFRM7UYkLneoF9wfdgnp9qYJnnp0/g1D5CMjYEBKn/PxivFxZapRsEolxNaDsM/G
 aaB9SFngXEFmLh9tpsEcZ08vV4wfrvrNAt7nMGlsNP5IUIjGvo+BkEB0//q7oAuoIyQk
 NoOV7QBXuuhlH2hw8yWmmMO/CfIAc2XvdyMXzjTfKMrClt1WbIGGWQ1/C4BSpXmS8L2e
 9kPP5XdMMURVJ/8Lu3rV9aqPRb7wVBkeOdl/ysCiWCmTUT6E/g84+GGcG51BzD9hxthv
 mJXN2E0I0WyvA7lapQtBFXtmvtQxQj2AOB3/5RmLDParxxNLWh8rLOeEWuVeJZfCMq4J zA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3cmrt7uj8y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Nov 2021 17:20:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ATGtg0u187376;
	Mon, 29 Nov 2021 17:20:21 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2044.outbound.protection.outlook.com [104.47.57.44])
	by userp3030.oracle.com with ESMTP id 3ck9swr28w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Nov 2021 17:20:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iaKPnFcM0Is/JQkrZddbKlWHZ6TSvgzcWvZvbm7ES5Wcs1gVoBy7BoAdrLiRaKrqXBXCfYvIfjAdG8RKXbebfmd8F644qenZgiZ9bGJbjl5GorFQTDR1LHcxb+wXHMFZvTJb5qN8pHAP8z/AoLActirVQRIjhvDnyG03HVqv3bxLBoxQJjATeElG0aXcfHYR4YgAk44dSrxfEzj1fQ4newti1zi7fAfq4kAsFbCe+oEwzJom4A9y6EDce8HgSYQMUgGD2ROgrpW24NlAg7KB62YcbxCDWt84l2VSF5RUGFXHP9+eTbKHZ3rURrhgjgbGljriUsXVwfzZIPIPFivCDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z2mXQHaZN/dBWzFXb4SOG+ANGzeeNjA4ZwGiXpvgu8k=;
 b=Vwl1QuEqWwSHolJqiH0Lr9ocGQPMIcOuxs+JY5wCgdix2ItEtUuphfmr0OprCtDCT25LwId3RA4nUOA7gFQsMBugidxiwMxPDLDimzzQ0Kg/yXv8zJOXyvYsBkoQefgdtRYyin3v0CxovJExf9L861sjlESjaMOC70jYuy82tMrbMFgl+9nveLNUSuK7iPeB88epjEIgCZ03s9+B1k+4YQdaHK4Ka4tnBrs/GIuVf9ANg7I3Pn7+UwMAxQ5F8+RoFfpSHvS5fTcNyMyAiacZChkmtXNpueJ5lx5n1bmk0nEfYQMqt7Thzp1jux+MUzhFd4JWZZeV9B//g5bS2XRIsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z2mXQHaZN/dBWzFXb4SOG+ANGzeeNjA4ZwGiXpvgu8k=;
 b=fR0bKok1wDCuDypDqgnSNJpSwEwhu6yJ56PZLGf7c9mkq8ILlU4ixvpwEe8rCGPWzjZYMLGC4LE5mL/RRr2uFETpnwh7y/eL/krB5zFghZcYvN/u1P9TPpnjaQidVMgwbX/v7S33+/2XfzA3ce+Hmj8fFZvTqh/aQnh2XGrMNyk=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3775.namprd10.prod.outlook.com (2603:10b6:208:186::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Mon, 29 Nov
 2021 17:20:19 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%7]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 17:20:18 +0000
Message-ID: <a3e8da96-2895-753a-4d4c-61e86a4306e0@oracle.com>
Date: Mon, 29 Nov 2021 17:20:07 +0000
Subject: Re: [PATCH v6 09/10] device-dax: set mapping prior to
 vmf_insert_pfn{,_pmd,pud}()
Content-Language: en-US
From: Joao Martins <joao.m.martins@oracle.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev,
        linux-doc@vger.kernel.org
References: <20211124191005.20783-1-joao.m.martins@oracle.com>
 <20211124191005.20783-10-joao.m.martins@oracle.com>
 <0439eb48-1688-a4f4-5feb-8eb2680d652f@oracle.com>
 <96b53b3c-5c18-5f93-c595-a7d509d58f92@oracle.com>
 <20211129073235.GA23843@lst.de>
 <b8056071-d0fe-b8ef-5fe3-85ab639f4bf7@oracle.com>
In-Reply-To: <b8056071-d0fe-b8ef-5fe3-85ab639f4bf7@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0214.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::21) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.187.247] (138.3.204.55) by LO4P123CA0214.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a5::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.19 via Frontend Transport; Mon, 29 Nov 2021 17:20:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59d4df88-3669-4229-b562-08d9b35c8438
X-MS-TrafficTypeDiagnostic: MN2PR10MB3775:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB3775052380B348C98306FEC8BB669@MN2PR10MB3775.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	cVN0PFHNrsq/hoCrxWDgSULFJMr+e85RkbiH/bU0cdJVvsjCQui/l9XTjLRuoS9IrHCOLKd+NxWP7fA+5x5tdy7O+8KUWg1XlZYCzEN0QzGAo4XEXOvGzaBNf+aATqw7zaOriDSn6J73iS8/5rs5LgkBdol/L6yNOTD81SjvKWlXaLD0eoph8Qn+thROJuou7GqByhbhviq+0+XAC7zteqq9panRbxgIedO6kG9Rhip5h0aLJB0Q2wUJuXFh0OZIGQrBhtgUti7mxswKsAQ+0N00UM7tvRWh0IQYgaOj/nhlLjDc9ZulOSH8Zus98QsXbQq5+Ahv6DbuuUlvgF7bzKGenpVz+sIAFzltEkEbvCOStYqk41nn7HXQ3jkrIzhhigjfMMBLXhWXtzHWEcGERkm3wVpIJ1lh7jJfRhI2hJBD9GiaOniztRvoD3KZT0ZBTfoFU+NUqw6KTX4dLQKEonxeAM3E1d1UvKQ/0TkhDdd6SfxS0N+FMx090YuH1z1tMSjSMG2Kqj8rB05CpDfc2knDOpLdtzOjm/wimySws2DpF8VganUbIj6dQSbhvv02m1ayadenIwH4d0jP/zcct7Ru+H+KNplFiIkUdZeJKunRzGJMpYwWF7rSUAaTwf/D6+QeUf6cROD1WRXlbSDWue5ein8q8ZQBo0Z464ascBj3rN1FKiJg1qGrA0EmxkEk5fXncnIfuSklZy+WGmg9mQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(2616005)(4326008)(508600001)(956004)(7416002)(8676002)(66556008)(6666004)(66946007)(31696002)(86362001)(316002)(66476007)(16576012)(54906003)(38100700002)(8936002)(83380400001)(2906002)(36756003)(31686004)(6916009)(6486002)(53546011)(26005)(5660300002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?SjI0OC9sMFVnT0RXVWVtWFJTdlNqQS93YnBXMXl4TzhoamMvT2ZUR1lSVFVO?=
 =?utf-8?B?MVRCc2Qrak9LMmQyUkhzaUMzNzJLdUhIazRIT0tLVWJvVjBKTkJXRE9TQytU?=
 =?utf-8?B?RGxRZnFLMHVvcmlteExVSE4rSkhSbHRPYjdQSnlWaHJkZEpJeHFaRkZlOUdI?=
 =?utf-8?B?WFFUdzVyUjdBcUNYWlA1azVRbTlBak1yc01GYWtsODZyYnNBRU91T2l3TjF5?=
 =?utf-8?B?dEYzTUFqbEFvREQ0V2FwSzB0OVVQTmFGTXlaUzdBM3FvdXZFakI2WElUaS90?=
 =?utf-8?B?SDVFa1FoYkxOMS80T3NqWUlWMHowd0Z1Qm5zQUFmMVBteVM4UHpQS0pacnVW?=
 =?utf-8?B?YmVlUlV1Qm9lczJIbTZYSlNQazg0RUFIZEtaVHExQTY2bmlBMDJvLzJaamRD?=
 =?utf-8?B?cjdaTE82dnUzUzQ0MFQxRjNrT21mNUt0Qy8zQU9nZEhpWmRVOUFDSWpha0Fo?=
 =?utf-8?B?SHJBWGlZV0VOTllUN2lJQkdOOGoxNUxFS0ZSZE41aU5naWxxcUo0UWlUM2RG?=
 =?utf-8?B?VUZSYnp5aGUzM01oS3F5Q3BVUmpibHB3SnVwRjBycFdtaUsza0VHMFRaNk5W?=
 =?utf-8?B?OE1uc1Q3VnBXQkNBL2NGcEg4U0tScWlqZUtBMzhsa25GUlVFU0tIL3J3b3Vm?=
 =?utf-8?B?Y01UU1VMZGNaOW5WeEtOenFHL012UlNrQXNkR090YkhyRXFWNjBkUXJLaGpZ?=
 =?utf-8?B?RWNPb2RZUjlGb2Q1NGJyc2k2bkdlczBMdXFSMkNaRlRIZjVISjdidjkxS3B4?=
 =?utf-8?B?LzZ0Tm9IZ0tFckxEeXZRQ0krSFNNSWtwTmVIby8yUzdmK3VzM2EzK1NlcjR3?=
 =?utf-8?B?eTZEV01lRWxUN1duWlQzNUJRZXBraml0OHpLenI1ZTk3NXBmeFF1R1YvT0do?=
 =?utf-8?B?SDJHblhPcVRlNHJWZ2VrTkJ6TVpWMnJvVEFDLzRmZjhrdUJFNVRQSXFVd3l1?=
 =?utf-8?B?akdsMkVwVGNyeG9FU2lLS0d4RkVURG1tMVB6N3FsNGZxYjNPaS93cVZ4aENJ?=
 =?utf-8?B?bjBzdWJiRlczUGdkQ3hUVFgwYmwrQkx4cWpBeG9XdFdkMkZxaHBzNFBPcFZP?=
 =?utf-8?B?LzI2MVkrcHozSEQrb21iU2FvaG42eHlkalViSUMwNUtIOXpSNkJhcUJwTFRr?=
 =?utf-8?B?aWk0cGcrbEpXU2RoeXd3VW92Y3BmdzNndFBWd000OWxreWsxaWV4N3ZYckJS?=
 =?utf-8?B?WWMvWUZ6YlV4cHM2NGRvS001TmJZU3B1OXBCMXFGS0hjNktaU2hWYk15bHF4?=
 =?utf-8?B?SVpZU1dLTlg1NGJsSDMvYjNMdS90Uzh3dTlmTjM1Zi84aGh6NlR5cVFOamoy?=
 =?utf-8?B?QzBaQm1hWEdtanN4ZnV3WTRDbmY1QVRJTlFaUUlqZUlUaWE0UnFMOE5nc0Jm?=
 =?utf-8?B?ZitkRG5ya01iNzQ2MFZnNXM3MTJabnBMcG9ZWm9sbzI0aXF4bFN0TiszN0hl?=
 =?utf-8?B?VXpaTHZpR3JpeHpyZmFMV1dSZUFRd1Y4SWNKUW8wVzBITzhUT0w4ODJyeCsx?=
 =?utf-8?B?bHp4ci9HbGtTQ3dmdFJTUnhLbEVNRXhnZ0xxamZtdWNiUS82Y1FEaXl2aE1h?=
 =?utf-8?B?TnZqLzJHeWRteTByQ1ZDN2FlM1lrRHEyWVFTOGRhQ08wSzY0L21uY1htYXNv?=
 =?utf-8?B?em1qbDZJeFlweTJZbnp2SkFwVGg3bnZnVGZ4MldxNmcwQmVvVFRUREw1V3Bj?=
 =?utf-8?B?dXpqY25FQTZIZUtJMkh2cGxyNVYxUDc5QlNjemFjeWJneFBxVE42MmhaNnpP?=
 =?utf-8?B?MzRKYmJjYU1qNVBXVU9nTVlYa0FuWkVpUURRSE4wbVByY2krcFNLb05kanF5?=
 =?utf-8?B?NlZIQ2RaakJiZEF4ZXZQeElZNHlVQUJQV1dyQnBBUVNUaldRc2Q4T1dERHNV?=
 =?utf-8?B?ajdsMW41THM2MlpwN0pPWkJRUnRHdFhESlV3TGR0RkowL00zMFFzSnVheGF0?=
 =?utf-8?B?NDEvWnNsb3llVXZxQjJjL05zSnZDREY1QmNvUUJKUzFNREUvN2Z0dXAvNTBN?=
 =?utf-8?B?bGVjSFlVeVpadDE0MHFlcEF5YUJnV3V6NURtYWl6TW1IYU84MWtSb0Y0YTUx?=
 =?utf-8?B?M1FoR2dKRGJ1UWFCclRpNlg2Qy9NUWJDcTI0cTJWQzVFYVBqVEY4Wk1KamNG?=
 =?utf-8?B?NjNySWFmYjc2TnFMdTQ5dmhjYnVBK0tXeUxSMWRNUm5tTEM0aVlUMlF3b0lt?=
 =?utf-8?B?OHZYWVY0LzVvak0rODN0dWZoZ0pVZFBNL3JQODZ2bDdWcU1EZUhxbXpiV3lh?=
 =?utf-8?B?SVUvd0FFbW9pRnk1bk5JbjNsNExBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59d4df88-3669-4229-b562-08d9b35c8438
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 17:20:18.8388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x9RgxlRh+tRN1dDBMQDIUH9Mb3iBvG6iecOXtlpRZby4ScyMxvzMnSxkwCr0ZmHHlSzhmquffglvfFN2MG9vbgHmDUrzdITVM9gLkjpEKSQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3775
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10183 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111290081
X-Proofpoint-ORIG-GUID: u_QwepFdWgINkawH-4ufcYuAu4rfoBXx
X-Proofpoint-GUID: u_QwepFdWgINkawH-4ufcYuAu4rfoBXx

On 11/29/21 15:49, Joao Martins wrote:
> On 11/29/21 07:32, Christoph Hellwig wrote:
>> On Fri, Nov 26, 2021 at 06:39:39PM +0000, Joao Martins wrote:
>> Aso it seems like pfn is only an input
>> parameter now and doesn't need to be passed by reference.
>>
> It's actually just an output parameter (that dax_set_mapping would then use).
> 
> The fault handlers in device-dax use vmf->address to calculate pfn that they
> insert in the page table entry. After this patch we can actually just remove
> @pfn argument.

I've added your suggestion as a cleanup patch between 9 and current 10 (11 in v7):

---->8----

From 999cec9efa757b82f435124518b042caeb51bde6 Mon Sep 17 00:00:00 2001
From: Joao Martins <joao.m.martins@oracle.com>
Date: Mon, 29 Nov 2021 11:12:00 -0500
Subject: [PATCH] device-dax: remove pfn from __dev_dax_{pte,pmd,pud}_fault()

After moving the page mapping to be set prior to pte insertion, the pfn
in dev_dax_huge_fault() no longer is necessary.  Remove it, as well as
the @pfn argument passed to the internal fault handler helpers.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/dax/device.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 19a6b86486ce..914368164e05 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -95,10 +95,11 @@ static void dax_set_mapping(struct vm_fault *vmf, pfn_t pfn,
 }

 static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
-                               struct vm_fault *vmf, pfn_t *pfn)
+                               struct vm_fault *vmf)
 {
        struct device *dev = &dev_dax->dev;
        phys_addr_t phys;
+       pfn_t pfn;
        unsigned int fault_size = PAGE_SIZE;

        if (check_vma(dev_dax, vmf->vma, __func__))
@@ -119,20 +120,21 @@ static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
                return VM_FAULT_SIGBUS;
        }

-       *pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
+       pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);

-       dax_set_mapping(vmf, *pfn, fault_size);
+       dax_set_mapping(vmf, pfn, fault_size);

-       return vmf_insert_mixed(vmf->vma, vmf->address, *pfn);
+       return vmf_insert_mixed(vmf->vma, vmf->address, pfn);
 }

 static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
-                               struct vm_fault *vmf, pfn_t *pfn)
+                               struct vm_fault *vmf)
 {
        unsigned long pmd_addr = vmf->address & PMD_MASK;
        struct device *dev = &dev_dax->dev;
        phys_addr_t phys;
        pgoff_t pgoff;
+       pfn_t pfn;
        unsigned int fault_size = PMD_SIZE;

        if (check_vma(dev_dax, vmf->vma, __func__))
@@ -161,21 +163,22 @@ static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
                return VM_FAULT_SIGBUS;
        }

-       *pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
+       pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);

-       dax_set_mapping(vmf, *pfn, fault_size);
+       dax_set_mapping(vmf, pfn, fault_size);

-       return vmf_insert_pfn_pmd(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
+       return vmf_insert_pfn_pmd(vmf, pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
-                               struct vm_fault *vmf, pfn_t *pfn)
+                               struct vm_fault *vmf)
 {
        unsigned long pud_addr = vmf->address & PUD_MASK;
        struct device *dev = &dev_dax->dev;
        phys_addr_t phys;
        pgoff_t pgoff;
+       pfn_t pfn;
        unsigned int fault_size = PUD_SIZE;


@@ -205,11 +208,11 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
                return VM_FAULT_SIGBUS;
        }

-       *pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
+       pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);

-       dax_set_mapping(vmf, *pfn, fault_size);
+       dax_set_mapping(vmf, pfn, fault_size);

-       return vmf_insert_pfn_pud(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
+       return vmf_insert_pfn_pud(vmf, pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
 #else
 static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
@@ -225,7 +228,6 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
        struct file *filp = vmf->vma->vm_file;
        vm_fault_t rc = VM_FAULT_SIGBUS;
        int id;
-       pfn_t pfn;
        struct dev_dax *dev_dax = filp->private_data;

        dev_dbg(&dev_dax->dev, "%s: %s (%#lx - %#lx) size = %d\n", current->comm,
@@ -235,13 +237,13 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
        id = dax_read_lock();
        switch (pe_size) {
        case PE_SIZE_PTE:
-               rc = __dev_dax_pte_fault(dev_dax, vmf, &pfn);
+               rc = __dev_dax_pte_fault(dev_dax, vmf);
                break;
        case PE_SIZE_PMD:
-               rc = __dev_dax_pmd_fault(dev_dax, vmf, &pfn);
+               rc = __dev_dax_pmd_fault(dev_dax, vmf);
                break;
        case PE_SIZE_PUD:
-               rc = __dev_dax_pud_fault(dev_dax, vmf, &pfn);
+               rc = __dev_dax_pud_fault(dev_dax, vmf);
                break;
        default:
                rc = VM_FAULT_SIGBUS;
--
2.17.2
