Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.9
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795119999;
	b=PsBw0sWl2jEvs2JijfnSCl0+xskFXxhgeLzANTeMxEGNBspmkHxfvJTYS0iFKz4AwLxy
	 6H38K95k4adGDGavTVbExhi06+WRMo/B/HXY+XxaXxXALcvQ7SZe6VVo8+BYbVPK5IWRb
	 9oiTTlV+wftxfOuqSzkhV7kAlWRXehEJEoQxKgEtYUpQo84SzeO4+WTj0hc9GuaSCrL1/
	 MF+jha6iy3oj1noiRnYPwi2hqlgTmk3KnmbGarewcx5YaVB+RfVYLWZZGLyDxmZUHzGwz
	 SBpo414Fkb3+K6ijB5BRRWCvH9f1Qd2TLAJ0kpXgtgIMwee9f/9NX9ZkLG6/70pkZoA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795119999;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:DKIM-Signature:Received:Received:Date:From:To:CC:Subject:
	 Message-ID:References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=x7cdYqzqx/Gum9BRPKRyJHvtrzpgJJ508N1XUYm1HZ0=;
	b=O0gtTNK4h7fmUS1IPu3qJRts/cnX12bOGxEVHQq0qR7SHN55Fp91Wa5wZ6TWp98jUUdf
	 SQA1QJKFabyMyWUpiGOrWlM/moxuegarb2tfdfOTwNMw8WII2YXHFWjGUlMCsq/XfHO+o
	 gVbi8LMbtqINh0FyoHns/wqzeg6/yyGF732X07PyOBAH4inKtPjYdp7ynvbrOwqvSk/Qg
	 9AaGbmyFUvf/4pzroad/mW6mZ1p8o92ZQEtcT76d0gO4/Q6Ec75GqyaPVewqNFU3rgv9g
	 2Mh7x3HE53E9HjXVGuuok48vMPLHkVdCtWctg4mKtfht+u2bpEQfA+T3Ktqq0PltSJQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=KxlObQ63;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=UAEoVoZE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842DD606A33F
	for <nvdimm@lists.linux.dev>; Thu, 19 Nov 2026 20:26:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 842DD606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=KxlObQ63;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=UAEoVoZE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795119999; x=1826655999;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=xz4uHehS/j8aCGfzTv0seiFsvdQXp5ml0sqWURCP9ng=;
  b=KxlObQ63os6d38FsEuXfRlSynu4au5VZsCaSxPnZ1pdo0hpf0FbLtQxp
   mMZOLxprCrLvvAX6rotNUMHkgFvB4oVqsmeF8AZyF9VAnC/AoIOa7f8DK
   0b9rgOu7lerNSsXfS9/MGQ9mOBKjEcwXzNkAkwooR4FGP9gGmOkPkenMA
   DuZudYbfPmhrf+X2akvPpKE0RMCxhY9YZ+PZbkH3mhyZ+q90AD5meIiGU
   eUnvMRJFb/Zd99igyHpBo3/246hBlPqX385i5sUWgJvswpl9yoSJl+5Gb
   v0PlBDopohjEMXPlHjHMVDQfv/q0SnWK8PnKwHNRqt6eYhp+OkR5Pj4NG
   w==;
