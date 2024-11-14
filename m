Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0BA487BF
	for <nvdimm@lists.linux.dev>; Thu, 14 Nov 2024 21:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731620010; cv=fail; b=UY9G0C7XsV1HgD85qJVoZBZCDzRLAcmQOU8h7Bw9n9Xpl8tMKfaGfHfpPUWvi9lR/ZYgBI0VS0dUSHXOocgOHvJmz2X/O4hv87u7Ek1wy6JICjM1UK8tQMm+hsSONneqi3fOs8K9pIHxG0daMt5bJl/4VwLqvpm5kT40+VcVOUk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731620010; c=relaxed/simple;
	bh=4pXgoQJIL9j+Ndt43r+CSdsMHUjEps812vJINmT61ms=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ImlxOn5fP2g8c0XoGD0+SzXSJjMqtYy7b4f+jub/so15cFS0JLofSRtNfvHsCKplsOD26R/zUHvtTwVvrEf/+X+4cHXXjHYgczEUqI+uMrUE9iL1c+DiDFDP2JPgVIdppKwqPACEIPfLhwxIfKCEJjRUxz7McjrYCzCbmDEYUUk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WCtA7L41; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WCtA7L41"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731620008; x=1763156008;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4pXgoQJIL9j+Ndt43r+CSdsMHUjEps812vJINmT61ms=;
  b=WCtA7L413FyxRNNbn9T0/BdQTpWAcQCEkGUn4WeC4JAcAmckODFY5v39
   kLGT3d3dXGFXy806jE1EqFt6rAhF9ZSqHs5SKc8OBaECYYsi+oGxmQ5dd
   394Ltm3Cll8e18/ZbTUF6snImJ2x/dL9hKY9ZgzZStfkWMry0j2yA1p9S
   YlBoKMOsX+TW/W6s4WjqIrsnUXiVbLh86Y/Vz1M7cMQa+1T39qRR7JB+u
   Shk6mMCx7G4fC33UQxr/vO52b4I9P8X1tJOgGooaB1ddFCO9PxeCqm1yY
   DgJy4YYe7qJGxaXXFSTuBzvoVSfSleldRwDkuQswqRwXuccOTpbxT/f0Q
   Q==;
X-CSE-ConnectionGUID: WFJdapZ1ROyeePUewz4dnA==
X-CSE-MsgGUID: oMVp6VjrS2yOI0EQRADOYw==
X-IronPort-AV: E=McAfee;i="6700,10204,11256"; a="30977072"
X-IronPort-AV: E=Sophos;i="6.12,154,1728975600"; 
   d="scan'208";a="30977072"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2024 13:33:25 -0800
X-CSE-ConnectionGUID: FCgq47cMRkqlDwLz5tLeXg==
X-CSE-MsgGUID: qTcdWFjCRCCYmthKiwx8/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,154,1728975600"; 
   d="scan'208";a="89104936"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Nov 2024 13:33:26 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 14 Nov 2024 13:33:25 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 14 Nov 2024 13:33:25 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 14 Nov 2024 13:33:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XUTqPeA5AFShLWhvA/mgmfw6SCaGcIFwrZe+Sf++CqyvOWYBwBEd43o9TdzdogxwOMv7Flf6LEfsOBM4wOZLvhka5L2A9BUM2dDLksXAnRIc2P0iiAFLqAzw4d9TgWpHY2nu9KJjXdpqdNc/WKmc/c7oqG7yMZV/veCQhREYCYGxHZFFPx6WW04AiB7abvMWBghTU24ESpniEb/WqegdZfl1NpACshJ1ALq5CBCYrqUhgzWDIXwrqDdd0sw/qgj83YEVNwUJNkiHEsSAMKx8UZMHUd0UKHEJuONNMdJegQoyUaZdI8InBWoJ2KEnAyVGcq9MbegJ+MpXJT9kJNqWdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4pXgoQJIL9j+Ndt43r+CSdsMHUjEps812vJINmT61ms=;
 b=B9JX7ot8j7ZEAuX5keXmI+gvTo7AJ5q/msbqZBdZqCgyoMU77eSDC/2F+vixA9bPt0AO/SN3cxxeD2GNzThZG3P8hRsnyaPSRVWgy+8BmsgJ83cUZRBrXwcVxE5BDmfIXveNnm3va5AH+XQlRcFlk11OKBbDwEoDFgMb6sPe8mmMX/FVUgxiYZ29ZqvzKr9rrNGXFDOi1pkwC19LgxeP+fV4K/FTSbrqKzlcskAE1BxpxKEbDFhUasYAJanWZhu3wQYfFx/U2/AtvrS68RXz4LLyKMGukei//1khYEQJ6LCZ3nxWaqKzEpqpL4sg6KyMAPue741VCdxjLdu7cHbTeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by DS7PR11MB7740.namprd11.prod.outlook.com (2603:10b6:8:e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Thu, 14 Nov
 2024 21:33:06 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%3]) with mapi id 15.20.8158.013; Thu, 14 Nov 2024
 21:33:05 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave"
	<dave.jiang@intel.com>, "kbusch@meta.com" <kbusch@meta.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
