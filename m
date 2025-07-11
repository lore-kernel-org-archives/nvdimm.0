Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BA6226CF0
	for <nvdimm@lists.linux.dev>; Fri, 11 Jul 2025 23:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752278225; cv=fail; b=GlV1FipYDjJ2+rYrIpj89jyjH0U5q+5sZnI3a8x06V6ZeKx6P5zvKBTGPsViOgfUx9ZipGszTV6bkbW2yt7mMSvTGjfN8ggCI1rfatIVQZkeM7ezqiJnRD8ZU/pJe2CaUMFlMTprRGZTBEV+mmI+AqNoEVE+NyaKroH7MM1Owgg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752278225; c=relaxed/simple;
	bh=30UvTHGCgPrbPtrRjx8S1byZRkwKQmc+wGOgjUKvr30=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=rZhW4o3n2ldqP/ElaHTURAaZkB9KGUlqD87y3kusXc9f1Xm5LQXu3COBhklNeoSgykRQunskOrplS9gGzf8J5wZtqp5x+m8Cse7tXSWuOlrikwtnGJNKp1sdRzPjvQdrctkYNHNh4GqbH64448p22V0xEuYelWEGHiPGXop+neI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IDn6snQg; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IDn6snQg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752278222; x=1783814222;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=30UvTHGCgPrbPtrRjx8S1byZRkwKQmc+wGOgjUKvr30=;
  b=IDn6snQg1Cje0pslhI6o2e5SJamAglHEqAdaV9hxkMC0FOgWr02RRRji
   ajUkrvmu6tGmFjcklxwNX3jt4Wat7WyadKwTqXZdgHuOfjEtVOI52ofWu
   50Q6uK+Gm5zl6VBnGRVSh0I0tQUBYvYxCQgPSt11+ym4R3UD7DNgBUl3i
   LXcYuhyRZS6N90uoqwdRaKEX+e31PwZoCeXFraogfjwMOY3AeZKisAKXw
   M4E4zEsqxi8od9nGRr0b+ZgF2gSVde62YFPA9THgveJdeS/KyWRTOomsA
   oDgpWMGuKRrdvTCr9O3AanV78E53hJY0qMCLXBgjiHeVVe6EkCBQh47Az
   w==;
