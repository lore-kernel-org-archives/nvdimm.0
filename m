Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FF7226CFE
	for <nvdimm@lists.linux.dev>; Wed, 24 Sep 2025 21:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758747771; cv=fail; b=iLSaWlQCksKtJzNTZWTO1hk2ucPvPekEp6TOvu4VDCoXnEa1ysi31PU8a2agZlrC6gVZDFcaNNdmxH/Xq03sOE60aoDgMHOPtfQ1LgMlrbNN8WITeDewjWBCNG8WMaq0b/jXJWriK6tLElQjF4xLxE3r0oAFA0lpJx5qmpsjkQE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758747771; c=relaxed/simple;
	bh=eWiodsg1pbV5f5EdjTGv/xjhWnua4vHvd0rtv9DHCg0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VSBbrRXbPSBiSpBdpoLMB7qiUAjsceqQpJ7zcWjTneHPqmvPJIkW/gc75VFjUe7oZQaVf2D9UG7drejOgLFzkAXO0M6FpIV62f8ylTDREcVpaiPM0gIi1sPf9XTYB1D/t8hniGqIn0L8P22UXVfh/0WDmGhi0aJnr3T/n9NtU08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U9pt88fp; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U9pt88fp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758747768; x=1790283768;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=eWiodsg1pbV5f5EdjTGv/xjhWnua4vHvd0rtv9DHCg0=;
  b=U9pt88fp6atT/H4PL6Lg7xfwyvl3KD08oKY4PRlkQsTF4jH+KIL/t9Mt
   Fn0qVsDS0fOR78E2AS1jSISu/d2+4Qtg1X+/hBMnkVOPccWImHpgX1pfi
   QARoM9ww0rIfipY42Rtc5jQDMgy4hz8a+HQf27ElZcEDjDyH7wF/GaUeD
   QSdd9ZrEZpV9mhGzl4sOXm1SQ4UCQWhomMPlP7uvSHPGZCv27XQLWUaHC
   esC60t7QqctSziJbkQYBDxejLyFx8I0kl/rvvPhdrYC5pOMOavbvzpjOO
   pyG3x+FXCWUmJGy5355KRzWHQaevzYtfTHk8TtJzFvvchUZL0VHHlCi2w
   g==;
X-CSE-ConnectionGUID: bVSXcgcQQL6yW49IWMAaiQ==
X-CSE-MsgGUID: IuQyGZ0FSJCFSjpm1ia0KQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11563"; a="71735824"
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="71735824"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 14:02:48 -0700
X-CSE-ConnectionGUID: 31Stg1/MRoa5Gxxga0iH4Q==
X-CSE-MsgGUID: DJD6IFjmRtSrOoxsdN04cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="177525820"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 14:02:47 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 24 Sep 2025 14:02:46 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 24 Sep 2025 14:02:46 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.19) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 24 Sep 2025 14:02:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X1H94POv3uUAUoXhsAa9a3297jfHXjcT45rQ0/3SUP1IhfYwIz1Y6poX+Y8UtHBpfD+y7DhZagLHhsGivGbN/5Qc6k0YwpTS6JyrRmdBHkpnmHGtFf5ycsk2qcpr4EScErERKjILYtP8JS4ZPJCk0esYbgTmyummHVWnsOWcZFiPiB18s/Ta2U+9+Hl//+lX92XoF/iMwVc0TctQkp0jkake+iPecGowyFspRNRAzxpubYEb2Rc2wMhXudmIt6I+fCbjTYyauGy1+YKzFFTEGGr4JM1v1yvFOZfAt9nGFiYGIkfec/ft4pGlZxvy7U32EWl3gZ9wLx8UellfHe2RlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YAIjjRE4fWfTsx4NUtY0klHAMHJU78zQALLNRhhKZUc=;
 b=vS8Ov5J6GV9+gTPyvdEsEHaTNBbpAfUbxnuV1uTjkuh0yrgSEF3XViqVigYI2JtJ2nOL8DzRLZq/RL05oEy7U/ZTUFgPtukuxTMvuPCSt0hlqMqnTSrnFSJ35H3PzjEeNMCMNgis78ZjfcJCZANmhHNQuJ2o8Q98BOE+/0fVSWZ+wQ8l4A0jAnQkMtLwPZXEa7uSDe5MFoj5auiBjoa2jH9Zx2sXy2Z51GfHqffoJgQaqHHOjS9ptXPTJCgcYHrsKRATA5eJljCeq4KJ8KEApBmKxa2yzHLJ67UlHrsNmDqLmfEZHlICF0VKZtQQYalDH0sdflIV81dA7WQgsbVB9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b) by DS7PR11MB9497.namprd11.prod.outlook.com
 (2603:10b6:8:263::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.16; Wed, 24 Sep
 2025 21:02:44 +0000
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde]) by SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde%8]) with mapi id 15.20.9137.012; Wed, 24 Sep 2025
 21:02:44 +0000
