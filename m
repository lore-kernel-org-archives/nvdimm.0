Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012008.outbound.protection.outlook.com [40.107.200.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE833EC2E1
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 16:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773938752; cv=fail; b=lqjfOEKY2LuARiD3eIHa0HwDLiOkVcTT9HmFC+EsTEKLMakURX3kju5n/LKfieYuAkGkyv/MU+IurH1jeGEHREXHEgKffy/q6GF4Qse3ApvsrRNRJgjtS6UrzmvyujkTPrT1JJuZ3wUKaz605PFcnXAOmncaLRBIUI7W1k3fuUs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773938752; c=relaxed/simple;
	bh=PEMP1bS99RWPXrAdHwiAjJbT4Wv27f6XbvHb8qks8BE=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YsTUxrSWx7HhoBAEqLqwb9h0JabazgqFU95jVIdIVE8l67hvfpLsY56dxlFwB/r7O92VBHGeuiQehLpJ+B43tB8bXp0k+7DckYb1AUapX4tjaYKWt9BeGNad3ey3iDCD1oSFEzqlA2/uAehauibGny4sNdDhtLZNYz6fsq66ZlU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=d2n+RMyU; arc=fail smtp.client-ip=40.107.200.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="d2n+RMyU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n/5isr5O+t7R5lZ3rY/Jfk/mJT7QmWwtFvHyPtcRqdD/XosLfyZzggQWkuHrNksRglFqJtlSGvLyE4Q2AmITWfFbbYUWaGNTle3SKoEyQF4oYzqKfCOG9HZS5K8YnZEtQ/dqeTHpsAcv13u8arvrSQIO09o9f+TPQPdgIxlO+1IAT5N6lWVONmEUHca9s0qJNypTk/IxAofIHP7cDz/Xl2OfYpTnB4ponBsdx9ymYLTLqWfYFDxHLCuhJNbD3XeteVvCiw7LrlMnO7wRhTtRXqGxBsHbucswpNrV7gipZ9FJQ0NGuU3XxHhEOBDQxZwi157KfNjoGsmuPpgRk3Qlgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JeRoF9dohZWUEqsNlCeVNc69yIY08sM5/OvlNAz9b14=;
 b=EeklYUvwEoN84pEYOUZERdu9CdSD2tkqkKokd7Ue0u9YCfmHTGLBvi4OviugdwC3c9kf51odPHF6bUtuqqvZcLDi9Me0okWsEdTop5pOjKVkWI5zLaSGZslQjSiDPfshediD8hPALebQ+05+OxAGANbHrTfTJ4nRsuAe9mdCrSelvnqnNVD3+uviQNMl1FhctTUvO75/zgw9VxX0ftOupralvrRR1m3v4MWm9WAhkzRfJpAkhaFNv0egI2oYjwmC77b+r3E2ZlX08IxsLH8FpDe+ijClFNUPcAW52bKrZj283p42jjz7l2zgRALnAihNf5y+Iv/k581kTnD1xtEp8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JeRoF9dohZWUEqsNlCeVNc69yIY08sM5/OvlNAz9b14=;
 b=d2n+RMyU8fFfcUYgQfvO7P/DiBRkCsSywPxuuqtfbFRKqoEY7ItowvFbFLuyZkhTcjTsW8SyH2qSpuEV1ET6C0xv54sXIZWIrGqmNlc1XaHHdhShjqJoN4SQsIhhyx6h9g4r/ibgqBDU7DBRkoXmaipJT3kgf6++YDUlwmTICPY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from LV8PR12MB9714.namprd12.prod.outlook.com (2603:10b6:408:2a0::5)
 by CH3PR12MB7643.namprd12.prod.outlook.com (2603:10b6:610:152::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Thu, 19 Mar
 2026 16:45:42 +0000
Received: from LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6]) by LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6%6]) with mapi id 15.20.9745.007; Thu, 19 Mar 2026
 16:45:42 +0000
Message-ID: <b56f55b1-4281-4edf-8aa4-27d0500ebd60@amd.com>
Date: Thu, 19 Mar 2026 09:45:38 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/7] dax/cxl, hmem: Initialize hmem early and defer
 dax_cxl binding
