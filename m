Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8793A8CE
	for <nvdimm@lists.linux.dev>; Wed, 31 Jan 2024 23:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=134.134.136.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706744156; cv=fail; b=KALNKQbHQ0ispdiRFz7dRbZiz2hj/IQlDzLoMhG7CX3gcaKc4yUjOnJ7R3zw4dnL2snq0nZt0ni8x2n+XuOXo6DIn7pGrjvS9YfqxLnhS+RwdnGBcaTZpb1aufvxOeNFxB2v/OOLN4MnXFUGjcglWv4DJGTou52efIDMIrN7cXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706744156; c=relaxed/simple;
	bh=oCW3igdMoaRJg1ey8C0irVhsjRBOypcSv7uF1up1o04=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=d2hAEKBRGFOEy8dFKfxWNxqXLq29ZMMhMdcw/+rmy0HEx7OIsGFgPxT1UM7MALzwgghxAVkuSSl/eS0GXUV2rfmtVYXxFHCp4bkIQjpDC2vlOUhDm/LufB57Ia8p25+DXpniNU4BpQnxzvs6kLRBbFaNe8FkAhe4kSJgYYu4Bto=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EhHQNQLl; arc=fail smtp.client-ip=134.134.136.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EhHQNQLl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706744155; x=1738280155;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oCW3igdMoaRJg1ey8C0irVhsjRBOypcSv7uF1up1o04=;
  b=EhHQNQLlCIeq7ii6+S6nwM93g2u0gfT5fIldOEXwRMd3LjIMIcKJZeuX
   qFp+6eDTHxo0hjng5Afz8029WZnFATzGcsXOmoRtPkkHN7zWHfCwVf/do
   XeRNZCaZbxJX01WfOqy8col6puGL2CDCE9p/ZCL+XTQdOuMegyWRhWOwS
   lhvNRgnVogktBTf9vRnhd9SX32NDamrcT7RR6SWd8No+a9ABmsqoiIacZ
   zgRLAuZ9O3Pq1B+a0ybmPQGIjuv8K0/ZiFV7LVkVosZeiXUkfr5wvXxPk
   5tpfUjeB53gpHnBakXy0uMG6Oo9+z3MbBxsiC+HbdxGQn9qYxhKsrZ5iP
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="394201631"
X-IronPort-AV: E=Sophos;i="6.05,233,1701158400"; 
   d="scan'208";a="394201631"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 15:35:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="1119774898"
X-IronPort-AV: E=Sophos;i="6.05,233,1701158400"; 
   d="scan'208";a="1119774898"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Jan 2024 15:35:53 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 31 Jan 2024 15:35:52 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 31 Jan 2024 15:35:52 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 31 Jan 2024 15:35:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRiLWwG+qHrpYyQ1rYiPXMOhTIccgSucKeoKx5amozKK+OHStWvECo7NYCZ/3et2rCSk3tYlDLgNpMh0MNKIyiigvDgTIPnl3GwcHY870+CthMKh03EEp0ye2KXGIZOb6zGJ7jnKiG0w5rgN5YvKzaGJ9CBXgl2/eze46Q9/WIzGjGYdKP8ED5UGcn1yNnvoXfjiE1wN68K7UaPoG0KGkzlYTH36mdXGgMW1ZBgEGzZ733rYt3Bh8ulGJGLXKsiJp5xC0M/7r9SsJiSlhvMdlKlzpo9ihJjh4GKBzXa89keL0ZvB9JOQ0/iV7E+6VJeRmHfUqcFaVWlqT56KENmkqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c3SmbAdv3rnOdSUWceQPADTQZf88N6fuCoKVWm+qXAw=;
 b=ew7YAXCiSxaMmOz9F4Qau0bjKlFKMnYLes2G0l0MwPcHKL1gipAMzSgTgzL0uncxW2ckZKb+C4hBwdaCaMYmMcXNShrBCSrxd7ZeYEnqXIOXukKFFB0kXT9tceXH/haFSAxI5wDsnvdZHY+RKJzB70mcrcrELGgE8GP8+rLyvS4R4GK9POYVs3dUxcFwoxk4TdcL99QyrEtnDyovU8P4LE8MAiEpRQ3+EclIW0w35ygqqW1szt0FHds+5l4HbzpWW/Kw0no0CMkmRx3fZ6FONOElIcVT6LvHym1dFkFwlKPSawNlQVdYmwDQN4u8ToqmHUvzj1fJ0nWHIc/wutSr0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by CO1PR11MB5091.namprd11.prod.outlook.com (2603:10b6:303:6c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.24; Wed, 31 Jan
 2024 23:35:46 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::c403:9b0a:1267:d225]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::c403:9b0a:1267:d225%6]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 23:35:46 +0000
