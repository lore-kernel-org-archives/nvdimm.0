Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B28255E32
	for <nvdimm@lists.linux.dev>; Tue, 20 May 2025 19:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747768289; cv=fail; b=MZSVJandqtGi3uacuNj2iczZDSXGuFY7DXjoaoyiYsOHUKydDRV+QOTIvz3W2i9CAr9TDdp25OFGQbokRTrBPaycsJwGaQ4rlIW4Ue4LmPf6YOPgwX644YJMJyEIRoFXmiyAD1Zu/aqkPbK7QTFBcCTsjrUNGbXliS1aGLqMrqY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747768289; c=relaxed/simple;
	bh=6W/N+C1eqjH3EmecxpYDcY7h+dimj9ezJrrESrStWCA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qvU9nCQ5bFZL+2qNCWOHpbEI4HTmTlM7CkXYw5+akZtW/wLKuTpEDUA91CYo1kZf9vr/h0lu0nZDqulYle3Lr8FFgMv3tNbRqKH/xtaPJW8ml2eWa+pdcQgtdfvWMUzuqSj3BMZ2jhbDwiT89QduznC+0CFTY3qVzIFb2wvrkMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=djLhyiMb; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="djLhyiMb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747768288; x=1779304288;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=6W/N+C1eqjH3EmecxpYDcY7h+dimj9ezJrrESrStWCA=;
  b=djLhyiMbilMJPt6/QMTp2fRbYApK0CeJev7JDmUqX94TaEG8shFgOJHi
   SaYVm42o3WFxdavTJ4PO8Ao+41NgbavWCuefNdkgJrPyovKhf9mnAaxM3
   fYD34o9siY7Mcb37iFMbwZu32WJJ1tVOBuunnYSqLREN7gljhGf+7u4iZ
   q0XRUk8G4V9BVfgkO3HmVjkzdEU5ULuYilC4bH4Rm2HSxtJj8O1KOqVWx
   WB7w+MF3ZMZRvheU/qHv4NUU0CnNCjs4tdN/JPUNyaRWNyQZBzF+pLHnu
   gStizBh8mJqpkFv9pzth9SOiXI34CmzPc9AHaJ2twEgK/Ey+JG1okaFag
   A==;
