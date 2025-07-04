Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52EF17E4
	for <nvdimm@lists.linux.dev>; Fri,  4 Jul 2025 00:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751588246; cv=fail; b=EXlLirFKK/8rvqMsfMZauzjp8zMpMs/Uz+7lqq2QhQfWMsxy3wzp+III4NSuhAY3Qw1X04dffcmbvwTo43rB0tbwENWk+d5c01ETeMhD5xA39ug6XvOWVS6nshfxACMbzKbSqCyL26ou5T76+zaoFfwnO9vXW3g0anOm/htZNl4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751588246; c=relaxed/simple;
	bh=8ryC9wd5SJL0MxRl7Vl9bUrodBksz4ziKONRDq6B+ro=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WbT501i+CEOKyVlN8vzu+xXRgH7Et0BCQTQlqk1KrslDxPGdbJjpyPbp3W1wChQpNIxel1cHigsjn+I7elbLx7F4+JbMsinMdp+vgcIPfHv6tzMLk3FHOTZMARPbcmTyTXvmHmtzJSAYRW3w03bkGDFF+qOwwniQM+7BT3dWP9M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j117sme3; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j117sme3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751588244; x=1783124244;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=8ryC9wd5SJL0MxRl7Vl9bUrodBksz4ziKONRDq6B+ro=;
  b=j117sme3sRc1/JKXHtIOm2AQvsmZ1MzY1P33JFG/eo1Nm6wlNIcXLNjV
   pWLPG6o9tOlAUVubhPhlrWQRNpHRCV1OZqy8KtjYh5+sQwPoVD7s9/+sI
   rJ5ZKZEmUod6DwrEmZDw3aTnbEkDyPWztTTqhmdcJ7veuw+faZaA+YZD7
   xiq9aq8sgs/b2fkzW2f0192k+5MA55V4OV7n4YJjKcj4omo1LL2L8f8U7
   zsZHfLOWfAaNJubOgz9URll84V+wRnbt2VLkoZ2rS3KMs7UkbvMLoicas
   dPh2y/UBrfPEDP8c3uHK8qj9tELIoLONBtcjR/XaWDJmu9a68gSj4BSro
   A==;
X-CSE-ConnectionGUID: gzFfHTl0SvCgBx8vePOt1Q==
X-CSE-MsgGUID: BN5+/BWqQ66lz+UvIv0HdQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="54069109"
X-IronPort-AV: E=Sophos;i="6.16,285,1744095600"; 
   d="scan'208";a="54069109"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 17:17:23 -0700
X-CSE-ConnectionGUID: hoGmzaoiSg638A3G+2Ae5Q==
X-CSE-MsgGUID: V0QdcvAvT/OrXBjn0Nv8LQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,285,1744095600"; 
   d="scan'208";a="185456127"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 17:17:23 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 3 Jul 2025 17:17:22 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 3 Jul 2025 17:17:22 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.48) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 3 Jul 2025 17:17:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=odU/fCAnTkpN3Ho4hn+ODPdyhlgCpBUogq9Ds7seX8uDHeQyz5KsyfZhPW3LlkgYuaZrdUwOWTRV6h40zLh22yCbKEUaR26FeaE9dn4ayx0tDTiiIifASSvNw7soJ6YTWDmQyuaLg2K5LxENbacp0DqRkKVbBRw1Y2yNIw5Z9koiw0p/tjqWw3VezNn84EopUAGDGdbWo3tle5udjIA0hVYKyGvJCGJKBcLEnDlXHUGQ6ZjYlxicLxs8Y6Q0uxKYLhGEXbAKOcwDl5792TlBW/hiMBqud4+LamWQjLz+prMOJTenWw6ly0C714CQC+PFfrwTnMYaNHagR0XQjf1OVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kKimAuUfGPlucSUOR8Ghm1K9/iW3eDDO6HY/H8WV2GE=;
 b=Bi8wyzheFm89lJb3niTFDC32gwDz1BiyRjAPr8WQ2LhZZglO0XfCUR5JQ+0W2mlp5tmL8wczOb1TwlFIuXJTuSz/OU4yITNpVHxoXGuQZQkBinFey4ZJWY9QdAeUNqEAedKPBI8E7iGz4f3DpXetR8GD735u3Eokz+vdncb1KVHnExj3tRshR/wMrClTsK+kCj/B3EBhqRVbgA25HC24WhYiiZbZQSiExw2yDwGkUwmIzhQXDNh67G8rvthKaz67EfrU8NDo1TxAd6YjDiiXJh0U0OqSwlJzT/fHSNJoZ0YG1zcFbtOA83/LgOjPf5Qf6Ul5PFlGLEHD7jWzoo/oGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by MW3PR11MB4763.namprd11.prod.outlook.com (2603:10b6:303:2c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.19; Fri, 4 Jul
 2025 00:17:07 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::8254:d7be:8a06:6efb]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::8254:d7be:8a06:6efb%7]) with mapi id 15.20.8769.022; Fri, 4 Jul 2025
 00:17:07 +0000
