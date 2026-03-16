Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010062.outbound.protection.outlook.com [52.101.61.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5609337268C
	for <nvdimm@lists.linux.dev>; Mon, 16 Mar 2026 22:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773699996; cv=fail; b=X483XG8LVNEU3g1nHsytpit7MZUhFGC2KJ4pc3Qa6avQvveYzKplDz1MsnSTPpvuAsYgeyI77qBE7aZfBGKqKuSd/hu2awk5pu/lIld5HP7IqEe4x4e1bq90GH8pLtoadlDqtq8R75qf2dm68ql7GWTKb0k4Qr0AzXMU5ZErLQE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773699996; c=relaxed/simple;
	bh=BPit/buO1IBd+hTqS+4D23TF1JhbSOJrNS7QkwlmAgw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XjDZRicNi8ycvN7Cw06tHFjm6W352iO9uDD4DuVG+lhMSRvvYyihEhzM1Ad6MgJ3A7/ADGs/vdh1/18JQysn11YBU0Ex29BYDC8tRklwbNbFKe0QCnBnyy5YOlkpgOIz3QZUslGMABAwwxRTVEf/hO9aiNVz7IVAsGtLjKijubg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UUH0bMjE; arc=fail smtp.client-ip=52.101.61.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UUH0bMjE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hlUJk4Zw2FFQCBF/IQ3PXeM7jJmBK2V9Ze/clOnSpzjL2sl4aiKb9yKiSBFYA4ZLs8ewW3YZakYXMk+hI5caHdSAeDKkL8SOWiAfX/4RBll3Bsfotcnc8HYCIJyahttOYjUktyVssn65IukrNvKop07MMrS0kbOaKOLUOHy7Usqg2AS6mIPaAj1wtiCiquzLOR/WsK36mOSGzomLI61rqv9Z9gTNJxbY3L5hfvBowIojQFnqka9ICFLtNpUDI+yYFG9rc4CBmMRTGgZ3BSALZRmr0SC9DYjhKk2aA+gvqXwR0y/RG55OTKNfS27DdaEoP/goo5aoQ2X/krh68Ws+WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=73MxnU5ROoIauim4wyTgeQH0oJn5S6lt7pAjWQwdiDY=;
 b=MNuZZCXR9qZ33KxyOzqm9glqSrZsiQz0ZFbfvr1/xda+gs/3G4KvLS/IXP+YoXqC88jKcK+7oZDVv/rLOA2BrfkmDTdWs2ru+EwowL8y/whIM4BqPDiN5/A448hxPsmkePxh8xESG2BPK4ueEku4kF6mlpzWvtjUzkJa15/yQBlJQfg7ak0+QDrM1W4jCiutQhkQUtxBYC/4e5DFFwNIU3ZfOiz/fwnl/usGsO4W3IIwBpiCFLpvUvUnLvlVDb/nruDgqlzrvVncjKgsg/KWWWWPJzV8PA/wAVSIj9eGwAFc6rWQ/aWGRUZ8paDhsY7M2GXC8DyF9XvxvNOu2vhGPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=73MxnU5ROoIauim4wyTgeQH0oJn5S6lt7pAjWQwdiDY=;
 b=UUH0bMjE87jAFYdZETHzzBCXqrQQaCtAOJje2Z0fYLuIx2p1A0XFSVf8G8ktd3C26YlNpL+47yEn9Y+WYtMpPyPZEm0An3GGfMgohY+2T0Zk7tWj2ksio4H6DFVBqychuXkmqSNm6b8dRaTpdyNS0gO5uiZ1UIv/xg7dGdDUNgs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from LV8PR12MB9714.namprd12.prod.outlook.com (2603:10b6:408:2a0::5)
 by DS5PPF884E1ABEC.namprd12.prod.outlook.com (2603:10b6:f:fc00::658) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.14; Mon, 16 Mar
 2026 22:26:25 +0000
Received: from LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6]) by LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6%6]) with mapi id 15.20.9723.014; Mon, 16 Mar 2026
 22:26:25 +0000
Message-ID: <e8a1b3c5-61cf-4861-af69-69a3ad323b2f@amd.com>
Date: Mon, 16 Mar 2026 15:26:21 -0700
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
X-ClientProxiedBy: BYAPR05CA0047.namprd05.prod.outlook.com
 (2603:10b6:a03:74::24) To LV8PR12MB9714.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9714:EE_|DS5PPF884E1ABEC:EE_
