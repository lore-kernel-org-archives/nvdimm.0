Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF3D3FD0
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 14:59:37 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RDWHDJ002206;
	Fri, 27 Aug 2021 14:59:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=IxjwUQbC39PYrInE4g3Z9kpgnSdsw3Plbkz7I6s3XTo=;
 b=ob4cqpw0jMad1oicN2YFs84ng1W0m/BM26qvcZGBarMjJXYfnGXwl6Nlejr52V02188u
 YDU0mTOF8PMDOsmBV6V46T6W3e+Kib5sW5xFnhW/UvCwyNsoB1hUBRRshQ41POWwaAkn
 M/C/0GrS3bfYGXn+54IGriPaDIKyXffzmRe2+BGyG5Il5xRjC+T/tf8E0nfbBPqCtOCL
 d76X2l/vVBBVAkBM98FxRYWiHAWoyIqF2cOcp3mRbp4p4dsejrBGK7Mhks4vahBaep2U
 sba7rwpAz9kDT+1hlpobXoxi0LYK6WFYt3muAzuYbLXPP4fPjtSN/Fsu1YNnm+bAnLuT 3g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=IxjwUQbC39PYrInE4g3Z9kpgnSdsw3Plbkz7I6s3XTo=;
 b=MHJxPNN0DH06l9qnbkGYe/jCy5e7/qKaLmuzo8j9ZmHFYIeHnLZdnF5wnfdjqoHFfIw8
 utnF1o9dgc05Q8XEV5PV6LHswOAcniFBz1RmMIaNQsdm4quAa9UuvuSpkFMaQ+OalOei
 dcsgjKB52NZK6jMPVbVyKShMCWGqxaU4mOnSLjFRLg0kG7S/bNttkSzlIbiDkklHumG7
 fvzath6vlLh/JYOlFqDlh+KXB+qEVywqdCCJqaO1X/2Q0enhX0TMNpDgYUfr3HdYb4Hc
 FpTx53pKDlaU12b+ia9baFMsS+NOmblDCpeWPVWalt2/KsYqoy1xUXohnj1MFoITS0sO MQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3apvjr0vje-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:59:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17REpOCI187113;
	Fri, 27 Aug 2021 14:59:28 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
	by aserp3020.oracle.com with ESMTP id 3ajsabbqvx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:59:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IyQjD868+t+Rs23AnWhJZjHCN5jxSpEexpAL478IVDE0D6Bq4q4e11x31Bn00CSIZp4OoGz2Gv5eLy1SOPgl6ndo1t735dQT7n54N7cM5Jqi0ma2RZqLOpfzZEvEGjjGM1T3ZT/3gAMc5t9Fnkr/fdIAI5nHjKR/k5dfnUqTsOaE+Ep9EaWq4t3dPJots9jexzSM4c63r/im3ergQXPi+OXTCeL6HRcESwbkknqv7d41EyQySC7lxn8qdCKlWDpDLEITqCvckbkyW30J+yWL7/Jt3DrBNwobUZtTNk0fPAnEGCOSY++T4XYTEnwWOuCNN6wH2fiQNg4/CWvNoT1spw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IxjwUQbC39PYrInE4g3Z9kpgnSdsw3Plbkz7I6s3XTo=;
 b=I82xcVkKqP3SXbaoNublxltALOJNrqBCmJ4tFK8KYPu6J75xlc30AxZaXAmRJUDBjKC6y26SWbDuPxsR2LskLxk3BP2J0oV18kRWLjjQOksDu/9bSmUrQaQx4vA6FWTwpD7i5wJYOSTN/ZQtCWtUTQcuxiU412MyZzwbrEh0GLOHeJ1N93Si32hzrwMZrzY9FwyzQwVmK/Yk9WlXInas1JW/3BLUnvv8e/2yYeGVuFoPyLgoZtZJX9+MFPmdoEjzfgF9ERu+WyeiO3eJqGFusTWOo80AkvmzCOWKhxmn9VOaSFUwRRXM7ZR8X2RjKny8zyb+qacEzcGploHEeOOVQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IxjwUQbC39PYrInE4g3Z9kpgnSdsw3Plbkz7I6s3XTo=;
 b=BKIPz4CW2KYBHB6xECaFtJFotmQ1xqOL8KJT4qCBk4Lh+bipuBu7J7FuMLap005/gfVM609p4Ujiv9Leeriu3HY7CfHuwvV1c2pvfwKczN/836AFgtfYYLTc/eNCTjkI1CbU3Ju2/mDrPpptrpp6P9dCD2A64g6fOBAGzJo50rE=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4946.namprd10.prod.outlook.com (2603:10b6:208:323::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Fri, 27 Aug
 2021 14:59:25 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198%5]) with mapi id 15.20.4457.020; Fri, 27 Aug 2021
 14:59:25 +0000
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
Subject: [PATCH v4 14/14] mm/sparse-vmemmap: improve memory savings for compound pud geometry
Date: Fri, 27 Aug 2021 15:58:19 +0100
Message-Id: <20210827145819.16471-15-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.8) by LO4P123CA0443.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a9::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4457.20 via Frontend Transport; Fri, 27 Aug 2021 14:59:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca1f022c-e285-4f82-2d6b-08d9696b42f1
X-MS-TrafficTypeDiagnostic: BLAPR10MB4946:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB4946BCE993F9A90D9F06D8BEBBC89@BLAPR10MB4946.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	qt4cDl8azoue81zpiW0pG8LM+77oUyS6fy2EVzjon6EbLT7U0jSFDiTa4/tMyIHz7IuTnH+A0o0v0vbAayak9wDnoKaUNl9bxLj2mlUqoCcFIi8zsNTLWzqzjPzersQwtaEtFQKItMaIKEZ+zBzdf9o2bjewFmJxBISUgjDY8NxC8sHftYBWcGlZMPZ/cmWU90IuYSrFp/M9sVBl1muo1aFEdQDaToXDdgOWbEA+w20520kGZXXjjSJWdG4d/r3ziWaUzn7xSqcLxT37gBxQ5s1XXNNGLWTFLGiK4CcHWm3OJN2zIiTN0yhPKaBYq+koQi3B2EfPcY1IQPlX+wZ2INqeY5bygOW6yEEpleUfovw3C3fcEUYggrGfG8go8Rq2Dnbl9AZcPby64k7iR1/aQnuVW0iRxoQSyFBDqMgf8WqwesT3vzYMPpm0/nJ0/4g1rzy+T3RQAjAgd7MxrqwZ1LyhNCzkpQFxLPM5xzT2rQeMbGv+vbVXmR4QAn3d8xdwQcdb8FMrzTxbEYSdYJwJHxAM0Uh+W/B+Y/ML9cpNijE6yeOy1dxfVM5uqGAbRy5OuOdTQIG/XpyLCJd4a46Nr2dTy9pVBd+OfDYJqi3/c6Y5wgc40ujElzUqKoe2lvJMFqhe8FV78xry0CdSWLFkkiKNLhuRxItbFzga+y8NFkjOhKaRh+3m0CXoEre36gze8RT+8Wt2cP2pBquPUn4tyynTMKYNL9PjXqXYh5+9f0k=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(346002)(396003)(366004)(316002)(86362001)(1076003)(2906002)(7416002)(30864003)(107886003)(8936002)(66476007)(66556008)(186003)(66946007)(478600001)(38350700002)(36756003)(4326008)(7696005)(2616005)(8676002)(5660300002)(52116002)(956004)(103116003)(6486002)(6666004)(38100700002)(6916009)(26005)(54906003)(83380400001)(25903002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?VVV6e70C5iRq38ybStB8gAivSf1NgzMtyG6gDAtUpFzF8AyD+2Z3V0gsqXbr?=
 =?us-ascii?Q?BruEj7Xb4Ce72VNY1pGcOszkQZzGBSyScTJs0ygMq5ZN47kPSkjvgLR4sp/d?=
 =?us-ascii?Q?AQfA2UtfRmFGmM+RNUjYvY6MsPbTSDMhC+8abluVD7LXFlbkdlNdp7cK/BYa?=
 =?us-ascii?Q?NkODWZ17GPhuyYHPvegfkdMNqfDu3QRQGZdwQZh1PP3yNcSVL9ZFz790yYzh?=
 =?us-ascii?Q?3IAfv/svVNvDh4Ay9WGtGU8LfNwLgRgR2cbU6K9vLHd3MOoedxNJuL3WMd9c?=
 =?us-ascii?Q?hjbR6UtuY0Zq9EtwXgT4yiSjkSsDmDJgYpQvcwWXhe7U52wGuBOyFydX3Ybs?=
 =?us-ascii?Q?wcz8M1TfaNgWbEjKGm9bk8e3ivah1tiOHALOYuCLg0WPTlly4JygOETjMh91?=
 =?us-ascii?Q?2bEtAD4Prxh2erwq/WcDCByQCkOy9LX1sH6FP+OcR7A1xql19eY1g+ogJVRw?=
 =?us-ascii?Q?Ct4fCbqIIjk3V/pXtKE9HvcHcStEPc+qD1rVQwBbhLi3/Wp0qOJNC6dBbgSr?=
 =?us-ascii?Q?Kdspj07kpvg2LbVSDFXgkr7FDQnZfO75Pqz5vd830E3O4lOCrfGdgfZ2hFZ5?=
 =?us-ascii?Q?v5eWQiu8NZMCUrq/RYxlGhhRTKRF23cDUhhkk9ZpBWpexxqtnYHi5TH+UQgn?=
 =?us-ascii?Q?lwyKKZsPoJSXrQKj+roGC0GrquXRdXYrYjwd7qPkBOj9/fYzgWz3Nrbe5aN7?=
 =?us-ascii?Q?6QNrGLxip2BrDRbZ7mX4qrXRvCmiiR/i6Bj2BrIuFiORc4yQUGxXIKSDvxMw?=
 =?us-ascii?Q?uywwUXCIlxyULwCeySSXI+xeQUbpDqMLxsLD4gcf4wqfctuSqj9O2vaS4xTQ?=
 =?us-ascii?Q?Pqb4Wl1fVT1W+pKFGjFdWxIV7DNk44E8ufhT+QVgNDx5YHblEFHHnPcZ3/qF?=
 =?us-ascii?Q?AKun6jtLjRdwNCQxrazS6TGQdivCfAWyL/cARry2jirYQ9zwdzdPs74jazcn?=
 =?us-ascii?Q?HX92pbh7CzqIJBjbOCPqXBfHiPX4EO8B2vatbk3dizh8pM4MGbSflJKg+qs4?=
 =?us-ascii?Q?5DAWOXoV40cn5DxXDJdUeUfjNggNFyW22JH1GvW/oOxYPv7PrbJbf1W/qhMe?=
 =?us-ascii?Q?/bdj4lNh+zJ3ZWmHGMNwXsaG+2w/UsFt5xJ59GfKiR9vve6+OZnf1cBCiLiw?=
 =?us-ascii?Q?IIvyJJ1rHVmoh1naj5ZiNsvjCFhKgZCuDMcTeVknXNGFUEDA6/usPMR2e86B?=
 =?us-ascii?Q?Rc4A3w48IlVLF0k4fUSvoxkBETRwnzGOOYg3NYyH3W2ThYIuD29Tefygt1hP?=
 =?us-ascii?Q?xfk5jFEwqGhzaSdqiQHzcQozN2teQGmZYqp25IrIPVTUAxwIsORZO9M1V2eS?=
 =?us-ascii?Q?YoxW823WFBwa85zFMq0M30BQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca1f022c-e285-4f82-2d6b-08d9696b42f1
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 14:59:25.7733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s1m98ExqapkQ+of+bAwIZihJqNJil+MU9QzTouO2siszUbi+ou4sdQNSggUIJsqhIUjEbdrkpRDhMUJ8ODYx3RpuN3vI2VAQWDFh13EDa2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4946
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108270092
X-Proofpoint-GUID: D7_rhbCZ7hS-_r3n1jyu9sBJnblsDAEq
X-Proofpoint-ORIG-GUID: D7_rhbCZ7hS-_r3n1jyu9sBJnblsDAEq

Currently, for compound PUD mappings, the implementation consumes 40MB
per TB but it can be optimized to 16MB per TB with the approach
detailed below.

Right now basepages are used to populate the PUD tail pages, and it
picks the address of the previous page of the subsection that precedes
the memmap being initialized.  This is done when a given memmap
address isn't aligned to the pgmap @geometry (which is safe to do because
@ranges are guaranteed to be aligned to @geometry).

