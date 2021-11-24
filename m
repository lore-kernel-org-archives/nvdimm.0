Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD4F2C86
	for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 19:10:54 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AOIx2bZ031509;
	Wed, 24 Nov 2021 19:10:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=6K3dV9kT1TePMQHNEat9vbBQo8pBmM+K6iChvFRe6Gk=;
 b=oMnJISYVluXbXhvBASTdBakeraweglGv3FE4o0lK8AOHho1bpWPKrfAECb+TWEN3dSy7
 q3ImjjIP8nQ6yFb7yFdRdX48mcbr/8P/ggfePjrFRjKbfUDUUQvrukG4ERzRjHB6hUGf
 dvkpiZ5Po+ziXJyAfaPUWG/jCLOIJf9xQ2XTt0xwyG/17OQ/IKFoDaMTwN1/sOgjIBGH
 Gg50hLl37HVbZ5IX12MFyV08UhSZTPGSTcNUFUIvCGNh5JosBuHJf1SVKZ0C02wVKapH
 Pw0zQ7joD+dW+kfUG15qZWogcmV9eWSpsUJ42gQi4PdAYFw1oRdBKaErlZdtN6nt5ggz 0w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3chpeesxm8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Nov 2021 19:10:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AOJ15SZ037553;
	Wed, 24 Nov 2021 19:10:39 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
	by aserp3030.oracle.com with ESMTP id 3ceq2ghyqj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Nov 2021 19:10:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q5mVj8koIOJZKD59sxh38eCNcThIVEkBnRD6SZdSBZ6dzp/Ycrmn/K217yazOSy+t1wWPv8Qvx/Exd3C0bVEeVYejqmXZPUKv++6R3pK6KENIj6K8cJLrWyH2EVHhioc+u3eTmf8kQVRRnOxy+7lILzaM7w5jg8aYOxUY16xwZDQ06WFNIPLliEDihd2d9d/d5kAyvhAIiySVV/ZGieDMLp6MuSyoU0eXdJWBpQ2qNCVD7yuaCgzsI2QsCbX3mOqMurJMBLrfZ5wBCWiEAnI5dacBRMCh/ExAGHuE3gdsZ3zRwK6gWLyc7JaLq4AsVuJQfY6sDAl2F2WDxD+ROWHVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6K3dV9kT1TePMQHNEat9vbBQo8pBmM+K6iChvFRe6Gk=;
 b=SCh6DWtpqICNmywrTzWaGHpf6zFumKWDNhVvC6/YVAzg4fFA+bGobMjKOU5IzPNamOQIBeCyntZUBbhTOef38sUna1bgafVhQa/ZOf+VmBy+T0OoNRjmsAE42MYeRvILiLfXKK+r4k1IEU/vmaZtRRrggDKjg7ZHbjD7QJGMkHbDsZTOFmoy0zQ1uNOvvCp7f3eADgOQzfstpgABTXlALB8l17LvGyBCbUD4ylrMZvgQMzg7DEFFpv9fEo0xVeCjRG1wTClo1E4xQMFeD1Wb+tZuvOKMk441WWuWVVJOXh2AH95l4NvVN9YZv+B+3lwBsWj2y4bwuSgzieqgp8J1dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6K3dV9kT1TePMQHNEat9vbBQo8pBmM+K6iChvFRe6Gk=;
 b=tfQx5X+pOOzP+f7lybo34Uu3g8qUYgyabiGaJcoVhppFqPGeVHcz/7kA39BtjD9gAOgXaw/jOR9weaQDy1oz/KapNTubj0Jp3l6NFyKvHkn0h+WNm4DdQO8u2fEHOXk3V3OQbGx+aWjGbkv3dYaG9Vf9k+iybA0ei/tosq8hPGs=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5234.namprd10.prod.outlook.com (2603:10b6:208:30c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Wed, 24 Nov
 2021 19:10:37 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%7]) with mapi id 15.20.4734.021; Wed, 24 Nov 2021
 19:10:37 +0000
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
Subject: [PATCH v6 05/10] device-dax: use ALIGN() for determining pgoff
Date: Wed, 24 Nov 2021 19:10:00 +0000
Message-Id: <20211124191005.20783-6-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.47) by AM0PR06CA0093.eurprd06.prod.outlook.com (2603:10a6:208:fa::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4713.20 via Frontend Transport; Wed, 24 Nov 2021 19:10:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51b0b42a-01ef-4062-0844-08d9af7e1923
X-MS-TrafficTypeDiagnostic: BLAPR10MB5234:
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB5234FC4A6761CD1BC80D08AABB619@BLAPR10MB5234.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	7Fhq/chqcx9PTYYm1AawQPlzC9UUeipBBP9qYllo5zD8F7mL6BNkhkpzdku/EpSMrHcdnJ4ZutTNcljDwjMpoFqHi42ZNWsJ2u3gUlbhJg+KR4WicgrVIofGPfv+Q3SIFZpk7zVD2pUEWrCIQxI+Xl5R51X++vgqKvJSI7jFwraKr3it8YcHZPx6sYqalDawOUl+7bjGcS4nW08c9gAMeIezsJ6gtvNS0SIwGG0974Prhp4xMYZ0sakiAbAotlkIstToRqkyg8p3ewO41u/R6had0njxChHDE6a38XYiTozFgU8ga/y9olhKXPeDoFs348GhjzSzLsaYFBeGpDqZ3FnMw3vTgTAQDp/zaY31ahwMM8YM0XNcfYv3sefWl1OHSuw8m95jnELrz+sAzkhF3oacgi2Ly1TYGEkA/tZnC81gafYtpMzuhncPFPhpuCjxjbOWT8cPOa0s6gtatJEvtzEJbTidmYdd+UQukp40wE8+i8zaBXM7g1+UO7OLuHIsLXPcC7xFPb3jRyJfE+w5xS4mKoJhT4Qk4r5K1bSsYWtGbHMfOqT3WRcOHn38nU5vzm8ItbY2hheAXcdxL7uIa84T0Q0JkhbozxSRVQ4c1sdKlTJKSsIVmbhPgmHIKfkXkexZGYUPdOtGOGzAacmJcwcJl9lLdcJBNBXEdj/9L8VefDxQPrahzgSLSXaO4hAQvvzti9e3Vl723+7acUrPiw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(1076003)(26005)(7696005)(83380400001)(186003)(6916009)(103116003)(316002)(52116002)(508600001)(5660300002)(38350700002)(38100700002)(107886003)(4744005)(7416002)(54906003)(4326008)(86362001)(2906002)(6486002)(66476007)(8936002)(8676002)(66946007)(2616005)(66556008)(956004)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?06XCv/JxSOjPNxsL1IRhlqjzO28qwZmtYOhhzukxAsZX8QdfSDmW8tfunUBv?=
 =?us-ascii?Q?KyxIOz69a0DCjze4iG6kU1ZxHzOf9khqjFALXOuKXey7UEBvdBv6eS0cjX9g?=
 =?us-ascii?Q?EOglFdq3ALuNR+xZBvR1wtmy/fpNGHP9LVZEn5N54/p141IUZW6hpjl1HlHH?=
 =?us-ascii?Q?p64bgSzht+Nry9xGKoXPCZvutYoQ4qP42kJ8KkieVn/WI12C1/YY7xlnFacH?=
 =?us-ascii?Q?w4DOuMkmXagwOGSWoBm+z8otFrC3vKMEnb6/A75LH3D24Zzq6+4GyluMAJsg?=
 =?us-ascii?Q?RcwyRkHxdMqZ2SFGYRvoDcRlUpSfHahiWKBc/4hdyPaClRUEAUX5RFr9CksB?=
 =?us-ascii?Q?MxmCHCWKk2SDiFQbOi6E6DdaQe7EBNR6Y9HXF39wN+BgIVWLFDi/SZn3TaMN?=
 =?us-ascii?Q?83gzcg/wgcIiJRAdNVsdCV/qDRGKQU0gLR5LmgWnYE7Z4rm+Ecg0/Vy1UFvo?=
 =?us-ascii?Q?vqr+GdZ/F3DH1GpbVuPSQKE8Ty1ZVrqCPrUZNN0xhuS+ObjBHISFc0fUUlpb?=
 =?us-ascii?Q?+YhI+Z5i3CXzKthEMlfwtAG1pKccXuSpUoA+8W04uZcNoWphpX1+rF7Odq2v?=
 =?us-ascii?Q?IjeaqdXUuUV7vxpo5XAKh5X4gFQCgVYHB/UhTecORmuNtENmjeTzHa7nHeGv?=
 =?us-ascii?Q?IGk43RXLiI9kUz7WdkbxBgHFtnS4kcGHGbU/RcPp8cczA9qhemCwJFTlR2QJ?=
 =?us-ascii?Q?IlLLtSPM21jo/KPd4UmKXez/h0X6LdUZ9pqsp9JyGOOoQtCrPtcepuLrMK2v?=
 =?us-ascii?Q?Iljm7Bftr7q1+FheTfMAwdi0Mt6Svi60mbkUPNaP99HB0kfze30aTAcIdB/e?=
 =?us-ascii?Q?Iot0+JLekQNfMc4KoqQzVVu9miaAUWYIhCjBrdNqWLCR2UqtgczcQZLLKo1/?=
 =?us-ascii?Q?ftE2nz1ZNc5WWn5ZIxPznSuUBBTd0LzjJ5ed2Pdh/RSrFFOAAx0m5Qq2s1WO?=
 =?us-ascii?Q?k/DnXCdxU6ECVYgTEvYkRS4N259SYReaw+sorMmjKCgbjsJXROwu2k0TY5Hf?=
 =?us-ascii?Q?xvhzD0LusgUmsSNHaoVFDVxLFkbbsh8JuGcgF5N8LQBs4ZVWMrx+mT72w4a2?=
 =?us-ascii?Q?fa3EwlKwh56I8Pn+CkEr8V5CjoJoFRX3Ejyw4dVlYXvMjDgUet8s1Ndztkb9?=
 =?us-ascii?Q?ZXXErmpVTipz6KlxznaBJzNFK9LycA+O+eRDkeOnsEXze1d41f4XJ/jM7dR5?=
 =?us-ascii?Q?Bh/u0bleSpRo/i7H892fNMeyF6hYJs31QGspQ0AkRb+ANJHqiJWmlC7QB8B4?=
 =?us-ascii?Q?C22vj3od8AHK1x5rQ1Q0ehcZBheYzclCvqN/O1RBTiEM/WVPJLu2boEMo0V1?=
 =?us-ascii?Q?8nAe1noxoQOL9fLQB22QGVtrwVAuh+Evo9rwg62OBlHwT0+sXtOYfXVZkjUx?=
 =?us-ascii?Q?KFzrIwVHN9KHfcQzwSbpG1d/iowjU4GQSOlsGJm5TFJ95kSqvgtFSzwujljm?=
 =?us-ascii?Q?eo0CdjGmV4qkr2QCjw3zW8tG48K0it495hxMSXopvfhROlMPLAS5tf0wOIY3?=
 =?us-ascii?Q?Ds/06GcIugJ/Z8d9o1uFrvdyVtAMr5Z0AFV66R4hHhKgcFSYY2FNkt0898mi?=
 =?us-ascii?Q?Jecr5VEflP78gDBRWO7Scf7YpqpVW2jNAhzyAx9QMygrF6arptYudixTkbPj?=
 =?us-ascii?Q?aF8Z81Z+QNyiNgR+l5W3GwiqK2TEBxlPzDLXt6HNmOJb5UwS/cISD5V6+J/6?=
 =?us-ascii?Q?A7h5EA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51b0b42a-01ef-4062-0844-08d9af7e1923
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 19:10:37.5357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Atm7XJolu/203de3KFHIdDE9O+jwrhH+UPEQm3/9JddM/Ykps3ZiwZlfd4G2S1o3SQ0L8RQy8m24h9/hf25ffw5FzWRTuXzNZdXVPevpftE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5234
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10178 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111240099
X-Proofpoint-GUID: TYzKT6S7jKs9q7BLIOTNCXg6gXNUYk_3
X-Proofpoint-ORIG-GUID: TYzKT6S7jKs9q7BLIOTNCXg6gXNUYk_3

Rather than calculating @pgoff manually, switch to ALIGN() instead.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index dd8222a42808..0b82159b3564 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -234,8 +234,8 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 		 * mapped. No need to consider the zero page, or racing
 		 * conflicting mappings.
 		 */
-		pgoff = linear_page_index(vmf->vma, vmf->address
-				& ~(fault_size - 1));
+		pgoff = linear_page_index(vmf->vma,
+				ALIGN(vmf->address, fault_size));
 		for (i = 0; i < fault_size / PAGE_SIZE; i++) {
 			struct page *page;
 
-- 
2.17.2

