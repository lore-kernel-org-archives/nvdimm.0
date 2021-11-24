Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961332C94
	for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 19:10:47 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AOIFX8F026943;
	Wed, 24 Nov 2021 19:10:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=aYH/nCTL7nXVEqIFHAReCCmZNxJXpjTths1wgvDt5jY=;
 b=0iZVKFsVj0EVi5vvaYk26Yba2+1+8aNllg4wOvYpCj6Hxg2nXrSfQW2y4j17v2lwEYda
 3gag+0FxkwiJWRCpD5ESXS4Z/jXihNCqAASFBCAXNZhhcgtVTREJ9aAQlwtf/yxlaIkZ
 mD8XbEVWZgY+KXvnW94CC5y1Q12k7WbVSLn3BDgXFM1i6Eq6pyDuIc2HzcPWDXQ45j5U
 ZC1TYKP7h3vKrIqa65XYeoCf0/Y4kY/uSUgMwdAw9PfXHmu9DUm/lkoc4ihUYWnc1M6h
 Kh/j7XHDJINFLffnGTaNnhLP6LdyPmUJWsDVSMzvePejV5Wy45d2yU+g38+Sa7n9Icga JA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3chk002yr0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Nov 2021 19:10:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AOJ14pi037342;
	Wed, 24 Nov 2021 19:10:23 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
	by aserp3030.oracle.com with ESMTP id 3ceq2ghy9p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Nov 2021 19:10:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GowOi9cg2L7FoZ1dayM1hoRNkBhi/vl/1E5Yh3P+5tdUU0Vum9DefOd3yT5dlWPEjUVlShggG3f1XCJtGEBGiIl8nLfFCYVhtKP/4Ih1jkYpMcd9Iy0VrHCjA1YkaUEYA4/XGOFbutfXKTDDKb+8xfC9WRHjVnG49lYV50JlpoHqtBUv7p6korBvffO0H5K/jpTmwr3Fyiy19rVW1vhbhXSYamCKMKugEG1UcCrnAEx6soIcpfQzh98wM1F+qNLQqR1vqGaVMW+eCpjvt2uaSfT3fpXxEgVvpI5FvhjJWMLDNp0qmKh5z3WFRBpTPvpDuUOxQKeLNkue/UC7gNsjBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aYH/nCTL7nXVEqIFHAReCCmZNxJXpjTths1wgvDt5jY=;
 b=hQWLdAONPU4DfKea5MecjCQgCmiudR5X9RODll6MtJ99pW6fVoVwCrwwIAj+xp4R2eiFftoIXkujOWtPgbXzd/nc3omxGYH+fL9rMDeAqebjmJW0uqtgySiFZ1AyU6yqehVhI6qVJByJF3XMINlaCngVoFlVK5jhP3FNilFhwP2Y9cD2GSxnq+dbm43mQrCunNhj9tcysBqOcWBAT5JCNYH1qaNqCL/qTfi4Ga26KlTdGguADWV13LcoXwvJnV6PS/Jvk3DSkmeYTkoDj+Yatsm91JefMyTJy7g+ZGnKaA2CES1x7fv3HDmknAR6ExPA0isbN8oQSLPTB497gt+U0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aYH/nCTL7nXVEqIFHAReCCmZNxJXpjTths1wgvDt5jY=;
 b=lYti13ndY71KnoIERkSBEftHFT2bOIm8pHOp6cYHW/epc+bkVCi1CnBbJSbVcJ+bU+H6Z4M7Z8VwVmVns4ZQAXH3l+KSwhNvRc5JgT991GSgDGPU4xt91Sps/+gtJg/eym+FshmX2Vz2RRw/i5ii4Cy7X3TSPAyXLD0oEmfRH3U=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5234.namprd10.prod.outlook.com (2603:10b6:208:30c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Wed, 24 Nov
 2021 19:10:20 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%7]) with mapi id 15.20.4734.021; Wed, 24 Nov 2021
 19:10:20 +0000
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
Subject: [PATCH v6 00/10] mm, device-dax: Introduce compound pages in devmap
Date: Wed, 24 Nov 2021 19:09:55 +0000
Message-Id: <20211124191005.20783-1-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
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
Received: from paddy.uk.oracle.com (138.3.204.47) by AM0PR06CA0093.eurprd06.prod.outlook.com (2603:10a6:208:fa::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4713.20 via Frontend Transport; Wed, 24 Nov 2021 19:10:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8d8bcf9-33c0-43e4-1fc2-08d9af7e0f08
X-MS-TrafficTypeDiagnostic: BLAPR10MB5234:
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB523413352E9AB85DDFD10BC0BB619@BLAPR10MB5234.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	8QS4d644XV2BRnCWpZ9//W4H6supePlUuBFKavAGd77eig6PnB/kc4AuR4Pt13IybYSYIM5qGcyW3YwLCKbzqoNCFrUb5WsaBQ1DXSegfYSeKvtxIlfrW7/fC6w4jUqPxN8iZGKB+yN6jyFuhX6M8f5dHYq+SAZ/GfnOcKK9yAXVsfGNyYotg6pmUIzKG7YRClDykbzPv/Bq+ynOCoLDywaNJPIve0yXZNL8lNYWz9K+r7RbaWkhx5PjickHSqq9ela5PvoXKsFdYkle8SI31EeZpNOOc2eM0F1xvniwx/HAAY2UDfO3hmWP1UfH39Ockf7YAnMK7r875V07N1JO9ANuOT0X6cu2nh967xiV7zuFJwfdiwTYxty6vaOb5IsK1l3DyMS34vJO1X2KLpc4jtqvM8OT2i8P01brJRlwhmWoLywCYmsF8BIRdsyMFhzSwsmm1Z7xyl8FuU6SH5hs9llh89G8q9JJqxIfcIjXC0MZV3Ulv9MWVLxIyDDN3sAaiVkhozQK8Dizicj5mvjOTAXloWxE5OqY43VHzqeTgSnvwxZ9HG+FDvLUuHPGRc8LGkvVA9uUu+42hC4An7MLkaBTIq98OxDsYO0VhHwLvZfTWclW8IprH0laXlANaPyx+PIKGeqwlZZCHXEfdIwRAsAMmGDBkyYrpSGdFZ044AKGRIyyTT51Q7bcb9cx92NNgemIM/7aaQOUzPkDwB98TYU8R7fVW4ICsPV1Rg6Y/Ne3fKcrklYXfePCF+HtHMS7Eu1T9iIIj0lCHxy58vYqwJ6naThF6CQzciWsasKS1xMjqdxMPHaJJKqexaMe/oojL2yOLTBpyTCGqpJgQXOeEg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(1076003)(26005)(7696005)(83380400001)(186003)(6916009)(103116003)(316002)(52116002)(508600001)(5660300002)(38350700002)(38100700002)(966005)(107886003)(30864003)(7416002)(54906003)(4326008)(86362001)(2906002)(6486002)(66476007)(8936002)(8676002)(66946007)(2616005)(66556008)(956004)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?LHBJFIHneIYf1/rLmft7eWMCvCLK7ACRTGWLYaR4Vq/86uyKK04ZBYHJ+X/f?=
 =?us-ascii?Q?UJcZCGvCYDs+CF4ve+Z6ubbmhExer9xEugNaQHz6JP6WjC/kGrimSjxqk3Oa?=
 =?us-ascii?Q?K80gTE/ZQbGP3ZMJZZxOgNticwy7NVPwOmy4BB4FwLNaSrOnBOM2EfS9bYS4?=
 =?us-ascii?Q?naU7aYsMQQMm+hOKOffnHuEFQj79cTrHSakYvrsLihurKBv1TVgYkF5Oltew?=
 =?us-ascii?Q?XTW4Sy34CgPTDWs9m8YbudsXvrgEXVgEiT40HFm89DtmWe4z3EhBxnM4OBeA?=
 =?us-ascii?Q?/pqjujR1YIfy14BhSVK8ULrV/lcn6FgxtKkogKZf591c2AYiAsSyY2C1uZb0?=
 =?us-ascii?Q?9IfwYcbACSa6VnKuLvcxMmEsqiuZp/icaNlBIwNgJo8AfMJCcRvNKmzTsyu8?=
 =?us-ascii?Q?HaKImj/y/5p5nICnEgSZu2DQutxPHvzB8jBzv790Kf7d4JfQtIO9T1OWxh+h?=
 =?us-ascii?Q?6tyTrkuuz7+5XlYs6VwKk58NFZ65CGIXQhLvons+aqo5l1ajtp6SeJhfWmsZ?=
 =?us-ascii?Q?qWeeqOUpgA/t4yKge8b1w/9ap806+W+eYNQgy9c18/uMnVvk49KzrMDNyCQR?=
 =?us-ascii?Q?OrjqS76m9/KRoPabtajdiS0iODQaYrKi2IiybrOU+yJqBSvD4YyJ/Qq5IdWV?=
 =?us-ascii?Q?uyvQxb7Nw5lS/+Sp9b8Y6GmRyyr+wpqhm/c+PzIceh3TXqLTJypezUBwaCc2?=
 =?us-ascii?Q?KOQepWPQep9Gx0s2koru6s2RXD5Ij9G1OP4ckyYhMEg8TcnqgKWXBEriDzql?=
 =?us-ascii?Q?xUZfoqWiY4Le4f4yPuiwCBz/y1KNt1wkX+6azaYbsppjlWKLCbaFqzn0QPgQ?=
 =?us-ascii?Q?L4bEPxuy4CiHFALzTk0oWNesR7sxPcb9vJIKsUVjpUjAy8QpVTxjtc6dUoEb?=
 =?us-ascii?Q?0jy4yWV6Zdin/qC+QfUtC+k7mvL0c95iZxs9vNkmi0MtdgU4OyjA/CqS6HUr?=
 =?us-ascii?Q?oAAjlwbnzQjTb2AY4Uc6kdgwQQIAsj+x5DH5kFQxzgAmkniNVNogETnOjned?=
 =?us-ascii?Q?6MkcDde3m48e5cHZQLckF1/AgkuP/jH0rgBU/da+cPSGt2XdJ4kf6Jx6Gnjt?=
 =?us-ascii?Q?eWXz066hdlDjNxsJD0qpOvoR7Xchh26uNuXneD2NvQrUr9MVGlw1+rgAb6+o?=
 =?us-ascii?Q?QO0VQWs9MNvmT6iNf15ObKxnOkpx0G3jnV0Wng92lKt72fkABSHyFQf4oQbi?=
 =?us-ascii?Q?kd41Zp6GrI+ifEJOPcfkcR7LhxDkSZWyHl6qbbPxS0VnlzMFsLySTrKucZfv?=
 =?us-ascii?Q?NDl2QC3kBHLtxj0Ex8NYHJP0csqiPK5TKokhDdMEBLLF5ASlRnbzdY18BRxa?=
 =?us-ascii?Q?GQtwk6zvqFhg4lh7Q0agYxYNQ2Au/JbiJLF/h+RfCBfZBmbvRbzjdKswLt9K?=
 =?us-ascii?Q?FwMn1ORsHg8hyMy9d6ptc803lybFWzRwmzK7L5f2Z+lkeVpu1nxzJI/jG8iR?=
 =?us-ascii?Q?NGIbPqv0B5kmjEJD0dVUfIuSClq1rGhwcAGGGaCFNVwJi4aVMHBdSj/8hXX3?=
 =?us-ascii?Q?4KSAPWwRadPOooz++vWbviH859aoww/DHo7CXaitxwkzbhCYYt9DUX4EELkc?=
 =?us-ascii?Q?rXpDr2pag3Wh6bwY77KEh+cTqBwv0fOGJ5N7rJI0fBUHLY/+HJa80/iN7dX8?=
 =?us-ascii?Q?+N4wl+wtAUG7S8X3wlVM+KZ8nZ4KPDXdHC6uv+KTS53SPO5to5W8y+mLOoRN?=
 =?us-ascii?Q?gksH6Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8d8bcf9-33c0-43e4-1fc2-08d9af7e0f08
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 19:10:20.7206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JyXjasg2oYnPpdmllZdHcPrwtH6c0xeK/QzIvVksi+SkobENXiRq6yVfNZgzYMuQmr1wLlAIv7U1DsGlsPaECmjn/6nr2wXsLkb7hJQPTQc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5234
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10178 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111240099
X-Proofpoint-ORIG-GUID: pI-OO-yw0VY9M_TPTDi5qbFZs0ooHWTz
X-Proofpoint-GUID: pI-OO-yw0VY9M_TPTDi5qbFZs0ooHWTz

Changes since v5[9]:

* Keep @dev on the previous line to improve readability on 
patch 5 (Christoph Hellwig)
* Document is_static() function to clarify what are static and
dynamic dax regions in patch 7 (Christoph Hellwig)
* Deduce @f_mapping and @pgmap from vmf->vma->vm_file to reduce
the number of arguments of set_{page,compound}_mapping() in last
patch (Christoph Hellwig)
* Factor out @mapping initialization to a separate helper ([new] patch 8)
and rename set_page_mapping() to dax_set_mapping() in the process.
* Remove set_compound_mapping() and instead adjust dax_set_mapping()
to handle @vmemmap_shift case on the last patch. This greatly
simplifies the last patch, and addresses a similar comment by Christoph
on having an earlier return. No functional change on the changes
to dax_set_mapping compared to its earlier version so I retained
Dan's Rb on last patch.
* Initialize the mapping prior to inserting the PTE/PMD/PUD as opposed
to after the fact. ([new] patch 9, Jason Gunthorpe)

Patches 8 and 9 are new (small cleanups) in v6.
Patches 6 - 9 are the ones missing Rb tags.

---

This series converts device-dax to use compound pages, and moves away from the
'struct page per basepage on PMD/PUD' that is done today. Doing so, 1) unlocks
a few noticeable improvements on unpin_user_pages() and makes device-dax+altmap
case 4x times faster in pinning (numbers below and in last patch) 2) as
mentioned in various other threads it's one important step towards cleaning up
ZONE_DEVICE refcounting.

