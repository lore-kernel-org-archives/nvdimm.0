Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F3A2C8E
	for <nvdimm@lists.linux.dev>; Fri, 12 Nov 2021 15:09:28 +0000 (UTC)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ACESmW3007211;
	Fri, 12 Nov 2021 15:09:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=hvgB5mDweR/VBfiQqOnVjCs4R/lJvlvNs8vNJke0JvY=;
 b=K8gvcO+ndN6saHACAx8FW0Id6PiwHUbOcAzt9kqkDCv7XAGIiRlh1KZ+50NYykS3UMcn
 +Ogb2WejDakJxJc7G1VAkCJYbB2t2N3udoda5o6hrAHXD8n/SkWhz2jw8H+3Z4A1FJKn
 o6uzDI6NHA4wU3d3nb9fGaOv/2efZG4qALxeiV52rNhne+gQ0J4tqazKexl7vArI4a1U
 whEeH2aRD/Cml0V1PTVWZdeIn0iMIqafqyqO/FDiW4mVPH8hacwcxckx0rdQNuO9MpWz
 uxCmY1J4R2kyyCCPWwWuJTFjW5dGzzWbsm8sud4232JA2VOlsD2OTea5wpk4p8OTdc9h +Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c9gvs2fbn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 15:09:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ACF6DqJ094521;
	Fri, 12 Nov 2021 15:08:59 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
	by aserp3030.oracle.com with ESMTP id 3c5frjhvs8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 15:08:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D5riX09NsQuSGB/6NhPxqtBe3YObcQOgoUtbzKydMYLHDiOKul85PKSC0r8Sjht51kpZAcaaznbZW6OFqr+tgm/lF3unwFbsMq2mPq/HRzme5oTIa0gw14kvlYg5/qVI7zH1AkxtGgMIcL/wjxWAuS6/E3W3YUumDJvxuJ6LihcklnBLHGjdSUYE3WqI6n3fUQaQxT1dKOjHhxIvxeVGge0F4R+BIhTfeITZuZM39KDB/B0mLTCzZr8U/nAw4/6O5cDkllojTzqCMWnpz7zwnHB0K4IIqk8RuJ8GxV+nO67ERozHrfVjh5RwqzANXHGS82WWrsyWzrhwHxAHtrOFUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hvgB5mDweR/VBfiQqOnVjCs4R/lJvlvNs8vNJke0JvY=;
 b=F57wtMAdB7YYPcXfcCHw9Ajqit/JZPGtntRtQz/4fDomIrmRBroOVIQtjy0ciJTwnynU/B223Fa3/kH73pgB9mbKc9vVtznopBq+C/SJiZz8kXB3ZlCx/44FfYrfT2/iIct7WazYgxCBSGROg0YuNkjSwaJhGiRArL6CVhY7NXqAdDaujypEbvcuFmpgLeb2gjSXps6vZrWuCm8yw6nnz4td7ASTj/fxNZFXOwSDindXn4eUQmgadyv94nvM9QZRidYIBoV1k8yVpSWEquwoU1/W/xLr8Tva4gLvaMYubt9VLK1wqVvgMqe/dGACFZzOsJI9SDzJtpOPlGQG0KHUUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hvgB5mDweR/VBfiQqOnVjCs4R/lJvlvNs8vNJke0JvY=;
 b=tyLA9bgGTR8PuHRlvBHs305sjNVbUhLQKSachpvFHwjPVhlXry39uaFUpz/1yfKc1ptQI5+9lV/luyJ+GvTfVkHrWQkS32j5Tyk6EXouvEL5UegDo67ugE4k6ZF3vSUb8EXGO4qGabrd60pAL8oMZO4IKP/WV2Q4iYWSHp4rgoE=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4223.namprd10.prod.outlook.com (2603:10b6:208:1dd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.17; Fri, 12 Nov
 2021 15:08:57 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4669.016; Fri, 12 Nov 2021
 15:08:57 +0000
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
Subject: [PATCH v5 0/8] mm, dax: Introduce compound pages in devmap
Date: Fri, 12 Nov 2021 16:08:16 +0100
Message-Id: <20211112150824.11028-1-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0134.eurprd07.prod.outlook.com
 (2603:10a6:207:8::20) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from paddy.uk.oracle.com (138.3.204.9) by AM3PR07CA0134.eurprd07.prod.outlook.com (2603:10a6:207:8::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4690.12 via Frontend Transport; Fri, 12 Nov 2021 15:08:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86e87a45-788f-400c-22cd-08d9a5ee594c
X-MS-TrafficTypeDiagnostic: MN2PR10MB4223:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB42234FCBF6E2DBC84D7D019BBB959@MN2PR10MB4223.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1107;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	VjFP9TRqlTfS93dktC4ivjl9AT/+dV1sjDfeZPWVrEsstqe/2IphwT6FAqnfGp+/b8Zujxhmf7GoRrvSJ0BXI0Zc/FUd3F02Vq3LwDb67tz2FZT+RJfY3JWstZKVpa87EfxwDbAA8z11xL46C6F7Q3/fVDXGvQcS0ZIWCuccLKpW0HY1TEt4yynzptW/XVvaBJNOttwWkixfgS6yOnL1bN/CJkCk4Bu7Bf8s+Lw7DD6Odk7FWO/IV/DF7D35ZK7vjCp7EtGn5gDxAiBWdS1YZA3okhZhxQe70JzUAjelY2uYldjBCORjyYNcLSd3qAJws3wTIvpNwTNjVUk+0YyIQnLQDldciJ9lQLY1lL1FKMI2dvZea7+x2ffEsTXrXnwjKMutgFOUD6k2T+ldLhRyqaFh2QjYh03ZnvOYa8Tggb2YDW6CuNhn07xbui6duModoHHDoHL5NdwD2Klj7/FQj8/46px775m7Gt2+wz/iQ/VZRuhkxsD1kL8UB0wu29TiP9nhJFAsLNZ2lojXjg9QpCeOSxdF682s15PoenvLMzUOrQI3Q2F3pLvbS4mjLH59Voo5BOHyFIOjc9Xi2RKNAMvWS7Qnw1iEwBQctOe812e+EA5OLgljCnBnz5PdQznNXlhuv8WzaDUesPnzCr6WmQh1gOJkw3fb8bmxuonFGZJMw0O94sCFraRr5IzgbeHBgWtXPWO51SYI74gCTZ0hvPojMEOCewH3ZwNBcmC5/NQj0I/LNQbiUrf/YoID4g7D0/Kye/945WDspBkp9Lkw0gZD7XG5pZywuSKfGUUZWbn6mvLx+nuGiktWeo+D2K1UrtFd04ge9ep2OvvccYDRCw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(5660300002)(2616005)(107886003)(2906002)(38350700002)(38100700002)(66946007)(6916009)(6486002)(66476007)(54906003)(1076003)(66556008)(6666004)(52116002)(4326008)(8936002)(966005)(86362001)(36756003)(103116003)(30864003)(186003)(316002)(26005)(956004)(83380400001)(508600001)(8676002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?ZkEr+PzzP5Q6lISCijFj//SbIkJ5Xm/DvxdljGuCDRegcckcd8AZR/w1hoi6?=
 =?us-ascii?Q?rEWIx0TSitKvXdUbaq759M+9K+D9Cjp77Q25MIpRIIOIGeMl6gkUQSadfYYT?=
 =?us-ascii?Q?apTLdF4CidibyphM/CFRB9I8hliyiDLKuWdGh/HkwzY5L0barc1Fpgz7+kcK?=
 =?us-ascii?Q?YJ+yytT25U83o9X/IUUicKD8CoeTjbdJjymdE2EuiWBaqk4TrEnViYlALyI7?=
 =?us-ascii?Q?AOtx5oSdJvbj97b1/E1tNinzwvDdcZr7sfs/OBPtOqBOoAEqdazQx6XDDhZ6?=
 =?us-ascii?Q?0He1UZev5mEA7yeMgvLxnpybgFovp/QtvljRHOiunSVsUVnY/tAG7T1Yoz9x?=
 =?us-ascii?Q?yLcRvaKxQRhLZVD6Pnmj356Az54EVOUGAEkNg41p/XC2alLYn9u2oVoCh3M5?=
 =?us-ascii?Q?+Vw5nsOBxwkElifhjVLL9LY3nO4HqqQO7OPRc9ryOaayqItGZHKAyakIxtM6?=
 =?us-ascii?Q?VINEXlahCGY0lldn84zDG5UVEGIDifL/qlCyb1G9VVBO3tFyKKR9zA2B3aJi?=
 =?us-ascii?Q?rltGhERs99Xml+elxMhhrkCSg8cJiEgjsnFXtsmXE1pJSW72KfzOiLV4wCR5?=
 =?us-ascii?Q?XeZXPrFAiyBrY0tXlfPTBgyXESffsZ3NHDj/3y0q/m3SWWDu33FEHR6Cnr7m?=
 =?us-ascii?Q?tp1UMdRKU30AzoNIiSeP5iq+Y9BmYlDsWqf3dStIHxoQJkvspy5Vo0f2b3ON?=
 =?us-ascii?Q?eEnw7Kzv61lMccXx1EPCUQLr7nfxBbJJNwndSnqhSkPiN7P+alF83fxwrsjZ?=
 =?us-ascii?Q?bHzesH3ROjtRRz76j/RMqcQn4jfNt9b8rxsyvApMCeQ+uO6tOnLvyl+WP9e0?=
 =?us-ascii?Q?4kDrF0UFKCr5+0yeQ5ZHzfoXoBVOVR90mBJ2Mx/Dq9W78g26GoU1JIYP7OuW?=
 =?us-ascii?Q?k+As5lWWA2YTHbUaSmridT5/kaQVKwUnxIwW6Dsv2upLCEa5Tcm78dz+TdcL?=
 =?us-ascii?Q?Iwsz4/WVJxWwqf94iGX1oL7RCgdjtwX9rrnvPDIV/4XiymPiMKxw3LvwfXaU?=
 =?us-ascii?Q?Xf6sCDva6h1D1cEG8Pwim+D+nRmjSwmuxjRMJN7HNFCYxmT/L0LWmBU5m0P1?=
 =?us-ascii?Q?1opgHHVlPBH8Lb2wd9DpiITfXJ9X7N7iT1kMcU4oCUcfSk/qh2FODNrUTEF2?=
 =?us-ascii?Q?VktRxLIaX1hTMGMo4oi8IBZCdkqmtCMKEGA5Z3D3u7TVcbAX043TCdUkk5sa?=
 =?us-ascii?Q?xifxHUQuBjjwCLw3uXnYlvUb3AU+GKK3g4smPG//ZB5m7cv+2i9YrLc8WQm5?=
 =?us-ascii?Q?F9PtHhIz9bHtHdHqqUvQp6o7m/q5vQ8eZGHYRLrzUx8s1jlz9l5eyBWiUnOe?=
 =?us-ascii?Q?d3KZMH400qBp0THLiAYBEbw273/AwMbazYmJba7ECdRytfkFbWr1E0OVIIAu?=
 =?us-ascii?Q?E9eCjZ87g7qhgiqVq1xh96Jfm7hlRT2Z1gjgs1RtILPGprlSnCqw53dYJf/T?=
 =?us-ascii?Q?RIxzbLo/Id2ofDmGynZvxFTqyrfKUbBrn8FlEmzhC/ilXFEHzSqSGDvKjrK+?=
 =?us-ascii?Q?SZ21EhI7cGUQms6B2Or8nzzpNG+VjhQRG1dyncrYi+twoRrXOb94oJzvcSrh?=
 =?us-ascii?Q?E5Yr8QU8KdhtwiPeMqxFZGjoQwFZI+k4w5tzcOhdiNpqITBV3m1HK77AsDsl?=
 =?us-ascii?Q?CcbAtAiJZxyH+ImFJYio8zs8pExoaorVvTjmGOR583w1NFfWSAGj+pj8kJZr?=
 =?us-ascii?Q?6cWInA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86e87a45-788f-400c-22cd-08d9a5ee594c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 15:08:57.3316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I/I7R9+khnMq+zuRf1agE3MjbxgcCN+WS5gT4DpMg4hJSYEwvR1j0KCDWCXBKnNPcntJVtE9hxXtaoDeFGFEy9W59sh3S6YX7MLhgDuQCZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4223
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10165 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111120087
X-Proofpoint-GUID: UXa9pUirXTS_E6STJ5MQUG9VZKqw4H2z
X-Proofpoint-ORIG-GUID: UXa9pUirXTS_E6STJ5MQUG9VZKqw4H2z

Changes since v4[4]:

* Remove patches 8-14 as they will go in 2 separate (parallel) series;
* Rename @geometry to @vmemmap_shift (Christoph Hellwig)
* Make @vmemmap_shift an order rather than nr of pages (Christoph Hellwig)
* Consequently remove helper pgmap_geometry_order() as it's no longer
needed, in place of accessing directly the structure member [Patch 4 and 8]
* Rename pgmap_geometry() to pgmap_vmemmap_nr() in patches 4 and 8;
* Remove usage of pgmap_geometry() in favour for testing
  @vmemmap_shift for non-zero directly directly in patch 8;
* Patch 5 is new for using `struct_size()` (Dan Williams)
* Add a 'static_dev_dax()' helper for testing pgmap == NULL handling
for dynamic dax devices.
* Expand patch 6 to be explicitly on those !pgmap cases, and replace
those with static_dev_dax().
* Add performance numbers on patch 8 on gup/pin_user_pages() numbers with
this series.
* Massage commit description to remove mentions of @geometry.
* Add Dan's Reviewed-by on patch 8 (Dan Williams)

---

This series converts device-dax to use compound pages, and moves away from the
'struct page per basepage on PMD/PUD' that is done today. Doing so, unlocks a
few noticeable improvements on unpin_user_pages() and makes device-dax+altmap case
4x times faster in pinning (numbers below and in last patch).

I've split the compound pages on devmap part from the rest based on recent
discussions on devmap pending and future work planned[5][6]. There is consensus
that device-dax should be using compound pages to represent its PMD/PUDs just
like HugeTLB and THP, that could lead to less specialization of the dax parts.
I will pursue the rest of the work in parallel once this part is merged,
particular the GUP-{slow,fast} improvements [7] and the tail struct page
deduplication memory savings part[8].

To summarize what the series does:

Patch 1: Prepare hwpoisoning to work with dax compound pages.

Patches 2-3: Split the current utility function of prep_compound_page()
into head and tail and use those two helpers where appropriate to take
advantage of caches being warm after __init_single_page(). This is used
when initializing zone device when we bring up device-dax namespaces.

Patches 4-7: Add devmap support for compound pages in device-dax.
memmap_init_zone_device() initialize its metadata as compound pages, and it
introduces a new devmap property known as vmemmap_shift which
outlines how the vmemmap is structured (defaults to base pages as done today).
The property describe the page order of the metadata essentially.
Finally enable device-dax usage of devmap @vmemmap_shift to a value
based on its own @align property. @vmemmap_shift returns 0 by default (which
is today's case of base pages in devmap, like fsdax or the others) and the
usage of compound devmap is optional. Starting with device-dax (*not* fsdax) we
enable it by default. There are a few pinning improvements particular on the
unpinning case and altmap, as well as unpin_user_page_range_dirty_lock() being
just as effective as THP/hugetlb[0] pages.

    $ gup_test -f /dev/dax1.0 -m 16384 -r 10 -S -a -n 512 -w
    (pin_user_pages_fast 2M pages) put:~71 ms -> put:~22 ms
    [altmap]
    (pin_user_pages_fast 2M pages) get:~524ms put:~525 ms -> get: ~127ms put:~71ms
    
     $ gup_test -f /dev/dax1.0 -m 129022 -r 10 -S -a -n 512 -w
    (pin_user_pages_fast 2M pages) put:~513 ms -> put:~188 ms
    [altmap with -m 127004]
    (pin_user_pages_fast 2M pages) get:~4.1 secs put:~4.12 secs -> get:~1sec put:~563ms

Tested on x86 with 1Tb+ of pmem (alongside registering it with RDMA with and
without altmap), alongside gup_test selftests with dynamic dax regions and
static dax regions. Coupled with ndctl unit tests for dynamic dax devices
that exercise all of this. Note, for dynamic dax regions I had to revert
commit 8aa83e6395 ("x86/setup: Call early_reserve_memory() earlier"), it
is a known issue that this commit broke efi_fake_mem=.

Patches apply on top of linux-next tag next-20211112 (commit f2e19fd15bd7).

Thanks for all the review.

Comments and suggestions very much appreciated!

Older Changelog,

v3[3] -> v4[4]:

 * Collect Dan's Reviewed-by on patches 1-5,8,9,11
 * Collect Muchun Reviewed-by on patch 1,2,11
 * Reorder patches to first introduce compound pages in ZONE_DEVICE with
 device-dax (for pmem) as first user (patches 1-8) followed by implementing
 the sparse-vmemmap changes for minimize struct page overhead for devmap (patches 9-14)
 * Eliminate remnant @align references to use @geometry (Dan)
 * Convert mentions of 'compound pagemap' to 'compound devmap' throughout
   the series to avoid confusions of this work conflicting/referring to
   anything Folio or pagemap related.
 * Delete pgmap_pfn_geometry() on patch 4
   and rework other patches to use pgmap_geometry() instead (Dan)
 * Convert @geometry to be a number of pages rather than page size in patch 4 (Dan)
 * Make pgmap_geometry() more readable (Christoph)
 * Simplify pgmap refcount pfn computation in memremap_pages() (Christoph)
 * Rework memmap_init_compound() in patch 4 to use the same style as
 memmap_init_zone_device i.e. iterating over PFNs, rather than struct pages (Dan)
 * Add comment on devmap prep_compound_head callsite explaining why it needs
 to be used after first+second tail pages have been initialized (Dan, Jane)
 * Initialize tail page refcount to zero in patch 4
 * Make sure pfn_next() iterate over compound pages (rather than base page) in
 patch 4 to tackle the zone_device elevated page refcount.
 [ Note these last two bullet points above are unneeded once this patch is merged:
   https://lore.kernel.org/linux-mm/20210825034828.12927-3-alex.sierra@amd.com/ ]
 * Remove usage of ternary operator when computing @end in gup_device_huge() in patch 8 (Dan)
 * Remove pinned_head variable in patch 8
 * Remove put_dev_pagemap() need for compound case as that is now fixed for the general case
 in patch 8
 * Switch to PageHead() instead of PageCompound() as we only work with either base pages
 or head pages in patch 8 (Matthew)
 * Fix kdoc of @altmap and improve kdoc for @pgmap in patch 9 (Dan)
 * Fix up missing return in vmemmap_populate_address() in patch 10
 * Change error handling style in all patches (Dan)
 * Change title of vmemmap_dedup.rst to be more representative of the purpose in patch 12 (Dan)
 * Move some of the section and subsection tail page reuse code into helpers
 reuse_compound_section() and compound_section_tail_page() for readability in patch 12 (Dan)
 * Commit description fixes for clearity in various patches (Dan)
 * Add pgmap_geometry_order() helper and
   drop unneeded geometry_size, order variables in patch 12
 * Drop unneeded byte based computation to be PFN in patch 12
 * Handle the dynamic dax region properly when ensuring a stable dev_dax->pgmap in patch 6.
 * Add a compound_nr_pages() helper and use it in memmap_init_zone_device to calculate
 the number of unique struct pages to initialize depending on @altmap existence in patch 13 (Dan)
 * Add compound_section_tail_huge_page() for the tail page PMD reuse in patch 14 (Dan)
 * Reword cover letter.

v2 -> v3[3]:
 * Collect Mike's Ack on patch 2 (Mike)
 * Collect Naoya's Reviewed-by on patch 1 (Naoya)
 * Rename compound_pagemaps.rst doc page (and its mentions) to vmemmap_dedup.rst (Mike, Muchun)
 * Rebased to next-20210714

v1[1] -> v2[2]:

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

 RFC[0] -> v1:
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

[0] https://lore.kernel.org/linux-mm/20201208172901.17384-1-joao.m.martins@oracle.com/
[1] https://lore.kernel.org/linux-mm/20210325230938.30752-1-joao.m.martins@oracle.com/
[2] https://lore.kernel.org/linux-mm/20210617184507.3662-1-joao.m.martins@oracle.com/
[3] https://lore.kernel.org/linux-mm/20210714193542.21857-1-joao.m.martins@oracle.com/
[4] https://lore.kernel.org/linux-mm/20210827145819.16471-1-joao.m.martins@oracle.com/
[5] https://lore.kernel.org/linux-mm/20211018182559.GC3686969@ziepe.ca/
[6] https://lore.kernel.org/linux-mm/499043a0-b3d8-7a42-4aee-84b81f5b633f@oracle.com/
[7] https://lore.kernel.org/linux-mm/20210827145819.16471-9-joao.m.martins@oracle.com/
[8] https://lore.kernel.org/linux-mm/20210827145819.16471-13-joao.m.martins@oracle.com/

Joao Martins (8):
  memory-failure: fetch compound_head after pgmap_pfn_valid()
  mm/page_alloc: split prep_compound_page into head and tail subparts
  mm/page_alloc: refactor memmap_init_zone_device() page init
  mm/memremap: add ZONE_DEVICE support for compound pages
  device-dax: use ALIGN() for determining pgoff
  device-dax: use struct_size()
  device-dax: ensure dev_dax->pgmap is valid for dynamic devices
  device-dax: compound devmap support

 drivers/dax/bus.c        |  14 ++++
 drivers/dax/bus.h        |   1 +
 drivers/dax/device.c     |  88 ++++++++++++++++++-------
 include/linux/memremap.h |  11 ++++
 mm/memory-failure.c      |   6 ++
 mm/memremap.c            |  12 ++--
 mm/page_alloc.c          | 138 +++++++++++++++++++++++++++------------
 7 files changed, 200 insertions(+), 70 deletions(-)

-- 
2.17.2