From: "Koralahalli Channabasappa, Smita" <skoralah@amd.com>
To: Alison Schofield <alison.schofield@intel.com>,
 Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 linux-pm@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Dan Williams <dan.j.williams@intel.com>,
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
 <3590e2d5-e768-4180-82a0-c972101f3440@amd.com>
Content-Language: en-US
In-Reply-To: <3590e2d5-e768-4180-82a0-c972101f3440@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0171.namprd03.prod.outlook.com
 (2603:10b6:a03:338::26) To LV8PR12MB9714.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9714:EE_|CH3PR12MB7643:EE_
X-MS-Office365-Filtering-Correlation-Id: eb087bf1-7d19-4d08-2113-08de85d6f5d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	yHY+midT8c5mMvNPfc5bNPCfYiWnJ9R9qRwqvTPlLFyPLM8h6HSMV3T1gIklF8RLiLXBQI74h0shWxgtWZns+tAqFsLhIZJ3xLVur+bhY1kOCiq5JDvDeEUl8EgBwpCmPhAMu15jY3ozARtXQ7x673PUrjSgFVw//VXXhNhzMw0n+Oivh3Y56tEtjc3jv4shXle6DbkXtT3fIZ984NU+QjdYYc1UXZsoJsEY24v/Z1kIdXfFpmfJFhQPrRLFUu4xzV1Pa9EMlq+F1cbt4raAVytkN2Cld8zxCx5kKHR4cFzGqS9+6NS45QIjeyVkJ9CFMSSDMuGDkIG1od6ExkmSRnHvoEWLIzN7feHilyBCpTj8/7Gg7a7Um+lJw9u5mdNVXEGJd0zAqtTrOq8IuikAEhwDVihINq5b1Ga7TN2BhZ8/fP6sTTRF8hORU+X4q09BQ87sfjdDcY+SulqTHqYY/1Cuq0k1yGxvzsgFybphsZrm0k34QwXLJLgDG53PT+uuNeolgggA86tRFR5uLGi2z9cdjyrHD7MvemgtmSNQQx7jNVFePvbLQzgJMh/yM3tA0WCWE0H92hSwg65umvwGlkEWHAebKVL4X2ltdzOWvN4m4NZvGRbT5CTsvvv01n6uBxhrbWx1CyN7uSrYu2VRQdx30kLxt6TtgsI1BfTqyzJILzu5Rrm9lfEJcNkISWM6kBwr7AdXwwmZohIRixwhs2ng2YMLerpISRtcktaj4cs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9714.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UzlHQm5LOUVCZkhYZTBxTVNSVCt2NjhHSVViSGcrRVQrbXgxcE5aUzhvK2o3?=
 =?utf-8?B?MnNrd3A5b0hFaU9tTlZ2NFRlaE1VVFhDYTRPWGc5cFNObDZ3cmJrMTVzV0du?=
 =?utf-8?B?YUJUM1pwRjBtVjhqRFlXYjczUXhUUlErMzVldGtCNFJhMFVQRnp2TXJkZXg5?=
 =?utf-8?B?TVZIM1VXRDJsUGNXVXh1cEJJaEdXYVAwUDk4eEVUS3ZySlBPY0Z0dGNtWTcy?=
 =?utf-8?B?dlhFTGdBZ2Q3TTJrMnpNWFNMMnhnZ2QvOHhLSUQ3eVhIZ3ZxeXI0ZnprdW1a?=
 =?utf-8?B?WDNGV2dVZENtb2xIcWN3UGJVNHJqelBXQkFlZlkxWHNsU3FLS0cwYlNHTTdL?=
 =?utf-8?B?UC91UjVwbUFERE5MNWJtK0ErRW1qV01IWXlJR3dkbTVPbnBpRHJJSUlNUTFN?=
 =?utf-8?B?eDhWdGRtYVpydWcvNUFabWdicGYxNWxRYWhnTjJhM2tpMVJhTmV0ZVdOcFJS?=
 =?utf-8?B?dUNZUm5zRU9qZTRGZ01VUFZPQ2RxZjJqcUs5bnlzMmZ4ZjFyVExGNDlwazdM?=
 =?utf-8?B?SHgxanQxVGp5QlBac2xLVmZUa04wSlhxWHd4cHNpUnZXcXV5M05JZ2M0RFdU?=
 =?utf-8?B?bE9wOXN3cVAvZnBkclFzdkJxcXRlZytCc2FqMldONFlSL3NYczVET05HRTg2?=
 =?utf-8?B?QlNYajZvc2UrTVdUWmFrdnVSaWg4Q1MrVURTYXB4bXJicmhHOHVkK211Y2ZU?=
 =?utf-8?B?L1FWejI5NW9VWEFRcncrd2ZXTCtneURwUjhXRXhqQzRpSXZ3cVh3OStCdGpZ?=
 =?utf-8?B?T1Q1MWVDZUl1bmV5MHJQRXloYk9BcDU3SGxKdnp3d2NPemszZ0FrczBTclBo?=
 =?utf-8?B?NGY4WDhFa24wQ0xkQUNUdVhvOWdCKzQ4UjVpQXRMWjk3bDVxWFVNQnordEI2?=
 =?utf-8?B?M3BBNVNmUVV6UDZqdjA5UXBHYlh4RGVzaXFoMjMvVFRRNGg4YXQ3c3BhaGdG?=
 =?utf-8?B?bVdiUHJ3UGxIOEY4MFc5SVFKcUIwaGZLNmJBMjNudzBmU3lBWGN3RHg0VW05?=
 =?utf-8?B?dDVlbE1pd3RueVlqdVAzK1NUU1VrVXpFUXJVRGRqekNtSlN5U09yZHVyTGN1?=
 =?utf-8?B?eTVQNGpLSU1SY1czR0hGcVhkMlNBb3pUcyszMjRBZUhNVEJQNlErcnFUKytY?=
 =?utf-8?B?OUR4WGlKTE5vU28rRXFiMVZtUG8xSFRGMVc1Q2dMQjRkTVlHMEI2YXdxQm9h?=
 =?utf-8?B?dlZuK1pmQXVha2V4Vm5IWktaWHA3WnlFM2txNlR5YlE0S0ZHS0dKVXJEczJk?=
 =?utf-8?B?bzRBUGRxWVJLY0NISm1sbHJrVmg0SjhqZzlMRWcrODV1T25BL0ZPb0JDeDhq?=
 =?utf-8?B?ajZMZnpDVnZFclAyRktXbTVUQXBNRFF3M1lkN0Rnd2lkVCtRdkZCcm5JMkV0?=
 =?utf-8?B?bmFJdVJ6S3FMcVdFeFVWeEUrS01IVThsMVZkNGlIaDV1RnZxeTVTSXAvblpu?=
 =?utf-8?B?VHJicUFVdmllK1l0VzQzM2tsL1dkMnhocVBVbG1wWEFwaitpa1YzSjhWWFFq?=
 =?utf-8?B?QlpRYXNORHVwUStmcUtIOUc0TFVmZ0Y0MElzc1NkdnZTemRwdGNPVnRaeTdt?=
 =?utf-8?B?Y3ZYaUpJbnUwQWlEeW1pUTNNeGdxNTlnMFhiWDNPakQ4K1NwM3RmV0JveVBR?=
 =?utf-8?B?Y3hwcXU5aDdvYjc5eDFRVnVxTlE5V2puUCtQbXBYQ25TdUxlTXNiQ1QxTzVH?=
 =?utf-8?B?ejBEOG5VQUxnekdGaEtqT00zUTlYbmx1SU1pcVAvQjVuUlBmdGczcEpiL1VR?=
 =?utf-8?B?TGNEdS9kMy9WTnpNSExiNGt0SVRYV0hrRDR6UWdjRlI2VW1vQU1ldENZT3pI?=
 =?utf-8?B?cXdwMGdtS0JxVGkxVDBZVzhIV2JZMzVrZTZRUUgvWTZtQjNQQjZKZ3FhNVds?=
 =?utf-8?B?Yi92MVNUR0xZZ2N6UjBEZlpPUnpFWEo2aU1zL0pjckVaYnZycHVVMThDL2x3?=
 =?utf-8?B?cSt0Q3dkUlpGQzkyOEZzdTlkOHpwUHl1NlNtYTR1blNZdTNmL3g2Q3U3WG44?=
 =?utf-8?B?c0EyRG9EVzJTTnd0WlFDaTYwUys0M1JWNDVIMEcvTXcrQU1paG9VNDl3MGJl?=
 =?utf-8?B?YUFBaXVGcnA1TFRaV2lVU3BiK1cyZWMzaWZNOExQeGZ2RHFadTlJdTBDdHVu?=
 =?utf-8?B?d3RURGNWWVhpZng5Ky9NeEdzUy9hYVNPVmwxSkhTK2pSRkhLeXkreEZpUnVW?=
 =?utf-8?B?WXdPVi9Lc0NGT1JZQWhyWm5tdEorNmRRNVU2M09KeEZPRTVYQXJIR3ZSUGJU?=
 =?utf-8?B?VGdrUTFyNERhaGpEMzdQTmlQa2N1ZEZSVmtZekVkdjN2ZDdxYmZlSTl6UWhD?=
 =?utf-8?B?MnVacitsSmcyMzVaRkNQK0FibTNwZmEreVNacXQ0RDk0cVBDN3hpUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb087bf1-7d19-4d08-2113-08de85d6f5d3
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9714.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 16:45:42.8276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ZprhAiYQZuBohw8UcWgWpGdV8i7JK6I07DMZYD1icPKf97J0wwNRjDbodAS2fzdQmSL71Y/4cvZJH7TBiB1Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7643

