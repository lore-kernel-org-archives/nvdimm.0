Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990A3234964
	for <nvdimm@lists.linux.dev>; Wed,  3 Jun 2026 00:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780445727; cv=fail; b=EjGOwWzJs3Z/PQkB/Hu3f7ORFMWTNGz1wqpIXiWMhhE4wcNcl6NXyVMh4k++h8jL+/MsJr0O80v+uy4FKvajC6tEMpiyAwVGM9K6cErEtEQlzK11zi99JwbpwHKgbDyiD21F7GReuebDA+i6gSOMwiuDEcZgxTAWR5CNgHYnB4Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780445727; c=relaxed/simple;
	bh=7vOMDoUiG0IASWJ+q6bVYRcDJyq66HEHoxdBsogEusI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=L95D97IlVjoIqRqrnWen9GB5dVyXdoaG5h7Hfm+vVC02gOxoxDmCEkKPVlUZQnci+ZGax1HtXmsvIjk3LhZNRyRPfI+DhCyqKnq2vE5gZY9wB0X+U559wSlDhe11rkUfupfAWzzsuONVtZJBQo7JI2oxU1KgzhCPEmil7HXYvmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BzmXJFZO; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BzmXJFZO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780445725; x=1811981725;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7vOMDoUiG0IASWJ+q6bVYRcDJyq66HEHoxdBsogEusI=;
  b=BzmXJFZO251sM9Ls2aj2CcGNoTHF/iIKC9imvAQcUIXYa0HCqdmIvJ/g
   Jp7hy9bP0jEF1qufm2IwmYcdw4f82euiunyQnbb7QyUn+7OAoSdl0Igv2
   6Zc6lyHGm7C0PoHw1vsXcDIhQMbmMHSt5SJcqELl0Loxtoy8m8fAdeN2C
   Ja733pRZzN287RGPtFo4WRkpvp2SIZsrAIktPJc25XSUrLgmXBnSVbWoQ
   cqbBgBVF7PKZJG4fq7OfJXeagD8yBRN6fBZvqRS5VciHiTj81MJjy0eA0
   q+OLR8X1QHqErpa3Cv+xdsHIkMdT/lmRu50p4m/x6TaaosKEeT32XcSeo
   Q==;
X-CSE-ConnectionGUID: wRh/n6lDTHWRYyYk5iVxGQ==
X-CSE-MsgGUID: Pjp+LAJsRFSS49X4b82ajw==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="68786219"
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="68786219"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 17:15:25 -0700
X-CSE-ConnectionGUID: /MqleEMBRGOrFjRgn84PvQ==
X-CSE-MsgGUID: EswQsRPVQwKsTw2O+bHVuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="239604309"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 17:15:24 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 17:15:24 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 2 Jun 2026 17:15:24 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.69) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 17:15:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MqNeDhzMHV4uoqGUxpiUyG3hkuzU+Jv8tYx8zbavNsp9OFmJeh63vpjcHlH1+7xse/D6beLx2gg3pvfHY+AVzo6CXdZPoR/jeQ70ROtrNfvSohm3h/Fk5Bdh4K59+sGuJMBvTAN/28jyDTOnqDAsEYIT6wYU6b/GZW4Am0juIg/gKWjrRkv0gbOGWUczLkLjukxIXrkK+0AFgpMM3YPsT7ejmw3O6U15GBAOA7msAhRGwn21tnAq4WZjKsZVleGThyHAqiFSJW/KxxJgwAPDkEpu0ITsKwWAbErC8S1Nc4Bxcfvz9KtSTj9inKpdRRXgvCwTknI8THEV8gTqtxoU6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ouhs+0gazIi1t61j0LX/wVlKXff8CTOFX2cCMYsoWpU=;
 b=E7KQj4XemzsX2Mm8TSY25ED9190kxokSoBKniYtOcZeF1P47dLgb/KANb+nvzT6epFhdW1hwWrSMzmOuy4sx9g3hXZXoBFsu7iJln+vyig8XNBqbqKmLOPsQLq+djee/9drwSG9/QNRe1SpLE1OqQggTe4KvJOdzuQ2/o7upx6c9yhW+5Pyo5IKNOyumvOQFfE2G/jAm7Fc2M0emlh7DEEQibQXGO+3Z5ARaMSQhnVCQDH3R7vFc7I/i6uLWyM1jc+JSYNGwLmZtZ29Y7hFRta+3vdYuIc4seAIPDP/p+2udAAWhPnHeDgbxCOPxDlAJAoEQ9VeWh8mOZS28zWX/vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA3PR11MB9511.namprd11.prod.outlook.com (2603:10b6:806:47e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Wed, 3 Jun 2026
 00:15:22 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0092.006; Wed, 3 Jun 2026
 00:15:22 +0000
Date: Tue, 2 Jun 2026 17:15:17 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: John Groves <john@jagalactic.com>
CC: John Groves <John@groves.net>, Dan Williams <djbw@kernel.org>, John Groves
	<jgroves@micron.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara
	<jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
	<brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Ira Weiny
	<iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V3 6/9] dax/fsdev: fail probe on invalid pgmap offset
