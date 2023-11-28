Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9DC46BAE
	for <nvdimm@lists.linux.dev>; Tue, 28 Nov 2023 20:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ExazPl4T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701203020; x=1732739020;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ehh1uCrz1mf0IuKdj2da6VBGkNpdpxVGDbEqFigS3s4=;
  b=ExazPl4TNQ2dx8J11ghcwo2KOSNQZU6bkR9kqZ5GDUjbayZpqYq5Kffx
   GNpYnTwaK3Jso2iEPFkCPkv+MLxBfn/aek+wLqNCt258mnFsakSvenLKA
   6gRdi6F/43g3iACQofeUOaoNjxpLWReqzmF2eGLTVINuYRwKNsUkBmAYE
   RC88gTnI9f3QrV+ok6ovFbo98u9V+s8hYB/1NZidrmwjLbaIkfkXUzTLy
   le2xPOvdriVttfrsora9T74TYZ6RP+qyVbhdiaajOCwMHW32Y4iTJPxxX
   Lt34lh+3GyYLnuHyQFPyWYxxbwLeNKZognzZwsX3tIP5YDBfefMnEs1+U
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="479213201"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="479213201"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 12:23:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="768646810"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="768646810"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Nov 2023 12:23:37 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 28 Nov 2023 12:23:37 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 28 Nov 2023 12:23:37 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 28 Nov 2023 12:23:37 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 28 Nov 2023 12:23:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YSTg5eG5Yj+QMhkETE2U1X0x8MLmxnDOYwvM9dzPRA/vlfgVa3316WhIATOPqxsTwsZvUnzVqXVLcBn2n7PHRE0tyvTeqDqAewy3HfOSUV7VOLHQn4n0mWZ7Do9+a2XfK6YPbNPpcMzGJGrbPwAI0qXrdz5ixdBJqZzms6+EJxV8edUHEIyRAhcsxVxw787yvyoEjimVKOl6z8ANLmnp68RZFtETZGGjHl+0fJRekGEBay0ZcdNNIh3tR1Z3Yeqe3ZvTczB24Zrb+sD68Zrf7aW9UoGxMoGqyKJifpcy3jiap8ECyE2DVUwVF3JuAZESs7GhH6ccmXtYX8Aacfi0HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q4PHeI79K6JfcHyc/RSsxPj4nijsf658os9JHFTA5kI=;
 b=DK3KJ3XEIkinian5kQhsvrECRiECi6JTbv/hQG8s+1op3QtimE/2SdzFjYH8vymV0te857Qle9tEC8GtmlEoeteFw+fHss2nQsaCQUbY+Mab5O2Arp5IvSi5MYKF+Fp+6G/aa6Omyr+PiY7jmyjMJMcfz1yQOzNnAWdl0orotWPJWdOGYCq22EtqHRKwYRwKvoTGDzas0cnXYbTZk6WK00nk+m10UFDOtBiRfN9TojfbTFKoDdS/1tM7iq7tnSbDYXrPbZ9G206zmatUStltptZ8tWnMD/eI74CAVCFUWt/futTgqr5EaiWlZT/iwx4cD/zDLRME65x29RRi7x+/dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by MW3PR11MB4556.namprd11.prod.outlook.com (2603:10b6:303:5b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Tue, 28 Nov
 2023 20:23:33 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6f7b:337d:383c:7ad1]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6f7b:337d:383c:7ad1%4]) with mapi id 15.20.7025.022; Tue, 28 Nov 2023
 20:23:33 +0000
Message-ID: <4d3e52cf-11d4-4764-8b1f-9c0937423410@intel.com>
Date: Tue, 28 Nov 2023 13:23:29 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [NDCTL PATCH 2/2] cxl: Add check for regions before disabling
 memdev
