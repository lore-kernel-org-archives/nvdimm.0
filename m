Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40918202C5C
	for <nvdimm@lists.linux.dev>; Thu, 24 Apr 2025 21:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745529870; cv=fail; b=UwqvTekCsl2dTjK823zAaNPKeLbuQ0GkRnhj90GAN4c1XenvJCYdcw2AsGgnD25mO+tsIXUlcu+t3yvYaFLw/RgJAkOehYhkD1oFDZW5of/Rp2ClITWgEzZEqBCaC/TzTTmc8lE0V8IZQnO5GPEu1yvqCbz4/kYjJqCpEYjUPsc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745529870; c=relaxed/simple;
	bh=QwnIeHkpCzftn8TLJ06sB7b9IYlMefqFUOBkzIMoMn0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cShtwxYrySlbKgbwpQcq3qaCTYZBaFuPastKANtLuLf/SGzMAmGNE9YvE0OyuGORFfVKrjEVNK1h2sFsJPauZORwUDsx+/edGU8pEYq9/ps6UX6QxvEknuLKIvQcj8xS15DTs7r4OO/wa4CVvj3TTF49+ZwD4ORZwyepfy5Oamg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=be0tFOM0; arc=fail smtp.client-ip=40.107.94.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="be0tFOM0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lG7XMfFi9niuFbJlcEvtv83oa4ZDznN6lKKJakfWYTJqos2qb/UF79YKM74Pj61kU5jvzb+73lyj0/XEhPnK+k/ld6aNR1CCVUn+cGxvWBecD38YW8nK/vlWz/Nig48x7rKTbU2KhZkpVunBBbiT9gcB6N3GYMrkV+AdNjZb1UMfXJZjxCzaeliAvwsqJEmhFVyXOjE2N38IELQ71swI2GN24AVqgJH92TjZ7+ODmEdMuFAdcTpOHePu8aa4brtAB2Kg8szROQleJkl1VQbfILT/mSEpeQ0ifSURvm+UZdA0V9ykW1eVHfCjGh+gwALoEmjsUphcx/uc0tNhxIdVKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I4ojes033gqnA2bRP4MAKNkWjSUH0HQZGE8kAqQ1f4I=;
 b=p/4i+C/to9Z5ndZsfbswbkFFNupXRVSu03KvByeVpCWwWc7hdn7v+VpGKpRvKmrxxDYldwrAK6p9G+Oj3tCzhyp+HUAKUjm/Evtug+plA819v/VAEy/pUN7SXljr8xOSgeydvYBZSZGD/ClpZYznops0CIK/WPLJBAF7SplP+DVU1uD0Fy5vi/83BvHB/4FASinw2AmaXbGJrx+mnzAobDpmksUC1KgonrttZa1dPDfXL7MgcVhJrfdopeFsJvuV0/3ncEQ1WJm0QZ4S2AMmm0CEk+dmhJOzIQflL4a+YCad0mDPc+PTZCRQArxYIkLOWlFjqn6qkZmiR2vDk99UQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I4ojes033gqnA2bRP4MAKNkWjSUH0HQZGE8kAqQ1f4I=;
 b=be0tFOM0UnFq7d6oiZXI2gb1KhqsMSH0VPdvR1gwevSkSmuoRYK5u9OiWfYqO11eCqiAPHiy1kdZ7e6LdsFYsYSN6v/r0DbQdA8Ws2Adl6+2YjUWjkeqqFHswnBTRC9hOLQDdWqghd/UIlVJ7S9avsiFbZ2a0FECJoNVauXcRXw=
