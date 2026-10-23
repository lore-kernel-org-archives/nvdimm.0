Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.61
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792762630;
	b=3x5fi5MHYox+Pcpn+gdJW2T12A6NzM0tMdviFkQa3m4wUqVkly68CZ5seyFLHETpFCM4
	 qrDgeVi2eBGAqBsIXc/OQCraqr2l7iPGftjwRn/5gJCbTSgLbU8K/2xdpiDdpz5YrfZ/P
	 GD6FcQrEnoPluwy3mLu43kiWN8VGUtSyCoyJ6PzRqbYlHNDlkPGomsR8QXlOsoGJLqTFz
	 2zfxXyv1SAuoYMXiVynW47iB22e0iILrA5fJ4XDxbaaKtsJyvn9f0BN5R4b0tK0Hx6KnK
	 A3d1CfxdQ1X7vMbyTS9gUIMLG/pHIvLAnla7xHm3HcUyWATMlR3sKMyPizYn5Yr1nmw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792762630;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:CC:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=eYY72LqcWyDES/89Str2pGYwi8OVgpy+OM4+oC5cNHw=;
	b=3+Bqcz0REyQvTAlW60NMiPdAJTSzEc50IZoWYtz2RBUcwX7USafAUfHNdWNxGdCeHqNm
	 OsvVA84YOIqS+m7lkll3Wikof5yQIVdLdafh7HSaXYMgznJnWoJcXFSF3l8tPJRiVhEH1
	 aM05e1jw8y7UlRhkR1YmdCINmP7T6VP5ZsnYm7Pn8qTjxX0o/GJNPaH56/MNZ5ruaz8tA
	 6Z40f20nO7kJvcWZqIUQ5vNaKherfH/V8mmvcquLOfLzxhhImtLtlZRkuj2sQhRGCTja+
	 Gh4+QkdpKzR4bHw2Td/HcJ9eyPRdeSTpYwQEnF2Ozsamz9UpoFG1XwFdi+4/7sIkl5w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=DfiGJSD8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.61
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010061.outbound.protection.outlook.com [52.101.56.61])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A901606A325
	for <nvdimm@lists.linux.dev>; Fri, 23 Oct 2026 13:37:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A901606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=DfiGJSD8
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XZuvWHuIkQ03PKWzInHEcxIntQ/tQIyUVa5MaA0EVj+XKYO8OWFJXm56u8YFSlJpKOeMR5YQ+EE0ql2UCK+q2BHSLwAuXy6KlF4ncPFuPk2sfFBzYIIhuE5lyf48+Eo7p8Czl80Pp1Yf2tcwPGW+mz6yfLtklYd5CL0DIyH1Wq8R6SNd2+LQAPctivcOnLAB7L+FinUkANqSLtV/7NMckTD+iKZoP3dQflpgSCtsReY0ydyqgDd/vmYks4IdDdW0pvmg5+7t9zrFV3jBbBZhjWVuG7/AQkRNo/SLfe5vlIZdG7nnyLrGtyv1xuKgR6wecukZvK6JXnnTd/UMXoM/9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eYY72LqcWyDES/89Str2pGYwi8OVgpy+OM4+oC5cNHw=;
 b=gEgMBsDeGZ6y7APP2PpmuMBlzpySYbx2mr68jJpAfWDheU2KElU+moaRzzjt+4Edzp0taokRSIhCjpgcJ0BsyYgXHxA0X0rb5iRZeypsmkd0hNcU7XokfcEcpBZlt1TQXWALoLeIJ4IbkInTzg/Cx5DNEnKSlJwZv5urgwld81Qieoe7Km/FpmjScn1hxoU68+iy9rVgWBdbp0H07a9CjigvOlxtNMPRsfii4xBxD8KUhlqUSqgtyLMyEDUSGYYnXPhF7qj0QKEQepg8oHBvuagf+o5SWU5bbVRe5INQsquqTBa8T4bt6wftZUp8njZHF2jWTtEF3VFo33riqxVGOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eYY72LqcWyDES/89Str2pGYwi8OVgpy+OM4+oC5cNHw=;
 b=DfiGJSD8Bk7izyP9/dWf4ozn4BKOYXalCegsj/Zv+w0FNKY67fygZ1RUnfmoeGKsE/cirehq3sg/iKOW/L8D015aK6kRnKj8PGSg4y3Qg/JjA+vyulljDlV8J7mlXza9SNH+3FAGLWr1WrUwfUHTE8DMXshijHsp0hd1ZzoNeJ0=