Date: Thu, 3 Jul 2025 17:17:00 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [NDCTL PATCH] cxl: Add helper function to verify port is in
 memdev hierarchy
Message-ID: <aGcdfKJ0shbKJTCM@aschofie-mobl2.lan>
References: <20250618204117.4039030-1-dave.jiang@intel.com>
 <aFM1iWWREEU_dlyF@aschofie-mobl2.lan>
 <46ea54ab-4e20-47d8-985e-53cb7ebbf33f@intel.com>
 <aFNBc0JqMxWT5CMu@aschofie-mobl2.lan>
 <a940a130-4c77-4f7c-812a-e273ddb01458@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a940a130-4c77-4f7c-812a-e273ddb01458@intel.com>
X-ClientProxiedBy: BYAPR04CA0016.namprd04.prod.outlook.com
 (2603:10b6:a03:40::29) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|MW3PR11MB4763:EE_
X-MS-Office365-Filtering-Correlation-Id: f93d0f5e-8c93-42e1-402f-08ddba901c79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?/LohspePg6Y5OfSZegbOxVn5JWjQxgLNSXYZm/pfvadVbvL1qVBPx6DTx0+r?=
 =?us-ascii?Q?w9hdSRKapGU8Qd/AV2sPtq85up/FF7SAsVNd/WnXaF3HPRKOPVxJNCoXI+Z2?=
 =?us-ascii?Q?dNeyHXg9RaoLOq8F6iwpwK6rrSdK3touCcqgnV56+jd+HatVQtzVitjnE1+U?=
 =?us-ascii?Q?5xB1ghlFbH2NFxKjqIq4XV407uWnJRs8QFZXDkC2KN1XeDZL9CUxYui9Z7/f?=
 =?us-ascii?Q?2jzR7L1dt5mc5zVQeBqYseRs/ZfyEnk4P17iH4jddMKgsBHQKNptcC+1rowy?=
 =?us-ascii?Q?iv2LDhMD2KHWvy/GE8mHICabYB7FL8Y+NzVz7+/qgP8CElgkjy78eXRx8U6F?=
 =?us-ascii?Q?eR+mbDG8/IPJtUknoEXShhywd4ZQmzvNBRP3pzoYuVWFg8B5QG1GNKeSxFXU?=
 =?us-ascii?Q?sguTWo4v9apZS9LF3iL4ZNaZInItmJvMBaw7mWDUqWll/u4NUT8rI/69r69e?=
 =?us-ascii?Q?yodV/zQw1MV5RmwoBiiemDVggKlt75Nsj92iSPEtH7hfvO2BXDRSCZrKYovn?=
 =?us-ascii?Q?hDe4f+p3gtB1xKcTvrOxt50uoF5mFaprKnyV7QiqvK7fdr7ZM1xyH0HqWO1g?=
 =?us-ascii?Q?W6JycxWVyja2KSsday2g6UUbOtSJha07CNy0suKU+cEP9a8e6aJEbjrxbTXr?=
 =?us-ascii?Q?fgpC+cjJfutFsiVSuT1bEu+/kHG7FkIlOjN2f+MQjGfOW0qyB7171vGRwDvw?=
 =?us-ascii?Q?iydjrUestTDhSR5DLs7q47RSHaFdXtAKk6pSB54tg8Mfd9LWt26H0VYZ0Bk+?=
 =?us-ascii?Q?KxEO2s2ERITwqqLK+031HLQtT9hOJjPf+RDNg1C1+I7x4Wb5h4KGheS9GbpQ?=
 =?us-ascii?Q?LzPBwbpnGQEsoRN9qwscvgwTOf2aZDQelCdIXmbSqQO2yV1jLfU7fmZhjbXh?=
 =?us-ascii?Q?jqURDz7gigyF3snQhcz55YKqdRNYSAPgMz2kiOvXsXSdKjDIrEHcaCUIW8IG?=
 =?us-ascii?Q?2Cw6EtLqqA12nLF+Tvk7R5eopFPtcD7A6z3Ek8ePWWXZOK+TflaRvuO2sqOb?=
 =?us-ascii?Q?Vqp1Y3BTX0l9C6PSYOL00H0AvfWYBxdNdf003U9Q1A/yFWFXtw0AyV/sqQ59?=
 =?us-ascii?Q?p9CDQvuZLXx1wMxJvvIdIy5N2NQIQLGIntQuG7yRTqUHWTyE8kQ3o8iBn9/f?=
 =?us-ascii?Q?4OjLkT9cl8mDzVYvIaxYsumIAOjDdiQVtvDvsTb5+p9R7ubPMU9jKyhAkfT7?=
 =?us-ascii?Q?ez83t4MuJBsQdRzMLrnkhsSaIODqD8PrcuVHt5zHODAXXfk/brU1rT9XfXM8?=
 =?us-ascii?Q?DWbYjhGMVklPw8gZpspu/qkukntNd+HZMKp7of52hNpakMG0dLFajNcZWlIE?=
 =?us-ascii?Q?TRejsyVsyQnaR5JXcjG9+CcMLs/h93UcSrTEaLqIDfHQdmCt36qfKXeYWi6A?=
 =?us-ascii?Q?nBsE3BufVOQ3SvSchhP1N5MUxyVGSoh+fGlycFVcNG/xNKhYoTGiwE5oh9jf?=
 =?us-ascii?Q?2ftCVZyZVOg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+Ig7W6UYgtpUXphNfYgTxPpLk0JM8yAhEA92Y8C1DJQM2Uyhx5OdPm+Nb8n+?=
 =?us-ascii?Q?pLhRAOiSgEQ9CXHAEYo31A+P3DeaTI7cKx5FRmZjRgYOl2z9FQoAhZ49IDd8?=
 =?us-ascii?Q?g/1h8NPsO5Zkr03651uy6KXCuPsd1M3xz1c8bXZjX9Ya6Xm/ykK1nQRuNitl?=
 =?us-ascii?Q?w9dVFBNdLr6mgxLGDt7hLAFrx8zrvZCB2Ey2Sb2ty46iK16cfxC+9NVYFQBf?=
 =?us-ascii?Q?NSfc97XUGESlUlrpUuH3wjzJ3BXPNjYSop+6KoPun8xE7DkCUOCaetLVvEQZ?=
 =?us-ascii?Q?wGnz9IGD/6FXLCQdTP8/o75kEqxAqfWaV6As85wcKKKpjQJGUVFwvV0SGRQT?=
 =?us-ascii?Q?zfcHpLehbeYZSzs8g8AQKEqNJFwe9Xl+c7+mKIKvE8U0lzlQPYVid8KUt0Tf?=
 =?us-ascii?Q?UJTE+/NbRNeiY1y+be//Fjd+YtWqcUZti+HrdxRIGEIpCJYr8lWqNgicynxQ?=
 =?us-ascii?Q?FOBMfUPLynxYPCdsOqQZ4owtKV8HkuDH8LRXcMbNyomyNehiwIy7TTdMYrIg?=
 =?us-ascii?Q?Y/wqA6+4cja+eexjkaZgKfu8V2kJtlBJ2bFSFPPZC3jDC/IUnZ7NMiqPBt54?=
 =?us-ascii?Q?5gRC5FADZ9cNxyAJM9zSBFGpg1/oBXapQNTSdJ5F61RY0zx4rwX1WO23wpa0?=
 =?us-ascii?Q?QMu0Gu2brsNCzbS2XnpXRAaOZl0Vh5VTvp6d/HK3zd3JgX2JTwPKT+od9N4g?=
 =?us-ascii?Q?p+9eIma/cRxxSrupBw0kcPHDgtGvF+qfVqkub3dP6YsDd4glvJyDdHFZWkn+?=
 =?us-ascii?Q?RC0cyHR0OwIqwHluPi6QNFtTa6CgxOqcD8/gIN0R5kF36YhqXoVNYh+biUcj?=
 =?us-ascii?Q?TbXwROjNRWxqdSoCYm+Ue40bT6PNzq1yEobZplurTPUieYm+k32NsLUtRrQK?=
 =?us-ascii?Q?hNkIC53FAfPG6aUR/HeE4sPujLfWrDEjz5wtj2Yb5divC3Xyxi0ATF8axC3v?=
 =?us-ascii?Q?A4mrzl06TgHzjerBUdXTU7ILOyK/xigXPkQnK5ONzSkGXxteXdRCWXEfC9ZM?=
 =?us-ascii?Q?oOi7XNWFtq0bzlEVqaBr+7vIkR4PpWV45MoTftxF1nkkUpcOpWApRk0TecAp?=
 =?us-ascii?Q?9Mn+qi0EUmCiFhB4l8hhiSYw3A8OEl3Ohyidg0o9HsHYgbRoyJf1M8VcWkIy?=
 =?us-ascii?Q?qqtMZRHjFzTIbQLnYWDXZSp6IB3RaP9JtT8vRx8GhoRkcSY5wmLZHAzJcDiE?=
 =?us-ascii?Q?yVO6dDXkeHfTdtpcl1qz0Wn+a07DmBG+ELLfuxTjrDByjHW20GQTR688ghgR?=
 =?us-ascii?Q?wF9v4jfsPu1Q1iA7hgrfEtJ4zZ+RVmmC96CDyepi6qzduLSLIgxUPzFVVOD6?=
 =?us-ascii?Q?lwYGvufKq+YgCUFY61LsGrKPL9v306/r1NYEJ/RgWt6tgW2WfRqGzjTyf8ts?=
 =?us-ascii?Q?rnnpf+ZF6zTJpH7tRQQuHsklIxCKr7zPZyLOFNehGHsXe0PCAviE4GEbVWA/?=
 =?us-ascii?Q?t8vSsnRajaYqCIOdOwgdWEUXcQKhn4VEyfW7njYt7G4bBIwfNMZazo53bRj4?=
 =?us-ascii?Q?lv7FEZisfw3ElvsvUxvzWUUdrjZc3MJkM28ZvJVBV/mNlnhPyKHqaBNLTfgj?=
 =?us-ascii?Q?Hm00+CsPdCE5qsRF/uPZ10zLnRCJdFzteGaCtAKf2rsLiPFumSPZ3FV32Z8R?=
 =?us-ascii?Q?rg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f93d0f5e-8c93-42e1-402f-08ddba901c79
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2025 00:17:07.3808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XdTH78iI2zzyL/ex8R8WSkWE+LeL1KfENwJ5QMQc49tfCUVO0N2v3peH76EUWVWDLOJwLEyLcAGSYQPP+8xigv60/RAAnLlm6qF4jyFBD8k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4763
X-OriginatorOrg: intel.com

