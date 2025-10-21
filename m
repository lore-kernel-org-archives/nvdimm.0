Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013017.outbound.protection.outlook.com [40.107.201.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D887434D914
	for <nvdimm@lists.linux.dev>; Tue, 21 Oct 2025 18:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761071574; cv=fail; b=AOs1l7no43VlYMYfc1YWwoirrgBkU8wj56vu9aPRyeLfCo25rX8FchFHA8JJzXPMaUNmus1PdMZ36wXJtZOhuj6+tZxeTVxltDOkPYchjW3rDZujoOJAtJYWQn2KcOdfbB6k0Aj3oUBQGQZmVpNJ8y90Go+q3+Mi82Penq323ek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761071574; c=relaxed/simple;
	bh=e73f5sPmuTW7xg92BoSymGAXHF3DhfyV2JVWpxK6juQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R29QEZ4nB20/Fsdpy//G8+yjFuF8I2H1z8KU8RYxNkzDIU7w/Ye9Q6ol6B1lHauEVoY8opZwQYIncFHXjw7l/tHbWC/9j0jaUZ2QSdPZzN7JHnwzRea2srif4DoVhNx6dvLa/gp0yr0WnamoSRcJF2kIR9Vfmmuchju8pyaV9yQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wCnu0kr6; arc=fail smtp.client-ip=40.107.201.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wCnu0kr6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XB34y+jF09cxvtEEEDyp03bi3Eqr/SaNdr1j9+P84dr/ZNda7xiuwQTTWNfvuAagb3xl76FhSii+bXiQeSljfKjlXudQeozIgxV+60B73QTYqdM3YwTOGtIOw7h3Es8R3qDiHLByO/lW2LXMImjw1ufboJfdIB3cY0g49M9aL/vgTM0T15fsADhAjSDUXIgh0byarmcoNfl8O3AN+S6xn9aDJUGr/j+S/i5xS8+dVnWeiEK4Y5fUKB4IsH5RA9kgUjgL28enBrgze+nLSf0CHreQTMwalB+1/RTi5xx1EFRWL73N8hV+JKEDe3L/HIy+MS+TDNvru1W65GgTBBVxxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lqd+XmjRQzd105iUR92E2545IeA1FmuDelzq0Oz40Vw=;
 b=nz315EtUKoWZ2K98MqxfxgCPl5919LM3zXl1CxPQqu4l8rnNkDKZvjdQ2KPehJE8OdOHMwIGIPedbgD0hX5vIY8TOZ1xD1oTscwTOcMzUGNGwHxNPTSZ/gjHbTa3AFvgeunYC4UiQ2EwKmCo8Ef5tIt24b9aS+hjNIJFkN47pzW39ebQkdYJ30ZoAnSx0qR5inwmyzmbpBbzLN2M7oYBPngkYu9UpJ5A3oLn2RdwnTWGsQeHxDooHyD8d0JRIeH9ej8cT0Dr4tWEAItT+G4hPgUDvqNFrg3E7IJQuhLCfZ54pMluPJTj1avu3yH54kswNoQMjnvO/t2R3eY8Qju7Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lqd+XmjRQzd105iUR92E2545IeA1FmuDelzq0Oz40Vw=;
 b=wCnu0kr6yQGet7+wb0fW13lOdKiGOEmBbF0UueVzTu8ZyP65fBS2hZO7KwNuI9C4o7jR32U7HB9JuuIgciyu3gBEXM7z9fXoK/sXEPpAsmWtORKyDby3FW4yhYJdTROg6G5EW4/vWYnRH+79J4TiHWUKOVoSt4D0E7S+oO8Jlyg=
Received: from CY8P220CA0010.NAMP220.PROD.OUTLOOK.COM (2603:10b6:930:46::22)
 by MW4PR12MB7216.namprd12.prod.outlook.com (2603:10b6:303:226::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Tue, 21 Oct
 2025 18:32:49 +0000
Received: from CY4PEPF0000EE3C.namprd03.prod.outlook.com
 (2603:10b6:930:46:cafe::f2) by CY8P220CA0010.outlook.office365.com
 (2603:10b6:930:46::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.17 via Frontend Transport; Tue,
 21 Oct 2025 18:32:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE3C.mail.protection.outlook.com (10.167.242.13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Tue, 21 Oct 2025 18:32:49 +0000
Received: from SCS-L-bcheatha.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 21 Oct
 2025 11:32:48 -0700
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>, Ben Cheatham
	<Benjamin.Cheatham@amd.com>
Subject: [ndctl PATCH v3 4/7] cxl: Add inject-error command
Date: Tue, 21 Oct 2025 13:31:21 -0500
Message-ID: <20251021183124.2311-5-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251021183124.2311-1-Benjamin.Cheatham@amd.com>
References: <20251021183124.2311-1-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3C:EE_|MW4PR12MB7216:EE_
X-MS-Office365-Filtering-Correlation-Id: fb4d2b02-a6eb-4371-e301-08de10d03ccb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RKn9P7YNCsbMvyDMPC7IN9eIT7nIOfOltOBE+Jh7UiutSiibrAEFAZpIR+si?=
 =?us-ascii?Q?L0oBee85c5+jXfhYEoFqRxVOXHzXRiQLy09SRX/MUXYjbX3HBzQrShnVv//x?=
 =?us-ascii?Q?HQrRf+xjL5Rf7t9gXAFqn//lLWCtdSNgYLyO1XGZHpjHuDbNxjS8qGogC7NY?=
 =?us-ascii?Q?Z417w6PhEP5TFMQJ7zbkIXRJ0k+RLtbB8aLkk3QDRgGGDfCie/xa+0Wr5SAy?=
 =?us-ascii?Q?s+xySf1WPAvKID99u8bIiwp9VNfu1SnUUnM9MdBOmAtTlm95dmuxj/unm+3V?=
 =?us-ascii?Q?thLVfipKImygJGotcBJnwUzFu89g8N5XzAVIRk1fjNyh5POLN2vAUmAwIVjj?=
 =?us-ascii?Q?zbcYHNUwgOSGmObJ+7K9n9R8K3zP+gsMk7ydNiQI4LCmPYxIacZkAnutKLJg?=
 =?us-ascii?Q?6HS1CfnBc0a0EodPWqzXQ+GPRsJ4nEFnU9gaUCIsf2ox3kSUwTnqbbPYheKj?=
 =?us-ascii?Q?6bmhfvtubWTemzQpv9I5bIqUyxttABcf1Cz+51HSvUA0HdFQLUjpYUmxgY0W?=
 =?us-ascii?Q?7cAuKLq87vu/zQNPbAzEBgsMsvh8FSo9HgSicA+NkBtHO/caqzML/xM9kr5C?=
 =?us-ascii?Q?U4Z2IjEAcEoSRsmQhqr2rVS/9R8I9ktKnNlzPwSNB0cvhrduLwBrBsGzoEFG?=
 =?us-ascii?Q?/HdLYHu15CBHiybIIQRf39Vtl7OVyJ62GEkc70w5tu+xFzO5ifEEm2Zmhnw/?=
 =?us-ascii?Q?Gh2CEmSaaAcYT5YO/xKZJKTo0XUNY1O1NhuET9Dwa42Avd1/HZNRLDrq++6c?=
 =?us-ascii?Q?TJD9KJ+glqvAi06WyA8JU23zfTdKorSiBK1gBsPN6X2jlBBxIu4tR0pIbPBv?=
 =?us-ascii?Q?MJX4ZHzQrGqjkBIchz10hA83n5Hongf0evUPTmJ4AHH8Kc3xgRdzThzmJBza?=
 =?us-ascii?Q?JmL61O6VWWsV7QUvBZv1UqtVPdj7dy6qPStQVI7WmQbdmcU7yEC7Xia2cxC5?=
 =?us-ascii?Q?srg0x7K2J17mpusPiSOxfrbHk0wJoB5wSAkLh487vwB0yniw61M6blKgKf9U?=
 =?us-ascii?Q?fSaqWHYBvGLNCuw67abJt5f043X0ZuNf88QSgQyYCcxtn3u7F2eaq7TMEfVK?=
 =?us-ascii?Q?rElG8FkD6C7KxgTsRWGDPQfW+CAP1hlzoqTbxj6LETrtleQPjwu15SPybi2z?=
 =?us-ascii?Q?8yYP88PzpYHUQEj3DOPh8tx3YEi3Gsz7mDgkK88xlkV7ieMtRAXb2zvVn5Bf?=
 =?us-ascii?Q?+sLfFfgtduOCEHCE9BtaEviH9uziaWCuW3ZCz9z+8RpEKJFFiE7MANV3xIZM?=
 =?us-ascii?Q?0zpXLlm0duFtny/vVWlWtrF8xNO9FP88bDPxFZV3Af0+fl78YxVyC+HQTjRs?=
 =?us-ascii?Q?blslb8fHs0z+Wgm+5bCODNojADDGLogbs4+FkNUCDjfWd6p0N8DPxGrARrh1?=
 =?us-ascii?Q?GGnxTT2lN458gILqI9DmvpD+XGQAr+ZiKMNqXWlVPcdHHF1+h1X/g2thocWh?=
 =?us-ascii?Q?wd21OyXq/28fdDevSAGljyWWkq73h9eS2jspugBkGzUJ8yijzneZ7yC9frnz?=
 =?us-ascii?Q?m/CNFJp19CI5OLC8WNIUWSoQywrJCVsLu9aKAbs990JkKTmADYat1wHavTnx?=
 =?us-ascii?Q?KXwXZNCYBTRs9VtcHWQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 18:32:49.1548
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb4d2b02-a6eb-4371-e301-08de10d03ccb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7216

Add the 'cxl-inject-error' command. This command will provide CXL
protocol error injection for CXL VH root ports and CXL RCH downstream
ports, as well as poison injection for CXL memory devices.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/builtin.h      |   1 +
 cxl/cxl.c          |   1 +
 cxl/inject-error.c | 195 +++++++++++++++++++++++++++++++++++++++++++++
 cxl/meson.build    |   1 +
 4 files changed, 198 insertions(+)
 create mode 100644 cxl/inject-error.c

diff --git a/cxl/builtin.h b/cxl/builtin.h
index c483f30..e82fcb5 100644
--- a/cxl/builtin.h
+++ b/cxl/builtin.h
@@ -25,6 +25,7 @@ int cmd_create_region(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_enable_region(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_disable_region(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_destroy_region(int argc, const char **argv, struct cxl_ctx *ctx);
+int cmd_inject_error(int argc, const char **argv, struct cxl_ctx *ctx);
 #ifdef ENABLE_LIBTRACEFS
 int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx);
 #else
diff --git a/cxl/cxl.c b/cxl/cxl.c
index 1643667..a98bd6b 100644
--- a/cxl/cxl.c
+++ b/cxl/cxl.c
@@ -80,6 +80,7 @@ static struct cmd_struct commands[] = {
 	{ "disable-region", .c_fn = cmd_disable_region },
 	{ "destroy-region", .c_fn = cmd_destroy_region },
 	{ "monitor", .c_fn = cmd_monitor },
+	{ "inject-error", .c_fn = cmd_inject_error },
 };
 
 int main(int argc, const char **argv)
diff --git a/cxl/inject-error.c b/cxl/inject-error.c
new file mode 100644
index 0000000..c48ea69
--- /dev/null
+++ b/cxl/inject-error.c
@@ -0,0 +1,195 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2025 AMD. All rights reserved. */
+#include <util/parse-options.h>
+#include <cxl/libcxl.h>
+#include <cxl/filter.h>
+#include <util/log.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <errno.h>
+#include <limits.h>
+
+#define EINJ_TYPES_BUF_SIZE 512
+
+static bool debug;
+
+static struct inject_params {
+	const char *type;
+	const char *address;
+} inj_param;
+
+static const struct option inject_options[] = {
+	OPT_STRING('t', "type", &inj_param.type, "Error type",
+		   "Error type to inject into <device>"),
+	OPT_STRING('a', "address", &inj_param.address, "Address for poison injection",
+		   "Device physical address for poison injection in hex or decimal"),
+#ifdef ENABLE_DEBUG
+	OPT_BOOLEAN(0, "debug", &debug, "turn on debug output"),
+#endif
+	OPT_END(),
+};
+
+static struct log_ctx iel;
+
+static struct cxl_protocol_error *find_cxl_proto_err(struct cxl_ctx *ctx,
+						     const char *type)
+{
+	struct cxl_protocol_error *perror;
+
+	cxl_protocol_error_foreach(ctx, perror) {
+		if (strcmp(type, cxl_protocol_error_get_str(perror)) == 0)
+			return perror;
+	}
+
+	log_err(&iel, "Invalid CXL protocol error type: %s\n", type);
+	return NULL;
+}
+
+static struct cxl_dport *find_cxl_dport(struct cxl_ctx *ctx, const char *devname)
+{
+	struct cxl_port *port, *top;
+	struct cxl_dport *dport;
+	struct cxl_bus *bus;
+
+	cxl_bus_foreach(ctx, bus) {
+		top = cxl_bus_get_port(bus);
+
+		cxl_port_foreach_all(top, port)
+			cxl_dport_foreach(port, dport)
+				if (!strcmp(devname,
+					    cxl_dport_get_devname(dport)))
+					return dport;
+	}
+
+	log_err(&iel, "Downstream port \"%s\" not found\n", devname);
+	return NULL;
+}
+
+static struct cxl_memdev *find_cxl_memdev(struct cxl_ctx *ctx,
+					  const char *filter)
+{
+	struct cxl_memdev *memdev;
+
+	cxl_memdev_foreach(ctx, memdev) {
+		if (util_cxl_memdev_filter(memdev, filter, NULL))
+			return memdev;
+	}
+
+	log_err(&iel, "Memdev \"%s\" not found\n", filter);
+	return NULL;
+}
+
+static int inject_proto_err(struct cxl_ctx *ctx, const char *devname,
+			    struct cxl_protocol_error *perror)
+{
+	struct cxl_dport *dport;
+	int rc;
+
+	if (!devname) {
+		log_err(&iel, "No downstream port specified for injection\n");
+		return -EINVAL;
+	}
+
+	dport = find_cxl_dport(ctx, devname);
+	if (!dport)
+		return -ENODEV;
+
+	rc = cxl_dport_protocol_error_inject(dport,
+					     cxl_protocol_error_get_num(perror));
+	if (rc)
+		return rc;
+
+	printf("injected %s protocol error.\n",
+	       cxl_protocol_error_get_str(perror));
+	return 0;
+}
+
+static int poison_action(struct cxl_ctx *ctx, const char *filter,
+			 const char *addr)
+{
+	struct cxl_memdev *memdev;
+	size_t a;
+	int rc;
+
+	memdev = find_cxl_memdev(ctx, filter);
+	if (!memdev)
+		return -ENODEV;
+
+	if (!cxl_memdev_has_poison_injection(memdev)) {
+		log_err(&iel, "%s does not support error injection\n",
+			cxl_memdev_get_devname(memdev));
+		return -EINVAL;
+	}
+
+	if (!addr) {
+		log_err(&iel, "no address provided\n");
+		return -EINVAL;
+	}
+
+	a = strtoull(addr, NULL, 0);
+	if (a == ULLONG_MAX && errno == ERANGE) {
+		log_err(&iel, "invalid address %s", addr);
+		return -EINVAL;
+	}
+
+	rc = cxl_memdev_inject_poison(memdev, a);
+
+	if (rc)
+		log_err(&iel, "failed to inject poison at %s:%s: %s\n",
+			cxl_memdev_get_devname(memdev), addr, strerror(-rc));
+	else
+		printf("poison injected at %s:%s\n",
+		       cxl_memdev_get_devname(memdev), addr);
+
+	return rc;
+}
+
+static int inject_action(int argc, const char **argv, struct cxl_ctx *ctx,
+			 const struct option *options, const char *usage)
+{
+	struct cxl_protocol_error *perr;
+	const char * const u[] = {
+		usage,
+		NULL
+	};
+	int rc = -EINVAL;
+
+	log_init(&iel, "cxl inject-error", "CXL_INJECT_LOG");
+	argc = parse_options(argc, argv, options, u, 0);
+
+	if (debug) {
+		cxl_set_log_priority(ctx, LOG_DEBUG);
+		iel.log_priority = LOG_DEBUG;
+	} else {
+		iel.log_priority = LOG_INFO;
+	}
+
+	if (argc != 1) {
+		usage_with_options(u, options);
+		return rc;
+	}
+
+	if (strcmp(inj_param.type, "poison") == 0) {
+		rc = poison_action(ctx, argv[0], inj_param.address);
+		return rc;
+	}
+
+	perr = find_cxl_proto_err(ctx, inj_param.type);
+	if (perr) {
+		rc = inject_proto_err(ctx, argv[0], perr);
+		if (rc)
+			log_err(&iel, "Failed to inject error: %d\n", rc);
+	}
+
+	log_err(&iel, "Invalid error type %s", inj_param.type);
+	return rc;
+}
+
+int cmd_inject_error(int argc, const char **argv, struct cxl_ctx *ctx)
+{
+	int rc = inject_action(argc, argv, ctx, inject_options,
+			       "inject-error <device> [<options>]");
+
+	return rc ? EXIT_FAILURE : EXIT_SUCCESS;
+}
diff --git a/cxl/meson.build b/cxl/meson.build
index b9924ae..92031b5 100644
--- a/cxl/meson.build
+++ b/cxl/meson.build
@@ -7,6 +7,7 @@ cxl_src = [
   'memdev.c',
   'json.c',
   'filter.c',
+  'inject-error.c',
   '../daxctl/json.c',
   '../daxctl/filter.c',
 ]
-- 
2.34.1

