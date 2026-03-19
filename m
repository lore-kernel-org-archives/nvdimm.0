Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012062.outbound.protection.outlook.com [40.107.200.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC143DE434
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 15:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935214; cv=fail; b=te1AjTOgLmTTfHZQ5mQ3482U8BIi/Cc41BfFhcnDRA6ofCYU99ZiDdMiTo0YVYRUajeAdetiO/LgdTSn8Uwywj59MmJc0cZ5VbqsqbaqMnq5hgZuaYCkH4Kyj0immCEsZj5/JGPahlvkLFJ9KshOS4W/cqsGCbXnIWDsW21mEyw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935214; c=relaxed/simple;
	bh=99buNJZySQzYRxcQRw8c+N39rjQhkwWD7JAACaDUWOY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MrDrgWFOAP5RoBngrVtHEPSlX7r+I5gTTAjUyPDtuJ7wNjTXtGGUhq8duyvG19axcFv9Hycihbrt7XtbXp3FVOXfEcK8DmUBuzFqbcs6XaUs7t5MGVDosueyz3bo4MOauEa79W1G4AT/d+4GZCbce5trxtjHXVCVgBtgMQxOGuQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FmZR5164; arc=fail smtp.client-ip=40.107.200.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FmZR5164"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GVm7noYKcn9FPJqWUR9gu3tG4MD5s0oUDhT0LQrIQyPP1LyUc0KkEFyTsaF7itVyLbNTx7eWA0WxFzUavk++hbjncxay1DlZTOTDLpHnS3lUFXT8VV6FvtMifTkxe7D9dPy90dy/PfO/uc5sf2p88dAjs4CTkEXXnGqBYj5o3WYYJr1v7IF9QkeISQ5r4BsizSZOfKOf3VJm614nosMk9WZh2fodOq1xQPeMT9SA2C4S/3+X8tw1YpnZAaoM/T96RTOynx6AHHmpFKSlyxrCPkmOkfGR77ca8faI4ZGrznlGNSUUM7bImghf+prX0LuOHJosPYXdQsmD9cewooxOHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wsAzUjwc+vW47s8sKEXl8FvEtEyRJ/Al/Mn3N7K6pts=;
 b=ZtUJzEYd6Sav84hndZ5XStzWhUrcy2e69mGiPygpeMkHlwT6dIV55WdAfq0BCOLxOIYX9LkaU3wzsUgrrSTzMcMnhWSHHMYuyfXQxAhqZh/1+EQGIawkYubg34w4tEG331xwIN+DSvDzKpUdL6rwI5N+xVo0z8pYk0m8OjO+MYZQyifbQcMH8U+4MX6bh+KNDu4CHJ2k8T+B8S8HrGjHjPOjDx5DVLGlqA7E1V/U/gaoZ+JrY560HG+q3wp80RW17BaUiVS0zY8hRNL7PFO+d6AF6g4E/JWnf0HWxywgdXgYyY7S4RzZH1hZwCdF2+g1QNQvr49DaPba13FsAfxQoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wsAzUjwc+vW47s8sKEXl8FvEtEyRJ/Al/Mn3N7K6pts=;
 b=FmZR516424Fg4jUV4PDKEwO7+UeeJ6O4feyLSuEd8XFRAovLmN5Cjpk30iBrbQuhi5ig1J3P5bSFoNlKLNgoDEQLnadqqFUDiVmaa7q4iziecLG8ICH1b209rBEHrfS0X1DvlHBuOB5F32/8+wLB+n/3MOmlGhFHH+Cc66SBIZo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from LV8PR12MB9714.namprd12.prod.outlook.com (2603:10b6:408:2a0::5)
 by CH2PR12MB4117.namprd12.prod.outlook.com (2603:10b6:610:ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.10; Thu, 19 Mar
 2026 15:46:47 +0000
Received: from LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6]) by LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6%6]) with mapi id 15.20.9745.007; Thu, 19 Mar 2026
 15:46:47 +0000
