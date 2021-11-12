Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F892C93
	for <nvdimm@lists.linux.dev>; Fri, 12 Nov 2021 15:09:28 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ACEeV4L005374;
	Fri, 12 Nov 2021 15:09:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=6K3dV9kT1TePMQHNEat9vbBQo8pBmM+K6iChvFRe6Gk=;
 b=X4rsohgvpwKbYk45fF9eYWadE/tfrlGhd8HDj1/mZI5K2pLPu5N7VBgg8a9O2mnPWs0j
 EbaneeEmylB+vTWBjmTLlTd9F4X5vKkVW3pktmwAUk1fGmolbe6tV5k4Pn26FtA9fgzU
 jLzUFqDiMYV0B7imRfBYm/ke226+ILLr8d1568cHDsiRKAwmF7MXUvJefnELH2dCzjsr
 ulyGFhc1chvTewN4FOaNLAE2di5PjlxFi+PEAC74TufMH89kynK4Jz0OuMy0DuPIyMWp
 0BKWoOz4Q9+nHdVDS57JIHan1cpUetS0pPE9a4EIwwC0p91cWHuv7FT8acyHc6s5kCo6 4w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c9ruc8k06-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 15:09:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ACF5wiD196345;
	Fri, 12 Nov 2021 15:09:19 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2043.outbound.protection.outlook.com [104.47.57.43])
	by userp3030.oracle.com with ESMTP id 3c842f8xn2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 15:09:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZWw6Shegvz6GfqqCyc7hvigeiWrB5yzvSmVCyYDpflpGAXos8LgwVHmY8B81kxD6yPuHSDFuL8qqHcgMQ9+FTS7TSPjbG3cpU/8lpJ6tPuoYtqosJ30ieW/F+M/pCS9vCOaL5cbkDroZPpp8txenp+gx5NPBYL4l8E5acE5h/AR8kunnBUzNoF6yaagX2NkqFtP16akIS/HuP1LK5vkzBUWwI9p1XzNolHkfV3hAyGnErG3qqbX5ahvNSewGWM3XVR/IspJBaPOYtosiMVotwmObNivbtkN0E+t1GtYIEBYwzKz+EwQrepbm+HQyCoHHvOR/5EG06tw6Mhwi7ac5ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6K3dV9kT1TePMQHNEat9vbBQo8pBmM+K6iChvFRe6Gk=;
 b=gIdcO+nYtWE7FVzuGybWdlL9sncrrc46NsSGdonlcMrxsMGv5QPUrZGKVzYqQKnlzMk6xStZhHi4kKz4qLaoZPLgmRhLe92n6R9hLAankoyNtLZ+gCq96J8jcP5XF/RH/hzWIzQchyWHWyj+ZdCnTi5bRzHE+lmZhIffZ+MK2JdjiXLyD0j2pXabBND6MHgXct0gMZYNBR9VjrgDzHZ3FRDh+muCvIOe8QT6pV9Eq6zeRkeNP5eISzqxnX91TGrW8CL/jQUmF03wwIBeNtq0K30B9uuCNrSSZ9LDg20jc/3Kva2Yzzl1uCH/ojvqJBIyHJNWb0XeAWRdsa7Y/7MvZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6K3dV9kT1TePMQHNEat9vbBQo8pBmM+K6iChvFRe6Gk=;
 b=BXp3qkkztlpCo8aPnz5HoM0ppec/QnNkDkwypW7UIgWQRmbH/anF5H7C4NBHqmu2+WO7MCzCoLUG/N96/DRrHsbrcBU+laZK8jjF5ru0xdxKFwWu1dMB3hAz1oz7yW1H2ZOV5rEqqi13yRfix334YmX1h7yw1Qd6db7ASo6OjIQ=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4223.namprd10.prod.outlook.com (2603:10b6:208:1dd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.17; Fri, 12 Nov
 2021 15:09:17 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4669.016; Fri, 12 Nov 2021
 15:09:17 +0000
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
Subject: [PATCH v5 5/8] device-dax: use ALIGN() for determining pgoff
Date: Fri, 12 Nov 2021 16:08:21 +0100
Message-Id: <20211112150824.11028-6-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.9) by AM3PR07CA0134.eurprd07.prod.outlook.com (2603:10a6:207:8::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4690.12 via Frontend Transport; Fri, 12 Nov 2021 15:09:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 404dfb93-7827-401e-080c-08d9a5ee651d
X-MS-TrafficTypeDiagnostic: MN2PR10MB4223:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB422312886379C269C49A721CBB959@MN2PR10MB4223.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	8NuI8sMaR8nnbyJF/ag8vSkrznw+YjLw9DZxlHPYEY+Vi4PNfpj7Q5PSt0SvAAueU69ymX59184wGJWHlgIR6bW0NSrn3ZVXAFYnYkmcMIgSfDo+Kxzy5IGEobCbo2k5Vn+RTDE0OFeKMjEX5oMNnUEhIgqV2a/tLy/irVV0UUP2qhxA8gKGAvwfJWlJCyPukqcrokSqlUDBAffxFUCP5uRJhDdVhek07IZGjoIcCNiUm4/an/L2Bgc+ihTb5SAFDIh+D0JR8CYBpcbv8FQVfAWly/NpOiPL4EsF0ZwZgknr8pqGOIyZcFdf+beShclF3Bm8Ofb8QWI8xIiyppK6z4kAWqTRl4aU13jJU21hmSlsAA0IkcQ05+HQ/fHp6t33eci3P4+FOd3aZbT8OWyci+VMNr3s/OWzItI+fkvx3rZEQMjTLdrLn6qEjlThGnyZ1J+YWH3yj57Qwelz/d8kmxO2vbCnnCN0luu2SXVfW9nmjctpXlakly/E4mdkx/MJPZzk8mR+4Tv7fYUKNI5peM58VoL1TdwQJcy88TDMSy20bbVkgbztU6ZlWBYiyqaZ9Gh/nG/YsOZn8xO6QuesLR3SV2XRH9GTawQVmtbncDx8GhxXtKHNrbwg9xzV9hzdFBasSAMR5IbwtaGZHSaXcv6tR9Z3Ctrh9NF7kxVUJzNeW7CfEb5pK/L0EaDxPcqwi0+pBqDkeuIRkxtqhuCdiQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(5660300002)(2616005)(107886003)(2906002)(38350700002)(38100700002)(66946007)(6916009)(6486002)(66476007)(54906003)(1076003)(66556008)(6666004)(52116002)(4326008)(8936002)(86362001)(36756003)(103116003)(186003)(316002)(26005)(956004)(4744005)(83380400001)(508600001)(8676002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?NxIHogO7ILVXRFcUssSlXbfJu1J2FnrKCo13Z2AtH6anAgeLXBplQ8PJUqE4?=
 =?us-ascii?Q?vqdBOVeqLsYrSM8iQwHkIwTLVFVaghE1/IiPOU5euDQOUEmIUgGskEU9TOZH?=
 =?us-ascii?Q?d/BZ2s37tq5/sR33fMNW+xbU9CDzgn1Th6+uJOKeGS+flGwc8goHSCsCiXSp?=
 =?us-ascii?Q?pON5OG78nbRpewmtHVwEf9ICFZBpMzjAQPMLU8YLyLq/YQfoQwT6pXDlfZgL?=
 =?us-ascii?Q?PUkMfbJhTMIePyK7tET9C6NnoV7dHfpA+Rx+svS8xdrF0kTdLB9czqImFNly?=
 =?us-ascii?Q?rbfI9ZLEsdSPX4ROwUsWTs5tO3BwsAXW/gSc2qp54YlA30SI7HadbNJzu+0f?=
 =?us-ascii?Q?klL0P90P3lF4uiu5SkNo5obAQF2vVe3Fp5crY03Sc58BNP5qNC5wiJfADBPa?=
 =?us-ascii?Q?zvOlbXLHeGgdHA5VJWHmFnFRF91tP9b/jjAfraxDyiJCHAr/XHGPy16Rdc2/?=
 =?us-ascii?Q?BvMQqYYwADNCxi0n/CpQvko6SyMLrDiT1cdCE6FcZ9Rg4EaiUM+V+dqHUxo6?=
 =?us-ascii?Q?FFblevMoIZVlWorIPUVGF7AAX0a8uWS5wJz5Mc+vqNBnYn/6/ReQtJD6jRqK?=
 =?us-ascii?Q?4JG0NLZM3OA9ucdcqLkGc4dDRIDYZwudPAjSerV63sUDm1jFN9noBnbAHPe4?=
 =?us-ascii?Q?EJ2/q8B3lVQ9aNYDE7wMeAwu+tmkYEw4az11k6RKB0nkC00aUu+cjvVGPqu5?=
 =?us-ascii?Q?ISBAsWroIOexn+FXgRI6GyiX6oMHeKlLc5GVVKa1wD+gXC6ZClH/eKXEG2HP?=
 =?us-ascii?Q?6CeEG5mXgrNAWJE5dxghYdajmpRl7muAH3qzKPR00x/QdzN4m87Kc5ow5N1d?=
 =?us-ascii?Q?j3U8IrgP6pk7lXAWuePnX+Ev/PGvCkFdlJYZOmcoMZk4T1qgzNeErQKdOD8F?=
 =?us-ascii?Q?0T6+IOGYra29jFrOUr6OJNdrnRNAJ44BMoMikzd3xXi+PlKBNU1Q8BZL4c7C?=
 =?us-ascii?Q?S5n7v8KwvxtvS2pTjef5Kpokk0a+TjhjPpAZBS+pfnud6gU92cHENpimE1DY?=
 =?us-ascii?Q?LaL0/d4avVP51UGrDf/ZUSA74hfTcnfS63imhDK1sNwY+aR+5CpPyNhrqWm0?=
 =?us-ascii?Q?mcfKlOPxWvqV5QWI1MxH6dZ/J/dCxSKePZgv2OFl5RS9FNHnQSlMNufkMBby?=
 =?us-ascii?Q?5PTvlr1R/ucsTINIjK0S0EYX5LeJ2J2kHYvLb/we/P9UteSJRd+ZAelk+P/5?=
 =?us-ascii?Q?DZ/ZPDXvRZKEZeF97OMIg0tjA0viDKkHqtIgD7I5uL05VcpiIisrpGMaX3Nr?=
 =?us-ascii?Q?YEwNTgtYFpPH3c80VnOAsmmcTTkoB1X4w/3sCi5u1dijpD3GsVRRkeZEnkzs?=
 =?us-ascii?Q?0Onrpet2UyUsHdthegSvTSL81b0ECMicN4BmznSvBqvSd1VONi2gvea5le5w?=
 =?us-ascii?Q?k9jUIavBn3h4Ao56pR4AbCZ8F4tjqoBACk5f1Gc8Y4lAdCTqq6conQRCwiZJ?=
 =?us-ascii?Q?i8aul3l8dXjsdfTy+8p5TxVYPWjp5Ckdp+abq9oZnSEinYzSt6FJMLPnRhi1?=
 =?us-ascii?Q?P21Z5ZxLha835/Rn/82Ha4BZmObS4hX343PAz0Rlnx4FJi2tvnblst8JOGrU?=
 =?us-ascii?Q?Hsbi/NMh59y4Q1O+RxaPWb2Yc1CBIrqnHHky5J5OV7AYGeTeFYsdTQvoG8yM?=
 =?us-ascii?Q?e3iEEbpPfgp0vnYqxG1MyTX3vGIeLxUk463ci4QvYhHWHYqsoaOcbBvSVo5p?=
 =?us-ascii?Q?T/aBIA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 404dfb93-7827-401e-080c-08d9a5ee651d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 15:09:17.0928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GylyENWzD5pB74llvh5f1fYOo/Ru5Qx1HzhRuwmHj2nZHHApAdHm9cKHHZrJPEy09k1dzsXhrG3rWzB0mU/9qEji0DqC/JBX7hrXK5M5HvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4223
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10165 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111120087
X-Proofpoint-ORIG-GUID: RyaQEB82cnhYmcSIJz4N1WJtjqEKqYVt
X-Proofpoint-GUID: RyaQEB82cnhYmcSIJz4N1WJtjqEKqYVt

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

