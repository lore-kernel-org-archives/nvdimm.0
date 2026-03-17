Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183FE15E5DC
	for <nvdimm@lists.linux.dev>; Tue, 17 Mar 2026 02:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773715359; cv=fail; b=gue84MGpTg36cD12EWOjqEVIFISTnfcDNR6hxzXE2io7+OCtoQJ7Eyy4caPjrbNXD9+IsAo8KMGG5d7hgmoxiOxrcWn31Sqci8OQ0GEFIYTN1u8IlD0TGXkbHbZOe+kggU03Mm8r0EDm8Gwi+z5DMm1+MvIb6GzXQPR0FfHkE3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773715359; c=relaxed/simple;
	bh=fihD1p7c/qWpQezzFAsTqlYurupXDq0xTtea+YRF5eI=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=Jy77KzoM8t1Nej+bn8j9WAtAqLMMx4UkORJqkRwVqdXAqZ9Np57RC5yd9DAVRGv8xIvfTdGY68AyHR1wzDm68GdaZCnQXCS3yeJQ3HoApiCVWvhl86Skc7CWJdmp3CpVwnEUQVVTyCH2CGEF4Dxo8CneqmFAe90ZcoDyMxwbgOw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gZf/rn1g; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gZf/rn1g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773715358; x=1805251358;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=fihD1p7c/qWpQezzFAsTqlYurupXDq0xTtea+YRF5eI=;
  b=gZf/rn1gEHadv4O17E6mjHtB2s5R3MOYsmPmo+YCNNC3G6csuqir/bUK
   /zTTdgqN/tJE9qZMi3JXN/xzJxp6PS08Ew832QFd+mIpdFXfyUHBae66f
   2KxTGJfKvMN0BBRlTTxLbRI/STrsV8JpJ2WTuYqhdwq2dhl7HhougI9EP
   aFfmo5hfXsmMdBHgz4mHY5VdL8w5VOEGmBP98gXmLyv3LrvBixCcu6Tqo
   24YW04i0HuNhDQP97QSflpfr154TvOBnuyEL6XA4i4kHm/DhYbu4GeWvh
   kQgnoA96ssRFDO7G4l4cLXNzSaJwHyXeLJd4cNzZgV+4/ijUgj/W1dNLx
   Q==;
X-CSE-ConnectionGUID: 5DJ8FYkHS82wx8QAtxxw2w==
X-CSE-MsgGUID: IUfXdPnCQiiPw9bS1j/k2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11731"; a="74630506"
X-IronPort-AV: E=Sophos;i="6.23,124,1770624000"; 
   d="scan'208";a="74630506"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2026 19:42:37 -0700
X-CSE-ConnectionGUID: qGrlm3gCQrWxiHvRVDPl+A==
X-CSE-MsgGUID: PQaicvdxQ9Ssv8xh4bhOBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,124,1770624000"; 
   d="scan'208";a="226234997"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2026 19:42:37 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 16 Mar 2026 19:42:36 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 16 Mar 2026 19:42:36 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.29) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 16 Mar 2026 19:42:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cOwddvMzDHj/7NSjLnKcH6LRtelDQ+0XUxpCufiYZIlMX46id+UenXspD+ckMjI2RKNUpz0LIcaJJ0dH7w/LBTX1hG5vxZBUErU91sh119Af36QLtsQNSKrJlLvU91zfN9OUC93oKMwcQslZehB1dB8J6qSMobW7k+UXOKI1Y4LCKwFHexM0y+2ZSY6+Zb5ZSZXArSZk1YfpZb/JGU53NKw2WETLN53NV2ct3iD6EbFsVXjiPbCFzHBfyuwoqoSVus19JnWwwxhbPJph8KAA/7W1/aoiWLBS7ZG9low18Und9YjZt25idA2azvRS114JdDgHa4T7d4OqgrZ41TcR1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fihD1p7c/qWpQezzFAsTqlYurupXDq0xTtea+YRF5eI=;
 b=eloCfv1UFy0mWvpRryiGdcpFeRZBJynesgFufEXPO9QgoniAqU9Ge7VibS7kjyF8OY7oXiwsjxZAEFCVipuXgCN8vwh6404A/50PBr0/VQxcfQ9Ss3wD2gHVQWfvJ5jKQT6/dLbz8iKeDl/YZ8TrrJTe9WxbP/eguyNn34lYqRZRCnJremwJup8i7dJV7UccuWbKE4p/41wqvr1sfusK4gW7t5OIYqRh3UuDXXoYZ8i6z1wsEBaEiqZyXpkOa+Pgcutgm+IcioonOHoc24B8glI8TQzE4WLrbExDUQQq6AhTKAKdK/LiBINcPg/1guDTIyPP7D1EyiOHcndR6DbtCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS0PR11MB9503.namprd11.prod.outlook.com (2603:10b6:8:297::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.8; Tue, 17 Mar
 2026 02:42:34 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%3]) with mapi id 15.20.9723.014; Tue, 17 Mar 2026
 02:42:33 +0000
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 16 Mar 2026 19:42:30 -0700
To: "Koralahalli Channabasappa, Smita" <skoralah@amd.com>, Dan Williams
	<dan.j.williams@intel.com>, Smita Koralahalli
	<Smita.KoralahalliChannabasappa@amd.com>, <linux-cxl@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-fsdevel@vger.kernel.org>, <linux-pm@vger.kernel.org>
