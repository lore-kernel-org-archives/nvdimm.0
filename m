Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C12979DD6
	for <nvdimm@lists.linux.dev>; Tue, 30 Jan 2024 20:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706647717; cv=fail; b=pszciYpOPlDVYrGE2yRyKWF7Ov21bFmYM2vqdEs2VOvl9IBUXf0WKh0p1T7kgeTEPGloa+r7/9pCJ6A6SkeYrRCv0gVresm16f2KuA4jkH0IK9w7MiRrlSdISkEtzLfuM11xYyDgwkneIBdK0xeT3JPk/B2kKLtdHz/iG4/fnG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706647717; c=relaxed/simple;
	bh=QfC21yukwGFuqAcBHSGA2GKP65QBbVotir1Fkh+eg8w=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=G4GTmvCNGqmsoF30SGf8Ui+spjIdqyPdSDOkBMLnmGqnD/hUW7XROgcIbtBxaxEvw3P29F03eifI+yHbUf1Y0litNZc2rQihw3RklBOYu/OOrwB/0s6QdCeIQt776FZt/b7rS64st9qI6C9NjYmUJEQu2CKKZkb3TyB5fqGC9vo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HGtL1KbM; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HGtL1KbM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706647716; x=1738183716;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QfC21yukwGFuqAcBHSGA2GKP65QBbVotir1Fkh+eg8w=;
  b=HGtL1KbMlTtk4r/YqQQ16Q52R6Cc+V0h8ot8dgv1LqNa2ljRyek/tyoZ
   egw9p9b3aVZ0COr3+jZxPH2QUBrpTDjcBBYChTPmeKU9Ul4JN6SWVr9C9
   XJkm8zK8OC2C/0GzL6DIUR9SpgdBMEY0AQCmnA0gl+M+3beKEoR6RmVtN
   KxHluRamwyDdUddirdXUe+aVyfewG9TR90nOEpslgKs9/ybO7qP21p71p
   3TZg5sQ4Uhtlh1UFfhX0Lr657CwelWhle7mdA37Dd7iv9YlH4lCqfpIFz
   C2L43wlLX9ZRjtsRVgRsZ6CgPWuM+R6DdOZHt7BpdpF6KlpH0BtQPmYbE
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="10784654"
X-IronPort-AV: E=Sophos;i="6.05,230,1701158400"; 
   d="scan'208";a="10784654"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 12:48:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,230,1701158400"; 
   d="scan'208";a="3842188"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Jan 2024 12:48:33 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 30 Jan 2024 12:48:32 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 30 Jan 2024 12:48:32 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 30 Jan 2024 12:48:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=as8gC82la4iaWaAfBEoOdKYBDCnYgeQ4FjeKzhhBYbPGU6GTVf+0XeSYMV02uMftCqzTh+C2JQVyHhJNCmPmSobBtNZZRvcKhJp96Jgntaam/HxF7HTlBAOlSAd4pP4VYs7/Szq+nCQ3Kaj3NtS7Y/Ui1HqOrEiAnZTsUcMzOM841tz0a6KWUfYraK/QXE6iS2KRvtc+YSv8FqAly2cSj+5cQTzCQXww2EVWD0sGi2CAGxwCuyadtEu5dziFZZrCafLM3l4GQM3ZYnICCPY/Gin4Wm1Cd67QJIwlmgemp/9PYFUUSon6OQNC0rnIkYBP1tvDdX+AjnB8bKhsz4cGVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bR0XRK5/08rPnSM8B5YC0E51qTiLWLTFQW43BwpX9ys=;
 b=KFftU38IKuTNsIqLhklilfsu9y/HecQeQgSW36U2MVSkMwHeznRKUPMhqN2j9UZR+3W6qNwDivix/sQ6DHAXUvNiKkHrVPaAWozT4ajxPkn/ucZQC/TZshyb0RSuLjPOBETcXZgq837uTCfX9Qz67j776Nhqgf+UG1Uy0BWDgLKmv8mVvoI5j0mo8FSWKFflk5cXBL57O5JTS/Q/2CXbhakPSmdpApoxLZEboo4wDRA8YuTHL7Y31cuVDihEt7ibfQ+WdoOE2KnyD+ZTczHXzcl8Fl2F2GlFXhOs8q8uXwf3Q9BuXTfK5tjEniZ9yGGtYHqEOKwPm8W50cYCGqo63g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by PH7PR11MB6746.namprd11.prod.outlook.com (2603:10b6:510:1b4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.32; Tue, 30 Jan
 2024 20:48:30 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::c403:9b0a:1267:d225]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::c403:9b0a:1267:d225%6]) with mapi id 15.20.7228.029; Tue, 30 Jan 2024
 20:48:30 +0000
