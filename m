Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004AE233722
	for <nvdimm@lists.linux.dev>; Wed, 22 Apr 2026 18:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776881173; cv=fail; b=QD+II3b0GR0OXrUCRriByrXr4E7I1D7fWtu6SMsOI4BpZf7w2ieVviCu8Arx01I0ZnSGE4IsydLrBuI2Dbh7UWI26+xeyqWbQPMrxLrSy6uNpnxBDAozUS9syO4OiuOLGc9Eh6lPr+kwB9gg2RWWTo1cLvSH9OW/JGiB6wut8X0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776881173; c=relaxed/simple;
	bh=74PDjV7694KtJ1YhRY2edLy37y9lv0ExbgH7YR1R9Ww=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=p6JhIR9qJLikoNOkbbeJ/f9A0GxuPbnxZlNrrHw8Zpt7GvhHDCXIUVTiXu9ncgheaAWkXZigGM3AVfKQOtIR43rRi/a1TDFMWvySWdri8CJd+by2AUva3/Q4K9SU6w0VZ/i6a3iblgoXfnBd2nyVtSTEeEzXturf3lBk1a8c6EA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EfmxaCwH; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EfmxaCwH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776881172; x=1808417172;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=74PDjV7694KtJ1YhRY2edLy37y9lv0ExbgH7YR1R9Ww=;
  b=EfmxaCwHHCgQWW3JNAik3pCGHeRychnUR/CCIQNilJlPbZ+v93S+2mDX
   ZnG79WGORuW8gxHU9abyL+rOv0OajaYd97aOS3kl3QVJvYr2hrC3soitR
   WbHzmjQhZuI30uiTLj8yZvl3kTRp4XqxFWnuXTiAMB4YfFnaVwg1CF5ot
   XeSci3/GLax5R2qbHQr+SiJR242sqSDskCLCwTbQ1t+exTEDIcgz9OZyp
   qF62GRge1W2vVsnIeP9E7Ldf+Wpeglp579SpHUoPlSiUEY+OZB9kGzZvF
   RfbBFTuIcKBm1ZpuNjGzEc9g8mEp9EqGDz7MJI2n8sLlRQ1Kl7Iu9WVhl
   w==;
X-CSE-ConnectionGUID: QOMKJ0kJQ7ihLbi9tqcDrA==
X-CSE-MsgGUID: AMFtt+wBTmKBsHp9huN8Ew==
X-IronPort-AV: E=McAfee;i="6800,10657,11764"; a="88147492"
X-IronPort-AV: E=Sophos;i="6.23,193,1770624000"; 
   d="scan'208";a="88147492"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 11:06:03 -0700
X-CSE-ConnectionGUID: Oc9+GwpdQbi4c1Sz2EPLNw==
X-CSE-MsgGUID: v8mrMw78TF+J1wkp8jsz4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,193,1770624000"; 
   d="scan'208";a="232327520"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 11:06:03 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 22 Apr 2026 11:06:02 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 22 Apr 2026 11:06:02 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.55) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 22 Apr 2026 11:06:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IvN1KznF/Cfe5PAtjHQKs9GgU9FvChs1ELDj/3UceOd0Mvd5U2Hf8quZkW2gylB9sDnSdzXqs6KaN1gcnQWISWM5E9s2onM779CK7t3KP8KO7BTp6+t6b1B+GhfK/q17jiWAcZxWksCDWGjarHttsTZXW/J7AMvjySkaRBWQIkqpGAIrPz0l/usw5/NFcNgGa+GCb4W7L+AMmbAQT2QIxuufcXG8P86mgfFDBTECxQs+n6mlB9hjz8DTFDC/gXVE6SPYFkVSMgnOYRzfw9yqr7XlZItqtO8Pggp2ct7cc+FgnUYzkfTA2bmjQEUmkoRFeZz6VMKEnom2wL1nFbJLtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rjfYk9Hka2umYdlUon4/ePFtAtj3UywmI2XwGXx1oyE=;
 b=GTh70OJMFWVSevB1ekrgt7ZoFIpuNmh9J99eC7ErMFlUpO+nbv2ENXTtWIxyF3TKxhyvUUr+1VImQOxuWl7RFWnOBDxk39T7+pAjPfSNCNx8NBM2SjP+taeRw/SJuxWdju1yoPt9sg6B/1LCFMn5Q+2a2z0Y8CMWGXWv/io+QT7HPzuS8E8vwkjyZTXsLSQO4ESNz1FF03Fa5fYhV6sDTOT1m7E4/fegH3rLCrxA3YHasToKzTwMtShXy6YeLdU3YatUynfhIh/4ii+z8RI5pgX1YQfagpP4NR6kv8BY02/FGv9wvGNrFwizfecbWzObRTNaphC6RD6MfIPQ4TwKlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by CH2PR11MB8867.namprd11.prod.outlook.com
 (2603:10b6:610:285::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Wed, 22 Apr
 2026 18:05:57 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::9618:33dd:29ce:41d1]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::9618:33dd:29ce:41d1%6]) with mapi id 15.20.9818.017; Wed, 22 Apr 2026
 18:05:57 +0000
