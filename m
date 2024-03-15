Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9A84E1B5
	for <nvdimm@lists.linux.dev>; Fri, 15 Mar 2024 17:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710524423; cv=fail; b=OrqXrK2jgK1PjcP6Uwb4/74Hr2pW71wUCjzoSCyUlqTxhTPQg+2kSY0h5PSM6kKhbTTSc18+GrBG1SbulK6T2HkpyuQl8fExAG0v+JFojVSeFH8N9NzrAVaolWighTLMyu3Rsk8Wo91B2WLwV2IpUPHHdYR54ZDqzD1P0Knl92c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710524423; c=relaxed/simple;
	bh=9ibPk3AUo143LHujgNjuXZeqMERGd+5X6ckk/yd6Y2k=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Dup/Jwy9CfnL3JD6KpoMzZD/gsaQvHIJoy5/jjd+/hQ01I9VZd1NSNgKqnKBO+mXv01DCkj5bNYcU+UznJGRDNAiDSWrTOezKtRBdj2UAvcXRFyKhK4Hcqr8rttQV6iFfE7JuXV658hmFI9+atiCiCNx85dFkn4TjmWd3a2e3B0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W3Ub1G2o; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W3Ub1G2o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710524422; x=1742060422;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9ibPk3AUo143LHujgNjuXZeqMERGd+5X6ckk/yd6Y2k=;
  b=W3Ub1G2oIJerASDFiDHyTlJpc0OAE8CSV/IIVIMf0IBoqVfjxHC+Spyd
   mBbH55zmmqjzzIWcbewpz7NNmY1V+d7loIcuoCemppSl9th9bcREbeFtd
   hrE/xTMX9VSAg8f8d0HQer71jrnszIYlabVtpvgtFnmHdY9YbGNNqf5hi
   /NsDDlqFlZKiHvDMQGqrH/IhCcH0dOBNuOxiQ3kb1tQgKvQeeQ7/v3dDh
   CWgNmjdiDytCVfkid2RvWt0g6Y4OghcHUTkJjHJzwAVY4bDlUbuOEvntC
   zpKK0J7VOb2ouyFDqTH9WedYA4EcWBgOijErVvFUuSQs3Yg6vCX++b1Sp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11014"; a="16809050"
X-IronPort-AV: E=Sophos;i="6.07,129,1708416000"; 
   d="scan'208";a="16809050"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 10:40:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,129,1708416000"; 
   d="scan'208";a="12666178"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Mar 2024 10:39:58 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 15 Mar 2024 10:39:57 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 15 Mar 2024 10:39:57 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 15 Mar 2024 10:39:57 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 15 Mar 2024 10:39:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MvO4Nq6s3HwSGRYZ0NQcMV1BpgC73FByd9MkmMsmo5AsBGvsTvw3KbsQ2lz5SQHwxX47ThUNPPi8VhlwCmIBDc2y1a2cfQljp48DYR9i3otvrkf39/5WHoUHw2yJXjCfV0bY2U2uqm0sLRd6OSb4tHJgQcY1Fw2CD2gOMA7nQ8brHW+D9vJk5iL3fcPFUFSCcaFghyOQzHC6nPelfvUtDHdmFUj7utkoYBakIHXiSHlruG0VL+wh7zcxW9fqiOwOiBkZfaFIydLWHd7JI3O4t5IWNNpb6hobBhQeQnJtusnV4PUxixJOT3EZ4wba13SGHYNLiyxDlP19Jqr0nFyZLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tdFXeM1okUaByWDN4dWdzdmf/md7KXZNWyCs1yIZLBY=;
 b=QXGgJZJtwKFFJFaAHstuatEk3THBeeBirUIW9V7cTXIek8NrivEeMl7SsuExqd8kJLoRpv1pNV1j6OfJTRSTVeh9dWxqP2pXmzF52rs+X2POQaZGakNl6aP6iQhWmTvr3gb8ZPx9jCi42JUZL8wotYQhrdtPCIxEVOux33PRMZs3MGOZvYQFJ9evETFbg4pEVdYPKjBsro7bhwtKZ8+1XZE3+kqI90DYXlytqqFHLBK8WVnOovsstKehTbHcyzhaPNNmDrex5KmbSLfudXT96xh6/r2W1bvG8udiy3h/V77VAFZfvY2MbWWhNaELVCz+140Hssba0NVH9bWkWkAmWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SJ2PR11MB8321.namprd11.prod.outlook.com (2603:10b6:a03:546::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.19; Fri, 15 Mar
 2024 17:39:55 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71%4]) with mapi id 15.20.7386.015; Fri, 15 Mar 2024
 17:39:55 +0000