On 3/19/2026 8:46 AM, Koralahalli Channabasappa, Smita wrote:
> Hi Jonathan and Alison,
> 
> Thanks for the report and suggestions. I took a look at Jonathan's 
> comments in Patch 6 and tying it together here.
> 
> On 3/18/2026 10:48 PM, Alison Schofield wrote:
>> On Thu, Mar 19, 2026 at 01:14:56AM +0000, Smita Koralahalli wrote:
>>> From: Dan Williams <dan.j.williams@intel.com>
>>>
>>> Move hmem/ earlier in the dax Makefile so that hmem_init() runs before
>>> dax_cxl.
>>>
>>> In addition, defer registration of the dax_cxl driver to a workqueue
>>> instead of using module_cxl_driver(). This ensures that dax_hmem has
>>> an opportunity to initialize and register its deferred callback and make
>>> ownership decisions before dax_cxl begins probing and claiming Soft
>>> Reserved ranges.
>>>
>>> Mark the dax_cxl driver as PROBE_PREFER_ASYNCHRONOUS so its probe runs
>>> out of line from other synchronous probing avoiding ordering
>>> dependencies while coordinating ownership decisions with dax_hmem.
>>
>> Hi Smita,
>>
>> Replying to this patch, as it's my best guess as to why I may be
>> seeing this WARN when I modprobe cxl-test.
>>
>> We are able to pass all the CXL unit tests because it is only that
>> first load that causes the WARN. All subsequent reloads of cxl-test
>> do not unload dax_cxl and dax_hmem so they chug happily along.
>>
>> I can reproduce by unloading each piece before reloading cxl-test
>> # modprobe -r cxl-test
>> # modprobe -r dax_cxl
>> # modprobe -r dax_hmem
>> # modprobe cxl-test
>> and the WARN repeats.
>>
>> Guessing you may recognize what is going on. Let me know if I can
>> try anything else out.
>>
>>
>> # dmesg (trimmed to just the init calls)
>> [   34.229033] calling  fwctl_init+0x0/0xff0 [fwctl] @ 1057
>> [   34.230616] initcall fwctl_init+0x0/0xff0 [fwctl] returned 0 after 
>> 186 usecs
>> [   34.257096] calling  cxl_core_init+0x0/0x100 [cxl_core] @ 1057
>> [   34.258395] initcall cxl_core_init+0x0/0x100 [cxl_core] returned 0 
>> after 538 usecs
>> [   34.264170] calling  cxl_port_init+0x0/0xff0 [cxl_port] @ 1057
>> [   34.264982] initcall cxl_port_init+0x0/0xff0 [cxl_port] returned 0 
>> after 110 usecs
>> [   34.268058] calling  cxl_mem_driver_init+0x0/0xff0 [cxl_mem] @ 1057
>> [   34.268743] initcall cxl_mem_driver_init+0x0/0xff0 [cxl_mem] 
>> returned 0 after 110 usecs
>> [   34.274670] calling  cxl_pmem_init+0x0/0xff0 [cxl_pmem] @ 1057
>> [   34.277835] initcall cxl_pmem_init+0x0/0xff0 [cxl_pmem] returned 0 
>> after 1671 usecs
>> [   34.285807] calling  cxl_acpi_init+0x0/0xff0 [cxl_acpi] @ 1057
>> [   34.287105] initcall cxl_acpi_init+0x0/0xff0 [cxl_acpi] returned 0 
>> after 262 usecs
>> [   34.292967] calling  cxl_test_init+0x0/0xff0 [cxl_test] @ 1057
>> [   34.339841] initcall cxl_test_init+0x0/0xff0 [cxl_test] returned 0 
>> after 45832 usecs
>> [   34.342259] calling  cxl_mock_mem_driver_init+0x0/0xff0 
>> [cxl_mock_mem] @ 1063
>> [   34.343459] initcall cxl_mock_mem_driver_init+0x0/0xff0 
>> [cxl_mock_mem] returned 0 after 356 usecs
>> [   34.658602] calling  dax_hmem_init+0x0/0xff0 [dax_hmem] @ 1059
>> [   34.670106] calling  cxl_pci_driver_init+0x0/0xff0 [cxl_pci] @ 1100
>> [   34.671023] initcall cxl_pci_driver_init+0x0/0xff0 [cxl_pci] 
>> returned 0 after 197 usecs
>> [   34.673051] initcall dax_hmem_init+0x0/0xff0 [dax_hmem] returned 0 
>> after 2225 usecs
> 
> I agree with Jonathan's comments in Patch 6, using __WORK_INITIALIZER or 
> initializing work in dax_hmem_init() and gating flush on pdev will fix 
> the WARN — I will add both for v8. But I think the WARN is likely 
> indicating an ordering issue here..
> 
> On initial boot, the Makefile ordering ensures dax_hmem_init() runs
> before cxl_dax_region_init(), so both work items land on system_long_wq
> in the right order and dax_hmem's deferred work is queued before 
> dax_cxl's driver registration work.
> 
> On module reload which Alison is trying here I dont think, modules are 
> loaded by Makefile order. I think dax_cxl's workqueue is calling 
> dax_hmem_flush_work() before dax_hmem probe has had a chance to queue 
> its work, so flush_work() flushes nothing and dax_cxl registers its 
> driver without waiting.
> 
> __WORK_INITIALIZER fixes the WARN, but doesn't fix the race I guess if 
> we are hitting that here..
> 
> [   34.673051] initcall dax_hmem_init+0x0/0xff0 [dax_hmem] returned 0 
> after 2225 usecs
> [   34.676011] calling  cxl_dax_region_init+0x0/0xff0 [dax_cxl] @ 1059
> 
> These two lines indicate cxl_dax started after dax_hmem_init() returns 
> but I dont think that guarantees dax_hmem_platform_probe() has actually 
> run..
> 
> I dont know if wait_for_device_probe() in cxl_dax_region_driver_register
> might help..
> 
> Thanks
> Smita

