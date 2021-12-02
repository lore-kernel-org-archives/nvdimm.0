Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF692CAA
	for <nvdimm@lists.linux.dev>; Thu,  2 Dec 2021 20:45:07 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2KOCUm006869;
	Thu, 2 Dec 2021 20:44:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=UeGLfalTKgxkuv18hYImqm/31GTOoGT1zdUZRd5Kn4Y=;
 b=0/s2VBk8c1Z11VmBU4rl4VR3Xi+ZOCq4rI2+/rSIpTY86hNnGfxMTTvdlxl7zyyN/ySP
 16PmWgLCKj3KSUgqJDMf22aS0YjZQbD2Sjeppxg8n50kquxJAn2WbkMc0CtSzf8PG8kV
 pZHYvRQwqHSUHVuUPZp6yeneNjg7bMYxBmfwNhqZEUeiBQvExX70VhMsfHnFeLgMjwLz
 XhRANURsp5rvZiB88aTAWL12X44+RLmB0AXlPI6Xd0IlzQ71SLPB85Jas5N/Szpi/G7g
 oKcSYWoy6NRxVKkZzxuypcj7Fme/deFaaYxyrC05pWk4+fuP4glSDYN/0ONji2iCkfZj gQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3cp9gku3t3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Dec 2021 20:44:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B2KeYlT048465;
	Thu, 2 Dec 2021 20:44:43 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
	by userp3020.oracle.com with ESMTP id 3cke4uwyhe-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Dec 2021 20:44:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zh26CR2iXBVeKuqSnZvgAkmm2ZQ6/mc9MBDVDkyN+cqJm7Jj63eUdvnlWL1XDtGVe0JVLFrRFChKbXecRKW4HCrI6QbLN3N7bXndbvs+VLzmt9zomk497O7ikigrTmdBiVwD98HuFU43rNnzQ12F8z0mFY+v9jHhKlLxoqnJ4Y+YetzgrBNDB0unZKvwYbWXtpzV4wvhRjktOIle4/EPmYa25X27mRfroZz4hnsma8XhDAwIW6z3uLOxq56dNvlB6TjgtXaOF4ugpuKJQ0qtP2z9aRSG3mcUeMPNmouWtilQcuUfDpNeaqf2dPYs+gVW3ADdyyoKN93yCk35nKgq7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UeGLfalTKgxkuv18hYImqm/31GTOoGT1zdUZRd5Kn4Y=;
 b=D5rv8KaFrjNp0cNfI5V0WpP3t6q5pRCu7NAm01p8K3d8qBmTC83rfI0GolBx+cStsdtgmWj7brH9L2WHhI8fHX6x5fyTv7j+c1FFzFLTgvQbfifa4X9oialqxZ3yoGzCAJ/NGdLJV1e0QPoF5hlnICFfHBONltI+4ggeUph/72gVhTJzM/HTsZclrclwxKzAfUfBe6NXASXGspkK0iw1A1fsO0RyTT+CEK8IbldH/lAPM66n7yYfkzLreXFmmhunnl4BSElQMG3MMW8QfX03GbmiQEySSZxMiChYbbSATE0h0DlHRAJ//y0cZxy9iiB5WY4FYx0p1zVBWRCxzbKguQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UeGLfalTKgxkuv18hYImqm/31GTOoGT1zdUZRd5Kn4Y=;
 b=Ow1CVyHYu1uY0tkR7y2qwwSEO3H/dzSDN1OmBizu3Go8Aoa4iMqbBW2rZPYrJg6+ahXEj5JMywMo7th2j6lLmtOe4DoIYgmP/hiSdPMDStp9EMM5PRbf8USMrpXxOeEhiDchvAXceIgsDD0CAk4fuHrH8bofyFaGWjna4OwuLTM=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4303.namprd10.prod.outlook.com (2603:10b6:208:1d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.28; Thu, 2 Dec
 2021 20:44:42 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09%5]) with mapi id 15.20.4755.016; Thu, 2 Dec 2021
 20:44:42 +0000
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
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev, linux-doc@vger.kernel.org,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v7 01/11] memory-failure: fetch compound_head after pgmap_pfn_valid()
Date: Thu,  2 Dec 2021 20:44:12 +0000
Message-Id: <20211202204422.26777-2-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20211202204422.26777-1-joao.m.martins@oracle.com>
References: <20211202204422.26777-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0049.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::29) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from paddy.uk.oracle.com (138.3.204.24) by AM0PR10CA0049.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4755.16 via Frontend Transport; Thu, 2 Dec 2021 20:44:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cc5aacf-c416-4efe-83ed-08d9b5d490d3
X-MS-TrafficTypeDiagnostic: MN2PR10MB4303:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB43038B4D1BB5B45AD1ED9E88BB699@MN2PR10MB4303.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	0zGn3li5vlAuxz7+zI6XP3X6YKNofjousxUaRFaQFUsnR6kQfqir9N3PPPzwMhR8HQPAOAhqP6vMl5ZCYKOcTH4FW5T1fjeexA64rQbMvrd2TisxEGgrdX4YkaddoFB7hrnWBrhcvcRyDby0yfO1ezFbEMwt2G8pJWvzwEr6IwpTYEU3wpjyRnuoGb7ZyPr/ifnKraItodHPqKuErscKDtJshI4sjJ5GpW+OtljaXx8qBR5qCsVLknIsckL8NkFekt2esW/jzCzWSWLgmS2bUZWifWzavLlS6yaxdX8de3M02YS5qJFYFPWiFMfXFqFzzBHOM+5uOJfmP7jQHg++StjhvsQvzFaMGvQmKsoJORRPXRxb9A3tRiJFDr2UBVAJyARjGhjA51lhpi4MCoLYpgLL7H6lWhHgFHTFn3lWZAyimHusu4JKPA4rViMVqNG/A3SVYSlU4qcxickSnmr1tSJRmEjky0VmhVdKM3GXgo5CMfDqF0DA7ujcCARqBf+JzRp0/5MDOIROijvOfVnLxITX3jtnh6LcAuhtALf67rX0Vs7ZdjloKAKmZhLPOO274y/1bfIC9GqsP14cErWCCm/cS3fGO5h1eshj7Z4hxyG2ubQfW1hSUJAGrU31see9KS1Vbwgl/7f9FYQ1Yed6+eWEErNnKr1O/jmH4yNZGdNUx7pgtNj3pN63mcBGmEIUZfpJObh8ZWP74Bx6hoTG7A==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(6666004)(316002)(1076003)(8676002)(103116003)(66946007)(66476007)(83380400001)(66556008)(26005)(8936002)(54906003)(956004)(4326008)(186003)(107886003)(2616005)(508600001)(7696005)(5660300002)(52116002)(6486002)(86362001)(38350700002)(38100700002)(36756003)(7416002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?XJcv1ctdvS7Lzz1ttl/mlrSKACiL7BhmztPq5oPBqxTC40DN7w92wgTS91+N?=
 =?us-ascii?Q?fotdtualNo6aaj/iaPq4CD2POscuim+qOHo6hkHTnEUuUowqnaAuBFW+YLpM?=
 =?us-ascii?Q?Zym6CAaLcp4GD0wReBvz4yH0yE7P+xAVT/PoKwrv6WzKHCCdQfN4T+hEcrAa?=
 =?us-ascii?Q?yMdEZoo3dLxuIA5MUKp0usdRZWLQrfCvURMnnR0F9tXbG1Q45r6Rbv5g/tuN?=
 =?us-ascii?Q?fRUAE/1EeiWO7/IKkIVcZ6g8neuqty/LPyaSx2rZqu6MSnyPQWJ1U0AT6KGf?=
 =?us-ascii?Q?CC1NWkacyCfpM1Y0b98vE/uiHmpqJ3JjM2UwabC6aoQpciqn4EYxJyt1UY8Y?=
 =?us-ascii?Q?FVldRcQ7rwSu3F9pCbXjRVb7xPRKNO5i0e+inWWKvmVw43c67rk7d/Wkqq1t?=
 =?us-ascii?Q?FP/VVnJZssObfiT5cx3jyOMakkMlebYW2NdwcoqME7nji5C28Ql6mlC70skD?=
 =?us-ascii?Q?mzAAp8PaAgIXoz2sZz/MyFT2CEhVVpQfZd83MChBeR+NBA3hz3n7SdYb9w9x?=
 =?us-ascii?Q?1dTq/DLQ+HLaPUMP3kFN7i6/RNqA3gOvr+cKzFVO/mDVMwVakqTEYFhPagCm?=
 =?us-ascii?Q?210cWH/Xegokx/AXZJDNGkOinJwjoifaPXsx9QtiUP4OTlByrCyuZMIqGcc8?=
 =?us-ascii?Q?qedo3jsK0Gr+ushj+O+djCCDyWc3/e4ynYVSvu0yiuyhL3iQQwMtruAvJjWc?=
 =?us-ascii?Q?8xXEBarsL7WmEu1JwebvHxvZr9Lzdb58Xl4noZ0lpodsKxWwsBvwL0x64hbY?=
 =?us-ascii?Q?K4R3sbCOIANC4gwkjVWJdgZb+M1NCJSzwJ/z22+cJqDFHf4vNeqPeKiSx2a0?=
 =?us-ascii?Q?MInd4S6bjnPIr1n3dbsT19abFcyl5HvRtgCYDY0cWSMJ6Ix5Z4HST0Ub0Q1A?=
 =?us-ascii?Q?KWuQ+dKisRAX+WZiFbN5idHSDokGv3vwSJYWDYcOnglgtWoJhzx6XXJBm6IM?=
 =?us-ascii?Q?hqV90ozygle6TwVnj2K3MjSkszz+Pq4Nn8V+d7uVYn8FYfC4fFl/uRz1oUsV?=
 =?us-ascii?Q?/Yx9ZIUod7L9YWF7nEJtL0MxTFhrU8MqlwDhUWuXbbcyXPxgmkKn6g4faDsY?=
 =?us-ascii?Q?0NPFZoy1bsJlN9wu48C8VrfmMkqp4tcivH5m7I9vUt058IoFzwMJi5LsZPMr?=
 =?us-ascii?Q?uz+9UPsavOrsmbW1EIdaPvQ1TD/jX5WT/uVPPijTQDHiwK5BKJPUuDtMStCT?=
 =?us-ascii?Q?mYL+GT+t6Nd3WJ/KvG6+UYut70m6UY1UcPpT2/JmlPeUdlZO1Bxowkbzde+K?=
 =?us-ascii?Q?7SbinICiyikO2eERDSnqWlirF8emmr27qbPouNgNrq4s+up+Q9Un0TgFhh1F?=
 =?us-ascii?Q?uk10fMF+fm6TPCXHcNVg6ZAoj6XDEn5lYwT00crLQxthNxwYPpG5MFMif10e?=
 =?us-ascii?Q?lIy2zrqJb/19drtsKqBzULaYnuOYSRKEcHsoodpIXXRCeSIxOYLpCz8dKKoH?=
 =?us-ascii?Q?66LJIVWVtC96pAFLGU/OCndwd1rhgqb+ssfYwsoPOnfUv9xWdE0TJwFm3O73?=
 =?us-ascii?Q?UPyJ8eKXXS8wI9mIEAJx3LbxYYiQDDJdGNR8PG347NfLF83UndQuUG+vA93R?=
 =?us-ascii?Q?O32M8MrhQvdQkDjUHlU0UZMY2n30+0DtjcyqtF/blz2gcYpCV1b8HaFiQh0Y?=
 =?us-ascii?Q?m/o9UEX640lm0X4ZDFX9ACgXOwXnM23g/PzBVfW+WCYYyNGmBZWRCs3osCXC?=
 =?us-ascii?Q?33dEYg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cc5aacf-c416-4efe-83ed-08d9b5d490d3
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 20:44:42.0247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yYTV0yE3te3K2iIXL6D+4H6IusAutnYxM187SNSTbw7AQc54s6z2agr9EUA+Ll5GZu32cVwBIeItmiCp1nGSxAZKtn3DvXzqmHNzCkXI58o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4303
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10186 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112020131
X-Proofpoint-ORIG-GUID: Z-cZMtebPIrjf9clKduK0Tco1julji1l
X-Proofpoint-GUID: Z-cZMtebPIrjf9clKduK0Tco1julji1l

memory_failure_dev_pagemap() at the moment assumes base pages (e.g.
dax_lock_page()).  For devmap with compound pages fetch the
compound_head in case a tail page memory failure is being handled.

Currently this is a nop, but in the advent of compound pages in
dev_pagemap it allows memory_failure_dev_pagemap() to keep working.

Reported-by: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/memory-failure.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 8f0ee5b08696..f5749db8fad3 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1600,6 +1600,12 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
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
2.17.2