Date: Wed, 22 Apr 2026 13:09:52 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: John Groves <jgroves@fastmail.com>, Alison Schofield
	<alison.schofield@intel.com>, John Groves <john@jagalactic.com>
CC: John Groves <John@groves.net>, Miklos Szeredi <miklos@szeredi.hu>, "Dan
 Williams" <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>,
	"John Groves (jgroves)" <jgroves@micron.com>, Jonathan Corbet
	<corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara
	<jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand
	<david@kernel.org>, Christian Brauner <brauner@kernel.org>, "Darrick J .
 Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Jeff Layton
	<jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, "Joanne
 Koong" <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, "Bagas
 Sanjaya" <bagasdotme@gmail.com>, James Morse <james.morse@arm.com>, Fuad
 Tabba <tabba@google.com>, Sean Christopherson <seanjc@google.com>, Shivank
 Garg <shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>, Gregory Price
	<gourry@gourry.net>, Aravind Ramesh <arramesh@micron.com>, Ajay Joshi
	<ajayjoshi@micron.com>, "venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V4 1/2] daxctl: Add support for famfs mode
Message-ID: <69e90ef0d9627_911a0100ac@iweiny-mobl.notmuch>
References: <0100019bd34040d9-0b6e9e4c-ecd4-464d-ab9d-88a251215442-000000@email.amazonses.com>
 <20260118223629.92852-1-john@jagalactic.com>
 <0100019bd340cdd5-89036a70-3ef5-4c34-abf8-07a3ea4d9f92-000000@email.amazonses.com>
 <aaD6yQLiyZznfAxr@aschofie-mobl2.lan>
 <aeaz9TecrINXaHcR@aschofie-mobl2.lan>
 <497e9e6f-6770-48d7-929b-8543a25172f2@app.fastmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <497e9e6f-6770-48d7-929b-8543a25172f2@app.fastmail.com>
X-ClientProxiedBy: MW4PR04CA0226.namprd04.prod.outlook.com
 (2603:10b6:303:87::21) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|CH2PR11MB8867:EE_