X-CSE-ConnectionGUID: lBilwDF9QsSlYqTGDWYVXQ==
X-CSE-MsgGUID: 3sWb6OqfQe2Da9y4hB9+fw==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="3872695"
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="3872695"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 12:26:38 -0800
X-CSE-ConnectionGUID: CGgJc/r7TW2bot9qItlCDA==
X-CSE-MsgGUID: 24xfdKS0T/CF/Q38lNMVTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="12502409"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa013.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 12:26:38 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 19 Nov 2026 12:26:37 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Thu, 19 Nov 2026 12:26:37 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.68) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 19 Nov 2026 12:26:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aP2MCtNu5FE5f+dXWb/VIbLIRVLrjmOWk/bi2cuQSEYaQQMnSqQEpx1madUxIakZsqR40rNO1R0v1+SuVY0LRUT/h5PcttYB//L24IQgyyK6g4l5h7fgByJEnioHIlGKj6L4jgGo7IcrZcYi9tNr9mQuroCgXbPRbcDyZ8bJLs647v8AO4Z/r3yNx96AkKqp6r4aYGgnPzp1ghHdEZ5zbYomYrzmVNFmhv7viK1rBjG2AI1619JuFwlq2U4sCjhVuj922bk8i3JvxM/IEgYy3QDQETpqVPWJ17HxYez46Dz6s0Iq5cif3h2a5o0Ufl4+6AiLhmBHWZratBtTlPXIrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x7cdYqzqx/Gum9BRPKRyJHvtrzpgJJ508N1XUYm1HZ0=;
 b=kr3L54DgF9BpJ5vYslTJDd7jDsuwrexNs3vJaj0Nku5KrV7pZowsokKaR5OPEdkLZFfkLummkLoMvxsa8EjDY+H5UfH9VIOemCBAb2bwO9IiJN6a0oc1mEEgl7rg4PRY57nDbyqWxYPE8dNE4iqLeM7aO4h8BkajB7w+BCRmXqEezXr3OuNjYQ0hN28uKp/YuFsLhCmWqs5v/Ew0WAtZ8pl3qHllwiAq/0q6Uej8h7QKKMrt8IFHGAkKL7LaSVd6wv3eqt+PGF7K5ULUHZ42Gpw9kaqBQyZjxOpUBm7YWrO0Ghz0mxF6r37+aXBprDQKIdM50SzFR+Vg3DUXKMN4OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7cdYqzqx/Gum9BRPKRyJHvtrzpgJJ508N1XUYm1HZ0=;
 b=UAEoVoZEFvDln/hC14Cmj16FxA8QAcpsY15N8/WrSO3c6taIX71DF3J2wuLkp1v2vSCl8UbzFLi5jnzBQ2KvTSTZZjBq/qjAr6Me6s4mUc1TCZCo1GSa8+qx0iRxviEJmmmW0FXJJvxonBPL0jmKRUlVmx9q9pdLYE0TkniH/Xc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH8PR11MB9771.namprd11.prod.outlook.com (2603:10b6:510:3a4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Thu, 19 Nov
 2026 20:26:34 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0615.013; Thu, 19 Nov 2026
 20:26:34 +0000
Date: Thu, 19 Nov 2026 12:26:31 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: YeeLi <seven.yi.lee@gmail.com>
CC: <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 1/2] ndctl/dimm: add missing OPT_END() to
 key_options
Message-ID: <av9bdzRA-WUMQg1V@aschofie-mobl2.lan>
References: <20261117062808.4004617-1-seven.yi.lee@gmail.com>
 <20261117062808.4004617-2-seven.yi.lee@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117062808.4004617-2-seven.yi.lee@gmail.com>
X-ClientProxiedBy: MW4PR04CA0077.namprd04.prod.outlook.com
 (2603:10b6:303:6b::22) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH8PR11MB9771:EE_
