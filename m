Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF0327990C
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 20:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757102796; cv=fail; b=j7kxf02aV+Hnqgm3xBnX6/7pnOY5b3cpiW11wkkrV8FIhBtFHX6C9O2S5y+L/uwVnqrnM12PvIuZ3WsZjYngQVMeBqTteWK7Wz/5E+6BysK3jCGs+ythFVNUWFQKCqHr6cElQUJ83XIg5ZIMV11Ks1paNysvT3mxIgxZaOa5UaU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757102796; c=relaxed/simple;
	bh=S/6+sD0Gdt3zSAk/fG9nXJF4mn6Xkwt9EGDU39oGA8E=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XRAFYHCaUjdU+6NCSjywa4uQ9HkQ4Gyn/+V0I2WOQVR8gqx/w12Gzcc3Ef9YPiRaDKW9KYR0Ano7UScLWfeWZASPF8K3uzHbMUYyEO6M5l6NqzGYUsEYle7b18DzMhcLE1bgFsqLCXFIOHmRFP9JEdCDpgug3Zg5l6VhMkrwlro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n4aZKRGZ; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n4aZKRGZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757102795; x=1788638795;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=S/6+sD0Gdt3zSAk/fG9nXJF4mn6Xkwt9EGDU39oGA8E=;
  b=n4aZKRGZfS4UPvTXUBMvFmrhpaGx/s2NP3GP18TFnoZK4d1NK8ue1DxZ
   pDgMQXX3n/3Ht3LFUCEUcmO1eJe0U5OAwIBdBY/zRb/tPL575TzMA1Oxd
   yUji2TxPMlW/oMoaLJ76OTtpH6OV9VissUfhmBgiwHRmG/lhY0TseVJI5
   aB1ge4xTUnQ3XfFHouBk2JTOy5qiEQbu3WTimUOOIeBJXtcSKPA1ss383
   0lG+iw8VI3aBdmAbjdMAqymX8tAL2F7foo0Dd4sfnBNLCsowUraHDbVao
   2w0oru4qf7LiCqUcqKiDFzkbrRrab3OajfOZ68PqYKOXKIkB69CLOhztk
   A==;
X-CSE-ConnectionGUID: AerAMuPeQOSZoQckhwomJQ==
X-CSE-MsgGUID: Vwi7EcpjQkWLey8tAGZAfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11544"; a="58670437"
X-IronPort-AV: E=Sophos;i="6.18,242,1751266800"; 
   d="scan'208";a="58670437"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2025 13:06:34 -0700
X-CSE-ConnectionGUID: wKFjrqU3S7iJPyPOYWwLmg==
X-CSE-MsgGUID: u8UhtalzQaC5cj/4/tw+lA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,242,1751266800"; 
   d="scan'208";a="171521461"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2025 13:06:33 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 5 Sep 2025 13:06:33 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 5 Sep 2025 13:06:33 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.43)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 5 Sep 2025 13:06:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fJaurg6h1ShlHK+6DgDwiFVVAuf50q91bvBD4gfCD+YR593YHHUfj19RZnpDhN+8QbWiVRHDFbc44skk+Hyp4Lv+Xxi56/IPUpD/QiXcM/flXKRLLbV4egKI2GqhxafeoAbqg+sl7YHCsI8czGWoHU8aWgnslFLb2ee1wfYru+wWFNCSau4N/Gr+2f3VOVIcrVwqZX9WGSmmOK7ocAD1sC8XyZGaSjmXlAvo8ljRQzHjibh9VSu2Y0l27TXmY1HJr8U3xGOQa005a/PEL9BSGvHbUxvH2fT/r4NKtDG0SdUu1PYiLIlPkYMAgsJ88VHHI7sbjucJiA6x5RBJ3FzmKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q3SrlE7XBKkICNA8CuVMz/KnGZapiD703AkGVJobD4k=;
 b=h2Ea45TL7nUgFjY4uCf+YWzYYH9c0OVNBaInenRzS/S43ye8DwkJDFGMzQqA4gj+A3/xotlqKTXw99W9bB/X4oTG/Qe7u9GImKPYzWIT4FdLwoRE+Te4RjCPLglyfj0xdMMRGVmuVrXbLNUIBQ1HVKuMwPhWYQZKD0jXJk2ffUWnHMTshQXpgbjlzTnIv5ePmyXi6hvNQwv9f/GrbPQZxt0Wna7R2B/rE78YxBFty3Swy8KUezq6HgTV2oI/2P40RpPd23NlqOzsUtx77ILCBJL0AWT/3FD9KUZ0joXiYW4vmQjOuuhRa/LC8QCF5kQyG+2H/i1WdAEEEWJkge5Jxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by PH7PR11MB8549.namprd11.prod.outlook.com
 (2603:10b6:510:308::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Fri, 5 Sep
 2025 20:06:29 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa%7]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 20:06:29 +0000