Message-ID: <3590e2d5-e768-4180-82a0-c972101f3440@amd.com>
Date: Thu, 19 Mar 2026 08:46:41 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/7] dax/cxl, hmem: Initialize hmem early and defer
 dax_cxl binding
To: Alison Schofield <alison.schofield@intel.com>,
 Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 linux-pm@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Dan Williams <dan.j.williams@intel.com>,
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
References: <20260319011500.241426-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260319011500.241426-4-Smita.KoralahalliChannabasappa@amd.com>
 <abuOLq6bMPa0nNAL@aschofie-mobl2.lan>
Content-Language: en-US
From: "Koralahalli Channabasappa, Smita" <skoralah@amd.com>
In-Reply-To: <abuOLq6bMPa0nNAL@aschofie-mobl2.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0381.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::26) To LV8PR12MB9714.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9714:EE_|CH2PR12MB4117:EE_
X-MS-Office365-Filtering-Correlation-Id: 62514786-f165-4198-0c22-08de85ceba69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	cqmjuQDP4zkUSn0VzOzMdH5ka1K7CWjcHV2jepxIFtGZwCKdzj48vujHtYLXBH4064lDNHdoQl5DP8FjGWcy5YT7JkrEe/yoo++ecym8f6lT02uimOPFPrcL4lkenY2ut5bNteiqEHl6fStKx8xN0+sKbSGZdD5IlJLXTjm1uzLO5euRPbQFxjgV9fiGFhmJ1+yRcsoUJtaRh1g6zcMPF46KT3tcLIQQwklLCRm9KZLkSKfNjtvKvWuw0EhZEYHe2FGD35yqctaRm1cGZC0IzqDRbF+gYJC29BKOf/Oa308ONnk5c8NpWAOxkvDW7srQAxBOZuHxrMo3l0wGQBcAHmBgD519dRUy+O+jMF803dcSmxUzn4iSA1pv5rjWK0TlpZFhvHway0O22RWMo998tcF15w78jGUSzGdb3xfWXFi3irCzZqOw0vkohKmTn0oB2kdD/2dyK6BuNktpT2ZBIyfSPDiG6hxjv12K8KNL5e4jV22cqeTA1M1asbTbHWPnnroMw4oEb0uEVfpCJWGoEa4A2x0KKj5RlX6+3ODGD9jfLL1FPF2P9JPAgjcEemQ6SIoarAFFn0mY0v5EBhmOjUIF42Mc8gvWEBS+RDPNW55qHomVS7WEjgMttkxSmxmxh1+rTWmSY0m7gO9/pl5gAfobcXIFp3SsVKQyq0IrehYpz9Hhmkn1BHLxS+nM263nyTKb7sY+6o2jAnHzq5o5+PQEEmxe/VQSJ4qu/O60okM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9714.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VmRwOWx1eVluOHlXYTdPbmtvYXMwYVdxNTRCcEhLaWhkL1BBNHhDYmRYa1hF?=
 =?utf-8?B?bURsQnIyNUJxZ1pESHM4VGNodjh0WGU5c2RqZVRQMDlaaHdqUTJlRUxkUkl4?=
 =?utf-8?B?TUZiaUF4Z2dqVjEvWmIrQjBKYmRJeXpHNHFVRTl3Z1JJQ2tTenk1bnJ6eG5r?=
 =?utf-8?B?UnR6ejhpMEF2ek9nYzVCdGJKU0Q2YjN3bHRpSG8xaC95cGVmWFdodzcrMWx0?=
 =?utf-8?B?cm8vV3dJL05sRHI3MmFLRE5RS0hZdkNpSlpGeGJWdG1PaEdqc3N6SnpheUl0?=
 =?utf-8?B?OVg2UG5TeXo3aDNwZCtSa3VHbmdPK0NWSm1odkZvcm1PSk90NHFiQXViOUJi?=
 =?utf-8?B?UXM5amY5MkQvRnFUbmt1OGEwd0VtY2g1ZEJwdStsbmFBK2hOQS9kOTVISVY0?=
 =?utf-8?B?b0Vnb2V6TEZyS1YxYzhaSTQwZVVXZGY0MWMvUmNCVU5zeE5zaC9XVFZ4L2ox?=
 =?utf-8?B?UjJmcmRvMzF0NzgyQ2Z3YUYrMzk5VlQ1clF0S0lpM0JTYkl2QUNyZTJmNjJL?=
 =?utf-8?B?Q3RETGRlRkVjVTQ0a3kzcnpBdllwOUoyaFNwNWNEdzkyMzR5a09ubUs2eDE1?=
 =?utf-8?B?WTFVNTVYR081MU9BTlhPMms0eDlaU0M4dXhRVHZUYk8wSDdLZ09nM3p1MUJI?=
 =?utf-8?B?a3VXYXVtVm1WVk1DbDQ2d2pIYzB4NzQwbFpOUjRPd2swRWlCZTQramdXQVow?=
 =?utf-8?B?NDQyZjdIR3JWNS9qVW12RGI5RGZidUxOYjhtbUFRRmcwWExmcFR5MEM4S2dK?=
 =?utf-8?B?azROMzJkSTU0NnBpTjIrQlJYNlh3NU5pWDN4R0UxRkRpcUZXWURFWHVKRUxH?=
 =?utf-8?B?blEvZFI1SnN4dmd4bnJkWGNCenZFYVczaUpha2JyN2dCUDZqOFJjK1EydFNI?=
 =?utf-8?B?UjlBUE1sTVROamExY2p4UTBremVSdTViRWZDVTBseUEvM0xCOGpZSGEwZDJ4?=
 =?utf-8?B?dThyNjdOM1NLVzNqQWVQazRpMkFUenJnbkxrU2dlUWlIMnF0aWFTTDdaZmtO?=
 =?utf-8?B?SEVlaDltSE1OZ1RobmMzRW15OE54dm1aUE0yRTl3Z2luN08xZVM5bVBkZFBv?=
 =?utf-8?B?MGdJVXRoeTl4OXRZV2U0SXN3bWQyQWRVWWlDU1dkeFprWnN2QzI2NzhnVExr?=
 =?utf-8?B?R0tyaFZVNVVLZG9wSE9YVzM0MTFwYXA2SXo5NU1mNCtvQUk5TTdBUVlLUWVt?=
 =?utf-8?B?MmxqTEFnOUdLODhFTndxRUp2eW8zUEZRUDhVbEVISGFLbStzVWlWcHpMWVpy?=
 =?utf-8?B?VWlyWlQ4OHV2YlVtM0F4NWVoV2R5ZE50ZGxZdFVubHljRlRXNGFuQ1ZOSjU4?=
 =?utf-8?B?c2xXeW9rcStFMHprZ2trL0RKYktoRzNBWkQ1U0I4Z25NeGZMYVJtRWlobDNt?=
 =?utf-8?B?aWVlSlNhcWRaenhHYURzUDZnY2VHU0JVOWlOSjNyRTk4OVlvU2s5MTBtVlhF?=
 =?utf-8?B?dTJkeWg2OXFQK1RtRTF4MUVaZ2ZvWG1jcUxRSiswREtkeXBiMWtTeU9Pcktk?=
 =?utf-8?B?Y1kxS1ZJaVRXNVAvVWk4YWhYMS9FUFVuNEU1a2k0a2xHYThibVQ4eUQyVUxQ?=
 =?utf-8?B?TmMwM3FWS3NYZFV6UTNQZTBsdFUzbjJHUXJBbzM0N1c0WHFhVmJUdlJMVHo3?=
 =?utf-8?B?WmQ3MlMxUHRwazRwb2xQdWQ5NHp2R0twRTBiWkVueDBDTEtaWnpxbW9IWCtr?=
 =?utf-8?B?RSt5c2p1V2RvTlJtZXdtUUlSS3dhZjlvcFRTZGhSbDBET0w5bThrVUpkbTNM?=
 =?utf-8?B?MWZWdXdFdkplTzYySXJhS1JjYXlzZkVjS1dqR3R5c3BzSEI5bk5USCtPb0Vr?=
 =?utf-8?B?ckxGNlJ3bkNIV0FhOVMwTmZQQVcvaWZRUUV0NnVZck9vaHVXWkNmRWZ6QStD?=
 =?utf-8?B?Ykl2YlcxVFlUbXQ4azRoY1I3V05PYVd3YmtmQ1NNQnpNVlVVMUpGUm1SQTVj?=
 =?utf-8?B?VjN3RlRGOGZZc0VXdlU5emlvQ0ZSdEtUeHNoY21WUjU4M0N0RGFRMWlJR2NE?=
 =?utf-8?B?RkNMNU05dUU0c3duMk9yNjYrb1V5TWlTZFFUUFZkNHFRRGpjNnl5T0pVbldo?=
 =?utf-8?B?RGFBOVBmRkhWRzlOWWdseEpvdjlrdzNCVnhnN2x1MmhkQ2dWTC9HOU1NOTF1?=
 =?utf-8?B?K3VDdzgzdjEwNkRJcmljc1Vsc1pQb29wWC9aS05udUVCVHRvd2hwWjBETlR5?=
 =?utf-8?B?Mkk0L0FMWHdmMGhRc20zV2lzcXMzeWlRSDJDQ1p0WlBrOXR4b0hNMC9qQ2x5?=
 =?utf-8?B?b05PRU4rRUhkU2RYaUVkdW9rVzhSZDc5NUtzMnNUZmwvQVI1TktaYmh0RGs3?=
 =?utf-8?B?cEJPSmticW1kT3p3NVRDRjRERlJGQ1pvcUhyQzNoMVBML2tOYVBzUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62514786-f165-4198-0c22-08de85ceba69
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9714.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:46:47.1740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dl7d8d0ulU5e+5HsDUE3gDKaRzav8GGisHDUazzMCHAe7kSk2PVprjvBqyx9p9xYyta+Oze5M+LpOEYtSCp+cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4117

