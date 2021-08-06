Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1ED70
	for <nvdimm@lists.linux.dev>; Fri,  6 Aug 2021 12:29:17 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 176CGQXe014707;
	Fri, 6 Aug 2021 12:29:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=JT402tGplsVte7Kz3nXZyQVGygzvV/KOKVvHb85330U=;
 b=pFXTNAU5gKYLdqNYEC8e4NfE9MmyNxeHfs6Vf1alFNHeUGphi1hQmXFHT/jG7SVZUe9c
 Dj0Sj7tMTCtFlkQAJWURJZZjSQSJoJAS75ziD749ZVL8d4SBKNJCq0+2tun3lpoj5CUp
 974mMM9HDMhAVxi4aN+tcSxDtq+cQ8K6mbzBc4wSax+kCyTDaG31fU+JPALzAyZHrPfy
 q7e6xX0qNbTc05vOpmjTyHf8ENtboS0D/5k+XhPbJjOsQsAjrhKtlwY/2B3VF3eqFWFZ
 o4l82X/tgoAqyTwY5xYQwULoOZ+Jk4G6mcpJILJPAPmg9U25kiY+OM5fWuaq+nJEtIpg tw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=JT402tGplsVte7Kz3nXZyQVGygzvV/KOKVvHb85330U=;
 b=F++w5RaCSWEnAHZX8sjsYE2JoeQsKNEX5SIOoCJMmCg44qHQGYepU7kVgL0iI26VzF4j
 oynfrU3T+rxHwbDxvapAyW/CY+K3netHrtDtIPTWasT6mpAr5rbdx2V7ggyvKDBNnvP1
 GDJ/+8eEM2NeJ6pDiv19DisVJcNiqx6Voy559jnCnWUxdznpAtRvDARumLV1KeLTvERD
 Z3NlU/6zdMLSd2tCrpGq6F4GAznQboTpqQSYuhy2ANZ3UILVa4r7pmL++70ZWtZw4mPq
 zTh9v4g2yy2EbqQle3ZQkP/EdM6NzLLge03aM2U2nboF3fRQUvMywAo2Cz62nwBCrMB+ Fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a843pbwc3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Aug 2021 12:29:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 176CFas4143294;
	Fri, 6 Aug 2021 12:29:01 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
	by userp3020.oracle.com with ESMTP id 3a5ga263ua-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Aug 2021 12:29:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6JADyD7p2gR9qi1PI9SMNkRpn77h5mN0u5jCM7Gdxae62zQSNw0rHTDCpTXOBJL9eg7fpSFJw3YF7hsOedv4V+Izcdtx1BIpwwVvNSI0iZ26gW/64ymKN/l1rmaA44GV24CbtFi/INY3g4957F0Pvuyz2sjWjCvyUbgNohuDumUor8i79E4b7D1HVzGf/VEJEUskdpjUuUzKWB2xRWQZ7yPjFg9aA5N4hAY6YHR3ulUFMJI3qvusaohgkrWTjfHY5JVPEGkF0KCTMEtQcqTVgVOkxjjkdAqRGiElSYuMKY7tlN3/+7my6HUMaBN5lAS+w4oG0SrisC3sArPiFLjFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JT402tGplsVte7Kz3nXZyQVGygzvV/KOKVvHb85330U=;
 b=UOlXGi3qVEl+hOVIF56rW9VDKqcNujZ0y0n0tZkQ/HHGjUJvct2lcHoGcZTr1hENxjafwaGnS0yCF7gTRk1mRyHIWwx4AK9DW5riRm49AfbjJxB7hXO6PhniQn6duWrpTjCyW9c4gtJbpiaRiBQr9QT3gmarlgDyjN+RBEg/t6bfl6BA8twGeNKlmrf1ggEzrNMiIp/lZCKoPk6Oo75njvftPEKB0WXlBTnHT0bFaVrbjfZO6JFQSmUi1hk7+6KCf2JXvDxQ5bD3wWniB78GVAkK8cwgDuzbel/DeGt3hGv/JGngt+tPzu2QeDixmNmzbRpvIQUV57yjGNJUUyWIQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JT402tGplsVte7Kz3nXZyQVGygzvV/KOKVvHb85330U=;
 b=miivkpqKIlks+fG/3zCKYQmA0wWylrnbjtyiARYLPR5/Lc0XQDYYBCqN8T+A17NDBk5ZbUvhjiTlIf+SfF7F+6/v3AaHvjogiHHxvls8nEBFmoLZikBx7zPg+CRnvWpAjbjF7wHEmbePSUQSgUZXhQTvWrUdyOV6WX3G5GWEUjg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4238.namprd10.prod.outlook.com (2603:10b6:208:1d3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.18; Fri, 6 Aug
 2021 12:28:59 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::31f7:93c3:6886:1981]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::31f7:93c3:6886:1981%4]) with mapi id 15.20.4394.018; Fri, 6 Aug 2021
 12:28:59 +0000