Message-ID: <ah9yFZA1hJrevfmP@aschofie-mobl2.lan>
References: <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com>
 <20260530165107.6687-1-john@jagalactic.com>
 <0100019e79cbfeba-7b2cf549-f869-4572-bc78-b32ebf16eb7c-000000@email.amazonses.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0100019e79cbfeba-7b2cf549-f869-4572-bc78-b32ebf16eb7c-000000@email.amazonses.com>
X-ClientProxiedBy: SJ0PR03CA0115.namprd03.prod.outlook.com
 (2603:10b6:a03:333::30) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA3PR11MB9511:EE_
X-MS-Office365-Filtering-Correlation-Id: ebacd8e1-6c5e-4d1e-63d9-08dec1053414
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|18002099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info: lOlJC9XCk1UVcNXD3aj/b10Ksul46y4N2x4OirgOyv4cmHJy2+G8mEqA4VCtw2Uhz0rUigWCFdxs2HGM6TrPftoh9QuU+OGKhWs7//dCL6IcsEnSC4+DeCy/JVvLJdbdxt9FmowjCKrr3kKBwvngvPJ/SgnaRDUDVpmGmymmorcg1WJsdHBt8jMM4z07bZZf83WZ12U3XjuuRXR7AIlCltxOBqm34moEgfeVAZ7ikjZWefI4BTu5EOgll4TmenCNsGtng3KWWtXq4TL4oRTu/QeLwrCw31QlTBYijO4UXmoCz2eUOS+z3Ng+6tB6jzAKmYsGkDPWsSz5spbfcA6N7ichgjUAX/JN2KKpN4NgW2toYBP2mkrAHu3qUC5Ze3vU345DS2BPK7L/Lk+EPg1ni4HoZGeMSU+3+JL73gZROKaC0ZvjieNSo6si6ObkexxBtcOfWgiLg4+5L+z/5LAobKLkX3ifpTiXQhinyZ7MXe/KxEg92oVgfVmDiOSKk0E+BIBXMsJzZzoKaCQ6EmhC2mFLdiYM5ezzr5l32QicafsKmPs3Afzsp05/uaXpB6G26haMj6UdYjGIKT0rksncgipemrYgpIfsfJxJrZaJb6IUxGcBHrCcwY5edX2OTF5uojqVqIjJxIzAbhLXWTr2Cw1fVqZgrROn6zmWjL2RUghzbg/RgaT4U9p8l8+cRcUd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ey5NqcwsiJGlaCcKcqU0Lg/1zIdqR2Nm2h8UjFIv/8wrSiQWV5DQdNiQRUId?=
 =?us-ascii?Q?3x4Wbh/Rer0q1/pCaBMeHe3ysyvdU+XVeTE5qCaaqvTrddPHv2VhA+Z1ZutR?=
 =?us-ascii?Q?SaAtLqjXzsc49iQB921cKdVgHXsVAOlsEhQxKk6XZaw8NhpmdvlMNwUUHx7g?=
 =?us-ascii?Q?hk9j6A/GoPzJyj/xcheZuRWtQW0jHLU6XFT1LfeoU0pEjEcCdvSDtvG+T4Ol?=
 =?us-ascii?Q?nE4UeooSkjrIHjPuQk7W6X1YFEgLuxtRA0NnOTK/XTgYYRpE53XVTZpAck3g?=
 =?us-ascii?Q?RmOgrNZrkyzANqxRiwin7Mc1QPwMsK66KUptjm8Dz+q4uCR5ORWyKDN6lnPt?=
 =?us-ascii?Q?gpyb5TKTAJKamMPaOMwx6n6B7OJAOIg4ICVsMw6cHdI1EKpzIqEFoJvZkel9?=
 =?us-ascii?Q?MrGk6zvt4lIrR1yQePhLL+gad5dnSk24bAG2z4gE9F0+qEJ7uwhMIVNNlPml?=
 =?us-ascii?Q?xMXQgDGrn3UVn4Z6mOWp2KtLoLnMstcqr/UFcGSu0E1bJaXpd0Y9Q5Qihony?=
 =?us-ascii?Q?0yVbnp3mVc6ng5PLrb1scbfqNYLOW94OW3niZKmw9R183rVTg+sD7w8Npu8P?=
 =?us-ascii?Q?kUtse30wjQqmmfvlqSnNNUSLhfJSeFQyFGSnUSV65CovSrSB0lMKj8PjpavM?=
 =?us-ascii?Q?BFGyk7EE/o8SwolBYxm71gG2aVgya+3tpvphPiOBsjWdMpAvTyWPQiPaSrnk?=
 =?us-ascii?Q?dhv4kRSkHBThE4SVzodn59y5ZlnyotC90qFTvMVDrnvNXFPQ/Io3DmbNrDrj?=
 =?us-ascii?Q?cyJsQW0YmzmRjJw5uXVE7p8cOb/sHxHt/jOXfMpON78NUwU/ur3dNFd3izEq?=
 =?us-ascii?Q?FGGnvsdvd718OGA9ybGgBDkmqtHRjaAEJjsDP4L3k98KBlHslbPMzHtg17HC?=
 =?us-ascii?Q?1tdxSq6HqK5nZ7OICJbnc1fukEuxEz3R3amkDTjkmZPH52wuAaJLED0WK979?=
 =?us-ascii?Q?44pKyhQdQUU7fMW+r0V/KyVWyiSDsl63JK8GeW3fn2uGfK1pZ0tcmQ4pxpwB?=
 =?us-ascii?Q?Ue20Xmm+gBjQCBiitcp9/SeEarFG8dGp4MwsQ9B3N3ujqK7Brb77rxedINhH?=
 =?us-ascii?Q?yyAPgyB6h00fnUPG0NcM3XE7ugtyFTPIM4l/o7mncUabLRBonhokNPDy3Px+?=
 =?us-ascii?Q?Bdsr9HS3XPtJKyE8EOOAR0hnt+uGnWIjETRp+LxM15t27qQfARx0hfXnkdFw?=
 =?us-ascii?Q?c9WY0hE9oCdlTTyaMYZpG6tQi8J1Icx7h9C3LrD8U7lGrAu+1bs/jyq1IIh8?=
 =?us-ascii?Q?jc2FELPERYXkutNceyagYijbku/uasfWX0ZCDZcspvmY3RGH96BitH+w6aOi?=
 =?us-ascii?Q?mIwkYPOzMTNFklDofYCvD3Si8ju2pOA5FKHogVMLPU8qqVlBl2gvKG+8/ecE?=
 =?us-ascii?Q?Q8Fj0sWk+gNgIuhLhH4b83tRx3E65RvgZxF20m8GVvdKr0mfUlhX/jjAvWf9?=
 =?us-ascii?Q?4vKx3PSdzUaUNB94pcSeHycM5UdiJu8BqDhv3UNmHtQYrRbkL/foB2bGUyJA?=
 =?us-ascii?Q?gpFksUL3Zv7fSOM5Lvbfq7ujMDraNS3bLFIDV8zt6kfVRxShaMFlJqX1J+CZ?=
 =?us-ascii?Q?lmR/wZH2+T0+Yx2cx75QlXIBGfjid5+jqpGkNHj3qVo31FzRPGpP6zujs+Af?=
 =?us-ascii?Q?bR1eRg4l4ctX/9WT15GI1cpbnRrWmoiMjRWBYkqoUmdmeTpuWW36oyLIuv8b?=
 =?us-ascii?Q?RQ9DujOYVS9Z6y8AqGGm72vcliwDhnlD0/3sA5lxxvwfmhtl9yghzX14meHQ?=
 =?us-ascii?Q?SqOthtduCTjSpjzxfENPG6Spg7NcjqU=3D?=
