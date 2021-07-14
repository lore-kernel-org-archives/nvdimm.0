Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6365B2FAF
	for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 19:36:18 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16EJVVjd010180;
	Wed, 14 Jul 2021 19:36:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=8lJ7EDg3tbbYqO7fNYtskGSK8ysuHvu4xJBz1wDuqS8=;
 b=pb3p4lDDgNBXmBNCgIWSQIIi1gAH25Zud6KNr6SSi/HBYOM1s4PxTRRGWtJpPoRHNIbG
 POJRW74XeZsw6hrbuvIGzd6qUvaOx8vfh40dgp8KpJEk9/jsB5iJM0MiEgNlcrsf0+Nm
 W/IAEuED00mPHJKU6I9gPQ+vPH1+XYlJFMGLde9k4d0E0se9lxXPNsk0HsASbc4eRH/7
 xqQQ2RK+nlHIHbg8XeYkQTB8kspfXv0hH/Fd2CbqT9XnUN2GuggJegwpipRezpeDTdL0
 DWffh7Ec8mEHWohVHwwJWTz2fUKw03IW+xMqZ7fZ04LaVyUPVArZcBNJAzTIBK7BFgqq KA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=8lJ7EDg3tbbYqO7fNYtskGSK8ysuHvu4xJBz1wDuqS8=;
 b=sAXUvwPHsaJB2dqyYmATcXocB1opgmdoQP4hYaY81nFjZDc5xOkf1MsrEaZJqt6wD2uX
 5mCO5kEL0rrayuftJTeFHUs0AVrV/ZgKaCjQYlEt8yX7LtXqxnyVBciBXhDaU/yeXEX5
 0we23+pdlxayFdoNigqDl15ulTDXciev4S04FOnQrXtrK35S1dh0/RL6AOhxO06o9w/e
 rhqsOWAmfRk/C860yUrHWhzA0Kb6+NeOZJeia4zqnfsYaS+kCDHvyD9+4ux6sYJvUTPk
 2pZx56TglU5c1RiIPZGiLrO1w2lOqxOA/Cp15RYBGBBuhAGOPFrPNOwNzieeLFcnry1F EQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 39t2mc0fga-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16EJUwDl187323;
	Wed, 14 Jul 2021 19:36:01 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
	by aserp3030.oracle.com with ESMTP id 39qyd1c5c6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tkb5DNyy1XuZPaa07HmFdVkJ/YlWQt+wjH44X6TwAzzeMb5Oh4WKwAmHn+DXNxOa8W1K2S/qwPQv66S1fGV+uaUzj3BgXLM/ZD3CgrmosrNmhmh86+oD/2WrjZcnfPCW2kmn1IqNxV1tyHQu6wLNaYALUCdRliztcRJQge6MI0gzEYGupntZdwyYaX1BWqi4xMh9bHPo7mRfzyRlVsBNQQEQlbXd346FDmCPfnrWOPxXOaI3ECOiCF5MSUShvPErdRv6YnO/Q/rcs7Dg6dftO6K8rxkd4oA2I5lF6vF4tVba8zkPdyyB7Nm1h9n/jsFy+cLBX24A4090jFQGAAD+Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8lJ7EDg3tbbYqO7fNYtskGSK8ysuHvu4xJBz1wDuqS8=;
 b=FWfz8XuU6LNCDNjB5i8ctz0q1P1zVb7i8KpuuWpJaO3zKaLhgxM2iPuzqM7Z3ix4bJzjJVGxiFlr2YqHVa4P0oT4D1b4tpbCMostkMgosThior1gcAHjjeoT1eZlDVLnJK55gJtx1Sz34oEjHnIqG4w1HXQ20gCsy0KVC+gbkJNPi66oKS3ojqrA4R4aT2HoKWiLAfH7ySOs2cIoVVGeroRalcR8FQLAFbbf8Dehid6OHTb90Syi5Z2OGoZyQAzlxp2Pro65CQlWAtEKEs4katVNCprwzn5DjRXo/yf5+7THLanXu+Z530EFDovzgH3XU+P8rvvHtNPDT/idMTyDIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8lJ7EDg3tbbYqO7fNYtskGSK8ysuHvu4xJBz1wDuqS8=;
 b=T7Nr1YRNIDghhVBGq+HBHqLkarpJ3O5FLIj8iNx60bdPMAPelrbWltKLvkVMwSmchsI321HY6Slv5eA4NhZhoa2TtgU+jjkvJYxGSxWya46jwk6CGjeNrnoVi02I+I9LmuFFil36btnn2GEnMyCfHf+FKFvBylIlePWay8FpKjo=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4080.namprd10.prod.outlook.com (2603:10b6:208:185::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22; Wed, 14 Jul
 2021 19:35:59 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4331.022; Wed, 14 Jul 2021
 19:35:59 +0000
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
Subject: [PATCH v3 01/14] memory-failure: fetch compound_head after pgmap_pfn_valid()
Date: Wed, 14 Jul 2021 20:35:29 +0100
Message-Id: <20210714193542.21857-2-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (94.61.1.144) by AM4PR0101CA0048.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 19:35:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36ddd624-a9d2-4e06-5a6d-08d946fe9b6f
X-MS-TrafficTypeDiagnostic: MN2PR10MB4080:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB40806761D47BBF7590BCB3BBBB139@MN2PR10MB4080.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	czqebY0y8Qi1zlKIYb3HVr/8JbmWw83aN1ag8Goln0gWCdBhmpOmT8KzFgwagRse7/HMWjyXWXwwK5memxOyd2Ud0m9kJbBB2xk3XOBknMHfZKtVgjSdzDia9fPk0zMaBRNI0nRM/ybpuVhiniKgSOTe8AVTly3GF8rzGyTL1He5pIr5IOZdSWlCtHTC1DJCzmIxQDmaaGy0XUAOuxuoShMWbMBDoB3hNfCJ9x7KMGA50/IkYE6B3iqM/R96k69LKRiglmw0R/a6kmjAsjchzm3BhVcyPKcsOcsa5qcB6Wkm799lYYzZzSLDtVGL/oHuCA6UP4GlxSWZSggedYi+tFa2JjDssopIUq2C+mePd5wle/Qi6vbikPN0NUEb6zD+vNJE4tbck+3Kyj+Gq5vxLZnONkx6GaMavwDOdwzekeJTDT9YITqyw+Xux5BhQRejQwsAW0ZnJz/WyMlBOBOdyuE5ZbtuJnXtCjR4wJi+LsxR/pxOD5P/HQaK81ijtmYEjIprRZV3GhdbI3sfUt0tc8g0YbWEus7I1+wRcjzUJAA256FwPYXEewE4NKbZFFcosSPGNDiSCE/FbcoAiDv2nfRxRecNv7Ac8dgpUh2Hm3gXL3kE15qdvEOZp2YfxNo1AORwGvTky3euXAbs/QhYVkQAr6pb3CG9pYDactbe9fCGg03ck7Q8FzMOALONcxCVzQGLNumbuV0m1Zzfwcm9NQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(376002)(39860400002)(136003)(6486002)(8676002)(54906003)(86362001)(5660300002)(36756003)(478600001)(186003)(6916009)(8936002)(4326008)(316002)(83380400001)(52116002)(107886003)(7696005)(66946007)(6666004)(1076003)(2906002)(26005)(38100700002)(66556008)(103116003)(956004)(66476007)(2616005)(38350700002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?uNBqsHHiQUA5aMkW3m/X5ZBkwpRE1gpsa5lyjAMDhl6HT9xlQ7GFoQSi1H45?=
 =?us-ascii?Q?6J9esvY0avLT1pyQBKjoe2pfdTmgiLQ7ktXCUAngTDDNN+hE91eiI7lI+sz7?=
 =?us-ascii?Q?IDk5Bw4Zz0QN43Gnq0fZA+fiJjsfp2mhgTfTtaTaNAY1SJNJ426/vOGsZZhD?=
 =?us-ascii?Q?fSHkhF6h+VgjtBqMETZ8vtHtUgT8tFq7WzwOeKsHwJGQpsL5riO1EZr9D+fy?=
 =?us-ascii?Q?iOF3go+3oECOGPOgAdbBTSUxew9F7vCeWi6ICNuQ9O4eAPCBdDo6s0kb2Gxf?=
 =?us-ascii?Q?OqhLuLDDo3qd+GKVB1U+9R36+G85ao7t3sqgmLdlcof3L4jNwzjLlNe/psb6?=
 =?us-ascii?Q?FqvvurHoYAA6Of4ZjQLbpvHszdtG6YWBqqfh2QuLPOeEB6bhaLGN5d8gnyvm?=
 =?us-ascii?Q?lmT/haXTaRt5R1MLS5wg4ldyYOO+9Mf2zXoL/1x/D3DzqeHjlvgxRDuPgRo/?=
 =?us-ascii?Q?JZ9SLsZDLIc2g2OiZH5ZVbBV7g2/gMzGB23m+V5vaYqwxG9LhH5OsAwx73U/?=
 =?us-ascii?Q?uM9MjCOlJzD5e7UOCsQb+tSjXvrzp2Vw4Z7+Ev09w9b7bDkLAsqjJUpv9cJm?=
 =?us-ascii?Q?W2tEY+AWoKN7wXofnELZxAl/MQrZinIrkQOtEuF1uev7uDPhxVCR7tsQDiQM?=
 =?us-ascii?Q?KJqjIfXo3Xb7lGmcQr/eNGY42MOLoPsPbuHT/lREBc2z3YS/vkYhraCdcWvb?=
 =?us-ascii?Q?aeoawwLGBMt+0LV0NdfbNX0hrMaOk3zTInf19OZnUKXFnq0DcU2REpCYE79l?=
 =?us-ascii?Q?wzq/eojEBvEgRYGa2D241PJi4q9LhOBk2cAdq88fcZi1jHjS6kZPq3mJsTO6?=
 =?us-ascii?Q?LJCq/wfBiSe1BsD8Pi9pG6JSdXvhcuI4MBJu7XXTGy7WFsNWY4bjLTykgI4I?=
 =?us-ascii?Q?kfEyrr0X9faNqh3dNYVt1LKr2TwZcBsTkrubPWI0a3APSGVNF2ueiJzC5xW5?=
 =?us-ascii?Q?2ln6UCFBQy753YbriahTEgXNr8bkCeNGbxQoEuJftzYtxKn/fAfHQs8bpLRU?=
 =?us-ascii?Q?7S6tz9kS0VTAnS12JcIx6gKlzg+rs84FfQdIYS95p/lXNB+zg7q3m0oMQiys?=
 =?us-ascii?Q?y0+tDEX04YVhp217VGTkixcYhpsCi9ZHP4TT0PIg61Rr5yoRly7PMtlU0J1p?=
 =?us-ascii?Q?yqz4CQLsNdPwbH9Z1qdlYzK/jFJULDbL3pF9fqJ2wgZswbEA9q1/4GCsy3qT?=
 =?us-ascii?Q?2mfwrW0BpDvpVvjM1r6jVL4SCWzPHkydJ2d3nnbOQ3q+llqcSd4Yy/A9oEsh?=
 =?us-ascii?Q?ka8OAx46ui5+U9PCFDiNdGtM93/VkznSHdoHyFRW1QR2/iAAzzheE9d3RwvV?=
 =?us-ascii?Q?yHTyJWBEnfjfulJ6rILrG4mt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36ddd624-a9d2-4e06-5a6d-08d946fe9b6f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 19:35:59.5847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2pp/3YptwSx5UhxTA5t7nCs1gywm50Z3MPd1r68mzTx6v4PlaROpyVhtDSFYQTH9Afv3ULKIqkFxqvlpTzx/oUQUXnRaBscZIoPRIRtbGjw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4080
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107140115
X-Proofpoint-ORIG-GUID: iOIbAJE7mU0kga6Z5JOSybjdCA6_YZjU
X-Proofpoint-GUID: iOIbAJE7mU0kga6Z5JOSybjdCA6_YZjU

memory_failure_dev_pagemap() at the moment assumes base pages (e.g.
dax_lock_page()).  For pagemap with compound pages fetch the
compound_head in case a tail page memory failure is being handled.

Currently this is a nop, but in the advent of compound pages in
dev_pagemap it allows memory_failure_dev_pagemap() to keep working.

Reported-by: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
---
 mm/memory-failure.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index eefd823deb67..c40ea28a4677 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1532,6 +1532,12 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 		goto out;
 	}
 
+	/*
+	 * Pages instantiated by device-dax (not filesystem-dax)
+	 * may be compound pages.
+	 */
+	page = compound_head(page);
+
 	/*
 	 * Prevent the inode from being freed while we are interrogating
 	 * the address_space, typically this would be handled by
-- 
2.17.1