CC: Ard Biesheuvel <ardb@kernel.org>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Jonathan Cameron <jonathan.cameron@huawei.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>, Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown
	<len.brown@intel.com>, Pavel Machek <pavel@kernel.org>, Li Ming
	<ming.li@zohomail.com>, Jeff Johnson <jeff.johnson@oss.qualcomm.com>, "Ying
 Huang" <huang.ying.caritas@gmail.com>, Yao Xingtao <yaoxt.fnst@fujitsu.com>,
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Nathan Fontenot <nathan.fontenot@amd.com>,
	Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>, Zhijian Li
	<lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>, Tomasz Wolski
	<tomasz.wolski@fujitsu.com>
Message-ID: <69b8bf96c877f_7ee310017@dwillia2-mobl4.notmuch>
In-Reply-To: <e8a1b3c5-61cf-4861-af69-69a3ad323b2f@amd.com>
References: <20260210064501.157591-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260210064501.157591-9-Smita.KoralahalliChannabasappa@amd.com>
 <69b224bf2fd12_2132100b8@dwillia2-mobl4.notmuch>
 <e8a1b3c5-61cf-4861-af69-69a3ad323b2f@amd.com>
Subject: Re: [PATCH v6 8/9] dax/hmem, cxl: Defer and resolve ownership of Soft
 Reserved memory ranges
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR13CA0094.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::9) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS0PR11MB9503:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ad319c4-18f8-41e1-c8d4-08de83ced721
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: rWx/FYc0DsdJAaFpcHntVVEmJ4/1B5TM1NE/UqPAujd32rioIvJ0wn5+p8ac0KBbnQ9oQhupNFVEZH0jBYPxcqIXTqhbal0i3Xjw2AwuF2K/JSSHSmV9mbeQ1gi1cg/SUH3tIkEGw4Vvoq9DhTVmIQMxDC+r3+E6+hUT7CICDRa8n0aKM2gYQABQLo4u8B8BdpONWR9yA6Rbl+33rL8Vk3ni7xpgvLp3ao0gtnniodsgBtczSlnuEKQSNm6Dy2I1+qD1CBvFL32snbJzl3Bz7flASgWqzjSCOfGT4Z3LZXl6EkDPjDec0uDz3eY0aGGypholAAyur7WAAxszfaOa1DpL6UnGNbQ97Z+6o7Z7nryaAqx5OEx+tqYAFeyV/w0quefu/kJbakP/40LCCFrHUrivHs4pGl1zRuQQbBke6JFiWpNZ9k+kZk6GSYG/BzViubY67WKUP4oJEKczj4CtPp+YxjPYcnDW31qA4OpY1K61FU3zjtrNV4bhhk4LCBF9kD4A/GKfme7GabhinohdCVhBKVmH5xxK8ZgXgwWSnJnn2IQvV6YLa0IfkcvQBU18JWVWAFvn7rGHwMMvmtMTpMgPcaEEBR1wJkyOnJ4tQn9kUaPPTf+h694HFFTJFf4TpYpXwanZWHAFcfXxOSe8fZLQs/oxfmnZc4JEKdag+CTtIGOf/w6J+YtgeaF2aFFEm8YsO5zTgW95Lhf/ARYCrf8R0zOvD5hdO7PFivZTolM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UW9qNzVDbnJOcGtESDRJalI4NXo2MEVVQkRRQytYRFVUUlFXbW1iQzFGWFF2?=
 =?utf-8?B?QXRwNWI0anA2aEVkVmZsd0NKdTd1TE9QREZZVzBvODlFaWMvY0ZJcTJwTW5J?=
 =?utf-8?B?bUJ6M0N4Y2tDamgrN01HYzRyb0xwWXNvMzhDYTRRSEo3WVVScmh5bHduLzhT?=
 =?utf-8?B?Vmx4NmcybzdEdEtJajZFL2RMRFUzVytLV2RFOGxEUG1tVFlSWDNUNHhRTFZs?=
 =?utf-8?B?dDIxcVFwU2w4bjNWbTZwbjhNdm9iT08zSDlXZU5HbkgzSEIvWThUM2hMdGpy?=
 =?utf-8?B?WGF2R3c3NWxLS1B0SEEvTzY1NTdadGg2cldhb1VhSkpEZzFPUzczcG5tYk9T?=
 =?utf-8?B?SHhqUEM1TTVRcFJPdkpYaWgvV3dDR0IyQng5TUE0WGlYNVdhWmoyVlhJOE96?=
 =?utf-8?B?NlNURk5jNU9ROUxHVURZeWlwQ1kydUZQTVBLYnJYNEdMRkV0OG1JZ0xlcnUr?=
 =?utf-8?B?enNpZ2x3RTc1N3k2M3hCT2xtNXBGZ2dyaVdwMHVPM2JHSUpiWGlFL2Q3OTlZ?=
 =?utf-8?B?S0JKdS8vZ2NRYjdNN3d6YndOWlpNdWNhMzYycVZNdkx0ZGxaR0hvRm0yVTBp?=
 =?utf-8?B?K00reEZELzJFTmFHcWdqemora0grZ2RMZzEvaTFoWFByVUY4UTl5ZHNTdGFz?=
 =?utf-8?B?YnJFVmJyMldYck1nZjBVZUozdCt2cEFyNUwwSnJHRnpSaWpqU05SSjJObHcw?=
 =?utf-8?B?MGVSck5TUjZ6Nk85cXR6eFVFenFvTUJXaVJOc2lRU0lUNkJPOVhENElQdWM1?=
 =?utf-8?B?RjczeVY0TjUwdmpnU21QRldIUlM1VzgxVVlNNHhEcHgxSkk4d0ZPcXQxTVp1?=
 =?utf-8?B?d2p2VTQ5QTBTMFdTUERBdnAxdTlvbW14L2MwM3ZwdTlkdVBQdi84N2lrZVVu?=
 =?utf-8?B?YU1JWlNlUmNOVmVSRTBoYkRPWHplRnJiM0VFZGU0b2d2TlZOLzRDdVdqNVpM?=
 =?utf-8?B?K0JPMUcxeXpCczRqNmJLdlRDV1kzeGxuRG5sUDh4VTZuckdHS0J3a1VlbStj?=
 =?utf-8?B?dHl4ank5bzJxTVpoSk1Bcm5XOXhoWlhZQ2lKZ3ZUaXErck5VTVl3WWRCakZ3?=
 =?utf-8?B?aVAxRG9rbG1QSTdPRlpGbjlhM2tNUmNKbFlWd3RpUDdHeS9XRWpYV201SzZ0?=
 =?utf-8?B?bk1oT1RtUC9sN05CbEdodlhVeWJ4TEFTRU1PU3dOUmVsL0Y0VUsvMFhnZmNM?=
 =?utf-8?B?T1VXT3RiZkxEd0lCV2Y1T1lGQmVpeE9aL1N5R1JGMkdGMThsOGxBN2kyc1Ux?=
 =?utf-8?B?RndzNzNrQzZZU1B0NmZVaTBTdElHcURXZ3FCU2V3bSt5d296bExONWdFK1Z3?=
 =?utf-8?B?VE1adlJJc1ZWbjg3WUdVV0JnMHk3bzc1YzUzOCtMK2p0UThHRHljdjNTWFhz?=
 =?utf-8?B?QWtNd2U3dEsyT0JUaVNzK00raThzRFpYYSsxWElqa0ZQVGJMSm5pZmpFRHNp?=
 =?utf-8?B?TkJWUktua3Z2K3VFYWlqVHlWTmVzVjByOWcwK1JjaVFkOXFIRi9jMkx2Uk44?=
 =?utf-8?B?eUVkckptM3NPTkpDVTk3RlR5TUZRTjBKUXBaMjVJZmNXVkwvcjNpWXRVMFFZ?=
 =?utf-8?B?S1VJVGNZdWh5cFZlWWtSMEI0eERML1VGMHJpVXo0QUNxQnVzcXFaZXdZb3ZK?=
 =?utf-8?B?Y2tESTBQUzN4Wmx0WkR4aHVyQTIvQ1BGQThQZGM1b2VJSmljY25SV0lodlFV?=
 =?utf-8?B?eVNTUldXWGhnTjR2djY5SEtjS0VMd2o0c0FZeHZkeUE0dkhlN2pZNnZKaktF?=
 =?utf-8?B?QnNiUFkreHRIUW82ZHZQUkdBWktXN01OV0NDMDJIY2JJZGdPY3lkSm9Kc3Ir?=
 =?utf-8?B?QjhjMFhhbUlDVFRrb0s1WE9pQ2gxeEhFOG5yQ3hndmpENTlZa24vZ0ZsT2RJ?=
 =?utf-8?B?YUVKOFIyZHR6S0xsV09PMys0VHVQSXQvQkNRR0N0ejdQS0YzS3N4U2hTQ3V3?=
 =?utf-8?B?K0ZkYVRaQ2lLb0lPNWFZNXFFcGRXL2NjVnFJOTNycURaUGJpVzEvak13M0ds?=
 =?utf-8?B?K2E1SzNGVVpkQmhBQ1V4YzJaS3A2VFE1OC8ybVFpTCtOclFNV2NYK2VCbWE2?=
 =?utf-8?B?RU1hOEowb3RoWVlBanBhVkdPNE45NWNQb1hBeUVZSmo5Z2cxRTFCb1Y3b1U0?=
 =?utf-8?B?Y1NpV3dOalNqcTRVY2lacXZ3cVd3NHJidkhYRnRqNkVUR1A5SjhsUXZOcVA3?=
 =?utf-8?B?b0N3SUtINnBXcWM0UGptbGJWWE5WSGdoTzlWSW90aDVDUnZQSlI5NnUvdWFN?=
 =?utf-8?B?eVFwbnc2aGxxWGdjZTFtcExJRGN5VS9odWYrYjB3NWFaV2JKZ2dxb0F6ZWsv?=
 =?utf-8?B?b0F6ZkdrK1Nla21aSm02ZzFXYTJKVzZ5MVJETG5NbmtVZWF2WDg3T2ZWcEJ4?=
 =?utf-8?Q?iSMVcMM8R8XyX9SE=3D?=
