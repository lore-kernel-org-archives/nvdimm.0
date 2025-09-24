Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44374243371
	for <nvdimm@lists.linux.dev>; Wed, 24 Sep 2025 23:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758755429; cv=fail; b=qMZGK1rozYLjPhum5VlpEp0LnQgcaAFN0ANelLhiu4MkV1OFMeBXSFMvDkJtpOvGTz7qEuR8rG3SFFHGMY6EzIs8PfkreZ0jGxgqXPNYsT8wxyE1uPN7tSjmPPNbt472P+5uUEuT+ETb4GTm7uLr2Ov3vtJDz6+jJlp9FWo/D2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758755429; c=relaxed/simple;
	bh=M9GlgxUHas9Na5YjtSoPVM2mShRy5mMdeStQN5MOsl8=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=c0XmyQBgGgL0x33vmoTgLxpxScm8fS8Q3oWrfXfvoFMrl3Fj0BV6tY537eNQIdeVqjEoHJGudnyGH7BUa/nT5S2Wo/yjaN9Mq1lbHEuWn3NpG2d+krhGbGz2lLHVEgmEnu1pyK9JDsUWAkn05OqVUyWgDNBCEcTChNpxfwM+wSk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NOD/6eYs; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NOD/6eYs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758755428; x=1790291428;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=M9GlgxUHas9Na5YjtSoPVM2mShRy5mMdeStQN5MOsl8=;
  b=NOD/6eYsbOPq+OPYrpVyV4l92XOa7e5+eInsqp86ClEYDb3Rihrh8Z6E
   wVGASaVXt963bgceabjmaB3/IJugfqcLmbzvENpIAW450IOp8JsIPryQ5
   tDcfgQKHAaVC65RRhljesewzY2dwd/IKPTbgGhKCbyQRyWozwLgPSBlJe
   2AsG2+i6LjPh5SXXdSzQesJg5BlXO0eRm62QCaBvb5UDwMg1H1N8nX4Wr
   p1W8j1CcrascX4JybOxYPc5l3gG5zS8ZxbQJcydXiUXrPDvvDlvCPpU6V
   i54BB53M09urtGeBcuM6+ENHATrr4CTp5qk5HhECWGXKh/sjtUa/5n8TR
   w==;
X-CSE-ConnectionGUID: gq0pH0RyRMubLjwIWYdGVg==
X-CSE-MsgGUID: /2gTCxUZStKic3/VgKSRJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11563"; a="60958301"
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="60958301"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 16:10:26 -0700
X-CSE-ConnectionGUID: ZO50M6F8TP2K0mrWaxN92A==
X-CSE-MsgGUID: pdp+dliTQgueDlzlIIcmDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="214287799"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 16:10:26 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 24 Sep 2025 16:10:25 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 24 Sep 2025 16:10:25 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.41) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 24 Sep 2025 16:10:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BP7gJeyDAAC7nDtaPccO3818g26QTKvzITwmUX7XF5paqGf9/BolNyyogTz9/cTZtnjzganQIcRB61Pal7fDECENXvSTwH8mgsHlACK+E+lrayo5tgCiN8Xj2JDdh9mCnPqZ+zgZckpupiLjWqed20t7TFXNaYla5PIAp5r+l6gYGuWwHlqGRmncJhryOOVm4w+LCZWUYlhToqPpCOJDNUXfsyefr1BN0oVgPALbjW06GH9hJg+UAozuqNOgnHNYtCDbTCvQk+j0gYAkBGPJzGLdu8vAknP3Mwqxv95NjPTB56i2VgZD1JZnhj9uNSzPEWqPwKZ9VHdgyStkTN8aTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mmclcm4nVKPjp7yfr1CPEa9gBoIf5HxKJ8Qa+ricgRw=;
 b=zMqG9W1tU9OyFrdQUAFk4XBmpKeNkNzwu6r2NgmgpjA8VogncUIoGWcUnWDIslKUGDEz+sXAzwsT3lJwXD8HDaxvGT+TTwodOunvSmzOYV8Aepj/MKpyuptLggI4egdQPdoXda4qeDm89b0topwCa0aX7K3h1zXsf21sQOqXy/kvB77INppHdAPuZj48+vZw+kvj9i/UEdQycAgni1DbM/0zgtuOBwVH5zHS8PRTI9pw+8KCotHAYnOPsA8Ho45P8j+31PwVX4T5zY7SLciXaqr4jm7tFgGps1udlw1Ut09Bbb7DSzIUKHNzSgerU2xvegWxoaMWroTACSpovQlY6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM6PR11MB4627.namprd11.prod.outlook.com (2603:10b6:5:2a2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Wed, 24 Sep
 2025 23:10:24 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%2]) with mapi id 15.20.9160.008; Wed, 24 Sep 2025
 23:10:23 +0000
