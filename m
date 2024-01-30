Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999BE5B1F6
	for <nvdimm@lists.linux.dev>; Tue, 30 Jan 2024 20:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706647995; cv=fail; b=q4IjMNEucRD3aumjgmHRwymOSKLdm/hm/t+CrjnZMTpSGvyeZK1ZgtrqPY43NTLyLJTxOEhmtqYR4LayccNOqbayX4i8nqbM32B+mNqwEJ80w7uv4xfl9m17sxPQB/YUjT1CHHFWzjxE3+LACE1jFTPJNI7+EYlgK18Af8sphys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706647995; c=relaxed/simple;
	bh=vT9fsamIoC6Wm2wtIiH7kliikSJHHOXz3Pfr2tMMfB0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LX9hvDqt2CUZ7ns4IWOFPKeGDlsx+J/a9Xog/9mT6X/lvl5YlMvIs8FwuudQ+l88wj/WVm2bHYkBo8zBT6l9YMQ4SwB+Tm4yOnBImjf2zm4DvkAtDdnM2euxE8xz1eB6Q5bh0v8pJtfFPVZm5r1d+mkC3N5+B98wKgftscNs0Ms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MFYNDFdc; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MFYNDFdc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706647994; x=1738183994;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vT9fsamIoC6Wm2wtIiH7kliikSJHHOXz3Pfr2tMMfB0=;
  b=MFYNDFdcNEjt7x/lAsRzx/LmYNmf60qxysTQOgOIkT/hxNQaNlzCGL07
   eIXqs/twDRcv2RbDoT8T1dQH/WSHiRyjZBEKlyp1f8EJM34rU7ylXCjaL
   CDrIEEunT3msUwooUCv8rDj/Zc/NnjQHM6doSAgRPHmgk/2DztGUvSI8m
   z0O+KzC1+orNnYL49UD/hPiSrOVA4ICxZtXsKoKXB8yLkZT6T88d2nKyJ
   Ca+qKkPJ2s2csRFXs5QJ2FCS0sh1aYvlof/p0oenvm08YPLdYCyw5Ql02
   QoAQkS2PXW5zT1VAdaRSnOC1FFJaqX7NnD9PLf8FGH/dwzvYKtbJ5cHK9
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="3245551"
X-IronPort-AV: E=Sophos;i="6.05,230,1701158400"; 
   d="scan'208";a="3245551"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 12:53:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,230,1701158400"; 
   d="scan'208";a="30020805"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Jan 2024 12:53:12 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 30 Jan 2024 12:53:11 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 30 Jan 2024 12:53:11 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 30 Jan 2024 12:53:11 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 30 Jan 2024 12:53:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MdKPKCpYa+KElp2Rd9IGy9dt5wzV/TVt6vgXkJLbnG+7FoQ5L21SPPEkq4vn8Tw4QAOZ+l/F3PaK1i5qbY30gfKA89IJSbJTnCp4Iq6HNFIg1QKOrYnKyKpRn9IRMY7tZJLjVPPNSvPNTpWbXn75IF7Z6NFtMI+39/MeMWjRl2Ns+gjSzY7M5b73X8SxfdaE0Mq0bvx0l3HcflQeRUxi3r0MA29jwO4vEoExtSxwQK2pMoU0jua2ZQi9aQQ3xjLxECdFxB09mMLqjDI9ObMx5kRTr4lWbcaUMgUvG6WIZsZaFViHWHNyBdMPA45IS36Yjgce2w5p7F3eoWsWDK1uqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gXgYKWe4iNb/dzS6pbo/ehsv935h6XMFYcL39h3/r/M=;
 b=SXTi55mI1o0I06RXM/l05at016qmGolOCmFyhcT34mFcfVIomLB3x/YQjuJ9tHY9wZXmGoakFcRqsI9DTxr6NrwMtY342hy4B/mSnTUBXRmmMO3x09xFBbtY9fzuFf1ZxSrKNYcbbsNvFbd6XjixCD7BiuWreCoj1EZA1sww16loGsu83uOYm4SvntAAKhCEZPRywx8hVzjcwOpgR06hzLXNgixvC3cFMB1KZc2ICRZ5CD548YUrfXTruFg0glJEycfCxBNeHAZFkOgefNJksDhX1ZKjQzwg7RQQxMBG5iEGv80At892GqK/HTe6rT/EqQFxQ7Bp51R/10HIUldUqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by CH0PR11MB8192.namprd11.prod.outlook.com (2603:10b6:610:191::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.33; Tue, 30 Jan
 2024 20:53:08 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::c403:9b0a:1267:d225]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::c403:9b0a:1267:d225%6]) with mapi id 15.20.7228.029; Tue, 30 Jan 2024
 20:53:08 +0000