Hi Jonathan and Alison,

Thanks for the report and suggestions. I took a look at Jonathan's 
comments in Patch 6 and tying it together here.

On 3/18/2026 10:48 PM, Alison Schofield wrote:
> On Thu, Mar 19, 2026 at 01:14:56AM +0000, Smita Koralahalli wrote:
>> From: Dan Williams <dan.j.williams@intel.com>
>>
>> Move hmem/ earlier in the dax Makefile so that hmem_init() runs before
>> dax_cxl.
>>
>> In addition, defer registration of the dax_cxl driver to a workqueue
>> instead of using module_cxl_driver(). This ensures that dax_hmem has
>> an opportunity to initialize and register its deferred callback and make
>> ownership decisions before dax_cxl begins probing and claiming Soft
>> Reserved ranges.
>>
>> Mark the dax_cxl driver as PROBE_PREFER_ASYNCHRONOUS so its probe runs
>> out of line from other synchronous probing avoiding ordering
>> dependencies while coordinating ownership decisions with dax_hmem.
> 
> Hi Smita,
> 
> Replying to this patch, as it's my best guess as to why I may be
> seeing this WARN when I modprobe cxl-test.
> 
> We are able to pass all the CXL unit tests because it is only that
> first load that causes the WARN. All subsequent reloads of cxl-test
> do not unload dax_cxl and dax_hmem so they chug happily along.
> 
> I can reproduce by unloading each piece before reloading cxl-test
> # modprobe -r cxl-test
> # modprobe -r dax_cxl
> # modprobe -r dax_hmem
> # modprobe cxl-test
> and the WARN repeats.
> 
> Guessing you may recognize what is going on. Let me know if I can
> try anything else out.
> 
> 
> # dmesg (trimmed to just the init calls)
> [   34.229033] calling  fwctl_init+0x0/0xff0 [fwctl] @ 1057
> [   34.230616] initcall fwctl_init+0x0/0xff0 [fwctl] returned 0 after 186 usecs
> [   34.257096] calling  cxl_core_init+0x0/0x100 [cxl_core] @ 1057
> [   34.258395] initcall cxl_core_init+0x0/0x100 [cxl_core] returned 0 after 538 usecs
> [   34.264170] calling  cxl_port_init+0x0/0xff0 [cxl_port] @ 1057
> [   34.264982] initcall cxl_port_init+0x0/0xff0 [cxl_port] returned 0 after 110 usecs
> [   34.268058] calling  cxl_mem_driver_init+0x0/0xff0 [cxl_mem] @ 1057
> [   34.268743] initcall cxl_mem_driver_init+0x0/0xff0 [cxl_mem] returned 0 after 110 usecs
> [   34.274670] calling  cxl_pmem_init+0x0/0xff0 [cxl_pmem] @ 1057
> [   34.277835] initcall cxl_pmem_init+0x0/0xff0 [cxl_pmem] returned 0 after 1671 usecs
> [   34.285807] calling  cxl_acpi_init+0x0/0xff0 [cxl_acpi] @ 1057
> [   34.287105] initcall cxl_acpi_init+0x0/0xff0 [cxl_acpi] returned 0 after 262 usecs
> [   34.292967] calling  cxl_test_init+0x0/0xff0 [cxl_test] @ 1057
> [   34.339841] initcall cxl_test_init+0x0/0xff0 [cxl_test] returned 0 after 45832 usecs
> [   34.342259] calling  cxl_mock_mem_driver_init+0x0/0xff0 [cxl_mock_mem] @ 1063
> [   34.343459] initcall cxl_mock_mem_driver_init+0x0/0xff0 [cxl_mock_mem] returned 0 after 356 usecs
> [   34.658602] calling  dax_hmem_init+0x0/0xff0 [dax_hmem] @ 1059
> [   34.670106] calling  cxl_pci_driver_init+0x0/0xff0 [cxl_pci] @ 1100
> [   34.671023] initcall cxl_pci_driver_init+0x0/0xff0 [cxl_pci] returned 0 after 197 usecs
> [   34.673051] initcall dax_hmem_init+0x0/0xff0 [dax_hmem] returned 0 after 2225 usecs

