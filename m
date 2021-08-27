Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FCC3FC4
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 15:00:17 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RDWIJo002221;
	Fri, 27 Aug 2021 14:59:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=vleb8xbLm8Ca5bQPl0MUBtBg57DLCMTJ2NWP2oEleU4=;
 b=ClgSWWI/jybLUeb1e8dqFVSjd5Lu01UwmP/9BEVhoIx/1ZRjH56O2A63Sc5Bh9pECoul
 Zs+M4wHPLZHnSgZKp3a3oR4T0wLJTP5wrBIHv9Ze+yoCbU9YRn6EMIEogBB6z/RDVQtr
 +GfnR/TAG5YeXwtWzv9wDj9jB1oUHXgY0VzP/s7vF3lUx5KNqnBGYaxPLO3NxNlE3FUS
 RulJwcXtfRWcIchGZftYuCyPYiMq7rhnhI8MRo5KUF8DGCv5+580p1B6dKY3vROg9OT4
 tqaMkWD7zZ12I3Sh5FfGZpI49jL1DNq842Hpk7uctcUANESiVwjeP96YBfjbbpRbTvcd 3g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=vleb8xbLm8Ca5bQPl0MUBtBg57DLCMTJ2NWP2oEleU4=;
 b=C9k31Njofgp8e69KVnervBuFxDWOn1O+b9jKizqPgRdNxrABMasWz5fTjYIDsi6WoREN
 gWp+TN62UbMyylFreogY0jwLD2um2XEVNqtBqnUOCN63douDQd+Shrgg65Vq923sxtxA
 7r8Q49JrqW0ySL2zTKoOyxe3FXQau0UdmZ7p1ai3gwsggGPa8yKP+iZFQWGNhtV726vG
 P7XA6PYTsvObNPVfnMdjuz1nOPUWdyW1CvLM0GTRIH98CWdQjSJFXIA89dqVcVnEjNVW
 0OmeFPUWijJSlniLYchCC8RCn1GGpWoC6Qb2ZzdyqWJMhPe7eIQzFesVLwvV/7iKdKhq Hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3apvjr0vha-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:59:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17REpYJN152595;
	Fri, 27 Aug 2021 14:59:00 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by aserp3030.oracle.com with ESMTP id 3ajqhmq1gk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:59:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fyLbwiT0foJTl1j/0/64bxs1bQTlBni3OvUgvJjy2NNCGso2rVC+X28lLIkGBx8BK687JGWTGVCqNC9rq3Gkp+zj7acaVe1nzr/wGfO/YDJURqtB9R4A7R9xZjCOrGUmgxO5UBa7CzdyxCS4bjbDHFaFl9+70TyxkDE97SvLHc9Idi9cnh0zgVn5JR1PuHT/VCYEp54e9U6BYmIzIaYu3iSX3kQf8Z5VFLQqfvruEVDDfeey+fhcz5ybHpmhnuECmKTsQK51lK6NcjfwQ+ZkBc8VXpy1c2XKxBkg4RqNzxz1HTj7kasYoaLrCRquDTlIkfEKjUazEvRTTWsMMX0ybQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vleb8xbLm8Ca5bQPl0MUBtBg57DLCMTJ2NWP2oEleU4=;
 b=mXYCA/jpNo2ZKFMVEy42h3cVUHl8ezSYf8MaM2wUjNdJuuZQ5rAQbxnFSQUy7dHRxterDmZoEc0oBQMWccf5iM1nqVecWFAHjI2NYOcNPL4jXX8hyzOJbGKLj4dJm5ogO+W7VKnKHk6MzL+cs4V1R704d1U8L34EB0u6SjkdcwNZnm35RP9rhaznkhWNm/XVHlo6CxTEjCA+AJqMRxLyHnsdbShjf8KKe0gsng7JEj8/TmJGNUCuOmL9U358kzp/ytykgLe7ndvW9E+m5VmBZrBTw0bS6uPJkY4O+lsy79VFw/aJAVAQqhiBeDyl6eQmDk5XV695hNH2Is2OHacpUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vleb8xbLm8Ca5bQPl0MUBtBg57DLCMTJ2NWP2oEleU4=;
 b=yIBxWpgnjD7bP9ZAgxXwoo2BwQJ2q74lrh9nOh+qfHQSzfk8Sgvg2I03FflWb08tdIGYyzlhst24OoHiVWe/LImH5x9hGvd/X+zUm6mm9rnXB8qMIG/KuY2SYh8pLJOtxd6RQeA3LGmrYJKHuDita25Q0rhua5JBXRGk4KphSqQ=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5025.namprd10.prod.outlook.com (2603:10b6:208:30d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Fri, 27 Aug
 2021 14:58:58 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198%5]) with mapi id 15.20.4457.020; Fri, 27 Aug 2021
 14:58:58 +0000
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
Subject: [PATCH v4 06/14] device-dax: ensure dev_dax->pgmap is valid for dynamic devices
Date: Fri, 27 Aug 2021 15:58:11 +0100
Message-Id: <20210827145819.16471-7-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.8) by LO4P123CA0443.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a9::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4457.20 via Frontend Transport; Fri, 27 Aug 2021 14:58:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f784e285-90d9-4732-e201-08d9696b32d0
X-MS-TrafficTypeDiagnostic: BLAPR10MB5025:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB50252B1FD7B70B68E89BC113BBC89@BLAPR10MB5025.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	zA94Ks/uu9DvumACtUU1uny7LScnXQ0CLeaO/gU0DE9hABuk7sP+MeLFdV3yrX/2Tg7WYL3wlI7apXuZXU0tTrBe8gnarILkv6hbdWrwTMrpEfoRVdT64rJr5ZzU436oQAEAvwuH050UYI1ODpe0y/H9oVsrVgjxIs+UN560pVWASciifiNEzQ13117RCdBSn3ax2H85QpjCTql13d3X612vpcqqBrhk37h0NS/eH9vsvIohUQZg2k+QCOaY/uQj7CgPB5H0NezA7iWycsiaNuXKizAU8zADSP26AaM1Fzjbv9H1NcDa+6vRJiFWgRDYw01mAxhcaixV9X2ACcxkhaPmvX6BJAv9BD0FgIO12JtSrYuwYedEpm5Vqfs9E+Tk+o88z6mN51SZXB3Lijlfg4WpANFQ/2PLJ3HRtc8QlRn2fcsjFcFEpWf8AaSzTXRPjEILwzIKpMAdMgmT6HF+NVco/bn0ivUHOrtiJp98U0zDO2nOzJTqN/SHpx8LzQ9e4gDUcHXjsgTFdfr8OzjQRK6iKGNKlCgZQTVU/pECznicBvT7x4Q8VVntjvQG7wq5Cj9kKZiuJajzU0w9Jxy2PMd1TjdwhJdeiF/JEzBrewlkbwXams9AMxUkRNTPoEnMgOPagvwAJvdqR7Jr2OBx6ejBdJz+J1vIIXgy0xLpYl9FNu6iM+awKk/OJbTh/NwZazCglnRrc5KP7fNGTsDeUw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(508600001)(103116003)(66946007)(83380400001)(66476007)(86362001)(54906003)(6916009)(6666004)(6486002)(2906002)(1076003)(107886003)(8676002)(186003)(4326008)(38350700002)(5660300002)(956004)(26005)(66556008)(52116002)(7696005)(8936002)(36756003)(2616005)(7416002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?6w53Llmp6GSyFkkK2oJlqLjJ4fTKPz/aOHI98ZORis6tQ+0EwbKefH9Gkt/3?=
 =?us-ascii?Q?AvHkMGB+RWjhcfxpuv7B++pIbVHyGOfovl49N0lA6S30FXj1DwD0D3Oxqgx9?=
 =?us-ascii?Q?ElZsOQqEFWnKzgAiK/Cy4M91Qb/wOuntczjWBTBsCjr6QnJwfBZLvwn2vQ+q?=
 =?us-ascii?Q?lYzYmcyYYy4jji6Tm7yVdyzfjowU24CfzuuGL6Z4n9aVVMu6nRr9mjw0Jpsh?=
 =?us-ascii?Q?SAVfF9xjZe09jJLolXppxxqsIBByFe4xjdzWYZdQB9AtKGTjxxT1q5paweHP?=
 =?us-ascii?Q?9q8nd7hjsWbgvn2iHINqhIyS1uHRdlU54ZGeu59R4n9pTCpdg+kHjmGR2nSG?=
 =?us-ascii?Q?RrImLQeF7ayZWOOAtu7o8ENf4PsGIgN5auV9xHoVTcsQQGLpn9CshvyWiNv/?=
 =?us-ascii?Q?ORfVyHV2B3w+ySGezPO/xK0rex2pzpwjN9l7uQIdpusMEq4gkIimMZFSXfZV?=
 =?us-ascii?Q?dI0hEMD5Dzf8z35vtfaeBOPl08ZPmyevFT6905x4sU0iUMoC/1+6ol/VrpAu?=
 =?us-ascii?Q?LJZN/Jsl2WFMg4AMM4BM1ggpNs3CmlbmIBueLSPPmowFzPVKThqMap9JKPsY?=
 =?us-ascii?Q?k1YNL4IJIhzcsactDhjMab6BrhpUj/bRALrV7FuTPxf6ekTNsXW9cdbRt1zW?=
 =?us-ascii?Q?i8sg/ikRUWhfJ8ToZF9M2GnAa9o9b1gpmrLwiM3UlcEWa88+corjzAYo4bDf?=
 =?us-ascii?Q?IxBqlRoes95VvuajkV+c4h7T0iM/Iy83W3JcHCVDL5dgKSyXXYuktT2ddHBb?=
 =?us-ascii?Q?r4dfYVkH50CX6XVkUhic572KHcdEQPGBJ8yB8GmAV4wC02RiehSOFtOBgCPG?=
 =?us-ascii?Q?O4Y8EnNoS/oGPkJP89whVi+3DNvBZRuDtBMaJlIJrKAS+cPEkdRzKd5yKX5y?=
 =?us-ascii?Q?E7elc/hXzye49lnIKv5Z5QkcM9dcvGmolBVpuaor52KdUyAZovaIBoTHp0FX?=
 =?us-ascii?Q?Vm60/fSJoogpgqgRXJ8onpOe3B3B+BzC4SHTDzdnkJIIlOwf2qPzesORr3Fp?=
 =?us-ascii?Q?Q2DNf1QBB0WlaA6k8qMSWbPlDYPsnYiqFJXZcylP/ijMudvcNbkdFtBeeVj7?=
 =?us-ascii?Q?2RTT95HW7MTbxafKV9T2GgfWwdx0BTGQxaJlxBFHPy9FTwBDEnfIohRu/P3I?=
 =?us-ascii?Q?iStphFnkLaRzJsjNak88+TX7ezAYB1Dy/nYpt+5nJbeMkpXDWrhw0Z639nQm?=
 =?us-ascii?Q?v1K/uCEMZ9X80Nwjnyq6b3aA4Ihhsi0EQjF6IEfT+Q7QbS8t2k+hKoepmCch?=
 =?us-ascii?Q?n013VarcM05txYBaaqBh4C0IT4FGmExDnRx65wHrNkA0uNs4Dj74R+9xDbF7?=
 =?us-ascii?Q?FJvuFPuzb3INmtohdgLveqTP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f784e285-90d9-4732-e201-08d9696b32d0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 14:58:58.6992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +zpWT6dHB5G6hSsSRND8l/D7ZtJrkWiYVjFKJUN8ahPQo3i/p1b/nScisJtDE326k3bep3kChK0KOBA4AJ9/rJuzuNBB7xfOfrwomI9DoOM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5025
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270092
X-Proofpoint-GUID: R4utl5Dxk8nXHr60bbLetGzZUHLyPGb4
X-Proofpoint-ORIG-GUID: R4utl5Dxk8nXHr60bbLetGzZUHLyPGb4

Right now, only static dax regions have a valid @pgmap pointer in its
struct dev_dax. Dynamic dax case however, do not.

In preparation for device-dax compound devmap support, make sure that
dev_dax pgmap field is set after it has been allocated and initialized.

dynamic dax device have the @pgmap is allocated at probe() and it's
managed by devm (contrast to static dax region which a pgmap is provided
and dax core kfrees it). So in addition to ensure a valid @pgmap, clear
the pgmap when the dynamic dax device is released to avoid the same
pgmap ranges to be re-requested across multiple region device reconfigs.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/dax/bus.c    | 8 ++++++++
 drivers/dax/device.c | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 6cc4da4c713d..49dbff9ba609 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -363,6 +363,14 @@ void kill_dev_dax(struct dev_dax *dev_dax)
 
 	kill_dax(dax_dev);
 	unmap_mapping_range(inode->i_mapping, 0, 0, 1);
+
+	/*
+	 * Dynamic dax region have the pgmap allocated via dev_kzalloc()
+	 * and thus freed by devm. Clear the pgmap to not have stale pgmap
+	 * ranges on probe() from previous reconfigurations of region devices.
+	 */
+	if (!is_static(dev_dax->region))
+		dev_dax->pgmap = NULL;
 }
 EXPORT_SYMBOL_GPL(kill_dev_dax);
 
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

