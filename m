Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F3E2CAB
	for <nvdimm@lists.linux.dev>; Thu,  2 Dec 2021 20:45:12 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2KODxZ006894;
	Thu, 2 Dec 2021 20:45:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=/nhO1hp5r7T4ndz30RLhGRKUHSmXEH+wbvbCgGKJltI=;
 b=VEKOqR9X26FdohOYW92mF/UoBBQ/5QqvONjUpuMltkQ8UDHOHoOUHdi84w/cY8zgs/UM
 psnCIk3LJco+MLRk7YAY1Kka7KAve/TnBvlE+7HeTLk8rhBqHOTQN/jqKfNc68WKje46
 OattRGnPkjoo6KM2WBKLS6A0vVHxtgAdeCVHoHmUzYzsGcc1H+5sxddMVoa89ZEQjQYL
 zLuK9LqYn4XcPR6j+2UOfvbPMm0HLlGFVmDX/pNfZRu1kEbG7QjyIvuX2C1jDb266PKI
 Emd4v+TLLZ80ActgKVTravGSWsKgS+vIqwoSkYjSqlYdjB2JUHuhO2Kmip035NdbOjRH Vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3cp9gku3wg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Dec 2021 20:45:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B2Kfoco167559;
	Thu, 2 Dec 2021 20:45:06 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by aserp3020.oracle.com with ESMTP id 3cnhvhc0qe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Dec 2021 20:45:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DRAryt1TdTEyg9JXgDC7tTInHJNphk92Hys+W+32UF2m9fpljIqR8Lp8Ot/jT8RgrKNRqD9hxN9fdFdL2p3/gIysM4WXjqwDPM+u6eUSqkPRPKmNNTpvqvL2TI/qcvNjTTM2S3j9baFwZmB1fSW+9Y73HI8coFmqn+dDsgDgh6qRrx8VYuxM8S8dVaSZtMEtQeVpQm9mQPaijxRRUkp+kxtjZ/PHfmwB0+ECkPIV/vaLg9AB4jtKq5A2JVdeV/RfSdMeRQ8CFWZ8srwUr4ZmOiVPbgkNDocOXECQ83McftiLcfBJhjXApfMF3mn/OSYv1DsLBJZWXQ7Z+HXIl6H4Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/nhO1hp5r7T4ndz30RLhGRKUHSmXEH+wbvbCgGKJltI=;
 b=afOkw0qSrqOC9B7F26mPvLQn6YbvkVLoLAlwfPPOSMnWPEBbwAgLPVf7uzBJecMzg6JCfMEFff9y/F1y1YuBDXSyyCw16jSolU1P+GkwRUjtoJFcVoLgiwdE38IXs5/mXwKgVSCysqsr95bMIO5Gizyh1P7hi3jlzgG+WjG7fYrKbf4Wg1+GheGeHD0pd0LVSrbBaTb0gtp1OBveeTurH24+++doF4oPNwe7aRQm0oSawEdGvDcfd20O6nNNHPEbiZXKnvwXsoRmjq6KU7ywRzIb8vSajd9dZrHr5dbF9D63Ec703jZQUm7725bovAGC6OhSFFo6FF7NqyhZU3XuOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nhO1hp5r7T4ndz30RLhGRKUHSmXEH+wbvbCgGKJltI=;
 b=E5sMIp7L7B5JiXqS+jPi1cx8GMIg//0bmOvjTsw3o8xf4mmaEPLivApJdA/x32/d7sDySB25zI8w2mP0JatS90376YmqUEqtmxXEn3145PT+0GHICOrDxVvDcshVaYsHuM6p5pzVkb2FKu+n0v31ZYvHGmYExPI7bj+a7ln4fEM=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5186.namprd10.prod.outlook.com (2603:10b6:208:321::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Thu, 2 Dec
 2021 20:45:03 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09%5]) with mapi id 15.20.4755.016; Thu, 2 Dec 2021
 20:45:03 +0000
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
Subject: [PATCH v7 07/11] device-dax: ensure dev_dax->pgmap is valid for dynamic devices
Date: Thu,  2 Dec 2021 20:44:18 +0000
Message-Id: <20211202204422.26777-8-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.24) by AM0PR10CA0049.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4755.16 via Frontend Transport; Thu, 2 Dec 2021 20:45:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e6614e0-5e9d-4ff0-1351-08d9b5d49d52
X-MS-TrafficTypeDiagnostic: BLAPR10MB5186:
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB5186AEE3C3569D9A8DF5259FBB699@BLAPR10MB5186.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	5ce/tU01/yS16STO4xoosdYM5BZ5lufTz+gJ8XYfXdv63CpeY2MDckF+5fZoZzfkUIpIANFzSemhvkBXHfiionpYp2kSdDy9ttNusuXL9Sjk+uMIl2RJZXYKQoLimRXqOPJ7XojrfS0hh2cAw2o2HsoZagLhDN4wLl1khUShfs/4rrqJS8T9P0jUvwAR75z7z3U9cJcKicNn2lH++Uq/tj731W8qe9xkq5W3PQly9ckrCnUBmGh2LB9hTVyjMyMRpDrZ+EUWXCSD86Y9DQNakZdpN7BjieDv0uyrwdcEwqHv8KHJyqpDEUUruCnwQgN0IBN19K4d+uE100UiSRwk3ADR5ou04W4kwacSNw3mBzO/Yf9BXx+dpUxxgX7MQ3kNfKEzOM2Nn1x6MLH8SGWeed6VkhwwbRztwZ62Po3VanFQsfp/oafeK1LRv0MU4ITiYhcFtR6g3rmDHwVgHeeRvhCfiDjLjF6lxOWkqtPWqKszGAbNisD8Q8NjnF7OzoWNhNbcxAjs69LNkcvyhfVpO5ffyT6u2Dkqd/2MkpMk7w9UX/okny5y1JVHhg+M1x9F2ozGdM2nnCZq08fedOv6GUnh7Xsu/S+lOdGBWJsxXm5otgHIA8Mk4aTXuPLu20a4P2BPbPr+W0/Wqy4iVK6gR8AN8bdIPpmP9rBK/Xa4qPSWs8sIxZV7MCLBkLylYUF95ncO9PkMdeMJu38JNOZb/w==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(52116002)(7696005)(186003)(66556008)(36756003)(8936002)(26005)(6666004)(1076003)(8676002)(83380400001)(6486002)(107886003)(86362001)(2616005)(38350700002)(5660300002)(6916009)(38100700002)(103116003)(4326008)(7416002)(508600001)(54906003)(66476007)(956004)(66946007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?zO4XXTOD+RSivhRcEmPVQv0fjln3PaT9Dok4CcRHH7YzF90Jy01YLHDhzPu3?=
 =?us-ascii?Q?eHu7VgHC0B3bmEI+kAesey+Y7HIqR5umuaf615j3Tb6vZbWUWWhbbwuYso4B?=
 =?us-ascii?Q?qgNWJV3PJuU5yEODAsu3XxEC7ly203UPNL9sbWS1OANmpnFZXx/pyEiauY8K?=
 =?us-ascii?Q?Gg98Nn04YrsdOgbWeftasd1sSXWQhobU5lsoZXqAwyox9SWZ89x4SoBImyxZ?=
 =?us-ascii?Q?uWEsLcVz2fV9IL1qVN9lJLWhZMs+/RMcP8NIx6IkaPVlTSGfYy8As6i6Sfzg?=
 =?us-ascii?Q?7Ixukmtrrn/uMKLI0dY94kqBFZj1qozHnD6bIstPWvxccx3aVbinj7MTmKCQ?=
 =?us-ascii?Q?K4E+MSQkrwxFX0Dh9dmGXv3pUUPLTB+6/APoGurBYM8N+ZXBsk2WnmWX4FeG?=
 =?us-ascii?Q?RdS6E7TULvNS0tIA4PcsSIDnVgNwkEyeDhLZBezp+esnxbtuiGvPPEuMUMkt?=
 =?us-ascii?Q?4YrBaXL+jZ2jfc2rHtfvWh6p99bFoK5zjTwv4Cnd4eg/oJf4vVQvQWYe6mcU?=
 =?us-ascii?Q?km+sKbxGx26ooXf00IiqsllRxJY/8ZO+hdk0xfu7cQR5Ck7v3XN/AuRHjbP7?=
 =?us-ascii?Q?byhaRXfhlGVxt0LjanX8XDzVgo3flB+6fjsItkkee9Mi8pHe/izo/qLs3EKZ?=
 =?us-ascii?Q?YoRRyCWU06Z/nbYdnhooXJUk3/2ZWGWb+0OtWN5+I+WPFtTjl6vAGhRsn/Wd?=
 =?us-ascii?Q?pKyw0mwFjiyfFj65jVRqmVcGyOagGOCDXn6SdKTmzPK5r/WhoG8Hw3Zn/32B?=
 =?us-ascii?Q?m/abzFwj9Dt5x3x5HqSf8x1N7LvR1JhVDY2JnsBVdXwUf9M5cgos5nbF+sW2?=
 =?us-ascii?Q?GgLTPc/N4+MdxfZYGRhsuBQEmDw83pzLnzDFRGahdsRrfUHtKZlmSIPqWJLa?=
 =?us-ascii?Q?MyQbb+LXB14e02ZXj3k+rU+RWxK26s03JeJE2RejaTepOYZg9peh28jOkch+?=
 =?us-ascii?Q?iVpyVyZplypkGFNxlJrxILXDNuNbyKQtee1R/MzSeYipqwSQZbeuxYDY3Hae?=
 =?us-ascii?Q?D9At9bZLG+0HVlfCr6t+gDWrPXnZCmSgqw/g8ylR/Ymli60VjqqsrIkxG379?=
 =?us-ascii?Q?QBUFflYQ+Viwg6XN7kW3gjVYJcoM0Xv/93AouxP2Ad7E4M9yieWwpah7fFdI?=
 =?us-ascii?Q?Co6sLhsbI53xadhyeW+swjRjFfQSrBRKmhvSIxkPynS19zAqrwd8ayDnE6l3?=
 =?us-ascii?Q?NwF1qjR9zltlFwrvm27wqG4GHBY3HlgUl2E80n3Gtmq/wXsSBgfcUEFV4wwX?=
 =?us-ascii?Q?Lpvcsm2z3gVCUhj9DA5mp8HNjkPABoCvCV3gGYqUcbhaIgKU8KqDrcgkcZTU?=
 =?us-ascii?Q?XpkvghPMk3et1KKcXRkaIPHmyjSvtVK/VEOAg+yM7s5ni4wGw8ezO7tSKkpi?=
 =?us-ascii?Q?sxjuyDgRmzOmaD29oTfncIKvLCMYGl/NH5iv2vkOUY/0PJxnOFOrr6Myfb1q?=
 =?us-ascii?Q?ozYM8iso4SFdPqZdMQDkPivUgLuImt81quWBEZ4dw6Npto4TF8AOpXcDHPaJ?=
 =?us-ascii?Q?zhCEw9uOqOxsuRm1e5U1/8R+qSdDJE5PARm4YJfdI5mU6OHAA0llVQgZCNqs?=
 =?us-ascii?Q?NkOrsdi4oQ2SKtCs1QmStfb8z0QV7zjr4NIxyrM4zhm4XZXE7T2CYGOl4hJW?=
 =?us-ascii?Q?b3WrQ/XgQWMhmOky/oKPVxjh9eWSI69kUWgyJiHhOKq4wmLdDatTdLGLvhEw?=
 =?us-ascii?Q?KpE+6Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e6614e0-5e9d-4ff0-1351-08d9b5d49d52
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 20:45:03.0950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QpVE3z/Bf+OPUN4aKXciPX3U0/xj9PVa9kJv2I3CVyDu0Y+o0Vb1S3cAaC3tXQu0xWS2XttSwzBHXriZV+7LuHpyc3jeHi5FDZZX2FheFSQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5186
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10186 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112020131
X-Proofpoint-ORIG-GUID: sO-ZT9QjA_Kx5YM33a1uoO_lOgpzDxWm
X-Proofpoint-GUID: sO-ZT9QjA_Kx5YM33a1uoO_lOgpzDxWm

Right now, only static dax regions have a valid @pgmap pointer in its
struct dev_dax. Dynamic dax case however, do not.

In preparation for device-dax compound devmap support, make sure that
dev_dax pgmap field is set after it has been allocated and initialized.

dynamic dax device have the @pgmap is allocated at probe() and it's
managed by devm (contrast to static dax region which a pgmap is provided
and dax core kfrees it). So in addition to ensure a valid @pgmap, clear
the pgmap when the dynamic dax device is released to avoid the same
pgmap ranges to be re-requested across multiple region device reconfigs.

Add a static_dev_dax() and use that helper in dev_dax_probe() to ensure
the initialization differences between dynamic and static regions are
more explicit. While at it, consolidate the ranges initialization when we
allocate the @pgmap for the dynamic dax region case. Also take the
opportunity to document the differences between static and dynamic da
regions.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/dax/bus.c    | 32 ++++++++++++++++++++++++++++++++
 drivers/dax/bus.h    |  1 +
 drivers/dax/device.c | 29 +++++++++++++++++++++--------
 3 files changed, 54 insertions(+), 8 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 6cc4da4c713d..a22350e822fa 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -129,11 +129,35 @@ ATTRIBUTE_GROUPS(dax_drv);
 
 static int dax_bus_match(struct device *dev, struct device_driver *drv);
 
+/*
+ * Static dax regions are regions created by an external subsystem
+ * nvdimm where a single range is assigned. Its boundaries are by the external
+ * subsystem and are usually limited to one physical memory range. For example,
+ * for PMEM it is usually defined by NVDIMM Namespace boundaries (i.e. a
+ * single contiguous range)
+ *
+ * On dynamic dax regions, the assigned region can be partitioned by dax core
+ * into multiple subdivisions. A subdivision is represented into one
+ * /dev/daxN.M device composed by one or more potentially discontiguous ranges.
+ *
+ * When allocating a dax region, drivers must set whether it's static
+ * (IORESOURCE_DAX_STATIC).  On static dax devices, the @pgmap is pre-assigned
+ * to dax core when calling devm_create_dev_dax(), whereas in dynamic dax
+ * devices it is NULL but afterwards allocated by dax core on device ->probe().
+ * Care is needed to make sure that dynamic dax devices are torn down with a
+ * cleared @pgmap field (see kill_dev_dax()).
+ */
 static bool is_static(struct dax_region *dax_region)
 {
 	return (dax_region->res.flags & IORESOURCE_DAX_STATIC) != 0;
 }
 
+bool static_dev_dax(struct dev_dax *dev_dax)
+{
+	return is_static(dev_dax->region);
+}
+EXPORT_SYMBOL_GPL(static_dev_dax);
+
 static u64 dev_dax_size(struct dev_dax *dev_dax)
 {
 	u64 size = 0;
@@ -363,6 +387,14 @@ void kill_dev_dax(struct dev_dax *dev_dax)
 
 	kill_dax(dax_dev);
 	unmap_mapping_range(inode->i_mapping, 0, 0, 1);
+
+	/*
+	 * Dynamic dax region have the pgmap allocated via dev_kzalloc()
+	 * and thus freed by devm. Clear the pgmap to not have stale pgmap
+	 * ranges on probe() from previous reconfigurations of region devices.
+	 */
+	if (!static_dev_dax(dev_dax))
+		dev_dax->pgmap = NULL;
 }
 EXPORT_SYMBOL_GPL(kill_dev_dax);
 
diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index 1e946ad7780a..4acdfee7dd59 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -48,6 +48,7 @@ int __dax_driver_register(struct dax_device_driver *dax_drv,
 	__dax_driver_register(driver, THIS_MODULE, KBUILD_MODNAME)
 void dax_driver_unregister(struct dax_device_driver *dax_drv);
 void kill_dev_dax(struct dev_dax *dev_dax);
+bool static_dev_dax(struct dev_dax *dev_dax);
 
 #if IS_ENABLED(CONFIG_DEV_DAX_PMEM_COMPAT)
 int dev_dax_probe(struct dev_dax *dev_dax);
diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 038816b91af6..630de5a795b0 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -398,18 +398,34 @@ int dev_dax_probe(struct dev_dax *dev_dax)
 	void *addr;
 	int rc, i;
 
-	pgmap = dev_dax->pgmap;
-	if (dev_WARN_ONCE(dev, pgmap && dev_dax->nr_range > 1,
-			"static pgmap / multi-range device conflict\n"))
-		return -EINVAL;
+	if (static_dev_dax(dev_dax))  {
+		if (dev_dax->nr_range > 1) {
+			dev_warn(dev,
+				"static pgmap / multi-range device conflict\n");
+			return -EINVAL;
+		}
+
+		pgmap = dev_dax->pgmap;
+	} else {
+		if (dev_dax->pgmap) {
+			dev_warn(dev,
+				 "dynamic-dax with pre-populated page map\n");
+			return -EINVAL;
+		}
 
-	if (!pgmap) {
 		pgmap = devm_kzalloc(dev,
                        struct_size(pgmap, ranges, dev_dax->nr_range - 1),
                        GFP_KERNEL);
 		if (!pgmap)
 			return -ENOMEM;
+
 		pgmap->nr_range = dev_dax->nr_range;
+		dev_dax->pgmap = pgmap;
+
+		for (i = 0; i < dev_dax->nr_range; i++) {
+			struct range *range = &dev_dax->ranges[i].range;
+			pgmap->ranges[i] = *range;
+		}
 	}
 
 	for (i = 0; i < dev_dax->nr_range; i++) {
@@ -421,9 +437,6 @@ int dev_dax_probe(struct dev_dax *dev_dax)
 					i, range->start, range->end);
 			return -EBUSY;
 		}
-		/* don't update the range for static pgmap */
-		if (!dev_dax->pgmap)
-			pgmap->ranges[i] = *range;
 	}
 
 	pgmap->type = MEMORY_DEVICE_GENERIC;
-- 
2.17.2

