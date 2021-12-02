Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C7C2CAB
	for <nvdimm@lists.linux.dev>; Thu,  2 Dec 2021 20:45:23 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2KONJn023249;
	Thu, 2 Dec 2021 20:45:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=3q6V4tgPIyw7c/7R8KMq4uY3+XZ+wyYfe/wFopasDvk=;
 b=QDz7aHDCPvXP63Lhlgxs+xJnbCoqYpDBrItoaCSaKvIKEUtrTq4aLKjrA1iFED5Bi/nQ
 Vst67ita4IK9DilrTcz5ArtLZhFE6ZJoTJrrhrLjNWCnEoKI2zj//Lgf4QUF/T4RI56w
 4xKihzvFiVdAOVGTeLTIplo4+IgY/hA+QDkPNISZehEPbH2RLSgp8ruD1ffV9nYMx/Pa
 eJzLw6C1Hg6LYBmW+B3wrb6vknVCPAIrWcgz7XGjWkF8A5MBNCittuhjfTLvEQD9x1Pd
 WSUgQUOj6JOAlhhxm61OXuNSJXV+BbXBvOuXeTlVawtGokhLKHMF38iEfX5zf35NgaET cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3cpb70b16a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Dec 2021 20:45:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B2KeWCK048020;
	Thu, 2 Dec 2021 20:45:15 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
	by userp3020.oracle.com with ESMTP id 3cke4ux1ap-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Dec 2021 20:45:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gLHOeDr9YQIkPrGNuKWtKX+YpNv5ITxGbcw3NOdDr4yVhDQV5zRs0nNZnNZjGxMiqGSMykAOtSeykzuzGAS9vsECfUZjobm7tUwIs2mYv9cy2HTXl0gI5xQtK1V2HqwdAC0CWmgheS697dxYS3rpkJOu5jsG+xd8f6XjaGI0n0meWLd6WQX4yYqiNp7q8hWKr16DS8T8a/XYILMuFUJpwhsp24DPzqbAnIz+BsATZGKpIn0B0gN/6frEa4l0IIL+5NM89BGgtb+TasKjhq0MUwoK6jPiPziIwKWbgSt944ZGrpcQp2qqkAN+MdR86LdE6VRME/2CdCabMK66AE9QHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3q6V4tgPIyw7c/7R8KMq4uY3+XZ+wyYfe/wFopasDvk=;
 b=I5r497G1kiii7YT0Luw2TlSuSthZU9QU4GVvAFfCq+cnSeAjOD1UfI8e+NPYh1/4NJiaLlyp8mIMte+omPhOptjI6soHohW9NZyFarIwz0Y+BEZp5s2/y6N+uUVV4ERo7xQBrqSmaOmTxWwKeNfR2xGV52zbZOtipvuYl0khA1o1zJr5hLTXAaNSpWxdm+d5v8e7ceEcgWDo5ybbdPzBWdQ+ZtxpdFVc8f34p8NOfIoR+v50keJGUINmv6up4S/6U9Y1Ur5NsGLY107adZc1YmTxGBFoa/Dn5/KN7jd8z66r7UKSLtB5k4XGqKSvuR3ShhZ0NrVF/h4Y5V1ZFAAdKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3q6V4tgPIyw7c/7R8KMq4uY3+XZ+wyYfe/wFopasDvk=;
 b=N3E6y7B7OgU4xxEYV1DVOUXd/TdvYLwfqqjV84Pi8Ft/fENqGsgG5/cCnr3qn05MKjHMGLNIPXLW1q7VJQ4IfoXdFnSxjAXup8oovSuIvDScyYQXFG49v2Wb4kGvpjPc0Y8PIUsu5U+WCVC+l0VBdD2u7bbDVir9BFkD5pxHYHY=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4351.namprd10.prod.outlook.com (2603:10b6:208:1d7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Thu, 2 Dec
 2021 20:45:13 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09%5]) with mapi id 15.20.4755.016; Thu, 2 Dec 2021
 20:45:13 +0000
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
Subject: [PATCH v7 10/11] device-dax: remove pfn from __dev_dax_{pte,pmd,pud}_fault()
Date: Thu,  2 Dec 2021 20:44:21 +0000
Message-Id: <20211202204422.26777-11-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20211202204422.26777-1-joao.m.martins@oracle.com>
References: <20211202204422.26777-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0049.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::29) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from paddy.uk.oracle.com (138.3.204.24) by AM0PR10CA0049.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4755.16 via Frontend Transport; Thu, 2 Dec 2021 20:45:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1e8a8b9-4e58-4221-aacf-08d9b5d4a36f
X-MS-TrafficTypeDiagnostic: MN2PR10MB4351:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB4351B283FE272F9560574000BB699@MN2PR10MB4351.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:813;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	66bRGzYoPEBq5N4uybUrlE6a4pKrGpVhetEQxGsqePD0+JKXyQxp+gHsLs+nCH+vSc0z7sIf2RconlF8ll+1Rrw+Ob+/87v2n8er7ozRDmj5LToDS3APY4RNIWrTGlPVWQ8Mpa6sRnVItOKEpJVpJlTmc9f9MV9OWoBhMQ/lfiwrB3TPSL81eZnZ3WFoY4u5/7mGCdBdSqiBjKkT5EsZAoiQESRGQNJ91iPslqPHfHRyHj1LjGMYMBsBwGsHPWZx8ZWfwAnYBHT1lbyJTAP0Jk1KyY8fniug0doAw0RknwgJlQCOobuYgVih6isZfiamlrq5o9iDDY3x7fWESNSEwnAedfpn2A+CYjferOR+SvOmRDnG1aXWJ8EutYz0bE/zW0nb+chZ3yITuzEbiPbAzNTfrUTthoTLSgtiNvdSWGw+lRoZtI3pRovVtv1SFcLnf38ClpVTVmk6VF1TS49tqtUsh7nwmzKmIEGWg2eH0wKxwky39K4SlGJKKipyMrsIjjL3VULNhrQXYjtPVkVeqTB1QgBgxLJbzKeguEzRWYMH2NwiVTuykG9WrakBuKE/0vCiIdiy+dxl0YBfeA18/f3ZIb+MMV4rsWQ1hTA9MESDkW6ENpIVa3Neuj8LbpHacqefcnsru6ra5DK9VCleR0x9Y7YfBWcchFkvoMXToI3d0GH7sNRiT8tEiipD4gg6nxBdbQrXXponW4OWdiNJMQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66476007)(66946007)(1076003)(7416002)(2616005)(6666004)(38350700002)(7696005)(186003)(8936002)(956004)(4326008)(38100700002)(26005)(83380400001)(52116002)(103116003)(54906003)(107886003)(6486002)(36756003)(86362001)(316002)(8676002)(508600001)(5660300002)(2906002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?mo/LCGQF07wCUN2rH+JQJ5LBGKpx+x3OZp3rcCOOFXsMxbzRnQUHZD89QpvW?=
 =?us-ascii?Q?gStAgvWRGrexznKIw/YmWh+sogvzmluFjbXlhD3u/v90cNPCJZk7nzxdU6+Z?=
 =?us-ascii?Q?qd9xsWZdhivVXjecNFLpVrlCEWp8Js1zWLO/DKzTD+gCo5D6jyl9OKm6qmu2?=
 =?us-ascii?Q?pcYqZZ3VdosLp+rPp5HArVRQ99whXZe1NEyrfDip8s+tJhAmzQrV/u8Lo6Zf?=
 =?us-ascii?Q?5hOfnv7O6QDd6gCsZfoaXPjIiPXLoVhiwo+i5ZiEoeSfLHAafGmSwYM5XKQ4?=
 =?us-ascii?Q?PJk40JEKQN40cRuYvipgDOTIc8KgJF+NdUn9A/7JnZeJnmdd5kck40axagJC?=
 =?us-ascii?Q?NrzbQx6pyqMKF6vyTfjEZB5/0uf9HNLUTvyWtVZ2Nk/A2GHSbYN2N3WrIV99?=
 =?us-ascii?Q?NRg9YLWres+ZuCIp8Eq3Xh9wssEZto/EotPpGG9NVBF0tzRfAdY3avDiWfec?=
 =?us-ascii?Q?H5vqyRyPZyHFAUyjKC9JAB7yWQw9LIX+TXfV8NPZpq58ZYDimevMbIfzFtFP?=
 =?us-ascii?Q?TO4TfAUN3CnbDag5Jdg3gEjohvShPKQ3NazHP5nW1kK2sSwyO6HF90JWQOWk?=
 =?us-ascii?Q?DIrzIoCRWHOe9jV61KTBH3/1+YQ7xf8B3EohCxOVw/FSD7p4ydyn2cQNBmzi?=
 =?us-ascii?Q?i7WiPmpT6prtusXlnno5DgQhU+iVRBD+EK5sPdnaFO3mVfLvyhheS+noqwYw?=
 =?us-ascii?Q?BOT387am29stgQBuoIH14EPDH8PIfEjSztalHJaG3hU6dw49kUfkk40sGccK?=
 =?us-ascii?Q?OGqY2nIU886hbsB5WJ4n0uDuoeHRK8uSordSrw9obo20TUkivxgSUCYM+7oA?=
 =?us-ascii?Q?BP528cXiEa+tmOUutpq2JSNLgUnMGr5b9z/1FdoeO4+WB3hpoCEGCjuWKXCD?=
 =?us-ascii?Q?LU/rJr07p9WgX2hW2q8TVPQXOdmVfGD4MUM+odvQ76WkTmBALGT8b7O50yn2?=
 =?us-ascii?Q?Y4vejMSxnCyGvjKAbNrhDm1FqDxNF/lIJJ4+L8Lbl0NxvWFlt2KxPchKAqEh?=
 =?us-ascii?Q?wtTWxfBhMhN+sJoFq9PXWEB6fbC+jgjteFp/NIwi08WNTGKsQG7y1aVGRl26?=
 =?us-ascii?Q?VdLC0axIDijrEXv4nRthqLRbBl5XKTz5kV5TecrRJEfPEt/2NNZx4dsdO4xv?=
 =?us-ascii?Q?msYxxzIHuBeOj7mk9EpwrmGoeezdw4lKgQnBQUXuybT2dvkX/grc8fbQf5ND?=
 =?us-ascii?Q?0bfyd5qo3q57imWKeMxdrWjdsEsseHG6zMx4ZMfQT3YIyxCvcxiql7FjXegc?=
 =?us-ascii?Q?acPi2kdqDhr3j31Fa4ArS7X2WTnpZTyME09RxWRTaPOIPqLumWujPDCWtggc?=
 =?us-ascii?Q?f3yT2mT++RsN21m94LiUW2b/Z54VjMmSt1pj+5tS9pIU7mQjm7HOGjAuoygl?=
 =?us-ascii?Q?shrREt9i+p4XFd5Q9epy8ASXC4F4nWIRZqcZa7btWy2un1ZzuqCnTb9Pi1wX?=
 =?us-ascii?Q?LFKMgMK5HoIK0glu4iUs7to4uXRiJY8MosGaSdSz8wFdAhYCTLdQMApoNDD5?=
 =?us-ascii?Q?vqY6RB0tRovgKqLg2cU8zg1wT4sztMh8MfwnrCEjEe2P6633tvMeRa6xwwhw?=
 =?us-ascii?Q?0Mqa1C9a5jipV24eN05xj/m6jGvIZvL8FwvnHwM3Aejbrnq7IVLqINOCGeQo?=
 =?us-ascii?Q?Bu8RmvOUapyDE1pqnyXZ/fr2nKghwn3JQiLhV4uHXDGMUwKuTdcbq5C0YCIq?=
 =?us-ascii?Q?yEhP/Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1e8a8b9-4e58-4221-aacf-08d9b5d4a36f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 20:45:13.6208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 83+6BzongsbTwAGY+p8Y7S4YjrkQ4iqxq9HF/+uPkRXTSI0tHBG6yWXugH1I2qsIZFO8GpvQXaM9G02Mx1ZG0fkcTVaXSlz9Qgn/jsqtn7U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4351
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10186 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112020131
X-Proofpoint-ORIG-GUID: 8h73Prh6ppfjbKDouM5bVDZVnqNkcAz9
X-Proofpoint-GUID: 8h73Prh6ppfjbKDouM5bVDZVnqNkcAz9

After moving the page mapping to be set prior to pte insertion, the pfn
in dev_dax_huge_fault() no longer is necessary.  Remove it, as well as
the @pfn argument passed to the internal fault handler helpers.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/dax/device.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 19a6b86486ce..914368164e05 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -95,10 +95,11 @@ static void dax_set_mapping(struct vm_fault *vmf, pfn_t pfn,
 }
 
 static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
-				struct vm_fault *vmf, pfn_t *pfn)
+				struct vm_fault *vmf)
 {
 	struct device *dev = &dev_dax->dev;
 	phys_addr_t phys;
+	pfn_t pfn;
 	unsigned int fault_size = PAGE_SIZE;
 
 	if (check_vma(dev_dax, vmf->vma, __func__))
@@ -119,20 +120,21 @@ static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
 		return VM_FAULT_SIGBUS;
 	}
 
