Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011007.outbound.protection.outlook.com [52.101.52.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB8F328614
	for <nvdimm@lists.linux.dev>; Tue,  9 Dec 2025 17:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765300460; cv=fail; b=Kga/5FTzq9xcasAFKCo6jGBX/p/17gJXesBsCI0EaNTTQIAcdOrG0WDSc2bfbz/L4P4n3KKkAS/FLdUBnJn53FOsakC5F5w3uIB/IOcEFeyreGGY3yYbXxkYPueXse0DMfmsWYA9XwCK+idyRIWcRayvjMk5DafNo/guEW7KfZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765300460; c=relaxed/simple;
	bh=HMdtN3rsRH6t48QtVDS5U+2zXJuO/lz+liD1xKorAbM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AORT58w+MZWMjWCPXV1pxMNqJGVAR88VF4qLaM8xUiFzIyObz6XHDdRQGBRLFqwulucKJ+Iunt7CpYNZ2NLFGBeGybgYQ2oGAg5Rpbs6UKo949isdcgXK7RXmliyhiWOkM/zn887B7Gjgw+kolUfn9+hwK3n94PEiIumPEOnVIM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Cpru+Wfz; arc=fail smtp.client-ip=52.101.52.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Cpru+Wfz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X1XeH0HzWaPkx/KV6xM2L8barfDZ5CGf4miIc080Ts9CapiYiFA33ZJiD6sZUuzc8iOhn3zsdEVb1D2Izppc0W2mCJVjwa9lTb5HxmXLQksoK7MmV66mfYtl4iCGJifJVxScs0s9hjc7QQEi9PtJ6GXUSGMgZ0JdqWPPAwbyAvuW3YgsQKnlZKJ7qWHJAY5i7NaoV4AlvbC5zyjx0UQKCPG9h9eViMFdvoNSUls4H+95DBL1Ro9Iz3fK3+5a0m1Tw34npsATL4b4ZcHtq+EYF9jMbInSeeuh2OKWQdLhfBAGhxLWN0kQsE33wEagv9NNcsl+Buc54GB4ulisHDTtXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q7lVzunFdOwh/mrL50fOpup1wdLU175lGFbaWzpfviI=;
 b=ZUnbEa2xztMGA0Z6Zq1ntatXYfGBRT3xno6lN5DNPJbXvm6Mj/zAIGPcsGpjcM3JsGkD69dab1Ui1Rac4NyeRA442Zn3glOWS7o0b47pFZ0lbHAQb6ONkILnAOeeCg8ceJoRXyNTTO0RjMiE/CE56fTVtaFgaNNMtI2qsBAJAD8BLeJEIaYZAHVWxqDRafi8NW+fJ4/KIwl/f1t+OLMjAqoYIJkAk0hkMrVJa9+EbgIgW+3CyGtrU7gF0kCe16qAOUU/Hox5shBPQah/T+iH1VRfgTixzH4nNlcPSa3pjJ7lmz0U7duBcsFY162aWVO9fbX0kVyo7TyaLUYgzHBrDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q7lVzunFdOwh/mrL50fOpup1wdLU175lGFbaWzpfviI=;
 b=Cpru+WfzwLHILjycR1VULzTYoXGI4RUAIZZJRbKti7R8INm0x6Vaw3huTXlxOaayQyRUJjDyq7ZxAZwum9HrXH9+JhakVQGhbawKGW+1LXJam3Qgso617QvFJsbRC7t6FwVBVeP8fiQsUbsTThUAKbaVPdsFaj39mMICd6rknlY=
Received: from PH8PR05CA0009.namprd05.prod.outlook.com (2603:10b6:510:2cc::26)
 by SA0PR12MB4414.namprd12.prod.outlook.com (2603:10b6:806:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Tue, 9 Dec
 2025 17:14:15 +0000
Received: from SJ1PEPF000023D4.namprd21.prod.outlook.com
 (2603:10b6:510:2cc:cafe::cb) by PH8PR05CA0009.outlook.office365.com
 (2603:10b6:510:2cc::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.6 via Frontend Transport; Tue, 9
 Dec 2025 17:14:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF000023D4.mail.protection.outlook.com (10.167.244.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.0 via Frontend Transport; Tue, 9 Dec 2025 17:14:15 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 9 Dec
 2025 11:14:14 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>, <benjamin.cheatham@amd.com>
Subject: [ndctl PATCH v4 0/7] Add error injection support
Date: Tue, 9 Dec 2025 11:13:57 -0600
Message-ID: <20251209171404.64412-1-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D4:EE_|SA0PR12MB4414:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bb8ef9a-50d9-4d95-f9ca-08de3746616c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LdkHbuyCm99TTG+ugVizz/MrdsD6eG87jMzPAI4cGZ0d/3ze3tSkp0ZhHpPi?=
 =?us-ascii?Q?5mslIusus8Iz+BLtgUtMoohtgu8Rl25ASo0QxWdSX9HkT/GflvrAZQfJ5lhp?=
 =?us-ascii?Q?pEABR0k+8mYI1dDuW0yULNhUF1kko3JjZoePNbqIc6IbycJAhoo/+RsJTWqL?=
 =?us-ascii?Q?j8Aeka3OQjKYJFV25Gia0KBrRdya2z+Gs487Ezo0ZjlOMwKs14bXGT3SZ0dV?=
 =?us-ascii?Q?m4IvyPccmDgBaZfWILdlZME5ZnGVL25HiJ8H7YlOYjcIp5D7i4RF9ipgPza0?=
 =?us-ascii?Q?/p8ZBU1QOXBEQDbX39/AjxPCbwNvkum7cqdnUEJKpBLLyUJdL6kwz/57cKcO?=
 =?us-ascii?Q?H9fLay1BO8m1pVBh2ycUi2h3CEoCZSvQctR+n7XXy3W0YDppiFcDcJ72j0P4?=
 =?us-ascii?Q?rhSpiciQ0/bxoqbORN/qHNTnLKQVwoLxKKZVk9o/ho8mOOIOMSIpzKk4sxl6?=
 =?us-ascii?Q?W30DYxnvrPqn6gfdcN17JkTZUN5B5c/FjEmhZwELmLI35egZOnzWzmosgQji?=
 =?us-ascii?Q?tLj/B+2XjKzyv/Lb3DPCgr8tDYcBEnd3UhSdgeXcBPuPwXL20bllgivOLBaL?=
 =?us-ascii?Q?rYr4UpTaPJVMRydYjHX/BMS0IVnxMM+5xJxNkrePmrsKPE3eFZc24KS7PM4w?=
 =?us-ascii?Q?+2/SErbY0xEUpgNJBVLCj1Y3Ntpin7ni63Xp7VQlvUXt0Jd/pAwgxdKRLPJs?=
 =?us-ascii?Q?QN2qoYxoePyIyVnOVmAx9d6YCNvcEFoCYS8Y5S4hhrFNRurif1S8iKMtsiZT?=
 =?us-ascii?Q?KSx7FwIYLsi6t38wvJXrN1tHafQLYgqm8q8XEis6rPw5ORYU0UGOE+pbQRFz?=
 =?us-ascii?Q?3/EBLfvPGAbJx1mSAsUjMdQPy2ZUkKvGLyndoKofqBTh0lXelzk727dKBAj+?=
 =?us-ascii?Q?WLsisYe5HArcWw9gC2wprWzQ9Kn+lK9hnGWV4xFm6v61c8fb8/JcJDtxGRiF?=
 =?us-ascii?Q?ckhb5RDrs5mA36MiIPhwkih+aTOPJfLqoMncc1G3m1eUhcGlOJKXOAenOnZv?=
 =?us-ascii?Q?CwCNckSsM3FosHnmjIASZaIUT8yXJ/cawCMVkx+xJ8Ic8D9sDK0fl8WP5Y8B?=
 =?us-ascii?Q?AXjgpXtEpKzlrElJZdkPF8vqjmm5gvZBwvqJeXqPgdJcEtKsicZNdLe5KW//?=
 =?us-ascii?Q?2fwYmeQC8XclAqbtvJA9FJdswMPC5HK26BHuQsgQFEpRbAB4MyzSKfB1otv9?=
 =?us-ascii?Q?WJYlH3d7j8XEIPIK6UoCbfrb90hndhMW1UO3y/AxcT1ho+z1is0iRpICvcto?=
 =?us-ascii?Q?Uhz7kx525Ld0k4gkmSHfAMDVaGR8AxGP5L7kM5kQwmpULcpUgX18PMCSaSd1?=
 =?us-ascii?Q?VrM/Yam98cEMwi8ox32vgTgLn7plRNPxFUTgd0Mc/jQbKsM5MB9tl0fByOkc?=
 =?us-ascii?Q?tx3rTQ+Zd11FOVGBxxxA1cBaz66RKBQVdgcWqftxqPdudt6x/f8zGReLu6kj?=
 =?us-ascii?Q?99T/HRFc1gC6wReLC82T0+xsn+n1KSh/12ReOURJGJC57HplWybUM8ZBWkZh?=
 =?us-ascii?Q?3tHbf53bB7cU8/HpwySY6jcfFXqKLLgYeYJX?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 17:14:15.3904
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bb8ef9a-50d9-4d95-f9ca-08de3746616c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D4.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4414

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
 Documentation/cxl/cxl-inject-error.txt | 129 ++++++++++
 Documentation/cxl/cxl-list.txt         |  35 ++-
 Documentation/cxl/meson.build          |   2 +
 cxl/builtin.h                          |   2 +
 cxl/cxl.c                              |   2 +
 cxl/filter.c                           |  26 ++
 cxl/filter.h                           |   5 +
 cxl/inject-error.c                     | 249 +++++++++++++++++++
 cxl/json.c                             |  30 +++
 cxl/lib/libcxl.c                       | 316 +++++++++++++++++++++++++
 cxl/lib/libcxl.sym                     |   8 +
 cxl/lib/private.h                      |  14 ++
 cxl/libcxl.h                           |  16 ++
 cxl/list.c                             |   3 +
 cxl/meson.build                        |   1 +
 util/json.h                            |   1 +
 17 files changed, 905 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/cxl/cxl-clear-error.txt
 create mode 100644 Documentation/cxl/cxl-inject-error.txt
 create mode 100644 cxl/inject-error.c

-- 
2.51.1

