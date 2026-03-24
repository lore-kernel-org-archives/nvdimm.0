Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011070.outbound.protection.outlook.com [40.93.194.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9803A4535
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 05:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774331198; cv=fail; b=ERniG0Ml3e+fHo6GZq70BfO/TStz8rAQNKSFFKD2OgT1R4UuO3QiJYc7OSpLtaYWA2DtlEfAZrXZa0HP380tHll7ClLcHzt7TstEBZxcxjSXU06rmw2ucaYC8/hqc9JOSDjXxDl0mWzzfMtp6o2RWsLovcadCiu4RmmPbfb15pE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774331198; c=relaxed/simple;
	bh=JqQXiLuSvghYg6+N/4bf1lbE1I8PVEYIjr/1mI3jLSI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r86DBM/e2tCodZnJDrvjpB+uepV2v+9nljS1aYRaZUHKZmaf3iAvy3xx4JhEFLUJ8QkXCBx6B6aHfZYrAXKKb/q4tQBXgezN4FCSxcFtKW3MVOMOgAQoNwzMm9q4NESrSCVHGbL4jlQSHDiF7a7s24eUuCzE0VpnVi9T0k20SQM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0LB9tJ4z; arc=fail smtp.client-ip=40.93.194.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0LB9tJ4z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WpMsoIgCv94+EslXo6WOrQipgpH138vN060ieerANrQxL5RpdBnEndlbbb35xZZiTgION3PrR0866iO6Za4QY4O+MMiin/3QIWAao130aS9gcUtmk3P//3ra2Edb0XqenPQZ0AmZjV8EJVZ9Is/T0ljAdoHxIUg+xUs7LYizQW2pmOEEMaD2U+m63KZ8ZmgJaaU5aLtGN+39YwviUTiyfbq0HG4FV522mBqK+1hWvpfyRI8GurxhJR09WqXohikxHY5Qe3A8GYyfYKzE9NcJpHutYXo2vU2hbpWuaywba6IRLrT3wpPDVErirj2E9EUqDFSVoBmThUEhSSE6YEf8Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WfbN9fJEHvMdG7Wn+4hi9U32IYanGNwa2+qAF194Geo=;
 b=HCWMDO1Hjuws3SIkXQ5O4wRBPVgz1RLHYrOT+lIHWCZg50iZsV4n84aWO2VimGJmLY0v3GOhesP/AVbdyxJ7vHZZHSqrhpwlfRDO2B7YMcNRXPvG1Au4fQMPVOOCV/WY4N8iuCD5iCsLbJT2Qo3dgXORZwFJexgpuFf8bIZflqdynafAd7QsM38G0QfHF1vDVNFg8bg083mMomnQsbkNd6pDQW9aO7uC3qFoZkU8EeWokRkojuqhp1+i+qUvb8MAVyEUCI/tkgS9UCvTE2T74OK33dI7wUYZmcRw38uX8B1dTE8QLe+nQ7QRV1qNADfJ0H6W7OUHZDRLzD3i4tfQuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WfbN9fJEHvMdG7Wn+4hi9U32IYanGNwa2+qAF194Geo=;
 b=0LB9tJ4zbT3aQUx2ayWjoK3/nJIEr93gc78pGzLukJH/sSY3mZvXsTYSW2Iym0HDmq4553UNdvFYC4URbd1WKYkqnVnFO4CM3WlvphX3q07bVCRAf+ubqoFfIBQMzA8p5ZDxJiJQRsHFkf2cTqvOdP5Nlklj5+v2GwxdE6HG7kI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from LV8PR12MB9714.namprd12.prod.outlook.com (2603:10b6:408:2a0::5)
 by SJ0PR12MB7008.namprd12.prod.outlook.com (2603:10b6:a03:486::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.15; Tue, 24 Mar
 2026 05:46:31 +0000
Received: from LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6]) by LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6%6]) with mapi id 15.20.9745.019; Tue, 24 Mar 2026
 05:46:31 +0000