X-CSE-ConnectionGUID: rkuWjMDCT2GiOSDvsT/Maw==
X-CSE-MsgGUID: XqRtKqlzQKSC+EauWzWVxg==
X-IronPort-AV: E=McAfee;i="6700,10204,11439"; a="49874080"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="49874080"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 12:11:27 -0700
X-CSE-ConnectionGUID: OVtoksgBTSW1dkho68KLrA==
X-CSE-MsgGUID: QdGnT2UwQvy5Z6yi7ZfB0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="163070599"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 12:11:27 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 20 May 2025 12:11:26 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 20 May 2025 12:11:26 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 20 May 2025 12:11:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GytGtQGTMedDzuiwlgiZYQkKPCdzCDzXtXgoHZeAXyMgaCXJhGSB0KeTzyQEae8UV8rctBUtwB2wf1qvbqBJUkp7Fe2iZzYsu9JhQOKulxN/FCcfhK1qbfCqdOi5iCqm6hpUScSoU0v8CEEpMu1mDa4EeakITMRK5AopupXiBC77OmvTUruH88HiKaXCNvbRTXYOAOuCa/eRrspWrb3dotSJiLuVdu7UAEYwNBmtqDVr5k9lgA1nYQH/WLh9KnPyNIfVUiq4u312ysJtj8N4WxzX5Pi9+eUw349zHs0bH426Lns9lLy7tRwgsVuS7N/LFPNq/zol6ZXvcek0m2rb1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X7sm9f/wbQ3nO5nFB/ALpFvrYrMpDA+2J2P/P05i7TI=;
 b=LuwjrfYNajvqMw2ydJZ8TZClAkqo/Sg9b0IK8Ks7MifZ3Vr8pQpx9eLg8pBmFnFvHBp1d0YJBDRpzMuT5NiaYE6cZDZ5yf56eZThZSVXWLDcpbASKvTvtMfWC4eydPoBpXqRLRKQUtDd/YQyxh9jlc+ohM99jl7i+RrDHwTPzxKluZvaRWg5TSpq83yYHgo2dTnUqaB+DdsApBXnCGATWI8GcCYHYS4wYDRV48oHIMg57fJlZOtfdA7X0geqgROvdN5EaeCpQgwkxSJz/9l/dEgchKV3FhpBcFmbqSQuutAoZCBzWHlZMr/lepGkWqtS4/Er+P3oQkdFJUQH/78Miw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by LV3PR11MB8766.namprd11.prod.outlook.com (2603:10b6:408:212::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Tue, 20 May
 2025 19:11:23 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 19:11:23 +0000
Date: Tue, 20 May 2025 12:11:20 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>, Dan Williams
	<dan.j.williams@intel.com>
Subject: Re: [NDCTL PATCH v7 2/4] cxl: Enumerate major/minor of FWCTL char
 device
Message-ID: <aCzT2BE8Ckhhz_LK@aschofie-mobl2.lan>
References: <20250519200056.3901498-1-dave.jiang@intel.com>
 <20250519200056.3901498-3-dave.jiang@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250519200056.3901498-3-dave.jiang@intel.com>
X-ClientProxiedBy: BYAPR11CA0102.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::43) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|LV3PR11MB8766:EE_
X-MS-Office365-Filtering-Correlation-Id: e1390517-e416-430c-ce6c-08dd97d21c66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NFpYUXlsSDJ0TjkwSHVwelMyclJOZmY3WnM3bXlYL3JwakZEdjUwYUxUWXlC?=
 =?utf-8?B?cGNHVW1YNGM3Q1M0RVFSeFFTNVd4UkljbXIyM29DQXF2N0dIMitMMmRDd2hn?=
 =?utf-8?B?MzdOWmNNbmFuKzBWUnEwRkxNVFdDSzhkMG5FSXFpY0tMS0hUR0VOV0xZNG1G?=
 =?utf-8?B?emx5cjgra1NZTVpmVkcyNCsvbVV0MWlUL2s0RllSZWlMN1FNb21xQWx2TDBV?=
 =?utf-8?B?eU9wYlJnZG9qRzVJeWQ2dzh0dmwvNU5IcUtiVUhIcW5PWWFKTEIwQW5zREx4?=
 =?utf-8?B?NWE0eWRlMk9ZdS9ZWFZCZkd6bERpSWhBV1M4YW13ajdFUFlGeThNMTJOY2s4?=
 =?utf-8?B?dFVRWmVNa2hJdUpEc1ZBQ2pTZmlhV2EyMngwR2Rrd0ttV0Zpd2dtRG55bEJ4?=
 =?utf-8?B?TTVtOHNkQ1RyUlh6enc0djErZHNQRGZkbWdLd3o5dklHTE4zS295NVJ4U0NJ?=
 =?utf-8?B?Nnl0V2hpTm92OUxtRlBmN2N2WDNnZS9MRXBhSWc1clphUFNFK2R6T0dmMWs0?=
 =?utf-8?B?VW5DSENBUXM3cllBQXZMdC8yNGZDd3VPZXNpR0tGd2NTdDAxQmhVRVhhSU1H?=
 =?utf-8?B?b01XN25GbkRxZmNhVVJtZTVIQUl2VjVmZXVqN2dpd2pKWEVENmNFSUhHYUNy?=
 =?utf-8?B?eWl4L1dQdFk5VVFHNWFKemNZZ09OUzBRdU5UMHdUczRmeGpycDkyMzJ1b3Jz?=
 =?utf-8?B?UWNVZVc0dEJtV0ZhQ3lHSUJCa0VsUkZPd0FmZXV1TDBWOXdsTUF5SjRNRnJ0?=
 =?utf-8?B?UXpVZzB2aW9DMXhCZmk3OXhDSVFoNzFxNGhLSTUrR1Zyd2NYK2JhbkxvUXhx?=
 =?utf-8?B?TkRHUHJncjU2NkhKcEJYZ3AwaWVHdjFJWTlua0lDYnVOaDY3RktsT2cxdUhw?=
 =?utf-8?B?SHh0K1FyR1RXRVVGV1ZXcE5NMDQzUEFLN0trbndZVzRNZEh5bUZFV21ZQSt2?=
 =?utf-8?B?M3Q4UTh6bGN1ZDg3ZVVjbkYzOWJTcWFINUFvZUY0aU44WHIrZEFzcjNDdy91?=
 =?utf-8?B?SjI4MzZ4N05oZHB2RlNCSVRkcjFVRVYxRUREZlRoYTNObVdaTldVUzhCdGc0?=
 =?utf-8?B?b0hEUHhWdytsRDlnSFNpZnArdnRDS0NsdElnMEF6TFc2aWRnemp4TUhlSHY0?=
 =?utf-8?B?Ky9uMmFWV29RUDRYR0VLb1hNaFJuc01BWHg4aUtqT0dKY2ZoenVnV0I4cHps?=
 =?utf-8?B?TWZDZ1Y2azFsOWlvTHpkR0FKR0ZUZTZOVkdLeEVoT2JyV3R5TjltS2xzNUFH?=
 =?utf-8?B?em5rbGxrVXR1aHUzMDNadzNkYUVWbXV2b0RTTUV2U3BmZVVqR0lYZGlVSmxR?=
 =?utf-8?B?bDBGZ2pwU1Fadkd6VDBKcTczYmhFU3dzdk1HWC93b0JVRUdHc0hjbkdBM1VO?=
 =?utf-8?B?Q3hjNExVUzBNdEdzRjcrM3RZSlp1S2lZV2ZXNk5tdEh6a0E2eTFMcHNhVkNw?=
 =?utf-8?B?SDNtcTg1K0lvYTVhOWRJRXhKUzBjTmc1U3diTlNnUU5QMkd0eTJvZ20wZzha?=
 =?utf-8?B?a0MzUUdMS1VhM2I1YmZqSHBsUUpFT09tMTZ6SEhYUUJDU3NGSXpiREhCYlVh?=
 =?utf-8?B?MHo1VXRGaDJmTldZbmVjeHJFMzFlUmNiWktPREVPcUtrMElHTzlvajRYOGth?=
 =?utf-8?B?K1RXaXRJU2RYMjN0VmFoeHJEb1ZGMDV6ZEw2MEZNYW1may9sUFFkcHR1N2E3?=
 =?utf-8?B?MjIwMnp5TzJQdWtTczIwSkthZWd4R3doQkd0SGlTNkdVTzRUSFhsU1RzUnVQ?=
 =?utf-8?B?SFcwME0zNU5UUXlSQ3B6YVFiTGFlNFJ0dUY3Qjc0ZmxDUlMwUXBVcGE0Ui9q?=
 =?utf-8?B?eDlKNE42Kzk5OXZlV0lMeUpBV3RqeXBBT0hxK3RMY1Zuckw5OVYvdm5lTHhD?=
 =?utf-8?B?bWs0YXQ3OGM5dEdXVHR1WElWbGhSazdXYjh5bkd1UVZ1dTE0NFR3M09uTVhO?=
 =?utf-8?Q?LTgpOEFX434=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXkzcGJ1NDhDNXMrZ1hDZkd1S0J2b1paSW9RcnQ4dUJhYVJaYzR5Z0kyb0hP?=
 =?utf-8?B?K2hQcU01RVk4Q3BXMDcxaVZ0czVnV1ZaS1FIS0FHUURUd3BXelUzdUJTNmZE?=
 =?utf-8?B?ZVFSbHFlM1lUMzVkbnV4UWJqRmxHaUQxUzdubi9XV2lFR2d2c0tjMHdydWh4?=
 =?utf-8?B?dUFYOG9LS0dhZzdVU1BRd01zdjhQUWFrR3k0dldBNGV3bC9ndEg3RFhsZUF1?=
 =?utf-8?B?NjF4REg2cHJzQ2ZBRkNLeW54bUJWUFJsREgvN2x5SGVrUmU0YkVBV2F0c0wv?=
 =?utf-8?B?MHJYaXEweWw0M2xONmczZG9SQnZFZmJ2VGsrcHhPeEh6cmk4UW8yYjV2NTlZ?=
 =?utf-8?B?V3JMMlRpLzhUSlVtM3F0dW9XS3d0NEszYkdKcGpEZHlwL0MwVThTeGVuZFcv?=
 =?utf-8?B?Sk5sd0tRekl4QzY5OFZDWm4zVWpJZXgrS1NtdU9LQzM3RzhPWVhoMFltdmZ4?=
 =?utf-8?B?aUsrNHdYZC9IbFhnZ2VPd1VyL3R1aVpvVUpvaFlCZVdzTE9DT3B1OHFtaWxz?=
 =?utf-8?B?SXVaMHBtVkdCWndtQVYxUEhYOEpoSHVpbkVqQzZXTkVwdXhyaUtYcFdJU2Z1?=
 =?utf-8?B?amVhRkZGTThQYlA4MnpCNTZNSWhsVzE4MmpaRnBCUXN1RjBZTzZyNEJrN2R0?=
 =?utf-8?B?UHo1TkczVE5vc1RnR3lIcHUvb0JCVFBSc2hwWE9MN3RiNWQ3aGhrVjBzZDFW?=
 =?utf-8?B?eUM5WEJ2dDZXbkR5alQyblNxenRGMFQvSTJGRXF2WjQxTnJKVElxeVV6bmdh?=
 =?utf-8?B?cUREZDlXcHVyUGptdDh6ckh0MGtlVlhhVkNPMjd3ZmFqWXZJTkZmVlFxZUdn?=
 =?utf-8?B?alF4VDA5NWV0TlI3Vy9MMkM3YU5Pc3J5dlNQV1RxaDZkUkRha3JTOXNDR3J5?=
 =?utf-8?B?STBIVklUZ1Z0ZGZsamZxSm1KbFVNQWE0WXpHOGhJOEs4enptSmxYcnFhUFp4?=
 =?utf-8?B?eTNHd05UTUFpSVZvcXFWWFVkNlVFaWxvanBvY1FNTGVjaUNJbHBNRmx1dVRR?=
 =?utf-8?B?UEloOWhZMmVOcHVXM1U2Z0J3Skx0MWlneGFlWEZCUElWMGVNS0ZoMVN1eDMz?=
 =?utf-8?B?SU9lUVVqZjJyZFBWRHk4WTJWVEkzQjFSbGo2RGhKeTk3ejRzRzJtOFRSbTZv?=
 =?utf-8?B?c2pqVkpWaUdrRUdmRy9XZnVnQVhDQmlUM1crbGRveklGcGdSbVlJTVA5T1dI?=
 =?utf-8?B?UDd0Nk9kVnBnVTZiTjcvbXV5UTV5M2pEZ2N3T29sVUpzZEpQOEREc2FmNCtu?=
 =?utf-8?B?VzF6azMxTkxaMk9IbGRoTTNmRm1QSDR6bTRoaUlLS0Y4RGdQdVVwUngvNUFE?=
 =?utf-8?B?diszQVBKc0xaVUtCT2RpLzVyVnlTT2R6dWZHZHlNZ2JWS1RMOW4veXdod1Jn?=
 =?utf-8?B?ZUdKRjFhRUpiUUYvcHBvMTRJY1htZUZYdkNjWHpCeXJEajdOZlZnZngyWUpP?=
 =?utf-8?B?cUJzYkM5LzA2bFVHaVJKaGp0d0M0aytJMW1SWjc4cFBTUEEveXZnRXlKSXIr?=
 =?utf-8?B?NW1aZXFyWXd1Slh0elNEa1NoSEpSRzV6Tmk3N1ZVeXdnS3JUSXFKaXJGdUJx?=
 =?utf-8?B?V2tTRjNWdDNVSXNzaXladEVqZkNUejdUNDAxanNGRWtlNGZnYVlFRzVsN0pW?=
 =?utf-8?B?MUp4UndDZ1NwbStQRExvaGFER0hhNExwVWJ2bUtTZ08yK1EwSG84SDJtODll?=
 =?utf-8?B?QTZxYWt5WndUMmF1LzdGajI5Q0dkTXdGekFLbnlKK2VVZkx4T2tjY2t2L0Zq?=
 =?utf-8?B?dEJ1VTVYZ2F2UVJqNFZsYmFHNndYUnEyY1ZNNEpWN3N3ajJtZGMrN2dYM1FT?=
 =?utf-8?B?ZUlQcFB3dXFrazEvbEVlSWNmUHQzRjZwNTdyV0pSWGM2OUg4THgxNDREV3FJ?=
 =?utf-8?B?ZUJCcjR4Y3FNWTR1K05EQzVuQU5FdUdFQnBjbWpqZ1liWHlKRFVOdTVQR1h6?=
 =?utf-8?B?U0ZyUEgwdmJLTHpyK1Q3MlQ4Nmp4UHJIeDVIU2laUVVVREFZRStHUzhFZ0kx?=
 =?utf-8?B?WjR3QW5tTnhTR1ZIbzJtTVZ2QVgzbnNyalZOa2p1cmVGRFVZQmZrOGhSSDJS?=
 =?utf-8?B?cmRyNE54dHRnTGhOUjAxWmNLcmU5OEIxQVNGaHZyVDdseUwyb2Q0elY1REJH?=
 =?utf-8?B?OFVwamtXTmt4RGdlR05HWDN5RXFBaHV0QktaOStLc1RiTmtHd0UxOVBrdE1G?=
 =?utf-8?B?NkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e1390517-e416-430c-ce6c-08dd97d21c66
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 19:11:23.5571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DejRruGAUbEJmnsEOTXfKAdWDE0w+Hh7mcK5ucc9XUzJ8o2c5l8xHSBhSFc6D262DgFfmH5cHg0fQZb/IjYWpxLZ0+77sccJPn6dasWXk1A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8766
X-OriginatorOrg: intel.com

On Mon, May 19, 2025 at 01:00:52PM -0700, Dave Jiang wrote:
> Add major/minor discovery for the FWCTL character device that is associated
> with supprting CXL Features under 'struct cxl_fwctl'. A 'struct cxl_fwctl'
> may be installed under cxl_memdev if CXL Features are supported and FWCTL
> is enabled. Add libcxl API functions to retrieve the major and minor of the
> FWCTL character device.

with this:  meson configure -Dfwctl=disabled
getting this:

[119/252] Compiling C object cxl/lib/libcxl.so.1.0.8.p/libcxl.c.o
../cxl/lib/libcxl.c:1291:12: warning: ‘memdev_add_fwctl’ defined but not used [-Wunused-function]
 1291 | static int memdev_add_fwctl(struct cxl_memdev *memdev, const char *cxlmem_base)
      |            ^~~~~~~~~~~~~~~~


snip
