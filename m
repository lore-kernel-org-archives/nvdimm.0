Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7C12C82
	for <nvdimm@lists.linux.dev>; Fri, 12 Nov 2021 15:09:28 +0000 (UTC)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ACESmWJ007211;
	Fri, 12 Nov 2021 15:09:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=A0HEozXxStZ0eIcVZFkPdFIHA26rV61+onQuEltLdQg=;
 b=rDaZuA/8K1pVJ4Q9DUcFC2CmnC99CdD4l1dU64nhlIvDGJ37G+n+dscIxcq8ntuOMxoq
 Om71mhorEgvhii74PkeQAM2K16S72ZJdeYMQsVcwIEGujhZi+PuQfK8qP+wnDJgMUzNp
 NLB+UQJf4ZNy/2+GrVlbICFMxEuCG5evlVZlCdvL1SDd5o6XBSsQO1fb87HUqq75d+t2
 eU1vP8eqMNMLAuRY0EbyzXmVWzba/PnoNA81rUuQHFHlQHUpwgsrTjzAjKaUozffyo7N
 S5RFONLKBCKK9j5ulUpXF10GATSP/KGPj8wV1lPyF1TeHEx1Jy01zo6+Wm9CXhjnw74f TA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c9gvs2fd7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 15:09:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ACF6rPI055870;
	Fri, 12 Nov 2021 15:09:22 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2041.outbound.protection.outlook.com [104.47.57.41])
	by userp3020.oracle.com with ESMTP id 3c63fxpt2s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 15:09:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJA+k6rFEqCXZQfNYWrXzMsWYxG2sZ0NTfENnzMjUpIkrCQM90W29OmIjJFe3VbFJvixZJoimyhPAEJ4LRC1Ctkj/6CDmle1jQrvimWWDgeRhR/gP5+iTvSGyDg0UsKFXs59mqjoWe3t5Nwb2kjYKdFVnI76BFOCI8T8JH54F60RwbBfLRbHQ7Ubf38bLm/XZSKb0MMmiV6pCggSChAMrN030vUwAMIzzqpo6gzlKb8PQXU8+aC9lxrJwMT390TYCi3IXxEf/7qNONn2XDML1WDOFEVnUVBuBu+NpR7UmxGp7DNA1AEUn7WwtNvbTHV8jo1RUl9ytRIclzaUAwNDpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A0HEozXxStZ0eIcVZFkPdFIHA26rV61+onQuEltLdQg=;
 b=gohK6DyplEw7Zpz6M7XZjOfbBbXo3dUjrjlFdywvohAB7BMaj1YwUeIk82/r94v3HFk2hZWyn7MdKtCW/lYsXQNtLGS2drCiRjcEnxCYbJE8mbgubCaqOpkIbWuOKt+xsqQESTFRJLMZSrgghws/KufPgeeQc5gzwBq3tz0EpOxgjp7qacQgIkaqU3xjKgmXUxjQmJ/rrSXaCVjC6OhdQShapJH2oQD3wLtz0YWk1ynt/9mNF1Tx1IUYPOKrVBDLtzl3AAmAzKnTil1I8Oyy679B/x9WAESctIIW0HWt0adLpui1Xt4cBjmPON76vFyTLxdG0RwrjnUAArbTz3FGvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0HEozXxStZ0eIcVZFkPdFIHA26rV61+onQuEltLdQg=;
 b=fbjWatErfbSdXOEEBrb/uaMqwtikvHfiq5KygefpGx5EJerWuU0h82D/HR27XxKFyhix6loZfROBn+wJbj1CwuXA3ojKXfTNJMv9gFwSvEkETjCXS0D47bY119DdyHMo1N/LpJnmViir0sSIJ95Ya6bULTa/LmHxmHU3Pf8arXM=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4223.namprd10.prod.outlook.com (2603:10b6:208:1dd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.17; Fri, 12 Nov
 2021 15:09:20 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4669.016; Fri, 12 Nov 2021
 15:09:20 +0000
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
Subject: [PATCH v5 6/8] device-dax: use struct_size()
Date: Fri, 12 Nov 2021 16:08:22 +0100
Message-Id: <20211112150824.11028-7-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20211112150824.11028-1-joao.m.martins@oracle.com>
References: <20211112150824.11028-1-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.9) by AM3PR07CA0134.eurprd07.prod.outlook.com (2603:10a6:207:8::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4690.12 via Frontend Transport; Fri, 12 Nov 2021 15:09:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31d0da88-349d-42d8-aec5-08d9a5ee674e
X-MS-TrafficTypeDiagnostic: MN2PR10MB4223:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB42238036191216FA0048942BBB959@MN2PR10MB4223.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	agiRxy1mjafRIlqAE7R6jb6oucIL1k5NVy83I4bDQM/4/4Fh78h1/kb8tmyDWUUkkz9hqiBkhqR1bf0LW2JU+ophOuZUB1urBlpuYPW5yh/CbD6VprmFrTO4V5NgWEK6QbI+TNHa0hcl8vSxQz2DRNPbO6eYopB8fnLT3mI8J5ekuhTZRsmrOOgEW1g4Xajus4TTDeCggNra6EgT43uUWKKOyRmMHzlPeTvtKMAxvAqFu03obrHHMwza+lV1t1xup0DGLEhQByvdFXLbwKY7T6CAGThX1AtmyRFDlM1zyPoyw/VnElVP1ZHO2dnMCBhcEXxoMm3zva+UannZomjKd+EFllZJ+XwETSsMwuv50IAMKyuN3wEbcju1dGLF08qUxt2RPqXJDMP/U/1kOy6TjXovnVGOc91cUCa1rJCKKhsZmL23f6LGZeIfnang5ilhSEufBa4KYVEc/1Bbvmy/vMtTUIJVMgPyCS95qd5v4Amk/Gvy82C/6geEPjcEFN9nVY2hyczYuvF7vc0Dg+ooEOTZM+2oT4VRDBDx83PZID4FoLm/zcww7RtPeaKNRJ6bktH2J5ZxaesF48AxuN+Po55q9FpQFi2Jb7f612sWmLl+1vJKFkttQ1Z3D7eZa9ZnEn/KUJbVpyn+gqfcncwtEGceBBW/JGjJZ1fr/oiNg5cldSJBNzPgWG67hkkov372D9kbxCmVhWOWJbJ6oJXnWw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(5660300002)(2616005)(107886003)(2906002)(38350700002)(38100700002)(66946007)(6916009)(6486002)(66476007)(54906003)(1076003)(66556008)(6666004)(52116002)(4326008)(8936002)(86362001)(36756003)(103116003)(186003)(316002)(26005)(956004)(4744005)(83380400001)(508600001)(8676002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?HHbqmKjRPaGAKalNSCO9xaf2ue8PoXDNplou9J75dojlskW1VHQ/lm2ubKQp?=
 =?us-ascii?Q?tlo5DSei+r3mKmfbNntihyw1tNzHPrHmvYWk7/ybwJhvxn3jAiax4qEE33wc?=
 =?us-ascii?Q?8uN2XZj3UauFX0osiPZR5uazVloElosrlXPwqvTqhwVnC0LBChi7TELQ7zjn?=
 =?us-ascii?Q?t+4HfjTTMbE/74yZpet6Q+jt6CMPMOkqfOcwmCW1SZwUJRJwAP+MZTzsllDa?=
 =?us-ascii?Q?XDUgbSjK0IDYl46uqt+0887rpuj9IK3iJsxOZFJmM8XqdY5TL4xy9L5Cg0f7?=
 =?us-ascii?Q?qUFE37eu/g4pMv1tyGtxMSU7HfbyUBNGwTZ7mrj+JhYV39WgqoWivxfI0r9C?=
 =?us-ascii?Q?PJbnCbKadeVx2tIUHYXgyvYL7Wk3jU3TQemSNa+PCqpiJBjfTdc52z9Hy7HY?=
 =?us-ascii?Q?NurRYi8LUO3D2bRwC0oFboqwjUmgn37U1QvfLce24mNwaxOWbWVNxQOuyw/W?=
 =?us-ascii?Q?4m4rMBRHCor6je3bmXgRH+89cuvnu8quiWffSTo9qUtmJltGBbh9MGd9kT3a?=
 =?us-ascii?Q?D7JHj45LDLGpYU/zfHuFOtdGefBfWwClkP30hDL0JEok2Qq/gbPzUwi+oAiX?=
 =?us-ascii?Q?u7mHy+qRbZt+hpJmmpDu/d7A0KgnQUanObixzaC8Uz7yGZG4mC91Yy3iZkln?=
 =?us-ascii?Q?3N5HKP7/S2+QObyiGT1WHtInOmrXCAsgtQw4RBtsW4+4D9TPgvFm+ljhe5qA?=
 =?us-ascii?Q?JPwSZ0vcrqfdK4fOeW8IcDYYHsPB+5lSDqRLpXkwwvn3EopVOAKSnSvEI+F7?=
 =?us-ascii?Q?4FL3lTzJh3SvJ2bBgziqhzKQ7wt92dK7nCcHTHjJsY2G0Ok6+/QqIdPOoPtZ?=
 =?us-ascii?Q?VPp/OfPfFGu9rU7mNSPPNyQsrS7aVXVAFh8+Bhmwh71/Qj+tv+Xa6S8/7/YY?=
 =?us-ascii?Q?HPv1k4zZvxxAe5g3mi9NzVa0iOmO4NDJyAui4F6ZOEi0O9gNtt9CAcHwYFth?=
 =?us-ascii?Q?BSdg26cmWSHO+WtzOWEXAvRaOxPlMbhBNBXldOhyMyMB6fWQsw+LdkgTi++n?=
 =?us-ascii?Q?CuTfBSVbt9PDfttfEcYSPFD47ywX0D176/TGH0D4wDaNXtzg/NPX3nQ41cY5?=
 =?us-ascii?Q?jwf8ccibuFWRMK1Qq2pyOCMgq70y9C0RQyuuTYiDp6pHPSV9s1/rOe8+en2K?=
 =?us-ascii?Q?Mx+p6s2N4vx9TE/ORLhAVvcjWks/DmbCLwV1REb6xxk0eiM2MWF86N5DpKvk?=
 =?us-ascii?Q?vylH5i33KebpdPKKyoR6wxKkvTdf43M8Fqtrujtm4IRdDFGPunmrtKWBBGLs?=
 =?us-ascii?Q?jRCzlGWJX/YQTukY1neCN0XAXcNK9ILAGo3i69g/glBbUdQPpJKjxd9Lp3Mu?=
 =?us-ascii?Q?2S/GbfskcBkUVmmgCCybXZB2TWgiOcPSAR8AVkir9lAp64lpuEo9ptSkoaEH?=
 =?us-ascii?Q?Kbc3Z7Qqeb/G6kl31g2y2J7op4VSzhYEG1Ep5E5bN1Bl2LBoF2f+8zTQooqU?=
 =?us-ascii?Q?GdIQMBNR3eufXMPre052UXZtitLY2TvYbrDqHQ4UKx6CgIUbaC4Zt8HLJH3B?=
 =?us-ascii?Q?Px959NaWi1msRtMI6PXyZcXerJQRFvoX2WJPa3GmuKYkZULzFLGQgPno8J2Y?=
 =?us-ascii?Q?AseEzkdknmts+CwBJOfx45zwN7EX8uh9JebTEMquS23BxElwlKM3zF8LZpNa?=
 =?us-ascii?Q?plbYjx4H0oIHHYBmmp5XBUVwZJkPzGOKnr7j6hnrUJffTyi8BWuIXSLBwr/Y?=
 =?us-ascii?Q?YwoPlw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31d0da88-349d-42d8-aec5-08d9a5ee674e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 15:09:20.7856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3FsxOSjWHaO4nlt8gv7Pi+AZ7YYrQzeAfRQJ8ubEpDu02Z4Sv9v0t2xjKoN31k34LAO3GRtKqMEBxFZ5ebRIbXWurGrgRP4mucJ2KiG4c8s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4223
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10165 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 bulkscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111120087
X-Proofpoint-GUID: a3weCfMS9cwz878PgOtF95JnMNhkMlWQ
X-Proofpoint-ORIG-GUID: a3weCfMS9cwz878PgOtF95JnMNhkMlWQ

Use the struct_size() helper for the size of a struct with variable array
member at the end, rather than manually calculating it.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/dax/device.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 0b82159b3564..d6796a3115a6 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -404,8 +404,9 @@ int dev_dax_probe(struct dev_dax *dev_dax)
 		return -EINVAL;
 
 	if (!pgmap) {
-		pgmap = devm_kzalloc(dev, sizeof(*pgmap) + sizeof(struct range)
-				* (dev_dax->nr_range - 1), GFP_KERNEL);
+		pgmap = devm_kzalloc(
+                       dev, struct_size(pgmap, ranges, dev_dax->nr_range - 1),
+                       GFP_KERNEL);
 		if (!pgmap)
 			return -ENOMEM;
 		pgmap->nr_range = dev_dax->nr_range;
-- 
2.17.2

