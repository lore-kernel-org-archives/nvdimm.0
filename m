Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012060.outbound.protection.outlook.com [52.101.53.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370C3388E60
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 22:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774391054; cv=fail; b=gxpOGpOQVZX4E7Uv1meH02vCNCQXOGL9FCCwO4wnO7prOKlBdv5rjMJwbDL/PHfIsq8vbbp89hkjqKBVPn0BGEq0KmEy27MXppdZQD+h4aeEVqX89Wc8zT/foqd1dVtRGdP31EDQqkXgQpcAOUXa6fFxB/npLCNFcjC/pMyvITs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774391054; c=relaxed/simple;
	bh=MkntWKkySfAzBo8Vykp6mzSLBElkDrjIduw1UC0+75w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QxcGBFD3I0musRMAtlxvIy1Hb4F/sTLYjLwXxru09hmwQ0uspXYpsUwwFPH8WfKY0WL7jaDOo7PIq/YFp6oKgW5UBJkoHhL7LOc0YCgn80JZvsw0e7VI7TAuz6mTlKEP+Y+UN21zggkZOK78ZjONYQlyLE9iyDzNVNU3v6HLFSo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AVKT3hhI; arc=fail smtp.client-ip=52.101.53.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AVKT3hhI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wba9IJO7/nkww4x5KFO68HILvpAixzROtQ3/AitXl4Z5t0dCO45uPv7Mt4oAsmhji4VT1nM0Jl6MudRf4dkeDZcn2Y4DEu6xawLuxT3V91nN1G7CZ/9gh04MvPg5GK8S4c4iOsZb8yhJ7qptmfd90OVtayaV6J4yP+ZjHQshY6pu8K/0nfmQNnOGjoDlaPm+JkmHEdApMQJHbMvjZc1FGKwgS12mzJJSwyMPl8HJqFanIju/Y9DEdmi5gGU7e7vwPnC+OdeCHqHlOhxrdG0/zrtzKGJF/31+pFj6Nsr8caXN5cN7Ef+rEXd4/H1dQfvEZXC2OsTDlLr6JuYR6Z1QtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=33vsrY5mxSzPexEVPH4ia05y0WUrHsoNBo/a/ha3Qiw=;
 b=mWYPvq3Xklhp+bdy3gNPEE8aK3gkhy9tzENKsddJFHEz2tI+IB+qJs6wahoaAFKuIbcAmvTT2MjROVOf1hVTbE+y1ag49o8SyEpnOCGwqCQ2hp5c2XSb5l+LpyjvHoQXd9fe7u/Ta9vgIRXOip6zq3jMbdiyUaZjOVz2Q20ftQV/QCyCAZdbUkyXYPaeocZfcRU2ivw7PSU8sqmxBcfD1DMC5QEJ0qt87tSMDwD/uvycmHvuTT3FRfSJgXmRz3jxASstiHRHZidGxai+LCKbLeVDrPa5A1rv1PI+sbpBE6XTZ7fRInXuNIbvFML8w7vEqDxW9UFcDXPBHtzw4u2cWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=33vsrY5mxSzPexEVPH4ia05y0WUrHsoNBo/a/ha3Qiw=;
 b=AVKT3hhImR2Z+AYiG6i+g/XLqFeB/t2Il/Pq5yo8IM+KiiNjfGBCMAqtvkpQS177c4dP4aRiNXJRVrJJT8P8GZT9Iw20gHGQiiWjE96mHYUijmrAET+xEMOjY9BemzLRvRwKJ6JkBKBjbe3oxNVSooKI5HRYrpYQLTy9R/4BvmU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by DS2PR12MB9637.namprd12.prod.outlook.com (2603:10b6:8:27b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Tue, 24 Mar
 2026 22:24:04 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::9e55:f616:6a93:7a3d]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::9e55:f616:6a93:7a3d%6]) with mapi id 15.20.9745.019; Tue, 24 Mar 2026
 22:24:04 +0000
