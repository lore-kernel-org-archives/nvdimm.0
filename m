Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FC220D4E2
	for <nvdimm@lists.linux.dev>; Thu,  5 Jun 2025 23:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749167255; cv=fail; b=Zp1tBvQctlQgHNR4mySUKlLzUqWNcZjEEKXnsWOiIwixT7RN2uOkLZR5LIMcYdmWg4LbHoZmrinjPxzux8kpQCm5biKjyOSTg1wBTm9Jx7EBiXXG7DkQGfjryYtGRM89c4rbySByDKGKs0kA/7k9rdeewnLNYgqk2GQeuYSPoqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749167255; c=relaxed/simple;
	bh=LRWzk+N25FkaYrOsvRuYWghUlFtvWukoz9QVkgHa5Ao=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=G9eh++hZFCfCruBWiDMS4vcxKiYxwW3bKrZ1PHCh9OUJ6eqfrvP5XaUFhXd2MpNzAdB4iO1fKaZ/XRzlSzchqofQKMiNAxlpQVKAuDU9JUBfStX66NAMDAr9DY3h+ZxBIh2/5xMuCdgIhS20IshTkf/ytMURsNBYQMFLCfu//vA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CWkHQUZ1; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CWkHQUZ1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749167253; x=1780703253;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=LRWzk+N25FkaYrOsvRuYWghUlFtvWukoz9QVkgHa5Ao=;
  b=CWkHQUZ1EAWo4yDiZ2dUgwWwENVytyE5YkCcYAz93yxEfRqXUvTyLhSz
   mbIX7wtQ7g/TnVxBAbmj+Y2OQZY0ZJ1Th/V56eos+iM6WQL+aZSvwNqC3
   aKJRfLMTu66ZsSXna38mh9ioVla6KIZQztqwnvAZFAuQIv7v3rDpzDvAR
   HLwxbIXDn5FDXV8IYtFf5cb268wnk/oHXWFWQk43WUMxMJ6/iHS6XSAxk
   1CEIty0fzpccxpdEkumAAWzvrFL23zp0/92XNZd3kPWLEjLzU4WX1JZkF
   2ItWh3Apwu8rC+e7V+i8P7P0KL6b2n94OrcGbLBXcFzCOwzmk0A3mGJYl
   w==;
X-CSE-ConnectionGUID: dT8nj9fbRyaNGg+IFjLAjw==
X-CSE-MsgGUID: T4eg+HsfTUyX76lP3Bq4cQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11455"; a="76707223"
X-IronPort-AV: E=Sophos;i="6.16,213,1744095600"; 
   d="scan'208";a="76707223"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2025 16:47:32 -0700
