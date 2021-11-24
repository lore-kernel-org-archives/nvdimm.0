Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EEB2C81
	for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 19:11:02 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AOIJEU4000716;
	Wed, 24 Nov 2021 19:10:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=EcYEsoxnESLwNGCqtEExBV+6TLNOK83bxuWGTwlmN54=;
 b=bVpMTvUUuYWAp35b0NR+2AskmfmUNYWLfszL6oTK3RYB4JFahRwmAR8/tCXI22zsu/UU
 lFEtVvLSZy287bNDgTwC371XE4QvdMd2GEv+o8nJDbsiEtrEbIO5A7EsHeffBYmGwcqj
 Ksux15fvVCC6FNpspK+3xgyQjZ1EFIeidARGpuMJ3C5HO2E/BtFKRLfCWGSCj/0CKS1q
 9oOAlTt6o1QHWj7wVxj6XHpXhYqaU8MGhz2GlEkjCWDJG6wGFOn9xVowcUG9I6w50TPC
 6NFyJ5b6NwVjQQuVckY5czr7mw6Y/gh11b+EDK/CdCTQSyMaVjLMt6UETlfWklPuOghr AA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3chkfkb0e2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Nov 2021 19:10:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AOJ1H5n086994;
	Wed, 24 Nov 2021 19:10:53 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
	by userp3020.oracle.com with ESMTP id 3chtx6hd38-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Nov 2021 19:10:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gIFIfBz3Au5Cdgwk82/rYLaTDtpBBxwx22K96sIfXJ+rT3ktcKTUmlR0Q+BwxDlPY90fLwXds/tmRzemrfIxGmROSjRAsBzacRIK5ylPehzR0pEZBD7xUh71LXEG73cgEZyMC6iW1PscigxJuGzzjVmvLFbGvFDC3O85emTIe4ZWn0V8UfkOi4GSlAr2ovFPmoSi4Z+KkNZretaJAc4SkvYVojPOuJg7mEaylKv4tFcoE4NrB/Vj/Kxda9BwAeRxEVR/iJjkjX+Ip9ZYZs+1n6PEsSmtFhGPDM8kQBXiw1pbAfDlTDYw9HEhfuty5FCPrn0cItr5mTBvFdU9njVp0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EcYEsoxnESLwNGCqtEExBV+6TLNOK83bxuWGTwlmN54=;
 b=EtK5YbR2el5uLprsKouSlqiq1fEWqfahLhDXr57PLg+3W1gfeynY7xC6WqiT0Tv9iD1QiWpsHk5Ev9lrjxrWx/+1/VhStw4YXAwhoJDT5BBgmP+GNqzFvm+SUuxJ0NmOV2tYwYRDUztz7vYBVkWSMS+CfyyuWumCZjljZ7QpwBXixezASTCEZeq1eMgo1frAafryqJa4JqXcf8YOHL1r4gTXnvdO6H3+fZeTLwiEM6GBDxueFHDBtR3sPXmW0eyzhyxMOTlnpSJtz7zQwpWiTavTTv5SW+dXwrmiNlBezGS2s+jFSt/1bGm6AxUetUBKIT6zl7esFiZHYL7GeA1bDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EcYEsoxnESLwNGCqtEExBV+6TLNOK83bxuWGTwlmN54=;
 b=GOSuInYTu+DEFYlROj1Q/iBIb/ZBySddpZNQCIuDIcGFk/hB4pilFFy0sZbXs3wVWbcybGLMTYd0DSQAO4ZIQeTiLSxbDZQnThR8BxnMpcvCx2z+Tj2wdDsKf9OhwRrP930b0nZRRzYpvb5JDgmMJYEon42nPo9Xr+u5TDwRC+I=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL0PR10MB2916.namprd10.prod.outlook.com (2603:10b6:208:77::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Wed, 24 Nov
 2021 19:10:51 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%7]) with mapi id 15.20.4734.021; Wed, 24 Nov 2021
 19:10:51 +0000
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
Subject: [PATCH v6 09/10] device-dax: set mapping prior to vmf_insert_pfn{,_pmd,pud}()
Date: Wed, 24 Nov 2021 19:10:04 +0000
Message-Id: <20211124191005.20783-10-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.47) by AM0PR06CA0093.eurprd06.prod.outlook.com (2603:10a6:208:fa::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4713.20 via Frontend Transport; Wed, 24 Nov 2021 19:10:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a0bacb4-447b-4523-3eb6-08d9af7e218f
X-MS-TrafficTypeDiagnostic: BL0PR10MB2916:
X-Microsoft-Antispam-PRVS: 
	<BL0PR10MB291690DCDCD0B14332EFCD59BB619@BL0PR10MB2916.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	hCREuq31aKyPhfix0H2s/4fuPY1UeWOApD1Kvq/ecfGG844gRux4XjqajRk0qWkzfTJLFkYOVMxoewLQQYN2jQgzXvdd0Izf4eCw6MLtft8jtb+iCUpLMlmy+pr9MKKH1PxyUYO/i6FBZ2u5xNEypAJAo+5e3IEIYJ883NRV7igpqfuDNEdU7Wjm7XMhSsPM8YsKwqJe/NPGpobZLN4hsfmnMn7MvApVMMhzz1uVNm7yplxv2jFVptmq6n34m4Oj+aei3nFfXN9M0vMGE5/XyWxr1fcD27zt7Ag1y9uCZV5MIR0Ze7TfisSJScacxfxBiAl0CgC16sPmYbl8bmajWLX0HDwcN34IISLYAFoB4278wCuNoE1sRfqrIugLo2WgTK2xivCmU4Uwv9T0S47kn4YZcud2OSCcs42bSzqw8+6cGgZGMeAytQ8KsHrT7pR3mVUEKwsDxlTBBv+jhEo1mIRjPymut6ziz6OE+0p/Jl6Z3asbCM821zK5d5zvbCxjNW/N4dQiHclOGEmE544gfYd8yxNdMvrSla597fY/G3hCrZur7a770tM7MNcWMWT1iNTEmp/NR0OK7wVghtTFgsj15pCK8htXebYUZ5MSTpIRkwA1/XhXPlBHkV6T8mzEY89sg3kSSHavFMroeLBD49MZRK/izLU2zXm3D+enACpl+LyXtx1MbSkejbjCelzmvtLNORHTX1J+rNuROa6vI06/YdDs3YIo9hthKDavB1SppQJpAwpyApVXEDW2Vcw+
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(5660300002)(103116003)(1076003)(36756003)(107886003)(6666004)(956004)(54906003)(7416002)(38100700002)(6486002)(2616005)(86362001)(8936002)(38350700002)(7696005)(52116002)(6916009)(508600001)(26005)(8676002)(66476007)(66556008)(186003)(2906002)(66946007)(83380400001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?BDvpVgI4DNbcYZuVJ0Y8j/RXlYNbi+ZIG/sbJntVOLXSlTcNCDzwOdP9BDZc?=
 =?us-ascii?Q?urZqyISPmz5I9Xb1v+Ss1TGI9k+3mZp2LnqTciGo4np699BAdsP02FZy7lnu?=
 =?us-ascii?Q?xDpbQVKFRFBaTUaxHLj/FyM3Tr4UHk8D+SNPemknh5QQMXiTeWNKtz4nLfSW?=
 =?us-ascii?Q?COTxD+Mtq5YAcOafZFLXIjKBZkYJpETyRlpu7jAEvbaydTg1G1wphzXxmbAl?=
 =?us-ascii?Q?ot9v4SOn+JixRX9Y2W4NFUuGMcJluuIm5VO8Iv6zyXML0nbbm7BOTvCvn0t0?=
 =?us-ascii?Q?gGFGtll0UV7G2UF+lDVEJx/bsG2JWRwoLFVMtq/gyDEphxeiXwfwIU+XBe5m?=
 =?us-ascii?Q?koi2kzR2vmY4Zxq15aoZL9MOAVYJPCyw7QOPexpvR2h3JegUYxqGxpx2AvYU?=
 =?us-ascii?Q?QybtOlEB/bOeHWe9R6Fm0V6tHc+PUQsfXhgot3ATou9DUxmciRSrOA3SEBRk?=
 =?us-ascii?Q?4ahWOYaA7C4VHApHoIt9eSixJXJ6vo9ycZ+nPn7w2UnyLwEcGHTKFLglT4HQ?=
 =?us-ascii?Q?0BBy4NyIlTw9Ox/E60uV3JUIPL3pgk+qP/6aWbrA4LKlaRaC2D47HMqvFjqE?=
 =?us-ascii?Q?ZCqVjrWj329WOZ/QpvkzAMeJZokfL0kZsOyMNQ4675I5PO+4t0j6zHmCfDMf?=
 =?us-ascii?Q?q7oofyB4F/DrKFZewfEXsRbLJneA/e91yc75J8d4d+to5GsUey08i0psSD6Y?=
 =?us-ascii?Q?FNiOE06mFt3JhMX+4RM/BNi1m9bZmWMJyyVaMfSG29DEQTnu0as5M1FVs/NY?=
 =?us-ascii?Q?j9zTO/P8Jofx5vM/3asUJfn7eRcl6NdCxLNctdCczcvyWqBbPdRGdXba5xsF?=
 =?us-ascii?Q?P/mbjrnvpPsrdcqDchwBeOWbNxMHCZUQDBlmuETtLpt3azK8BgriQkl5C6xX?=
 =?us-ascii?Q?13gqtlCdp/RUU+9QgDm78nMhMP2nxyjqNZP07BD1TBImVH7B5my1UTN4BCjP?=
 =?us-ascii?Q?x3KAHU3xPp59k4enFQ2nWXcGNMdGOVXpnlDKisuHGihPQGf4L50/+ltbKz+B?=
 =?us-ascii?Q?X9gY/E6e3wqPR7Nd0BQG4tDjRgRuRbDfS2u9w7VzULuevGtAr574gfChMPBo?=
 =?us-ascii?Q?3xRSFMyXWWCEzeEZyRqY5cEBq+7K/zXsJJUx9vRl8IAF3lGY0OiRDlKoYSSS?=
 =?us-ascii?Q?5xLc0mCFpDATw6AdyvyiwStWk12Ea6/hTfnIDbYdPayM5KOaz3e4drrBYEcL?=
 =?us-ascii?Q?Nw59SQcVa5gQDEOubkHUfzLbiMVLzDdb5iijeh+t2n+Zmu1BywniMm7YOZR5?=
 =?us-ascii?Q?TIhHqR+beXQ2WpSJ9JSMO/ZeZt9vSvtCHCnBY1XJGOA9na8drvCe3yzhMKVb?=
 =?us-ascii?Q?AeUaFlQIZPfgdlUmvrt5ha7vS/+/XYCxoQ3kweZC3lQ+K+5ZogzaN+OHK83+?=
 =?us-ascii?Q?XkYrHwMGjHI22cARsLEW81CYdoRA2AXl2VRpz34y+RsL/t408yGndnDWFnjU?=
 =?us-ascii?Q?FYd5eo4Y0sTKMZvr1wmY3/v3Cu8JfoPXHgp+PdfxBvVuf/lvInuOYRBuxmeJ?=
 =?us-ascii?Q?h8wpEFmGWMihAbHpK5ZANd700NLDl0WRHM+xIBoFdeZOPkR4ly4/XvQD7m8m?=
 =?us-ascii?Q?lPeVRDoFGm64P/Q5IFSYXwC6mZZBSqcd85ceS9yVxkOabVdoIDosOMSARjCO?=
 =?us-ascii?Q?hUffEFwK4McmIiIyzNckQKRU3zXis26Z/pwgwcFLWI+9vyzHOR8hRuYYLdYP?=
 =?us-ascii?Q?hWJlpw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a0bacb4-447b-4523-3eb6-08d9af7e218f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 19:10:51.5462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3LnxZewutSys3fIvAQUeQZJgTgnLoXqmuP0fKHkqv8PUptsgsqxxt9U0EFMVw6cpDgP6e/xkcygN4lZhJLQdOZDdbruJYlKtkJIFBPvnJxs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2916
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10178 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111240099
X-Proofpoint-GUID: 9NZSxvsyjwpQPDKrx5e2dtLuL4685T_c
X-Proofpoint-ORIG-GUID: 9NZSxvsyjwpQPDKrx5e2dtLuL4685T_c

Normally, the @page mapping is set prior to inserting the page into a
page table entry. Make device-dax adhere to the same ordering, rather
than setting mapping after the PTE is inserted.

The address_space never changes and it is always associated with the
same inode and underlying pages. So, the page mapping is set once but
cleared when the struct pages are removed/freed (i.e. after
{devm_}memunmap_pages()).

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/dax/device.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 9c87927d4bc2..0ef9fecec005 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -121,6 +121,8 @@ static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
 
 	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
+	dax_set_mapping(vmf, *pfn, fault_size);
+
 	return vmf_insert_mixed(vmf->vma, vmf->address, *pfn);
 }
 
@@ -161,6 +163,8 @@ static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
 
 	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
+	dax_set_mapping(vmf, *pfn, fault_size);
+
 	return vmf_insert_pfn_pmd(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
 
@@ -203,6 +207,8 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
 
 	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
+	dax_set_mapping(vmf, *pfn, fault_size);
+
 	return vmf_insert_pfn_pud(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
 #else
@@ -245,8 +251,6 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 		rc = VM_FAULT_SIGBUS;
 	}
 
-	if (rc == VM_FAULT_NOPAGE)
-		dax_set_mapping(vmf, pfn, fault_size);
 	dax_read_unlock(id);
 
 	return rc;
-- 
2.17.2