Date: Wed, 24 Sep 2025 14:02:42 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: Dave Jiang <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<gost.dev@samsung.com>, <a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, <cpgs@samsung.com>
Subject: Re: [PATCH V3 03/20] nvdimm/label: Modify nd_label_base() signature
Message-ID: <aNRccteuoHH0oPw4@aschofie-mobl2.lan>
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134134epcas5p3f64af9556015ed9dfb881f852ea854c4@epcas5p3.samsung.com>
 <20250917134116.1623730-4-s.neeraj@samsung.com>
 <7622b25c-a0d8-47b6-910b-9b2e42e099e4@intel.com>
 <1296674576.21758556382506.JavaMail.epsvc@epcpadp2new>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1296674576.21758556382506.JavaMail.epsvc@epcpadp2new>
X-ClientProxiedBy: SJ0PR13CA0089.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::34) To SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF0D43D62C4:EE_|DS7PR11MB9497:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bb6d125-e75d-4563-22f7-08ddfbadb54a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?BKtMaE+qts//PlI6wDqPcAqh5EKWUfhnF1jN0ku/K62oBG7S6/feOGdZgEdn?=
 =?us-ascii?Q?gSgm5z610y2sqr7K35UsX1nMxHeXh8K2vIpTxlGSHb0tnL2ZBBVDnztAsBAa?=
 =?us-ascii?Q?zO8EO9S1QpM/tKX+v7RuMPv6pnV4BKDzk78kCs7EX/02lUPr4Axt5iIf2gWV?=
 =?us-ascii?Q?RUcww4tnCCMIwJqPN+OpsJOWULj1gPLvyAwbw33r9hctZGB48qJEOUOgQ08J?=
 =?us-ascii?Q?VKJ7VYiB/rXXi79EIlgpNYAPqObgbP3ZCNw/cMfpnSHJZBb45PT/WAguhrTj?=
 =?us-ascii?Q?QO85tD0YFXCrc8A2vyXVOkd+mkbBO9YI+BO/qKhjQKVz93y/bXo7bS/lhXQM?=
 =?us-ascii?Q?Wym7naP5ixbVDnRJW+y6VWIaNB9kS4QGJAU2mT9Csk/j1FymstLaukgJyUSe?=
 =?us-ascii?Q?gab0/T6vLPo3eBceWf0kshicKljYGuZ2elEntQ17kfQIleYapw/BLmi1llJB?=
 =?us-ascii?Q?XXvwH/IKa+kE2Ft90QBYWtvvTBLeBwv7UhnEmfX+bJuR2WjKEpwLZ46Wsev2?=
 =?us-ascii?Q?Ko1dBQKrGY544fZP4RGa5WFs9gdxzOniAbc1LhiFiXuHv8WueC17Nr0AyeSL?=
 =?us-ascii?Q?IpPSDUVbzt2smGRtMl7rYInA/7wiGND00zGUpGPnluo0leH2eWgopjvBbG4m?=
 =?us-ascii?Q?RyEylBwWOP99r8xGlU/Za6q53O2yAHqoe7n1W3gRennBRnXhneO4tC0EIh9w?=
 =?us-ascii?Q?eDr5konPgVq02CY0mF9wbGXCZkGm1WFkxvEd705+vwghRWJRm+O8mRlzETI8?=
 =?us-ascii?Q?HsrpbB0q/4pbvTZwdBVx32XMKcLtEIxisqcFk0gKishZGaSYAoyudJL/TPWS?=
 =?us-ascii?Q?AZIasVUxMXzX3m8J3D0TGfu26bSotzKjhlOdwXYx1kIRtWP4A1QLXqw5+w6B?=
 =?us-ascii?Q?yqpDe75sNKNbUHVsdlZB59f/QtNCwVx1ZSlEZQez/HWvlOW5zOIf20OotDki?=
 =?us-ascii?Q?nf9KkctTdm8FOArxHHRX5RnFcIgur0B2rjd+c0JlKrGRhmph3ADVjL1nrt1n?=
 =?us-ascii?Q?AQAcAKxSdPxjrS8GPsyWcZfUwEF36kTzzcfkBIX5tr/TZCrQfkEna3X/hSwa?=
 =?us-ascii?Q?4fjdmd5r7GrQal5TKHOiv+IN2MTTVp6hj46dLd0x6/HS0jE7vkwmsbsRP1hI?=
 =?us-ascii?Q?AnkU0Pg2gMXZrjUrWgs3Dwnh41pEof8APSsDl4F4FdsA2TffDSgsP1sH+NQG?=
 =?us-ascii?Q?75wfgUG6iQgM0QiOjqkzn7Q72ftTCIpn+foiwP07wdtnAJntPJihPKOpZ5RK?=
 =?us-ascii?Q?GCpABdK0xXfMU44J3y8cHFhW4i3oY8COgpkm1XUPdbh5pdkE88+wJJJOydpj?=
 =?us-ascii?Q?DGT08hQecMURKEeHov111Dsu+bmsKeOjNkUs1dEpazQsezcXASdwj9ZFu8yS?=
 =?us-ascii?Q?PuL/D+a01+Q+PXS/lGiiIlvDcgEfGyIDQrG7F9pVpQ6NdL0xuZdpH7Yg5cMl?=
 =?us-ascii?Q?ne6D3zzfE9s=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF0D43D62C4.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZA+LrgkxmE2ApcxxjtOYvnoX9Yf3AFrmuI0gpkRCjEN5Dsla6++jxKGG9JWA?=
 =?us-ascii?Q?ejJh06qaiS1v8YpCYEjMMLe2Ng+evWPAQ6uChvHFgSYfNjMKUIzl8Q2NJJqW?=
 =?us-ascii?Q?6lhSYx39opnAIFnpQWYnwnLLiRhTBJfwsW9dOMJITFsad2ufv37usoYyAuqT?=
 =?us-ascii?Q?wt4yZdt/nZ8QuKc8Rdb712soeWn9LUGn8MKeC3KS1Izb/J0+YihVFVmZrzxU?=
 =?us-ascii?Q?T7lO61KedO6i+4UmayKBNjXr0Umg8dfPoVTDJ1zEROFZMRqbIOkEHhDN+m3a?=
 =?us-ascii?Q?kOiSioc6J+ka9xOqil98VUMbk1g3TdjF01Kbzuxpfjk9ycul026UD4fAxCM6?=
 =?us-ascii?Q?TXzPCEo4qXyzzMk1E61hspPKU8c9DjAVqkEYdPOGpdnOUitOL5LQQ4kibLf6?=
 =?us-ascii?Q?rdctwS+AxpZWsEB/+I8OYu/3xwKQ5Y8kVihTO0bf+PrHCYoA2DKMqPvyU9Q8?=
 =?us-ascii?Q?UI184pX5WTwa8JYN+OkI1k89Z0rypS6gqStoPv3tH3xmzNRyKUkb3j5CPpka?=
 =?us-ascii?Q?EQWFus6R7YgBCvQ7xFIYkVbsOPjuwmxl/wLVRAL2pnLnVSNDFMBmYTjaKR6e?=
 =?us-ascii?Q?n5eT5Z2oH2SpRrciY+eU82H6+BE7aMZW1tPjnSfCmRhAySeWilSgnMPONx01?=
 =?us-ascii?Q?Sn7fX+qUsMwVr8LgH516VOvu+2iRkIWeT1t975g0ZK8oy8wZ53pKDu59O2jo?=
 =?us-ascii?Q?9JZUUs045uchgmVOqY12z4mcd9Er4uqHx3CTWiJd8pZ8TdqOt7YkKHZ0bLZs?=
 =?us-ascii?Q?0D4Feqp7tcNmA7i75nPv2nvzudGcX7AkrxUyhzn9mQPvNXaaCFmSwQkxZc60?=
 =?us-ascii?Q?6o2OK/H9rLSid3nrazUE+0gh9+OQsE1TYnXQG+igIbwLBZkV4de5gdlOk2q8?=
 =?us-ascii?Q?EYFf9PLGG2p4JnLPmrArP1DWHA6SfcQAX+B93tER4r+SBWJg+WLFuAk700fe?=
 =?us-ascii?Q?FHEsJejfk6nZdGuJUcosx3xLqg9UBCuAjAkI6KM0+uaq3BNqNU7oM9lW4ZHB?=
 =?us-ascii?Q?lO9lgNxySJZz3aHXfyXgRLIY3luk6uuaam7W7ND4xdDbY9pQTT7ZZUaSds9E?=
 =?us-ascii?Q?A5Egs65hAhlwfQvkO4UqNSp1+9oG1Eax5sB5Z6wsqTUXcmA95AmkZ4pOgnFY?=
 =?us-ascii?Q?7IxcRy/M3FAVBZcDWc0y73pTjHnFb2JEO7/elcJamTSUSxyQuu9ksv8gQa6U?=
 =?us-ascii?Q?HYkrcLOMZh6bcTRchCZfcnsBC9GfFsJW6l7Xm/EtzMW4RbnfwOPSdGphjQ9O?=
 =?us-ascii?Q?aEV3o27B3zCPBPqt+MvPo4L2r1LsAF+JtXkUjiFL2bMWJlRp1VhPRVpngv5s?=
 =?us-ascii?Q?/8gBLgO73EhAu2xS3hhFwtszSHivswjquUhzmyCSj4H2H5wtFTUQnGLiaL68?=
 =?us-ascii?Q?axmkzaNVvjYwPguijRZ1Vmek5/rbLF5xpnKMD57zr3Xy8mkDQK/eOCcvWoqh?=
 =?us-ascii?Q?WcRi6cyUL+hEXd1XG7fA/O51UJZ3HyX+paZNuoyWGeaxB56HexHZiWTph3NF?=
 =?us-ascii?Q?XkJ2O7Aliedr330yXWNumNCCPSmNT7nQ24bO1xVrZNPr17fnjfiwf6Bz0kMy?=
 =?us-ascii?Q?84gMeL3jXN756FDkawVJbyThf7R2q3Yj0lfdCHDsY0VEfY92UBUWR/JchnGP?=
 =?us-ascii?Q?dA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bb6d125-e75d-4563-22f7-08ddfbadb54a
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF0D43D62C4.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 21:02:44.8251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lEf8poafig6nph6J/oB6z+dr2O0qlcWfg5sIfCCJ6DD+0+HbvL97bIT+oSnQPmVWqSy4GoOKPHKW/SGwe1SEmA9CZlsbC/pOl83CAPR8RnE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB9497
X-OriginatorOrg: intel.com

