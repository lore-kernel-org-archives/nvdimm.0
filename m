Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.24
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794468853;
	b=pwzbAFnhNkJRW+J0oxdPLPUxtcRi3cSUDgSP2tsFzVef2TqXxC+P9ac6wQ3cN/tGyktO
	 HdsB1S49OW6Z+hJprnPGTgHXm0ZRX4pUThenl//yUqOITRCTI+7164bgDr+hKZi+S22LC
	 8iIqNdtSkRz7gmpPPQTaMIurA2g79EVxnotD0fdMKXceASvMRUzvoHM/5P2qto5/kYSGS
	 Mo6279TFpS8MMiaCVE0d4Edw2YzVOgwj1/29DxVenK4L+AhC8C5feuWhE+NktqNrFXNs0
	 LAU9LiBwY6kte3MbtzaPef5ETuxBw4n6brW7Dv1/vm31FEZIbZRgkzeVZkK1phD36eA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794468853;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=9VEku7pG0fNpoIyAAbpgzSLUl5pTdO9GdkpKtQStI5Q=;
	b=XrnukJFT2ODUn0aqHwcKDR0q8NO57Fbvw4hC/xyYlaypeyxr7A2gDhC9kRFP/V69RT9r
	 SmDPbN9MuZ+i9TQXzdSt6heWeaIFNDrlH1PSp6AKPwh84o8IyDv2+cP7gJrsc3uZVamRy
	 lOCyp0yu8tF4VrgdQNN99A99kdXT5/JBQsMKrl1oiYnO6LAd/UZTjQGGtBWGn9qC1rE7x
	 K5NFeg8jmUguU8ZXNhXrKNUTrEu4k5abE9XWc7/yNgwu1HEL7XT42eulbUqGFfoEE5opP
	 HA06yf5wYqdgKJDJ53g0jsKx1dcUguo/oWWUFNStbR5kMmMxDJSE6lUBgiRhhmKdCrA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="NJtxx/EO";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.24
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011024.outbound.protection.outlook.com [52.101.57.24])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755BF606A31C
	for <nvdimm@lists.linux.dev>; Thu, 12 Nov 2026 07:34:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 755BF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NJtxx/EO
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gOV1TPt33vD0BCmsejhLWc1MSppcuN0U7YoVuhNDsqJpJyd9IXYnV1gTwTOGV3yaVzNn8EdF/Dl1ZCbIiKddDhoymh44++CBmPrynjxNdGIysFU2mvAE3EHfsyDDyC9UF/hzHEsA2i6HFXI6o7/WiUHoNHmMJWFH6/aonCLomcnI16N8zcfIfjkASgep8VFumHFmKTHv0/k2CTUQX9XFvFwFOg7YjecQuk8nVapyrRfqghJ+4vQ4Tsmzg0t2y/HcqAXKb6V3qNF24PApuXDZt+Bxa4U3rL3o46CwFLhyfor+1Nia9UGDPznYAU4XgJtxFPHIsCBgEN2W6xJk4/zClg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9VEku7pG0fNpoIyAAbpgzSLUl5pTdO9GdkpKtQStI5Q=;
 b=MyxAKYPOrIg4Fj//g1tRCIFftD1EeCFzPemuVhhDzuafvVCzpbIwXg2pNwQ0kiGd8rgTreV838ajt1xQvE2kLLS8obu28/ddXt92byy4xI+QeNFoEnVcVz1nX1CNmoQU34+qLVOQCdNjE1SG3vM0jev45HVaR/w7GdAcgnBkPavjhH710sD7nfjf5mXz1eMtQmdIHXMqG5iolPD4loHIaqr0JWDa+JpZ4dNSFfR2lAeHnW1P+wJnXci/V51expLYTb1NQi+irLPgJpfuPEw95tg4bTyeSnIGbjVHk5CTD47B2PBnYKsGE6AP80pZyjtfT486HmUV4lEUkdqGdCFdVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9VEku7pG0fNpoIyAAbpgzSLUl5pTdO9GdkpKtQStI5Q=;
 b=NJtxx/EOe6Yusuyb0nNPk47Ld0Tm1nvxNsM32V66sU0dawKXNCVK+9jtum+2nisZUu29eki9pvL4Qso5+k5NmP719vVaENBHPwIqWKHUL0C61ZMb1EQfhjCkUfMRd62CYn4t853nSdQPSdXs3NKdggsJi8FsrAqxg7bjV95MAhqLTjuviQSYVaB1BxVKFurd4sL6iCTvaE3+qHQtx3nxwp+4t2aNQ5m7dkNcuIlc5LLjyyab3L4tEBE4E+UiBAP1Yfc0qTiwdDHEj555cOBQsmQzrHc88irScdfE0F527Fz5GcNs13goP6tPweinApYP0DWh9jweUCKEqLbzho2rHQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by IA4PR12MB429550.namprd12.prod.outlook.com (2603:10b6:207:128::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Thu, 12 Nov
 2026 07:34:09 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0615.007; Thu, 12 Nov 2026
 07:34:09 +0000
Date: Thu, 12 Nov 2026 15:34:03 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Anisa Su <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, Jonathan Cameron <jic23@kernel.org>, 
	Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Fan Ni <nifan.cxl@gmail.com>, Li Ming <ming.li@zohomail.com>, 
	Benjamin Cheatham <benjamin.cheatham@amd.com>, Gregory Price <gourry@gourry.net>, 
	Anisa Su <anisa.su@samsung.com>
Subject: Re: [PATCH v1 11/14] cxl/extent: Handle DC Release Capacity events
Message-ID: <avVq11dobEgbxaC_@MWDK4CY14F>
References: <20261104230445.66625-1-anisa.su@samsung.com>
 <20261104230445.66625-12-anisa.su@samsung.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104230445.66625-12-anisa.su@samsung.com>
X-ClientProxiedBy: TPYP295CA0050.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:8::12) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|IA4PR12MB429550:EE_
X-MS-Office365-Filtering-Correlation-Id: 797bc20b-2c6f-4f16-8c66-08df408f56ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|23010399003|376014|22082099003|18002099003|6133799003|261009223027099003|3023799007|5023799004|11063799006|56012099006|4143699003|261028144727099003|261021121427099003|261102123227099003|261026140227099003|261026121527099003|261021123027099003|261022113327099003|261022105027099003|261022075727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	eJt5HvPfMTMpY65XqznZ2zI34NBOYhFOkkD0uLM2d1aOxajFpDL0giV9XcYVkTykF5Ek2to5IDywoadjoQpJ1yFqSs0sFn65rHdktmyovt7t66Ptw9qbn/72FCKDR9yzBKayCDyaextM3o8gUn/G1i6DnIUJM2UOOAzT4MmNs6iKPkYbvZRhoQW4AAtZPupGk1x7SGIbyiZErLI8wOqbPD0n86NekvxbSVQ4jCS/DqsVi2+yhFNkMz19b+13Ml+QzuO90emY46NapQXLLCh/S7Q1NXPGvt9CG9XLn/5wE/i2dU2CDj/EfM22f0bJDd1mJb+fO3jdeWod4EBqQo9EBcDciVFjoT00AV/pG3FEr9/v3j/o7nYEhhLQBny26+wYxvZEtfSw1h9MRiAKTaJx9oglgWOm28dA9p6UPyeRp4cgLypye4lEgPDOiu9c7pSJ6xIYQnm773RhvylxKnL4Md2vAKWi0ntrL0mcdeBhitYeoP9KjNG9GVdxmd45sxcAAHIN0r5QOGuTKAoYUQiiegwBtXU/jNkESr1pvJD/zN6J+s+ggP1tcLbthn8PPseVpMbPg7aPA3bChiG4bwD/BAfTCPzUvn7d49hUnChBY1c3Ouhi/OfHqQSrHG/uMLQtMar5kak/34f+YH1hoOWbxhZR0/l7Muk8Eaph3Y4fVLw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(23010399003)(376014)(22082099003)(18002099003)(6133799003)(261009223027099003)(3023799007)(5023799004)(11063799006)(56012099006)(4143699003)(261028144727099003)(261021121427099003)(261102123227099003)(261026140227099003)(261026121527099003)(261021123027099003)(261022113327099003)(261022105027099003)(261022075727099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KYnLkN1BnIQ5qHCRiNM4e4c8eKQIDeWneKgYI5NqZd9v7kg3mY7FcbbXVq62?=
 =?us-ascii?Q?KLvCJRzKUdDEoDm7jvs1ObC36VmLK99b3CwnbfcDfWNxSDnrHv05VWtsUH4W?=
 =?us-ascii?Q?HbnyxMlqpcMD7Wf7vyL3CWYCLuu7qdKrcvomagTmGSmO5gLrZX/BzPXAUhEB?=
 =?us-ascii?Q?uAuMqGMOoihEgEauxkGBmq0+5DhPQxJpzSAbRixSRmoKXEnOG8llcCHq8EB3?=
 =?us-ascii?Q?kiU8CJZs9HQ2IZjSHPjjuKG04i4PpFFSV83nbXDnGCK495RSroWii8tbJhRp?=
 =?us-ascii?Q?sdGMZi/cLju7BHKjRvvjxzVeQzI2D7OQNnUB6stX/cO6jfU1JVvpXLC274hG?=
 =?us-ascii?Q?qf5RvVu3iV7rz+ZWGBlcMoc1eYHWofLFMxMc9tCeOUI0BnhjUAG6BayDl35X?=
 =?us-ascii?Q?9hQay7ETYxEbz8jlCjvdz14U8wF+h1j6nIRBJ5opV1ftTFeie17dmc0nDey9?=
 =?us-ascii?Q?vp665di1qySxTsdhGCp8RQ8+rccsKEi1nD806k0RWnnEUV2mlQC/x++Cyuhx?=
 =?us-ascii?Q?tcDU95GhlKbeJ2HdKaMGxzggaBMoaKcyqpyojh7SHCgKLkgBNXZbvi+HX5a0?=
 =?us-ascii?Q?uQXcAWJNdPUdAVCMrCS8hEP7CQwusYXEoSy6pHL57WvX11p4H6jRrumrAgaX?=
 =?us-ascii?Q?7CP5Br4nF4MfJf1Q2lenfgKYLctwvDda38W+vZ68PWo6AvmQVSiRUcXQQtV8?=
 =?us-ascii?Q?S94eF+aXLoFq/UjHWuDwPeVwAj/96uVvtlxx5fhGRYkEyeK7zX1lsFodw5/v?=
 =?us-ascii?Q?9RfZxVj2JNVn+kl2tbii42bET3j57s2CXVX7rtEHxWux+J9ALXNtj7TMtr+G?=
 =?us-ascii?Q?2mHvL/pRtOPL/xwTE3teO3u+3dx3zJ0Nx5aXTv2XPQJFpVLt3nB/pEmthqug?=
 =?us-ascii?Q?R79SGq8JAZmg5VVrP7nSkkLL1cOX5ykT/DuyaX7GUEgJI0VWwpEtBCpl3UV5?=
 =?us-ascii?Q?eeotHCEo9AAaftOKV9QXDLgdoy45Pe9o1l3U1Pq+xpnNYG3IbGprioeUilx0?=
 =?us-ascii?Q?PhemPbNIehMEiW9ab4i1DpSWs4CSxbpjSXkEUmxbBCe7DYoQ4B2AgRblQJrg?=
 =?us-ascii?Q?p7jRFGpaDvj31adQK5DktVt41F5wpRtW47alhdgzgxKZ1MvI3nvKeo3K6xDI?=
 =?us-ascii?Q?SQ5fxwersH6/hsOZcqtbF9KGSc5RWPK4qQx8PX849/Zjk2Dym8/z7iBDgl94?=
 =?us-ascii?Q?av/qGXn/1EA7IIuUGa+iel/e5HrTFt89SM2lqrklfLse+ztxaPDNioYk/+6x?=
 =?us-ascii?Q?WPycROORpOfgaPRjoHAf33kGURT//eXNz1cZnnWUyG4xNlGoXprNLzfDCU7y?=
 =?us-ascii?Q?pR30R9ub2Bye0BGmrdg5UlWyUXr58MqnuoFF+iFR0qHfk0kMAv/4DMSq5jbC?=
 =?us-ascii?Q?PxtbIJxdiTGFEYdt8Ug6lPpb49/FMK3W/N/1FkpC5gjalU7ibTsPunCN88zD?=
 =?us-ascii?Q?gIxWBs8wZjtBsS36wTjWMkktuBMuxQWNbQrrysrg03USlpbvyYIl1+ysTo/M?=
 =?us-ascii?Q?1JSdB1sDO2YZeqbs/ZyFvcr8bKOd06ujb2YypJbWJcK1Ci8hhpq/+cyi5nmB?=
 =?us-ascii?Q?ttLKTFyFjZB0eTnxbL6MyEsOmOL7BmYAXhQlJg+FDNz+MMV0N9/uaB3GsbpA?=
 =?us-ascii?Q?4qLxh9jA0opfFID+lxiwmvnyh+dOMm5SqscO7OvefwBbZqMDoe2BmcYzXzUs?=
 =?us-ascii?Q?cYJpFkFYdjp9gGo4X1oxUDoK2wxmwPRchNtCsIN/XknejldXIfAx1lqQVKb9?=
 =?us-ascii?Q?bufCo+Ak6Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 797bc20b-2c6f-4f16-8c66-08df408f56ba
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 07:34:09.1352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0fJKl9DIzBzdmBLkZKAdELLk1ki/K16PB3DhRuSj7JdU6KyFdv8crpUW/4T/bVAjDeXmaz0Inl6DdIVl9n8USw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB429550

On Thu, Nov 05, 2026 at 08:02:35AM +0800, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> Replace the ack-all stub for Release Capacity chains with the real
> teardown.
> 
> Similar to add capacity events, Release Capacity records arrive as a
> More-chain and are staged in mds->dc_chain until the chain closes;
> a chain whose closing record never arrives is dropped by the 20s
> watchdog without a response.
> 
> A tag group is one logical allocation, so a well-behaved fabric manager
> is expected to release all members of a tag group together.  However,
> CXL r4.0 Section 8.2.10.9.9.4 permits the host to issue an "unsolicited
> release" of extents not corresponding to any event.  So as a generous
> policy, the kernel releases all members of a tag group upon receiving a
> Release Capacity record containing any member of the group.
> 
> Extents are matched to what the host owns by DPA range and tag.  An
> extent not matching any host-owned extent is acknowledged for release
> so the device knows the host is not using it.  An extent that overlaps
> owned capacity without matching any host-owned extent by tag and DPA is
> left out of the response so the device keeps the capacity for the host
> and must retry.
> 
> Extents are not usable until exposed through DAX.  The DAX series that
> adds that capability also adds the check that an extent is not in use
> before it is released.
> 
> Everything a chain releases is acknowledged in the Release Dynamic
> Capacity response (opcode 4803h), split across several commands chained
> with the More flag when the extent list outgrows the mailbox payload.
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Co-developed-by: John Groves <John@Groves.net>
> Signed-off-by: John Groves <John@Groves.net>
> Co-developed-by: Anisa Su <anisa.su@samsung.com>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> Tested-by: Junhee Park <jh9934.park@samsung.com>
> Tested-by: Heesoo Kim <habil.kim@samsung.com>
> ---
>  drivers/cxl/core/core.h   |  21 ++++++++
>  drivers/cxl/core/extent.c | 103 +++++++++++++++++++++++++++++++++++
>  drivers/cxl/core/mbox.c   | 109 ++++++++++++++++++++++++++++++++++++--
>  3 files changed, 229 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index b7f8886db498..f0edd0100c72 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
> @@ -79,6 +79,11 @@ void kill_regions(struct cxl_root_decoder *cxlrd);
>  
>  int cxl_add_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent,
>  		   u16 seq_num);
> +int cxl_resolve_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent,
> +		       struct cxl_region **cxlrp,
> +		       struct cxl_dc_tag_group **groupp);
> +int cxl_release_tag_group(struct cxl_region *cxlr,
> +			  struct cxl_dc_tag_group *group);
>  bool cxl_tag_already_committed(const uuid_t *tag);
>  int online_tag_group(struct cxl_dc_tag_group *group);
>  bool rm_tag_group(struct cxl_dc_tag_group *group);
> @@ -101,6 +106,22 @@ static inline int cxl_add_extent(struct cxl_memdev_state *mds,
>  	return -ENXIO;
>  }
>  
> +static inline int cxl_resolve_extent(struct cxl_memdev_state *mds,
> +				     struct cxl_extent *extent,
> +				     struct cxl_region **cxlrp,
> +				     struct cxl_dc_tag_group **groupp)
> +{
> +	*cxlrp = NULL;
> +	*groupp = NULL;
> +	return -ENXIO;
> +}

