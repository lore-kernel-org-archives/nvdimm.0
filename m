Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2041.outbound.protection.outlook.com [40.107.220.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CED1FDA82
	for <nvdimm@lists.linux.dev>; Thu, 24 Apr 2025 21:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745529858; cv=fail; b=laabte8nEPebqx92LU3nvTJ7bg5sle6H9oHtDLw2RHyQVqtfDAsGMrnneXT/VHbVrtSTAyc6hDAe56Yu3RniCIvxbvJSjK6RAyBUw2gqhWt2yIh3X5cTKvHFHopszNwogmWeQqpvrfJy4U3saNq0GTXv/gaCJg0NNNOorlVWxNk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745529858; c=relaxed/simple;
	bh=aT9PQn9+GwJNg7WBLbld78WJ+8WfPXF+mCC4O/XxiIY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UgVWBP69YJgs8HsDRKiWOp3ZZcxwPzLGEzRYn1FI7s1F9m7akoBhxvAZIdq8KD+20NilGmkQpZkrZPF2MP+lIT8iQqaMPk7jRqfkTc5htCZ7a51oncbB0KFMC7/kXbc7QdHRP2EdAKxWacQoES4UxFUmE9+kczx3MkO1AzC9A4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4NvMhT3m; arc=fail smtp.client-ip=40.107.220.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4NvMhT3m"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dgry6s9Q3QEGdHtzW+AtSubMBAvnoIIpAPXvfCdoNtJKYYeN3yybK/FL6+/39IWvKwXjzhXm6ykYDtjIzMwQwtlF99eewDsIfbl0I7xh5Sop/V2X4ierwPbOG4pV44TdY8X/F1UKp9u56G9fMKOYOmeWtAteqvB55+U0c3VmQPJxe2Tk1cL19FWHVbqfdt6Cpx1Ene0kh/ApN8761JOIDkObxrtyP2S2MEzCHYX0+ULS33yte/NkOzH9ZL/vwSAYUD17kQ7hZfshqwB7RCKNtZJGZzclzTvPKE3LQbGyhobKmIDYuNmSZglL0hootW3aAAl5IuUPLNFZNmg0Nh1LwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2uvoKFyyqPPpAB7DdzmbWdZ8obkXc3R46c9/qPLmHmo=;
 b=tyBb1pNDzAviN+fbNa7hnG3BFoimYJxQZTJATw0KNd8HcwycSaR9T/sspIRUOoA/ej2ScW+vH+lOykTsLOfhs0x5/l0nMlUUMdik2RovptchNJvaw91PE0MxDmm+vz/1vMyJIwCXFkCfkKdVfxeiR0NzATwYWdaQKXUl98yP9RzLcrJtATlmH5marxc/M+dOBASIZXtRNS7d/Mo+ty5Fvomhcl16fxmb+qyYPcgTX/4P0UfgWBhlK4OR6FTgd4IT0KHeC5fVWCqkePN8e8lmnQzh3LgbC8Ym1McnriHMVDA0qNO0+6Cz+GcdZ9G1o7WpuQlGw6r67e6EA7UYVaWaog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2uvoKFyyqPPpAB7DdzmbWdZ8obkXc3R46c9/qPLmHmo=;
 b=4NvMhT3mVnl5q5SLkgoD7xd+oSZbmk+pJLSf4AdYZEm/o+BPVemmk7unrqEthEdoksCo5cFNS1+moMvwZz266PTcIvZIcCGZ4wvw+jXT1vuR4mhx5Yf0zqrwtI/rcgEuY2L/IydvmRvoBrRnZo/WaSLsMM2Uy9takvfjlnkkoN8=
Received: from SJ0PR03CA0162.namprd03.prod.outlook.com (2603:10b6:a03:338::17)
 by DS0PR12MB8219.namprd12.prod.outlook.com (2603:10b6:8:de::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.23; Thu, 24 Apr
 2025 21:24:11 +0000
Received: from SJ5PEPF000001F4.namprd05.prod.outlook.com
 (2603:10b6:a03:338:cafe::7f) by SJ0PR03CA0162.outlook.office365.com
 (2603:10b6:a03:338::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.35 via Frontend Transport; Thu,
 24 Apr 2025 21:24:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F4.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8655.12 via Frontend Transport; Thu, 24 Apr 2025 21:24:11 +0000
Received: from bcheatha-HP-EliteBook-845-G8-Notebook-PC.amd.com
 (10.180.168.240) by SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 24 Apr 2025 16:24:09 -0500
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>,
	<alison.schofield@intel.com>
Subject: [ndctl PATCH 0/6] Add error injection support
Date: Thu, 24 Apr 2025 16:23:55 -0500
Message-ID: <20250424212401.14789-1-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F4:EE_|DS0PR12MB8219:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b734542-db39-4848-f79c-08dd83765b1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?njO98+FT6c8jpyarcD6T7gMJT8fHK/N2k+0+Iht0ilNuyY4LHQ0hoW5n6WUS?=
 =?us-ascii?Q?8SQXApJGjbxQDogYXQRlGYGIvYby4TrOcsEi0sMn0von/j82AO+Z/0Qp4Sto?=
 =?us-ascii?Q?JKebzdB0Y+ib5dJn2t+rm5ES1je2hMLa0WUU3n6ah8a8RaUHpiROnUmahCh9?=
 =?us-ascii?Q?iwVpfF5yVEnqbzzxwWBRXBAJAXxEW4DXWK55YcJzxtpqCKZyflutRbBFjz7M?=
 =?us-ascii?Q?M1M4FcidTgUY82Cb3j9NK5xHuGx0mloh9cAStFuNX5Xj8KVuP8yliCyOKnGM?=
 =?us-ascii?Q?EGoInywucrFp4GhFTRfNpdzVpxCYyielBnwID585ryFjIEsxvLMpPFrkZyU+?=
 =?us-ascii?Q?3B+QRQ/T/f/we5eo6FZgdQRhZ71gIW6KkYnhhlXo3tc3ccnaakxJJjnwzjaR?=
 =?us-ascii?Q?swK/i5e/SP0SpnkNLDZ4uPHiPLlWsLoR55I26c4TdmaPyt6n954Tis1LPz4N?=
 =?us-ascii?Q?iL8TWYshcr9xwXvW3z/my/GHIxJRfc9BZPgpJJBpkdmDaKbd44n76cQrdYQz?=
 =?us-ascii?Q?sB4fhjBiRC/ZH0HmlEOag7ErMEFZ6jzzNcAcpcMyWhl9rOgdxZvJMJ56V3SI?=
 =?us-ascii?Q?nTtSLEfyeY+5tMiRyaZSnp6djoQ3/7NQYX6qpH34d98yMqRw8QuAGpcFKx50?=
 =?us-ascii?Q?cJUcU8y0qdoRLRXxXnhrtSFAuW3iPtCyBn0dxBPWkSJGIGJjkf0C5hw8et5Y?=
 =?us-ascii?Q?w/cyIC3A0j/7wJk2SNdeO6Uos7JxjWJR+E49hamxpKqhUyPE4GWhwBKE1b3o?=
 =?us-ascii?Q?C3RE70l2vo0tPotAZXR6HUzO5knph/aBzc9UHaWW+z9fRaxphn7/QGvmi0wj?=
 =?us-ascii?Q?1+ig/s/dKYxC+B+tDaW0G71Jlsn1GgurreQb37LBV8Wyv+XbZPZwUG0bHc9Z?=
 =?us-ascii?Q?EhUy8RsA7i3KRAFYPKwiSaUTO3oqEWqw8+dH3U3rc0F4ArVmNqrg1pG1rBqy?=
 =?us-ascii?Q?3kBIan3dUTSzOyPiFPJIr8WbKSd56gXmAiaq48zSg7KjKkWdKI17Keg166mj?=
 =?us-ascii?Q?u8Ijwvc3uIOZYv+zMUoqYDFa1Phs2BUhZgkgtfSdOtLx+hYCE8r7VXqB5XuV?=
 =?us-ascii?Q?NFGCyfP2mDfY2dl2TwZaLAwTV4FxD9ymyDUEsqmqMgI2CJ2TUVSqVVx0Xu2c?=
 =?us-ascii?Q?/vBw42GVlaabjM4u2gWJkgSzrTntC86l0/Ap4Bixg6GEeQ7xyTq3IK46GAzh?=
 =?us-ascii?Q?0BjXoRUKB1oRm2NAwSdew+Ld/mHDQZh4ulmIZPzWcdM7oNd1+eejzKlYPHoW?=
 =?us-ascii?Q?NAzDwnSYlDTH2bK0eLgiZK3E+GcPhv0+uwB5/I6s3z2ucHawLLuGqBw9t9Q8?=
 =?us-ascii?Q?nUAUjA3L8EbFo9O2Dh82qgkFUt8/CX38YHruZjVQWa4jsyK5lshiN5xyxiCg?=
 =?us-ascii?Q?JgVnGmfyrB/2TdeUHYMz6jD5LjjpUxhhLdDSlNalSADEJrHarMsr2iM/iKy/?=
 =?us-ascii?Q?FOpZSADv8o4h16cSiLrxph8tLJXEYPSgofaN/ll9wrUWilHCTnzPCg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2025 21:24:11.3142
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b734542-db39-4848-f79c-08dd83765b1d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8219

This series adds support for injecting CXL protocol (CXL.cache/mem)
errors[1] into CXL RCH Downstream ports and VH root ports[2] and
poison into CXL memory devices through the CXL debugfs. Errors are
injected using a new 'inject-error' command, while errors are reported
using a new cxl-list "-N"/"--injectable-errors" option.

The 'inject-error' command and "-N" option of cxl-list both require
access to the CXL driver's debugfs. Because the debugfs doesn't have a
required mount point, a "--debugfs" option is added to both cxl-list and
cxl-inject-error to specify the path to the debugfs if it isn't mounted
to the usual place (/sys/kernel/debug).

The documentation for the new cxl-inject-error command shows both usage
and the possible device/error types, as well as how to retrieve them
using cxl-list. The documentation for cxl-list has also been updated to
show the usage of the new injectable errors and debugfs options.

[1]: ACPI v6.5 spec, section 18.6.4
[2]: ACPI v6.5 spec, table 18.31

Ben Cheatham (6):
  libcxl: Add debugfs path to CXL context
  libcxl: Add CXL protocol errors
  libcxl: Add poison injection functions
  cxl/list: Add debugfs option
  cxl/list: Add injectable-errors option
  cxl: Add inject-error command

 Documentation/cxl/cxl-inject-error.txt | 139 +++++++++++++++
 Documentation/cxl/cxl-list.txt         |  39 ++++-
 Documentation/cxl/meson.build          |   1 +
 cxl/builtin.h                          |   1 +
 cxl/cxl.c                              |   1 +
 cxl/filter.h                           |   3 +
 cxl/inject-error.c                     | 211 +++++++++++++++++++++++
 cxl/json.c                             |  30 ++++
 cxl/lib/libcxl.c                       | 225 +++++++++++++++++++++++++
 cxl/lib/libcxl.sym                     |  13 ++
 cxl/lib/private.h                      |  14 ++
 cxl/libcxl.h                           |  17 ++
 cxl/list.c                             |   9 +
 cxl/meson.build                        |   1 +
 util/json.h                            |   1 +
 15 files changed, 704 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/cxl/cxl-inject-error.txt
 create mode 100644 cxl/inject-error.c

-- 
2.34.1