Date: Fri, 15 Mar 2024 10:39:53 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
CC: Alison Schofield <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v11 4/7] cxl/event_trace: add helpers to retrieve
 tep fields by type
Message-ID: <65f487e9fbfa_aa222949f@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <cover.1710386468.git.alison.schofield@intel.com>
 <0dbf9557aaf5e8047440cb74f7df84ae404c11ba.1710386468.git.alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0dbf9557aaf5e8047440cb74f7df84ae404c11ba.1710386468.git.alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR04CA0095.namprd04.prod.outlook.com
 (2603:10b6:303:83::10) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SJ2PR11MB8321:EE_
X-MS-Office365-Filtering-Correlation-Id: 35246b64-0416-421d-e47e-08dc4516ed23
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tl2p7wFE1zoMVy6XkamYzfohh5woLuOqg6aqfCpU8HrsLLIEJ9xbz7csQkUz+KKK1Vx+CerOlnHUPPP9Y5eUDcMv8/OS2Dh3QFFoTWxrNv1gqz/08C7cWKplgRMSVenM+tLkOKMjLNGCOiImbJI8yFk4bbVnV2grEkbUGclKNkVb8czaOEspIcNYmtlREw5VaiMwa0X1NRq1YoHzCeIzIFPZq8Q0V46Eua6ibiRpAZgsrEUp0eLPweMZ1nauY3TIyRDWhc/AqmK9nrDAaWrOGc2pLZc0EgAIWTX4NU9fb0KTuaKhS0nOiU76tDOToOm6RnA4POZsdQH0M7VeDVG0tWqgRzL3Z/1LGAKbM5f3tikodPGIk3GfKDlK9rr+pQ3Dbb3NDz5zNa4eSK0YcqSNIHifHEHVKE1zNdwUPYWpIRpRSeY15kDKk4qg4lBKdsofWS7fs+txeSnwRDhmA5E8Ff+dPqL/Lg/bp8r0DCAOiCCDs1JStUV2XsUi4TF+1tQXDH22bQUj/Zj/6ZB8ZIUbgASD+LQq3aWoYESN2p52z5RbozsSCPMgO4nJ47GXad2eIZvV6r81DrySE6TzleXegB5xxG4rnk/IDPEBkOeUpxUzidCFSJfaYxy4YfqQGzsrUa95BdFCFs7klwp9RW1VLYphravpU4anZ6+02YRFwPU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xbpmoHqI3AC8uC45r7dYXR4SGeK1iW7qtfbNdB81irUdHlUs06/oK0Ja67uS?=
 =?us-ascii?Q?aIVG14bw6K+vzxHOIyDo1bkCwVGHVfJAeR39YFmj8zQvoUIoQTdGTbdjyOyS?=
 =?us-ascii?Q?9CYxo+ItrqhD99ANC0oLsSITqf9ydLtJ2QTWZllFdfptJabfth/roQAawtEQ?=
 =?us-ascii?Q?YHBaHZGiJQw+r0QpSYIK9C+T446BFwTVekyL0BWjRAgonahD6II3NX77kFKS?=
 =?us-ascii?Q?GAP+CTSF434zgxpvFfjsATEs91XqZUJEJO3wtjfIf0oSX0NpwzdnkwOImZWi?=
 =?us-ascii?Q?VhDPwTPNphe3zDXWRJ/xgNx6h9WuSejc/EaaeQwFwVIBia5FSOQGmt9yiDwS?=
 =?us-ascii?Q?ncZPnEjXBrjvJoZZQMOFjoZHvgSmMpgySF0ixolw5xtuqP/mzaUjOwUYhwGQ?=
 =?us-ascii?Q?MLgByMKbNKiyCi+93HeMKS8ecqEIAGRXFYUqCT70tahavOHLBUoA8j0T3eZ5?=
 =?us-ascii?Q?GeoVTlYL7SEbaZPd9sT/DLU7SD5EE3fv6lSdZSD3AH93p/w16iWBRtv0zAia?=
 =?us-ascii?Q?ji7J9kQ/EldFl7gCKzFFgMcKpxdDEOK+1nmIdnWRbPZPZt1QHn756zmOJRrS?=
 =?us-ascii?Q?1+ezDbbf1CxTRrfEBkmshyEnQ07jj1IUo0JeUGX5jPG40VmthvGa6auQBR7H?=
 =?us-ascii?Q?Ps44ieUDZZDIHqUbPjQ+BYQNG3SnfKPyqB9eLvEaeyPRSfEkPKpPBDdmPHIe?=
 =?us-ascii?Q?/o22+q+VRVxuxNjkWvmdaUZnPg1LOVy7HC/O5RW+7Bl2f3ynKg5aQgQf46Vq?=
 =?us-ascii?Q?oDQBsmkMBN8R5cIb4Fr49GyXV/vf7XKIsQKShZnYgPzC4/TZ6ENBDoVf2/7F?=
 =?us-ascii?Q?Ywh379a+oeWJ4kUwXxnxe9XE0L641usUE8FYxquaC1bm3In7mXVmCUZfL0Q1?=
 =?us-ascii?Q?/+ww+FKIBlFHoSC1JaJnmngE8xTg47GHT3areUgwQ1GK8wQbcQg6gjEEQFev?=
 =?us-ascii?Q?hA4V+CZaQPAnHdrkIcXZsr8ipWrRPd4cqY3xMG8+DIIFZxZsaRH7kcmYaZTQ?=
 =?us-ascii?Q?ibQRPhSsl9R/doqlTpRRp3q/vydoqgLoR/QR+KHm5N4o+n8Pzit6nF5VZubv?=
 =?us-ascii?Q?BQdDUNiifgkZ64n50ZNeXOXpEH4yLLYzn6elX/wKK6dVsLh5l1Io0XQyO2Fu?=
 =?us-ascii?Q?/V470OgYjtuQ2B1yUkuOrxiQT2WEpbDy7zpEWOKJNRsVaJ/4c6IERMDf4c5y?=
 =?us-ascii?Q?KOowVAV56+ECpKptRGAsTAHdzV/StRsQz/130GdnCZsFVo2wn6T2IA/pxysR?=
 =?us-ascii?Q?20xwYuE9hwHoxFCTKT21ybDQKD2mD/BNoJSfAl7xDoZhWVldo/CMVkkLXkW7?=
 =?us-ascii?Q?kTHyuqOAVlWbvF5sOuavDMhpyisnAHLutDxeek4M5lIyWQZ6sKK4lQtBTYdB?=
 =?us-ascii?Q?+aydAIh/+66qzcFJEjYje7LHzJQcYz44feqL/UrSLwA81lfs1Sxxx/MTtEhe?=
 =?us-ascii?Q?tzjl1crybzZGq3CnTapH5BWqNL7wdfp/gyrcBzadVCmL06KAJS3wpHEloKJt?=
 =?us-ascii?Q?BOLYHgwUZT/qcP4P7j7pYcvTslnsGh8ArpiAHIHI2Ifkwqsc4/1XD5hByRjB?=
 =?us-ascii?Q?C+nZP7G8D6+sSijYuoqM4wjLWPzXHr94E0H6T0XgHFgoQFtdhuYKSRC/eDE2?=
 =?us-ascii?Q?Zg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 35246b64-0416-421d-e47e-08dc4516ed23
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2024 17:39:55.1411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QJeTPWNKdsQX6NTK+08oywvK+1MNO9Odzh6hEYji1uKWBXeGmYx51hvaogmuZcLvqwB1FtLxMYMLaQk7VHfkpEyx1wMQKQKT3QZENaqvZ0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8321
X-OriginatorOrg: intel.com

