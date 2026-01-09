Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011038.outbound.protection.outlook.com [40.93.194.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7E029DB61
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 16:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767974854; cv=fail; b=UWlHbyKprnDkAkTlhg5l0yIJ9GpaGDtjHDtdMLgUE37aBgdFPmOY6pWD0X9faWoej7uLEuHHEhownHccwHuwIgHfYCsuCahMnqP2UhS8TN0aVVMTp3Pvye37aN7kkeQ3CWtDO3hZxBdfxTSbMCVtRAQX0Jk+uJfKafb2IdzdQ0M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767974854; c=relaxed/simple;
	bh=hf+Rc/FZOMZFnUSHojfYQJMiKYUu6TANm4R/GXG+MpU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=f6e7NRxg86VgFbRmrzW2zjWPb6rBr+hlV1d3yFJw8/JeubgK+mxuFg+ioGaH/aDBV2fXoQAAXCvfrwQPW4BHAVNYOfW2mSL73IjlXQZoJAViiLW8aS1BkywlU0f45hawvpT0OSgIO1TZZiZzcDk+gJ/23i9sKMX98zWX6dzBNFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zFahfmUB; arc=fail smtp.client-ip=40.93.194.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zFahfmUB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NtWdwpFgBJu2Rd7lzvMcqPKYHCH9xyyhiepSZu1MwuVELIyxFN4zaX6vGigJvjfxMZxNpLmXMf3t0hy3lFXK5K3I2nfMg8M8QuEFOET8Iz+9tjMO+OTcC3J0L+phA5T/fHqdblSrWEyNlFikXMsr7XzrK9btv0u2QgwYY0iKdwIxtL7dIf8lMp7PwmicEHX1JHVVNIAFGUy8bBUoUGqhnPJ/iQFaqgJZPwv1lnuMI9MP9EMvgiDhZhV6R+TweORQyEZwkTrUSV6lTu1EkJPyeeyB5DxmUDdPCqT0zT1Q9zjBzQolp1g/Mw//oDcRTbq9Txmj6atm9/ZCIO8BHmXivg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R8A7bxmign/Uz5nOFEji6TzKTYYleDfX+KnLS7ZfHPI=;
 b=ygp3EAw4ImfI2XzwJRxMk1WrQjhJVInlx7V0C8GE7EfmqLP9gkNQSPEOnXzRhrdnwfJGdwHCY215ts7ErXVmAdd1/oOgqq53kH7QWfcAJ/ud1Z7gt1Np/LvGzuco58rZY5DfX5ml5k+eZe6RSWfprd6viG6kJpMJJoc2dzlT2Whhoka/r4HLSiCq2t0ruuxnyf/T66yS4A0IYVC/nal2UowD5oFsQ5mcM8pZXeabLEDj/iKhAlK5t8DKYx2zhKI59bI4KDB6oRwSDaUt1qV5QFjSzvQdSkxhZzrsbLqqPGjljwtJ/oA2dCjHIrVlP4GUB7P44DLK9vfT+1s51d5YCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R8A7bxmign/Uz5nOFEji6TzKTYYleDfX+KnLS7ZfHPI=;
 b=zFahfmUBIioc1+1z1/jevbQoB1ElK9nIHPTMw64w8pGudy2rfDvi5dLkKYchjbCw9t1/Rl7JEC9W4apDvmswaThY5x/gFAyfrtJnIfJN2O9+WRnvP60I6JFYVDnpRv8gXbTCc48zqrem9BBBYMHnHXrIZjQiGC7q7f62hu2pBUs=
Received: from MN2PR13CA0002.namprd13.prod.outlook.com (2603:10b6:208:160::15)
 by DS0PR12MB9400.namprd12.prod.outlook.com (2603:10b6:8:1b6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Fri, 9 Jan
 2026 16:07:27 +0000
Received: from BL6PEPF0002256F.namprd02.prod.outlook.com
 (2603:10b6:208:160:cafe::1) by MN2PR13CA0002.outlook.office365.com
 (2603:10b6:208:160::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1 via Frontend Transport; Fri, 9
 Jan 2026 16:07:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0002256F.mail.protection.outlook.com (10.167.249.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Fri, 9 Jan 2026 16:07:27 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 9 Jan
 2026 10:07:25 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>
Subject: [ndctl PATCH v6 0/7] Add error injection support
Date: Fri, 9 Jan 2026 10:07:13 -0600
Message-ID: <20260109160720.1823-1-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256F:EE_|DS0PR12MB9400:EE_
X-MS-Office365-Filtering-Correlation-Id: a9ed58ca-25d0-4e5e-881a-08de4f992f17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Xz3tEL/bErgTeWUWZjHxIRFe2SuVkr9ZrJ1wpF72KjmP2+BGE+TSIlENpI//?=
 =?us-ascii?Q?9Gi6rvlt9bC3G25RTthBQIbcZHVbV/T/TLf847RE6kSy6+dunIktGKO47ziS?=
 =?us-ascii?Q?P6OFmLG4mVWjbPBhzHjBnnPIZ9tJ1jZv9+/nwM6UVGDdFdH0/oIUszvHILFI?=
 =?us-ascii?Q?KAqU6i7LQMtgJ8hh7KFCoVsE/HxA6VDMu05JV2H72Slxcwnl4DnhGJuGDfgm?=
 =?us-ascii?Q?lLXVwypooeV6xwiHRnnHky4paAeYULK74dfKTVFZYdRpVWiOT+HBS5aidbiN?=
 =?us-ascii?Q?beZaO0g+GHw//KRJdG7DhRZ8qDJV/CjvakBiLtCeo0xg3YRco/0w7qryB+iZ?=
 =?us-ascii?Q?uB8kJaND/M2aQl8W5M7B/4Q+ntZnl16DDOOPi4Z9qFVWFAuN/KBpYFEHj1QL?=
 =?us-ascii?Q?ho19mclzYtrAMeS+F3wddTI5q9+8CSD8bybI07xR+RF7HfNtR6WnvMNa4yGI?=
 =?us-ascii?Q?AWnjhYt8VQCtLP/A6togzAqRTiasLKi6PGIzXIXMD8F3UCH9qovxRT69hYqV?=
 =?us-ascii?Q?9pkmJ9A93xX9XevG9tMWseGa+pBZnOkEt3RMZsT2D2VkKXaKj7BIh7REE+Yw?=
 =?us-ascii?Q?7gEzW7nmIZIL/tKa/zzkFXwyIVMGsyu+mBQw53ZKB3RTtldR3VSJ8QoqhrST?=
 =?us-ascii?Q?0h/yCzxGDIPgIjV8fD7btzkGtOY/xi/6HI6/mMB7Uo8qm3UZUuSmFE/XlYf5?=
 =?us-ascii?Q?bkK6UbLd0nJmH0U+NXCi7pe97N5ZWKKK4h4jZ1uQZta3yGfpg8Xj86x9Wv1x?=
 =?us-ascii?Q?0Po7oWSsojH5AKlGinWGtKDPGDYv3vTB18wZUAO7dHsqamxlIyE3JMU8o2bk?=
 =?us-ascii?Q?s3CAx7f1K46+Fyii01H1x+ALmo/YJciOKjAcNUNUflSDAV7ttFG+S/7ThlCw?=
 =?us-ascii?Q?7R00FCVGFmaDpWtC+FTa/BK39vYu6IqriQEilH4mIxlzP0e7ZCs2bSP6bk/A?=
 =?us-ascii?Q?hAPD58zSULj8aCjirMRYl8EQodQLoIYOS3fx7+2tVX+KwzxbJvarIriAEKZ9?=
 =?us-ascii?Q?NM4X3V76IIlLyrrYcMO42ehsE3NICQhZhF9EnJcNPYMzSl38YOreS07gzDUe?=
 =?us-ascii?Q?TnfNgQTFP5Xak4a0YfYO0sH3M0MK5+zTSttKJNAm+HUiu/eBlDbMsP5Bm6rd?=
 =?us-ascii?Q?28zA4Ouzy8i19xvw6FtQkxiohLBEgmmHdCA7AlAngjj0hPafIYrGQDFXf90V?=
 =?us-ascii?Q?xLreF9dMPk4qoQu07SOxE7ZxqA9S4p/Vy7+7Y4W0xnMtqBq+/bwKJRUf6SSt?=
 =?us-ascii?Q?1xpjz3UeVq1lR0m7B1ltk9KAX/+E4MAnpK6Hk/WNqK+3FoyqGer7e4545oh9?=
 =?us-ascii?Q?wdFcSwFskNSfAuDlxKE+HneOCYKlEM5rpU3U5hbnOCb11SqQqKDhqhic2L8i?=
 =?us-ascii?Q?+pcEwL4Otvy15smpWwcnwA4eaSvgNHIP7jkiS8v1Bp3hb/tA8VuAQhphNQrq?=
 =?us-ascii?Q?g4iBUBzNhQyZQRQwjjaFyIXtNRRbuVTcmf7FWhdSG9GAyzO0dJNE/ho6Chsv?=
 =?us-ascii?Q?yLDyo8PQMfNxzPaGAq34VEUxKiZX0lZ3/xDJ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 16:07:27.1412
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9ed58ca-25d0-4e5e-881a-08de4f992f17
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9400

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

v2 Changes:
	- Make the --clear option of 'inject-error' its own command (Alison)
	- Debugfs is now found using the /proc/mount entry instead of
	providing the path using a --debugfs option
	- Man page added for 'clear-error'
	- Reword commit descriptions for clarity

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
 cxl/lib/libcxl.c                       | 330 +++++++++++++++++++++++++
 cxl/lib/libcxl.sym                     |  10 +
 cxl/lib/private.h                      |  14 ++
 cxl/libcxl.h                           |  18 ++
 cxl/meson.build                        |   1 +
 14 files changed, 923 insertions(+)
 create mode 100644 Documentation/cxl/cxl-clear-error.txt
 create mode 100644 Documentation/cxl/cxl-inject-error.txt
 create mode 100644 cxl/inject-error.c

-- 
2.52.0

