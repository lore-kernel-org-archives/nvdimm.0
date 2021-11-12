Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149802C80
	for <nvdimm@lists.linux.dev>; Fri, 12 Nov 2021 15:09:27 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ACEQENk008613;
	Fri, 12 Nov 2021 15:09:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=blBh2EDfpufy4WWuhG5UL/QpYFWDSu5K0S3/ZSg8MR4=;
 b=SsEdWSdcmqD0wMH4GyoyB1+uRnR7ELyuqirQZlY2q++ICfRWFNJyh1qFc/MCTl5bnhBx
 31FYaXgmeYM0ABovHwcoysuFg6VbJmg5I8Zh0yHa4btPSBbWa+IWSexLTz+eIdJDLHcI
 07SeCLSBxbYiptGV4ByEGLF2EON0APoBlnumDryjMFP6aE8J6ctK1keW/JtJ3vjNwMhN
 0LEfVWQ2AX4HHvZ/P51NolV+YgQ5HKoIn8dBgIMJqc82w5daX768tXbNEzc8tW7aKDY2
 siG380DHRtMA/EQwQUPfCqm7+6gGOLLD5wSm99BGRi7z/9xr81Cb0/Z8lqbXPSqTSm01 kQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c9kn51ya6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 15:09:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ACF5w0B196349;
	Fri, 12 Nov 2021 15:09:03 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2046.outbound.protection.outlook.com [104.47.57.46])
	by userp3030.oracle.com with ESMTP id 3c842f8x77-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 15:09:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZYyLEf7Nmj2IEK62lY3uSCY3IM5eDZBq9QUblxKH+ltIrqGfUi6TaKZ0QX6vTnuK4wIYX43kTa4OQbWtfT0Xs1rLdq7vyiFBt8nP0+ccw+0qGNIFEmb4zeOp2EOHks1V6ra+UPEhW4kaOS0UnbWUDAYL/qIoons7vakAQYDTFBJMZzLd7z4VIpd0LR2Czw1Co2yEbKO2RQHAWe09JJ8NW8CJMQ8hgfSGgT3AUShJrXQAYTvdd/hnu4UQ7SKRZ9cQPjzfIBfrl0diyETC7jOhQK9kmF3innd+4seEMMXfyFNVYZT6YE471qMQGDpEYomSi/ZoFcD7T7QJcLT4b2aeoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=blBh2EDfpufy4WWuhG5UL/QpYFWDSu5K0S3/ZSg8MR4=;
 b=BQeWXtpEBYV73M73+GCodwssjWsQjUDSASc/pLNjmSCoUBwXeJww7wWhd7FXRm0QmiRB4FEuk0JJA1PuLJh3LAmW0NWaHHWWe0OWX+XyjSVkijuIT+RctX2IR7Pj0nHOaA9YSW50OWf2ojyv8SBigixxkzkvI+BVMQsNpwOsvaM+jWkU4WHOgRC2LOgkMJPsGx9oWSmLt+TtWa9wwYwtATdh3hGOnh1LUEoDFX62arV50S+VKRWfpnkGfVtjKHQCTxiA+ScJhsb84fHyIS20kPkUQaq/d4mFXvn/J0ubkf8nWeKqGaB4QcvoaGVoI+D3XGjxbEhVee5oBbR6TZemvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=blBh2EDfpufy4WWuhG5UL/QpYFWDSu5K0S3/ZSg8MR4=;
 b=Ra0EYswM63d+EuiS4i0VXFTn2iTLxnWJA1SNdvhGqIxpKqXd4Ex8f9xU4fUA20uTInhdf9r9a0tOpVcRLX+/c/KNs4dYSzpKCdNnIkJ3BwfMU4EyndFy8JpHwhR2Gp2TSd8LuR2SqWUqLLDCjiVx7m8NiHbYndhgYkNNXbj47vI=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4223.namprd10.prod.outlook.com (2603:10b6:208:1dd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.17; Fri, 12 Nov
 2021 15:09:02 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4669.016; Fri, 12 Nov 2021
 15:09:01 +0000
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
Subject: [PATCH v5 1/8] memory-failure: fetch compound_head after pgmap_pfn_valid()
Date: Fri, 12 Nov 2021 16:08:17 +0100
Message-Id: <20211112150824.11028-2-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20211112150824.11028-1-joao.m.martins@oracle.com>
References: <20211112150824.11028-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0134.eurprd07.prod.outlook.com
 (2603:10a6:207:8::20) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from paddy.uk.oracle.com (138.3.204.9) by AM3PR07CA0134.eurprd07.prod.outlook.com (2603:10a6:207:8::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4690.12 via Frontend Transport; Fri, 12 Nov 2021 15:08:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85a4c399-ebdf-4a2c-7665-08d9a5ee5bf2
X-MS-TrafficTypeDiagnostic: MN2PR10MB4223:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB42234B3B2D325E22B1FD5CA9BB959@MN2PR10MB4223.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	AKDjxXOFdQWpKPnxX7nL0n98chJq9NDCfWOnwqz25a5Ld+v4PJTcmcHLpbKoRT5uXTdcduokI4xBnoxnwvXZYMzwN+BjCCVJoO+pt5EaPNqrsr9qTNxMmRod1kaKpBcMsLBs6+bC3nwNFrFi8NwSL/bvuUpg5hWTbKl0ivaQa9+bZvYvAWQbmqZZtZvnXjcOdDNLwF+bQ8QnjGibeFWVTeDUJbWYY2LWEvokANO2ItjChUOQfh9RbB5UOb3e/cO5eSsL926zA8YORvyVWZFpWzQ3ek4xWPpsZF1SLwAWl3V/2gwqV7/I6kt5VbqDgSBSD9zgTGlD9ojP2tuWya06/nwdSEx3b4AjLHK9Jrmu6EwXWtR84ER3AA/THTRf9wJ3zYiAgKnGHJ0Y4Tm4oWbreGu8IO2rZxMbNOqt4Ju6QyuW6aSuDWp9Y5N8I8ocqJkJ9ju40ZdIn8st7KinDRH5UrwrnPsA5/PdUIvBchzSKDhhspdJeebV7Y97ApyaJd1z9RtPdx+VtYxiZstsN7N3egxtNJ1dk978mPrMncOLjTsLhVRFKq11+o2j/verzQX4NCaSQooZtCqEpSQWuTWgwuZA6oTinp6QL6gZZAJEKK3QRu6b/AVjASmB7Ei5h7P6njuMVV+b/cPSgXU9UPQNAkdfx7CfQfgiLPQGOvuzmy+Is0nrs2QkAJZvgCe/V+cwNGTk/TRWvAU1JwITXNB8Zw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(5660300002)(2616005)(107886003)(2906002)(38350700002)(38100700002)(66946007)(6916009)(6486002)(66476007)(54906003)(1076003)(66556008)(6666004)(52116002)(4326008)(8936002)(86362001)(36756003)(103116003)(186003)(316002)(26005)(956004)(83380400001)(508600001)(8676002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?nAqCBXgUnzBourGkMEcdi7XeGGyf8hp2EbM1MYcFJbDpfas7k0BREXv1MkxZ?=
 =?us-ascii?Q?7K3GqJzQEN10s6ifnWiRLh5e9JuQTltIOM6mEPPyA4p8NgzSVtin1RyfKwiX?=
 =?us-ascii?Q?Q83VnYJxK9Nod1G/tuRe2XGKOPKdF/Lbdhq1UaPTINfGWzuR4kvSKT+0Ctpg?=
 =?us-ascii?Q?fw/casgQWGSpq4kU7eD4urgtgdIATYTQ1siNv9mrIyVyvfOIqPz4lU1q4/RH?=
 =?us-ascii?Q?4z2tPOiXM3yxYDloP+nnIREfH2h99aRetY2t537etPOgw1ryZGOptQmbC+0d?=
 =?us-ascii?Q?1OaZcrZ0yFCNyYYsA+mw1KUbZkRb5/zebNlft/HhPuor04he577gXbpjvHfu?=
 =?us-ascii?Q?bp+8YyTphtNZzuWPOpmXPtauNtikOz3QftZO0CX0HWEHp2xbWZRMIoqWDr5O?=
 =?us-ascii?Q?d4BnN2IGU0KZRNxFoeQFQYb8cYycTE45Q4yrOSeUAsV+e4Zq7rm6qFVKUBy8?=
 =?us-ascii?Q?DMbQrb7CKISnPljPvAzaTKDHxZDaELLN0Ge3IwhPQZsev/e0zf6o2Q7HWwVh?=
 =?us-ascii?Q?EAHuG3kff48kDYcHbN+niy33WvcVZrNc0fvCJpGP+Aq07nMfTRf1T3lvZJoY?=
 =?us-ascii?Q?HukzCVdz95fBBaBp2T5mbKsyCLl17A/MaXur1oXgt8YtoFpazd9z6ISQPju0?=
 =?us-ascii?Q?DjTr0RalQqwKoheY6LaOcFJHONSAaEpsykpDsrWp4NWBSEPIDcKsf0sqlqC7?=
 =?us-ascii?Q?EiKuDHxweiG6DHAFSVgqFWwJomDt9dhy4MMJL7/JSQG3ebqY57n6zXEMp2Eq?=
 =?us-ascii?Q?MUq68gpCZRR3YnZSt8VPMqcrzCxE1vy6uWXdZyiE7uPYWFnnYFRYniI9MN5F?=
 =?us-ascii?Q?3qpD/Bp4jDXk231faqVP3UuGNOjKMHNQNNhSX12A0FiL0VDdjDQlrhkYFug6?=
 =?us-ascii?Q?WTQS7bSpWMvCc3NsPguVP/s7TfmbUicjaEBP+LVFh/2NjhaVAsSzl7/BTkYT?=
 =?us-ascii?Q?KAUVGRwL/GuH51RxT6MMm71ZqcZZTLWrY9UopaJZWu1arv3pDEnV3d4tCxbr?=
 =?us-ascii?Q?zxOFrESTCw/FDhXCTGNKARstExMWDYoR8KGTZww93hrq+immBPGpM/9subbk?=
 =?us-ascii?Q?lxoi7IQr6zRbDagTI8NamdfEcuhvnVjjX8xfDTVD4lkdLKMT6GK/3e7HdDlQ?=
 =?us-ascii?Q?d+pmyRzt+muc6dLBK33fx5uZImnz8fTs5EMhoVZOlf1+MnAiUf72X1xO7gCx?=
 =?us-ascii?Q?9anuAeIwjOxKqQrLBU8PkUToi86Gsf4oP0w7p0GC8GxLPknCUUIq5NpwOI5i?=
 =?us-ascii?Q?Z/L9Os9xf9iY+BwcCLVuA+gXLexU8ZIaUl3Z4eFtjRZWURK7cB+VIIQ58o/r?=
 =?us-ascii?Q?VJyBpk7t/TRVgo/sEdkGW+nTNUlJ8/+i0pHckkow4JLsfn9tcbTdFcJqLQ+W?=
 =?us-ascii?Q?3NJLAev1bN9XbP0p9Vx3rHgUvINt6go4Js5lPMN1SN5p+9D/sz00NURY5fCG?=
 =?us-ascii?Q?BvKDEAoUVgvGnFWRpf6kxWXFwi9QNrk5bM+V/ogQ8FxEGs1kud1paa1Rm1Z2?=
 =?us-ascii?Q?Qj8YahZmFcqYFiBUCew78lMyp3eEokCOaoQUGyRYa/TIBbK3gRRqMfaDiilL?=
 =?us-ascii?Q?KqJF0GcfGsr1ramJ79aHwJ5t5vx1vZ8YT7NnbFDPq7LdfQUVZXYyhV+nox5S?=
 =?us-ascii?Q?jUPNNmUx1xnWhCfRW9w7zvJMyThl8rn/A2/UuLDRG+MknQtj+aUVyX2852n5?=
 =?us-ascii?Q?drONRQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85a4c399-ebdf-4a2c-7665-08d9a5ee5bf2
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 15:09:01.8358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s9fvt1VNJ5i8N/4erZFF0ae2/JyYd0/8e758iD6sn4si9QxOS0hFnfPJdDLwzUV/0NbuLdUFVdGMKBXO1NNCwz2asUwLbIztsrd2FlmU8wM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4223
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10165 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111120087
X-Proofpoint-ORIG-GUID: b53EmZGhpguVN8bzemXtEM5n4C3GIk_i
X-Proofpoint-GUID: b53EmZGhpguVN8bzemXtEM5n4C3GIk_i

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
index f64ebb6226cb..0c4b08da1a02 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1565,6 +1565,12 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
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

