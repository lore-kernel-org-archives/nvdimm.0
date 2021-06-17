Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC536D2B
	for <nvdimm@lists.linux.dev>; Thu, 17 Jun 2021 18:46:07 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HIawpr007633;
	Thu, 17 Jun 2021 18:45:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Fs4CZCkv9VqQyCxw0vq4MCFN99w0gEVGwhskncAGQVw=;
 b=UiA2+DHiznrlVY/CJ4Sd9TiJYd7Ow7bP5HRM4AamgxIiEYi0KCAY/FjXPdg3y+IE9iWs
 6j6yLi+vwpvPwJu6wnfVaMD42KrHG9wZUYj2KhsuPR/etJdozUEhKt1E9dVrVenBXtcp
 DhWM/wcV3z41vbiG6DmJIZfyOtng+wu3uiFtkIxC5mfBaBYXuLbsEI5qi1j03lm3Tlo+
 SRFSGxtKtxmbRVPN+VypkmRq3dKhvfUcDhjXmkL/dSVUy76uUkRZVb34t89bxwMqWJa0
 ZE9Tbrxz/MfCiOtfFaHNubsCSDjGA2xWOaMkcXi8AhRNQVrY66NjNpEN2ZqnO8JtqVk1 xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 397w1y1r5u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:45:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15HIjaO5180356;
	Thu, 17 Jun 2021 18:45:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
	by userp3020.oracle.com with ESMTP id 396waxy5wg-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:45:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKxQOkYoIc/lByJh+rvBwfOZH/KPKokR35ZEgvY2+cNxWF4f5uG3Z7JU9iaxYGmFM4+axgUYX8//CqSDStyeFqtQLwYItwW7RVmPqjG8Xh3WgvfiyHreVcP+iSYeVxT/I9504ht0tvC0/ZysWnA8ZMv/ZVgQX2PUtczAZywt5kQUgZR8JHf0PP1FuWbHv+SFaVPJrJdQT+yBqAmxUvIN033Xa5At8IcYyFcOtncTgqeyYrmhz6L5RZAhudstQuFwkxKdFCZvt4sHdgi+X8HcxC8xipRE0eHazJk6A65PI/rG0XrlaZsqNIZkrN1y7D0jdutBC0uGsFdupb+iSAR9Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fs4CZCkv9VqQyCxw0vq4MCFN99w0gEVGwhskncAGQVw=;
 b=FTpW6OduxUqJKHrfJkeIJaZWrhPAtR9JB8BSkYp7oN4i6dUir0L/sAisX7/lTAeeEM4ru+pP/fYKVanghIVvtiNVHCh90sbmScPQkYZ2ZPJ4YC4gVrKS2euTqMKqYOGqHwuJUGhe/AZhn4fqK/AGLf01fa8YvatDZMsEcVzFdSAeuB3zqwceCC7O0mXQ1v7FBxlYAyVQY9+WnWejCc8PW1IX5I9WAdBNXflRuijCt5h+osqrcyvrLlPW1NIEPfT59PcnrYkbIsSi0un/C35MaJmvp6NI0WhJgPXXTCkzCmR+4vyHihT9+V/P4VWwnjUf9BfzC4/W8hr6u09u48/7hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fs4CZCkv9VqQyCxw0vq4MCFN99w0gEVGwhskncAGQVw=;
 b=Hp/mU86YX7QNMADyyiFCkNPiD743evYAoh+DnKfgcUgvT2nqAeRYkt9BNEtvk/T7hGogwx0T5EGeH5nZ4L/KITHezNy6SrNJA13DOHkMxXM5lm0vvfwF5cS9vG6OONuFX0jyksI6D69swLYgDHH4VHdFVL2M+0+qWFSlCcR3d84=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4852.namprd10.prod.outlook.com (2603:10b6:208:30f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Thu, 17 Jun
 2021 18:45:27 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582%7]) with mapi id 15.20.4242.021; Thu, 17 Jun 2021
 18:45:27 +0000
From: Joao Martins <joao.m.martins@oracle.com>
To: linux-mm@kvack.org
Cc: Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev,
        linux-doc@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v2 01/14] memory-failure: fetch compound_head after pgmap_pfn_valid()