Subject: Re: [PATCH v3 11/14] device-dax: ensure dev_dax->pgmap is valid for
 dynamic devices
From: Joao Martins <joao.m.martins@oracle.com>
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
 <20210714193542.21857-12-joao.m.martins@oracle.com>
 <CAPcyv4hv+LXmAs-BMATuyoPLRAF_-+d5Yap450sbCDFTcvGO4w@mail.gmail.com>
 <9e361442-f8e9-cdac-ce7d-94c0bcc6cb0a@oracle.com>
Message-ID: <21b65b9d-fa76-727d-6db5-02b0c19f2124@oracle.com>
Date: Fri, 6 Aug 2021 13:28:51 +0100
In-Reply-To: <9e361442-f8e9-cdac-ce7d-94c0bcc6cb0a@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0172.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::15) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO4P123CA0172.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:18a::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Fri, 6 Aug 2021 12:28:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b401ae4d-b057-4d4f-125a-08d958d5c3d6
X-MS-TrafficTypeDiagnostic: MN2PR10MB4238:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB4238E0FFDA621C22B6A0B374BBF39@MN2PR10MB4238.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Xt8F7j4Aimoc25Dq4cvGzE2aUXoiBF32ZGcJcQz9apVD505mTsbUG+5JpttC+gdbkxgacWdeUg1crhyvHbH288kiOCXyYrANp1K85lWwelqa2c9C/A37+WmLbdQ2xwLQwdGLRWWaLCDqwreHOfm1WT+TXDzWPjcPR1WsicyXGQKKH4VAErCwQQhaeB9XhQCiFEvZlfZsJPramyYBvD+ugTzUfEzmoXdW2SmiP3/235JDxKMxw68vmeLvxn5CtbRfAKF26dl8baNWQwgEcnICWkn7PzH9SLHIx7wrXy/tji6lVkxjJA9uirs8nuew57Yi/vBku6dldbZgUz+QO+ZNSYpJyKtS8qaCumDJ7Hg324IsMwrzemBfKtYjMAJtGVjlcNVw1Ymz1vAxlN1rx5v60zzikFI4DhXmiKaY6QgeJKWP9iGNNbSRP3LuvqzzLqHffv5n7YcRWyXFrxRyGmSEARujrC3lTs2jekp5hFWXU0j+OltpGfN2/aa1NAwAV0QGwUsw4x4DCBoBHodpmyCElv2llEzSXUcZd+7vsRwk7Y9X8RmdO5xrpaNrMHo/XwmM4uvtI7JWJlhGLOpRt65lM7OUQp0vu/6WDNCBrHdC5keo8gUy2nbLvbyxBFJNudU0LqFtz3owVUveEBnNnw6daeYR9W9MMEVjVC8GpV6RxOd7S7FDYLXQH4COrJaiOcAOR7396QQ8qlFLD2Ik5+mzNA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(346002)(366004)(376002)(31696002)(6666004)(4326008)(2906002)(53546011)(6486002)(26005)(86362001)(83380400001)(31686004)(316002)(8936002)(54906003)(36756003)(7416002)(186003)(38100700002)(6916009)(16576012)(8676002)(2616005)(956004)(478600001)(5660300002)(66556008)(66476007)(45080400002)(66946007)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?L05EYkNjRktKajJxeXRKUlF4VHdwWTQrTzhnQ2doMHFJdGxtQU9iRjVZTGto?=
 =?utf-8?B?WitsaXVreXM0K3NsdTVEVnVtL3Q3WWhxR2ViS0I0OFpFQ1JnT1pSblluLzRi?=
 =?utf-8?B?WkJhczFNTDk2VWN3WEUvZEN0bERNWGZ4dC9iaUFnVnk2RzM5RDJqWEpKRVZK?=
 =?utf-8?B?dkpQdFNSeHNPVU1EQkRhUGNhUnVKTFloWXpzYnd3R0xKUnh5K3ZMRVY2RU54?=
 =?utf-8?B?Q2VWQk5OR1NEWlVEVHZvc0RYcytOUnIxdDZzVVhBdXhOdHk4eFNqeWFlYkJu?=
 =?utf-8?B?WWdiRWRWK1VUM2JhOG0xRGlXb3pXWVVlSVNaTW43QlFFSk4xOEM3Y1doRDh6?=
 =?utf-8?B?ckJzS3ZBQlVrNTI2NStsVG9teW5SY1MrK2ltTWJDWkJDcExMQ00xSDdtZGFF?=
 =?utf-8?B?NWlWLzBsSmlJcVU0ZWJJczU4NnMwak9yS3BVSnVRamwxM2llVzFRUER4OTJC?=
 =?utf-8?B?QmR4OU9FbHNNM3VpMWR3TUZRN2w5dC9JMnByNDVxbnNlbEZSTXZpQ3VUTW4w?=
 =?utf-8?B?RjM4bEhaczY4dFQxS3dPdDRWaEtmM3pxSDEyd1h4eVNBYnloWWNCM2JySWxl?=
 =?utf-8?B?QWxibU5wMk5zTHR6dXhxdCtmcTE1VVFjV3hjME9mOENuVk1ocGhyVDNucHFL?=
 =?utf-8?B?Mll3Zmh3V0NhdXUxTU5WRHBaUVpPN0lROFZaMXUxZk0zZ21ydzFmNkZmcEFx?=
 =?utf-8?B?T0ZDSVZ6Z1ZndVhjdnBUYXhFL2dtaWJEWGw3ZC8rNVRadXM1ZmpWYTNTK2x6?=
 =?utf-8?B?Zk9lT2xoNk9tOTE4ZjBNd21sR3drY0NLNklwK29HSFIvdGhibDNQVURBcEFn?=
 =?utf-8?B?c3FFZTAvelZUakIyUzRqY0ZLNHpyTjhnVjdoSWlpNEd4eFFpcmZDODZvV2Nt?=
 =?utf-8?B?OE9yV1NjUlpGYmxFeFVqRzcvZGFCWGMyR3FnY1kyYW84OFh3aWIzeWtHSTVO?=
 =?utf-8?B?Q0FsMDk4Y3BET3JLNGMrTndyeGZoWmNwa2V3WnVlNUNuWWhtbXpseDN6YjZu?=
 =?utf-8?B?cHdGdEtWQjBHTitoNDFtMStjK2NjL2grRjRxRXFEeXBjazZoVk9TQTBoT2sv?=
 =?utf-8?B?TExwSUQ4VHMwRXNEOGZpNGR4TXcxaGR5RUx0bk5YTXh2azh4SEtCNW9FTWMv?=
 =?utf-8?B?K1hyZFhybkhBU2pLTTVpenR0c004OW80L29nblhhQUM5RVFrNm5uMlBhZmtH?=
 =?utf-8?B?eElBN0RBSFFoMXJ4bjdEN0Zndk9qM3dTaW10WWJwY2sxeW9lTC9DWks4UWtx?=
 =?utf-8?B?ZWM4L3RnUDFWMVdKUkw2N1libHUwVzQ2cGVOYWVINmlPYmFWY0RnN0pubDFl?=
 =?utf-8?B?eTBpRXRlR0ExWmE1ZUxZWnprM21kQTRMQ2xRVWlRZllaekpZOFYxTDFTWmZI?=
 =?utf-8?B?MWYzS0EvbW96TTdhRStySmgxakVTVUFYZWhhL1MvUzZ4UzMvekdXMFFkUk1y?=
 =?utf-8?B?M3Vtd2dtVlRGbUNzUWljUVc0NG84VGx3R2tsMVRzUWpMRWdJUDRPMjN4V2pK?=
 =?utf-8?B?S3poYXRLWCtZR1RjOXlEMCt1Z0JrMjF3WjMwcXcrZVhrdXhtWVBmYXF4Vm5W?=
 =?utf-8?B?RW1iQmlQSXlRTWpBb3RvRm1qd1pPTkdYd2JOMzZrQ2MzVFBIWjhmT1pjMHZU?=
 =?utf-8?B?NkdDYWZNUlpLTmVHcFV2M3RNTVU4ckQ0ZnpCSmhXT2Q0VVl6WkJlNmhFSUxK?=
 =?utf-8?B?VXhRUTV1NWJjeWN2bmdkeXhoZzJNUllWOHp3UnIydmtsUFM5OHF4TjVEdXJH?=
 =?utf-8?Q?DJ029/bcG6J7uoa3mZf4PjwQYohDVGM1H0bwKvx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b401ae4d-b057-4d4f-125a-08d958d5c3d6
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 12:28:59.4396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WhPqAppOaQGDO0mASqFkE14zORD2XDYz/XCcxpEoNx8WFdgQENPR+oeAKNGJbtudLQOXnst8qYpGaQRpQuetMkld5T3qi5HnDqdGEbEn0QY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4238
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060087
X-Proofpoint-ORIG-GUID: 2wHpSo2lPUeQnxslO6RrQ7rZsJIyIPwP
X-Proofpoint-GUID: 2wHpSo2lPUeQnxslO6RrQ7rZsJIyIPwP