For devmaps with an align which spans various sections, this means
that PMD pages are unnecessarily allocated for reusing the same tail
pages.  Effectively, on x86 a PUD can span 8 sections (depending on
config), and a page is being  allocated a page for the PMD to reuse
the tail vmemmap across the rest of the PTEs. In short effecitvely the
PMD cover the tail vmemmap areas all contain the same PFN. So instead
of doing this way, populate a new PMD on the second section of the
compound page (tail vmemmap PMD), and then the following sections
utilize the preceding PMD previously populated which only contain
tail pages).

After this scheme for an 1GB devmap aligned area, the first PMD
(section) would contain head page and 32767 tail pages, where the
second PMD contains the full 32768 tail pages.  The latter page gets
its PMD reused across future section mapping of the same devmap.

Besides fewer pagetable entries allocated, keeping parity with
hugepages in the directmap (as done by vmemmap_populate_hugepages()),
this further increases savings per compound page. Rather than
requiring 8 PMD page allocations only need 2 (plus two base pages
allocated for head and tail areas for the first PMD). 2M pages still
require using base pages, though.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 Documentation/vm/vmemmap_dedup.rst | 109 +++++++++++++++++++++++++++++
 include/linux/mm.h                 |   3 +-
 mm/sparse-vmemmap.c                | 108 +++++++++++++++++++++++-----
 3 files changed, 203 insertions(+), 17 deletions(-)

