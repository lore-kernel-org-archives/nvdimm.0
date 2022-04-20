Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A434B1863
	for <nvdimm@lists.linux.dev>; Wed, 20 Apr 2022 15:54:35 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KF6eJT025975;
	Wed, 20 Apr 2022 15:54:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Pp9ImtKk1xRZnPd6z6QwGblAXhgTBGlOjM5edRw08BY=;
 b=F93ze5EjofBrP3DIE4ALcD/N0AXH1pZYzkRKLUlY5Mv0cNwMirWXxOpuOm5dur5ug/3L
 GdXBPBfvxB6wwD3LXhLV51h0z9L686sLuXMeUb3ZdtQJ13bQbUDjwU1pdxs8f60pH7uH
 sj+iMeLpINR7bVloBsyDsVw5QxGwF3S6W4Qz1pJFF03N+su/RUisJvmGXAOR/fSevjhM
 wLtSuyiMWXHKvvYytsROxxp2blaGdLt+BFx6RT2BWFEAFETU217Fy6kmivrgz8faxm18
 xuzA1OZhkt2T9KNOkwllpW6o9N8BNznuO8EaIDioi0L7L6UDYdywLC5SJDutJ64CShQp pA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ffm7csbqr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Apr 2022 15:54:27 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23KFpnSC009004;
	Wed, 20 Apr 2022 15:54:26 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm86u8j7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Apr 2022 15:54:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XnnjBn1wwuMSGR6HUvTYMnA2/sYpyVWaoPj8HUwlETyljWVSS1Iq5HiyAn4rfxqwRrkHbgOL/Fxatt6BppuRpgDtAOFsfr4qW9rgG9EHgQRI1nlsScEwYnJ2xT4sJuyaRb739l+7qfvFneptziUvJdB5kM+R/yssypOZG01VWahxr4/GTr0UUf8/7NwBf4SFNPYjsLnSkvky4Lg79UKQsvyyR4cY6ec1DDrwUArFBTxtdgffqxpA0oqijl8wnkzUYyQ1DMjwMEpPwyLgwWOKWyAn7q1JVUcrPAlurFwvmYPCs1mPRzvONf6e+d3BEaBx/k+u9ECH7NfD+JA95hCKsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pp9ImtKk1xRZnPd6z6QwGblAXhgTBGlOjM5edRw08BY=;
 b=lqDkCyyWgkJ4oHTvi+fjOBCsaYJI+vH/Jpvbs34+MLNfvZXOaGUFnuXFidnFedZFTYzn3pSfI/l64xJtVVJtqA11eGSwdpjGsmS1vrNQ8usaTupW3r8wggyelD77CJM2QmYhPTJOYk7AnsH5opZvAFzqOOKUchk66k4GEPmcqzYAZFn3kfpRckE63KqxwMJip3t1I+W1ISdjAi5CWloSXtUmabd9PJ1iFWGeq44UfHBNaqRDDFS/nQxDuF/0KerwKZuHG9tokW0KFL+bot8c+wwIdmibT9DFbh5yiSJIJj2gVmd07KIVA/7gVSR1//jHW2H2Tch5OLu+KlHtxrUlsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pp9ImtKk1xRZnPd6z6QwGblAXhgTBGlOjM5edRw08BY=;
 b=Sa0aJGrU1kQ5aABS7tIfweO8GusoHN9K+Bd505A/6Nf/XTY5eiOyQOamWvQQ+g1zxGXSJhMVwS8QkiIGUo1YfPrWaqj/cBcMnVDnt6aoTW+KXv/89fmlGEL62laJVb4Mrk2WEiIOfXzvWLW3/dhGWsof+f0aS+s4F+ZaOT6i95M=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN6PR10MB1330.namprd10.prod.outlook.com (2603:10b6:404:43::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.25; Wed, 20 Apr
 2022 15:54:23 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d17f:a2a4:ca0c:cb49]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d17f:a2a4:ca0c:cb49%4]) with mapi id 15.20.5186.013; Wed, 20 Apr 2022
 15:54:23 +0000
