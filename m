Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012006.outbound.protection.outlook.com [52.101.43.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F822E36F8
	for <nvdimm@lists.linux.dev>; Mon, 15 Dec 2025 21:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765834606; cv=fail; b=nskgMsvqyvMY92lyaFmgiehn40la0wWWw55Byme2/Z4YlZWdK9IZDwaAhyPDL9bzsE7scCDQy4MtM/DAuOmALrhqOW380Ph+I/3eTEN33iDBEeg1/zfNI/v5O+TARd8+Mpmb15p0QcxUlS9lmnf1bX4dHUOZA44sBZy42yQ0JXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765834606; c=relaxed/simple;
	bh=082qXz5MIkNW1ZDfQETwad9eiAr1kC6Wpz4OdHTkA2s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UA+g/RIUPcZFuXugact0gsuvGUT+klkzrZDggZnKoVpxrys3oLc/xiehN9w1R9B6Tj2jNi7+8EsxmppkE4VGqfSiyK8D89UsYIybUU6i5KoO0ybNQDI6OmLxqNqX6Zc5/4ksftwEV9P0jPBeRqed6yjA52eDAp5YbJriomwScNk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=n+vw9Esk; arc=fail smtp.client-ip=52.101.43.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="n+vw9Esk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=STvam/vv7YYXZWffHigY/AnTDZ4G8umbhjRgiHTjkBz42J/sdGX4a5BJQc1+sH/sWPoLxjYaJu7FliG2M9WqocolpWWtH3MMnH2Ix4wGp6U5Vw9fzYv/yin0tiJBnLIrHfKC4wrVmqePsjw7Hk+CtYpBwnqlUoX2puYzyJNcYzGre0PksUoi28bEH8CVfZ4ScSBS70OV+FyjjjU500mS4tIRD/w4ZJ5iFjXvZ88wfSzo1hJG8/RHUBL+SXsu9XkoS6t0Q2A0sOMyKZtghbuNk2HRDJ/quJJpVzi//f2pojmMKS+cmrY6JKkV8wWcJclI24wxjG3yMaYFJvZYR/XXrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QOv2N435xKZqCNJ26pYL7XTxItF7CHD5edXbOov77SI=;
 b=I49f+P8LYHRojK82PkcbCqNi2LUH7p7JitnihZLxQNBh9XTxkKGX+5NsU7Vagv1qWuYKef38mxi+QzBBGq6MwhKodTmjxnCoR4rgJNPsPUZL05ojECpQ0UR4o4u6nvBXb2iROYcvoOd2MRIz8p2dofPcOOJP8mKHanrGYmYqhmAF9lr6azp0DM3XW5dUu5uGoPMUrsiyvGCdI1yEXrRex8cW+NXbJtsirE9j5CzoGsRe8wAQ2spJZAW8MAPFPQqo7rtrDJm9P/uqv3NXbHi4nMJp1YjCuL+wXPNmyopc9NKX9R82DfiU3ZeR/iTvGOFTL2W4km6uWj28+/mTh2WU1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QOv2N435xKZqCNJ26pYL7XTxItF7CHD5edXbOov77SI=;
 b=n+vw9EskWCGPnZIGcW10XOsxVrEzQxB9kA5JTgueKcpnL9QRrgNfBexgb2cT0nUHtld0wiMnaveiPIu/JKpZLvc7iMsB30Y6Us46YEK4jRsd67drSOqGrff5CHzUEaSsLHIPsaVscl9fhurKaQKImWgRWiixUC/NFzhl9d/bG8k=
Received: from SJ0PR05CA0094.namprd05.prod.outlook.com (2603:10b6:a03:334::9)
 by DS0PR12MB8319.namprd12.prod.outlook.com (2603:10b6:8:f7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 21:36:38 +0000
Received: from MWH0EPF000971E8.namprd02.prod.outlook.com
 (2603:10b6:a03:334:cafe::d0) by SJ0PR05CA0094.outlook.office365.com
 (2603:10b6:a03:334::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via Frontend Transport; Mon,
 15 Dec 2025 21:36:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E8.mail.protection.outlook.com (10.167.243.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Mon, 15 Dec 2025 21:36:36 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Dec
 2025 15:36:35 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>, <benjamin.cheatham@amd.com>
Subject: [ndctl PATCH v5 0/7] Add error injection support
Date: Mon, 15 Dec 2025 15:36:23 -0600
Message-ID: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E8:EE_|DS0PR12MB8319:EE_
X-MS-Office365-Filtering-Correlation-Id: be560703-494f-4a8b-5ecc-08de3c22068c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+H63Mht3rnxcG5wCAQMJz7SvNXLsM3lLsq00ACZ9xUIY4YuZ4I4GiML4n0h0?=
 =?us-ascii?Q?pNdSNrgX2polu+bUMrXEib3sKL5ngsMlvsVpfQD9MWMu+DiookItwna5c20M?=
 =?us-ascii?Q?EnaWm6i7I1md0XoWMH3a81uTAq+VSGzyE+UgH0bGEoqfUfH7q80GcXyKP2vu?=
 =?us-ascii?Q?HTZLyGwsyYKYACQZpuI9kXFO76n35p8ngw9cjZQ9Z6IFW+cyZTfcpwrcojY9?=
 =?us-ascii?Q?C4MaTtDCeAGqnzHcUVBxuxNQo0oWCg7U6Tvz7kQvOf+Z/lhRUT2CF5wj9Ifn?=
 =?us-ascii?Q?5MCqCUuIKtH/1n1+gkQj90dsHmlpr5swqsxRhFAbrT8LwNpou04NHaXu6RNY?=
 =?us-ascii?Q?CT6+LGZ2o9BsqphrXyJ+EzOtYYUNZOd3uM2XxAtkKa1/vECmS6aIFYXiHfW2?=
 =?us-ascii?Q?MxjRLUEh0aHlbFWT3QwBCAiWaqb94ueRk5tSdSbjd4QCQTAq/t8bzgSOXlb9?=
 =?us-ascii?Q?fgC6T9qy9rANrWPzS5SxXC/GOCKltQq3QToRulMWIECHMT3wOc35fNc2ijEX?=
 =?us-ascii?Q?KKuBDARKiMW27UyGH2M+IWcwMX1uy3lxqqnxAr+q8QVrLimY9xt+BlMYSSae?=
 =?us-ascii?Q?m6E+b1X+BO9ioTDL/6gjPlnYNMt4t/0bmvm2DvlkZLMCTDM1Fsf7rn+MiJhP?=
 =?us-ascii?Q?KMiaSASImPuexwHTM5rrOnlj0JBl65KibH+3RX3+y8XnTOjhCdTv65kJBCyZ?=
 =?us-ascii?Q?aWHsmRE28NsZWjUfAl1l63pgq7J7uxHU2VpVpmlLTrUocx2D7dh9ZORmKwFV?=
 =?us-ascii?Q?JDXUC47HX121YphZQuYmjadsBozn24eQNL9s2WTSd25LoZ40mXhhnWDOVJ8K?=
 =?us-ascii?Q?Dco4SqZjXD3OoJDxsRCwgn5ASQ3k0N9tCPYtroWDMvzRJpspubj+BXZmc6A5?=
 =?us-ascii?Q?XDbLk8CBzccnDRi+epFBVxhgPQys0/jVPrWb2LFT7MRBpDGqwibcE30gep3L?=
 =?us-ascii?Q?a5ilHga0p3eBtC9z7kPsnrXPKwdrTuTpEk8ztu3L4Hy6hWA78QOOGZ6LwMp+?=
 =?us-ascii?Q?QWqYEYrWM1eeXeP/sVCbO3Nx5Ox9iulnLXxaSHyu75sB2qJRnYO/Q/VT44jd?=
 =?us-ascii?Q?s2y/0XgIWcx/NXojtT7ZrDoFKWOXpmehM1muxZZwwu7+tOgoO0tSsuO6cEAs?=
 =?us-ascii?Q?sc4M3njH1Ae5bYp+GEKNOMNiXaJT6OYpcrWGHH/eFF41UjT/xrJBSRdrDiAA?=
 =?us-ascii?Q?xU1m7XGFnJvDGin6R0qzZWRM2YZtRH+4J+JUJQVcU6GgYZVk04xkl/9rS8/o?=
 =?us-ascii?Q?La6+mY8uDpvR+dGG5H+PBNdCtkp6cUFuNmwTFZdWgJ1ueGpA6rG/p2yuYknY?=
 =?us-ascii?Q?OhN+CEU0F7NYiC2mzRlEXupXzShmghupprZYxqdNq0jCV9HqMgjDXmt28WHH?=
 =?us-ascii?Q?8AEw01cmxu1H7N8hprLRU7PqfT+0i2KJIj8B61yBYrfG4YGZy7A136o2qQYb?=
 =?us-ascii?Q?0gUn0Gt2mqHVwpmqOD406KraIl6PF04ZCQtD8h/y9XjyRjAWEvMt0hDop+br?=
 =?us-ascii?Q?fT72/XmHZG+5fkwh0L5BQD1rgmTcs+3sQnRp?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 21:36:36.8260
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be560703-494f-4a8b-5ecc-08de3c22068c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8319

v5 Changes:
	- Use setmntent()/getmntent() instead of open-coding getting the
	  debugfs path (Dave)
	- Use correct return code for sysfs_read_attr() (Dave)

v4 Changes:
	- Variable renames for clarity (Dave)
	- Use errno instead of rc for access() calls (Dave)
	- Check returns for snprintf() (Dave)
	- Add util_cxl_dport_filter() (Dave)
	- Replace printf() calls with log_info() (Dave)
	- Write correct value to debugfs during protocol error injection
	(BIT(error) vs. error)

v3 Changes:
	- Rebase on v83 release
	- Fix whitespace errors (Alison)

v2 Changes:
	- Make the --clear option of 'inject-error' its own command (Alison)
	- Debugfs is now found using the /proc/mount entry instead of
	providing the path using a --debugfs option
	- Man page added for 'clear-error'
	- Reword commit descriptions for clarity

This series adds support for injecting CXL protocol (CXL.cache/mem)
errors[1] into CXL RCH Downstream ports and VH root ports[2] and
poison into CXL memory devices through the CXL debugfs. Errors are
injected using a new 'inject-error' command, while errors are reported
using a new cxl-list "-N"/"--injectable-errors" option. Device poison
can be cleared using the 'clear-error' command.

The 'inject-error'/'clear-error' commands and "-N" option of cxl-list all
require access to the CXL driver's debugfs.

The documentation for the new cxl-inject-error command shows both usage
and the possible device/error types, as well as how to retrieve them
using cxl-list. The documentation for cxl-list has also been updated to
show the usage of the new injectable errors option.

[1]: ACPI v6.5 spec, section 18.6.4
[2]: ACPI v6.5 spec, table 18.31

Ben Cheatham (7):
  libcxl: Add debugfs path to CXL context
  libcxl: Add CXL protocol errors
  libcxl: Add poison injection support
  cxl: Add inject-error command
  cxl: Add clear-error command
  cxl/list: Add injectable errors in output
  Documentation: Add docs for inject/clear-error commands

 Documentation/cxl/cxl-clear-error.txt  |  67 ++++++
 Documentation/cxl/cxl-inject-error.txt | 129 +++++++++++
 Documentation/cxl/cxl-list.txt         |  35 ++-
 Documentation/cxl/meson.build          |   2 +
 cxl/builtin.h                          |   2 +
 cxl/cxl.c                              |   2 +
 cxl/filter.c                           |  26 +++
 cxl/filter.h                           |   5 +
 cxl/inject-error.c                     | 249 ++++++++++++++++++++
 cxl/json.c                             |  30 +++
 cxl/lib/libcxl.c                       | 302 +++++++++++++++++++++++++
 cxl/lib/libcxl.sym                     |   8 +
 cxl/lib/private.h                      |  14 ++
 cxl/libcxl.h                           |  16 ++
 cxl/list.c                             |   3 +
 cxl/meson.build                        |   1 +
 util/json.h                            |   1 +
 17 files changed, 891 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/cxl/cxl-clear-error.txt
 create mode 100644 Documentation/cxl/cxl-inject-error.txt
 create mode 100644 cxl/inject-error.c

-- 
2.52.0

