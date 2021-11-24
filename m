Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AD82C8B
	for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 19:10:58 +0000 (UTC)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AOHa4Ix012792;
	Wed, 24 Nov 2021 19:10:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=MA4VecHh0l8AWrW9XudQugjpfPgplinZmvX3+fimGXA=;
 b=TYzJWhnf3DbneUpp0OLAitnf3LHIekst00HAC//6qbCf3XszCdoqkpm9cuQ5QB0W6ktL
 Z/LabQjh7+bYf0iVZSzAnQfN0mzNdhrvFl/vQnORAajfLqB0d777RRmXErAnHKOMjXif
 o7CL0jvj9h79nRxNvdTj5X7+rAtpJVOe9f96jokReKT5gxacZTQm0guSu+p1r3WohBmq
 PkUJFhr9Q+ZyZrTv6E2e7PYYfrZx8i6uo2z5ueZ4JWzhuDNYTYy8gIP+eSeOtvCJf+LS
 A2fG13/ugleWGWhKkI6D6PtIrlryMIewmrT/H4XPN1MboSs4eTqLiG2UPR1Hyc53gcFc 7A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3chj7g3876-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Nov 2021 19:10:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AOJ1KPs178822;
	Wed, 24 Nov 2021 19:10:43 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
	by aserp3020.oracle.com with ESMTP id 3ceru7j9n7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Nov 2021 19:10:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jq0pDOhiMfwofd5leeiwZjjewgkLokMigacz+gGTqSaqcC0eAS38Uf8+SFxbgFmix3/6qRZoV46Zpm2X98sA2X06eaWW7WQqid073aGZ2jSs3RT4G/tyxJ7XsN5Si18jX/QBoCJkdZJWu4oOerMZVHELxROm29Xbo7+dio1nGmtCRMF0fcx4Xm/x06oVYJ1X5Ku2et5oT0mHloir39o+wUzEhxfjj78N+KD2Kj+hgyLhmo8tcYAErEqB7kqQ4tf7RDETGdpPbG3OboFDSFj/xxGkG7QVHGCk6MVLm3ogUf2SymZeeyLHJWbYNuIvSAlz8jEil1Ofiyiq5g2svcFqmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MA4VecHh0l8AWrW9XudQugjpfPgplinZmvX3+fimGXA=;
 b=bnQ0Gq9EhWfggilQCEie0di5i/6TA9F4RR1B2k6GeAVUSZniquoSyLW52IbwNnPUwKnr73keH/qrN7H6+FgLMKGZsHQJIgGBynNCUlHtgyG9x2QJPM9jRYLRNz1clmGSajGxYkPIQv5ljsoVX016++bFdeZh5a/Avjw/k0lOZAH8Ep9lqlBOTBFvBNsuh2ISgscEEZ//Glwtxujf+al0b7vFDvQ25eAnqubMNij2mXxT63IfBmufij/GBnDL51SccgbqQk3n2wji7IqkoueTGpWTDVJHTDrdKkjYqvpYIjx80NG7/2mA7CzdMBkH8hXmt7FNmJSk25BkPbBOYU0pWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MA4VecHh0l8AWrW9XudQugjpfPgplinZmvX3+fimGXA=;
 b=oQkTg8fb1IkuPkb3pCctfVf4hA4C1s1RNlUNKKujDVc6L3njYAAUomMjjlce0jlYu2M0FZgf641YK5gM3/XX8hhzsv5qn62fWnt5YvX3uUR6fHeVSpyoNP/H1CMDZHxTENz+wn4IYSXA+N+0t6aE6oMXZPLHaooM3Q9rsE19JDg=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL0PR10MB2916.namprd10.prod.outlook.com (2603:10b6:208:77::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Wed, 24 Nov
 2021 19:10:41 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%7]) with mapi id 15.20.4734.021; Wed, 24 Nov 2021
 19:10:41 +0000
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
Subject: [PATCH v6 06/10] device-dax: use struct_size()
Date: Wed, 24 Nov 2021 19:10:01 +0000
Message-Id: <20211124191005.20783-7-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.47) by AM0PR06CA0093.eurprd06.prod.outlook.com (2603:10a6:208:fa::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4713.20 via Frontend Transport; Wed, 24 Nov 2021 19:10:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8deb342a-9ce9-479d-83cc-08d9af7e1b37
X-MS-TrafficTypeDiagnostic: BL0PR10MB2916:
X-Microsoft-Antispam-PRVS: 
	<BL0PR10MB2916D6A9EE8D4A45681E31CCBB619@BL0PR10MB2916.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	2N2p1Kxb9Jhtk+wrsu/HiLFB+jJIDWjEgzsJmwb5X6gyc9zrsamMN89AotUKLyM7KpdonM2qX/2xcKX3unEWymUWTM4q4S/tU0MgtR/wQKw00rhN3ZmETrb3J60dvPrH3QNM6BZWho+gTPXEfRWQMJLZIPXPATzhX5tdryMbB17Zn8eE0KPKsFASQ1rfDhf6gRl6shMSG7Z9s6nGIe1oZCUT3zXfEYVeoFQbR9QYkIyf9JtdH9RQ6m96QWvooYVLhC3iz/ShA9vL1KTOKWCZLtqRln5IESSZksqeTTUP73iCqaUyPPdctmgFQPE5SizsCUQlObXc2QevzTVoBqEbj7TFeL4ZXJ/PQ5UkyzwgtSHuOptRh//6dBztBhk728pCAFXiZp1Q58hsYmprbeVqwklOz9E2UNtWkQgrFHuHvz+glTRutJ8VrMoC9e758hZxUQONLKrP4FCeV933lzFxzsb8tJAYbWkUnC/R3qRZEqiXBITQOaickruAp9NJEyI7gx3cKzb88P6IogZ2q8imtpuTr9AB6vXl/Z1+P41Hn3vjQbR08e5XN55hfooAauPAaJWqY2Iog6ewHsvvrUzJkJHoZI+4XJ5L+JnBmx3LAjVmZ7xu9ESUZfbZ8fEz7CD8ypnCqlzuCAcob7j7grdAaMHX4ES+yeLqL1LJIGfH21ZbcL6c8yfvXfF5UXHJfiZz6F9O8ZGhzszS5yX97OmIv1mbPQMJOz8mefoyXmHZvx2oo8bRdy7r8aQpfebodj4d
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(5660300002)(103116003)(1076003)(4744005)(36756003)(107886003)(6666004)(956004)(54906003)(7416002)(38100700002)(6486002)(2616005)(86362001)(8936002)(38350700002)(7696005)(52116002)(6916009)(508600001)(26005)(8676002)(66476007)(66556008)(186003)(2906002)(66946007)(83380400001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?wMpH7R2+UN9aNtnelr5zRqezgzS7XyUkbtnX9eGCGKfU118zy/fYlua7uXAi?=
 =?us-ascii?Q?YfVNNHhgguGmzoaCyb6GSvZhY/SVhCOe0rkoNVNnMwklsL1uFRHjUfFTnMuT?=
 =?us-ascii?Q?mGQ8NTKyOuZeDtz32cNGFHZEU/rFYpKXEvH04BVl2IUKhAgf0MlEtgxynQzg?=
 =?us-ascii?Q?aX5ShIeWPyUNNecsAVyZ+u6Z8idoOhaArbywq2LhhEp8mE1463ZjoeXJfs3l?=
 =?us-ascii?Q?P38c4s5xbSa5GhllLcssz07b1Ut/0xyTsvYn9pCSfiyO3oL91U2qRjy/53O4?=
 =?us-ascii?Q?fFgvxdVqCbDgwkgoi+oVtAGggNKbSnJ20dmLyCGFvdJk412Zdm5OhKqL+0+G?=
 =?us-ascii?Q?3URm5ymBhI9kNeExxYpv7bXC+yQ+VSEGWeQJE7ziVOw53cW5ADxdjOyb/k/4?=
 =?us-ascii?Q?pre/YYjG0mrxbtiFLQOPA90Ci18b0w7Eo1gh4pTfvZdRZmxXH+UXbzZLF/HM?=
 =?us-ascii?Q?jYrhV/h2oKk+XDzRq/7RLVumJwYvlSSf7NOnd1MV5pK702XdIzRolGq1YS7l?=
 =?us-ascii?Q?LxbpcmeDJyv0TGqDIx4pHYIB41+Hu6Xo9zZFnkWs+KZ8cu3NLprG7GnZ7P7e?=
 =?us-ascii?Q?69uvFpK4x5hB7cm6YrUks8gFwVNXOqg/wII3I04c8MirqhU5pBqp/aEGU/Mw?=
 =?us-ascii?Q?+KL7yV8xHeqBncy1XM2vKQIEZHNF5UViLRIxeLnVCqDfMhDBKaliJzkPftlT?=
 =?us-ascii?Q?PnxsvYRJ0LsuzdrMBNQ7hc0hSerfEyNDYdTpgPRuxZCvhIg4cEskmRiquqnc?=
 =?us-ascii?Q?ZUygUClVcE4I1a2Hnk/VBcFIRgHi70ne8dW7ByMo4zMBunU5smQSf50C1onT?=
 =?us-ascii?Q?QHNTvYM7jvlmPMmC2BvKrZALV0z9TFjZpqFvKjhRUFjfsJQnUFaoIZNIdfj3?=
 =?us-ascii?Q?/SzoAj3IRpJvY8K/nTXYNAik3DR8dJfWHQuHbbeDahg/HT6sOlD0XBQnOrN+?=
 =?us-ascii?Q?/sdyNd8E+nroIikYWiikImLz3uVNNr7hc3IbD8aK6YuQkf2vCo9p5UvxhAUl?=
 =?us-ascii?Q?kbMbUHGGWtb3BBw2RSWpLen5UX4MM0zV9P7EInc1ZOJEpuIqnhF98o+4qM3A?=
 =?us-ascii?Q?E1fgqtAhABlIsAh9bJ3NHILII+Vv0VPzKOxxOZQHVFba6nnjDvwF7zluUATE?=
 =?us-ascii?Q?BzUHwHGe/5vmYWDME9PwSv6uTVvkprKPdQ9fHPOJbbDG7WzTzfMP+qLX0xnM?=
 =?us-ascii?Q?uwb7hSWmKM4sDJW4n+3COP02stDBoxDHCaK0nS5bEYXMRwXvudCZjaJCNRYE?=
 =?us-ascii?Q?rjHqkSHpL9f3LZYy2VEaZcXVVHwph+9BrGujK3v+Iot4KrzIoa6yriKvJ6nu?=
 =?us-ascii?Q?qEGGo5AMj/KluICJ2oPC2MudHfUYSdhQvQzjKBksnOqGMTD49tLGtULE1kA5?=
 =?us-ascii?Q?xXAnuwsnay1GSg1VaLcTCN1aXDVLW2ajQris4ilM722HX9cOclWuUguciXsh?=
 =?us-ascii?Q?+n6c1MR8Utx1EZNVQ5A75Ypds5ZBGmp5cWNOmN+QDQIZm0MxSoUfbezHOD81?=
 =?us-ascii?Q?ECKkIWhZ+G/RU9VQStSi7HO9qJutmVlPH+FW2l/1yiocmcU7GvAgGxIWiryK?=
 =?us-ascii?Q?m5QtPCpYXCtj2GX90qdDKYmGZ+SHzHDAg58f+4Kej/pZirDdr1ekL5ZN7J4s?=
 =?us-ascii?Q?NpFvYRexwfyY+rifncRNl35JEH7LYkJ/F2QAG96zyxa6RjYZJbbgSF6bYlHB?=
 =?us-ascii?Q?B/6i8A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8deb342a-9ce9-479d-83cc-08d9af7e1b37
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 19:10:40.9697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JPQj0sOng2tql2Ec0EMU4Ez+5UiHFXg7LfTbItG5BLRoWGgONNADyI/56rVOoeteDGtv5AZIHsJCDjRC85HYBsnuhMxk9go1IZTWajDR8P0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2916
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10178 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111240099
X-Proofpoint-ORIG-GUID: r4BG77tGTnqyxh9GcLR3gm_T3Nn8YkK3
X-Proofpoint-GUID: r4BG77tGTnqyxh9GcLR3gm_T3Nn8YkK3

Use the struct_size() helper for the size of a struct with variable array
member at the end, rather than manually calculating it.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/dax/device.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 0b82159b3564..038816b91af6 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -404,8 +404,9 @@ int dev_dax_probe(struct dev_dax *dev_dax)
 		return -EINVAL;
 
 	if (!pgmap) {
-		pgmap = devm_kzalloc(dev, sizeof(*pgmap) + sizeof(struct range)
-				* (dev_dax->nr_range - 1), GFP_KERNEL);
+		pgmap = devm_kzalloc(dev,
+                       struct_size(pgmap, ranges, dev_dax->nr_range - 1),
+                       GFP_KERNEL);
 		if (!pgmap)
 			return -ENOMEM;
 		pgmap->nr_range = dev_dax->nr_range;
-- 
2.17.2

