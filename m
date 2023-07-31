Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A412F3B
	for <nvdimm@lists.linux.dev>; Mon, 31 Jul 2023 22:46:46 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FWhEsken1FozT/fV4o1lOYXyvqGGULSfnsp1i/5GsxstlM7Cfa8ZDSfqiy2wm2/f+raRvba+CByQ9RlOm6N6nTjjeZNzqCTr4zKxWqHjTivO2FeC6+0SSQhxU+gfe4XJh2pRB9cSSKXmFkKnWdgmEXV5xUgtIa6a49+V+D2eP5/5KPys8c1HmuOVSo7F+hDB/PWpGF374xj1wBmvR9qy9ksTWyU4hFWnxRlN0Dvw2fd5+TqjBK0CHp2XDyv2NGJWQgJpVi8t/u0itZLClhI1ilb6zszqStnKrpdVOsDa7aiUb8ba7eGQ5wMxzsbv+N6o4asJFM/RUhoDQz9YQh21Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MEHAyqzL5uRxv/JjtDC3gVqXq77Tqhiw4XUHLr5RWsg=;
 b=NxKoFhVLJtTxuw6UKvHe65OCnH+X7agnU7LV+kRrMQlSJxLDqeHfyWDPMr7L3cjjlVKP92bRbmAheVe29VTqx0Ul8CdTYXjsvw520UdWmnRn5bFCZayddfNU0veOAPCHLdqwhdSyFBFto4o+vo7FRc1XcCoNo9Iz1sZsbXByPbaIYv6sMLDy0IUoTkmEyf/XqHeVsAFK0g7IQ2men9foroOu0mL9/vdhQi24NnE1WdqsUQHzoVPK2Zry3mPu6zrRGvupq/AjUMrSWCwDTaB0LExn3rybWNmrQSSiCIrsqtVIJ4MdC7nPsxMGVcLs4ytgjTuSW2dDY8w4e1MiJl+xXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MEHAyqzL5uRxv/JjtDC3gVqXq77Tqhiw4XUHLr5RWsg=;
 b=I6tAAYrOTckVwbxKKePf/fQCtmXF9Vm9CrXuy62XYDoUWy8uoKVQfaz+FeCT71S7atH7eT4EuyqGwN8NRvRQVsqWWZeiBPz1cGaYPNygL4MfvpWp+Xit/lfXl4PbE2JXxlynz0OE6+kGqq1lbruiRqqKEHPtJP0tQp0/KtLsxOQBiHTJFJ8AJa8GwruV7pwTbKKgs1EazVjF+A0885KVI+9l8u7F7Koyn2vqFGFON9yAlsHEAUU8gWAiVWLz2PJgtfGNDmV7kJ70nyOinWZK4sTivQ2M1dJM7Ncqjkxlk4pFnSMBojlV86nF/eNoHNxrCkU1y6Sq43QrpCnbZkLo4Q==
