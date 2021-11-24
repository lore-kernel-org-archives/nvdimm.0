Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AC72C8B
	for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 19:10:54 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AOI2smC031388;
	Wed, 24 Nov 2021 19:10:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=/nhO1hp5r7T4ndz30RLhGRKUHSmXEH+wbvbCgGKJltI=;
 b=WJyhhANpWM9evjMWwUScPAHaQvu7LCW1rJ6bnoeerI/DdRHiHXB6IE9OPBQmtFlwslXA
 UzuzvNbEGDKHnG/YEkVyuRYZJkq+652Q/eWHfWRRWK6z0aqdAfsZ7Ap7EY8dkeqQ4CQJ
 iaqN8ArZyRCEsl5732bhmcbrdkXyzBevhFNzWxaIiOK5LarVG9FRpIHCwMJgH9sCw2wb
 o1F52X9DiaWCXY6slwyZK355s6pVqBRayyWfYEKg7mO3InT9DFKUC8lZyX0kySpO00CB
 kdXhM55fnMl6SC0wKBThZdMrP4N4ybXjVsv7pgIgEevSvYhgo2n6Cq0K49OYmqc+B4Bp gw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3chmfn2qu5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Nov 2021 19:10:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AOJ13Wt037264;
	Wed, 24 Nov 2021 19:10:47 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
	by aserp3030.oracle.com with ESMTP id 3ceq2ghywu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Nov 2021 19:10:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cxvAtHFa4mi/MOvh5/8+iX5Nn9sLI3O/xlNL4p8dCNEX6Tk7pFp8OJaGoS1hSa/p4zBGX8RV/O6z7abl/G535WNwLb1T+/Tzgxk8xMrf71WfATNMK0EC07LP4QJH4CmC2tWPbBqlJQxVHK71b/UH0b2PEaRgokzot4scaribdOXsiSCyaoLifK1g/Y7vhR1Jhe5aT06y3xf6nnTlSUd7MBVVvexN0BfABG1ZNnkSHP0boRtquaf60OzWZVV8AonXlVACbYJErxXMP+4dhI/Ua1H+dRV5rLPNnCGAwqIkatuvplF/Dwe/uxbEM2bhYruVuspc6rsNLzuNrNLt57cFrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/nhO1hp5r7T4ndz30RLhGRKUHSmXEH+wbvbCgGKJltI=;
 b=iCLIo+ywPU4GtTtuRtxMqFzchCn7thpA7Aes+CWT0Mo6iuYen/8qUJyxdjrzTMcmZheztT8dzSKvugjIvl/Y24wdM8d9pMm+5axeOqqttT1nVyc8E2rRp6gh8WSCKNMgvhcclYm+HyKJsOj7tN3wt2Z2xr89mtYis3ff66XLouN+WHuIR76/ncpThrzLzO/fFh8MJs6hrXVZvtLKo/mJx+UT0BQssQkd5oMgHIxn+gPbZ9ghR4YILCx9JdCdH/hhemIFbY9rTqe9q5VHazKzUcukrShRg4UbRdP+tnOsOlviHMSgbFZbIPtdjSoGVYVfaF8i3S32xGheRjqXwQioGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nhO1hp5r7T4ndz30RLhGRKUHSmXEH+wbvbCgGKJltI=;
 b=B1Q2nJl7sotF0HA/32ZNEMDJWlw1eSB97DCQBIA6exLrJhXDLfOH2SLtGgE1Q/FeaSiRPpNDscDuefNnr7dhNTomoiRz+ShwA8jATL1G4yYhHx23Gtdcz06oDIgoWt81S24zmS7BKwL3T+/IrAmoW1sQ7uD1j7jytmClQxvyfFQ=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL0PR10MB2916.namprd10.prod.outlook.com (2603:10b6:208:77::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Wed, 24 Nov
 2021 19:10:44 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%7]) with mapi id 15.20.4734.021; Wed, 24 Nov 2021
 19:10:44 +0000
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
Subject: [PATCH v6 07/10] device-dax: ensure dev_dax->pgmap is valid for dynamic devices
Date: Wed, 24 Nov 2021 19:10:02 +0000
Message-Id: <20211124191005.20783-8-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20211124191005.20783-1-joao.m.martins@oracle.com>
References: <20211124191005.20783-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0093.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::34) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from paddy.uk.oracle.com (138.3.204.47) by AM0PR06CA0093.eurprd06.prod.outlook.com (2603:10a6:208:fa::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4713.20 via Frontend Transport; Wed, 24 Nov 2021 19:10:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4473e54b-dade-4728-6431-08d9af7e1d57
X-MS-TrafficTypeDiagnostic: BL0PR10MB2916:
X-Microsoft-Antispam-PRVS: 
	<BL0PR10MB29166D8AC4A7368CC717D869BB619@BL0PR10MB2916.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	zJiIVI+mS0I+moKCMSWValB9d2NeyulRBLAViiT8F2JUKyZbEwZiBSPhM0P1oawWWyFK/aLyblcB79Enz1RDPMfAsnq3js6fsV+qxq+pKZ3XiyyFBRITA7/r0cXfVNsjRZZLw3y2CSylCwJBr8H5zPMVFiPHGARLCwXiPWaNM1LiMR9COinfxrmgIF79S8rExZrJl7bTw7K0+8pAcKU1Bd9t/0tApyczrnslDf1JhniH8ii3a2vNIvEwZzcTAPdHMtBR2adJcU2rgmFpYLMZxIMDkIcFYbPs9w4fGWghECrSQxyaB4/v65pwdJl28ciAikryTMOna2VhB356nXkYxpcoKgzbyt8+60AQaLTBI3F78it9bDI/QPJCxR4dKl0tvbDMXL2mFnwQCLY4bG54+/Yn1gzTRU4c3dCBGpYHk8vfgFqfCJHaM3yxDptIOexEoo1S0mv123qnm756L5y2OEJ6YPcORiG89pyyqZPNsdyMIr2h9BpnXwLoH4y8mRfstjqTb4llI061GaiECK9PyQQjA784lSzGac82pjd8S+1hFpaLNT8K0d5zoni8lds4DRSpo7vQWFmWfq3LU8QVCOJYBYc74URP6Qd0+FzrZMeQ8YTUijfOfKOX+j45xzLkAHiHiStAx66thfWFlimTKte77c5BAnLU8oYNL2bs03lwX8nsyx5ueMLGw7NM4/RLcWbwur+dF0GH/ZVrAbW7h+VtrjiLt09dKED9fwjcnLB4n6N7Y7bqzsi6RyrlHcMa
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(5660300002)(103116003)(1076003)(36756003)(107886003)(6666004)(956004)(54906003)(7416002)(38100700002)(6486002)(2616005)(86362001)(8936002)(38350700002)(7696005)(52116002)(6916009)(508600001)(26005)(8676002)(66476007)(66556008)(186003)(2906002)(66946007)(83380400001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?KxT23KISPC8Xyq5/rL8CmVzCCAotvGOHjyNzzpD5A1IfnTqCxrglsVEsUmPG?=
 =?us-ascii?Q?Cg4FtJgXzaybUQYC6NoWRjLaDfTFDYc8QVng+EX2J0dQqeM5X2GNwVbpbs5e?=
 =?us-ascii?Q?+g3lY6XmaDzQjwrrfAxJGu2H0X1GvfCndhdI9+fc9AcqDZx7rdXazKS9EegX?=
 =?us-ascii?Q?suVkJHumUJLV1o20JASb5Ylrdv92Xis9PlTOV05up+zDdlYsP6MgbWnj2cE7?=
 =?us-ascii?Q?fgkHInQX2JEmmXWJ7d5ZIN960mEO5TCeEGw04iyp8bbSLO+GvVNg3F7qPjEY?=
 =?us-ascii?Q?VQZ8XQ2UewMceNkIqze+HD6BnRuTZYoZTKhfvXSUaWLA5PLykFb51l0DoEOS?=
 =?us-ascii?Q?1j6uSU6TcidaOXdpFEnzVAklc3vGa0sl4aFRgqHb+VXQTSJ6m38alUSfhDD4?=
 =?us-ascii?Q?SIDbNUNnoxet29sfujCoj49Nz8Z9nRQ6t1eCDPYIsQP/+8b7XZoGk5Zzud51?=
 =?us-ascii?Q?cpw74B6YeU+JGgvi+gZwaRE694OKdUYVgy1UGOKtLUwgT6445s9z8xUcV+LE?=
 =?us-ascii?Q?+Q35RI04ADz7t37+53ku5y5pm6ylvTH4mN+8WkGis9QjDmQOPh5x4U0FOsDF?=
 =?us-ascii?Q?eXJ8cbjPYiIsK8mmxn1qM8r3h7KxE8LY8oitoRHXagW1WKpn2PtXF0TibOOf?=
 =?us-ascii?Q?LZ1ZrqQQjdbo1RL9+no8iG3vQeePPYxzWH6wkuqVMl8xQuhhxqlqXo/y53JK?=
 =?us-ascii?Q?cWwMZJMQMxRWOJViFE1lLFZWdzt3CNZFH2QC+GjmPtGoWdTKpHqih1aaMo9m?=
 =?us-ascii?Q?NJhNdNnfxSq0yHUHdV+3pRdFNy8+r+VSiREuHvQS/XO6Oh7xUkpWWs764Yiy?=
 =?us-ascii?Q?t/A57Imp5InBZqAI3c1BK3rlDuU2JJFcSzhH+VPPF0QefEM5gok4hhZnCf8y?=
 =?us-ascii?Q?1Ut/NSRaJ8wx4DgATrOW+veXhW2wUI+bNJ4TRPZFgbo1Wmk5PRJIcsVvekh4?=
 =?us-ascii?Q?clzPsn1cW4apc2DBnuKW7f8ZKlIrSnDZOVd3HvZPjzW5XvZYofZogEQbYZgB?=
 =?us-ascii?Q?lcbrV6y7KxACnMCI+Nhf8for2x6kC9AHm93xZjAYm8o+kYXBv3h7DfclkkBv?=
 =?us-ascii?Q?ijDwuKp2VOkal+AQ3COk3BTEaxAX8mKjzVPJJwVeJGh4kIIuWpq4EiRMycQ3?=
 =?us-ascii?Q?kbJaMUYCKcRTJDtLIGq53qmjUZPtXEZe7cGsKA2Lufe54KKpzIIqmbJuepWh?=
 =?us-ascii?Q?UcFGHA3V90sX3mCHVb/JXn+vHZdNIpDoCTsTln2Xd1MZcaBZRjHblSkmGzC3?=
 =?us-ascii?Q?VwQVZB3zhFuGK8feQOB6E8/y4CS0+eI3wHExjCbnvkKX6aCdQT0OQMnOCnj5?=
 =?us-ascii?Q?W/xqvoTYWBQjIRAbJY0jYAeQlF80S1RaWmnGqyCqb9N148BMd23+ZMRG/T4J?=
 =?us-ascii?Q?nNeMTQ8XjsrNn7GKfBO3W8Tb0G1eUM56ZTm52gYzpUzv50FS7Bq76iLw9/0g?=
 =?us-ascii?Q?c2NG1iXxURY1R9zRmjYLHO3ernZBllVizBNCbg+lZ3tM9WUTOpS81Q38iqbd?=
 =?us-ascii?Q?K/Cq47U/4UfOO0wo/j1y8JR8vvHkR6wJutoSDIba0oYbXvzkOHmeQfXkfPkU?=
 =?us-ascii?Q?OLtNSS3Gfz5qgMmGw6kIoQNs1vPYqTYCJPOMIEGUa81qDpUHPKGoG6jgbHWN?=
 =?us-ascii?Q?B3H0xOwWG+K3273RVgCvPhdT0F7HPUk4UvuSXiXjULU7sdLeu/SxxG6UcMDN?=
 =?us-ascii?Q?+A7wxQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4473e54b-dade-4728-6431-08d9af7e1d57
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 19:10:44.5211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bYSzIueGzjlnpLCU+Zj3UfOO1gC0fBu23Dhan7h55gOXbLoekAaKTU8IV9xoUqOjjPdMo7kB856qABbHEVBLrCSgaSJUe9kCTjCfnm6rI8Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2916
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10178 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111240099
X-Proofpoint-ORIG-GUID: QwhXKrp3r8Y_pON-73azZb4yQuICCg7Y
X-Proofpoint-GUID: QwhXKrp3r8Y_pON-73azZb4yQuICCg7Y

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

