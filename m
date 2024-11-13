Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2343EAD0
	for <nvdimm@lists.linux.dev>; Wed, 13 Nov 2024 21:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731533310; cv=fail; b=EGjnMKqdOfMo8DlxCZVSXvDMIWNsprz5JCZ0e8gU1HTaU+RVPS+qtdzB3nc22uRZRvk1d8KTf3WuzrdhjWlU39VuZvQ7vs1JL/q800k5Rd/Z9VdiLZwbZeA3skk7riC3mfsZyeSVs2D0Wvsc4PJFtzDH2Sk0AzvQqBZab+0rh9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731533310; c=relaxed/simple;
	bh=QNA6J//RjGtz7VmQxIZH7eMq1xv1SDVCZvWHmuiMjC8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nort8zORL+Otos3GqdJYBNm4grRL6zeCfRrB5qvKi47CDbcDh1VGi/J7JmLB59DEhPL/1Lnaw1M4lKE7WB4JycgscLYaA+Fv2T5bkRqp98AmhhJ7pSQ4Dm5i6FxJXzkPuZH2eYnNdY49e9zYtTX5h8GPpJp0c7AL2orl09P87dw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G93Z81XG; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G93Z81XG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731533308; x=1763069308;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=QNA6J//RjGtz7VmQxIZH7eMq1xv1SDVCZvWHmuiMjC8=;
  b=G93Z81XGhEZI9sPKU3mQf5UVaDJgolJS5BkW4cfivvjbmZPARHPViwXo
   GgEyj/LXG277L8sBL3VtlVyn93xHyU+PZ6UDxEo3kph9CY78s37isQbVw
   36zinDyAmZKS7JIVhjNzysa6ZmbJg3bsQTobxakV4H03vg+IlpBpnDzAV
   owV6If4EMlotab2urnSebIZAp632DjGuGNMLq4SUw9fk6pkBNu18G8Nep
   SPz5Xbe8YYOx8QakwecBEAsK5EUzCeoJFtCjsRrdnw/4JCaTxGDiZNKa0
   kFvm0abuhWEqO/tdDFW4PxdtiQMh4Z9zZq/8Ovw2yM60l61xRySM/+yFE
   A==;
X-CSE-ConnectionGUID: HA4+/KPfRpO0csF4F7fpOw==
X-CSE-MsgGUID: ZM2pDkUWQAq7nr0CINVF5Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="19053257"
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="19053257"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 13:28:23 -0800
X-CSE-ConnectionGUID: HFygRve/TVasRFtrhCL+Ew==
X-CSE-MsgGUID: CLDskonOSKmqmrvgO8HwQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="111307237"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Nov 2024 13:28:23 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 13 Nov 2024 13:28:22 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 13 Nov 2024 13:28:22 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 13 Nov 2024 13:28:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VlceadgkUkmgpzpnyugZUr/P4Uxu/mqZaney3ultmfrf1uy9KGh9m5bsnc3dLF5m9UjQaZPR2EV95yQBJsZZY6JOCMPqNw/7Cm2rRouct+FX23JvoADVXxVwJkEEhyzK8sIaMKu6pu8PIlbX8pJWqfJJiQb3B8tjMz6yp//igub5ILud0qJOyPdLpIkHJOZ6JErhoNgxT4wAOiD8Sy2bbUnNuiIjijU5HLLIynTr44iviqwvJoLEGX1BqbX4iGYxvi93MKJCMaCTAMaxenCMF90lCBvZWR4cu9LSmlZDf3iscTS/J3DRX4KHpFjK/Pm319+NCFsGcT8RD4LeXM2JPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Qatanmi/3WPXJNVJNW+DSlZg6hv/zUwi57fc3PWgZA=;
 b=bfoA+2g4J2VtptYqEegefwrgY/+RnCEmWzeVOITsCwHNKQFshACriG5vGCI0LB5iy5tI4NMRdtcpjCqkA6Nv/3GGTz+HZ1OpkTfj7LPU3qevnZNBKLi/wCSrRMnwJ1PVJlF+k1EdsbwjYwtF79VxrOs2lPJTRTqEpDtR3+LYp00XGUR7Z65SLIEGDICj96FVgFTGfu77G67VpciJxGViNA/W1We0A72RatXcKLRZoW+te3InPxkPl6AIyTjFJyTEdC9X1ggUYjQA8Ra4uLC4VEGHrlo+25kLYm7csgntByFZ8y+NUDQ2Q02vDQjKQ9fWG/Wl04w8cZ6MHjR/XEE8tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH0PR11MB7496.namprd11.prod.outlook.com (2603:10b6:510:280::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Wed, 13 Nov
 2024 21:28:19 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.8137.027; Wed, 13 Nov 2024
 21:28:19 +0000
Date: Wed, 13 Nov 2024 13:28:16 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Keith Busch <kbusch@kernel.org>, Ira Weiny <ira.weiny@intel.com>
CC: Keith Busch <kbusch@meta.com>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH] btt: fix block integrity
Message-ID: <673519f07bf7c_214c29470@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240830204255.4130362-1-kbusch@meta.com>
 <6734f81e4d5b9_214092294be@iweiny-mobl.notmuch>
 <ZzT8O_yvAVQDj2U6@kbusch-mbp>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZzT8O_yvAVQDj2U6@kbusch-mbp>