Message-ID: <b3c34787-db24-4d82-8c63-3b070df5ff60@intel.com>
Date: Tue, 30 Jan 2024 13:48:26 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [NDCTL PATCH v3 2/3] ndctl: cxl: Add QoS class support for the
 memory device
To: Alison Schofield <alison.schofield@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<vishal.l.verma@intel.com>
References: <170612961495.2745924.4942817284170536877.stgit@djiang5-mobl3>
 <170612968788.2745924.12035270102793649199.stgit@djiang5-mobl3>
 <ZbPzj90keGE0zr0K@aschofie-mobl2>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <ZbPzj90keGE0zr0K@aschofie-mobl2>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::22) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|PH7PR11MB6746:EE_
X-MS-Office365-Filtering-Correlation-Id: 54f090ca-819f-460f-b95e-08dc21d4d0b8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8nzJDH85Z0vjujimnW5wnVWu3IuFCbcNEXk5pzmvYUtwWvDOFPAtf0fC40szZjiGRMrdoIWvNcWYO5BltmeBsYtiVGOjAMrUGH5ro+/YCNCCsp+zWMoHJ+yP2KpwJA7m5RyZl03obtE3giB5fGgcLYHqQxo211oXCHl1696T7otMQ6xWju3bEYxDLt+VJyV1AshoWfDgGrg72c7DD2yyYJlaC5YP6cecyGaGp57MNUnYfJE9+b/dvJ7WBswiBeTjOAR08SASs+c8YupWRvWyqOaKin4/kNQuc9K5HhDQFIckENdnCR2faiCti2izeJV9Gi5QxiPq99EtpkFvyifLPVaYRoowRCetQpVhFGdov/spc8lAcs68e6yHbbB/Vv158qqbtVxauXOR3fHE+Sq130oAVOWiewgRUFDbqyx8xALDahjZtgtfHP95jZ4ExZhSIVqbmIAgVKBEzMGls/fup00HkndDx2a6/nxSRX/WGWC13IdxEr9Mqp/MaJm8B32Bju14kwVuy9NQ+YVdGy6B3DM8Y9is45zLlQdPsKBJ0qmM9pzxg6LWiuy97v/svKX28kjPiguT0/+ddNNnWPI52yTaOsXXFstXIFw4QEolLJ/PCff2rRfXKpsDFPr7SNh+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(366004)(136003)(396003)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(83380400001)(26005)(6506007)(53546011)(86362001)(107886003)(6666004)(8936002)(38100700002)(8676002)(5660300002)(6862004)(44832011)(2906002)(66556008)(6636002)(37006003)(41300700001)(66476007)(66946007)(4326008)(6486002)(316002)(36756003)(31696002)(82960400001)(2616005)(478600001)(6512007)(31686004)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RXJWajYvTkJsdGJKNHo2TU1JSnBieXNLKzVKUFk1WjAzM011a0czTElvQjhh?=
 =?utf-8?B?WW1IcmwvVk14aTZaVXFyS3lKb1NmdTRoTFZWdEFrWERxWEFkaTROdlpUN0k1?=
 =?utf-8?B?elZ5MjczajhJdFNCdndqZThaWFUyeHNaSTVSOUc5Y05uanNjQ1A4bXZvMWtv?=
 =?utf-8?B?RU9jbG1aaGw0T2VhN01qeTkxeTJ5OXFtWGplSkNxL3YxUHd6d2M3d1AzTllP?=
 =?utf-8?B?d3QrR2IyN1UzbCtLRm9lNTVKTDNTWjZZTjRQdkxFaDl5c0dkN3FvYWJoendN?=
 =?utf-8?B?TTJiOWovak9FY09ERnFUVEx1UGZJNTY1WEg4MXBKY2xJaWZjYnQzY21mcnNs?=
 =?utf-8?B?blVzQkRGTFV2WHNHWnVVMDhNRkI0aldFTTNESWpKSHBYdi9rVy9naTczU2VK?=
 =?utf-8?B?TmpXZmpUQzJPd0MrRlVkdEs1T2RzbGtsbWpFQlAybktleFQyVjhBWXF3cXRM?=
 =?utf-8?B?bUNYQzNhOTNDcjdadVpTVVdjcGNWTExPZWJ0K0dRWG1LRXJuUm9lOW54bHlu?=
 =?utf-8?B?R1NJSWZsd3hiMnVzdUdveUMzVE5VNXhKRW1Odmx6aVlNVllHWW9Cd0JrMW4w?=
 =?utf-8?B?Nmk4N1BPOFdqVFA0NzVrbzFSSjdaOXFJN0x6Ly82RjY3QW8yeU10VFZmdGJO?=
 =?utf-8?B?QVMxbGExTWNYTzRFNURkTUU0M3AyU0YyU3g5b0x3NlRYTXhpamJRMVYrc3FI?=
 =?utf-8?B?MnNOOHBiRVlBZWxPcXRVVlArSExqbzJZVnpWOUJBV2x0T0w1TitJU1cyQWJJ?=
 =?utf-8?B?cEhPL0t2NTRzaTlKc01XeVU5M25ZYmVQV0IzMHJKRWc5U2RjempmeVJqSTJi?=
 =?utf-8?B?NnJidmtmL2RxNlNmcyt4VGc4MCtKOExiK0VDMk1mZzlHZmozRXBqVE15K1lj?=
 =?utf-8?B?WTY1NHR1bGE4cXBPNTdsbWpKLzlBMVNobEROVnZuMTd1SXhvdWhZWWE2NHdJ?=
 =?utf-8?B?MzB5cWZ6Vy9VQ2hJWDdydk14aFRGTytqYkNHZXh6d2lEbDk1YzlxZUdwQVQ1?=
 =?utf-8?B?NjRLRFVCWEZ1WXpwcHZwYWdVeEI3bFpmNTJ3SXlvVURodUUxNUhlWWt6c1ZB?=
 =?utf-8?B?THlNTEdxYVRLNWJrRjV1YTVqai9LQVVBeDQvQSs3WG1zSWl2SEkxd3hUNk1C?=
 =?utf-8?B?dGVhSVNjbXJ1anFjdTR1OUIxUWRqdHBaQitCSzlkS08rd1h3RksxNE9KWHAy?=
 =?utf-8?B?MHBuN3Z0VURsNktjSXlkMTVLME9GQS92SUs0bG94VFQrRUlSeFdaVGJkZ01B?=
 =?utf-8?B?ay91MGFwMFJLc2VCeWV4cXBQUy81YWp1ZmptRHE2Lzg0Slh6d2JCRDA2TzFo?=
 =?utf-8?B?Q3I3c0pMYmdtZzBNZ2JhcVRlbFhQTHpOYXYzZDdPQXd0S0d3cFFwTVViTyts?=
 =?utf-8?B?SUVnM09SbDZONEE2bkpBd0x0MnVkQ2JBNUtkc0tJVmJsYjBMZkdrOE5wMjhY?=
 =?utf-8?B?Qi94SVhxb1dCZlBDcXFGbHc2Tm8zUGZZc1JRUGtPVlhFenJaQmhTckVPNENT?=
 =?utf-8?B?Q0ROb3FTNXovK24rbEt2QXRnVzB6QVpKVnJqbGlCcUZ6Vis0aHNiNEdETEFH?=
 =?utf-8?B?dUg0QU5pZFdKdDNrYktLYkxQekplZEtjQmVsakVMc1RwQWRpcXNRZjdHelhx?=
 =?utf-8?B?Z3FSeEJIV0RUZWNyODA4bWJjWVhRSSt1MFVUMGpzdUlnbUROaXdIQk0xSUJV?=
 =?utf-8?B?RFNvRG5CYnZtWUxickUrc09SdmRLMmxXYUhkc21CZHE2ODBxNTNaeE1NUE91?=
 =?utf-8?B?R2E4bE8xN3FsNG52MEpmcWpuU3Nndll3RGRyKzNDRHVIUzlGVXZPcFRLaHRF?=
 =?utf-8?B?cHNIejBXcGRxN0MweUx2R05WL01qN1oyT1ZWTXZJcHB1R3pNUElaVzVCby8v?=
 =?utf-8?B?WVlBeGp3emxSRytEMFV2Y0RUWlBweHYwMkFsL0UzeTJWYVIwRXpqdDFsQ01R?=
 =?utf-8?B?eU5IbDFKRFVZbzltOVM2WXdUelJESUE3MXJVNDBtZE1mcXhTRDhPbCtkUnR2?=
 =?utf-8?B?d1JYUUc0TzZ3RDVIUU1uQmpnS2ZqRy9KUTZvVTNQWXVlODVEZzRWK05LSE5G?=
 =?utf-8?B?Qy80UzgxQzFmaFR0eFF6YTNEZjRCQUlZejVNbmNRUlRGTXdtM0hKMzY4VEVV?=
 =?utf-8?Q?RkijsPQmx5ol5sP+5RP8vsM08?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 54f090ca-819f-460f-b95e-08dc21d4d0b8
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 20:48:29.9848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 639b6Ad47jzYW6xDHXda0kc48R1rhv3xOyZYK/Z2xEgBN2ojqTKy3L0pDTZyrKi+zDuap0nBXWQ2x6cR1eKHAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6746
X-OriginatorOrg: intel.com