Message-ID: <2960e485-fe26-43b8-a950-9cdb5a090678@amd.com>
Date: Mon, 23 Mar 2026 22:46:27 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/9] dax/hmem: Request cxl_acpi and cxl_pci before
 walking Soft Reserved ranges
To: Dan Williams <dan.j.williams@intel.com>,
 Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 linux-pm@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Yazen Ghannam <yazen.ghannam@amd.com>, Dave Jiang <dave.jiang@intel.com>,
 Davidlohr Bueso <dave@stgolabs.net>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, "Rafael J . Wysocki" <rafael@kernel.org>,
 Len Brown <len.brown@intel.com>, Pavel Machek <pavel@kernel.org>,
 Li Ming <ming.li@zohomail.com>, Jeff Johnson
 <jeff.johnson@oss.qualcomm.com>, Ying Huang <huang.ying.caritas@gmail.com>,
 Yao Xingtao <yaoxt.fnst@fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Nathan Fontenot <nathan.fontenot@amd.com>,
 Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
 Benjamin Cheatham <benjamin.cheatham@amd.com>,
 Zhijian Li <lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>,
 Tomasz Wolski <tomasz.wolski@fujitsu.com>
References: <20260322195343.206900-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260322195343.206900-4-Smita.KoralahalliChannabasappa@amd.com>
 <69c19a8c66fd3_7ee3100e3@dwillia2-mobl4.notmuch>
Content-Language: en-US
From: "Koralahalli Channabasappa, Smita" <skoralah@amd.com>
In-Reply-To: <69c19a8c66fd3_7ee3100e3@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0023.namprd04.prod.outlook.com
 (2603:10b6:a03:217::28) To LV8PR12MB9714.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9714:EE_|SJ0PR12MB7008:EE_
