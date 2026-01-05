Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011061.outbound.protection.outlook.com [40.93.194.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFF6246335
	for <nvdimm@lists.linux.dev>; Mon,  5 Jan 2026 21:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767646815; cv=fail; b=l/j7KjBINuqt2LXHB2QdwFzR3EG3onIv8GQxjeUpbaxob2qqRJXeSJHRxEDc3lpqJCRdw4yw4OSDAJSHj1YewN5Ma59r5F3BBpYFhqQYuxpFv00cMnMEtzSxpvABQ9ryiT4s6gonl/WQS04c84mtGP1lxpZk1bj9pmJnMLz5EZE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767646815; c=relaxed/simple;
	bh=KY3ojYkBA22sLvR2ccvdotBohrlsLl2P7CWJBvCVp/k=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=q4k/zCIhXeIl5qFqfZ6BsKXfufy45Yk5gp80yH/PHMCBvRtrfGOEi7R+64wBlp11WRH+u7Y/jdCssnkcx8dJKJOB210vi9SWrB7yy8Kp3yj1v+2cWelY7oNV3GcjM3+uo6+MkIxDhOSXtYQsf9kBNRgk92tyVAMGsnzVZjgzSQ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UEDMIi4T; arc=fail smtp.client-ip=40.93.194.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UEDMIi4T"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kAbehbKSFYU094JjBdCxYqz4Nhb78k3E6uFeEyExk/J2uzgH/mMFLWA+VRGn6L25GGtNtw7ypE9UhCZQOf2IHPsQqBiNNqwIingTrGZvnofnhLH10kr77AuW4UBiTLO909BXAolYrTeF2YZURiRNpP4uk3I9IXWJz/oA8B1RlsT/epFnTv9Md2fYri60RW5t5pcbpk7GAUbJVLh8O8ehr82T1Juknh0zOdJFKrFjeYIgduMlWunKqKlb+wVkn0kDoXxp1pjROpF0YbzMGv5w7hwmwOHBVRofHtb45s7knM5WHEea5AigT/WDvw7SR39l4Y3Sdyv/ERabBCXOK3Q1yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m5aO7uxzSs2A2gncWXqXlICPPPYfrZ3ecnwTDCISS+8=;
 b=kpBSmNScUGzPgi9zIvr6ijgNZY1HevLZTkYKIn7hvF6ys2mXJS08zhy6xKdqZBialpEcDXdR7Et89tVeAN4ulKCdXbicYPUyv9urnb/+CN8s+m/ioTDUCGda3aaxFNR1cvcIyRQAoDkdPEw7jWnWFVC4rVpyaOsm3G4UekEpzxvAI11SPbndjc+ywPnVe1phzPOhaG0GCF4c7vNY9ppb0qd0R/eVsReXZmCNjAnoVZOwRPHn43eXTXekiWoCOVSjm+sBXig4JS9v7cLSctwEsS8KXKBPxo5zVELsndhjnhWbaETJLv0d0SfbjxrGihyaLF6+loW8YH4ueLmsAKWh8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m5aO7uxzSs2A2gncWXqXlICPPPYfrZ3ecnwTDCISS+8=;
 b=UEDMIi4Td2MKjUpvoLwuoJyJ/q8f2/y7x0gyovrA3AmvcqDjEzl4KkjcrdVrHfw5QVlqB69RnqU1tBY4Yk1DJ/yEShcQPTSVfp4eyeWuHSVcOfSa17THb18zhcq/+jwtjyikv09Rv480xVgU5Lg5Se0fNzFnAf8XQhMR85Ddr4I=
Received: from PH7PR17CA0069.namprd17.prod.outlook.com (2603:10b6:510:325::29)
 by CH3PR12MB8186.namprd12.prod.outlook.com (2603:10b6:610:129::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 21:00:11 +0000
Received: from CY4PEPF0000EE36.namprd05.prod.outlook.com
 (2603:10b6:510:325:cafe::1) by PH7PR17CA0069.outlook.office365.com
 (2603:10b6:510:325::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9478.4 via Frontend Transport; Mon, 5
 Jan 2026 21:00:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE36.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.1 via Frontend Transport; Mon, 5 Jan 2026 21:00:10 +0000
Received: from [172.31.132.101] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 5 Jan
 2026 15:00:07 -0600
Message-ID: <c4962282-d9d7-4aa4-8527-f7e42ae8963b@amd.com>
Date: Mon, 5 Jan 2026 15:00:06 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/7] libcxl: Add CXL protocol errors
To: Alison Schofield <alison.schofield@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<dave.jiang@intel.com>
References: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
 <20251215213630.8983-3-Benjamin.Cheatham@amd.com>
 <aUTW1pvDvKMRqWPh@aschofie-mobl2.lan>
Content-Language: en-US
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
In-Reply-To: <aUTW1pvDvKMRqWPh@aschofie-mobl2.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE36:EE_|CH3PR12MB8186:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bd9f55b-42eb-4281-503e-08de4c9d69dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d29DYzhLOTZ4OUM2UXRFVzhlUVphcVlTOC82V0U0Mmp0MUpsNnlsbUgrQzlq?=
 =?utf-8?B?b1gyUlB2dVlHVTNBS3RmZTBIZjlHUEVYaE4yM2FNa3kzWDI1TFpQTUdPWXlr?=
 =?utf-8?B?ZVYyU2lLQmVDcHNvUzIwZjRmczl6a1NQL2lwRHl6aDBsbENTNGJnZktld3ZR?=
 =?utf-8?B?RmtLa1VrYk1LU2c5cHRyY3RCR3RiRHVjOGlPbkUrZnpHVjA3aFV0Yml4SEN6?=
 =?utf-8?B?NmtTUmU4WWpGNnZkUm1vS0o1dDYyODVpaTRqTGRUK2VPLy9vYzhYSTlGbTF3?=
 =?utf-8?B?R2dkb3o4VDlmYzI3R1JLbjZGNGhaZlY1NTFJSllGd2NUNGQwVjRId3NvU1Ar?=
 =?utf-8?B?L0JSZVJTRnA2RDNTdWFnYUV6aS9UeC9STEQ5ME55NmcraDhCWkhvS1B6L2Ev?=
 =?utf-8?B?MUtlTFNsTDZBOGtUanNQbWlvOGJiTjZ3ZmtSaFVKeG84bkg2MnJ2QkpHZkhj?=
 =?utf-8?B?azU5aXdqQlFCRzBmOWE3N2pkZXYvM1V3RFkyb2d2RVo4WjhNbGIvbHRySmNO?=
 =?utf-8?B?L29hTTNtMkxXS3g2bUFUVi8vSXRqc3dGVkRHRi9tOG14SjRVVWJpOGFlQy8v?=
 =?utf-8?B?bkpNUWt0aURPZkxKMDZ2N09Pd1hCSlNERGdmZWpGQVZIcSs2RlgzZk5EalVx?=
 =?utf-8?B?WGpIci8zNVVuT3AvbWc4a3RiSGpNR1JkWnRyc1FkdDY5bmp2Ykt6ZHZoc01y?=
 =?utf-8?B?RGFKUXh1OEVmVVg2OER1TEI3UnQzQ2NkYUdpejA3aWxLTFJvNEtCZW9CNlAr?=
 =?utf-8?B?ZzlyTlpkRThVVmt3SDcwTitJRFVuY1FFeW8zWmQ2a1ROcmQ5d0lIUHM4OEJv?=
 =?utf-8?B?YjZRbmNTZk94MjFjRUovYjErMUROa3RaNTR2MUMwcjgwUHBtQWoyMWpFQzcv?=
 =?utf-8?B?TG53N0RBOHJOOFR1NTRuZ2FMK2NKWTQ4d0pGOVJadzFucUxHd3RqOTl4d2p3?=
 =?utf-8?B?N1R2TjgvQUhET215MHpZRzZCU3lIVFhzQzdGYSsyZS9ZNzFvS0tFeTR3WkNV?=
 =?utf-8?B?V25lM3pYSE1JY3BOOTEvamloQU1WWmsxZ1ZkQXdCNzVESzJMNDBzMTV5RG1a?=
 =?utf-8?B?VURtMXFXalF0cDJJWTNzbmFPczdvdXZiMjJ2S1hpS3hNZURYK1hzWTRZTHh4?=
 =?utf-8?B?TUhmZ3REZGJNVmU3L3VHallneDBIRFlBRVY4TDhaNzJlTUFkU09jajVCS3dK?=
 =?utf-8?B?VkRqcWoxaVlJbVVCcUNFdkVBcVNRR0Jvd2lFbnFwb3ZSN2pVYlgvYzNNWTV2?=
 =?utf-8?B?c2tkaU1wQnU4WlNPT0wxZWZ0dm0rS2dUOVlwNHYxM3lVUlRyRVFJREptZ0tw?=
 =?utf-8?B?SEVuTjhwNGVZK2FpZE9UUy8wRTVoSHR3RnBoSGl6Y1lBSHAwZTk3NlhicnFN?=
 =?utf-8?B?VGx5N1MzOEtkWUo2WnVjMUFjSGY1R1lsNUVtWi92eUJxZ3hhQnFCY1FFLzZ4?=
 =?utf-8?B?SzhqaENYUm1IQjAyYXN4UlRibFQwZy9sR0cwdFZEQ3RFRFV2enhtUVYvZjk1?=
 =?utf-8?B?SGNkaFU0QkhmdTZ2MjYrenlwV2F0bThPL0dkU1ZFbHBaVDdBUmZWc0ttdy82?=
 =?utf-8?B?bFU1RS9TRnFFam1vR2M3Rk1PbHFwWXlLNk9jMjlLbEEwR0hvQlovSmxUT0RZ?=
 =?utf-8?B?Yndac0FjQlhla1dNSmlUdTczYVViQk9zeGkzeFcyMDJPWkZ1aW5tRjNGd1JB?=
 =?utf-8?B?dnJaQWZYczFHazhLYzVUN2RLb3Z2cmpsYTVXRU53Y1BYNXRSb0lFVU5MTzk4?=
 =?utf-8?B?WGNwTUFTZWlYdU4vZTNTUG9HY2l6R3c4UzcrcE1aaU5pVzlIaDdtRHRrNVBt?=
 =?utf-8?B?Zi9vclFkcTNoZ1NQSitMTmY2MGoyNmh0NnZSdmlKaGVXTDlWbnFlaVNvUEha?=
 =?utf-8?B?UWxCL2ZhZ3F3QWZFWkM4ZE9qdW1EK1daYmhIeXZNTlBrVmU2YkFOcy9kUDlL?=
 =?utf-8?B?RS9nV25aYTJjbWhLZUJuTnRHT2VXWlVIUjMreWVaTnpSaDBUeHhrRnZYcmJI?=
 =?utf-8?B?REk4dWhVaXpIc3lGb1kwZ25aVFdGeEdRck0wSEFnNDJzTHNJdXRHSEJibzJB?=
 =?utf-8?B?Y1lUK2FnMm1pZWJBbTcxUHBWNkhxVWt1TWxHZUN4THpxUVp6YjhMS3RkSExw?=
 =?utf-8?Q?+MfE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 21:00:10.1939
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bd9f55b-42eb-4281-503e-08de4c9d69dc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE36.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8186

On 12/18/2025 10:38 PM, Alison Schofield wrote:
> On Mon, Dec 15, 2025 at 03:36:25PM -0600, Ben Cheatham wrote:
> 
> snip
> 
>>  
>> +const struct cxl_protocol_error cxl_protocol_errors[] = {
>> +	CXL_PROTOCOL_ERROR(12, "cache-correctable"),
>> +	CXL_PROTOCOL_ERROR(13, "cache-uncorrectable"),
>> +	CXL_PROTOCOL_ERROR(14, "cache-fatal"),
>> +	CXL_PROTOCOL_ERROR(15, "mem-correctable"),
>> +	CXL_PROTOCOL_ERROR(16, "mem-uncorrectable"),
>> +	CXL_PROTOCOL_ERROR(17, "mem-fatal")
>> +};
> 
> Can the above 'num' fields be the same nums as sysfs emits?
> ie. s/12/0x00001000

Sure! I'll change it.

> 
> Then no BIT(X) needed in the look ups and reads as more obvious
> mapping from sysfs, where it looks like this:
> 
> 0x00001000	CXL.cache Protocol Correctable
> 0x00002000	CXL.cache Protocol Uncorrectable non-fatal
> 0x00004000	CXL.cache Protocol Uncorrectable fatal
> 0x00008000	CXL.mem Protocol Correctable
> 0x00010000	CXL.mem Protocol Uncorrectable non-fatal
> 0x00020000	CXL.mem Protocol Uncorrectable fatal
> 
> A spec reference for those would be useful too.

Will add.

> 
> I notice that the cxl list emit of einj_types reverses the order that
> is presented in sysfs. Would be nice to match.
> 

Yeah, I'll update it.

> 
> snip
>> +
>> +CXL_EXPORT int cxl_dport_protocol_error_inject(struct cxl_dport *dport,
>> +					       unsigned int error)
>> +{
>> +	struct cxl_ctx *ctx = dport->port->ctx;
>> +	char buf[32] = { 0 };
>> +	size_t path_len, len;
>> +	char *path;
>> +	int rc;
>> +
>> +	if (!ctx->debugfs)
>> +		return -ENOENT;
>> +
>> +	path_len = strlen(ctx->debugfs) + 100;
>> +	path = calloc(path_len, sizeof(char));
>> +	if (!path)
>> +		return -ENOMEM;
>> +
>> +	len = snprintf(path, path_len, "%s/cxl/%s/einj_inject", ctx->debugfs,
>> +		      cxl_dport_get_devname(dport));
>> +	if (len >= path_len) {
>> +		err(ctx, "%s: buffer too small\n", cxl_dport_get_devname(dport));
>> +		free(path);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	rc = access(path, F_OK);
>> +	if (rc) {
>> +		err(ctx, "failed to access %s: %s\n", path, strerror(errno));
>> +		free(path);
>> +		return -errno;
>> +	}
>> +
>> +	len = snprintf(buf, sizeof(buf), "0x%lx\n", BIT(error));
>> +	if (len >= sizeof(buf)) {
>> +		err(ctx, "%s: buffer too small\n", cxl_dport_get_devname(dport));
>> +		free(path);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	rc = sysfs_write_attr(ctx, path, buf);
>> +	if (rc) {
>> +		err(ctx, "failed to write %s: %s\n", path, strerror(-rc));
>> +		free(path);
>> +		return -errno;
>> +	}
> 
> Coverity scan reports missing free(path) before return.

Yep, forgot the success case :/.

Thanks,
Ben

> 
> 
>> +
>> +	return 0;
>> +}
>> +