On 1/26/24 11:01, Alison Schofield wrote:
> On Wed, Jan 24, 2024 at 01:54:47PM -0700, Dave Jiang wrote:
>> Add libcxl API to retrieve the QoS class tokens for the memory
>> devices. Two API calls are added. One for 'ram' or 'volatile'
>> mode and another for 'pmem' or 'persistent' mode. Support also added
>> for displaying the QoS class tokens through the 'cxl list' command.
>> There can be 1 or more QoS class tokens for the memory device if
>> they are valid. The qos_class tokens are displayed behind -vvv
>> verbose level.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> 
> One tidbit below. 
> 
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> 
> 
>> ---
>> v3:
>> - Rebase to pending branch
>> - Skip from failing if no qos_class sysfs attrib found
>> ---
>>  cxl/json.c         |   36 +++++++++++++++++++++++++++++++++++-
>>  cxl/lib/libcxl.c   |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  cxl/lib/libcxl.sym |    2 ++
>>  cxl/lib/private.h  |    2 ++
>>  cxl/libcxl.h       |    7 +++++++
>>  5 files changed, 94 insertions(+), 1 deletion(-)
>>
>> diff --git a/cxl/json.c b/cxl/json.c
>> index 48a43ddf14b0..dcbac8c14f03 100644
>> --- a/cxl/json.c
>> +++ b/cxl/json.c
>> @@ -770,12 +770,32 @@ err_free:
>>  	return jpoison;
>>  }
>>  
>> +static struct json_object *get_qos_json_object(struct json_object *jdev,
>> +					       struct qos_class *qos_class)
>> +{
>> +	struct json_object *jqos_array = json_object_new_array();
>> +	struct json_object *jobj;
>> +	int i;
>> +
>> +	if (!jqos_array)
>> +		return NULL;
>> +
>> +	for (i = 0; i < qos_class->nr; i++) {
>> +		jobj = json_object_new_int(qos_class->qos[i]);
>> +		if (jobj)
>> +			json_object_array_add(jqos_array, jobj);
>> +	}
>> +
>> +	return jqos_array;
>> +}
>> +
>>  struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>>  		unsigned long flags)
>>  {
>>  	const char *devname = cxl_memdev_get_devname(memdev);
>> -	struct json_object *jdev, *jobj;
>> +	struct json_object *jdev, *jobj, *jqos;
> 
> Can the generic *jobj be used below rather than adding the new *jqos?

With the kernel code change, this code is simplified and jobj will be used now.

DJ

> 
> 
>>  	unsigned long long serial, size;
>> +	struct qos_class *qos_class;
>>  	int numa_node;
>>  
>>  	jdev = json_object_new_object();
>> @@ -791,6 +811,13 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>>  		jobj = util_json_object_size(size, flags);
>>  		if (jobj)
>>  			json_object_object_add(jdev, "pmem_size", jobj);
>> +
>> +		if (flags & UTIL_JSON_QOS_CLASS) {
>> +			qos_class = cxl_memdev_get_pmem_qos_class(memdev);
>> +			jqos = get_qos_json_object(jdev, qos_class);
>> +			if (jqos)
>> +				json_object_object_add(jdev, "pmem_qos_class", jqos);
>> +		}
>>  	}
>>  
>>  	size = cxl_memdev_get_ram_size(memdev);
>> @@ -798,6 +825,13 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>>  		jobj = util_json_object_size(size, flags);
>>  		if (jobj)
>>  			json_object_object_add(jdev, "ram_size", jobj);
>> +
>> +		if (flags & UTIL_JSON_QOS_CLASS) {
>> +			qos_class = cxl_memdev_get_ram_qos_class(memdev);
>> +			jqos = get_qos_json_object(jdev, qos_class);
>> +			if (jqos)
>> +				json_object_object_add(jdev, "ram_qos_class", jqos);
>> +		}
>>  	}
>>  
>>  	if (flags & UTIL_JSON_HEALTH) {
> 
> snip
> 
>>
>>