Received: from SJ0PR05CA0151.namprd05.prod.outlook.com (2603:10b6:a03:339::6)
 by PH0PR12MB7984.namprd12.prod.outlook.com (2603:10b6:510:26f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Thu, 24 Apr
 2025 21:24:25 +0000
Received: from SJ5PEPF000001F0.namprd05.prod.outlook.com
 (2603:10b6:a03:339:cafe::d9) by SJ0PR05CA0151.outlook.office365.com
 (2603:10b6:a03:339::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.16 via Frontend Transport; Thu,
 24 Apr 2025 21:24:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F0.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8655.12 via Frontend Transport; Thu, 24 Apr 2025 21:24:25 +0000
Received: from bcheatha-HP-EliteBook-845-G8-Notebook-PC.amd.com
 (10.180.168.240) by SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 24 Apr 2025 16:24:23 -0500
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>,
	<alison.schofield@intel.com>
Subject: [PATCH 1/6] libcxl: Add debugfs path to CXL context
Date: Thu, 24 Apr 2025 16:23:56 -0500
Message-ID: <20250424212401.14789-2-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250424212401.14789-1-Benjamin.Cheatham@amd.com>
References: <20250424212401.14789-1-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F0:EE_|PH0PR12MB7984:EE_
X-MS-Office365-Filtering-Correlation-Id: b462a2a1-55c8-43b6-45f3-08dd8376634c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IiEzMI0HtnbY5TGvGvhkhX1lhU6G7SNBuQFyatTwslVEfH/AJVHewDBiA/VE?=
 =?us-ascii?Q?7SGXb2TvV5OT5rslfd8Ot0UOxST9TNjdQR/OHKshQjqI3oLUsNSnSAZkNfdc?=
 =?us-ascii?Q?EXBN+en6XlrsdnFolzMBDIGJwqlxvSyXAKRyuHV0rBj7UEFeLRbwjG1P0LrX?=
 =?us-ascii?Q?DJ+nVgUYylLeb7mOb3yJA0HKkWCx/zkABLlOgCZzijorissz5qzme4SbRlYd?=
 =?us-ascii?Q?sYcTS/4vDbP+wr3/Q2PNDvI8rZT4vsVbQNON4BUmICR29RPcLBpdC5MEfuLU?=
 =?us-ascii?Q?Dn2vFEACp2ZRfZHzMYiRGnC6T4desL9w1OI/IlPzZKZ2ejMm0V+fk5XO6Ukd?=
 =?us-ascii?Q?PXJYaZwj4xp0IJ+TLE+db7MaJ82i++BKAetxiiFGnhCoYgvgeW2Of2nMFoim?=
 =?us-ascii?Q?6GZu3CnWLYAXYjil8XeOQGpIHLe0mCGQ/QGq8RbTxhvaMsllR81fiBYK2C3C?=
 =?us-ascii?Q?9jyA5sXeE1MoaUd3mjWzZ/DELCn/7sIaaAKRwLgwP5nuLLAn8IrNDekeqLn7?=
 =?us-ascii?Q?lSOhZppuWsKw7VyCj6jxGqDOJvKFdpiCPIKBy+5NbE2+0WRdSiw4ppOkqS3N?=
 =?us-ascii?Q?iUEiSyITmK+f6hRYcj9WaGp4UIUEmmgyOVyuLCtI0x2rq8hjRn2ukESsOR/A?=
 =?us-ascii?Q?b+jT98T10ylpqpN2YQa/ItSFD0qjWYXGsLzbpucQfqFcIKwvDRvuJXS0C8gT?=
 =?us-ascii?Q?WX5ELgfOrZXHBIQOPhPJJkcM79gEkK8N8uHyjRPSnQGjNerGX+jWkcL5L/Mi?=
 =?us-ascii?Q?q2J6wciKglyb5oVVaicGTgYp8GznSZfqqAiJ4GJAzsV2XYdiFCWm22J36nfQ?=
 =?us-ascii?Q?NMUv8U+10fsunpME6w0Ae/+7guE2ifzGnxOb+cqtRmoEgAv6mKNSw7GXeMdd?=
 =?us-ascii?Q?zOFnCO5wI99S82oTi6h3VyzmFIwo08aBNv0dUL4RlpQysX6sgTcRE9zxP4Vi?=
 =?us-ascii?Q?J6bQlS14oS5fOMR1hBlcHL/TZjZOlRax6XdJycjyxNPpHgBTtNg+hWSHVk4e?=
 =?us-ascii?Q?ZamLvo5PQ692TPzjXzzEeJUj++z4lrlhN1XbNR6MsClnpNVNGWv4jg9Vgr3a?=
 =?us-ascii?Q?yuJxkR/8znFQrolaJuet67R1v9mkUnl9efLi0DsI8mP52cMqnS0YUciGAx0s?=
 =?us-ascii?Q?qZ0+t8q94ove9KgesJ+oQJDU4pJRt6w/p5lqSGAbVUxz4fJSmsxbiUMY3z89?=
 =?us-ascii?Q?bhGvVjd68oYfqHaso/KUj0JED8LCCreAcUVmvuE3AK1SBNXjlzIqPU80wN3E?=
 =?us-ascii?Q?GBA1FegsfuW0355HmjLe3dksvWNMpa2pCuLaH6KTyEty6sSSmjKuK8s8mcAI?=
 =?us-ascii?Q?OZ1il3heI2HWRCQplJsfX5w3m9rvoujEETTjhVH1y6YRkyry77yZ3psrXe9p?=
 =?us-ascii?Q?UIa2QfRDmrbD1BgKTCCi+7KM57ENetwWi048SqUJn2HBc5A1dAYXtTs1SerI?=
 =?us-ascii?Q?WMdaE6OzHee2FrcsJGIrFqzLqf83v/whfDPVb5DHQ9GkFt1keNEOdXesG8kD?=
 =?us-ascii?Q?Et3msBuieBf8v7RCquccZMIMoV6v1iDFU+Wk?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2025 21:24:25.0550
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b462a2a1-55c8-43b6-45f3-08dd8376634c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7984

Add the debugfs path to the CXL library context. This will be used by
library functions that access information from the CXL debugfs to
retrieve information.

The default path is the normal mount point for the debugfs
(/sys/kernel/debug) but the debugfs mount point can vary. Add a library
API call for setting the debugfs path for cases where the debugfs isn't
mounted at the default.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/lib/libcxl.c   | 7 +++++++
 cxl/lib/libcxl.sym | 5 +++++
 cxl/libcxl.h       | 1 +
 3 files changed, 13 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 63aa4ef..e86d00f 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -54,6 +54,7 @@ struct cxl_ctx {
 	struct kmod_ctx *kmod_ctx;
 	struct daxctl_ctx *daxctl_ctx;
 	void *private_data;
+	const char *debugfs;
 };
 
 static void free_pmem(struct cxl_pmem *pmem)
@@ -294,6 +295,7 @@ CXL_EXPORT int cxl_new(struct cxl_ctx **ctx)
 	c->udev = udev;
 	c->udev_queue = udev_queue;
 	c->timeout = 5000;
+	c->debugfs = "/sys/kernel/debug";
 
 	return 0;
 
@@ -3265,6 +3267,11 @@ CXL_EXPORT int cxl_port_decoders_committed(struct cxl_port *port)
 	return port->decoders_committed;
 }
 
+CXL_EXPORT void cxl_set_debugfs(struct cxl_ctx *ctx, const char *debugfs)
+{
+	ctx->debugfs = debugfs;
+}
+
 static void *add_cxl_bus(void *parent, int id, const char *cxlbus_base)
 {
 	const char *devname = devpath_to_devname(cxlbus_base);
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 763151f..61553c0 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -287,3 +287,8 @@ global:
 	cxl_memdev_trigger_poison_list;
 	cxl_region_trigger_poison_list;
 } LIBCXL_7;
+
+LIBCXL_9 {
+global:
+	cxl_set_debugfs;
+} LIBECXL_8;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 43c082a..f3f11ad 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -32,6 +32,7 @@ void cxl_set_userdata(struct cxl_ctx *ctx, void *userdata);
 void *cxl_get_userdata(struct cxl_ctx *ctx);
 void cxl_set_private_data(struct cxl_ctx *ctx, void *data);
 void *cxl_get_private_data(struct cxl_ctx *ctx);
+void cxl_set_debugfs(struct cxl_ctx *ctx, const char *debugfs);
 
 enum cxl_fwl_status {
 	CXL_FWL_STATUS_UNKNOWN,
-- 
2.34.1

