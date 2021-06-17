Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A856A6D11
	for <nvdimm@lists.linux.dev>; Thu, 17 Jun 2021 18:46:02 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HIauX1020433;
	Thu, 17 Jun 2021 18:45:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=XS+vp3u3f2gS+4FaUrtKudUv4lyVIJUIhs/+PkjZjxU=;
 b=lqLiOCUmg1uNyDejtbY2IqLPPqP6LKhDglKlAbW1EMkCZv6Bd/KzwCcKVeDqVoLv64Zp
 v91sD8WArOq1D/nVz8orc9OtmkCwRCRfMFJJYHis8LDMR//sKt4uk/fhxtl6YZNxG7UW
 9wsHUZi4FA39NMmShfCgx070RafXPz59KWYgyMkrOZRhFqLUToJtfwkbj/G1Jk2hxVcS
 JINZWAE/bcxnpkZgwA9D3Yvbo8o4TLUFBk8ft/LvccukNRQYNDTCS6ziDxa3vG2ftnlG
 ImCA733lHrko3FjG4H3vUP4jc/kN7tGsr7SkmuZTNPExehUDdY0AWCmULJ7bOgqwAXLl Xw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 39770hby0s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:45:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15HIiunJ160797;
	Thu, 17 Jun 2021 18:45:55 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
	by userp3030.oracle.com with ESMTP id 396waqf704-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:45:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oY/hCn1W5JBD0SCjGK5qbE+mxqSirRZV1f7nhjyWRWd0FB0vP/QWpH/qcfjXqdMNxgyNY3B1ToLFE8OjT6ZLWW6XLxDsxyGhKzNvGM7gVZr4ODE7Rfi5ihhJbPckzGM02OHgwz3XtCd7AuNmXAQh8ClbcB1QETYbMkzbLxv7/mYP5zIiQhnyN+dNFbqpCYr+81jUu3gowubbr/evRGGzeRZ8H5Ui3g3orcj5O4RqwTZH6zWgvz0wcLxb+pLs2IEIVU+Yo/c1/x72DlXq4ZU+mW6aj+syMb3IeDqsZgUEIQ4QYsVXLLvcCTULVhbCisy/f4zcZNI5z3lFjleFGWlRPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XS+vp3u3f2gS+4FaUrtKudUv4lyVIJUIhs/+PkjZjxU=;
 b=LWv1mAXgo89T2VLUKLqmVzAKdUVTnnG4ZjPpvnKaV2XCiUt63JVf/oUTPuVNE88lNwMLCN2Akzc+/B+9k0iUKqg+f2VoDUbAriiT635La80Hasl87pKBBN9mJGewyHzlLa3DGM7XV5lcDBB+2sXXL2DPvTEr4Al5+b+rDARe5nsHO7ONr6nSe9e4sJVm0046DGqja2WFNJT2xnpUvpykzMeBiLnhisZCuCbxeWwSQ8pnHf24UWzWoRe16SzuwgKQS9fLY8D/FFrCgpe1YMFf8D92MJw88LPANDE8xGmUQgfuIOpoaVPU/SE9+cAcYK2jHUfuzdVbcaThrq19liTseQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XS+vp3u3f2gS+4FaUrtKudUv4lyVIJUIhs/+PkjZjxU=;
 b=VAyWbVe0UBdvsD163JvOkiSR9pQWpjFg2TpTfy/YLsS387mf5e0P0QgOLMmHGF9XhAWVLMCR+++DMPYxow/Y6pVsu6ZwlrKMG4jSu9xB03BNQQFoSm6v4OvYFrjFKd2uuLHfRvm9kdDWkEy25vWgZKz0CxKELZpGvZ81iUZx9fQ=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL0PR10MB2913.namprd10.prod.outlook.com (2603:10b6:208:31::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Thu, 17 Jun
 2021 18:45:53 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582%7]) with mapi id 15.20.4242.021; Thu, 17 Jun 2021
 18:45:53 +0000
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
Subject: [PATCH v2 11/14] device-dax: ensure dev_dax->pgmap is valid for dynamic devices
Date: Thu, 17 Jun 2021 19:45:04 +0100
Message-Id: <20210617184507.3662-12-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (94.61.1.144) by LO2P265CA0113.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 18:45:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99433f39-a075-409c-1269-08d931c02285
X-MS-TrafficTypeDiagnostic: BL0PR10MB2913:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BL0PR10MB29131D1EB162F48EAA8CC08EBB0E9@BL0PR10MB2913.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	PEXAbDdNvwRB6KbEzdLl+5AKl6XIKQqp+9AsLza3H68DwUUSePzO48tn8rmmangqOvPmW0IZMGIBANeLkcI0VezkoVT5FJNlRMTLsYR21wCKAGE57YP7y7jLqocqvLu8VMB9KuduAVCXWpM8VZCUbApDZZhgv4IBWA4si9dEJGsNJUU0hvCkEQ85BM0UrJa3w1CBR8SWAVPW1lDuRl2eSSBHmTVOAE9ZlcrjSKx2WFHvnlIxWaUGkFJ/RPAkZoZQAmK6zHDVFk6FFknNZEv7sTqUhEb4oFt4IruIyDsM3INn9VsPVdJBo2urLCRw1Y7QgS0u39xkmnc2oX6x6f+OLn52fHol7M1ddSz18WxbjRT5dO6bObyn03D6srWZG60840HVfJUmPu8TNamZo1kH1GYwTXoW5sfuf2NCUjFplUk9XuxxKnET+hsHMZbROfTEWM58cL3zYHIXSK8ydTDNGl3DuITt66mIWq5+qRe6YaXyG63tZe95KyeJmfASZR8drPOgUdRS7YQs2SUHlAHjFTLfGYAYQRCikU7VQ7QbUj/monbhcnxKt75AUEue+9s+0dsx0myWh4ZD8negftea5qOyeXlpPmgfPAhjC26HjZ0pbwqeQjGQtv7ByrXY9wHqCPICIRT3DDsBXZaCy80Agw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(478600001)(16526019)(66556008)(52116002)(66476007)(38350700002)(86362001)(4326008)(38100700002)(186003)(36756003)(7416002)(6486002)(54906003)(8936002)(26005)(2616005)(6666004)(8676002)(7696005)(5660300002)(103116003)(316002)(2906002)(956004)(6916009)(4744005)(107886003)(1076003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?g2k5up19auWhN2F8fBn+Nhs98UO085OfdUkrLTILpr0PC07EEqQrb50sgeaw?=
 =?us-ascii?Q?1VFOewMVxJ7hhHRxB/Vjn27fRwbzoKfJEE5qaiAxrB6VCPjIIu5/eOqL1X6d?=
 =?us-ascii?Q?jPt6wlwBQdT8710PBo+xQz1DAFrV90DeOq0rwY39RFzlAcoQbgqlDFeCzhen?=
 =?us-ascii?Q?09End3apzBhgtLBEwR2C6O3PFJWj8OYr/jryY3QlBrD8L3+9H+gNqcBbmZV4?=
 =?us-ascii?Q?7tZ3ymgGBoHxZ+BHwEh+iscCsbm9dlZrOTnemdQXMzAa/15Amno5q3ZdYCz8?=
 =?us-ascii?Q?TlaIPVQR459HgbMOK9O4RZBxcOhkuqBjOZ/fJogb7Dwzu4mSdRu9rrPHgKIu?=
 =?us-ascii?Q?0kGcaD4LFLjBCNw6txKUz5/IfnnruWt+xmERP5Ul6b+bD8NTKxbSVX5H7gW9?=
 =?us-ascii?Q?ny29lQO+uI9zIOS/hSsK8rSJUg3oQIwRZZ8/swQKhYK553fch8pfX7dyX5mG?=
 =?us-ascii?Q?JZAcCWrSATi7EwMvn7w+GHCrVSP50GrXcqsdjkWneaqlQgyp5/7Xw42xGBOn?=
 =?us-ascii?Q?KTEoib9LT6FBkdulM8TKy6pcAI3mbOeH0hyi58J2kMuf0gjWnBUHkjfJ0vm7?=
 =?us-ascii?Q?HK2PVSlkU7Z06lH2sNE9kyUoKQwwewdGATH7GdZqznrBHz3PlzN57/saEcfP?=
 =?us-ascii?Q?+u/xevxZOsJOsmIRNwpbZDCdb3DS9HEUV7/SPtEQPorcPpgF3YCFxXSx86yg?=
 =?us-ascii?Q?Kajg8IQxwkNR+gUHKfL+PCKoJL2tFxMMsjLjnp03cLF7RCxvUrLjJJ1G61Dm?=
 =?us-ascii?Q?iAG9BO0+fiYUbg2ESMYjHxI4mVaUiFmthp8X+PlSinKb6QklKU0lJqlDXyHy?=
 =?us-ascii?Q?mts3nqGwO1+A/ImsmcLRvvNnLF+sNmgNp6ZiBCCmPO+AcPbppbMGmukkKdbv?=
 =?us-ascii?Q?3JpNxsnQJG8w1i5hMVME2ymqWbWVPTv4bbD6sWEq7NS6k55In5ew6wL4X92Z?=
 =?us-ascii?Q?rPznM/6sbpi5tUjpROat+jC3DQGr4xvYnZ6bsT/VrV2ySeAhsH8B+qSg2xHK?=
 =?us-ascii?Q?aHPj5oEhb+Z1tejvuujlyq601gDWKD0HLLMlRXWCFyCKsJhSddQOplNJDMot?=
 =?us-ascii?Q?R4rRKUTRTKfv2qN0FMqZOtn0tEvkuBH0+yneLLZzE03KibLzY0ScOWDv0G7S?=
 =?us-ascii?Q?lcEeeJBSTUyZ7EtEnKVXJ6DfNj0rAdukMLRpo0xUiOJmAoP7Dkv6MFn66qc9?=
 =?us-ascii?Q?LE10wNeLZOeKhWDFn3VeOS/oQuxcf5fK88woltxOjlMQMugyo9fv/VfDcB5g?=
 =?us-ascii?Q?aKnLqIY3a+XKRXklYEg6yu/aURcC+iX3Rt2+n39yOh3Z9M1STXZSKm9+t/4i?=
 =?us-ascii?Q?mERYm7dxvOYZAUGPk95Ol2/1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99433f39-a075-409c-1269-08d931c02285
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 18:45:53.5051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cHotVGXCjKGjQE7eMWOa066LEv5zxpleGgbc9Z9WcLQ3VUAV/JxJiD2qSpoCmAZTGRKNwLGY1RfjL30FPTF9KgH43SP6MXaUNfQAgO0Ry7o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2913
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10018 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106170117
X-Proofpoint-GUID: N_LZLoVW262b8Nt8luDJDdwv0IteUJLm
X-Proofpoint-ORIG-GUID: N_LZLoVW262b8Nt8luDJDdwv0IteUJLm

Right now, only static dax regions have a valid @pgmap pointer in its
struct dev_dax. Dynamic dax case however, do not.

In preparation for device-dax compound pagemap support, make sure that
dev_dax pgmap field is set after it has been allocated and initialized.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/dax/device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 0b82159b3564..6e348b5f9d45 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -426,6 +426,8 @@ int dev_dax_probe(struct dev_dax *dev_dax)
 	}
 
 	pgmap->type = MEMORY_DEVICE_GENERIC;
+	dev_dax->pgmap = pgmap;
+
 	addr = devm_memremap_pages(dev, pgmap);
 	if (IS_ERR(addr))
 		return PTR_ERR(addr);
-- 
2.17.1

