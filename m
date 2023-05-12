Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2053.outbound.protection.outlook.com [40.107.101.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E26633EA
	for <nvdimm@lists.linux.dev>; Fri, 12 May 2023 10:43:26 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZPSthyY78L/dztIMH/4oeXsep5EJLNMnBBPHe6KMEF9+blKzOJsh966xVgrPd6T9ISs1vE9TLS6/flpjR8sJUxxg+PLBm/yFv9cs2Utl2JtlJOcdzrhjCT3JW3G7c/e/AE0Ci/PnAAP9Fc0V8/R9/0anUSo273GUeayhLer2Uicqe//7/9cGf4lxK22aKLGzmWgvNUOCfxfhrqtDRuqJIlLsY7lxCJ+1xkTjqHaAaQ9PLDgtPt63hQ9OoS+yX6oe2fJ9tpHrmN2xnIvgJWUUW+qt7+9x+Po196cMPhS8wL3RD99cKtw9Je7t1Hc2WnSgTkDTaaLYyF3I10Jb8ufp7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cles/KKJLql8VAqJmsejXyYj2FlFDfQgcZlomxqT18k=;
 b=oYY91tmvSwiihGQucueyF6U64ulhN3TP4tGWCrv/cfRx6EFC9B2us7SAxdFkolm2xTaYGGbREdHjNvGzGA6Np8bKKVbZUdubw81doVWUr1f3/elD6NMlz40dG3M759AmFwZgRjBefLghaTGZQwACj7Psa+o2hluk6bL79O5M8JgfWHt5RL5I13HWXkvpNd5EXnyeYVm11aYZ55uVwuOR9hTjxH/FwtJRvAC8oZ4kd2Mh03BVJgsGYJZndN3GEqHn7IQKqW+42CSINMSJCw+DpwVV6ICGWwRtv0CNXSOpiyIFOC/u/rK2QtfY+P1chRi5v3am9JujsvEwEeDHXlZOEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cles/KKJLql8VAqJmsejXyYj2FlFDfQgcZlomxqT18k=;
 b=YgDttkPt2xruL0QbZhosmWz8ijf/4+s4N9wxBLQc0w+2M9WHXAsvmhDHAzAp0qGCxf7XpgK7DKpXNDEz1By5XUQQ2wL6d+1zr6QtCKpkdB/p+Hpz4F/tKv8jxpGNFUM9OgiLE/oRZaNxJg8osx4o3aSQOnzIXqvaNUu3XZBLWzvv9Igux4edc1ObLSeIQeUyoE4QroKDMSMEgyTptdNlyBTjVpuvElXhRI+J/fz0gji153zChrufbW1y2iR8JWpMkUpbPLB6YaWrSCa99fZUuR+nlwmez6ApZPBX3RJa51DuQtDjN0DefV1CuKdtCkMPcwcCtfzbDTg4R3V8B3HDCA==
Received: from CY5PR15CA0097.namprd15.prod.outlook.com (2603:10b6:930:7::19)
 by PH7PR12MB6444.namprd12.prod.outlook.com (2603:10b6:510:1f8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Fri, 12 May
 2023 10:43:23 +0000
Received: from CY4PEPF0000B8EB.namprd05.prod.outlook.com
 (2603:10b6:930:7:cafe::4c) by CY5PR15CA0097.outlook.office365.com
 (2603:10b6:930:7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.24 via Frontend
 Transport; Fri, 12 May 2023 10:43:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000B8EB.mail.protection.outlook.com (10.167.241.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.5 via Frontend Transport; Fri, 12 May 2023 10:43:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 12 May 2023
 03:43:13 -0700
Received: from dev.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 12 May
 2023 03:43:12 -0700
From: Chaitanya Kulkarni <kch@nvidia.com>
To: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>
CC: <nvdimm@lists.linux.dev>, Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH 0/1] pmem: allow user to set QUEUE_FLAG_NOWAIT 
Date: Fri, 12 May 2023 03:43:01 -0700
Message-ID: <20230512104302.8527-1-kch@nvidia.com>
X-Mailer: git-send-email 2.40.0
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EB:EE_|PH7PR12MB6444:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bb1acb5-b69a-4e42-47f1-08db52d5b54d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Nz7iMYE0/gYFCSgwjjD6KDZhhEKhAFnPeDer1MOqwGtJQUkD6E+iszDlCtfVqEtDaKHasokNEF+Q692YFNfDcRqK44JRVUO+V1KuGEFbnjLGyrjZSjfdp6V5TeooKnsoU/CQ9zBz0UKLUeHI/CuacyZH/nplzpkxfZQCg7bc5V8w5AYa7bsYhmjS3J3MIJOOs86ZOv001aQOUVU9DwWimrz2yC3aAJtQG/aO7mC9iRbXXt/b5kB9m3GAdAub0h+rz5Hb6wYMZNsLwMZy0JZGoUDagF4KZIjnu7GK0pRygp2rB6kJ5N23Lno84TsZYn3URl/jp+Y4CBNfVK9IgNtuPvctxvTAjgzTyycid7h3sPbhvwJ/ipMm5H8NcwGLtt/e5OJNYW1nvcKy00XMfqnTicvFXAtYFRmrEixfc3uBW7FYD64ue/ciu8YaeujJ4hCJPrWM/R2wubyZheECPTNut4MjnpM5rZCQOZGZGLoOcGcl6245v4u4GHlP1hfVDRba/IX4IAhsyaGwnkTjUWjvq2mkWjxExbbEeWb954K1HZ3eYMI9X2nICYr0CW78KQ5jbxw4wq9GNB/pMOGrVroR7vsb2K5XhN4FZw9O+WdkjXwb67fkMbYfhYVXlM80uNHIXBHb0O2IM2kXoJvd3KAv3rJX/QniB5HOzHnPsxFdS0zRHNfVfRW1CPPHsms/FlylGJNFiiZDm4xV8GEo1ge0DQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(39860400002)(376002)(396003)(451199021)(40470700004)(36840700001)(46966006)(336012)(356005)(36756003)(70586007)(4326008)(7696005)(110136005)(54906003)(19627235002)(478600001)(316002)(70206006)(36860700001)(5660300002)(82310400005)(2906002)(30864003)(40480700001)(41300700001)(7636003)(8936002)(186003)(16526019)(8676002)(82740400003)(1076003)(107886003)(4743002)(426003)(83380400001)(26005)(47076005)(2616005)(6666004)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 10:43:22.5060
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bb1acb5-b69a-4e42-47f1-08db52d5b54d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000B8EB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6444

Allow user to set the QUEUE_FLAG_NOWAIT optionally using module
parameter to retain the default behaviour. Also, update respective
allocation flags in the write path. Following are the performance
numbers with io_uring fio engine for random read, note that device has
been populated fully with randwrite workload before taking these
numbers :-

* linux-block (for-next) # grep IOPS  pmem*fio | column -t

default-nowait-off-1.fio:  read:  IOPS=3968k,  BW=15.1GiB/s
default-nowait-off-2.fio:  read:  IOPS=4084k,  BW=15.6GiB/s
default-nowait-off-3.fio:  read:  IOPS=3995k,  BW=15.2GiB/s

nowait-on-1.fio:           read:  IOPS=5909k,  BW=22.5GiB/s
nowait-on-2.fio:           read:  IOPS=5997k,  BW=22.9GiB/s
nowait-on-3.fio:           read:  IOPS=6006k,  BW=22.9GiB/s

* linux-block (for-next) # grep cpu  pmem*fio | column -t

default-nowait-off-1.fio:  cpu  :  usr=6.38%,   sys=31.37%,  ctx=220427659
default-nowait-off-2.fio:  cpu  :  usr=6.19%,   sys=31.45%,  ctx=229825635
default-nowait-off-3.fio:  cpu  :  usr=6.17%,   sys=31.22%,  ctx=221896158

nowait-on-1.fio:           cpu  :  usr=10.56%,  sys=87.82%,  ctx=24730   
nowait-on-2.fio:           cpu  :  usr=9.92%,   sys=88.36%,  ctx=23427   
nowait-on-3.fio:           cpu  :  usr=9.85%,   sys=89.04%,  ctx=23237   

* linux-block (for-next) # grep slat  pmem*fio | column -t
default-nowait-off-1.fio:  slat  (nsec):  min=431,   max=50423k,  avg=9424.06
default-nowait-off-2.fio:  slat  (nsec):  min=420,   max=35992k,  avg=9193.94
default-nowait-off-3.fio:  slat  (nsec):  min=430,   max=40737k,  avg=9244.24

nowait-on-1.fio:           slat  (nsec):  min=1232,  max=40098k,  avg=7518.60
nowait-on-2.fio:           slat  (nsec):  min=1303,  max=52107k,  avg=7423.37
nowait-on-3.fio:           slat  (nsec):  min=1123,  max=40193k,  avg=7409.08

Please let me know if further testing is needed I've ran fio
verification job in order to make verify these changes.

Chaitanya Kulkarni (1):
  pmem: allow user to set QUEUE_FLAG_NOWAIT

 drivers/nvdimm/pmem.c | 6 ++++++
 1 file changed, 6 insertions(+)

linux-block (for-next) # sh test-pmem.sh
+ git log -1
commit 6df7042a11e06465b1b8f275170cb5593d8d7dcc (HEAD -> for-next)
Author: Chaitanya Kulkarni <kch@nvidia.com>
Date:   Fri May 12 03:24:54 2023 -0700

    pmem: allow user to set QUEUE_FLAG_NOWAIT
    
    Allow user to set the QUEUE_FLAG_NOWAIT optionally using module
    parameter to retain the default behaviour. Also, update respective
    allocation flags in the write path. Following are the performance
    numbers with io_uring fio engine for random read, note that device has
    been populated fully with randwrite workload before taking these
    numbers :-
+ rmmod nd_pmem
rmmod: ERROR: Module nd_pmem is not currently loaded
+ makej M=drivers/nvdimm
+ insmod drivers/nvdimm/nd_pmem.ko
+ sleep 1
+ test_pmem default-nowait-off
+ sleep 1
+ fio fio/verify.fio --ioengine=io_uring --size=896M --filename=/dev/pmem0
write-and-verify: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=io_uring, iodepth=16
fio-3.34
Starting 1 process
Jobs: 1 (f=1)
write-and-verify: (groupid=0, jobs=1): err= 0: pid=5358: Fri May 12 03:25:49 2023
  read: IOPS=266k, BW=1039MiB/s (1089MB/s)(566MiB/545msec)
    slat (nsec): min=511, max=49865, avg=2732.59, stdev=1231.82
    clat (nsec): min=1703, max=134486, avg=56488.86, stdev=7471.91
     lat (usec): min=6, max=138, avg=59.22, stdev= 7.76
    clat percentiles (usec):
     |  1.00th=[   43],  5.00th=[   47], 10.00th=[   49], 20.00th=[   51],
     | 30.00th=[   53], 40.00th=[   55], 50.00th=[   57], 60.00th=[   58],
     | 70.00th=[   60], 80.00th=[   62], 90.00th=[   65], 95.00th=[   70],
     | 99.00th=[   83], 99.50th=[   90], 99.90th=[  103], 99.95th=[  111],
     | 99.99th=[  124]
  write: IOPS=214k, BW=835MiB/s (876MB/s)(896MiB/1073msec); 0 zone resets
    slat (nsec): min=1473, max=92145, avg=4049.04, stdev=1645.45
    clat (usec): min=29, max=232, avg=70.52, stdev=12.86
     lat (usec): min=33, max=234, avg=74.57, stdev=13.54
    clat percentiles (usec):
     |  1.00th=[   44],  5.00th=[   53], 10.00th=[   56], 20.00th=[   61],
     | 30.00th=[   65], 40.00th=[   68], 50.00th=[   71], 60.00th=[   73],
     | 70.00th=[   76], 80.00th=[   79], 90.00th=[   85], 95.00th=[   92],
     | 99.00th=[  112], 99.50th=[  121], 99.90th=[  151], 99.95th=[  165],
     | 99.99th=[  188]
   bw (  KiB/s): min=115224, max=909344, per=71.53%, avg=611669.33, stdev=432768.96, samples=3
   iops        : min=28806, max=227336, avg=152917.33, stdev=108192.24, samples=3
  lat (usec)   : 2=0.01%, 10=0.01%, 20=0.01%, 50=7.92%, 100=90.44%
  lat (usec)   : 250=1.64%
  cpu          : usr=41.68%, sys=55.78%, ctx=6691, majf=0, minf=3975
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=144933,229376,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=1039MiB/s (1089MB/s), 1039MiB/s-1039MiB/s (1089MB/s-1089MB/s), io=566MiB (594MB), run=545-545msec
  WRITE: bw=835MiB/s (876MB/s), 835MiB/s-835MiB/s (876MB/s-876MB/s), io=896MiB (940MB), run=1073-1073msec

Disk stats (read/write):
  pmem0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
+ fio fio/randwrite.fio --ioengine=io_uring --size=896M --filename=/dev/pmem0
RANDWRITE: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=io_uring, iodepth=2
...
fio-3.34
Starting 48 processes
Jobs: 43 (f=43): [w(16),_(1),w(1),_(1),w(1),_(1),w(11),_(1),w(14),_(1)][80.0%][w=9744MiB/s][w=2494k IOPS][eta 00m:01s]
RANDWRITE: (groupid=0, jobs=48): err= 0: pid=5377: Fri May 12 03:25:54 2023
  write: IOPS=2400k, BW=9374MiB/s (9829MB/s)(42.0GiB/4588msec); 0 zone resets
    slat (nsec): min=411, max=9672.1k, avg=6856.45, stdev=13756.39
    clat (nsec): min=70, max=12541k, avg=28576.27, stdev=32832.06
     lat (nsec): min=1583, max=12543k, avg=35432.72, stdev=34424.05
    clat percentiles (nsec):
     |  1.00th=[   916],  5.00th=[  2288], 10.00th=[  4896], 20.00th=[ 10560],
     | 30.00th=[ 17792], 40.00th=[ 22144], 50.00th=[ 25984], 60.00th=[ 29824],
     | 70.00th=[ 34048], 80.00th=[ 39680], 90.00th=[ 51456], 95.00th=[ 65280],
     | 99.00th=[102912], 99.50th=[122368], 99.90th=[199680], 99.95th=[276480],
     | 99.99th=[888832]
   bw (  MiB/s): min= 8098, max=13617, per=100.00%, avg=10176.24, stdev=45.01, samples=366
   iops        : min=2073313, max=3486177, avg=2605112.23, stdev=11521.54, samples=366
  lat (nsec)   : 100=0.01%, 250=0.47%, 500=0.36%, 750=0.08%, 1000=0.14%
  lat (usec)   : 2=2.52%, 4=5.05%, 10=10.81%, 20=15.78%, 50=53.95%
  lat (usec)   : 100=9.72%, 250=1.06%, 500=0.04%, 750=0.01%, 1000=0.01%
  lat (msec)   : 2=0.01%, 4=0.01%, 10=0.01%, 20=0.01%
  cpu          : usr=6.89%, sys=29.96%, ctx=6989842, majf=0, minf=584
  IO depths    : 1=0.1%, 2=100.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,11010048,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=2

Run status group 0 (all jobs):
  WRITE: bw=9374MiB/s (9829MB/s), 9374MiB/s-9374MiB/s (9829MB/s-9829MB/s), io=42.0GiB (45.1GB), run=4588-4588msec

Disk stats (read/write):
  pmem0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
+ for i in 1 2 3
+ fio fio/randread.fio --ioengine=io_uring --size=896M --filename=/dev/pmem0 --output=pmem-default-nowait-off-1.fio
+ for i in 1 2 3 [r(48)][100.0%][r=16.6GiB/s][r=4348k IOPS][eta 00m:00s]
+ fio fio/randread.fio --ioengine=io_uring --size=896M --filename=/dev/pmem0 --output=pmem-default-nowait-off-2.fio
+ for i in 1 2 3 [r(48)][100.0%][r=15.8GiB/s][r=4138k IOPS][eta 00m:00s]
+ fio fio/randread.fio --ioengine=io_uring --size=896M --filename=/dev/pmem0 --output=pmem-default-nowait-off-3.fio
+ rmmod nd_pmem: [r(48)][100.0%][r=16.6GiB/s][r=4346k IOPS][eta 00m:00s]
+ insmod drivers/nvdimm/nd_pmem.ko nowait=1
+ sleep 1
+ test_pmem nowait-on
+ sleep 1
+ fio fio/verify.fio --ioengine=io_uring --size=896M --filename=/dev/pmem0
write-and-verify: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=io_uring, iodepth=16
fio-3.34
Starting 1 process
Jobs: 1 (f=1)
write-and-verify: (groupid=0, jobs=1): err= 0: pid=6062: Fri May 12 03:28:59 2023
  read: IOPS=492k, BW=1923MiB/s (2016MB/s)(567MiB/295msec)
    slat (nsec): min=1021, max=45136, avg=1220.20, stdev=473.55
    clat (nsec): min=812, max=79261, avg=30452.86, stdev=3469.19
     lat (nsec): min=1944, max=81274, avg=31673.05, stdev=3575.81
    clat percentiles (nsec):
     |  1.00th=[28288],  5.00th=[28800], 10.00th=[29056], 20.00th=[29056],
     | 30.00th=[29312], 40.00th=[29568], 50.00th=[29568], 60.00th=[29824],
     | 70.00th=[30080], 80.00th=[30336], 90.00th=[30848], 95.00th=[37120],
     | 99.00th=[48384], 99.50th=[49408], 99.90th=[58112], 99.95th=[59648],
     | 99.99th=[78336]
  write: IOPS=215k, BW=839MiB/s (880MB/s)(896MiB/1068msec); 0 zone resets
    slat (usec): min=2, max=122, avg= 4.30, stdev= 1.52
    clat (nsec): min=401, max=190492, avg=69931.70, stdev=9390.70
     lat (usec): min=3, max=289, avg=74.23, stdev= 9.87
    clat percentiles (usec):
     |  1.00th=[   54],  5.00th=[   58], 10.00th=[   61], 20.00th=[   64],
     | 30.00th=[   67], 40.00th=[   69], 50.00th=[   70], 60.00th=[   72],
     | 70.00th=[   74], 80.00th=[   76], 90.00th=[   79], 95.00th=[   83],
     | 99.00th=[   96], 99.50th=[  122], 99.90th=[  161], 99.95th=[  165],
     | 99.99th=[  176]
   bw (  KiB/s): min=811952, max=899120, per=99.59%, avg=855536.00, stdev=61637.08, samples=2
   iops        : min=202988, max=224780, avg=213884.00, stdev=15409.27, samples=2
  lat (nsec)   : 500=0.01%, 1000=0.01%
  lat (usec)   : 4=0.01%, 10=0.01%, 20=0.01%, 50=38.69%, 100=60.80%
  lat (usec)   : 250=0.51%
  cpu          : usr=38.33%, sys=61.60%, ctx=1, majf=0, minf=3984
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=145223,229376,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=1923MiB/s (2016MB/s), 1923MiB/s-1923MiB/s (2016MB/s-2016MB/s), io=567MiB (595MB), run=295-295msec
  WRITE: bw=839MiB/s (880MB/s), 839MiB/s-839MiB/s (880MB/s-880MB/s), io=896MiB (940MB), run=1068-1068msec

Disk stats (read/write):
  pmem0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
+ fio fio/randwrite.fio --ioengine=io_uring --size=896M --filename=/dev/pmem0
RANDWRITE: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=io_uring, iodepth=2
...
fio-3.34
Starting 48 processes
Jobs: 48 (f=48)
RANDWRITE: (groupid=0, jobs=48): err= 0: pid=6065: Fri May 12 03:29:00 2023
  write: IOPS=10.6M, BW=40.3GiB/s (43.2GB/s)(42.0GiB/1043msec); 0 zone resets
    slat (nsec): min=1162, max=10395k, avg=3946.17, stdev=6436.85
    clat (nsec): min=70, max=10396k, avg=4608.73, stdev=6810.12
     lat (nsec): min=1282, max=10403k, avg=8554.90, stdev=9532.53
    clat percentiles (nsec):
     |  1.00th=[ 2224],  5.00th=[ 2544], 10.00th=[ 2800], 20.00th=[ 3184],
     | 30.00th=[ 3472], 40.00th=[ 3760], 50.00th=[ 4080], 60.00th=[ 4448],
     | 70.00th=[ 4896], 80.00th=[ 5408], 90.00th=[ 6304], 95.00th=[ 7200],
     | 99.00th=[14016], 99.50th=[27776], 99.90th=[42752], 99.95th=[46848],
     | 99.99th=[80384]
   bw (  MiB/s): min=40342, max=42969, per=100.00%, avg=41656.06, stdev=29.12, samples=93
   iops        : min=10327717, max=11000181, avg=10663949.00, stdev=7454.42, samples=93
  lat (nsec)   : 100=0.01%, 250=0.03%, 500=0.01%, 750=0.01%, 1000=0.01%
  lat (usec)   : 2=0.28%, 4=47.32%, 10=50.83%, 20=0.91%, 50=0.58%
  lat (usec)   : 100=0.02%, 250=0.01%, 500=0.01%, 750=0.01%, 1000=0.01%
  lat (msec)   : 2=0.01%, 4=0.01%, 10=0.01%, 20=0.01%
  cpu          : usr=15.39%, sys=83.72%, ctx=1002, majf=0, minf=580
  IO depths    : 1=0.1%, 2=100.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,11010048,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=2

Run status group 0 (all jobs):
  WRITE: bw=40.3GiB/s (43.2GB/s), 40.3GiB/s-40.3GiB/s (43.2GB/s-43.2GB/s), io=42.0GiB (45.1GB), run=1043-1043msec

Disk stats (read/write):
  pmem0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
+ for i in 1 2 3
+ fio fio/randread.fio --ioengine=io_uring --size=896M --filename=/dev/pmem0 --output=pmem-nowait-on-1.fio
+ for i in 1 2 3 [r(48)][100.0%][r=22.8GiB/s][r=5987k IOPS][eta 00m:00s]
+ fio fio/randread.fio --ioengine=io_uring --size=896M --filename=/dev/pmem0 --output=pmem-nowait-on-2.fio
+ for i in 1 2 3 [r(48)][100.0%][r=22.8GiB/s][r=5990k IOPS][eta 00m:00s]
+ fio fio/randread.fio --ioengine=io_uring --size=896M --filename=/dev/pmem0 --output=pmem-nowait-on-3.fio
+ rmmod nd_pmem: [r(48)][100.0%][r=23.0GiB/s][r=6016k IOPS][eta 00m:00s]
linux-block (for-next) # for i in IOPS slat cpu; do grep $i bc-*fio | column -t ; done
linux-block (for-next) # for i in IOPS slat cpu; do grep $i pmem-*fio | column -t ; done
pmem-default-nowait-off-1.fio:  read:  IOPS=3968k,  BW=15.1GiB/s  (16.3GB/s)(908GiB/60002msec)
pmem-default-nowait-off-2.fio:  read:  IOPS=4084k,  BW=15.6GiB/s  (16.7GB/s)(935GiB/60001msec)
pmem-default-nowait-off-3.fio:  read:  IOPS=3995k,  BW=15.2GiB/s  (16.4GB/s)(914GiB/60002msec)
pmem-nowait-on-1.fio:           read:  IOPS=5909k,  BW=22.5GiB/s  (24.2GB/s)(1352GiB/60003msec)
pmem-nowait-on-2.fio:           read:  IOPS=5997k,  BW=22.9GiB/s  (24.6GB/s)(1373GiB/60002msec)
pmem-nowait-on-3.fio:           read:  IOPS=6006k,  BW=22.9GiB/s  (24.6GB/s)(1375GiB/60002msec)
pmem-default-nowait-off-1.fio:  slat  (nsec):  min=431,   max=50423k,  avg=9424.06,  stdev=19769.73
pmem-default-nowait-off-2.fio:  slat  (nsec):  min=420,   max=35992k,  avg=9193.94,  stdev=19814.91
pmem-default-nowait-off-3.fio:  slat  (nsec):  min=430,   max=40737k,  avg=9244.24,  stdev=22646.40
pmem-nowait-on-1.fio:           slat  (nsec):  min=1232,  max=40098k,  avg=7518.60,  stdev=26037.75
pmem-nowait-on-2.fio:           slat  (nsec):  min=1303,  max=52107k,  avg=7423.37,  stdev=24122.06
pmem-nowait-on-3.fio:           slat  (nsec):  min=1123,  max=40193k,  avg=7409.08,  stdev=17630.05
pmem-default-nowait-off-1.fio:  cpu  :  usr=6.38%,   sys=31.37%,  ctx=220427659,  majf=0,  minf=641
pmem-default-nowait-off-2.fio:  cpu  :  usr=6.19%,   sys=31.45%,  ctx=229825635,  majf=0,  minf=639
pmem-default-nowait-off-3.fio:  cpu  :  usr=6.17%,   sys=31.22%,  ctx=221896158,  majf=0,  minf=650
pmem-nowait-on-1.fio:           cpu  :  usr=10.56%,  sys=87.82%,  ctx=24730,      majf=0,  minf=784
pmem-nowait-on-2.fio:           cpu  :  usr=9.92%,   sys=88.36%,  ctx=23427,      majf=0,  minf=720
pmem-nowait-on-3.fio:           cpu  :  usr=9.85%,   sys=89.04%,  ctx=23237,      majf=0,  minf=724
linux-block (for-next) # 



-- 
2.40.0

