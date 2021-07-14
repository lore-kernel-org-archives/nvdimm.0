Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F612FAF
	for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 19:36:33 +0000 (UTC)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16EJVWTn022332;
	Wed, 14 Jul 2021 19:36:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=o13ytpm6INie/NN14mwJls2enUk1cPtSh7jEJOPQtuw=;
 b=zpp5j1XcdhM8Zj7vUlH82Bos73EsMV3S8L3oPCZicN2NMMOtMAbt2eEy5x+i45cejJ2k
 Ph89HdFJ23GBK5vLTEi83YiT9XVOowdfEpf6a6+cPKv2O+XWpcdi1bJjuNPYiY+nuN6R
 1xcHHzCOe49Al3bVW9xx+tmYuVd0ey8jrnKaGfwllXIgXgKPCIF2/RBGiILKi8PUNrCr
 mI7VNht6ihRZry2ikdQ5u+HuDRQ3h3L6LEKB7iQOrhUTKKntwmOcwrWhIKCEkYUXVMfd
 W2hhTyvPVjw96ybToSNs/OyRS0bjg6TqtbXykbmySa6+wdCR/LLVUXfksqMO6nWtwJqR BQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=o13ytpm6INie/NN14mwJls2enUk1cPtSh7jEJOPQtuw=;
 b=bkSXQJB0OZsu8nmv8hDpwjvOEOOImSAUjc2U2XWLJBjrfGG7KPGLUBIIQOwuuriy/mzn
 9o96cQNpXZkgVrLqaK2UJNVEct2uSFmmCISUyGxBTUQQd3FfMIeqB4Lj1uKl+At7LCjz
 l2eLlEwckUY0zW4QcGsCDhbQUAjO2VaSENkW9vCsziZe36tNZYVJ69gHXs6wmTYamDtU
 MRPNDmqkEkQ+gqh19tUHgZidhVbfrDBWwFkN2cZ3RWt532Mn/Ggxeq3nhN5V1A5FcxEW
 PBzhYVM6HVkTS0syQA+j5CjfwUDiuwQl6ob6aZ0HZ5MGl+2InbPsJ/Idw118RA8CN4O0 eQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 39suk8sejy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16EJUXrX021532;
	Wed, 14 Jul 2021 19:36:26 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
	by userp3030.oracle.com with ESMTP id 39q0p98mdn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IvnFMAcEFrr6fPjxzRepdruN3x+N67wWkSKK39Z37HFn9LbKPzJTr6xyyNrIU1KTwbRvJ89SpVDEwwQFsdYoK7kthZtzMfP4IRarmYkdyhBv0VyZ2xKgfASS5RMrZrHlC6XZO0chX1uy+1kHnjxUHSs3MnHKdZBf1/qqEW70ldIBGW2tmbbhJgWoY++7ieUK/41GUvkrUZ61jfgcxzzK8V80n+CuqoZxLs9CWLebgkNZPuHqy+ZHRLbB+DB2mP/W8WcubZVfhO0hOHYmiXiW0fcmLyMGH2jCs6PdP0lZHfEzSiIHwpU0Bv4SXQVF+3jjU9+9ml3jz65hHq3G03AeDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o13ytpm6INie/NN14mwJls2enUk1cPtSh7jEJOPQtuw=;
 b=nH42uNyFVeIwn+obbTUHyne9cDZ6KN9eQVyZgaLLJOLtZ8wARrY5LR8J1GW3SwnD/44zXuulKJ7EX4W1wF+BpHpXIGBzvS9ML60PmXpPT1ZMEyz+bRlo+EZJNZCq78KaRtovc4cES/qdYPPPvfqkTQpaki5P+weulpRpSBYxxMh+SRk1irWMsaCnC4y1zmJcRktZxqCWq9XIL4HPlGlsF/X58uvR81wr2H+OieRYUmml+j2M8h6dQyjflYX+5Cng8EtR1zOONDCX7RjGyXbfO08bq6MN3J9JRV+3s1MZ64TulaVUj+GdNxHoa99Ip91Q0q0jC4OqWNt43wJI4TawEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o13ytpm6INie/NN14mwJls2enUk1cPtSh7jEJOPQtuw=;
 b=Mo1yYcQVM5ilTzGeo9du30enB3SNnmuqFO15iWiFL32jHEL32VL2iQ8E6jZhX8guo8tmUWVPd5p5QWtuDxxbCjFmzkS44SNjk4vAxK44HZDDl4qK4CG3c/h6dLBJ8Mql539HoL9R28hgPu3EYTSLeLkB1bkNPfb93tKJyR69moQ=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL0PR10MB2899.namprd10.prod.outlook.com (2603:10b6:208:78::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Wed, 14 Jul
 2021 19:36:24 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4331.022; Wed, 14 Jul 2021
 19:36:24 +0000
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
Subject: [PATCH v3 10/14] device-dax: use ALIGN() for determining pgoff
Date: Wed, 14 Jul 2021 20:35:38 +0100
Message-Id: <20210714193542.21857-11-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210714193542.21857-1-joao.m.martins@oracle.com>
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0048.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from paddy.uk.oracle.com (94.61.1.144) by AM4PR0101CA0048.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 19:36:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05f4e851-1b4c-4086-866e-08d946feaa1a
X-MS-TrafficTypeDiagnostic: BL0PR10MB2899:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BL0PR10MB28997B64D0055979A330672FBB139@BL0PR10MB2899.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	//DS5/blqvKD7K8715LxJxfSnmcnTA6Phl3CIICxXBxSjzd3pzSBHWhjWBAfypfROupSBQUanii0wIHGTgVswhPHAhZ/5sWoBAge/rDy5JghdNubJ+tA0DHGGCYBob/r+gdDbm/CmJzgsxX6htVgL0SWno+Q8aFZFAEro5wxGg00Xdi9mrBZQ3tZbt+Rn/PzjkTWJG7Duv8h3l7N+ISShHD4SwgIIkD+PdLHtKc+YpeFUZSl4lU/aCWo0ERi9T4tFLd/F5s81SxdWxxKEyFisYuOHD66UUTrnvkmUBs4TEAxUOyzrk6OhthFiFK09518ZInadAqMjjUPel1GVMqO9c9sA8zGTZhRaYodwbdbKQWxRlUH9ffWhCE0WWjwbbQN08mWZkMchjVD+G/8Oo6f0VZ0ekvw87bi4cTfx5/19Kl9vctB0gbwoC3L3uzy8ySbnofjbI++K4NkIXG5cpUxkWk0sN7QybOYcUmCo3G75+tOgiXCxQhwRs+LR5PpeA2YjUBVJ5v9XezPZWzb+/BbvwXdCa6X3gT78pRFqBkG8XLbcOMZWBq6PVSA40WglnAaKIhmlvJ9dSzJml7BJCHf6ouQrJ1xJ40Q/qpsnjq9TDGrnIxylyMEpdd2LtXw/4ZC8XDsEsVg1QYV0kIVD3yWIuzs5twUMsjLat21m2NSDK/ijAvIB90XO1LvHCROKJNRYRcHGAZepbYSvXpJqH7C0w==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(396003)(366004)(136003)(36756003)(6666004)(478600001)(2616005)(66556008)(956004)(1076003)(4744005)(8936002)(107886003)(8676002)(4326008)(5660300002)(186003)(26005)(52116002)(66476007)(54906003)(66946007)(103116003)(316002)(7696005)(6916009)(86362001)(7416002)(83380400001)(6486002)(38350700002)(2906002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?pfh6b43GqJPbmajU0h1ihY4rv969lRbaM3IAA8vUo9VihzAgeLFma38Q34HZ?=
 =?us-ascii?Q?pBuPSb5kxzGF+2TLWGIRqQRpX+9d1/HWdKyUM1ckHHl3l1uI9hncZhgPOlNy?=
 =?us-ascii?Q?7s/dJgJc7BmIbmYZLa9npwqBiQFFRKc/tIhnVKjwZLZUKecjnq6H1vHXJXih?=
 =?us-ascii?Q?gNW83XfAXvrOc8XyCeXy4lN4uh1SucEuEMRkDDntAuAHxDOowloAbjRyyKHy?=
 =?us-ascii?Q?ifjJb6ehHtEejufJ66wLN2QNCzOwo60eiKuJu91jx1So+Zg0uk1ILY3qzMR8?=
 =?us-ascii?Q?PEwzF3xyZ60hpLTG8xrmYeVQ10uL2Fv+dcHZyFLhMfuKocdZTmWheb94hDkB?=
 =?us-ascii?Q?zxYn2SPDObHm4RpQ08jOnBSAHU4SNBDMB6nG/zH2qpflbYIXI/Cryg1SsDOg?=
 =?us-ascii?Q?evh9XeD+GxDady/BQThdTA+ByHcknbUv3nBlAc96M0kbe6DBp5gRaEDO9ChT?=
 =?us-ascii?Q?plaRL/7PixpCJg5qOq0fpjJ5ouuw1Tn64XTfy1s2HidYn9/2nj31acPb+WXA?=
 =?us-ascii?Q?rvz9esAI2zeMvoFVwEdOnB8gjJb4frzmVQAedBnhbgJ5g+oLJRbQU+MQ6IVu?=
 =?us-ascii?Q?c1gHLRsnU0cEgTEaZZbleF7Cu5Lyk5gvRFTnGm8WHWnIFO1DYmbUBouuljAT?=
 =?us-ascii?Q?8QQMqKgBVpdtuAmXjbRRk+yeZdZ5jRoJwVqmTjaHWNG2R6JkhQ/g+wCFdZdm?=
 =?us-ascii?Q?Z38ki51BdifkQXt/Dqqbv2lbmaVrh68qHS8y2R32XovabMA/q6fbSEho1wrI?=
 =?us-ascii?Q?+Kmd9l1IErhsYup+S2LEsjGCz4Slof8LZE8f5TuZwOmLoR67kOKzqlIf+Re/?=
 =?us-ascii?Q?oP1VNtKNdUPmevd7vaZF07bedGx8+rBmo9AvgfGbIyfax/T9Tl02MZSVNCau?=
 =?us-ascii?Q?Uy76TbwQKKwU1VcUn8HE8sowlW2/a6p1uH4WfokS3Z+xPkXQbH/XECI3DPlS?=
 =?us-ascii?Q?ldP/KKRh7JUQ7eOqYIka/UKJDJZPkF/H+F4N8yTw5MP5IIW4/cgj3GwAUtgH?=
 =?us-ascii?Q?uoyZILfZFbzF5k7huR6yk137uKiX4klEAuSgV/jOvYUVcvpxwsfd13a9JEM6?=
 =?us-ascii?Q?lUw6im6TYkUb/qvjMH57KU9cCqLDqz3e8F/pmVyBXrtXkwbSwBENZ+XvJPQO?=
 =?us-ascii?Q?ejL+cvlqJBUFlEts4eK/E/Borj7Sr7T0YRJtuyu7tAO1zOx35upd7mNb+HOt?=
 =?us-ascii?Q?r0ObQaOV+SdkkVBUE/Yni7KadlJz93HvgFbKUzNQRLJtVktVjPBfN4PiuuOO?=
 =?us-ascii?Q?WlEZigaQ/nclbDvAYENmsSysTUs2ljo4kPmyrLxDmXhq+0lyBtvaNALpaPXQ?=
 =?us-ascii?Q?VD7+FXC+mgJf3OX6YHUWQCuk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05f4e851-1b4c-4086-866e-08d946feaa1a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 19:36:24.2105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v+iRekKBqT1nkTObqk51KRpa5D6Q34pocR+alkjvH3j71c1EBC7Wrgdz+UTIQ7vxJqp845VdTQBLlzHw0c+P7pwKxe7pAPRWUk8dH1fDG0A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2899
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107140115
X-Proofpoint-ORIG-GUID: 2VsLBtRtdvkao4YmgYE9NwFgmmx_7CFv
X-Proofpoint-GUID: 2VsLBtRtdvkao4YmgYE9NwFgmmx_7CFv

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

