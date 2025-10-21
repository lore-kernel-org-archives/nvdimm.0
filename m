Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013009.outbound.protection.outlook.com [40.93.201.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5923C34D904
	for <nvdimm@lists.linux.dev>; Tue, 21 Oct 2025 18:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761071538; cv=fail; b=BQMe7+rJdsEsw9W26WRAZqqJh9I31hxNVLxF2pOGLzOaMty3Ph6W4Y4Rub8lNo4OJXHCwRY7Ruga02u9LVZWQd7VmM/xID+CnHp0Gl/hPDT48ML+DTJKxA1HGtq8f02qDwC0/2ha7cndHbLEekLaEEqsDivljH76+MYIcRJGozY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761071538; c=relaxed/simple;
	bh=d8QUyDGAMWhd3VzFk1QSmCXCi9olCHJoupaDuMvAoQM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=u5/yh2oN+89UhGxNTaF5M9P6lnXwFcd6s0YV0rZoOl0bL3FmbbJfHq6Zn6q4Te3eq8HoO+bjV+Yic6pjqSRsL37Qbsowpnr53XXGYvIdDds+ixdlzvE8570P9Oy4n59VU/VP+seq4qjrxMyKow3coCHHDRA7kgg4moJvmZTSIgE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=e4YhhKOn; arc=fail smtp.client-ip=40.93.201.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="e4YhhKOn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wXMRX0IQUsoftgG8kJPrGCFWtge7Z3RkU7wlW6wxuLf79xz4PsKakIoig9CcqQA9Rad+HL7lemu9Qyr9bX3NiHI0LRlKQkzN4jvD21mCAne2NPsElSU5hfzVQf63pQTmDIP0NzT3vV8tNUuD4ft6c5Mo+1nVGn07ymYGsb+8+WGmCzPZq7QB/rHQ3NljvmrjBSLo/Tx8hJ9zJpiZ5YqWDUV8CdtdRu8KTRfzi1jGUdGqbLmY057U22oiqSEIN9ZJWGW5Qw3rjMpGDLiKkix/TDFQNE3pYOC34DeNq5wj6jRCQEdVX1hhbOVFRxF6l/0OxEeZFm6o+24QcPN4VIyWGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CmI8CgR0J2tzPxyKBVEOZNt6BELgfoPmgSaJCpLf5xU=;
 b=Q9TSORc88jYmIqsXYtVNgFSUnQF4qeCn1NoTxTRUlaA/EW+ziFde1a4BXup5EFoKpgimdDhqsSILtLXVrH1boIcCAIGCmko9mikbhr+dWka+tyEsZPOy+YkDF78ZGE0mdnfkDnd+K4SVH2pV8NS/w+tjQODX4Nu6KQOjInUQCTdNHrNOObpzAn2s9Z1hzwon40D1yfildhNSAoaW69yfxFKYWnznlabQl1MyYWjCOhjT9UcvmxUzCRtK6JVHbg3TYS0UrBV64bz9uJlbN/j2CU1bmT3V0+Pwp4UdihHnCSRJZU/fjHbVdeHMgKvD32YcpTUtSmlO9WxX/bY0jNrwPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CmI8CgR0J2tzPxyKBVEOZNt6BELgfoPmgSaJCpLf5xU=;
 b=e4YhhKOnHYdL6tokEiuMstAUezvbNcMrQpPkQbwR0IY0E9L62LBi9Ih3JTOmreHPUQweufmyGbisroC2rIzoDt7xvcTUR/0kHvqJLAh3EClErOB3xtWVx6Z72vI+OCp9Du+rn3Y2M6xTzaJOeAmYgoSYBirpxl9M9JU9IoEbZUs=
Received: from PH7P220CA0088.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32c::32)
 by IA0PR12MB8862.namprd12.prod.outlook.com (2603:10b6:208:48e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Tue, 21 Oct
 2025 18:32:10 +0000
Received: from CY4PEPF0000EE39.namprd03.prod.outlook.com
 (2603:10b6:510:32c:cafe::ac) by PH7P220CA0088.outlook.office365.com
 (2603:10b6:510:32c::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.17 via Frontend Transport; Tue,
 21 Oct 2025 18:32:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE39.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Tue, 21 Oct 2025 18:32:09 +0000
Received: from SCS-L-bcheatha.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 21 Oct
 2025 11:31:31 -0700
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>, Ben Cheatham
	<Benjamin.Cheatham@amd.com>
Subject: [ndctl PATCH v3 0/7] Add error injection support
Date: Tue, 21 Oct 2025 13:31:17 -0500
Message-ID: <20251021183124.2311-1-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE39:EE_|IA0PR12MB8862:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f50583b-d243-4f00-0f62-08de10d02513
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jmKFh0AdaiFQehLnbgMJrmad0Q2M9mzNfX9Cu4xKUkAHfw1MBg/U2SaDiAeF?=
 =?us-ascii?Q?EiPrSDG3LBZMRIp59fVKTLm9yqXafvO5VmFSqQ0pyC5p83PHYf1akKyCkMyf?=
 =?us-ascii?Q?H4VPj8mFh7O9f6/3ex5Wnb1XioO5/W4B6RF0hHf/YQep7RylkbTiQGPrXag6?=
 =?us-ascii?Q?jQXnTw68nXtl+D5ulmJJ03QwZlUDL4RxmZzGx3rKR5QPEjTf1tDGy3O2YDen?=
 =?us-ascii?Q?p7wBQJrq9BNx9AIUoiUqseQ0Z9Ji4LjidMcFv/gGLFfS8qcQ85rk1lTlEbNm?=
 =?us-ascii?Q?QOmZYu9Whs8bG7u1pZOjDLmZnm17EYOQ31L2KLhQN1kQ89EbDhHpKI8bBZWy?=
 =?us-ascii?Q?N3IbxDl0kAHZzI+7apNOHPGTd5OVAzXEDroADbF/MvKQD8kel8HftV/DS7Lq?=
 =?us-ascii?Q?KkEzm+H7XPepqBZBNX7hjKj+2VR7fnn2ubvoPTavTc3mBp+nmHTIGG7NVT0u?=
 =?us-ascii?Q?zTObSozx/Yz3RzF0LE8finEaThMA8LW0OYwrHAncz3Zbc2gb1s5d32zzgFJg?=
 =?us-ascii?Q?gn2N7Z+74ojxjNyDM/s6amORRnWrbhYTB+8ZByUG3xHMhHz4gKCegF+H0HWM?=
 =?us-ascii?Q?THvHyMjlga37DBoXvxWBOc51yssP1BJl2qNIemkQSwpIALw6DD1Fr0R+rw++?=
 =?us-ascii?Q?0sevGJjXhs+UBBLogp6gkAB5UH2BDnli5i6s7HRfB8UbKLvIsPXGkVlWSnLo?=
 =?us-ascii?Q?n2jXDH6f1B/ArDLuuqvTIR3MDOu3v7QV+U788rLgIolxfFlIE6hMsGBFkrna?=
 =?us-ascii?Q?ndoiaFSxce5As4yPGndd5Dv5bICYdX0rVtBPiwTr0vgD9Rt+Yos0G0MjHQh4?=
 =?us-ascii?Q?RmbghJCACU+Ck1PpZaoknKqM39W3je1YVf8hbtVx9D7RemogDS4OTGA5UaOo?=
 =?us-ascii?Q?43XavmK8qUqXLzkCXbUw2ESGiX4Ocul+OWcaWSf53KGfesFsWhDNh8qfivbX?=
 =?us-ascii?Q?XRseUDB/73AOwnmIt5XMEhTF13eFcUeWrXMa9IMb979vLLSQKnHzEJw0aB98?=
 =?us-ascii?Q?zbRDNtiObUAdF5k3Pcn5wp+XgcAbKTjGBmx86bkWK69GEASHA2MgKkeZer1j?=
 =?us-ascii?Q?xqYWf6yAisIs2abhj+p7OtPl4VIfQwoZBl4YQ04cUPsvq2+YyyaKODeofVkr?=
 =?us-ascii?Q?HkL5/4b2HjAYMdvVFg2f8nGhc/ETc4TXQyqFQxhTNmrnxi+1LlHc+W0CB8cs?=
 =?us-ascii?Q?53LzmUoV5Tl/ji146c74B36P5kTISapZf2DLwkh2OC61YgjjsefWlYjciPD7?=
 =?us-ascii?Q?TzGMpLeplvCTJLjql+S81V6BduK0OS7Q0kmdlo9yHAAsvzNKCDoi9Vf2VOWF?=
 =?us-ascii?Q?sOuqr4HybVQwm1L5xA8B6j/SfQgAYkkC5mcvjD3mhq4w7HXr0w0s/7uUdsHG?=
 =?us-ascii?Q?+2JafKrq/GMDrQK2K59mRhp6N5609Xg7t0fAn2VtGoZ5arUT1vCi/jdviWDt?=
 =?us-ascii?Q?LCk5ibrfFA9ZUJeq1+gs9NXgn1QS/5zyingeCCGEb0fqhvOh/tAra5O18bd3?=
 =?us-ascii?Q?X++qB6C+nQIE2K7RToZKugwREqKfm0Pom+1S?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 18:32:09.3558
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f50583b-d243-4f00-0f62-08de10d02513
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE39.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8862

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
 Documentation/cxl/cxl-inject-error.txt | 129 ++++++++++++
 Documentation/cxl/cxl-list.txt         |  35 +++-
 Documentation/cxl/meson.build          |   2 +
 cxl/builtin.h                          |   2 +
 cxl/cxl.c                              |   2 +
 cxl/filter.h                           |   3 +
 cxl/inject-error.c                     | 253 +++++++++++++++++++++++
 cxl/json.c                             |  30 +++
 cxl/lib/libcxl.c                       | 274 +++++++++++++++++++++++++
 cxl/lib/libcxl.sym                     |   8 +
 cxl/lib/private.h                      |  14 ++
 cxl/libcxl.h                           |  16 ++
 cxl/list.c                             |   3 +
 cxl/meson.build                        |   1 +
 util/json.h                            |   1 +
 16 files changed, 839 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/cxl/cxl-clear-error.txt
 create mode 100644 Documentation/cxl/cxl-inject-error.txt
 create mode 100644 cxl/inject-error.c

-- 
2.34.1