On 7/28/21 4:56 PM, Joao Martins wrote:
> On 7/28/21 8:30 AM, Dan Williams wrote:
>> On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>>>
>>> Right now, only static dax regions have a valid @pgmap pointer in its
>>> struct dev_dax. Dynamic dax case however, do not.
>>>
>>> In preparation for device-dax compound pagemap support, make sure that
>>> dev_dax pgmap field is set after it has been allocated and initialized.
>>
>> I think this is ok to fold into the patch that needs it.
> 
> OK, I've squashed that in.
> 
I am wondering now whether I should un-squash this into a separate patch.

It regresses one of the test suites from ndctl for dynamic dax regions. memremap_pages()
calls (from a dynamic region) starts hitting rather random splats (below) on the 'root'
device (not the dax device children aiui). This fixes it but I am yet 100% if should be
this way:

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 6cc4da4c713d..2a3a70e62d89 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -363,6 +363,9 @@ void kill_dev_dax(struct dev_dax *dev_dax)

        kill_dax(dax_dev);
        unmap_mapping_range(inode->i_mapping, 0, 0, 1);
+
+       if (!is_static(dev_dax->region))
+               dev_dax->pgmap = NULL;
 }
 EXPORT_SYMBOL_GPL(kill_dev_dax);

stacktraces:

[  834.884765] ------------[ cut here ]------------
[  834.885887] nr_range must be specified
[  834.886461] WARNING: CPU: 3 PID: 3148 at mm/memremap.c:347 memremap_pages+0x54f/0x610
[  834.887578] Modules linked in:
[  834.887993] CPU: 3 PID: 3148 Comm: lt-daxctl Not tainted 5.14.0-rc3-next-20210729+ #201
[  834.889131] RIP: 0010:memremap_pages+0x54f/0x610
[  834.889886] Code: e1 97 00 0f 0b e9 14 fc ff ff 80 3d 11 99 79 01 00 0f 85 3e fc ff ff
48 c7 c7 e8 78 5e 82 c6 05 fd 98 79 01 01 e8 f8 e0 97 00 <0f> 0b 48 c7 c0 ea ff ff ff e9
2f fb ff ff 48 c7 c7 b0 a7 d1 82 e8
[  834.892491] RSP: 0018:ffffc90008fb3b40 EFLAGS: 00010286
[  834.893249] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000027
[  834.894250] RDX: 0000000000000000 RSI: ffff88900fcd7610 RDI: ffff88900fcd7618
[  834.895283] RBP: ffffc90008fb3b98 R08: 0000000000000000 R09: c0000000ffffefff
[  834.896286] R10: ffffc90008fb3930 R11: ffffc90008fb3928 R12: 8000000000000063
[  834.897279] R13: ffff889042856430 R14: 0000000000000001 R15: ffff889042856400
[  834.898279] FS:  00007f83ddfd8780(0000) GS:ffff88900fcc0000(0000) knlGS:0000000000000000
[  834.899423] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  834.900194] CR2: 00007ffdb895c148 CR3: 0000000106bfc006 CR4: 0000000000170ee0
[  834.901195] Call Trace:
[  834.901651]  devm_memremap_pages+0x22/0x70
[  834.902244]  dev_dax_probe+0x175/0x2b0
[  834.902797]  dax_bus_probe+0x73/0xa0
[  834.903285]  really_probe+0xcf/0x3a0
[  834.903801]  __driver_probe_device+0xb3/0x130
[  834.904363]  driver_probe_device+0x24/0x90
[  834.904967]  __driver_attach+0xa1/0x170
[  834.905525]  ? __device_attach_driver+0xe0/0xe0
[  834.906164]  ? __device_attach_driver+0xe0/0xe0
[  834.906818]  bus_for_each_dev+0x74/0xb0
[  834.907321]  driver_attach+0x1e/0x20
[  834.907875]  do_id_store+0x1db/0x210
[  834.908352]  new_id_store+0x13/0x20
[  834.908865]  drv_attr_store+0x27/0x40
[  834.909398]  sysfs_kf_write+0x3b/0x50
[  834.909968]  kernfs_fop_write_iter+0x128/0x1b0
[  834.910635]  new_sync_write+0x117/0x1b0
[  834.911139]  vfs_write+0x181/0x250
[  834.911644]  ? do_sys_openat2+0x1d7/0x300
[  834.912216]  ksys_write+0x61/0xe0
[  834.912698]  __x64_sys_write+0x1a/0x20
[  834.913242]  do_syscall_64+0x3a/0x80
[  834.913772]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  834.914491] RIP: 0033:0x7f83dd4cda00
[  834.915010] Code: 73 01 c3 48 8b 0d 70 74 2d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f
44 00 00 83 3d bd d5 2d 00 00 75 10 b8 01 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48
83 ec 08 e8 7e cc 01 00 48 89 04 24
[  834.917543] RSP: 002b:00007ffdb895f308 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[  834.918627] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f83dd4cda00
[  834.919650] RDX: 0000000000000007 RSI: 00000000020c639d RDI: 0000000000000004
[  834.920658] RBP: 00000000020c639d R08: 0000000000000000 R09: 00000000020c45c0
[  834.921649] R10: 2f7861645f656369 R11: 0000000000000246 R12: 0000000000000007
[  834.922670] R13: 0000000000000001 R14: 00000000020c71b0 R15: 00000000020cc2e0
[  834.923650] ---[ end trace 61ea8560dbeb3a89 ]---