X-MS-Office365-Filtering-Correlation-Id: d802833b-6267-4297-f24c-08de83ab0f51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	rJviAYwBjblUArb7la3aYPSZQFkaKn5zSSd7zvLHgTGVcnXOzbfYmrl9W5u0GAyM/Ce1L3tHz5jRMYZxS9cDDlSu7z8J2kxdRTXPyPMzmQ3V5OgLQwtfNAwYPiW+4zTL36xHKJDFW5ZQSgzfJLQnK4qylhk3WuHQXDpaTpESupP4FFzoCjzj3E0Nq/P1uAqzZzCdgpsoCZtQCTilHlDrUZ/iyFYS7b+AxPs9aqb4cyCbDfzd3gveCBYR1ph+Nmq0ansuNrGbQXJ1ke+/1aLae6LC37VNz2huEvYgddY/UJAQGHEa6akVIizd/0KkQB4h7Unp/q/hAuU8/7txHi3X9WBQNEOz0doNeLxBV2Otpxt448g9qiQNRXM5IGgTLQEQNJci2vjgoxievKSlEtRq3KiIbt6ud9IZ/C90dtPVLylulkN5XfK5NOWx6p9EG5qxNwiD6LgQ/cl/VmWM2GDI7TpWILW2kkDS/M9xvEYUU6F6EtgyL3SWZ94TSz4HJpNrg+fBejg5fgWkE9Hf2Yk3T8l/9JDJnODKYOZWYmSW4DqgSZgb6Ia8r0Sw3wqCM6qXE5Z7DOCenlV9r4A3m79Tp37H78g2ulajgLVkrFsXOMFQIMR9BANVs3sLdguhl/yZteMX+ELxAMP8IF2eL09cEDeWZi/3zBS2rlnh9NpxeFJEMnzlrdZrrD8BSpUG1swxOK1UH0psVjaBAwfv/r0T15dZHsoOeKkNEG4oWvzGWe4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9714.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QVNXTzdNQ3VoanAwVGV1SThqOTNGdHNaWHFHRGRuSUxhcnlwN2Q5UEZlQ0FB?=
 =?utf-8?B?cy9GZFUxNy9lblNCVUZIdHRpa3phSzB5WWFiRkxPYjgwT201aU1pT1B2Q3Nr?=
 =?utf-8?B?ZWsyTWl4ZE1xcngzL1RRQzBSUFRnajRJa3R2RjBoWHkyVXA1dy9ZNWsxc25m?=
 =?utf-8?B?eHk4cHk1Z3R2alV2by9OUXJVcWpFVUE0bnlpd1N2R3VjL0xYbEtNS3Joei8y?=
 =?utf-8?B?Y2twMk9qQVlHK1BCbXhMQmhISk5GcEFSS0prZExNSDZsZDcxWllaV0hDZjBp?=
 =?utf-8?B?UGVlTi9nVThOU1NMVlp2MWl4OElCQ05jWXgvblVMeDcxd0pvUWlMaFA5d0xt?=
 =?utf-8?B?dG05TU5YZHZySWVJVyszMUVUM1h2bTB4bENGN2VuaWFDMm1tMVZ4VUc3VjBz?=
 =?utf-8?B?cE1Yalk4L1lOVld0U05TYkpMbHVPeTNrZFdKS3VNN2Y4c3k2ald2ZnJMYkhx?=
 =?utf-8?B?cklZTE1CekxrK3hlZzh3bEhmUVo4OXNEaTNpOFFIOUQ5K1FlUjA4bngzUEVx?=
 =?utf-8?B?ZG1RY2FwVmJtcEFhdFJzRTU3eE8xdXQ5VjVNZTdhYjRiMXMzcitncjhNSXgw?=
 =?utf-8?B?dUhtUUc1dlk2cXBRTVg0RlF2aDhobDQ0SUtseHg5RU1tN25rTS9uWmxBRWVN?=
 =?utf-8?B?RUpDYzBNeUhQVG5wOExPZFlDNkZQTzVPU1FxS1h3NlJ6R1haREJNU0pyV2pF?=
 =?utf-8?B?SU9TNHlUVHNYb2IzNXNxeGY1Tm1xOXB0NlJlSjBaa093d3BDVlE5K3pJQ3lh?=
 =?utf-8?B?WmtIYlcvdHRrdW1TTUI0ai9xMmoxTTU4QnhlL2hxZVhwRVZhL0o5akR0cDJ4?=
 =?utf-8?B?Y1AzVlJ1Z2xKeHBXdE8yWjh3b0I1cXNac1hlY1JlRHhJQm5uZDAzVjgzQ1l0?=
 =?utf-8?B?bVFSRnhTMms2dDN1Vm1GTHBDRkk3cnIyTlovTk81RUhBZE9PenU2Q1FYNEc2?=
 =?utf-8?B?VVJaVytXUS9nZ09sd0MzOFFzVmd5cEl3WkNEajhIb25weEpsb3pJQUM5MW1o?=
 =?utf-8?B?amdTVllSR2JTZ0ZxTVpNNUwvN04vQUUzL0N0eFBRMGI5c2hCNUVIZDEvN3NY?=
 =?utf-8?B?YVhTRG1tZVhIdlNDTGpzN2lJbDl6elE2UnB3M2tWaHplNThqc2FDUW5kRzZk?=
 =?utf-8?B?NlFoVHFScXFJVXVWNEdnaURWb1JRcGpLaDZMc0xmZElxL01xSGhoSTJTbjIy?=
 =?utf-8?B?SW9oMnhIaFp0K25LS3k0R04rc1A1QzVXV0c5RCtSYkdVNmU5SitEeG11RjdK?=
 =?utf-8?B?cUZXU1hTaytDMEJuZ2ZlQUx5YTU2THVBZWtkVi8wVlZJU0VmNUNaWE9ZenlP?=
 =?utf-8?B?VGorOFpPMmJtQThqU3RBZE9TNHRZZzFoL3czdEZiQ1N2SmI5Z0kvd2IzOTJl?=
 =?utf-8?B?bVZjdzJIS2lYMTZ6ckhuNlRjWHJmN3VUc1JQMTlFdEpPa1dDd1J2blRTbVpj?=
 =?utf-8?B?bUZ5dDZscHpTZlZoMzhhbHlpMlVhYTdabXMya252U3pmR3pzZlRZaTZudzNE?=
 =?utf-8?B?T1NIdVJOaDBtVTl3Tkx1QktzcURHaE55aXp6VVNtOXZyU0RPTENremt2enND?=
 =?utf-8?B?U1NHbzBzWUJIenlLK1VKbzk2OUU0OWxMNk8vL0lRN0E0b0JYdTRBVTUyM1V3?=
 =?utf-8?B?SXFxVDkrM0sxTng5cDFhSU1lMHBMNHVHeXd2Yk1oQmd3UUI3TTdZYWJWS09X?=
 =?utf-8?B?N2FFTE1VZDZCbEVzaGhhZGQ3dFVqTXlFOHRSOEV2NXZydTROa3k4a1dKUzFY?=
 =?utf-8?B?b1Z4bjl2SkRkWFhjNW5ZQzJGMHdHeEF3TDJnbEcyZUE3WnZmZDR1Z2dQZ015?=
 =?utf-8?B?YUV0MHVUUjdsZmhnK3NaR3B4dzVUNHFJSVBoRzhaQ1BLZnJJZjV0VDVpa29a?=
 =?utf-8?B?OThNMFhaaEpHSnhGNFBKcFE0YnRVSmQwVGdJVFJWTVV0YVIxN3JaOEVFYStL?=
 =?utf-8?B?eGVOa25WeENTZ1Y2KzhMTlpiRndFWGhxYVU0bkk1cXgydTlhR1BIR1Z6WmQz?=
 =?utf-8?B?MEM2b25zeFJ0eVZ1NzBZUXVWL29HV1BtWnplc29JVUhNVmZnaDBpby9qQktw?=
 =?utf-8?B?NW5GalB5M1BPVGk1ZEU0cFVUazZ5TDJIVW1XcE54bk02bG01QWNaZ3VYUGhB?=
 =?utf-8?B?bTBGbUxmSnEyNUkyZnFpYjJ0MDVnYXRvUGFxejd3czlUdmhiMXJHUStWbmZr?=
 =?utf-8?B?aXROWk9kM2pULzBvdnVhQUxtUnB0VWpGQ1pETDdxN2pKYTg3MDYxY0QvallP?=
 =?utf-8?B?UjBRZ29PM0hWS1pjWlAzK1pRVndBdTRzUUxvanh5Z1NobFpxWDNhYTBYL1B3?=
 =?utf-8?B?TlA0UjVnUmVZd1lRL0ZjdFU0NFY1S0p5SHFIdWJ5VUVPSHFTcTJpdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d802833b-6267-4297-f24c-08de83ab0f51
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9714.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2026 22:26:25.4581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MZp026Y52v7rw/viHyt83lUtX85ZdFQQq0TPEqJRQ2ZoA7aiT31PB97vw6ollynzPQ6i43o2b52C31i16NO/kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF884E1ABEC

Hi Dan,

[snip]

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

Just want to make sure I'm not misreading this — are we dropping the
all or nothing ownership approach? In v6, if any SR range wasn't fully
covered by CXL, all CXL-intersecting ranges fell back to HMEM. With the
single-pass hmem_register_cxl_device() that skips individually covered 
ranges, we would be doing per range decisions..

[snip]

Thanks
Smita