X-Exchange-RoutingPolicyChecked: wKhn3U8XukcwRjAlU7revCvPi7Mnba2ryW455/1L9keS3thHbL+V3Dm9BZKPFYMCVIHmO5V0etW19wn0l6zTocPyxvWaHYhA0Q/dFLk1vF1x632BkfmHMDfFom7uZSczuBd13vDn0l5Z+gIcZeYKEc4L5QyW0oFgWY0XCK1mIoWGwdJzhFOf4qx0Bkp72cXYvXcc55cLhuqQ9GA++Iujpq9lfMhhA9I8q0mOF/w7pID5Qn04wOksGAGp0AaZnB++yqd32qasDD1oZmLMz8yKeyMQOIGtrHPjtHO7GPyg6in9T3x2nl799DMEZjbLl2aZgfgXv3H5dPju2AxFLSq2Kg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ad319c4-18f8-41e1-c8d4-08de83ced721
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 02:42:33.2603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f++DSSGSmCcJL0Cbp6RlWj6a+12oFAn/pSalqrHLhxrChBtIJ4TVgC/T+mwbNZvsFBvlEFJJYC4Puw2jjP59pgeTr/ljdEUIIDeQqUbHAOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB9503
X-OriginatorOrg: intel.com

Koralahalli Channabasappa, Smita wrote:
[..]=20
> Just want to make sure I'm not misreading this =E2=80=94 are we dropping =
the
> all or nothing ownership approach? In v6, if any SR range wasn't fully
> covered by CXL, all CXL-intersecting ranges fell back to HMEM. With the
> single-pass hmem_register_cxl_device() that skips individually covered=20
> ranges, we would be doing per range decisions..

Right, I was thinking that the simplification of not destroying regions
also includes the simplification of not having the kernel enforce a
policy of unassembled regions.

Just give a chance for CXL to grab the regions, and if that fails let
the system come up and not try to take any other pre-emptive action. We
can always go more complicated later with the evidence that the simple
approach ended up being *too* simple.=
