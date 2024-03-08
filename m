Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404AB2C1A7
	for <nvdimm@lists.linux.dev>; Fri,  8 Mar 2024 04:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709870644; cv=fail; b=PcKBie+tkFHu3M96KUD35Q4Uf3XUR1WOCZ5gH/l6HIHI5EuT5SeQ+JnqdnwJl/G6LuvcOcWx8MW3Xy7jftPSu9zkcTV/8PNxBdNWKm2ybAm6EkvN451JPaHDPmv5kOj9AyExOiRtC5dLRDq1TZmw/isvrFKT5WuieKR8e4WmOa4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709870644; c=relaxed/simple;
	bh=n01QXS/dTDTaVzXYlnCrm/JqlNxIJAceN/2V8Rh+XEA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=P3dLBC1cmGFdQaMmKpuwkie536tScCiRFX/4poJ87BTpt3XGkSNW8ivxB4k2lTFws1svxuTM38wIKX1ZJ9wFmP/5ebuT7fft14SU4J1kWWvK5qQiEUe0svWchIGnZ/YczolDGNbiCK68uXV2Q6rHVeMi9Xp7qonB0hS2tKpnNt8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eAlw4t61; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eAlw4t61"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709870643; x=1741406643;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=n01QXS/dTDTaVzXYlnCrm/JqlNxIJAceN/2V8Rh+XEA=;
  b=eAlw4t61u/qN2r0eshicgLjtSnX0UB/Np3XVOfZyim3NaArdcl8uICcy
   w5LufmWlzLiG/11/G8I83ykFMeeF3G41KiPQpQcjlSVRQG1YJPgooNzZW
   hOu2hzAfM23tM+9/iugth2aIyFG+IWfVCOVjrQ5+RdY2I4Lt3QMPmCpZK
   Ss4DAdtK5RuI5MyiAGjqGJAEQGoJOhnCUK29RPgeA3ehxvegluwA2lXiB
   WC9f73nG39QICVn3j9TMD75u3Q6SiUAstNma9qFNcKU5b6t5It3IO1mhf
   H+YXzsg1lcyLW3F/Yfew5tWF+ZvBlKyI2YHRFsBSLdksGvq3dk1a3kWn7
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="8390321"
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="8390321"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 20:04:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="41252285"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2024 20:04:02 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 20:04:01 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Mar 2024 20:04:01 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 20:04:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E4jpdqbKEHnIwMeIHdy+uV1kcSb5nYosJ50EfnxKPLTYC2wlmFk1DAlD8dkjX89Ycu8C0qgYJ5r0kRKyz5T0JvJdqqFMNhU5E9TkEk7B9wvr3JuYn5bRPi6DAV4ZNDSN73CGoOdKJAe8FNn3I6qGWDzRs5hvsAwsxhvmIqF9JMl+LmDx8lWK7swrvIqlrQ3U8djhMVgrOXhzallWG/X5eQgRmn/D69qCwEg3lt102QSaEldgibHJSVAZzoWMJMBO8cs1ucprGbgMpVImw+JKriNuX61puerHFm58d6YPL/u2Zru72aGan6FWxoKKkENjCmBCWYBP8b/4GtXKswdg9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m7mSnB+QHn/XHmb6GA2D8d2YqZBdZD35DV2nALBU1ho=;
 b=ogY/YrwwbdDjl8DKGs5Gngffjf6pUFj1RsrWbPe9iV2W67SNkfqe6G5FzLlGqfegW40s/Tq4pKhFEgN6sr75jAe90F/HqZc/NLW4Iqs6leLYNxw+AH7THM7Cp0mEK04dDjHi3Bp8ff2WBJR4RsYCvBcQYeWUGVZB4wRRb5+H2bZBedKYvUEPHbrubg49oT84jMwIXarVfLThRKOzTYpDh3jqGpkBuEimoa7bDqztJhVOBYFLRbk6ka8BDMANRupQswEjb9wlenlzyiZjHZOV9Noesx0vaYN3Y9xsgfTjE3Yua3i3fVqmK7HCimpkd/QUW2t9O3rYoRMBDmFxd1j6jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA3PR11MB8118.namprd11.prod.outlook.com (2603:10b6:806:2f1::13)
 by MN0PR11MB6159.namprd11.prod.outlook.com (2603:10b6:208:3c9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.9; Fri, 8 Mar
 2024 04:03:59 +0000
Received: from SA3PR11MB8118.namprd11.prod.outlook.com
 ([fe80::545:6a88:c8a8:b909]) by SA3PR11MB8118.namprd11.prod.outlook.com
 ([fe80::545:6a88:c8a8:b909%4]) with mapi id 15.20.7386.006; Fri, 8 Mar 2024
 04:03:59 +0000
Date: Thu, 7 Mar 2024 20:03:49 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v10 0/7] Support poison list retrieval
Message-ID: <65ea8e2554c5f_12713294b5@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <cover.1709748564.git.alison.schofield@intel.com>
 <65e8f64c6c266_1271329483@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <ZeqM3uvPUNvOj//5@aschofie-mobl2>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZeqM3uvPUNvOj//5@aschofie-mobl2>
