Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A5B25334E
	for <nvdimm@lists.linux.dev>; Tue, 29 Apr 2025 20:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745956914; cv=fail; b=cvFXdVCUl/7Y/kqfSHOtLPy6EDVv384INewJJvmdw+hJaP4XGce116FaAyU8F1fjHVBnhc++hr1aaIt32rnfIxDjeGHyOsBItt+ruvrXiemiaazI1KrqdqiKjoTWt2tHQzGW4GuBsJEr5zFvl0Yvgwo46fOsdovwIEOmRi+W238=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745956914; c=relaxed/simple;
	bh=77knnnQ1u9FXbwD2TNWs1Mf5fqScshJpGhZ3J/68d7U=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=ZgbE0tkW72KvBVNNDFV7EQEtMRa3bRxa8dUM2uONCBuz6Zk3APRBZabtVqZXT1AAUGekmWx4SzcejRnzBDaERFbx+5EASOpQ3JVjmn/8fbviqxY4u2lluoBDd+OPOQbcC8KiLvcUcD2G8zBdeOuoovm5ObmHDC4y2XtHYngBODQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Cv9F8BMx; arc=fail smtp.client-ip=40.107.94.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Cv9F8BMx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iC5VL/Kd4vfQUN940ysnGu0OLYvsGvyfKKWqQKfGwy1CnD7Pf2EXeFw8XIhzR+MWcrWczNhqgBA0F4emWEejkwuwMD04grSjy5BBLXmAG4rA98c/4nyC4aFpbw2cT0EIHrjc1D1FVwzfN6gBFYY5G6N1+ns4+CoVhyhcMJP75qERPZLCQlYtZcppQ0Rug4VAtetufbMsDV0/Rpd8Bnf+Q6F0zJczzCsr2yWuActzrWytlKNORRhofdgsSxeoh5NjfgnC1F06lBrstEHr7oJb3AX09vq8zFXwckFljLiimZbs+Dvkqc4dKfy8DLuO3CyuXxQl6vK3bp4PNoGZve7RlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zTFGtXl0QlcFsiCqTEf4xULIHuRDSoqVfnoTStwggpw=;
 b=GjbUVIA1AbH++5Eo/dw2r7fUAfKeOfhQkEFa5ci9PXnPb3P92tjVbLTverAaTdOey2S6pIRzBZJ+2rpQTRkpBP4CEWMMaWUxK8iemRO3UlFpsf9JtCImisbBhFWwI2jeD/aQcMetTakFz82Q9tw4KX5VHGa10Fyu9wlEkCxACPboYlHnpfyqD449/NDLOJmfhq4PZdmhXQdB4VVX7UZhcDW+TasAk4DnWuArB+oMLkq/YHe7KyvXZNjASHtXYBbzoMdBvvISjGeVrYFjPMohZ/KMYQHXDtsSHVxjVx0VCcJIiP+aJBA2MoGIHq10tnWmWwxkI+GqrqAJO2iyeZ7IFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zTFGtXl0QlcFsiCqTEf4xULIHuRDSoqVfnoTStwggpw=;
 b=Cv9F8BMx34IPT4JS7XrT2/opallCyU9xqJ2XEciKgh2DJDUd3COsuef9n5SXqt7SNIkdD3ERXIFjZmv3HSjFrhuhuuaOWMe/vVd8MyD15/hOX1jy1EkFDn0WLY6/Lx0s7aZ3+NQYX0kPlPRLgBoVkB94FeDozVqc4YS7szaI/OE=