Message-ID: <e3f6c723-7702-4577-bf4a-2c9802a60c04@amd.com>
Date: Tue, 24 Mar 2026 22:23:55 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/9] cxl/region: Skip decoder reset on detach for
 autodiscovered regions
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>,
 Alison Schofield <alison.schofield@intel.com>
Cc: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 linux-pm@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
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
 <20260210064501.157591-4-Smita.KoralahalliChannabasappa@amd.com>
 <69b1e0aacb9d0_2132100c5@dwillia2-mobl4.notmuch>
 <absY10LzUqb3vK7A@aschofie-mobl2.lan>
 <69c2ea1ea24e1_51621100a1@dwillia2-mobl4.notmuch>
From: Alejandro Lucero Palau <alucerop@amd.com>
In-Reply-To: <69c2ea1ea24e1_51621100a1@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR1P264CA0071.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:2cc::8) To DM6PR12MB4202.namprd12.prod.outlook.com
 (2603:10b6:5:219::22)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4202:EE_|DS2PR12MB9637:EE_
X-MS-Office365-Filtering-Correlation-Id: d0ae5815-0f31-4a1e-69cc-08de89f40e81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	TbTbttl9rKuW10MMDMixo0Ulx9L58sp8BbsAEABVZsV5xqd2fi2XsoZIDQxm9vQBJ+SSViUpmFP36pzD0mXUA3q3hjB7/PpRdtQIrJBPcj7/8MosFFdy/oG77CI3jpedPCm7u95hBNuT1yewgUbwDpQJ4nUh21yhmL1eJ87JfzLyYPr69DVeYQ94H1bVlUZoFGEOBXZi8O2iHeR+hW6xVagVjEcoU2w095g0kgljn/83KG4BqWlBeRImQwbIW692D0NPG766esVAtsM+/DruSnq1gFZwfUcKbS7g+pjrvYd0YMt+SsYECmqZn3264+VN5JGZFyMVV5bAY9D1pMEwCfbCfxKMJ9CaOLQs3Jb1juklpYjODbkfhF8ZzIHK9C8MMZysSxUlhK97GtjDtHLaDbYYYH7OgmMcI76+Sy0a0Px7+GHACwBJ2FZs2KR/e+QKFYo5Scl7/XEDUZkyUMjsXvpiQ2eLfAUPibk+OAq8Z/3Prqxyds3ltfTmHdr1CVoVcjZeaZzW6tpkh7zeIgjZ21sQnhnRCzS2swIpMdaeodHzXDe0qwKDl+gtcu5exuqUlzUZgJ7gNk2l18wJpi9KSnD4cAJr49FK4Iow4de4YheRXlTpoJmtKp2QCKFSZLNp+NC79T7ViEIrRyhvxsD9+8CdXj8HatiU6do0Su/oa/JjdyibWeQoS8ICVXTB0E0yUyL7YpJcbbJ0Swq0nDsnNy3ueRDSZSNHAvrb6khP1eY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RVlmZU9Rb0xSTEJWRU5IcmRMRjNvbWVlY1IrWEFkUUNWNW41ckxIU0dMZDg5?=
 =?utf-8?B?Sm00aERSRW9ONjY0Q1NHdXA0ZWVtd3JEVmtWWFFvQTZzRmtUdERONk9RQnM2?=
 =?utf-8?B?RDE0ZW82VjllQnBIR3dPQzJUS1d2dENsSVlkZGdRYUsrVTNPc1ErSndYcmJt?=
 =?utf-8?B?Mi9RUDBSVTF4ZVhsNEliT2tRckxHZmxxazVVQ1R3SnJXUFBOY05pV0IxOHBK?=
 =?utf-8?B?MnhRZnB1L204Wi9tOUV1WXhVR2FKdXFWamZIWTZPQ1p0RjdxTkxQclJjMWRU?=
 =?utf-8?B?MnEzTDhPQWpOcDdxQzFNMkV5WGxpSU5SeVIramZpTjlSSmxvZENnYXNDTWdn?=
 =?utf-8?B?dThBRTdHdTRlOTE4eDdiSTdsbzYxcnN3ejYydjlubXoyNTZlU2J3c1ZQSWNm?=
 =?utf-8?B?TUkyZFpORzUzMUVQL2FqWDRoTWhDd1RQUC9oVU40RG5QTzcvMTdtTkk2ZXNn?=
 =?utf-8?B?d3hrSlF5cjZmM2RWcFlpZUwzNENXN0RYaEFIbXlaek9GcU5aV09DcEtMMGxV?=
 =?utf-8?B?NGtyZzZXaldlQms4eVZjUGtIZHdMRy9NZ0tkWWtsV3EyYVViNEVkM3hUMmM4?=
 =?utf-8?B?cEFEZ3JveklhRXlLc3RaUU5UdG4xN2ZrWDNlVFFjQzA4bkJmam1tWWVtSERv?=
 =?utf-8?B?QkFqMUVTZHRDd0RkdC9mUXM0MFJobWowREdNUC9Dc29lVS9UWTJVRUVsUnox?=
 =?utf-8?B?Q1BvcG1sWCszQ1c3RTM3TEFlUFNwZVFpdlA1eVBMS1FaWno2UUtxMnloOFdX?=
 =?utf-8?B?a1NyYzVDeGNtaEEyQWQxVmdlMGNLTm5wQUg3Z1o1Q1JBekhvaVgrVTdJdlRi?=
 =?utf-8?B?Rzl5cjZpUzNqd2Y4ZkRnK1ZhZ2UzeGQrMGNBSHN5dzVNb1VNWHJtcjdvejF3?=
 =?utf-8?B?eHJpZTJWOEZGNTl3MHpHR3Fud3RUeXhlOXZnTk53WFI3WUUvd1lVQlBYQ1pL?=
 =?utf-8?B?MGFzeVhJUW54YXFMZ084QzdGdFJrUmlJa1E0RmhXTHlCa1hZaWV4TzhHL21m?=
 =?utf-8?B?ZURkZ1o1TTRhSjZZRVd3Wk5xeWpJTnJad0RZK0xRQmg4Q0JaaVFOVUJkN3Vj?=
 =?utf-8?B?bExGOWJxYnZhWUlHUE5ZTG13VVp3UmxLUjRORzVoV0VUQVVZL1ZCSE9mbGNz?=
 =?utf-8?B?bDFkNDZ5RE15LzF5SFFlQmEyQWxQMnpYWXNRc01nZGw3WXh5SFJ2blRoc3Yx?=
 =?utf-8?B?V29wclZhWU9BY0dVRGh0dnF3dTN5djVvNHFtemtqSk1ybjUxWFQ2aTBMc2NR?=
 =?utf-8?B?M0hQeGRidVhOY0ZNR0FmK1V6bUYvZVhnaThaRFNEMjhjeksveXJLckcwOE9E?=
 =?utf-8?B?OUJjczd5ZGc3ZEZxZ0E3ZFlCN2RPaG55Y2hJR1ZURUJCVDYrTGk1djdJblVS?=
 =?utf-8?B?em9XWXpBRE9ob2xwL2V1TFg4WU8zaEd1cVBmbzRTVHJBT0loTzF4NDRnQ1Nq?=
 =?utf-8?B?OEl6d2huMmVGaXN0dTFibnBOQ2ZKbDdlbG42WmxLc0Y5VDdJNDZ3S2NieFUx?=
 =?utf-8?B?YnBuWHRibEMrSVRuYlllcG1qT2tkRTN0UDh2SE5uanJuL245bFVkRVB4clht?=
 =?utf-8?B?MklQanFqa01IcUZhM0Nsa3Yrd25TWkpDTW5xK1B4SWlvTExlRjJjTC9UU2lI?=
 =?utf-8?B?NnBNUE9SaGEwSG9DUDJVUXNXNjdvd0c5NnUrenMwa2podnhOSDNLQlEzTHJo?=
 =?utf-8?B?MkFBd3QvcXNHZlBCSVkwT2tIYWZtREFlTjVqYisxcGZXd2tJb1hHTHIrZEpL?=
 =?utf-8?B?Um5aL1hTSmhWZWQ1cVhjOThyQi9BWk1HYzZiT3c3WHhnVG0vbnFOZGhCQ0Fq?=
 =?utf-8?B?S0xRd05Hb0Z5MTF3Um45WjJ3ZjhTaU9tcHVmR0RGTnJaV2ZQUVIvaVZiekla?=
 =?utf-8?B?VWFSeTUvN1hMUEtjdjkrSi9LQjAxWlBxR2c3ZGx6TGVKMkpRaUxaTVE0RGxJ?=
 =?utf-8?B?QTR6TmhHNU9KOWJ5emg2ZFJOMytVYzg4RE0xU1lJSVIyaTJmQys1eXNuZm1j?=
 =?utf-8?B?R0dkYnY4VU1wcVJwT2U0YjhEWEZHZzR6ZkZkcmZBZmN2UTFEQkNYeTVsMEtN?=
 =?utf-8?B?aW5MelErbWNXK1B0OUphMHIxaXZyYjNGN3pUeVNLUVd2ZFpSUUgyek4rVEpy?=
 =?utf-8?B?dHBQK2ZDck05dG42Y0FPSnNySUlLZVhoUDd2NitDdFBGVUthVU5WTmJRZmVP?=
 =?utf-8?B?N0ZNV0RhWjBhSlR3RmtUSXZsMnpHTURTU3VUN2l3QmdQREVQNzNNdUc1dmJz?=
 =?utf-8?B?Wmh6ZEVtVlNuSmp4T1pJdEx4MTRmUXlRUFhKNUtJRkdjaWV1ZjNWeXJzRFgz?=
 =?utf-8?B?L0NjOHk0ejBBL1VNek44YlF0NlFWelIxUENmZ1RMK0d1MUQ2dklGQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0ae5815-0f31-4a1e-69cc-08de89f40e81
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 22:24:04.3113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tsmw33AJiQ0O23eTaAO45GVR1o2YpGZv0OG9KW3yYF3hJ2ztLsN9iTQMre3oyb5IyT43PGRKFG2dDgkLqqA7+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9637