Message-ID: <d9127d2f-da9f-4b39-9f81-0a8e718e5ebc@intel.com>
Date: Tue, 30 Jan 2024 13:53:04 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [NDCTL PATCH v3 3/3] ndctl: cxl: add QoS class check for CXL
 region creation
To: Alison Schofield <alison.schofield@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<vishal.l.verma@intel.com>
References: <170612961495.2745924.4942817284170536877.stgit@djiang5-mobl3>
 <170612969410.2745924.538640158518770317.stgit@djiang5-mobl3>
 <ZbP2f31s09WRzWb1@aschofie-mobl2>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <ZbP2f31s09WRzWb1@aschofie-mobl2>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::15) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|CH0PR11MB8192:EE_
X-MS-Office365-Filtering-Correlation-Id: c6a94553-4bcf-4ad2-0c4f-08dc21d57691
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CFiBFCc+XW0KC9uXXyRUdyDv7UvUVf6w6mrFOhI9ezyCHYDoYocATKSiPD7z4lx09KuYuTFlAk0cSCeLR3WM4A9WWkR4/Mq213oxxbVHy/JUAJLiVN9A3Qn0dP2264RM8/7uB0lYKTVVosRkCZbDY18bNWTjyIaMH9SCkHH9A1r3OtNhz2VJ2MVAlSOyc6BCAx7u7EXXD9W7cGjXJn0W6/xt4Uy1Dkr0J8atVLmuCG1bAc9MSMqZ4GAzpB8JUGeITz7bS5iuefp5pmBLErljFV+koyL3XoWfVIlPLmSJMc0593DLZ3ZaV3DXP2/KwAOUEcIP6ln6yT5UllxRtRAlexaFxl+htAOdn/LyfT7EMFQF06a2Qo2ooc2BEixHQrSwV7a5NMXrd8fpx1FJqF00omMy4ZVm2U1kPnWkFOw46CNnQqJVFEu3cnzQS7iTr3DY1IT0Ezt5KA5csimuM3NMHsctsAHkn9IBoOpsBoqV1dTp9sTCA9IZGwI8TzwP5BG2/tq5LH3RGVw49jPHame44OEnQQlwuOEGyQspSHIiUd/jcTgAu/IRBXlUl5yZcuWiW2WfgVxJJ+rTWTGhbSse/YLP8q9wYNqoxBtKrHkF1ts/KU3eUj8mFyj2xMrofgGHKiNt4YOYdCe55Fu3R9T1Cv7MB4hN08A9sLfuFlzmsho=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(136003)(376002)(346002)(39860400002)(230173577357003)(230273577357003)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(36756003)(66476007)(5660300002)(4326008)(6636002)(8936002)(6862004)(8676002)(2906002)(66946007)(31696002)(86362001)(44832011)(478600001)(316002)(37006003)(66556008)(82960400001)(38100700002)(6506007)(6666004)(6512007)(53546011)(83380400001)(6486002)(26005)(41300700001)(2616005)(107886003)(31686004)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QkVMOFNEMWlNQzNUaXFuR3FZQzJMb0Rad1hJYlR1UEdhcmtkamVxMzg3b25q?=
 =?utf-8?B?UVo4VFNod1JQZVo1SHBMemRXdVd2Y2I5ZmVoeWFaOXBkek1ERWJnNVlZODVt?=
 =?utf-8?B?ejVCaUdac2xZVzhZZ0VtcWtUdE1vT0JFTGVwMDQyMGh3cTFrZDFXTGxWZFZ3?=
 =?utf-8?B?MktUNUJIaEQrMXFzVVZtV3RVK3A3RmsyTUVmZEFaMXQvVnB6cmdDNGlnSU9Z?=
 =?utf-8?B?aUhvWllJMTNsekI4Yk53L3gyWi9nclhnc1dmaUpNR3R4aDBQTFpCS3B1L1Rx?=
 =?utf-8?B?TUJnYXptZ0daOThQM01RTzNhU2dtZWV5TXMrRWVNL3BzSXBwTSt3NnVrUGky?=
 =?utf-8?B?UThyaUluUVhNZTlHb0JMZkV1YmZySGpiWUFiZkxieHdDczlHWW1ZSnpMUUht?=
 =?utf-8?B?YjFLbmtHaXVIcityQjhORXlQZDIxY0tOU2t3VWJRYUUyY1hQZ3dadXpEOWtk?=
 =?utf-8?B?QUN6UzgrcFA0eXVHdVlXNFQ4OGEzdmk5ekZuTlJvSXhrMkNLV3JaVUtheDdl?=
 =?utf-8?B?UmZnakpjWFdJWGZRTUtPVGVsVmZKK1lWU0p2YWVzVmYrY3VQZ1I2cEErNkR3?=
 =?utf-8?B?QmtFbEwxSTNpbzBkRVF4VTZ1bTVtMkNVeUoxVXdMcktOaHJnUEVYQUtrTjRp?=
 =?utf-8?B?N2owSFRRdjhzMEFhNmpCL3lsdk9ZTkZReC8wUzhwY2hvekJmWURldDRLdUxD?=
 =?utf-8?B?eUZhTjZ1TkYvSis2L0dhTXNMVUxyYTBmK1VjdUk5T0szV1VDTHp4NUxIazJE?=
 =?utf-8?B?YlI5YVVnbGJ2cU43SE5URWlwUDN4WWEyd2o4c0lDM01wSm5TUGs4OWJGVXVW?=
 =?utf-8?B?WFMxY0ErVmtSRGdVVU5MbHVFTjhTRUhaVU1FcEFCV3k3ZGtLQVk2WkNJaGV4?=
 =?utf-8?B?djhGUVZoTzMwY25objFCaExlcm5LVit3eFVuV3ZFdFNPSzlIbzBvSFpRQVdo?=
 =?utf-8?B?M05LN3djNVFpczZCZ3kzYWNjODI3MkxsazkrOUIyQkVma29wS3FLMnV4MVJP?=
 =?utf-8?B?anh5N3VKYnF2RXUydk41N2gzTGhWZWc5U0RZMzJESGtabyt6cklxYVRVOGV1?=
 =?utf-8?B?SXd6WkVVK0l0MFl1VnhTQjhFTVR3QVFHZVJCcDl3b3FBclNSeG96TUtCOEVm?=
 =?utf-8?B?UW1DUWRLNGJFT21RTC9MMkxZQ1RmbFQ3a3dDWjRETWMyNkdKeFM3UnRRenNk?=
 =?utf-8?B?NkVaQzkySmN2WktWVDQrMit2VStET3ZpSDhNZHYybjM2UmdJalU2aGQ5am1u?=
 =?utf-8?B?TXBUdjc5ZWkxUitWRU5lT1lUVWx4K2d6b2RoMVdXcmhSZlpleVg4NkpvOWJ0?=
 =?utf-8?B?eEluNUZTd1V0OUpBK0s3dTF6TjladWxpbGNCL1hlQkhyK1M5N1l4dXRtQUdn?=
 =?utf-8?B?cHlpWmVTNDZ5ZnEyK21kZWlYdDlLRVBNZnhwWEoxRHNmeHVXL0hCN2dpSFkr?=
 =?utf-8?B?WGdyc0NRcFNTQUhwZVhURFh6ZVRhYnlhbDF4YkNqazhuVWUrbHNnU2tvYXhG?=
 =?utf-8?B?TEsrcEYzKzdUbkNtV3FLaTN6Y1pnNyt0citDTExjdktoWHoydmtZZ2hhcVMx?=
 =?utf-8?B?WjJIbHgwU0tKSjlNWkJQYmRNRUl0VWZsNW5UcWI3V2RzU0JmL2lYZXBzZHkv?=
 =?utf-8?B?MUdNQXQvM1VoNlhGZXhKeTZvajQ4cUxBY3RVT2xmN205azYzTm1Zc2trL1Vi?=
 =?utf-8?B?VHdlZ20xVXdaTE51V0c4U21QYW9aejdoUnZSbDlCOEgyeXZzSVBsb0JKdkxV?=
 =?utf-8?B?K1NSSFRrRVNGMmhud0RTTCtWNCs1Y3MvQmhQT2drUjBPRlZUaTBhbHNtNUlP?=
 =?utf-8?B?Ui9aVmdFcG5IQVFwZVB0Q0VhR0lkclFTTlNZV01FNFhlSWtZcUtXa2N4UXNt?=
 =?utf-8?B?VHVNMWdFMExWNFNMZUx0SWhveTFHZmgzb3RZRWlqb2oxb3Z1RHBKZTg3MXdm?=
 =?utf-8?B?dHMwVkZnU2NhMS8wcTRUNDI5Ti84OW1wMU01cWtGNWhHRTJ5azJZOU1tVjJM?=
 =?utf-8?B?M1RXalQ5ZU5vMGE2OU5NRHR2RzZLT2k5ZXk4MTYzY3p0UFg5UDZXSkpIb3hn?=
 =?utf-8?B?cFdUcUxOa2UzZ3JMZzNTTWxBVStDWWlYTjFIS2d2ZitZRHlHV3VjbWZ1TGpL?=
 =?utf-8?Q?nzypaaA3Gvi9cYc6tIsJYzgPp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6a94553-4bcf-4ad2-0c4f-08dc21d57691
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 20:53:08.3570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ICoi+l4JawDqdi74e0nLAc0Vz/HsQXb3G5ftjvUt1G/7zONlOKX1IOIqLLwOljEYE1yUAF82Y0nfrMiOVmeFkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8192
X-OriginatorOrg: intel.com



