Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABFE2C81
	for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 19:11:05 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AOIaT6L030842;
	Wed, 24 Nov 2021 19:10:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=hQi3B8K98Wz3FDIAzwhNkO2hr+ugB142dpvOdHzcV/4=;
 b=tomSsOTHOYGZu2cX2EbTVjFtIs1R1LaijN9AXnI290pShm5VsPSXOSmSvunZFrIQLaCI
 caLm0/EWnEgR32x//oqbS1iBC8MXLHfnwJAwWl1Jr0YJxknarnN8s4s4RNUHt2Z6Ttiq
 lf2HcqBjNKKzkEvpfXiZVK4gMgaU0YZ1WP5T7Dvnxto55yo2wzcAQy/KdbduBRZgWcVq
 pdkoUt7qo5EevOiPJqArW7pP88wBj1eedPRyUpHzdvyWsRNQS+58o81V4eamqPTx3BHB
 LMHXBzJG85EwzaSZTEz3TX3BIHqYdXmWgLtC2QvJghV67c5ngPIMYIMkNoImlchyxyTR aA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3chmyyafsb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Nov 2021 19:10:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AOJ0rTF192884;
	Wed, 24 Nov 2021 19:10:58 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2046.outbound.protection.outlook.com [104.47.51.46])
	by userp3030.oracle.com with ESMTP id 3cep526udp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Nov 2021 19:10:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PP6WwpJ1fdDx7czGoo/nJvyk8AdkLooVgHZ8vnHwEdCrlCkc9VLJ3HADgs4OWKa3kNzL5UpfwOKVV+JMasxOObdzN0T1HHKqKg+BPe+/Yk5HPJCo0N/VmUW/1vU6QWjbwb62MM+s8Z8u7PMnWbcJZiY2ON72ieQXHx6gASjI0Zdx01VqzmH8y5grWH+6whjEQuUExanTZm51wNYp0tMtACJaQ4wBJJSoWL5iMxZquOOr+2MDE9h2Vev7ity7d5Bvj7H0j18Y5NmGINe6G7yGFwce4lUjWwy72SjyitpNA00Wi6J9Kb2nv7jr9Qn0PZ0MEdzZksjJbH4zBsfln4DTJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hQi3B8K98Wz3FDIAzwhNkO2hr+ugB142dpvOdHzcV/4=;
 b=RD2V/5lLTPWWSfgd1cfMjYZUBWsAKH3maRRlNqVks1oUWc0yGMLngAzhR9CdtcikEDn5crJSb5jU8KS3KjsYamvEw1SjPqMZSKqkat1Tx/CLd6Uf3xOagvJFhr6eIvSXsMJzbzmZUGWwtF2UiEr2n+sTX4wmgZM0mILTub+uPmlFRRndXIHPMm4FKpiicpxsBHheehPH/kBG1CMwzXh9rzOeh19aWaNvHOmw8mCuwwIcXv5l+dETxT+FMjsxA9pWbuA82nAruDnjs9ceeqyyJiOnNyZB4r25DYpUpPFFg8JXEN3oh0zF0kuv/R6NK8TTxfxaxnUvP1etTpt6bE+sTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQi3B8K98Wz3FDIAzwhNkO2hr+ugB142dpvOdHzcV/4=;
 b=D4f0NfomBaSz1+O3vxkW1Ymhs3vd8TrGNjj8wLH8JsKJWpQihe8kWgdjx+sNWFDACVFjEZAWS21KUQazcMFNPxVK3t03c9rT4DA8B+0hNC4XjEMpaxynaR7YMmqcARmYjPggL8OYX+1YKa5lqLB1IPey3XitPI7SHuSzd0Jq5OE=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5234.namprd10.prod.outlook.com (2603:10b6:208:30c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Wed, 24 Nov
 2021 19:10:55 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%7]) with mapi id 15.20.4734.021; Wed, 24 Nov 2021
 19:10:55 +0000
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
Subject: [PATCH v6 10/10] device-dax: compound devmap support
Date: Wed, 24 Nov 2021 19:10:05 +0000
Message-Id: <20211124191005.20783-11-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.47) by AM0PR06CA0093.eurprd06.prod.outlook.com (2603:10a6:208:fa::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4713.20 via Frontend Transport; Wed, 24 Nov 2021 19:10:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c33dcde-ebf6-4600-8014-08d9af7e23a9
X-MS-TrafficTypeDiagnostic: BLAPR10MB5234:
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB5234AD4FB3B79B85F434E2DCBB619@BLAPR10MB5234.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	g0ZNSbe7dUDou9bzn2b8AEqBYyjxPdU98ycAKcMHW88TLFWHNb+tIsLr8bGmpylJIs3XOEdcLxMMwrlL9LYlJ18iSNUbWlwbAXWp8G7GuNwz43AIU9HOpSBbKPD8ZZih5FXeIDc6/efqQNOy1w72Rd7Ha2beAdlZN4QNhgSx+Ejbjii6x6mvKs2WaazqWCDCHUWfa81pG0IFabKbf+XGB44exOsluGN/xtXxRT52L+uL6R8s6x5nU+dbP8QDiqt+2PaWPPdrp3d5n39yqr8JgJ7CZ+XKvSDJdOedY0kQlXeV2w+tl6K8V03kY7QzQllGSAqNCKLGXde9lQFC7/SOZ0MQZUCp3NiBjJAGmXDQ7MykE5kkRVq/55uswy1qK9FjMFm4Rrpej93m70TveHt0OP5cPSMZIWbDxVKmPWIegY1JFxxjLcI4XEni4prcl5oInS7vWEALvqorPf8vBH8um6+jrnYVJ8ZvodFwYVXCyhO/42vgjnJjW9PoXW0L0MMMjTv9rH4E+Tus2tDJizg4uWeozYTg48iS7fnx/8ZMNUD4xNuFOFs/IycnlWIhpwpWXNFz1jEUfBQT2SmLFtXkO2Enj4mV//nSb3Pw01lGpABPufE0UCAoWrvvqX8RJRBepSpchOxu5W2fo7Ov+TXW2nRe3Y5/e1vAmzThKgMoyITEhRk5L/oRxueTMJrul/AWEyj7Kjd7Kvr9OLK49aA6gHoDPNcWIlJnqC91SsbC2/ttEbnzzvnCKeZsPSL+Z8wUecy8ZKGV82Bt0lp8XYv+gxMIgaab97y3aCJ9GlOrA2o=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(1076003)(26005)(7696005)(83380400001)(186003)(6916009)(103116003)(316002)(52116002)(508600001)(5660300002)(38350700002)(38100700002)(966005)(107886003)(7416002)(54906003)(4326008)(86362001)(2906002)(6486002)(66476007)(8936002)(8676002)(66946007)(2616005)(66556008)(956004)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?VXYqXtANVm8o29x3gZz2l6VpbZa7ku5FqAWyqrpQnr9nOz9b399hGzZ/tdoM?=
 =?us-ascii?Q?eNcUpVcPuK0IndyuV9s/M6DS3SuXOQMJLT+cT7Mwl/XI2cWhG2xXF4MwuDAo?=
 =?us-ascii?Q?xZMOosAlCH68qe0h7Efbnh8jKCeunalvG8IOtAEuXmdyVijPM/9qj+GX1G4b?=
 =?us-ascii?Q?bUvZcttZbFK/mY0/8KnFVblBs8OPun4VJJavDGlLxWRnq4RsUWua6reAMJM7?=
 =?us-ascii?Q?2VGBJzRd8Z/2tJl+fYGFKgJDajpPr4wKSWubTcPkAQqwfeTbTN6HFbkaH5Ac?=
 =?us-ascii?Q?3Qc8fn7ivTrqRdFqv7wC8jIdr5ZnazYtnCLicJnR9RQpki5zu1maW7EcumDw?=
 =?us-ascii?Q?nqDAjC8aEc0/2j3LUK7Q7IMEFt6hQshsqVbgMHKCYW2x36XkgCbjjLOdRC3M?=
 =?us-ascii?Q?Xrc9/8tjguq6e5M4NeTBQeRItmmUWNVZrtktpvGqulAk5AhX630Fy0aMOxN9?=
 =?us-ascii?Q?96VobqrYj7yt0015+2P2+HBQF7eAyVQR/BiKYE26VF1XGkCE2LKj1G0+/b+Q?=
 =?us-ascii?Q?9aKaocG0u1x9CLm1dh7VTpIeTKKdrweWLRysFNJcX/Seo+36C3y87nlczV8g?=
 =?us-ascii?Q?+N8wfX9/KtZCDii9gOttDTIRWdMRgYI2/+WZdff0k/jHP0JLnUvYeuDjUtgz?=
 =?us-ascii?Q?7jJKtEQ5J97rXxrB1CMe2n8G5mbNLra+7h6JtKy7NZfZnCBDKSbnT4ykB2J/?=
 =?us-ascii?Q?aXmANgUzKbo2Ik097vEO2RYBVWp9tLF94smxCHp0LAjO3pXDk/R21o/DXIGd?=
 =?us-ascii?Q?Rb7BhwzQUC0+DdqLVrFM0L0XZZzRd4ZTcliD/IIjTaV7cTzHkZrotPJosEqf?=
 =?us-ascii?Q?Z031tCYuxqvgPbjG1ImfgY7g920VEAJN5LCtqJV1WU9i5M1O9omdJzV0wLC3?=
 =?us-ascii?Q?gcUu1gdxKvKNdezylcDT+fTjVPrwN9oTLeygnb3cU36ooi8yxqhhJG2mQTUk?=
 =?us-ascii?Q?gRt4TjspHUu9byHcTqckDD1p5Ly9GWlI8wSVTieaS9cUvJVrw0s2qskCEwDu?=
 =?us-ascii?Q?dOo6M0CPxP18dhlooJeiI084wF27hg21T0xdCMPXjk+S9Jkfhdo378wgTpA+?=
 =?us-ascii?Q?AvGidB+kH8KAV+ib/saQdwnqoJ2Gp+ZCGlPQ7qeDqF3sHVtzW5Hvc9wqOQpS?=
 =?us-ascii?Q?gCRYIN01sVXsP/bKHr/bvhegmD7Ue3JBVx3+EpRYgsjvK+dKxp57nfTFJ3kF?=
 =?us-ascii?Q?kMwd9x5V6H0PePVct4fXXP+nbAFGMooQlq8lmTQoU7KMWJQKyoislLb7YN88?=
 =?us-ascii?Q?gQD48J0J9uKz9wslShabR66bpeFmC3sdy2lkaTTw7xzfW6rXGyItomqWRYke?=
 =?us-ascii?Q?oTvdJLHubMP3+njVqzQlTBdkNaonZDCMB3fQ7EDBaYoH4Hat7pMb1/likUkP?=
 =?us-ascii?Q?Dc6YNSE6l54+cMJreG17m6rjfPnu3fPhT9XfzcwfOdjPOmiDseZJfgYja7d/?=
 =?us-ascii?Q?OtYBZ6fnCUH+VFCnFEWneHcsGzGzCc+Gv5nkWvfPqGgqyi9Pbig3GsOCMSkm?=
 =?us-ascii?Q?5HULSSHPlts8APHoS1A+JuAyJomdtDdgoLdVylLfJN+JYQq0RdfRfNKPkBhm?=
 =?us-ascii?Q?1KIIFZ831CT1KByAyr3j6cgc8MKygfsYTdQhQ+aoVyGxzr25bpsUaTKWW1EL?=
 =?us-ascii?Q?J48JmsOgXa5a/is8NphhCQBhCAORja+hThAB3rAgzgdijTfR7f/eZ5qbFlJq?=
 =?us-ascii?Q?E5KrZg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c33dcde-ebf6-4600-8014-08d9af7e23a9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 19:10:55.1265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xO9WvPGg4HpgpQrvA7IHv13NybLwr8Gkf8CgH9DMWiLyliesyDjlEAzPje+2xW8NN5sw48Sd5bZ3uXvC63VNScL1YQu1I7EAwcs+2+M25Bk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5234
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10178 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111240099
X-Proofpoint-ORIG-GUID: vYSB3fFI64C9X-D1nCAgXJ94AK-jq-3j
X-Proofpoint-GUID: vYSB3fFI64C9X-D1nCAgXJ94AK-jq-3j

Use the newly added compound devmap facility which maps the assigned dax
ranges as compound pages at a page size of @align.

dax devices are created with a fixed @align (huge page size) which is
enforced through as well at mmap() of the device. Faults, consequently
happen too at the specified @align specified at the creation, and those
don't change throughout dax device lifetime. MCEs unmap a whole dax
huge page, as well as splits occurring at the configured page size.

Performance measured by gup_test improves considerably for
unpin_user_pages() and altmap with NVDIMMs:

$ gup_test -f /dev/dax1.0 -m 16384 -r 10 -S -a -n 512 -w
(pin_user_pages_fast 2M pages) put:~71 ms -> put:~22 ms
[altmap]
(pin_user_pages_fast 2M pages) get:~524ms put:~525 ms -> get: ~127ms put:~71ms

 $ gup_test -f /dev/dax1.0 -m 129022 -r 10 -S -a -n 512 -w
(pin_user_pages_fast 2M pages) put:~513 ms -> put:~188 ms
[altmap with -m 127004]
(pin_user_pages_fast 2M pages) get:~4.1 secs put:~4.12 secs -> get:~1sec put:~563ms

.. as well as unpin_user_page_range_dirty_lock() being just as effective
as THP/hugetlb[0] pages.

[0] https://lore.kernel.org/linux-mm/20210212130843.13865-5-joao.m.martins@oracle.com/

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/device.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 0ef9fecec005..9b51108aea91 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -78,14 +78,20 @@ static void dax_set_mapping(struct vm_fault *vmf, pfn_t pfn,
 {
 	unsigned long i, nr_pages = fault_size / PAGE_SIZE;
 	struct file *filp = vmf->vma->vm_file;
+	struct dev_dax *dev_dax = filp->private_data;
 	pgoff_t pgoff;
 
+	/* mapping is only set on the head */
+	if (dev_dax->pgmap->vmemmap_shift)
+		nr_pages = 1;
+
 	pgoff = linear_page_index(vmf->vma,
 			ALIGN(vmf->address, fault_size));
 
 	for (i = 0; i < nr_pages; i++) {
 		struct page *page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
 
+		page = compound_head(page);
 		if (page->mapping)
 			continue;
 
@@ -445,6 +451,9 @@ int dev_dax_probe(struct dev_dax *dev_dax)
 	}
 
 	pgmap->type = MEMORY_DEVICE_GENERIC;
+	if (dev_dax->align > PAGE_SIZE)
+		pgmap->vmemmap_shift =
+			order_base_2(dev_dax->align >> PAGE_SHIFT);
 	addr = devm_memremap_pages(dev, pgmap);
 	if (IS_ERR(addr))
 		return PTR_ERR(addr);
-- 
2.17.2