[  835.941573] Hotplug memory [0x0-0x0] exceeds maximum addressable range [0x0-0x3fffffffffff]
[  835.944269] ------------[ cut here ]------------
[  835.945412] kernel BUG at mm/memory_hotplug.c:316!
[  835.946574] invalid opcode: 0000 [#1] SMP PTI
[  835.947622] CPU: 6 PID: 3593 Comm: lt-daxctl Tainted: G        W
5.14.0-rc3-next-20210729+ #201
[  835.949845] RIP: 0010:__add_pages+0x100/0x150
[  835.950899] Code: ba 89 55 d4 e8 4d 32 00 00 8b 55 d4 48 83 c4 08 89 d0 5b 41 5c 41 5d
41 5e 41 5f 5d c3 31 d2 eb e0 0f 0b ba ea ff ff ff eb e2 <0f> 0b 80 3d e6 43 dc 00 00 ba
ea ff ff ff 75 d2 48 c7 c7 b8 35 5e
[  835.953662] RSP: 0018:ffffc900094bbab0 EFLAGS: 00010246
[  835.954336] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  835.955276] RDX: 0000000000000000 RSI: ffff88900fd97610 RDI: ffff88900fd97610
[  835.956251] RBP: ffffc900094bbae0 R08: 0000000000000000 R09: c0000000ffffefff
[  835.957214] R10: ffffc900094bb888 R11: ffffc900094bb880 R12: 0000000000000000
[  835.958154] R13: 0000000000000000 R14: ffffc900094bbb50 R15: 0000000000000000
[  835.959097] FS:  00007fd63c55e780(0000) GS:ffff88900fd80000(0000) knlGS:0000000000000000
[  835.960163] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  835.960960] CR2: 00007fffc4d7abd8 CR3: 00000001126f2001 CR4: 0000000000170ee0
[  835.961903] Call Trace:
[  835.962220]  add_pages+0x17/0x70
[  835.962696]  arch_add_memory+0x45/0x50
[  835.963175]  memremap_pages+0x2a8/0x610
[  835.963726]  devm_memremap_pages+0x22/0x70
[  835.964223]  dev_dax_probe+0x175/0x2b0
[  835.964778]  dax_bus_probe+0x73/0xa0
[  835.965215]  really_probe+0xcf/0x3a0
[  835.965717]  __driver_probe_device+0xb3/0x130
[  835.966248]  driver_probe_device+0x24/0x90
[  835.966835]  __driver_attach+0xa1/0x170
[  835.967340]  ? __device_attach_driver+0xe0/0xe0
[  835.967956]  ? __device_attach_driver+0xe0/0xe0
[  835.968589]  bus_for_each_dev+0x74/0xb0
[  835.969090]  driver_attach+0x1e/0x20
[  835.969605]  do_id_store+0x1db/0x210
[  835.970057]  new_id_store+0x13/0x20
[  835.970536]  drv_attr_store+0x27/0x40
[  835.971023]  sysfs_kf_write+0x3b/0x50
[  835.971529]  kernfs_fop_write_iter+0x128/0x1b0
[  835.972141]  new_sync_write+0x117/0x1b0
[  835.972697]  vfs_write+0x181/0x250
[  835.973130]  ? do_sys_openat2+0x1d7/0x300
[  835.973698]  ksys_write+0x61/0xe0
[  835.974117]  __x64_sys_write+0x1a/0x20
[  835.974654]  do_syscall_64+0x3a/0x80
[  835.975105]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  835.975802] RIP: 0033:0x7fd63ba53a00
[  835.976257] Code: 73 01 c3 48 8b 0d 70 74 2d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f
44 00 00 83 3d bd d5 2d 00 00 75 10 b8 01 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48
83 ec 08 e8 7e cc 01 00 48 89 04 24
[  835.978754] RSP: 002b:00007fffc4d7dd98 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[  835.979765] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007fd63ba53a00
[  835.980761] RDX: 0000000000000007 RSI: 000000000081939d RDI: 0000000000000004
[  835.981714] RBP: 000000000081939d R08: 0000000000000000 R09: 00000000008175c0
[  835.982671] R10: 2f7861645f656369 R11: 0000000000000246 R12: 0000000000000007
[  835.983647] R13: 0000000000000001 R14: 000000000081a1b0 R15: 000000000081f2e0
[  835.984593] Modules linked in:
[  835.985041] ---[ end trace 61ea8560dbeb3a8a ]---
[  835.985789] RIP: 0010:__add_pages+0x100/0x150
