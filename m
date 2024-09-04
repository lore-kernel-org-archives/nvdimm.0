Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154DA1E00AE;
	Wed,  4 Sep 2024 17:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725472441; cv=fail; b=kyWKeVhJMyC49Nl1MuWNE3lGFIyQl+n7oPDrai5HtFtqjRF/RH9uAuABQJSFkfl9at905IahXnoVjcy+kGWNrFRp1bSoF3h190F4n7W7j9mNdH2WNjfPxA+f8KDKl2P9UsXVcfdf2erh2VPELI3iVXgs49MnB8eEpWQrTORufWk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725472441; c=relaxed/simple;
	bh=tE2Ay/6P2WxICF+joI8865g5WurcFnYpM/eGIKY9TfM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mFY6GfoLyYdEmVDZdc+g8+XKhkKhHdqjkdc+D9SeeZexc4uKwHgm+S97+AHLKeFvQkWk55q8dAoQNkEZ6G9FXdzdITZmo7Ty8gHRRBWdOgtxsWvh96g1zKIVJwYVbk+PL/zKu+rzPfVCf9hOAdk+2Brs2KeS/Mw5X1ee4PK2z1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UNdwU3mA; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UNdwU3mA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725472441; x=1757008441;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=tE2Ay/6P2WxICF+joI8865g5WurcFnYpM/eGIKY9TfM=;
  b=UNdwU3mASiKXCsArpq7k5Kzj1Uy2610XrSrUu7GK5tJ8/luFyp8j/26n
   /xheF/ZZPlmYRrJCRHFEtSwAb9cnNzJn0wY/prkzzYKM6crETgX/uUBig
   3B2rtrmdh2nkQkLtZ05VcezBopOTf4Jpo2HJnlAOoktCGRYmHtcrnaYWA
   0puwI2BuOKY82f0nXgQvv/asEzM319ic+AAhGm0tWNIAFRoX3HgVOXV/9
   cOefo1/6qrIg7ZxxfCwva+f25Vjhnn/GFzo35j3yZTXFfsdqzkBqKX7ga
   1oi8i2HZcKbWxWjMKvp5WbaxQ/QFP4UvYQeXJsKX1mc8MgPicLGlnv7nH
   Q==;
X-CSE-ConnectionGUID: 6w4coy+qT9ieiN4FdPP9Lw==
X-CSE-MsgGUID: OMaiOoz0SkyUe6RJK2i2LA==
X-IronPort-AV: E=McAfee;i="6700,10204,11185"; a="35311592"
X-IronPort-AV: E=Sophos;i="6.10,202,1719903600"; 
   d="scan'208";a="35311592"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2024 10:54:00 -0700
X-CSE-ConnectionGUID: J5nxRWV8RryvIhK8Bn1syg==
X-CSE-MsgGUID: 4MbvWWxqR+OzYQH1TCFNKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,202,1719903600"; 
   d="scan'208";a="64996687"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Sep 2024 10:53:59 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 4 Sep 2024 10:53:58 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 4 Sep 2024 10:53:58 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.47) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 4 Sep 2024 10:53:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gfhe+UgAMQothV0qq/hb/1+R8reiQj9+xBf+uv5jdFwgFEhpW0DCY8U6nCdsbBr6rtkm/bc5UikVj0F/6lr9FqSaLyyxvbspfn42Rekcu5Pl8TVOq+xfPRK8+uAwu8bPYLfOOiGgSWIFx9r7pBsxG1Op52P6JVnLMxIjohd/Q9pKgJBHcpA+nOoP76GUvwaDXIeSXIxWATXimaOLkarQNZ5UCv7uDBhu5BSJvd3XGgUAowLrlBhcC4KqqtltjESDN7CC/rRHv5XSfLgHXCj+Yjf7gjvXf/y7oOc351rYWs/Z5vtRQVISUGZzFJ7Gl5TVvYcQKqjL/L1YbU049UIa0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mNsTQPNSKai79SkpZq6/GRvBaWbEJ62g65NwHjOR2C0=;
 b=NNxSholT7sDWYyWjaW3Otdi77UWMyEORJUAYhwOCIUUs6rQ0gbhydZD4UYPRozHLKePYw0at9veZF3tF8cinc0C/DCmbw96ppR201Wo/kp8thi3z9qRlZlacYtFGWY1wj0O6PW84NLY2Bwdzggl8spfu7GQyPDCUNcIZvhLtmsTgeM3b7z8muyjT+Mu0tB0j2Hm2ylF3QALsufgdORtPOgHsax7ntU2/Gph1xUlfpo6I+8Ki8GSClzzVS4oVVjD46ol9kFoR6QkhVFavYkoNC6uCZCAnY+JkceFDA3nnIBOpYSjFzjL3DxmQFcYI8rchk7ENCC+tu2EvpFGNjlEUvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by DM4PR11MB8227.namprd11.prod.outlook.com (2603:10b6:8:184::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Wed, 4 Sep
 2024 17:53:56 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%6]) with mapi id 15.20.7918.024; Wed, 4 Sep 2024
 17:53:56 +0000