Hi Anisa, Ira,

Release lookup should be able to distinguish "no owned capacity" from
"teardown ist still in progress".

In patch 6, it clears "cxlr->cxlr_dax" before driver cleanup finishes.
During that window, cxl_resolve_extent() returns -ENXIO, and cxl_rm_pending()
treats the extent as untracked and ack its release. The missing pointer
doesn't establish that DAX has finished stopping access to the memory.

CXL should remain responsible for the capacity until it's safely returned.
DAX should stop new claims and finish stopping existing access.

The release path needs to recognize that teardown is in progress and leave
the release to the teardown owner. Removing the lookup entry alone must
not authorize returning the capacity.

Best regards,
Richard Cheng.



> +
> +static inline int cxl_release_tag_group(struct cxl_region *cxlr,
> +					struct cxl_dc_tag_group *group)
> +{
> +	return -ENXIO;
> +}
> +
>  static inline int online_tag_group(struct cxl_dc_tag_group *group)
>  {
>  	return 0;
> diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> index 4a59db823af4..1873a3dfe8e0 100644
> --- a/drivers/cxl/core/extent.c
> +++ b/drivers/cxl/core/extent.c
> @@ -449,6 +449,109 @@ int cxl_add_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent,
>  	return cxlr_add_extent(mds, cxlr_dax, dc_extent);
>  }
>  
> +/**
> + * cxl_resolve_extent() - locate the tag group a released extent belongs to
> + * @mds: memdev state
> + * @extent: extent from a DC Release-Capacity record
> + * @cxlrp: returns the region owning the group
> + * @groupp: returns the matching tag group
> + *
> + * Pure lookup, no side effects.  A record names the dc_extent that contains
> + * its range: the host cannot split an extent.
> + *
> + * Return: 0 when @extent matches an extent the host owns.  -ENXIO when the
> + * extent doesn't match anything on the host (no region, no dax region, or a
> + * range that has no overlap with host-owned extents), so the release can
> + * simply be acknowledged.  -EINVAL when it overlaps owned capacity without
> + * matching any single host-owned extent: it straddles multiple extents, or
> + * the tag doesn't match.
> + */
> +int cxl_resolve_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent,
> +		       struct cxl_region **cxlrp,
> +		       struct cxl_dc_tag_group **groupp)
> +{
> +	u64 start_dpa = le64_to_cpu(extent->start_dpa);
> +	struct cxl_memdev *cxlmd = mds->cxlds.cxlmd;
> +	struct cxl_endpoint_decoder *cxled;
> +	struct cxl_dax_region *cxlr_dax;
> +	struct dc_extent *dc_extent;
> +	struct cxl_region *cxlr;
> +	struct range dpa_range;
> +	unsigned long idx;
> +	uuid_t tag;
> +
> +	*cxlrp = NULL;
> +	*groupp = NULL;
> +
> +	dpa_range = (struct range) {
> +		.start = start_dpa,
> +		.end = start_dpa + le64_to_cpu(extent->length) - 1,
> +	};
> +
> +	cxlr = cxl_dpa_to_region(cxlmd, start_dpa, &cxled);
> +	if (!cxlr)
> +		return -ENXIO;
> +
> +	cxlr_dax = cxlr->cxlr_dax;
> +	if (!cxlr_dax)
> +		return -ENXIO;
> +
> +	import_uuid(&tag, extent->uuid);
> +
> +	/* RCU keeps entries live during the walk; teardown happens later. */
> +	scoped_guard(rcu) {
> +		xa_for_each(&cxlr_dax->dc_extents, idx, dc_extent) {
> +			if (dc_extent->cxled != cxled)
> +				continue;
> +			if (!range_overlaps(&dc_extent->dpa_range, &dpa_range))
> +				continue;
> +			if (!range_contains(&dc_extent->dpa_range, &dpa_range))
> +				return -EINVAL;
> +			if (!uuid_equal(&dc_extent->group->uuid, &tag))
> +				return -EINVAL;
> +			*cxlrp = cxlr;
> +			*groupp = dc_extent->group;
> +			return 0;
> +		}
> +	}
> +	return -ENXIO;
> +}
> +
> +/**
> + * cxl_release_tag_group() - tear a tag group down for a device release
> + * @cxlr: region owning the group
> + * @group: the group to release
> + *
> + * The caller acknowledges the group to the device as a whole; the group is
> + * dropped without a Release DC of its own.
> + *
> + * Return: 0 when the group is gone, negative when the caller must leave it
> + * intact and let the device retry.
> + */
> +int cxl_release_tag_group(struct cxl_region *cxlr,
> +			  struct cxl_dc_tag_group *group)
> +{
> +	int rc;
> +
> +	/*
> +	 * Invalidate CPU caches for the region before releasing the capacity
> +	 * back to the device so it cannot reassign the range while stale
> +	 * cached data lingers.  On failure do not release: leave the tag
> +	 * group intact and let the device retry.
> +	 */
> +	rc = cxl_region_invalidate_memregion(cxlr);
> +	if (rc)
> +		return rc;
> +
> +	/*
> +	 * An unbinding dax region has already collected the group's devres
> +	 * teardown; let that finish the release rather than race it.
> +	 */
> +	if (!rm_tag_group(group))
> +		return -EBUSY;
> +	return 0;
> +}
> +
>  /* The group's device may already be visible: readers walk the xarray under RCU */
>  static void cleanup_pending_dc_extent(struct dc_extent *dc_extent)
>  {
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 0fa501f5800c..c3236fe9e7c5 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1747,6 +1747,109 @@ static int cxl_add_pending(struct cxl_memdev_state *mds,
>  				    pending, total_accepted);
>  }
>  
> +/*
> + * Tear @group down and queue every member on @acks.  Members are queued
> + * before rm_tag_group() frees them; on failure nothing is queued and the
> + * group stays intact for the device to retry.  Returns the number queued.
> + */
> +static int cxl_release_group(struct cxl_region *cxlr,
> +			     struct cxl_dc_tag_group *group,
> +			     struct list_head *acks)
> +{
> +	LIST_HEAD(members);
> +	int cnt, rc;
> +
> +	cnt = stage_group_release(group, &members);
> +	if (cnt < 0)
> +		return cnt;
> +
> +	rc = cxl_release_tag_group(cxlr, group);
> +	if (rc) {
> +		drop_extent_group(&members);
> +		return rc;
> +	}
> +
> +	list_splice_tail(&members, acks);
> +	return cnt;
> +}
> +
> +/*
> + * Flush a staged Release chain.
> + *
> + * A tag group is one logical allocation: naming any extent of a group
> + * releases the whole group, and members the chain did not name go back as
> + * an unsolicited release (CXL r4.0 9.13.3).  Each extent is decided on its
> + * own, so a group that refuses teardown, or an extent that overlaps owned
> + * capacity without naming an owned extent, is held for the device to retry
> + * while the rest proceed.  Extents the host is not tracking at all (no
> + * region, no dax region, or nothing owned in range) hold no capacity here
> + * and are acknowledged as named.
> + *
> + * Everything released is acknowledged together in the Release DC response
> + * once the chain is flushed (split across More-chained commands when the
> + * list outgrows the mailbox payload), so a sharable tag is always returned
> + * whole (CXL r4.0 8.2.10.9.9.4).
> + */
> +static int cxl_rm_pending(struct cxl_memdev_state *mds)
> +{
> +	struct list_head *pending = &mds->dc_chain.pending_extents;
> +	struct device *dev = mds->cxlds.dev;
> +	struct cxl_extent_list_node *pos, *tmp;
> +	LIST_HEAD(acks);
> +	int cnt = 0, rc;
> +
> +	/* cxl_resolve_extent() -> cxl_dpa_to_region() walks every decoder's dpa_res */
> +	guard(rwsem_read)(&cxl_rwsem.region);
> +	guard(rwsem_read)(&cxl_rwsem.dpa);
> +
> +	/* Untracked first, before a teardown below makes a sibling look untracked */
> +	list_for_each_entry_safe(pos, tmp, pending, list) {
> +		struct cxl_dc_tag_group *group;
> +		struct cxl_region *cxlr;
> +
> +		if (cxl_resolve_extent(mds, pos->extent, &cxlr, &group) != -ENXIO)
> +			continue;
> +		list_move_tail(&pos->list, &acks);
> +		cnt++;
> +	}
> +
> +	list_for_each_entry(pos, pending, list) {
> +		struct cxl_dc_tag_group *group;
> +		struct cxl_region *cxlr;
> +		struct range r;
> +
> +		rc = cxl_resolve_extent(mds, pos->extent, &cxlr, &group);
> +		if (rc == -ENXIO)	/* sibling of a group released above */
> +			continue;
> +		if (rc) {
> +			r.start = le64_to_cpu(pos->extent->start_dpa);
> +			r.end = r.start + le64_to_cpu(pos->extent->length) - 1;
> +			dev_warn_ratelimited(dev,
> +					     "DC release %pra (%pUb) names no owned extent; holding for retry\n",
> +					     &r, pos->extent->uuid);
> +			continue;
> +		}
> +
> +		rc = cxl_release_group(cxlr, group, &acks);
> +		if (rc < 0) {
> +			dev_dbg(dev, "DC release of tag %pUb deferred: %d\n",
> +				&group->uuid, rc);
> +			continue;
> +		}
> +		cnt += rc;
> +	}
> +
> +	/* Updated Extent List Size shall be > 0 (CXL r4.0 Table 8-352) */
> +	rc = 0;
> +	if (cnt)
> +		rc = cxl_send_dc_response(mds, CXL_MBOX_OP_RELEASE_DC, &acks,
> +					  cnt);
> +
> +	/* The caller frees @pending; hand the acknowledged entries back */
> +	list_splice(&acks, pending);
> +	return rc;
> +}
> +
>  static int handle_dcd_chain_event(struct cxl_memdev_state *mds,
>  				  struct cxl_event_dcd *event)
>  {
> @@ -1793,10 +1896,8 @@ static int handle_dcd_chain_event(struct cxl_memdev_state *mds,
>  
>  	if (event->event_type == DCD_ADD_CAPACITY)
>  		rc = cxl_add_pending(mds, &chain->pending_extents);
> -	else	/* Nothing is tracked yet: acknowledge every release */
> -		rc = cxl_send_dc_response(mds, CXL_MBOX_OP_RELEASE_DC,
> -					  &chain->pending_extents,
> -					  list_count_nodes(&chain->pending_extents));
> +	else
> +		rc = cxl_rm_pending(mds);
>  	clear_pending_extents(mds);
>  	return rc;
>  }
> -- 
> 2.43.0
> 