I've split the compound pages on devmap part from the rest based on recent
discussions on devmap pending and future work planned[5][6]. There is consensus
that device-dax should be using compound pages to represent its PMD/PUDs just
like HugeTLB and THP, and that leads to less specialization of the dax parts.
I will pursue the rest of the work in parallel once this part is merged,
particular the GUP-{slow,fast} improvements [7] and the tail struct page
deduplication memory savings part[8].

To summarize what the series does:

Patch 1: Prepare hwpoisoning to work with dax compound pages.

Patches 2-3: Split the current utility function of prep_compound_page()
into head and tail and use those two helpers where appropriate to take
advantage of caches being warm after __init_single_page(). This is used
when initializing zone device when we bring up device-dax namespaces.

Patches 4-10: Add devmap support for compound pages in device-dax.
memmap_init_zone_device() initialize its metadata as compound pages, and it
introduces a new devmap property known as vmemmap_shift which
outlines how the vmemmap is structured (defaults to base pages as done today).
The property describe the page order of the metadata essentially.
While at it do a few cleanups in device-dax in patches 5-9.
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

Patches apply on top of linux-next tag next-20211124 (commit 4b74e088fef6).

Thanks for all the review so far.

As always, Comments and suggestions very much appreciated!

Older Changelog,

v4[4] -> v5[9]:

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
[9] https://lore.kernel.org/linux-mm/20211112150824.11028-1-joao.m.martins@oracle.com/ 

Joao Martins (10):
  memory-failure: fetch compound_head after pgmap_pfn_valid()
  mm/page_alloc: split prep_compound_page into head and tail subparts
  mm/page_alloc: refactor memmap_init_zone_device() page init
  mm/memremap: add ZONE_DEVICE support for compound pages
  device-dax: use ALIGN() for determining pgoff
  device-dax: use struct_size()
  device-dax: ensure dev_dax->pgmap is valid for dynamic devices
  device-dax: factor out page mapping initialization
  device-dax: set mapping prior to vmf_insert_pfn{,_pmd,pud}()
  device-dax: compound devmap support

 drivers/dax/bus.c        |  32 +++++++++
 drivers/dax/bus.h        |   1 +
 drivers/dax/device.c     |  92 +++++++++++++++++---------
 include/linux/memremap.h |  11 ++++
 mm/memory-failure.c      |   6 ++
 mm/memremap.c            |  12 ++--
 mm/page_alloc.c          | 138 +++++++++++++++++++++++++++------------
 7 files changed, 212 insertions(+), 80 deletions(-)

-- 
2.17.2

