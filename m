Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6F12CAB
	for <nvdimm@lists.linux.dev>; Thu,  2 Dec 2021 20:45:10 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2KOcDU015208;
	Thu, 2 Dec 2021 20:44:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=6K3dV9kT1TePMQHNEat9vbBQo8pBmM+K6iChvFRe6Gk=;
 b=Xi7KJNmxo1crFiDcsY8aGpK61J+x47wkOqGycsAegfgY4xWCS7eVOOwOjG9RqQQqY7Vs
 GnJNvftl6Jglac6cqwBVK62lpd+NUB1BbdGTeNqRvsj9JDrpkNBvwiv1puD9tSJGapQK
 GG0MP+4Sb/zOMNGPa1rcvRhCeODb0AY0FZGBFre77lkrvTSn7drcsR5LUt7MWCOvoVtw
 PLObCv/R+0kraFs72vR6NzRlE9fAcFoVAleKmv/IX7Xe57VGJkxKbaIR4Zw157jOl2cb
 6KIUVsIYXy+aXXPvAEgAI0LnbLEwss/1rtWXI4YMIwwj9vGxyohoJpBykRMXkmGqMWtq Qg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3cp7t1twxf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Dec 2021 20:44:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B2KeWtP048001;
	Thu, 2 Dec 2021 20:44:58 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by userp3020.oracle.com with ESMTP id 3cke4ux0au-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Dec 2021 20:44:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gSmkuPxfM5793QFxag5da/y5LkdiWFJsA2jHY+vPwjdU42Bh4kcxG8+I3jfIdNW4lF3jVYvNf0/adh1lTQe/fS96UTJbmWiqKC/mgeuhh3Xm63kQ9uqzmCYniYgv1AIpVMe+kvFnhgCBPIblSpqKirTHtp9GgNg2DKKDgIG/yqWXB9GXqSIerBzB92M+hnXBKpHw7/1urMzO0feYXpCPYS6ePj//ZPwLaxfBuTqBoy2pv7XqmTtRE/1R4VClx+yHSSo5mQcG8F40U+Pc34ebgrz97o0CsbRTf1P5V5799nApJ6FomggEjie5H5uTD7A3LtGURc99Xdz7S6i9oXu+qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6K3dV9kT1TePMQHNEat9vbBQo8pBmM+K6iChvFRe6Gk=;
 b=gNJ3CN19RAMYb7cE21+3xLUrzMKYSplm1x5gj+S2f7v/4LyHDWXByJLXe/RnQGtwgLztt6Rsp6cd1Rgmogz2dZd6HlzCKIF1sxfsJQtRaZuEWuFpa80JvaKRC4Pz92umC857KBW1iPBNgJAwef8+I8dg6PosLws7Y+y9MgkCbszZozZclT06PYq763vqJfYa1y4Fj96yOwMYOHKV5uxMdarVoj7u89YzhBKvZ9ylg4eiL+/Ce4V4g0q527/7vvVBYpu5DnA0Il1Ei+8g8dV99Cr7NI+evRqFiOuOgiBYnrtIB/i1k48Z8I3QcQCModcens455FGT2U7/AwLcTRjZiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6K3dV9kT1TePMQHNEat9vbBQo8pBmM+K6iChvFRe6Gk=;
 b=LJLPFt09CRR8H/a29N2Hk/ZFQ/7PT1BkJvbkVzh2UGQI1qcSXbX7fYnd3/VqCrW0tSyAhS/Y38s+o7aO5wA0u2yglVyP+C0HgRPhwc96QYJ9uHepVZIE90b9ia+glHm9QCwoKFMqLsxaNJiBz98iiRGvYpIMxR4p9jPnNY66/0o=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4303.namprd10.prod.outlook.com (2603:10b6:208:1d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.28; Thu, 2 Dec
 2021 20:44:56 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09%5]) with mapi id 15.20.4755.016; Thu, 2 Dec 2021
 20:44:56 +0000
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
Subject: [PATCH v7 05/11] device-dax: use ALIGN() for determining pgoff
Date: Thu,  2 Dec 2021 20:44:16 +0000
Message-Id: <20211202204422.26777-6-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.24) by AM0PR10CA0049.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4755.16 via Frontend Transport; Thu, 2 Dec 2021 20:44:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b90bf18c-8047-4e56-f430-08d9b5d4992e
X-MS-TrafficTypeDiagnostic: MN2PR10MB4303:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB43031A7B3CA5C7F5A01A579FBB699@MN2PR10MB4303.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	YssDo4XUxb7L4+f+ZTrgwZTxGwl1TISK8myI5MuoFn1kdxEk8oi+PvEgE4atWmWTdy0qyQNEd9+Eg4cIwjqG9ZWSgTBHo4vbYJg5UsVqEpuRZlSaWTBmIKhQKoT5zJXWKvmIffQ0o/tskqLEO/jXCS8O284m0zxuQJwx/cQNQYxDr/jYyVJglWuj97vRd8qm7r2HA62xGVtNx5gLYGmYqtro2v2RgT/97yDt3F07ZhOsARp0HP4sKbq2DjJajIHItonysnUyxYHf+XqH3itEPF9V2AwGe6FhBS5fsTZE1Dyfooe5hQtDPfsCbg8qaPxNO5omZ6NOPu2wjh0wCNLoEhuBILO+MfGuedi8xCLSjvTZWcBarSnAMiT32vV7GJCTr+r6ndk0moozbPIc86RlecUNvDLCZZtHeiCHQLhjqPePkZoeeHucovjdwxqLri57vfDZgrZ+snyx0lxhIixH3WzN9S16hK7Rqwpmms91zd3OnaxdO3U7muUX+CgZh299L+nIBCGisTz4SKXI/kxS+qd9w9HN2hN7hfx7V60RLn3uZfxvnxEBmwpNsDGYxc2O5FH5mSKugfDryZNb460h3rJzlFN0kICIv5pXwAruV2KL9WdOE8PN9mjXyCiEtfb6pdZHuX39U0E95wuQ9lecOKzJ8oDeS/oRYvBRmpevyXjvVVJ92gjZja2WpOAALAmP5Db+LK38fzVt7wHEvkzUDQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(6666004)(316002)(1076003)(8676002)(103116003)(66946007)(66476007)(83380400001)(66556008)(26005)(8936002)(54906003)(956004)(4326008)(4744005)(186003)(107886003)(2616005)(508600001)(7696005)(5660300002)(52116002)(6486002)(86362001)(38350700002)(38100700002)(36756003)(7416002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?v3VWQa8Eun+JS8LZXyGfDTwn4RThTZElkWblrgulgwl8ItqqYMYjW1b97O11?=
 =?us-ascii?Q?RCjE8foJHhPHxd1rfJgiG02ekYv9196ccOSBorfNubYVDZgKGDrVg2+k9gQc?=
 =?us-ascii?Q?9pQEx5Qucsaff8l/BIXZF5o/vD75F57iGOH2NdzJREQoFBUafXLa0C1lCKHv?=
 =?us-ascii?Q?BQBWqzOSoE7FyAZsZDNr8d61Oei73ElL+EN5RyZtFN4aKCL4KjyHcU6n2XF+?=
 =?us-ascii?Q?3f9c6krQYn2YgtZGuK0AabjtDd+JWYtRlFq/Q68th6nZGQBnFrP5HEF2FfL4?=
 =?us-ascii?Q?LiCfhyJ0bX07pD06vJx+E1huQB1D4jz/FjfGGPxyFRv2I0JXSIBHNa05hHbg?=
 =?us-ascii?Q?Vj2PMb7p00vLOydzsSiZuEOZGWqUUrIEZR2U6uOFXORnTjJT+Z4uo5xp19Vc?=
 =?us-ascii?Q?DKp/f8EVpSL/Ccg32/KJXpwDLBQP8pL22+91iv2V1DtouUhxECj6UQWTLbQN?=
 =?us-ascii?Q?VVtDnLVeuE9STeg1XMmCmM2MtkN4neawz2/EwfD5wAhWs2LxHUWALLM5iGmr?=
 =?us-ascii?Q?VWqtbJ8768zxTePK7GbzzwMPfadnwMX00DRw3Md9YUvg1zPASsQ+TZRLfjkk?=
 =?us-ascii?Q?HgNpWUn9XcfYZpMAqKW5HA3WLceDPq28Djc4IK5KEfTlOW/DmVR9bbGaPSnd?=
 =?us-ascii?Q?az20BgrNr+UyBu9ZZd0zwKNdt1Q+CayqMMhWjHtWXRYbInw14IBwVJWx+jZJ?=
 =?us-ascii?Q?yOBLU0ojdRZcPc9c3AsDStGGbX4RczgbstXfCGmzgqZ5sChkTXXGobcrZJDg?=
 =?us-ascii?Q?xSfR4zW7wD8LE7/C69d3QO1Tmawca3I8uUUo6QYO+nvbC09Rd10l4nKkFdnA?=
 =?us-ascii?Q?8ze8NfOYM7feksxaouLe5vF87xNmvbhhmTTDgTRIEbDloGQX0+vu71HnwtXy?=
 =?us-ascii?Q?tiTInl5YBK6EB4417JS+Q8xjMZ0MYifTekBCuXPiBkmCvhRFYFDdrbiA4hLO?=
 =?us-ascii?Q?o2BwYRxuDfNLqISO9/1Ej7op8KpNJsX3+e2/jtUYy6YgV06tP2X8/2fVaUh1?=
 =?us-ascii?Q?/WsAPF2ygm/1tpSFxlBKEby5dkFKN+XAZsUWaAN13PFqxMby/WFhOH75Rsi0?=
 =?us-ascii?Q?KVZTxs+zqD+eUNwSWBdICZQoXVsnTZkUtJ1wR1JOmtozlH1XyXZBM17nH2P6?=
 =?us-ascii?Q?opSralR/ghPNXL7o8woFiKqSxNvI9CGt5co7Q8OmGhN0Awgqh8RoVrSQ48Pc?=
 =?us-ascii?Q?K5Zk5a/SnizRgkELaarOIX/ffu83hOiiObI56PcJmXZQ4TX6TWOlAP0zA5Fq?=
 =?us-ascii?Q?67+W2nDUC727AgyzGqfcFuJeoKsW2Kbz9ExDMfKwhBhvSK/xSPYCYUN4vOl0?=
 =?us-ascii?Q?8WVT4RAhITSxlGt9VsBIOgdqYnMoHet9yy5GMLM1ilUo3DG8O19kN/C4wLSh?=
 =?us-ascii?Q?bXHaFxcQZxYdVUZzcKnREwHGQ6kE3gEaWRU409kmxMihWhvmzDs6bw0It8o4?=
 =?us-ascii?Q?La5G0CwILb9BCmrwKZQ0jyRjpo2SXb1RS2yGqi5kizX3Ca2dVPMciQJddQqX?=
 =?us-ascii?Q?6wf4dEyWfPWcD5/tuFxC5aE9HD8s5Uk8NnNQmTT9RlE4iupxyBagWCcfGDXa?=
 =?us-ascii?Q?s6f1k5MEicJv/0G4FS4/BAuCcejbZ91uu6/Sa2hZZRc91ur3N2KS5WQQG3sQ?=
 =?us-ascii?Q?GpGvjOqiixdtgDIAo13f7XMn8cxIh2mvc9g1+hvkfQZ6lZZ4b72dbc+H+hbR?=
 =?us-ascii?Q?4WyY2Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b90bf18c-8047-4e56-f430-08d9b5d4992e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 20:44:56.1082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BOuyGUHi4jtgiXZOQ0Z4US65MKXqOyH5MD6fc5nPnYEJqUPjQcyeL14FS2iTVdaOVQywShd/0lxfh8xKsbpGuYT6TsKTdIAnsmJR4/hFb08=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4303
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10186 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112020131
X-Proofpoint-ORIG-GUID: TD0OPE3nQ8KJv1Ld3lSlGytrrwtVD-oM
X-Proofpoint-GUID: TD0OPE3nQ8KJv1Ld3lSlGytrrwtVD-oM

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
2.17.2