-	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
+	pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
-	dax_set_mapping(vmf, *pfn, fault_size);
+	dax_set_mapping(vmf, pfn, fault_size);
 
-	return vmf_insert_mixed(vmf->vma, vmf->address, *pfn);
+	return vmf_insert_mixed(vmf->vma, vmf->address, pfn);
 }
 
 static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
-				struct vm_fault *vmf, pfn_t *pfn)
+				struct vm_fault *vmf)
 {
 	unsigned long pmd_addr = vmf->address & PMD_MASK;
 	struct device *dev = &dev_dax->dev;
 	phys_addr_t phys;
 	pgoff_t pgoff;
+	pfn_t pfn;
 	unsigned int fault_size = PMD_SIZE;
 
 	if (check_vma(dev_dax, vmf->vma, __func__))
@@ -161,21 +163,22 @@ static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
 		return VM_FAULT_SIGBUS;
 	}
 
-	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
+	pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
-	dax_set_mapping(vmf, *pfn, fault_size);
+	dax_set_mapping(vmf, pfn, fault_size);
 
-	return vmf_insert_pfn_pmd(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
+	return vmf_insert_pfn_pmd(vmf, pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
-				struct vm_fault *vmf, pfn_t *pfn)
+				struct vm_fault *vmf)
 {
 	unsigned long pud_addr = vmf->address & PUD_MASK;
 	struct device *dev = &dev_dax->dev;
 	phys_addr_t phys;
 	pgoff_t pgoff;
+	pfn_t pfn;
 	unsigned int fault_size = PUD_SIZE;
 
 
@@ -205,11 +208,11 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
 		return VM_FAULT_SIGBUS;
 	}
 
