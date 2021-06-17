Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710752FAE
	for <nvdimm@lists.linux.dev>; Thu, 17 Jun 2021 18:46:01 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HIZdKu004692;
	Thu, 17 Jun 2021 18:45:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=o13ytpm6INie/NN14mwJls2enUk1cPtSh7jEJOPQtuw=;
 b=yeRiOTka9gghx599O4IMxKCeJov663LZcljOt6wSRFVn/jjICFrvryr6nfQGKQt+PDBw
 NydyK05lY6gxQQcH4HGjtuu7cpDEuNkwyIYtSD1e7aAUFnC2nPhvpedtcRn62xlNW6mb
 xvbHEih9l8z/WiJpbOW3yxtpS6jJ7JRrTT5WZtEKU75dHGCjDukle7HEkENxXGbBlJMj
 d3y/MMSCkRWjsx3QxP9jBuDbirm7tpm0NNeKi+nykR31weANqstV+XoA6jAkjP/eG2pP
 i8dIowq4yoHM9KJOHteCH71aSpg5+Tby2VB2/2s0Zbs0v3zXmjQ5/ah30iEH94KLFWpm aQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 39893qrcfj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:45:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15HIjNhL165530;
	Thu, 17 Jun 2021 18:45:52 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
	by aserp3030.oracle.com with ESMTP id 396wavvrae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:45:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OCNOnGd7ysqlmuOELnTTYd9YeNbBxhEqrSHdJOzKY+H6Bd9L3gg93yw4/ZUBk5zCZJHDC0zzFEwpQ4AhmEt2uw/KRBMXc1Mo2qPzVtxPZuhvKJxdsdXTEbxV7tPZyhyJ6tVK/MyjwnqUXK23KUiduiaiHj1JQ/VzvTbaSkL7NZBlESZl3eYhNaYdpsKifBMM2LppOFqresFDI3XRfIKh27cP23p5EBaQx0CHIXPO/3onoACOp6MsiSnvOMXLlZS2EXFHZxL+lpwOv3C/0wdw5w9pyxPe4fEurBoRgXv/0OpTiwBNI3GtuRCMaj1QHKNHGl6iKF+MtOQYH4D8yBJ6dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o13ytpm6INie/NN14mwJls2enUk1cPtSh7jEJOPQtuw=;
 b=eM8W0DyBTmFdICFdHzwWQi9oEcSuGtkzNgUBeoqhaLwTOrr4p/V82h2FXKNWpNo2mv6SQZ3a4vjWwOSHfbUZZAO0SQ958l/H9/c1tHo5go5eEsCtMMyOCi6yyPO3MCzT/3f+vm8Cs8lbvr9F2B1uITTfNI6Xx+/3dYj1FUnhQTmorsUSDeSWUjrnFu7kRuWCdxkl//C90qkb7pR403UxjOKBwBLrDj5UYGO9kouw7ryvQgx32X0dsNdVV3xz/XGLghPZAndiEDirzhZOVbuOACZmC8PmxAjMM+j2ULzYikRlb60tsiFGc/UM4ERs9xTaXo+OYwpS7rwq6UgWnZ3h7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o13ytpm6INie/NN14mwJls2enUk1cPtSh7jEJOPQtuw=;
 b=YPJvn/ebQyb0lcH7Nr+UIec7S7/8Kv4b3AO1q3nEIK99mO4WTRdjAREnhb+o7y/wI660zxRAc6X+aJufOyaFyExrft95Y8vFoMdyH/3A+S4OgJo2m2p3SjEx9Yu8BFLpaG0eTGjO4q79u/OhWBOC8bzMgQJRzmDe9rcJJ2p99vU=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL0PR10MB2913.namprd10.prod.outlook.com (2603:10b6:208:31::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Thu, 17 Jun
 2021 18:45:51 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582%7]) with mapi id 15.20.4242.021; Thu, 17 Jun 2021
 18:45:50 +0000
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
        Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev,
        linux-doc@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v2 10/14] device-dax: use ALIGN() for determining pgoff
