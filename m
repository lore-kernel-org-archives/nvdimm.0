Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2082.outbound.protection.outlook.com [40.107.95.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02D42F3B
	for <nvdimm@lists.linux.dev>; Mon, 31 Jul 2023 22:47:01 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bskyn9AsBFARxyrESKu6ph/x7akTVbIPRBWFReLthRddg4NJ0+vt/Lu1B7BssY5mzL5It6hjYm5WzebEKw+JMBulkBiMCT3D3s1VllQBuR3Zo1JXvcjsNI5pClylRcezUKznPdsD/lWs+LIelhgrFFVGhZqyv39iloyqKddsn3UmG2EEUCKkFpdiBcU/qLyFlWRMxBGCqcYzoWJfNC9m/VHnIDx1DeOBRJocpO7iYTjj/HjDadIWCajMDRhYfkiY7OLJ6RvGBZFOzeerAasWJ9uycjNg56Y3+cFYRVQY9yW23Fx6WABS8VCwJ1K7Vuv/rDGVIpwTcsR0XDcaMi0v2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9X4S9V3kNu1pNEfZ17ktkb8HsdikCHkodc/mEJc4m98=;
 b=fDRnoI4HvD/AQozamNH80hIOuI+ZzygVJlSmSdCBwZ3AJ2gJTHHMEp7lxEkxZ6NwKu33CNLZ8bm/V1T6Eb6qCO/pw0QCx3GRlC8rnOlkMp3xqbmu5Nj126q+gXpRG3SF7yS/vwcq06AygmruzsmOlZuQJN4zsag4XqkM/cD5G8jOF5sL7DLM8FP08Cg8rjvf6YQbz9+YjD5yCLAWKRi+Tg9me3TpKeIO4FNozZvdu0TTBUszB8NhDtuJi9FbOkMlcwiqbOl2JWFOK0ChJg+twWD0Ud4zmGqaa7n5WkrhJiHAcmcjh0lwHWOIP99gxWC9j5DQe7IB7rqNWjoVHDgyMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9X4S9V3kNu1pNEfZ17ktkb8HsdikCHkodc/mEJc4m98=;
 b=sPcmRVxE1OmHLisDwD0R65soeo9ZbfkLdGnsuwqD/bmkBTl3QAzExPbTFKqbwgtBWtOFmoEGB9weon1YhgeoJ08mJP4R+7GVnZ2/SIsNAnHZs40cqDoH4WgPw9eSbZlalx3+XL+MEpkzKBOYXGw5bu2G8JUMjkA1nHRQ6FPebWyoAmNzqHZub6PJpr8iDdojYayL/nhOyPRLqh4TfwyaDJxr3Hgi8viAsa84Yn+u4BkCeyYG9a8l/OSzFRA90k5/m+DzJqqGwdR14CojyFsNRxfdjl3OkpL3N+OlJJBydb6a9FDzN06SQvnktNBG84W14s9kE673yQrxPsWb4srcSA==
Received: from BN9PR03CA0667.namprd03.prod.outlook.com (2603:10b6:408:10e::12)
 by DM6PR12MB4532.namprd12.prod.outlook.com (2603:10b6:5:2af::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.43; Mon, 31 Jul
 2023 22:46:59 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10e:cafe::3f) by BN9PR03CA0667.outlook.office365.com
 (2603:10b6:408:10e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.44 via Frontend
 Transport; Mon, 31 Jul 2023 22:46:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6631.44 via Frontend Transport; Mon, 31 Jul 2023 22:46:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 31 Jul 2023
 15:46:43 -0700
Received: from dev.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 31 Jul
 2023 15:46:42 -0700
From: Chaitanya Kulkarni <kch@nvidia.com>
To: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>
CC: <hch@lst.de>, <nvdimm@lists.linux.dev>, Chaitanya Kulkarni
	<kch@nvidia.com>
Subject: [PATCH V2 1/1] pmem: set QUEUE_FLAG_NOWAIT
Date: Mon, 31 Jul 2023 15:46:17 -0700
Message-ID: <20230731224617.8665-2-kch@nvidia.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230731224617.8665-1-kch@nvidia.com>
References: <20230731224617.8665-1-kch@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT060:EE_|DM6PR12MB4532:EE_
X-MS-Office365-Filtering-Correlation-Id: cdef42f0-7fe0-4014-3a75-08db92180c67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uGwjhOVBGQ431tk+BvmbPU6AXkA61hFqQE5T/WhZl/9AonB9TiGxIRusavWtGr0g6DMH1Om9dN2DOzFk8hIUy1zXwWBx8yYJPx2vfkaaFgT6Zu280FPaNvdJAx2Lrtaf+346wzw63mEaRg7lXPFnACfesCMACGNYoNaj6NLWns7EtvK/1smTyWDGj1Y2ziihXUS8wGEKyPYnnfDx1nJUE6yrYEbpWNByh/mTUaDy13qzovxCzbBm2LueQpaAgLhB+HbPrps2AEBMDMFtnysqiDBkqIZdPNrGWcv1Jy5T97u1gi1hqFxhqOKpMkKQzoLhfTwGtWm3ol+igi24r8XmNwNvkKG5afSAYn/1NhApcsz3Mvc43CMtiQwBTgml1Dfrr4Pvv/NjdVyhOFrJhv2R3ljHPKhxgRIpAYrevcW8wP0OiPkQVwBbsetqveK5vbEgvxdZGCNhVJJSuGksXh58EWp+tBAyU6a0m2LqliLZbzb3bjpqUpdmceKv93bEcYm51LdwkaSSLX40ygmlX5Nm42nh3Y+XsblyjOn7lzXlA8iP0OAwXKTcX92QxUfL1gBktGPXzstWsTZiHi01dGYkLtYCNJvzpXStOivA4ojm2cuTkTKgM+LjKSZUqWI2BjLFKfaosRYhTa7mxPNGda5g6dXwikoStQRblNH3PJvzDYyU9C0ovHCktQr22zB/9UHAHwXl4x2SLqRQNjDpuvjtklIkdKB5x480XGwFj05hyc4+vKNAfu6p4Vg195SYdQsh
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(39860400002)(346002)(82310400008)(451199021)(36840700001)(46966006)(40470700004)(40460700003)(7696005)(6666004)(36860700001)(16526019)(186003)(83380400001)(2616005)(47076005)(426003)(36756003)(336012)(356005)(82740400003)(26005)(7636003)(1076003)(40480700001)(5660300002)(4326008)(41300700001)(8936002)(8676002)(70206006)(70586007)(2906002)(316002)(107886003)(478600001)(110136005)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2023 22:46:58.5988
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cdef42f0-7fe0-4014-3a75-08db92180c67
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4532

Set the QUEUE_FLAG_NOWAIT. Following are the performance numbers with
io_uring fio engine for random read, note that device has been populated
fully with randwrite workload before taking these numbers :-

linux-block (pmem-nowait-on) # grep IOPS  pmem*fio | column -t
pmem-nowait-off-1.fio:  read:  IOPS=3683k,  BW=14.0GiB/s
pmem-nowait-off-2.fio:  read:  IOPS=3819k,  BW=14.6GiB/s
pmem-nowait-off-3.fio:  read:  IOPS=3999k,  BW=15.3GiB/s

pmem-nowait-on-1.fio:   read:  IOPS=5837k,  BW=22.3GiB/s
pmem-nowait-on-2.fio:   read:  IOPS=5936k,  BW=22.6GiB/s
pmem-nowait-on-3.fio:   read:  IOPS=5945k,  BW=22.7GiB/s

linux-block (pmem-nowait-on) # grep cpu  pmem*fio | column -t
pmem-nowait-off-1.fio:  cpu  :  usr=7.09%,   sys=29.65%,  ctx=198742065
pmem-nowait-off-2.fio:  cpu  :  usr=6.89%,   sys=30.56%,  ctx=205817652
pmem-nowait-off-3.fio:  cpu  :  usr=6.86%,   sys=30.94%,  ctx=222627094

pmem-nowait-on-1.fio:   cpu  :  usr=10.58%,  sys=88.44%,  ctx=27181   
pmem-nowait-on-2.fio:   cpu  :  usr=10.50%,  sys=87.75%,  ctx=25746   
pmem-nowait-on-3.fio:   cpu  :  usr=10.67%,  sys=88.60%,  ctx=28261   

linux-block (pmem-nowait-on) # grep slat  pmem*fio | column -t
pmem-nowait-off-1.fio:  slat  (nsec):  min=432,   max=50847k,  avg=9324.69
pmem-nowait-off-2.fio:  slat  (nsec):  min=441,   max=52557k,  avg=9132.45
pmem-nowait-off-3.fio:  slat  (nsec):  min=430,   max=36113k,  avg=9132.63

pmem-nowait-on-1.fio:   slat  (nsec):  min=1393,  max=68090k,  avg=7615.31
pmem-nowait-on-2.fio:   slat  (nsec):  min=1222,  max=44137k,  avg=7493.77
pmem-nowait-on-3.fio:   slat  (nsec):  min=1493,  max=40100k,  avg=7486.36

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/nvdimm/pmem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 46e094e56159..ddd485c377eb 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -543,6 +543,7 @@ static int pmem_attach_disk(struct device *dev,
 	blk_queue_max_hw_sectors(q, UINT_MAX);
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
 	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, q);
+	blk_queue_flag_set(QUEUE_FLAG_NOWAIT, q);
 	if (pmem->pfn_flags & PFN_MAP)
 		blk_queue_flag_set(QUEUE_FLAG_DAX, q);
 
-- 
2.40.0

