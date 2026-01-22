Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010043.outbound.protection.outlook.com [52.101.193.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F68E3A5C20
	for <nvdimm@lists.linux.dev>; Thu, 22 Jan 2026 20:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769114267; cv=fail; b=DHI8SKkQlH8NGZ2yvFrE27M7zPZAfpm5nTAcoXru6noPvkUKaT1sGXT2AgzHSaMIoXXVBWOwaJMpb3GgBfyo5JlBNnGlcYi4fqVd9tjdpSJYk3dLiAAytGGc6/GAgkrMhZYbFnEGscaBqFneTZViH3sonK4EPPn6oksA8+XdApA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769114267; c=relaxed/simple;
	bh=dhP2N57mH7mkg4PAq5vLzfeIyaXmulOU7sMBqQuLVEg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QvZ2pNYHnUqmu969ho+B6NO5aJ7owPYYzBQ1hh4V3W1gysg51zLDsPl0/cpadv+wkxaBJbrOiFmF/WFbfNqIYAC8uz07SGCatpoi7WougYPyQKmun4pRFPguwChv15H8XOOVEfXuAg+tbb5HlBSBhlui42zha/DoIscNUpz1LmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BcGF/k/O; arc=fail smtp.client-ip=52.101.193.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BcGF/k/O"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nlk2BHw+RfggGHDi0UFNiwIvJxN0/yGIhan1yWDo0uXodO3mH0FLm1x3qkdp40BpLm81JK2KDQ9n5Xscq5VEtJkvC9/mM5h7/DfKKYeQVQn6HKs0RWur5xfu9nuu0ZEYqkbY6yhaYmNg0MMiO/75vsDxj9JNDssIwjfxDPgqkmyXvlgK7t8VzQH0wTszYRxyLAoOzKpVbEuVuQ/FCdUlFQnq/S2IOx76zOwuGiUNiLj2N011s9fja+xWp2+krdGPtsoprXbGTyjqHgDpsBOGzRLmxhYu5NA9ZEl6AhseDcPPdkRjyMR7RbPCRFgd0YnMxdU8VoZ2PCN16A+LmwgOIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mgu0sOlwQw9BTEv4MAdK2upvILwOxlr5im8NIGOH4bg=;
 b=FhZHC9omSG2bubvB91/ui867DPlK0eN7gwhtl/JW1D6uvOhLPGYyi4WKJMM35g93x0bhvL1IUKIOKRzxx29j1NsZsSFW63zgAR8lQDRDeb/aWdLJuAdMqrmUon8kcZOESwMkderb2WHPslhXRuNwG3aMYxNej2UoglpMVJUxBZUAnlyyQQo5pcUKjSNQ1Vup67VxRpSsMPZdcXjG+5qo15/QpNzu6/cxgca+qt+1jNQsyW/cF3gauicrEXwzclMiZ0bmzTYCokFGsdrJ4+ZLCv7YDkB184U9vxCE4WAcMkM6pW/uo/YkO5ZdJTulTXpcwI/En4ijMCANQZEAY4+hyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mgu0sOlwQw9BTEv4MAdK2upvILwOxlr5im8NIGOH4bg=;
 b=BcGF/k/OVy2A8oBme1XxLfqBkWtSfrpPZeJ8ILJ+BkYiecEOAbzkb3JIoUy0bkyMWyPFti0vkXGgTzVU1YYIjUD2K5LAm90ydW1KLl2qksBddCFDqzBNVvhj8DQVmjBot/SJQcCUCU9f2DbMZGu/1LnxfJI25SPR7Lh1/rXGvks=
Received: from SA9PR13CA0045.namprd13.prod.outlook.com (2603:10b6:806:22::20)
 by PH7PR12MB7259.namprd12.prod.outlook.com (2603:10b6:510:207::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 22 Jan
 2026 20:37:35 +0000
Received: from SA2PEPF00001505.namprd04.prod.outlook.com
 (2603:10b6:806:22:cafe::3a) by SA9PR13CA0045.outlook.office365.com
 (2603:10b6:806:22::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.8 via Frontend Transport; Thu,
 22 Jan 2026 20:37:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00001505.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 22 Jan 2026 20:37:35 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 22 Jan
 2026 14:37:34 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>
Subject: [ndctl PATCH v7 0/7] Add error injection support
Date: Thu, 22 Jan 2026 14:37:21 -0600
Message-ID: <20260122203728.622-1-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00001505:EE_|PH7PR12MB7259:EE_
X-MS-Office365-Filtering-Correlation-Id: f0da0c2f-38ee-43ac-0657-08de59f6136e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tZxq/h0e1fz/Z0/5Gr5PdR6LPIWpVTx9gkZToDhrVaIg7o5wMrCg8EMqPyqb?=
 =?us-ascii?Q?QTS3gs5onqLAZGPpFLZUHSs96LgEptV4/grtaOsQW9EAg2Zi7Hjxqa5b7FGP?=
 =?us-ascii?Q?tEOHuT87ZJzMuXcp/FSv+LpRR+p+WKpossrzcTObqqISyMXhAFeNO+9FDdPZ?=
 =?us-ascii?Q?yrTeWNHulGbnvUUOPEnmDS3Plb+8d5N608WVF7hS5bMU12iFocby943Pl4m2?=
 =?us-ascii?Q?tjcDUvJ75XlVRhfHzQCFoTC9gjx/kYWE3+ul1ci6SjGnbapQK172TQmeM1Tk?=
 =?us-ascii?Q?zt1JaD7QXdar4ZCizGF8+NodBP5+fnf1iDSrw/sPtrZnDzFXkTj6B5aC7yXz?=
 =?us-ascii?Q?ZrU4He/GuhI0vPvjIYRi0rNxjRq484EDUiyCk98JyyL437r59gMuWXCY33lD?=
 =?us-ascii?Q?m5iQJ9+2CnzJse0+Kd1NQ9ZeRnVVP5Eg0RfkPusSND0tXiwhDAN5tiqlfLnQ?=
 =?us-ascii?Q?BLHAg2OuVvz78lyNRwqjZ8H/V0wIF7QzbxB9VgANGxPTmh0p4vohBvI87ycb?=
 =?us-ascii?Q?hG7LdVyK2vstGVNDbtMvZUtP8ndFL6p4IakY0JNXlDAH/2d/uK05nj2o5ALk?=
 =?us-ascii?Q?fr8eQjhHoFvpb9UT8kpDy8BlibEeQzaME5jFYhCNK5NqvyNCTp40fPW/wf7H?=
 =?us-ascii?Q?QQcB7S/jIdsaDdHVbIgUOULvfKQrOFF5xi0kHYSY0KN75rWpUZZX4mOc893Z?=
 =?us-ascii?Q?GJd3uiAXWsoU/yCBihIGJpYhzKNaORnJy/DI4fa/GM3MA6deBVLku87iSKuD?=
 =?us-ascii?Q?UO0R8AndmQOIH9HU9RAtYyPrWjQYc7HLlBc30ggmCxmKii3wq37TaS/ZDQcd?=
 =?us-ascii?Q?bD/21vapybMpmIMFvSYLtR6cLnhvIiLJP3Gf0qEXMj/5HBzpxp9+NrSnP3cy?=
 =?us-ascii?Q?iZ2GekvOM+XWtk3+GpYXmk6fFWiSQ+hBH8gmpk0Mseo7ZZuEgzzs/TLEIQjN?=
 =?us-ascii?Q?lO56Z85ZTXt5rNyvv0BrR+K59shJDMhO6Ilz4VKY0jLOdmPtpgXJ4HjBH+uF?=
 =?us-ascii?Q?3IEM+q+/bwktStVJz0VvCpCQ5ekxxNjL5/YOvfXw/NO80+JQjHT37ugb2eYo?=
 =?us-ascii?Q?IsF8N8WPF9TD/Qf8WTE3fY25PxNXDgU2N2FP0Td3SQn+QRP4Pi1+zpcRjutj?=
 =?us-ascii?Q?TcYykF8VcOkABsqPvN8f7ca18kodvWkAItVUioROaTCuPh5OEPVfqLuRbJHI?=
 =?us-ascii?Q?x/PC5G6yeDAJLdZrF8z/AFr9w/VUn5rspDidqdgtb3OMMA3VjTz24OgSV/bH?=
 =?us-ascii?Q?bMeFEq2IPP0TwYcUoWPIRJUnt9mpFNGMjQLxxlJWJg1hUU2wIcduVkKmsE6e?=
 =?us-ascii?Q?FZ14B0YZ3RDHZy30u1ggST+XfmzswBNGAMDzet8CUBG7vHpkUdUlW2YlaYFn?=
 =?us-ascii?Q?Y6gWfU8bA7zwiNuv493xrHSjwNqvq38xKUQpUdw5W4mR5iVGHamzpGMwJrq1?=
 =?us-ascii?Q?uJIUQ7cTuoefi6W38toYyAvNKaCp6CWhwKJec9BOm+S9x9saxEL7l9pwGEO5?=
 =?us-ascii?Q?TwfPWypUj8FrDuVXf1ZqwZmZTjl/28ePFQl4me6i/e51lCnX6PIuzgwC85Z/?=
 =?us-ascii?Q?ZQMumw6tFxgKbR7V2fN9ECyEj1tci6mfznEaAMK6CKfZ4IOtLj4EEVm4e8fE?=
 =?us-ascii?Q?vsuvhKXFUyVNc5nQ/g4AFwM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 20:37:35.5382
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0da0c2f-38ee-43ac-0657-08de59f6136e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001505.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7259

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

This series adds support for injecting CXL protocol (CXL.cache/mem)
errors[1] into CXL RCH Downstream ports and VH root ports[2] and
poison into CXL memory devices through the CXL debugfs. Errors are
injected using a new 'inject-error' command. Device poison can be
cleared using the 'clear-error' command. The 'inject-error' and
'clear-error' commands require access to the CXL driver's debugfs.

The documentation for the new cxl-inject-error command shows both usage
and the possible device/error types, as well as how to retrieve them
using cxl-list. cxl-list has been updated to include the possible error
types for protocol error injection (under the "bus" object) and which CXL
dports and memory devices support injection.

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

 Documentation/cxl/cxl-clear-error.txt  |  69 ++++++
 Documentation/cxl/cxl-inject-error.txt | 161 ++++++++++++
 Documentation/cxl/meson.build          |   2 +
 cxl/builtin.h                          |   2 +
 cxl/cxl.c                              |   2 +
 cxl/filter.c                           |  26 ++
 cxl/filter.h                           |   2 +
 cxl/inject-error.c                     | 248 +++++++++++++++++++
 cxl/json.c                             |  38 +++
 cxl/lib/libcxl.c                       | 327 +++++++++++++++++++++++++
 cxl/lib/libcxl.sym                     |  10 +
 cxl/lib/private.h                      |  14 ++
 cxl/libcxl.h                           |  18 ++
 cxl/meson.build                        |   1 +
 14 files changed, 920 insertions(+)
 create mode 100644 Documentation/cxl/cxl-clear-error.txt
 create mode 100644 Documentation/cxl/cxl-inject-error.txt
 create mode 100644 cxl/inject-error.c

-- 
2.52.0

