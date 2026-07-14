Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E2842EEA3
	for <nvdimm@lists.linux.dev>; Tue, 14 Jul 2026 23:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784071413; cv=fail; b=Pk38AfqkUWsuvCbc3obMirM+QaLBYrL5iTe/MAnN415mmBSNWy2bNZ2jgZtm1vK/iyda/HhOCUs4mPFmdLTH6C25x3zmdyq2D2MaVywQkQ0eRBFqgHaHKYzqQrS+8FPBfui/+fgtpk6iqPduLx52GrVbFFNOSrGpj/a2A0HZVJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784071413; c=relaxed/simple;
	bh=P5TAaVuTThd2RVSKMx7u4UTHE1s+FdFMjPdNbmtHJOo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Pl/9T97042DdE3Jk05/cjr6ll4WzRN1HxPCi4ndJITFjdaBbW2ScJpZwomYe9qocdnPUsi1zfoIRTVzgSQMzXuYGBY4fyu3SRXVYnJjaizqjIEzJTnorfjxeEC9WVklRI/Brum3RMQXTsn3qts+14+NYHSCbubDiqNW2UDqJWTw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m81prBzn; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m81prBzn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784071411; x=1815607411;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=P5TAaVuTThd2RVSKMx7u4UTHE1s+FdFMjPdNbmtHJOo=;
  b=m81prBzn0u2U+dqHz8I73RpmkVsDJGIhz2EV8gHkUIdNiHJ2mdbp+VT3
   Bx9VWvqesXpVqeu3SqOaP0hHN1y/pWU/M9iXgxHVt84uWF6tkjl9dbLj4
   I3Q68ABk3vSKoXpuhqOVbWvtMD4fMZX0ZDJGYhFtuG/z+is3hlMT2f+Ui
   UNVemIIn2KiL7jjBDsVz2P3UNlPnN7a0KkNwWi5DlogspIoTK1dUAHohG
   nn4JWziayTvv0IdwowsbJFzaVr7kaibzYPfrdAO7V9fG4w4t6OwFDV9ZP
   +fmD/qpoLYFyFw5bFci+xz81EJsSslTciOjbMnghhgsEIjezMvhsTj/Pa
   A==;
X-CSE-ConnectionGUID: 6RoAUTGlT0q7+UiBhocbPA==
X-CSE-MsgGUID: X1gKwVZaSuWM/wb1WpkLhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="88382356"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="88382356"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 16:23:30 -0700
X-CSE-ConnectionGUID: MsDkdUp/T3mMkm9DPrNhJQ==
X-CSE-MsgGUID: GEDaXurNT6Ga1mQGo/1XIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="255493209"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 16:23:31 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 16:23:29 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 14 Jul 2026 16:23:29 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.68) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 16:22:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R1FQN3aYUuTufj0+YkTUE8BnTnqVbnMPPtfqzWb16wFk3hUYnsvR6YRTo4X2mmLh1yA+HvG1MsQlElF2d8tc7E6eabw5/C6x+FzxG1aH1JlUJDD5MEzpk21FrUvzI79ea/T/CSYehS/zXS9AHrKS3rHd+iPpOssXA3CVdYa8Yrj+hKrTwfiQPXeTBht/djP9Khhgq4ja/S5zPRcPilK6/dtlEkqjKKKQ+y9vcSoEX1Tiic3s1WbQ+GhP3uQRlDDapTupkbjzrXQtXkyj6rNZnUoHrCZUTCig6MVNUn3WMDIKqkom+xiYhMDwpSyTnYN095fKm7a+iZzTEJiHip80tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nVf4qWeREGpmu8O7K9B93SMjIoomwQHRIhB2y6fyfx4=;
 b=HIh+UzqsSJWx2z4VfWxiXbwJrQkVR0lLXsmJgS/useM1z5/9Jhw+CmaySfksMm1RWZDwCb5Fk8JhLAvo6b+jq9fYFoTf5/z6zYpkSN/AXn9L7nRMtqbLyb50Dg/0zJof2WT1XGy388c+GWWPEsHNVQAEbgBCN0vFGysq92ihacFeIpTG/dDq+wFkqnGEoMj82qiwaXI4i6gN9njiSY75mb5pGHkGxtnU+5OXqMtR+klOU9uhGxAI7B+/3V60lzIvU21fL6VgGL+z92cRBsbkI4fyW037SkzqSzFaXQnsLXM+pZMRkjNdwb6ZsbHr9L39mug9LnNv8U7t234f1HvP2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH7PR11MB7987.namprd11.prod.outlook.com (2603:10b6:510:242::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Tue, 14 Jul
 2026 23:22:54 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0223.008; Tue, 14 Jul 2026
 23:22:54 +0000
Date: Tue, 14 Jul 2026 16:22:45 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Dooks <ben.dooks@codethink.co.uk>
CC: Vishal Verma <vishal.l.verma@intel.com>, Dan Williams <djbw@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <iweiny@kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] nvdimm/btt: fix sequence endian in btt_log_read error
 print