X-CSE-ConnectionGUID: jJKospXFQECSHOXcXk0JKQ==
X-CSE-MsgGUID: 94CpyX/ASl60NA6lfHUayQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,213,1744095600"; 
   d="scan'208";a="146252324"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2025 16:47:32 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 5 Jun 2025 16:47:31 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 5 Jun 2025 16:47:31 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.82)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 5 Jun 2025 16:47:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m5WftbLt7SpCmsxp2TUR7Ckf7mF1OXdfgwpmfobakFtXr6dlQtUccOMtJy0rIiViWd98yzkqTq7fny3iGx29hpUyIn1s99g1tkerg4kOmJAdo8QvATTYhGNJphKf9UIWfdz23g7gNsfuL7QZR3vhnmWSEwiJ9QBPcbZrlh2TXg95BfqtogY/kgPPf6012aN+f+SkGCANzpabETpVvNxkW8UIbBQmqoJhepyftiZpjP5PDK3+xCHFt93u/nqJsPdzHK6HLEFV0ngP444DFYgd6YtxY+Jz00cUKCdO8B2CxwWOQiTqS+CnVUYEVS/S6TbUaRkC7d/iicXIM6gtA1c/yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vkLebv8Fd02QcLHTY60ugKOmE5JzmUHKngb01nPbbeo=;
 b=jZjpurQHH9UPu2upn54uaRIEPobkySkT8KxjHcrY7iSI+KDiClkud2nQ4de2hT0SmrcBQpt4ypErhJMbegIhjc/3/YIUDfMgMsUuH+qfc2qM1qKW48zPXzgqtyMgh8AtXLcoW29cQged1j31FuzlcRoP4Vh6q3nSYdKKc0Cp5CYFc/VQMXqSjNhLJI8z8er5xyWKAOFnEs8K6NVKppaRCsKQcPjmQwBecqEwoqFqGhQ0lbf1k67EZb72ebS8OeSAACeUJmB20PLu+Vg0Im7V4jtIi3yla/gkpyV5v1dQshOitfXcjqqEUHJXo+dNuUVWVDtNAuS3dn9HOvTj/SM/Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS7PR11MB6175.namprd11.prod.outlook.com (2603:10b6:8:99::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Thu, 5 Jun
 2025 23:47:10 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.8813.021; Thu, 5 Jun 2025
 23:47:10 +0000
Date: Thu, 5 Jun 2025 16:47:06 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: David Hildenbrand <david@redhat.com>, <linux-kernel@vger.kernel.org>
CC: <linux-mm@kvack.org>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, David Hildenbrand <david@redhat.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, Alistair Popple <apopple@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Dan Williams
	<dan.j.williams@intel.com>
Subject: Re: [PATCH v1 0/2] mm/huge_memory: don't mark refcounted pages
 special in vmf_insert_folio_*()
Message-ID: <68422c7a3a2c2_2491100fe@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250603211634.2925015-1-david@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250603211634.2925015-1-david@redhat.com>
X-ClientProxiedBy: BY5PR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::16) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS7PR11MB6175:EE_
X-MS-Office365-Filtering-Correlation-Id: 18e7fd09-a21e-4ec8-a3ba-08dda48b49dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?tJNA1bSx5p3noqKwaa7pP4vfICcGYU1+3/atJ7rjG+TUmH02HMPmV7rPvUwU?=
 =?us-ascii?Q?5wDszkMVTo+BHW9cSLzhFQMgnedaq8Rpg8SuRfnYsc6Dbst55sPSqRGvnPj+?=
 =?us-ascii?Q?TW9Ang7QzHAZlrIKxzuIfaAC3Z4MTPpRvHL4q/vTmJvhFAVgzQz476ohfu+f?=
 =?us-ascii?Q?53ND9Tca8fN3EFLhJb5Tb/32jzSc4H964xMItig4nGXXjDHM48Tu8c/OBiFz?=
 =?us-ascii?Q?SU7RktJIrDvBFiEps5SVzpweRryRT/MsX0zBltIsGxITLDnStw7t9raayZmp?=
 =?us-ascii?Q?VlZM7OFoD+kW84vIKMARFBD8EGbOIEV55ZLH+qxBHa4Pogk6961t4m6N3lK7?=
 =?us-ascii?Q?OouKqWKsTvD2Ihh5OWmRseAkc+UEfIAeDx2iQmbZopk47sxhANcTsl6Wh61U?=
 =?us-ascii?Q?wdL60qMF05ncWap7yCVEXaFgVJGYr2pHt9sC5es0d1oeymw6EF8pt8we+EKQ?=
 =?us-ascii?Q?fDPdaj46jDUxKlM/YXA/mai+Ps4pYHjzzNvdIn2vVLfX4ntwanBOy/U+th9O?=
 =?us-ascii?Q?kyjVjzxu2j7VVwYCXd+GBQIuA27nnEzYtpSxskFrom/X7NDj2y0chbgOHRWB?=
 =?us-ascii?Q?3VUsZXl4/yQQccCxUG/o9SJgqWPIZWgp2RmayFaF+MfRlE+DjHnPNNFXAfTv?=
 =?us-ascii?Q?VenMJq43M/56ucqEX5jSxKZsx8huxfrD4BCi1D5wc2m72EtFhtz5gYKh4U9V?=
 =?us-ascii?Q?rxEQxZroloR8J8E4a+Y2twobC1IAD97mGQzzVNOBgpBtzbklnEAaw9nkmkaC?=
 =?us-ascii?Q?eLjv//nQYVfsz3IJBKmw9bw+AI6Pk5lTOFLGYacgJVF6PrSzBd6IR/SWlexY?=
 =?us-ascii?Q?sUfA6X/5ZPCLU9WPuyYwEw1SNc0HrphwpnAsGI1J4G2f4N7pjIp4kfOFDa2s?=
 =?us-ascii?Q?LJNTk4dG2oc1TAS6o5a1w5mjOAEXixM0vcoEY/1VC3rSi+WXLmyMRgSoJTXO?=
 =?us-ascii?Q?Fy3FJdX5s33Iy7p/lY+J81ztMN8jC+t9xjy72i/A2ja+Saj27hmZBThL9jfh?=
 =?us-ascii?Q?raj4bPKs5oiMY2j3B9sIzwd1JWsDS9gOBJr1SBYcyZmnTYOPjWRTJtjULC31?=
 =?us-ascii?Q?OlK+zgEPxMl0FD+b/KxecGUXyJA1uYCFT2p/v4MBqdaMRxLx/m+COK7N/acR?=
 =?us-ascii?Q?RcUMCeEQZzYWtsGwktQ3SwEqVwIRnGk1UCKVSndUTWu3NX/5OD+vgvqibGK8?=
 =?us-ascii?Q?nWMdqKb0KskPE6HzoV27ySaCg/64MugzZ6psN96MyoZSCbK2hwsxQYBhafgx?=
 =?us-ascii?Q?zFopkL60xQeB3Om56/T/R1oFLQH/Dxq1PS47ANYqArjjHZKXWUcqiMq1RWau?=
 =?us-ascii?Q?hfD2TG+/Pcp08n5wM0R5AKxJeasWUoYYqm/lijUlHY8oJG2RISURJfC7H99C?=
 =?us-ascii?Q?8hcA/0KXgB/i4LTYsF6FMtXI2rCj0bndUNcw8duyGpR8xmaVurfzITLG/92C?=
 =?us-ascii?Q?YYVukSsY9ZQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hf+YhJJ0IENRMsKEIy48YCeTa+0D1w5OtlUnwuvRLz+WwIXn0S00bZDjQirY?=
 =?us-ascii?Q?dfP8cagEkxA8RgsYmg78Pnd02mHGtUWiiY5DEHGMPfBnj2rWcOrDshiw/sdX?=
 =?us-ascii?Q?i2E8TU3UTnT4fxXYMibAux2qlyYCPRJRXln5ZMWWGHDOum72WWRqx/hH74Zs?=
 =?us-ascii?Q?FI4QWuIagbM7p87bsJ1dkBpJZI/Vda95IFQhP+ZjIVXZC4BAgYyOSGvE+CwK?=
 =?us-ascii?Q?08WrugTA8NsLyWS4JNVxpljIcJiYvdP4hEN4mf4gjppHHpKbGo3H6Q6dQrXE?=
 =?us-ascii?Q?0deHA7QzkqibaVxQskoc1Xpu63CFSopcj/9tknjJMNhBTpa4mMGeUuOvlM+E?=
 =?us-ascii?Q?/UU3iZvW0+VR0rpv9B3OxUywJml+YSWHYSR0iWIiUzdnwI9hVlJa+Y1XweMw?=
 =?us-ascii?Q?e3Sbh7M5V2jEyl7aSNEA22/mYnAhhc4b3xO49E9BMjAyqupwFav1YHdFjW48?=
 =?us-ascii?Q?vYozai8sG3ig1LwpWfFwumF7kBlUzJbqmakwFnbPpCHTfHT0paeWTX2FlDNm?=
 =?us-ascii?Q?3d9wnndM6uhOm8vQUiG6YpcM9VFEL5NtqWG8ADFqBypFgmoXnv8F30LYwttW?=
 =?us-ascii?Q?i3EnEls0OM+Aj2CiqZ/9HTUR8nBOh1tGqJqlvEyZ72js5ZOKSvQjApBQEoto?=
 =?us-ascii?Q?KfyRS8AodCIw+zhb3On1k9Vo9U5e5qQIGlYH3vhyCLUknGBaNfQTo0MUyqk3?=
 =?us-ascii?Q?QaDdUXQnj+xJQEDSTlhorPLT672w2u+L0iSu1+Ih/HLQRsvQT4YdI1XRDzSd?=
 =?us-ascii?Q?CvkQ97EM0Kj8qwbTLR0N6YKndHSya6isiWabbw3DabP0F84ePoI3XMLH62JR?=
 =?us-ascii?Q?FLRzJ6xO6tOu/qAMkiJGYHHcgrnZLO4/8AUzdfFPeuMOJfMaXu8+koB4jzZh?=
 =?us-ascii?Q?OV02/IrB9b+0qC3bSaywmh875ik2xj1kdlhnmM3hLHt3tn5mukZGZ4VDfJoC?=
 =?us-ascii?Q?mxrSo5YcUCHZeS/dYT9jnG70YU4dY4FfN0cweCYSad7KWZth/GGRBdQ2yGba?=
 =?us-ascii?Q?eKlkTs3Dt3a1W5XyQnjG9npsYaMYLYcvFioSQNZwgK6fDVDGuSYL8bQ0c3/g?=
 =?us-ascii?Q?nAlmZkZd3BjgZmdxgx6SG6t1dH+sIgLvvP/0ARWm4alqOcCydDtZUtye8xLB?=
 =?us-ascii?Q?SrkD6Oal9k9yEdBXlSRNo4EUcj25sIShU0nekHPIK5PpdN20krSu6BXU/dzq?=
 =?us-ascii?Q?FTNUGouUMzCrpc0lJXppK+/simtzLKhCeNoXLZUV14iaY7+tZ1Tk6picATQU?=
 =?us-ascii?Q?LXvzj7Vf+boRMcRcI8L34H+MOGezj1P8DqTdmyT57H9+/xMJgsEYIORKmAw+?=
 =?us-ascii?Q?OChQQH1i/ZI/co7QAXgbOE9hVMIR/qerce5DCZUtwYtHhFemf+jm2UPPHKb1?=
 =?us-ascii?Q?UtDRVEA18b0n7P0L/KbK0CleqX+R3EQQod67Y7RG4Z90ARG8oUrJ/yZzBwFk?=
 =?us-ascii?Q?koJ+DXZQJg+XKn817A5jSxOz7Lza5klVjzEMFwnZcBvADbBc9Hm4CiWRzWCn?=
 =?us-ascii?Q?kVFEqUKNpd6JfiHmsdb53bg4kgZQpsLzTmqxvTcvS0hlPxCLNPxqT8RgiqRs?=
 =?us-ascii?Q?rbjro8D8BHQbeLPwL0obsUSRQNd2ieismp0uu5XVIbdyJZo6hiT+p7BUxk6A?=
 =?us-ascii?Q?Sw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e7fd09-a21e-4ec8-a3ba-08dda48b49dd
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 23:47:10.5059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CRy0Kyt1Cu2DwgjvnjkjmVh/OMFhZHbK/3+r0O6KCXB1QI+WJYDvTSlC59S6BhvK6cOAMxapR40S2/+e+EUAi444ll5vatO7DH4LIFHcuOM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6175
X-OriginatorOrg: intel.com