X-CSE-ConnectionGUID: 0JI53f+uSLC/084+GMeJAA==
X-CSE-MsgGUID: cvdJIPtNSGiyfpjen0JJGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54448786"
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="54448786"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:57:02 -0700
X-CSE-ConnectionGUID: Vqzo2T4qTuiGDTLM13Nzug==
X-CSE-MsgGUID: 1La8TSsmRpuyWBCrtMRAmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="162161783"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:57:00 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 11 Jul 2025 16:56:59 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 11 Jul 2025 16:56:59 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.60) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 11 Jul 2025 16:56:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ph+107PtCZD8g3eEW3cPpiieAz/V+dnhRGfoR+m87D9wliMOf3axXpXTItndcK4qRRVhWt376gHy+cYHZIXprWs3++qY8zrxypBE14E/YF10YPShUwQpCNuSCtYJJNs3PnKgGj/EVwCXcpyn+aijtsJFJ7XgnidSRL07UGa/vUvbVao3l0q2DUcGNXFhFe5/b4qYL+R+BsDzWL8blrtIV/Zm/WZb/DdjKwi++TYlRB70JnEc7QyYltj8etRLTuDUO/jaJ1mtDVmamFuFg6ZU1LV5ucX1BrDJv6q3NKX1Z/Ack0E8avOucTOf832Wcf+1ktI2wx3QZKHkHzhqayQlmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TJidBi4SBLqyvAFkjgaQLc/7BvD2FzDn5E+ubgKnApQ=;
 b=GES5Q0rExnJlq61Ms6C0lq1ObUQdlqwpG4g9F2XaWusnVg/ZrGDdnKsiOZPKjqpX1ko519kAEgZesnFqXutvV2a817O5+5cNgW5X3iIrYEApVwve42UNrFVEYeBACZQ67GQOkwHQ5Xn5TV+az1BJ9il7XdAeA5jLk6/rQ0ueo0kFzg7Ef6P7Q8eMLPODxZMLk0n6HNKdWMKQZJQlW6EVbyMSWOySY+kXQA4T67wySVTEzDsAZbvWylTupWzkV0Yq/9siVuRn7Wnwbep/I3RjCIymDMeT4c2J4HJKpdDIAXca3KIJk1vaREpUgPubK2pX2beneAeWlvbyJ/a7CIuBTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS7PR11MB6247.namprd11.prod.outlook.com (2603:10b6:8:98::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.29; Fri, 11 Jul
 2025 23:56:57 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.8901.024; Fri, 11 Jul 2025
 23:56:57 +0000
From: <dan.j.williams@intel.com>
Date: Fri, 11 Jul 2025 16:56:55 -0700
To: <marc.herbert@linux.intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <alison.schofield@intel.com>,
	<dan.j.williams@intel.com>
CC: Marc Herbert <marc.herbert@linux.intel.com>
Message-ID: <6871a4c78ae41_1d3d10030@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <20250611235256.3866724-2-marc.herbert@linux.intel.com>
References: <20250611235256.3866724-1-marc.herbert@linux.intel.com>
 <20250611235256.3866724-2-marc.herbert@linux.intel.com>
Subject: Re: [ndctl PATCH v3 1/2] test: move err() function at the top
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0042.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::17) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS7PR11MB6247:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ced3af6-9769-4f6b-cbef-08ddc0d69ea9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VlpJS1VJaFdDU0pzL2hMbTg4UldtSXhrUUhVUVdXVXdBZkh3aHRVOW1yeEZ3?=
 =?utf-8?B?MnE5SmZIN3VqZ1QzV3lWdWowS1VQUkw4RGRqZnZCdml6VkVQaGZZNGhCVFl1?=
 =?utf-8?B?THJ5T3UwM0RYbzZUaWR2c0EyVGNYMHFrU2VaM2lEN2hZb1RhMitQbTdGMzBM?=
 =?utf-8?B?Mjg0cnltak9WS2F0dlBsd0tZWjVFSVJNbTkreWRnQTdETWdYN2gwa1Vta3NE?=
 =?utf-8?B?ekt5RllVZjRMZFR1QVI1bnIwbnh5MFNQSlNqTW1tdjdycE41cklIVSswSDFv?=
 =?utf-8?B?OXNuSU5iMWJUNkJySHAyREkzRmVlQjJ2d25PMG5RdTRNNDZrU3NLU0lCc0NQ?=
 =?utf-8?B?bXNXNGxGYXNhcXpUTVZrelVJc3dmWnhYRkJLZjNXN0pSYTdJV1hPcnRiWHhN?=
 =?utf-8?B?Yk1yTHZvSXU4MmNWM3h3Rk1iMFJQWTgzR1B5SnpGNWVLemhqWWV0blBOSXIz?=
 =?utf-8?B?Y1R4blF2Y2F5SEpSTlYwazdXZnVuUE1yeWxMbEJBQ3E3ZHhraDM2TGtrN0Fr?=
 =?utf-8?B?dzZibkk1aUdaMzcxV0JaWDZVVVhjVXU0MHZtOUtXcXpTalBSK3lGTGRqMDh1?=
 =?utf-8?B?eDIvcjF2OEFEdk9HR3lFcU51VytKSUw0WTNiUFM3ejRLYy9TTVByY3k1eU8w?=
 =?utf-8?B?aVo4V0o5UU5weFNFR2xWZFU5YnRENXZlVjhMMXdxR3FscDhEdkkrUFcxczNj?=
 =?utf-8?B?S2lJQWhOdCtnbTB2RUdWU2VFdS9zNWxtbzZUZmlyMU1pRC85eWtYSERwYjF3?=
 =?utf-8?B?OVl0TG5MNzlyVUVrdzc3RERXM0xPZUJiZzhuTURIcGRWWGkvaEJDUU9OUXlZ?=
 =?utf-8?B?RWtFOERLamVxbFBwVTk5R3VWLy9yWXN2K0M0VkNsa2JrVC83aCtHRi9rdUZD?=
 =?utf-8?B?dmF2dnR4V3I2M1dUb3VuTlJic0tPMXRkN1VaMTFsNWxZeGhvRG15SXg4QkNF?=
 =?utf-8?B?VUxLOWkzYjdDZE9keVF4REUzUGNkRmxRZHEzblAweDM4dENOWUZWSktKNDdN?=
 =?utf-8?B?MjRCcVdiTkZ5NlpGdHVtZWFFVnM4TjNiNnJ5VVl4TG5TTFNzL3cyLzVuUGE2?=
 =?utf-8?B?R0NGTjR1TVo4VXlYWW5jZFRWTERWWlFCMGk5MHNWbjV5UHJYK3RGODM1bDlu?=
 =?utf-8?B?TVFxWXFGOHV1OTNaRk85dUpOamd0SzFaMVYrb05PZVdLdktCQ2taR2FwVkZK?=
 =?utf-8?B?a2swWDJsaUVOVS94b0J6ZGNMRzRGT1NOUDRUY211YzB2VktJWWV5REtxUXpp?=
 =?utf-8?B?MDlYSmRuWFBmWktWTFpuRUI3aTZ0MUIvaXdvdGZGOE8wR2ZkQ1FJNDcxM205?=
 =?utf-8?B?QjNSSEdmUURIcUR3Qjh5aHJrR1phcmxBOTBOMDFHWStVTkh2YTN1YjNVNjZ1?=
 =?utf-8?B?WDMwMEE2a2xwMWNpcE1KZmJMRW1IalkxQjBWeUJ4b2dJQmRnbnhQSEpJSGQ0?=
 =?utf-8?B?LzRGNnRSZDFiOXNKMHZldjdrWnh4a1Q2Q0UrQm9rWW03ZVVKNGpqeE1RZXFn?=
 =?utf-8?B?NjhGUkhvRTl2TXhmMmIzbGRGOTl4L0V4ajFRSWVwRndac0F6WFVUUW1vOS95?=
 =?utf-8?B?TXZTY0s0YnI4KzM0Z0QxcU5WWStMalJEdDNqSUtIN3d5dVFjSERYWTJPcmNh?=
 =?utf-8?B?bmpqWUpmVk5vcmkrMTdBRzFpR0Nnd0FyczJ3cE1rWXZMN3gya28rcVlCNTBy?=
 =?utf-8?B?NnFPMVR0aitzUmhVRWlFL3BtVEM1YjJFYkRyOThSajNNTUNOeFh6Yi96cnR6?=
 =?utf-8?B?eVJvOW5Bb3E3NURTdGc3Vmpvdmdtdk9VNTZZc2UrbHpEOWlQSWdkM0NoOTBy?=
 =?utf-8?B?aWQ1RjEybktCdEE3ODhjdzRPMStPUXU4aU5OaExwZkNJanNLVlZvRUQxZk1v?=
 =?utf-8?B?cmd5cm0xVGNJc0lCenpwcVlmdnBMTFl2cUs3RmxUSTdJbEN2VTVCM0FKejhu?=
 =?utf-8?Q?PchjhZ4mNr4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDJET3hiSGtHTytpYjRVb1RFSks1TWQrNGlFOHVCSTdJUEFoUW9NdU4valE5?=
 =?utf-8?B?YWF4cDlzN3M2VmZJbDM1SFVUREkyLzJyWWJqeGNucnp5aWRiZVMzRURjb2dS?=
 =?utf-8?B?dDNwaEl6YXE0SWd3azZ6aFVkUTdQL2trbEUzWFM3Tzc0MWE4KzY2VWFDV1d3?=
 =?utf-8?B?NS9RN3E2ZlV0VFdCVmsxVXMxVnJoUk1uU3FKU1g0eTNGM3paclhUb0lZTGRi?=
 =?utf-8?B?c0I1RldzV3ZxbDBTcmhGaHV4VVlFQTJsMGp0Q3J0aHdPb0hocEQ4S1FJRzZh?=
 =?utf-8?B?bUMybXk3M1ZOT1lkQ1QzMlRrRGtPdHFqZFhqSGlYaHJQOFZyU0FSdzgwV2Z4?=
 =?utf-8?B?Ni8rcW1ha2JHbm1vRlNvRUQ5RTZOY3dXYXF5ZGl1dEFwclV6a1ZDRmFBVDVx?=
 =?utf-8?B?cmJvcFlTdVUrTXQ2K2pFN3dYQXZoczNZcEYyT0dUVkkyOWNtZEZNenlXcWZX?=
 =?utf-8?B?YkNUeGlHQXZZRXIyVlpWQ2VaNHNrYTVFSzhROXZraDB2MUN4UUxDaTYyUGZ2?=
 =?utf-8?B?bTJaSkJhSUE3SjdzbUxPVWhWYTZIOExYeGNHaVdqSDNnZm03S2JPdzNyZG5Q?=
 =?utf-8?B?dXhDWWRvQm9nbm5uWWJaQ253VGFLcld5Mnh2ZVYwZHBtMGdtbnc3dDBzMmRK?=
 =?utf-8?B?OUNKdW8wUU50T2JKTmdvUE5QYVRDMGJidy9tbE85Tnl0OTdUS2lhZjZlZWJ4?=
 =?utf-8?B?U2FBUVU0RVVEUDJ0U2tucm15UUViWVkzaExWcTB1Z0NvdEN2dU9XYWhVSXZN?=
 =?utf-8?B?Q3JUQVFYYmJtOEdqdFR1THBHL0tOOVBmZ0J4YlA5TTlka29VWTh4S0ZGYm9Q?=
 =?utf-8?B?REZENUZnY3NXb04xbEorS243TXJsNlZDSUhzRUFBYWdHV1ZDbjZ2QzNidWhP?=
 =?utf-8?B?TzNqeENjWC9wcFBSQTk2YzgzNUJvVHVzVmhTSlFhRFJQMkpyOGJ0Um5zenUy?=
 =?utf-8?B?K1FSTnQ0WG4xV3dtQTBkbURydkZTYkIyS0traDhjR3NZQ2dLZmlHYUk5a1FX?=
 =?utf-8?B?b3h6UGw5NjFMWHJYUllORzd4WWs3SExLejBQTlE3VXMyRG1aVGFZRVgzeG4r?=
 =?utf-8?B?dFdQL0VmUlk5cGxYcTJlRVdXNGNFOEVtbXJzeFoxTEE2a0EreUthWVNEQ08w?=
 =?utf-8?B?Y1J0aDFySm55ZGpSS2JkSU94cXYvVnk3ZWZEK2QxanRMa3ZqTzltZzhxc0Fa?=
 =?utf-8?B?VUhGRk5zZUdmaURaTk9OT3h6WlpTZ2Q2Z0pmcEVBWGVtMlVlczI1YlpmcElr?=
 =?utf-8?B?dGdEQVFiQ0V6MGlCY2w2M0RaSTJCSDJoVVBJc3R4c1VvRFZjcDIxKzVwdWJx?=
 =?utf-8?B?WDdQVmJXZFN2UitMczRyWEZiSHAvYmFuZnhrT1hNMktTVUFlOGJyZWdvUHA1?=
 =?utf-8?B?MS92RHNDa3JpZFlTQWJjRDFVQVR2RVF3S3BBT2RhbGJlWVp3ZWltMEFlUHdQ?=
 =?utf-8?B?MC9nK1kwd2lFSXRqQzE4NXRpamtYajRtOUZsS1l1L3hRNjN0Mk15S2tWQXVJ?=
 =?utf-8?B?cDFNdko5NG4zM3AxWE9od1djNUduamxFY0E3U3dZMjNwRGl4SzJQaTZjOXpO?=
 =?utf-8?B?Vm9kU1dGRy8zaWRhWEJuOWkvR0JEejJvYlpSYTdhRTBlWlRYcmdUcHU4VUNP?=
 =?utf-8?B?d1VPa29DMWZ4OWtmY0kyM0RGWk1qR2FYcUJldjhXd2UvOS9qU0JiRkNteWZy?=
 =?utf-8?B?ZzNGZ3VOb3EvMFdBWjZyRmhsZ2cwRWc3c3ZHTVYxYTFYL25jSy9sMVZ4Umth?=
 =?utf-8?B?RVQzVWg0NlI3YXNSMnRNbE03a2tHUFp2OVBNTkhhWFdHbnNtZ0c5TjFxNlhm?=
 =?utf-8?B?ZjhGSXNBWmd2Y3pzNWg4UTBYWCthTEZoQUZZdW5VbGNzdDJJM2dIRFdkT0xN?=
 =?utf-8?B?V3QxMXdocGY5bmF0bHdjS2NLMkhiSFlDSXR4Q1dTVXBQQ0NPTDZ4RDRxY2ts?=
 =?utf-8?B?czdZNkw4S2tWVWRvTDNhYjg1eUw4THgwUHUxbi9KLzIzYUZFb0piZGVPQlk4?=
 =?utf-8?B?YnVzK2dsZkhRU3lXYVR4enFKM1RIZGZpeDZXWTBtRHRzTzZ4NlUrRTJ6b3hs?=
 =?utf-8?B?bkVoNy9sNXpVZ1VXY2F1QytERkpsSHJ3KzIzb3RWaTJ5TlVmODUzSVRUaGJE?=
 =?utf-8?B?cDdzM2xnWFdJVmRpb0ljQnErTlFmTmd0Q3B5T2hjdVlrb05yS1BnM21qUC9F?=
 =?utf-8?B?VWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ced3af6-9769-4f6b-cbef-08ddc0d69ea9
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 23:56:57.6285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lh0NRabMF5OdG+WrdUzocrmAWsbnqJPyLeSFaeS8lpN40kJ0mMm0OYYfZ9T6b9fl9ajijQnI73c3n+qH51+UNN41tR0NEOa2J6TCS12YGvc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6247
X-OriginatorOrg: intel.com

marc.herbert@ wrote:
> From: Marc Herbert <marc.herbert@linux.intel.com>
> 
> move err() function at the top so we can fail early. err() does not have
> any dependency so it can be first.
> 
> Signed-off-by: Marc Herbert <marc.herbert@linux.intel.com>
> ---
>  test/common | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)

Looks ok to me

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
