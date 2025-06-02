Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EF01993BD
	for <nvdimm@lists.linux.dev>; Mon,  2 Jun 2025 20:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748897831; cv=fail; b=WKKguEynLmpcyj1gB+E/4f6tmObdO63+nKrisbgBCz7UQeedOOwTOIYyY2cfoNqBGehZLVcEmolp1w9rEVXS+ENwRF8HH9semtXnWq/RpH/t+Gye8N7dbCnGtPGPpq3zsP6288VnTxkiYUk7OAaoVYHJoBkwlFF+rXEbX0FYMXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748897831; c=relaxed/simple;
	bh=6bE9n0UsxSn32eKfmSYPLSGt2Mhfz2fu0jMUM+xlV+s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LqkYSKGTHRyPw3lcb/Frwa3ApODn4ayu6HQ8iFVC+qvH8/WUHRh86UV9ijzMPPX9rJCnWLCAeFQN4yLEleaynIZye0eIk0aBAAjCWq93r80byBo20k+tGx/NqkEEyQ83mNAVbp5iv65N+hr2fVL5w1C20yLTh8i435bQKjXWQgk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mpbkk5t4; arc=fail smtp.client-ip=40.107.220.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mpbkk5t4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q7w+/7XmtGmmdSOYg/Hx0oFsV5qZKJdGzewSlf00umHEDkelRN0VfPfrIWybf1fIpf5tWKrVGZ3byJDPIajU8wz4mGx++t5hJhaif3sRFTkHAVDMmugkTq/GbF1eejh80K+qsMNuLeFtTTssjpxT6Rjs25jzaYYMjId4lj0badjPDyygZ4Cfyj/fb29RIOor6yfxVYIhMXeqPOMGzh9UK/Vg/QX/kL4RiSjMrW71dr/8LYLEk9COlovqF/Zo9JppfKtRDDqWA0trurhi9Dp50FBS/LwR5MNZMX3pPtLD6A3zeQuHhcicdors7ZtEVin9BsVdmWwKjKQto0eouMn28w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ljj/5zlH0x4MvMWMi/Ip5iDaQjN+VkY+NYKbEjkA3vU=;
 b=A7xNm8i42+tj8VxQdmMxs8qfh4C9+2C02M+vpaNPQ8aqGHOo6RI6MdmTObOnbpCXid5khr2AiXJqjRuV5jFj5x1yVwx2eaj0IDoKW5II8qjcttwD3JJBifGhsSgppd+g3/cMzlRcgKbXkjurZ4VJPnVHW9VIza5GY8H80p9zf6/VBmTRS8bBdP0gwH/kxw2OLK69831caM56gvuhDG4z4WpQ3Di54CMMjcuL31BVFv95tyx0blEPUjEqKLi4lxaLzzdMH7YfdbHqinl87bPbMisPtnJcVjKtnw1y3wSVO+feJ3NK1U679eDjf/1IqrviX2bBPAeHuou9WsPXwq2ZjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ljj/5zlH0x4MvMWMi/Ip5iDaQjN+VkY+NYKbEjkA3vU=;
 b=mpbkk5t4bvyq7xL2fUbBRUcur8qC/UBvEyJF5wT0ffqEV5ebM6bqcc46xSww90XGzA9z1iIcS2L3spnc//x1Fn9Kz6/QYacPtLhJjlsMID58RuvOvC/Be4oSejpJqCwOnFLYChMzcVzTxEW1jyTqjFt86Ia47DVzp2ZhE+AVuks=
