Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010068.outbound.protection.outlook.com [52.101.201.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1E32DEA90
	for <nvdimm@lists.linux.dev>; Mon,  5 Jan 2026 21:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767647602; cv=fail; b=E7KN3AdY1TiDMCDP9LKDCBY3IoJU6rlZa9n7I/xkza1SqLgM/biQx3oyBTHZhejqHxLQEYxnqw52NTWMgks+vUgdBeC2Kfd+xK7nlqEbFDuBAX3WW4ikbB+PiSw2qk97WNG5xuBSiAWao/uVR2DiE3urGN/Ceg1d48xEayqz5eQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767647602; c=relaxed/simple;
	bh=dRHDXdNZFvyit0kGaiT9RmwuILxFH70h7zjjYKjZXJs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=KoInUwPdL6oyi6GDpHh+SlFTJfaEq0rEjQburbdgk32q6FamyOhcKSuJsMoeRW5cyjANJrSeXVIesW1dR/wElDazTZNwBKRR0EdJBkOhIKfBO17A1c0jYApELFpfVl6F5lOkBBZPMaMLFRz7mXF2SKhy+1LB2umqZdY/7Is4BfU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=G6aZMMED; arc=fail smtp.client-ip=52.101.201.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="G6aZMMED"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hFVR/5yzQX03QlJdDTU1uNULh/qqfuZK4FpV66Zu3uo2B6M6FP3wrYZuSOxFouOF+oGSUEDXfr4+PF2/xbNfydO/AM7UHB2XuErXsuUL5nBlooDRhZ5oIdkTJTM9Od6hc246/4PvfX+f5/Kx47B6xsOnIMaeo/jmhfU4gRGAAbxu1ZaFfH0CGNO2epWn65j4u6HG+TAv28FGmnjhKcxu9xnyDyx1zwdcsbKOwQJ4XJE3KWetHba6h/jupV2+wcEAdhW9VICnkPyxb2yofA/xUx+vIeCaDO42sI4WDSmGSPa/plluMNN8EJA7kF8DD4/nz68TlsrJb2rUNpNE76w46Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aiDR3Bby6ogfwKfO48mR+aqiokMf3wxDmSf2Nuy0lbU=;
 b=gnEibHZ7xq+MhwzggK1lXq8LT8WZDMKntV7H8YC6ptlLS8IzaqY5R9GBZSAfuuoquMswecNtaWlvpTQ+VQbZ4A6jfmH/hrmdWUOrKKdCYUOmpXiNBtP/mIvZovoHWcUyRMgrw/+GY/7TXXfNpwQEI+gkZtRGXKA49wNM2JkuVElFlg1yHFB10rpo4P5XWEqC9aRxy75wyItrLB6oZVIl+HmtGbKtRES6Uk4gTVGnkUTCCdIeiiP9BofwThr66UYMN8OTtDVKssJHMjgZS3e7U7sfCl2740pudV7dJygHGiKN2Xd79poVcjyE0ouwXY3HegVl0MMUXJyIDd0neojg2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aiDR3Bby6ogfwKfO48mR+aqiokMf3wxDmSf2Nuy0lbU=;
 b=G6aZMMEDOWHYCjzKyfOYpkAXdGbW/P57as3pJxacBc9VlSxpr+/Ov9DdH0MBn/+tJhKBC116cIxQiBlg4xFRp3b4aCK3pqBpPbaiDYs7kh+Jk5QrKlk15YubDyFUdbY9xAUHRkontgLjs9QKCdwxfnxJN+gbJ5/Uwlnmt4nDCow=
Received: from BN0PR10CA0015.namprd10.prod.outlook.com (2603:10b6:408:143::33)
 by PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 21:13:11 +0000
Received: from BN1PEPF0000468E.namprd05.prod.outlook.com
 (2603:10b6:408:143:cafe::9a) by BN0PR10CA0015.outlook.office365.com
 (2603:10b6:408:143::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9478.4 via Frontend Transport; Mon, 5
 Jan 2026 21:13:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF0000468E.mail.protection.outlook.com (10.167.243.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.1 via Frontend Transport; Mon, 5 Jan 2026 21:13:11 +0000
Received: from [172.31.132.101] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 5 Jan
 2026 15:13:09 -0600
Message-ID: <3eae10e0-0203-4cce-b060-88c69b2e2f41@amd.com>
Date: Mon, 5 Jan 2026 15:13:03 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 7/7] Documentation: Add docs for inject/clear-error
 commands
To: Alison Schofield <alison.schofield@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<dave.jiang@intel.com>
References: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
 <20251215213630.8983-8-Benjamin.Cheatham@amd.com>
 <aUTaIPvIeILjEnnI@aschofie-mobl2.lan>
Content-Language: en-US
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
In-Reply-To: <aUTaIPvIeILjEnnI@aschofie-mobl2.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468E:EE_|PH7PR12MB5712:EE_
X-MS-Office365-Filtering-Correlation-Id: ac09ede5-03bd-4055-75a4-08de4c9f3b4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Ylc1TENlbmtuMnlvamdJVVNCQTZqUG9vSFlCZVdDS2MzRlRhOEZZaVRIQk1u?=
 =?utf-8?B?RGFRSmo4QTJ1NXBqMUREb2M1V1ZHeDd5TzZ4c0tmMjVWNkdEVGNBUmJkS3Nj?=
 =?utf-8?B?WTZLNnphVU1OaWhONUpXM1ZjeDNXT1U3SWViQzNaVExWQ3JNb20xNTBidUEx?=
 =?utf-8?B?Zzd5RHZlbHNRcGFOT2dxNnhvaFg1QWo4emc3WituSW5aRTVVeHdNRm1odzZD?=
 =?utf-8?B?b29UOGpqajM1UktQSFp4cFBGZklOemZDY3lyYVVVaU5wdGw4WDRCVzdkaFRw?=
 =?utf-8?B?RjZRdG9IZ1Ziakl0b1BuRS9xOXNweXJEbHBSdG9yQXBUK2k0R3NTYkpxbkFH?=
 =?utf-8?B?cElqYVlGYnd3N2RFN3N4cmFSTU5BL2RuUXIxODVBZ01nVjROMjNvVzNMUm5i?=
 =?utf-8?B?VE13QmlCVnFjNktWdzM1Wk9qeHBabmY0WERJTlVVSHl3bDRBazkwQUFZYStp?=
 =?utf-8?B?M3hjZkNPZjBVQnZnWWdJTDBlczhDUmlUY1dGUTBUMTZaK09iWVE4QVJkdC9z?=
 =?utf-8?B?MXVRdUxFMW94S3ZxZ0xmNUZoN0VMOGZRUE9tU1BnZk4xYXJOL1UwN1pTekpF?=
 =?utf-8?B?MWg1dHlHVnNwWUpMdDFRNDh1THJ5a0JJOVIyNGx6YWNQa1pkVGkvdVZoVkJZ?=
 =?utf-8?B?V1ovbVZFdTlvNCtUSFEvOGd6eEF1NFVZQ2I0QTUrK1cxOTdwNDNETkRMVDFs?=
 =?utf-8?B?MFNZSC9xdVVZa2xWd05QcDlRMm9vVlozN3hWWDcyWWVtdktBWXFpdXllQ3h5?=
 =?utf-8?B?Zms5d1ZkWGRzQTR6b01FWm9Xb1BWM04zYmtZUmo3UkloQlNGVmh2eWpCMWNt?=
 =?utf-8?B?ZlE4MEZUNkhQQUtJWmlLblRqbXNuT3UwTmtpaFQ1SHdXdjlGTm1BVFpyNEpU?=
 =?utf-8?B?VnU2bUxEaG91MHFwcFZ2ZkxxUnAzSEZYZkRURDBUM2ZvT0c0RFcrTVo1dklF?=
 =?utf-8?B?b0dZOXc0SHhJUFJ2Yi8xWE5VMmFCTnRUNkU0Ni9sNUJzMkd4dzFtNk1lWG8z?=
 =?utf-8?B?VzBLUXNNazZHMHFVY3UyWjdKNmxIc1Z6citBb092VmE1UjhjWGlaZGR5TS9M?=
 =?utf-8?B?OEhibkxLVXEzVmlkUUFqaVYxVU9wb1d1ZjdYbFRKSXFDT3RXRmZjODRTOFBK?=
 =?utf-8?B?R2ZmQkU3SFlCMGVTdWFHMVBKa2JCekNod2lLQWhranptaHRQNWRXTTN6Y2Jv?=
 =?utf-8?B?UFFobUVMblNPVGhHS2tTdjJsUWVDV1dReDFKY2FBcjN2UGpVY1FuR1lBdkpH?=
 =?utf-8?B?R1p6MHlSVGNQVVY1VVJ5Y09DQ3YrT3d4MXRzWi9LeDFDM1plenhYMXRtQmZM?=
 =?utf-8?B?b3ZHSXlQT1RqMStWVXNnb0hxaHlFZGoveC9wNjFLY3JxWTJMenMwRURBVGJl?=
 =?utf-8?B?cGo2ZGNOU3JkM0tKaGNOcTJ4MW9UL3AxbkpNZXdndVNUWmRaQWxQeEc5MFI0?=
 =?utf-8?B?NDdDRkFwZWczMG02M3VzZGlyZWorNHVEaVJ3a0x3WDU3cDdyZ1BFN29ITndj?=
 =?utf-8?B?dUYrcndBQ0Facm8zZTRsVmlId1lzdjVWZVVONXg5d2VveDhMbnJiSWhKbmxO?=
 =?utf-8?B?R1g5d0xkMkxWbTkra0orTGhZQnpVWGJQWTVIbTVWSVJIbzgyR1VyWEtucVZW?=
 =?utf-8?B?Q3JDYWRKalVNVUZaOTg3QjN3SU05UWZCOHp0Q3NLL2hScXUvdEZmSzJIbHpD?=
 =?utf-8?B?Qzc1RitXR2lVdkJqVkY1U2Z6SU9xYWJxc0g4dVNYOVdRL3hEUFlFYmJMWXlz?=
 =?utf-8?B?RS94MGRlR2ZlS2NFNWoyMnN3U0U2U3lBc2FHWUZOSjdzUk9teitLUGRFdWJw?=
 =?utf-8?B?Wndjb3htNUxHbW5iRUdsaGxVUGVrT3pTQVJTdldJZFpqc2o5QzFUV1pNbWZx?=
 =?utf-8?B?VFdCZ01UVkIxRktXUGN2VWZTWE16d1NiYUdnbW5Wc25rUCtuRkRHYkFza0dV?=
 =?utf-8?B?bm5nOUdGY053aUhSVWJqUDd6S25lR1BuVWtieGpEbFRzdWVjeXlDN05MUlIw?=
 =?utf-8?B?b3k0NHNGR1Q4eG9FMVc4RVY3UEhJdWpFdHlSME1iQ01Hamo2WDVGcDlVcGVl?=
 =?utf-8?Q?bKaW41?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 21:13:11.1314
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac09ede5-03bd-4055-75a4-08de4c9f3b4f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5712



On 12/18/2025 10:52 PM, Alison Schofield wrote:
> On Mon, Dec 15, 2025 at 03:36:30PM -0600, Ben Cheatham wrote:
>> Add man pages for the 'cxl-inject-error' and 'cxl-clear-error' commands.
>> These man pages show usage and examples for each of their use cases.
>>
>> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
>> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
>> ---
>>  Documentation/cxl/cxl-clear-error.txt  |  67 +++++++++++++
>>  Documentation/cxl/cxl-inject-error.txt | 129 +++++++++++++++++++++++++
>>  Documentation/cxl/meson.build          |   2 +
>>  3 files changed, 198 insertions(+)
>>  create mode 100644 Documentation/cxl/cxl-clear-error.txt
>>  create mode 100644 Documentation/cxl/cxl-inject-error.txt
> 
> snip
> 
>> diff --git a/Documentation/cxl/cxl-inject-error.txt b/Documentation/cxl/cxl-inject-error.txt
>> new file mode 100644
>> index 0000000..e1bebd7
>> --- /dev/null
>> +++ b/Documentation/cxl/cxl-inject-error.txt
>> @@ -0,0 +1,129 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>> +cxl-inject-error(1)
>> +===================
>> +
>> +NAME
>> +----
>> +cxl-inject-error - Inject CXL errors into CXL devices
>> +
>> +SYNOPSIS
>> +--------
>> +[verse]
>> +'cxl inject-error' <device name> [<options>]
>> +
>> +Inject an error into a CXL device. The type of errors supported depend on the
>> +device specified. The types of devices supported are:
>> +
>> +"Downstream Ports":: A CXL RCH downstream port (dport) or a CXL VH root port.
>> +Eligible CXL 2.0+ ports are dports of ports at depth 1 in the output of cxl-list.
>> +Dports are specified by host name ("0000:0e:01.1").
> 
> How are users to find that dport host?

The user needs to know beforehand at the moment. More below.

> 
> Is there a cxl list "show me the dports where i can inject protocol errors"
> incantation that we can recommend here.
> 
> I ended up looking at /sys/kernel/debug/cxl/ to find the hosts.
> 
> Would another attribute added to those dports make sense, be possible?
> like is done for the poison injectable memdevs?  ie 'protocol_injectable: true'

Which ports support error injection depends on the CXL version of the host. For CXL 1.1
hosts it's any memory-mapped downstream port, while for 2.0+ it's only CXL root ports
(ACPI 6.5 Table 18-31).

The kernel adds a debugfs entry for all downstream ports regardless of those requirements IIRC.
Having the extra entries doesn't break anything since the platform firmware should reject invalid
injection targets, but it does add an extra hurdle for the user.

I think what I'll do here is submit a kernel patch to clean up the extra entries (needed to be done anyway)
and add a 'protocol_injectable' attribute for the downstream port when a debugfs entry exists. I'll probably
send out the kernel patch at the same time as v6.

Let me know if any of that sounds unreasonable or you'd rather I do something else!

Thanks,
Ben
> 
> 
>> +"memdevs":: A CXL memory device. Memory devices are specified by device name
>> +("mem0"), device id ("0"), and/or host device name ("0000:35:00.0").
>> +
>> +There are two types of errors which can be injected: CXL protocol errors
>> +and device poison.
>> +
>> +CXL protocol errors can only be used with downstream ports (as defined above).
>> +Protocol errors follow the format of "<protocol>-<severity>". For example,
>> +a "mem-fatal" error is a CXL.mem fatal protocol error. Protocol errors can be
>> +found with the '-N' option of 'cxl-list' under a CXL bus object. For example:
>> +
>> +----
>> +
>> +# cxl list -NB
>> +[
>> +  {
>> +	"bus":"root0",
>> +	"provider":"ACPI.CXL",
>> +	"injectable_protocol_errors":[
>> +	  "mem-correctable",
>> +	  "mem-fatal",
>> +	]
>> +  }
>> +]
>> +
>> +----
>> +
>> +CXL protocol (CXL.cache/mem) error injection requires the platform to support
>> +ACPI v6.5+ error injection (EINJ). In addition to platform support, the
>> +CONFIG_ACPI_APEI_EINJ and CONFIG_ACPI_APEI_EINJ_CXL kernel configuration options
>> +will need to be enabled. For more information, view the Linux kernel documentation
>> +on EINJ.
>> +
>> +Device poison can only by used with CXL memory devices. A device physical address
>> +(DPA) is required to do poison injection. DPAs range from 0 to the size of
>> +device's memory, which can be found using 'cxl-list'. An example injection:
>> +
>> +----
>> +
>> +# cxl inject-error mem0 -t poison -a 0x1000
>> +poison injected at mem0:0x1000
>> +# cxl list -m mem0 -u --media-errors
>> +{
>> +  "memdev":"mem0",
>> +  "ram_size":"256.00 MiB (268.44 MB)",
>> +  "serial":"0",
>> +  "host":"0000:0d:00.0",
>> +  "firmware_version":"BWFW VERSION 00",
>> +  "media_errors":[
>> +    {
>> +      "offset":"0x1000",
>> +      "length":64,
>> +      "source":"Injected"
>> +    }
>> +  ]
>> +}
>> +
>> +----
>> +
>> +Not all devices support poison injection. To see if a device supports poison injection
>> +through debugfs, use 'cxl-list' with the '-N' option and look for the "poison-injectable"
>> +attribute under the device. Example:
>> +
>> +----
>> +
>> +# cxl list -Nu -m mem0
>> +{
>> +  "memdev":"mem0",
>> +  "ram_size":"256.00 MiB (268.44 MB)",
>> +  "serial":"0",
>> +  "host":"0000:0d:00.0",
>> +  "firmware_version":"BWFW VERSION 00",
>> +  "poison_injectable":true
>> +}
>> +
>> +----
>> +
>> +This command depends on the kernel debug filesystem (debugfs) to do CXL protocol
>> +error and device poison injection.
>> +
>> +OPTIONS
>> +-------
>> +-a::
>> +--address::
>> +	Device physical address (DPA) to use for poison injection. Address can
>> +	be specified in hex or decimal. Required for poison injection.
>> +
>> +-t::
>> +--type::
>> +	Type of error to inject into <device name>. The type of error is restricted
>> +	by device type. The following shows the possible types under their associated
>> +	device type(s):
>> +----
>> +
>> +Downstream Ports: ::
>> +	cache-correctable, cache-uncorrectable, cache-fatal, mem-correctable,
>> +	mem-fatal
>> +
>> +Memdevs: ::
>> +	poison
>> +
>> +----
>> +
>> +--debug::
>> +	Enable debug output
>> +
>> +SEE ALSO
>> +--------
>> +linkcxl:cxl-list[1]
>> diff --git a/Documentation/cxl/meson.build b/Documentation/cxl/meson.build
>> index 8085c1c..0b75eed 100644
>> --- a/Documentation/cxl/meson.build
>> +++ b/Documentation/cxl/meson.build
>> @@ -50,6 +50,8 @@ cxl_manpages = [
>>    'cxl-update-firmware.txt',
>>    'cxl-set-alert-config.txt',
>>    'cxl-wait-sanitize.txt',
>> +  'cxl-inject-error.txt',
>> +  'cxl-clear-error.txt',
>>  ]
>>  
>>  foreach man : cxl_manpages
>> -- 
>> 2.52.0
>>

