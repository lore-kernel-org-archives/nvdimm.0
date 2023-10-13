Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362AE2C84F
	for <nvdimm@lists.linux.dev>; Fri, 13 Oct 2023 22:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FV3RXI0M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697236728; x=1728772728;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/v5HKtXD2fq1uZS9rvdgm6rEy4r9WxFlH533vE71yxo=;
  b=FV3RXI0MqRN71yoeOcpzTYoSKUHFHx50JvDXykbvieuBJcYLoRLAFxU+
   H1KA8CCQZ/VVpSEiL3coOJYj3G7YR8PEWr2chLVKK6H+zk/tIaiBhZFGf
   win3x8LMnK2NoINpIZ1UD/33pi9osWZ3bWAVLcfneVQzXd15nTOW3xUD4
   X5F+GZ4iCys4D38xHn9hRFioE1ubQ16UGUEDgwYFY2Ma1f2edx9Z0XpSK
   i+OHWMiMKg48Hv6QddUmN32ywa57/u8GDXf5CGyXhGIqMPjM9KOAF/iPT
   6Hr7Y7Sq9J5bGRcgVLm22bpjhrTYQbyuQyT5qDaFPpwqq/slFD2NETtUk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10862"; a="385117627"
X-IronPort-AV: E=Sophos;i="6.03,223,1694761200"; 
   d="scan'208";a="385117627"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2023 15:38:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10862"; a="878676588"
X-IronPort-AV: E=Sophos;i="6.03,223,1694761200"; 
   d="scan'208";a="878676588"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Oct 2023 15:38:47 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 13 Oct 2023 15:38:46 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 13 Oct 2023 15:38:46 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 13 Oct 2023 15:38:40 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 13 Oct 2023 15:38:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZBz8Jf0PEjHSY9GKslJq7mzfmvjlP3bVz38w5sxVzFTZpesfHgVlWxjVNKwj6ZDL36i8gcT9EGLN46D6Np2IsJTzDZiMFsZfYnIUEZyprEsv63L9stAO9FYCMf5iYPgJLJ2e5FLLXjpIs/Jf7KnxonHFlB33A8QkmYVwb4e5GaV9zzdrdachliVZY7ZZ8xlfXZHx1/zZsG9j23KomlUdSue9NTX29eACDEUrRkG1JajvWUYJV8xFv5XvUt9e2DMDqK5HBxiqCXSCcFX7A+c2Q9Qrl0D/SPsyj0u6w3azYc43/JzaG/tSkYdIgug5a0zfWggaVCVjH4ryRdWNWCTh7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jNzkpU4e3UzX13Poh9LCOfHvMRaEvU2RLhTfWWmAcdY=;
 b=QwO081rNwrKJwM/OdH5O/ymLWtIC3+tRvLvPncC7wKBygP2dUgmIM25HVXXfvJJe/mBtS79P59xCyxHHHYAj2v2TDlD6IRiKUoqjqVHuo/WoLnPiU7NeDZWmciqK/7K1LOXgoJ+WPUyLlGIr9bndngUCFMKURJHTQ8R6qNex94uXsct1KvYa+63d+D/uSrgAandetd7WbVo920ptFAGEJm93puf2iRAFkz5fjs3caF1bbGDpl2N+nNcY6PC6EMUqayWas4fF5hspLhKe7AIryjv6DbtEwFp/mzQbvBdWvIu6Cgi/ss09235iwvx2zVdw9dlAlkaJKwp/54NFMmu5Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by SA2PR11MB4875.namprd11.prod.outlook.com (2603:10b6:806:11a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.44; Fri, 13 Oct
 2023 22:38:37 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::e9ca:a5a7:ada1:6ee8]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::e9ca:a5a7:ada1:6ee8%5]) with mapi id 15.20.6838.040; Fri, 13 Oct 2023
 22:38:37 +0000