CC: "kbusch@kernel.org" <kbusch@kernel.org>
Subject: Re: [PATCH] btt: fix block integrity
Thread-Topic: [PATCH] btt: fix block integrity
Thread-Index: AQHa+x09ayIj4MsumkmxDSK9K/nMO7K3w1YA
Date: Thu, 14 Nov 2024 21:33:05 +0000
Message-ID: <eb557451f28668a7c8877322a5d5cb954fb6ac32.camel@intel.com>
References: <20240830204255.4130362-1-kbusch@meta.com>
In-Reply-To: <20240830204255.4130362-1-kbusch@meta.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|DS7PR11MB7740:EE_
x-ms-office365-filtering-correlation-id: da7af2ba-850a-430b-3a28-08dd04f3ed0d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Znh1aktlTDVVcklPWVMyZzM3d1EvcjhDNVRrUWkrSkRNeWltR2UrcGxoZVc5?=
 =?utf-8?B?bEhkMDNPSENkV29tUjhpeEZqUnQvSDRVVTMxaENGb3hwc01mUmczcXkxcFpy?=
 =?utf-8?B?b1o2ckdWaGsrTXFFK0tiay9tR2xvRXNyT3Z4aVRDdmI1Nzl3c1FtQ0s2Y3Zr?=
 =?utf-8?B?cVk1aGZEdk5KNVJsanFIcHpwdjFwTmowWXhacmdiV0ozbzZsUDd3dnErNFRp?=
 =?utf-8?B?UHE5ZWwzZTdXc3VtZGFBNkZHbWFFSHV4TWFLWWdyZFY2NnpvdUJGVkxzZXNI?=
 =?utf-8?B?VlFSQTNjU1REMXZVcUpDRVRMSjZud2tGTjErcnpzeEw3c2dCdWlhaytHUmpZ?=
 =?utf-8?B?aUEzN01yY1A4c1hieFBxcHNnejdiSjFxQ2svS3pCRDFJV0tlZFJtVE5teE41?=
 =?utf-8?B?UEtmRVczVzNIdkNCVHJFSkw0TEZRdldKTXFhM0ZINDVaWUFkdnQyVW5kajQ2?=
 =?utf-8?B?eHpkUlZ0K2w3M05OcDNROEtBdGUyVjFlUWgzKzkvOHZOMXB2WFBjSVlUeFZO?=
 =?utf-8?B?c3RRanh3MVhXSFZySm9aeWQxeE4zNFZpVExQbzc3ell4YW5ORDRGUkwyUnNw?=
 =?utf-8?B?ZGIvL1NlSkp3M0VuREY0a2RuY0FGZjdPcmdscjEvdktVeWphZDJkVVE3eHJV?=
 =?utf-8?B?THFDNllVL1p0dXI5aVhWenEwdXB6NUtUcXVISSt2L1RteUo0SCtOYnIyd0Qz?=
 =?utf-8?B?d1NOcHFPZml3Nm1Ed3lZYkQ5OFRTNktpaTlFZ2RZYU1hbE9oWndOd3FMcWps?=
 =?utf-8?B?TUFjM21JTFMwNUlsZVdlRW1zcG45ck5zeVFwcnVNcTdkeXlLelhEQnowUUZD?=
 =?utf-8?B?SCtGVVhremJNZG9NeWtLaGxUQkFMWW9xVlpRc0xhL09NeUE3REkyRFJZT0hi?=
 =?utf-8?B?UkF0NUpIdEtaa0N5Zy9ocXIyaVpuNSt5MFF1ZndrQmlYSXhLcEs0MURDQUZY?=
 =?utf-8?B?elVYQ0o4UnAzZjk5TlYyY0ZlWENmaWdmUkhYdXc2WmxPU2VRLzZ3V0RLaHB0?=
 =?utf-8?B?bUlGaEg2VFVIWFJNRlFTZ0VFYm9rREpKRytIdUJrOTlrNkNWM3VmbXJrdHN4?=
 =?utf-8?B?Smt0N0VMMjdWSmxpa1BvTVdlZExOcFBjSVozQTZleVN5d3E4azhNRU0vTUJU?=
 =?utf-8?B?SUJ6V3ZIMHNnWmZ2Zm5wOVRuK2hrRXluZ1BHK2o2R3BsTjI4U29jNGY1SFdW?=
 =?utf-8?B?bkFYcXVlcC9PN2h3Wk1QeGdFM2FVcDlVNDBJY09RNXZ6aElsRHp0czNZNHlm?=
 =?utf-8?B?dkhXNVRnbDhWSFZmcEFGUmU4eGNPbmdZa3hXWU5jU1dWcHJyaE1udUphUEZN?=
 =?utf-8?B?RXJCV1ZUTHpOYXd0VUV6YitLeW54SlRSZm9FVnMrNHc4UDlldWdwRzkvTTZl?=
 =?utf-8?B?YkYrUXU1YkJGTTQ4UTQwUFhGUkR3LzlsUzYrZ3JUK1BJU25Vbmk4U2Y3UGdL?=
 =?utf-8?B?K2JZT3VQc0xGNnNOZEtnOXNQZGZPSEUvMFRRRTR1VnY1ckN2by9pd2VuTFRQ?=
 =?utf-8?B?YmZzWVhHUUNNZTM4VkhvU0hTdStFK3hncEkzdTE0NnFEeUNxR0wwY29PajEy?=
 =?utf-8?B?OUQ5YWhOc1Z4ODBocWUwN2xtZ2xER0JMOWNZUkJRa0V0MEFtblZieEUvOVB3?=
 =?utf-8?B?dGx4QndaVDUwdmZVRnRseFdvSXcra3hRK0VCRTRXUm0vaXo1S1hRWnhncTVN?=
 =?utf-8?B?MkppamxXOE5JdUdLTGcrNGRYWmU3Mlk5eE9ZREF4djhkRlBHM1VnNFp4blpC?=
 =?utf-8?B?ajczQk1ZOXB1d2Y2MHJ2ak1POElRV3lOSGl5R2VlSSsvRkluc1pHeGVTN0Vi?=
 =?utf-8?Q?g9VwXRYe/3LAZX7SpvTcxKSGIH0b4QcUfPcfk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VFlhWW5PWnJqRlQ2ZmltajU3bExrZDBsUEFNQXdsaytuem5aZzJwZlpnc2tm?=
 =?utf-8?B?cjBVcmRndk4xOVFuaW1iVmtiQmdqaGVhSUhwWlJqSitvNDJJVGRTbHUxemQ4?=
 =?utf-8?B?aUpkM1N2bG9WZGRsQkFwWWIvdldsY0hzSVA0UFhFOXRDWS9QdHpzSXdPa3Mw?=
 =?utf-8?B?K2VEUFcxeStPUFJMaVF3VnQxdzZ2eXhHR0Y1c0FTeDNUSVhBT0xlN0xnZHF1?=
 =?utf-8?B?MVR0dml4aCtraW50eEgyRzV0MXpxN3U4L0xHMjhnRTE2bTZmaldFblN2Sisw?=
 =?utf-8?B?MVRaOUpqVTJBL3BPY3RteFR3VnQwOTdvU0p5eGM3dlFFcVlYTmRHc29SODhW?=
 =?utf-8?B?R1dtRk1TYXJ2ZitlZTFnQi83TnpXcXpGcnVha3JLNlZLaUxHbmxHcVpTZ1M3?=
 =?utf-8?B?eDJueHhEMk5PYlMzM2MxemQ4OEIxWlNEYlhDYmdOUWorbUtsNTlyaVI0WTFP?=
 =?utf-8?B?RjYraFlFZnRTT1djOGxSR3Rpbk1tbTFtRXd1WjBIVHBYa3JMTDk5OXBQMktP?=
 =?utf-8?B?TE5Kb0ZLUzlKYTRsUWlzNHNCbGx3WUhmUlFrdDFIbEZmdUY4cnh3SzFoaWlD?=
 =?utf-8?B?MzN5WmUzQmxoVGhsT3I0QTZpakZwdkNYa2ZQTlU2UFRNNS8rU2E5eEVUNTd5?=
 =?utf-8?B?MWxHSjdzUUlnYk9HM3VFdjgxbkVhZFdaeU8zMzlhZGRlRlFOaFBzbUlnaElk?=
 =?utf-8?B?SHRxWGJxTXg5RDlTNU1FVVZRWjR3MkxHa0RZbkxKdDJEYjZZd05ETkJWTW1T?=
 =?utf-8?B?bngxMldNNlloQW9YWUVURW10bGhCeXF2OWxUNjV1QTJFcFJ4TFozR3p5NXdz?=
 =?utf-8?B?Z1g0enBZa1FTMXhyRWhqTHFoWTlrRExkbGE3NGhBRlR1anUvek1jYjlhM1Bh?=
 =?utf-8?B?NGZNMjNIWEJDU0dHaXFZLzJBemlWaHFDWWFRWTBkNithVnEyczl5VjVMRHpP?=
 =?utf-8?B?QjVKTWxFWjRjY2k0dFUyOUNtcFN4Uk5HQnMzUzVSSFRpb2I0TnQ2RmZqYmVi?=
 =?utf-8?B?a1M2WGR1di9vNEozOEtkSVN4WFh1Y2xCZmE1TW1xZGxmUlVYdWJaM09YdVhO?=
 =?utf-8?B?dm5kVDNCNzhiRkUza3BMNFZaQ0d6NXlnVDJGbUJ4S2RyMUFTMm0ybitMWUVN?=
 =?utf-8?B?QUw1b1dqaHRIT3czNzg3TkxqM3RhOWRCckpoZk5rL2NzMUFKZzA0NFV0dld3?=
 =?utf-8?B?MnF1UlFQakNkU3h5aXZ2ZTYzajRiclRwR2srODZhYWp5RGY3N2pJbDFhVEhk?=
 =?utf-8?B?TzVIQ0R3VkR5RXVXWmJZa2pGZld2RXZ4YVFKRGJ6cTY4YmtjSkk3SXU5V1hK?=
 =?utf-8?B?NHgvOEE2Tjg0UDAraFYxMVRpa1pncHJkM3V0azI0U2cwTWI0SVdMYitidTlV?=
 =?utf-8?B?OWViL3RvK0poNG0xa0dkTGFmaWNNTml5OS9aQ09ac29xM3ZrcEY2dGdQYVpq?=
 =?utf-8?B?OGdRc3M0WDZIWWM4MHpzcy95OGVvOFkzSXdQR1hWWlhTMUxWK1oxdlBwL0t0?=
 =?utf-8?B?WXpLUUVXa0V5clQ2aXkyL3BrWHFjQlZ5Mjd0aUpzeU1iS3hUQ2RadDlZdGxu?=
 =?utf-8?B?dUVVZWxIQ3VDZ2lQUFcwVHBubE9tbHQ0UFJZWjRoRUhTYVYxejJaUnRhRWM3?=
 =?utf-8?B?ZHEwR1owdTh5aVkzVU9hYm1lSjR6TWMwaXBJWDFyZDRnOE56am1uZ0FYVXlE?=
 =?utf-8?B?QktFcExsK0MzSmFKTUdtRTdjTDJicTFLZi8wL3dMU3RxNm5mNE51c25qYzFJ?=
 =?utf-8?B?TFo5cW9rdkQxSFJkRzdvT3p6Tmh1U1lnOTZqREw2R0lraHJ1eGRub3NJdnY1?=
 =?utf-8?B?V2xsNGtFR29pZWFJa1lUMUh5cFNDeTFKL080ZGhCZzNyd01KSXJyRUkwSVUr?=
 =?utf-8?B?SGhSaWxkNzR5L0YrNXRBOFVXYit6TEJ6ZGIwM0tReXl6SzVoMmZTMW5vTzN2?=
 =?utf-8?B?aWYxM2M2VDZJdnhXVzlRYTlIUU9UN0l1MEdsRU9yTlE4d3NEaDhpZlYyTjU4?=
 =?utf-8?B?YXlzVnA3TklYZHQyUDU2VFlNY1NKU2IzeXdOb2xROXU0WXF0NnQvbmplYlVu?=
 =?utf-8?B?czR3cHNxZWVKOFZYVTJmYVdvSkdrS1ViNmN2VkpMUE9QTXkzd1VCWkxtd3N5?=
 =?utf-8?B?U1NTRTBvL1RDTktoVzdPVUhnOGlTNDNxaElWTUVaeVFrVWZUNTBOc1liSlNk?=
 =?utf-8?B?Q2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E56CD706ACE0F1439F02A52DA04CF148@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da7af2ba-850a-430b-3a28-08dd04f3ed0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2024 21:33:05.6486
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6in1iiz/sQxdN4zUnchIj7gE3T2ldyeISmvvJME1dUoIbjq1045nP3W/C8Clr36I757Q+bZKlgd1caQBXqcBOOTtiBUPQd+lvG7TSKE/ObE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7740
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA4LTMwIGF0IDEzOjQyIC0wNzAwLCBLZWl0aCBCdXNjaCB3cm90ZToNCj4g
RnJvbTogS2VpdGggQnVzY2ggPGtidXNjaEBrZXJuZWwub3JnPg0KPiANCj4gYmlwIGlzIE5VTEwg
YmVmb3JlIGJpb19pbnRlZ3JpdHlfcHJlcCgpLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogS2VpdGgg
QnVzY2ggPGtidXNjaEBrZXJuZWwub3JnPg0KPiAtLS0NCj4gwqBkcml2ZXJzL252ZGltbS9idHQu
YyB8IDMgKystDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlv
bigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbnZkaW1tL2J0dC5jIGIvZHJpdmVycy9u
dmRpbW0vYnR0LmMNCj4gaW5kZXggNDIzZGNkMTkwOTA2MS4uMTM1OTRmYjcxMjE4NiAxMDA2NDQN
Cj4gLS0tIGEvZHJpdmVycy9udmRpbW0vYnR0LmMNCj4gKysrIGIvZHJpdmVycy9udmRpbW0vYnR0
LmMNCj4gQEAgLTE0MzUsOCArMTQzNSw4IEBAIHN0YXRpYyBpbnQgYnR0X2RvX2J2ZWMoc3RydWN0
IGJ0dCAqYnR0LCBzdHJ1Y3QNCj4gYmlvX2ludGVncml0eV9wYXlsb2FkICpiaXAsDQo+IMKgDQo+
IMKgc3RhdGljIHZvaWQgYnR0X3N1Ym1pdF9iaW8oc3RydWN0IGJpbyAqYmlvKQ0KPiDCoHsNCj4g
LQlzdHJ1Y3QgYmlvX2ludGVncml0eV9wYXlsb2FkICpiaXAgPSBiaW9faW50ZWdyaXR5KGJpbyk7
DQo+IMKgCXN0cnVjdCBidHQgKmJ0dCA9IGJpby0+YmlfYmRldi0+YmRfZGlzay0+cHJpdmF0ZV9k
YXRhOw0KPiArCXN0cnVjdCBiaW9faW50ZWdyaXR5X3BheWxvYWQgKmJpcDsNCj4gwqAJc3RydWN0
IGJ2ZWNfaXRlciBpdGVyOw0KPiDCoAl1bnNpZ25lZCBsb25nIHN0YXJ0Ow0KPiDCoAlzdHJ1Y3Qg
YmlvX3ZlYyBidmVjOw0KPiBAQCAtMTQ0NSw2ICsxNDQ1LDcgQEAgc3RhdGljIHZvaWQgYnR0X3N1
Ym1pdF9iaW8oc3RydWN0IGJpbyAqYmlvKQ0KPiDCoA0KPiDCoAlpZiAoIWJpb19pbnRlZ3JpdHlf
cHJlcChiaW8pKQ0KPiDCoAkJcmV0dXJuOw0KPiArCWJpcCA9IGJpb19pbnRlZ3JpdHkoYmlvKTsN
Cg0KSGkgS2VpdGgsDQoNCkkgc3VzcGVjdCB0aGlzIGlzbid0IGFjdHVhbGx5IG5lZWRlZCwgc2lu
Y2UgdGhlIGJ0dCBuZXZlciBnZW5lcmF0ZWQgaXRzDQpvd24gcHJvdGVjdGlvbiBwYXlsb2FkLiBT
ZWUgdGhlIC8qIEFscmVhZHkgcHJvdGVjdGVkPyAqLyBjYXNlIGluDQpiaW9faW50ZWdyaXR5X3By
ZXAoKSAtIEkgdGhpbmsgdGhhdCdzIHRoZSBvbmx5IGNhc2Ugd2Ugd2VyZSB0cnlpbmcgdG8NCmFj
Y291bnQgZm9yIC0gaS5lLiAnc29tZSBvdGhlciBsYXllcicgc2V0IHRoZSBpbnRlZ3JpdHkgcGF5
bG9hZCwgYW5kDQp3ZSdyZSBqdXN0IHBhc3NpbmcgaXQgb24gdG8gaXQncyByaWdodCBzcG90IGlu
IHBtZW0sIGFuZCByZWFkaW5nIGl0DQpiYWNrLiBUaGUgYnR0IGl0c2VsZiBkb2Vzbid0IGV2ZXIg
dHJ5IHRvIGdlbmVyYXRlIGFuZCBzZXQgYSBwcm90ZWN0aW9uDQpwYXlsb2FkIG9mIGl0cyBvd24u
DQoNCklmIHlvdSBsb29rIGF0IHRoZSBvcmlnaW5hbCBmbG93IGluDQo0MWNkOGI3MGMzN2FjZTQw
MDc3YzhkNmVjMGI3NGI5ODMxNzhjMTkyLCBidHQgbmV2ZXIgYWN0dWFsbHkgd2FudHMgdG8NCmNh
bGwgYmlvX2ludGVncml0eV9wcmVwIGFuZCBhbGxvY2F0ZSB0aGUgYmlwIC0gaWYgaXQgaGFzIHRv
IGRvIHRoYXQsDQp0aGF0J3MgdHJlYXRlZCBhcyBhbiBlcnJvci4NCg0KU2luY2Ugc29tZSBvZiB0
aGUgcmV3b3JrcyB0aGVuIHRvIGVsaW1pbmF0ZSBiaW9faW50ZWdyaXR5X2VuYWJsZWQsIGFuZA0K
b3RoZXIgYmxvY2sgbGV2ZWwgY2hhbmdlcywgdGhpcyBoYXMgY2hhbmdlZCB0byBhY3R1YWxseSBh
bGxvY2F0aW5nIGJpcA0KYW5kIGNvbnRpbnVpbmcgaW5zdGVhZCBvZiBlcnJvcmluZywgYnV0IGNv
aW5jaWRlbnRpYWxseSBzaW5jZSB3ZSBhc3NpZ24NCmJpcCBiZWZvcmUgdGhlIGFsbG9jYXRpb24g
KGkuZS4gTlVMTCBhcyB5b3UgcG9pbnQgb3V0KSwgYW55IGZ1dHVyZQ0Kc3RlcHMgbmljZWx5IGln
bm9yZSBpdCwgYnV0IGlmIGl0IHdhcyBzZXQgYnkgYW5vdGhlciBzdWJzeXN0ZW0sIHRoaW5ncw0K
c2hvdWxkIHN0aWxsICd3b3JrJyAtIGFzIGluIGJpb19pbnRlZ3JpdHlfcHJlcCgpIHdvdWxkIHJl
dHVybiB0cnVlLCBhbmQNCmJpcCB3b3VsZCBiZSBub24tTlVMTCwgYW5kIHdvdWxkIGdldCB3cml0
dGVuL3JlYWQgYXMgbmVlZGVkLCBhbmQgdGhpcw0KaXMgdGhlIGhhcHB5IHBhdGguDQoNCkRvZXMg
dGhpcyBtYWtlcyBzZW5zZSBvciBhbSBJIG1pc3Npbmcgc29tZXRoaW5nPw0KSXQncyBwcm9iYWJs
eSBpcnJlbGV2YW50IGlmIHdlIGRlcHJlY2F0ZSBhbGwgb2YgdGhpcyBzb29uIGFueXdheSA6KQ0K
DQoNCj4gwqANCj4gwqAJZG9fYWNjdCA9IGJsa19xdWV1ZV9pb19zdGF0KGJpby0+YmlfYmRldi0+
YmRfZGlzay0+cXVldWUpOw0KPiDCoAlpZiAoZG9fYWNjdCkNCg0K