Date: Fri, 5 Sep 2025 15:08:21 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>, Ira Weiny <ira.weiny@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, <cpgs@samsung.com>
Subject: Re: [PATCH V2 07/20] nvdimm/namespace_label: Update namespace
 init_labels and its region_uuid
Message-ID: <68bb43351ea_9916329427@iweiny-mobl.notmuch>
References: <20250730121209.303202-1-s.neeraj@samsung.com>
 <CGME20250730121231epcas5p2c12cb2b4914279d1f1c93e56a32c3908@epcas5p2.samsung.com>
 <20250730121209.303202-8-s.neeraj@samsung.com>
 <68a4c8d971529_27db9529479@iweiny-mobl.notmuch>
 <1690859824.141757055784098.JavaMail.epsvc@epcpadp2new>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1690859824.141757055784098.JavaMail.epsvc@epcpadp2new>
X-ClientProxiedBy: MW4PR03CA0039.namprd03.prod.outlook.com
 (2603:10b6:303:8e::14) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|PH7PR11MB8549:EE_
X-MS-Office365-Filtering-Correlation-Id: 7908c04b-3a29-48f5-4b14-08ddecb7b39d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?z/qL26jYoQiwhy2PBVXY2j/YZ4s8yeXrlupjmtOLOENTUj176cDNgO6ufH5X?=
 =?us-ascii?Q?VpkCSBP6SG8j6rUFeZS70q7jhwxnbHIhbHDJTqhuc9/UB6JfaBQ8AGbKXxBm?=
 =?us-ascii?Q?s70rw/TdtRmRYCq5bIB3+e5TT28Nmki1IV43zfeyXF7HcgyuuLZucynpqLp7?=
 =?us-ascii?Q?yf5pt48wr6hl6Jh30EMEzegphFILGYJd58hb82hfMLtlpFC4KlZcNhzQS2AE?=
 =?us-ascii?Q?8vrzGkJZxBVc29GeglSXQ5fCd7yaH9bPLHAzB9qD2a8hu/sEjahKzWoNWjnR?=
 =?us-ascii?Q?Q6zlM3pGtPoKfFRb5jbABjGXIwfI0txjP6VRSsHBjrUrM7QF/TDpOYhGe6lc?=
 =?us-ascii?Q?ErtcyZOzg772HQd/TZaiXtJsC6+HrrQGe2Sa4r+dFqGytt1WVdRBaZTJEM7c?=
 =?us-ascii?Q?YMvy5oWpsHTnnnRhUsif+IBeo1IsWnqVdufImt/MeUdSeOmQrXiwxOT7W0M9?=
 =?us-ascii?Q?fz9GylMopMcAYhD3K2YT2yxsmBL9TiowiPLkQ1sss1qIwBfM7UjqoS/rGmu1?=
 =?us-ascii?Q?fQZ+V/+7gi/0eqn9awmErw+HWTB3E2Rch8rAMkjwKd+oGNz4/vkOLQmyQDHa?=
 =?us-ascii?Q?gHkpRZ3YIGYg0JVTOxzWceWCtjEfjNMaFntbvDF4Crgu32UJ17/GuDcSM2KG?=
 =?us-ascii?Q?sbAj9JOU+3TxbDuo+eJn1k8hN+OxLXdrTG3fylghUN079LsNj2Ae+cTgbJ47?=
 =?us-ascii?Q?dGyYQERzhvMdW13GziVBoLm8cGgKQN9RcT87H919QcW1ijyWySPw8i7TABcF?=
 =?us-ascii?Q?t5TVWvL6RRbrzwK5sL0y5IIa6IdVT0GoOpSRYboiDlIt/x75tDxTKrYEgwvE?=
 =?us-ascii?Q?QecSGyfqGXgxMY6JZH5akFNGCGXMoi0te6R4qFbNmd+KJyoBcCQGa8zalRjg?=
 =?us-ascii?Q?rZskGAtKMVa8+AOsCPEh+1Pz4JBdiekObi4VpcyAbkO3rVdd2nrBlFB1Qzm6?=
 =?us-ascii?Q?FHFoDWgS8HK8fm7FZy8w02KQW0nmY3ilI8zaHSg1bbniUp7ZDuT9HNlY4QZD?=
 =?us-ascii?Q?EPH/7OouDMivdgknhWZJRmoedySVtWl1QlNfkTIZGntTwH5YhpDg/8HHjUsj?=
 =?us-ascii?Q?MbARsC9/+cWItiLra1C4f7SrgOaU7EBhhB8Ya6D03KFhN/A5ckVDfnmSBFQD?=
 =?us-ascii?Q?WJ2fsKg15GwmdjDFChPE2pGfypswziooHmrZ61pgDm762R207AVZszqO0i9n?=
 =?us-ascii?Q?x3JCPVwD+/4qD+44E+tt6dqnO2Yq/QozCpjNqTAi/CizNnM2ulh5OHYffMRB?=
 =?us-ascii?Q?vsbNyR4/CdwEF3P7gHUFCgNc+pp1bJegKuzyiBQe3F4/ECnAXGTIui3ZJ+pA?=
 =?us-ascii?Q?+j6ATRyDoBI2G1l/bqkowBsH5dMl3C0iuDX5TI7CJS/zNm6S8V7OZTiF+nGu?=
 =?us-ascii?Q?/5eVtiexLjGGL1Do8C5ko4msCw87o5QYk4zgBbOZIZ9DjHKgJVs+Oynek4IT?=
 =?us-ascii?Q?ILoq09BjsoM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UXXX/Me/KQvJKGQGsrFgHgWel3n/gctmyGb5/d6cIyAs18SHnbai3Lt2yTWt?=
 =?us-ascii?Q?8ExNvqnWDuAVhvZEIci1LjdsSf2IhacIS4b19DZI95ZUFL5rBwgbplHyPB87?=
 =?us-ascii?Q?/4e0+3F12fOZEi9Fll4ayNc0ROLzYGOKZXyqk0EzgEbK2+gA70jN/srU4Go7?=
 =?us-ascii?Q?qjOvx0WX8Sd8teOeMoXvXL4QVvRcw0yDUXdDQPk0m49Rr+3NCFAjCCc9ZBTn?=
 =?us-ascii?Q?8Nrhny0Q8wmbaLKzwrBTgSzUid5s6tOnFF1lyP+n590AhY6mNgHnCyzgxw7p?=
 =?us-ascii?Q?lp6lbpE9xxvUmb719p+djj+2d7wBSp/3KnuPbw75qYZouIc5bo03HiY9dWZr?=
 =?us-ascii?Q?M58KVU8seiw77egLRT8V/BHyjYcy9VYuQXiSD3EyF1afcAVCo7MhP0LGRv/6?=
 =?us-ascii?Q?kX8EYml6V6gz7QHonZv8aSUYaVny8zsczhLI70gEb9AkxN/AJcctY39bBrka?=
 =?us-ascii?Q?gJFjfKF5UPoWmKdDsJkTFh//GvbbjA+QM69QVrFKtXpVKVgIseazbICdy2CM?=
 =?us-ascii?Q?5k1h/kU7VKnFlBE6YJaeFwpIHYlbDaKRBYCL1uVhNon9JX9oaMIkOTXLyR3b?=
 =?us-ascii?Q?zq2344+l+uQ3utGlOKO/QuGvghqkrn5xkUE0zTMB9jJHsCaGvbbG6yMYAuyP?=
 =?us-ascii?Q?qA9oHHzTcR6mJBqJvxf98hpIPu9jmZuLODhqL3lrDpArR7NbKIUudIXHUphv?=
 =?us-ascii?Q?sT4DbDBHGyk3/tWwNTSW1RYOduJEf+yp29qTfhZXoEo31eFZEn+Lgj2eW8Nm?=
 =?us-ascii?Q?3kI85FCTB1kBU+qKGcFUDj/IbhHs4MzoxZTgZaVrfdl277Q6LFL3HXgdYR33?=
 =?us-ascii?Q?HJcMwf/ah7bY7W9op4yeKDsjzcQipNY8s6kT5Oe9mynOeCSh/G8l3nMQuSFC?=
 =?us-ascii?Q?dtQgXM9USRCLGNDYyX/a1jByK9ea37UKN+EbzwTD9kEIbEOenkAI13CTpALF?=
 =?us-ascii?Q?Lh8CtDxAW5Xz7YbC/FYGIpvoahv+zc3paiPmAAsJyhT1INUh+L9EUF+I0/CI?=
 =?us-ascii?Q?kespH0JUasIwulHuiNJGRKauYbLa0XF6hs7ZISw0+elqYPFhYnf4HfoKJEiQ?=
 =?us-ascii?Q?afO9/gqYSEP6kkH6xwdSYYYVfAFd9RvKO5o0c0nJDQnvLw+qxg+cR3cKo8w6?=
 =?us-ascii?Q?WdvLYEHLgCork/bXwJIv8iPsVBs5Zh2AEzge3Pn2DL8nhnKWkVA170rJyZqq?=
 =?us-ascii?Q?2G/7zgpzY/aPv6LJz+ZQNz9Boi2AZlTbbG/YfFe4NyO8y1lFqZJ3cMVyFT3e?=
 =?us-ascii?Q?dUDtsQUF0rciXlMcWgTTvcymivLQ2R0zHG+zbVZz+GGTRuFa6z1Vflc861iA?=
 =?us-ascii?Q?4k1JkVHE/ifbC8mpuVrQvH/2mprZV2kTMb9VSMekBCVoFZugfMSqbLLx4pn6?=
 =?us-ascii?Q?xmI5XEjVj9aIsDmk4IS4H+WUDFnLlNI6PVmyQV7ZvNiVvNJ9Ilvpn2nxRCpn?=
 =?us-ascii?Q?z0bvA0BJ8sTxx8jz5yls4qk3RLu8MktwlYHZuMZGHEP1VmLedKlTM0FXc93X?=
 =?us-ascii?Q?jvnXyjitx8GK4qHMbICpnfzpTSaJUbgNb5Yvud6f1yPaqyl31wrxC7SCJsw2?=
 =?us-ascii?Q?PZ7chjacyFcHBC5eys/OPsBfZ7buPjXzbeSOQaMP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7908c04b-3a29-48f5-4b14-08ddecb7b39d
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 20:06:29.6029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mhq5TgSgyckopHdn+zpi+amZmWv/fzoz3edT/UA0BCPUQoCs5XGLaFBGHyTusAIztCds55odw3uf9MbIh+fNNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8549
X-OriginatorOrg: intel.com

