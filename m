Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7763B39
	for <nvdimm@lists.linux.dev>; Mon,  7 Mar 2022 12:25:39 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227BtcK5006652;
	Mon, 7 Mar 2022 12:25:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=v17sfs+U0QGJqsJY0qJ6/XcOeTsameaPQRSKg+GMctI=;
 b=ACQ6ivBsxMbFkuDJBjXFeD5U52hIhfOusQhakRWy6hNdxJm6b63PnFj0xCiBMQWyG0sa
 dd76ylf8bNeHp9iIN1ofcg9Ll4iFovjGK7A254npgLjvtbl9jnB00ast/ddYeSiRv+fL
 3m+XwQ+z2JIbXE3n2gAdgM7uL8oQCBU3LRyFcsWpg6rJ29ppr2oFIg7EVTPpVmza1W1t
 Qw50fmmR6/ZlTDldJgRQ5lVqcVcP/eI/MR5Yqgi4vCEcrisdxVrFqyR5KhWRqzs0f3BT
 c6m7herm1HQEeS4m++/ifHQ9s52LFRV898T6D1wwjD2gpjQx2wnzGxI5brcMk9Sw6xam vQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ekxn2bn3u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Mar 2022 12:25:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 227CCHbX029583;
	Mon, 7 Mar 2022 12:25:21 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
	by userp3030.oracle.com with ESMTP id 3ekvyter28-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Mar 2022 12:25:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bd98RgoRsi42eBAgevBQADmrYgIleVjzJozpMA6u2lSs8hc+uV+vqKHSu3S1DJmidl3qpKGB6GDm3ei7DXEE8XNAG8NPx2z2OC4mMHqVGsrfSBmJUKQNVyQfSd2EgVLcJXztmcZtNuJ7JjM2c6ql1M0I9R6x/XE443lntftcYdYS1MdcRf1/jGF7FcZvoH7sJioaS94k+ZD8otLYb/LsUTGR3Ybd0GSZL4c414jgQTqRyd51xXPPwrD5eNeK9gFlfrL/GQq+nIRQWx25RZNbwTt3wUJSt46el2V2/7t3Xvpi5d3UjTU+FAgPI/0PuBG/MgkNJVndlyq7IbBvfIszCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v17sfs+U0QGJqsJY0qJ6/XcOeTsameaPQRSKg+GMctI=;
 b=Yk17FVWV2rZFiODDHT2hV7JlgZSozS94LWKhjRsoBOlL9OatB0eJKm9XcjcL0+zzapKbEtVUVycFD5vPGfVGktDqfGcebVPIONXzwxb9/7Kluw+AYJNj52aeMlIEGE1uyhdmegu6SdsbL4gzCtl16XgW1wEJqd3zUP8E368whn03XQk7m4qP2Pn34xFZZfbo+MdJcNV9m2+8EDUKIWbmJGLTvqfgnRdStc8k6j2mhtBaU+qj7RiLT/yAaDM/1UuKKs6MlpGrBMayX45PhY64uEq3R4RrARpT1DooCk/5cdYtSaoUykEvK0jkW39goDQuc5rCPchTO1rHGVc9qhuZfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v17sfs+U0QGJqsJY0qJ6/XcOeTsameaPQRSKg+GMctI=;
 b=KmuNBf0ylLgwfMxI3MguJtGd0JP3fXb9l10Lpg+jS03TKzligEsgFmcRSticPNXWjNFrTgnhSlrkSCo0GI4zxcdVIKotmpCEaMCkKBHfVyLVEjBj2WGMBxzVEls8pf1B4h2xrrBVwi0XJZznda2j+ecTO7NF2o2/wTOwy3wzyJc=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM6PR10MB3451.namprd10.prod.outlook.com (2603:10b6:5:61::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Mon, 7 Mar
 2022 12:25:20 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%5]) with mapi id 15.20.5038.027; Mon, 7 Mar 2022
 12:25:20 +0000