On Wed, Jun 18, 2025 at 03:50:33PM -0700, Dave Jiang wrote:
> 
> 
> On 6/18/25 3:45 PM, Alison Schofield wrote:
> > On Wed, Jun 18, 2025 at 02:58:13PM -0700, Dave Jiang wrote:
> >>
> >>
> >> On 6/18/25 2:54 PM, Alison Schofield wrote:
> >>> On Wed, Jun 18, 2025 at 01:41:17PM -0700, Dave Jiang wrote:
> >>>> 'cxl enable-port -m' uses cxl_port_get_dport_by_memdev() to find the
> >>>> memdevs that are associated with a port in order to enable those
> >>>> associated memdevs. When the kernel switch to delayed dport
> >>>> initialization by enumerating the dports during memdev probe, the
> >>>> dports are no longer valid until the memdev is probed. This means
> >>>> that cxl_port_get_dport_by_memdev() will not find any memdevs under
> >>>> the port.
> >>>>
> >>>> Add a new helper function cxl_port_is_memdev_hierarchy() that checks if a
> >>>> port is in the memdev hierarchy via the memdev->host_path where the sysfs
> >>>> path contains all the devices in the hierarchy. This call is also backward
> >>>> compatible with the old behavior.
> >>>
> >>> I get how this new function works w the delayed dport init that is
> >>> coming soon to the CXL driver. I'm not so clear on why we leave the
> >>> existing function in place when we know it will fail in some use
> >>> cases. (It is a libcxl fcn afterall)
> >>>
> >>> Why not change the behavior of the existing function?
> >>> How come this usage of cxl_port_get_dport_by_memdev() needs to change
> >>> to the new helper and not the other usage in action_disable()?
> >>>
> >>> If the 'sometimes fails to find' function stays, how about libcxl
> >>> docs explaining the limitations.
> >>>
> >>> Just stirring the pot to better understand ;)
> >>
> >> What's the process of retiring API calls? Add deprecated in the doc? Add warnings when called? 
> > 
> > What is wanted here? Should a v2 of the existing cxl_port_get_dport...
> > be replaced with a v2 that can differentiate btw memdev not probed vs
> > NULL for dport not found.
> > 
> > I see example of v2 APIs in ndctl/ndctl lib, so doable, but first need
> > to define what is wanted.
> 
> So there are 2 locations using cxl_port_get_dport_by_memdev(). If the usage in cxl/filter.c can be replaced by the new function, then we can drop the call entirely for CXL CLI. Of course if someone else is using this function in their app, then we would be breaking their app. I wonder if we need to add documentation to explain where it would fail and emit warning of deprecation in the next release?