Neeraj Kumar wrote:
> On 19/08/25 01:56PM, Ira Weiny wrote:
> >Neeraj Kumar wrote:
> >> nd_mapping->labels maintains the list of labels present into LSA.
> >> init_labels() prepares this list while adding new label into LSA
> >> and updates nd_mapping->labels accordingly. During cxl region
> >> creation nd_mapping->labels list and LSA was updated with one
> >> region label. Therefore during new namespace label creation
> >> pre-include the previously created region label, so increase
> >> num_labels count by 1.
> >
> >Why does the count of the labels in the list not work?
> >
> >static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
> >{
> >        int i, old_num_labels = 0;
> >...
> >        mutex_lock(&nd_mapping->lock);
> >        list_for_each_entry(label_ent, &nd_mapping->labels, list)
> >                old_num_labels++;
> >        mutex_unlock(&nd_mapping->lock);
> >...
> >
> 
> Hi Ira,
> 
> init_labels() allocates new label based on comparison with existing
> count of the labels in the list and passed num_labels. If num_labels
> is greater than count of the labels in the list then new label is
> allocated and stored in list for later usage

I think I'm following better but shouldn't this hunk be included in the
code which creates the region label in the list?

I'm concerned that this '+ 1' out of the blue and will be confusing in the
future.  Why can't count be kept up to date when the region label was
created and added?

What code (patch) added this region label?

Ira

[snip]
