Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0984C7C
	for <nvdimm@lists.linux.dev>; Mon,  2 Jun 2025 20:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748897807; cv=fail; b=UiR1XxUs12LMvAEwR2xAwNWbWQo5yvQSgorrLJwlXWTPIahLW7PvlAlVcw8urRuqGspIolT8Jx1cW70Fke7R2XaFvLIHlbcUeJ/mprpzl7yYbtU8tGljbkJp9hHbK6zDzFJRkjW22mkONZomFn6QYXj2Tpmmng+hfbOWZrVu3hk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748897807; c=relaxed/simple;
	bh=Tq21xdBwslBalINJG7ZbsT/HZHHkQL2s9lsNUKiw2Q8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=a8tA140I6h6pq6Gxq4TnA1ulGjBWB9VAWyyoLq1LwSDcDGi3WuNn0yd8dpw8fgh/lYmPxdboPg/7b0NTcdnPmc/rmC87xHrE7XfpPYhkUPS/5cu5u5oWuh68WjqQn61j3iu10BJGOwLjfgVd14ZVxFKYZEG7IUynOjeSTEqzCo4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZMz8+yIr; arc=fail smtp.client-ip=40.107.243.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZMz8+yIr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uZeX9Z0L44EzwHiMq7hFg2SPWzKGZ1H5NsAgi+sXSyyN4/bEMI4Hm0Cgvw26rcXGouq4Yq5pXF2Qgbs/AX8ALmnbgNrZdaXPQE7c2dTQAP7iwzJa974gdZtoEj6pwA0agrM1TxtBOm71uTXWY/NMH8TuvQeHCRwcbAweZKo+8VTZHXgPNGr1O0fsDJWt1gFXGqQ0JsQgdRBEPan7z6llYrbhXQ3KrTIRYXidQLWeGL+hpv9n17bnPpkK1LIxaCBJhOzJdaMc3rTeoEzOfMw6bMIIAabIwpFUVl0c/lHNXwMlCjQeCzI0WeM456Zr/SAJ9pk24/9W8RkROgg/yTTySQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A4Qaorn836ve7gnZCJMIvKxUzqcjUj8m8erbeYoS304=;
 b=qju6Fj7cYk+S4pqT59wTHfZpB7IzckrPmY68KkNb1NVzOs65hOeWC7ya7lI6iptLkWMrxkf6Fgkyb7HAEpq643DHS5toYhxyZ3pIWMTXKW2wVPCZVWrqDiJtufWuMAhlphd28gg4/3FNs1LRCuaN2SR6aATgyto7IaOG1pQ39f+wGMuO8GWzF1nPz1aaYujO5fBirZ9g1SUnSiKt1j5QGO80rkp0ZXMs+OhQBupXlixJMhnTdglHLed+2OFIkp2qdlmulEuqp3SxI+NthUxAG34Dat7Jgd+RLNRfU2WbjOyEXXBrj5CtRgsDAUgDg4mkdQlAcS7BMvkJTe5V1OkgmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A4Qaorn836ve7gnZCJMIvKxUzqcjUj8m8erbeYoS304=;
 b=ZMz8+yIrqnxDBBJeurkGjq8qsNjZzQ1KwiusP9baUKNnVIvZPOZ9MbLYoCoJA6wx493XoNMq/1azsbVxPZAbNnS73rUVLv8oScYcDAo72F/AS6VWxDl4NZn1GBGVFdOT2U/4M3+i7BXL5olCOCPRSnWBi+kb62TWs7ZiVa9L93o=