X-MS-Office365-Filtering-Correlation-Id: 86a0a92c-4bc6-4299-6df9-08dea099cd62
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: CPOkFd7/9ttoEIGH0QQtT48Nfq0qD8lx54eMHfSOFj55DHp91ggH7SinG3E0VdsyMeqKVgJgLj/4jmw6VLVz/PIQ/P9/jFKK5eqiDsfwPppGvLIktsFiDJw1SQ9q6iPUn3E7w+fldQvvBU/ybm4IWPGjeCeKuZZHccyrPnl1Slrj0Xks2mo/TT588toQCmGZ9Msgm1tVNXyx/luLjmtnhehywkiWJxVSK5w5sBKuZroUOfrtkSQdiWen1OYOgexEvhJv6qulIYj/nvTf/DL0yaGRI4VEyw8jV6K2eVj5x7N7pkN/3vgerbQOgMihXJBKjZ524bP4938alB/PzKmiQkwl25LxXYDr3Vddxsk9CwenQbriKdwKTf2yuZo3Z8uz1nPR3BohYOEwtAJsnzo/kWN5a3Jw8CtgBmreiVdyMFl0GADVn72nmvRzMRzFrwNGKHu+EiFiT7I30Tn7w/AYO65PD/7vZivDOoKu1NHJUF/m/OAWkqrPkNyyVoai3Md5c0brksZRom9nP6baFsMBO72Ozo+eh6AjwXZ4HgHIec4H12ptDdC7T0zqU8WRUmPfL9l2x23HIJ7iPPMKsQOZ2pd9cCoAHiW8z9xEJzgB5xzQ2kAdqQIDz4jRkYeXggLYhq12Lili5wFyAGLY+g6GvvJbRDDOR0E1ROaOs36M5N9wHo8Q70SFCN+38e8qN+y21fcZQTmJDBhF7OKV3CsWuP3BJZ2e2ae/3+9+X/nxn4A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TlTGlgOLj1I+z6PjI1Aov+sF0z5MJBw8cDEO2zIRvMNXlH4dsI9jOV/geYr7?=
 =?us-ascii?Q?nDsz/ty+lmmiFj56Vfjz+ZlBpfJkLKJk/YlOkrs+VTEyG7vOdOFx02bBZSeF?=
 =?us-ascii?Q?dTFmKLzC/DMOEA4/2Tpb2YYFagJN7WDZEORTaVj4MhCRPZufunRWdI659sB6?=
 =?us-ascii?Q?CT0JC1Af2Bx2Km0aOuKfF0jKOlBLoE9y6ghp45PaQ7EK08MMWgduUyC7h4oj?=
 =?us-ascii?Q?GGD6dkL8LJzYzZW6g3eL/1tsKNX/QGjsJpSqz3j3b4e07ZK3XdWF1zHocP5Q?=
 =?us-ascii?Q?gIJvB66z0j5b9MpAdu6V2nL0/ZysMGXtm3WPtz+0YUUXL4FepvJWwM7GTIzC?=
 =?us-ascii?Q?HDQNVwebmKLmNOn3CogUT/6+/XP4yr9MykDD+MJfQEzXOru/XRaosNrpVUFc?=
 =?us-ascii?Q?ShA6cLKRY8Z+aXJNZeonLFmPO/oBHKKMyRTXnOWwrbkkJ6P6dWxDwPfhMCNN?=
 =?us-ascii?Q?wdtxC3nz81GY3xMwNKj7lmKkgbbUgp7CofCBbnaK4kcSPKQcuWqdkJxEoeDR?=
 =?us-ascii?Q?dXRyEslCLLD1hYdptsJxP1a3U8ACPGz0yhIydzJjG7m7EGd81/OipOa9OAXQ?=
 =?us-ascii?Q?IXq80RLU8nw20rYgJVsxBONFPrCtLG8/j1tZ6XfLHbfELT11GPNkZmHA1Yh4?=
 =?us-ascii?Q?m4QwgoGfp97RS0Zo7rwx+7VtdN5UKIDcYVh/qJ1zQhEtjzD8kANrJZrYcFr1?=
 =?us-ascii?Q?P0qrC4VZrG8vpXnUbkj1ZebTG8rnKiMvbGvkwf7eq98VgUdJg6/D1YlS+srO?=
 =?us-ascii?Q?tJTvOGD1w1Sn24NK96HsSjeEPBO3PybEt8e/1zgZqf+RkmEfy7kW1GRJajae?=
 =?us-ascii?Q?vv5rrAbgXam/04Sd8NTVt9568RL11dhoIARD3Ma+wlZoIOvevSs3vPE2saRu?=
 =?us-ascii?Q?4yBqAP0yVv2mf4rggmkcp3PZ+9yyGgpmitzHW0yJFwMlaqLFxRriskkPS9ZM?=
 =?us-ascii?Q?br5Fh36zF+eTeQ4R/R9Rdpz0rOY9Mz5llSv9nP3apuSQfZJJpmdgvtAzh3Zu?=
 =?us-ascii?Q?csmWSmEOyT3Hy6ZzAo+pIyZijxUyF+nctqjqaO7TLQvYw5mZQzcBu/arahji?=
 =?us-ascii?Q?3VMTrkgjnEIjudELw/FUhlEktqZn49oKtyVBSiPjJ3ChJ/U6z7/wdOlr3MZO?=
 =?us-ascii?Q?rzdultdjSqHJmGhtUPzCiFhL6nWbjx8pSR0t7weUtpN8Ryggl2ucbPR5ng3m?=
 =?us-ascii?Q?qufj+pJyFNPTC83Qbm1LqoaExPdRbPqwGruzWjBMV5CWArzknFGm+DysLJGX?=
 =?us-ascii?Q?LTA0ndGQGl1NYiyU8OwGbQ5HbKPr0Xsj3GLro6wzVOk1xt3SZNys0faL38I7?=
 =?us-ascii?Q?+NHCmUmp95EzpQWvP4AhkpW+z8L4fKezqQFex3PfOtf8IAJu+5zwjr73Nu53?=
 =?us-ascii?Q?HVKvAgySh/z4dU6Sg0pIPIloSuq0p/sqrAsJ+IfI7Is5g50XYmUXeH2sTaT9?=
 =?us-ascii?Q?a1roI4txl0MaKWkq1NC1Gs0UpDzr+aQ4HNZW3YkHy+HoT+Cn4JILDJlv7q/u?=
 =?us-ascii?Q?FAnCZQ1xMkiyzSYJhA39aQXqKI/Oa+zfLQvHPxIGYR3Y6NVB/7m2Qgnd90+Y?=
 =?us-ascii?Q?xdgSbtXK1iHGY6GLe8yEnzGPJC00iB9PmmLoG25wa0x7vV9fipOv1Qo55x3L?=
 =?us-ascii?Q?5Utdk4O1oCBjTdvQTnuGJTq5bpzywKVusKmY5SO8pdgCzB36asmnxNq81nY2?=
 =?us-ascii?Q?gudrHZwUfQoA8clsAv7KZSd9v0foMgxMPbKIVp8zmCtcEES/DxJsZUL9hmIG?=
 =?us-ascii?Q?180XpMNRzg=3D=3D?=