Received: from BLAPR03CA0091.namprd03.prod.outlook.com (2603:10b6:208:32a::6)
 by SN7PR12MB8002.namprd12.prod.outlook.com (2603:10b6:806:34b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.28; Mon, 2 Jun
 2025 20:57:03 +0000
Received: from BN1PEPF0000468B.namprd05.prod.outlook.com
 (2603:10b6:208:32a:cafe::57) by BLAPR03CA0091.outlook.office365.com
 (2603:10b6:208:32a::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.19 via Frontend Transport; Mon,
 2 Jun 2025 20:57:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF0000468B.mail.protection.outlook.com (10.167.243.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8792.29 via Frontend Transport; Mon, 2 Jun 2025 20:57:03 +0000
Received: from SCS-L-bcheatha.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 2 Jun
 2025 15:57:02 -0500
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>,
	<alison.schofield@intel.com>, <junhyeok.im@samsung.com>
Subject: [ndctl PATCH v2 2/7] libcxl: Add CXL protocol errors
Date: Mon, 2 Jun 2025 15:56:28 -0500
Message-ID: <20250602205633.212-3-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250602205633.212-1-Benjamin.Cheatham@amd.com>
References: <20250602205633.212-1-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468B:EE_|SN7PR12MB8002:EE_
X-MS-Office365-Filtering-Correlation-Id: 06dc4d58-d972-430b-b3fc-08dda21806e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?75Q4D7zBKs2zkajwhnupbXpqnV8cRqocSf5sUPhViFnLXNU0xrM8DNVqzUP0?=
 =?us-ascii?Q?VBHEY0xuGU0G6HlDOqxLV/3Z4POS8/dtuHz61y5RImqU0OzuIQqNKhpYMfc+?=
 =?us-ascii?Q?OzExej3HiZe72HXPwYbVG5wqh+2+O574/7VGdYH6r9YIcy/oxUkQXvTjaEHr?=
 =?us-ascii?Q?ggwAdKt/mhXqnAIgzaOQ4kmxIh+OBx2HBAkyfn577QWGyUH5l1gQBQYWhW6V?=
 =?us-ascii?Q?yqzJCpTwvWrIfxQfEckSoO+hbsgDffblNQcb/KT1SmJq7VYs3qHBRQb/6qey?=
 =?us-ascii?Q?IKqDZ6/ihulqwEXSuGxcO1JngUwD2DcdgTLpoZ/YAH9+YLjMvMAtzFgH1Vbg?=
 =?us-ascii?Q?eN6ktdH9xHewec7MiyDfaJkBrJ7CgoNWJR47HKXHr9wJeNihVLtjDt8h5o6Q?=
 =?us-ascii?Q?lUFqQ+rh7uuOHaq70TE7fkzCUv7AeVTZbj1rC9UeVJQxlRy7LoezAjiItELe?=
 =?us-ascii?Q?iv5XzrtFQNrDWRwu+IaHnK0MzEXwaO4N3DdsI8Eo/KsvC/S4QBdbZuGYJBh7?=
 =?us-ascii?Q?XQ2j6OnUMLrzwoMlOh/xdH14n3280lpOc/+XAdrdNmSo6LhMH0GT02q1VVxe?=
 =?us-ascii?Q?n7DQ6zKhUHLr7U+X1GBbGbNQFA1UU3RE60+5FU0hUAK3nsAdVYyIBwcNtfgz?=
 =?us-ascii?Q?B+pzMTiXRN/a5YbG46fRZHP4ib/+a7yRg/n7Sq393BIcM4gm6VwsON149os/?=
 =?us-ascii?Q?X0ekUn7UeynZCiOnXd43qJjgfQtYdd8qUZXNrld97ws20vFc6X1JGJvdh3gW?=
 =?us-ascii?Q?4CHugfLo2qFf09GR+3duLUjFSEUl9S5fOGkSHJx0OQOLFYAy/HdBvrMTcssQ?=
 =?us-ascii?Q?XlIinwCzCLaENLS/kp28rvmJIkjBQdFEke0gM7V9zj6QUHMIT31POVUOuGYT?=
 =?us-ascii?Q?vUOuIOQYIja6b7KwJbV+pToi/cWwsJ1HXiNOohzbUXrMnsOqncvQYULJ4FVI?=
 =?us-ascii?Q?pj+ONbE+s96mJ04i9cY8tgDyRaWLfOIMq0hbDivKUk9T6E+boXpVRUXCpm1U?=
 =?us-ascii?Q?vRz4VdkrSfP6KS0nvnbbcqo0aENhJPjBnq6tkxF2FR+z5j3YFxJW+tm0JZLv?=
 =?us-ascii?Q?nxngsAyjiUbtu7Lyh3DrabyvEy51jHtw+DcvE2NgiL3C63Trp/eD5ZXfA/FF?=
 =?us-ascii?Q?oJQET+JZow8/Ufmhx9FK2zkulqiH5V5oo0D8I6NpsZiAwQSXn3Jns+j8kJ3A?=
 =?us-ascii?Q?zuKUyeNMgJXAZZ2Oajj+rgqhO5QDGuOYFKCT749rm742n4KzCrNnHR0dy5NI?=
 =?us-ascii?Q?yMll5gVCUpP/ANpyhtiEiDtzEjYbj4UESfysIH+xRse2OL4iHEJEW/0de/R5?=
 =?us-ascii?Q?fNRxvfxcisEErg5ZKPat6m3QZctivmIG9oQnSUXYOxt1uhuB5kQ2ns6vHm8J?=
 =?us-ascii?Q?RJVklKd95Z85nxRQH9NX5b6BVeKrlxZLJzlCUpEFRgFap2xMpel7vZ/N9IDD?=
 =?us-ascii?Q?6mkgJvb+23rJtl2zoWEkFW1d/SjgCzTcZRBSvb5m02DUVr+EF05frJoyiOZI?=
 =?us-ascii?Q?fIbIM2zIYri6i67q9TgI9KDPJ+AIk3aaD8V8?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2025 20:57:03.4484
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06dc4d58-d972-430b-b3fc-08dda21806e2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8002

The v6.11 Linux kernel adds CXL protocl (CXL.cache & CXL.mem) error
injection for platforms that implement the error types as according to
the v6.5+ ACPI specification. The interface for injecting these errors
are provided by the kernel under the CXL debugfs. The relevant files in
the interface are the einj_types file, which provides the available CXL
error types for injection, and the einj_inject file, which injects the
error into a CXL VH root port or CXL RCH downstream port.

Add a library API to retrieve the CXL error types and inject them. This
API will be used in a later commit by the 'cxl-inject-error' and
'cxl-list' commands.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/lib/libcxl.c   | 174 +++++++++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |   9 +++
 cxl/lib/private.h  |  14 ++++
 cxl/libcxl.h       |  13 ++++
 4 files changed, 210 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 3e0aa5c..0403fa9 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -46,11 +46,13 @@ struct cxl_ctx {
 	void *userdata;
 	int memdevs_init;
 	int buses_init;
+	int perrors_init;
 	unsigned long timeout;
 	struct udev *udev;
 	struct udev_queue *udev_queue;
 	struct list_head memdevs;
 	struct list_head buses;
+	struct list_head perrors;
 	struct kmod_ctx *kmod_ctx;
 	struct daxctl_ctx *daxctl_ctx;
 	void *private_data;
@@ -204,6 +206,14 @@ static void free_bus(struct cxl_bus *bus, struct list_head *head)
 	free(bus);
 }
 
+static void free_protocol_error(struct cxl_protocol_error *perror,
+				struct list_head *head)
+{
+	if (head)
+		list_del_from(head, &perror->list);
+	free(perror);
+}
+
 /**
  * cxl_get_userdata - retrieve stored data pointer from library context
  * @ctx: cxl library context
@@ -327,6 +337,7 @@ CXL_EXPORT int cxl_new(struct cxl_ctx **ctx)
 	*ctx = c;
 	list_head_init(&c->memdevs);
 	list_head_init(&c->buses);
+	list_head_init(&c->perrors);
 	c->kmod_ctx = kmod_ctx;
 	c->daxctl_ctx = daxctl_ctx;
 	c->udev = udev;
@@ -368,6 +379,7 @@ CXL_EXPORT struct cxl_ctx *cxl_ref(struct cxl_ctx *ctx)
  */
 CXL_EXPORT void cxl_unref(struct cxl_ctx *ctx)
 {
+	struct cxl_protocol_error *perror, *_p;
 	struct cxl_memdev *memdev, *_d;
 	struct cxl_bus *bus, *_b;
 
@@ -383,6 +395,9 @@ CXL_EXPORT void cxl_unref(struct cxl_ctx *ctx)
 	list_for_each_safe(&ctx->buses, bus, _b, port.list)
 		free_bus(bus, &ctx->buses);
 
+	list_for_each_safe(&ctx->perrors, perror, _p, list)
+		free_protocol_error(perror, &ctx->perrors);
+
 	udev_queue_unref(ctx->udev_queue);
 	udev_unref(ctx->udev);
 	kmod_unref(ctx->kmod_ctx);
@@ -3305,6 +3320,165 @@ CXL_EXPORT int cxl_port_decoders_committed(struct cxl_port *port)
 	return port->decoders_committed;
 }
 
+const struct cxl_protocol_error cxl_protocol_errors[] = {
+	CXL_PROTOCOL_ERROR(12, "cache-correctable"),
+	CXL_PROTOCOL_ERROR(13, "cache-uncorrectable"),
+	CXL_PROTOCOL_ERROR(14, "cache-fatal"),
+	CXL_PROTOCOL_ERROR(15, "mem-correctable"),
+	CXL_PROTOCOL_ERROR(16, "mem-uncorrectable"),
+	CXL_PROTOCOL_ERROR(17, "mem-fatal")
+};
+
+static struct cxl_protocol_error *create_cxl_protocol_error(struct cxl_ctx *ctx,
+							    unsigned long n)
+{
+	struct cxl_protocol_error *perror;
+
+	for (unsigned long i = 0; i < ARRAY_SIZE(cxl_protocol_errors); i++) {
+		if (n != BIT(cxl_protocol_errors[i].num))
+			continue;
+
+		perror = calloc(1, sizeof(*perror));
+		if (!perror)
+			return NULL;
+
+		*perror = cxl_protocol_errors[i];
+		perror->ctx = ctx;
+		return perror;
+	}
+
+	return NULL;
+}
+
+static void cxl_add_protocol_errors(struct cxl_ctx *ctx)
+{
+	struct cxl_protocol_error *perror;
+	char *path, *num, *save;
+	unsigned long n;
+	size_t path_len;
+	char buf[512];
+	int rc = 0;
+
+	if (!ctx->debugfs)
+		return;
+
+	path_len = strlen(ctx->debugfs) + 100;
+	path = calloc(1, path_len);
+	if (!path)
+		return;
+
+	snprintf(path, path_len, "%s/cxl/einj_types", ctx->debugfs);
+	rc = access(path, F_OK);
+	if (rc) {
+		err(ctx, "failed to access %s: %s\n", path, strerror(-rc));
+		goto err;
+	}
+
+	rc = sysfs_read_attr(ctx, path, buf);
+	if (rc) {
+		err(ctx, "failed to read %s: %s\n", path, strerror(-rc));
+		goto err;
+	}
+
+	/*
+	 * The format of the output of the einj_types attr is:
+	 * <Error number in hex 1> <Error name 1>
+	 * <Error number in hex 2> <Error name 2>
+	 * ...
+	 *
+	 * We only need the number, so parse that and skip the rest of
+	 * the line.
+	 */
+	num = strtok_r(buf, " \n", &save);
+	while (num) {
+		n = strtoul(num, NULL, 16);
+		perror = create_cxl_protocol_error(ctx, n);
+		if (perror)
+			list_add(&ctx->perrors, &perror->list);
+
+		num = strtok_r(NULL, "\n", &save);
+		if (!num)
+			break;
+
+		num = strtok_r(NULL, " \n", &save);
+	}
+
+err:
+	free(path);
+}
+
+static void cxl_protocol_errors_init(struct cxl_ctx *ctx)
+{
+	if (ctx->perrors_init)
+		return;
+
+	ctx->perrors_init = 1;
+	cxl_add_protocol_errors(ctx);
+}
+
+CXL_EXPORT struct cxl_protocol_error *
+cxl_protocol_error_get_first(struct cxl_ctx *ctx)
+{
+	cxl_protocol_errors_init(ctx);
+
+	return list_top(&ctx->perrors, struct cxl_protocol_error, list);
+}
+
+CXL_EXPORT struct cxl_protocol_error *
+cxl_protocol_error_get_next(struct cxl_protocol_error *perror)
+{
+	struct cxl_ctx *ctx = perror->ctx;
+
+	return list_next(&ctx->perrors, perror, list);
+}
+
+CXL_EXPORT unsigned long
+cxl_protocol_error_get_num(struct cxl_protocol_error *perror)
+{
+	return perror->num;
+}
+
+CXL_EXPORT const char *
+cxl_protocol_error_get_str(struct cxl_protocol_error *perror)
+{
+	return perror->string;
+}
+
+CXL_EXPORT int cxl_dport_protocol_error_inject(struct cxl_dport *dport,
+					       unsigned long error)
+{
+	struct cxl_ctx *ctx = dport->port->ctx;
+	unsigned long path_len;
+	char buf[32] = { 0 };
+	char *path;
+	int rc;
+
+	if (!ctx->debugfs)
+		return -ENOENT;
+
+	path_len = strlen(ctx->debugfs) + 100;
+	path = calloc(path_len, sizeof(char));
+	if (!path)
+		return -ENOMEM;
+
+	snprintf(path, path_len, "%s/cxl/%s/einj_inject", ctx->debugfs,
+		 cxl_dport_get_devname(dport));
+	rc = access(path, F_OK);
+	if (rc) {
+		err(ctx, "failed to access %s: %s\n", path, strerror(-rc));
+		free(path);
+		return rc;
+	}
+
+	snprintf(buf, sizeof(buf), "0x%lx\n", error);
+	rc = sysfs_write_attr(ctx, path, buf);
+	if (rc)
+		err(ctx, "failed to write %s: %s\n", path, strerror(-rc));
+
+	free(path);
+	return rc;
+}
+
 static void *add_cxl_bus(void *parent, int id, const char *cxlbus_base)
 {
 	const char *devname = devpath_to_devname(cxlbus_base);
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 763151f..61ed0db 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -287,3 +287,12 @@ global:
 	cxl_memdev_trigger_poison_list;
 	cxl_region_trigger_poison_list;
 } LIBCXL_7;
+
+LIBCXL_9 {
+global:
+	cxl_protocol_error_get_first;
+	cxl_protocol_error_get_next;
+	cxl_protocol_error_get_num;
+	cxl_protocol_error_get_str;
+	cxl_dport_protocol_error_inject;
+} LIBECXL_8;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index b6cd910..85806ac 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -102,6 +102,20 @@ struct cxl_port {
 	struct list_head dports;
 };
 
+struct cxl_protocol_error {
+	unsigned long num;
+	const char *string;
+	struct cxl_ctx *ctx;
+	struct list_node list;
+};
+
+#define CXL_PROTOCOL_ERROR(n, str)	\
+	((struct cxl_protocol_error){	\
+		.num = (n),		\
+		.string = (str),	\
+		.ctx = NULL,		\
+	})
+
 struct cxl_bus {
 	struct cxl_port port;
 };
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 43c082a..afa076a 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -486,6 +486,19 @@ int cxl_cmd_alert_config_set_enable_alert_actions(struct cxl_cmd *cmd,
 						  int enable);
 struct cxl_cmd *cxl_cmd_new_set_alert_config(struct cxl_memdev *memdev);
 
+struct cxl_protocol_error;
+struct cxl_protocol_error *cxl_protocol_error_get_first(struct cxl_ctx *ctx);
+struct cxl_protocol_error *
+cxl_protocol_error_get_next(struct cxl_protocol_error *perror);
+unsigned long cxl_protocol_error_get_num(struct cxl_protocol_error *perror);
+const char *cxl_protocol_error_get_str(struct cxl_protocol_error *perror);
+int cxl_dport_protocol_error_inject(struct cxl_dport *dport,
+				    unsigned long error);
+
+#define cxl_protocol_error_foreach(ctx, perror)				       \
+	for (perror = cxl_protocol_error_get_first(ctx); perror != NULL;       \
+	     perror = cxl_protocol_error_get_next(perror))
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
-- 
2.34.1