alison.schofield@ wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> Add helpers to extract the value of an event record field given the
> field name. This is useful when the user knows the name and format
> of the field and simply needs to get it. The helpers also return
> the 'type'_MAX of the type when the field is
> 
> Since this is in preparation for adding a cxl_poison private parser
> for 'cxl list --media-errors' support those specific required
> types: u8, u32, u64.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  cxl/event_trace.c | 37 +++++++++++++++++++++++++++++++++++++
>  cxl/event_trace.h |  8 +++++++-
>  2 files changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/cxl/event_trace.c b/cxl/event_trace.c
> index 640abdab67bf..324edb982888 100644
> --- a/cxl/event_trace.c
> +++ b/cxl/event_trace.c
> @@ -15,6 +15,43 @@
>  #define _GNU_SOURCE
>  #include <string.h>
>  
> +u64 cxl_get_field_u64(struct tep_event *event, struct tep_record *record,
> +		      const char *name)
> +{
> +	unsigned long long val;
> +
> +	if (tep_get_field_val(NULL, event, name, record, &val, 0))
> +		return ULLONG_MAX;
> +
> +	return val;
> +}

Hm, why are these prefixed "cxl_" there is nothing cxl specific in the
internals. Maybe these event trace helpers grow non-CXL users in the
future. Could be "trace_" or "util_" like other generic helpers in the
codebase.
