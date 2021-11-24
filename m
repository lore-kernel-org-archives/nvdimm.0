Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3595868
	for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 19:10:45 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AOIFNRj000722;
	Wed, 24 Nov 2021 19:10:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=UeGLfalTKgxkuv18hYImqm/31GTOoGT1zdUZRd5Kn4Y=;
 b=lLfdfUMGy7JPCWBWyzq84YMBELDNhW67rHNb0qdqc6b0BHzBoiDR0sL8oYKltC2pKUkG
 jFvkq1kU6iI8DheGnDGf2z4JK8nfBeUyzvfCd+RftztIDsg2wcGkfr27BOvh4lVu6vlg
 N7BDGIULgHJfILpQaRimiev6d8ko3sVa5bTnLi9JxzNTWmAaMxKVca+Rqjalris66ekE
 +UvKATa8so6h9ACBdN9qGSw2Ic+y1mC/KD49GKGXsrJoXl2sRHtMOuvP4rwrOxBQASYd
 kqEvm6xRgmikmRlAegofOWb5d9Rxdfbnyw87uM3z14zW2rg8Ge5ZT4CyPL+sEahM8VuE YA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3chkfkb0bm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Nov 2021 19:10:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AOJ14fq037308;
	Wed, 24 Nov 2021 19:10:26 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
	by aserp3030.oracle.com with ESMTP id 3ceq2ghycf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Nov 2021 19:10:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BhFYVb80K3HwOyHvNe7EOdTb4C9FC6MciuoFmkkVsoLf9XmMX2aLMEPeZ47LMaPpnNRLXDvAXK/mfhwiYyv2kaWyfrmgQ7153YiiOjEizvCkqOMOB+O4dIiOFpbTR6zdflvVVukx3YjVQYTPI+Y+3ANTd9db7UYHVHNE+vVk+p3rSkF11FwuLB1lwbCDFppBPQQri2m/I6+LCbxcam1kxMXdP8B2OHj13Us+U9XIoCgjeb1pW28FaP9H/3OyGD2ZNe1i+XZg+E2PdquGKxq23MhQiyxxYfVvLAi+zbClqkeLL+739m1msPBtht9lH887umbC03oFQVelZZxv0U6AIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UeGLfalTKgxkuv18hYImqm/31GTOoGT1zdUZRd5Kn4Y=;
 b=JaxwNfpP4AfGxphouLfANIfLvFVrTaew+ZoaNF8YsMr/4lIJFxNXZmagv231u9tm0YjKYNuNrHspKH1eIlUplb4O1lmP/8G36QCLyN+MBtHzbF8fPmWQin6PvIuVXNLpVtnTVCnliYAeDucCPCrcBFcyafYroxoUHro5bY/6E3l2slS16NAlatV57PMfGXwO/g8+dvPlJ7hR45JPheWVA3e2tO1V5ZxoMM+rJ/o6KDFofWHiUVx37Ms8P3p2nJBpjadUVYP3PwCPzJmdaTQzDoJLA+yvcAggEJjg9Zxx/APhtVcjKldums1uKj4qNZ2UbO/kbD+vD+E8YMnRsQXV+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UeGLfalTKgxkuv18hYImqm/31GTOoGT1zdUZRd5Kn4Y=;
 b=EXDDk8vFhUckQFpEPS47Bpj1lWq+HQcSf7c4IdV7FXqbMowhbTFyyIUb5AB1UQciLTu1k4sOoQyJFnJzXPtf6yOHxTTz+PLjVVW5QgAQZDqscgacgYmO/1gvlUlyeW0FF+T7KKKFsnoYCnla3qkOL+lTPmrl9wXpfNCCeoarWTk=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5234.namprd10.prod.outlook.com (2603:10b6:208:30c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Wed, 24 Nov
 2021 19:10:24 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%7]) with mapi id 15.20.4734.021; Wed, 24 Nov 2021
 19:10:24 +0000
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
Subject: [PATCH v6 01/10] memory-failure: fetch compound_head after pgmap_pfn_valid()
Date: Wed, 24 Nov 2021 19:09:56 +0000
Message-Id: <20211124191005.20783-2-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20211124191005.20783-1-joao.m.martins@oracle.com>
References: <20211124191005.20783-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0093.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::34) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from paddy.uk.oracle.com (138.3.204.47) by AM0PR06CA0093.eurprd06.prod.outlook.com (2603:10a6:208:fa::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4713.20 via Frontend Transport; Wed, 24 Nov 2021 19:10:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4127b418-f5d6-4a70-2420-08d9af7e112f
X-MS-TrafficTypeDiagnostic: BLAPR10MB5234:
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB5234A95E54AA98A1A4550096BB619@BLAPR10MB5234.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Dqg1VCiTzMRqULX0z9IOaHasJKKoNYqxI7/sQN6GvOr3n2qahvvREziuKsOYC0zlO8YQ9V/rhueckuQ0oBVG43ehohaRxSszmROxTb5pho6/8a2NBL3ItJjd5AnPuEcS+1ttFRG3BHv6ieIFKv9v5iDuPYz83VKqwW4bD00hSCLfH22w4d6fPvWoOgrCK0cL3FHB84Dw++EL5ZWnyefaTTguKfAARRXrjjRDmB+KUWHEkIfsB/Vr8Z6lM+5z3oKzgwU5O/nSqoMUjcJ40NZlc/pudFfWNK96s2WQ1KZtEPEDlViU7KqOO0M4p0hZ8YOjq1X8a5yYsT4TsYyGZxSN4yDekPDPqE9jyBU0ex1Vyqzk7R6VeLgQzGHAM+gx/EgnhNlyf3gG5ZGjAIsuVOB01yG/Q5cSBcHds/eDoliEvzOvML7WTvaukCDCAxHarUbvf/L9etnzdXheueDStLy/+BTm1RLswmEmufkpK3Hgjbra4RjcbpBzRhhI+4SblwTMsCnqkzpJKyiV9rZvnktljTDbrmxQGPnvMszj9SOl4hfp2WxaGDf/gmx4JgWMYC6xjdf7h7YN6KgwYm+LvC7YlXQ6UdMBLfyr5+cyDTYn9k870Uuc3K9nGtkO/IEgmN+oeXgHSWFhPX1d8bMHm7274Gd2Tmc+QcCr0iYWNm09cHTyvGaFWeoK1uJNYngXXyednrshqNepwgJSilrmf+CHtg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(1076003)(26005)(7696005)(83380400001)(186003)(6916009)(103116003)(316002)(52116002)(508600001)(5660300002)(38350700002)(38100700002)(107886003)(7416002)(54906003)(4326008)(86362001)(2906002)(6486002)(66476007)(8936002)(8676002)(66946007)(2616005)(66556008)(956004)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?GnquEfHOeqb9LDA4MGa8O9RRQTxzUQaFgjpqWyvOuLTJvgp28ZiOq8L+XBND?=
 =?us-ascii?Q?6A+/2wAOUBkTPCgx8QPZTQGIQgAJjg3A/BHG4VqWqdWn9cbpO0F4HzpAzJpr?=
 =?us-ascii?Q?tdNlpxpC+iKSUEwRwplG6NG5lx+tXzuxrLedMedSvjed/ZZfkxFnZl8H7uBX?=
 =?us-ascii?Q?NuefbWfRU0R40Z+9pamZaeUDIj39szT+Hd4UPy82+4gId8nP0iND9f793Qw1?=
 =?us-ascii?Q?CGQMncJuUO4T0JW6NaxKLd7o7GfMlbPVm+Z9D9eUB9beWaK3kF+Cr6qfaE9r?=
 =?us-ascii?Q?zcVIj7iU9SiI5eqXU+MDsxhqDrlAJyJgk2LKrgJXiGFTpfa+yUJ5s8pOHOKV?=
 =?us-ascii?Q?6A+mXHzLiHiwIpJ5iibnDV6q5LAI3+KITAQlMHBeiWYoE+QFFdF01PPfLvaE?=
 =?us-ascii?Q?RDDUtHexAKAu9FsEAOhTnK033mXiBg0He+MDWfz/tz/VNqN//SLYSzP2CWNn?=
 =?us-ascii?Q?O2B0LACqaC/DEd/6ApjHVD8lH1uJXuj2tUreS9FtiFkaGX8F4oMn3MC+cZ75?=
 =?us-ascii?Q?JmzrOfbGUNU5ZKgoVV+dXQ1qnj8MuPtOy8OYQEQiBmoRrsRnIiEzQC5gpDYm?=
 =?us-ascii?Q?UBPrGAmVKo5uQs0/kCbEq1b3s7llWGF55l3L1ioJN2enklloGZpd0XBbGD2o?=
 =?us-ascii?Q?m6a0ZTEaUfrGVaPO0FMgTJvIrw2ypLHLO/DNb2XooFO1dy/JSLSTnuDdtuYx?=
 =?us-ascii?Q?VzUww9luNQBzbL0u4+taYc+yAQzN9eNeGa2Ud/bc/4Ci8Oy2QdHXwqIjEyxQ?=
 =?us-ascii?Q?4acKN+RA+rt6j6N/nD9VOQ/eyqqHajXk8qxVGT5NQfYZ0z5Nmae8IcBCQqks?=
 =?us-ascii?Q?Tvh1ovdpY2x7ujbmNmjL/uHTJNuty21durupdTz1cp7377nCldn5pVi2IR7N?=
 =?us-ascii?Q?wN1o7QIv+mWN+NJqpim897AeRSHIgxEGKA2y6EP+FTFg4ak829u64qB2KYFH?=
 =?us-ascii?Q?r3jqu94cDYklZpMKy3+qdIhrkE80oXqB2f0Hg6jGSH5Rjsrq3vxgg+VMjJ+U?=
 =?us-ascii?Q?T4BpezPhegC+UQsQJgM5O7b0dTpudpy+QWBnGIJmejl7XH0MIFhtq6OwY+Fx?=
 =?us-ascii?Q?ZRUocGJszYSbBmHTgAE0pZzDZAuvcj2hZg70CZQOGdEGoxX2fOJl/kOyQ19Q?=
 =?us-ascii?Q?9+5pZF+t4Ky/+a3nOVgVAAGybC57S6VWjFfWJBg0pvN+POX8oVnB0A5XKHJA?=
 =?us-ascii?Q?4AK3C8I/+Gnig1EJV1tpy4sGxTr/AboPyifVjPz42+fFjo1CfrmIxi4l16aO?=
 =?us-ascii?Q?90V07N4BbEpIKUqhM0nIbN3HViBVKCRagBT78kNQb5Pt39vKyzk+HKthCcaz?=
 =?us-ascii?Q?pHnriRjXqe/RAvC69Ps6eEwkH+JGOCQtFox5qlHAqk9A/Q21noWmJJswqm5P?=
 =?us-ascii?Q?3Ig8VZEtaMCNlIY+vNGefxcCQkNVeN2dltXVGLow4l9MZCnFisRDrd//Qptc?=
 =?us-ascii?Q?a6zeqMj/yrILuDI1z1t1SD4ej+XUsG3oqloE+IKXAZmZsO2iccwrRB3h3KHp?=
 =?us-ascii?Q?+VqJnpUqKIVLHD1wF6GPaaXFsz92q3yJYMXb2g94tnQayhN8W9e+XYk/xoJJ?=
 =?us-ascii?Q?cpnFauRBzQthhAD9XiNY01ZD4AxeIwSSNEbYRztVriTmG2Uborwqbx+nfzGW?=
 =?us-ascii?Q?SvR4HEmlrXCZMWWSR0QaZ+Lpex3j/qGuvXM7fpuOiK4eeGH2FzgGRhtFu2hs?=
 =?us-ascii?Q?wplSfw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4127b418-f5d6-4a70-2420-08d9af7e112f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 19:10:24.2501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TY83AnqGWiT17BN/5PnWy5MpE589B2zOEKxPMFXjNsD0aanBZdVa3L9XzMIWrPDtAGmRUzUKQjNHHJODm7PzpoS9R8fTZ6ssbufIFfKapUg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5234
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10178 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111240099
X-Proofpoint-GUID: klqb-lAVVTgCajdGzt6k8L1KWIdW7gyf
X-Proofpoint-ORIG-GUID: klqb-lAVVTgCajdGzt6k8L1KWIdW7gyf

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