-	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
+	pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
-	dax_set_mapping(vmf, *pfn, fault_size);
+	dax_set_mapping(vmf, pfn, fault_size);
 
-	return vmf_insert_pfn_pud(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
+	return vmf_insert_pfn_pud(vmf, pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
 #else
 static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
@@ -225,7 +228,6 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 	struct file *filp = vmf->vma->vm_file;
 	vm_fault_t rc = VM_FAULT_SIGBUS;
 	int id;
-	pfn_t pfn;
 	struct dev_dax *dev_dax = filp->private_data;
 
 	dev_dbg(&dev_dax->dev, "%s: %s (%#lx - %#lx) size = %d\n", current->comm,
@@ -235,13 +237,13 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 	id = dax_read_lock();
 	switch (pe_size) {
 	case PE_SIZE_PTE:
-		rc = __dev_dax_pte_fault(dev_dax, vmf, &pfn);
+		rc = __dev_dax_pte_fault(dev_dax, vmf);
 		break;
 	case PE_SIZE_PMD:
-		rc = __dev_dax_pmd_fault(dev_dax, vmf, &pfn);
+		rc = __dev_dax_pmd_fault(dev_dax, vmf);
 		break;
 	case PE_SIZE_PUD:
-		rc = __dev_dax_pud_fault(dev_dax, vmf, &pfn);
+		rc = __dev_dax_pud_fault(dev_dax, vmf);
 		break;
 	default:
 		rc = VM_FAULT_SIGBUS;
-- 
2.17.2