diff --git a/Documentation/vm/vmemmap_dedup.rst b/Documentation/vm/vmemmap_dedup.rst
index faac78bef01c..65aabfa2ca0b 100644
--- a/Documentation/vm/vmemmap_dedup.rst
+++ b/Documentation/vm/vmemmap_dedup.rst
@@ -189,3 +189,112 @@ at a later stage when we populate the sections.
 It only use 3 page structs for storing all information as opposed
 to 4 on HugeTLB pages. This does not affect memory savings between both.
 
+Additionally, it further extends the tail page deduplication with 1GB
+device-dax compound pages.
+
+E.g.: A 1G device-dax page on x86_64 consists in 4096 page frames, split
+across 8 PMD page frames, with the first PMD having 2 PTE page frames.
+In total this represents a total of 40960 bytes per 1GB page.
+
+Here is how things look after the previously described tail page deduplication
+technique.
+
+   device-dax      page frames   struct pages(4096 pages)     page frame(2 pages)
+ +-----------+ -> +----------+ --> +-----------+   mapping to   +-------------+
+ |           |    |    0     |     |     0     | -------------> |      0      |
+ |           |    +----------+     +-----------+                +-------------+
+ |           |                     |     1     | -------------> |      1      |
+ |           |                     +-----------+                +-------------+
+ |           |                     |     2     | ----------------^ ^ ^ ^ ^ ^ ^
+ |           |                     +-----------+                   | | | | | |
+ |           |                     |     3     | ------------------+ | | | | |
+ |           |                     +-----------+                     | | | | |
+ |           |                     |     4     | --------------------+ | | | |
+ |   PMD 0   |                     +-----------+                       | | | |
+ |           |                     |     5     | ----------------------+ | | |
+ |           |                     +-----------+                         | | |
+ |           |                     |     ..    | ------------------------+ | |
+ |           |                     +-----------+                           | |
+ |           |                     |     511   | --------------------------+ |
+ |           |                     +-----------+                             |
+ |           |                                                               |
+ |           |                                                               |
+ |           |                                                               |
+ +-----------+     page frames                                               |
+ +-----------+ -> +----------+ --> +-----------+    mapping to               |
+ |           |    |  1 .. 7  |     |    512    | ----------------------------+
+ |           |    +----------+     +-----------+                             |
+ |           |                     |    ..     | ----------------------------+
+ |           |                     +-----------+                             |
+ |           |                     |    ..     | ----------------------------+
+ |           |                     +-----------+                             |
+ |           |                     |    ..     | ----------------------------+
+ |           |                     +-----------+                             |
+ |           |                     |    ..     | ----------------------------+
+ |    PMD    |                     +-----------+                             |
+ |  1 .. 7   |                     |    ..     | ----------------------------+
+ |           |                     +-----------+                             |
+ |           |                     |    ..     | ----------------------------+
+ |           |                     +-----------+                             |
+ |           |                     |    4095   | ----------------------------+
+ +-----------+                     +-----------+
+
+Page frames of PMD 1 through 7 are allocated and mapped to the same PTE page frame
+that contains stores tail pages. As we can see in the diagram, PMDs 1 through 7
+all look like the same. Therefore we can map PMD 2 through 7 to PMD 1 page frame.
+This allows to free 6 vmemmap pages per 1GB page, decreasing the overhead per
+1GB page from 40960 bytes to 16384 bytes.
+
+Here is how things look after PMD tail page deduplication.
+
+   device-dax      page frames   struct pages(4096 pages)     page frame(2 pages)
+ +-----------+ -> +----------+ --> +-----------+   mapping to   +-------------+
+ |           |    |    0     |     |     0     | -------------> |      0      |
+ |           |    +----------+     +-----------+                +-------------+
+ |           |                     |     1     | -------------> |      1      |
+ |           |                     +-----------+                +-------------+
+ |           |                     |     2     | ----------------^ ^ ^ ^ ^ ^ ^
+ |           |                     +-----------+                   | | | | | |
+ |           |                     |     3     | ------------------+ | | | | |
+ |           |                     +-----------+                     | | | | |
+ |           |                     |     4     | --------------------+ | | | |
+ |   PMD 0   |                     +-----------+                       | | | |
+ |           |                     |     5     | ----------------------+ | | |
+ |           |                     +-----------+                         | | |
+ |           |                     |     ..    | ------------------------+ | |
+ |           |                     +-----------+                           | |
+ |           |                     |     511   | --------------------------+ |
+ |           |                     +-----------+                             |
+ |           |                                                               |
+ |           |                                                               |
+ |           |                                                               |
+ +-----------+     page frames                                               |
+ +-----------+ -> +----------+ --> +-----------+    mapping to               |
+ |           |    |    1     |     |    512    | ----------------------------+
+ |           |    +----------+     +-----------+                             |
+ |           |     ^ ^ ^ ^ ^ ^     |    ..     | ----------------------------+
+ |           |     | | | | | |     +-----------+                             |
+ |           |     | | | | | |     |    ..     | ----------------------------+
+ |           |     | | | | | |     +-----------+                             |
+ |           |     | | | | | |     |    ..     | ----------------------------+
+ |           |     | | | | | |     +-----------+                             |
+ |           |     | | | | | |     |    ..     | ----------------------------+
+ |   PMD 1   |     | | | | | |     +-----------+                             |
+ |           |     | | | | | |     |    ..     | ----------------------------+
+ |           |     | | | | | |     +-----------+                             |
+ |           |     | | | | | |     |    ..     | ----------------------------+
+ |           |     | | | | | |     +-----------+                             |
+ |           |     | | | | | |     |    4095   | ----------------------------+
+ +-----------+     | | | | | |     +-----------+
+ |   PMD 2   | ----+ | | | | |
+ +-----------+       | | | | |
+ |   PMD 3   | ------+ | | | |
+ +-----------+         | | | |
+ |   PMD 4   | --------+ | | |
+ +-----------+           | | |
+ |   PMD 5   | ----------+ | |
+ +-----------+             | |
+ |   PMD 6   | ------------+ |
+ +-----------+               |
+ |   PMD 7   | --------------+
+ +-----------+
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 77eaeae497f9..ff0f7d40c6e6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3172,7 +3172,8 @@ struct page * __populate_section_memmap(unsigned long pfn,
 pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
 p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
 pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
-pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
+pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node,
+			    struct page *block);
 pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
 			    struct vmem_altmap *altmap, struct page *block);
 void *vmemmap_alloc_block(unsigned long size, int node);
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 441bb95edd68..dc3a137ec768 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -537,13 +537,22 @@ static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
 	return p;
 }
 
-pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
+pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node,
+				       struct page *block)
 {
 	pmd_t *pmd = pmd_offset(pud, addr);
 	if (pmd_none(*pmd)) {
-		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
-		if (!p)
-			return NULL;
+		void *p;
+
+		if (!block) {
+			p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
+			if (!p)
+				return NULL;
+		} else {
+			/* See comment in vmemmap_pte_populate(). */
+			get_page(block);
+			p = page_to_virt(block);
+		}
 		pmd_populate_kernel(&init_mm, pmd, p);
 	}
 	return pmd;
@@ -585,15 +594,14 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 	return pgd;
 }
 
-static int __meminit vmemmap_populate_address(unsigned long addr, int node,
-					      struct vmem_altmap *altmap,
-					      struct page *reuse, struct page **page)
+static int __meminit vmemmap_populate_pmd_address(unsigned long addr, int node,
+						  struct vmem_altmap *altmap,
+						  struct page *reuse, pmd_t **ptr)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
-	pte_t *pte;
 
 	pgd = vmemmap_pgd_populate(addr, node);
 	if (!pgd)
@@ -604,9 +612,26 @@ static int __meminit vmemmap_populate_address(unsigned long addr, int node,
 	pud = vmemmap_pud_populate(p4d, addr, node);
 	if (!pud)
 		return -ENOMEM;
-	pmd = vmemmap_pmd_populate(pud, addr, node);
+	pmd = vmemmap_pmd_populate(pud, addr, node, reuse);
 	if (!pmd)
 		return -ENOMEM;
+	if (ptr)
+		*ptr = pmd;
+	return 0;
+}
+
+static int __meminit vmemmap_populate_address(unsigned long addr, int node,
+					      struct vmem_altmap *altmap,
+					      struct page *reuse, struct page **page)
+{
+	pmd_t *pmd;
+	pte_t *pte;
+	int rc;
+
+	rc = vmemmap_populate_pmd_address(addr, node, altmap, NULL, &pmd);
+	if (rc)
+		return rc;
+
 	pte = vmemmap_pte_populate(pmd, addr, node, altmap, reuse);
 	if (!pte)
 		return -ENOMEM;
@@ -654,6 +679,22 @@ static inline int __meminit vmemmap_populate_page(unsigned long addr, int node,
 	return vmemmap_populate_address(addr, node, NULL, NULL, page);
 }
 
+static int __meminit vmemmap_populate_pmd_range(unsigned long start,
+						unsigned long end,
+						int node, struct page *page)
+{
+	unsigned long addr = start;
+	int rc;
+
+	for (; addr < end; addr += PMD_SIZE) {
+		rc = vmemmap_populate_pmd_address(addr, node, NULL, page, NULL);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
 /*
  * For compound pages bigger than section size (e.g. x86 1G compound
  * pages with 2M subsection size) fill the rest of sections as tail
@@ -665,13 +706,14 @@ static inline int __meminit vmemmap_populate_page(unsigned long addr, int node,
  * being onlined here.
  */
 static bool __meminit reuse_compound_section(unsigned long start_pfn,
-					     struct dev_pagemap *pgmap)
+					     struct dev_pagemap *pgmap,
+					     unsigned long *offset)
 {
 	unsigned long geometry = pgmap_geometry(pgmap);
-	unsigned long offset = start_pfn -
-		PHYS_PFN(pgmap->ranges[pgmap->nr_range].start);
 
-	return !IS_ALIGNED(offset, geometry) && geometry > PAGES_PER_SUBSECTION;
+	*offset = start_pfn - PHYS_PFN(pgmap->ranges[pgmap->nr_range].start);
+
+	return !IS_ALIGNED(*offset, geometry) && geometry > PAGES_PER_SUBSECTION;
 }
 
 static struct page * __meminit compound_section_tail_page(unsigned long addr)
@@ -691,21 +733,55 @@ static struct page * __meminit compound_section_tail_page(unsigned long addr)
 	return pte_page(*ptep);
 }
 
+static struct page * __meminit compound_section_tail_huge_page(unsigned long addr,
+				unsigned long offset, struct dev_pagemap *pgmap)
+{
+	pmd_t *pmdp;
+
+	addr -= PAGE_SIZE;
+
+	/*
+	 * Assuming sections are populated sequentially, the previous section's
+	 * page data can be reused.
+	 */
+	pmdp = pmd_off_k(addr);
+	if (!pmdp)
+		return ERR_PTR(-ENOMEM);
+
+	/*
+	 * Reuse the tail pages vmemmap pmd page
+	 * See layout diagram in Documentation/vm/vmemmap_dedup.rst
+	 */
+	if (offset % pgmap_geometry(pgmap) > PAGES_PER_SECTION)
+		return pmd_page(*pmdp);
+
+	/* No reusable PMD, fallback to PTE tail page */
+	return NULL;
+}
+
 static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 						     unsigned long start,
 						     unsigned long end, int node,
 						     struct dev_pagemap *pgmap)
 {
-	unsigned long size, addr;
+	unsigned long offset, size, addr;
 
-	if (reuse_compound_section(start_pfn, pgmap)) {
-		struct page *page;
+	if (reuse_compound_section(start_pfn, pgmap, &offset)) {
+		struct page *page, *hpage;
+
+		hpage = compound_section_tail_huge_page(start, offset, pgmap);
+		if (IS_ERR(hpage))
+			return -ENOMEM;
+		if (hpage)
+			return vmemmap_populate_pmd_range(start, end, node,
+							  hpage);
 
 		page = compound_section_tail_page(start);
 		if (!page)
 			return -ENOMEM;
 
 		/*
+		 * Populate the tail pages vmemmap pmd page.
 		 * Reuse the page that was populated in the prior iteration
 		 * with just tail struct pages.
 		 */
-- 
2.17.1

