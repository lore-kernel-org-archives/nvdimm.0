Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012019.outbound.protection.outlook.com [40.93.195.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9DD422550
	for <nvdimm@lists.linux.dev>; Tue,  7 Jul 2026 21:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783461095; cv=fail; b=t47spWXdRKrMkMuLWIoxa6x7s2TMXMidKBJM1OoqRn7DzinUVZj86LQvJ9+EWUPiRIwzQyvdRoTANptfdSY6ECKgaBK3SRjfm1cP3ivKFEPbcBkvemDsJqGMBLwnDT5aB6we3cp0woFkR9vssgxApTMi3vW1KkadEStbihN2WgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783461095; c=relaxed/simple;
	bh=rUPSmvveoaNlgA6BBUo3hW1nXOk2sQj+pkuSpLZBlFw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=HBVs1quS2UXrDaUz1S3ub2gM00FOuGipEb7UsrC1Q2Zkwk/L1ft9pPENzuUsMtjF2fNjxijwUJO5J6IRYTMxiDJB5UZKuBUbDUZpSVf7cQotSV5SIx5NsGol1byUuvu+FCSrrN8ImebxQOH9JB1AfpD98crt6xYMtzpSX9nLVk4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HupiZ57c; arc=fail smtp.client-ip=40.93.195.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HupiZ57c"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uc+XM6swTWEANv+vbjptggeveCTPk+OzAZn8WsK0SKC4uy5jyJNvXLWTXk7sMOSpm+36EOUWbGDI4utOO9M6RMFBd9XsIK7C7FVrh6WtfbVibd5Dl82ZEStTPWS3cJNIiNehsUwG+mIw+ckNdELHYAAcxj3mQ/bxD1YSHiBriW7Mu91DpPQtoXKgdk4/Vwx6vzNf3bCayexMhjkrjxrs7A4/aKPw66ro87Cxltc80j14bG+V7V5FMX/pBIh/1pXsf1Fn6Imxx1xy9b8uhehVGGZWEax2oK5hUdu5/teGZvHIp21W0jGUT0lMLrH280Q4ymnYnICZWOxOUYTcXxyHGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BMILDJSfBqtLtHoP1ar6PCaLvCIoRVbYTP6lIN+9VMs=;
 b=vHL2l6p4MjY1VbP/DSx/1+w5YlAfytZb1zG+Em+tHPtxkULHPFJSlRt3fW9s4ft11ULKLk3apo+hMujHZSybWaMrSrMn7Uh4Hsk3J1wkSui4c7PE7LPVQmBC8CWhgr8xZPWPPzhDElGcUo9kNm/H7qReRBA3ng1nwiQGY95CgqEemDQe43r2aIPFEO26UbUHMCFvsTziFuRAuIxaIhYz/HXTDJ88PfBPUyk+vDrehE9/rEmh5NJXTKDiKzxNNXBXBa4zPje3RfTN8yrYjmPyi4dHHwmuFrTIVCg9qGvdacLdoy6d73lG9DrQHvzu7/Rko0e73sOBsQNGIfVBRb1riw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BMILDJSfBqtLtHoP1ar6PCaLvCIoRVbYTP6lIN+9VMs=;
 b=HupiZ57cIA3qMcd6SmKst2wFN8Fnf5via9x547badmpEcEx+bGXUrqmPKgrj1UAp9cPAijqTf5WS0XXr7h6AvGNh5HkvMijGUcZdr2wlJVmt7KAmZvwGVqsBrc/5Kc2VV8ikI2D/yYjOidpwbevfBafQ/CB4qAqfVciqFfvtEqA=
Received: from MN2PR08CA0021.namprd08.prod.outlook.com (2603:10b6:208:239::26)
 by EAYPR12MB999133.namprd12.prod.outlook.com (2603:10b6:303:2c1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 7 Jul 2026
 21:51:26 +0000
Received: from MN1PEPF0000F0E5.namprd04.prod.outlook.com
 (2603:10b6:208:239:cafe::46) by MN2PR08CA0021.outlook.office365.com
 (2603:10b6:208:239::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.13 via Frontend Transport; Tue, 7
 Jul 2026 21:51:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0E5.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Tue, 7 Jul 2026 21:51:26 +0000
Received: from [10.236.178.12] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 7 Jul
 2026 16:51:24 -0500
Message-ID: <6d4b2c0e-5c05-4e92-9c9d-dba8cabe849b@amd.com>
Date: Tue, 7 Jul 2026 16:51:23 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 10/31] cxl/mem: Configure dynamic capacity interrupts
To: Anisa Su <anisa.su887@gmail.com>, <linux-cxl@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, Dan Williams <djbw@kernel.org>, Jonathan Cameron
	<jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, Dave Jiang
	<dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny
	<iweiny@kernel.org>, Alison Schofield <alison.schofield@intel.com>, John
 Groves <John@Groves.net>, Gregory Price <gourry@gourry.net>, Anisa Su
	<anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-11-anisa.su@samsung.com>
Content-Language: en-US
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
In-Reply-To: <20260625112638.550691-11-anisa.su@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E5:EE_|EAYPR12MB999133:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c2cda6d-3613-4f0c-22bc-08dedc71e4d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|30052699003|1800799024|376014|7416014|4143699003|11063799006|6133799003|56012099006|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	uWFEneWYwLR+Mv+xuahCkcrwwcRPEPuAZbedx6aeylXs1e+rtiss+w9w2NilDjli0VvnGbvbP/Ppfx+zso3mUn0JY4KVwHijZj7BScJ1/2tYw0pLGoy3r/75T8v0Nq3PQe+GZwdsvYrNN7/BVq6lhGdrmOb4R0q5Dk4fUvJMar69d1vhrX91WAHwwowg2ikNDk9V3sU5IMJUC76E/krI+GOCfDdQPeU+H51QAgUbRarVNFGom5+VDXnvIelBlf7RQDNbnqb9VoosLnsh9XlWVQ+QGa6UwyNksw7eAnji0ftsGYa2On+iqYl3Rm9dZEQhG8QYH5v/fezA6VkLSYVMHwkPg4ZVIE83agVNYPyPwssj365Mp3SDUvXgno77fVc8EuvP2b235yUoBRz6t+bfasdKBOLPVU9Co/YsnPxX1qPtIaR+c0uW+XeATsdHWOaqiduIxKz1KgfQPCZ3V9tsZpfIMTH+w4v/EKdvHeTws2jBRM19IWWBL1rUuc1VJF8rsKisoJZ4f3X4cdkFmgSk1GJ/K1DkmkEK70a/5AHPPRN6zMbV/4shC/Hc87jyYxjkODiUoR0uVRtySPNMsyzYZVPY958/qDyFFOluxmt7BqohaP9MFyKxOzN+4tUu9lcYiLfgttRqlgv+eUdI7cr3oQBX0dw5YUMXMJphfMSz+TYfKc7OmopxIlek6BbRaQex0R9hCm7FXY5wHLW1gwTlpw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(30052699003)(1800799024)(376014)(7416014)(4143699003)(11063799006)(6133799003)(56012099006)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ubODyXKpF2BS/oEDI7T/P6LyhIy9cRG1c8eJ5yL+/rq/2fWmlQABBp2dN45HtB7KtYLzTVKd0OtXKV+N3zx8lS1zp7ApoSV1IZwkt+T9UR7lx36D6zp7DxDRkVCIG26yVoIFOkQhVI5jIsLZWg5H1te5/bj/paUjFhRCoEBUMM/9/Ci0Wp62oK2IyBKz9We9mvkqqkywpljsSo2g2f+spVxYg4no+0zo9/PG5jKG4CGdAQ2OPrcvfySDCEVnpNQUxvE+iNcLywvCtLdWIXS2dOVACUDbTlS3Dt6UO4miGEAvguw7Ns4oQt5v/4LpDPYHKILZZBYvRPT26s0/sxnVC8e7wrJYSbD0wKidoU3fILpM245Du5/JMBlvoFdtGESixa2kxl9C30BNYpOO+1QJe3tIWEF5cKy2Ky5sIN8x4HyuPoyTkxlyM1Qi352TBMG/
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 21:51:26.1008
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c2cda6d-3613-4f0c-22bc-08dedc71e4d0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EAYPR12MB999133

On 6/25/2026 6:04 AM, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> Dynamic Capacity Devices (DCD) support extent change notifications
> through the event log mechanism.  The interrupt mailbox commands were
> extended in CXL 3.1 to support these notifications.  Firmware can't
> configure DCD events to be FW controlled but can retain control of
> memory events.
> 
> Configure DCD event log interrupts on devices supporting dynamic
> capacity.  Disable DCD if interrupts are not supported.
> 
> Care is taken to preserve the interrupt policy set by the FW if FW first
> has been selected by the BIOS.
> 
> Accept the 4-byte CXL 2.0 reply on GET Event Interrupt Policy by setting
> min_out to CXL_EVENT_INT_POLICY_BASE_SIZE; pre-CXL 3.1 firmware omits
> dcd_settings and would otherwise fail the size check.
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> 
> ---
> Changes:
> [anisa: add CXLDEV_EVENT_STATUS_DCD (bit 4) to CXLDEV_EVENT_STATUS_ALL;
> previously added in a later commit but moved to current commit]
> 
> [anisa: check native_cxl before cxl_mem_get_event_records]
> ---
>  drivers/cxl/cxl.h    |  4 +-
>  drivers/cxl/cxlmem.h |  2 +
>  drivers/cxl/pci.c    | 94 ++++++++++++++++++++++++++++++++++++--------
>  3 files changed, 83 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 1297594beaec..864f6d3c03d4 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -180,11 +180,13 @@ static inline int ways_to_eiw(unsigned int ways, u8 *eiw)
>  #define CXLDEV_EVENT_STATUS_WARN		BIT(1)
>  #define CXLDEV_EVENT_STATUS_FAIL		BIT(2)
>  #define CXLDEV_EVENT_STATUS_FATAL		BIT(3)
> +#define CXLDEV_EVENT_STATUS_DCD			BIT(4)
>  
>  #define CXLDEV_EVENT_STATUS_ALL (CXLDEV_EVENT_STATUS_INFO |	\
>  				 CXLDEV_EVENT_STATUS_WARN |	\
>  				 CXLDEV_EVENT_STATUS_FAIL |	\
> -				 CXLDEV_EVENT_STATUS_FATAL)
> +				 CXLDEV_EVENT_STATUS_FATAL |	\
> +				 CXLDEV_EVENT_STATUS_DCD)
>  
>  /* CXL rev 3.0 section 8.2.9.2.4; Table 8-52 */
>  #define CXLDEV_EVENT_INT_MODE_MASK	GENMASK(1, 0)
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index afc195d8c090..bcf976829c3e 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -218,7 +218,9 @@ struct cxl_event_interrupt_policy {
>  	u8 warn_settings;
>  	u8 failure_settings;
>  	u8 fatal_settings;
> +	u8 dcd_settings;
>  } __packed;
> +#define CXL_EVENT_INT_POLICY_BASE_SIZE 4 /* info, warn, failure, fatal */
>  
>  /**
>   * struct cxl_event_state - Event log driver state
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index 8d12c684d670..95a4bf7c1e46 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -514,7 +514,19 @@ static irqreturn_t cxl_event_thread(int irq, void *id)
>  	struct cxl_dev_id *dev_id = id;
>  	struct cxl_dev_state *cxlds = dev_id->cxlds;
>  	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlds);
> +	struct pci_host_bridge *host_bridge =
> +		pci_find_host_bridge(to_pci_dev(cxlds->dev)->bus);
>  	u32 status;
> +	u32 mask;
> +
> +	/*
> +	 * Only drain logs the driver owns.  When BIOS owns event reporting
> +	 * (!native_cxl) the driver is only here for the Dynamic Capacity log;
> +	 * processing the standard logs would steal firmware-first events from
> +	 * BIOS, so mask them out.
> +	 */
> +	mask = host_bridge->native_cxl_error ? CXLDEV_EVENT_STATUS_ALL
> +					     : CXLDEV_EVENT_STATUS_DCD;
>  
>  	do {
>  		/*
> @@ -522,8 +534,8 @@ static irqreturn_t cxl_event_thread(int irq, void *id)
>  		 * ignore the reserved upper 32 bits
>  		 */
>  		status = readl(cxlds->regs.status + CXLDEV_DEV_EVENT_STATUS_OFFSET);
> -		/* Ignore logs unknown to the driver */
> -		status &= CXLDEV_EVENT_STATUS_ALL;
> +		/* Ignore logs unknown to the driver or owned by BIOS */
> +		status &= mask;
>  		if (!status)
>  			break;
>  		cxl_mem_get_event_records(mds, status);
> @@ -557,6 +569,8 @@ static int cxl_event_get_int_policy(struct cxl_memdev_state *mds,
>  		.opcode = CXL_MBOX_OP_GET_EVT_INT_POLICY,
>  		.payload_out = policy,
>  		.size_out = sizeof(*policy),
> +		/* CXL 2.0 firmware omits dcd_settings; accept the shorter reply */
> +		.min_out = CXL_EVENT_INT_POLICY_BASE_SIZE,
>  	};
>  	int rc;
>  
> @@ -569,23 +583,34 @@ static int cxl_event_get_int_policy(struct cxl_memdev_state *mds,
>  }
>  
>  static int cxl_event_config_msgnums(struct cxl_memdev_state *mds,
> -				    struct cxl_event_interrupt_policy *policy)
> +				    struct cxl_event_interrupt_policy *policy,
> +				    bool native_cxl)
>  {
>  	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
> +	size_t size_in = CXL_EVENT_INT_POLICY_BASE_SIZE;
>  	struct cxl_mbox_cmd mbox_cmd;
>  	int rc;
>  
> -	*policy = (struct cxl_event_interrupt_policy) {
> -		.info_settings = CXL_INT_MSI_MSIX,
> -		.warn_settings = CXL_INT_MSI_MSIX,
> -		.failure_settings = CXL_INT_MSI_MSIX,
> -		.fatal_settings = CXL_INT_MSI_MSIX,
> -	};
> +	/* memory event policy is left if FW has control */
> +	if (native_cxl) {
> +		*policy = (struct cxl_event_interrupt_policy) {
> +			.info_settings = CXL_INT_MSI_MSIX,
> +			.warn_settings = CXL_INT_MSI_MSIX,
> +			.failure_settings = CXL_INT_MSI_MSIX,
> +			.fatal_settings = CXL_INT_MSI_MSIX,
> +			.dcd_settings = 0,
> +		};
> +	}
> +
> +	if (cxl_dcd_supported(mds)) {
> +		policy->dcd_settings = CXL_INT_MSI_MSIX;
> +		size_in += sizeof(policy->dcd_settings);
> +	}

It seems there's a bug here that I found on one of our test machines. It's possible the card doesn't support
DCD commands but does have the policy bit for DCD (i.e. CXL card is 3.0+), so the payload still needs to be
large enough to include the DCD bit in that case. So, the size_in needs to always include dcd_settings but
the actual policy setting should stay based on whether the card supports DCD. Hopefully that makes sense, let
me know if it's not clear...


The first thing that I thought of for a solution is setting size_in based on the CXL card's DVSEC revision
(i.e. size_in = 5 for CXL 3.0+, size_in = 4 otherwise). Not exactly a clean solution, but I'm not sure there's
a way around it.

Thanks,
Ben
>  
>  	mbox_cmd = (struct cxl_mbox_cmd) {
>  		.opcode = CXL_MBOX_OP_SET_EVT_INT_POLICY,
>  		.payload_in = policy,
> -		.size_in = sizeof(*policy),
> +		.size_in = size_in,
>  	};
>  
>  	rc = cxl_internal_send_cmd(cxl_mbox, &mbox_cmd);
> @@ -632,6 +657,30 @@ static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
>  	return 0;
>  }
>  
> +static int cxl_irqsetup(struct cxl_memdev_state *mds,
> +			struct cxl_event_interrupt_policy *policy,
> +			bool native_cxl)
> +{
> +	struct cxl_dev_state *cxlds = &mds->cxlds;
> +	int rc;
> +
> +	if (native_cxl) {
> +		rc = cxl_event_irqsetup(mds, policy);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	if (cxl_dcd_supported(mds)) {
> +		rc = cxl_event_req_irq(cxlds, policy->dcd_settings);
> +		if (rc) {
> +			dev_err(cxlds->dev, "Failed to get interrupt for DCD event log\n");
> +			cxl_disable_dcd(mds);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  static bool cxl_event_int_is_fw(u8 setting)
>  {
>  	u8 mode = FIELD_GET(CXLDEV_EVENT_INT_MODE_MASK, setting);
> @@ -657,18 +706,26 @@ static bool cxl_event_validate_mem_policy(struct cxl_memdev_state *mds,
>  static int cxl_event_config(struct pci_host_bridge *host_bridge,
>  			    struct cxl_memdev_state *mds, bool irq_avail)
>  {
> -	struct cxl_event_interrupt_policy policy;
> +	struct cxl_event_interrupt_policy policy = { 0 };
> +	bool native_cxl = host_bridge->native_cxl_error;
>  	int rc;
>  
>  	/*
>  	 * When BIOS maintains CXL error reporting control, it will process
>  	 * event records.  Only one agent can do so.
> +	 *
> +	 * If BIOS has control of events and DCD is not supported skip event
> +	 * configuration.
>  	 */
> -	if (!host_bridge->native_cxl_error)
> +	if (!native_cxl && !cxl_dcd_supported(mds))
>  		return 0;
>  
>  	if (!irq_avail) {
>  		dev_info(mds->cxlds.dev, "No interrupt support, disable event processing.\n");
> +		if (cxl_dcd_supported(mds)) {
> +			dev_info(mds->cxlds.dev, "DCD requires interrupts, disable DCD\n");
> +			cxl_disable_dcd(mds);
> +		}
>  		return 0;
>  	}
>  
> @@ -676,10 +733,10 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
>  	if (rc)
>  		return rc;
>  
> -	if (!cxl_event_validate_mem_policy(mds, &policy))
> +	if (native_cxl && !cxl_event_validate_mem_policy(mds, &policy))
>  		return -EBUSY;
>  
> -	rc = cxl_event_config_msgnums(mds, &policy);
> +	rc = cxl_event_config_msgnums(mds, &policy, native_cxl);
>  	if (rc)
>  		return rc;
>  
> @@ -687,11 +744,16 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
>  	if (rc)
>  		return rc;
>  
> -	rc = cxl_event_irqsetup(mds, &policy);
> +	rc = cxl_irqsetup(mds, &policy, native_cxl);
>  	if (rc)
>  		return rc;
>  
> -	cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);
> +	if (native_cxl)
> +		cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);
> +
> +	dev_dbg(mds->cxlds.dev, "Event config : %s DCD %s\n",
> +		native_cxl ? "OS" : "BIOS",
> +		cxl_dcd_supported(mds) ? "supported" : "not supported");
>  
>  	return 0;
>  }

