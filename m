Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9762FAD
	for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 19:36:36 +0000 (UTC)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16EJVVkV022326;
	Wed, 14 Jul 2021 19:36:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=XS+vp3u3f2gS+4FaUrtKudUv4lyVIJUIhs/+PkjZjxU=;
 b=AmxLNzAEdnNmKH+8IwEJAK6E1Jxufo8dvp35I8pu6d8T6w9hXOa8xpSAVIpq6DvIZ4WQ
 qMYxpVxO6jqPv1kC3ROpLSHJZwmEs4Juq0mMntqp9SvJZtE9GnQA4beV9yEscjbZZvwB
 D88dtNZh7iFcG6H8UP2VCnscXFIhsXpeLHNFdhOrKxm9Ee7FZASmJkmA8c7kukLIA3Kl
 SDqcTc/XTPSuD93LnWhGQwP9WjVHUIBJKjVvuCPPN0asvbYaEl4jCYT/QM4ZpHGDZ3R5
 UjBpZ46mMKMZrHpFhg+9jqKBAHWyyXpDtztpAJcc08udooMzZm93+d/g6eVD1tn2Cqvf +w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=XS+vp3u3f2gS+4FaUrtKudUv4lyVIJUIhs/+PkjZjxU=;
 b=QSond0ZPvY4kIjqW7/PgwWOO4QLdI3J/D4GaFnM5/mfZAlnmkYPr2PPw/skdkr/bn/H0
 8oVjsLzutYv6NxygOFGpuHZoOkb84pskjWP9DljsW/4IFUm2adaSPMs2LPeMMWNo7362
 W2Is6xIKpDP1TkEnG0zTF/RD12hJh1lBY9j4/tIhGrVNUf+VjjRFp8jd6hEuQqok3cUv
 8nGJAR5mhRq6BRZmMqFy/05KGzmM0vkYqTR7RCykLquigU+HVhZkzUErGGBPVvGJzifB
 c1YxHm+X1TIHR7spO2Q7AfIFhMUdk8RUTSYEm32CC9lxY4JAIIeaw+KBifU/V1P7VdOK /w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 39suk8sek1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16EJV0sQ079711;
	Wed, 14 Jul 2021 19:36:29 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by userp3020.oracle.com with ESMTP id 39qnb4290t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nb1QlTviaedz757qwIAn69TmEu7jpwwidxxLH8nwkz1FEPltXaeFkclUvHJuH6FHe6IHwkpea2zzzT9SkHoWFQBt0VzmqKMWucrOeHuQ+Dqm0BKFKvyjqnQRr239lZoZp8nk6DTQD6Q2pawCCEY+peGlVqmgN/4x018C8UN1AbckqvrzSEQvppt++JkHhcitCYPzgypXOo55co21SH6DfbEY53J4Ncm5k7XejTneeSlppGXRl/jCYYdqRkYIhIOsW5qrHApbUlEoucF8WKQ7dNlYfme+FCU4DRv0KMeFTAAkRTk5Ck4dGMHmjRj0ftLA8v+x0lRzoKROKvAT4crN4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XS+vp3u3f2gS+4FaUrtKudUv4lyVIJUIhs/+PkjZjxU=;
 b=m4Tm6+IZ2IHzp2WW1cglr5yrOp01nnKftGvAgRnhyMf3Zf+6dfurexkTQKLOxoddog19kdAYLSf9gf/1W4Ck2Hozl00yfGPlX8HY9hjsCkifGLVfaIK3AtK4NLCMzFKG08e2faWTNYvFJAouANuIDqhWVF1yyF59sheEujqBObXVbLMbTKhDpUZx3rghlcJKtXgdq67PvqWnIzSSEJ3DMVqFT/Bdf71p9LI4ufPqOLk/NoqUmt6kbaf1WjqGpgHiUh3qP2Ja/8sVReKjsypSp18MH0OHJbJl+ZEkIrqbxOnSJNF7Zq9vW/jrTdufTl5lSDqlgMC+pgEQ1YuGas/gyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XS+vp3u3f2gS+4FaUrtKudUv4lyVIJUIhs/+PkjZjxU=;
 b=jJDfXoJHrCV4rEKAD06raLWD/Gr4yQavUq1f/yKUEHikEWtqI4W1uDG50dMZOclKh/wWrw+l00dIg6nulAM3mqVHGDqc09JCJRrOIrmVK07wGtqSxbyZlBAhdZ0RwfQXlVVIDUBWqGnIyyoQtMJ4gaIQCuJVIATE9jkpCSLbc0c=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL0PR10MB2899.namprd10.prod.outlook.com (2603:10b6:208:78::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Wed, 14 Jul
 2021 19:36:27 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4331.022; Wed, 14 Jul 2021
 19:36:27 +0000
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
Subject: [PATCH v3 11/14] device-dax: ensure dev_dax->pgmap is valid for dynamic devices
Date: Wed, 14 Jul 2021 20:35:39 +0100
Message-Id: <20210714193542.21857-12-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (94.61.1.144) by AM4PR0101CA0048.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 19:36:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1e36061-a547-4984-37d8-08d946feabbd
X-MS-TrafficTypeDiagnostic: BL0PR10MB2899:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BL0PR10MB2899E4A6A72AD1214E081B4DBB139@BL0PR10MB2899.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Lt2OjV0LlOUze2VFsWs6yuZPPzHGfEtKx4vB4ldN/9i9Xj2O+AFY040fTMIJdKv9XjZvvBeUTYrXY1I2kWypq1hlPx+WJiYnoXsfWS1MBkfM0LoPNQ7IxdS60kfxIhk4VRnOGBeI9n7XNR9WNEoNdc6LRdA5YfjYrhfSNZTSM7P7QJ2tMH/CMLOpLuoVBVKUsjAf9xezMIlI+5wlsaTYkRP9cjSccANpkO4XtwyTtDPh4Dp11mYq07GBbQs4Vgp9agISlZSMGlAsZDOwM4YDbohGRsKmr6dIzvx1CtBVwMnbqPBWJ+M110nVxbV06Z9dPY6twqokbe0u5dkoyGGqwXK1V58xoN7l2SPGvVDxKmZiq/QCcFKawVHieTf2zp7C/yFgT28bGK9zxg8CK7mbdMAKZRd0LYGuSc3Az4Lw7+bZi/KKYVXM84Og/PlYci3Kpyh64xHJ2zGu6yZsNnTWmr09JbpOxAN6bEkaDTYxNgbP37nVmq/xTHTX/w3UdVyWctRgErvgAI94f6snswQOMWLuBiWPagz5ks2ajdP/wdfnudelneAnNiOWcL0oOz+y6nyJOWdk/5Qt+Q0AjyrJjXYHKbBeUTgPr+UCIPgGOWE1tOIl70ax0E47skALTiOy11djy9h47gVEBFAf7oT9ooS61Gz3b6ksaK3cx459K1lIuu1DTwk8XyNuZAjUg7RlpV6inT9uWA535VgCGPk/yA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(396003)(366004)(136003)(36756003)(6666004)(478600001)(2616005)(66556008)(956004)(1076003)(4744005)(8936002)(107886003)(8676002)(4326008)(5660300002)(186003)(26005)(52116002)(66476007)(54906003)(66946007)(103116003)(316002)(7696005)(6916009)(86362001)(7416002)(6486002)(38350700002)(2906002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?05I7u65vtoCp6i8Up9kz4IzQK87XJfwBBWd/ZWaWlTxqIKoTzW/IYFrBQURQ?=
 =?us-ascii?Q?6u7E9n3YWSWLh2F7a+hasOjzNex8zA7acJbAa+8xMde0Loj9InPxCtqHngGh?=
 =?us-ascii?Q?vCnss0o8xr+CQlf+ekwCEiVdd5UT4frpqHI34ABAkwqIYdPlM1O250i8IzDm?=
 =?us-ascii?Q?Wdp3aIu1j3fVdqP5IEzlTybfGL8cVTQkc5U+B9e6aD7Ke4ecvryYLgfQ9Q7P?=
 =?us-ascii?Q?ck7fS5IPqbvOsD5rku6bAwKNnfTar78xaDVx5sEd0oeGp6OCTdDzU7tCsf1w?=
 =?us-ascii?Q?rVXks7QuEfveiWP2H7eBh8NQEhznbuWROIZK5IVn/OdtIohvkpjkezWToQEK?=
 =?us-ascii?Q?LpjVyZrIWxt7efk0aNfaR4cP1TjlcoEt4xpE/fL/CrunDfDBkkqNOribP1aA?=
 =?us-ascii?Q?Ca7zKCTAwEpwXKyaXHjVLIKKVWCeKza957TFzTmoDWrdKsxa59aRvkrI1W6w?=
 =?us-ascii?Q?44gzd9GqoOG8ThxJU4fYz4WM15HdJKC6XXBrm78h22n0NJ0MTyfB2bTz38V/?=
 =?us-ascii?Q?bL6s5TtrM7oYAlet5jHvltI43cnzG7pSH6C/3N/Mrk7cwh8TGfC7Oh9MDvIA?=
 =?us-ascii?Q?jCXJynIBocu2IMv8OimSks0MyjjIUo1GPcwVx/saDWJ4gLIfKBojDejA8RYC?=
 =?us-ascii?Q?7WVZzSWvqvUTBtycWUSxGcLSKTibX/Ad8grTtgy+FtLtqwy29U8TgCu7xDnC?=
 =?us-ascii?Q?PGWZ57dJiygW0DF8BZSdWXYEsD8MKTA+4i3qg94p1KctT3vl5A3WI0QRIbnq?=
 =?us-ascii?Q?4ECj9vdL/4XfmYjFXwDIR+IGNMv5WwO8H0ZPCz4BOhD443tesOuB6Vl5c39T?=
 =?us-ascii?Q?gp/J+8xwqj8IeY/lLcBab92KxFgflzGEgNl1RQFCE3ntJBAJmn7uOqE7GKrP?=
 =?us-ascii?Q?x4T7IczjJvcZWdkMQjB+0zKrnUrnrraUgLweQfn4VKIjxLFFWOFFySOSFaca?=
 =?us-ascii?Q?nFzEP/Ga7mKOesBrzsVt87/jq5rXwjkGlDVVIos3loeT3XHBsV2lp+sIXgu6?=
 =?us-ascii?Q?oofnAmMLIdbz5tqdWQDj2cS1XBp/2yPoWwsQmo9PRvHCYsO3CouNkgt8+qT9?=
 =?us-ascii?Q?T2UeUiGRqDrj3JWBhxDzYrGNuB/5G4lMpWBKFFu1RJZ3IyB7MS0yItpBKnV9?=
 =?us-ascii?Q?kAiTXjLDcF3zv2STCIZ2UhadF59PAqSJuf1+TJ8KzPIv5pOycIKW7I7N+d5X?=
 =?us-ascii?Q?cBVlakFeF6aaIOaM4FGxzpg0kVErsdj/I33Uvo6/m62cnDFV/r57byFJMdNk?=
 =?us-ascii?Q?uPG0Jttdvjm/dLFhgnW1KMnEB+fMThbaF6wL5L5daRidkmXoKo4J9QVo9s36?=
 =?us-ascii?Q?qv73NpYy7lWKd6zY5hTDFGLC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1e36061-a547-4984-37d8-08d946feabbd
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 19:36:26.9495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tFAbL7J3fkDoCcP7Voi4ZaGwiiMq4JGcCtRWhkP55cYMTNcm/2/F3FyBPWwVn/vVygEi5GWZQq0xvUs+xUPmkyOeslLAZyRcVvW7TSl0tHY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2899
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107140115
X-Proofpoint-ORIG-GUID: AaPNpLEq8BgQMAAJpnhK4_2Ask5k89g6
X-Proofpoint-GUID: AaPNpLEq8BgQMAAJpnhK4_2Ask5k89g6

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

