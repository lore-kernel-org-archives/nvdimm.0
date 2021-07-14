Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645D56D37
	for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 19:36:39 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16EJVdqI009390;
	Wed, 14 Jul 2021 19:36:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=eItdugg6FcfLnkv9zYSPCFwM/aIL01iwtGtFBoCYk6k=;
 b=h/M1lzJP8vCYG+OUcJDkQxIxl9xK62qMeo5/sdoyt6nYPHFtGV/+twJv7z41oqW7Bw5G
 Ug22y4Zqz5udngQ1+NrKN5g8ras9a3P/w2W7kkRhdz6zRhHxqDivxh2XXNA+RJ/QnYod
 NtVRhawOpUs7L5xvB3dcdaMpUhybi0rdmxOXTN1rLdt88XWD0G6i6S1RJqLl+JAheukT
 wotz+6l45XXezRbGe7rQhZw6XCDMX54B9FTqg0FiwvJM5wto++zUwgtSMbS2Ffw2QhXN
 JUcDUvmxz50+m6rigu6/ylCiuEnCFttlyYd6hw3jvdxpafswZYaaERJVCkI+5hW1wvJ6 jg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=eItdugg6FcfLnkv9zYSPCFwM/aIL01iwtGtFBoCYk6k=;
 b=GYmvTbBj/D3Ix768TwaFJtlAzQt2+Jvdbkr/Yjm1ypSuTlT2jqnp7zElAc40PZe6y8If
 15KITnEf2b3hhVXzQW3J+N5osr7UjrMKHPtRA35lV5uPGC3kGQvw0xHHJxVXEPBDGuHa
 mm5aw6PZkJeoLrxVBspt2kD5j4ZxQhg8Okm2mWGjGdb81vHBsaEiQ5HjC9hPZCcHZILJ
 qsPtjsSDtabPGrkQXFzBd+iylycpHr5SyoohnJMrbxs7bcRu5MjB2yVapi/p6LXSOL5b
 86mpAhD468Vl8cZ5WyfzWQgiua0w5knyPAe6BgVTC4EMp/Zy2aDgOVU0DvyufAoerqFQ 6g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 39sbtuk7v7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16EJUYri021568;
	Wed, 14 Jul 2021 19:36:31 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
	by userp3030.oracle.com with ESMTP id 39q0p98mju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GCqsbbYVIljX4YD0GbxVBU3v0ZlPTGzxsjDLCpfEPl+xCvV5/SUzD1davla6hR0s4Rsp9J5xGZ3QockYIV7HZ1k9KFNe+J56N01K8GXNuGdXircHaqxya4h4YQ749a7QSExtzPDUmpTribWMaeoEjWIcrL2FEeE5Hy6glGpxK+u1+btgxtusILKd+wIn2sMVVt0banbIHc2lZHnexbCw/PE5bU3KddqrErGwqqlNfShNkusim//wVcusPSnlVBPuZgehqvZgSuAu6dkydnN4qyxLwQH39sqMZ0KjcPt5pQVCdklJcsv+Cv/1EixOKIOMEPhRK4smnmaiTbfvH/j34g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eItdugg6FcfLnkv9zYSPCFwM/aIL01iwtGtFBoCYk6k=;
 b=i+Fe5Xi5u1dFG72Wfu8BOI3mYfy0YK6W0rjiFC669z0QcKrQzd0jtVr2LozIhAM9GchHP6iBcsV5WDahrSZ0KC0WIPMy5dITDb/WPBsup0jvF5P35CrsQqiIABqefno5/Px9VUbSKoelsJTACo5ydvFbBQpH4Gk3Zv6NZZr0HhkWiNfr+P8JlU9orQCGvcDu8k0Bb3wC/0gQgZuWwJFEaDcHsNU6qNYOwiijG8w6J6AD/ZnTBTKVKShWGrAWfAvwr5Wexa8A+v7zrm5X+jnhwMrgyjNx+SmLohAL5KP+yJfsKmCnEsTwfbdKQzLovwxkRk74O+kaS5hoDq6UNevK6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eItdugg6FcfLnkv9zYSPCFwM/aIL01iwtGtFBoCYk6k=;
 b=Lr44uyilPxB6BfYrFIYsAcxt9jMTzvlqTNcgQTrqKh7bJ1/A0l6CPYccEgDLlOjOPTAe3eiHt1HfkZiYVx0laiwwBWAMRDal5XwreQoc5sr8zyhttqjSVvqgN7aieDdFqdIhcLFp0OfZn1LCZlG7Vlsqyqi2wWhOJKjBtCunTeg=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL0PR10MB2899.namprd10.prod.outlook.com (2603:10b6:208:78::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Wed, 14 Jul
 2021 19:36:29 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4331.022; Wed, 14 Jul 2021
 19:36:29 +0000
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
Subject: [PATCH v3 12/14] device-dax: compound pagemap support
Date: Wed, 14 Jul 2021 20:35:40 +0100
Message-Id: <20210714193542.21857-13-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (94.61.1.144) by AM4PR0101CA0048.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 19:36:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 558d8404-a7d8-4653-ae9c-08d946fead59
X-MS-TrafficTypeDiagnostic: BL0PR10MB2899:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BL0PR10MB28990920DC05B61EB67A187DBB139@BL0PR10MB2899.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	uTmjoVPgyVOk3o9Pr/FaC3T7y366Or3KBz5OC/LqicVSiF4iWrmiCYVyL1Uq3a2mrEbE7Mc9ElfXnwPM0W2aS8lkz5g2bcjiaDpeGGNAfCbvTbH1meEz1xev0jLRItIft+u/I0t0kLwK9H4Oo4eDjZVDrBcb7ecv0QBfc5skvyMc5B86qkA2Ok9R9KrNE3TcRlNk+9ZYWBIrWEE2zGmwxUV9hXpBPVgsavysMWJznAeL0ZhwnTl6QmUssHbtJlFsjmX2KvyFDO38u3xyDmG6+OBVZikAVl+L54Y6HaKqfIkCzsAsHvBPa1bvg9eqKqaA6+Nrmw+KxONqRg2ynucTRfr5by61gwGZaDc11EFCeFF/MB84c1k5UU2SaavAr/IO0eo3h0VvztuuwLLSJRDFglS8oHL/NTI6E2/gnP4CB63cqh6DHkaj9ijUFmvAQ6CcChASLlosijxqMApM+fl0LttWsW3pyQO1TTbGq4U2TWh22/uRP0PaDR7R+TBUgsNQeZQ8y9VifMHMnyhkESczidoaoZ/7PZ8uSEjcCY05gOWnf6xpWKf81Z1Ru97AQ0xZowPhBpEP16A6xdWW3JzdyA4tP+/3mUiZeYZs1mq1CjPUEW3lU1TlpHceF9F9QxrnoJn/HVe9DN7fdMxdRjACDv7BqhIkiSkvJ2bFQlwyk0gVufX54A1XW7xdXdcncivcW3x4aV7oefLeBLTbGcv6Fw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(396003)(366004)(136003)(36756003)(6666004)(478600001)(2616005)(66556008)(956004)(1076003)(8936002)(107886003)(8676002)(4326008)(5660300002)(186003)(26005)(52116002)(66476007)(54906003)(66946007)(103116003)(316002)(7696005)(6916009)(86362001)(7416002)(83380400001)(6486002)(38350700002)(2906002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?wnAm+Nt5Y1Adg8vg5EaL7sw8p1gLCEaW08evj5J61CR21WIVvK5RnvNE0k9x?=
 =?us-ascii?Q?kwucoRaQeHtnDzkvgQAYt269m2MVXIHTr7ZPhTDmVRSst9h4DB0YyjALtEK4?=
 =?us-ascii?Q?KJm9EdNUXdCgfLbUM7AjKFRbT3FtfrbM8yv1xacdrpGLhNbwzhT1MlT7rruz?=
 =?us-ascii?Q?INGYAjrDtAKqXAzem2pzX+cj04EBKDkAo/9M2Ro489SnKp17uZ5meYj1OJZ0?=
 =?us-ascii?Q?r5Uva40X8h33AVLDeTriCdJcqMbWD43g9ygaue91y3Pz2h9xmu6pVBUvfIU2?=
 =?us-ascii?Q?TkJCGKDwFgMgB76gtEvMeV8z3jeDL39k5LbfsGRE2RXA2KqlUuiRMkofyxP7?=
 =?us-ascii?Q?EDDhaqfuWec45BmQYg7xiSDsApFoN7rfk5bj4qHZpa0ggtPdocFf4QUDaeFV?=
 =?us-ascii?Q?2oUsawmhsl9/CCKMbToGGMTl/8VrYPhXt9x1Ih3SEKKWchdxi0q0IDo8iWks?=
 =?us-ascii?Q?KG/TyPSeE0bkEPCwDvDngqtotDuaPsv5+hyBlvmhelCA3mPofmLHRklEk1Fa?=
 =?us-ascii?Q?1ylxhJkE7okrNqkJy26Qw981dZtkbyzuCFsjrTd4wi2Hu2Rx3pk64Vc6QAIq?=
 =?us-ascii?Q?hI2W69qpeZaBvDOqoeNWZbnh7RDJAqLQxglkicr/JaMA2qIaHNler3H3zbwS?=
 =?us-ascii?Q?lOOstBVW2YTCgmTOgDe+ffp6yimPNwfEZLYWFx9CQKtP8+nesitJNo6+Yag/?=
 =?us-ascii?Q?iJJmO0orHKSuVetQUiJHpmAkXvma9OMgCUt9J2rMjlYXYx2fUwvLwSik0vET?=
 =?us-ascii?Q?J4E44+fqwY/abZ57c9gbl/OH/oXb5039ERloO0Z7pcDZm7xCbNUiLFSjHN4L?=
 =?us-ascii?Q?0VY9Xn9676dK59vK4i2T48+NDaXqhAbGLzsx8Icp0k0maeQh7B2h7W7/CS0K?=
 =?us-ascii?Q?i6ohS1miTk/3RgPr+W5GsXwsJtXUNSOqsQQf6mFCb9DS3waLRci0c6kUPx12?=
 =?us-ascii?Q?YGz1RsYhEcHXVtaYgDQe4mCC7ELsdJ1JMqr5GspY04cEyFObpDbaGgDOYJrt?=
 =?us-ascii?Q?ExoyFTbRaO9VRKpwenOJY+J5H845a7mqRvbhLdJ2fMK9MrQhS8NaJS0JaJ8q?=
 =?us-ascii?Q?nVM+DfEGhCU3DpHPFMICrfzHvkPbGGc5lP4gKdGOCpDaTB7NUc2n/IdpWwrV?=
 =?us-ascii?Q?mP+jS43llIuZbyHDNc6RyZy6tTBIUSntLP8VLYvnsn4uo9qJ3n7txYRQpBOr?=
 =?us-ascii?Q?k08/duf5R/5QkAtESjFKvVScRAP7oAMhq6ISpuBg9VfLXOgrWMPjPR53C94H?=
 =?us-ascii?Q?58i3aN8N5R0/MNY/2cQkO/MJBD52h88ICNJAu1I678/Cs+4SxVuON9bkgT1u?=
 =?us-ascii?Q?veR36ZqJT+v/IyDRSeOT0YzI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 558d8404-a7d8-4653-ae9c-08d946fead59
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 19:36:29.5470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Cu86l3rJLakhIe4cPDFRYBEAi8dmO9+X404t1Rkw1r5u8bbPFximFh2OICvOZM7BEYAfqUocmD/amGDdpaw90/xsMR1fL3MpJTAMMiC0dY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2899
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107140115
X-Proofpoint-GUID: 5fceide8n79df_Kr4Z6nsvPLTE_LhNtx
X-Proofpoint-ORIG-GUID: 5fceide8n79df_Kr4Z6nsvPLTE_LhNtx

Use the newly added compound pagemap facility which maps the assigned dax
ranges as compound pages at a page size of @align. Currently, this means,
that region/namespace bootstrap would take considerably less, given that
you would initialize considerably less pages.

On setups with 128G NVDIMMs the initialization with DRAM stored struct
pages improves from ~268-358 ms to ~78-100 ms with 2M pages, and to less
than a 1msec with 1G pages.

dax devices are created with a fixed @align (huge page size) which is
enforced through as well at mmap() of the device. Faults, consequently
happen too at the specified @align specified at the creation, and those
don't change through out dax device lifetime. MCEs poisons a whole dax
huge page, as well as splits occurring at the configured page size.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/dax/device.c | 56 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 13 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 6e348b5f9d45..149627c922cc 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -192,6 +192,42 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
 }
 #endif /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 
+static void set_page_mapping(struct vm_fault *vmf, pfn_t pfn,
+			     unsigned long fault_size,
+			     struct address_space *f_mapping)
+{
+	unsigned long i;
+	pgoff_t pgoff;
+
+	pgoff = linear_page_index(vmf->vma, ALIGN(vmf->address, fault_size));
+
+	for (i = 0; i < fault_size / PAGE_SIZE; i++) {
+		struct page *page;
+
+		page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
+		if (page->mapping)
+			continue;
+		page->mapping = f_mapping;
+		page->index = pgoff + i;
+	}
+}
+
+static void set_compound_mapping(struct vm_fault *vmf, pfn_t pfn,
+				 unsigned long fault_size,
+				 struct address_space *f_mapping)
+{
+	struct page *head;
+
+	head = pfn_to_page(pfn_t_to_pfn(pfn));
+	head = compound_head(head);
+	if (head->mapping)
+		return;
+
+	head->mapping = f_mapping;
+	head->index = linear_page_index(vmf->vma,
+			ALIGN(vmf->address, fault_size));
+}
+
 static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 		enum page_entry_size pe_size)
 {
@@ -225,8 +261,7 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 	}
 
 	if (rc == VM_FAULT_NOPAGE) {
-		unsigned long i;
-		pgoff_t pgoff;
+		struct dev_pagemap *pgmap = dev_dax->pgmap;
 
 		/*
 		 * In the device-dax case the only possibility for a
@@ -234,17 +269,10 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 		 * mapped. No need to consider the zero page, or racing
 		 * conflicting mappings.
 		 */
-		pgoff = linear_page_index(vmf->vma,
-				ALIGN(vmf->address, fault_size));
-		for (i = 0; i < fault_size / PAGE_SIZE; i++) {
-			struct page *page;
-
-			page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
-			if (page->mapping)
-				continue;
-			page->mapping = filp->f_mapping;
-			page->index = pgoff + i;
-		}
+		if (pgmap_geometry(pgmap) > PAGE_SIZE)
+			set_compound_mapping(vmf, pfn, fault_size, filp->f_mapping);
+		else
+			set_page_mapping(vmf, pfn, fault_size, filp->f_mapping);
 	}
 	dax_read_unlock(id);
 
@@ -426,6 +454,8 @@ int dev_dax_probe(struct dev_dax *dev_dax)
 	}
 
 	pgmap->type = MEMORY_DEVICE_GENERIC;
+	if (dev_dax->align > PAGE_SIZE)
+		pgmap->geometry = dev_dax->align;
 	dev_dax->pgmap = pgmap;
 
 	addr = devm_memremap_pages(dev, pgmap);
-- 
2.17.1

