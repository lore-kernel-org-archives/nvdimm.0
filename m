Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010001.outbound.protection.outlook.com [52.101.201.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DA83DE431
	for <nvdimm@lists.linux.dev>; Fri, 13 Mar 2026 18:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773427337; cv=fail; b=kVn0A5YOL1UaZnMilhcu8iyzimb8ZJ52vyoyUjjMlubtgaL7j7aco8VaTa/D0QjrZIHPo+49BsFN2SrFn6kePdis4xVqEExzMYeuOgQlZq2Q2hcqF9iVtpuAw+ybneQcdJtDgRPboIhts4FqIMPjkckEMaUqLSyZpSEyFYArW70=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773427337; c=relaxed/simple;
	bh=QcPPg9iCNyYqoNQCn9DFV9z0AMy43HzDlz647Jn/fz4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oieMN7Z1ymQnqn4FhGo0fdZYkfE44r4eN7VF5ccjEbCRYu8UL8kTCpNbGbTYM4jSg9OtXdw7A0DE61pwh3VVQ+PA6koGwOnI8i595gZHG0/9nLC6/Owj9HTZLQQDJl0v7DgGJEW5r3EtQfLaFTfQVRf5m5m08zx5G5R/j9Hz2Lo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=i2LY5LrM; arc=fail smtp.client-ip=52.101.201.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="i2LY5LrM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UNqtse5V34GdSksbmGVPdJu4Eqqy46Cg+jXMh/nE6KA6WUgVAnPI7/zF1solS3oHHtdpk3GvCBEzm8BMf4chR4ZL4PSXERPVrYUBVpvQd2sVb1NMOBeAyHz161KmKGuAnuIoxbMuAE02d4j0/m1jzVzrxxzawk4dss9tdsFVCPVEAycbdBDRmcW19pV2wjQyfd7AM5IqgN3yQe+L5rZSmoHiAxzWI2YaaFa927lhOlT2yBjlQJEnjcHLHQVqCXAE/qY6Onjo7utM7NRC8FiRTkIRIVhWR3cmUtlMqFUq3JZdFgbPcsfqOeGKHAmco2WxUkEHJBctGCfbjHwSPwjWLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CuWbinttJUZiMlQ2zuHjGGECF6aTX9/5u0r7jMDAgag=;
 b=O2ydf7WRkau6FrN25lb949EjAfoJZ5Z3F5jT6gK3mYnP7FHzBrFgtsUZ1NuAMlAxQk5qk9fSM0mdDEYAt/uOdGOp9zQtleeuOtgvaXYjc1UVTk6JIdEZN5+ylyqaiG1MP0biKyMhPcSC99pig95eh9q3KGkA3LMRXHHWiV0LTzlsGfA5Hksh/EswbgPn+6UyPPLSeDN9cJqB94vQZGCqYxO5Gi5hec9TJb4sTQLpVBatvS8d75NR5WXCeWJIvL/H/U9mRlR8K9Ek+zAW1sRIsidzPtbxE+9p0HkE9bvj86wRTEMwchubkp2QbSGde0jR8T1t71s6TTm3o3XxSBT2YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CuWbinttJUZiMlQ2zuHjGGECF6aTX9/5u0r7jMDAgag=;
 b=i2LY5LrMatTkVc+5dMcgmg05GLkj25RkvpcJgAek33Shk9qrlvZP25AUUxLLe/CxTmdD2MDEItsB2EinrvZGp7Ey1d1GyQp5trLrBIWWntLQXF5qL3Y7N7ouHHlEt2wYkGVI12fctLd0x5Byml/voWjfjM33yK7BUlqBWHT/Q5I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from LV8PR12MB9714.namprd12.prod.outlook.com (2603:10b6:408:2a0::5)
 by SJ0PR12MB7475.namprd12.prod.outlook.com (2603:10b6:a03:48d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.8; Fri, 13 Mar
 2026 18:42:05 +0000
Received: from LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6]) by LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6%6]) with mapi id 15.20.9723.008; Fri, 13 Mar 2026
 18:42:04 +0000
