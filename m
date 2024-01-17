Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538FB10799
	for <nvdimm@lists.linux.dev>; Wed, 17 Jan 2024 00:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.55.52.115
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705451131; cv=fail; b=R/SovpScJwvlWjrNWDWFYrBujgtl0Adbo9vYKsSRBcQSGgLg3P44Z0FVZ2xVNDLA5ii2sSwY0FYISUh4LKT6WuGLuBWpAuWNbcmrz34hrArrXK3skpNCPmGbYenSaJXp9+VIcs6C//iF+w9auLUxwXD0ZrWpLZz2yLqJdnSnKMg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705451131; c=relaxed/simple;
	bh=nUUXtjhNiXiPySwQ5+XqKpaiuYp+OTcJJGE9cHNSoTM=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:
	 ARC-Message-Signature:ARC-Authentication-Results:Received:Received:
	 Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	b=a+b6RDj9ejdxXD1YfK4VNafqbNC2o8p8Dt/RiBo5D7s8VRYR3Calupk5gbYEM0UiKpqOzTT2xRjH1LSpAbiRz5yxQ/hmF+aBqXW33vA+Pf4LpBgTq7e87p2FvFNa3HRcLa2xe+PKsgc64DT6RcMWfrJ7rN+j7EJ2nf35GB1nLfo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nDxQRfAe; arc=fail smtp.client-ip=192.55.52.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nDxQRfAe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705451130; x=1736987130;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=nUUXtjhNiXiPySwQ5+XqKpaiuYp+OTcJJGE9cHNSoTM=;
  b=nDxQRfAeROVrhstEtNe7MrXsb5xOAJHyKL5GvQZKt/+eEYi4uIyl4N0y
   uTPvGce9EZdy/pNgKrULM3TIOlTzMMM0X/rOkwMtKWSS3qVDna6J/43lt
   Y0dHjvIxrRT0H84x8a3vyDtwn6cJwmc7zmVZEgh4jA4nUfmxTpRBlJKnO
   t8Riabjrcc3lCi07NEzg2qetbco4L682LwhsW6Jp1W9ivyLRpTEcf38Ll
   0a2xnp2NU1sJb5PshQBEtCHYGTKUROvvyxR66Ah4xZszJx1dDwkS/RHEe
   V4BHMgXjrDUdIQAzFe1/kwWJt03pOxD+3lAcCoS40KzXNMalvvFkU3AC/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="399697750"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="399697750"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 16:25:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="854519763"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="854519763"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Jan 2024 16:25:12 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Jan 2024 16:25:11 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Jan 2024 16:25:11 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Jan 2024 16:25:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k0HBm7ZHsBVlp19MoE0pECoD/2p0P7mbfVJ8fa6w7dZpRdba4J7Eh1+KV9IcuC2dPNZLQmuRGMN+ftNaVu/WQ6pPcwKF6axGps5h9B5NnECNAArkSFUSTcIoZklxPz5VbcwN73GHCJzefBtTf365yAVb718bRmNupvdpIb/RTJjR3GuqewGwTq6eqdU5YZxm7nfwFFd1WG1y4Mx4xiLVUoKG/rhfpKDUqT31Z1wsYovFc3XHd4MQmMJT1Hy6DakBKyLSvK/30zegS4Q7YgTEtakrr1MDZ3mTg76EuFvk+LtKapMJGbwfWKhhCO8U8+aDwSEM0nwnkpK71aZ1Tiz4HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AswpL2ZwV5Ae6T1mXFq93oD/4V88vCu9FcMziOFfWrE=;
 b=dS+knQTXX0UojdhffMWN22FW2fZIy5nR1XBQ/sFOfWNkPqJkrfecTdDK4ID13ujO4uwfpkjpxHTkYJu6WBSzCAGyuCavCes50ELHMWF9Cbc5XOwAX7p18difrz8hkG/AXzSBkRE88vAHIgrNtFqo2Tt3NykbnEjNx8ddRpkmkXpRcFea4jupM1gwm+y0kJHgb2vYhZ398mtw6gA/4CD9PoLtWK82SQV4qSaVyfnTe3921uM56OWsuwyOaioOg0Vao+wCW9Ow84dxcexe37hbcTP2TdSZy2DzwBhzfm87jDK2dmfy80RtIhvCCMoM2X/WutQXiWyBAyGTjmHB/oPkcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CY5PR11MB6317.namprd11.prod.outlook.com (2603:10b6:930:3f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.30; Wed, 17 Jan
 2024 00:25:08 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6257:f90:c7dd:f0b2]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6257:f90:c7dd:f0b2%4]) with mapi id 15.20.7181.015; Wed, 17 Jan 2024
 00:25:08 +0000
Date: Tue, 16 Jan 2024 16:25:06 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Xiao Yang <yangx.jy@fujitsu.com>, <vishal.l.verma@intel.com>,
	<nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, Xiao Yang <yangx.jy@fujitsu.com>
