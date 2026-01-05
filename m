Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013056.outbound.protection.outlook.com [40.93.201.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365912DEA6E
	for <nvdimm@lists.linux.dev>; Mon,  5 Jan 2026 21:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767647665; cv=fail; b=MSZhjVs14+hy1H8JdTVpBp8Jkb3QevNojnbk6RnmulLSATwMBkFDXGoQLbq3oKRuVSoh81/Mr4RSHdx/vsccj0JCyNlFCNxzh5rlzeGMH/1nJi6Wy/d1QdRdcnzbCQ4k2979H+eBe4qeqr8DE4cv5BRtKccDH/Okd6dMMsRJKLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767647665; c=relaxed/simple;
	bh=4wmzG3traxwnOPhXnwjBZ+aVU0w+6uvcEMSBcNDbkOE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=QSTCMML6S25C6UGtHyYwZeNekFR+bH5+zBqG/kfWg/O0a8hR1RXmO79w5ac7HWzDjUYvt+Hdq+Lx/KrKPQeO0l7JVXoMCavd1Bx3X4MCB5IRLo1kX+LesXq/Kzl/QGoiqhvzKhYzstslOMmzNnRNTUVP42V8hrtP4QG+mtDY75I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iL1XREJ8; arc=fail smtp.client-ip=40.93.201.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iL1XREJ8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AM4kMR4QCmz6WsNF2kZyYMDbHF4G58+BlqQ2KPw+YzzOFhMCiEeAY3Ry473NGRhij56txdQAb1/C79uHSKMWMV0B6z0ZKvwAzi3mNbs1UnAsDcSzLRuZ8wF3Qv+mzkSughJ1pu+S5nSAFf1NcskCdouA6tp1Wm+lp3WPmFptKJnncZM0w+WWudmJc3L1tMf2086l3cc5W1S4zUnnB43tye0SC3BTAmG10amq18m4hCuRkCmvtZUlbBj22YuKJchnHd8SVkVEO+CRMzp7tOolsAe+XgeXV8dgmFjIA7jFXFpotuapj3640Z+vECt6NjNBy7Zqe4zEgj/00s5rGD85/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GdiqszoL/KT52v5OMWRjE9Q3HcLL62Ug946dOYDF54c=;
 b=CEYSojczrA8/5A4wQYCmOV4ojv/8hcqL9BYXAzJPvQxtlsEP7xzVZ5gJTGgM3zUA8K0fJr8uIdRqiL59O5Yx7DuvNdznTtbZGOmFEC3zkViE0aLafPzEZr6zfwR+ZOiQ+aUlCTKwF2NoeLcGMWnENlVKL7kNi5A0lQyb87bfpCCZkDxLAS3JOaKXax9SmaWKEabUdRHfCB+2ePnHd5dvkOVwnEpuYJRqYZY8s4z7XKzew3c2FPrl518snpWbaHSTXj5Fvtdt3dsq39vrePxPLOItfskUi5a7L3IaW+08bMZzzARaKRvA91RJJn05QDYziVOeBajK31HVvnpfbu1USA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GdiqszoL/KT52v5OMWRjE9Q3HcLL62Ug946dOYDF54c=;
 b=iL1XREJ8HbI/MPBdagxfYDDfXOqKezizlEpdQTkimFqDQdYXxKCDnzrt1YJqjYKjrRp6mLavNjVcJgpnxWpgTpoNlwrtiKiTHIXXRam3SJLB7UQtZ1rqkgBJ/qpzDI7iCyOYJoxgOdIqtDeMpZYvVARd7q+TEbPcoIUOD4rp3mk=
Received: from SA0PR11CA0114.namprd11.prod.outlook.com (2603:10b6:806:d1::29)
 by SA0PR12MB4493.namprd12.prod.outlook.com (2603:10b6:806:72::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 21:14:19 +0000
Received: from SN1PEPF0002636B.namprd02.prod.outlook.com
 (2603:10b6:806:d1:cafe::c9) by SA0PR11CA0114.outlook.office365.com
 (2603:10b6:806:d1::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9478.4 via Frontend Transport; Mon, 5
 Jan 2026 21:14:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002636B.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.1 via Frontend Transport; Mon, 5 Jan 2026 21:14:19 +0000
Received: from [172.31.132.101] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 5 Jan
 2026 15:14:17 -0600
Message-ID: <d5743ac1-0b7b-443c-8773-49fc8e99da6a@amd.com>
Date: Mon, 5 Jan 2026 15:14:11 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v5 0/7] Add error injection support
To: Alison Schofield <alison.schofield@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<dave.jiang@intel.com>
References: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
 <aUI13O1UFv4L__yw@aschofie-mobl2.lan>
 <bea48658-5960-4159-bf74-f4ab806189d6@amd.com>
 <aUTdzjlvdXmh0B1L@aschofie-mobl2.lan>
Content-Language: en-US
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
In-Reply-To: <aUTdzjlvdXmh0B1L@aschofie-mobl2.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636B:EE_|SA0PR12MB4493:EE_
X-MS-Office365-Filtering-Correlation-Id: 019ba34e-2596-42b9-c10c-08de4c9f63d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OWFDZC84SC9aTVIzOGtxZkFZcjNlbjRxcTJQZTd4dlNuRURJeXpEc3V4anZ4?=
 =?utf-8?B?VU81SHpMYml0VXg4N2hCUzBuTVl5ZkJDeDNoWWtqaU1JNUdKM3pXeDVPS1pM?=
 =?utf-8?B?M3lnYlRmRjRSTFVUdE1xbTQ0RUh3NU1RZFlXRWhTY05LZXZxQlc5SHI3MElF?=
 =?utf-8?B?bEo1RjJOb3IwY1ZyVk84Vmd6NjlhT044VjdWL1E5OG5sOUZ3T1NKdm1TQllK?=
 =?utf-8?B?UElpT1V3cDVEOXRYeHh3SEIwZGF1VWVOdDM4d2U4dmt5VERGUEdPNWZONm0r?=
 =?utf-8?B?QVJjSEVNdGpyOXI4ZWtYYVJGb3p1STlOU0JIMVNsYUcvdlZqd3M1WER1MkRV?=
 =?utf-8?B?NEFJMjVWR3dlcUVqL3czL1JzL0w2eW9od2pxYm9sSnJVMVFJaHlxVlJIRUdh?=
 =?utf-8?B?Y1pKZ2pKVWJodEJXUVo0cU16RDhtSmJGQ3FiRGowUW9HenFOSHlxMVBKNTUv?=
 =?utf-8?B?Vmd1ZzhCclFNSEg0V3FrQWYzTVQyTkdhbHY2VzlxZ3Q3clI3L3gwQUZ1cDMw?=
 =?utf-8?B?UlhHVDBFSlE5UEw5b3BlNlBPQlJndkZBYW51bE4vMGJwT3Qwcm43bENITDFC?=
 =?utf-8?B?UHFtK3RQOTVEYlpBNlgvVUE4YlpUdkgvMjVrMVlxVXQwS0Q2TEJlRUkvQ2gr?=
 =?utf-8?B?RjZBSjVtYXhpVy9Sa2M2eEJ5c0ZqclFhUmtvUW5LaXdZV2JaRU5kRjlhWURO?=
 =?utf-8?B?cENtZHZucDhRR2Q2NnZXbEEyUy9heE1waUFWMHZYZDZVTTZHazU2SFBHUnhN?=
 =?utf-8?B?VVZOWTM0VU1COFZLSjVKeCtXdVhuMTBMUmRKZm9pY0R6c3ZMVVBJSVM5bDJJ?=
 =?utf-8?B?dnJISC9KL1Y3a3N0TFF5Y0IwWkVGeWhaaGMyMi80WVEzbkdjaEdIUURSb2w0?=
 =?utf-8?B?Vmk1Nm9UODJmUVhyTy9mUTE1Ky9yRGplZ3oxNklvb3AzWEhWNTVoN2t1RFFw?=
 =?utf-8?B?NnlJNVNuUm9LUk1URDBhTm1QcGJpUU9hVUVXQ2pab2dJcmx3U2kweUdOeWdO?=
 =?utf-8?B?ZkpwbWtyRzJFSGJ5WTZzNGxPbzBwdVF0c2w2M0ZvRTR0QUZMb0pLdDBjQ2cx?=
 =?utf-8?B?OU4rTzJNQ0ttZWN4TmszNkR0clFmME5EV3pzY3Y4d1dBV3p6ZnpyTkFZaXNi?=
 =?utf-8?B?aHJsRTFNMTBVS0RHTUdobTB3ajlKc2VoQ3UyY1B0QVpINjU2cURjajZXV3p5?=
 =?utf-8?B?VWhYZXBoTzFHNkdsSGpXeVkrYjBrSi9QekFxUS84VEZ1V2hNMyt0elRITmEz?=
 =?utf-8?B?NzNsNU9Kd3FTbWFqTzhRQTZsMnJuUks3a3BIWUR6ME5QelZUT244ODd5ODY5?=
 =?utf-8?B?Y3NycUdtNXcrTEt0WG95N3pPZXVmai9oOCtsQWpUaGV0Y3ZrdzJQZHIzQVFG?=
 =?utf-8?B?cW44THNVOThSc2pWRE1TQzluYXVaRXp3Q2NnVHdKYzRuL2hoMERCMHIvNjM1?=
 =?utf-8?B?RFc3b0k2M09QRmNOZHFYZW1FckR4TVFxMXdZVHB5eUduQWY5eVRjM3dJMXFZ?=
 =?utf-8?B?LzE2dHF4M2Y4Si9zaWliRW5tRXhkRDdhOFVLbkhEb21CS1JKNkVPb1lVNUFn?=
 =?utf-8?B?a2Fmazl6YW56L3IwUERieTZBeDFtV2FMMGxjQWNjRjZneXArWWR6ZlZFUU9q?=
 =?utf-8?B?UW5RencyU0xvajhlRzVPaCt6WDZZMlRFUE5oalZUWTRMUDAwYTdjaWJScU9o?=
 =?utf-8?B?R1JGL0FDWW4wdmp3YmVVanZ3RmI2d2JleS9JV0pvc2gxdXMrV0gvSnI1Vlp4?=
 =?utf-8?B?QkxVQ3FZNTZESFBhZk9TWUpzOHNXZUdXeml5eWovV3lVRUlDdktYL2l6dEtK?=
 =?utf-8?B?RlRZVEx2ZGg0Tk5ob3dkVXV4aWhUNWZmWEpmWGpLclYxcGhiSVBvSUNacVAy?=
 =?utf-8?B?cWZPV0tDVG1NSEZ3Y0gvc0RERHlLQTMyeTJOSXMzSTJITWlVd3VCTk1XNzhZ?=
 =?utf-8?B?Tm5MMEIvQW5TK3Z1c1lsSU1RRngzM3htczBLcmZMKytadWVURFM5Qi9YWDJQ?=
 =?utf-8?B?VTR5QmpOaWwrMkFPaWZHVGppOHVQdVR5MWlDQ29KZG5Pc1JyM1R4WkJQY2Yy?=
 =?utf-8?B?UXl1ZStrVmpCbjUybXVaRlh1Z29yTVdpQVEyQlVzQjB2d3NremN2Q1o2d2lB?=
 =?utf-8?Q?BCys=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 21:14:19.0928
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 019ba34e-2596-42b9-c10c-08de4c9f63d4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4493



On 12/18/2025 11:08 PM, Alison Schofield wrote:
> On Wed, Dec 17, 2025 at 01:56:35PM -0600, Cheatham, Benjamin wrote:
>> On 12/16/2025 10:47 PM, Alison Schofield wrote:
>>> On Mon, Dec 15, 2025 at 03:36:23PM -0600, Ben Cheatham wrote:
> 
>>>
>>> I have no test for the protocol errors. Is there anything you can
>>> share for that?
>>
>> I don't have any at the moment. My first idea for one is to modify the CXL test module(s)
>> to replace /sys/kernel/debug/cxl/einj_inject with a dummy that prints a message to the dmesg
>> then check for that message in the test after running the command. That would somewhat match
>> the real use case, but doesn't test any actual error injection. If you think that would
>> be useful let me know and I'll put something together.
> 
> As you may have guessed from my other comments, I got this running on
> real system, and am able to sanity check the cxl-cli commands for the
> protocol errors.
> 
> Does qemu have support for any of this? 

No, QEMU doesn't support EINJ. I think it's expected you do error injection through
the QEMU monitor instead.

