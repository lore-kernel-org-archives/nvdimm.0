Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C7024A7E8
	for <nvdimm@lists.linux.dev>; Thu, 16 Jan 2025 06:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737009205; cv=fail; b=IOr7ysP1QshZy21yssspAOj5fWYhyJM62m7JQW+Jn3Pec2IziP2IVWm8r4liIFLOB08YAEnKgM27ae5xrAJnZRAmjf6Vu+XhE0cm5LLO+ZaajMtUCgYglcPvjYjXyjlSG4AqsAK1H22EHm0frOWaPF1jSxFgt4KV1XmyQed0O1I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737009205; c=relaxed/simple;
	bh=cfO1t+DQw+8If2lfZ8fLr4XqZzQfsQE3Q7OszMc3aIk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bC9RciZafjdAcIpStRGfAiCCYppr8A8vEszTHISgriwo62xvloDFxqYgSMDAfu7CfgJtihcxAmHL9/Ms4rB9SOhOvMnPhYcnR8uAc1BLrDPP7BNRuNbqq9WRMZYj8IBI+wJB9PUMFWOZFbvjwg+Va2h24/4N006w6I9jnc/vmpk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W+69xn8M; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W+69xn8M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737009204; x=1768545204;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=cfO1t+DQw+8If2lfZ8fLr4XqZzQfsQE3Q7OszMc3aIk=;
  b=W+69xn8MKie+J6R8UuVynj7gHpGmhbB0ZebE9sFy6INJzcyTlSKY68T6
   lvZLIxEUZfa5kPKCK203fBe81nNg4tUE0tg1r/PAsh3d0sj90/keFPGq4
   kWELUuV86w9LA3F4Nj/rSqMD8dbru9wCpWRJ1e4DzGY+Fpkpej4zovz50
   k7UEZzATlxNOV2e+J2Y32INXCIIabBBY48rcjMfppeFb+Oc4badmWVWPJ
   Attvz/wdwLwDDKSAr7ZDcuV17HLj6rqvho6x/k5nqWDimqf2GK8ppKkD5
   86mzoyoZHcRNfB3IKQMbCkyRjF2JIj8LpHpgkABk+sZSzdzQhv7D7mCdm
   Q==;
X-CSE-ConnectionGUID: 3m8zH3V5SPqUTtpo+/oNSw==
X-CSE-MsgGUID: zcEvlSb9T767RbaNxi+2wg==
X-IronPort-AV: E=McAfee;i="6700,10204,11316"; a="47866632"
X-IronPort-AV: E=Sophos;i="6.13,208,1732608000"; 
   d="scan'208";a="47866632"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2025 22:33:23 -0800