From: Joao Martins <joao.m.martins@oracle.com>
To: linux-mm@kvack.org
Cc: Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev, linux-doc@vger.kernel.org,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v8 5/5] mm/page_alloc: reuse tail struct pages for compound devmaps
Date: Mon,  7 Mar 2022 12:24:57 +0000
Message-Id: <20220307122457.10066-6-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220307122457.10066-1-joao.m.martins@oracle.com>
References: <20220307122457.10066-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0019.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::21) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 892fc0ea-119b-4f06-38af-08da00358b69
X-MS-TrafficTypeDiagnostic: DM6PR10MB3451:EE_
X-Microsoft-Antispam-PRVS: 
	<DM6PR10MB34513FD988EA874284E31F16BB089@DM6PR10MB3451.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Ny5dGCuQUFoMeqjWma4sXkpPkgFOqcuUti/569I4C+YZ1cSnUPkpP5MTqWUhVBwTVamBMZyl2p+A+vTpDOHy9gioRWktFE8Ymc0VAgo7Wd0ebxlHpgM5k66FQNG4K84/H03Ps//c4d7Tdmxt4Lx6P44ykmLl+isTcoe3eelqHouTkdmuGucH7yNHc4pKjTI9NDye1LJUpm4vmuOWhxEXZndcrX6RoR77GB/PaC/pYF53g6CAQ9wKepnSpHTGEEMi2uF7OIL2/CxeMkVXMJYoGgAwt01UEW/iPdZNe5zWnNgPGxdAGmhE4APuYB4DuHB1AQtL1razFwid0KoACY8gSEi4ra919yaol1SinLq526NgNotMZBUPdwnDrMQwJdyLFYj1khlOA29vNTw5EStvFJH61KIp1V0UP5BI2OjzFYX3B33OoIpUwhP1GTIDJtk25CIBXr6hshlbtdSmBog3Cjftyof6vWA/wXTmri6KEcGQIAIiJLTDdYgT2KETDRprdbCYDBOqQ2yV6yVyTPDOVD/b0uWDkZeaf7YRrSPGuSuADlLaDfl4mjplPBoh4aoAAoia2W3M3J6Tlf/LLK8NTHUYQJupIfhUAndTPPaBB76KTBD9meSwMShRr1HWOxFuCjsetTLtyp2+MNgd7odzgbMJmt2u+8lXbrJAehKyW/iVKKjXIsRMOeAhGHhof6Cz53FLSzpEnSFtftwg6CbRgQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(26005)(508600001)(6666004)(1076003)(107886003)(2616005)(186003)(6512007)(52116002)(86362001)(6506007)(83380400001)(38100700002)(8936002)(103116003)(5660300002)(7416002)(66946007)(8676002)(66476007)(66556008)(4326008)(38350700002)(36756003)(2906002)(54906003)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?SsMQdHdQcWycS6Gro83oQxwGwilbgyyA4CU0/75+EFRTjXf2ttVz5tlX12qy?=
 =?us-ascii?Q?ao22sLUH/kELAZS4aE05hhy9nONrOeIt+O4h8eFAZk+tTr0RNdsd85Q33cLo?=
 =?us-ascii?Q?bY0orLaZGpy9NsWVaOaPAvxXtZ8VpcrHK4x+ieXzcmhvs8yP5twmuccvW7Qs?=
 =?us-ascii?Q?vpZj6Lgy1KVy5UOxMbnd1goRTWs7hCFZo//moBexwo9NEPV5+PTWjY8Jx8aQ?=
 =?us-ascii?Q?owKPu+PtO7Jy93rfZ8CnjOV64caBjBv3cYF76nPMmUIdnHu/bC+PlY1fgOzi?=
 =?us-ascii?Q?D0lJwlAx03eca8YJlGG9gdMoLcVGlfs++A96TejD3Ag10YKPMDKh4PBNVDxI?=
 =?us-ascii?Q?CFsy4ixE/zvIo3zUHO0pImWV03Z2sKmypJEkVungXc7QMZjgCl0oYgvaGoM7?=
 =?us-ascii?Q?vqTsm6Tns14Dffm6rxieVeYesXBI9enC4J8bBipOd156oiL47k1SchBhrp7J?=
 =?us-ascii?Q?4SbBgEQ/7inJcztDnN8tGxzdO+1L10iCMQomWEKoHDSZlHovsmDkTteOg0rh?=
 =?us-ascii?Q?x9SUswKCbmbxQHXybsO0G3DhLx/iB2r0+1nEzyDIzyRc4pQwCkOW0Q3FZ/hk?=
 =?us-ascii?Q?2H61ftgI5BRxEHOYrl7Eh0IEUaBOojouRLol45A/5Uzbf4zFvLc4yTjgkeg+?=
 =?us-ascii?Q?eJw/gZLir/uu2VcD++wyHiayGrF+2UEGo7B7l0R1MFUvhZNIo3AkOidafqY8?=
 =?us-ascii?Q?lTWq6V1nzqiYc5HQmOCHK0M84Rc0Nik6fRtLJY2+A4ueaAX1WoEbQ6qe0ACW?=
 =?us-ascii?Q?a6hm2L27BRU0TB6ND3SlurrCCO89i25EjQdnAUeiPV3Pj9rS9gufW7iBCO7A?=
 =?us-ascii?Q?5amyFe9D5C9I94OakThA5JDR4US1vQhkE8PCDZt/00VkqtKuO2YUruscEYJK?=
 =?us-ascii?Q?saZ1RJZ/NVEkaTL8JtkjcGxtZ563l5QZQdMu2dLzdnjCQD0ChLSLBQIHITGn?=
 =?us-ascii?Q?xb/DKhLMa2UlZKMMdXZZznCFdrqiZZLlrzN210qKZSmSNJEWC6NpROoEeRS7?=
 =?us-ascii?Q?aEbdCKBblC2+uBwT5PIHp7A/kOXMWLbBC36123B3U+SHqFe2LZoah79A+U7u?=
 =?us-ascii?Q?kcWNJ8gKCBjNNMpen5mMRuO1kv6im0e+GafAadGdafKqeCkikqYsdmoZHqae?=
 =?us-ascii?Q?tzZ9BRd+AQ4/VOoY9guupCupj4lgW5+s9F07Fpc7nqzh3G6mlDFQcwI0ueV0?=
 =?us-ascii?Q?qYjfGAl6xrJJ/ggzZfS7dfdyqmms5Fe/bJPgvpyI7OSocUuXss0zTk/snK9g?=
 =?us-ascii?Q?KWGcMIyBFxwge0FKcMT7Jb7zrzul3wu7B7mv+owsHawgiSIx8SjGTvu3PSuN?=
 =?us-ascii?Q?aUbQPQ+D0oXBMHwdyiVFoQ23dKU6KWwtQ9jrNMVsnQvHpp1oWOn6u8B6ihBO?=
 =?us-ascii?Q?sJDWgzWgnPU3nGEk5LbcyO+mgw4QTs/PyqMURpXgJSNfOm9oWgqio+0jN8tq?=
 =?us-ascii?Q?dS/5AcjhFcoTDq1x5KwN60RrcAMc8LgodG/pYwzPIRgesC7FecN3hijmus9U?=
 =?us-ascii?Q?F+AZxDHwB6nZ6N7wEBbg45z9FetShsHJVC4Z2125zqeJLNTIQ54Pw31Fifmi?=
 =?us-ascii?Q?/xyYAnMGS3Izbtmxk0cjVKyem9i/TTASY8dAb9vWx58e36d3rJ519yqHwK31?=
 =?us-ascii?Q?TUAlq51pBbmNm2jWZw0Oid30XX3jdFSIIJuu8vge3siiLZy6ffNy0SRA+a51?=
 =?us-ascii?Q?M9ZNBw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 892fc0ea-119b-4f06-38af-08da00358b69
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 12:25:19.9948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S5VSmuqHnAyGLzoz8hKW2JuK0w/3M7J0XmgCLa5gO8YbokmSxV7Gxfsec6Q5ufmEsT4qM9ukk3ioWdjrVt+X7CCbv16qMcogjxsANRcw+WI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3451
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10278 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070071
X-Proofpoint-ORIG-GUID: vCtYCLxras5pDftoLFFo3oMq3T-GApMk
X-Proofpoint-GUID: vCtYCLxras5pDftoLFFo3oMq3T-GApMk