Message-ID: <01cb8ae6-f436-422a-9fd3-92eda9dce3b7@intel.com>
Date: Wed, 31 Jan 2024 16:35:41 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [PATCH v2 1/3] cxl: Change 'struct cxl_memdev_state' *_perf_list
 to single 'struct cxl_dpa_perf'
To: Dan Williams <dan.j.williams@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
CC: <ira.weiny@intel.com>, <vishal.l.verma@intel.com>,
	<alison.schofield@intel.com>, <Jonathan.Cameron@huawei.com>,
	<dave@stgolabs.net>
References: <20240130222905.946109-1-dave.jiang@intel.com>
 <65bacb4c3a677_37ad294ab@dwillia2-xfh.jf.intel.com.notmuch>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <65bacb4c3a677_37ad294ab@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0056.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::31) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|CO1PR11MB5091:EE_
X-MS-Office365-Filtering-Correlation-Id: d3f12344-4950-49d4-61e9-08dc22b55919
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rmOvuMZEyHPsmev9xoURQIuoA3oHGDf4LaH4smtx6WLJj/xwCvXAWVjCWpQSeNVa5xalYpKjVRTRRZKpCJECKsvoC+xV+r7Na5EjuuLHUz6Ybs+Yt2ysEYvCOtbQ+p1BSsgD96RXnu27rjX9jXgASrpMuLEwInjL9+4NRjcciWVKo9EVBO16S6BCx9ZmMxUbPvUDhhCy3wBLuwGu3HmqrdFx8jSKfzpH2fgDvKF/udeAOVIQF84QFezibT+FAOORYyYQ7pnYUG6ai82b1/Ywy+w5i8QYFcVdNttXgZeGl5VjIt5TdAgShD9F0GOPvi47prPB2TBX16gjStJU/qo5MVWfjiNTQVnSU0tg4ZRsPXUPkozbTDBExEWbbNN+i3EAB4FPz+Kj1bzfaZUZMSFaHFMfAfawbxcSVGIr3DTqZwmufi63NCDL9F6tw1XSz0wYieRSEkZYRRIQOVWyfg9YPvi2EFgoMv+iaS0fUMf1qltw+rZo3nr8z5MZzbYMne2C4GuwmOkU0/xXsAdPWyatoQBal0vOQnfmLa45v/cT1C55HBt9r4PsMZHOpvpIwNb0TYNxQhAymZxorA1sxByzDalxJiRqTTeun8GQjP9GjDQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(366004)(136003)(39860400002)(396003)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(31686004)(26005)(2616005)(36756003)(966005)(316002)(66476007)(41300700001)(6486002)(478600001)(6506007)(6512007)(83380400001)(53546011)(38100700002)(6666004)(82960400001)(66556008)(66946007)(8936002)(31696002)(2906002)(86362001)(8676002)(4326008)(44832011)(5660300002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VDBPdUl5U25BMENacWZQVWNCRTdMcEpmcGhsWXI3RSs4S0NQQXF6Z2dmdjZt?=
 =?utf-8?B?MkI2RWIybXV1dW53WFRxWXNRdTJjUDVtUGFLYmJjOWVIMzBwbW1Ba3c4Qlly?=
 =?utf-8?B?V2JFRDRyWXZUMFg4L0x5UUlUYVN4OFU3cHdYbThqaGpXa0lXRTJFS2prNmM4?=
 =?utf-8?B?WjZ0aHh5SzNyeStqT21hSDUzK3lhMCtkdFZXWEFQSTVDeEdXUXBhYXRhU2VH?=
 =?utf-8?B?cnVLNVVobGVMMjEvUEtlOXNTaHZBMGM5QVJNVGVXTzlEWUFCQk1VTnRneVZ2?=
 =?utf-8?B?MHF4U1J3c2dQOUdzdHQ4clkrNjZ1K0VEc2xGYTdFOTZRUHlDb2ZtaWZlVjkx?=
 =?utf-8?B?alNZVk83Zm0xb0ZQVldhYlpDOUdMWk9IcER1MTVCVm9GU0ZyS1l1MEk1M2U0?=
 =?utf-8?B?Sk9sYmtWanF5MXJVV1lUQUgvVkRPcTMzdzIxbWZUNEZobnV6QXVIRG5DZ3ZN?=
 =?utf-8?B?TWVvVTNBbmVGSW03dmpyUEo0dU5ZenhoeUJZTkp1ZTNpVHlheE1UcGV2TXBZ?=
 =?utf-8?B?SGF3Y1BCWW9jWVlYQ3JHY0hyWGNwNnZ3TWZUU05CSldQOHVua2JDQ0NFbHBi?=
 =?utf-8?B?Q0pZdWxZOGNRZGFKTmphUnlNc3dzSHNTT29YTjhwRnhxZTNBYWFhem9aNEV0?=
 =?utf-8?B?WWY1Q0FnT2gvZm1ZYkdBM3BadGpacUtsQUVYemFWZEkzM0Fxd1IwNjdMaXZ3?=
 =?utf-8?B?VnZPcm91dmdsU0J0WHhpcUNtNU5RQWQyQ2tUVlA3UkVmWGM4QUlQRm5wY1Jk?=
 =?utf-8?B?SlN3dW9YdU13L0U1QXJZb0N5M2tJblI2dDZKQnIrTU9vSDg3NVcwbHBWWWN5?=
 =?utf-8?B?U0lTbE50ZGUrdzZGUllFOHpGUjE3TkRWZmRkTmhIeWZjOU44TW1PZ04xelB0?=
 =?utf-8?B?eEdMamIzUWpIQXl1K3FMZ2c2bWpSTzhJU01LQjlqTTN0STJMNGNvdVh1ZlhI?=
 =?utf-8?B?dVM3QmI1MU9jZ05PWlJodkIraFE1cHdteUJJdzVFOHJSbXIvaFpMNTdUa3p1?=
 =?utf-8?B?R3d1VXAzN2xYRS9XckJvbWkvWVZzU0JYUEJvb0RzejNhQVRyZDgvQmJxdERu?=
 =?utf-8?B?NnMvbTZMUnVIUWxlUUJNeWd2MkZodFo5NUVpWVdEZy9tRTJ2TmVtZXRNV3M5?=
 =?utf-8?B?TzRYM2QwdE56ZHMzTXB6MDlSK1ZUYUxrZ2JvNCtmUVdKaVE3ZUppY3ZkbG4r?=
 =?utf-8?B?dVBLQlB4MWtjYnNRNm4zOVZPM0lHOVV1WDlJa1UrVW9TbWlIeElySEJEbHlv?=
 =?utf-8?B?SzhUUnBLTmJWTTQ0NDdPcnZ6UVZQVDNyNENmeWN5N0wzSklKa0I5YUtHckZ0?=
 =?utf-8?B?NlVsY1JBWTlYNHE2czRZOUtKUnh4TUpOR3JWTUczWjNpSHkxYlA1K25OUkox?=
 =?utf-8?B?WXpUZGNQMDhYbk1RZEdId1grSDN6aUE3VG5LbFFLSTVzd2Y4YmJ6YzFUTHFT?=
 =?utf-8?B?MVBZUzdSSVl3N0hqUlBvOFFnbXpTcWVDSFRjd1FES1UxT3JTYTVMUVcvNVBM?=
 =?utf-8?B?dE5CY2V5UHFaaDhjUDJzQ2Z1Qy9WVk9DdTl0aDdIMFNqVml6UmVNVUtYSVZX?=
 =?utf-8?B?YUxLOUs4YXVuV05yVWpWa24wNnVEYmt6VTNGMC8wVUh0a21WWTVLdXJudnQw?=
 =?utf-8?B?aGE2M05nZ3F4bUQwSGdvMkZXa0ZJdFNoYUdwbFZBUDNNR24zMlZQRU5xRTNC?=
 =?utf-8?B?OVB3NEgvdUQyMVRBZVk3TTVIMHEyaHhrbHI0Y1NYME1lL0dWMzJ0UzVmSGh2?=
 =?utf-8?B?VGpIODF4a2JOb1FLRmxCK1VmSXFzVjBuenZoblVZTTlTSld5NUg5bkt3QTY0?=
 =?utf-8?B?Tk5PWjV5L3gvYkZ6WURTaEFaaEVtMzRLS1lJOXlIaDNDYWRRaFQ2eGdGWmlX?=
 =?utf-8?B?QzJVcnFwdXZ0SlJBM0t0NWpEOEdYNFpwdHAzalp6enp4cUduNU5tSU1IcTNX?=
 =?utf-8?B?WCtnMmJydUVITW1NY0JRU3o1TXFXWERLMDRZNktRS2pFeFVOWWszWHJGa3RG?=
 =?utf-8?B?dUs1MzE3UnFybUJ0WjJFRzE0bGFYem1Ia1IxeUlCNHlmM0tNQllRMWpWUUlI?=
 =?utf-8?B?S3I4K0F1T2doUWlibVBlb3lvZUlOdkw4UEFwSUcxcGh1QndYMEhMeWFIZ0hG?=
 =?utf-8?Q?nijscqwUQ3ayAUhxXzu8DEwrc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d3f12344-4950-49d4-61e9-08dc22b55919
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2024 23:35:46.0308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VsQukdEL0fe4i4fO5Ruw/0Nc3IUxh8+3w0P/d3bcyTXb2L0MtEMnJsbDypJlxQRbOCTD6CKCXo/tupd/7zi4DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5091
X-OriginatorOrg: intel.com



On 1/31/24 15:35, Dan Williams wrote:
> Dave Jiang wrote:
>> In order to address the issue with being able to expose qos_class sysfs
>> attributes under 'ram' and 'pmem' sub-directories, the attributes must
>> be defined as static attributes rather than under driver->dev_groups.
>> To avoid implementing locking for accessing the 'struct cxl_dpa_perf`
>> lists, convert the list to a single 'struct cxl_dpa_perf' entry in
>> preparation to move the attributes to statically defined.
>>
>> Link: https://lore.kernel.org/linux-cxl/65b200ba228f_2d43c29468@dwillia2-mobl3.amr.corp.intel.com.notmuch/
>> Suggested-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>  drivers/cxl/core/cdat.c | 90 +++++++++++++----------------------------
>>  drivers/cxl/core/mbox.c |  4 +-
>>  drivers/cxl/cxlmem.h    | 10 ++---
>>  drivers/cxl/mem.c       | 25 ++++--------
>>  4 files changed, 42 insertions(+), 87 deletions(-)
> 
> Oh, wow, this looks wonderful!
> 
> I was expecting the lists to still be there, just moved out of 'struct
> cxl_dev_state'. Am I reading this right, the work to select and validate
> the "best" performance per partition can be done without list walking?
> If so, great!

I've not encountered more than 1 DSMAS per partition in the CDAT on hardware so far. I don't see why we can't just have the simple case until we need something more complex.

DJ

> 
> [..]
>> diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
>> index c5c9d8e0d88d..a62099e47d71 100644
>> --- a/drivers/cxl/mem.c
>> +++ b/drivers/cxl/mem.c
>> @@ -221,16 +221,13 @@ static ssize_t ram_qos_class_show(struct device *dev,
>>  	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
>>  	struct cxl_dev_state *cxlds = cxlmd->cxlds;
>>  	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlds);
>> -	struct cxl_dpa_perf *dpa_perf;
>> +	struct cxl_dpa_perf *dpa_perf = &mds->ram_perf;
>>  
>>  	if (!dev->driver)
>>  		return -ENOENT;
> 
> This can be deleted since it is racy being referenced without the
> device_lock(), and nothing in this routine requires the device to be
> locked.
> 
>>  
>> -	if (list_empty(&mds->ram_perf_list))
>> -		return -ENOENT;
>> -
>> -	dpa_perf = list_first_entry(&mds->ram_perf_list, struct cxl_dpa_perf,
>> -				    list);
>> +	if (dpa_perf->qos_class == CXL_QOS_CLASS_INVALID)
>> +		return -ENODATA;
> 
> As long as is_visible() checks for CXL_QOS_CLASS_INVALID there is no
> need to add error handling in this _show() routine.
> 
>>  
>>  	return sysfs_emit(buf, "%d\n", dpa_perf->qos_class);
>>  }
>> @@ -244,16 +241,10 @@ static ssize_t pmem_qos_class_show(struct device *dev,
>>  	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
>>  	struct cxl_dev_state *cxlds = cxlmd->cxlds;
>>  	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlds);
>> -	struct cxl_dpa_perf *dpa_perf;
>> +	struct cxl_dpa_perf *dpa_perf = &mds->pmem_perf;
>>  
>> -	if (!dev->driver)
>> -		return -ENOENT;
> 
> Ah, good, you deleted it this time.
> 
>> -
>> -	if (list_empty(&mds->pmem_perf_list))
>> -		return -ENOENT;
>> -
>> -	dpa_perf = list_first_entry(&mds->pmem_perf_list, struct cxl_dpa_perf,
>> -				    list);
>> +	if (dpa_perf->qos_class == CXL_QOS_CLASS_INVALID)
>> +		return -ENODATA;
> 
> This can go.