On 1/26/24 11:14, Alison Schofield wrote:
> On Wed, Jan 24, 2024 at 01:54:54PM -0700, Dave Jiang wrote:
>> The CFMWS provides a QTG ID. The kernel driver creates a root decoder that
>> represents the CFMWS. A qos_class attribute is exported via sysfs for the root
>> decoder.
>>
>> One or more QoS class tokens are retrieved via QTG ID _DSM from the ACPI0017
>> device for a CXL memory device. The input for the _DSM is the read and write
>> latency and bandwidth for the path between the device and the CPU. The
>> numbers are constructed by the kernel driver for the _DSM input. When a
>> device is probed, QoS class tokens  are retrieved. This is useful for a
>> hot-plugged CXL memory device that does not have regions created.
>>
>> Add a check for config check during region creation. Emit a warning if the
> 
> Maybe "Add a QoS check during region creation."
> 
>> QoS class token from the root decoder is different than the mem device QoS
>> class token. User parameter options are provided to fail instead of just
>> warning.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>> v3:
>> - Rebase to pending branch
>> ---
>>  Documentation/cxl/cxl-create-region.txt |    9 ++++
>>  cxl/region.c                            |   67 +++++++++++++++++++++++++++++++
>>  2 files changed, 75 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/cxl-create-region.txt
>> index f11a412bddfe..9ab2e0fee152 100644
>> --- a/Documentation/cxl/cxl-create-region.txt
>> +++ b/Documentation/cxl/cxl-create-region.txt
>> @@ -105,6 +105,15 @@ include::bus-option.txt[]
>>  	supplied, the first cross-host bridge (if available), decoder that
>>  	supports the largest interleave will be chosen.
>>  
>> +-e::
>> +--strict::
>> +	Enforce strict execution where any potential error will force failure.
>> +	For example, if QTG ID mismatches will cause failure.
> 
> The definition of this 'Enforce ...' sounds very broad like it's
> going to be used for more that this QTG ID check. Is it?  Maybe I
> missed some earlier reviews and that is intentional.

I left it intentionally broad to allow it be used in other strict checking in the future and not exclusively to qos_class. And then the -q parameter below is used to override for qos_class. Speaking of which, I should fixup the documentation to use qos_class rather than QTG ID. 

> 
> I was expecting it to say something like: Enforce strict QTG ID matching.
> Fail to create region on any mismatch.
> 
> 
>> +
>> +-q::
>> +--no-enforce-qtg::
>> +	Parameter to bypass QTG ID mismatch failure. Will only emit warning.
>> +
>>  include::human-option.txt[]
>>  
>>  include::debug-option.txt[]
> 
> 
> snip
> 
>>