X-ClientProxiedBy: MW4PR03CA0044.namprd03.prod.outlook.com
 (2603:10b6:303:8e::19) To SA3PR11MB8118.namprd11.prod.outlook.com
 (2603:10b6:806:2f1::13)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR11MB8118:EE_|MN0PR11MB6159:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c5adbaf-0bc6-4572-9280-08dc3f24c852
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VEQjX1XW6vW/XNmy7Kndr55kNQofl8YWqpaKLOBa2Ogi6YL7KiwRTdbPkPbyTHooS44u5K+uS47q1/IU13fGBuZJj7qLEtRDw1nNBSldZ1SuAOS/rkBDcE5DIWdzoXqQZqbnibRGXQMc//iOaC7FofFJxIaeInfHn1PXewwtW4X7zvFwQV0wATqSm6gvAPW5TK8Tb+p1JCroIXIrvymdDo8gvaj/4yzCBdUyO0T1WCbMFgiyzYJ7AV4YC6y/THFZ9vsKCVlp/xQyJwR78L+6w6KcnLLDv12bNLnVrzscaUa900hLJQLmriJoH9tG2sa/rrTRlmduAVebPRsPgynqeScWIjbf2kkIoRAVZ9SeZD5Mp2fSgwe9QsaWziPEv0vEFVJYqN5v8zwvAz0JbgFJ/chxmiu2MllpeYss4fjG2Hnn1a1IlKezKQNwp96rDMsAL7M3TadEmfMquC46qkH+8v/yd/aWa8hMFc7D9UwtmFEeon4OUG77f3zOqKnQ46V0PYAx4J+6lpc7l8xEhtR4Bu3wvfQwFq6xSretgFOCw2yZH1PtLzTk7B6QcjPHmWElslv7jkWS/kFr5DDh9Ik3MFcJ73uhkrh3HO7ZD4MrVjkEdnFsOEr0P/ekvzsScZO3LkeZYR52CKkjlEF0hGu2KSnur/LX9itUeWbUFMBOimk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8118.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lpUOM0Mx+VoXNaMtWOBDRxyU4iJg9hV8gmwQvYJp1u0pEhJZ8ia5LdCDbu14?=
 =?us-ascii?Q?yCvnTkuMfexB9wXqEJEd+2U6kHJMDbQ4ihvfFwxLMMp618+wBxbB/7tPoNAS?=
 =?us-ascii?Q?Y7OeQoJLUoPg4Lh1dyQTxMBX+xYb9oJwMPh2hWDBXPtKi5jl/ws6EgiYjguA?=
 =?us-ascii?Q?h+kURKjarkNWs02D6t/N8CJrnznB5rocFSETY33f0vdDK8N8wX++eNmd9keu?=
 =?us-ascii?Q?M9RWG+/hy5OV8oCSGC4XkYHP5Bg5ySzHWboaDG6GRsnZLn9TIAFZAQlg8D2d?=
 =?us-ascii?Q?flPOZXRDo7PPNfoa49+PmDUObGyLCwqMsfjbK2Xf2MSYGVOFJ78IliK5Vndt?=
 =?us-ascii?Q?HRUAIHq4UMix8irnjWaqedy0zHp5PJNKntpXCjJzSfIbpD9gIlkWjKNHHu6a?=
 =?us-ascii?Q?cbVTs/f2JOnCp+rrEBPUZQZo0udVbgr06hwcQXUs4RFwXFan4V2B7AtIVHlY?=
 =?us-ascii?Q?1OETN6O+votNgKvMVSXoZzjisFtc1ZNuoUnlirlG/EEN8hF6uCTd8ay7oWYQ?=
 =?us-ascii?Q?4OOUJuRMYkt84KIVI/a7THPJpq+BIUHtnce3GxQ4H/gWK/0kgXjYQdDlUGzF?=
 =?us-ascii?Q?4nD6eRbX8B5TUapzjSaidAC/27L2v/UlGUIxEOkUMu2nhSlW3yNwetL6RQgD?=
 =?us-ascii?Q?pnIMsyev5MD9oYBsWnVHQIErTpb+ihigEEjUtOH5k0aj9eNg/xuw7yNf4bD6?=
 =?us-ascii?Q?M/SEwA+AUd2tz8VnpMHlG5btuT49+z37JbGHNaUQ8L9nias+kM7KXiE3PgU7?=
 =?us-ascii?Q?s0sKev6a04Wsl7OOa4V2tOXI1l69B88vPbjt0Y6I9v2Yg0uVmWI5g74RuykX?=
 =?us-ascii?Q?TYEf9pd0MRg69XxtW94D/ySJg9zhTMiD3/RaQXuUPHh9+tp9TVxkXNKkrhvn?=
 =?us-ascii?Q?zc4A1RfBVmF5JMDRNLV+QZaZLTVtWjgpEa7QeBjPw9fDYWvl87M/MBbyJ2xv?=
 =?us-ascii?Q?bwQ3BHBWqVNzh+71uShkINJMuDmZVlK8pQejIoXRk6ZH6MFxR4Wuw0yAllwU?=
 =?us-ascii?Q?bQmEflhYo7jpG3X/w1y/LsbG4fMl9kKLQziaSuPFxNSTApvDbgL/DPEJPwtH?=
 =?us-ascii?Q?Dbek1iCyVsqmCOF6TIu8f04nv6oSQN2cBuVtqk/ub0/5uiD8VcgEhUnDWDns?=
 =?us-ascii?Q?GCqfCSUzuloJGr4SmijnvfIv7e4/zQFv+c8brCHOfqHbXUdsfHOUZES1FGZo?=
 =?us-ascii?Q?4Y+FAoE8+/OO5sHRA7HRbRKu0zEO1XdKIudtT98XAui7jfXaMAWlcWXRvTTX?=
 =?us-ascii?Q?cab1DN3VsjGVCzpCwUFJnQbHUQMmeXIIteEC6zSTGsSDWzed+KDRnSRjDmw4?=
 =?us-ascii?Q?rbgm3eXhzchnZClApm5zaeXW6E/hJBDaVq5APz3qiuZIzd927qhIhrs1tHRd?=
 =?us-ascii?Q?vA2bq9JDlkx3SF70y2lpuLBfsSuNKo42c1pxjKq+s3obAKGhaazvV7lGkPM6?=
 =?us-ascii?Q?AAJH84BmtwRtVp11+CQH92/91WTK3DazXCSQm3R6g5jsPEeyDuqrU0HuBq55?=
 =?us-ascii?Q?x6+xyPsvA/l5idTmqyjMB7du0EySqFB40otKtoushkB1dYXRFo7VWp0b6Pz3?=
 =?us-ascii?Q?FBYgUROlMEavu9JjV2dNvA51BuAhZLbouBrYlWj3dVj9EQn/cNe3wYYI4n0P?=
 =?us-ascii?Q?Mw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c5adbaf-0bc6-4572-9280-08dc3f24c852
X-MS-Exchange-CrossTenant-AuthSource: SA3PR11MB8118.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2024 04:03:59.2890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vQHDGw3ktO7KmlnRg7f8qqCKNwYOC9vmPToYzC8CwbqnjzPq26K/iLnVMJ++jD1HTXPfFc6eUTU5g5ZFj08Basl+hOJHHhW8qtODOTyk8x0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6159
X-OriginatorOrg: intel.com

Alison Schofield wrote:
[..]
> > I notice that the ndctl --media-errors records are:
> > 
> > { offset, length }
> > 
> > ...it is not clear to me that "dpa" and "hpa" have much meaning to
> > userspace by default. Physical address information is privileged, so if
> > these records were { offset, length } tuples there is the possibility
> > that they can be provided to non-root.
> > 
> > "Offset" is region relative "hpa" when listing region media errors, and
> > "offset" is memdev relative "dpa" while listing memdev relative media
> > errors.
> 
> Done. memdev relative dpa is just dpa right? Unless you are thinking
> offset into a partition? I don't think so.

Right,
	memdev offset == absolute device dpa

	region offset == region base relative