Received: from BN9PR03CA0362.namprd03.prod.outlook.com (2603:10b6:408:f7::7)
 by CY8PR12MB8364.namprd12.prod.outlook.com (2603:10b6:930:7f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Tue, 29 Apr
 2025 20:01:47 +0000
Received: from BL6PEPF0001AB75.namprd02.prod.outlook.com
 (2603:10b6:408:f7:cafe::5e) by BN9PR03CA0362.outlook.office365.com
 (2603:10b6:408:f7::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.40 via Frontend Transport; Tue,
 29 Apr 2025 20:01:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB75.mail.protection.outlook.com (10.167.242.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8699.20 via Frontend Transport; Tue, 29 Apr 2025 20:01:47 +0000
Received: from [10.254.96.3] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 29 Apr
 2025 15:01:45 -0500
Message-ID: <2bfda6ab-7eb7-4166-832f-06a6a3216d0e@amd.com>
Date: Tue, 29 Apr 2025 15:01:42 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Ben Cheatham <benjamin.cheatham@amd.com>
Subject: Re: [ndctl PATCH 0/6] Add error injection support
To: Alison Schofield <alison.schofield@intel.com>, Junhyeok Im
	<junhyeok.im@samsung.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
References: <20250424212401.14789-1-Benjamin.Cheatham@amd.com>
 <aBA63FNkc21vPZ1d@aschofie-mobl2.lan>
Content-Language: en-US
In-Reply-To: <aBA63FNkc21vPZ1d@aschofie-mobl2.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB75:EE_|CY8PR12MB8364:EE_
X-MS-Office365-Filtering-Correlation-Id: ab2df01a-f45f-4c58-fc55-08dd8758ac4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d0xhN2xiQXgxcTVKb20zUGRTNUovTEJxNUtOcVZhb2c0eHBIQTV6MTZEcC9F?=
 =?utf-8?B?cWpBZmJVZE16R0NDMzk1VDRuL1JLd00zUnYwT2RuMU9jSi9wSytOWHZvQnJK?=
 =?utf-8?B?VVVIWHBtV1RGTldqUStuR09mMWxjR1U5cU42T1Fia01ZNUk1SnNxRkN6Rm5q?=
 =?utf-8?B?K2c1N2F3UWtUL2RDRGxnVjNHdzFpMUNPYlp3bjR6SkNhb0ZoV2RmZDA2dS9v?=
 =?utf-8?B?VkdpVUlUQnhDOUMvZmtFdDBFRWMvOWwrRVAxQ3J6Tnh6NjBOR2Y1TXYxeGFH?=
 =?utf-8?B?NmhXUzhDVjUrblJVNjJzZ2xyT2p0Y2puSFBxbjEwNTFEdHB5OWJwd2tTN08r?=
 =?utf-8?B?SG1hN2xXRDFWZzk0N0xXTktmbDFMeGwxWXI2YWQrMjdhcy9VRmE3azlIUUNv?=
 =?utf-8?B?eTJMSVhvcXRjT2FmV3I0ZDV2K1NHWGordnJyN25OZlVqNFd3Z1hraDl3bk4v?=
 =?utf-8?B?UjRzOHZCRVlMVlBlVnplY0tkMXhXbkhhZDA1a3ZHaXBEY1BSZEdVMXBBVlVG?=
 =?utf-8?B?aytwSTBTMldIY1pncmg5ekFvWXIzU1J3bnpmQjNZczRmQVNMWGNDVFdGbXlF?=
 =?utf-8?B?bWw3MmF2SXd0enM3aytzVDY3cGUwME1CcUxWdm5xYWVYWU5QelE1WHE1Wm9G?=
 =?utf-8?B?b1locGZIcDE5NmljdFhWUWV3Nlh3eldaMEdMRTc3T2dVdkFSdnhYVDFKQ3JH?=
 =?utf-8?B?ZjZyVjZ6dFFFOGJjMkt1azlqQWczUnJkeG05NVpKbnhweGNRdzFZNEJESi85?=
 =?utf-8?B?MVVQZVVUN3lIbExVREhPaVVoMkE3L015b0pPSzh2bTFsbFFaT2Q0Z09wWEhh?=
 =?utf-8?B?RVY5T0xsc3ZQMHVoRjN5M3E5QWo1cXVONDFuTmF2TjZGb1hidlAwNW9HTjFU?=
 =?utf-8?B?MHV5WnBpcVZVZ0pDbnJkajlQVkUvZ0ZpUWEzWHN0VFQrbjJNeWlKMVQ5dnln?=
 =?utf-8?B?WXRBRTBrN3lndFBNMVYwOTNBc2N6b1I5RTdkSXRwV2JWRW5RcEhuMElmdm1U?=
 =?utf-8?B?NUVMK2V6UTFJRDlFNTYvakdXY0h2R0JwcWpwSFNaeENnQnMvZlQ0Rmp6V2Nq?=
 =?utf-8?B?YjBNQ3lrRzlsQUJSQnE1V3cxUU81QmFhWG5KeVJxZk5rcVprREVQT2s5L084?=
 =?utf-8?B?WlBlTkVSYURsZVJSU2J4ZmNFR1VZK09La1NmRnZ3UDRTSU9hUHZ1NDA3bHE2?=
 =?utf-8?B?MnRBMWxBZGRsTWFIL2VERG9xVUJMbEVUQ3RmUkFSVm12ZFBoTlFUVzZNOERh?=
 =?utf-8?B?VCt1eXRocUdySEhORk9SZmRLd2I4ZXY2N0hYRG1GaDJPM0pYaDFOa3p6QnVC?=
 =?utf-8?B?SVZhVmJkcER4QmRQa054OWl4OG9scXJhcGtEbnU1UCtXNGpoT2MvVHlLRmcr?=
 =?utf-8?B?a25hN0Vka1pmQjltcVhibVNkWkUvY0VkRTNSTklMTzVyRzdweElaT1hGV1hm?=
 =?utf-8?B?YXFPd1k4Ung1Q2lURXQxQndCd2VleUNzNjRtcXhEQjB6L2ZHUm01cWhaYS9L?=
 =?utf-8?B?ODhGbHpoSm5NM0xLZ2R2KzVBVmEzUWpEQjlhOGxGYmcvLzQ5Q2V6ZUhaNCs3?=
 =?utf-8?B?YWNEZmd6ZUxWZkM2b1Nwbi9rMVFaY3dFaDBGM243QkNlVGFxamlXZVRxaGlG?=
 =?utf-8?B?TlBNYnlKM3dMS0pWVTFUNzJxZXVBdWlIMXJiem1TOGUvbm81ZUl6QXFRZDVX?=
 =?utf-8?B?eHhDN3FVelJGeUp0SWNCUFlnWW5Ycy84bldCc0dpNVpBa3JxcTZWak5KcjE4?=
 =?utf-8?B?bzdldmVUVFAzMmcrNjJ0RzU1TFhvVmhGd0FsV1JRMEl3V0ZGNmR5Z05iVklC?=
 =?utf-8?B?dm9hTXljSDExbEtxTkZQNWtmUnlmZVYyR2FnWTF0SGYxbjRmdERSYjY3UVkv?=
 =?utf-8?B?UU9hUnJIZE5XT0R3OEUxalY3QVp4dE80azBEU1pOTWJaNXArM0pSMzZKdzlt?=
 =?utf-8?B?VXRoYWdNRUkrdExCR1dYTUNoNUFzQzNwUDBlZEZWWm5zaktqamhwQ3I1MWRr?=
 =?utf-8?B?QXE0ck9WbG13PT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 20:01:47.3711
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab2df01a-f45f-4c58-fc55-08dd8758ac4d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB75.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8364


On 4/28/25 9:35 PM, Alison Schofield wrote:
> On Thu, Apr 24, 2025 at 04:23:55PM -0500, Ben Cheatham wrote:
>> This series adds support for injecting CXL protocol (CXL.cache/mem)
>> errors[1] into CXL RCH Downstream ports and VH root ports[2] and
>> poison into CXL memory devices through the CXL debugfs. Errors are
>> injected using a new 'inject-error' command, while errors are reported
>> using a new cxl-list "-N"/"--injectable-errors" option.
>>
>> The 'inject-error' command and "-N" option of cxl-list both require
>> access to the CXL driver's debugfs. Because the debugfs doesn't have a
>> required mount point, a "--debugfs" option is added to both cxl-list and
>> cxl-inject-error to specify the path to the debugfs if it isn't mounted
>> to the usual place (/sys/kernel/debug).
>>
>> The documentation for the new cxl-inject-error command shows both usage
>> and the possible device/error types, as well as how to retrieve them
>> using cxl-list. The documentation for cxl-list has also been updated to
>> show the usage of the new injectable errors and debugfs options.
>>
>> [1]: ACPI v6.5 spec, section 18.6.4
>> [2]: ACPI v6.5 spec, table 18.31
> 
> Hi Ben,
> 
> Junkyeok Im posted a set for inject & clear poison back in 2023.[1] It
> went through one round of review but was a bit ahead of it's time as we
> were still working out the presentation of media-errors in the trigger
> poison patch set. I'll 'cc them here in case they have interest and can
> help review thi set.

Thanks for pointing this out. I forgot to look for an existing set before
implementing it myself, sorry about that :/.

I'd be willing to drop the poison support from this set and use Junhyeok's
instead, integrate it into this one, or leave it as-is.

> 
> How come you're not interested in implementing clear-poison?

It is implemented, it's a flag ("--clear") for the inject-error command. I forgot
to mention it in the cover letter, I can add it in v2.

Thanks,
Ben