Message-ID: <albExZ_-yXhYR7Iz@aschofie-mobl2.lan>
References: <20260624150602.905561-1-ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260624150602.905561-1-ben.dooks@codethink.co.uk>
X-ClientProxiedBy: SJ0PR03CA0085.namprd03.prod.outlook.com
 (2603:10b6:a03:331::30) To SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH7PR11MB7987:EE_
X-MS-Office365-Filtering-Correlation-Id: 579fa643-8cf4-4822-747e-08dee1fed460
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|5023799004|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: yo85SaC2mo5mY7YpuuAEAoriIIfIIvm3dID4QTjhwPWzwVBH2WRvZ9aOQJWcHHtnI/MMPGPtEnW1vdxdZC0zv7ecXDMJojuT0knAXgkVixo8coPuwUYyZiIUJKiH5oFYibwNRfb9tPRBiwBPz8nFuxJZX8CuiCBt6chc+OHicM3BmRpBe5KlDIFZFGe12MZkCAA9E1AVwR4zrdxs9xTnmApFXOBd74/WAsCuStnmx7uRKmVt2PO8wBoDR7mffqM6ufO1E1GF7krvv7E9+AOQWeW1J1bLW05sVrXg7N6fD8CTe3BpK6AxIBGYphOUxZyVM92QndZ+1iUeG6a41g2RteM375Sr3Cht5o5xuTgi8slWhFGBUpMHfQLXunoSHOeXAd1L4M42gPVsUSUNdEeCmwU+aVVE5twONq/oqrMkUTp+A0y454kV24hxVzeVa5JKipOSq36d0eBsQkrOSJ6QwV0xy0xtgqPtM3L3MwME5s84XbXcrEk9tMVoabhLG4Rd+8VTZOLrIocNbQpmSKiEpYB2UyWcVGzuHTrauXnL9pqK4ANlC8sa+zucVF1nZcvMm5Nm+AalCN+YVpFFPbOI3TruML6e5ZjYnghPif/PT9N2KV7IeOXg8baa2INAoDHi8VZ6xgVTLa1AlbbybW2HkArDmAIPa3WB0PlTfvCIMEk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(5023799004)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K3Zf7odI17j8Pf22iRVSabhDLUQihD+xQnZ0UdXESh5AY/X7acbDz12QupdA?=
 =?us-ascii?Q?auByGfGTXvVx/QEARrCSruxdrg4m+KrsnKQAtBoN4TcrWWj+4wu85HInVwn4?=
 =?us-ascii?Q?dOkcTWMPI1okCnvIhtGqEl0GZHGijsR5XxSOiscAN4uJiOW7Rz4LDJPmOOSF?=
 =?us-ascii?Q?ybn+K5jlL/mttsQFrIAa/R5OuithiexpWcQfVyAWOq2w0Td6Q1CxqFoOP7tD?=
 =?us-ascii?Q?DpIViyxutCfplXiuDOCd7ARwyaNpGdS565qwTxinqksHvql2NVTPhx13s44J?=
 =?us-ascii?Q?ix+kLVUNXLZvNsDLMYmQe4Rp14VxzLfjCFLIY4M7x1mqVxywUAUKKsK9Frre?=
 =?us-ascii?Q?4cpI7IId5PJuLNbx8idQzyMpJGFC0oPE1Xjol3kIL9VtNlcDDhdiM4MNkvLl?=
 =?us-ascii?Q?oitjcEwOmvSIgpak89DsF8WbNQ3Gryrgkr8S+5b5QxC4t6qSfaGPQLESX4pm?=
 =?us-ascii?Q?n2QbVM1Eh3LiI7DY3UteQjy16JTzig0XJl3rJw7SU1lTMm1RvxlahYfN8FfU?=
 =?us-ascii?Q?9/nwdB0pozsZBeMe8A9TIokvMPITkxvGtSKw81QaXck0YX3aLfD+bHqzR+Rt?=
 =?us-ascii?Q?5K59ExjoLakafPgHRD+6r8kmhVxn7Pke5+tz6xlEpQq7fsrm2EZr1uMFbZYt?=
 =?us-ascii?Q?c6d4OZV1JdEIC4QYHV+m7cPtNwpru6XNnhfMc3vrJOAW+l6pggmQkywQeryd?=
 =?us-ascii?Q?METfEGX46JMboYhNPd58nDg9i/t9xj6cXTtm5zyhJTalYljnGaYSNR1t3nS1?=
 =?us-ascii?Q?sc2j3gRmszdt1Jezeb67FI8gYO0PvzYoazXDUxanXVuUv3nBrKZxGokHKCA8?=
 =?us-ascii?Q?SA9u4DMCt0d7H6Z91jqn4WyAFZl6joVYWM8v7dLpUd1tp3r96jemi+RYyowk?=
 =?us-ascii?Q?vjNxdy1cCMCzpQXo5Ujji5yU/g7bFE8t3g9AeV0qNhqokmVw82je7mBUcaXT?=
 =?us-ascii?Q?uYAutxMWh0FYEkbkLncCVnFRnCgopXX2ySCG7wAxc6mXUVKOIeNM4TRqYG7D?=
 =?us-ascii?Q?k0Qn7z/IsVt8bydwIzMbKvSb+JzvSa0zRE44XcuqWwOHZGBcvgG0FE8TikXB?=
 =?us-ascii?Q?gmh5ajJE96wkaSDuwnl0j2TDSqRZfTh1IfVTkszps2nD7tlKGo1Ox2miuYjR?=
 =?us-ascii?Q?IRKIa11RJH4eYydqYXinSx/tjLu9Hiy1Lx6nZyeDtw7nEyE+nELeEP0s/CFs?=
 =?us-ascii?Q?DT4B3WbxQlcp14iCtmHQxtGpZSwRNxwuNzUw741x0I9LTZIzBUs++COaZTd8?=
 =?us-ascii?Q?+QdfswRHSp5/Qm9alWtwKu45F0Sx8Yi4ksP9V0+5/orcwuJ+nJJgLLroOcVt?=
 =?us-ascii?Q?rCrSMC85Uj1Sq65697u1BkIJD+pQht+fKwtn6r/ZFVI9gOsQpSpoulzitzVU?=
 =?us-ascii?Q?G39gnJ2CMi+VvowRaVE6wnv9iqa2LW7uQ32beZo21PvITnfjhEIkUtzxXSAJ?=
 =?us-ascii?Q?mkEK0HeMpRlWFyxi2+pBgNHDNWnS0XLq38HJU/mQeljJ69S7/Z+oEyUNQWNn?=
 =?us-ascii?Q?pyZ2WRcmrblvvlS/D8aEBa8BByQsqszUqmwYiysQvEvoz4nJcbNvDN9hWj2i?=
 =?us-ascii?Q?w+Qpwnc4T9Bmh1NjBRWyB9MBB+NyKiOJPQIxzV7LsWrmnE1Tgi576YQBnFq8?=
 =?us-ascii?Q?kuMTyUZSwDab8tlP/3y6k+HhgOUs41QCfPhR/fYVvQ75fxqHETTTYZtxATuU?=
 =?us-ascii?Q?8mHVh13vxdX2Vw1nh6YoGR+HFVvt/Tm6uwNe+AwmD7ei8PYd6ara+uZPN1zC?=
 =?us-ascii?Q?2wACA3lz1wTf/qLPoonwdrg30hkbv1A=3D?=