On 3/24/26 19:46, Dan Williams wrote:
> Alison Schofield wrote:


<snip>


> Like I replied to Alejandro it is not a dependency for the type-2 series
> [1]. It *is* a fix for the issue reported by PJ, but it can go in
> independent of the base type-2 work as a standalone capability.
>
> [1]: http://lore.kernel.org/69b8b9181bafd_452b100cb@dwillia2-mobl4.notmuch


I'm afraid I do not understand what you mean here.


<snip>

> Just like the decoder LOCK bit the preservation setting is a decoder
> property, not a region property. Region auto-assembly is then just an
> automatic way to set that decoder policy.
>
> So, no, I would not expect a new region flag for this policy.


Could it be acceptable an accelerator having the option of locking its 
HDM if not already done by the BIOS?


<snip>


> Appreciate you pulling this together. I want to land type-2 with the
> existing expectation that unload is always destructive then circle back


As I said, v22 had that destructive behavior, but v23 kept the HDM 
committed, as that was what you asked for.


Last v24 has only the support for dealing with committed decoders, what 
is the expectation from current BIOS (Intel and AMD) if a Type2 device 
is found at boot time. I got now some BIOS versions which lock the HDM 
decoder for a Type2 device making impossible any destructive action. The 
reason for only supporting this case is to have a chance to be in time 
for 7.1 with the basic (but good enough) support as there are issues 
with the changes to create a region which will need all to agree on how 
to solve them, and unlikely before 7.1 window closes.


> to address this additional detail because it is more than just decoder
> policy that needs to be managed. The type-2 driver may need help finding
> its platform firmware configured address range if a device reset
> destroyed the decoder settings.
>

And again, this problem should be addressed, IMO, as a follow-up.