X-Exchange-RoutingPolicyChecked: VSHSRw70jGcaeilyRE1WxoJsD2E2oi6nJAzPQ9zXVl1IC5hyRgFULvE4BB8YrMUlSYhcZD6bXMGqWTwGN+msaEHgoRnbCvbcusDUpCNeoGVgw2f4RzCRGA82Ntek2qaOsIyNUihzftO4N/9ZiqOsPi7UUxv31jWUlTiEsTNSJZqZHZ1sXIisjSBcSdbVh8sF/JCoPdARlbOnGdAD9CrLZ0wo1sQn51CbEFom2FtTaB7qYHN4fXSfsljm4LFTSQOSVo1j2Mion0k8bX4Y1pOn2DBKLFOicuaVw9mMFEmNnl2UA3iW3cwFoyM5GOJuwSvntsFfKYp33bUbb5JnPNeZyw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 86a0a92c-4bc6-4299-6df9-08dea099cd62
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 18:05:57.2007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k1WBoa8NL5IsTX8+XNQOkQD0Y7lO7GsydU0+p6FdB9M6PTsSEhcmtUeHQYqWHD5dyuTx74MAI7rT7mwmmhg+tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB8867
X-OriginatorOrg: intel.com

John Groves wrote:
> 
> 
> On Mon, Apr 20, 2026, at 6:17 PM, Alison Schofield wrote:
> > On Thu, Feb 26, 2026 at 06:00:41PM -0800, Alison Schofield wrote:
> > > On Sun, Jan 18, 2026 at 10:36:38PM +0000, John Groves wrote:
> > > > From: John Groves <John@Groves.net>
> > > > 
> > 
> > Hi John,
> > 
> > This is where I left off with the actual changes to "daxctl" for FAMFS.
> > We need a new rev of this ndctl set that includes both patches rebased
> > on ndctl pending and addressing the review comments below for daxctl.
> > (Although I've used more recent branches, I haven't looked at whether
> > these issues were addressed in the code.)
> > 
> > With a new rev, I'll take another look at ensuring a dax device is
> > available for the unit test.
> > 
> > Thanks!
> > 
> > --Alison
> > 
> 
> Will you be on the DAX call tomorrow? If so, let's work out a plan and assign
> my action items as necessary. Not that I need any more action items :D

What plan do you need?  Now that the kernel changes have been merged, we
need to have an updated daxctl patch set which Alison can apply so that
rc1 can be tested without me applying this set.

This is a pain for me to apply by hand.  Please update this and submit
with Alison for merging soon.

Ira