Message-ID: <80bab312-7945-4579-a369-380d7094bbb3@amd.com>
Date: Fri, 13 Mar 2026 11:41:58 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 8/9] dax/hmem, cxl: Defer and resolve ownership of Soft
 Reserved memory ranges
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
References: <20260210064501.157591-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260210064501.157591-9-Smita.KoralahalliChannabasappa@amd.com>
 <69b224bf2fd12_2132100b8@dwillia2-mobl4.notmuch>
Content-Language: en-US
From: "Koralahalli Channabasappa, Smita" <skoralah@amd.com>
In-Reply-To: <69b224bf2fd12_2132100b8@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR04CA0006.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::16) To LV8PR12MB9714.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9714:EE_|SJ0PR12MB7475:EE_
X-MS-Office365-Filtering-Correlation-Id: da7ab31c-ef9d-41d2-c434-08de813038e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	pOVxcn2ao2+X1eqQj3hFida6fG7ON2kEDUyP/IKBXBQURuPwKZTge7ASzREREnZ2f46QdXdtRHee8JpaEoi+omE7unpLxgFVyvUK7JSfp1A59tuULp/C93K1truIqe0K5mhyQ1l00Ej0RSWrNyFuV1iosaATKB1igz0wuDQSvWCRsaWqX5UlYUf9GHoWQwanIgRdmX/0GN8B1Bodrr/DxyC28Gv/aSl6qBihLrTRZWxXMbxLDfuVrEpC97kJjcSh9QzvY4NlcdzIZSS2glqeNRMtKkua5L6qTbO4qSdf2GPQGpftA1SWjmcUYtTmc5ENjJQIvqhdwpZvrA7Zb5QDbh4AUVVt4WS5DwAVv2RzW5OnCDkFU1VbiBEZmhufZvKF0qOGQAeBhgy8chKbVOhdn9EstvczI69fo19BDDwPXqvkvqpSYWRavez3N80Kiaok+mM8L9CtzxKxKJ2YdaGEPwzPgUvahDcwsDuda9KPCCMTeLG8q3yTOu2UglOElNYROKmC8AV+CnLjUbnb2fsFejm9MfoYVNIWrGsb9J6dtqyQl7EnzJOBhI/zpZiCqukIZNcI54OZjjAFe3Qc35hAy8ljgPDpujYwq6Q2tub3nAe8uz+Ah2ArtPtIlypJzkxw0YBAKxHfTrR9ku8e/0vywaA4DAMUgVB8/9sc9t9iw2eBDqNVF9YLMQ9MOZhqQQWF
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9714.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bWpSTk53Y3VEdk1OZzFoYVVrS0RTWnlIaGZYcENUWDc5SFprUGVCajBwYjVn?=
 =?utf-8?B?T1NFTXlxYSswUVU1NjRtSWM1VXNrVmhvZ2dPend4alZFcUdhamhwZFJseU54?=
 =?utf-8?B?S25PVEtQdCt2ZjBRaWRvNVZtbFZ6Q25XZ1NRN2NKNnRiMUkvRXFNUnZRY25R?=
 =?utf-8?B?L0ozenVsT2Rmb08ya1laR0RFS083L1B6YVBVZUt5QXdYV3Y0QXVQc0JvNHJQ?=
 =?utf-8?B?dkNQeGR1Tjk4dWVZU20xaHV0aEMxUG5FWURVbk94a0dFNGxuVkNpbUY1SkhR?=
 =?utf-8?B?bFNhRXlVSENpZFI0STBVdm5JdW5JeHBKc25xUUFHdjE0VWdrallKV3JCbW5u?=
 =?utf-8?B?Vm1USEp2ZFNBb3ZPcTFGMFpqYkpuMTJlS28yOWRYeDBFbHFvN3Z0VFAySHZ5?=
 =?utf-8?B?eHRqV3NLcDhpcTMxL3hMZXZmbFR4bFR1dTFUSGMwLzN3V3lRV3B4TjFmVDd5?=
 =?utf-8?B?OGZNQ2pxaE1meUdOWFBWZFkrQVhKblc1Ti94YWRCeU9kdlFpeHJmazNrRGU0?=
 =?utf-8?B?YmhmTmxZSU94Z0p4azBYcTBLVlo3Q1FpVHZkSFRDeWhPY0pML0NYZ1dFQ1dD?=
 =?utf-8?B?TnZ1dk5iK3hjWnh4cGtKQzdxWWpDbCtDQ2JYWTZPc2YrYmJWNkVhdmNVVWU1?=
 =?utf-8?B?MmJYdm0rYmlReHhsWjc4ZFNCYm5sWDcrY3NpWXdhczMyeEVSZXZOc2JvQUVx?=
 =?utf-8?B?RVhMb2NzNzVtUXpUOHQzemo2Q1IyYUMwWWlCRDlLVU1sQ1U4Z1dRbXBxUWdk?=
 =?utf-8?B?R0xyUlB3ZzRldnM0YUQ2dUVNSERqSVpkSWYzT3k2R0Z5TXFwKzA4UlA5WVgv?=
 =?utf-8?B?b1NSd3lpa3FWVklRTlBIaHIyUkprQWU5R29KTmhlZDNqSjAza2ZVZ3FSZFRm?=
 =?utf-8?B?Nk5FQ3BxM0FQZjVjcVVQRzhGeUFTMlJIanJiK2MrY2d1a0ROUUloaUFaWTVs?=
 =?utf-8?B?U1RlOHVQZHB4YUJibVZFOFZSeGN0SFkxZjlNS0J0MDVXbkRFbkM2bWJLaDdK?=
 =?utf-8?B?TmVSQ3BHQ3VtQ1JmVFdUTnNmRXl3K0V0QzhRcWN6eG83TTNPeFhMZHhOTmhx?=
 =?utf-8?B?dXZPN0ZRWS9mNFVqTGdxR0ZDcTBuOTFRNFA2Vi9WZ25ORXZWeDlJdElyblZz?=
 =?utf-8?B?OXFoV0swVkNyVHh0NlJYOTVuWmVQTTJMekhONFRrVHBpRWVpcVdFTm05cDdx?=
 =?utf-8?B?ZWxEYWRjQnExWnNCVVJUYUZGWTlDQkRWRi9TYUc5UGwwNkRubTNtWmNGU012?=
 =?utf-8?B?OVlDdXEzOGZEQ1MvcWVxcDdkMi93eWtKelNUa2dzK1phK2VxOU5nbmp1MWV5?=
 =?utf-8?B?TUZneHRPR3NhRG5KUm1yYVNKS25GckhzTHU5WHcyd0ZUZ2dLM3RKQ1NHUXBw?=
 =?utf-8?B?Z2ptY0NqTTBkaTRPVGtkbDNkUkE2dGpObXhtdzd2L2x2cjVLYi9hQzBHU3Rt?=
 =?utf-8?B?dGNacFRRRjBFK2VoZG9xMit2b2JkZ2hDZk9xT3oyc1FrN2drNVlnT2Fzek1K?=
 =?utf-8?B?YUo5UFQ2clh1VWhZVktnMUx3NzRCZ2RVTCtRUTVTd1FHaXNhYnhqUGxoUUlp?=
 =?utf-8?B?Y3J0bDJaVmtaQlpmUi9UaXhQSzdpaHo4NjlHOERGVVZOdy83YU5XanZUT085?=
 =?utf-8?B?RmJ6TlBVcHluY2M1OHNCMWNiVEZRbU8vbWowaTh3anlNY3F5TEpGanp6bTZF?=
 =?utf-8?B?cEVPNEREWnFrK1hRa1N6LzFCRkpleks0RTZsMDNaUXZnVVFnZDRKZWJmSjJ5?=
 =?utf-8?B?UWxib2JWWGRlb3FLalgvUloyaUV2SHhLVkNBM1NlWHBQUS9YSXprN0NCcE01?=
 =?utf-8?B?SDhlQVM1bTA3dnlpWEdRVlNqekZ4RE8rMzRDbXdsT2kyQis0S1dsOC8vRU00?=
 =?utf-8?B?MHp6S0tQSlVCZ2haVnloZ3EwU0xITis3TkRDcnJjc0kySmZzd3FUNTQvblI5?=
 =?utf-8?B?dGh5Y3VCOUtaWSs1QlVqb2JmYVMxU0hmbUlEczUra2ZITmFSNngwOW1hMC9E?=
 =?utf-8?B?N0pPdXk1YUlTM2JNQ2daTmhOVEpqSkRoUklzYnVldzZFL2FoUXdsblRiYzNS?=
 =?utf-8?B?a1JPRVVkTTk3K1JRU3ZRKzQ0YjBqUURxUFRzQk9CTzlMWWQ4NjFHZ1VuWWZ3?=
 =?utf-8?B?ZWNQYUJLYy9pRFJ0cEJFNVgybmlhakhBdkZWRGZyb3dyZk1ObmppbjdpUjNS?=
 =?utf-8?B?cDhndVV4c0ppaEVXeUh4bm5BSC8yYkVJTXNXcEtMdzIrS05PV0swVmtlSGNX?=
 =?utf-8?B?eUlaQkJna20yaFcrUkxRem4rdFo5aVp4MTZhS0xsUTF2azhJQXhKNjdEN0x3?=
 =?utf-8?B?V2V4OEpvN0paeTVNN0xtZFBIQ3oxY3F1OXFwRFZRTVF0b2Y5OTZ2dz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da7ab31c-ef9d-41d2-c434-08de813038e7
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9714.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 18:42:04.7650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iYpFpZ94qySYknYKigj+SazXoTjZnXXkGhvxQz/Xijj6kD1S5Vj7eNiysnL5rx39E6f9Q27AlcPZR/n3U5EvDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7475

