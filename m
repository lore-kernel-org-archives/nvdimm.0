Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010012.outbound.protection.outlook.com [52.101.56.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C033603FB
	for <nvdimm@lists.linux.dev>; Wed,  8 Apr 2026 21:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775684390; cv=fail; b=BG9Pe/2jpzFpyKThnL2wh7X9uXmuV2yfXahlXcVO5ooGrERqJ6Yb+/79ewlocsTS/sVawbHuqY2bLNECSvle31DGdsftaVsupweUIuA622M9VrVjuYIUaGikc5VmdKq0gBZWtEP1nGbVtCpi+rSML9NeKbcHbmxOaux6t8wwqvY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775684390; c=relaxed/simple;
	bh=K1/ugQ4mT3QVbfEbjptWYWkxvhZDRPRJo4EfxUYdBr8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=IX7MU0w/XLrElafhU3y3Af7rWJ26w8IrgVb7f56NF1w3a7Qp5dSuxXYBHqHCKoEWYfCn+90rjB2FqDNxxLY6z5QjgY37JTL94i+Fvv0kemtPzFLeCqefZfrp7WPmx1+bI4gFAEHsVyayT0DoIgTgNJMelsJIbaD0do5RQAjF6WY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OiR8O2hV; arc=fail smtp.client-ip=52.101.56.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OiR8O2hV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cK8aEWbBgBkgKf++MvH8z3h2vuvNRZO0lJ1g+4OVyoyCGpr1Y/8QE2uX6rXQkemk5rlaXtktX9hMqVHKEp1Xsnwbun4GHIR/mEzJQkIzUpmdXZaV6GtPCKMQ9rptzDLUlSDmsqyLHSUrVOB7hNuwyiR2qIjX88iJpH/7zREngPM4AZA3XUIUcHv6m9bf/GNH9Q9D1D37a9B9IS3L0eXnLFspBG4e2EhzadO6SaMkG7js+Kr3PdJMiycguNo9BcQrJDFqqT6hmQTc5bi0S6ez1Ys3sUf6HpPYm4dbzd3r2yVGaY1AHdkeIa4to2jvE3AKiSUnNtyVmWdX2VXQAIJkFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zn0w19zLvdFd6fGhMOp29QSGJE6EPIAHanAFsG90fCk=;
 b=f66IhDSh/+sL5BGK+5OxU5uZ8mOmExacca/EchBBzYJk1f0b8EgHpsQOt4tdObYJolbYUMk9uuhRxoxU7cW7FQveKLo+1hvKsgzlloXiskCWDWqEyy9I4812Kc+HB8VeAf8SZuC5n8Rg2I0rFhVspZYbZfRJgPwlcTiVGTKGK1JJ1Q9ws5alAmJLeEvbANZ85n40/TNJVE1sLYlS8uDIsQ3SlgIuGZ2Tspnpc1lmhknb4ZaFHMMg3Uy7NzxTwLiv7wVOJmwhIfm6m8D0D3Givv54macjoL5RIdhkuTxO/61VGL3lZIa6h5Gxnt2jaf6hLPUDaj+kqGbo2DYztl3isw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=stgolabs.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zn0w19zLvdFd6fGhMOp29QSGJE6EPIAHanAFsG90fCk=;
 b=OiR8O2hVu/ZcIbFvCJVlleSNfKMHIMGBjWo37rkpMErkHKHv7sAYr2Z9IzAC+Rt7nssfuxI0bdDKWRBWOPpMnsGi0ara+/7QD57KhAkflMW0fLtWac/w4solq6sKvJDQdcvMcjvzffzdjG0RE6M6115MIYxEy+YIvUbsFFX4HlM=
Received: from SJ0PR13CA0129.namprd13.prod.outlook.com (2603:10b6:a03:2c6::14)
 by DS0PR12MB8218.namprd12.prod.outlook.com (2603:10b6:8:f2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Wed, 8 Apr
 2026 21:39:44 +0000
Received: from CO1PEPF000075F3.namprd03.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::df) by SJ0PR13CA0129.outlook.office365.com
 (2603:10b6:a03:2c6::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.37 via Frontend Transport; Wed,
 8 Apr 2026 21:39:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000075F3.mail.protection.outlook.com (10.167.249.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.21 via Frontend Transport; Wed, 8 Apr 2026 21:39:44 +0000
Received: from [10.236.182.193] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 8 Apr
 2026 16:39:42 -0500
Message-ID: <7fe63454-9df7-47c9-ae7f-4db1fd1a3576@amd.com>
Date: Wed, 8 Apr 2026 16:39:41 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Subject: Re: [ndctl PATCH 0/3] Enable CXL protocol testing
To: Terry Bowman <terry.bowman@amd.com>, <dave@stgolabs.net>,
	<jonathan.cameron@huawei.com>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <dan.j.williams@intel.com>,
	<shiju.jose@huawei.com>, <ming.li@zohomail.com>,
	<Smita.KoralahalliChannabasappa@amd.com>, <rrichter@amd.com>,
	<dan.carpenter@linaro.org>, <PradeepVineshReddy.Kodamati@amd.com>,
	<lukas@wunner.de>, <sathyanarayanan.kuppuswamy@linux.intel.com>,
	<nvdimm@lists.linux.dev>, <alucerop@amd.com>, <ira.weiny@intel.com>
CC: <linux-cxl@vger.kernel.org>
References: <20260408203231.962206-1-terry.bowman@amd.com>
Content-Language: en-US
In-Reply-To: <20260408203231.962206-1-terry.bowman@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F3:EE_|DS0PR12MB8218:EE_
X-MS-Office365-Filtering-Correlation-Id: 45dd616d-25b3-4f8b-6230-08de95b75933
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|7416014|376014|921020|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	2M7Ff3NpBlz4fEt0h2YE772D8o9qi8qkTdp7a3xdD/AN20trjppYeeSX5OBjyNLlzt7447XbLW3pl+i4BEfemOhS95KeVFG6E8PyqVe0GBBcYSfn9RiiBvWzF4dOVRQCOVfXOXMmKZ3FpiSwiIOml5YPOdpj0wJLxxhNIshiXijhmV1Nhgfu3wFyIM5UtmPdAGSMCms24W1DuZ6WBM7vlO1xDJL0/bSa7wLq216TrbjgRduJPbTTGIsBjuHFo3+G9par2aTMa63CCMVYTSnGUMJTwXFU+amnDn7fHkDVvpQGv9u1/lMMwVQ4ggAsjoCh++WKh+i/Gmd3iCUWx1vsBpBpTNIVezBlwwd1M0sk3h7HjKNiPGkpIGbyutRGTFMX+nRrYM15j+pcBcCxQUkS4jp7ZQfh1VZGEy2zqU3XmYjIRv6LJLzF/n5hSjpf8qLzw+LuqKVrzCie8jaG4lGOvooYI2U4sBDE0Up1ImyXju1ETKZoYuAHX/PMBhVPBTd+zXoK030C9cRoIpluyCBzJuE0YonlrfBuKdrWYjNPDp6Ha4+gvurc8CQhzoYhV4Jsm3zSaZ9a4zf27rTQ2odAuvjMtsnDaxw3ECdG/jIJDtYr++nk1iVyoka4irqZicb3Kbnuy9HqiSok7A0AITuij/UTMz5Fux51q1iemc32m8uW4Xbb9DQBNl8hOUDz9+FI/hFeqUR30S5g+qKnvpjcp2hid4m4tzgweeXQNwgBmz/z08Gkr5AgX5Rb1ptIJN259Rxdu+ofeEjsyDjSZSYb2vK16TR7OUBIm1nwxewQ/ofXKuNUIrvS7zWmOTjagvGL
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(7416014)(376014)(921020)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EJrqbXega2lSQrm15SoVLYOR4fB6J31EO8ksh2aXPSXkzfCWMB6pFEJA9L97KXfyGojABIGBDryvZ9+mjJQxt2HmMjSA9Oh58/wECkjBPaZPnC3KLlhyZEl4T/FqmQfAngJ3DGRs/+WkuHDOIpM3RhzG0dWBpSOyhREl/gNeCwI+dGiUJ3HYe2kf5Jfc4n7qrXJDEh/s874dHHzDLbn1S5riCgR5KRaiN7vn141P4xRgHSzzx5ZVDjy/+l2tSSLpRu+G4nceXnWcH/99KAz+8VTOWIUOjlSeeHiHlYSN9gUf4Pmy9xeY+aEd2HusoqQ3bQbKrQXcfwJ3EhebIwLzNoUoVxrB1aVU+wLp5hrMtZgaqJgs+k9JBzT/X3wQUrFYbzxO67uW34D5z8XQKjGQ2A9aJf9TgnIcoisRp+o/gPZyh6IjUUMN7+VHKBORufMp
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 21:39:44.0522
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45dd616d-25b3-4f8b-6230-08de95b75933
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8218

On 4/8/2026 3:32 PM, Terry Bowman wrote:
> Current CXL error injection (EINJ) only supports Root Port protocol error
> injection but a method to test all CXL devices is needed. This series
> outlines methods to update both the kernel and the 'aer-inject' tool-without
> relying on EINJ-to enable CXL RAS protocol error handling across all CXL
> devices.
> 

This functionality should probably be added to the inject-protocol-error subcommand
instead of spread out across the directory as a bunch of scripts + patches. The command
is only set up for protocol error injection, but I don't think it would be *too* hard
to extend.

I think the first thing you have to do is expand the accepted device types to include ports and
memdevs instead of just dports. That should be simple enough, there are already helpers to find
both based on sbdf, name, etc. Then, you'd need to change the interface used to inject the error
based on device type (is it a root port? then use EINJ, otherwise use aer-inject). All that's
left at that point is to actually call the aer-inject command with the correct options (and
update the documentation/help messages).

I would be happy to help with any of the above if you agree with the direction, just let me
know!

Thanks,
Ben
