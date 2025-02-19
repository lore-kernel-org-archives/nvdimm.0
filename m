Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BAE1F3D56
	for <nvdimm@lists.linux.dev>; Wed, 19 Feb 2025 17:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739986497; cv=fail; b=muI7NU/R4WnvxUC9NEt7LAfehKog+q/ozqYIVSwW0Wr+FRq/gHZsIEtNNbG16o7CWK4UcZeFaO8mS60/bnnUry3www+9sMGi5JWCnR6xHIFnq4Rh9V61JIkrQsohTtXI2NUXzS/MPj/2FAqN8n8uz3az3ZQ7oYGPAkcWCbrEzS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739986497; c=relaxed/simple;
	bh=zmzfrKY29yMMFxlxCeVZxA5D1AH65InO1D7mXt8q5u8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=j6D5Bhbpf5WoKNCZUNWppK3Xil8OF14ZG/yFLEiDttkRSx8p1Wbf+S2BDgF8LkU/Pp4xw2aqvOSpnxQpXQI0tBviSGKAnOZKqg7gp5VDLCobA8X8580Ui30lEcFtUEbvAS95nxwcA+GrbLyBHMXvCCcnIXyAgWbzY+B8B5lNueQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XbhX9ZCK; arc=fail smtp.client-ip=40.107.93.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XbhX9ZCK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y6KrfcpT4hj/hzBuIQTyHUlPjCR3tbx0fXPXoE9K01Trtj73qxGj/wR8d4YPXp6xlCzjQ6lYNt5bDbmgDdnUCvI4udM/IKm5Nmswy3GSNS8yWJDVfgf6NCw7B4pfwf23MOhhPiXnizGZS2O6/JWCqP4qO8Ji6VdwkAy9ZJuwTGNKj5RbJ/BWIkBETG+TymdHaqb3x6sf8v7s3URY8LTGWjLQmD21BN6foP2JI/lCCgm2RDC1JvYFgMsI8koGlkRDsiLLQNMXG8QE+pqr4YbT3kJUbm3MW+OwKZ2h3mPSn+7EHYnXeiDsVdaq0lKB5sMCC+AGOY9VStIId3n13+FIzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gLip2IPcfPqgAg9qEiLAZmKWC2JDt/Rmd4enyv4VHDY=;
 b=ymaqh9w/LZeC4oG0QXz/frbRU1DbJBfkPTZaG0CtyRDSQKeucP8L+jOLOMvMHPig7B8sx8pImAdMX0sKQ/joEuv1dMlJ4c7pEOFp8MvYdJhLsHlU7oxa/x+/gQC6NxBHr/8qSwLLaY55QJbEGi5A5W9CfOY75BYrXk0xhZK3tB6akSAxYiN6QG33t3jOMaI5UmfemaCFW7U9/z3OD4sTx1xSlOC0AJW1DeLJiVuDmkGyONZ6u7p5adeedJsG1gYOEX89JdcQMpmw9daYpfEiBZdOnCBtUbyw98ebG5DascFEci5iBNzwT3+9rBles3lzeSzPRvShTmJnLKM+oeOYVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLip2IPcfPqgAg9qEiLAZmKWC2JDt/Rmd4enyv4VHDY=;
 b=XbhX9ZCKk/iK4b0/yUrHpvcFAk9We9fHgzy1LlajUOkW49EtVxDLsDLiHyoCPUbjdsCzNt4ingBwHUHBuIi1rrGIId3benITUcOBH3QOZ1LidFqF+icJBZ5oF3lMfI6Ybs6stMleUtaIGJuGnTU6wTUioMSHJSZibMweqo9WBbw=
