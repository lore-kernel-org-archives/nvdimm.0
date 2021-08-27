Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31ADB3FC3
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 14:59:25 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RDWMp0015214;
	Fri, 27 Aug 2021 14:58:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=wu8oqghcawDSfhMyWRMS/wTgRRsj91HDqE16jmGF5bo=;
 b=m858ETkKS6/bY3Ep/xON7A/rDutmLHHlilZzLLucQdRkOEaDyeYNspmEueb5IT0umSNq
 zH5k2o20CUSTQHU0sykD1p47ZX5yZ1vbLtcMp3IsHJ6562DmX09F4H15yw+lHCdmXde9
 47fti6+rN6M2Of4piyHvxHeUV9r89ZQ0m5FtUpObcngLuakI4L5KHXYJk15Fe4lfO03q
 FtTZkRxFm6xmHqbH8xYdsjFBQc+HMkHzVbbEW8cEfpbsK/T/MPJVjQOsmt+lUsTSoWD1
 go3oAq5ceJ8M9Y9ihk945KK/eEdix8IrIkChAzspa0nQGegl2nMSvXKAfchRRBFz8P9S cg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=wu8oqghcawDSfhMyWRMS/wTgRRsj91HDqE16jmGF5bo=;
 b=uEZE07Bod4DC+iC2PIQ8nO5PgtN/D9flGh3eeRPCHj9mujGOp9L/+hj2Aw4golQM0R9s
 q+5Q01ONkcx5nchiEIL+iSUlDBAcNo8rMtYmaHh+N6t4IPp+grrJaWQjAWjIK4W0gvJY
 ee32PuTVUGpobWMlR4nTjIa/iGDr5y0uNX7TWj9RfH1kFdf8N3P01OiVPpZ+c3BaMH5H
 OzO8DyxegOqo8YtnFJo+CdccbxKJlLHKZuwmECFq1a7yDxh5hbc+WqMwPbJkHFF5P88k
 S8SpunFVHkF4qlY2FA2Lso/9WSvUDn6ZHHQtGBzQsnhpOQrxZw/+vUA798TsrMCUYlHr 6Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ap4ekuwqf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:58:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17REpYWO152590;
	Fri, 27 Aug 2021 14:58:57 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by aserp3030.oracle.com with ESMTP id 3ajqhmq1eb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:58:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PX8v6Tzz2jvjCFnMbTyaI2/sIfpv8x4m3jx+An2j/dZkqcR63DMpIjaYtlb9fP5Pu8Q5YLbn2QW1v2/Dy4GRNvLsk2S1GLGU8N+bD4uSXaOO04N8Kibv/JXEn0rhv8T+DikPteCGUoBWhozRMvYyV/lgef828OozKCmg1yG3nc0t5PSSDZTRhLCa82k4YDbFiXrsnS3Wnx0mlOmySAovojolLr3IlbYIXl88VDve1jJZU0r+vPDRxCKuKtd0QGAY2igRMEyZhCOZPbyMg4ssFNms1ssqK3YyPNV8C7ZsJyYXeQK5Tqkw8+qTch0eOEiTOG0alkYf6Sgt76AeXdmshQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wu8oqghcawDSfhMyWRMS/wTgRRsj91HDqE16jmGF5bo=;
 b=GHV/PgCdenLXaV6gM3E2GvbefhEWpCSn6BML1/8s+z2qqdFY/qpY9RNQHcXi3rXNLV1HlONEDUWJ/1UtjIijUxRoEvA51HrrENkd3JP3AiNuxItaHgJyqq4jLxqdQrw7p/R3oXgaj+mGTWmQ0OsXYiP1dAyXxhMjBXKEhO7XNzQz9zOzQys609PpT+GTxIdgRNkfVOrIA/dVkcdVTKqV+XMpqO0hAMIJCK8fAor1BH8L2WKTNP3aqM9l3Gk/BKXp6sZ+0lvDKONbwO+62R5RfoqCK3tXZrewlu03B4tMaUeRg/DbXdutxKDC/2Jhpx+ZssygwiVNB5fLAVisddVmsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wu8oqghcawDSfhMyWRMS/wTgRRsj91HDqE16jmGF5bo=;
 b=N1anZRqZtM0u9YmO+W4IPLBW7xbLsgKEsVBshcux70RuDmTDqncji6uTaCwHp8y4X3JTUL7xhOmNpwo77fWrDA7pU9Dc7E12QtVE09b9aINrbZv18+CvFlDXTPayFr0PBhhKk9QWLfSMv/BfI+eYhf7RUL66s2Z7MMouVSdT0i8=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5025.namprd10.prod.outlook.com (2603:10b6:208:30d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Fri, 27 Aug
 2021 14:58:55 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198%5]) with mapi id 15.20.4457.020; Fri, 27 Aug 2021
 14:58:55 +0000
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
Subject: [PATCH v4 05/14] device-dax: use ALIGN() for determining pgoff
Date: Fri, 27 Aug 2021 15:58:10 +0100
Message-Id: <20210827145819.16471-6-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.8) by LO4P123CA0443.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a9::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4457.20 via Frontend Transport; Fri, 27 Aug 2021 14:58:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee86bfcf-a81e-4212-a117-08d9696b30c2
X-MS-TrafficTypeDiagnostic: BLAPR10MB5025:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB502534A884482FC4198B40C2BBC89@BLAPR10MB5025.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	9vzTNOlPea6nBL40OQFP94KLWLle2UmNZVC0dcyhgFI1gqpjVgwIaWTrV3oyQ4gYG/uMLii2Pds2fTRQZzBhH0o670HRMwSE4ukF5KwoNGLpYqlB1e4VXF8TE/2u5Xki8pyfmseTIFzyGOQU50/j2mlItOPPfm3AFbovLQRUvtfQf+uGWMkNL/NJnWbLNxWAH5gnwNb4fc9Xxyq36fzQineRTgdv9C+DV9w+1CaNnnWtkRgd5Jfn/tWS2QXpSdPQHdddzfvP9H4OOiU0KjvVcyNvYG/6vrQEgywsNtuOOuMqNvOF4YtFXmz+EfTy6YUIqFKbg2XwYygrZIFd1iK/O8nSlqWOMlozUn6qPhq/3CP65K6Hxy+52XZoK/nWkjiTNn7AicQILl8gyvskkw4jZVjrbp7IE0rd8TONIa+gyA55iFRyuRuO1ce+V5S4USEqQbe9w+b71lKhpTVbTzzTPCVBxAhg0JG392qlaH6Bhrcb4Es+7+s8U7PkVTRc/uuWoUdYp1qNF14ZYXYXWskUJs2Qcfuw2zkci8oodqDzXrRQthZHlGR8HYSLJkjT1pYHla0o1hhcvif70d8kDW8tXKxr4B4NDbmcSRz0Q3FMr5FexsmoeBxNDdeJWVK0/WQyyMH/bYZVbGt1F2XKhdAJ5wmb6tswgTVEGxfZEpXSl2+wmZ1SNxXHPWCaLb1b7zcySoZzIVPF0SqEVgsgwEQ8sg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(508600001)(103116003)(66946007)(83380400001)(4744005)(66476007)(86362001)(54906003)(6916009)(6666004)(6486002)(2906002)(1076003)(107886003)(8676002)(186003)(4326008)(38350700002)(5660300002)(956004)(26005)(66556008)(52116002)(7696005)(8936002)(36756003)(2616005)(7416002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?8j4plPIs6OqwbCGm1x1dFLAlUo2rK66/SySEqHRX9D+D5SwjWDZyC2mDOHgN?=
 =?us-ascii?Q?UZBDngBBpHlDmGGH8AOOHlzZ5pG6OOKB66HkmQbDWdpr8UQYgGATN6jm1Td2?=
 =?us-ascii?Q?cFfQNWeENsqW39m+dSF8g5xM9vXeJhkYJoxuXjkxQDnseduFQ6gYN4t7wqAX?=
 =?us-ascii?Q?n/MJ5YZ8yPDRuDlgObFpwpL4BqSzbdcQL4ldsk0t9vhkvHkNBmYJlnI+TtIL?=
 =?us-ascii?Q?lyQAEtBsILzpAkxlBy/OR/qK0UJnsa2Oxer4VNIcau00ojApO7YIBsF7v95F?=
 =?us-ascii?Q?zx+uWhrtMv2yfMmnGYCUGuM4Y3oDy6J7DH8MTnH29UjsEeD3ozZnIZvC1AW2?=
 =?us-ascii?Q?30s63SZSPZcWSol+BOE5H1dmwR6i8yXX8vlPMvVrl9E9MvoZOExSf5Mq3HQG?=
 =?us-ascii?Q?FnOYXmcw24x0Tb4O910gqLKzgyHWBYY1i/8hBERc7AkLnbecWq2k+j62lQfa?=
 =?us-ascii?Q?Nj2oHvNCMhK3RO7tFpJI9kKkQzndDOWhCfO3KfUsMyu3Hd7Sq21eC/KADZNZ?=
 =?us-ascii?Q?4+Ww13MrHjchkkwzQqL0J1lxIbiTD3B5iD5jiXyRPWPlguuJJajivXHCtPNz?=
 =?us-ascii?Q?wHB8+MOsIp73NYQnAU70pjZ/vvvV29LTtIrzEG3Yvke9dDsiOIlYxpXwQ0MV?=
 =?us-ascii?Q?BKXcZgMy9VVtpAtsRkE+eExlQfN65mXcEeA9/+bEYmZA+Ho3EKo33UU5ZYUW?=
 =?us-ascii?Q?KPqavmrZjvfJtTbUiWGZUaP3JS+xG5sgccy0bEqh9k7QVbEBzJ2DrixUuqpU?=
 =?us-ascii?Q?XPjExods4Msr7Qn9cfj0/llHDZPuROJ4PZ/7BnEc3Ar+UEkhwn1pgRS0UHfC?=
 =?us-ascii?Q?raRuP4yDwkE8Uo8WH3Q4KgClTXURV9sm1kQ93NsDYiI5E9054obd8XdzVcdl?=
 =?us-ascii?Q?QEkYXBZOk+sOLMgYx3p+b3m1CRN6NjjjFQlTNNiGR6kTOcncx/nrkwnlEgES?=
 =?us-ascii?Q?Ey3Wy3LOJFVIRtDlVOpj+JLCfoAcAwoJQbmLZxN8fiC1CltTVL2/Mk7Hal5v?=
 =?us-ascii?Q?/UInS6ynIbrqJSa7uHOI6DM8manz3faydgXplTLYPUxoRPAjB0LBFOPhmpe0?=
 =?us-ascii?Q?WTFqdcQ3jEVNnNI/PM+PF4pMIlb6th4EgAhQfu+jHiaQ5FF9ETtZQg/1KcuB?=
 =?us-ascii?Q?U5cRSqGr1KHKdQ6papQMS0OV4kkPz7XwZ3S7f86ROxj1E+t5oEDfZOe+8yL7?=
 =?us-ascii?Q?Lrl9AQXjGIgqgFPeQDTzCukb8NU/2gBUlhxFIULHzM1IX2/5jJdm5UErvy/N?=
 =?us-ascii?Q?LhoHB3EMWXzHZ1515Qclotp2aJfYN1CmOxRl5pdd6XoTnBiWNETc7SoOKnTI?=
 =?us-ascii?Q?5zK7iVDUukul9uN1lX1O12x4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee86bfcf-a81e-4212-a117-08d9696b30c2
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 14:58:55.2942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GYQ5upL47REGuuVNzIIP+feG2qJjZUBMO6CJ6NHSpC7uhc5iD7QS0IBnTlh4BMLWSuADbukN1xPxBvUbv3pftaacM8tvca5iRU6sKuQOA2c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5025
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270092
X-Proofpoint-GUID: k2aCWWn_NvuxwQTuNKSh09KgxSKpSZST
X-Proofpoint-ORIG-GUID: k2aCWWn_NvuxwQTuNKSh09KgxSKpSZST

Rather than calculating @pgoff manually, switch to ALIGN() instead.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index dd8222a42808..0b82159b3564 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -234,8 +234,8 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 		 * mapped. No need to consider the zero page, or racing
 		 * conflicting mappings.
 		 */
-		pgoff = linear_page_index(vmf->vma, vmf->address
-				& ~(fault_size - 1));
+		pgoff = linear_page_index(vmf->vma,
+				ALIGN(vmf->address, fault_size));
 		for (i = 0; i < fault_size / PAGE_SIZE; i++) {
 			struct page *page;
 
-- 
2.17.1