Hi Dan,

Thanks for the detailed feedback. I have put together a pseudo code 
sketch incorporating all your points. Could you confirm I have 
understood the direction correctly, or if I'm missing anything?

On 3/11/2026 7:28 PM, Dan Williams wrote:
> Smita Koralahalli wrote:
>> The current probe time ownership check for Soft Reserved memory based
>> solely on CXL window intersection is insufficient. dax_hmem probing is not
>> always guaranteed to run after CXL enumeration and region assembly, which
>> can lead to incorrect ownership decisions before the CXL stack has
>> finished publishing windows and assembling committed regions.
>>
>> Introduce deferred ownership handling for Soft Reserved ranges that
>> intersect CXL windows. When such a range is encountered during dax_hmem
>> probe, schedule deferred work and wait for the CXL stack to complete
>> enumeration and region assembly before deciding ownership.
>>
>> Evaluate ownership of Soft Reserved ranges based on CXL region
>> containment.
>>
>>     - If all Soft Reserved ranges are fully contained within committed CXL
>>       regions, DROP handling Soft Reserved ranges from dax_hmem and allow
>>       dax_cxl to bind.
>>
>>     - If any Soft Reserved range is not fully claimed by committed CXL
>>       region, REGISTER the Soft Reserved ranges with dax_hmem.
>>
>> Use dax_cxl_mode to coordinate ownership decisions for Soft Reserved
>> ranges. Once, ownership resolution is complete, flush the deferred work
>> from dax_cxl before allowing dax_cxl to bind.
>>
>> This enforces a strict ownership. Either CXL fully claims the Soft
>> reserved ranges or it relinquishes it entirely.
> 
> We have had multiple suggestions during the course of developing this
> state machine, but I can not see reading this changelog or the
> implementation that the full / final state machine is laid out with all
> the old ideas cleaned out of the implementation.
> 
> For example, I think this has my "untested!" suggestion from:
> 
> http://lore.kernel.org/697acf78acf70_3095100c@dwillia2-mobl4.notmuch
> 
> ...but it does not have the explanation of why it turned out to be
> suitable and fits the end goal state machine.
> 
> It also has the original definition of "enum dax_cxl_mode". However,
> with the recent simplification proposal to stop doing total CXL unwind I
> think it allows for a more straightforward state machine. For example,
> the "drop" state is now automatic simply by losing the race with
> dax_hmem, right?
> 
> I think we are close, just some final complexity shaving.
> 
> So, with the decision to stop tearing down CXL this state machine only
> has 3 requirements.
> 
> 1/ CXL enumeration needs to start before dax_hmem invokes
>     wait_for_device_probe().
> 
> 2/ dax_cxl driver registration needs to be postponed until after
>     dax_hmem has dispositioned all its regions.
> 
> 3/ No probe path can flush the work because of the wait_for_device_probe().
> 
> Requirement 1/ is met by patch1. Requirement 2/ partially met, has a
> proposal here around flushing the work from a separate workqueue
> invocation, but I think you want the dependency directly on the dax_hmem
> module (if enabled). Requirement 3/ not achieved.
> 
> For 3/ I think we can borrow what cxl_mem_probe() does and do:
> 
> if (work_pending(&dax_hmem_work))
> 	return -EBUSY;
> 
> ...if for some reason someone really wants to rebind the dax_hmem driver
> they need to flush the queue, and that can be achived by a flush_work()
> in the module_exit() path.
> 
> This does mean that patch 7 in this series disappears because bus.c has
> no role to play in this mess. It is just dax_hmem and dax_cxl getting
> their ordering straight.
> 
> Some notes on the implications follow:
> 
>> Co-developed-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
>> ---
>>   drivers/dax/bus.c       |  3 ++
>>   drivers/dax/bus.h       | 19 ++++++++++
>>   drivers/dax/cxl.c       |  1 +
>>   drivers/dax/hmem/hmem.c | 78 +++++++++++++++++++++++++++++++++++++++--
>>   4 files changed, 99 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
>> index 92b88952ede1..81985bcc70f9 100644
>> --- a/drivers/dax/bus.c
>> +++ b/drivers/dax/bus.c
>> @@ -25,6 +25,9 @@ DECLARE_RWSEM(dax_region_rwsem);
>>    */
>>   DECLARE_RWSEM(dax_dev_rwsem);
>>   
>> +enum dax_cxl_mode dax_cxl_mode = DAX_CXL_MODE_DEFER;
>> +EXPORT_SYMBOL_NS_GPL(dax_cxl_mode, "CXL");
>> +
>>   static DEFINE_MUTEX(dax_hmem_lock);
>>   static dax_hmem_deferred_fn hmem_deferred_fn;
>>   static void *dax_hmem_data;
>> diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
>> index b58a88e8089c..82616ff52fd1 100644
>> --- a/drivers/dax/bus.h
>> +++ b/drivers/dax/bus.h
>> @@ -41,6 +41,25 @@ struct dax_device_driver {
>>   	void (*remove)(struct dev_dax *dev);
>>   };
>>   
>> +/*
>> + * enum dax_cxl_mode - State machine to determine ownership for CXL
>> + * tagged Soft Reserved memory ranges.
>> + * @DAX_CXL_MODE_DEFER: Ownership resolution pending. Set while waiting
>> + * for CXL enumeration and region assembly to complete.
>> + * @DAX_CXL_MODE_REGISTER: CXL regions do not fully cover Soft Reserved
>> + * ranges. Fall back to registering those ranges via dax_hmem.
>> + * @DAX_CXL_MODE_DROP: All Soft Reserved ranges intersecting CXL windows
>> + * are fully contained within committed CXL regions. Drop HMEM handling
>> + * and allow dax_cxl to bind.
> 
> With the above, dax_cxl_mode disappears.
> 
>> diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
>> index a2136adfa186..3ab39b77843d 100644
>> --- a/drivers/dax/cxl.c
>> +++ b/drivers/dax/cxl.c
>> @@ -44,6 +44,7 @@ static struct cxl_driver cxl_dax_region_driver = {
>>   
>>   static void cxl_dax_region_driver_register(struct work_struct *work)
>>   {
>> +	dax_hmem_flush_work();
> 
> Looks ok, as long as that symbol is from dax_hmem.ko which gets you the
> load dependency (requirement 2/).
> 
> Might also want to make sure that all this deferral mess disappears when
> CONFIG_DEV_DAX_HMEM=n.
> 
>>   	cxl_driver_register(&cxl_dax_region_driver);
>>   }
>>   
>> diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
>> index 1e3424358490..85854e25254b 100644
>> --- a/drivers/dax/hmem/hmem.c
>> +++ b/drivers/dax/hmem/hmem.c
>> @@ -3,6 +3,7 @@
>>   #include <linux/memregion.h>
>>   #include <linux/module.h>
>>   #include <linux/dax.h>
>> +#include <cxl/cxl.h>
>>   #include "../bus.h"
>>   
>>   static bool region_idle;
>> @@ -69,8 +70,18 @@ static int hmem_register_device(struct device *host, int target_nid,
>>   	if (IS_ENABLED(CONFIG_DEV_DAX_CXL) &&
>>   	    region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
>>   			      IORES_DESC_CXL) != REGION_DISJOINT) {
>> -		dev_dbg(host, "deferring range to CXL: %pr\n", res);
>> -		return 0;
>> +		switch (dax_cxl_mode) {
>> +		case DAX_CXL_MODE_DEFER:
>> +			dev_dbg(host, "deferring range to CXL: %pr\n", res);
>> +			dax_hmem_queue_work();
> 
> This case is just a flag that determines if the work queue has completed
> its one run. So I expect this something like:
> 
> if (!dax_hmem_initial_probe) {
> 	queue_work()
> 	return;
> }
> 
> Otherwise just go ahead and register because dax_cxl by this time has
> had a chance to have a say and the system falls back to "first come /
> first served" mode. In other words the simplification of not cleaning up
> goes both ways. dax_hmem naturally fails if dax_cxl already claimed the
> address range.
> 
>> +			return 0;
>> +		case DAX_CXL_MODE_REGISTER:
>> +			dev_dbg(host, "registering CXL range: %pr\n", res);
>> +			break;
>> +		case DAX_CXL_MODE_DROP:
>> +			dev_dbg(host, "dropping CXL range: %pr\n", res);
>> +			return 0;
>> +		}
>>   	}
>>   
>>   	rc = region_intersects_soft_reserve(res->start, resource_size(res));
>> @@ -123,8 +134,70 @@ static int hmem_register_device(struct device *host, int target_nid,
>>   	return rc;
>>   }
>>   
>> +static int hmem_register_cxl_device(struct device *host, int target_nid,
>> +				    const struct resource *res)
>> +{
>> +	if (region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
>> +			      IORES_DESC_CXL) != REGION_DISJOINT)
>> +		return hmem_register_device(host, target_nid, res);
>> +
>> +	return 0;
>> +}
>> +
>> +static int soft_reserve_has_cxl_match(struct device *host, int target_nid,
>> +				      const struct resource *res)
>> +{
>> +	if (region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
>> +			      IORES_DESC_CXL) != REGION_DISJOINT) {
>> +		if (!cxl_region_contains_soft_reserve((struct resource *)res))
>> +			return 1;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void process_defer_work(void *data)
>> +{
>> +	struct platform_device *pdev = data;
>> +	int rc;
>> +
>> +	/* relies on cxl_acpi and cxl_pci having had a chance to load */
>> +	wait_for_device_probe();
>> +
>> +	rc = walk_hmem_resources(&pdev->dev, soft_reserve_has_cxl_match);
>> +
>> +	if (!rc) {
>> +		dax_cxl_mode = DAX_CXL_MODE_DROP;
>> +		dev_dbg(&pdev->dev, "All Soft Reserved ranges claimed by CXL\n");
>> +	} else {
>> +		dax_cxl_mode = DAX_CXL_MODE_REGISTER;
>> +		dev_warn(&pdev->dev,
>> +			 "Soft Reserved not fully contained in CXL; using HMEM\n");
>> +	}
>> +
>> +	walk_hmem_resources(&pdev->dev, hmem_register_cxl_device);
> 
> I do not think we need to do 2 passes. Just do one
> hmem_register_cxl_device() pass that skips a range when
> cxl_region_contains_resource() has it covered, otherwise register an
> hmem device.
> 
>> +}
>> +
>> +static void kill_defer_work(void *data)
>> +{
>> +	struct platform_device *pdev = data;
>> +
>> +	dax_hmem_flush_work();
>> +	dax_hmem_unregister_work(process_defer_work, pdev);
>> +}
>> +
>>   static int dax_hmem_platform_probe(struct platform_device *pdev)
>>   {
>> +	int rc;
> 
> This wants a work_pending() return -EBUSY per above.
> 
>> +	rc = dax_hmem_register_work(process_defer_work, pdev);
>> +	if (rc)
>> +		return rc;
> 
> The work does not need to be registered every time. Remember this is
> only a one-shot problem at first kernel boot, not every time this
> platform device is probed. After the workqueue has run at least once it
> never needs to be invoked again if dax_hmem is reloaded.
> 
> A flag for "dax_hmem flushed initial device probe at least once" needs
> to live in drivers/dax/hmem/device.c and be cleared by
> process_defer_work().
> 
>> +
>> +	rc = devm_add_action_or_reset(&pdev->dev, kill_defer_work, pdev);
>> +	if (rc)
>> +		return rc;
>> +
>>   	return walk_hmem_resources(&pdev->dev, hmem_register_device);
>>   }
> 
> The hunk that is missing is that dax_hmem_exit() should flush the work,
> and process_defer_work() should give up if the device has been unbound
> before it runs. Hopefully that last suggestion does not make lockdep
> unhappy about running process_defer_work under the hmem_platform
> device_lock(). I *think* it should be ok and solves the TOCTOU race in
> hmem_register_device() around whether we are in the pre or post initial
> probe world.