Message-ID: <7a01a5aa-678d-42ff-a877-8aaa8feb3fbd@intel.com>
Date: Fri, 13 Oct 2023 15:38:35 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [NDCTL PATCH v2] cxl/region: Add -f option for disable-region
To: Xiao Yang <yangx.jy@fujitsu.com>, <vishal.l.verma@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	"lizhijian@fujitsu.com" <lizhijian@fujitsu.com>, <caoqq@fujitsu.com>
References: <169525064907.3085225.2583864429793298106.stgit@djiang5-mobl3>
 <59e51baa-cd6f-7045-178f-c327a693f803@fujitsu.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <59e51baa-cd6f-7045-178f-c327a693f803@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0069.namprd07.prod.outlook.com
 (2603:10b6:a03:60::46) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|SA2PR11MB4875:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b181a7f-218f-4bf1-1870-08dbcc3d2424
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eB+wvqEafPFn9xpx28r7SMW5nAOpPlpnHwp66au4ITuklawgkF6Fvfk/S/Xl2Z8UZXwqunt1T+NNwsFxkzma0preyB9r5R/etbqDN6CzyM2F6jXIAeH4Z2dwBQWYhcAe2qgOJfa90rn1EKQ3c2/qJ1BeFcX3M/eQFrjk8Plihma7Ou4U/YgirQT/CIAzGcrAN7yX1Hmv9qRLRGi+Ll1JShmXoZFw0C2QU8DCZ2KvRgP3YrxyLTm7pTdlgZ4X6tSA5pFbgDpTF8oERKWnIywnabTUZizOZDvBLtRojpUqhoiZBQLvaak5RDk8djRA0yhfy7SxZsnnKMn1+vzzfR61v5UG8S8Mj25Lhcgiau8HA6f8vK4fYHYI/bqFzUcNT+pMoK7ltzsBbAjEX+HyJQ0TAjrZzi9PmCTe3atTpWgvac4bGnOyVNfkjD0AM3YspEn91oXPpnTQha4GZyUjt+rOl++e9+P1TD5OnL6DGWnvEH9ozM1LZ8fKWtVbNBSf1nJgnIvS/TvOU6LOPi/BANTv36MN+O4n2RydGzkEjHKOc4bzlrihOBivUvh0wV8kauGgYuOAx+cqpADoGTd9NLJbfhL7bgm1KXyE4Q2iTny44UA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(376002)(346002)(366004)(396003)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(83380400001)(2616005)(26005)(86362001)(478600001)(6486002)(316002)(4326008)(5660300002)(8936002)(8676002)(44832011)(6636002)(41300700001)(2906002)(36756003)(66476007)(66556008)(66946007)(966005)(6512007)(6506007)(53546011)(31686004)(82960400001)(38100700002)(31696002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SHdzLy9vYlZxY0tKQ1VtVTI2cFEyYS9UYlk2UnEybkNGaFpWaUZBc0NWL0pZ?=
 =?utf-8?B?SFRiWE9LVDBJTll3dUZUL0ZlMEZNdkNhYmIreGdKc05xNXBsbHdmS0Q0OW5M?=
 =?utf-8?B?ZEF4ZHIzOStXOW55LzUwTi8xTDBneEl0b2tYN0pONTRqWTFRNEJlb2tIcG9j?=
 =?utf-8?B?OHNWWXZDTzJBc1pNS3pwcVFsOERqNnZvT3owVFNKL1RnNDBoOWtHYXFUazNU?=
 =?utf-8?B?UVkyZkpBemExc1NpZFlmN0hUcUpZVUhuelpJUWpRcUxmdWNwYk5XSm1KWTJa?=
 =?utf-8?B?Z0NUMUZmMUNkOTB4QlVtNjJ5dHpWdm82blVNV0F6aFN1Y3Q0STdBQXZTdlFt?=
 =?utf-8?B?OXZCTHMrNUprcVlvSFlMRzd1b2xZU3ZDdlFiOUN1U3diN3hsMUY0SThhUFIw?=
 =?utf-8?B?Zm55U0J6V0N6anY2dmt4d3RFVGw3ZkRVZkVWcnZzd2VxaDFTY2xZVjc0R2Nu?=
 =?utf-8?B?M1lNek55MVV2NmxiU3Q2MFZHOHpkbkpPMlFYdG10clpUQ0FMMUN6T2IrQ2VY?=
 =?utf-8?B?R3RHQUtnNjZjdFFLdlg3Wkd0cHlza1ZZVERwQ3lMQWZVZmFaRnhGeTllQkFF?=
 =?utf-8?B?WHNrZjAvSVNxbE9IUnJWYmVIeEVCU09FU3gzazhuMnN0T3pYQy9KV1NmaDQz?=
 =?utf-8?B?aHBoRWFTWW0wSWNLYnpwNHBCb25iWC9tS2l3WTdYYnpSZGs4R0VUa3ZzM0VN?=
 =?utf-8?B?dDQ1WTJ4TjhhRThibjlXS2tsWlhEdUIvL2JmZnVhcjdyMThDZ0xHcHdqaUxv?=
 =?utf-8?B?bTFIdVVpZ2xMRUtqTzhlWHVVcWIxRmpCUlNTTU5IOVJZS242MGcxbExJUFBI?=
 =?utf-8?B?bjNicmJCeCs5MjVkeEVCWHVmTDRDaWdSeHVUWUJoNW45eUNDWW12T0hYTkVs?=
 =?utf-8?B?NUZzRXJVNVdxMGgybkFjMnhpVERQL01GZGNvQWZYTmQ2YWdiL0JTdDhvSURv?=
 =?utf-8?B?SDBuZUxMY05WR3BScXBhc2hISzRpekFTWE1mWUlwdzh0aVBvUHl3RXRmb0Vo?=
 =?utf-8?B?aERYekxrRnF0NGU3UERjaGdoRHYyTlZySXQxeklvbGpCVk03bFVLY0NJeWdm?=
 =?utf-8?B?UTdWakN0NTN6MDhSSksvK3dhdDRybzY1YlM4ME8rSnVSWFFlZnBjVERiNnVo?=
 =?utf-8?B?amVuZzdURTlWTUxsUGtNMnU2N0lVdEpRUWJoQ2xNSzV3QXpoV2dsZVdDWkcw?=
 =?utf-8?B?b2NWV2RQUy81ZWxPRmxpRmI4UHdEM2xkL1QrUmVqMUVLNUJDQnVVYXNoOFBW?=
 =?utf-8?B?K05iM0dKUUtTb3RVMjg5dDR3djNoaDcyVmxlS09XcTBXbFY1UVlaamZyVnRv?=
 =?utf-8?B?UEJtOTk3MllhVjdrNEdZcWI3REY3eUhhbmx0eEQvWWpFRFpYNlFwZjVuR2Rv?=
 =?utf-8?B?ODNXU0tYVmx4S0RuTjVpOFhHcy9pZjI1dnNjL242bHBIMHFHdGpiNnVId05n?=
 =?utf-8?B?N3o4Q2JKRFM0Tm56b3NTMzhQMFYrT1ZZeU03MHdxRStaR1llWXQ0dGJJckl2?=
 =?utf-8?B?YXZYU2tYb244VDlveWJ5R2xmbFY5eDRCaWRjSTd3WE85T1Y1aWdWWTBwT3FE?=
 =?utf-8?B?ZFE2QmlGajBveUZJS050YWdiSkRmRm56UTFZNS9nOVZ4OXdEYWl1aDNzcDFn?=
 =?utf-8?B?WEMzTnZ1T3BxbU1EQ0d6eHdNYTlEM0duTnR0UlZHckVDUmh4UGZNQXRudVZJ?=
 =?utf-8?B?QnlzZnlBMWJCODNGV2l5K0V1Wng2OUJJcWJpMy8zYkE4czhIcGZMTXoyemY3?=
 =?utf-8?B?SkNnMXpGZ0JJMVNQOFJxVHhOQ0VNMWtIMWt0L1dFK0ZCajJnWWxrRGZwVkVJ?=
 =?utf-8?B?TXRlc1JRcVJMUi9PSmZ3WkJCMDhxcklDV0RXNXdCaUtKdVVKOTFiQTUyRWNE?=
 =?utf-8?B?STVsSGxYQXJuSFdOY0pBT0lhTHI3Vm40RkRSY1hIVy81TTJQMTArbnYxb2Vx?=
 =?utf-8?B?ZUFTMWRDYnIzZnhFZS9ubFRQUnRPdkdPU1BWTHhFUTVmRDhDdUd0Z0Vrb2VM?=
 =?utf-8?B?KzdKbTdQRzJJTHFTUjkxZ0tTcTNCTjVXdGoyZTNJaWFuZzY2NUQyL3VqZk1K?=
 =?utf-8?B?dmlEMVprSTBXR3gvRmdEck5ZcWIvL093TjR4NE10NXRxRndDdXg4cWtscThx?=
 =?utf-8?B?amduOFFFdnlVUlBqM3gzclpuUWdpaWtjT2g0NFhMN2ozNnozd3FXSGs0aFVT?=
 =?utf-8?B?L3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b181a7f-218f-4bf1-1870-08dbcc3d2424
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 22:38:37.7194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FYWGepm+EpSzj2de3la5lqWieWYufUxZhRorICTMlewMhu4TIDgy63XIoaRiU1ABjCFXwLT8wYBkNeRqsWrkCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4875
X-OriginatorOrg: intel.com



On 10/9/23 03:52, Xiao Yang wrote:
> On 2023/9/21 6:57, Dave Jiang wrote:
>> +        if (daxctl_memory_online_no_movable(mem)) {
>> +            log_err(&rl, "%s: memory unmovable for %s\n",
>> +                    devname,
>> +                    daxctl_dev_get_devname(dev));
>> +            return -EPERM;
>> +        }
> Hi Dave,
> 
> It seems wrong to check if memory is unmovable by the return number of daxctl_memory_online_no_movable(mem) here. IIRC, the return number of daxctl_memory_online_no_movable(mem)/daxctl_memory_op(MEM_GET_ZONE) indicates how many memory blocks have the same memory zone. So I think you should check mem->zone and MEM_ZONE_NORMAL as daxctl_memory_is_movable() did.

Do you mean:
rc = daxctl_memory_online_no_movable(mem);
if (rc < 0)
	return rc;
if (rc > 0) {
	log_err(&rl, "%s memory unmovable for %s\n' ...);
	return -EPERM;
}

> 
> Besides, I send a patch to improve the implementation of daxctl_memory_online_with_zone().
> https://lore.kernel.org/nvdimm/20231009103521.1463-1-yangx.jy@fujitsu.com/T/#u

Thanks. I added my review tag.

> 
> Best Regards,
> Xiao Yang