I agree with Jonathan's comments in Patch 6, using __WORK_INITIALIZER or 
initializing work in dax_hmem_init() and gating flush on pdev will fix 
the WARN — I will add both for v8. But I think the WARN is likely 
indicating an ordering issue here..

On initial boot, the Makefile ordering ensures dax_hmem_init() runs
before cxl_dax_region_init(), so both work items land on system_long_wq
in the right order and dax_hmem's deferred work is queued before 
dax_cxl's driver registration work.

On module reload which Alison is trying here I dont think, modules are 
loaded by Makefile order. I think dax_cxl's workqueue is calling 
dax_hmem_flush_work() before dax_hmem probe has had a chance to queue 
its work, so flush_work() flushes nothing and dax_cxl registers its 
driver without waiting.

__WORK_INITIALIZER fixes the WARN, but doesn't fix the race I guess if 
we are hitting that here..

[   34.673051] initcall dax_hmem_init+0x0/0xff0 [dax_hmem] returned 0 
after 2225 usecs
[   34.676011] calling  cxl_dax_region_init+0x0/0xff0 [dax_cxl] @ 1059

These two lines indicate cxl_dax started after dax_hmem_init() returns 
but I dont think that guarantees dax_hmem_platform_probe() has actually 
run..

I dont know if wait_for_device_probe() in cxl_dax_region_driver_register
might help..

