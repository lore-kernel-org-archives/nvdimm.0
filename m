Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF8D3FD0
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 14:59:33 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17REC3PY025345;
	Fri, 27 Aug 2021 14:59:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=XpSpJm3nZ4qEUIa2z4eeiBY340ZMwnjwoC8TZYWrPsQ=;
 b=QhQ0dzfMiJruSv7quNu6+k5AUD7BC1TzNGw7P2CFEjw+ByyU1VACDe1ZJeHCC1nJXe5G
 IZCp4hclSo2SsKxUgIHHkLpsglJzAtBYDi1EUBTGe8/P4VmukdYgL8tHKf1vqicEcGN4
 v536iUYBFxY7wbn8vBebnlczVNwL7DGXEwI6VjGqDwKyhkAwrr9zRggo+V30cD2d9IG9
 QQqRjXO9BB1wxHDgQVaXLqFV40d+gAYqOEE5gF1NLq/v3mIcc+FCLyBm8LGNafLZ3gg+
 xbvxmx1SnIv67GHoQXwjMSUnMaGxxgw4n9tJR15v3CEtRKQa1vDKiRAoEs3TLjZBYPWy MA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=XpSpJm3nZ4qEUIa2z4eeiBY340ZMwnjwoC8TZYWrPsQ=;
 b=LPW+xMyHMiG7hkic9ncpRtVnlwgoK9f1sOlr+LlSl7cF29BTtghd49fghkAHZfGcKeWq
 f/TNG3v7Rzi1AxMSC1Mc4Qs+A3ywZfleFYK7ksiECcFTMQPqTx/3HHooQVvRkMYintRe
 SODlCmC8jYq4W+xKiRcfQlDDSTz3WMb+nzKv09I76XdN3JE1IkBQ/26++LgnFt501WWf
 rlWPSZ1l8KAZIexTZJtqM089G1l79ceJxZicltZEUtNUpmEwJAy0LOyJWtcDkG2c/wxV
 KNPDbtKRE+IOa2r9Ej/n88COTRhluKfcB0487ghnLMWk7dQrqadMt1vJ9hnG9BeybWgZ KA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3aq1kvg4bp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:59:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17REpoFK034259;
	Fri, 27 Aug 2021 14:59:24 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
	by userp3030.oracle.com with ESMTP id 3ajpm4u93h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:59:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q5jdC6rODq2xPumNtsSyNyW4YPlE2qp1DMOpi1fsxSt+Xw6X9C6bYRMtvXqBaqGDi38i7yQMw8sKhO5kT0sPClq6il3aq84weF5l6dZ6whaakAM7Qiq5cMwrvYlSFiSwVkzsGQGwtX+uAUW8HiJv8UGtat1RdX40ZaO0fx8bVAWThWe2HF6U8IB7W5GU77uTbRp+b3LCBAWZoMYDCPiXUuJLQpzxphkPV9kbL2c4lg0j2svW/h6931iuJ8z9/GssVJteiK76GpIvBZsW7zAubwrl2gjT0k1gNbdEOYnTABbVlQxGzGrtkOb+xaGk7FR67CiJUEi4/ZK9a/DDNM+Rvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpSpJm3nZ4qEUIa2z4eeiBY340ZMwnjwoC8TZYWrPsQ=;
 b=Sls9STu3kHLeb9Pf7Rj3HPFK0NXTXoZypR5CK7+yiVz//X77W5WK2mMVdm16kYF6SuHLa5Cx51DWi5c/h/Y3Gayx+eDPTsBEYsUxmezsjs/MD9EsH7W8mj37YWOgFjejOrqc5iOmbo0HcsqiO+nNZgLGZBQfPSGWVrWF7/iR4WdO1cbtJicMkXQfIloVRRSX2rDrKlZMUaU9C34rLf/fl1NAjmD+Ie7NDCFoEAm9MR66zCzTiI5bYVqq6AIe6FuVhDZuFJvs6c+DR0EA+6+al/koe0n7FlEvi28APnMMQwt4wtnQhcGvfmcxPevXNbti8e/A9qi+1dS9KEgVNGWC6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpSpJm3nZ4qEUIa2z4eeiBY340ZMwnjwoC8TZYWrPsQ=;
 b=RK6lQMH4nmqxzJqXeuAxtkFcnd6Qyz161DBLSF0ZfTZKiubWRDeJpmFI7T03CIPLftxqL3op1TtTNboPknobXOHQF+A4ar8LgQY4XTzSlrIlp68erv8UrM72ZWh5X5HaFLRv15uJElSfHpfcwFtuOxiwva1xtheiV8QZHY44Zos=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4881.namprd10.prod.outlook.com (2603:10b6:208:327::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.24; Fri, 27 Aug
 2021 14:59:22 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198%5]) with mapi id 15.20.4457.020; Fri, 27 Aug 2021
 14:59:22 +0000
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
Subject: [PATCH v4 13/14] mm/page_alloc: reuse tail struct pages for compound devmaps
Date: Fri, 27 Aug 2021 15:58:18 +0100
Message-Id: <20210827145819.16471-14-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210827145819.16471-1-joao.m.martins@oracle.com>
References: <20210827145819.16471-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0443.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from paddy.uk.oracle.com (138.3.204.8) by LO4P123CA0443.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a9::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4457.20 via Frontend Transport; Fri, 27 Aug 2021 14:59:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3c6c459-e426-4341-7ba9-08d9696b40f3
X-MS-TrafficTypeDiagnostic: BLAPR10MB4881:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB488179E60A97A8DF65B3BD8EBBC89@BLAPR10MB4881.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	psU1ci5OGR/PO19YcNTKhiRCT1ExYGc4ZAIK114n4/8iGd6pePPrmImEOQDZ3dCnimMDzcmoTmu6H2a0ohX7w4A3hs/t8Pd/hINJID75rV8uXSOp3qhdPsfUlDqDZ1YqCMTSjhwmjHxq60Ox2Gm0FUdsNXd6xJY0LMnlYdLsC/UbpfOv+/wZZdiMXj2IEt2yj5lY4Na5t7cr4VE2VyULMuaEBE7nRvzSNN3Fi1FyewRf2FzZK59HoaAwCnmlz2AFCbvxf8V2i1G5JFilpGHaln9iKy0BleVQF027NOvD2lS5xXEjiDDpoMACqBsp6Sz5MDw0SmnqQdziwYX4ZN1KnZDl5zrBPEcvGtAcMryavap88+e7o6KAttvCTvRF7XUByCjvGBnXp53mmTl08rtBObo2EYH7V9s7BmkKbnM8dhsVaN6LLABekq3Gmte1epekjK57Ba8F4C5tuPvXC09w1LAKQtQI+czf57nfchd0kkzarAvB/7jzFS3uYgeexboAo0R19P6gOyFHBXxphDPSZXntIZ+GlqvyhzqJy/E33MgmU3Tltrk0mgOQAugvQhgsDMsSVlzylXeBTowTiYL2QvpYAIGeT6RcCbbdI1Omkuu6enkMVZYVBQs3Nt+v6PYYGedLybpHAfZXocgw11oplp8j3l3tA+9Ntdwp8fc5gpaRxr06ZYp+kUbXk/0dUQSTOXXeYt9N4vk/bCf/fnOokQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(136003)(346002)(39860400002)(7696005)(2906002)(83380400001)(38350700002)(38100700002)(52116002)(66946007)(8936002)(478600001)(7416002)(107886003)(86362001)(36756003)(6486002)(316002)(1076003)(8676002)(103116003)(26005)(54906003)(956004)(4326008)(2616005)(5660300002)(66476007)(66556008)(6916009)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?T60hV4y8JopaAAQMTOZoIPh0Q7zI/PhjNuoKUFYv0wwnXsLz5aLlJpUV9REL?=
 =?us-ascii?Q?6PBz7bczu1BoN9D9dPaArZ/MhZl4BSFf0Twar8FHhkS36MZDWbZICUcv5Z3M?=
 =?us-ascii?Q?53AUcP0CiZ+nXuJiBXSS3pzC3KJExaY0F0rMWrE5GpAnGCgDjoZYY+N4dXvu?=
 =?us-ascii?Q?Q7eG5AL8WFgKd4i4+xzqevaD4RlJhmY32+nXdu1/ITJKHEeCFr2DBqDRu6kB?=
 =?us-ascii?Q?YjZqW1dWz2dzSOPHKbG/m+W6gBsAUab0/RsYPscKYOEA0y+vDo67YsN64CZo?=
 =?us-ascii?Q?Yl3JSIjBpcqa54KvhWma2IsRbadxwDP9D/qbPoDtYs+okyDNC59Q4lCib+Fu?=
 =?us-ascii?Q?JY1QpZjy1oukEat7h74F77txjBC72Pl8dXQUx9J2E15v1BE6BwhxO/GauF0Q?=
 =?us-ascii?Q?uzhyST9zoT1isCjrbLaSf714fSYpEV4TaBGEyfB1QtdYKqF8ZOFjNXJxaiaj?=
 =?us-ascii?Q?vem+JZQ4/2qiRDZxulKZjFfN2kSeRC7sCVa1F6sw/7O/v2uuMe97T0xYPYDl?=
 =?us-ascii?Q?ZQ87qZmJZlDlncnR66XGT+D6w/loJhnv/dA6l15+Niq7qt1Fv2qNTqq6yEX0?=
 =?us-ascii?Q?ceFpJe4DJ+DpjRSj2aYhZnXIxbDhogdmT6VZ0GogWAiXWoUyccQVttZCVokx?=
 =?us-ascii?Q?MmKK7xitOmYakbyfRxTCff5Ps54Cv8yhhLdy0Aw7jiEWpAkxOLAEyEoY7m/y?=
 =?us-ascii?Q?zRRJg/HxzFLtrpV9Z2XUMadXNYQX42CSoeo3VoeBJ17BwBhNyFMKvgBW1gFh?=
 =?us-ascii?Q?YKbeLqCFTqmEc//FEaP9mVPd+gCJzLRmtFrgkntDcwrkZ0w1FxY8mP0MAJAN?=
 =?us-ascii?Q?Ru0ul7S88Sii/x5dJ+lO28fXG3A8oL4XJbcCvh+Qjg5Jf66WEyomynHEScO/?=
 =?us-ascii?Q?J34iEQnVa0UIHLm6K7SrT/sSKgjZHyogAv9RYI8gp9fyh385DvnP98KltleQ?=
 =?us-ascii?Q?YMBjzWSQEB93kkQklVHqDK8kjosMrWdG34ZixJubzGrl0RNZnGGW3LAIaCED?=
 =?us-ascii?Q?3ioPcaqO0645zWA9eX/1b+ZcPCnu33bcdWa/k98TEJCTBbd8cKTSPtt+gEvF?=
 =?us-ascii?Q?AoOPPT20WDEAKi+QkY+fgtb/MLfNSSwQ7nCdpV8/jg3mGr/5/ybPrz2k9tBn?=
 =?us-ascii?Q?ajTRjJAfqprWlh9ToIgFx9GPNeVGsfwDPDgbEgQwjRgrvITGnInEuLyMQAWy?=
 =?us-ascii?Q?88r8MH0D/4DL9ZGljE1TmZQKlCMmphEFeVr1bVNqd9btsUc8o0STFEIuafcL?=
 =?us-ascii?Q?WQ+qCpxyr4hB40RcVdEVv4f9TcVztM4hQJvkKB7GJUij/0Bwu6GUXeq0RaZu?=
 =?us-ascii?Q?qCyTXH9x+gGCno7VffLkM93s?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3c6c459-e426-4341-7ba9-08d9696b40f3
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 14:59:22.3334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pk7+OqImxE1v/vaSf2iSjZ+5gvLLJA0upkx+TdiEnhBIOlfQir0qKI0BG/ciSBV0KT/M+n4mpT50/Dt/kIC0PrHeTNnOoc1wsjYU8z6D2wE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4881
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270092
X-Proofpoint-GUID: ZzlN6-x3mIww8QBdldqQCLmrC-hX6o8W
X-Proofpoint-ORIG-GUID: ZzlN6-x3mIww8QBdldqQCLmrC-hX6o8W