Received: from DM6PR13CA0021.namprd13.prod.outlook.com (2603:10b6:5:bc::34) by
 DM4PR12MB8498.namprd12.prod.outlook.com (2603:10b6:8:183::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.15; Wed, 19 Feb 2025 17:34:50 +0000
Received: from DS1PEPF00017097.namprd05.prod.outlook.com
 (2603:10b6:5:bc:cafe::9e) by DM6PR13CA0021.outlook.office365.com
 (2603:10b6:5:bc::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.14 via Frontend Transport; Wed,
 19 Feb 2025 17:34:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017097.mail.protection.outlook.com (10.167.18.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8466.11 via Frontend Transport; Wed, 19 Feb 2025 17:34:49 +0000
Received: from [10.236.177.134] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 19 Feb
 2025 11:34:48 -0600
Message-ID: <9968270b-ad34-401a-ab4f-6d4c6d658d38@amd.com>
Date: Wed, 19 Feb 2025 11:34:47 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC ndctl PATCH] cxl: Add inject-error command
To: Alison Schofield <alison.schofield@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
References: <20250108215749.181852-1-Benjamin.Cheatham@amd.com>
 <Z66J7fW4SXuqFgN_@aschofie-mobl2.lan>
Content-Language: en-US
From: Ben Cheatham <benjamin.cheatham@amd.com>
In-Reply-To: <Z66J7fW4SXuqFgN_@aschofie-mobl2.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017097:EE_|DM4PR12MB8498:EE_
X-MS-Office365-Filtering-Correlation-Id: 26dc7eff-25f5-463d-4461-08dd510bb63a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q1FOR2ZieUMwRFRNdWVlZ0xNdGV1cmo2dDhKTktROCsxUStKaHJjcWgzNHEw?=
 =?utf-8?B?WC9oMzhxV3F6dnhoSzZhdDlwRFB4ajVHOW5KelhOc2JvMkxsTHZXQkpXNWsy?=
 =?utf-8?B?U2FwZkdPZUVEUjdVOUlEczZKZ2UzN0Vack5odWwySkZ2NHUzeCt6RU9EYTRW?=
 =?utf-8?B?cEk2UWJhU29EaEd1TGNTdkhoTW1QazU0RTZIRnhzcHVZL2k4M29qS2RKcUY4?=
 =?utf-8?B?bTdFME9xbUNkeTNWa29yZUJ4S0pValVmUFloUGFvc2l6ZlA5MnlxU1RUMmdP?=
 =?utf-8?B?d1pscHlVSlJJb0pvSXRkU3d0ZkZTTzN2akN6c3BRMnR1akxuUFBxRy9iRGNH?=
 =?utf-8?B?TEZ1SFNqYjNXQndsdmlEY3lJU05XVUR1WGVvUTFsNGN4cDBXMS9RSmlEaTNJ?=
 =?utf-8?B?bTdYQk9pbjBpRDB3cHUrcnVxUUlYOUh6ZnFqNUkzNzNCVlRyWlhqNEFVY2Zw?=
 =?utf-8?B?N0JOdFVUbkFPMkpBZ3RUcVdQRGxyYmJTODQ3bkVUQkMvWGxtK0R0NzFEZEc2?=
 =?utf-8?B?TU4zMGc0VlBNeVVZWGpzc2piZVp2eC9KTWxKaHQyOExiaFFDdUlmNVIxMEpR?=
 =?utf-8?B?MmgrQ2Q4NDk1cUUxU2hldThJMkgzYU5BTUplQXhCelNjSkk4TXM5bk9Wd0Jp?=
 =?utf-8?B?L2V2ZmIzMitQUWRKVUo3elVpZEVyT1ZOeXJsYW1sOTRmTGZ4MHdEb2wya01P?=
 =?utf-8?B?NVgrd2lId3Y1QWdBS1lLUEJlWjZlQVI1eTdnS2JOS0Eza2tncnF0NWVTM2p4?=
 =?utf-8?B?Q1JJOVJpdElUcEJIWFh1eVlqYUV1UVpLb3FwQjdkaFlwWHkxK2RBZ1pqWnFz?=
 =?utf-8?B?c3VKN1NzUHZXVHJZZ2hORi8rMitGSnhFQjg1dE8vSnluUHd6cHRLbWd4NkJB?=
 =?utf-8?B?WFUzc2JleW5IUm5lVUZGWDZKUUxuSnE5Y1prVDdjMkZ5T1hmZTllUDgxT0pI?=
 =?utf-8?B?SVNIWXNObkpRSEtFc3lUY21ZM0VtVGVobHZ6UkRUMTlvdk4yUTB4VWZRQi9k?=
 =?utf-8?B?ZGRQOFVLdUYwdzVaak1KZXJQdkNKeUE5V285WVVkMGsxdFpHNnNkZzlDakx4?=
 =?utf-8?B?dEpIaTNEempVWjNXVkV1b0FNWW5pR2haU3drbjZCcWVLRkdIU3lqSHJEUGlO?=
 =?utf-8?B?YTlNUE5WZkFGaFhkclc4OEp5Mzh0alV5VFdXbVczOEFLYU1DNUZkd2xhQnd4?=
 =?utf-8?B?SXJPM3hYZ0NkRDBER2VsbmtlVVJwZ28yd2pURUFvbitpUCt3N215YWpKTUkx?=
 =?utf-8?B?eWJoSkhUd1J4bm0yNUdHZVZNL3FRYTNYZlB4YkVoSDRIUzVQSTRTbC82UWQy?=
 =?utf-8?B?TXRxRGFxSjdvUDc5Tk5KbFhqaXdZTzhPaGY3eFBZdHhGMFZKbHY0VHlNVUNB?=
 =?utf-8?B?V2tvTDdPU1ZHeXBnWGxYeHArTVJXZnlmOVNtRVlMUlpkdHpWVzBBQndnb0lk?=
 =?utf-8?B?WlpZWDlwMkszb2V6U2tWN0lMajJxTisrNGc4RmVFbE83cFY3Sk9ya1ZaSHBm?=
 =?utf-8?B?dHRFUFdDWnZxZ3FhRFhocVlCdjMxYVNtcU9Ccm5Vanh1cnFBS1R4MmJkSGYx?=
 =?utf-8?B?SFBjMmo3TUxhNHY3RzcxVU04TmR4cXNhTkQ4WDFaMVl3bnVPN3VpYTc3aXo4?=
 =?utf-8?B?TS90VzVUNTlqSHlsL2Q1QWFRT1VRK3FEZ25WdEFpSWpVUTZuL2U1YnB4aGpG?=
 =?utf-8?B?SCtlWmhuWFhSZy9SZ1cwRklrR1hISm1zaTVtRm0vd0ZYaER2Tkt1OHpidmpC?=
 =?utf-8?B?ZC9nU0wzUjVTK2F0VkZhYlptY3ptdGgweHVMZ0dldkJNbGl6eHRqNmJmOC9G?=
 =?utf-8?B?dkpiUHRCOE1uRWVWTS9lSnNJRDVDNGFacWgyeHdoNzI3R04rSldSb25IQjNx?=
 =?utf-8?B?cmQzSjh2MmpyOXFLRXcrYVQ1VmR2K1Z6L052bGRJM0dPUnA1V1YvOXhKTnl4?=
 =?utf-8?B?ZFdKemtMWFJmbnllaVhmT0pBbzZVSEZBNkwxK0pZZkRrYUY2czVlQ3dhT3BP?=
 =?utf-8?Q?cGkJo81CG57nPlQ0HdCLsutpjk81JY=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 17:34:49.9302
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26dc7eff-25f5-463d-4461-08dd510bb63a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017097.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8498

Hi Alison, sorry it took me so long to respond I've been a bit sick. Responses inline.

On 2/13/25 6:10 PM, Alison Schofield wrote:
> On Wed, Jan 08, 2025 at 03:57:49PM -0600, Ben Cheatham wrote:
>> Add inject-error command for injecting CXL errors into CXL devices.
>> The command currently only has support for injecting CXL protocol
>> errors into CXL downstream ports via EINJ.
> 
> Hi Ben,
> I went through enough to give you some feedback for your v1.
> Just ran out of time and didn't want to keep you waiting any longer.
> 
> wrt 'currently only has' - what is the grander scope of this that we
> might see in the future. Will there only every be one system wide
> response to --list-errors or will there be error types per type of
> port.
> 

My thinking was that it would be a command to do any type of CXL-related error
injection. At the moment, that would be poison and protocol error injection,
but I wanted to leave it open-ended in case something else came along in later
spec revisions.

As for the --list-errors, it'll probably be per type of port. I think I see where
you're going with that, I can look into that option taking an argument for the type
of the component.

> Spec reference?
> 

Protocol EINJ is defined starting in the ACPI v6.5 spec, section 18.6.4. I'll add
references in the commit message(s) and code comments.

>>
>> The command takes an error type and injects an error of that type into the
>> specified downstream port. Downstream ports can be specified using the
>> port's device name with the -d option. Available error types can be obtained
>> by running "cxl inject-error --list-errors".
>>
>> This command requires the kernel to be built with CONFIG_DEBUGFS and
>> CONFIG_ACPI_APEI_EINJ_CXL enabled. It also requires root privileges to
>> run due to reading from <debugfs>/cxl/einj_types and writing to
>> <debugfs>/cxl/<dport>/einj_inject.
>>
>> Example usage:
>>     # cxl inject-error --list-errors
>>     cxl.mem_correctable
>>     cxl.mem_fatal
>>     ...
>>     # cxl inject-error -d 0000:00:01.1 cxl.mem_correctable
>>     injected cxl.mem_correctable protocol error
>>
> 
> I'll probably ask this again later on, but how does user see
> list of downstream ports. Does user really think -d dport,
> or do they think -d device-name, or ?
> Man page will help here.
> 

I went back and forth on whether to use '-d' or '-s' (to follow lspci), but
ended up on '-d' since the dport device name isn't necessarily a PCIe SBDF.
I don't mind changing it if you have a better suggestion.

I'll also add a man page next time.

> We don't have cxl-cli support for poison inject, but to future
> proof this, let's think about the naming.
> 
> Please split the patch up at least into 2 -
> libcxl: Add APIs supporting CXL protocol error injection
>         include updates to Documentation/cxl/lib/libcxl.txt
> 
> cxl: add {list,inject}-protocol-error' commands
>      include man page updates, additiona
> 

Will do.

> The 'list-errors' is the the system level error support, right?
> Could that fit in the existing 'cxl list' hierachy?
> Would they be a property of the bus?

The errors listed by '--list-errors' are the CXL-related EINJ error types
(ACPI v6.5, table 18.30). These error types are provided by the ACPI EINJ
implementation and are system-wide AFAIK. So that wouldn't be a problem for
adding them as a bus property, but the issue with that is these error types
are meant to be used on CXL-capable PCIe root ports.

I think it may be confusing to list these under a bus, and I wouldn't want to muddy
up the appropriate dport entries since there can techincally be up to 6 of these error
types (and the names are a bit long). If you think that's preferable, or adding it
as a bus property is fine, I'd be happy to do so.

> 
> I don't know that 'protocol' is best name, but seems it needs
> another descriptor.
> 

I just took the names from the spec, if you have a suggestion here I'd be happy
to hear it!

> 
>> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
>> ---
>>  cxl/builtin.h      |   1 +
>>  cxl/cxl.c          |   1 +
>>  cxl/inject-error.c | 188 +++++++++++++++++++++++++++++++++++++++++++++
>>  cxl/lib/libcxl.c   |  53 +++++++++++++
>>  cxl/lib/libcxl.sym |   2 +
>>  cxl/libcxl.h       |  13 ++++
>>  cxl/meson.build    |   1 +
>>  7 files changed, 259 insertions(+)
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
>> index 1643667..f808926 100644
>> --- a/cxl/cxl.c
>> +++ b/cxl/cxl.c
>> @@ -79,6 +79,7 @@ static struct cmd_struct commands[] = {
>>  	{ "enable-region", .c_fn = cmd_enable_region },
>>  	{ "disable-region", .c_fn = cmd_disable_region },
>>  	{ "destroy-region", .c_fn = cmd_destroy_region },
>> +	{ "inject-error", .c_fn = cmd_inject_error },
>>  	{ "monitor", .c_fn = cmd_monitor },
>>  };
>>  
>> diff --git a/cxl/inject-error.c b/cxl/inject-error.c
>> new file mode 100644
> 
> Can this fit in an existing file?  port.c ?

I just put it into a new file since it's a new command. The functionality in the
file ATM could probably fit, but my idea was this command would eventually not just
do dport protocol error injection.

> 
> I didn't review this file yet, so snipping.
> 
> 
>> index 0000000..3645934
>> --- /dev/null
>> +++ b/cxl/inject-error.c
> 
> snip
> 
>> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
>> index 91eedd1..8174c11 100644
>> --- a/cxl/lib/libcxl.c
>> +++ b/cxl/lib/libcxl.c
>> @@ -3179,6 +3179,59 @@ CXL_EXPORT int cxl_dport_get_id(struct cxl_dport *dport)
>>  	return dport->id;
>>  }
>>  
>> +CXL_EXPORT int cxl_dport_inject_proto_err(struct cxl_dport *dport,
>> +					  enum cxl_proto_error_types perr,
>> +					  const char *debugfs)
>> +{
>> +	struct cxl_port *port = cxl_dport_get_port(dport);
>> +	size_t path_len = strlen(debugfs) + 24;
> 
> What's the path_len math, +24 here and +16 in next fcn.
> I notice other path calloc's in this file padding more, ie +100 or +50.
> 

Taking another look at it, I can't remember why they are different :/. If I
had to guess I was adding the length of the sysfs attribute (i.e. "einj_inject")
+ a bit. I'll change this to just add +50 or so when I get to the calloc call
instead of doing it at the top (and also make it uniform between functions).

> 
>> +	struct cxl_ctx *ctx = port->ctx;
>> +	char buf[32];
>> +	char *path;
>> +	int rc;
>> +
>> +	if (!dport->dev_path) {
>> +		err(ctx, "no dev_path for dport\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	path_len += strlen(dport->dev_path);
>> +	path = calloc(1, path_len);
>> +	if (!path)
>> +		return -ENOMEM;
>> +
>> +	snprintf(path, path_len, "%s/cxl/%s/einj_inject", debugfs,
>> +		 cxl_dport_get_devname(dport));
>> +
>> +	snprintf(buf, sizeof(buf), "0x%lx\n", (u64) perr);
> 
> Here, and in cxl_get_proto_errors(), can we check for the path and
> fail with 'unsupported' if it doesn't exist. That'll tell folks
> if feature is not configured, or not enabled ?
> Are kernel configured and port enabled 2 different levels?

For sure. If you have the kernel configured to use CXL EINJ these files
come up as part of CXL driver init (specifically when cxl_dports are initialized).

It's possible the CXL driver will come up before EINJ is initialized, in which case
the sysfs files won't be visible. I've only seen that happen when both the EINJ module
and CXL module(s) are built-in. In general though, if the kernel is configured correctly
and the CXL driver doesn't run into any issues these files should be present.

> 
> There's an example in this file w "if (access(path, F_OK) != 0)"
> 
> 
>> +	rc = sysfs_write_attr(ctx, path, buf);
>> +	if (rc)
>> +		err(ctx, "could not write to %s: %d\n", path, rc);
> 
> for 'sameness' with most err's in this library, do:
>         err(ctx, "failed write to %s: %s\n", path, strerr(-rc));
> 

Will do!

>> +
>> +	free(path);
>> +	return rc;
>> +}
>> +
>> +CXL_EXPORT int cxl_get_proto_errors(struct cxl_ctx *ctx, char *buf,
>> +				    const char *debugfs)
>> +{
>> +	size_t path_len = strlen(debugfs) + 16;
>> +	char *path;
>> +	int rc = 0;
>> +
>> +	path = calloc(1, path_len);
>> +	if (!path)
>> +		return -ENOMEM;
>> +
>> +	snprintf(path, path_len, "%s/cxl/einj_types", debugfs);
>> +	rc = sysfs_read_attr(ctx, path, buf);
>> +	if (rc)
>> +		err(ctx, "could not read from %s: %d\n", path, rc);
>> +
> 
> same comments as previous, check path and make err msg similar
> 

Ok!

> 
>> +	free(path);
>> +	return rc;
>> +}
>> +
>>  CXL_EXPORT struct cxl_port *cxl_dport_get_port(struct cxl_dport *dport)
>>  {
>>  	return dport->port;
>> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
>> index 304d7fa..d39a12d 100644
>> --- a/cxl/lib/libcxl.sym
>> +++ b/cxl/lib/libcxl.sym
>> @@ -281,4 +281,6 @@ global:
>>  	cxl_memdev_get_ram_qos_class;
>>  	cxl_region_qos_class_mismatch;
>>  	cxl_port_decoders_committed;
>> +	cxl_dport_inject_proto_err;
>> +	cxl_get_proto_errors;
>>  } LIBCXL_6;
> 
> Start a new section above for these new symbols.
> Each ndctl release gets a new section - if symbols added.
> 

Gotcha, I'll add it.

> 
> 
>> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
>> index fc6dd00..867daa4 100644
>> --- a/cxl/libcxl.h
>> +++ b/cxl/libcxl.h
>> @@ -160,6 +160,15 @@ struct cxl_port *cxl_port_get_next_all(struct cxl_port *port,
>>  	for (port = cxl_port_get_first(top); port != NULL;                     \
>>  	     port = cxl_port_get_next_all(port, top))
>>  
>> +enum cxl_proto_error_types {
>> +	CXL_CACHE_CORRECTABLE = 1 << 12,
>> +	CXL_CACHE_UNCORRECTABLE = 1 << 13,
>> +	CXL_CACHE_FATAL = 1 << 14,
>> +	CXL_MEM_CORRECTABLE = 1 << 15,
>> +	CXL_MEM_UNCORRECTABLE = 1 << 16,
>> +	CXL_MEM_FATAL = 1 << 17,
>> +};
> 
> Please align like enum util_json_flags
> Is there a spec reference to add?

Will do, and I'll add the reference as well.

Thanks,
Ben

> 
> That's all.
> -- Alison
> 
> 
> 
>> +
>>  struct cxl_dport;
>>  struct cxl_dport *cxl_dport_get_first(struct cxl_port *port);
>>  struct cxl_dport *cxl_dport_get_next(struct cxl_dport *dport);
>> @@ -168,6 +177,10 @@ const char *cxl_dport_get_physical_node(struct cxl_dport *dport);
>>  const char *cxl_dport_get_firmware_node(struct cxl_dport *dport);
>>  struct cxl_port *cxl_dport_get_port(struct cxl_dport *dport);
>>  int cxl_dport_get_id(struct cxl_dport *dport);
>> +int cxl_dport_inject_proto_err(struct cxl_dport *dport,
>> +			       enum cxl_proto_error_types err,
>> +			       const char *debugfs);
>> +int cxl_get_proto_errors(struct cxl_ctx *ctx, char *buf, const char *debugfs);
>>  bool cxl_dport_maps_memdev(struct cxl_dport *dport, struct cxl_memdev *memdev);
>>  struct cxl_dport *cxl_port_get_dport_by_memdev(struct cxl_port *port,
>>  					       struct cxl_memdev *memdev);
>> diff --git a/cxl/meson.build b/cxl/meson.build
>> index 61b4d87..79da4e6 100644
>> --- a/cxl/meson.build
>> +++ b/cxl/meson.build
>> @@ -7,6 +7,7 @@ cxl_src = [
>>    'memdev.c',
>>    'json.c',
>>    'filter.c',
>> +  'inject-error.c',
>>    '../daxctl/json.c',
>>    '../daxctl/filter.c',
>>  ]
>> -- 
>> 2.34.1
>>
>>