X-Exchange-RoutingPolicyChecked: M/abUoM0TAw3acGbLG6RemDreVbsbxNfYcjMxZwDV16irnTib+9Xc4317yeulM1e0Q+yk1WFTZojcLtf8ORydOKvl980wOVLw0oTcQ3evIbjncRFVkhFK32lSEIE8PXC/vay7s/aTGq5UqVen330SZUYtsWHt64nm05zyoMeDdhnPB1F86tAUwNU3HVwm4+6ECphelmqUzNHgew3XucrmtJw3usVfDD78fq/IDYVy1AwuE0DfOqKuQ7yHEUFEG1Q/4+IEmWLyh/m94GG3LR59qkXVV5PahsClyszy9f+tzXaEqEHjhY3uVqOLRpWRDZ7sjWdq+v3G0cRQQ00TnBgAg==
X-MS-Exchange-CrossTenant-Network-Message-Id: ebacd8e1-6c5e-4d1e-63d9-08dec1053414
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2026 00:15:22.7158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tL41Jzo5EVUflU/g4akpuIPR+bSfrP0cesL2FLVoJb1qNUVYUBHRBZG3tABj9rhnwhoUKIEkgmxIb9tfL0RXt+/eAdT9ZqMIcx/aRiemBKA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB9511
X-OriginatorOrg: intel.com

On Sat, May 30, 2026 at 04:51:12PM +0000, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Convert the WARN_ON to a fatal error when pgmap_phys > phys. This
> condition means the remapped region starts after the device's data
> region, which is an impossible state. Previously the probe continued
> with data_offset=0, leaving virt_addr silently misaligned. Now probe
> returns -EINVAL with a diagnostic message.
> 
> Fixes: 759455848df0b ("dax: Save the kva from memremap")
> Signed-off-by: John Groves <john@groves.net>
> ---

Reviewed-by: Alison Schofield <alison.schofield@intel.com>
