Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012043.outbound.protection.outlook.com [40.93.195.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C67311C36
	for <nvdimm@lists.linux.dev>; Fri,  6 Feb 2026 21:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770414626; cv=fail; b=aUZRr5fH56oo4LzCWVusmTq5FPWOuUDAmP5iG/I3tXE7Ko681c+u8EgGTUmO2SlVQdeAA5t4hWaWm8taCFiiU2kABgHbQJR4jfTnHteBdStajlakVnaOaDUsIQR7aWQy1wP95gM7DddKkrzlvotelXLsfPwGslSz8VSLPjRvVBc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770414626; c=relaxed/simple;
	bh=YyHCt3ssKPREnwqOD0KNd+jwsNXuccmiNl3je+UkLxA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EyB8p3lCEkiQN4fYe6f2zSMLechYkb8xVfG+7fAOTB50ab8gmrA4d5Hck3mQUZvv1k/Bws82PzSuFXJ24IaR+NWdc19Pzb+jjNiq0kqR+vdcXRg3+Rqs9UY/HAgVScCCalrPp0uo2MFvUUDosT4xLdjw92qNqkY23iYpwav6XWM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rNJwBkLq; arc=fail smtp.client-ip=40.93.195.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rNJwBkLq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lu9bE18v+Xpkbi8Ha4TfQVayl8wtKt4Yj1bMEdLOtd9sjttSEyDiL/+RU5WUQjiXl6kGahHfybSBORwFRiMQpDGB8tq0NAmThyg0oswzTvPBySbHvu9Y01F97drJjPGauu5Dpksf4InqBpNXm48/YyBseIOD34S/DUCpX4h9x9qeA4QDvY7WrtE6J5eb9VQZazF5rR7DxnaPQ+AyHSYsUOjarJToF0YiHc4sXrT2XtzegfepuTgYuZSVF2aYtPa/s2kuNAtCGjt8S7POK1e9+1BNJaBYWgtSKhjxyhqZpmfb10X1Y973twz2uBBsav820kMTy62uHl6qMTGsExE/dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i5aKHucdtA4GGjAzMMLAUAqBfYjxqjic9ITWXrjS5Dg=;
 b=nc039chH/ugRF4Vw/aSSFfC1iORHm0mpqnycVqcdoGhl3Hx5HWTQl9Ov+alQqvEaOq43x+LCI+IyeB6lxcDArWxbHWSU5XyNv5q0nfmYBFSs5SIZwOpsCt0ELsYHTJrEnhGw+NkvLpoQWJUtTpjLUd3PC2kNH5UsqBT3IvJ48qNZa5W39rEb2IaaFY9/DUXBr05zMddqcYvwcj6vbAdzcqX526uoQk9obzpOAcdgYL4fw5py7/uBlKWbp+OB7QeA1OrxuusIEG//VJPFSh75EHbcUtX9bDEzVxqesZmA2kTKSFhGdbcb0+6LJVqye3LBjJdI64A2eZS05jf0zgS1Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5aKHucdtA4GGjAzMMLAUAqBfYjxqjic9ITWXrjS5Dg=;
 b=rNJwBkLqltM9oRCtRKChOnn6CToudpMDBXwkiiDAu4a+NY1sWXF4Cx9miafGwNG5ktH/4UQpBrttfJQ8++0vzAgioCLEtPzGc86IO8BNPKU1xUSCJfVyIJY+CVCxElRyJqbfQy+FyLpexR4u2LZXdRjpjqkPBOwbMWxRun74nvs=
Received: from BLAPR03CA0154.namprd03.prod.outlook.com (2603:10b6:208:32f::28)
 by BN5PR12MB9461.namprd12.prod.outlook.com (2603:10b6:408:2a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.13; Fri, 6 Feb
 2026 21:50:21 +0000
Received: from BL02EPF0002992D.namprd02.prod.outlook.com
 (2603:10b6:208:32f:cafe::23) by BLAPR03CA0154.outlook.office365.com
 (2603:10b6:208:32f::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.15 via Frontend Transport; Fri,
 6 Feb 2026 21:50:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0002992D.mail.protection.outlook.com (10.167.249.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Fri, 6 Feb 2026 21:50:21 +0000
Received: from ausbcheatha02.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 6 Feb
 2026 15:50:20 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>, <vishal.l.verma@intel.com>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>
Subject: [ndctl PATCH v8 0/7] Add error injection support
Date: Fri, 6 Feb 2026 15:50:01 -0600
Message-ID: <20260206215008.8810-1-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992D:EE_|BN5PR12MB9461:EE_
X-MS-Office365-Filtering-Correlation-Id: e2a8b34f-53f0-45f7-56f6-08de65c9b9c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3kh75z+sDoKJYml+g+ogJghefOrpuF4Rl0tmj1zASR7zynSRVr3Meg6e+YPC?=
 =?us-ascii?Q?9vTsutu/W7QlZgMFwFSKZQmagWlBFDM4UIUL8TCPnWR0VbrELv4jpkousptq?=
 =?us-ascii?Q?6Gkz2ySSB73ClIkcnNl3h2i9XRAHtwqKHqHWYkzmPt/luZRtO5PdFInS3u7D?=
 =?us-ascii?Q?CBYoSTQgAGCAhBpyC9M7OR5cVq34Dpz4wlXjwPwPSgVdUhDbc1fv7lyatj/w?=
 =?us-ascii?Q?JufQW3hpLoWSyDsc4doFPLhmZYwdSEkBd596pQN19f24g/0FmRYlWTINOB/D?=
 =?us-ascii?Q?DlziilDTcYKJkxs/C5B7Gbs1boT4v8aQ7GCS9zyKJMFVhvRvgywNmnRZ/cAo?=
 =?us-ascii?Q?NjxK01A/WgfSLoH29cyMRSxYCt8PwVDQ5SAAuPK6vZnWZ3pF1i9H1YKXZLEo?=
 =?us-ascii?Q?JUX2HfYTgn0lUAGMJO/OO0hr9SXGWefUyslDoRco3JrzR8Jnf5PeA1N7wFgP?=
 =?us-ascii?Q?bGd4KuNFSssFkF7Q9VVw+w25u22qHA15Ys3dXD9zEs8YuflzavmRZ3KCjz2i?=
 =?us-ascii?Q?1FcBHIHiYp0FyC05dMAvlQhS5erXShr1b2843wamdE3ZdLhuAdtH2+QPl3kk?=
 =?us-ascii?Q?kZgpu/KAnPkA9avrX3xiENIZFDEyTGh33whUpuvSBbtWM3QWFqBUisTImCn9?=
 =?us-ascii?Q?lEfICk3NuI7MxeFqPqPknpdz7O41zapc9u5MVz8IkK9+XfSOZYeyplZtgm4F?=
 =?us-ascii?Q?42G9DCx6BCbCj8BSaITC7LLxhU3y73hHhcofcwzE+xDULLgiEWo5nAL3CDlt?=
 =?us-ascii?Q?JkHFC55wowwaAqgVEZgQef/IW6Ts3OEi9BM2QpyrWoQVJm7vedraB1oN89d1?=
 =?us-ascii?Q?YuLadMd6v/yBlQXlz3qbCEHQKnEKJMgO4RylqTptoeg5gua9zU65fcDSZT+K?=
 =?us-ascii?Q?9d2xzkSqxZCgnR8J8mS3NRw1JQF1c0BGct3/9EXe+aaDCjT/Z4jSILhSG3NP?=
 =?us-ascii?Q?bgkYhPDrVWnx2xyo79K2wFMZOjeimyT2+KW81unM6hlWZFcyfX9rC+9YNaas?=
 =?us-ascii?Q?mmxFFaxA7MwpUDvOBjUsKd/zAjvtDAFz1E72eL6n2TNmYAyLKy5GhStLw0kq?=
 =?us-ascii?Q?DXV3vXXn32fHDSLmhr+ynQ5xorD72dovcxA7HTY6oSHMJ+yX8lBUXBabpW1l?=
 =?us-ascii?Q?1jq1e1GaXib8wBvyWsHzytsLsg1fDc+ZeKAcFlTD6Fg267HiBlG3fETy4/iH?=
 =?us-ascii?Q?RlMUtA+Pay4Yemm+2leePx+4K6JxHiLuGJaZ+vy+0cLatGBDHtzo69SAItm0?=
 =?us-ascii?Q?rs/JcTVCUTDlMQ9cWaFqhBhuRDOgVnhgBXVzL/ZkWPsFL92/h5QxPqYVJ7UU?=
 =?us-ascii?Q?oZLY98Q3LAvXnBAJ21CshfoEkCCxZy5YP7ET2bGUO/V9Yrddt0srjhUa718D?=
 =?us-ascii?Q?5TF23ym4VRop7M0+x7Fm5ghShFybrX3s4Qjx8CPxjsHBuL/dN7B4qu+tso3a?=
 =?us-ascii?Q?5hRn5hHqVzV6MdDhY29lNBJqTP34krEwxvIEwgJD/hycymNZ7QppCxcPiQpR?=
 =?us-ascii?Q?lviGtwODKtPqvKJnFAgWopXJ/DyBq4bMaGbYEfaYJ27Y0xoSGy2K2GM1149s?=
 =?us-ascii?Q?6uJzXELJ70sfqOv+mk/958XIyvwPGop+HFyMpTAxaVwXfX6bLNsIi3Mgl402?=
 =?us-ascii?Q?9rlrIX3ctE+4D2vVBeLGEB0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6jjPFKRvZrXG/d8khaE3nlWVne+zL1PtYVM1hCCZbItUP+Q3Ewm2ATnX3ZKiLCykgB7Xn7h8GbOWzz3vPM3Y/B4kX19RfCol4wYQujTrRXObdefRg49YvxOeE7aCjWwku3RcsRCjQmgl6Ob+0Fkoo88upzBq5v9w92Hv0ov5daJAsuoE9X7UrLvdhYb01Yc2wH26H69ExgY8vTTgDzv8KFyDG6x2LpBdtwj+HRtDjFgwV4fcUYlxCt/ygQo4FshC+cjBVujK8mj7zNgOSsIIbCSQ6ZzxXXIvmze/2BkwhFtl/sYkEG4ltIbWcKd1f91E4XDwwXOChD5Z392rgRReNpSYEYI4UbLENjXM4XxwlSQnxarrrI773yj/nYta9vEyWBeKIBPdcElzprXKU793bIKpmLXoz0iMoSje9w8X/FakK/K7UOp0c1NCPf9HjHO0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 21:50:21.2517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2a8b34f-53f0-45f7-56f6-08de65c9b9c9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9461

v8 Changes:
	- Split inject-error command into 'inject-protocol-error', 'inject-media-poison' (Vishal, Alison)
	- Rename 'cxl-clear-error' command to 'cxl-clear-media-poison' (Alison)
	- Documentation rework to reflect new commands
	- Cleaned up a few error prints
	- Updated help messages
	- Change "clear" param of poison_action() to "inj" and reverse usage accordingly
	- Change cxl_memdev_has_poison_injection() to cxl_memdev_has_poison_support()
		- Used in poison_action() (cxl/inject-error.c) to report missing functionality
		more accurately
	- Print usage when '-a' option is missing for media-poison commands
	- Remove checking if '-a' option is empty in poison_action() (no longer needed)
	- Allow clearing poison when 'inject_poison' file is missing in debugfs (and vice versa)
	- Updated cover letter and commit messages

v7 Changes:
	- Use PATH_MAX instead of strlen(ctx->cxl_debugfs) for debugfs paths (Dave)
	- Add goto for error paths to memdev poison functions in patch 3/7 (Dave)
	- Add Dave's Reviewed-by tags

v6 Changes:
	- Rebase to pending branch (Alison)
	- Drop const for ctx->debugfs (Alison)
	- Rename get_debugfs_dir() to get_cxl_debugfs_dir() and return cxl directory in debugfs
	(i.e. "/sys/kernel/debug" -> "/sys/kernel/debug/cxl")
	- Rename ctx->debugfs to ctx->cxl_debugfs
	- Fix missing free of einj path (Alison)
	- Add protocol errors in order to perrors list (Alison)
	- Use hex constants instead of BIT() for protocol errors (Alison)
	- Add symbols to LIBCXL_11 instead of LIBCXL_10 (Alison)
	- Update commit message to reflect util_cxl_dport_filter() behavior (Alison)
	- Remove EINJ_TYPES_BUF_SIZE #ifdef (Alison)
	- Fix type mismatch of addr in poison_action() (Alison)
	- Fix inject_action() to catch missing 'type' option (Alison)
	- Remove '-N' option and show the information behind that option by default when
	CXL debugfs is present (Alison)
	- Add 'protocol_injectable' attribute for dports (Alison)
	- Update inject-error man page with port injection example (Alison)
	- Add warning to inject-error man page (Alison)

v5 Changes:
	- Use setmntent()/getmntent() instead of open-coding getting the
	  debugfs path (Dave)
	- Use correct return code for sysfs_read_attr() (Dave)


This series adds support for injecting CXL protocol (CXL.cache/mem)
errors[1] into CXL RCH Downstream ports and VH root ports[2] and
poison into CXL memory devices through the CXL debugfs. Protocol errors
are injected using a new 'inject-protocol-error' command. Device poison
can be injected and cleared using the 'inject-media-poison' and
'clear-media-poison' commands, respectively. All three commands require
access to the CXL driver's debugfs.

The documentation for the new commands show both usage and the possible
device/error types, as well as how to retrieve them using cxl-list. cxl-list
has been updated to include the possible error types for protocol error
injection (under the "bus" object) and which CXL dports and memory devices
support injection.

[1]: ACPI v6.5 spec, section 18.6.4
[2]: ACPI v6.5 spec, table 18.31

Ben Cheatham (7):
  libcxl: Add debugfs path to CXL context
  libcxl: Add CXL protocol errors
  libcxl: Add poison injection support
  cxl: Add inject-protocol-error command
  cxl: Add poison injection/clear commands
  cxl/list: Add injectable errors in output
  Documentation: Add docs for protocol and poison injection commands

 Documentation/cxl/cxl-clear-media-poison.txt  |  85 +++++
 Documentation/cxl/cxl-inject-media-poison.txt |  85 +++++
 .../cxl/cxl-inject-protocol-error.txt         | 105 ++++++
 Documentation/cxl/meson.build                 |   3 +
 cxl/builtin.h                                 |   3 +
 cxl/cxl.c                                     |   3 +
 cxl/filter.c                                  |  26 ++
 cxl/filter.h                                  |   2 +
 cxl/inject-error.c                            | 312 +++++++++++++++++
 cxl/json.c                                    |  38 ++
 cxl/lib/libcxl.c                              | 329 ++++++++++++++++++
 cxl/lib/libcxl.sym                            |  10 +
 cxl/lib/private.h                             |  14 +
 cxl/libcxl.h                                  |  18 +
 cxl/meson.build                               |   1 +
 15 files changed, 1034 insertions(+)
 create mode 100644 Documentation/cxl/cxl-clear-media-poison.txt
 create mode 100644 Documentation/cxl/cxl-inject-media-poison.txt
 create mode 100644 Documentation/cxl/cxl-inject-protocol-error.txt
 create mode 100644 cxl/inject-error.c

base-commit: 39085f76b6a9d3ac349c3c5dab1cb820c86a293d
-- 
2.52.0