Received: from CH5P222CA0010.NAMP222.PROD.OUTLOOK.COM (2603:10b6:610:1ee::28)
 by DS4PR12MB508551.namprd12.prod.outlook.com (2603:10b6:8:50e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.19; Fri, 23 Oct
 2026 13:37:05 +0000
Received: from CH3PEPF0002457B.namprd04.prod.outlook.com
 (2603:10b6:610:1ee:cafe::2f) by CH5P222CA0010.outlook.office365.com
 (2603:10b6:610:1ee::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.19 via Frontend Transport; Fri,
 23 Oct 2026 13:37:05 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH3PEPF0002457B.mail.protection.outlook.com (10.167.252.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Fri, 23 Oct 2026 13:37:05 +0000
Received: from [192.168.86.102] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Fri, 23 Oct
 2026 08:37:04 -0500
Message-ID: <b4678429-f12b-4cdc-b189-4a1c67e1a93c@amd.com>
Date: Fri, 23 Oct 2026 08:37:04 -0500
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] cxl/list: handle missing debugfs when reporting
 protocol injection
To: Alison Schofield <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>
References: <20261023011333.522080-1-alison.schofield@intel.com>
Content-Language: en-US
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
In-Reply-To: <20261023011333.522080-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0002457B:EE_|DS4PR12MB508551:EE_
X-MS-Office365-Filtering-Correlation-Id: a4ca0e56-a428-44c5-3f98-08df310aba4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700016|23010399003|56012099006|11063799006|261021121427099003|261022105027099003|261009223027099003|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	kVSq+EshsUd/kRjI+FicJapauMv6hEdaQ5Otm9dBtb9XNY2nOT1xnsOJ8oY+DvqITZEDMBZZc7qT3/FTxdL0H1c8BNag38yOep0Nh5RMb2N2f+b/2UtUsESl+uecz59G5yq+EIOhNXRZ0TJYSfSmABhlq+jMNklnVuZBaFB4wF3nhFeeqL0Ulq+m4nrWIO3z81w6RRfG3uyq1PLdTjOw+1+jT4BNinXLU8EPbWDCFtqT2LTJ9IFbAG++0eopNeG7DiptpOTOk7/vqCZ5MNEb4+oiah6fcYYN/iI1uh1yv1VlAvaXo2dtgCBkkUq40YLV5Hk5unB2c5UES0IvblPXPYRKSujKBrBBsvg2Lfp51XU3tmyCUb6tRqN02+i7zua8Zh7rcTbSzpxGkE7rfiqRLR+8q815HfnGOJNTCj6sDb0jBLPyLVt4+gAbpsW61p/tViuSuG43kIjkDy7eqIJ92NWRHayKj8gTZoBBeOGJ/Qb1IreMwvsA2/U87f42yp6E1YuXQAeeBPVd4DwH4DGK5V8rDdfoITe3ply8tG1vBT1ax4ZeF6e+qII5NUH91C05miKn7x8tMvtLzHCmVeuwhAeaHn+6U89lYJOinsGXKOMLCCf7HX5Fr31ejUXlu3PugWse4A1SAenV8OYfkclQV9lf48H5tPMM1+xwrhXpTXcXi2T8nYCV8mkmdO+ONRwx7wAKN4Dq5Q1vaQ9UQm1jRQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700016)(23010399003)(56012099006)(11063799006)(261021121427099003)(261022105027099003)(261009223027099003)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lC+3fKuQPFBSX5T/hr1X24DmzkAWlr9AyS/wJ2f9V+YRSRoZ4+DtMjgI2u7Wur1CkOYpHQfruZ+2vrcKCzsPyL88t0GJX1DxsxAYuRIP++CQG6nWeMOARBAyUD4X8SEklTr0sQEWJ4Ko+O5QNOtrW9e6MReiG3Kax5LdJrXu5YoioJRVejwYFKDCg4qnKD8Tfl7fC3tntX6ZG702UgABrGaNJhMi60buajq2lzVH4aODZACM6y77uy9Gi4mMmqnbEChX97Lmn7rov9AQ1IC1ZtPc+Dcw5HmT13Z7Nofwt+0PGIP5l2+LbzEKVzcIGmEzwNraKE6/AxRz+UxY/V21kqnXZ9vzprYAPIrR27BCerbXaPNy905R76/cXiIhQNV6fPXSeZPcCO0QLhGfIkhAdb/NKvXAdMrE3rTzQPUDTVEWh6CPXOMq9DSJLhRIGvZN
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 13:37:05.4439
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4ca0e56-a428-44c5-3f98-08df310aba4c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0002457B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB508551

On 10/22/2026 8:13 PM, Alison Schofield wrote:
> When debugfs is not mounted or CONFIG_DEBUG_FS is disabled, 'cxl list -v'
> crashes while generating the protocol_injectable attribute for downstream
> ports.
> 
> The crash occurs because cxl_dport_get_einj_path() passes a NULL debugfs
> path to strlen().
> 
> Return NULL from cxl_dport_get_einj_path() when debugfs is unavailable,
> and omit protocol_injectable from the JSON output, consistent with other
> debugfs-dependent attributes. Update the documentation to match.
> 
> Thanks to Christopher Kim who reported and provided the fixup.
> 
> Originally-by: Christopher Kim
> Fixes: 5d596866f8c5 ("cxl/list: add injectable errors in output")
> Closes: https://github.com/pmem/ndctl/issues/300
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

LGTM,

Reviewed-by: Ben Cheatham <benjamin.cheatham@amd.com>