Received: from BN0PR07CA0027.namprd07.prod.outlook.com (2603:10b6:408:141::29)
 by DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6631.42; Mon, 31 Jul 2023 22:46:42 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:141:cafe::6) by BN0PR07CA0027.outlook.office365.com
 (2603:10b6:408:141::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.44 via Frontend
 Transport; Mon, 31 Jul 2023 22:46:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6631.44 via Frontend Transport; Mon, 31 Jul 2023 22:46:42 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 31 Jul 2023
 15:46:32 -0700
Received: from dev.nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 31 Jul
 2023 15:46:31 -0700
From: Chaitanya Kulkarni <kch@nvidia.com>
To: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>
CC: <hch@lst.de>, <nvdimm@lists.linux.dev>, Chaitanya Kulkarni
	<kch@nvidia.com>
Subject: [PATCH V2 0/1] pmem: set QUEUE_FLAG_NOWAIT 
Date: Mon, 31 Jul 2023 15:46:16 -0700
Message-ID: <20230731224617.8665-1-kch@nvidia.com>
X-Mailer: git-send-email 2.40.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT049:EE_|DS7PR12MB6048:EE_
X-MS-Office365-Filtering-Correlation-Id: c1f67c0b-69cb-48ac-167f-08db9218028c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	PnohE3oPBXMIAVgJQUPOZUQVNDvSlLLB1oQj0VPFZhzJVMOJs12gQsXdmOrhpbmU4G6nG79ini5Z3M/SkoL4ZVc7f8Xicd2XF/BHbeWXetoSuTXHU0nglgzbrbalDfzrKfngn4EPY2qBwUNz64ncpAXWga26ByWQVQb3Svnwg93GFaPQ1SU1GsZ2nVjj0h0msd49SdtzbM3rursU+gReMXRrEj75ysA9PXULFvMJ7gyODwWp2QeKgRXV9gC/f0L6EBxDoD2MAXQOcY6ck7MPlQM4w/DkelPtheAPCGlUAjuwehPM5vKiz1Fv36mkoR+9mhmge/QNVIkhfxFFyZHj7Kn3KGf19Oka8WDZMtpsEqxo/dv/WgbLGIOznYdylXJqYlWGk9eMr1NeYb3AMNpXGEP9QBWNsH8Z/VLFR4l9oOj6n5ZvwPEq1NJ3Qcyaa9JUkpDjpBJWb0XLySwy5ysDtdov+LYBomR5OZwlGupEocCytOn6uFY+PETL5AYUKKHTnczalijFjWpap9Buqf8wzVdL9NhTerDCwxNGZZUMnFXk9/fx5jB65vipLbeqYVWlf4ruakbBJvNsTP6UTxGpwM/3GzO1WcwjhwEZE0bSG5MuTUHbT3GZGvAqAWxg2ZY5+4IQxYmkmZciF3bR1/KgpwijPN91ajKXscQqxxwXpgToNQtiOLZx+p1nz7gusQ0FxlU9tFAED3Tzu2c7tfLcJKdt5TCDk0DnJ62DTi4U3pRRkFLObcysH0fvAo+eBN7E
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(376002)(346002)(39860400002)(82310400008)(451199021)(36840700001)(46966006)(40470700004)(36756003)(478600001)(356005)(82740400003)(7636003)(40480700001)(40460700003)(6666004)(7696005)(2616005)(186003)(336012)(107886003)(4743002)(8676002)(1076003)(26005)(8936002)(16526019)(5660300002)(70586007)(4326008)(2906002)(70206006)(54906003)(19627235002)(41300700001)(110136005)(316002)(30864003)(36860700001)(426003)(83380400001)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2023 22:46:42.0631
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1f67c0b-69cb-48ac-167f-08db9218028c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6048

Hi,

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

Please let me know if further testing is needed I've ran fio verification
job in order to make verify these changes.

-ck

V2:-

Unconditionally set the QUEUE_FLAG_NOWAIT in pmem_attach_disk() along
with the other queue flags.

Chaitanya Kulkarni (1):
  pmem: set QUEUE_FLAG_NOWAIT

 drivers/nvdimm/pmem.c | 1 +
 1 file changed, 1 insertion(+)

linux-block (pmem-nowait-on) # ./test-pmem.sh 
++ unload_mod
++ rmmod nd_pmem
++ rmmod nd_btt
++ git checkout for-next
Switched to branch 'for-next'
Your branch is ahead of 'origin/for-next' by 155 commits.
  (use "git push" to publish your local commits)
++ git log -1
commit e50c5e801b5a9e1797eb5a157eac1b5e50084486 (HEAD -> for-next)
Merge: e6dfe861227b e98acd815ebf
Author: Chaitanya Kulkarni <kch@nvidia.com>
Date:   Mon Jul 31 14:48:39 2023 -0700

    Merge branch 'for-next' of git://git.kernel.dk/linux-block into for-next
++ makej M=drivers/nvdimm
  CC [M]  drivers/nvdimm/pmem.o
  LD [M]  drivers/nvdimm/nd_pmem.o
  MODPOST drivers/nvdimm/Module.symvers
  LD [M]  drivers/nvdimm/nd_pmem.ko
++ load_mod
++ insmod drivers/nvdimm/nd_btt.ko
++ insmod drivers/nvdimm/nd_pmem.ko
++ sleep 1
++ test_pmem nowait-off
++ sleep 1
++ fio fio/verify.fio --ioengine=io_uring --size=896M --filename=/dev/pmem0
write-and-verify: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=io_uring, iodepth=16
fio-3.34
Starting 1 process
Jobs: 1 (f=1)
write-and-verify: (groupid=0, jobs=1): err= 0: pid=4662: Mon Jul 31 15:24:07 2023
  read: IOPS=265k, BW=1036MiB/s (1087MB/s)(566MiB/546msec)
    slat (nsec): min=501, max=31820, avg=2733.20, stdev=1179.52
    clat (nsec): min=17022, max=96063, avg=56544.09, stdev=5848.22
     lat (usec): min=20, max=101, avg=59.28, stdev= 6.06
    clat percentiles (nsec):
     |  1.00th=[44288],  5.00th=[46848], 10.00th=[48896], 20.00th=[51456],
     | 30.00th=[53504], 40.00th=[55552], 50.00th=[56576], 60.00th=[58112],
     | 70.00th=[59648], 80.00th=[61184], 90.00th=[63744], 95.00th=[66048],
     | 99.00th=[72192], 99.50th=[74240], 99.90th=[80384], 99.95th=[82432],
     | 99.99th=[88576]
  write: IOPS=209k, BW=818MiB/s (857MB/s)(896MiB/1096msec); 0 zone resets
    slat (nsec): min=1352, max=113484, avg=4293.77, stdev=1425.01
    clat (usec): min=25, max=285, avg=71.81, stdev= 9.33
     lat (usec): min=31, max=288, avg=76.10, stdev= 9.56
    clat percentiles (usec):
     |  1.00th=[   45],  5.00th=[   61], 10.00th=[   65], 20.00th=[   68],
     | 30.00th=[   70], 40.00th=[   71], 50.00th=[   72], 60.00th=[   73],
     | 70.00th=[   75], 80.00th=[   77], 90.00th=[   80], 95.00th=[   84],
     | 99.00th=[  102], 99.50th=[  113], 99.90th=[  169], 99.95th=[  180],
     | 99.99th=[  219]
   bw (  KiB/s): min=152408, max=857568, per=73.07%, avg=611669.33, stdev=398064.54, samples=3
   iops        : min=38102, max=214392, avg=152917.33, stdev=99516.13, samples=3
  lat (usec)   : 20=0.01%, 50=6.40%, 100=92.93%, 250=0.67%, 500=0.01%
  cpu          : usr=35.49%, sys=63.60%, ctx=2561, majf=0, minf=3973
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=144875,229376,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=1036MiB/s (1087MB/s), 1036MiB/s-1036MiB/s (1087MB/s-1087MB/s), io=566MiB (593MB), run=546-546msec
  WRITE: bw=818MiB/s (857MB/s), 818MiB/s-818MiB/s (857MB/s-857MB/s), io=896MiB (940MB), run=1096-1096msec

Disk stats (read/write):
  pmem0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
++ fio fio/randwrite.fio --ioengine=io_uring --size=896M --filename=/dev/pmem0
RANDWRITE: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=io_uring, iodepth=2
...
fio-3.34
Starting 48 processes
Jobs: 48 (f=48): [w(48)][100.0%][w=20.6GiB/s][w=5389k IOPS][eta 00m:00s]
RANDWRITE: (groupid=0, jobs=48): err= 0: pid=4681: Mon Jul 31 15:25:07 2023
  write: IOPS=5147k, BW=19.6GiB/s (21.1GB/s)(1178GiB/60002msec); 0 zone resets
    slat (nsec): min=380, max=57147k, avg=6895.36, stdev=28357.20
    clat (nsec): min=130, max=57173k, avg=11233.63, stdev=44260.60
     lat (nsec): min=1944, max=57174k, avg=18128.99, stdev=53168.60
    clat percentiles (usec):
     |  1.00th=[    3],  5.00th=[    6], 10.00th=[    6], 20.00th=[    6],
     | 30.00th=[    7], 40.00th=[    7], 50.00th=[    8], 60.00th=[    9],
     | 70.00th=[   10], 80.00th=[   12], 90.00th=[   21], 95.00th=[   32],
     | 99.00th=[   58], 99.50th=[   74], 99.90th=[  135], 99.95th=[  186],
     | 99.99th=[  742]
   bw (  MiB/s): min= 5793, max=30898, per=100.00%, avg=20121.35, stdev=146.64, samples=5712
   iops        : min=1483165, max=7909996, avg=5151064.04, stdev=37540.43, samples=5712
  lat (nsec)   : 250=0.01%, 500=0.01%, 750=0.01%, 1000=0.01%
  lat (usec)   : 2=0.33%, 4=2.22%, 10=71.71%, 20=15.22%, 50=9.07%
  lat (usec)   : 100=1.23%, 250=0.18%, 500=0.02%, 750=0.01%, 1000=0.01%
  lat (msec)   : 2=0.01%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%
  lat (msec)   : 100=0.01%
  cpu          : usr=9.36%, sys=31.21%, ctx=286817971, majf=0, minf=607
  IO depths    : 1=0.1%, 2=100.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,308833813,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=2

Run status group 0 (all jobs):
  WRITE: bw=19.6GiB/s (21.1GB/s), 19.6GiB/s-19.6GiB/s (21.1GB/s-21.1GB/s), io=1178GiB (1265GB), run=60002-60002msec

Disk stats (read/write):
  pmem0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
++ for i in 1 2 3
++ fio fio/randread.fio --ioengine=io_uring --size=896M --filename=/dev/pmem0 --output=pmem-nowait-off-1.fio
++ for i in 1 2 3[r(48)][100.0%][r=14.7GiB/s][r=3864k IOPS][eta 00m:00s]
++ fio fio/randread.fio --ioengine=io_uring --size=896M --filename=/dev/pmem0 --output=pmem-nowait-off-2.fio
++ for i in 1 2 3[r(48)][100.0%][r=15.7GiB/s][r=4116k IOPS][eta 00m:00s]
++ fio fio/randread.fio --ioengine=io_uring --size=896M --filename=/dev/pmem0 --output=pmem-nowait-off-3.fio
++ unload_mod8): [r(48)][100.0%][r=15.1GiB/s][r=3966k IOPS][eta 00m:00s]
++ rmmod nd_pmem
++ rmmod nd_btt
++ git checkout pmem-nowait-on
Switched to branch 'pmem-nowait-on'
++ git log -1
commit 24573494ec05e8d7bb7acb82e4a0e400297272aa (HEAD -> pmem-nowait-on)
Author: Chaitanya Kulkarni <kch@nvidia.com>
Date:   Fri May 12 03:24:54 2023 -0700

    pmem: set QUEUE_FLAG_NOWAIT
    
    Set the QUEUE_FLAG_NOWAIT. Following are the performance numbers with
    io_uring fio engine for random read, note that device has been populated
    fully with randwrite workload before taking these numbers :-
    
    Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