David Hildenbrand wrote:
> Based on Linus' master.
> 
> While working on improving vm_normal_page() and friends, I stumbled
> over this issues: refcounted "normal" pages must not be marked
> using pmd_special() / pud_special().
> 
> Fortunately, so far there doesn't seem to be serious damage.
> 
> This is only compile-tested so far. Still looking for an easy way to test
> PMD/PUD mappings with DAX. Any tests I can easily run?

The way I test this I would not classify as "easy", it is a bit of a pain
to setup, but it is passing here:

[root@host ndctl]# meson test -C build --suite ndctl:dax
ninja: Entering directory `/root/git/ndctl/build'
[168/168] Linking target cxl/cxl
 1/13 ndctl:dax / daxdev-errors.sh          OK              14.30s
 2/13 ndctl:dax / multi-dax.sh              OK               2.89s
 3/13 ndctl:dax / sub-section.sh            OK               8.40s
 4/13 ndctl:dax / dax-dev                   OK               0.06s
 5/13 ndctl:dax / dax-ext4.sh               OK              20.53s
 6/13 ndctl:dax / dax-xfs.sh                OK              20.34s
 7/13 ndctl:dax / device-dax                OK              11.67s
 8/13 ndctl:dax / revoke-devmem             OK               0.25s
 9/13 ndctl:dax / device-dax-fio.sh         OK              34.02s
10/13 ndctl:dax / daxctl-devices.sh         OK               3.44s
11/13 ndctl:dax / daxctl-create.sh          SKIP             0.32s   exit status 77
12/13 ndctl:dax / dm.sh                     OK               1.33s
13/13 ndctl:dax / mmap.sh                   OK              85.12s

...ignore the SKIP, that seems to be caused by an acpi-einj regression.

However, how about not duplicating the internals of insert_pfn_p[mu]d()
with something like the below. Either way you can add:

Tested-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>

base-commit: a9dfb7db96f7bc1f30feae673aab7fdbfbc94e9c

-- 8< --
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d3e66136e41a..cce4456aa62b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1372,9 +1372,9 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 	return __do_huge_pmd_anonymous_page(vmf);
 }
 
-static int insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
-		pmd_t *pmd, pfn_t pfn, pgprot_t prot, bool write,
-		pgtable_t pgtable)
+static int insert_pmd(struct vm_area_struct *vma, unsigned long addr,
+		       pmd_t *pmd, pfn_t pfn, struct folio *folio,
+		       pgprot_t prot, bool write, pgtable_t pgtable)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t entry;
@@ -1397,9 +1397,7 @@ static int insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
 	}
 
 	entry = pmd_mkhuge(pfn_t_pmd(pfn, prot));
-	if (pfn_t_devmap(pfn))
-		entry = pmd_mkdevmap(entry);
-	else
+	if (!folio)
 		entry = pmd_mkspecial(entry);
 	if (write) {
 		entry = pmd_mkyoung(pmd_mkdirty(entry));
@@ -1458,8 +1456,8 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write)
 	pfnmap_setup_cachemode_pfn(pfn_t_to_pfn(pfn), &pgprot);
 
 	ptl = pmd_lock(vma->vm_mm, vmf->pmd);
-	error = insert_pfn_pmd(vma, addr, vmf->pmd, pfn, pgprot, write,
-			pgtable);
+	error = insert_pmd(vma, addr, vmf->pmd, pfn, NULL, pgprot, write,
+			   pgtable);
 	spin_unlock(ptl);
 	if (error && pgtable)
 		pte_free(vma->vm_mm, pgtable);
@@ -1496,9 +1494,8 @@ vm_fault_t vmf_insert_folio_pmd(struct vm_fault *vmf, struct folio *folio,
 		folio_add_file_rmap_pmd(folio, &folio->page, vma);
 		add_mm_counter(mm, mm_counter_file(folio), HPAGE_PMD_NR);
 	}
-	error = insert_pfn_pmd(vma, addr, vmf->pmd,
-			pfn_to_pfn_t(folio_pfn(folio)), vma->vm_page_prot,
-			write, pgtable);
+	error = insert_pmd(vma, addr, vmf->pmd, pfn_to_pfn_t(folio_pfn(folio)),
+			   folio, vma->vm_page_prot, write, pgtable);
 	spin_unlock(ptl);
 	if (error && pgtable)
 		pte_free(mm, pgtable);
@@ -1515,8 +1512,8 @@ static pud_t maybe_pud_mkwrite(pud_t pud, struct vm_area_struct *vma)
 	return pud;
 }
 
-static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
-		pud_t *pud, pfn_t pfn, bool write)
+static void insert_pud(struct vm_area_struct *vma, unsigned long addr,
+		       pud_t *pud, pfn_t pfn, struct folio *folio, bool write)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pgprot_t prot = vma->vm_page_prot;
@@ -1535,9 +1532,7 @@ static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
 	}
 
 	entry = pud_mkhuge(pfn_t_pud(pfn, prot));
-	if (pfn_t_devmap(pfn))
-		entry = pud_mkdevmap(entry);
-	else
+	if (!folio)
 		entry = pud_mkspecial(entry);
 	if (write) {
 		entry = pud_mkyoung(pud_mkdirty(entry));
@@ -1581,7 +1576,7 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write)
 	pfnmap_setup_cachemode_pfn(pfn_t_to_pfn(pfn), &pgprot);
 
 	ptl = pud_lock(vma->vm_mm, vmf->pud);
-	insert_pfn_pud(vma, addr, vmf->pud, pfn, write);
+	insert_pud(vma, addr, vmf->pud, pfn, NULL, write);
 	spin_unlock(ptl);
 
 	return VM_FAULT_NOPAGE;
@@ -1616,7 +1611,7 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
 	/*
 	 * If there is already an entry present we assume the folio is
 	 * already mapped, hence no need to take another reference. We
-	 * still call insert_pfn_pud() though in case the mapping needs
+	 * still call insert_pud() though in case the mapping needs
 	 * upgrading to writeable.
 	 */
 	if (pud_none(*vmf->pud)) {
@@ -1624,8 +1619,8 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
 		folio_add_file_rmap_pud(folio, &folio->page, vma);
 		add_mm_counter(mm, mm_counter_file(folio), HPAGE_PUD_NR);
 	}
-	insert_pfn_pud(vma, addr, vmf->pud, pfn_to_pfn_t(folio_pfn(folio)),
-		write);
+	insert_pud(vma, addr, vmf->pud, pfn_to_pfn_t(folio_pfn(folio)), folio,
+		   write);
 	spin_unlock(ptl);
 
 	return VM_FAULT_NOPAGE;