Actually, thinking about this more..

dax_hmem_initial_probe lives in device.c (built-in) so it survives 
module reload. On reload it's still true from the first boot. This means 
hmem_register_device() skips the deferral path entirely..

The problem is this bypasses the cxl_region_contains_resource() check 
that the deferred work normally does. On first boot, 
process_defer_work() walks each range and decides per-range: if CXL 
covers it, skip. If not, register with HMEM. On reload, that check never 
happens — whoever registers first via alloc_dax_region() wins, 
regardless of whether CXL actually covers the range.

So if dax_cxl registers first on reload, it could claim a range that CXL 
doesn't actually cover, and dax_hmem would lose a range it should own..

I dont know if Im thinking through this right..

Thanks
Smita

> 
>> [   34.676011] calling  cxl_dax_region_init+0x0/0xff0 [dax_cxl] @ 1059
>> [   34.676856] ------------[ cut here ]------------
>> [   34.677533] WARNING: kernel/workqueue.c:4289 at 
>> __flush_work+0x4f9/0x550, CPU#3: kworker/3:2/136
>> [   34.678596] Modules linked in: dax_cxl(+) cxl_pci dax_hmem 
>> cxl_mock_mem(O) cxl_test(O) cxl_acpi(O) cxl_pmem(O) cxl_mem(O) 
>> cxl_port(O) cxl_mock(O) cxl_core(O) fwctl nd_pmem nd_btt dax_pmem nfit 
>> nd_e820 libnvdimm
>> [   34.680632] initcall cxl_dax_region_init+0x0/0xff0 [dax_cxl] 
>> returned 0 after 3842 usecs
>> [   34.680918] CPU: 3 UID: 0 PID: 136 Comm: kworker/3:2 Tainted: 
>> G           O        7.0.0-rc4+ #156 PREEMPT(full)
>> [   34.684368] Tainted: [O]=OOT_MODULE
>> [   34.684993] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), 
>> BIOS 0.0.0 02/06/2015
>> [   34.686098] Workqueue: events_long cxl_dax_region_driver_register 
>> [dax_cxl]
>> [   34.687108] RIP: 0010:__flush_work+0x4f9/0x550
>>
>> That addr is this line in flush_work()
>>          if (WARN_ON(!work->func))
>>                  return false;
>>
>>
>> [   34.687811] Code: ff 49 8b 45 00 49 8b 55 08 89 c7 48 c1 e8 04 83 
>> e7 08 83 e0 0f 83 cf 02 49 0f ba 6d 00 03 e9 a1 fc ff ff 0f 0b e9 e6 
>> fe ff ff <0f> 0b e9 df fe ff ff e8 9b 48 15 01 85 c0 0f 84 26 ff ff ff 
>> 80 3d
>> [   34.690107] RSP: 0018:ffffc900020b7cf8 EFLAGS: 00010246
>> [   34.690673] RAX: 0000000000000000 RBX: ffffffffa0ea2088 RCX: 
>> ffff8880088b2b78
>> [   34.691388] RDX: 00000000834fb194 RSI: 0000000000000000 RDI: 
>> ffffffffa0ea2088
>> [   34.692135] RBP: ffffc900020b7de0 R08: 0000000031ab93b0 R09: 
>> 00000000effb42e8
>> [   34.692876] R10: 000000008effb42e R11: 0000000000000000 R12: 
>> ffff88807d9bb340
>> [   34.693588] R13: ffffffffa0ea2088 R14: ffffffffa0ed2020 R15: 
>> 0000000000000001
>> [   34.694358] FS:  0000000000000000(0000) GS:ffff8880fa45f000(0000) 
>> knlGS:0000000000000000
>> [   34.695179] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   34.695775] CR2: 00007fe888b4e34c CR3: 00000000090ed004 CR4: 
>> 0000000000370ef0
>> [   34.696494] Call Trace:
>> [   34.696889]  <TASK>
>> [   34.697238]  ? __lock_acquire+0xb08/0x2930
>> [   34.697730]  ? __this_cpu_preempt_check+0x13/0x20
>> [   34.698277]  flush_work+0x17/0x30
>> [   34.698705]  dax_hmem_flush_work+0x10/0x20 [dax_hmem]
>> [   34.699270]  cxl_dax_region_driver_register+0x9/0x30 [dax_cxl]
>> [   34.699943]  process_one_work+0x203/0x6c0
>> [   34.700452]  worker_thread+0x197/0x350
>> [   34.700942]  ? __pfx_worker_thread+0x10/0x10
>> [   34.701455]  kthread+0x108/0x140
>> [   34.701915]  ? __pfx_kthread+0x10/0x10
>> [   34.702396]  ret_from_fork+0x28a/0x310
>> [   34.702880]  ? __pfx_kthread+0x10/0x10
>> [   34.703363]  ret_from_fork_asm+0x1a/0x30
>> [   34.703872]  </TASK>
>> [   34.704227] irq event stamp: 11015
>> [   34.704656] hardirqs last  enabled at (11025): [<ffffffff813486de>] 
>> __up_console_sem+0x5e/0x80
>> [   34.705493] hardirqs last disabled at (11036): [<ffffffff813486c3>] 
>> __up_console_sem+0x43/0x80
>> [   34.706354] softirqs last  enabled at (10500): [<ffffffff812ab9f3>] 
>> __irq_exit_rcu+0xc3/0x120
>> [   34.707197] softirqs last disabled at (10495): [<ffffffff812ab9f3>] 
>> __irq_exit_rcu+0xc3/0x120
>> [   34.708015] ---[ end trace 0000000000000000 ]---
>> [   34.752127] calling  dax_init+0x0/0xff0 [device_dax] @ 1089
>> [   34.754006] initcall dax_init+0x0/0xff0 [device_dax] returned 0 
>> after 422 usecs
>> [   34.759609] calling  dax_kmem_init+0x0/0xff0 [kmem] @ 1089
>> [   37.338377] initcall dax_kmem_init+0x0/0xff0 [kmem] returned 0 
>> after 2577658 usecs
>>
>>
>>>
>>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>>> Signed-off-by: Smita Koralahalli 
>>> <Smita.KoralahalliChannabasappa@amd.com>
>>> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
>>> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>>> ---
>>>   drivers/dax/Makefile |  3 +--
>>>   drivers/dax/cxl.c    | 27 ++++++++++++++++++++++++++-
>>>   2 files changed, 27 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/dax/Makefile b/drivers/dax/Makefile
>>> index 5ed5c39857c8..70e996bf1526 100644
>>> --- a/drivers/dax/Makefile
>>> +++ b/drivers/dax/Makefile
>>> @@ -1,4 +1,5 @@
>>>   # SPDX-License-Identifier: GPL-2.0
>>> +obj-y += hmem/
>>>   obj-$(CONFIG_DAX) += dax.o
>>>   obj-$(CONFIG_DEV_DAX) += device_dax.o
>>>   obj-$(CONFIG_DEV_DAX_KMEM) += kmem.o
>>> @@ -10,5 +11,3 @@ dax-y += bus.o
>>>   device_dax-y := device.o
>>>   dax_pmem-y := pmem.o
>>>   dax_cxl-y := cxl.o
>>> -
>>> -obj-y += hmem/
>>> diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
>>> index 13cd94d32ff7..a2136adfa186 100644
>>> --- a/drivers/dax/cxl.c
>>> +++ b/drivers/dax/cxl.c
>>> @@ -38,10 +38,35 @@ static struct cxl_driver cxl_dax_region_driver = {
>>>       .id = CXL_DEVICE_DAX_REGION,
>>>       .drv = {
>>>           .suppress_bind_attrs = true,
>>> +        .probe_type = PROBE_PREFER_ASYNCHRONOUS,
>>>       },
>>>   };
>>> -module_cxl_driver(cxl_dax_region_driver);
>>> +static void cxl_dax_region_driver_register(struct work_struct *work)
>>> +{
>>> +    cxl_driver_register(&cxl_dax_region_driver);
>>> +}
>>> +
>>> +static DECLARE_WORK(cxl_dax_region_driver_work, 
>>> cxl_dax_region_driver_register);
>>> +
>>> +static int __init cxl_dax_region_init(void)
>>> +{
>>> +    /*
>>> +     * Need to resolve a race with dax_hmem wanting to drive regions
>>> +     * instead of CXL
>>> +     */
>>> +    queue_work(system_long_wq, &cxl_dax_region_driver_work);
>>> +    return 0;
>>> +}
>>> +module_init(cxl_dax_region_init);
>>> +
>>> +static void __exit cxl_dax_region_exit(void)
>>> +{
>>> +    flush_work(&cxl_dax_region_driver_work);
>>> +    cxl_driver_unregister(&cxl_dax_region_driver);
>>> +}
>>> +module_exit(cxl_dax_region_exit);
>>> +
>>>   MODULE_ALIAS_CXL(CXL_DEVICE_DAX_REGION);
>>>   MODULE_DESCRIPTION("CXL DAX: direct access to CXL regions");
>>>   MODULE_LICENSE("GPL");
>>> -- 
>>> 2.17.1
>>>
>>>
> 