To: Alison Schofield <alison.schofield@intel.com>
CC: <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
References: <169645730392.624805.16511039948183288287.stgit@djiang5-mobl3>
 <169645731012.624805.15404457479294344934.stgit@djiang5-mobl3>
 <ZWYyDDOYyqxTf7k+@aschofie-mobl2>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <ZWYyDDOYyqxTf7k+@aschofie-mobl2>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::23) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|MW3PR11MB4556:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bec51ee-8833-4ddd-6a4e-08dbf04fe458
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QzbEOY620uYPOAyrd2Ne//luvZkyF56R8DMLzmAWfvEk88VaE5Fk2BDILkY5+lELM5yGNxwqvrHk9HRfvTrY+48319+MumtDiIYsHS0ZXGNlQ1OA125/1BIaF1spgK2VImFzodgRydjzem0uPC9MqtyjkfE+Tg5MwubmNfjVLL/oAsZSC9pYLq9rGzqzhIfRWztNuUbYS1T7/J5IL6eLkmR2NvRO+pXTsZIbKVPBBmU7U3LQXL7tX0CgT1gXZQzrbbH9molLTxc8s0FNqbG8A+UQLEEmjxR2MEq9e2sOgOj28x/CQfaT1FGbLAVWrm0a16PaXtbJmpHcMyXDjXMOv07cegqx9qp+v3pCJr1KQtA8J/DjErfUxkB3xfC1e3bmU6aAI/mnY0kZyDiRzgjygAE+IrGOhgY0VpT+PbvLVCgmsYWH2DjX4wQK2jA5Ypt8Kj2Gaz/natBl5XV95FJrbI7WTiFHq4gucd8djKVC98SW9wxcFVOZgQqRniKM1ZeJJtDzEEybgT82S+U3YF3oP1LHCnVDb0PIlvr0ADQoOm37WG4M75rgruPqkKhEjEBF4vgp9buYlUhlCk4SwKzFhZj7jnGQRqX10qxMKY5etw1fzZ+7WAVZlcX/elCbmYb+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(136003)(39860400002)(376002)(396003)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(31686004)(41300700001)(44832011)(2906002)(86362001)(31696002)(6666004)(5660300002)(83380400001)(53546011)(36756003)(66556008)(6486002)(4326008)(8676002)(37006003)(66946007)(6636002)(6862004)(66476007)(6512007)(2616005)(316002)(26005)(8936002)(38100700002)(82960400001)(6506007)(478600001)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3lRNEJaMHlsZWR1WStQNmQ1V1RMUkFLeGJRSE53WWxxc0pKOWNCVlR3anZQ?=
 =?utf-8?B?eTJTUE1ndTAyR1NTdXBlOThsVXdFS3FPL2VkWERtblpFeG1nUTdFV1NvaTFU?=
 =?utf-8?B?MElUa2Y5cWlpajEzUStFMi83Smk5UEY4aW9UT1BReWZJc1B4V1JpMmJ5Z0ph?=
 =?utf-8?B?eDRkcjRObEdRZUVLM1VDL3B0bXBndUFtRWNoek9GeklWbE1zOTBoZDBwTjVi?=
 =?utf-8?B?TWc1ZGF6ZjJEcFlLT1NNckE4dTRRRmRUeUxSUlJ3cWlhOC80dFZDdnl3TFpp?=
 =?utf-8?B?N0V6dllSZUU4bjVRNUg0aVcreEo3MTJlWGM3QnlKdFBlTkd3R0NibWx5amRt?=
 =?utf-8?B?a2xPa1lzQjJXY0ZlcDdtbXI5QnNWT3ZnY2tvWXEvaDdoUDRmb1RpaDlTTGdm?=
 =?utf-8?B?YTZNRmxSZGtUazVVcUtWWE1JalpzTXE3WnFPWTlVVm1RcVJzdUkycUV4S29F?=
 =?utf-8?B?Uk9kRHhKWFI0N1hkZVQ5clR2MmNqVVU0UlMwZ0owUWJlYWQ2STVlQ0pLSVlK?=
 =?utf-8?B?cXhvcHlsaTJldWRWQWtwTUhibS8yWVZWdkpPNUpEbXNiR21Eb3R5VFQwYVVT?=
 =?utf-8?B?SUNPbk9pbzBxSjNGOTU4clMrM0hPYkJuVUVDVlR1dVZ4eGlERXM5dW04a2g2?=
 =?utf-8?B?NGRZWHFZNzhDTWViZ0pOeDgyMEttUjNxZ2thSmZrKzhqZ3cvRnZhRHdkMlhI?=
 =?utf-8?B?TmlDb1dmOC9wTDVYZFhlZCs4dlEvZ0E2TzcxR09vWUlEbFdtT2JhcHkwUjUz?=
 =?utf-8?B?NmROb1YvV2dtS01pUXlJdERYUXFzYVVZbTZMeHRsK1BIQWxNNXI4SEZxRmYy?=
 =?utf-8?B?UCtWbEtCMmNKeHQ1ZElkUlBDWjgzZ2s2ZFVkUDJ0MzI0QW05UjZWSDRhOW1u?=
 =?utf-8?B?U210R1ZnaEF4Rkw0NVVQNXo2Unp4aUpINmxNVWVjOEp3TUthZ29EQkVPaWh3?=
 =?utf-8?B?QVZmQ2wzOFFOT0JBVkV4SUVZZllBWjErZHF3a0xUVkk4SzBSUTYzQVVJUFpk?=
 =?utf-8?B?R3ROT2pQOFBQTS9JRnUvWGM3MWhPL0F4NGk3blhMYWV6V0ozZ05mMTlRNzVG?=
 =?utf-8?B?WG9scWdaRW95R1RFM3YrY3E5L0NJc3FjTWhoTnJ5bEVPU0w2clYvRmM5T1Ru?=
 =?utf-8?B?YmJTdFpKa055dXh3TURselFsYzRJZXNUY0FjQ0YvcjJmUXlIcHRlREVrek82?=
 =?utf-8?B?dDVxeHlKOXhFaFlmTGRHRlB3ZFZENUVnczF3a2Q5SENIVXNwSU0yVUQ3QkNl?=
 =?utf-8?B?cU1vVkFacEhKc1RLVmZQU0hnelF6amtTaVFLU2Z5S3ZvV2R5TWwxY3NsRGhU?=
 =?utf-8?B?S1BJNVh5dzlSMVdiZlF3OVdQbDRGVWxKK3NrV0NDNldMUmNoWWlhbXR3bUdy?=
 =?utf-8?B?WkdxWXEvWlVsU2RnK0tERzFpTHZRNjlTRnR3N1RMdG10YmM5MTY1bUI5R2xV?=
 =?utf-8?B?UVZOWkJBYlM1aHpCOEhzWkE0K3ZxaWdUdDJVTTZPVElnbnBzMnBMQWgwQ1Vm?=
 =?utf-8?B?bHBxZmFEa0czRE85MVZYblo0cUFMMVNQSFUyQ1A4S205cG5Hdk5pei83OUFo?=
 =?utf-8?B?eXRQM2owMGNhdlRzVUUzTWVMSC9kdDNRZTdWY2hlcHJvMjl4NmNPYXJPcW9v?=
 =?utf-8?B?VWhQaERTaEhsVEZpMWZ2ZzhUWDhRS25YQ1c0ODZGdGE2NC9XVXF2eCsrYTdw?=
 =?utf-8?B?NnE2T2JKVExqUUEyZzdjRnpiR0sxQ01SOHFLYmxyRElsRC92QjFPREhxTkl2?=
 =?utf-8?B?dkJsellWajcvbzZNcXREV2RjVDRxWStHSk5vS1c0WnFQNDBPSFN3QVhCNFNX?=
 =?utf-8?B?em4xTld4cjFPZGNlYjRncEJSTytNTWtwOTV5eUdLeUtvcTZST3o3bnZVUUFH?=
 =?utf-8?B?SHFXSWFYdnQ2T0MwKy9DNTF3a1NSd041TlBKRUgyQlFDOTNzTDdLbjhoU1hR?=
 =?utf-8?B?R3VDYWJaTlNJeE5nV0NacTUrdk5zT25UYkdoLzJTTnZzSzhMeUVJaXFYU21O?=
 =?utf-8?B?dkdWRUE4eENSVWlGV21sTmJvdnJYUTBJelNDR2xYTHVHZXNoZUc4MmkyVSts?=
 =?utf-8?B?S3BOaWh0MStpZm9uZDcreSsrWjF2cXBESmVEbUdUenN0akV6OXoweGtsTkJS?=
 =?utf-8?Q?r3x6YNWm5DavDAP35VVrxZWcz?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bec51ee-8833-4ddd-6a4e-08dbf04fe458
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2023 20:23:32.9601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4kh8POKQ1qIxXKrT4BryRkUV757KvqLUDXHScDqJRSUIZwD9qdPdzbRxTLaRatJjslyVuRh1XfKT2DXGioiLTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4556
X-OriginatorOrg: intel.com



On 11/28/23 11:31, Alison Schofield wrote:
> On Wed, Oct 04, 2023 at 03:08:30PM -0700, Dave Jiang wrote:
>> Add a check for memdev disable to see if there are active regions present
>> before disabling the device. This is necessary now regions are present to
>> fulfill the TODO that was left there. The best way to determine if a
>> region is active is to see if there are decoders enabled for the mem
>> device. This is also best effort as the state is only a snapshot the
>> kernel provides and is not atomic WRT the memdev disable operation. The
>> expectation is the admin issuing the command has full control of the mem
>> device and there are no other agents also attempt to control the device.
>>
> 
> snip
> 
>> +
>> +	if (cxl_port_decoders_committed(port) && !param.force) {
>>  		log_err(&ml, "%s is part of an active region\n",
>>  			cxl_memdev_get_devname(memdev));
>>  		return -EBUSY;
> 
> Can you emit the message either way, that is, even if it is forced,
> let the user know what they just trampled on.

Ok I'll change that.

> 
> How easy is it to add the region names in the message?

I don't think we can get to a region easily. The way we currently check is to see if there are active decoders and not region existence.  

> 
>>
>>
>>