Date: Wed, 4 Sep 2024 12:53:50 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Philip Chen <philipchen@chromium.org>, Pankaj Gupta
	<pankaj.gupta.linux@gmail.com>, Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
CC: <virtualization@lists.linux.dev>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] virtio_pmem: Add freeze/restore callbacks
Message-ID: <66d89eaeb0a4b_1e9158294e1@iweiny-mobl.notmuch>
References: <20240815004617.2325269-1-philipchen@chromium.org>
 <CA+cxXhneUKWr+VGOjmOtWERA53WGcubjWBuFbVBBuJhNhSoBcQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+cxXhneUKWr+VGOjmOtWERA53WGcubjWBuFbVBBuJhNhSoBcQ@mail.gmail.com>
X-ClientProxiedBy: MW4PR03CA0145.namprd03.prod.outlook.com
 (2603:10b6:303:8c::30) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|DM4PR11MB8227:EE_
X-MS-Office365-Filtering-Correlation-Id: a496a43f-a760-41d4-abfb-08dccd0a8bbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WnV1R0ZyTjhZRHJDaFlmTVB4TVhKMVhMSDIwdWxEUUJGOEZLc2tPbGJ4a2Z5?=
 =?utf-8?B?VVJhMVNGUTVnaEVDR2pSbzYveUxvSTE4R0pMcUY5VXViWkt6azBlMEo5SUNm?=
 =?utf-8?B?UkJVcUpmRUJpMUo3eVNlTVkvcFo3VmcrMEZsMyszQk12aUtRR0p2bFZxeEM5?=
 =?utf-8?B?dUlNNnh2MmdVaWlRcWlUQm1LWTZjS05TMDBka25VRS9oMHdpL0ttM29LRnZC?=
 =?utf-8?B?NExzd1VESVAwSnpiVHRRei93THorTjczVkFlUWJpb1JVOWpvaFo4WVRHaklx?=
 =?utf-8?B?MEhvNlBSemY4WnNCRUVxcyt2MmorTktCZjFoMjFad3Zub1laaDZYV2c2U2xs?=
 =?utf-8?B?L3hGWWRhMWpaVElsUjdOdU1tUXUrajAxcncxb3Bxa1pKSTV6Q2IyTWJwTi9j?=
 =?utf-8?B?SkJ0NHdsYThBcEQ2aGsvdEQ5QUZjd0Z3dytUVzFkTTRrUzRpSzhGYnVRV3dI?=
 =?utf-8?B?Z1ZDK3RhWm5FU01vOEJUcGRBUnZIUVU2aVRJeTBxQ2VvaW1abXlJWmRseFBQ?=
 =?utf-8?B?WEdNVDZETUQwUWd4UWl5eDFGekNWYXo5UnNwNXpEWkRjR1JFSzZPVlVQRTJN?=
 =?utf-8?B?U0lnc2dBYUNxK0JJdW5DL0s0R1JRMVlHM1ZISmtVOFo2QnpiTStZMWxjN1NJ?=
 =?utf-8?B?eXUvVEJrK04rUEZUZFlDbHBsZy9wOXdGdTd5bTc5QUMrelM1S1VISEZYOElD?=
 =?utf-8?B?K0VHKzhYZFJIMVJ5WWNUUTdDTUZCcmQwK002WjFIeTR1VUJBcjVCTzlJZnhO?=
 =?utf-8?B?b3VLVGlBRC85RC93QUx2NDZML2E0Q2NzWk53ZVNWbFcrbi9KbU1UaXI4UVIr?=
 =?utf-8?B?TU5XQlJFMnpBRUd4TnZXTTVJcnFGVXAvbHYzWWwrWURBdUxka2Y1c25IRjc0?=
 =?utf-8?B?UzR5ZVZkRlBXcmlFemVJWEwzQ3ExSnF5c1g3K0tTMTE3STVhaGVBN0t2OUY2?=
 =?utf-8?B?eU5iWkpxd2lGVEFwZXMwa0NqMTN0Vkd4Yk9XYTlUK3ZqNWE5VmZiK0NuZm9E?=
 =?utf-8?B?Mm53Mjk2eEtJRFVxeS81ZE1qR2dMdWVZMWh6Myt6dWc3TFZnZTZxcW1kS1Bj?=
 =?utf-8?B?dGZyQzBxV09YSjNpR1pDemY1bjJsVW1GUHUxSmpZZlFaY1Q3L1dheUQvZHRE?=
 =?utf-8?B?ZTBoVnlJUlg1SVFOM0RSZkorb3BSU0oxVnZkQ1lxU0pjTGlrQTIyRnI3QVVE?=
 =?utf-8?B?SGpoQ0NXdDRmclhOS2dpTk9qeXUzblo0YW50Z3lrQ3pVNWtNenp0UGh4b05u?=
 =?utf-8?B?aWhmeXlYVHRaTnEyckt5dlo3UHhtU2ZsTWFqR1JybmxQejh1MTAvMlJyQUZL?=
 =?utf-8?B?S2drZGJ5M3BhTVBVME12UTBHRS94Z1N1QnhqR3FGNlRPK3FSRWk2eHQxalox?=
 =?utf-8?B?VW1VdGw0TjlHdHgzc2RWRlg2VmQ1SUN0SEFKUnZaY3BDb3RLa0VQdzZjbFgx?=
 =?utf-8?B?TjFQZEg3R0F0NkQxUkRNOVJtWnJrOHVVUkxiaEVGUDJaTllaK1NGeFJKaFZB?=
 =?utf-8?B?YkxmYlFlUzY4QkRxY0NQaUdhSGZRcGtTVGdWS0U4b0VCWVZsNjV5WE1xM1gx?=
 =?utf-8?B?dnFZVVR1dGJuR1RqT1lnNFlxM3NXU0ovUTA5RU5PdE5oNmNjZDFWYitzVXpP?=
 =?utf-8?B?V2U2OWJOREJwZ243dmlrSGRBbytvcjFKcjVOeGRwd2U0WEZ4ZmlpbDVYdzJu?=
 =?utf-8?B?SXMvaGF3UDBrWkJsSE9sZ2djQWx2UGNnN2E0bU5tUzI3R0IrczVncitXZzhG?=
 =?utf-8?B?Vi9lR053eU9vV2JkQml6Q3Fid25VaXpqRkNuc3Njc1RSaHhVZkdyL0xVb2pI?=
 =?utf-8?Q?Vjl1xpjzhLsmxFCSBTg9GVhEIvfMeIT0Tke4o=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eExVMW0zK3RIaGx1Ymh5NHZTU0V4SktKTjZtNnFJTUdhdjBHODBzU0grV2l1?=
 =?utf-8?B?dmtUN2E5elRNUWt6Z1E3N21MK0xTQmtwYVl2SmVRRU5mdDVueDVqSlFmQy9F?=
 =?utf-8?B?Sm5EdHMzdGpjRnF2VUFva0hYd3puell2dCthaXNDQXZGWHI5bEdMVW15SDZp?=
 =?utf-8?B?OGdUZVFkVzdISDY3YU1mR2h5ODZvV0g4ejJVWjVrclZJdXVUNUozbG5sNWZL?=
 =?utf-8?B?a3NPK2JnYVNFcEN4T2Y2clV1S0dVMUdqOFgwYnJidFlyYm4vcXdkcHFQOFNy?=
 =?utf-8?B?d09KUUt4cmxJY0RxYkNYa2IwSFd3dVFPTjBFSlBCZWlMNkl1dGRYSWZYQWVT?=
 =?utf-8?B?djRSMjFtOThodVY0OEMybUw0LzZvS1ZXVjEyNVprQjdxYUN4V0pDcnBobmJW?=
 =?utf-8?B?REp1aTV5M0FBMU9NSDlLcU9NMjBwZDdtbzQwalRIbG52MUk0VHBKS0VlRzky?=
 =?utf-8?B?SnNYUDdHb0UwVytybm9CcnFQYlpWWDFKMFZ5S2pIZzdsd3ZNY3grUlRQeTV2?=
 =?utf-8?B?RDhIYU9rUDJRUS9tb25mMzU2blBiVVpLVzRCamlkU0xKeUlNVWJVRHVxbkF5?=
 =?utf-8?B?dGphaUVmTURYNUpvbVpkREJhbFd0bVZDQ3pRdVRTSUF1NzNURzZoMm5uSW45?=
 =?utf-8?B?MXBWbHN2UmhNVjB6ZlpWN3NFTFZTRzEyYVcwWWJjWXlaNTdtUHpqa3hHN3Vk?=
 =?utf-8?B?YlBkcTQzUkorcjMybGk0NUU5M215MERxQkZxQndyM29zS1JzeXZqQy9JQWJv?=
 =?utf-8?B?bHR2SWRGYTNyRGJWbXRmMktnTHJVZUs1VTFvS0NQbHI1MWVDMEVoS0dob21h?=
 =?utf-8?B?bzhhT1FNYzJiSFJyUWovNEVWSGxIWW84eGZSRkNiWkJUcmprYkJvcGJIcXBp?=
 =?utf-8?B?RGs0OUFkK1NudDhGVlB0KzFxUGtvckhGcEdUdkdkeWFoVFZnV0o0Z01ZZE1B?=
 =?utf-8?B?bEtYOUExQmcvbmZRRndQcG9TRlhtL0FyRnRqUDdCOC96R2NxdDhOVmY5SFdW?=
 =?utf-8?B?b043WXNyZE91RkNQQ3crT0FjcWdxbzRva2xjUVNwdlc2cDdFSWlwSXdRQ2ZD?=
 =?utf-8?B?eExQSVFISVJQVVZCSXZ1Y1lMVXVyTUhtMEZsblYvdTdFZHNvdnQ0anZUbGk2?=
 =?utf-8?B?SGFIbXoyWjJjODcrWmhJbk1pYTluOVRlYXFGZ1NIeHhjdHo3UjkvMkRWYjdE?=
 =?utf-8?B?MCtsWGR1N0tQaUFLTmRhVlQvYndoNEpFUEpyWmljTTcxSko2SmR0d3g2Q1Ro?=
 =?utf-8?B?RnhIZ0VFZS9GTVVsYTlkVCtIcU0zM0cyV0pod0JzOEJFSkR5emxRMjZHcHpw?=
 =?utf-8?B?K0RScTY2MlZpbWsrNHk1Tjl1UXU3bFk3ZFZDb3FzVWZta1hrd2ozeEVacDRY?=
 =?utf-8?B?YWoyamZvTWY3Y3VaUWJIZkJ6QVo3YWtRZWlveHhkcVlsbUVZanJnYjNldzYx?=
 =?utf-8?B?eWI3emwxVjliWksxQzhDK3d6Vi9GSnNRTmhuVnRRU2xYSCt2MEdncFkzS0dz?=
 =?utf-8?B?RmVUbWpaR3Q4TGQ2NC9lWTNCRUwxM05zZFVzMmFYaWQ3cHN5Qk9ZV09vaUo0?=
 =?utf-8?B?T2NkU1RRSCtSbUF6TVFlSTdOazRueDdleXRuUVlXNlltZTlIamhhZVZ6d2Nx?=
 =?utf-8?B?d3lwU3JPQXVMUDdreVBJQkZEb0ZLZjhOWVZ4RnB2ZHQ5RDRyRnREaktMTjYy?=
 =?utf-8?B?OXhHVWdkT1R5a2hoU3E1YmRMamozUW1Tcit4czg1RitveWNxSldsdHJUazgw?=
 =?utf-8?B?eC9acHBQNTNGNDQwMHA5QTRQYjdCN1JLUjZKeTF0TVREK2hXZndtczNQTzNB?=
 =?utf-8?B?Q2VhWU9Qa0JVWURJUTlsUzNkTktVdy9uQkc1bit4b3orR29ZU2RHem9mMm01?=
 =?utf-8?B?bUNBa3R1QitRZ0hhazZqS3RXaE5jQmJBNDIrVSttcUhUb1M1Qis3Q3BPd1Br?=
 =?utf-8?B?S2p2Mk9xMzBBbUl1QVdqaXdDRDBBM0QwTk1ZUTU4T09XZkNmeHRkVDdQQlBr?=
 =?utf-8?B?dUlMM2JYdlB0QnlxZFlzbzErZzBRdm1DVVJUSUord0ZZWUp5eGtRSU90NDZ4?=
 =?utf-8?B?Wmx5RW9jcTczVFVmRjdJTStCOEtxZnMreHJIUG0rNytqQ1NPYitMSFhoVC9k?=
 =?utf-8?Q?LHBF8Ow1DFCyAXhTb/Xls8Hlo?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a496a43f-a760-41d4-abfb-08dccd0a8bbb
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2024 17:53:56.2086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5FPzTiQscLLHxNIRPKOUTPa2NebAJX50mW+YugIK6oylbC498fBRdpc8x8+Tr88sMYGBhdofx1pBy7037VMpoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8227
X-OriginatorOrg: intel.com

