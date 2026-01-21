Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1331D32572F;
	Wed, 21 Jan 2026 05:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768972336; cv=fail; b=YuDb6egriAI8MyoddQnbwqxeBFXWyHPdbqkXVbTlSTIM82vjZLAsAWxcUEe1SjpGmL6Mb2m9vmqMYFZKDkInFhqfKJQsmS7bZT1xIgzido++4OchNBxbpTPb5XopGKNOoHpLVWK+w17m9U0oFEnyl859uuYZD26rfve4z+rDwLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768972336; c=relaxed/simple;
	bh=OT1wyaoa1i6AMkd4djvTxB7sMz3DsoqD3vnr6R9CziY=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=E8e59jU/MkRvHKnCC2BtMTLdYKwhf1rGh1oijtmieC87I8huLNSHnNkd4/rmpvxFyvn/DPdjL0mjD/ue+eKT5PXLjTXfwgycLVtURhfXKb7FdTtsH3aeh5viZfl3HYa/MyDe2gFHkMKxFWHEC2KQ6R7opBKttsLav+qizly9Dp4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wleg0179; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wleg0179"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768972333; x=1800508333;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=OT1wyaoa1i6AMkd4djvTxB7sMz3DsoqD3vnr6R9CziY=;
  b=Wleg0179gC6YjAotEk5v7O/vb5SuP37yuGThUqBz7Gsf8D07rnzY07V4
   fJl+y45fUCtRPqEsdgPRyPGaUfrhFxSgEh+Gs5aDJ3rmCU8mUVJ7d+gZS
   kBPBQmPnJvcNNW7G+abjQ4pEIs8txgYMSnxrwZgaKNc+K59yDvlfx46LL
   H9tUfyER2DDtYNQcoOw9mwmtzUWP6fb/qAASB/4V/3TWFlW3tQM+amIV6
   LOKdCyJbj6A4Kk2gsa1zVp95oXC8V3+5JOK2toMN3JX3r1C7I66wGJh4o
   H2LKlrmwDLk+pjVAgD8jwlO6AeCy9/g1wMBUv6U2RosfKoEhZiAG7LJZf
   w==;