++ rmmod nd_pmem
rmmod: ERROR: Module nd_pmem is not currently loaded
++ makej M=drivers/nvdimm
  CC [M]  drivers/nvdimm/pmem.o
  LD [M]  drivers/nvdimm/nd_pmem.o
  MODPOST drivers/nvdimm/Module.symvers
  LD [M]  drivers/nvdimm/nd_pmem.ko
++ load_mod
++ insmod drivers/nvdimm/nd_btt.ko
++ insmod drivers/nvdimm/nd_pmem.ko
++ sleep 1
++ test_pmem nowait-on
++ sleep 1
++ fio fio/verify.fio --ioengine=io_uring --size=896M --filename=/dev/pmem0
write-and-verify: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=io_uring, iodepth=16
fio-3.34
Starting 1 process
Jobs: 1 (f=1)
write-and-verify: (groupid=0, jobs=1): err= 0: pid=5662: Mon Jul 31 15:28:13 2023
  read: IOPS=448k, BW=1750MiB/s (1835MB/s)(567MiB/324msec)
    slat (nsec): min=1092, max=56347, avg=1349.16, stdev=838.70
    clat (nsec): min=741, max=152570, avg=33482.76, stdev=9895.86
     lat (usec): min=2, max=154, avg=34.83, stdev=10.20
    clat percentiles (usec):
     |  1.00th=[   30],  5.00th=[   31], 10.00th=[   31], 20.00th=[   31],
     | 30.00th=[   31], 40.00th=[   31], 50.00th=[   32], 60.00th=[   32],
     | 70.00th=[   32], 80.00th=[   32], 90.00th=[   35], 95.00th=[   49],
     | 99.00th=[   87], 99.50th=[   96], 99.90th=[  113], 99.95th=[  122],
     | 99.99th=[  139]
  write: IOPS=207k, BW=810MiB/s (849MB/s)(896MiB/1106msec); 0 zone resets
    slat (nsec): min=2135, max=81445, avg=4433.09, stdev=1568.20
    clat (nsec): min=441, max=210380, avg=72445.60, stdev=10663.97
     lat (usec): min=3, max=254, avg=76.88, stdev=11.22
    clat percentiles (usec):
     |  1.00th=[   56],  5.00th=[   60], 10.00th=[   62], 20.00th=[   65],
     | 30.00th=[   68], 40.00th=[   70], 50.00th=[   72], 60.00th=[   75],
     | 70.00th=[   77], 80.00th=[   79], 90.00th=[   83], 95.00th=[   86],
     | 99.00th=[  120], 99.50th=[  135], 99.90th=[  161], 99.95th=[  169],
     | 99.99th=[  192]
   bw (  KiB/s): min=764336, max=876176, per=98.88%, avg=820256.00, stdev=79082.82, samples=2
   iops        : min=191084, max=219044, avg=205064.00, stdev=19770.71, samples=2
  lat (nsec)   : 500=0.01%, 750=0.01%
  lat (usec)   : 4=0.01%, 10=0.01%, 20=0.01%, 50=36.90%, 100=62.08%
  lat (usec)   : 250=1.01%
  cpu          : usr=37.58%, sys=62.28%, ctx=3, majf=0, minf=3983
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=145180,229376,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=1750MiB/s (1835MB/s), 1750MiB/s-1750MiB/s (1835MB/s-1835MB/s), io=567MiB (595MB), run=324-324msec
  WRITE: bw=810MiB/s (849MB/s), 810MiB/s-810MiB/s (849MB/s-849MB/s), io=896MiB (940MB), run=1106-1106msec

