Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7E02CAE
	for <nvdimm@lists.linux.dev>; Thu,  2 Dec 2021 20:45:08 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2KP5m6019810;
	Thu, 2 Dec 2021 20:45:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=MA4VecHh0l8AWrW9XudQugjpfPgplinZmvX3+fimGXA=;
 b=B+6YfW54Kau7Ix3qTX6/WB/EqPVAvOMWnlTQaoncZadSRWOMU8wAKISg7LL3umUxSwNh
 Ap9MXRzmwAkQVJJpyZXX6V/kzYqvjr4bESAKAymfm7848M9DwBwDf+CopCMwGkhjJvGz
 uGuos46WWqinX9Hfsbbs6yIITc6KArzobrVgm9g61iaLPG9wiK0HzqM4pNZS8SHbx6XP
 Xlpg/6gap/yTxPWtVKWR1gdqh+5TL46clwJolvhGkvGG7NXdyWXQn1ZSjcrh321a037C
 CdcB45IHr7MyS7WoiuJi20FeY9OOEqTd63KOzQ6k98Gl7RUFjUdel4Rgk1v9xD6Gg+Cp rQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3cp7weud4r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Dec 2021 20:45:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B2Kfo2K167590;
	Thu, 2 Dec 2021 20:45:01 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by aserp3020.oracle.com with ESMTP id 3cnhvhc0ju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Dec 2021 20:45:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X9UZp+uR7FGVD30Xskre6Tqgf+6/OrS3ffSMVjVwDoZym16JN05LMasDg6oLehQ54UHwZZAgjbNQM3LIxizF6kJhfIa2LOyILGdeh+48YQEwq16DFDe7cpZmeaulB4oBowfeOz66GKO2TpAp7IzC1RILZiD9l4QowN6wYoNgdUknCzuhcLpCe/w7Jvnnln71g4ti5/l6MR6DXKimbkY7UEuVYX2RBxmBFWEVcqurVizNn7jjy7iURvJ9/xtJCutM+U1ujZ7zz/+5O6DTh+uSdBOF0gf7Xgb6l0JU+gQdds1+8fupHviGyyO7GQOVStHVx1WAhvS3DJbl6orcO8w2+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MA4VecHh0l8AWrW9XudQugjpfPgplinZmvX3+fimGXA=;
 b=A1DykunFLZSfhGCjTjR+mToDC4gFN8zf8sVRge96QD8JXbDKGmvW+GqPNnhFoajI+qXWM8Rs3sZqx4X5taKb3bAUZxPmcmMx2GHjlNi1eUlVdBQB2GUD+mlGqIw3q6aknKgV5mF0EXs4V6UqM3sYwI7JL3vk+lj0B4SlSgtwBslfuvajJQtLaFu6RxEWiMWRAd6vicy/5CcimCdVY+rMHZL1q1wpbaOruwgB9ja3VOHfFvKh/8y5OscLSjCeMRIhmJ/3isrQQ1uWq5jvXLUQSj5Zcrw8Y3yMzzVfObDP3dhjfgRVN5B5cCSvtAlCHNSr14ZS0ESK++8OMixS89kGAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MA4VecHh0l8AWrW9XudQugjpfPgplinZmvX3+fimGXA=;
 b=tmKvyBTN+0XSwoh8jVYdTnJ+EiDsc8uIe6ovoqEfySUTpcq4V9zI7vkJp+jadr/nCk3Mq6ndmqD/s3iCNB/gp/n12IuIq9wQdOA3MtohuvvoxiZ2Pt4/2oXByjiHhMx5RAY0e1s37C68MfpnlQqVq3EPx3IqmtNFBk0MYTgyKQo=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4351.namprd10.prod.outlook.com (2603:10b6:208:1d7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Thu, 2 Dec
 2021 20:44:59 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09%5]) with mapi id 15.20.4755.016; Thu, 2 Dec 2021
 20:44:59 +0000
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
Subject: [PATCH v7 06/11] device-dax: use struct_size()
Date: Thu,  2 Dec 2021 20:44:17 +0000
Message-Id: <20211202204422.26777-7-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.24) by AM0PR10CA0049.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4755.16 via Frontend Transport; Thu, 2 Dec 2021 20:44:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7bc49543-6639-4ed2-12f1-08d9b5d49b43
X-MS-TrafficTypeDiagnostic: MN2PR10MB4351:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB435152B563140D561F538CDABB699@MN2PR10MB4351.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	4618BapZPe2IvN1NhVifYT7ysbZBbC7nSnO/56RYoHYNzNk8vwBDxYsyX1OKFm6t/2A0mGmjXBqBL+xwH0wS+5G/Ui27Ml3+ReHs7B1f+0XWQ7GUkpNWH9ep6yIaTGws1XsguGpHe0pBvdtPArVx8g9YPO7I2GmVMh5ZinPaQx4Nd36splvKSRoGJlJ5/HXo2iFUig3wTD8S+SGj4ohsAJGrwxqyGggdCaNWoqspIoGJdohGxbxPqluk88NisfhZegJN1zEHBjH9O+mbt6I0dTRULoA7WgRj9Sp7ffcToj63rSAeONWd9lId0gufKOnLtuSa49DwVbcbrqX3msm3acx2bzhzpQvnsFO0PE55v6dm6Vfi+AQZvNVzb/x2fZLX5v7gItYSOFSsfV2acfOQ1BUKHIhT8Q8kdBDGLWRRZHLW/kGh+l1VEpqYxciWKAOgj1iYOvKW3RoNpLgdUMWmHIFzYU9knXXH2LNYKZES+t02/sMliqreS8nk+dmtmLJcHQvtVRrme8wY/dHE/CmFRhakKS7agK7qdAmt6PGN6QHU0Ijilj97rSlQpTOj9OBtrGiG/6NVRtH2BBrFxpdNWxUlAZnbtC1wzuLs6b51XOh8yG3hKxx4DPtMxmHDM6YKE+vba+8TBjypDr30sxvYxbhjdTgfGRHjSHjqKc3a8u4tnid8J5aa6fdjmGgIKz72kVdELXQcJ/ViCUlkhyb8ug==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66476007)(66946007)(1076003)(7416002)(2616005)(6666004)(38350700002)(7696005)(186003)(8936002)(4744005)(956004)(4326008)(38100700002)(26005)(83380400001)(52116002)(103116003)(54906003)(107886003)(6486002)(36756003)(86362001)(316002)(8676002)(508600001)(5660300002)(2906002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?xss/65LKqzRk4DXbyVc1PDz2U8ZhRILieFG+dJbhf2Y1TH7O79yoQboeT3/O?=
 =?us-ascii?Q?QtevEHKmMhHqxHPJlkXohsQAj1bjTaM9Jy+Hj6BQTh/GL1tXQ3f1NGQyTqwd?=
 =?us-ascii?Q?KIGuJ1ozo/xV08E0Ch8LfPh9OhWxKmo9Ly9jMkmhqirGlRNhttS2vI1XEBDQ?=
 =?us-ascii?Q?hlJopAo5J1l3OK24GnDbmi1q09urhe9OH+4TuubKdZ9Jo+7IdrfRioMz+gCb?=
 =?us-ascii?Q?m4GWBts7N6wbEFIucH04GBjt+SBRjsdPLSbDLHcQxr3oBQ2k8lQl+wwKle2E?=
 =?us-ascii?Q?fmz59c4csNdVQbXJyqUcco4KJWFfX7kMojk+bbLE2jhmErnSCYmeyf6/q83Z?=
 =?us-ascii?Q?bbabZwf5mi6NfP7Sp+aFOOWtJ0wmU8p1EygZ2n0CLcQ4nTZxwI5z5NPREko7?=
 =?us-ascii?Q?DDY3uzKARajnbOfjppuMQ5akeOEl71vlQn0j3oGUH3bmsqE7SA1owUL9P7Sl?=
 =?us-ascii?Q?Czm6K8IRlllaL8hZeGocatDtsZ1PvGhMwbeEyOjT0FFOhQXj3oPXHgYZ7NDx?=
 =?us-ascii?Q?LHOq1NhjLOEvqFJcnCYmKwan0ObIuclvncSKMzIxNGP4HjN6eiN1AoNH+18c?=
 =?us-ascii?Q?7l7S0z4EkiE3ljjkSaVAkZqe4kDz6HxtkU4ndOWFOCJix1adlDJ2TlPi2jLC?=
 =?us-ascii?Q?GpiyqFFzo/5Tz2vbP1atBz2KWm+MmHH6g36vsdd1GVHazS4pYMQN9pMvPLeK?=
 =?us-ascii?Q?IeDxFLiR51mC0rjt+OUl0JeWwgs+BqPzUdtCRLXiyFdl2Yg28gK+ueXBtUv1?=
 =?us-ascii?Q?D1kSUK5qUAkzsfbcNAPxoiOQbReziPyXEs8NMcKXKNfXV/FunrKKe4aPZ0Zn?=
 =?us-ascii?Q?BZ2VK1Df+ChWunu+oNO1gLsE1donQz1M4vKzQElLu0yCd/eF+fo0kXwHnSuF?=
 =?us-ascii?Q?UcPdsMbytf5YL2XrT03V3ndurJGcP4CShWFHN5kVekeui30Y8i6FJY2nTs5b?=
 =?us-ascii?Q?WkWPbeeVEnuRIAmuXRT+lieYgqM5g3W618rB98vnVLJMBhxD3vRrEvekKY55?=
 =?us-ascii?Q?o+N+VqbpBd1n6OCGXxONyPdJfgiieIEW53VikCVGKM7sh+KBQrnMmzlvi6c+?=
 =?us-ascii?Q?DW259KTLNUikxOUFfkBsKyYH64mYS14zNXcFFm0W9pZdVvXgUuGE3G1cFEzu?=
 =?us-ascii?Q?DZsENwHp1Q2BWLh/GwLVl68G1Yrhux8+mH4z2A3yigWclx4w7aDOKA0hgUal?=
 =?us-ascii?Q?i5TyId8sqDZNBoIXkf2EsVlMltsEPWqfRb4fUfcY+HR32RE3aLhvM+2OJyXY?=
 =?us-ascii?Q?uAJGcOh7iB7fr4F23TiNPziin4TUOavrn1/EXtJVpJQrLRFBdgeE4PJ/DFy2?=
 =?us-ascii?Q?umqIHm/+cGhsdoFpz0fajixr6fqmK7n25PCLuOeX10eRwKfTqM7AV4B1XiQU?=
 =?us-ascii?Q?G4yf0Vme/IrRNvdGk2+ScUDLg/WgU4IUeusfIDO2fHeAiFxIr7J5RVQlnXxf?=
 =?us-ascii?Q?vTqLlCdjnhMPnIzV/uEcEz/k2TAeM9RsARXCRNQeBW/K5JgZRXi5ThxwlNnJ?=
 =?us-ascii?Q?orJOKGVyQNBk/prFY4MIXxCEXl/l43NPBX8/+ZXsNEBa8j2DjH7xB1ZSzzhK?=
 =?us-ascii?Q?FVZ6e8JEEyZLYvxiG0/W903Ng4EwTbRYuNioLyupTkMq/8VXXgtG+2h+KXrZ?=
 =?us-ascii?Q?tm71Esvg8QBDf3QNBxTkrJvdLGuxOlpvt1er9UeU5e0qNnxQfwbN+bz4NRi/?=
 =?us-ascii?Q?iWLPvw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bc49543-6639-4ed2-12f1-08d9b5d49b43
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 20:44:59.5943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VAsSx4rXbGIefmuTH9q4HqS5fK1IglMV+JcVzeSOw0P2dUbLCblbiqsrBT9r1vjwoP1WegwiGg51thEoNprYNypdm98Mz1hpCs3kagdNDkk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4351
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10186 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112020131
X-Proofpoint-ORIG-GUID: mClAZvXMFGCiHzrtVWlWpRhDK8bcS3MJ
X-Proofpoint-GUID: mClAZvXMFGCiHzrtVWlWpRhDK8bcS3MJ

Use the struct_size() helper for the size of a struct with variable array
member at the end, rather than manually calculating it.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/dax/device.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 0b82159b3564..038816b91af6 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -404,8 +404,9 @@ int dev_dax_probe(struct dev_dax *dev_dax)
 		return -EINVAL;
 
 	if (!pgmap) {
-		pgmap = devm_kzalloc(dev, sizeof(*pgmap) + sizeof(struct range)
-				* (dev_dax->nr_range - 1), GFP_KERNEL);
+		pgmap = devm_kzalloc(dev,
+                       struct_size(pgmap, ranges, dev_dax->nr_range - 1),
+                       GFP_KERNEL);
 		if (!pgmap)
 			return -ENOMEM;
 		pgmap->nr_range = dev_dax->nr_range;
-- 
2.17.2