/* hmem.c */

+static struct platform_device *hmem_pdev;
+static void process_defer_work(struct work_struct *work);
+static DECLARE_WORK(dax_hmem_work, process_defer_work);

+void dax_hmem_flush_work(void)
+{
+	flush_work(&dax_hmem_work);
+}
+EXPORT_SYMBOL_GPL(dax_hmem_flush_work);

static int hmem_register_device(..)
{
  	if (IS_ENABLED(CONFIG_DEV_DAX_CXL) && .. {
+		if (!dax_hmem_initial_probe_done) {
+			queue_work(system_long_wq, &dax_hmem_work);
+			return 0;
+	}
...
}

+static int hmem_register_cxl_device(..)
+{
+	if (region_intersects(..IORES_CXL..) == REGION_DISJOINT)
+		return 0;
+
+	if (cxl_region_contains_soft_reserve(res))
+		return 0;
+
+	return hmem_register_device(host, target_nid, res);
+}

+static void process_defer_work(struct work_struct *work)
+{
+	wait_for_device_probe();
+	/* Flag lives in device.c */
+	dax_hmem_initial_probe_done = true;
+	walk_hmem_resources(&hmem_pdev->dev, hmem_register_cxl_device);
+}

static int dax_hmem_platform_probe(struct platform_device *pdev)
{
+	if (work_pending(&dax_hmem_work))
+		return -EBUSY;

+	hmem_pdev = pdev;
	return walk_hmem_resources(&dev->dev, hmem_register_device);
}

static void __exit dax_hmem_exit(void)
{
+	flush_work(&dax_hmem_work);
..

/* cxl.c */

static void cxl_dax_region_driver_register(struct work_struct *work)
{
+	dax_hmem_flush_work();
	cxl_driver_register(&cxl_dax_region_driver);
}

/* bus.h */

+#if IS_ENABLED(CONFIG_DEV_DAX_HMEM)
+void dax_hmem_flush_work(void);
+#else
+static inline void dax_hmem_flush_work(void) { }
+#endif

A few things I want to confirm:

1. Patch 7 (bus.c helpers) drops entirely — no register/unregister API, 
no mutex, no typedef. Everything lives in hmem.c.

2. enum dax_cxl_mode drops — replaced by the single bool 
dax_hmem_initial_probe_done in device.c.

3. dax_hmem_flush_work() exported from dax_hmem.ko so cxl.c gets the 
module dependency for requirement 2.

Thanks
Smita