Currently memmap_init_zone_device() ends up initializing 32768 pages
when it only needs to initialize 128 given tail page reuse. That
number is worse with 1GB compound pages, 262144 instead of 128. Update
memmap_init_zone_device() to skip redundant initialization, detailed
below.

When a pgmap @vmemmap_shift is set, all pages are mapped at a given
huge page alignment and use compound pages to describe them as opposed
to a struct per 4K.

With @vmemmap_shift > 0 and when struct pages are stored in ram
(!altmap) most tail pages are reused. Consequently, the amount of
unique struct pages is a lot smaller than the total amount of struct
pages being mapped.

The altmap path is left alone since it does not support memory savings
based on compound pages devmap.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/page_alloc.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e0c1e6bb09dd..d969b27f7b56 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6653,6 +6653,21 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	}
 }
 
+/*
+ * With compound page geometry and when struct pages are stored in ram most
+ * tail pages are reused. Consequently, the amount of unique struct pages to
+ * initialize is a lot smaller that the total amount of struct pages being
+ * mapped. This is a paired / mild layering violation with explicit knowledge
+ * of how the sparse_vmemmap internals handle compound pages in the lack
+ * of an altmap. See vmemmap_populate_compound_pages().
+ */
+static inline unsigned long compound_nr_pages(struct vmem_altmap *altmap,
+					      unsigned long nr_pages)
+{
+	return is_power_of_2(sizeof(struct page)) &&
+		!altmap ? 2 * (PAGE_SIZE / sizeof(struct page)) : nr_pages;
+}
+
 static void __ref memmap_init_compound(struct page *head,
 				       unsigned long head_pfn,
 				       unsigned long zone_idx, int nid,
@@ -6717,7 +6732,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     pfns_per_compound);
+				     compound_nr_pages(altmap, pfns_per_compound));
 	}
 
 	pr_info("%s initialised %lu pages in %ums\n", __func__,
-- 
2.17.2