On Mon, Sep 22, 2025 at 06:14:40PM +0530, Neeraj Kumar wrote:
> On 19/09/25 04:34PM, Dave Jiang wrote:
> > 
> > 
> > On 9/17/25 6:40 AM, Neeraj Kumar wrote:
> > > nd_label_base() was being used after typecasting with 'unsigned long'. Thus
> > > modified nd_label_base() to return 'unsigned long' instead of 'struct
> > > nd_namespace_label *'
> > > 
> > > Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > 
> > Just a nit below:
> > 
> > 
> > > ---
> > >  drivers/nvdimm/label.c | 10 +++++-----
> > >  1 file changed, 5 insertions(+), 5 deletions(-)
> > > 
> > > -static struct nd_namespace_label *nd_label_base(struct nvdimm_drvdata *ndd)
> > > +static unsigned long nd_label_base(struct nvdimm_drvdata *ndd)
> > >  {
> > >  	void *base = to_namespace_index(ndd, 0);
> > > 
> > > -	return base + 2 * sizeof_namespace_index(ndd);
> > > +	return (unsigned long) (base + 2 * sizeof_namespace_index(ndd));
> > 
> > Space is not needed between casting and the var. Also applies to other instances in this commit.
> > 
> > DJ
> 
> Thanks Jonathan, Ira and Dave for RB tag. Sure, I will fix this in next
> patch-set.

This is independent of the patchset, right?
How about just sending a one off patch for this, and shortening this
set by a tiny bit :)


> 
> 
> Regards,
> Neeraj