Disk stats (read/write):
  pmem0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
++ fio fio/randwrite.fio --ioengine=io_uring --size=896M --filename=/dev/pmem0
RANDWRITE: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=io_uring, iodepth=2
...
fio-3.34
Starting 48 processes
Jobs: 48 (f=48): [w(48)][100.0%][w=39.7GiB/s][w=10.4M IOPS][eta 00m:00s]
RANDWRITE: (groupid=0, jobs=48): err= 0: pid=5665: Mon Jul 31 15:29:13 2023
  write: IOPS=9926k, BW=37.9GiB/s (40.7GB/s)(2272GiB/60001msec); 0 zone resets
    slat (nsec): min=1192, max=32084k, avg=4269.53, stdev=21566.61
    clat (nsec): min=501, max=32087k, avg=5022.97, stdev=23279.45
     lat (nsec): min=1854, max=32098k, avg=9292.50, stdev=31761.04
    clat percentiles (nsec):
     |  1.00th=[ 2544],  5.00th=[ 2992], 10.00th=[ 3280], 20.00th=[ 3600],
     | 30.00th=[ 3920], 40.00th=[ 4256], 50.00th=[ 4576], 60.00th=[ 4960],
     | 70.00th=[ 5408], 80.00th=[ 5984], 90.00th=[ 7008], 95.00th=[ 7968],
     | 99.00th=[10944], 99.50th=[14528], 99.90th=[24192], 99.95th=[33536],
     | 99.99th=[63744]
   bw (  MiB/s): min=26941, max=42586, per=100.00%, avg=38794.41, stdev=73.04, samples=5712
   iops        : min=6897082, max=10902168, avg=9931366.71, stdev=18699.20, samples=5712
  lat (nsec)   : 750=0.01%, 1000=0.01%
  lat (usec)   : 2=0.01%, 4=32.93%, 10=65.63%, 20=1.26%, 50=0.16%
  lat (usec)   : 100=0.01%, 250=0.01%, 500=0.01%, 750=0.01%, 1000=0.01%
  lat (msec)   : 2=0.01%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%
  cpu          : usr=18.08%, sys=80.64%, ctx=30470, majf=0, minf=587
  IO depths    : 1=0.1%, 2=100.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,595577284,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=2