Subject: RE: [NDCTL PATCH 2/2] daxctl: Force to offline memory by param.force
Message-ID: <65a71e6296de9_3b8e294e7@dwillia2-xfh.jf.intel.com.notmuch>
References: <20230810053958.14992-1-yangx.jy@fujitsu.com>
 <20230810053958.14992-2-yangx.jy@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230810053958.14992-2-yangx.jy@fujitsu.com>
X-ClientProxiedBy: MW4PR03CA0245.namprd03.prod.outlook.com
 (2603:10b6:303:b4::10) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CY5PR11MB6317:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f6875e0-602b-40e4-684d-08dc16f2c2d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cxwnjxJqO5AOo2nKk3im8ETyFfUtFJP31RgnKNcd/b4xbZx2jFvxHDDWQWPhWd80xcgO7obyzsKkgwUA+HFJvKSWYg3OBlfrJss4JhjJybJ+Uurx9YEQdobGznzjNdWUJR/dWehSiQUJApcLJwQKOM2NlRNtHOCKHh0zhjfQJvSe+ZdlzpVLvtRXyqFKjL0/mBubnrtATO/yiCgnRPrtga6QmE6ed8Kq1Sya0HAqKnNML6nQf4xqDoE1MNrVE51pIbkYf4NWvYtnLoE6/s1YlQvuTUwtmnsLhIB1nyFyYuE/7gAn2n/+/LZcrCne2eV9HCEDyZLOzi2K6+pwKzZaOkgp8DvvL5GVUX70NQbD9DZRoMuKRppiOFtQp1VZVtBXEqVJwrsajRi2GCm4DYlK5414757z0BqYV/nAa8pMdcObkp1GC1Me05gmRHtLfY3Tk7NZzeZun0q8XZDWm7vV7b40PnkKVh+5yMDxLxtdz90n4BBsn3cX1429UDmLBbKjZ6n4TxOmI/IlkQ/hrNatxbZcfAEyez7e0II+C2ezcqGlcrcCiNwUm2h3E23kmN+zIOr4nSXISSIpikGv0vpHvF5sd1TayawfBEr3Oau1I3T/F9BzX9ds3vxhaRMr1/kL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(376002)(136003)(346002)(230922051799003)(230173577357003)(230273577357003)(64100799003)(186009)(451199024)(1800799012)(5660300002)(2906002)(41300700001)(38100700002)(86362001)(82960400001)(6486002)(6512007)(66946007)(66476007)(316002)(478600001)(6506007)(9686003)(66556008)(83380400001)(4326008)(8676002)(8936002)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?weqg08Syq+8MgjVFkpq87LqDCtojpgUewvqLjle3F5FLwq5NuU7C9EDhmvLi?=
 =?us-ascii?Q?IKzcnAkjSaiK3MxZfC7zd6rxu29ncwT/41vvm0OiWop+BuB0y1RFSSPZIzeD?=
 =?us-ascii?Q?2Ftpt7Y67s2muPamyF/QY8rJBf+kMzZb3FEc/4wUReZBW7PLo/3rDyfXG6sc?=
 =?us-ascii?Q?tZrAyLlvV3ea2VPFVQINcDsJsJvVv8OrShhZAlJakrDbMKp/Bij7oQ9y0RSx?=
 =?us-ascii?Q?7ROiDcz66ptPC+D7R81gb1oF2l/0EkUSgtvtSzMAdnVM42085pqlb8yRnnBp?=
 =?us-ascii?Q?59n03VBbNmWYWUSwu3SOIUOdVNFS7++8vhQWYz6GhGXWq5zAHgJH2uwW+gHt?=
 =?us-ascii?Q?BEPJyxK5wJtNKXtwZKJuwgfu6bHkBnbW3vs/0JRhMmpWCn9i3zeXpQ5VcAlO?=
 =?us-ascii?Q?XdrVT0gcrWa8n1YXVAftXHxQPo6otolQTKIs2jbr6i4FFQl7smjFlaWaSahM?=
 =?us-ascii?Q?7Uuo0fBBEP+qgyT52t13oGUqFnFM3llRvnL7nu8bBZsOisAuAoSV9FIoAtYI?=
 =?us-ascii?Q?fkignusE8zvJ7uH6UcGfqwO+flf1PNO1wZMepFsZgU6js2rsdvtSYOMGqdQV?=
 =?us-ascii?Q?8T2xdGnI7fYhsc6rctZoK4mg0P8oMucVszi8D2emAXwtSDW4uuS2r3DDn5nn?=
 =?us-ascii?Q?cbnjHys3CdapHwZafsEZg+9Atq87WtL6YVkgWd3LDurXNF7DpTw2DNkphIUS?=
 =?us-ascii?Q?PBPuAe7AklcUDgbtIoXl39VFK87juvnTQR4nVi1Ii6R+HcDvNWFYvuRrdMLb?=
 =?us-ascii?Q?ekEex/raH06sDIK63SLkC+eCuNt41/3EX+lE+yuEEqt/HGdPDrm7ET0RvrxQ?=
 =?us-ascii?Q?INZmVQD44RF5wfZ7Rt/pF3iZJuYxaDM0H7aV8Ee+7qfsu0hv1ysGRpeHced6?=
 =?us-ascii?Q?Wq7ehc7XPmkZn0Aw/9HeZYaSfRxirr6bq2xyqMv+3GdkD9j7rVUc0S8zJS3l?=
 =?us-ascii?Q?25Cv52QAREHVV1Catx/8ukcJqCqJdH5U7D2q30NAWcORXVEt/L1/VqcPBFHF?=
 =?us-ascii?Q?Id4XBTpfcHFkwJKTrh6Ot7jwV5V98AiiN4pPHf8OBVSefEDF6SPgIq9rk3uW?=
 =?us-ascii?Q?7mErec58+s38cd0aXbS2kaprZhiICBaPY/nhncdovJx+gNPsk6IQAnyyFqSr?=
 =?us-ascii?Q?Tnps/Rc1Wj4wuontLYAhod6WhjwQBUOxMiLOMnJWbTpJJVjM6jGQvT+LXlM8?=
 =?us-ascii?Q?05gShIwccYDsvG4uwD6AbrPuZZDY7h+AnxWrBBrJV3h3+rtnUmPuLnDKCeb6?=
 =?us-ascii?Q?WBK7ML7XCR24B9eP0AN5NMQefcx/jVj5C4Gsndpd1BXvEKnYFsuD9dPHfgR+?=
 =?us-ascii?Q?0PlGBp5smEOr35qQCYRExitHnXxom3+c1eOyQ/eH+5mFZ5HUmFB7OsG4yBtx?=
 =?us-ascii?Q?MiWM1yOo/0A2a9ZyTuP2z1NjiZURa+PJ1ZxRh5Psl3LGTrVp8i29jGMps/m/?=
 =?us-ascii?Q?KHo1jkKZ7u0qJd/7bukbsFjItJsP+qUUts9xZLvJnkJrqFTD+apMt3oeV9J7?=
 =?us-ascii?Q?wHth9ZOzCUrSsaI42S+hZzKdt5733NaHTPAxpUUg/XLRkeKab7C9yPy4zemO?=
 =?us-ascii?Q?tJlNXKxXD77IWxJIxWZB/YG5z3A3VZgFdpy53cAaXZlosClUDiSoMxylvwFT?=
 =?us-ascii?Q?oA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f6875e0-602b-40e4-684d-08dc16f2c2d4
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2024 00:25:08.7505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v/9+rR7tyrGUTF0fBoRSYp7dZkWp311hIVIckHG6ZG+4oiCKCJ3QKbcVeo0754QUrP3msXaDb6hwbBjQeEFv0KxsXd+Lk/PQPRN0Zaq5d94=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6317
X-OriginatorOrg: intel.com