X-CSE-ConnectionGUID: Bd1sI1buQXWVDBjpRhrfcw==
X-CSE-MsgGUID: pTqksLzgT3KdPam4WYTs+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="81302666"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="81302666"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 21:12:12 -0800
X-CSE-ConnectionGUID: GmmbQl+gTJSuI7RcP79evA==
X-CSE-MsgGUID: ON+8X7+JTYmcHDt7r+OrtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="210833230"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 21:12:14 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 21:12:12 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 20 Jan 2026 21:12:12 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.9) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 21:12:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pEXnk+p5TRCrDUtcT/76P3f6+nNNq0Pm+tWER4UgpID9FxCGUeRshV4rYCFIgQJyWnhdtHprM165HOKIaZ3f2xqRBrExFHvLm8Y/PCOmrhv4ZKZ9MdIPxQdhjiuAzuaOO0T8N5ih7l3ALY/cj1kYuWysHArAB4XngiH2ai4QPQNkooto1iCnO0GIoVHTfg9GC/8QOWX0hphs06+WUY3J/l2uduP4BXoDZpnZiCkEo7UhBmv6dW2ocYJnWcfg3IbiioUdDZWGL/+xdT50VaJt+rLfyZ4Ad0YcPL3pT2qVX1WDVWn9JjfsG4VzLDuiN9NgZlhtZFpVP6/zBuA0D9RM9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZaONvekS5YNsE7S1HEg2ynmdqKBXIAjH2xyWH3D0e0o=;
 b=bNCayncEycIpe+p+7H78QeeV+h2NojxPCb9OgG/n/AdwhusWokRzrsbqNEwbpciIiaGI5A/Bs4sHm+Wu98tsjKUBTg0zsUyfxY3ONTnIaAOMh93zpOE8YoU1dpuc4wUPjqzBqLhDo0FKRmpWD9JE9uJkJaremKc31Gh1jy/PUybg3Yfn7qJ1L9djv1ueXbzrUxD8UIp9F8XZpiElOwMrTz9n4Ci1SrsrDosiQ6VTlWCC0f+SkJ8OtJfHZCN15IYxgIzOKee4KafTXe+PJyHqaxwZsHSRqwabuXhPHw4wXjv3tiIj4LSAuvgJfoGq6Bnv6oV1PVEJ5g3d/Zk8YrsaBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by CH2PR11MB8814.namprd11.prod.outlook.com (2603:10b6:610:281::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 05:12:09 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 05:12:09 +0000
Date: Wed, 21 Jan 2026 13:11:58 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>,
	<linux-cxl@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, "Smita
 Koralahalli" <Smita.KoralahalliChannabasappa@amd.com>,
	<linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<oliver.sang@intel.com>
Subject: [cxl:for-7.0/cxl-init] [dax/hmem, e820, resource] bc62f5b308:
 BUG:soft_lockup-CPU##stuck_for#s![kworker:#:#]
Message-ID: <202601211001.82fe0f1b-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: KUZPR04CA0027.apcprd04.prod.outlook.com
 (2603:1096:d10:25::19) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|CH2PR11MB8814:EE_
X-MS-Office365-Filtering-Correlation-Id: 23f648a3-529d-428f-a58b-08de58aba09c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?98u38XN7oy1XDTreNbNKcjAXmpCoBuEMsWZE9EABgyaXZkl+eZxGXHEhaFfu?=
 =?us-ascii?Q?ajkRqyI7ky5e3j7r7SnOZ+K5plTzMFrdO9oaOjfLGvDDvsjJiZAMThe+swXZ?=
 =?us-ascii?Q?uh+kzOjrt728N/gvsQf+AYxH3kVBrzawD+BrTtVrr5aLSEQHcHyOmspJE5wi?=
 =?us-ascii?Q?8XT9McfkH3AfzIrhhcKKkHVViQogIuWJKzj/BuY7Sn+U0kAQ2OvrbjkBC+/d?=
 =?us-ascii?Q?abPFYwP/Qn/TPsRleKO4SzFfnkAslIGvkOkOuOJxW4YeCihdaI3PkOcXhZlw?=
 =?us-ascii?Q?lKeCP20H5kXPR6uqFusbs/SiL4Kb8bpVG1NRPXDy+j5Yj3zqH0KOt4cucOEd?=
 =?us-ascii?Q?i+iNkJqxvVufF87gYow4eEH8QwRcB5I8gTkGTn9jiLdRek0kgAoJHnnE6w74?=
 =?us-ascii?Q?7PV9DWyMAlx+zehsRsC5EhzP5JNsjM1QU9KNhWCsrlkOWNhxKk1JfgKWzfOu?=
 =?us-ascii?Q?pSbf4uTZ3p8asOI3ue/M1WbXAUgAlDq/KDSb2+R9VcCNPAQA9XtyygJlLxMx?=
 =?us-ascii?Q?EnYH0v0QgnSrrxinWgFkoib+M388gxshaDR5lb25z04eb1f4KGwZPH+f67ki?=
 =?us-ascii?Q?YYt77vQV8y7+LRn3++6YeiFwhU0/OF92o+qGqGM5TFVicTN2EmWp0CHQoWzC?=
 =?us-ascii?Q?/JqLAkhKU++4W4eccRK7qWXpWYSkwK/T9wlot1IA64MDBqqVqmN4gjrijOoB?=
 =?us-ascii?Q?Mq9602RQYPgW6gQUCHGXqB16umUmum9B9vYxNVsm5M6wmnSXN0K1RNCyOJjQ?=
 =?us-ascii?Q?MhydGO0aFHdvqVWrN+OMswqv5a/EmWE3ZSDQi+XY/1HrG98AdbYc0H55toMm?=
 =?us-ascii?Q?05nFS4CYkXyfYQGHyiSpDegLPwd6WyTjOA+uIKlgsN7Wa15yFZm9r5MLZV+M?=
 =?us-ascii?Q?vGGXHIbUdUa/Ir9No07b0ea/xHdaLhT/fLspO8rshYX9lE3G3GCuNEMlSsQH?=
 =?us-ascii?Q?6+79nj/3h4aK1Y/ufITFSeZtNgfd67sjCjj6gM88iirlPTg7Nfy46/l9j7t4?=
 =?us-ascii?Q?DzBRkSWEhUdT32ODEYoxhTlDJvlKZ0CFuhbAoRoXHXarhTLl3/W6JzemOA/N?=
 =?us-ascii?Q?7SFJ2AV2Igeg22Vh4oODLToQzdSVtj0gvc1jp3osXdAa5WbxyjX8gb4Siyip?=
 =?us-ascii?Q?hn8ZoGiyBekvaP10RoHujz1W+VEmgx4w/23YjWyfNJdt9wILe0xCM7hjNYqR?=
 =?us-ascii?Q?HqDsj/clYZkNiJpKk2zwmoKysjemaJh7WZynDZrpXsPhzBHx2RnfsWfH9ifL?=
 =?us-ascii?Q?Hta/OLoaQLCp2IvUYbnTSc/mgZeUi2IQqoztC/Im9VLfy0Gpq1mx+kN+3GwP?=
 =?us-ascii?Q?UpvYTT6oLDAW1u1x0ynwmEEVHXmYuYVRnbZBV1J/1zg8JqT9rM+V3v2t8HC/?=
 =?us-ascii?Q?q0+nD4AAgrC+sKa24hldbEMuCwOJZMtAfHN1ATO497fGa9b8g0YH+PRuQF1S?=
 =?us-ascii?Q?VE1v/6j7Os5qrqOGTmsUB5QKvR7eTpQEvGbRBni+dNmPRfx/ZbTx5dlGEX25?=
 =?us-ascii?Q?blQjDoQWter072f/DkeorUq96dprevasQzq8mET1jAU+l/bvG96chTLw0rnK?=
 =?us-ascii?Q?KxizZT1wX4lKTgkWE2/hclPbQUgs8+Kzi9CSMzrL?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FlXdn5fCuBgfSsxjEmYOsJUwgNQSrTz/xh0DS3YlCkkGJVcyEbum3hAuZuGZ?=
 =?us-ascii?Q?z+8+T3vGRF4Xz4imshqoyOKG4zdBji5xgtdKxvHtcHjjwjFA/ofIH5izh2kg?=
 =?us-ascii?Q?FoWYl1LxqWZnAq41uV45WXT1+7O4pZY7wV/Rlw4i/mV9iDpfm1cdEZ/DkCdQ?=
 =?us-ascii?Q?aJ5EvW5h64EaHv0sKMP/sDuRi0hHf2QCZSX8Vs9FjmIgDWJ7QVPVb8AVJb13?=
 =?us-ascii?Q?J4bNA/SUvxAy9oJHi0IjqrozuWZLkIWVpbegjvJGURIPBbvnGUaN8Mi/G+uP?=
 =?us-ascii?Q?UoB/O4G0FQGl980xjsdG/ZFRQgJaVSZu/vuUOtL1I8xthbheCHduHtmv4s41?=
 =?us-ascii?Q?k/ahU07lx39+AnRZIZ5azRKNW9OTAyf0NNrfrb/e74M+WHoXCjYIHllgkUGz?=
 =?us-ascii?Q?8h3eY7T8bHY1EyRUoJyn5kQrulCLspWBuUmzicffR8Ezp8LfZ5aRJXENjG62?=
 =?us-ascii?Q?yHtEQcZFdJCU+6RzqEhAuFwpWL4vVV2TwVl42/0KEtjsPWQMA5HFIZlgjJMi?=
 =?us-ascii?Q?FBGAtQm0HuzQk2pToEp+hg9zO6Pwo5PudHPkgHI6Z7LGgu7zVGSuunpsMk+h?=
 =?us-ascii?Q?BC/2TtF6UX84H/fNe+LK4RSsKOVyyIQ8ejY4jQ7v2S8oSFBxxI0j2eUOeeVB?=
 =?us-ascii?Q?s5UhlNbQ/BdXfJ/zG7ycPOsyFId9jpUe0Ws1WGNnPZBI4ScHeLwtvnAl5TuU?=
 =?us-ascii?Q?kdS4FlyefqG5FpJ7/GtfL8RY97s5x+cgUM0t0839w61Z5RcPLquISmAyDbfz?=
 =?us-ascii?Q?bTOuqZaWxramHxCKR0rSEx4unc23d5DOsJPpn1fMLSOd5SuKDSf1Tm7bpJvF?=
 =?us-ascii?Q?4bcXpNGo7BvyOY9Y6ogQQ3zBzZiVgfUlFEjPZR7RIZgJsYTA/Zv1Khsvxgsf?=
 =?us-ascii?Q?LJSIcrvcEl/kKS6v0nB3t5fuDhGU0xlEh6D6r6JwLoppeP96N1DBUyTmiKjH?=
 =?us-ascii?Q?Iycy+f4wqCKIwpsC3jo20oyVJjUqwW8/Odx/M/VOHK6mkNAf9OMrZT2QIp/T?=
 =?us-ascii?Q?PlW+ZxITDIMQUV1cLUF/vpRaP3sv/EBdv85eRFGZj+FytuM93cPQrbaSewrt?=
 =?us-ascii?Q?671i0QYGtJG+lqWKZPfWSxWkttk9/ZHVPzwR0eqVBp7gPool0DMwp7pcEElj?=
 =?us-ascii?Q?ErAp6AvJvWitteFDdJKrDDzdLCbmawqjWw6afVFZU1pp9PNYciOzF9PDoJ53?=
 =?us-ascii?Q?sII4QD76A7oCzqj0F/oD0krfXWFTpxR1p4i1exC/KjkN8lDP8fuEXTlJNByk?=
 =?us-ascii?Q?RdncCOGB6fE+xkH2vNbQpIUlYoEl+4HZgv3eKoEifehKaAT3mI6g5xIIYNKn?=
 =?us-ascii?Q?HIkwT0nT/mhy8IY0JafcETXuy28TBNVjsbDxjCOWlu/S5iyTsoaBQFuw7oRq?=
 =?us-ascii?Q?wDJi3TTrgYjDrLpjZniAhi1H3TVx+vGCiqO9kpt1kI4MbkMp3IcneELLPmff?=
 =?us-ascii?Q?T1gDrI3UY8edDs/MujYJkPCKCw0bI/ZXZ8HwYsmVWpg84+8p1i4fdWTj8tMc?=
 =?us-ascii?Q?OLG5zlFnsuqIUBPUgRuSSAVG3vQTfqrjH2WWYNLu5Ua1rnPHw+jQKruBnT8b?=
 =?us-ascii?Q?XYDZHoZFUUw/hyUbemOs+fAEQ/QW+cx1uEZhp+Zk4MG+PLSWoG4+3DDAMTRy?=
 =?us-ascii?Q?fsARqveO0FF7XCt1N6jF4D2PtcfhOiZhbaKq8uk0S3KNA/4Pc0Liqe17Q/Ya?=
 =?us-ascii?Q?zib20KfWQu1aqW8do9LXBIRRXixx3FjplBo4S8Kj9FwRIC5f6vZXCHpdYfkt?=
 =?us-ascii?Q?ivTU30G1MA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 23f648a3-529d-428f-a58b-08de58aba09c
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 05:12:09.2800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XKX7cMxs2IJRXQMMpJ65hviMIAnpO2zDAu3CbYA+gmFXQDu3pab3S26q8qA7BLsIL4hFmWaQOPL3NKLVLEG0IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB8814
X-OriginatorOrg: intel.com



Hello,

FYI. we don't have enough knowledge to understand how the issues we found
in the tests are related with the code. we just run the tests up to 200 times
for both this commit and parent, noticed there are various random issues on
this commit, but always clean on parent.


=========================================================================================
tbox_group/testcase/rootfs/kconfig/compiler/sleep:
  vm-snb/boot/debian-11.1-i386-20220923.cgz/i386-randconfig-141-20260117/gcc-14/1

29317f8dc6ed601e bc62f5b308cbdedf29132fe96e9
---------------- ---------------------------
       fail:runs  %reproduction    fail:runs
           |             |             |
           :200          2%           5:200   dmesg.BUG:soft_lockup-CPU##stuck_for#s![kworker##:#]
           :200          2%           5:200   dmesg.BUG:soft_lockup-CPU##stuck_for#s![kworker:#:#]
           :200          8%          17:200   dmesg.BUG:soft_lockup-CPU##stuck_for#s![swapper:#]
           :200          2%           4:200   dmesg.BUG:workqueue_lockup-pool
           :200          0%           1:200   dmesg.EIP:__schedule
           :200          0%           1:200   dmesg.EIP:_raw_spin_unlock_irq
           :200          2%           4:200   dmesg.EIP:_raw_spin_unlock_irqrestore
           :200          6%          11:200   dmesg.EIP:console_emit_next_record
           :200          0%           1:200   dmesg.EIP:finish_task_switch
           :200          3%           6:200   dmesg.EIP:lock_acquire
           :200          1%           2:200   dmesg.EIP:lock_release
           :200          1%           2:200   dmesg.EIP:queue_work_on
           :200          0%           1:200   dmesg.EIP:rcu_preempt_deferred_qs_irqrestore
           :200          1%           2:200   dmesg.EIP:timekeeping_notify
           :200          0%           1:200   dmesg.INFO:rcu_preempt_detected_stalls_on_CPUs/tasks
           :200          0%           1:200   dmesg.INFO:task_blocked_for_more_than#seconds
           :200         14%          27:200   dmesg.Kernel_panic-not_syncing:softlockup:hung_tasks

below is full report.


kernel test robot noticed "BUG:soft_lockup-CPU##stuck_for#s![kworker:#:#]" on:

commit: bc62f5b308cbdedf29132fe96e9d591e526527e1 ("dax/hmem, e820, resource: Defer Soft Reserved insertion until hmem is ready")
https://git.kernel.org/cgit/linux/kernel/git/cxl/cxl.git for-7.0/cxl-init

in testcase: boot

config: i386-randconfig-141-20260117
compiler: gcc-14
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202601211001.82fe0f1b-lkp@intel.com



[  674.140379][    C0] watchdog: BUG: soft lockup - CPU#0 stuck for 626s! [kworker/0:2:18]
[  674.140379][    C0] Modules linked in:
[  674.140379][    C0] irq event stamp: 192928
[  674.140379][    C0] hardirqs last  enabled at (192927): rcu_preempt_deferred_qs_irqrestore (arch/x86/include/asm/irqflags.h:26 arch/x86/include/asm/irqflags.h:109 arch/x86/include/asm/irqflags.h:151 kernel/rcu/tree_plugin.h:587)
[  674.140379][    C0] hardirqs last disabled at (192928): sysvec_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:1056)
[  674.140379][    C0] softirqs last  enabled at (192850): handle_softirqs (kernel/softirq.c:469 (discriminator 2) kernel/softirq.c:650 (discriminator 2))
[  674.140379][    C0] softirqs last disabled at (192839): __do_softirq (kernel/softirq.c:657)
[  674.140379][    C0] CPU: 0 UID: 0 PID: 18 Comm: kworker/0:2 Not tainted 6.19.0-rc4-00007-gbc62f5b308cb #1 PREEMPT(lazy)  9b7ba6dd04fa63ebf0e343a2cc1c803e2e6231bd
[  674.140379][    C0] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  674.140379][    C0] Workqueue: rcu_gp strict_work_handler
[  674.140379][    C0] EIP: lock_release (kernel/locking/lockdep.c:5893)
[  674.140379][    C0] Code: b8 ff ff ff ff 0f c1 05 48 c2 ff c3 48 0f 85 95 00 00 00 9c 58 f6 c4 02 0f 85 aa 00 00 00 81 e7 00 02 00 00 74 01 fb 8d 65 f4 <5b> 5e 5f 5d c3 2e 8d b4 26 00 00 00 00 90 ff 05 14 e0 e7 c3 a1 5c
All code
========
   0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   5:	0f c1 05 48 c2 ff c3 	xadd   %eax,-0x3c003db8(%rip)        # 0xffffffffc3ffc254
   c:	48 0f 85 95 00 00 00 	rex.W jne 0xa8
  13:	9c                   	pushf
  14:	58                   	pop    %rax
  15:	f6 c4 02             	test   $0x2,%ah
  18:	0f 85 aa 00 00 00    	jne    0xc8
  1e:	81 e7 00 02 00 00    	and    $0x200,%edi
  24:	74 01                	je     0x27
  26:	fb                   	sti
  27:	8d 65 f4             	lea    -0xc(%rbp),%esp
  2a:*	5b                   	pop    %rbx		<-- trapping instruction
  2b:	5e                   	pop    %rsi
  2c:	5f                   	pop    %rdi
  2d:	5d                   	pop    %rbp
  2e:	c3                   	ret
  2f:	2e 8d b4 26 00 00 00 	cs lea 0x0(%rsi,%riz,1),%esi
  36:	00 
  37:	90                   	nop
  38:	ff 05 14 e0 e7 c3    	incl   -0x3c181fec(%rip)        # 0xffffffffc3e7e052
  3e:	a1                   	.byte 0xa1
  3f:	5c                   	pop    %rsp