X-Exchange-RoutingPolicyChecked: K0CSeCRW0NUaCc2ROjADnLHo5i+xeL/7EEeWhXcz59ztTCRhndTYE3flIAA7gVq0bDbEIDrERytPm/3ijF8pDf4cS8RVtDh3oP+jyLXC/WEwGKhFx2M91VRE4+FaneSgNWZmFhRdiPPieAzxdKSut0a0B/ipIDgfjQ8NvfUUzJvEAlhO8dawDwF/WChojTa0aYpJVEHvSfm9nUOtVOqehKh3MjE5MYvXbHyXqsI/J+tlnlTZPU+a41MB8D8Vdb9sV6pTk7BaC5nIYID9e1syCeQr4X1o5MyAWZrt1E+n8q/4Jb7RBJb96lwtm4E3duICv2iOZUYpSfYPmIaJVBVloA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 579fa643-8cf4-4822-747e-08dee1fed460
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF0D43D62C4.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 23:22:54.5540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ANTvLhBi4z4Acw06uBpSxA5RXQ5iaJBhag20Z/yKOnfBtdm6tBWceogCA/ljgFHfcN2uD406zkfZ4KkRAUFsVzV1VnbSxZNAQMF13PpD2DQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7987
X-OriginatorOrg: intel.com