X-MS-Office365-Filtering-Correlation-Id: dd7aec33-8d39-40d9-d21c-08df467b673e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|18002099003|22082099003|3023799007|4143699003|260925021311599003|11063799006|260925022911599003|56012099006|260925021911599003|261022105027099003|261026140227099003|261028144727099003|261009223027099003|261021121427099003|261102123227099003|10067099003;
X-Microsoft-Antispam-Message-Info: 7VnULbGIT32X/L965y+2UDndUOY+MixfxToHiYG8W1PbQNv/wWck8bmIOODV+Oa30CkO4iXhdQR2P7aACp4AvB9qAgLqcIcYvwXLdKaXZgE9/B0O7VSeslclsT18IMnp56w85y9x2qophHf17BbdVMieD7r/LwnbLbb2bsiYhHHTJpDAryva2RpyPqUTLnNFuiHoNDaso7bm3/OEwIcDca82wF5nAxqKeTCco+hj4MCZ6xTvnVSv9X8uOS364KIsZBYxlrBXTLq7jJSpuVxOto3uFEjo5/yPidIGTcsG6CmNKE90yqjSzEG/nXq6nsHI6ttH3nmU+BKjAEv6m6vLYRxtERQCY8tCfJRegDA/V/q+grwq5xX1Bs/xuYUcYYTtK83HbEdyqPsSyHJFOknlBQLnhqPWCpDUHuJZdc3+exvDSm+RLCY5xiOMOz6FALB5EjdatgXYgJWduITWCMGy57PmrPipl45M4CbBDW1rQRuKW1/OU5JFnNgzdJdX4GysgNZ2BEoRryPAblE98ud+mqBTXFfXYfP1aYWkK9ZjDgUE5PCFh9oH8qtfHayvgdjuk6SFjjDKENVJEie8LsZaZEkL/Dd1VIquBSxEjB9T6OIx2nGVfmQKqtwKqej/ZN6X5ppW8XVDhMKUC251Vsp1Y86X+hpm1+00IJPGcFTYZmQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(18002099003)(22082099003)(3023799007)(4143699003)(260925021311599003)(11063799006)(260925022911599003)(56012099006)(260925021911599003)(261022105027099003)(261026140227099003)(261028144727099003)(261009223027099003)(261021121427099003)(261102123227099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FT2PwE3tB9vdauViVPgM3p+tfAh2hFYXWsTIh/00AhJ64qmN8D+zpyfhNsuO?=
 =?us-ascii?Q?7LZoK2xePwXtutUlenRUP2diHRlK6onxxsx7hBy0foEyfvMVSZ7JSuBu/yfN?=
 =?us-ascii?Q?6cTrKgwlbHEnIMvg5uZkiV1Ap+p60qJME2SGJb4B++N/JpRdudAHAOOQ3hhL?=
 =?us-ascii?Q?Fni16908W+Myx7DNwzksxw9SPpWuiB8wXeZiqCnb5/IaDNBJQQEV9acMTlfB?=
 =?us-ascii?Q?JP12fOdiFqh8Rzc3Cb7SBp1ZJkiV8p0oDV14MOgzVZpdhFngyfmzKuyVMex0?=
 =?us-ascii?Q?l3/pwuWQNVSCeDbFZ8u8bb/oRtMbNsaqmP9/wai5TFzyOlG8j2wwsBWJ88wP?=
 =?us-ascii?Q?bf/yCYrOQaboOgBvlUzD+37oS8MZcF2uaw2AusJardKvuzVlzrhcD2Y+v7tj?=
 =?us-ascii?Q?g8hsmC3WsWI4ZQteJi/tJIvlbH5EaSEfQedJ6z+6rvROWNgDp/YYVA3wgrAq?=
 =?us-ascii?Q?sJJPQ7yXrZpNVF1ik9fIrXSPA8x4n6qei57iFzSnfCyGLYZkYlcbr6obl00i?=
 =?us-ascii?Q?j+20blY3NVugsxgMm+LWqa7h4oDLwrYua4ZbPjz46OV4vuZngsGUmmh61eFO?=
 =?us-ascii?Q?7YM5vMA8Sc0e1kxsgQQP8CnJiAAWwLHAaj5T1zdaLL80ifP7HeFidTFjyi9p?=
 =?us-ascii?Q?5mqLsbI9kN4gFYKILxUzZ9QsrwoMVKCkvxRAAiWWTuf1d45UtBilemmfYtFQ?=
 =?us-ascii?Q?qWOEWxh8uhEZ6UNHxSyYLypSLcvXGme90JafQqjzv9YnDHUMcmJZWUvVhEj+?=
 =?us-ascii?Q?We9RPY6Gc+ct+OLMU8GJd/9LcpPxv+B2pLBXTbYynOv/zyLR+H5Ny2a7329/?=
 =?us-ascii?Q?rjm2k9lRRe8rUboWAX+srp+vRrK97NBhZKhvXgvfoAvbBgCJvRXVg5CCj4X5?=
 =?us-ascii?Q?NhmAoOQjKIoZRhGrdSHW3eRoVPcbY6hlcuRYSvgITrULWjtZTXYKmth5oFBa?=
 =?us-ascii?Q?Gv3TPDGlxkcrU9u0usXhS5wehnhsnxoMYuVUD42aEc1AEeBbC6Wg6jd1CfeY?=
 =?us-ascii?Q?aFBDQvSjaKOz102fM2f2XqUIv5kILSIkufcUQu3aLylKaH8qM+vYJUhJm9n8?=
 =?us-ascii?Q?i9ri2SmrKdVEyhGwfOij3nBgE8iJ3Ml8IPtXscAIYjG0iM7PoWa5MfR7XVx8?=
 =?us-ascii?Q?8y9EUFF0T640R1GZHA5Q+ubGoecAIjnGCgdqj7xbdebC7zrvxXesplaAM3gL?=
 =?us-ascii?Q?AUmxW0suouV3RAo3jNLbFmLt7ksCSYi4uNH1qgiHsWucFSiJQ2lCHlV2nXQM?=
 =?us-ascii?Q?usGAiDFI0mzag8NkaBbb+lxF5uoZG3rp379omzUsW1JMvId3jZvLfTwuPdjI?=
 =?us-ascii?Q?urQuu61yMqKBsMM844n3mW7pa7ou7esuZzQfijSzDwFlWrfiNDcxsOgBgS2j?=
 =?us-ascii?Q?dLoUewhK+Cu2NFjKQPZUHGNGJA5BalEyTmTXuMIk4Xds/gCpVKSweFw024nE?=
 =?us-ascii?Q?u39qbnF2z8TlHJbh7PgKIXnLaVrRTnkm76ooVQIXOm77YYHc7jOB9CkT2w+6?=
 =?us-ascii?Q?s6IMw7JZx6JaNYfBL7JaEjy8KZHldOTDDiA9q4xblS6+/e34anYGyfMkmmzf?=
 =?us-ascii?Q?ApeBJD7qydHRha01pPj0KoZefthlOO8WaES0QyKlWCAcb0TKnpeu86dU4qPr?=
 =?us-ascii?Q?DtpQsyKuQJlwerauA89nacTXgrhEGZknceDrpidJKJTLEUo0Cj+3H1LxkWbq?=
 =?us-ascii?Q?UnwdIV197bcWff9SM+MPftR2/L2JIaPYEkr7oVDc02NZJioYzw9yqxNeLk8u?=
 =?us-ascii?Q?h3y/HdBih7B9NsyxiMwBN4rBjodgiVw=3D?=
X-Exchange-RoutingPolicyChecked: HLM3SnQLQNBtxTztsRLCYiW5N79y8NBZTNHuaF7ut4R0XJLO9O+U7xsHk2WkN44EsfCxIuxSgOmYnvYnBa/uUTtFYryqrwSws66UCXWXLvjnub554VtnIBIS3fruULjAroKR7g7FAZlqrsx1ZZbxhq/uBeoNPi7vYrI3aShbOZs+ji/MsW7NPbgeo9Z1lQhTqKE6558FyaTtJVjoWWYopQZFvW+upX2IPqqSSlGe3a7o9rnCJU0oni2c6j1cPE1koYDKzcBH2rZCI7/EPte5jem3EK4lUEkcuXd0wTLlQ+s0teRsR79vISf+pHdtiXlvC2lp7ssOk03k9BRtwaCABw==
X-MS-Exchange-CrossTenant-Network-Message-Id: dd7aec33-8d39-40d9-d21c-08df467b673e
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 20:26:34.1015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CiLeNTtwdCUuz9gsj1Sk5tVQjxJ6Xmw0mcHRcvMabrujE1UnKPo6rPcPMiEIq79CQqwdz/pNL4rm+EGKqSySklWXVR0Tt8JNcIGNEyikp78=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB9771
X-OriginatorOrg: intel.com

On Tue, Nov 17, 2026 at 02:28:07PM +0800, YeeLi wrote:
> From: yeeli <seven.yi.lee@gmail.com>
> 
> key_options[] is used by setup-passphrase and update-passphrase, but
> it is not terminated with OPT_END().  The option parser walks the
> array until it finds an OPTION_END entry, so it runs past the end of
> key_options[] and interprets the adjacent sanitize_options[] array.
> 
> Before the fix, --crypto-erase is silently accepted and the command
> prints the bogus usage:
> 
>     $ ndctl setup-passphrase --crypto-erase
>     usage: ndctl setup-passphrase <nmem0> [<nmem1>..<nmemN>] [<options>]
> 
>         -b, --bus <bus-id>    <nmem> must be on a bus with an
>                               id/provider of <bus-id>
>         -v, --verbose         turn on debug
>         -k, --key-handle <key-handle>
>                               master encryption key handle
>         -m, --master-passphrase
>                               use master passphrase
>         -b, --bus <bus-id>    <nmem> must be on a bus with an
>                               id/provider of <bus-id>
>         -v, --verbose         turn on debug
>         -c, --crypto-erase    crypto erase a dimm
>         -o, --overwrite       overwrite a dimm
>         -z, --zero-key        pass in a zero key
>         -m, --master-passphrase
>                               use master passphrase
> 
> After the fix, the same command rejects the invalid option and
> prints only the valid options:
> 
>     $ ndctl setup-passphrase --crypto-erase
>       Error: unknown option `crypto-erase'
> 
>     usage: ndctl setup-passphrase <nmem0> [<nmem1>..<nmemN>] [<options>]
> 
>         -b, --bus <bus-id>    <nmem> must be on a bus with an
>                               id/provider of <bus-id>
>         -v, --verbose         turn on debug
>         -k, --key-handle <key-handle>
>                               master encryption key handle
>         -m, --master-passphrase
>                               use master passphrase
> 
> An AddressSanitizer build reports a global-buffer-overflow
> immediately after key_options[].
> 
> Terminate key_options[] with OPT_END() so parsing stops at the end of
> the array.
> 
> Tested by building ndctl on the target test system: both passphrase
> commands now show only the four expected options, and --crypto-erase
> is rejected as an unknown option.
> 
> Fixes: 374369ac2f67 ("ndctl: master phassphrase management support")
> Signed-off-by: yeeli <seven.yi.lee@gmail.com>

Thanks for the patch!

Applied to pending for NDCTL v86
https://github.com/pmem/ndctl/commits/pending/

I made two updates to the commit log when applying:
[ as: fix Fixes tag, describe the overrun as build dependent ]

Fixes tag: 374369ac2f67 only added MASTER_OPTIONS() to key_options[],
which was already unterminated by then. The terminator was lost in
8e4193885357 ("ndctl: add an overwrite option to 'sanitize-dimm'"),
when sanitize_options[] was split out of key_options[] and took the
OPT_END() with it.

Overrun impact: what follows key_options[] in memory depends on how
the binary was built. It may be sanitize_options[], as in your
example, or unrelated data, in which case "setup-passphrase
--crypto-erase", "-h" and "--list-opts" segfault instead of printing
the bogus usage. The log now says the parser reads whatever follows
the array, and labels the example output as coming from a build where
sanitize_options[] follows.

-- Alison

> 
