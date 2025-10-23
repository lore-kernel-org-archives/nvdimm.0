Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013051.outbound.protection.outlook.com [40.93.201.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964F842065
	for <nvdimm@lists.linux.dev>; Thu, 23 Oct 2025 20:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761250540; cv=fail; b=RA9jWmh54uflf2b3d/2LxolZffSAm3yBfaBJzwbAY+CQi2TITdc7hGSJ0xsrZSGBsxXrfLIOdSgFVm7ubr84sFjf4rw7vN7exTltPR/MkF1nRnzUyW6GO744SduMvDnqyW5hwu68voIACCqau3libxvQN4pBo374uw+Y0Gp384k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761250540; c=relaxed/simple;
	bh=oPojhbqcmovHa8blo8H2PiHfvecBXqXwrDRlcyZw6Xk=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=E12mHMZ/5uzqKC7dz5kLviQ/i2hW+dtaZ35DJ3tKOMzVlkd/rlv9Fml7fj6Go194EThXMAfIZoa+3Q6+qqbOkvasbZlNCUlbzJWjFR8si4HKNfwLajdSqY87xLPLI/T8OTHx+U0NO0r1BJCsa+GZhTpySRaYwMrkAKOt1rr0SoE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Bpx1ieY+; arc=fail smtp.client-ip=40.93.201.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Bpx1ieY+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LoWHagCfRyUHu+yRCHsRwMmzNAsiorsc48vqMp9f4nU9ey6qNHLr8AAsq7mqEw2RNSJsv9k2CDHHewemIoBeDZdyg2cGSwoWkW78CUFXLTLptr7FBIIM+2/leuvhl6QMNlDJur4odqYtezxkgglQ348CieidZfY6bTaZcz6pLGVZlwtXVi+VLrJRNDlgUK16o/yI17VsAk4Fq9wpFfyBRqQQSKR88KhMTd6HiYhDNQQMbyLMElCFsiGMh7DCaJF/3cCV28+k3ydGYnnoaCovBiarXZ9sVa5l/gdQLpWp+lc0Qug84gtflJYuYKJ/GiJcOjHXSfeugmiTGpLbZAHf1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eZYeDLovOnwos3MsisXZHf7Q4RLbbgdTtnqzxvxoyVU=;
 b=bRSntRDBReAg6lSWql6ZyXiOUX53tZIFoat+CT3Mf2Hqtr37DSj4mSDyfNx1rmdJK+DrXGgHBuRKXHBc3MNEy3oLaJGrD/L64Lg1xdwjWJS3dPBAhJK2h45IhiHGsfjc3XJ7L3klDLxy2lYmKpBFxWOgHei1fG69bM0LGPXdbhTHGUL241pWdKFq5GuQDBz0et6Qgf/dKprx0O2FJOcZaJ1IOJHLSOHxeAnb+qu1bh/haYXpmAGtgPFaeOayjweoYkDrOWITVqUmsu+rNlG5HIhBkThcFkbxPjrb5cZi3YYefSi9QkakJ6kz4F7jwr119ifCstZmOJhE/LJQGwWelw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eZYeDLovOnwos3MsisXZHf7Q4RLbbgdTtnqzxvxoyVU=;
 b=Bpx1ieY+/sLbHINN8Ajrrkzrm+fA3P2A0e/EDCNRr2q9w8A2dPdcQ/h7kbX0DWigecdxbiMvTSW+nUHYC/tIsbRoH4/FkR9R5mTIfNF2IIApu+dhK0cEbqWjP9cDcXWlDFxw6WJGn5cTcHIxZWt6bKSvRi0M/li128dEFlhBri0=
Received: from SJ0PR05CA0202.namprd05.prod.outlook.com (2603:10b6:a03:330::27)
 by SA5PPF7F0CA3746.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8d1) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 20:15:35 +0000