From: <dan.j.williams@intel.com>
Date: Wed, 24 Sep 2025 16:10:21 -0700
To: Alison Schofield <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
CC: Alison Schofield <alison.schofield@intel.com>, Andreas Hasenack
	<andreas.hasenack@canonical.com>
Message-ID: <68d47a5d13605_1c791001d@dwillia2-mobl4.notmuch>
In-Reply-To: <20250924045302.90074-1-alison.schofield@intel.com>
References: <20250924045302.90074-1-alison.schofield@intel.com>
Subject: Re: [ndctl PATCH v2] cxl/list: remove libtracefs build dependency for
 --media-errors
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0238.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::33) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM6PR11MB4627:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ed16769-9b9e-41d4-20bb-08ddfbbf8a7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QXpVWEFEZXQxUjl6dFpwaXB2MkVXVDFLa2lWcytoYkRyVSs0OGdWVkUyTEVD?=
 =?utf-8?B?VjdmSXd1WGYweXpkZ1ZKV0p4L2sySTkzTUlJUWxXQnZjeWRBZFVZV3NycG1k?=
 =?utf-8?B?STlwbGpZVVRwQkF0Nm15YWFDY0ZqOUw5ZXRDQXI4cllZK05ncUQ0eStwOThk?=
 =?utf-8?B?M3VNVjRxRGMzUjhaT3ZZbEdVdjdmZGFQTTFUOVRMN2p4OG5wTGs3d3NZL2Mw?=
 =?utf-8?B?aDVVNWRZOXZyQlN1aXlTdVNjdEhHY1lhRC9ORG1IYVN5dEN2dHFFTlVhRGl4?=
 =?utf-8?B?Z1JPRlJpVmJMeVVrSG5vNEtzRVdPM0x5RWtUWWVxNk9CK1VzRUQ5ZlJ1cXl6?=
 =?utf-8?B?NDVHQzB6ekRLRWhKR29WaVNlcW4xWGFVZlBuZ1pKRk02R29PRXRlZFNKaVE3?=
 =?utf-8?B?VHNsdFVXekN0cTZGU2ltaGNESDJOaHlqMlNyWDc5alBmOGNJWnQ4aHdUZUZ3?=
 =?utf-8?B?L0FGdHlpeEEzb3A4eUF5OTVMcW1tcVZzVThWd3lHUFUzUXQ0L0NkTVNUVjVC?=
 =?utf-8?B?OXh2aUJ2aHBsSGE1S2ZzbHd1eGdNQy9nZTZQaUZHQmFlc2ZPVTIya3A3VnhL?=
 =?utf-8?B?ZUdBM0ZlV25YK2JrYTNEb1J3Y05lMitUQStWRDQ1M1ZzZmIwVkJLVTd6eEx5?=
 =?utf-8?B?QVJNcy85amFGc2lyTnRrKzFXUVVNRDFqV0ExN0FNR3JHY1I3elhubTJRMTVw?=
 =?utf-8?B?c3hESUsvOFMvYWtwUy8vYS9YK1U1TG15aW5SU3JneEkxeHAxU3YxejREK3Vh?=
 =?utf-8?B?SDhxQklpTGVYc1hUV296Q1c1M2lJQzhndHlLNTlWMFV6OFZzbFFWaSsxZUZk?=
 =?utf-8?B?eFBpUnk3OXRkYndadzNyRlRRMTAvR3dYM0FmRStYZ1ZzaUw5T0UzVmR5c25P?=
 =?utf-8?B?K29pSzBRc0U5d3dOU21ZRGVGd1Brd1VoYVV4dDc0RWFLMXVyZzliVG5Eb3Ro?=
 =?utf-8?B?OGRDcEI3cHQrUXg0d0VpMllQaWhBanY0UFB1VTRaUVRjdG45YmVVV081b3Mw?=
 =?utf-8?B?Z0pzdVRTQ01HTEp4U0YveExRd2xxeGJyWU9kNUhjL0Z0eVFSSFkwSUFWZC9Z?=
 =?utf-8?B?WGlTUjh3cEpORjlRK1pReUZEd2lYRVVyeTVMZDhRR1hraFpEMlkyMjNCblJn?=
 =?utf-8?B?amk3UnFDMTRyRFhGMWEyNWREaGJDZnRzaXV6OGNHZG13VDJsSFlvZFhEUGZh?=
 =?utf-8?B?K2xOQ1ZaL2c5ZkUzQjIyYlpndkZybHFkL2JhbExzWTBhN3NPTjlZcTF4YkI4?=
 =?utf-8?B?WkJnUzM4UDlteTBuN2VZYlQ2eElMRmVINnBBU2ZQRlByc2FDOUhWUzVSUkJS?=
 =?utf-8?B?YVVKMlhveksyZW9kdDRxWmwzUXZxbUN5WmlzcG9TZFlvR1dnM0lFWnVzcTRN?=
 =?utf-8?B?c0I4Y002dzM1Mm51N25jZHZPWXArVDV4V2hhbWs4T1g2ZlFtWHQweG5MOS8w?=
 =?utf-8?B?RUNnYk8xMVRkUEhhQWZiQ2V5REdpQXRiZGJMQ1BNQXZQUkpadHpDaVNYNmFj?=
 =?utf-8?B?d1NFNDNxWWk0ajRNV1FLOWU2ZzFuMm1ObXVZNjZaS1lodjVWUEhORmVwTXFV?=
 =?utf-8?B?RUF4bXY5LzBoeElhZWJDRjZvTWZLN0xkK0JMWGJRMHdUWjdXRzg3N1UxUWhy?=
 =?utf-8?B?WlFCb1BMSSsxa04ycnVvdVQ4UWpFNmtBRVJSVW9DUmh5bGRmSmJUSGRoTnZJ?=
 =?utf-8?B?KzQxd2hCbXV3VFVZc0wvQksxV3RlQlBYbWMrcjZEQ2FWMXN5OVJGamdHWDBq?=
 =?utf-8?B?R1gzaS9mcjk0NXVWZFpnaFJHcTZnVVNqY2h5RzZWMHJBdlgzZHVmRWFnT3gr?=
 =?utf-8?B?dXd2NDhCL1BtTWp1VTJqVE4ycTVxajV3RWhXZm9vTXQ5WWJqMzAvUDc1eURJ?=
 =?utf-8?B?N0g4Q3dDNUloR3FyZ05qWHpDM0xNV2NBc0lwWUQ3ZHp6WUp4cFduYVluVmJ1?=
 =?utf-8?Q?9g+j0iZfL/o=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bWk1VGhNK0o5UGF4WTlSMUJKRERGcFgrS1pJVWl1d2xuOWc4UGdVczRUbG5B?=
 =?utf-8?B?bjRISm4yc0dnNU1YcWViSGVLRGhCK2c2ZDcwTldKc3lBbVI1R3FUdS9DakVJ?=
 =?utf-8?B?UGRWUkxMMHpLM1B1ZGlnQ3l6NDNZcy91eVo2WkcyMHFOQkozWmlmdjJxZUlu?=
 =?utf-8?B?Y1ZGclMvNStUMFVBa3dtcTZKTzNadzFtLzJKN0lsZm1nV2xFM25MVnZZZGdN?=
 =?utf-8?B?a0twOHQyRGVrV0NYcDBwTW9GdnR2eFg2MElnZU9NeTNBZytHY3hSVWF3aENX?=
 =?utf-8?B?WGhTYWljRWtPbjRnQ1E1T3VCMkhXcTcvRVBLNnhLYzdiOUo0U2tZSStialpn?=
 =?utf-8?B?WDR0K0hQRUJjbGtPQjRzY2ZUdSttKytJd016ZGt5V0tWT0RNQ2NMdmZPc1JO?=
 =?utf-8?B?emlhZGpWK1VzMXZHamwwZlloRG1kWFovQ0VjemNFSFArSDM4UGdZZUVWM3N2?=
 =?utf-8?B?MytZbWtNbjRKVkhVOXdsQmZSajA1MFQvZHVZQWdFZnQ0RzJweSs4WStqMXla?=
 =?utf-8?B?bkdveVc4MG82OUhlSzVSR0lSajJlNlhLbmpwcXhLeHhVY3dJM1BpN0ZkSlM0?=
 =?utf-8?B?SFpMK0Q3bWZDVkxHZ0hIU3pkY0hqVldSU2FyQlNRd3NOdFduRGJhcGNJbFJT?=
 =?utf-8?B?WDBsZnl1bE5OOUNFUFBOQm8rT3NtTkh1M2FGbnR0UmM5RFhTVEttc0pOR2t5?=
 =?utf-8?B?NXFhTUJSTkk5aUZ6dE1kb1cyYmRGb0g5c2pZQnVYandja0taOFhmTGJOSWF2?=
 =?utf-8?B?KzRKODZRd2dDbEN2My9rMmNQRUtDWU5lcXo4Y2ZhNTVxdDhWRzNtVlFONzZv?=
 =?utf-8?B?NGJtTERFWmpQT1diY01nTjZEZXJnUWJKQitMRE1XVnZtSGliQUVzdk9JZWNn?=
 =?utf-8?B?R2wyU3Fmbnp3dTQ0MVJFWG94a21DUmZMNVVXTFRzNml4eXFoTTVWVmxvazB3?=
 =?utf-8?B?ZFZnRjJqOWthSVVIZU5BUXoxMFozNWt2VEEwejE5QUVTMjg4dGpNNTU2Rmxz?=
 =?utf-8?B?RGRsZUpVamk1bDhYNHVuaWFoM3BHRjdKelYzZTdNT254V0FUM2xNNzJjRGs0?=
 =?utf-8?B?OVRYTW9VSXJQRVBZVGFPVko5WW5kZWNueFoxL0h6dDhBK2dGZnRLTEtCMEhn?=
 =?utf-8?B?eEFFZDVhQksxeThtVnI1akN5OVBUNnJsTVJFTUFZaFZJK0JwOXlrNS9maUxy?=
 =?utf-8?B?cWllemRoME9Yc1NIdStjRG5PVFdzOFNma2RYT3BLbzN1eFp0RHZpZ3crTU83?=
 =?utf-8?B?ckszMThCV0w0ZW1xUmF4djhTNWZWdE9FZFI5NElVbnBtNGczM1g4bHdQSnZV?=
 =?utf-8?B?YkFpZGpVTTdzeitXMDZLdzNUam42SmJ3NTJydW5CNURVUDRNQzdTVUFRZnRO?=
 =?utf-8?B?SFJROFJoNWNsRVFBMkNucEpnTWFhNkJ6a0pBNUU1TlZsakU2a1I4dlc2M1g5?=
 =?utf-8?B?Z2Y5SkFuV2lZdWdKbkNpSHlnMkJmZ3VWSVJlSUVzcFVsVGxJNWRBMGdsY0wv?=
 =?utf-8?B?YVVTak9jTi9BMEY0VUwzbUV6TlZqeFlveTBhVjAyTlVWUnUxdDdieERSK0RV?=
 =?utf-8?B?WEtad3pkWTVXamt5LzZHTEwzMkptbEozSEpkbkxGSUZiajlVdk9qL1p1VzlK?=
 =?utf-8?B?eEVUd20wWkt0c3JVNXZxTFlDb2lpcWhuWEhsVDRvNGRqSVUwTjg4OGQzVG5G?=
 =?utf-8?B?L3ZtbXVzSmc4VkErRWQzR0RDaVpPY2pKZW1FVUZaWW5WaTN3eEJEMlVKL1Jq?=
 =?utf-8?B?c0VmbytaaVZaY0JSMlNxV2J1eXlBV3U2Ykw3cnY4YmxvODVtTEhCbzFHdzNZ?=
 =?utf-8?B?T2VUNjV0SG1VMVVjeWs4NU93MTI4MWtvb3EvZ25JajhDUzFGVlFkUUtzLytl?=
 =?utf-8?B?dG0zTXJ3NHhaSEthdkNZbGs3K0RlVXlBN3NDNzdENEMyaE9mMk9BcVIxaHJ5?=
 =?utf-8?B?aGZZdEhtcDBUN2dRWWNzcnAxL25saXBpZ3dXVGFZdU1uNm1tM3JleUZIS1Iy?=
 =?utf-8?B?TkJUTFZueUl1UVVRN09BV2owaENtbG5IVUorQUNMZVFmTU92ZFFzWCtWWXo1?=
 =?utf-8?B?WklJMTl6N29YMFZIeWJLVndockRMNlJEdWdLQTEwSHA0M29rSXg0b3lDVUth?=
 =?utf-8?B?SmFYUWNIR0NBK2lwY3h5bjFvdUk4R2J0ak9ndWlRWlRjNHJrSVRnOUs2Uzhp?=
 =?utf-8?B?ZGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ed16769-9b9e-41d4-20bb-08ddfbbf8a7a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 23:10:23.8684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V5SyAqp1d3cLitvkrEOlMJehuMc0qvScRqed1rcWG4roXHppbSNFcrjR16VL8OYwLOITyXgo62fzOXrGnaO0XKyxi0HdqN4vIY8j0tmBNTc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4627
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> When the --media-errors option was added to cxl list it inadvertently
> changed the optional libtracefs requirement into a mandatory one.
> Ndctl versions 80,81,82 no longer build without libtracefs.
> 
> Remove that dependency.
> 
> When libtracefs is disabled the user will see a 'Notice' level
> message, like this:
> 	$ cxl list -r region0 --media-errors --targets
> 	cxl list: cmd_list: --media-errors support disabled at build time
> 
> ...followed by the region listing including the output for any other
> valid command line options, like --targets in the example above.
> 
> When libtracefs is disabled the cxl-poison.sh unit test is omitted.
> 
> The man page gets a note:
> 	The media-error option is only available with -Dlibtracefs=enabled.
> 
> Reported-by: Andreas Hasenack <andreas.hasenack@canonical.com>
> Fixes: d7532bb049e0 ("cxl/list: add --media-errors option to cxl list")
> Closes: https://github.com/pmem/ndctl/issues/289
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
> 
> Changes in v2:
> - Notify and continue when --media-error info is unavailable (Dan)
> 
> 
>  Documentation/cxl/cxl-list.txt |  2 ++
>  config.h.meson                 |  2 +-
>  cxl/json.c                     | 15 ++++++++++++++-
>  cxl/list.c                     |  6 ++++++
>  test/meson.build               |  9 +++++++--
>  5 files changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> index 9a9911e7dd9b..0595638ee054 100644
> --- a/Documentation/cxl/cxl-list.txt
> +++ b/Documentation/cxl/cxl-list.txt
> @@ -425,6 +425,8 @@ OPTIONS
>  	"source:" is one of: External, Internal, Injected, Vendor Specific,
>  	or Unknown, as defined in CXL Specification v3.1 Table 8-140.
>  
> +The media-errors option is only available with '-Dlibtracefs=enabled'.
> +
>  ----
>  # cxl list -m mem9 --media-errors -u
>  {
> diff --git a/config.h.meson b/config.h.meson
> index f75db3e6360f..e8539f8d04df 100644
> --- a/config.h.meson
> +++ b/config.h.meson
> @@ -19,7 +19,7 @@
>  /* ndctl test support */
>  #mesondefine ENABLE_TEST
>  
> -/* cxl monitor support */
> +/* cxl monitor and cxl list --media-errors support */
>  #mesondefine ENABLE_LIBTRACEFS
>  
>  /* Define to 1 if big-endian-arch */
> diff --git a/cxl/json.c b/cxl/json.c
> index e65bd803b706..a75928bf43ed 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -9,12 +9,15 @@
>  #include <json-c/json.h>
>  #include <json-c/printbuf.h>
>  #include <ccan/short_types/short_types.h>
> +
> +#ifdef ENABLE_LIBTRACEFS
>  #include <tracefs.h>
> +#include "../util/event_trace.h"
> +#endif

Maybe this is my kernel taste leaking through, but I am allergic to
ifdef in ".c" files. In this case you could move the include of
tracefs.h into event_trace.h and then ifdef guard all the parts of
event_trace.h that need tracefs.h.

>  
>  #include "filter.h"
>  #include "json.h"
>  #include "../daxctl/json.h"
> -#include "../util/event_trace.h"
>  
>  #define CXL_FW_VERSION_STR_LEN	16
>  #define CXL_FW_MAX_SLOTS	4
> @@ -575,6 +578,7 @@ err_jobj:
>  	return NULL;
>  }
>  
> +#ifdef ENABLE_LIBTRACEFS
>  /* CXL Spec 3.1 Table 8-140 Media Error Record */
>  #define CXL_POISON_SOURCE_MAX 7
>  static const char *const poison_source[] = { "Unknown", "External", "Internal",
> @@ -753,6 +757,15 @@ err_free:
>  	tracefs_instance_free(inst);
>  	return jpoison;
>  }
> +#else
> +static struct json_object *
> +util_cxl_poison_list_to_json(struct cxl_region *region,
> +			     struct cxl_memdev *memdev,
> +			     unsigned long flags)
> +{
> +	return NULL;
> +}
> +#endif

This would move a new conditionally compiled ".c" file for just these
trace helpers.

>  struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>  		unsigned long flags)
> diff --git a/cxl/list.c b/cxl/list.c
> index 0b25d78248d5..48bd1ebc3c0e 100644
> --- a/cxl/list.c
> +++ b/cxl/list.c
> @@ -146,6 +146,12 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
>  		param.ctx.log_priority = LOG_DEBUG;
>  	}
>  
> +#ifndef ENABLE_LIBTRACEFS
> +	if (param.media_errors) {
> +		notice(&param, "--media-errors support disabled at build time\n");
> +		param.media_errors = false;
> +	}
> +#endif

This would be a static inline helper in a header file that optionally
reports the problem.

All that said, I am not the maintainer so go with what you want, but
leaking ifdef in ".c" is, in my opinion, a slow walk into an
increasingly unreadable code base.
