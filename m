Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0D0173
	for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 19:36:16 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16EJVMxl031367;
	Wed, 14 Jul 2021 19:36:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=ioNFjD8NhDXZa+R+7/rHf1SiRAfQBFOXCHwJQI5f5vQ=;
 b=oNYoR1LVuiFf01YrB1sU/+JYCUzKSV4XcY5FNPFPI4+qGQGgXcWcTYwt8YBg/ji+wMiJ
 q9P5wCPH8L6Ij6OFwC1u1hWCXQl4DUrjWRILE9YT4Qm6dq3pC9y3b6MLi1+vpaHsNqaw
 lN3v7NhximBRI5x1lrvU8LrUfZvBXSlArRXCWe7edfhN6Gow0MiNiIiPfg5V/cvFG0kg
 ICPrRrsRCAbnrGsTWLvHjAvCWpnzsensMwgKRqXFayLrZI8yYcL5ZJWhC3v9qR0Wo+S+
 AGwnfG95L2rMsnlTQLQV2Mf03Cn3ESSW+Z8Lc/fITEOvfaGG06MLDl1ABIw23NUoL0TZ dQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=ioNFjD8NhDXZa+R+7/rHf1SiRAfQBFOXCHwJQI5f5vQ=;
 b=RsAwqFlRX9bjfVncrAWn+H2UPdmDI1JvOxKwgnJdqxfgxrkmLAb2PDQ2Xwzmr46HDMrv
 a9d9W4PJMW9d46XMAG3RSMDqX9R6bqslCGyhV3XfJZRgX+dCECjuLXvamYkWlLgxC30I
 mpZKT1CC1iG2XjiiUCuI4msta2HVvewvR4pNlf8qqUbqPBx0Nh4C4cH9kXtagOz5kCPB
 Muaf8ULjmfUpsjYq2nPmfvG4S8YUkmHK6suONZ/qJK7NRRN74yt0shoXy7guhe7WshCd
 TDZMVyoCrZMjoHARlyBFEkLps9GhexdUru8Ab1Hg676yFIj7tuSSGxXF9bh6J38zIIYn tA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 39rqkb5kmk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16EJUnTx114189;
	Wed, 14 Jul 2021 19:35:59 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by aserp3020.oracle.com with ESMTP id 39q3cfyyhs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:35:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XgPDawFYUEpAyPZRCPp+mbmSMTKRVlHhBuXwcCyh7aMiYPnPvqt2KtfRCmT9xAvJBFLQp5p05i2M5dNvo2OMVF+xPXkB1Wx2n9yFezK+gXVWgJue+rT91yeGnzVfVjJYRK0ES+BUS09uCEwiloMjJ3eyLPT4qumeFLzffwNQOu/TAKXojOABPDO3Lbf76cb8hBeaVktPbD3zXzBMyXunmiwM88Odqz2oQpHnTt45oK3edH5lE2Co50fi0I4/iagp+dVFceGEfNcRPFLe0UFfHFDQwC6aAJQFSbffksuLZNRulNvN44UrIHdUNevf2uQOLy/7sJvyyl/hg7qTYh7aiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ioNFjD8NhDXZa+R+7/rHf1SiRAfQBFOXCHwJQI5f5vQ=;
 b=ChQlWJQoHXouOw8F4A1Iokt4WOhfcDS/PvtssrZ3rmCO6iD5yBiVSNqQ9WOBfNE9NPpGqMt09CzM1B/5qpkqRhGvLC1jlLk5lzRR+N8UjxOFTh7gEg0JIPlBeDi6qHnJTZ34l927v9ndOUvLIeozvbJ0v8xPt4q7omqZqOURQ9bBSHnzjmt6rFa/1FtZz3O1E9PWRyK0x/OXv2GTRePzZnIVqtuYaEM9W3Zi0L9AT+HITQWyVXVMSKD6yS7iORHHIFosr/Kp3R3wPtQaEIEMp28pG48oTRABWRY6HnQv623k3w7Qp2piZdkd8HQcIRLBmioUO244B0JLQhhsDezDaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ioNFjD8NhDXZa+R+7/rHf1SiRAfQBFOXCHwJQI5f5vQ=;
 b=q3mibWzAxv5dFonapLNtLZ5OnT9ypfZBG75Ghm/9uIilxWohjybsyto823dsOuFkWdds3wBcTAxqhVJtlkLC7YpJmaCDJOEoEE4d1LIeMK6r4JhXl3RyI1crQZSOifA+SvzWNaff6l9CETlVCQKlbT7FJ69c+kTq4sDCDBAP+Ks=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL0PR10MB3028.namprd10.prod.outlook.com (2603:10b6:208:77::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.24; Wed, 14 Jul
 2021 19:35:57 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4331.022; Wed, 14 Jul 2021
 19:35:57 +0000
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
Subject: [PATCH v3 00/14] mm, sparse-vmemmap: Introduce compound pagemaps
Date: Wed, 14 Jul 2021 20:35:28 +0100
Message-Id: <20210714193542.21857-1-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
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
Received: from paddy.uk.oracle.com (94.61.1.144) by AM4PR0101CA0048.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 19:35:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 172e7f18-091c-47f8-b8c8-08d946fe99c1
X-MS-TrafficTypeDiagnostic: BL0PR10MB3028:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BL0PR10MB3028BDBF5DC6480A2CBA144DBB139@BL0PR10MB3028.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	o5md53Np4BtCXdmANvtDM6uAUbJ7qYQ+uXyQ6CUs/lgt2/NlseU0mjA420beJ7lE/0OoRITxGaPXW1+qiyUlCG8+Ty2/qhUsyG/oSLUlj68RX6TFXsa0oNKrALFq3a6hpHRsrN/SI4if1avFmuZ+cVnIpHlAWZk6EY/j/MdTE1HpY1/4fqzFLM91ZuOgYtkcy2RdKnVekI2XI+bMU+NCMaXfBzb8oGAUukJwEV5djstV2QfuQxHMZt7WYZJKqBebA8CRgxsgXDVu1538/GIVDyrdesI4F1eeF4WGKERWJuG77sE2zANLrojmGuovHGhJpaZofpzoTt+JGKNmK1FmWvMN+bncKZJj8LwSyIKLvVcWmI0KKObSZC2hcPrufL5U8S9wKr6Sa6odVF7qj4ImwL+c1FZ1768Xx+PtK8AzT2gA1GJf8P89a773ZJVKcbdbsKw7hVt7LJcDD1Ce2ej09zY5oIfyaG7tgnu1obm4BMGWhkC6/wPILVnVWQLza9ayVlpGMoj5ttUm4r7LLSf0gvMYY6+BwWeaXs2ansfwLI/D+UrGg1aHP4Q+4FYHWpbjwOhND0a9iBq5jMGFDobysJzJB49nGp35rZGGB+53LRYYtm1ScYHBGDswh5Vfg77EcOtvhpmvJkPW/kVZUEWkRaZaaiOcTQxR5SS7QbjXEhFi5sxVlP9Hl+faD5W5HbXFeu66Lin5ILiI9LyxuvK3cNf/U/e4kwreebqd9FH6XuTN4ut0fqjVLvo960g/JiOx6H0wadyv2/lzgCJN2jdksGtWtETuD6gjd2rM1Jg1pK/QSyKBGYtzAX1nMLZqu6wO7AmuCTGY/cLkmoebFgTjTg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(39860400002)(136003)(366004)(316002)(86362001)(83380400001)(54906003)(4326008)(5660300002)(8676002)(8936002)(956004)(1076003)(30864003)(6916009)(2906002)(2616005)(107886003)(36756003)(38100700002)(66556008)(7416002)(38350700002)(26005)(478600001)(103116003)(66946007)(6666004)(66476007)(186003)(6486002)(52116002)(966005)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?WdPFc4q+k5jVfo7hNM0lQFzcufb4avdsSWegMm6Gzv2B0/BuQa8aj87FoQ2y?=
 =?us-ascii?Q?lC0Up6O/DqtiZjM6NSWPaX2CFFcZDFSZDfzFNSKByPfj4ZoPpzUjkaoaMOyu?=
 =?us-ascii?Q?4NNeOcgoWDWFC46h+3/Pgcdce4OwyEmBe1XAUDvSt5JXjwbor2hzT+7/jfqU?=
 =?us-ascii?Q?LvgtJ2Jj8JAFop0XKs7Rv0RnIvI+rbzarnEOH3FW4RpKnbLqZzDO9+DfXOtH?=
 =?us-ascii?Q?9Zyrdz5jqNDRdgNVmnlnb7AcVn92Nj37VKZTrNOCbOX12vJ4DwNFFO6pIQAK?=
 =?us-ascii?Q?pFdpzacb3i9DIToRtQJzpnMjJrz3IHI+X+GwMRxYHEEHdxb6JB04rCQJza67?=
 =?us-ascii?Q?O5s0VcX295SvMp2RmayPgaWw9+dcCeenronG15WGmkWuPjveiebmq5mndikb?=
 =?us-ascii?Q?jNDlDmSprilpuoVmLSYINSQK5jVCdZp4IjtrYAsDhClQpRDL+ExXULJt66Fn?=
 =?us-ascii?Q?tQ+uD/Hdc+r+TjJx67wNEbwPyCPP5t+RkX4AdgWQb4dJQ1BuymnHv3DVUM5p?=
 =?us-ascii?Q?6IayNnDId1FLJtev26PO5F0DQrzt9h6gJlQzlA9IPaydyqpvLA7KFXbvlVjI?=
 =?us-ascii?Q?MoCLxjRMcBAkT2H/Y5qc3N8iPVkIoqv0f1vHOVbGcjRcTBc5rfIiV02g3QyI?=
 =?us-ascii?Q?itxavwDk0iTdn1ulGZDoFvM0aZvuho1/YQ/O3b6hsIqGB96Ra4W2J4qV2Cpp?=
 =?us-ascii?Q?PGXtNTNx+jUvAC8O1O5Kh4Q/nMPjhpaUjN/TBynIdhj1nr7+sBBLVIi52W6a?=
 =?us-ascii?Q?hFWyeNSqKfvkWIc12cVnPminrQVvXV+vmm4DQFVC9TOVVkS9NW0DzpcCt/uS?=
 =?us-ascii?Q?e6eF0ruZf2Jjg8EnwnXb56sFCpxebkSZicwjpSa5bECVE9zRhvwaK38EExT9?=
 =?us-ascii?Q?lpXnRgmKSS0v3tdciRN4YCzOtX9fIpucjE3Y1/S/7sPsIrgteX51J6CFTrbo?=
 =?us-ascii?Q?L/nhHUxk9ms/wcz6IbbTEyu7SCg/TonXrn+8QOlc4i1yO6575oeDOAzuOjN9?=
 =?us-ascii?Q?fxVv3XE7umcKKKkLoZRcXHBkQoeeIT+RoC1uRHYJFHuSwp0LWNJ/sJIFV59f?=
 =?us-ascii?Q?ZyN0y37UTBH4sKrEFOOwlkiqGxpjbI3g71q0Z9Vw1VxAnVc+/Fpff9XiHNlx?=
 =?us-ascii?Q?Uh5xuwG3h5OXxYUcqkoCxsAM0ZTpFrf4OTaBLqWXdzS+fnEtzIsfSdUycg2r?=
 =?us-ascii?Q?+Ae906uE3hlBLtL6sYqtid3zViW53qIyzxkIA07wl4QF2+TkTHrJj2MedXKW?=
 =?us-ascii?Q?V3xbKfG50QjRzUZuoeev8+LwQD7k2sn1hOkl4XUWo/hii6t7VoVhHcuHyNTz?=
 =?us-ascii?Q?lrmM6RBiq6OJT9O3gctpIvIR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 172e7f18-091c-47f8-b8c8-08d946fe99c1
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 19:35:56.8626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JFmygihkfKzK+Itj07wq85itKQeqtMbwAK/M6nGdApqopUOKtIBrT7zB1bRgjyugL6P7uBgSYzcvJS1pIEQhG6RzgrktNkHtgLqtSQNSarU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3028
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107140115
X-Proofpoint-ORIG-GUID: gxqWHA1H27eg74bN1Jyuw7WxiazXk3BO
X-Proofpoint-GUID: gxqWHA1H27eg74bN1Jyuw7WxiazXk3BO

Changes since v2 [1]:
 * Collect Mike's Ack on patch 2 (Mike)
 * Collect Naoya's Reviewed-by on patch 1 (Naoya)
 * Rename compound_pagemaps.rst doc page (and its mentions) to vmemmap_dedup.rst (Mike, Muchun)
 * Rebased to next-20210714

Changes since v1 [0]:

 (New patches 7, 10, 11)
 * Remove occurences of 'we' in the commit descriptions (now for real) [Dan]
 * Add comment on top of compound_head() for fsdax (Patch 1) [Dan]
 * Massage commit descriptions of cleanup/refactor patches to reflect [Dan]
 that it's in preparation for bigger infra in sparse-vmemmap. (Patch 2,3,5) [Dan]
 * Greatly improve all commit messages in terms of grammar/wording and clearity. [Dan]
 * Rename variable/helpers from dev_pagemap::align to @geometry, reflecting
 tht it's not the same thing as dev_dax->align, Patch 4 [Dan]
 * Move compound page init logic into separate memmap_init_compound() helper, Patch 4 [Dan]
 * Simplify patch 9 as a result of having compound initialization differently [Dan]
 * Rename @pfn_align variable in memmap_init_zone_device to @pfns_per_compound [Dan]
 * Rename Subject of patch 6 [Dan]
 * Move hugetlb_vmemmap.c comment block to Documentation/vm Patch 7 [Dan]
 * Add some type-safety to @block and use 'struct page *' rather than
 void, Patch 8 [Dan]
 * Add some comments to less obvious parts on 1G compound page case, Patch 8 [Dan]
 * Remove vmemmap lookup function in place of
 pmd_off_k() + pte_offset_kernel() given some guarantees on section onlining
 serialization, Patch 8
 * Add a comment to get_page() mentioning where/how it is, Patch 8 freed [Dan]
 * Add docs about device-dax usage of tail dedup technique in newly added
 compound_pagemaps.rst doc entry.
 * Add cleanup patch for device-dax for ensuring dev_dax::pgmap is always set [Dan]
 * Add cleanup patch for device-dax for using ALIGN() [Dan]
 * Store pinned head in separate @pinned_head variable and fix error case, patch 13 [Dan]
 * Add comment on difference of @next value for PageCompound(), patch 13 [Dan]
 * Move PUD compound page to be last patch [Dan]
 * Add vmemmap layout for PUD compound geometry in compound_pagemaps.rst doc, patch 14 [Dan]
 * Rebased to next-20210617 

[0] https://lore.kernel.org/linux-mm/20210325230938.30752-1-joao.m.martins@oracle.com/
[1] https://lore.kernel.org/linux-mm/20210617184507.3662-1-joao.m.martins@oracle.com/

Full changelog of previous versions at the bottom of cover letter.

---

This series, attempts at minimizing 'struct page' overhead by
pursuing a similar approach as Muchun Song series "Free some vmemmap
pages of hugetlb page"[0] but applied to devmap/ZONE_DEVICE which is now
in mmotm. 

[0] https://lore.kernel.org/linux-mm/20210308102807.59745-1-songmuchun@bytedance.com/

The link above describes it quite nicely, but the idea is to reuse tail
page vmemmap areas, particular the area which only describes tail pages.
So a vmemmap page describes 64 struct pages, and the first page for a given
ZONE_DEVICE vmemmap would contain the head page and 63 tail pages. The second
vmemmap page would contain only tail pages, and that's what gets reused across
the rest of the subsection/section. The bigger the page size, the bigger the
savings (2M hpage -> save 6 vmemmap pages; 1G hpage -> save 4094 vmemmap pages).

This series also takes one step further on 1GB pages and *also* reuse PMD pages
which only contain tail pages which allows to keep parity with current hugepage
based memmap. This further let us more than halve the overhead with 1GB pages
(40M -> 16M per Tb)

In terms of savings, per 1Tb of memory, the struct page cost would go down
with compound pagemap:

* with 2M pages we lose 4G instead of 16G (0.39% instead of 1.5% of total memory)
* with 1G pages we lose 16MB instead of 16G (0.0014% instead of 1.5% of total memory)

Along the way I've extended it past 'struct page' overhead *trying* to address a
few performance issues we knew about for pmem, specifically on the
{pin,get}_user_pages_fast with device-dax vmas which are really
slow even of the fast variants. THP is great on -fast variants but all except
hugetlbfs perform rather poorly on non-fast gup. Although I deferred the
__get_user_pages() improvements (in a follow up series I have stashed as its
ortogonal to device-dax as THP suffers from the same syndrome).

So to summarize what the series does:

Patch 1: Prepare hwpoisoning to work with dax compound pages.

Patches 2-4: Have memmap_init_zone_device() initialize its metadata as compound
pages. We split the current utility function of prep_compound_page() into head
and tail and use those two helpers where appropriate to take advantage of caches
being warm after __init_single_page(). Since RFC this also lets us further speed
up from 190ms down to 80ms init time.

Patches 5-12, 14: Much like Muchun series, we reuse PTE (and PMD) tail page vmemmap
areas across a given page size (namely @align was referred by remaining
memremap/dax code) and enabling of memremap to initialize the ZONE_DEVICE pages
as compound pages or a given @align order. The main difference though, is that
contrary to the hugetlbfs series, there's no vmemmap for the area, because we
are populating it as opposed to remapping it. IOW no freeing of pages of
already initialized vmemmap like the case for hugetlbfs, which simplifies the
logic (besides not being arch-specific). After these, there's quite visible
region bootstrap of pmem memmap given that we would initialize fewer struct
pages depending on the page size with DRAM backed struct pages. altmap sees no
difference in bootstrap. Patch 14 comes last as it's an improvement, not
mandated for the initial functionality. Also move the very nice docs of
hugetlb_vmemmap.c into a Documentation/vm/ entry.

    NVDIMM namespace bootstrap improves from ~268-358 ms to ~78-100/<1ms on 128G NVDIMMs
    with 2M and 1G respectivally.

Patch 13: Optimize grabbing page refcount changes given that we
are working with compound pages i.e. we do 1 increment to the head
page for a given set of N subpages compared as opposed to N individual writes.
{get,pin}_user_pages_fast() for zone_device with compound pagemap consequently
improves considerably with DRAM stored struct pages. It also *greatly*
improves pinning with altmap. Results with gup_test:

                                                   before     after
    (16G get_user_pages_fast 2M page size)         ~59 ms -> ~6.1 ms
    (16G pin_user_pages_fast 2M page size)         ~87 ms -> ~6.2 ms
    (16G get_user_pages_fast altmap 2M page size) ~494 ms -> ~9 ms
    (16G pin_user_pages_fast altmap 2M page size) ~494 ms -> ~10 ms

    altmap performance gets specially interesting when pinning a pmem dimm:

                                                   before     after
    (128G get_user_pages_fast 2M page size)         ~492 ms -> ~49 ms
    (128G pin_user_pages_fast 2M page size)         ~493 ms -> ~50 ms
    (128G get_user_pages_fast altmap 2M page size)  ~3.91 s -> ~70 ms
    (128G pin_user_pages_fast altmap 2M page size)  ~3.97 s -> ~74 ms

I have deferred the __get_user_pages() patch to outside this series
(https://lore.kernel.org/linux-mm/20201208172901.17384-11-joao.m.martins@oracle.com/),
as I found an simpler way to address it and that is also applicable to
THP. But will submit that as a follow up of this.

Patches apply on top of linux-next tag next-20210714 (commit c0d438dbc0b7).

Comments and suggestions very much appreciated!

Older Changelog,

 RFC[1] -> v1:
 (New patches 1-3, 5-8 but the diffstat isn't that different)
 * Fix hwpoisoning of devmap pages reported by Jane (Patch 1 is new in v1)
 * Fix/Massage commit messages to be more clear and remove the 'we' occurences (Dan, John, Matthew)
 * Use pfn_align to be clear it's nr of pages for @align value (John, Dan)
 * Add two helpers pgmap_align() and pgmap_pfn_align() as accessors of pgmap->align;
 * Remove the gup_device_compound_huge special path and have the same code
   work both ways while special casing when devmap page is compound (Jason, John)
 * Avoid usage of vmemmap_populate_basepages() and introduce a first class
   loop that doesn't care about passing an altmap for memmap reuse. (Dan)
 * Completely rework the vmemmap_populate_compound() to avoid the sparse_add_section
   hack into passing block across sparse_add_section calls. It's a lot easier to
   follow and more explicit in what it does.
 * Replace the vmemmap refactoring with adding a @pgmap argument and moving
   parts of the vmemmap_populate_base_pages(). (Patch 5 and 6 are new as a result)
 * Add PMD tail page vmemmap area reuse for 1GB pages. (Patch 8 is new)
 * Improve memmap_init_zone_device() to initialize compound pages when
   struct pages are cache warm. That lead to a even further speed up further
   from RFC series from 190ms -> 80-120ms. Patches 2 and 3 are the new ones
   as a result (Dan)
 * Remove PGMAP_COMPOUND and use @align as the property to detect whether
   or not to reuse vmemmap areas (Dan)

[1] https://lore.kernel.org/linux-mm/20201208172901.17384-1-joao.m.martins@oracle.com/

Thanks,
	Joao

Joao Martins (14):
  memory-failure: fetch compound_head after pgmap_pfn_valid()
  mm/page_alloc: split prep_compound_page into head and tail subparts
  mm/page_alloc: refactor memmap_init_zone_device() page init
  mm/memremap: add ZONE_DEVICE support for compound pages
  mm/sparse-vmemmap: add a pgmap argument to section activation
  mm/sparse-vmemmap: refactor core of vmemmap_populate_basepages() to
    helper
  mm/hugetlb_vmemmap: move comment block to Documentation/vm
  mm/sparse-vmemmap: populate compound pagemaps
  mm/page_alloc: reuse tail struct pages for compound pagemaps
  device-dax: use ALIGN() for determining pgoff
  device-dax: ensure dev_dax->pgmap is valid for dynamic devices
  device-dax: compound pagemap support
  mm/gup: grab head page refcount once for group of subpages
  mm/sparse-vmemmap: improve memory savings for compound pud geometry

 Documentation/vm/index.rst         |   1 +
 Documentation/vm/vmemmap_dedup.rst | 300 +++++++++++++++++++++++++++++
 drivers/dax/device.c               |  58 ++++--
 include/linux/memory_hotplug.h     |   5 +-
 include/linux/memremap.h           |  17 ++
 include/linux/mm.h                 |   8 +-
 mm/gup.c                           |  53 +++--
 mm/hugetlb_vmemmap.c               | 162 +---------------
 mm/memory-failure.c                |   6 +
 mm/memory_hotplug.c                |   3 +-
 mm/memremap.c                      |   9 +-
 mm/page_alloc.c                    | 146 ++++++++++----
 mm/sparse-vmemmap.c                | 226 +++++++++++++++++++---
 mm/sparse.c                        |  24 ++-
 14 files changed, 742 insertions(+), 276 deletions(-)
 create mode 100644 Documentation/vm/vmemmap_dedup.rst

-- 
2.17.1