On Wed, Jun 24, 2026 at 04:06:02PM +0100, Ben Dooks wrote:
> The error reporting in btt_log_read() prints sequence numbers out
> from the log which are stored in little endian without any endian
> conversion. Make sure these are passed throuhg endian convesion
> before going to the kernel console so the user sees the correct
> sequence number and to avoid any warnings from sparse due to
> endian conversion.
> 
> Fix the following (prototype) sparse warnings:
> drivers/nvdimm/btt.c:342:17: warning: incorrect type in argument 5 (different base types)
> drivers/nvdimm/btt.c:342:17:    expected int
> drivers/nvdimm/btt.c:342:17:    got restricted __le32 [usertype] seq
> drivers/nvdimm/btt.c:342:17: warning: incorrect type in argument 6 (different base types)
> drivers/nvdimm/btt.c:342:17:    expected int
> drivers/nvdimm/btt.c:342:17:    got restricted __le32 [usertype] seq
> 

Hi Ben,

I'll wait on a v3 of this one that addresses the Sashiko review
feedback. Thanks!

-- Alison



> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
> v2: reworded commnit messae
> ---
>  drivers/nvdimm/btt.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index 7e1112960d7f..e9d548442884 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -341,8 +341,9 @@ static int btt_log_read(struct arena_info *arena, u32 lane,
>  	if (old_ent < 0 || old_ent > 1) {
>  		dev_err(to_dev(arena),
>  				"log corruption (%d): lane %d seq [%d, %d]\n",
> -				old_ent, lane, log.ent[arena->log_index[0]].seq,
> -				log.ent[arena->log_index[1]].seq);
> +				old_ent, lane,
> +				le32_to_cpu(log.ent[arena->log_index[0]].seq),
> +				le32_to_cpu(log.ent[arena->log_index[1]].seq));
>  		/* TODO set error state? */
>  		return -EIO;
>  	}
> -- 
> 2.37.2.352.g3c44437643
> 