X-ClientProxiedBy: MW4PR04CA0052.namprd04.prod.outlook.com
 (2603:10b6:303:6a::27) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH0PR11MB7496:EE_
X-MS-Office365-Filtering-Correlation-Id: 35f92589-fcda-47f5-2049-08dd042a17f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?qfgECbQXQA2o+zhNllqyAuagmpJZUhqLCQhzH3H/Xa43ejBldW4j53Y+rIt4?=
 =?us-ascii?Q?JY41gyJfdITo+o4KOczcP9wRYMwy55wVhlEPmcgvEByF+6fHkLmlaWY/c15D?=
 =?us-ascii?Q?rmPPJeT7Hmwn8rn/G/Bq/oel20ITx9OMvsuxVXqy1UGfjKSU/HCZW14M6VUC?=
 =?us-ascii?Q?m/UU/xvKVPHUZnsb6m34DuISMF1Xq2QLORxxJcolpcVK/qb6GnhDTaFim4mX?=
 =?us-ascii?Q?yuyfxgILciCkFH4rH7G5JUR1HY2OJvx1iSW2pQWXjd88oSZNpEa95BAH1UbO?=
 =?us-ascii?Q?iBsFM6Wy3I1P9/KzjM/ITbu0PG58Sk93VJKvbfBjz55xacyjC3hbEbmFF+B4?=
 =?us-ascii?Q?ZHI0I5F0aLC52fgSWyTb6eH5qumaLHkZKw7FREMXjZLr+mA8hTMRN0qh/Nss?=
 =?us-ascii?Q?h7EoD7+JErrQhGGljFvIdaWV8Sk575E4bWAxwMFCHRCSQZf96sanaEyCTL/J?=
 =?us-ascii?Q?MMBGcwy61XNpVwkab9s//7YCl14FX7Gsc+yGeN+n20bOknKweO5V/whnF2v4?=
 =?us-ascii?Q?YLWYf9ISKdgptp8ZqubitWTq8YEp+He+a1K63vHhfj6nsHCUFjFsNkKG1YCl?=
 =?us-ascii?Q?LWO74lTR6DNMuwtXF+fRLCd31CYWpMEelFubc9Po+O4N87W8VBXkigXOXfZ0?=
 =?us-ascii?Q?/uiiskrVLXYSUXj9L5WxorDEe8gh4OUvb7bODpiJmXP3yUTN5/OGb5Uw4JRj?=
 =?us-ascii?Q?VHd77snZIvVnt4rUT3ML5MsQfDFcNxMxAsvxlroopkGKYUGn+Dn7M9oUysT2?=
 =?us-ascii?Q?T4Gu8P6VCOLC4R4nOmwky7HG8WvcFZ01T5EyKus0SFrGyDwxe49/M/hbgLHt?=
 =?us-ascii?Q?krC5f9VAYA2DQvE5HFUcRelFNq1JfHf4xrz0jNTx3xdsKITA5VNhz627yBRn?=
 =?us-ascii?Q?BP9zjMA7jEM1yn2F7coC5sV9a4vOVWT9jvEjvNbxIbgERa7Rl7EbvfGZ2axj?=
 =?us-ascii?Q?cx0EDj8iF+51GRHHQDbiS9WAMrTsU3oWjV0aQhOZvHAXWOJzKNGfOc4jAdGO?=
 =?us-ascii?Q?RxyEhuS5ye1mR5vIwwqU4fmcfRt/aUUPM6RG0JDDPoPyOJ9HY5YHYxcjJky3?=
 =?us-ascii?Q?mPH2ls5hAdfMprtPF3HzB4811H3xIVFQOJGGjn8AUQ4ecsbP+vjVi5ag/BH4?=
 =?us-ascii?Q?e+ffgzkmxDOXS2cZieHjiwnFbsawfAFcCy3eNmip6GlxyJi8AU8Yy+pQ9lVs?=
 =?us-ascii?Q?YKucEU0eXhVYjeQAsLgNLmrngvWsF1WnX0rvsAqhw0NFw1Jbxx6bJkyzhrDe?=
 =?us-ascii?Q?DTbVPnVTgWTLzFYfcRlg38dqOYU6PGWoEDOgxoWYkqVesFIh3EaQeqG9mRPP?=
 =?us-ascii?Q?bITI4ez+8dxINNK166dIBDeE?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9M+eX6PyK9lrvUWHSk3dLx4o0zmblz04mmCtIdnQDLUoxq0vtXhIYpQXj/Yd?=
 =?us-ascii?Q?iWZOj/JAjYAX6fDahzsAM1bpdh2b3QJQJFYih19bnPmaqyBThUsRv4tbKl0y?=
 =?us-ascii?Q?hWj1jPzQDxzcgkRvgunZK/98jhzA23kGrHD4/vUjTWufcXH2uj5hbzJ0/u83?=
 =?us-ascii?Q?S3F3fcIlnyUPzLDDbvJDrSpv+hgxOSd6GsVLl0ExFJBkP9FlIrh6VLT/lNNQ?=
 =?us-ascii?Q?SEtI/R7UvTGKShGuqm01IOiybpGU3+/gqEmAK1zNDn6fieGZJ3i0w0E2cVJh?=
 =?us-ascii?Q?DCu5QLCCLwGb6ud+tAdSCKNcfxsqtLQZEOzxBTxW3TbzW86RFlmPq8j15BDK?=
 =?us-ascii?Q?q451ssFCIoMH7QilJbT+oj6hlffP6jWDCR1ezI83LLXYbpf/zRlQPqtC5nJZ?=
 =?us-ascii?Q?A929qoTn9YNnEe8W+0BaHfOMrsjLh/JzOla+NOK18xOf4zx5kGPuMRalf8y9?=
 =?us-ascii?Q?Rt2z74iS0itJxOk+RKBP9EvN1Ad2jk8UxsdBmLQa1RfCAnjKgr5UV0EO/372?=
 =?us-ascii?Q?swlSuGBnoAsL+ICIIf5JCqeWQdK+wh2/J8Jo3sRDhqn7TMLbOrvOCRfspq+f?=
 =?us-ascii?Q?8GypJtTpIUKRW6yoD2TX+V5qi1b6KIIiZ6omais0P8ZQLz3uNrTKfCFVCRBs?=
 =?us-ascii?Q?h0L+Gtqh9Fc6hOvLfm4ry3tfMHgQNnJ0KWGYsvAKx0N889uCR9PglApjkip3?=
 =?us-ascii?Q?1fsIZS29/IfmmpuPjYlYYBQfxzm8Cplv+lFNyMK5zQ4zXB6UNWuGJvS4uOQr?=
 =?us-ascii?Q?qrxtUXKyUWUjWRL0OABNwzi4xPNap5eNR/MqkW25i2TydvZFJ9w4la+PXqZY?=
 =?us-ascii?Q?4zuUySVAl09YnXpO25xDitbakYIez+L9fRlLGo22Komw0kh/DwrIuNLK4Awc?=
 =?us-ascii?Q?Yvef9ScW2WnPuH9QedLoOgkIfJhLWegdZm5TPzc0//SVxnIUYtZlJkGxv/b9?=
 =?us-ascii?Q?mK7ytF8U4vNQKuy+by4dYXGDLNPWlgoTijByiNEDShQI+Ot7S3O2Vkcp/8gQ?=
 =?us-ascii?Q?cDrO4G+XkiY0EXGMJ5r/qCvrBXBh6SrVy6yJW8SYZGlUAhr9xjK3InQevd7S?=
 =?us-ascii?Q?jRhalQf6sIyGt4tgWVcqg+J3DI1cpsWB/e8PgqvhmV5cffFalUA8Hogp56Xm?=
 =?us-ascii?Q?BThcaS54FTVntRAp9Mo+lvCoMxkNvHHIK3GIMOc25ofwL2mgE8nCX3zjB5OE?=
 =?us-ascii?Q?X34mo5AeE8s5xeHPU6POOD6jLAnoF3V1Jkdq+kRV8UOreXXh9Nrc9fEBV7xp?=
 =?us-ascii?Q?fe2zJz7zqGUd8QBGz6iyH7niw0wROcW1XwhZ8svmi+m02TqQAmyEtxMhCaWV?=
 =?us-ascii?Q?RLpVEkWMpLHhN3mplgKrlk+jv4mcKpzWuHv8U1km9YY4lG42NZToa7JAbuxC?=
 =?us-ascii?Q?c8dtj8b8kQej4c30eNYjWrQAr1/2GJJORnagx4n3q8MbtbIZAriMsiZhPwFe?=
 =?us-ascii?Q?4TX2CAdOhPqwLLa/j7xYGxycFVd30pFbmipW8Of9Wu54sw9oIWBgTELzIy6K?=
 =?us-ascii?Q?0LxrbXodqrQ8qtGEc/joXIjhYXIaxSHSNxLEMTmijFmNLHWk/FqRdyadrsOo?=
 =?us-ascii?Q?jf5GyxhaygEzyGG3t5qU+xqQCJY3ULYHPCt0/fp/OTXzCZwcLUy6ch9j4nWs?=
 =?us-ascii?Q?JA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 35f92589-fcda-47f5-2049-08dd042a17f4
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 21:28:19.5185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3i8vpyU0yuzdYr3YgcoGWQDsrw6bpwnEPd+58UcknjEMo7RDoNQGgznsfHfdEq9XGZuxEpa30XwIddE2yUOIxBtbOy6nVHx63PI8ZIUDfL4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7496
X-OriginatorOrg: intel.com

Keith Busch wrote:
> On Wed, Nov 13, 2024 at 01:03:58PM -0600, Ira Weiny wrote:
> > Keith Busch wrote:
> > > From: Keith Busch <kbusch@kernel.org>
> > > 
> > > bip is NULL before bio_integrity_prep().
> > 
> > Did this fail in some way the user might see?  How was this found?
> 
> I think this means no one ever used block integrity with btt. :)
> 
> I found this purely from code inspection because I was combing through
> bio_integrity for a completely unrelated problem. I was trying to make
> sense of how other drivers use it, and this one didn't make any.
>  
> > I think the code is correct but should this be backported to stable or
> > anything?
> 
> Up to you! It's not fixing a regression since it appears to have never
> worked before. You can also just delete support for it entirely if no
> one cares to use this feature.

I think most people are just hoping that filesystem metadata checksums
are catching torn writes and not using btt. For the few that do not have
a checksumming filesystem and are using btt I only expect they are using
512 or 4K sector sizes and not the sizes with integrity metadata. For
the ones that are using the odd sizes with integrity metadata they
obviously do not care about the integrity data being transferred since
that never apparently worked.

My vote is delete the integrity support, but keep the odd sector size
support for compatibility.