Currently memmap_init_zone_device() ends up initializing 32768 pages
when it only needs to initialize 128 given tail page reuse. That
number is worse with 1GB compound page geometries, 262144 instead of
128. Update memmap_init_zone_device() to skip redundant
initialization, detailed below.

When a pgmap @geometry is set, all pages are mapped at a given huge page
alignment and use compound pages to describe them as opposed to a
struct per 4K.

With @geometry > PAGE_SIZE and when struct pages are stored in ram
(!altmap) most tail pages are reused. Consequently, the amount of unique
struct pages is a lot smaller that the total amount of struct pages
being mapped.

The altmap path is left alone since it does not support memory savings
based on compound devmap geometries.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 mm/page_alloc.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c1497a928005..13464b4188b4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6610,6 +6610,20 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
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
+	return !altmap ? 2 * (PAGE_SIZE/sizeof(struct page)) : nr_pages;
+}
+
 static void __ref memmap_init_compound(struct page *head, unsigned long head_pfn,
 				       unsigned long zone_idx, int nid,
 				       struct dev_pagemap *pgmap,
@@ -6673,7 +6687,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     pfns_per_compound);
+				     compound_nr_pages(altmap, pfns_per_compound));
 	}
 
 	pr_info("%s initialised %lu pages in %ums\n", __func__,
-- 
2.17.1