X-CSE-ConnectionGUID: v9zRKYMbTxSYf6QFwg4aHg==
X-CSE-MsgGUID: qzfDw9v2SsOY9w6SaCfXGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,208,1732608000"; 
   d="scan'208";a="105151619"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jan 2025 22:33:23 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 15 Jan 2025 22:33:22 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 15 Jan 2025 22:33:22 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 15 Jan 2025 22:33:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FU4ifvGt/u7i9BouWx44IfjmW98C7t7p2y3GqkL763yU3PlMLMJQOlgJ1zAqLGnWaD5k03RsdzFai0WbtYGFvHJP27MSYlHeFJBVfIPCqHK3xhbaceaj8e/1HAYy65d2WQ8fRQhf9dLermMP/2uX8fqxGzcgtnfNK14Z2WUEPTBk+AYiBDdr+fLIhXYVt1pujj2lniRiw2P2Pr/B0clJYGBLZMlHiDp/Mlos2+RKafSSFMrCaGd0GLX4e3Hic7lRAIAW6KoPrrIs2icqiEdO1UeoIYJyKjsXw8MQR+GO2HJUcGfGKMtfcMD4Fvlm+dgh7cFeZxTvY621Exa4VLM/PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQcQ44/IYRtBCGlTsXFtfYMsFC6RpUK5ofmkgIiraZ0=;
 b=I7Y9/n5I5KiZ3TsMO1gleQ+SNc4x49dSSNolL1epwCJtiD+294gO+dNuPzdm2BXrnx2UzlfD59ZJCQTrvbPjlJyUxjgKVau1iEZbflyPH0OBc/PyUhLC0Z/TUJ2LZdKAZcliD5ypMYFExoctZeZSWDew3fAxuV2+2gA37LGqeE7l69ORuZiv7Swb6O13ghoRvdvGWK0dbJIZpHVoG/TMjqJtVZ71tCfHliH+8Dfd+jhz/tCyJDGy3sZzq+xazPDgZr9PYoN+1zL8JcxvKcsgkHGLTE3F+AEo+zH0LQ7zmj95UOBKIEYDMSaDjmfDmA5W/dQF0DArvpZXzhX1m96zzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SN7PR11MB8284.namprd11.prod.outlook.com (2603:10b6:806:268::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Thu, 16 Jan
 2025 06:33:20 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.8356.010; Thu, 16 Jan 2025
 06:33:20 +0000
Date: Wed, 15 Jan 2025 22:33:17 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Alejandro Lucero Palau <alucerop@amd.com>, Dan Williams
	<dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Jonathan Corbet <corbet@lwn.net>, "Andrew
 Morton" <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>, "Gustavo A.
 R. Silva" <gustavoars@kernel.org>
CC: Davidlohr Bueso <dave@stgolabs.net>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<linux-cxl@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-hardening@vger.kernel.org>, Li Ming <ming.li@zohomail.com>
Subject: Re: [PATCH v8 02/21] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <6788a82d2455a_20fa294b2@dwillia2-xfh.jf.intel.com.notmuch>
References: <20241210-dcd-type2-upstream-v8-0-812852504400@intel.com>
 <20241210-dcd-type2-upstream-v8-2-812852504400@intel.com>
 <67871f05cd767_20f32947f@dwillia2-xfh.jf.intel.com.notmuch>
 <469ac491-8733-986a-aaae-768ec28ebbec@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <469ac491-8733-986a-aaae-768ec28ebbec@amd.com>
X-ClientProxiedBy: MW4PR03CA0287.namprd03.prod.outlook.com
 (2603:10b6:303:b5::22) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SN7PR11MB8284:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b1a30ff-e25d-42d1-e0e1-08dd35f7ab0a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?gF/uJ6MPp1+Wtuh9Cw0ikGfoIMh+jbajoU8KrP8zyvloiRDa14KTbMCYp6bG?=
 =?us-ascii?Q?Pp65V3sP06sxERzKgx8E5dMEvu+w8rhGEgXlG/2VUg+vP0k7I4dVZ6trjSqC?=
 =?us-ascii?Q?UK8CPMgWhXefLKjKMW523Dtp7DLEgC+ou0rgNWKNjta2nWcwKPwbRJcm9jNh?=
 =?us-ascii?Q?RJV/zaFS49kKhpaHWSVLqZ7S7KVTaiiA4bB1HVaYRiIkxQobtbmEKul8zRNv?=
 =?us-ascii?Q?HCPZWLm/6ufjLwG2emARom7cnppVCDQ3YOWZqQJClkh5hGR9Hr7+Ue9eD3vw?=
 =?us-ascii?Q?Xnvtydr6IRWfotYUSnagupLJPKgJH178SNsM1FVCzZXeG0aeWoqNiAY/lx0E?=
 =?us-ascii?Q?ol5Y4A4s+ZjP4zpFq0INx6L/ls+2uypkb9OWbBBJ4ilRqXr+TXdfPAZYpt/j?=
 =?us-ascii?Q?qArGzTf4tpP+5HkMrEYYdO24hqAj58BDjlIJd5iwy2+WkXwvatyo0t/SIPaV?=
 =?us-ascii?Q?HNdMBC4pV8O9ESlzJa8+mroKPCOuKdSL5jcZ46p8PkTmhaSLADmoCwHWToi5?=
 =?us-ascii?Q?UQhVZO/fb04LlkrN6qPJBzfpZHR3Kxy0sHOA6Popd65uLvodNP92iR8DBmYM?=
 =?us-ascii?Q?JJHoJHvvvcqXYtnmxKeXTxbN/CUYYN/uyoCv/AYId3ctQ3O9cGjce0GcrvRn?=
 =?us-ascii?Q?Y02I7edtTKnRG1DiI21TuzazS4AfS9fJm/QdP4QSmdB84KbewPV96YkKuhNO?=
 =?us-ascii?Q?uFoprGOMTJcXhMLrM5LVUZ2NzgbThVh+JJ8DMVk7DCuLolQKarITi1SklgV/?=
 =?us-ascii?Q?nKHimRldESH1dNDkq2K8KZGxjtuwpxKWILEU1M7Aq7GC8/jwNcbTwi2dWZ1l?=
 =?us-ascii?Q?3hpk27GkoP510W3jQ2Zmlinobf1eBSkUeC/HjXw2F7wvsUN8LacgR7txiagv?=
 =?us-ascii?Q?Zd2XJm54YLlo3rBm22flDZLq/EgY+S+ByPkdqcTI7D3pA3zQeO2JXikacewS?=
 =?us-ascii?Q?qe0M/TuJWLNpJuqHXT1w8SSmDL+UeewAtZqyIuM99Ypi6J3B7oLUpWCTMX3L?=
 =?us-ascii?Q?CtjmMMzF76vVe0ZYVxeN+vtXfmYvjIBTJeBt9gGwW9YyINOYsFkOkdR+Y667?=
 =?us-ascii?Q?zkYMHxmKpY9Fj74PnlQI9p55pTyUmZEnuV6MWFIHc7T2Tx086XIILBwGOQbZ?=
 =?us-ascii?Q?GEGLBvhX6ddliL436OjCFoxytbV0VzZgT3U65ryBV7J4KOBmp7xHb4OHZx0m?=
 =?us-ascii?Q?ZkrzyToWUeSpSa9Nn0PZ+2Ls4pRenmes81A6v4CKQzLLb47Jxan2sQ0x+gRT?=
 =?us-ascii?Q?ohnEgfz42Y6byMvn778QRyYOigt4WYixYw/k/mjq0vf1zAscDyEFSAsdP0Vz?=
 =?us-ascii?Q?YWJ8k6VUynEU/Yn832PsIETnWEgCdJkE68nGjD2XHtn2038Q8lPyvcWjGBcI?=
 =?us-ascii?Q?qwVFLkUoddJCVhjJcoEENDW6IPcC59XEzNdRK1nww3YGIWIgXyAMo/Xo4vOC?=
 =?us-ascii?Q?ogO9dxSUsIk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3zk3UHKvHmnqrQ+CZ97JZtnfqEbaRYXQD2kGo9CJsqqkf4B6HumGvFN1pVWX?=
 =?us-ascii?Q?HL5DoUHofqTyvC/3LYbG5rp1vJ4s6N1A/v/E1uvYoAKtz7A7GaE7ki7EhB4B?=
 =?us-ascii?Q?aXu+Zsl2XuEgx4vZi37TbzINj/Q7/shSyP0XWAYwLc/CIoyByAbpH/NnYa/J?=
 =?us-ascii?Q?2xkIPaH5pnpBSZYxkB3w4BslQdjq4cNgicaF2vrAF0f7a8xZNm1Fhl3uS2+a?=
 =?us-ascii?Q?PplnkX2OGhffFvjjwS+kxes0Eke8tC7JknMeXf2CdBTQh7QFOrF+Akv1JFd6?=
 =?us-ascii?Q?N0JjZZE9Bx0P2kp2kv5uQxwW92qk1muKJWmMC7mqr23YSRbbGqY4ff4iIteJ?=
 =?us-ascii?Q?rFZ4g+CyY/rqtwJ8DvB16DVShFkrgcEdaRULrx0a17V7HByi+YuzxsGVCgoK?=
 =?us-ascii?Q?8oVOkI7CQXj3kjeJkkkA0fJKOmQMPTtMPUrXhtvcp03TDg85y9t6ZDyVulRt?=
 =?us-ascii?Q?mW5Tn2zgV3EKA38iP6ejG0zNL3bOYB00sa73ZmIMZQSBj9qNlcJviTsqt7vG?=
 =?us-ascii?Q?N9lVTHPHy+LArdPv/96HAOxh7MBYHP9Y+xh9XaKS0cTbJyydFgfVVxo1p/BN?=
 =?us-ascii?Q?iW7YOVj1D0aKubvB+hZKhK3yb5cEQSnHmAJyFobqa2bFIwusixaAlAg40mAo?=
 =?us-ascii?Q?cAy9X0+OvwcKnjGM6dRJRXWtTrPA8KMr/+sTCehVsO4zGXsAbectUoLKym41?=
 =?us-ascii?Q?eV2a+Md6/kKYpsphZxkfOykxDSNPHsWzMPB7mMueCi/pubo7tUqaJAR/Jl7T?=
 =?us-ascii?Q?6/YS9K+9Ev5Sary36Pdrp1VhtxeNUBG7ee1kdmx6kjQjNTbB219SLL0aKLuH?=
 =?us-ascii?Q?AKWgZLTJFA+5TFx4VOkx5kIpKSkohtPNVV54fSVgNoCSFRaw7GX2kluMQbgQ?=
 =?us-ascii?Q?pcmamGQgwWk4lTXXhQm9gLWo/f6PsSXAQ4/N71c308pSIcCJiBEyMxDv3AfD?=
 =?us-ascii?Q?H6D1TkeBXL+Qi2AjCXu0udbBiLe8pz2HESPD9qQFvDdhGHKtFtSVd1lCCo24?=
 =?us-ascii?Q?mazZld5eSX+d4M0sDK83Spn1vzWr4emUOgu0ylUUjI7y5KT6Kfq+ADUsKuHq?=
 =?us-ascii?Q?84ouk44lhzZd1YwCE5SzroTcZ8djlG8Ht3qbMffyvZwNtylCq0BwZKUqClzX?=
 =?us-ascii?Q?7TfAnjJO8JUjfuOdvBzze/L9bK7IAuxVHYmtp0DRVmDRHYTSCK1Q+L7Nu+1Z?=
 =?us-ascii?Q?VxTAqu8ZvHMdYVR9fejWHtIm5he5rhJU7+Pa+CVNWj6+ZSSjHKF8uzSvf3wr?=
 =?us-ascii?Q?P3YtDMOtrmxdH35fFlhqNiOrhV+4YNVXRhWkNiRz5UJLqkTzs6U9UqWD54yf?=
 =?us-ascii?Q?+6gu9y0sSaNV9NiWNINHuqICiorYDR0ilHMBw2w3YkqcRCTdQD7EbbVsFB75?=
 =?us-ascii?Q?XOrjeTrDWaV07gZ95kwnfX3Cn8u2ulBq2mj9M0rSsKKOxI0n95s2aCHlOG4k?=
 =?us-ascii?Q?ZNPqq2eTDu7IXyRZjkp+k0/gJs2dM55cB0JmlPQZ+wqDIHTnzG8cZAd90QLQ?=
 =?us-ascii?Q?nrJPXmRE7STgaKP/U4ecyymyWhBOnh5LTVhLppYOSkvo+fIg54VejwVmso/B?=
 =?us-ascii?Q?OWDDTfSG4y5A+mzN/uo+bfqwUeb7HUyHvKJq0v+a0oqAr/kf0my1Ov3Vsml7?=
 =?us-ascii?Q?mQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b1a30ff-e25d-42d1-e0e1-08dd35f7ab0a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2025 06:33:20.0501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nFXNCqmu3GmnJ0O/lfS+4PGpTDbFA8jwUN3YdDOSd/jfRLrjPZ1GBN8HmYhy6FR6O0sKLu4X2LblQ0Y2+zgHFs6O71806Rxy/IqajsTd7Hg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8284
X-OriginatorOrg: intel.com

Alejandro Lucero Palau wrote:
> 
> On 1/15/25 02:35, Dan Williams wrote:
> > Ira Weiny wrote:
> >> Devices which optionally support Dynamic Capacity (DC) are configured
> >> via mailbox commands.  CXL 3.1 requires the host to issue the Get DC
> >> Configuration command in order to properly configure DCDs.  Without the
> >> Get DC Configuration command DCD can't be supported.
> >>
> >> Implement the DC mailbox commands as specified in CXL 3.1 section
> >> 8.2.9.9.9 (opcodes 48XXh) to read and store the DCD configuration
> >> information.  Disable DCD if DCD is not supported.  Leverage the Get DC
> >> Configuration command supported bit to indicate if DCD is supported.
> >>
> >> Linux has no use for the trailing fields of the Get Dynamic Capacity
> >> Configuration Output Payload (Total number of supported extents, number
> >> of available extents, total number of supported tags, and number of
> >> available tags).  Avoid defining those fields to use the more useful
> >> dynamic C array.
> >>
> >> Based on an original patch by Navneet Singh.
> >>
> >> Cc: Li Ming <ming.li@zohomail.com>
> >> Cc: Kees Cook <kees@kernel.org>
> >> Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
> >> Cc: linux-hardening@vger.kernel.org
> >> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> >> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> >>
> >> ---
> >> Changes:
> >> [iweiny: fix EXPORT_SYMBOL_NS_GPL(cxl_dev_dynamic_capacity_identify)]
> >> [iweiny: limit variable scope in cxl_dev_dynamic_capacity_identify]
> >> ---
> >>   drivers/cxl/core/mbox.c | 166 +++++++++++++++++++++++++++++++++++++++++++++++-
> >>   drivers/cxl/cxlmem.h    |  64 ++++++++++++++++++-
> >>   drivers/cxl/pci.c       |   4 ++
> >>   3 files changed, 232 insertions(+), 2 deletions(-)
> >>
> > [snipping the C code to do a data structure review first]
> >
> >> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> >> index e8907c403edbd83c8a36b8d013c6bc3391207ee6..05a0718aea73b3b2a02c608bae198eac7c462523 100644
> >> --- a/drivers/cxl/cxlmem.h
> >> +++ b/drivers/cxl/cxlmem.h
> >> @@ -403,6 +403,7 @@ enum cxl_devtype {
> >>   	CXL_DEVTYPE_CLASSMEM,
> >>   };
> >>   
> >> +#define CXL_MAX_DC_REGION 8
> > Please no, lets not sign up to have the "which cxl 'region' concept are
> > you referring to?" debate in perpetuity. "DPA partition", "DPA
> > resource", "DPA capacity" anything but "region".
> >
> >
> 
> This next comment is not my main point to discuss in this email 
> (resources initialization is), but I seize it for giving my view in this 
> one.
> 
> Dan, you say later we (Linux) are not obligated to use "questionable 
> naming decisions of specifications", but we should not confuse people 
> either.
> 
> Maybe CXL_MAX_DC_HW_REGION would help here, for differentiating it from 
> the kernel software cxl region construct. I think we will need a CXL 
> kernel dictionary sooner or later ...

I addressed this on the reply to Ira, and yes one of the first entries
in a Linux CXL terminology document is that "regions" are mapped memory
and partitions are DPA capacity.

> >>   /**
> >>    * struct cxl_dpa_perf - DPA performance property entry
> >>    * @dpa_range: range for DPA address
> >> @@ -434,6 +435,8 @@ struct cxl_dpa_perf {
> >>    * @dpa_res: Overall DPA resource tree for the device
> >>    * @pmem_res: Active Persistent memory capacity configuration
> >>    * @ram_res: Active Volatile memory capacity configuration
> >> + * @dc_res: Active Dynamic Capacity memory configuration for each possible
> >> + *          region
> >>    * @serial: PCIe Device Serial Number
> >>    * @type: Generic Memory Class device or Vendor Specific Memory device
> >>    * @cxl_mbox: CXL mailbox context
> >> @@ -449,11 +452,23 @@ struct cxl_dev_state {
> >>   	struct resource dpa_res;
> >>   	struct resource pmem_res;
> >>   	struct resource ram_res;
> >> +	struct resource dc_res[CXL_MAX_DC_REGION];
> > This is throwing off cargo-cult alarms. The named pmem_res and ram_res
> > served us well up until the point where DPA partitions grew past 2 types
> > at well defined locations. I like the array of resources idea, but that
> > begs the question why not put all partition information into an array?
> >
> > This would also head off complications later on in this series where the
> > DPA capacity reservation and allocation flows have "dc" sidecars bolted
> > on rather than general semantics like "allocating from partition index N
> > means that all partitions indices less than N need to be skipped and
> > marked reserved".
> 
> 
> I guess this is likely how you want to change the type2 resource 
> initialization issue and where I'm afraid these two patchsets are going 
> to collide at.
> 
> If that is the case, both are going to miss the next kernel cycle since 
> it means major changes, but let's discuss it without further delays for 
> the sake of implementing the accepted changes as soon as possible, and I 
> guess with a close sync between Ira and I.

Type-2, as far as I can see, is a priority because it is in support of a
real device that end users can get their hands on today, right?

DCD, as far as I know, has no known product intercepts, just QEMU
emulation. So there is no rush there. If someone has information to the
contrary please share, if able.

The Type-2 series can also be prioritized because it is something we can get
done without cross-subsystem entanglements. So, no I do not think the
door is closed on Type-2 for v6.14, but it is certainly close which is
why I am throwing out code suggestions along with the review.

Otherwise, when 2 patch series trip over the same design wart (i.e. the
no longer suitable explicit ->ram_res and ->pmem_res members of 'struct
cxl_dev_state'), the cleanup needs to come first.

> BTW, in the case of the Type2, there are more things to discuss which I 
> do there.

Yes, hopefully it goes smoother after this point.