Philip Chen wrote:
> Hi maintainers,
> 
> Can anyone let me know if this patch makes sense?
> Any comment/feedback is appreciated.
> Thanks in advance!

I'm not an expert on virtio but the code looks ok on the surface.  I've
discussed this with Dan a bit and virtio-pmem is not heavily tested.

Based on our discussion [1] I wonder if there is a way we can recreate this
with QEMU to incorporate into our testing?

Ira

[1] https://lore.kernel.org/lkml/CA+cxXhnb2i5O7_BiOfKLth5Zwp5T62d6F6c39vnuT53cUkU_uw@mail.gmail.com/

> 
> On Wed, Aug 14, 2024 at 5:46 PM Philip Chen <philipchen@chromium.org> wrote:
> >
> > Add basic freeze/restore PM callbacks to support hibernation (S4):
> > - On freeze, delete vq and quiesce the device to prepare for
> >   snapshotting.
> > - On restore, re-init vq and mark DRIVER_OK.
> >
> > Signed-off-by: Philip Chen <philipchen@chromium.org>
> > ---
> >  drivers/nvdimm/virtio_pmem.c | 24 ++++++++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> >
> > diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> > index c9b97aeabf85..2396d19ce549 100644
> > --- a/drivers/nvdimm/virtio_pmem.c
> > +++ b/drivers/nvdimm/virtio_pmem.c
> > @@ -143,6 +143,28 @@ static void virtio_pmem_remove(struct virtio_device *vdev)
> >         virtio_reset_device(vdev);
> >  }
> >
> > +static int virtio_pmem_freeze(struct virtio_device *vdev)
> > +{
> > +       vdev->config->del_vqs(vdev);
> > +       virtio_reset_device(vdev);
> > +
> > +       return 0;
> > +}
> > +
> > +static int virtio_pmem_restore(struct virtio_device *vdev)
> > +{
> > +       int ret;
> > +
> > +       ret = init_vq(vdev->priv);
> > +       if (ret) {
> > +               dev_err(&vdev->dev, "failed to initialize virtio pmem's vq\n");
> > +               return ret;
> > +       }
> > +       virtio_device_ready(vdev);
> > +
> > +       return 0;
> > +}
> > +
> >  static unsigned int features[] = {
> >         VIRTIO_PMEM_F_SHMEM_REGION,
> >  };
> > @@ -155,6 +177,8 @@ static struct virtio_driver virtio_pmem_driver = {
> >         .validate               = virtio_pmem_validate,
> >         .probe                  = virtio_pmem_probe,
> >         .remove                 = virtio_pmem_remove,
> > +       .freeze                 = virtio_pmem_freeze,
> > +       .restore                = virtio_pmem_restore,
> >  };
> >
> >  module_virtio_driver(virtio_pmem_driver);
> > --
> > 2.46.0.76.ge559c4bf1a-goog
> >