From: Joao Martins <joao.m.martins@oracle.com>
To: linux-mm@kvack.org
Cc: Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: [PATCH v9 4/5] mm/sparse-vmemmap: improve memory savings for compound devmaps
Date: Wed, 20 Apr 2022 16:53:09 +0100
Message-Id: <20220420155310.9712-5-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220420155310.9712-1-joao.m.martins@oracle.com>
References: <20220420155310.9712-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0011.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::23)
 To BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55fdee67-95c6-4287-6a6d-08da22e609c4
X-MS-TrafficTypeDiagnostic: BN6PR10MB1330:EE_
X-Microsoft-Antispam-PRVS: 
	<BN6PR10MB1330E52D51782FA4C4476756BBF59@BN6PR10MB1330.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	eiEn7umiB03CzVn3AocWRU1M4nrwS1n8ioLYqef+SDXe3etqQ15fh405ZjYl9vH8IeKYHuGduoXqoNCFME8ZjXILRymz21he9HyqQdEwabGj/OAXHunSrQxKi+r5tDtGiEKeCfzYu1cNiwyY6Rg9fL/VGW2NlgOR+PoJxLbHGoITk2zb7TN8AmTPIvxYSDdEanNQEiQ2Y5iOK7n9/vLWb43fnbrVFnzE3dBZWWOrAZ/oA0eo04m23Fy2xms2yd0YiMaJeJ+WnGT76bTADMkDG0njA6505sw2A1ErU7PTYzSGL6syOYJ/cgymYFwCtVLVAy7HE34Zw/YTemfea7Rv/gDKuDPiowlS8T2mVHxUkce+M4qqXTXIE1Zgc7+WdZMzVWmZlxJxX7BiswelHFhF5gyiOVAvWoqQ8bXtujcN2yWvBKLY5zMz007MDGS7FKgwnaAGhrTOgieBHb7ZwIln+q6MqaHf/x5+jZ8Uh8cZTQ+YOhLsV1YwH3LlhxaZKf2i5z+pmzNtd5CIC8ynAeZx/ziyJ8nSiz9uKAPCMC8XNA0zR8O57xuPZtg9jgGVn4HcsdYj8JKBgvpDdXjarOoqO7bOx6R+jYJnSaRZSsEnM/VEAi6pynXLVIj1Zuf/0nCvawsZyKFpOYe4QKcQozOvGyUjSAxb1ZbjARG1e63u3v5RO7xehRPeUeJrhy0bo0fQ63dCHrdeJfbou43zWV1YRXLUmcHZxNkSNcnwJhmfOeA=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(8676002)(26005)(6512007)(4326008)(86362001)(38100700002)(38350700002)(6486002)(30864003)(8936002)(66556008)(508600001)(66946007)(6666004)(7416002)(52116002)(316002)(1076003)(6916009)(186003)(2906002)(54906003)(36756003)(83380400001)(2616005)(66476007)(5660300002)(103116003)(25903002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?untrLd3tJSLCs+Q2JBXhzHJcaA/v6ZgXqNDS+O02iliC74wDuzIZPWtN/+M2?=
 =?us-ascii?Q?np3Brrjt+SgCFC9kxnpO8XYLv0hltqSy+bMKdF8P2u8vrbt9LpTYZC97KXp1?=
 =?us-ascii?Q?ChAmmu79uwww+jRghXQutV/L4eygV//R3uktNiQj7ofihUX0BFi0kzuBIgOg?=
 =?us-ascii?Q?ukGC+2r4f+9mHQLjk+/vZSzmpHcqHGo1R+ut0bCpj0/Cms78xFIqz9XuUrw+?=
 =?us-ascii?Q?V6hkgx3u7BHsVVXRDj+wXC8H7UvJCZyaBRE3FrFOWy6+bB2UnN3cjBZ5eeS4?=
 =?us-ascii?Q?Hm3J2lFnlGf+HLME30GAjfY4Gf7ICsrWIYCySURuOA1sE5ha8aQFvIo3bqgF?=
 =?us-ascii?Q?isXXuXGRClFOH6o3qB9bsuQSfUpN+Mm7Zw/SeNmRNEJ3RVJuS1Saz2DLNxlg?=
 =?us-ascii?Q?SiKy5+z0g9Uia4gXrtdcXgXz/fykRWOH5nwVxheHOMuG6uWtvd9rLX3PAByK?=
 =?us-ascii?Q?hUprNBoLpmmXW6Sd+EG7blxC5tHs5s7dZR2dIYxG6akcoqHsp7t2nEUh42EH?=
 =?us-ascii?Q?RljxiUcf1NQ6Bp1xPgUlVy6t9xczE+yLg/U14bdwdkiE3upqgQ4+e4drr5vf?=
 =?us-ascii?Q?YweMLnvSTNgxxF4pfyTiQOW0QNWlFUCwQ6935fKLteVfH03umeAAl2j2GNSx?=
 =?us-ascii?Q?5Nz8v9TJlq+PnXFHSTqlJUXEAqFBj7tfk0hQGCKkFtnU7bzwRdm2WB3S5BQt?=
 =?us-ascii?Q?AcBfpyChfsU78vAAZvllFDtwklwvULLZfwTaSK046MJQ96qrmdSfqwVkiXys?=
 =?us-ascii?Q?n6fRKP6NQSMzG6GtVsRDoccPNIsExg4yHoBuBI0J5L7JIcdnGDzIDXtXV1qp?=
 =?us-ascii?Q?CorCgI8A8+EpMSlGjCL2iFZyWAeldgw8I0JsksNiIHoDxWbHQP2LgwjmmmfX?=
 =?us-ascii?Q?6Ad+uVeaaEANmFxZvvrqLlikIpftHGEkkXbqTwtAP+nee2CVWAfVZWz+V3qM?=
 =?us-ascii?Q?TYDSbdWScoKts/IhkUNlYRt+QEDa5tx14erjom62u2NJMyDZEliwaqwP/AfG?=
 =?us-ascii?Q?9NNohkTptY2yL9ha9+nu7K/UQu9IkUw5cClSAjlrwRJLK4Zzse85cI2tXOD6?=
 =?us-ascii?Q?8klq7wNDK6NKRiHuDzV1LmxEIryU5jNR9rJJLTNk+jlj/d5SAATo2Jac1TE8?=
 =?us-ascii?Q?bpqRehIEgfgouBMKg6HxW3Aku3bPV3UkJM/FYsufg7LDbm34CuwI7zpuC+Dh?=
 =?us-ascii?Q?i1RKsaUFuOW0ZyrabNk5NIdrfe8qUqcrPUvC4VT2+lXFgTGLmE41iqPoDXVw?=
 =?us-ascii?Q?P0ErEczTuC0nVMZoW9MDX+SfjgbYUUJ9/CvBYRwVCtNHpWqOOsDCn6W73JSv?=
 =?us-ascii?Q?xlNqVxugvNHjPXhAnGP7xpzBXIUcT2P55zigufBaSnb3isrqkCWam3ry914j?=
 =?us-ascii?Q?Lx9V1wlUE3+AiH9KcUY0dLrC7yH8YMjMDKeE40JGs1ZFdwtjJRp2jC7xl5Bs?=
 =?us-ascii?Q?h1T7ZWqVIHw2gqoz96whyNTjEqYbhPfJGmT1iCGScSIwixYxumZT5sLC0mQ6?=
 =?us-ascii?Q?JRmUpt/LMWJXKG0HNLkOJ7KjvV0i+ay8p7BYTGBG9cvp6yp8MPkNNMNDVHMg?=
 =?us-ascii?Q?djwfrKWC3qwbickKdaEIRlj3iaccQs4exLlTSA970rphmecVbVifi3DHXwgP?=
 =?us-ascii?Q?aAdG6BXA7L/HZuZlHGhvs6j6zbb4DRv2IXDTKK1WmeBJWuGpqUZfUwVlHJ3u?=
 =?us-ascii?Q?N/Dj5KpHXZspnFaTWS00StwiM6rVUZ/MudE4BXPvskPFRdclSuC2VLieQ8Y5?=
 =?us-ascii?Q?ODeNgNdgRzRvk3beDABXPidYtx7c6/U=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55fdee67-95c6-4287-6a6d-08da22e609c4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 15:54:23.2566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x/wHtp4GDFFw3cPL0LVz/pcMzIjDPP1ODCXcCyHnaJGwGm+da6WESmw0eYJtYCPjNlTMZFYqSjwGBQtgazTLYj5a8VvcXPZ4tNobvepXH5c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1330
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-20_04:2022-04-20,2022-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204200094
X-Proofpoint-GUID: 3OLG8k9dCIVQTZalwWBjFQgO6-UogQdc
X-Proofpoint-ORIG-GUID: 3OLG8k9dCIVQTZalwWBjFQgO6-UogQdc

A compound devmap is a dev_pagemap with @vmemmap_shift > 0 and it
means that pages are mapped at a given huge page alignment and utilize
uses compound pages as opposed to order-0 pages.

Take advantage of the fact that most tail pages look the same (except
the first two) to minimize struct page overhead. Allocate a separate
page for the vmemmap area which contains the head page and separate for
the next 64 pages. The rest of the subsections then reuse this tail
vmemmap page to initialize the rest of the tail pages.

Sections are arch-dependent (e.g. on x86 it's 64M, 128M or 512M) and
when initializing compound devmap with big enough @vmemmap_shift (e.g.
1G PUD) it may cross multiple sections. The vmemmap code needs to
consult @pgmap so that multiple sections that all map the same tail
data can refer back to the first copy of that data for a given
gigantic page.

On compound devmaps with 2M align, this mechanism lets 6 pages be
saved out of the 8 necessary PFNs necessary to set the subsection's
512 struct pages being mapped. On a 1G compound devmap it saves
4094 pages.

Altmap isn't supported yet, given various restrictions in altmap pfn
allocator, thus fallback to the already in use vmemmap_populate().  It
is worth noting that altmap for devmap mappings was there to relieve the
pressure of inordinate amounts of memmap space to map terabytes of pmem.
With compound pages the motivation for altmaps for pmem gets reduced.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 Documentation/vm/vmemmap_dedup.rst |  56 +++++++++++-
 include/linux/mm.h                 |   2 +-
 mm/memremap.c                      |   1 +
 mm/sparse-vmemmap.c                | 132 ++++++++++++++++++++++++++---
 4 files changed, 177 insertions(+), 14 deletions(-)

diff --git a/Documentation/vm/vmemmap_dedup.rst b/Documentation/vm/vmemmap_dedup.rst
index 485ccf4f7b10..c9c495f62d12 100644
--- a/Documentation/vm/vmemmap_dedup.rst
+++ b/Documentation/vm/vmemmap_dedup.rst
@@ -1,8 +1,11 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-==================================
-Free some vmemmap pages of HugeTLB
-==================================
+=========================================
+A vmemmap diet for HugeTLB and Device DAX
+=========================================
+
+HugeTLB
+=======
 
 The struct page structures (page structs) are used to describe a physical
 page frame. By default, there is a one-to-one mapping from a page frame to
@@ -171,3 +174,50 @@ tail vmemmap pages are mapped to the head vmemmap page frame. So we can see
 more than one struct page struct with PG_head (e.g. 8 per 2 MB HugeTLB page)
 associated with each HugeTLB page. The compound_head() can handle this
 correctly (more details refer to the comment above compound_head()).
+
+Device DAX
+==========
+
+The device-dax interface uses the same tail deduplication technique explained
+in the previous chapter, except when used with the vmemmap in
+the device (altmap).
+
+The following page sizes are supported in DAX: PAGE_SIZE (4K on x86_64),
+PMD_SIZE (2M on x86_64) and PUD_SIZE (1G on x86_64).
+
+The differences with HugeTLB are relatively minor.
+
+It only use 3 page structs for storing all information as opposed
+to 4 on HugeTLB pages.
+
+There's no remapping of vmemmap given that device-dax memory is not part of
+System RAM ranges initialized at boot. Thus the tail page deduplication
+happens at a later stage when we populate the sections. HugeTLB reuses the
+the head vmemmap page representing, whereas device-dax reuses the tail
+vmemmap page. This results in only half of the savings compared to HugeTLB.
+
+Deduplicated tail pages are not mapped read-only.
+
+Here's how things look like on device-dax after the sections are populated::
+
+ +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
+ |           |                     |     0     | -------------> |     0     |
+ |           |                     +-----------+                +-----------+
+ |           |                     |     1     | -------------> |     1     |
+ |           |                     +-----------+                +-----------+
+ |           |                     |     2     | ----------------^ ^ ^ ^ ^ ^
+ |           |                     +-----------+                   | | | | |
+ |           |                     |     3     | ------------------+ | | | |
+ |           |                     +-----------+                     | | | |
+ |           |                     |     4     | --------------------+ | | |
+ |    PMD    |                     +-----------+                       | | |
+ |   level   |                     |     5     | ----------------------+ | |
+ |  mapping  |                     +-----------+                         | |
+ |           |                     |     6     | ------------------------+ |
+ |           |                     +-----------+                           |
+ |           |                     |     7     | --------------------------+
+ |           |                     +-----------+
+ |           |
+ |           |
+ |           |
+ +-----------+
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 62564d81d8cb..a097323778c4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3209,7 +3209,7 @@ p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
 pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
 pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
 pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-			    struct vmem_altmap *altmap);
+			    struct vmem_altmap *altmap, struct page *reuse);
 void *vmemmap_alloc_block(unsigned long size, int node);
 struct vmem_altmap;
 void *vmemmap_alloc_block_buf(unsigned long size, int node,
diff --git a/mm/memremap.c b/mm/memremap.c
index a7b6abf6ca1b..223ada81fe43 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -307,6 +307,7 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 {
 	struct mhp_params params = {
 		.altmap = pgmap_altmap(pgmap),
+		.pgmap = pgmap,
 		.pgprot = PAGE_KERNEL,
 	};
 	const int nr_range = pgmap->nr_range;
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index ef15664c6b6c..f4fa61dbbee3 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -533,16 +533,31 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 }
 
 pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-				       struct vmem_altmap *altmap)