Run status group 0 (all jobs):
  WRITE: bw=37.9GiB/s (40.7GB/s), 37.9GiB/s-37.9GiB/s (40.7GB/s-40.7GB/s), io=2272GiB (2439GB), run=60001-60001msec

Disk stats (read/write):
  pmem0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
++ for i in 1 2 3
++ fio fio/randread.fio --ioengine=io_uring --size=896M --filename=/dev/pmem0 --output=pmem-nowait-on-1.fio
++ for i in 1 2 3[r(48)][100.0%][r=22.7GiB/s][r=5960k IOPS][eta 00m:00s]
++ fio fio/randread.fio --ioengine=io_uring --size=896M --filename=/dev/pmem0 --output=pmem-nowait-on-2.fio
++ for i in 1 2 3[r(48)][100.0%][r=22.7GiB/s][r=5953k IOPS][eta 00m:00s]
++ fio fio/randread.fio --ioengine=io_uring --size=896M --filename=/dev/pmem0 --output=pmem-nowait-on-3.fio
linux-block (pmem-nowait-on) # ][r=22.7GiB/s][r=5946k IOPS][eta 00m:00s]
linux-block (pmem-nowait-on) # 
linux-block (pmem-nowait-on) # grep IOPS  pmem*fio | column -t
pmem-nowait-off-1.fio:  read:  IOPS=3683k,  BW=14.0GiB/s  (15.1GB/s)(843GiB/60002msec)
pmem-nowait-off-2.fio:  read:  IOPS=3819k,  BW=14.6GiB/s  (15.6GB/s)(874GiB/60002msec)
pmem-nowait-off-3.fio:  read:  IOPS=3999k,  BW=15.3GiB/s  (16.4GB/s)(915GiB/60002msec)

