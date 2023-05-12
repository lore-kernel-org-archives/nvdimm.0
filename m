Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2079.outbound.protection.outlook.com [40.107.93.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BA2946F
	for <nvdimm@lists.linux.dev>; Fri, 12 May 2023 10:43:41 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FmoVWNY4ifPNJsbEWlMtKkk40LfZGiEh1jxoIVHmSth4Jz8ug7ynsqhye+Heg1/WXIlFFBkfDiyYbfkNWkSsAmRBhhsFzKs/ZbFPPypubSjGd7l22uBmfsu873o/FRPAKbuSPl5BZg1e9egR96vENXAsEnVQiFrPz6CSTFmAczKvY3d/5TFXXt7kMvHz/6m+lk5Q+RyzwCmnAT2gYhk/OlkRyiiG1dhwlk3ihWTGSaFbzAVDP18t1ijM6oI1ohBetRGnHNClocKht4UNLA3JslyKuSnX9ICHanTF9qGsUqSFJAjbKRbjavoKOfJWCtlT/ZYE3hbtcPy1nzPNpVPjyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QkNHzyEKycFnNzmt4k4EGQUS19YxZyR7Comn0HwfwCQ=;
 b=moPYZzPWSQp7GMNrD6V5SPmoJZUj5NVPSNyyPrDExWU6Y36ba+tJP5asAGRs6lZKXwVW8aEcQqh2CCOtcsV/CFpv/eO9oCX9qmdPNp/K0v37+VkNpz4bm20muu1p/LPi55DwHhKZK23OSxSDSFy4PUgbfMILOlmkOa0MeGfWNwGkiAOgRqBMqXkkj726vQzZ9xgVKoulJxdTuWhBXAbfj9l+CQDEg5m6CVxumeF8jNgzosPOsuxIWpORFfzwXvVINhyxThf+WS9mEp1n+E0ydGwamgkRPccQf9VhxEgcY4yjt+yTh18+yboXvK88+AP4tFNrw64wb5rpYAHaeQiGRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QkNHzyEKycFnNzmt4k4EGQUS19YxZyR7Comn0HwfwCQ=;
 b=V2gRttQQ5YD/pzj2nXmgZKsM8kl7ViTe6A8x7iMz8ktvYDvT1UeCT1NARoDc1nETYpPaqe74FWOA/gOw1tD6AYjkoIB+rl6fY+w7SxB/errEKZmWr63Mf5fKFkFZ7D085Fh6aY3RUVHu1NfgSyMYM4w2gUiyCsFxBM7VVegl1mA0kHNfp+GOB/ff3TKSA8F+IZzoklaoYur6z2skzKuMkul8gbJBOHCnsJeL8YeQtDVyB1xajjBJQMmczWK1mypt52UkFnDcDR5i5BI+UKahvwG8N/wWoC5dm5ZY3BM+jZVFCzDaWCZbaGjxKjNkx07SRuqVDy+2gfr4IMGm9Q8GSw==
Received: from CY5P221CA0014.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:b::25) by
 PH7PR12MB8795.namprd12.prod.outlook.com (2603:10b6:510:275::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Fri, 12 May
 2023 10:43:37 +0000
Received: from CY4PEPF0000B8EF.namprd05.prod.outlook.com
 (2603:10b6:930:b:cafe::e6) by CY5P221CA0014.outlook.office365.com
 (2603:10b6:930:b::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.24 via Frontend
 Transport; Fri, 12 May 2023 10:43:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000B8EF.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.5 via Frontend Transport; Fri, 12 May 2023 10:43:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 12 May 2023
 03:43:24 -0700
Received: from dev.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 12 May
 2023 03:43:24 -0700
From: Chaitanya Kulkarni <kch@nvidia.com>
To: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>
CC: <nvdimm@lists.linux.dev>, Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH 1/1] pmem: allow user to set QUEUE_FLAG_NOWAIT
Date: Fri, 12 May 2023 03:43:02 -0700
Message-ID: <20230512104302.8527-2-kch@nvidia.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230512104302.8527-1-kch@nvidia.com>
References: <20230512104302.8527-1-kch@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EF:EE_|PH7PR12MB8795:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ee83d12-67cd-4a1d-9137-08db52d5bdc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	EcnixX4MvwyDXSsp9pUBhnMYOyL3TJRuUcJ+tJ9o9751IDYk9Y3X7sH9Zogi5OUWRroILC244QGL9lsOgQbIXSPpRSUs+8JzPGx3U+hwp6CwUDVoflfD/Ak5I3LzrjyUQYWVEHlzvkOVgwdzpgAjTR7Q23W7d2FjxuGj3JMFADzAXqU9BPbZ0IZozDCapeWdlhc2vK1zi2PLBM5CxAlICXHbuO5U221/8KyALPOLmSh67MVWX7yHo6Rt4Ymp4BV7wrn4gUBnLi3dBZ0LbWOJKThnZSmfA+S/LhLSe5tGXE1ja3Qkh3WiEqcj9PEmBTCZBYfUHyE2Q/dYTpP6eYxsW64YHeqpo3vsDEjd+XL1nqGQTxs7t0fgQQ5Zq89lFBwAtQAZ3Fc8GNje8qFI+1CJLcds2DeV9bXMmtmgf0A/YAaQFJahB1Fv5m+IUKQyZeklr8MGMdNUCcDnAuYrNhnwm+xNZJBWONreKS/9rsYjOqWfJzIZGH8fewm+b6qiAK9VdWRjJKlqh4Kti8HaazB3q7GZTPtUWo1IUGmLwFP5MZB7kIIgf2l+VLfB9zASEVb6rMqsFWezTZQFWO0lvySDbdsN0Jv6db4z66Der+9xLUsPegpE4uZjWNSDhz4+NLDGDOGgpwNHrq8YaT6BMvKHAY5Amp+1ZVOCT3/Ek9OqH3dh9kp0OwwkFsE7UEcno0fIYWZSYo7DzzzWO2GObzObdPfTCg9N2Sv1Y/Azkjj/AU8nd1oDeZrUIGWEglF7E2Ql
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(39860400002)(376002)(451199021)(40470700004)(46966006)(36840700001)(8936002)(40460700003)(2906002)(336012)(47076005)(2616005)(316002)(186003)(426003)(16526019)(4326008)(36860700001)(6666004)(83380400001)(41300700001)(54906003)(110136005)(70586007)(70206006)(1076003)(26005)(5660300002)(8676002)(107886003)(478600001)(7696005)(40480700001)(82740400003)(356005)(7636003)(82310400005)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 10:43:36.7291
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ee83d12-67cd-4a1d-9137-08db52d5bdc7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000B8EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8795

Allow user to set the QUEUE_FLAG_NOWAIT optionally using module
parameter to retain the default behaviour. Also, update respective
allocation flags in the write path. Following are the performance
numbers with io_uring fio engine for random read, note that device has
been populated fully with randwrite workload before taking these
numbers :-

* linux-block (for-next) # grep IOPS  pmem*fio | column -t

nowait-off-1.fio:  read:  IOPS=3968k,  BW=15.1GiB/s
nowait-off-2.fio:  read:  IOPS=4084k,  BW=15.6GiB/s
nowait-off-3.fio:  read:  IOPS=3995k,  BW=15.2GiB/s

nowait-on-1.fio:   read:  IOPS=5909k,  BW=22.5GiB/s
nowait-on-2.fio:   read:  IOPS=5997k,  BW=22.9GiB/s
nowait-on-3.fio:   read:  IOPS=6006k,  BW=22.9GiB/s

* linux-block (for-next) # grep cpu  pmem*fio | column -t

nowait-off-1.fio:  cpu  :  usr=6.38%,   sys=31.37%,  ctx=220427659
nowait-off-2.fio:  cpu  :  usr=6.19%,   sys=31.45%,  ctx=229825635
nowait-off-3.fio:  cpu  :  usr=6.17%,   sys=31.22%,  ctx=221896158

nowait-on-1.fio:  cpu  :  usr=10.56%,  sys=87.82%,  ctx=24730   
nowait-on-2.fio:  cpu  :  usr=9.92%,   sys=88.36%,  ctx=23427   
nowait-on-3.fio:  cpu  :  usr=9.85%,   sys=89.04%,  ctx=23237   

* linux-block (for-next) # grep slat  pmem*fio | column -t
nowait-off-1.fio:  slat  (nsec):  min=431,   max=50423k,  avg=9424.06
nowait-off-2.fio:  slat  (nsec):  min=420,   max=35992k,  avg=9193.94
nowait-off-3.fio:  slat  (nsec):  min=430,   max=40737k,  avg=9244.24

nowait-on-1.fio:   slat  (nsec):  min=1232,  max=40098k,  avg=7518.60
nowait-on-2.fio:   slat  (nsec):  min=1303,  max=52107k,  avg=7423.37
nowait-on-3.fio:   slat  (nsec):  min=1123,  max=40193k,  avg=7409.08

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/nvdimm/pmem.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index ceea55f621cc..38defe84de4c 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -31,6 +31,10 @@
 #include "pfn.h"
 #include "nd.h"
 
+static bool g_nowait;
+module_param_named(nowait, g_nowait, bool, 0444);
+MODULE_PARM_DESC(nowait, "set QUEUE_FLAG_NOWAIT. Default: False");
+
 static struct device *to_dev(struct pmem_device *pmem)
 {
 	/*
@@ -543,6 +547,8 @@ static int pmem_attach_disk(struct device *dev,
 	blk_queue_max_hw_sectors(q, UINT_MAX);
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
 	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, q);
+	if (g_nowait)
+		blk_queue_flag_set(QUEUE_FLAG_NOWAIT, q);
 	if (pmem->pfn_flags & PFN_MAP)
 		blk_queue_flag_set(QUEUE_FLAG_DAX, q);
 
-- 
2.40.0