Received: from SJ1PEPF00002325.namprd03.prod.outlook.com
 (2603:10b6:a03:330:cafe::35) by SJ0PR05CA0202.outlook.office365.com
 (2603:10b6:a03:330::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.11 via Frontend Transport; Thu,
 23 Oct 2025 20:15:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002325.mail.protection.outlook.com (10.167.242.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Thu, 23 Oct 2025 20:15:35 +0000
Received: from [10.254.54.138] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 23 Oct
 2025 13:15:34 -0700
Message-ID: <33c55070-35f4-4aec-afd1-33197b368d80@amd.com>
Date: Thu, 23 Oct 2025 15:15:33 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Subject: Re: [ndctl PATCH v3 4/7] cxl: Add inject-error command
To: Dave Jiang <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>
References: <20251021183124.2311-1-Benjamin.Cheatham@amd.com>
 <20251021183124.2311-5-Benjamin.Cheatham@amd.com>
 <5d3337cd-94c4-4d5e-beb6-219058af11a5@intel.com>
Content-Language: en-US
In-Reply-To: <5d3337cd-94c4-4d5e-beb6-219058af11a5@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002325:EE_|SA5PPF7F0CA3746:EE_
X-MS-Office365-Filtering-Correlation-Id: 09b10b84-c02e-4db9-5999-08de1270eccc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YVpHL200WmhMRnp0WUt2VVNhWUpjQXh0dVMrZEt2aUdKMy84dUc2TXVvdXVH?=
 =?utf-8?B?VkZqcGw5aUNwZzNXbUhkZnhma0JSVzEya3IvTzlXTXd1SEFjTkVUdHFmZ3Iy?=
 =?utf-8?B?ZXVNK3BldXdCY2dJdFV4NTF4TzN2amxBTkZaN2F1MmpZV1dDaXZFUXUxbWRo?=
 =?utf-8?B?UkRDZ2ovVDRyOC9ac0phNURQUDR4MFpvYlM4NzhaWTBmSUJHbUtkU1p6OFlk?=
 =?utf-8?B?YU9QYVNXUEdYaVRveTljQ3hLMFNCWldnRTdJd2JRekcyOEhmbEFwRjdnQmo4?=
 =?utf-8?B?UXA2NmJSZGlUM2h6VjN3YzdLcC9VN1FEdVlOdWlvVlowTmN0NkJzUHZkUUlN?=
 =?utf-8?B?cUMvS0lsZnNMTTVRVkZ2Zzc1dVBpVytvWGZycGVBT3c0MmNiNmNHYkNDOGFa?=
 =?utf-8?B?SGZXTlFCZVROUlVkdUhlUGdyenoyN1NHT3JScDQwbFRuNzRVMlVYTDVMdWQ2?=
 =?utf-8?B?WFNMSk1QUFovYkdBR0Fiak5VeTZiVm5YdWt4VGpUVlZ5YXRHZ0ZRaW1pUjMz?=
 =?utf-8?B?RFNERDMxQ2FjS0xnZkxvNkJpNG44b0Q5OHI2NWw3NlpyaDAwUHg0Nyt1TEIv?=
 =?utf-8?B?RXM4QU9YKzlYZFRnNmszVGxJMWxwdWNkQzZRUDByb3duZVIwVDkzS0t1WitM?=
 =?utf-8?B?UzRVYmk0S3FMckZmNEtFMEk0NVJuUFVVclF6OXAwa3pnY3QyQzhXZ3VvRzln?=
 =?utf-8?B?NHRvUGd5Y1h2QmhXQlBWREZEakFGK2lFUkZWYVBpQy9KdnZRWEErR3QxNHdq?=
 =?utf-8?B?Y1oyaFA3dlB1Q1FjWnk1b1hnNTIycGlEdklQclo5Q0JNYWNQd3hNNUNIYlpS?=
 =?utf-8?B?NFo3ZThadmNPR0xRenBKNzVadDkrUndYZ2plWUxyaGVIRysxRjd0ZlVlWGpB?=
 =?utf-8?B?Vk9VUzdTcTBCMWpNMzRMaGMreFZtWi9kbWV3bHhYcjVWejRpZXRzN0loeDhL?=
 =?utf-8?B?VlFMTGxRRHgvR0FCK2V0VG5oMnkzc2tlVjJzZlZBMlZNUy9ZTjBtbEpvcFlN?=
 =?utf-8?B?SjE1UXpDeVQ0V3ZJQmN2VytSYXNRd1laWERCcllBSnNBZGJ5YlB0VXVaTHph?=
 =?utf-8?B?a0lBMlNiYk9IRytya1gyM0FmWURmM1FTak0zYmpvR3l3MGxPRjNrc0F3SzV5?=
 =?utf-8?B?aWZVdXFDZXhTbkswZmt6QWtDQXJXN2NnWHZDaXRjNjI3dTFnUDh2aWd0VTdx?=
 =?utf-8?B?U0Q4UEhieldRR0hUV2p5anJiOHM2YUUrY0hpTXdHNlJXSUVveG5TRjlBR0J4?=
 =?utf-8?B?MktLOEcyWnZ6QmlkZmxXYzMxdWs3REdVNitNbFdvd3FnU2g3T1h5VHd3M0Q3?=
 =?utf-8?B?dHdtUHVVVnhlUVhvNjFZTlhUOEdMeEE2VC8vRjNyUHhMV2N6c1NrTGZhM2RL?=
 =?utf-8?B?STdFOXBHRGRxSmNkS2tJcXdxTHQwSlB1bUZyb3FobUY1Mm1WRUZvOXZRMTdI?=
 =?utf-8?B?LzVvWms4UG1lZDErS1RsTW9jRy96OGFqT0hQMmxLQ1VFNWRJRVk5cjREZnh1?=
 =?utf-8?B?Y0g2alp0MXEvYkRUUVdiOHdScnUwdVluUzBCMXBSeUVqbEU3L21aSzdROGpZ?=
 =?utf-8?B?Z3dsMnVGUERIcmNQdkoxTEdrT3Iza3dxR294WFhXNndZVmdsNVdxdkwycVM2?=
 =?utf-8?B?VndEallib0RrV1FIRjVLbVdzZEhWTm94eGVVM0Y3dHFsc1k3U1pLNDM4aUxY?=
 =?utf-8?B?KytXUHR1RDJwNkFXcmRlb1VEdlE4TDJYZi9CNGhOdW53dXhmZzFWK090WXcr?=
 =?utf-8?B?TmFaYURsNm9OTXN5OHA5YVlyYXFBdWIxTjVTb2FKMDdHUStvRFZiRzVnUjlq?=
 =?utf-8?B?SjBzc3phOHFBT0lsemQyamtIaUtSQW9JQS9LNmx3U1lKa1lXTkd3RDBoZGxK?=
 =?utf-8?B?bUlwUVVheDVSVEJkeEZ2eXNENkZyWkVHTFV5c1ZwZExyV0tabkpCUG0vdVc2?=
 =?utf-8?B?Q3V4ckNhUU1KNWg4cFZGQ1BTR1ZkanJTZGtQZjVhWExkTEpaUTBIMnNCSzRQ?=
 =?utf-8?B?VG5LWGNPM2g0ak0yM2F5RlFBMlgzaHdueVNESVV5MkJTYUdqMXBGOTM0VkhV?=
 =?utf-8?B?eHVKVE1MelRKRVBVYVpiZkRkYkF2ek5rV3YrWTVkNHhmdEM4dWNUVVBOWkMv?=
 =?utf-8?Q?sMfY=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 20:15:35.0309
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09b10b84-c02e-4db9-5999-08de1270eccc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002325.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF7F0CA3746

On 10/22/2025 12:06 PM, Dave Jiang wrote:
> 
> 
> On 10/21/25 11:31 AM, Ben Cheatham wrote:
>> Add the 'cxl-inject-error' command. This command will provide CXL
>> protocol error injection for CXL VH root ports and CXL RCH downstream
>> ports, as well as poison injection for CXL memory devices.
>>
>> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
>> ---
>>  cxl/builtin.h      |   1 +
>>  cxl/cxl.c          |   1 +
>>  cxl/inject-error.c | 195 +++++++++++++++++++++++++++++++++++++++++++++
>>  cxl/meson.build    |   1 +
>>  4 files changed, 198 insertions(+)
>>  create mode 100644 cxl/inject-error.c
>>
>> diff --git a/cxl/builtin.h b/cxl/builtin.h
>> index c483f30..e82fcb5 100644
>> --- a/cxl/builtin.h
>> +++ b/cxl/builtin.h
>> @@ -25,6 +25,7 @@ int cmd_create_region(int argc, const char **argv, struct cxl_ctx *ctx);
>>  int cmd_enable_region(int argc, const char **argv, struct cxl_ctx *ctx);
>>  int cmd_disable_region(int argc, const char **argv, struct cxl_ctx *ctx);
>>  int cmd_destroy_region(int argc, const char **argv, struct cxl_ctx *ctx);
>> +int cmd_inject_error(int argc, const char **argv, struct cxl_ctx *ctx);
>>  #ifdef ENABLE_LIBTRACEFS
>>  int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx);
>>  #else
>> diff --git a/cxl/cxl.c b/cxl/cxl.c
>> index 1643667..a98bd6b 100644
>> --- a/cxl/cxl.c
>> +++ b/cxl/cxl.c
>> @@ -80,6 +80,7 @@ static struct cmd_struct commands[] = {
>>  	{ "disable-region", .c_fn = cmd_disable_region },
>>  	{ "destroy-region", .c_fn = cmd_destroy_region },
>>  	{ "monitor", .c_fn = cmd_monitor },
>> +	{ "inject-error", .c_fn = cmd_inject_error },
>>  };
>>  
>>  int main(int argc, const char **argv)
>> diff --git a/cxl/inject-error.c b/cxl/inject-error.c
>> new file mode 100644
>> index 0000000..c48ea69
>> --- /dev/null
>> +++ b/cxl/inject-error.c
>> @@ -0,0 +1,195 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright (C) 2025 AMD. All rights reserved. */
>> +#include <util/parse-options.h>
>> +#include <cxl/libcxl.h>
>> +#include <cxl/filter.h>
>> +#include <util/log.h>
>> +#include <stdlib.h>
>> +#include <unistd.h>
>> +#include <stdio.h>
>> +#include <errno.h>
>> +#include <limits.h>
>> +
>> +#define EINJ_TYPES_BUF_SIZE 512
>> +
>> +static bool debug;
>> +
>> +static struct inject_params {
>> +	const char *type;
>> +	const char *address;
>> +} inj_param;
>> +
>> +static const struct option inject_options[] = {
>> +	OPT_STRING('t', "type", &inj_param.type, "Error type",
>> +		   "Error type to inject into <device>"),
>> +	OPT_STRING('a', "address", &inj_param.address, "Address for poison injection",
>> +		   "Device physical address for poison injection in hex or decimal"),
>> +#ifdef ENABLE_DEBUG
>> +	OPT_BOOLEAN(0, "debug", &debug, "turn on debug output"),
>> +#endif
>> +	OPT_END(),
>> +};
>> +
>> +static struct log_ctx iel;
>> +
>> +static struct cxl_protocol_error *find_cxl_proto_err(struct cxl_ctx *ctx,
>> +						     const char *type)
>> +{
>> +	struct cxl_protocol_error *perror;
>> +
>> +	cxl_protocol_error_foreach(ctx, perror) {
>> +		if (strcmp(type, cxl_protocol_error_get_str(perror)) == 0)
>> +			return perror;
>> +	}
>> +
>> +	log_err(&iel, "Invalid CXL protocol error type: %s\n", type);
>> +	return NULL;
>> +}
>> +
>> +static struct cxl_dport *find_cxl_dport(struct cxl_ctx *ctx, const char *devname)
>> +{
>> +	struct cxl_port *port, *top;
>> +	struct cxl_dport *dport;
>> +	struct cxl_bus *bus;
>> +
>> +	cxl_bus_foreach(ctx, bus) {
>> +		top = cxl_bus_get_port(bus);
>> +
>> +		cxl_port_foreach_all(top, port)
>> +			cxl_dport_foreach(port, dport)
>> +				if (!strcmp(devname,
>> +					    cxl_dport_get_devname(dport)))
>> +					return dport;
> 
> Would it be worthwhile to create a util_cxl_dport_filter()?
> 

Yeah probably. I'll make one for the next revision.

>> +	}
>> +
>> +	log_err(&iel, "Downstream port \"%s\" not found\n", devname);
>> +	return NULL;
>> +}
>> +
>> +static struct cxl_memdev *find_cxl_memdev(struct cxl_ctx *ctx,
>> +					  const char *filter)
>> +{
>> +	struct cxl_memdev *memdev;
>> +
>> +	cxl_memdev_foreach(ctx, memdev) {
>> +		if (util_cxl_memdev_filter(memdev, filter, NULL))
>> +			return memdev;
>> +	}
>> +
>> +	log_err(&iel, "Memdev \"%s\" not found\n", filter);
>> +	return NULL;
>> +}
>> +
>> +static int inject_proto_err(struct cxl_ctx *ctx, const char *devname,
>> +			    struct cxl_protocol_error *perror)
>> +{
>> +	struct cxl_dport *dport;
>> +	int rc;
>> +
>> +	if (!devname) {
>> +		log_err(&iel, "No downstream port specified for injection\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	dport = find_cxl_dport(ctx, devname);
>> +	if (!dport)
>> +		return -ENODEV;
>> +
>> +	rc = cxl_dport_protocol_error_inject(dport,
>> +					     cxl_protocol_error_get_num(perror));
>> +	if (rc)
>> +		return rc;
>> +
>> +	printf("injected %s protocol error.\n",
>> +	       cxl_protocol_error_get_str(perror));
> 
> log_info() maybe?

I think I had it as log_info() before, but I don't think it was making it's way to
the console. I think I wanted the console output because I personally don't like running
silent commands. Not a great reason, so I'm fine with changing it if that's the preferred
way.

> 
>> +	return 0;
>> +}
>> +
>> +static int poison_action(struct cxl_ctx *ctx, const char *filter,
>> +			 const char *addr)
>> +{
>> +	struct cxl_memdev *memdev;
>> +	size_t a;
> 
> Maybe rename 'addr' to 'addr_str' and rename 'a' to 'addr'
> 

Sure.

>> +	int rc;
>> +
>> +	memdev = find_cxl_memdev(ctx, filter);
>> +	if (!memdev)
>> +		return -ENODEV;
>> +
>> +	if (!cxl_memdev_has_poison_injection(memdev)) {
>> +		log_err(&iel, "%s does not support error injection\n",
>> +			cxl_memdev_get_devname(memdev));
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (!addr) {
>> +		log_err(&iel, "no address provided\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	a = strtoull(addr, NULL, 0);
>> +	if (a == ULLONG_MAX && errno == ERANGE) {
>> +		log_err(&iel, "invalid address %s", addr);
>> +		return -EINVAL;
>> +	}
>> +
>> +	rc = cxl_memdev_inject_poison(memdev, a);
>> +
> 
> unnecessary blank line> +	if (rc)

Will remove!

>> +		log_err(&iel, "failed to inject poison at %s:%s: %s\n",
>> +			cxl_memdev_get_devname(memdev), addr, strerror(-rc));
>> +	else
>> +		printf("poison injected at %s:%s\n",
>> +		       cxl_memdev_get_devname(memdev), addr);
> 
> log_info() maybe?

Same thing as above.

Thanks,
Ben

> 
> DJ
>
