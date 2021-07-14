Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3788E17F
	for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 19:36:17 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16EJVdnA009369;
	Wed, 14 Jul 2021 19:36:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=XoxHzHAMM9oJZqN+t6xe6mxgkfsozmJmybUdFrsYolY=;
 b=Htxd6b20o5qzVG2Ncdmka29c9xD98fim+2D83qUi6wyQM+9gkmkIUL2I31/3W0lTvWvp
 z4kglxuO/egd+CqIQTqgGKq6FqyJGuIb8FpazgmtYTkKBzA8ZnSB6c3CCvSkEPadVafW
 6/eg5X7ktmKTQm6tv6c6hV36V0J5zgrh2lzQaSs7YqxnOYUqrfnDwfqnbWm3/GaLehhb
 x7dsZ8mFHZIwx6Y4/UidKe6jNAqaurI0LLjh0cNY5Em3BigNIdb5SdEavrZXHC0WfYIx
 EEJ7Tc3ztf1bwTJ8DvNBgk2LNSd55gd+6QhPSVhrogeiz9Cx1rs5glJZNVNImag2Ys/w kQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=XoxHzHAMM9oJZqN+t6xe6mxgkfsozmJmybUdFrsYolY=;
 b=CZUzielpMQEiZzcCla6ys3Iw6y9LDhsLAMIizkmU9Y3Agag7HXO+oJM3h2WjrMiHfmqa
 QR4Zig9zvNAy5zgoEDv8q8BfohK/VhHcJM9lHaWsKDi2h8kjlXUy5RIMbZPT/oeaMvii
 gk3zxu5KB25rhLZjLQLZ9FhZpvfzq2rpuyg7LHikjBVjoGLY6tOWHlotbM5aN81svCJ8
 BsHIBs/1EYobHfiYosWqdNHkd7vlSfYS71YPGvNSys3Ic9OlumIZTK2aMePyKJI3XR3e
 06fXyOwTT8QAZ7/04H+NbgJ13AIWcF6QHdQ9OfwUy/Dp+JibUUxjZVjN5j6uyRkn06Pu 3Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 39sbtuk7ue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16EJUxOI079690;
	Wed, 14 Jul 2021 19:36:09 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
	by userp3020.oracle.com with ESMTP id 39qnb428kk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oXonmSdi8usYB0W8Tzp+hQJDQ9JP5S7Kz+mfmktYijuREE18ElqRe/KgguE+KRlLlCGkl1TV7bWH5GBPnnG8V/bub9e6B7tGQ/J2u4o+cSyB/qnqneLnBc9jpSRRfxFzBZvXyB2elr3kON+OXODpnJlcGCTvd9t5qb9ouaI4hcxjjLyBiO55mJOS67eS8HXVAcdwDOUi5ZNYoWZDVJ/zm79DDZwrma9SK8BV8rMilodhnk7quTlvBnrbJ4KyAsOtvhdMrSufrUFuQw2gK/Po530vcbzaJTNwkJ3xU5X708Fl8jutPCoieSId1iv+EstYf/V2qLAVXWWC7x37EHEaUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoxHzHAMM9oJZqN+t6xe6mxgkfsozmJmybUdFrsYolY=;
 b=GhnUUtwHGt91POhXB0WkwZIRYKu7ug96HHehatgvrvqAXEtkv1EipcqpJfESTYCxcZgxN13lxLfzsncsOkPuagE/gh/qHTXv+fWklDU3sVDIQYCB+EjIKYS5DiNLWaIp1ipL4gTovQQn7vDodW+1OeheGScR0NuPg61bXs2MOzlFbxFxtd1Zmk3RNYRySNlfdNSmTFHRhMrrNO/itBRXaD7RyWKk9aLG72e4cytygKZMixXJGfjOnmLfseKlGQ7NIKE0VbMkaaizzeDR9OWT4Ys5uIicgcN9G4GPWlwa6BLgCSyqLZ/m2Jryv08HhxQB9AT+GTNLFmGzAm8xinctIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoxHzHAMM9oJZqN+t6xe6mxgkfsozmJmybUdFrsYolY=;
 b=n/98cJFRvkr7vXDa0Dsv6sGEi3XvE5/QC3KnCQpkOU+E2LDLdTsnMIqXWeuliwo2UfWt4S2+f+fygL1gd7tySvfJm8wC0u0qau+s6ohDth5uPRACONd64rqhpHULAzAN2DjjV89GkG9P/BDRQYGGe6YrCxO3EXcTnNWzIpw2bLc=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4080.namprd10.prod.outlook.com (2603:10b6:208:185::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22; Wed, 14 Jul
 2021 19:36:07 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4331.022; Wed, 14 Jul 2021
 19:36:07 +0000
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
Subject: [PATCH v3 04/14] mm/memremap: add ZONE_DEVICE support for compound pages
Date: Wed, 14 Jul 2021 20:35:32 +0100
Message-Id: <20210714193542.21857-5-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210714193542.21857-1-joao.m.martins@oracle.com>
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0048.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from paddy.uk.oracle.com (94.61.1.144) by AM4PR0101CA0048.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 19:36:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2fd76329-1c9e-4ec9-b829-08d946fea03a
X-MS-TrafficTypeDiagnostic: MN2PR10MB4080:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB4080D5808B5172C41C45E876BB139@MN2PR10MB4080.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	NB0GI8L9bYp2M/UT2zgQwOV3EkVAz0iZShY8kgyWnnJaxa7L5rfelrI+jW/N5469rnxHNP8YKAaMaxONdCXnOHS5TnKxfA9Cb5NXr5/q14/x3qK+oUvGE0ain1fe/hBRvM1eNJC1Eb/hUbvSWy3deBs5vVg2psmOnmmsJXbeyipzAb3PPXJUPjG4ch/dEsACih8qmaO0VeHSyv7z5sRlFeG0oSS6YvB6p1JU9oO5qVpLQy3dmA3E8d09uHM3xvanLo9xkhrEt92AVOFoIsYxo00aDStbYA6ARGKqll0pSPyPecblenZj0ATEaxppb5JV/rfaRdFE1hQIawjx6qVOaP+UvJnxMA5bQaNfu4jVnDotkmjXn81CTjlcPNpliKgchs6Oni93YvXDeME4GaZTcHrnr/qaB3ZxRFDpMZ5PntzJMha5lL6ox6v+SMiXKqEAl2IGPG0GD+jaSoTEng0OpMaK7cNNTc4SVNDeuX8oOxIrDg/RT3MWT91bXD/KHXUiXAPFwvhiIVGuW4fnKSyvl5jU1I5niLJ7PHe3U1Qha5XD/zpw+AbVFX44R6rGr82U/2+SumzVXC0ukFLX5gijcki0zcLyjJDK4Su4FiHyqPpCKEsyXUHyZ97tMjVgIvyJHi2n2F5sD/XePyMQEmQHQbaOjye7l3dQjMtgoEISc7UTqjbXcWEwp7ZsWJ3CDq6DDtqbJvMRjiWOCtKbBCtz6A==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(376002)(39860400002)(136003)(6486002)(8676002)(54906003)(86362001)(5660300002)(36756003)(478600001)(186003)(6916009)(8936002)(4326008)(316002)(83380400001)(52116002)(107886003)(7696005)(66946007)(6666004)(1076003)(2906002)(26005)(38100700002)(66556008)(103116003)(956004)(66476007)(2616005)(38350700002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?frx9lq9rMAZ1EEbT4EaZ9uVBb2AJeom6vqZrikauCM7Vd2wGvOX48LZKmUoe?=
 =?us-ascii?Q?OUvVY7rIQIbCIAVjOwWte2a8BRodVMsmkgyNkON/ZGI6wrTnz0TGMGJZker7?=
 =?us-ascii?Q?0lqyes23HjSCcq/51UypgeDoN9GusyIam9ACEdwnb5x2r0aXQsUabeGEUosa?=
 =?us-ascii?Q?WsT5H4Pydq2qL6F5dNa9lm32IKLlg3BPNmw8Ced7tTDuJYAHIj9JoL15q8OY?=
 =?us-ascii?Q?p8uyaJb1JYJTRzuBYbVP+rGIHJTe/JnCh23PM6oQBgBvQybaQK0sUyrUIc/u?=
 =?us-ascii?Q?gsVNEyhVoEDQd0+Vx8aBN8DDKbT2Hiw5TFvVgFQ5xeHq3efkW0PBRx/xEzVx?=
 =?us-ascii?Q?ot5ZFZBpB35v51kLIGkLk465qgNCaKy6CMgduZLPHNkr97Z+XR+c2a8lRdSK?=
 =?us-ascii?Q?ALSwuzpfbRhEBc/1d0tECgvoIeVXjJJrGt3obC+BNkKPPbFeE16oYeg/Ytca?=
 =?us-ascii?Q?vpJVzka8EwNjkJ5RfmF28XBHi1AT3qJePke5Q01gHNs5EfMEURRW8403TRqr?=
 =?us-ascii?Q?/3v/0CaDP324KtkR1I1154jvr3FmjJlIRzytHQQstf87Af5c+9i10p/8bNb8?=
 =?us-ascii?Q?L5LK/hjp7hDGc9Qgu0o0NX0J+bq9DK6x+GdpYjqGgMQHFqnBb7IAyIIatQkv?=
 =?us-ascii?Q?CPNFZK0+AZIm4ANuw3WXaJ8nYyr1xH0pn3oZs7IqVBVtTb1uUl4pdvfFKf4i?=
 =?us-ascii?Q?n+cLfEWFzU7A2m4RZHDm7Hkrfl8Cs6GDH9LNXFg9PuLezox7Cw3nV480lqca?=
 =?us-ascii?Q?EB02cfIlm5BazyheH8tB/caeePwXU0Wv8OzsZccutUVRcdgV/L5r03tMU3zJ?=
 =?us-ascii?Q?tDSIqlOga8SMmpGTS8Pl4mgMi1U6hbmOKXmwbg1GG/9+CnTfne/+dkevwajo?=
 =?us-ascii?Q?NNI/f14UuQoRTIFo0G0gQ7rgpgTkgCXDjPBKRPERMkNKnM5L0PloDFMD6cEK?=
 =?us-ascii?Q?Bgva7b8wE+LfhcJdzSUkb6QGrVs5w6+gTxQbaxLJnQwx61Cu4O2A26+8rZKU?=
 =?us-ascii?Q?LZOxTr3rR2wkllZWvGczM9UEmCv1vEbUMgmHk/Vihmcg0TjbTF/yR9mJD2jH?=
 =?us-ascii?Q?QHEcESkXg7qn7GPiyqa6FlJJJw8fef7q+Zeho8pSArlWoRhNSXsw7P6sSMeL?=
 =?us-ascii?Q?J/AWM2KDCX6DVFM/cDD3PhCaC3GomKjQoDUEq78U1TvTdLHAqUrUXrT32Oa4?=
 =?us-ascii?Q?h5VyVHL2fk3g2bRV6o4u3fLTzhGRK8gd0Xk8KFoTVROpWWxtqXRt3iN3xzAJ?=
 =?us-ascii?Q?ST7H1VLKzROUXHxXRIfigx05NpSvMugFUm6Fkae6hEw+WCaMGS7EuCC8qrsH?=
 =?us-ascii?Q?ImAvFRcMY9zgJfZFez8Wszqg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fd76329-1c9e-4ec9-b829-08d946fea03a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 19:36:07.5925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VmhNzo3B5o0lIAjD4J5hnYkxxeahuH9psZvVjpcED8ajyMrzw3NM0pn2HblBSvYvFd+J/TQGbcolamKSrC+aLjgbr0+3Lmawa9o86E3JJMI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4080
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107140115
X-Proofpoint-GUID: S9BiDl7ICR21jCS_uf07NHZ8H6WSXT6_
X-Proofpoint-ORIG-GUID: S9BiDl7ICR21jCS_uf07NHZ8H6WSXT6_

Add a new align property for struct dev_pagemap which specifies that a
pagemap is composed of a set of compound pages of size @align, instead of
base pages. When a compound page geometry is requested, all but the first
page are initialised as tail pages instead of order-0 pages.

For certain ZONE_DEVICE users like device-dax which have a fixed page size,
this creates an opportunity to optimize GUP and GUP-fast walkers, treating
it the same way as THP or hugetlb pages.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 include/linux/memremap.h | 17 +++++++++++++++++
 mm/memremap.c            |  8 ++++++--
 mm/page_alloc.c          | 34 +++++++++++++++++++++++++++++++++-
 3 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 119f130ef8f1..e5ab6d4525c1 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -99,6 +99,10 @@ struct dev_pagemap_ops {
  * @done: completion for @internal_ref
  * @type: memory type: see MEMORY_* in memory_hotplug.h
  * @flags: PGMAP_* flags to specify defailed behavior
+ * @geometry: structural definition of how the vmemmap metadata is populated.
+ *	A zero or PAGE_SIZE defaults to using base pages as the memmap metadata
+ *	representation. A bigger value but also multiple of PAGE_SIZE will set
+ *	up compound struct pages representative of the requested geometry size.
  * @ops: method table
  * @owner: an opaque pointer identifying the entity that manages this
  *	instance.  Used by various helpers to make sure that no
@@ -114,6 +118,7 @@ struct dev_pagemap {
 	struct completion done;
 	enum memory_type type;
 	unsigned int flags;
+	unsigned long geometry;
 	const struct dev_pagemap_ops *ops;
 	void *owner;
 	int nr_range;
@@ -130,6 +135,18 @@ static inline struct vmem_altmap *pgmap_altmap(struct dev_pagemap *pgmap)
 	return NULL;
 }
 
+static inline unsigned long pgmap_geometry(struct dev_pagemap *pgmap)
+{
+	if (!pgmap || !pgmap->geometry)
+		return PAGE_SIZE;
+	return pgmap->geometry;
+}
+
+static inline unsigned long pgmap_pfn_geometry(struct dev_pagemap *pgmap)
+{
+	return PHYS_PFN(pgmap_geometry(pgmap));
+}
+
 #ifdef CONFIG_ZONE_DEVICE
 bool pfn_zone_device_reserved(unsigned long pfn);
 void *memremap_pages(struct dev_pagemap *pgmap, int nid);
diff --git a/mm/memremap.c b/mm/memremap.c
index 805d761740c4..ffcb924eb6a5 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -318,8 +318,12 @@ static int pagemap_range(struct dev_pagemap *pgmap, struct mhp_params *params,
 	memmap_init_zone_device(&NODE_DATA(nid)->node_zones[ZONE_DEVICE],
 				PHYS_PFN(range->start),
 				PHYS_PFN(range_len(range)), pgmap);
-	percpu_ref_get_many(pgmap->ref, pfn_end(pgmap, range_id)
-			- pfn_first(pgmap, range_id));
+	if (pgmap_geometry(pgmap) > PAGE_SIZE)
+		percpu_ref_get_many(pgmap->ref, (pfn_end(pgmap, range_id)
+			- pfn_first(pgmap, range_id)) / pgmap_pfn_geometry(pgmap));
+	else
+		percpu_ref_get_many(pgmap->ref, pfn_end(pgmap, range_id)
+				- pfn_first(pgmap, range_id));
 	return 0;
 
 err_add_memory:
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 79f3b38afeca..188cb5f8c308 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6597,6 +6597,31 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	}
 }
 
+static void __ref memmap_init_compound(struct page *page, unsigned long pfn,
+					unsigned long zone_idx, int nid,
+					struct dev_pagemap *pgmap,
+					unsigned long nr_pages)
+{
+	unsigned int order_align = order_base_2(nr_pages);
+	unsigned long i;
+
+	__SetPageHead(page);
+
+	for (i = 1; i < nr_pages; i++) {
+		__init_zone_device_page(page + i, pfn + i, zone_idx,
+					nid, pgmap);
+		prep_compound_tail(page, i);
+
+		/*
+		 * The first and second tail pages need to
+		 * initialized first, hence the head page is
+		 * prepared last.
+		 */
+		if (i == 2)
+			prep_compound_head(page, order_align);
+	}
+}
+
 void __ref memmap_init_zone_device(struct zone *zone,
 				   unsigned long start_pfn,
 				   unsigned long nr_pages,
@@ -6605,6 +6630,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	unsigned long pfn, end_pfn = start_pfn + nr_pages;
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	struct vmem_altmap *altmap = pgmap_altmap(pgmap);
+	unsigned int pfns_per_compound = pgmap_pfn_geometry(pgmap);
 	unsigned long zone_idx = zone_idx(zone);
 	unsigned long start = jiffies;
 	int nid = pgdat->node_id;
@@ -6622,10 +6648,16 @@ void __ref memmap_init_zone_device(struct zone *zone,
 		nr_pages = end_pfn - start_pfn;
 	}
 
-	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
+	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
 		struct page *page = pfn_to_page(pfn);
 
 		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+
+		if (pfns_per_compound == 1)
+			continue;
+
+		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
+				     pfns_per_compound);
 	}
 
 	pr_info("%s initialised %lu pages in %ums\n", __func__,
-- 
2.17.1

