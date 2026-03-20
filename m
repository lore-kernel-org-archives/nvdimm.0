Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2131A682F
	for <nvdimm@lists.linux.dev>; Fri, 20 Mar 2026 02:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773973306; cv=fail; b=JMcyagI4QltjzI76LqhqlQ897vfXFZ3Y3cOV+vRlwduZUvlw0oyuA4fQpzjF6wnQYhtbqw2ne4Za1xL7JvXWFaqOtbyjsjH7S2+MffPmprKI+2odL1Ead3Am2p27Iuk+HSJMILL9UQdWJZ0QHOe2t7YNTuTz1+8usNYWJcay03w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773973306; c=relaxed/simple;
	bh=Um3uDnif9yG50n44ri8FntXTlKlDadsYTO6mdg0DeX4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bjtqyhNdIyClL+i3DkixOwoNASr2QHpzZ16Cdkd7WxCUVQ+8ynBcvmsaS8qYLVjzTkUzInuFHs/RvD2VTh58POBPw7B5PqExOTLEKORiKIu+NTtMuDBUa4DQgfCN5g6yigiv0ENTtu8H6/s2tLSnorGw2RxolQ5rZZfMGP/xe10=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hijYtYkP; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hijYtYkP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773973304; x=1805509304;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Um3uDnif9yG50n44ri8FntXTlKlDadsYTO6mdg0DeX4=;
  b=hijYtYkPRQG1v+FObssaKxjnHSNWTVBH5gdtgjNVjdefWLDBuUOVAVl9
   FXr72SpO1YtNFaaT+2stBmPHxduaFdsG4bB5cEPhD4x5qKUP+ILnLlr3C
   fUBufiJQnTqXQRSVO4OID4fBI4pKbkwStBW04Ih9PAL6jOIsnKHS9Okla
   Ium8UR+LRx52PU4fsfU4fZBCLM7ze5KqQx20axArI5DFlnLsgsGuj76ZO
   IdZK/aNMvPtrOYm4wSqll4eHZSy+GNaeHHcs+3zGIc74zcKsPUonzFiVE
   kuCphu1fGlFj03vZMbNWg+ZErn/mSo9iJC46c5s0EW6liX8R0uwAK2I+/
   g==;
X-CSE-ConnectionGUID: E6bl2jMESrekGrugq2Q46Q==
X-CSE-MsgGUID: UgwiB0C0SQKgluoYxCF3MA==
X-IronPort-AV: E=McAfee;i="6800,10657,11734"; a="75176853"
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="75176853"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 19:21:37 -0700
X-CSE-ConnectionGUID: SppE+qwpS+C2I8MptqRQxQ==
X-CSE-MsgGUID: LMtV39u+RCu06s4salTEqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="220083222"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 19:21:37 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 19 Mar 2026 19:21:36 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 19 Mar 2026 19:21:36 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.31) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 19 Mar 2026 19:21:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jzmQhvUi0ydAWMwnQRPwf8huV2YnKrKdRE1EAgDiIoCbueMLfA3KhMiaRUNNb+7SYJTdrx2avSErNMwNRd26iXkH7Jx+TmyScDHS9d8NgiCBKMzhBH8jrx+h8FOZJXL5DQtHbnSFITGPnQRK4uuieuDG3eIJBqY5b2mbkmZwRqKN6hWRaFugIjGrutjP8cFqZF3XOW0tabmcjjjrrgi3g76zD54aqXfZtbGPh6R0Ka2YEkpcyT5+5gYlZgcNBfWAqdI6jXSzyxrCFqarg24qIfk5uXh6C4uPIXgSWU3y16snlr/2it5qGeIOB/hxQXmKN/xUR8JIykuYJSpZ8bvJQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mJHckNW9oBMY8GzVBj95flsdVoOstLGzHQG2uv4zHIo=;
 b=JMNd4d7rcWI5wEo/MljZi95+1Sp/UTdwZh157LIP2Ana261MEWrVu5ZBaRoxlrmwzM1nLXblg1JdyCVr9CN9p38C0NJ3bZrAxbrjLilo3PYINJBoaeNbMB+Jb34CDgj6uRat07+vepzDNOXUk93YrSLv0p97Vr3chSRtNWxnobw8HhNh0Mtd1De2E8pLu5N4xsOjSIm/+4ZwJ27UHeGJg9bY4tRweC3sFKbNxG7XN3l1gottDWK2vUL8JYyt5ahtdo+W38JUHaBvDhSRO33vngCTP5lwnpmQ16VjEB+Xe8BVYtq1SQQxbtX709eMyzN2swS2A256+RMYoI8VuKz0kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by MN0PR11MB6009.namprd11.prod.outlook.com (2603:10b6:208:370::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Fri, 20 Mar
 2026 02:21:32 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::3979:c00f:fdca:b895]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::3979:c00f:fdca:b895%4]) with mapi id 15.20.9723.018; Fri, 20 Mar 2026
 02:21:32 +0000