X-MS-Office365-Filtering-Correlation-Id: de9e1d17-9ac2-45b8-784f-08de8968b364
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|18002099003|56012099003|22082099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	yYHQ0yyaTICQ2p0+Ui0wZTBBCaOgD2OSv4t6YRF0sN+qK66BWiKWg42jJs4FMAx0s388nsUoPSe9yLT0NsynLRPNnrYCk6yXEIpfhZtXWVwuAJvJ7iQb+FlVc+ZxYxzPW5AITZeVo7GDzKfz05Ph5y8Z3My3iQ7MHg7HCYRCkPAwNSqMJGq7mp0SsjncsvAdxDOD68DQAjYpaU1oazn21YhEyYggl9wPzbgAgk44Uyn1gYh2LZNh4Iiu6L8LymAkh5sM0oqmFiIxCLSelJPD7zMFbBKju8CStamf6KyknbO2HZcQwdYQt9o4Tyi+4NWT+P5s7dJS+plkqoGmfjuwEcNeoNxysAsRtb1/9RzY2koBd6eltMbcrMiMVXXAuvZbbd1bY4Dh07wA/8RR5QglXCQAAag2ILq7fQ3+uMdt/qSpnpCkFpLql5ab8gR6FxBdp6h2/05hLh0mddGo8mw+tbhUzPA+0O0SmY9oEOdpswEldVGJw3j8KIXKlR1ckY80oJ8VxsI2/zN8t/u6PSqlkwcyiNnQCzery4u9j00o8jDKgA4BDo8w/D+Z68nYAXCH3ibbxFj1IhtRV23zD+fgZU2jTTaE07RPSYL3t7+F2oArfPj82MflNNLDw9siBOCxupvlx3fbAAHqH9SwKReTi1nV7wjQPC5GeBA2EccWTqKGSt25iU8NYGsBrwr0TBa1cW4PYXc78RlsnPXe91NRc4v1fgY2NqYQ8TWExhVNuOc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9714.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(18002099003)(56012099003)(22082099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cjEybmJ2K3JuVFlRZUFaVkRkMTFsdXVqaVBaUDArYVJORm5aTzVMWWJYbWZX?=
 =?utf-8?B?OVFheHlsUlVQRG1Pd2RNTit4dHZjcDVITHBWZlRhV3loc3FZdEZRditvQmh5?=
 =?utf-8?B?TDBSVW9aOC96a2YvY3gxenJMS3lIUnVBT2JtSGVrVG5LYldoY2dnaERaWUY0?=
 =?utf-8?B?Nk5haVFhUk9LZVQ3SGU4SWJLOTdtR0JJUnNHZ0Yxc25Ic291NERxMjRnSGEx?=
 =?utf-8?B?MjhhQ3c3TUhvWjllT1czSi9Xb1gzNDY2a3prOWp1Wkx6UXJycmZZU2lJeWhL?=
 =?utf-8?B?bEU2MXlBV2IwWE1NUjgrQWcwOEhQSWcvRTlkb1lmS1JQdGNYQWp6MzR0a3h2?=
 =?utf-8?B?Wkhrd0pxSEprRVdKclVXT1d4SVNxK1ZuOGM4SlJXY0w5dE9tTmd6K3N6QmVK?=
 =?utf-8?B?UWhrUGJjU21tZDgvaU1EdFAwRUYvR3NtdzdVOEt4Y2I5ZTZJWFNaQlBqZVE0?=
 =?utf-8?B?azhwaUpsVVd0ZGtZNDRpNGJLWUpZSVFjMC9RZFBleGJKLzVITStEKzRUaUpV?=
 =?utf-8?B?enRiSUsyRGdlb0Z3VWlWSWdRS3FRUWgzWWlHQWdzTU5EVVB6dFdSU3dEYk9H?=
 =?utf-8?B?MldXTUpaODdBWkJlL3h6Yi84dHYvVGhJenZDS2ZjU0tqd1RUZWlIbUwwczlJ?=
 =?utf-8?B?OFZsOFlrZE5hUmNOVlVkckpSTzJOZVlCRG15UGo2K3A3TWs4SDIwVU4zbitP?=
 =?utf-8?B?MG10aTAzQndsNDkwb2hXUDlwQ1pPUlFSQlJ3aGFxamRaR2wraXg2TnVLMlhH?=
 =?utf-8?B?ODZPdnVNcGcyaHBSSHFjaVM5UmVPWGJKNG4vanZFZkJ4MitBTnFRSHJQOVBE?=
 =?utf-8?B?YnJrRys0NFFQSXVMb3E4RjU4ck9ZbWpkM1lrbUtmNHZmblRMWWlPZjl4SkpY?=
 =?utf-8?B?SlFUemc2V295bzgwdkQ1WUk0RmdYVzJwWnpaVlN6aG5aWjFmaTc2VGJIaE1q?=
 =?utf-8?B?NUdNSlVIb01oRkF0YnVmKytic2pYSFRxcTVqcGtFWThDWXVtMitxdzdBaURB?=
 =?utf-8?B?N1hqa2ZKY0ROUS9OWTcwcktCSG5BY0lsQTRJYml4Uzl4dG93TjdsVVNKRTZx?=
 =?utf-8?B?RFRmem1IdFNGbEN1MmJaWHJmT3l4NHVUODQrY3hVMEJyMld5ZkVSUERGSVNl?=
 =?utf-8?B?bWdld0FjYWNycFdEVmY3NzVsYjVzWUJYWVM1ejRaU3VUcU9Kb1M2WFBnOEty?=
 =?utf-8?B?S2x5RjZIZjcxbUdBVkRYbE11Rmc3QjAveDFVZEVhYThhZzl2VzMyU3NBTHZG?=
 =?utf-8?B?WXN0bC9FUzcrdWpNUE9YRVZJeDY5dE93MVEvdklqMzRkMzVSZHV4czcrdGFP?=
 =?utf-8?B?dm5DWmZqWVRURFZ6aEM0NWF1OGdzajgwQ1d1c3NpWjBwWmtlWUVHRy9ZTlY1?=
 =?utf-8?B?eUlTczFVdEloN24rY0FvaVU3ZStycm9aVDRkWHFWS0xJeW5SQUNVekxCM3BP?=
 =?utf-8?B?djRQancrOW9iVkpLb0p2VzZPNzBiNlhGcUlyN2I4bDNycTBGdXhac013U0dh?=
 =?utf-8?B?elVmL3VEZWQwQVQ3UC8yOEpsWTRoUnVjVXlnSENBcTZidTNlT3MrY0NMYWdF?=
 =?utf-8?B?TVJUS1hiLzNaYTZEcm5tZUN5SXJOVnZ6NFRWYW10ZjF4TEtieHE2aGRDL1li?=
 =?utf-8?B?cU5WQ0NiOHJqZXdIeUV4dmVkODhCNVZkRHB0U1p2LzlIK1VIODFKRjkydlo4?=
 =?utf-8?B?T2VFRmVTMThxSkVWdHByWTczeXNhSTZsam14UGdQTXdlcHJBK2JBTmRMdmVR?=
 =?utf-8?B?aGpwbWtRb0x4SzRxbDVSZit1ZURwYWd4dmoycXRvbHVIZXluVW1XV0U2blkr?=
 =?utf-8?B?NzRraVV4RERDaGZRT1lJd1U2bSs1bHFEOTJXVEEyNXNJS2ZuTDJ4a29ybEUv?=
 =?utf-8?B?T3ZEY2NHTHhIakM2bEhGVWRZOUxjMVRkai9LNlE1aTk1c3NVd2RHNzQ3czBs?=
 =?utf-8?B?bWw4eHhPS1REbFZUVUQ1SlVYUmNTYVJPMnZUS2x2elBxSzlEcVlhVGJ0bVhT?=
 =?utf-8?B?Zmg0S000Ui9IakExY2s4OW93clpOUWQrdXVqWG12aXVjN2xPNTFma0piN2xq?=
 =?utf-8?B?QndTQkQ1ODJBdTRreDNxY3QxeW1TSEtITkpjc2NXRVhjMTU5MmlKOGR5YjMw?=
 =?utf-8?B?cm83VmozVnZwNm1JY1hpNmhoRjBrL0hPVkRyYlRpcDBML2J0eGdCVnNaUjV3?=
 =?utf-8?B?RVdoRTNxb2dFek0yMEhNVXJ5SVdlc3BOeW1jTnAzUHNzYmlUQW9FNjFPc1B4?=
 =?utf-8?B?M1owc3JkcWpkRkdOOGhkZzliekE4bnFlVkFMNTdqRTZHWWs2NzZNd1J1SEFj?=
 =?utf-8?B?ODVncldxMTc3Q2JValhIb1VNT1UxK2N0cFhkL2NIS2o1WFFaTHljQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de9e1d17-9ac2-45b8-784f-08de8968b364
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9714.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 05:46:31.4078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SgUKVvp7c+R61aW3NOR0eD2cqd1uppdOFY1VwLu1TYZvYwVbHq95At3gGDPcjxnX1gv3RtW6OlKB82qp19wyew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7008

Hi Dan,

On 3/23/2026 12:54 PM, Dan Williams wrote:
> Smita Koralahalli wrote:
>> From: Dan Williams <dan.j.williams@intel.com>
>>
>> Ensure cxl_acpi has published CXL Window resources before HMEM walks Soft
>> Reserved ranges.
>>
>> Replace MODULE_SOFTDEP("pre: cxl_acpi") with an explicit, synchronous
>> request_module("cxl_acpi"). MODULE_SOFTDEP() only guarantees eventual
>> loading, it does not enforce that the dependency has finished init
>> before the current module runs. This can cause HMEM to start before
>> cxl_acpi has populated the resource tree, breaking detection of overlaps
>> between Soft Reserved and CXL Windows.
>>
>> Also, request cxl_pci before HMEM walks Soft Reserved ranges. Unlike
>> cxl_acpi, cxl_pci attach is asynchronous and creates dependent devices
>> that trigger further module loads. Asynchronous probe flushing
>> (wait_for_device_probe()) is added later in the series in a deferred
>> context before HMEM makes ownership decisions for Soft Reserved ranges.
>>
>> Add an additional explicit Kconfig ordering so that CXL_ACPI and CXL_PCI
>> must be initialized before DEV_DAX_HMEM. This prevents HMEM from consuming
>> Soft Reserved ranges before CXL drivers have had a chance to claim them.
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
>> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
>> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
>> ---
>>   drivers/dax/Kconfig     |  2 ++
>>   drivers/dax/hmem/hmem.c | 17 ++++++++++-------
>>   2 files changed, 12 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
>> index d656e4c0eb84..3683bb3f2311 100644
>> --- a/drivers/dax/Kconfig
>> +++ b/drivers/dax/Kconfig
>> @@ -48,6 +48,8 @@ config DEV_DAX_CXL
>>   	tristate "CXL DAX: direct access to CXL RAM regions"
>>   	depends on CXL_BUS && CXL_REGION && DEV_DAX
>>   	default CXL_REGION && DEV_DAX
>> +	depends on CXL_ACPI >= DEV_DAX_HMEM
>> +	depends on CXL_PCI >= DEV_DAX_HMEM
> 
> As I learned from Keith's recent CXL_PMEM dependency fix for CXL_ACPI
> [1], this wants to be:
> 
> depends on DEV_DAX_HMEM || !DEV_DAX_HMEM
> depends on CXL_ACPI || !CXL_ACPI
> depends on CXL_PCI || !CXL_PCI
> 
> ...to make sure that DEV_DAX_CXL can never be built-in unless all of its
> dependencies are built-in.
> 
> [1]: http://lore.kernel.org/69aa341fcf526_6423c1002c@dwillia2-mobl4.notmuch
> 
> At this point I am wondering if all of the feedback I have for this
> series should just be incremental fixes. I also want to have a canned
> unit test that verifies the base expectations. That can also be
> something I reply incrementally.

Two things on the Kconfig change:

When DEV_DAX_HMEM = y and CXL_ACPI = m and CXL_PCI = m

1. Regarding switching from >= to || ! pattern:

The >= pattern disabled DEV_DAX_CXL entirely when DEV_DAX_HMEM = y and 
CXL_ACPI/CXL_PCI = m. So, HMEM unconditionally owned all ranges - the 
CXL deferral path is never entered.

With the || ! pattern, DEV_DAX_CXL is enabled, which changes the 
ownership behavior based on how the probes starts for CXL_ACPI/CXL_PCI.

On my system I see:

   [  7.379] dax_hmem_platform_probe began
   [  7.384] alloc_dev_dax_range: dax0.0
   [ 28.560] cxl acpi probe started     <- 21 seconds later

HMEM ends up owning in this case because CXL windows aren't published 
yet when HMEM probes (built-in runs before modules load and 
request_module might not work this early??), so region_intersects() 
returns DISJOINT for all CXL ranges.

But it could go the other way if CXL ACPI and PCI probe starts before 
the deferred work is queued in HMEM. (And I think this is the expected 
path if DEV_DAX_CXL is enabled..)

But do you think it is okay as of now with resource exclusion handling??

2. Separate build issue with DEV_DAX_HMEM = y,  CXL_BUS/ACPI/PCI = m and
CXL_REGION = y.

I hit this build error when I was testing the above config: (Sorry I 
should have checked this config before)..

When DEV_DAX_HMEM = y and CXL core is built as a module hmem.c calls 
cxl_region_contains_resource() which lives in cxl_core.ko causing an 
undefined reference at link time.

This happens with both the >= and || ! Kconfig patterns.

The current #ifdef CONFIG_CXL_REGION guard evaluates to true even when 
CXL_REGION is compiled into a module. Changing the guard to check 
reachability of the actual module in include/cxl/cxl.h worked for me to 
overcome the error:

-#ifdef CONFIG_CXL_REGION
+#if IS_REACHABLE(CONFIG_CXL_BUS) && defined(CONFIG_CXL_REGION)
bool cxl_region_contains_resource(struct resource *res);
#else
...

Not sure if CONFIG_CXL_BUS is the right check here or it should be more 
specifically checking on CXL_ACPI or PCI..

Thanks
Smita