Date: Thu, 17 Jun 2021 19:45:03 +0100
Message-Id: <20210617184507.3662-11-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210617184507.3662-1-joao.m.martins@oracle.com>
References: <20210617184507.3662-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-Originating-IP: [94.61.1.144]
X-ClientProxiedBy: LO2P265CA0113.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::29) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from paddy.uk.oracle.com (94.61.1.144) by LO2P265CA0113.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 18:45:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1aefe263-47a2-4756-df35-08d931c020e5
X-MS-TrafficTypeDiagnostic: BL0PR10MB2913:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BL0PR10MB2913508D3BC2E18E132D33B5BB0E9@BL0PR10MB2913.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	8aQi4nNRD5m6xmhhwETYTilR9ebhPYc++YripbFHCaMLVEeaNdhiKP7+xhOxy9wMrZRGL+RrkJI0ZPujGgw3hYdVUhBnSkr83I187/aTCkHNDvJCD+fKaiUxDvcA66w/Hq/34gfSxNaPQphTeU280+mfswv2WrCNvxForBa79uoF1LuyRlgGDXrgezYJFjhvajz+Cx7R1TFB21lIcjXwmyrsfHXgybFaJON4uQGlrDs4KCUVKQb4Kg6SGj4qFqA/NIM+HrAQ2CYjBy/dGR8sBye+zCwwz8GsYZYE116QvNpF4/rHQrzdHoAZuB+2X/tiE2qq3jknP4N3diqGLZ7EVOUDnlnAJWk0n6Ibh/KQ1qunuKA2V1XdlAcqGvHDfraDBslrU5xdCkik7UbkmxfSDWj11J78R4bZzdoRUz0WUoogrZ1FCHD6HNCG0W3JdtP1POQqeAH9KMLTyuYptE9Ikkyk+1qOK0MkZbVXOqJcsvgczg+ThKM8KGhS5cMLKAtQi7JXCf0fQYuTvfkiUQP9oKXEH8oWawHXDApu6Bv5auEVztdk2u/ZXLv71tvbY8eLJyw4/wAN7BRsALYMEuYsSBVaRbI4di/7V1wWnx8+wuVwi8/AqY8FA3BsShRXYAFVdYAETdO9xA7TsPtu1QVLxpxv70LuYx4dW0MOxVpsOzw=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(478600001)(16526019)(66556008)(52116002)(66476007)(38350700002)(86362001)(4326008)(38100700002)(186003)(36756003)(7416002)(6486002)(54906003)(8936002)(26005)(83380400001)(2616005)(6666004)(8676002)(7696005)(5660300002)(103116003)(316002)(2906002)(956004)(6916009)(4744005)(107886003)(1076003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?tkbFtif5AOYyDz+GHWaPzqh8W5lTU4g9BGk+95LLqUTTgveSeGUiEcgbkI0D?=
 =?us-ascii?Q?EmI00cDEOiTNaOOxuLdEgh7SbCXkIF6/w8H/tHTSW5E7/MYQL4yFwgjqUlw/?=
 =?us-ascii?Q?xEWYFFysg88tvTGXaktbPqzMmVwm1pDTr8XtsF0FuEekoiB94bRr+XwcyZFm?=
 =?us-ascii?Q?X4SqHaI2RPZ62DGeIv6+CivcLeMTJlnLShEziB4CrWMucCWjlrlJ0c98FhAz?=
 =?us-ascii?Q?m/dZtdIwlAzFHZCxSnu8aIim8kGy4tMlGnj6G5fQB7kBJD4vMMK9qklTqFXb?=
 =?us-ascii?Q?rTqoSoyK6yPCJEBHBWomf7Y/6+7EN5Rcx49O7TNckaPWXKFV/VynzCQMXAZy?=
 =?us-ascii?Q?39XDchDH+ShHTkd74c7BSbrEmDTl7HjZZLXgl5B++P8WLk/QjZUwaDTV9pq3?=
 =?us-ascii?Q?rGOZMwnCl7KgIGLwxxD8FeVFUebSCJuPz4JHLlXPB4qy465qAONKzoHHtojg?=
 =?us-ascii?Q?iTPGMPCsOH6tdiB+F9g0RuNBMkEcgEqyrksrxF4PJGQUHXqwH2VCpLoqL0mV?=
 =?us-ascii?Q?ImInDTwVKUb4sloSPDINb7+1aW/1o8nWKWnKiNG+uXh3MYZ3yhLm0ulYuo6r?=
 =?us-ascii?Q?sNBBlGY9PKRYB2tOIpmKQRAfSWXuYfmjdq8tQ2O9aoF1zWtz9cNgNnz4whWE?=
 =?us-ascii?Q?Njsx1hMyhYuQWWzvIjiMZeZ65brAJMAlZPkjpwqVuRCE07lO+h3bnvQftI0S?=
 =?us-ascii?Q?I6JNi3dikaG3+j5DtVoHcbwktYiZgPRRgJqgd6OMAJ58GHrxZ/M8jUkPYtDi?=
 =?us-ascii?Q?znTRO38PemoKc2bYlsv18o3D95atybWgv8zG0nlZ4Bjcef7TkTIoUYv90w45?=
 =?us-ascii?Q?q9NP78yPE5tUc/gKAitDOaVQECFyRd9DUTdYJoVrbUGGkxhAMsTbyb/S40rs?=
 =?us-ascii?Q?FPJZ3CrWs+N3Av4mRy5FmvH0N1/NvoMsDqSo8OaMikcs0qKzLgxSA1Iq1kGN?=
 =?us-ascii?Q?0iwTkNiUgS3MRKwp1qthnxflyQjA4C7n/DyUIi9Hzu5nHa4uttjVSSwQNch1?=
 =?us-ascii?Q?EUtxvoWljfeSm7zk+tqIbD8lpN7pLZXCnvhpvAL3HSGwxekMrXnqNq7jjLyr?=
 =?us-ascii?Q?hx8pBhJ2NzYVc1pUlfY7N5Ka5wDUf1fVXs2kJm+3G03Ev26lGP6lSXB/MXAX?=
 =?us-ascii?Q?O3F+cD4ixxfhHCH+c3imoevSxdczjBQcWn0kl3TMGbqi1/Gtfk8rpBIuxO/j?=
 =?us-ascii?Q?PHNSxKOoiBsZ+bOrmLYU7xQXeOXWPwzZskJNYiBXitMoaP4PkxjZyfv5PJcg?=
 =?us-ascii?Q?Hj3WXPpzJR9ZLV6+nWuqfhwZILygW51Ga0wBW+jk0DH9pJS80NbOW3lk7ic4?=
 =?us-ascii?Q?VDtbdDa6bIMSk83KrwmMMl0n?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aefe263-47a2-4756-df35-08d931c020e5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 18:45:50.7144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EoPDRMNqoHnTc0fKOpTg0WMtZG+jaJx4PMJs4znnJqun93Zjoxm617qiZQsO02JEURoqJ9KYitN6/VsQOHFi1BzkGX9yHGd3B7G4LJUVedo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2913
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10018 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106170117
X-Proofpoint-ORIG-GUID: SkepR_0yNaOZY_O6w7se397tXSwlkcd5
X-Proofpoint-GUID: SkepR_0yNaOZY_O6w7se397tXSwlkcd5

Rather than calculating @pgoff manually, switch to ALIGN() instead.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
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