Date: Thu, 19 Mar 2026 19:21:29 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <cp0613@linux.alibaba.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v2] ndctl: Fix missing key_type parameter in
 ndctl_dimm_remove_key stub
Message-ID: <abyvKfGRDOM02BUN@aschofie-mobl2.lan>
References: <20260319015149.13719-1-cp0613@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260319015149.13719-1-cp0613@linux.alibaba.com>
X-ClientProxiedBy: SJ0PR03CA0239.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::34) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|MN0PR11MB6009:EE_
X-MS-Office365-Filtering-Correlation-Id: c955aacc-97d3-45b2-0619-08de862766bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|56012099003|22082099003|18002099003|7053199007;
X-Microsoft-Antispam-Message-Info: 2CoGKjvMdFw5xmDhyXZkTvVmpoMKp++GehlRE/gw45m3E5IeR4ZFQqrQm+52zShIoPv6QgrxoSyhReSebraFeO538Q/T+0lDSvY+v2VS3l7Y1N5GdpUDIXhiAfW7KuSC2eQCtTOhziM/tlpVfTCx1d8ILqoG6sMh8zuup0PWe8nSjDVn3qlJEUSFZPvxxiqXFKq6deJdAE9cUEHI7oJyq8OPxDv18fbpnuRs28lbUwHnqKj+4HqciVlKQ8gsG3ux9eicHMl/SVkyo3+V14Gf+Lx/4+HJFa+70jGnDeCFDceroHMb4Z4c8BYQ3Ox/we31PmD0aKOx0pY5TW1CurzsNhUZuEIMGuJnda9FX2WuYAa8Jrj9JpqzN0EPDZ8eDL4nLLulDOk1cHMlEuZ5PTo91gC44Z8XdoAIn7f80NP0iyXCd1wkvQa+4Sd46aAEHDXhp/EvumNfPqWuGY9Y2I4EGwd1oZ2efDxjvYIAksRlJ009Qiy94piMHWLXrFYsyRPhmN9zmWLLsoc5TqHgxrOIeyRXVLvK91DET/t3BWtPyvV58VxAe0MPv6QDyluQSKlHX99MxL78lscamSN21WT73jOgfEYgj4jO5o05cKfaeO5IdI9/1JbXMX2nTm1rbyYDAwDeJWpZTnEhbBrn6OQDiyA2fcLlaEKAF37vi2I7m+jjX7iOGBYdEWc8XPAVs4Nb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(56012099003)(22082099003)(18002099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M1hPK1pzRHI5Tkxkd1VLTTZUSzI5M3hGTENnc1lyUkh4OXl5SVJEbXRRSy9v?=
 =?utf-8?B?SzV3SXI1cFhsbHFOOFVMRHRhZjlUT3U5UmlaTTJTbW9zWisrYVFNcHdpTkt1?=
 =?utf-8?B?Yzl5czlocWpsSCs2dWtKVGFOendqUStUNXd5UzZKejk4d0FwRTVSWFhjZ0JP?=
 =?utf-8?B?dk0vamI1M0lGb0NoYk9BUVVOaUJoY3FnZENKalRvaUJNUEJTOWxuWTBoem9Z?=
 =?utf-8?B?N2V6Y094VjJRcndyRW9pQjgwa3FkQmZKby8xTG9vNTdieFFYbHkvWVlZQURa?=
 =?utf-8?B?K08zZUQ2ejFuSlREVy82Q1UrOTN6NURtcFI5dXhQdWk0RVpOeFVud28xbHUv?=
 =?utf-8?B?NnpQSXU0SHJsYmxNU09vTXBpM01ta2xlb1l5ajl2TDVPbGpJUThuMVV4TUJh?=
 =?utf-8?B?U0JtUUN1RGtLa1IwRTZ3aGhtRHBEUVRlT0dNeWdUclRTNzRkVFU0cElCd3Fh?=
 =?utf-8?B?WnAxZFpjUER2akhKYTRtcC9rZUh3SC90VjBFWHJGK08zRWU5amNJUU5Jck9p?=
 =?utf-8?B?dWRhUy94MDk4Um9qTGNiL3BKcmdSa0FReTZ3dkZodUxxcUZyS3NOZno5S1pr?=
 =?utf-8?B?bldnZnFFekZQV1BPZ1loTHVnbStsRndMaFNudDRmaStxYmlyNUJCbDE3OTNH?=
 =?utf-8?B?NVhJUWc1VmovQlFLaXBNTktncDI1TkhkWHlwMlJ2ME1qRGRrL1NycHJUbHI4?=
 =?utf-8?B?eXNTZlJCRkU4ckJWaS94RzY3cU0rUzNvRm5UL3VJMGc4OXl4M1AvQzI1U0da?=
 =?utf-8?B?N1hIN2l4ZWN0QUpXMHJDVVpqUGE2SURCLzNWdjYrZnBJMU55WkZmTXJKMmtY?=
 =?utf-8?B?WXVKb0RmckczWThiK0oycEw0c2hSR24wL0s0NmwvL25uWlhKSjNZd25rWjB2?=
 =?utf-8?B?d1lIb1UvNmlvUjFsU2R6Q0ZXRzYycEZ2djlwU0VkbWRleDRROCtFMlpVd0Nz?=
 =?utf-8?B?TDU3VnBXQjdBZTg1WkNnTmFONEdodVF2dFZFTGlBazRlNkYyR2RlWU1KNlBV?=
 =?utf-8?B?NkxJOFVlcFZVMFFDWkJGSVZ5bkpsK3RacG5IdzJjQ2pjMk5FZUkyTEZ0ZkRq?=
 =?utf-8?B?TlZKbDhDdkVXREdWSTl6czZXZEtmUXVQNVlpSEwwVVJsWkM5VG1Gd0xWRGhz?=
 =?utf-8?B?d00xWmF1dExWUHlmbWdHZ1AvM2xpNkJNdlM0YzJLcERlV1VYbkdCM2lTQUdk?=
 =?utf-8?B?WFFEV3RVTWJUazZTQU5lb0NRTUF1ZUhramJNZ2dhQ0JhaFM2VDh0Z1BUQTdx?=
 =?utf-8?B?aDdhMlBSbU1vVlM4dW9xc3ErM3FRcFIyN0UzQ2ZscHFRdkIyZS9LU0ovNG4r?=
 =?utf-8?B?WjZEZHdFNEhvOE15ZXozeGtvcVR4TllnejNTWkFHUnZ4bE9VU3dYaHZtL3U4?=
 =?utf-8?B?d0oxQ3BPRlZXb2ZDVmRHSllKR0MwcGFqb3hqNktNZ0dsOC9odE9tZTBWbkh5?=
 =?utf-8?B?VmNVMFJYVG9TdzRLU3U1SFhjaDkvUkxmOXhsYXovcHI4dlN3dHQyUXRDc3Z5?=
 =?utf-8?B?K2JIdUxoYkpEMmJTY3pjM1E4OG9vUEo0bGJmOEZlRG10UE5PbzZPbFlxS2px?=
 =?utf-8?B?YWJ1MHpnK1hhYlR6Y3ZNbU04alFwb2gvVmdwRnFzTVlJVk9Qbm9rNUVOcVpS?=
 =?utf-8?B?MkFuQVpVczFHK0dHRUlCL0o1RkpMM04xZGNpTEJBbm1lTmJEUUJ2ZmdMMjMx?=
 =?utf-8?B?ZmQzUEdpcVl2RnJRVlBJZDFiS3RyZU9LSlJLQy9LUm43QjZ0QzBhODIwWGpz?=
 =?utf-8?B?bU43Z08yTWlLSnMwWXE4d1BYanJaaUt3b2ZiYjdPTVBpSDdpWlhPV1I3MUhO?=
 =?utf-8?B?Skg0cnhrZnNEalR4UkJJTG5SeE5ua3pOWnJZaGhWOWV4ZjloWmFCVXQzK0Ja?=
 =?utf-8?B?SkU4eHVlU0tiMVJxL2YzaWlaM1pyVXRCNHE3Q2czN3VsOXN1anJRalBkK1RP?=
 =?utf-8?B?SU1iMURQZmlCSEh3RGtFVlVIbElHVFpXUU0yRHFGaVhvY2J3ZDBMenA4RlVZ?=
 =?utf-8?B?VVZSVWtpeTc2Q2ZvN1dhRzBnL0N6TFhHVC8vaDRHb1Y1ZkNGMmowaTNPL01O?=
 =?utf-8?B?OStQdG9mWkUvNE80dGlwbzVEcWd4R0R4bXZZT0R5azN0d0FqQUlDbEtiQk9r?=
 =?utf-8?B?Z0V6Nk1remxheERSR2cvcDYxbzJqU2dSbDBhUTYwSUoyeHZKUFIzWnFXdkFz?=
 =?utf-8?B?R1F0b2llS29VZWx0K3BWNWFzSVdxYXVWOEhVcXNWRFRNQU81Y09Id0dLVFNH?=
 =?utf-8?B?TWZYS2xuLzJ4TUR0bXpDOUMrWlZRQmxmRnNxZUkvYlZxQzg4NWJRQTV3M3lr?=
 =?utf-8?B?SkdDdmlNT3Nod29iTlRQdi92ZUd3K2RFaWxlcDZtUXRTT3IzLyt0bzFzNU1x?=
 =?utf-8?Q?cQ/uMmtG5PWgddhg=3D?=
X-Exchange-RoutingPolicyChecked: wY5mHhzJ0nvqyn2vJCHd+o+1CPmj74Yg+uvOzF46reMSfc+jj6VZWzew6BXmU6n/yAaarH3stuymbfolDVEEP4xeHIcsJ1qGm/z1X8/hMJqE0LIsnXwVty1/GGy4IqxzTsXbNvUgDK3vJMxGpNv5nc1LM8cgn2uEm19CxojJt8vMq3qcYzfYLCAU7js4AWJhxUafcGfA61eXUhUIWFcVvV8YidVtCsaQam8SOLTKmdEhadFzj1M+0mGCehaYuwVwO3BlKeCoL5+cFB8eQH0YdCA3I0XWZxH6kL5IL9oa+qG6D8xN17UefJPe0Vb3y+oU0r9igTApsfd5ZSVGuuQD7Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: c955aacc-97d3-45b2-0619-08de862766bc
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 02:21:32.0179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gVpohipY3JpGlm/kbGPnxqKraezU1Upt/z+Kg+q7MyQsgKNeVwYiklSpSdT4bUrPIlCVSdxlaasQpCqRe3WLjdv4ToM5agPDqNi801qSzCk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6009
X-OriginatorOrg: intel.com

On Thu, Mar 19, 2026 at 09:51:49AM +0800, cp0613@linux.alibaba.com wrote:
> From: Chen Pei <cp0613@linux.alibaba.com>
> 
> When keyutils is disabled, the following compilation error occurs:
> 
>   ../ndctl/dimm.c: In function ‘action_remove_passphrase’:
>   ../ndctl/dimm.c:1030:16: error: too many arguments to function ‘ndctl_dimm_remove_key’
>    1030 |         return ndctl_dimm_remove_key(dimm, param.master_pass ? ND_MASTER_KEY :
>         |                ^~~~~~~~~~~~~~~~~~~~~
>   In file included from ../ndctl/dimm.c:25:
>   ../ndctl/keys.h:51:19: note: declared here
>      51 | static inline int ndctl_dimm_remove_key(struct ndctl_dimm *dimm)
>         |                   ^~~~~~~~~~~~~~~~~~~~~
> 
> This patch fixes the issue by adding the missing key_type parameter to
> the stub declaration of ndctl_dimm_remove_key in keys.h, ensuring the
> function signature matches its usage.
> 
> Fixes: a79375a9b0cd ("ndctl: Add  master-passphrase removal support")
> 
> Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>

Applied https://github.com/pmem/ndctl/commits/pending/
Thanks!