Thanks
Smita

> [   34.676011] calling  cxl_dax_region_init+0x0/0xff0 [dax_cxl] @ 1059
> [   34.676856] ------------[ cut here ]------------
> [   34.677533] WARNING: kernel/workqueue.c:4289 at __flush_work+0x4f9/0x550, CPU#3: kworker/3:2/136
> [   34.678596] Modules linked in: dax_cxl(+) cxl_pci dax_hmem cxl_mock_mem(O) cxl_test(O) cxl_acpi(O) cxl_pmem(O) cxl_mem(O) cxl_port(O) cxl_mock(O) cxl_core(O) fwctl nd_pmem nd_btt dax_pmem nfit nd_e820 libnvdimm
> [   34.680632] initcall cxl_dax_region_init+0x0/0xff0 [dax_cxl] returned 0 after 3842 usecs
> [   34.680918] CPU: 3 UID: 0 PID: 136 Comm: kworker/3:2 Tainted: G           O        7.0.0-rc4+ #156 PREEMPT(full)
> [   34.684368] Tainted: [O]=OOT_MODULE
> [   34.684993] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
> [   34.686098] Workqueue: events_long cxl_dax_region_driver_register [dax_cxl]
> [   34.687108] RIP: 0010:__flush_work+0x4f9/0x550
> 
> That addr is this line in flush_work()
>          if (WARN_ON(!work->func))
>                  return false;
> 
> 
> [   34.687811] Code: ff 49 8b 45 00 49 8b 55 08 89 c7 48 c1 e8 04 83 e7 08 83 e0 0f 83 cf 02 49 0f ba 6d 00 03 e9 a1 fc ff ff 0f 0b e9 e6 fe ff ff <0f> 0b e9 df fe ff ff e8 9b 48 15 01 85 c0 0f 84 26 ff ff ff 80 3d
> [   34.690107] RSP: 0018:ffffc900020b7cf8 EFLAGS: 00010246
> [   34.690673] RAX: 0000000000000000 RBX: ffffffffa0ea2088 RCX: ffff8880088b2b78
> [   34.691388] RDX: 00000000834fb194 RSI: 0000000000000000 RDI: ffffffffa0ea2088
> [   34.692135] RBP: ffffc900020b7de0 R08: 0000000031ab93b0 R09: 00000000effb42e8
> [   34.692876] R10: 000000008effb42e R11: 0000000000000000 R12: ffff88807d9bb340
> [   34.693588] R13: ffffffffa0ea2088 R14: ffffffffa0ed2020 R15: 0000000000000001
> [   34.694358] FS:  0000000000000000(0000) GS:ffff8880fa45f000(0000) knlGS:0000000000000000
> [   34.695179] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   34.695775] CR2: 00007fe888b4e34c CR3: 00000000090ed004 CR4: 0000000000370ef0
> [   34.696494] Call Trace:
> [   34.696889]  <TASK>
> [   34.697238]  ? __lock_acquire+0xb08/0x2930
> [   34.697730]  ? __this_cpu_preempt_check+0x13/0x20
> [   34.698277]  flush_work+0x17/0x30
> [   34.698705]  dax_hmem_flush_work+0x10/0x20 [dax_hmem]
> [   34.699270]  cxl_dax_region_driver_register+0x9/0x30 [dax_cxl]
> [   34.699943]  process_one_work+0x203/0x6c0
> [   34.700452]  worker_thread+0x197/0x350
> [   34.700942]  ? __pfx_worker_thread+0x10/0x10
> [   34.701455]  kthread+0x108/0x140
> [   34.701915]  ? __pfx_kthread+0x10/0x10
> [   34.702396]  ret_from_fork+0x28a/0x310
> [   34.702880]  ? __pfx_kthread+0x10/0x10
> [   34.703363]  ret_from_fork_asm+0x1a/0x30
> [   34.703872]  </TASK>
> [   34.704227] irq event stamp: 11015
> [   34.704656] hardirqs last  enabled at (11025): [<ffffffff813486de>] __up_console_sem+0x5e/0x80
> [   34.705493] hardirqs last disabled at (11036): [<ffffffff813486c3>] __up_console_sem+0x43/0x80
> [   34.706354] softirqs last  enabled at (10500): [<ffffffff812ab9f3>] __irq_exit_rcu+0xc3/0x120
> [   34.707197] softirqs last disabled at (10495): [<ffffffff812ab9f3>] __irq_exit_rcu+0xc3/0x120
> [   34.708015] ---[ end trace 0000000000000000 ]---
> [   34.752127] calling  dax_init+0x0/0xff0 [device_dax] @ 1089
> [   34.754006] initcall dax_init+0x0/0xff0 [device_dax] returned 0 after 422 usecs
> [   34.759609] calling  dax_kmem_init+0x0/0xff0 [kmem] @ 1089
> [   37.338377] initcall dax_kmem_init+0x0/0xff0 [kmem] returned 0 after 2577658 usecs
> 
> 
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
>> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
>> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>> ---
>>   drivers/dax/Makefile |  3 +--
>>   drivers/dax/cxl.c    | 27 ++++++++++++++++++++++++++-
>>   2 files changed, 27 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/dax/Makefile b/drivers/dax/Makefile
>> index 5ed5c39857c8..70e996bf1526 100644
>> --- a/drivers/dax/Makefile
>> +++ b/drivers/dax/Makefile
>> @@ -1,4 +1,5 @@
>>   # SPDX-License-Identifier: GPL-2.0
>> +obj-y += hmem/
>>   obj-$(CONFIG_DAX) += dax.o
>>   obj-$(CONFIG_DEV_DAX) += device_dax.o
>>   obj-$(CONFIG_DEV_DAX_KMEM) += kmem.o
>> @@ -10,5 +11,3 @@ dax-y += bus.o
>>   device_dax-y := device.o
>>   dax_pmem-y := pmem.o
>>   dax_cxl-y := cxl.o
>> -
>> -obj-y += hmem/
>> diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
>> index 13cd94d32ff7..a2136adfa186 100644
>> --- a/drivers/dax/cxl.c
>> +++ b/drivers/dax/cxl.c
>> @@ -38,10 +38,35 @@ static struct cxl_driver cxl_dax_region_driver = {
>>   	.id = CXL_DEVICE_DAX_REGION,
>>   	.drv = {
>>   		.suppress_bind_attrs = true,
>> +		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
>>   	},
>>   };
>>   
>> -module_cxl_driver(cxl_dax_region_driver);
>> +static void cxl_dax_region_driver_register(struct work_struct *work)
>> +{
>> +	cxl_driver_register(&cxl_dax_region_driver);
>> +}
>> +
>> +static DECLARE_WORK(cxl_dax_region_driver_work, cxl_dax_region_driver_register);
>> +
>> +static int __init cxl_dax_region_init(void)
>> +{
>> +	/*
>> +	 * Need to resolve a race with dax_hmem wanting to drive regions
>> +	 * instead of CXL
>> +	 */
>> +	queue_work(system_long_wq, &cxl_dax_region_driver_work);
>> +	return 0;
>> +}
>> +module_init(cxl_dax_region_init);
>> +
>> +static void __exit cxl_dax_region_exit(void)
>> +{
>> +	flush_work(&cxl_dax_region_driver_work);
>> +	cxl_driver_unregister(&cxl_dax_region_driver);
>> +}
>> +module_exit(cxl_dax_region_exit);
>> +
>>   MODULE_ALIAS_CXL(CXL_DEVICE_DAX_REGION);
>>   MODULE_DESCRIPTION("CXL DAX: direct access to CXL regions");
>>   MODULE_LICENSE("GPL");
>> -- 
>> 2.17.1
>>
>>