Code starting with the faulting instruction
===========================================
   0:	5b                   	pop    %rbx
   1:	5e                   	pop    %rsi
   2:	5f                   	pop    %rdi
   3:	5d                   	pop    %rbp
   4:	c3                   	ret
   5:	2e 8d b4 26 00 00 00 	cs lea 0x0(%rsi,%riz,1),%esi
   c:	00 
   d:	90                   	nop
   e:	ff 05 14 e0 e7 c3    	incl   -0x3c181fec(%rip)        # 0xffffffffc3e7e028
  14:	a1                   	.byte 0xa1
  15:	5c                   	pop    %rsp
[  674.140379][    C0] EAX: 00000047 EBX: c54814c0 ECX: c5622508 EDX: ffffffff
[  674.140379][    C0] ESI: c122e710 EDI: 00000200 EBP: c562def4 ESP: c562dee8
[  674.140379][    C0] DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068 EFLAGS: 00000206
[  674.140379][    C0] CR0: 80050033 CR2: ffda9000 CR3: 047db000 CR4: 00040690
[  674.140379][    C0] Call Trace:
[  674.140379][    C0]  process_one_work (kernel/workqueue.c:3268)
[  674.140379][    C0]  worker_thread (kernel/workqueue.c:3334 (discriminator 2) kernel/workqueue.c:3421 (discriminator 2))
[  674.140379][    C0]  kthread (kernel/kthread.c:463)
[  674.140379][    C0]  ? rescuer_thread (kernel/workqueue.c:3367)
[  674.140379][    C0]  ? kthread_unpark (kernel/kthread.c:412)
[  674.140379][    C0]  ret_from_fork (arch/x86/kernel/process.c:164)
[  674.140379][    C0]  ? kthread_unpark (kernel/kthread.c:412)
[  674.140379][    C0]  ret_from_fork_asm (arch/x86/entry/entry_32.S:737)
[  674.140379][    C0]  entry_INT80_32 (arch/x86/entry/entry_32.S:945)
[  674.140379][    C0] Kernel panic - not syncing: softlockup: hung tasks
[  674.140379][    C0] CPU: 0 UID: 0 PID: 18 Comm: kworker/0:2 Tainted: G             L      6.19.0-rc4-00007-gbc62f5b308cb #1 PREEMPT(lazy)  9b7ba6dd04fa63ebf0e343a2cc1c803e2e6231bd
[  674.140379][    C0] Tainted: [L]=SOFTLOCKUP
[  674.140379][    C0] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  674.140379][    C0] Workqueue: rcu_gp strict_work_handler
[  674.140379][    C0] Call Trace:
[  674.140379][    C0]  dump_stack_lvl (lib/dump_stack.c:122)
[  674.140379][    C0]  dump_stack (lib/dump_stack.c:130)
[  674.140379][    C0]  vpanic (kernel/panic.c:487)
[  674.140379][    C0]  panic (kernel/panic.c:365)
[  674.140379][    C0]  watchdog_timer_fn.cold (kernel/watchdog.c:869)
[  674.140379][    C0]  ? softlockup_fn (kernel/watchdog.c:781)
[  674.140379][    C0]  __hrtimer_run_queues+0xa4/0x380
[  674.140379][    C0]  hrtimer_run_queues (kernel/time/hrtimer.c:1999)
[  674.140379][    C0]  update_process_times (kernel/time/timer.c:2455 (discriminator 3) kernel/time/timer.c:2473 (discriminator 3))
[  674.140379][    C0]  tick_periodic+0x33/0x100
[  674.140379][    C0]  tick_handle_periodic (kernel/time/tick-common.c:130)
[  674.140379][    C0]  ? vmware_sched_clock (arch/x86/kernel/apic/apic.c:1056)
[  674.140379][    C0]  __sysvec_apic_timer_interrupt (arch/x86/include/asm/trace/irq_vectors.h:40 (discriminator 4) arch/x86/include/asm/trace/irq_vectors.h:40 (discriminator 4) arch/x86/kernel/apic/apic.c:1063 (discriminator 4))
[  674.140379][    C0]  sysvec_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:1056 (discriminator 2) arch/x86/kernel/apic/apic.c:1056 (discriminator 2))
[  674.140379][    C0]  ? process_one_work (kernel/workqueue.c:3266)
[  674.140379][    C0]  handle_exception (arch/x86/entry/entry_32.S:1048)
[  674.140379][    C0] EIP: lock_release (kernel/locking/lockdep.c:5893)
[  674.140379][    C0] Code: b8 ff ff ff ff 0f c1 05 48 c2 ff c3 48 0f 85 95 00 00 00 9c 58 f6 c4 02 0f 85 aa 00 00 00 81 e7 00 02 00 00 74 01 fb 8d 65 f4 <5b> 5e 5f 5d c3 2e 8d b4 26 00 00 00 00 90 ff 05 14 e0 e7 c3 a1 5c
All code
========
   0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   5:	0f c1 05 48 c2 ff c3 	xadd   %eax,-0x3c003db8(%rip)        # 0xffffffffc3ffc254
   c:	48 0f 85 95 00 00 00 	rex.W jne 0xa8
  13:	9c                   	pushf
  14:	58                   	pop    %rax
  15:	f6 c4 02             	test   $0x2,%ah
  18:	0f 85 aa 00 00 00    	jne    0xc8
  1e:	81 e7 00 02 00 00    	and    $0x200,%edi
  24:	74 01                	je     0x27
  26:	fb                   	sti
  27:	8d 65 f4             	lea    -0xc(%rbp),%esp
  2a:*	5b                   	pop    %rbx		<-- trapping instruction
  2b:	5e                   	pop    %rsi
  2c:	5f                   	pop    %rdi
  2d:	5d                   	pop    %rbp
  2e:	c3                   	ret
  2f:	2e 8d b4 26 00 00 00 	cs lea 0x0(%rsi,%riz,1),%esi
  36:	00 
  37:	90                   	nop
  38:	ff 05 14 e0 e7 c3    	incl   -0x3c181fec(%rip)        # 0xffffffffc3e7e052
  3e:	a1                   	.byte 0xa1
  3f:	5c                   	pop    %rsp

Code starting with the faulting instruction
===========================================
   0:	5b                   	pop    %rbx
   1:	5e                   	pop    %rsi
   2:	5f                   	pop    %rdi
   3:	5d                   	pop    %rbp
   4:	c3                   	ret
   5:	2e 8d b4 26 00 00 00 	cs lea 0x0(%rsi,%riz,1),%esi
   c:	00 
   d:	90                   	nop
   e:	ff 05 14 e0 e7 c3    	incl   -0x3c181fec(%rip)        # 0xffffffffc3e7e028
  14:	a1                   	.byte 0xa1
  15:	5c                   	pop    %rsp


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260121/202601211001.82fe0f1b-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