Xiao Yang wrote:
> Try to make daxctl reconfigure-device with system-ram mode
> offline memory when both param.no_online and param.force
> are set but daxctl_dev_will_auto_online_memory returns true.

So is the goal here to try to save some steps in the case where the
kernel already onlined the device?

It should probably emit a warning that the memory was onlined
automatically so the admin can consider changing the default kernel
policy. Otherwise, it may be too late to undo the onlining at this
point.

> 
> Signed-off-by: Xiao Yang <yangx.jy@fujitsu.com>
> ---
>  daxctl/device.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/daxctl/device.c b/daxctl/device.c
> index ba31eb6..dfa7f79 100644
> --- a/daxctl/device.c
> +++ b/daxctl/device.c
> @@ -83,7 +83,7 @@ OPT_STRING('m', "mode", &param.mode, "mode", "mode to switch the device to"), \
>  OPT_BOOLEAN('N', "no-online", &param.no_online, \
>  	"don't auto-online memory sections"), \
>  OPT_BOOLEAN('f', "force", &param.force, \
> -		"attempt to offline memory sections before reconfiguration"), \
> +		"attempt to offline memory sections for reconfiguration"), \
>  OPT_BOOLEAN('C', "check-config", &param.check_config, \
>  		"use config files to determine parameters for the operation")
>  
> @@ -734,8 +734,13 @@ static int reconfig_mode_system_ram(struct daxctl_dev *dev)
>  			return rc;
>  	}
>  
> -	if (param.no_online)
> +	if (param.no_online) {
> +		if (param.force && daxctl_dev_will_auto_online_memory(dev)) {
> +			rc = dev_offline_memory(dev);
> +			return rc;

It is not clear that this is an error that should fail the
reconfigure-device, because the reconfiguration succeeded. The fact that
the kernel policy forced the memory online is the administrators fault
for setting conflicting policy. This is why I think a warning is
appropriate because the administrator is confused if they are letting
kernel an daxctl policy conflict.