pmem-nowait-on-1.fio:   read:  IOPS=5837k,  BW=22.3GiB/s  (23.9GB/s)(1336GiB/60002msec)
pmem-nowait-on-2.fio:   read:  IOPS=5936k,  BW=22.6GiB/s  (24.3GB/s)(1359GiB/60002msec)
pmem-nowait-on-3.fio:   read:  IOPS=5945k,  BW=22.7GiB/s  (24.3GB/s)(1361GiB/60002msec)

linux-block (pmem-nowait-on) # grep cpu  pmem*fio | column -t
pmem-nowait-off-1.fio:  cpu  :  usr=7.09%,   sys=29.65%,  ctx=198742065
pmem-nowait-off-2.fio:  cpu  :  usr=6.89%,   sys=30.56%,  ctx=205817652
pmem-nowait-off-3.fio:  cpu  :  usr=6.86%,   sys=30.94%,  ctx=222627094

pmem-nowait-on-1.fio:   cpu  :  usr=10.58%,  sys=88.44%,  ctx=27181,   
pmem-nowait-on-2.fio:   cpu  :  usr=10.50%,  sys=87.75%,  ctx=25746,   
pmem-nowait-on-3.fio:   cpu  :  usr=10.67%,  sys=88.60%,  ctx=28261,   
linux-block (pmem-nowait-on) # grep slat  pmem*fio | column -t
pmem-nowait-off-1.fio:  slat  (nsec):  min=432,   max=50847k,  avg=9324.69
pmem-nowait-off-2.fio:  slat  (nsec):  min=441,   max=52557k,  avg=9132.45
pmem-nowait-off-3.fio:  slat  (nsec):  min=430,   max=36113k,  avg=9132.63

pmem-nowait-on-1.fio:   slat  (nsec):  min=1393,  max=68090k,  avg=7615.31
pmem-nowait-on-2.fio:   slat  (nsec):  min=1222,  max=44137k,  avg=7493.77
pmem-nowait-on-3.fio:   slat  (nsec):  min=1493,  max=40100k,  avg=7486.36
linux-block (pmem-nowait-on) # 



-- 
2.40.0