+				       struct vmem_altmap *altmap,
+				       struct page *reuse)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	if (pte_none(*pte)) {
 		pte_t entry;
 		void *p;
 
-		p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
-		if (!p)
-			return NULL;
+		if (!reuse) {
+			p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
+			if (!p)
+				return NULL;
+		} else {
+			/*
+			 * When a PTE/PMD entry is freed from the init_mm
+			 * there's a a free_pages() call to this page allocated
+			 * above. Thus this get_page() is paired with the
+			 * put_page_testzero() on the freeing path.
+			 * This can only called by certain ZONE_DEVICE path,
+			 * and through vmemmap_populate_compound_pages() when
+			 * slab is available.
+			 */
+			get_page(reuse);
+			p = page_to_virt(reuse);
+		}
 		entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
 	}
@@ -609,7 +624,8 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 }
 
 static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
-					      struct vmem_altmap *altmap)
+					      struct vmem_altmap *altmap,
+					      struct page *reuse)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -629,7 +645,7 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 	pmd = vmemmap_pmd_populate(pud, addr, node);
 	if (!pmd)
 		return NULL;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap);
+	pte = vmemmap_pte_populate(pmd, addr, node, altmap, reuse);
 	if (!pte)
 		return NULL;
 	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
@@ -639,13 +655,14 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 
 static int __meminit vmemmap_populate_range(unsigned long start,
 					    unsigned long end, int node,
-					    struct vmem_altmap *altmap)
+					    struct vmem_altmap *altmap,
+					    struct page *reuse)
 {
 	unsigned long addr = start;
 	pte_t *pte;
 
 	for (; addr < end; addr += PAGE_SIZE) {
-		pte = vmemmap_populate_address(addr, node, altmap);
+		pte = vmemmap_populate_address(addr, node, altmap, reuse);
 		if (!pte)
 			return -ENOMEM;
 	}
@@ -656,7 +673,95 @@ static int __meminit vmemmap_populate_range(unsigned long start,
 int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 					 int node, struct vmem_altmap *altmap)
 {
-	return vmemmap_populate_range(start, end, node, altmap);
+	return vmemmap_populate_range(start, end, node, altmap, NULL);
+}
+
+/*
+ * For compound pages bigger than section size (e.g. x86 1G compound
+ * pages with 2M subsection size) fill the rest of sections as tail
+ * pages.
+ *
+ * Note that memremap_pages() resets @nr_range value and will increment
+ * it after each range successful onlining. Thus the value or @nr_range
+ * at section memmap populate corresponds to the in-progress range
+ * being onlined here.
+ */
+static bool __meminit reuse_compound_section(unsigned long start_pfn,
+					     struct dev_pagemap *pgmap)
+{
+	unsigned long nr_pages = pgmap_vmemmap_nr(pgmap);
+	unsigned long offset = start_pfn -
+		PHYS_PFN(pgmap->ranges[pgmap->nr_range].start);
+
+	return !IS_ALIGNED(offset, nr_pages) && nr_pages > PAGES_PER_SUBSECTION;
+}
+
+static pte_t * __meminit compound_section_tail_page(unsigned long addr)
+{
+	pte_t *pte;
+
+	addr -= PAGE_SIZE;
+
+	/*
+	 * Assuming sections are populated sequentially, the previous section's
+	 * page data can be reused.
+	 */
+	pte = pte_offset_kernel(pmd_off_k(addr), addr);
+	if (!pte)
+		return NULL;
+
+	return pte;
+}
+
+static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
+						     unsigned long start,
+						     unsigned long end, int node,
+						     struct dev_pagemap *pgmap)
+{
+	unsigned long size, addr;
+	pte_t *pte;
+	int rc;
+
+	if (reuse_compound_section(start_pfn, pgmap)) {
+		pte = compound_section_tail_page(start);
+		if (!pte)
+			return -ENOMEM;
+
+		/*
+		 * Reuse the page that was populated in the prior iteration
+		 * with just tail struct pages.
+		 */
+		return vmemmap_populate_range(start, end, node, NULL,
+					      pte_page(*pte));
+	}
+
+	size = min(end - start, pgmap_vmemmap_nr(pgmap) * sizeof(struct page));
+	for (addr = start; addr < end; addr += size) {
+		unsigned long next = addr, last = addr + size;
+
+		/* Populate the head page vmemmap page */
+		pte = vmemmap_populate_address(addr, node, NULL, NULL);
+		if (!pte)
+			return -ENOMEM;
+
+		/* Populate the tail pages vmemmap page */
+		next = addr + PAGE_SIZE;
+		pte = vmemmap_populate_address(next, node, NULL, NULL);
+		if (!pte)
+			return -ENOMEM;
+
+		/*
+		 * Reuse the previous page for the rest of tail pages
+		 * See layout diagram in Documentation/vm/vmemmap_dedup.rst
+		 */
+		next += PAGE_SIZE;
+		rc = vmemmap_populate_range(next, last, node, NULL,
+					    pte_page(*pte));
+		if (rc)
+			return -ENOMEM;
+	}
+
+	return 0;
 }
 
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
@@ -665,12 +770,19 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
+	int r;
 
 	if (WARN_ON_ONCE(!IS_ALIGNED(pfn, PAGES_PER_SUBSECTION) ||
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
-	if (vmemmap_populate(start, end, nid, altmap))
+	if (is_power_of_2(sizeof(struct page)) &&
+	    pgmap && pgmap_vmemmap_nr(pgmap) > 1 && !altmap)
+		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
+	else
+		r = vmemmap_populate(start, end, nid, altmap);
+
+	if (r < 0)
 		return NULL;
 
 	return pfn_to_page(pfn);
-- 
2.17.2