Received: from BN9PR03CA0086.namprd03.prod.outlook.com (2603:10b6:408:fc::31)
 by DM4PR12MB6351.namprd12.prod.outlook.com (2603:10b6:8:a2::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.22; Mon, 2 Jun 2025 20:56:40 +0000
Received: from BN1PEPF00004688.namprd05.prod.outlook.com
 (2603:10b6:408:fc:cafe::8e) by BN9PR03CA0086.outlook.office365.com
 (2603:10b6:408:fc::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.29 via Frontend Transport; Mon,
 2 Jun 2025 20:56:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004688.mail.protection.outlook.com (10.167.243.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8792.29 via Frontend Transport; Mon, 2 Jun 2025 20:56:40 +0000
Received: from SCS-L-bcheatha.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 2 Jun
 2025 15:56:39 -0500
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>,
	<alison.schofield@intel.com>, <junhyeok.im@samsung.com>
Subject: [ndctl PATCH v2 0/7] Add error injection support
Date: Mon, 2 Jun 2025 15:56:26 -0500
Message-ID: <20250602205633.212-1-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004688:EE_|DM4PR12MB6351:EE_
X-MS-Office365-Filtering-Correlation-Id: a0d1fe4c-7264-41d6-cb9a-08dda217f930
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BJAxaa32ZlRshrnRtl59SZJYcBLWJ7pZ+wakLOV6ggnVD573qJuaDa+ifAbC?=
 =?us-ascii?Q?5ipQpnBeH5KalsahsqJC1uREt1hpwaC2Y+O5oXH+b4cyO1SKVljRXScfC87z?=
 =?us-ascii?Q?PtJ+HNKVzcJy7Au36euP3Dm3rMgWJl8tCPZfWJ8gn4tRME+SpYPIkO5dT7oW?=
 =?us-ascii?Q?xO6KCJSAQqY8i368YxU+l89Otl7G+IXch11rAeeUAUpvw+WaZK3rOYEgDDo2?=
 =?us-ascii?Q?3IJN4pYSFzNF0BqfCtZKLHxMOV7RAA1C7x+HVv3Bjul/CUlPHahlWKXW/SRS?=
 =?us-ascii?Q?YVaLV091ei4roUB4+9j4Qr++EYZuNPTEGTcNbbdGPM5pS0JB7GTBzdSnPPNp?=
 =?us-ascii?Q?RSAxYoJWMee6nrpwa7ELE7++yU/n2sXC1Ssk21ghOHF9uCi+g2U89oF/9Uyi?=
 =?us-ascii?Q?Kt4dnl0KZVQSZCOJotKvAogzF7xdAOfym/VxXsqUySbpeix+16vg6cskKzi+?=
 =?us-ascii?Q?ur0NzSbctQ3WoldwqrebszHE9vLVnPtJQSyQgNOMNn+FX221v5F0D240uq5b?=
 =?us-ascii?Q?blRc6ziYHqdhpTn9OVBncn8NXHcgDJL9zGdjT5wGeFfJjQIIVZ1Hwc8eGVO1?=
 =?us-ascii?Q?LyAxCpdcUL4LxRpDR3mDV/FZGtZH3nqYgXA8W4ee80PZAWSbeIuu1itIHtWj?=
 =?us-ascii?Q?ublzCeiMHL3b6EaTY8dvL2puaJxwXf2LLSndj4s5ysJucDZIIc0NxeM8zFQ4?=
 =?us-ascii?Q?nWREBsj2axrn05yqu0cMqekcjvws/uULZgNNgRuTJNXA0dK6fbWNFus4/uAZ?=
 =?us-ascii?Q?G0ypnwkEl99UBkeAQ9mMWWJETWP0OPxhJ9htyk5/qLL8Ut0jhbVFNoHh8LUo?=
 =?us-ascii?Q?P8g3cYkKbo1MHD0PsClQNkBOHjEuHF4IOZM8oFaKxUwBqxaqel/esIzaMqZ/?=
 =?us-ascii?Q?MsxUkPG6enjLYIRJgodUc7KtfPMD2Q6Vk6tTAIZe3tZ4jtwRROzDrwaKIUri?=
 =?us-ascii?Q?URBsCWNIBoZZ0/je12hkkL4g/k1mcMiynYeGXeE/1kcz9SKmT8qhKP2fQ3I8?=
 =?us-ascii?Q?I7ng3Nour/tylBO9iaGHp1HOaM4dbMeWy+GYRd+eXfb89VZpwwURHbl/kss4?=
 =?us-ascii?Q?gvo9cw4ujihrK1F+EMQTqIfRw2RKiyZ+JrWur6x+lpJ8X8coANwuFDSjqq/j?=
 =?us-ascii?Q?eXOJnTlzCSWl4U0rgu7C0fswG05yyOGeVHP5glItxuAdqCS+LC4a0rvCljO7?=
 =?us-ascii?Q?5eucVxm1ahpJMBC8UzKQzxRfhOEOSi9SRu4GIMa9seSJ2qUty4q1kA9eLgTJ?=
 =?us-ascii?Q?Ky/qWGAPPQP3vCWAmLQtgKvTMfUJ7gkLx8uwigz2kVcvgWcZDKKyDVa4ONo9?=
 =?us-ascii?Q?4ctOpTIQbiogpt4fPPuqEglKNPCt1LOkeCe+1pM2Wxncoxb6vPiLMERZnKkh?=
 =?us-ascii?Q?KvVLLygLMvsqrD9f/PmpIJjQ2o7o+92+ZK/RluPTnJwCZPiUIQO9J/SL73iH?=
 =?us-ascii?Q?lNn87gdL3LpQC1XlWBSphrsPsm+7k7Zh9qk3RO4mF4dM7N7crx10kQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2025 20:56:40.4125
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0d1fe4c-7264-41d6-cb9a-08dda217f930
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004688.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6351

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

--

Alison, I reached out to Junhyeok about his poison injection series but
never heard back, so I've just continued with my original plans for a
v2.

Quick note: My testing setup is screwed up at the moment, so this
revision is untested. I'll try to get it fixed for the next revision.

--

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
 cxl/lib/libcxl.sym                     |  12 ++
 cxl/lib/private.h                      |  14 ++
 cxl/libcxl.h                           |  16 ++
 cxl/list.c                             |   3 +
 cxl/meson.build                        |   1 +
 util/json.h                            |   1 +
 16 files changed, 843 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/cxl/cxl-clear-error.txt
 create mode 100644 Documentation/cxl/cxl-inject-error.txt
 create mode 100644 cxl/inject-error.c

-- 
2.34.1