OK, back to this:
There was no issue or question about adding the new function that only
checks for existence. In fact, neither of the call sites of the old
cxl_port_get_dport_by_memdev() use the returned dport - so both can
switch to use the new function.

What to do about the old? Can we do something like this.
I'm thinking we don't need to obsolete the function.
We can document this alongside the description of the new function.

Not so sure of the is_enabled() in this context. It is just checking
for the sysfs symbolic link.

cxl_port_get_dport_by_memdev(struct cxl_port *port, struct cxl_memdev *memdev)
{
        struct cxl_dport *dport;

	if (cxl_memdev_is_enabled(memdev)) {
		error message 
		return NULL;
	}

        cxl_dport_foreach(port, dport)
                if (cxl_dport_maps_memdev(dport, memdev))
                        return dport;
        return NULL;
}


> > 
> >>
> >>>
> >>> --Alison
> >>>
> >>>
> >>>>
> >>>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> >>>> ---
> >>>>  cxl/lib/libcxl.c   | 31 +++++++++++++++++++++++++++++++
> >>>>  cxl/lib/libcxl.sym |  5 +++++
> >>>>  cxl/libcxl.h       |  3 +++
> >>>>  cxl/port.c         |  2 +-
> >>>>  4 files changed, 40 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> >>>> index 5d97023377ec..cafde1cee4e8 100644
> >>>> --- a/cxl/lib/libcxl.c
> >>>> +++ b/cxl/lib/libcxl.c
> >>>> @@ -2024,6 +2024,37 @@ CXL_EXPORT int cxl_memdev_nvdimm_bridge_active(struct cxl_memdev *memdev)
> >>>>  	return is_enabled(path);
> >>>>  }
> >>>>  
> >>>> +CXL_EXPORT bool cxl_memdev_is_port_ancestor(struct cxl_memdev *memdev,
> >>>> +					    struct cxl_port *port)
> >>>> +{
> >>>> +	const char *uport = cxl_port_get_host(port);
> >>>> +	const char *start = "devices";
> >>>> +	const char *pstr = "platform";
> >>>> +	char *host, *pos;
> >>>> +
> >>>> +	host = strdup(memdev->host_path);
> >>>> +	if (!host)
> >>>> +		return false;
> >>>> +
> >>>> +	pos = strstr(host, start);
> >>>> +	pos += strlen(start) + 1;
> >>>> +	if (strncmp(pos, pstr, strlen(pstr)) == 0)
> >>>> +		pos += strlen(pstr) + 1;
> >>>> +	pos = strtok(pos, "/");
> >>>> +
> >>>> +	while (pos) {
> >>>> +		if (strcmp(pos, uport) == 0) {
> >>>> +			free(host);
> >>>> +			return true;
> >>>> +		}
> >>>> +		pos = strtok(NULL, "/");
> >>>> +	}
> >>>> +
> >>>> +	free(host);
> >>>> +
> >>>> +	return false;
> >>>> +}
> >>>> +
> >>>>  static int cxl_port_init(struct cxl_port *port, struct cxl_port *parent_port,
> >>>>  			 enum cxl_port_type type, struct cxl_ctx *ctx, int id,
> >>>>  			 const char *cxlport_base)
> >>>> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> >>>> index 3ad0cd06e25a..e01a676cdeb9 100644
> >>>> --- a/cxl/lib/libcxl.sym
> >>>> +++ b/cxl/lib/libcxl.sym
> >>>> @@ -295,3 +295,8 @@ global:
> >>>>  	cxl_fwctl_get_major;
> >>>>  	cxl_fwctl_get_minor;
> >>>>  } LIBECXL_8;
> >>>> +
> >>>> +LIBCXL_10 {
> >>>> +global:
> >>>> +	cxl_memdev_is_port_ancestor;
> >>>> +} LIBCXL_9;
> >>>> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> >>>> index 54d97d7bb501..54bc025b121d 100644
> >>>> --- a/cxl/libcxl.h
> >>>> +++ b/cxl/libcxl.h
> >>>> @@ -179,6 +179,9 @@ bool cxl_dport_maps_memdev(struct cxl_dport *dport, struct cxl_memdev *memdev);
> >>>>  struct cxl_dport *cxl_port_get_dport_by_memdev(struct cxl_port *port,
> >>>>  					       struct cxl_memdev *memdev);
> >>>>  
> >>>> +bool cxl_memdev_is_port_ancestor(struct cxl_memdev *memdev,
> >>>> +				 struct cxl_port *port);
> >>>> +
> >>>>  #define cxl_dport_foreach(port, dport)                                         \
> >>>>  	for (dport = cxl_dport_get_first(port); dport != NULL;                 \
> >>>>  	     dport = cxl_dport_get_next(dport))
> >>>> diff --git a/cxl/port.c b/cxl/port.c
> >>>> index 89f3916d85aa..c951c0c771e8 100644
> >>>> --- a/cxl/port.c
> >>>> +++ b/cxl/port.c
> >>>> @@ -102,7 +102,7 @@ static int action_enable(struct cxl_port *port)
> >>>>  		return rc;
> >>>>  
> >>>>  	cxl_memdev_foreach(ctx, memdev)
> >>>> -		if (cxl_port_get_dport_by_memdev(port, memdev))
> >>>> +		if (cxl_memdev_is_port_ancestor(memdev, port))
> >>>>  			cxl_memdev_enable(memdev);
> >>>>  	return 0;
> >>>>  }
> >>>>
> >>>> base-commit: 74b9e411bf13e87df39a517d10143fafa7e2ea92
> >>>> -- 
> >>>> 2.49.0
> >>>>
> >>>>
> >>
> 