Date: Thu, 17 Jun 2021 19:44:54 +0100
Message-Id: <20210617184507.3662-2-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210617184507.3662-1-joao.m.martins@oracle.com>
References: <20210617184507.3662-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-Originating-IP: [94.61.1.144]
X-ClientProxiedBy: LO2P265CA0113.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::29) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from paddy.uk.oracle.com (94.61.1.144) by LO2P265CA0113.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 18:45:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50fb0ab1-ad29-4252-a2cf-08d931c012d0
X-MS-TrafficTypeDiagnostic: BLAPR10MB4852:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB4852E7E6403338DEE3957ED7BB0E9@BLAPR10MB4852.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Ni6nB2tJDUusgNf4b1Ck+znYrf60ZR+3szEc5cgMWeclpvePsrUQz2bds9uVwvbDy2kaNt7D4hyHYmvByqpQXZVJqIq/07ulwmHxW1AioRpxcR+wiHt4fRnjzuQKLH2IeFv85eHiumRDJuJpik6et155TzeAe790PzqtfZFREmfTp9JqiSIVKhVbLEC1DHfdIqTUeXwsUI3qw1bcssUQU4YB+eXb7HPn2465WIb87wkkH1xCTnWxgJ5eX3Zqhz0Ak+iZsm0kSfbDjzfkJQI/IdL13Y+J0N5ME+2n/N/dTe5V6E8C7Qd6UQND8ias6gGTvS3Rm0du3JcaKBTgOjZo7GZCBeWDxj/rOo0ggnc1DuSJDQg4KfwStQZiiZT19YWYEPOvsj4kRJ4E6IbzLgGHpgmbV+cu05P9vLZ0FuZTlby0aFUsJudIoImZ8jsQh7qtWe2z9Yrtb2ksXiRbRMy29SRQ77ts+psbtEDLgFtRpy91/Gf29Uf36CYwr9zU3Jt9H2h5PNQx7wvOS15bHqclf+pLgqi1jOMTFL3K8BRJpo3aQj5CrXV3uV95AY4pWThnriEiA6URuyMdNdidkNoFrEHVtvh6ds3a90yA7NBrWUgNZxBwLgRJL5f+Lj2kETt5F4Yhtn543VBrpslCLS/Zsc7UT1fa6vTRUpv7FRtNt2s=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(136003)(366004)(346002)(83380400001)(6666004)(38350700002)(4326008)(103116003)(7696005)(5660300002)(186003)(16526019)(26005)(54906003)(478600001)(38100700002)(316002)(107886003)(1076003)(52116002)(8936002)(66476007)(66946007)(66556008)(36756003)(6486002)(6916009)(2906002)(86362001)(7416002)(8676002)(2616005)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?+q+yDFW97GKJfFH0v/cqQaLUmRWK20ocxNrOC4o1ySy9anZHvRm23VRRq7Ci?=
 =?us-ascii?Q?snxVCbrcubxoia2yyycLWCyEn00cMDBOnzZzMvuRAxRzos1NeyAqR4eYOH28?=
 =?us-ascii?Q?jTkCqBQwmDsPDCRig6yim+WICTidHTmWfLS5JChjuvijSJ0yxNWtEq3yaMvI?=
 =?us-ascii?Q?KMNENOUjWggo6OOCjtmDQ+vaJW2naZUDAMwlm0wgZNb83SHSFgB5yFtDcnxR?=
 =?us-ascii?Q?WilOZbdFxwIdj8fpjtamqOTRYNXhZytA11om6S8yJaJvdP33eO6tJURPDGGs?=
 =?us-ascii?Q?tcFDUobP6NxAi/Qr51duqw94MSqQ+elOijPWGZkR8aeZu2L28456SiYdEDFx?=
 =?us-ascii?Q?zqSNgd7oQhhonzkqYXzxj6aCrqM6nkTAy1HYHHCkbNaQTTpvceZvyDtYbZsu?=
 =?us-ascii?Q?pxnDogh2bfBdI/zELyUz3rRlH3HLQHvB0BciKG1tD5qATH9yebBZBNGST8TJ?=
 =?us-ascii?Q?mO7szbyfiCMZ5xBVAggfxe74w7DJRzhCywF9qKqRUGeqGxiGPRC3pA0xBaUw?=
 =?us-ascii?Q?Q/DZ5xSZgcv1vzfSy2SdF/4LwMnh2TS23jk8cW8cKFE20XJhAed4yHkqxYaH?=
 =?us-ascii?Q?FW9DaoN4aOF4CeLU4y5oUr8i78x/hdfGKTqb3IbsKP0RzIsTd3DOEruVshph?=
 =?us-ascii?Q?x+TrjuHJdcCetRl8lQ16rYPEjSDeI2sQGXgFCDJ6OwqLPUX+/OPP0qAhJ70K?=
 =?us-ascii?Q?I/+Gsx707u1VCTbgfAgStGsCnpdYVI7dswmGAmXK7pNSe2cUQHX+h6bB9sax?=
 =?us-ascii?Q?yPDzZBSHRRNbtHMs80fiKd55mfwyUjyEYf5L2c3ds1ym+cxTxIx+MmxdaNIY?=
 =?us-ascii?Q?3nLBkksqkSwdejoaX+0kLKuV8gGPGoWgvygMj5WfsDr1HTnPLBgz4ua8txuK?=
 =?us-ascii?Q?U83TwfOfveSW4zzhxyXsG2WpE4OE0dOuJzCJEqCrqjKjyR8MbdxSosYJsJbS?=
 =?us-ascii?Q?bCk4hYsOeKnJN9Fk2pHGco4Xpm20YRKNbRbwRvspmSsnnnPnddbSbGWUle0K?=
 =?us-ascii?Q?xmQurgHPqJDT1txsJcahgvl/KjvZflxpOGVOCg1RhSFIZUyuZal8Z1QKrpJO?=
 =?us-ascii?Q?AAvXwFcZzViT+VJA9yhGio5XMtnMx5iWlmNiG5B/+Bagn6wYhQ/QyzgXa92Q?=
 =?us-ascii?Q?oebgvCW0O4tK3sp8Wnlw/LJ5tiWqnvPm+Jp1vHq4sh4fBA1AKtOxfTarsdjo?=
 =?us-ascii?Q?z513dFhhvmPxaHCK0WeWowEFRi67LfPHIUhTT8NQEPTz0zq4BcU+ePLK7+7H?=
 =?us-ascii?Q?UVbsjrQrKwg1k9l1l1re2UsVeLYHj0mDGd4Bn0YpVlS4zrqukh9jozVupxDJ?=
 =?us-ascii?Q?ipaa213+Br7eSp/rt01AYEuH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50fb0ab1-ad29-4252-a2cf-08d931c012d0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 18:45:27.1040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PWx3Aj5ZoUTs9Q+Tg5Qw1Q7zsdt5MsjwaEn8siqhn6u42ss5Jwebavjjq8Gk41wA2emW0qvA2ReuBsjW5A66WLpoZnBB+5oiMDC9fM2I7CE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4852
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10018 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106170117
X-Proofpoint-ORIG-GUID: FTJaQ_avhxf5AYXab3dmRo98HavP0URr
X-Proofpoint-GUID: FTJaQ_avhxf5AYXab3dmRo98HavP0URr

memory_failure_dev_pagemap() at the moment assumes base pages (e.g.
dax_lock_page()).  For pagemap with compound pages fetch the
compound_head in case a tail page memory failure is being handled.

Currently this is a nop, but in the advent of compound pages in
dev_pagemap it allows memory_failure_dev_pagemap() to keep working.

Reported-by: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 mm/memory-failure.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index e684b3d5c6a6..f1be578e488f 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1519,6 +1519,12 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 		goto out;
 	}
 
+	/*
+	 * Pages instantiated by device-dax (not filesystem-dax)
+	 * may be compound pages.
+	 */
+	page = compound_head(page);
+
 	/*
 	 * Prevent the inode from being freed while we are interrogating
 	 * the address_space, typically this would be handled by
-- 
2.17.1

