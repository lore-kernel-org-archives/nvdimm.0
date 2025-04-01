Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9484853AC
	for <nvdimm@lists.linux.dev>; Tue,  1 Apr 2025 17:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743529669; cv=fail; b=PinOpaZGyFS4l5//JNFFFUCmzQ0lV9OBYru5ktmw0TTqAsjXoWMAlOjTzALMz7GT04qFYiUmz/K6XAd8hfKIT421l1VEiphyeWkAP7ET+oODnGFqh5xAfSa4EJgvuWk0YyyLfsYXLfgnyL7+7qRWtOKSmBvp/qf9ydM1CMD2Hno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743529669; c=relaxed/simple;
	bh=CcseOYLbrtbQSZMhrasBQnChiIxdBeqTk8HKW33hyQE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=e6iD1b24lrHsKXMzCxDar+QAKrZqHcdilxVL5QZF2SDY2SGgEJLDjzF3wYUckgT9Kys9P9VPcDi8PYHG3W4SIgVZ0trRYtWeYXc3ja30IWfh3DkL8EZBevuex5JC4eXrPz61I0eNbu6ctCVlWvi3RVA+j0cLM1ycDW5vMfe6qX8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vp9zHZuP; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vp9zHZuP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743529666; x=1775065666;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=CcseOYLbrtbQSZMhrasBQnChiIxdBeqTk8HKW33hyQE=;
  b=Vp9zHZuPpKjQXvwNPgSfxzqID5zqe00Uw6yfH76cZylzYkvEMKQd+df5
   KhoYUzRhkhUsmtLB0tyxLfyrg9F6RxSzW/WsDoNh4PYBDWHTh28iX09L+
   CANjAqdrEDuUOu46QuaHhQ8fJrjac9kj0kxclRG9elibmn2OHS7wIyLTE
   PD4PyGy12DeWS8HXZuxS9i1Bf8329KvhUgjFJ40VuR+1cAD0dviWF1X6a
   /i41HFdoaxgvMDUqryoDFUomAowYNfyeGO57Bg/lUhKXyQXC7QHchHvNI
   OPMyjX4D4v5Ng7BmmhDw9IJ69k9caSuqR6nxBCRGWvwz86Vt3zer3jw/1
   A==;
X-CSE-ConnectionGUID: Rg53ahJFQi6f2dRIAVVpIA==
X-CSE-MsgGUID: SxpJWFvcR8i1B5ePv8sNnw==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="70226745"
X-IronPort-AV: E=Sophos;i="6.14,294,1736841600"; 
   d="scan'208";a="70226745"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 10:47:45 -0700
X-CSE-ConnectionGUID: VMX+6qM8RiOAtwA0YmSRog==
X-CSE-MsgGUID: W+CxXhbUREqSFVOMalnpow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,294,1736841600"; 
   d="scan'208";a="126211840"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Apr 2025 10:47:45 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 1 Apr 2025 10:47:45 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 1 Apr 2025 10:47:45 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 1 Apr 2025 10:47:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o0JMIA1gUWiwHZXLJ8+sOKNiVA9sjyB/opG0CUl4UscmoJddmopv6nE2Ix2qvkTtxeHhm7ZM6gIeU+V7nY1Qjb4ei1R+7QxD0kzvoA866b3pzz9we6a9fQPsOy/tihGjIdjj1aoIdOrnIVWq+2GqYH+MI5mHMBKKhWnN3wgEq5m5PDhlFQxhu3iyKQYkxcATpouDbTyi86t/WE7FpwN017oWwshXpzYwBI/ozMLDrjtbslPlwumjemRQK14Po3+bziJseuOtei7x1bmeoYw+wAiqiEDzoCckYfx8oDv1bXes4FEo0VsqvI/KYAR8m6IpSCiYh58dxAtMj0WKiAdPqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DNR4KcbjSraO+yGOlrAxa4edc5rkIqm/O8unyaoyVQA=;
 b=kkEfZXrSJvfO6m0FO2avR7mGoyTaPOwjvtR0QnXLXvnDGAn9goM6UotDKk7CCnreOUfqXo2ZVbnnrhxZupea4ZgHOtjOH2J1tATeK9PfgDOigqAZ8vosyK4ixeXokmjybj9O/0uDuCXGwyj2ZvuNKPOac/B0bmc/jio5rKUHlEynDJS0iPmiyqVHjA+didFyiXNW+ELEvZnk/pXCBULHzloOj+9Cb/5WS3OgawZ4yKoo9mEULmr2gyz+etwW33OWAWkICckO+x+KX2JXkFZp33K6IXhDi3guBPZvyi7bduCzz9Ay+TU6cRdsLGO/yFJ99afd7cS7ZgGcYaI9yRA6tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA0PR11MB7282.namprd11.prod.outlook.com (2603:10b6:208:43a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Tue, 1 Apr
 2025 17:47:12 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.8534.043; Tue, 1 Apr 2025
 17:47:12 +0000
Date: Tue, 1 Apr 2025 10:47:09 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: David Hildenbrand <david@redhat.com>, Gregory Price <gourry@gourry.net>,
	<linux-cxl@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kernel-team@meta.com>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <dave.jiang@intel.com>
Subject: Re: [PATCH] DAX: warn when kmem regions are truncated for memory
 block alignment.
Message-ID: <67ec269dc51da_1d47294c8@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250321180731.568460-1-gourry@gourry.net>
 <88bce46e-a703-4935-b10e-638e33ea91b3@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <88bce46e-a703-4935-b10e-638e33ea91b3@redhat.com>
X-ClientProxiedBy: MW2PR16CA0070.namprd16.prod.outlook.com
 (2603:10b6:907:1::47) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA0PR11MB7282:EE_
X-MS-Office365-Filtering-Correlation-Id: 389fa222-1123-4caa-bfde-08dd71453bbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?d4R27fTjFDVNIYV+aJDfUW7HZlq3V9AmQ7wRKme5v5tZqL9IU7zi34xseNBC?=
 =?us-ascii?Q?OdirBCPTg9CagNL4kqy6Xv6psaSZDwkeiwY8vkLGP1L8Odr1O/51vCrULLd0?=
 =?us-ascii?Q?8uex/hrS7Zuy7Zp3tomOY4Ue/pO5q6rYMH+dhw0JIk+9aOi4F7Euz61CGAVr?=
 =?us-ascii?Q?Em74WsbgAYW8nZ8NyhtH8niwzI52vuyEETNOpbo6Xa5PIhJu/BAyozevHVbM?=
 =?us-ascii?Q?tfIZJ47RlkiybHnDJ0kJeL50cHnsK5KEtmvQM+le0Y+OZmv9LXSuyGDSX75f?=
 =?us-ascii?Q?YpDMIyQSQ250QBDRp8WJKYqVVsGErUWEpyBbbavykoFA5uJeLW6DD4HTxv2v?=
 =?us-ascii?Q?S6VAvg5meVVZzpwHoV2H9RMebTxKQCOlV6vu7PDK/WL8tiLqqZGFTurHBnI6?=
 =?us-ascii?Q?o783ZLpiYB5aHbcZG9GwGBNuONwxHSo+skIFnjfIcnHi/G3pB2LOLTaVWzzB?=
 =?us-ascii?Q?VGy+0wLoa95Q4Z7Aw3/F1/TTibS1lvzsbJQy5ycYGQjB4XmNuy10h6M2nZGe?=
 =?us-ascii?Q?wTIXkIA2vS27B5EmvwQILU2fye/gyY7FxhEKlIqpr8XlCyLCs8gCGFdGdy2D?=
 =?us-ascii?Q?dLRYlt1PTbcTJDqDx6Z3pVReiHtFSXJ1k/R0sOVhdrOAKlH7bPvZRRyh5Hct?=
 =?us-ascii?Q?5l51nQEvw5vlwaooCAv8OJBSa47YGSmx/JvyL6iR1kC3FD5w9ghs36ckVMAl?=
 =?us-ascii?Q?HG+yjQtQP4xWCCRVoh8I77sYxyBJ7Q2W8bTKtdP5bgggjCU29BtGyDTvpdtV?=
 =?us-ascii?Q?1LhOukSjXWc5cQFglseGcBKAbgtTRWHe54fHlXL6TO/Q5m0I9cE1uSHLxVSu?=
 =?us-ascii?Q?b3wUMcMkuDLn6gL1Lr6EN8IVi+be+SVPiMXudRWtWPEJmCKOeh5Nc77bgbpV?=
 =?us-ascii?Q?5yiBtZgTSwPPiWUhbXunkM2sTn+8jUHefsWgxqGYvxt9+9Uu9tKy5EVKs1ao?=
 =?us-ascii?Q?dQToV5d6WZja7U5B7oYp8uFIUyGZs8wEB3bX9HtdQCnfyrNgtIvnyrV6avxD?=
 =?us-ascii?Q?EtenaAyn1q1cXuj73IOuH6EADBXFekRles89fFriYHmp/SEzaBRnumrnwml+?=
 =?us-ascii?Q?srUZE6F+GbN26wwZ6fZUcJlF+BOk4sJDO5YbryJ7/4tPmN2SDYfqaRzIYlQa?=
 =?us-ascii?Q?Paja5fRQmwjvGpj+MxNksI1Yjp7Y57vCCByIf2B/5lE2IXMQ4kr/GoW16kis?=
 =?us-ascii?Q?hyEptWDKRjSVpDHc1WbQUw36E8W62rMFNkhRrOkPnbMufL3spqJFb8MWIZzN?=
 =?us-ascii?Q?EPU5x7mVjbltRPsT6ct5w6zSFFI26O2js6lPGyySYhlB0fqE9FpiJCizNzfI?=
 =?us-ascii?Q?Loflrq53ttkdPKBWhC0u70aWnA4fNmsAxLHcAAw+tcl2SCtQQ5Zp2MPmE04G?=
 =?us-ascii?Q?Xgkr1o8ttKWmMuRiuMEqkO2cOxAQ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YGdK4OSbO/Wq0vdir+1VuY5SLlCLFqgXU+lmVSg9omqGTYFgypCyWyyNKS8f?=
 =?us-ascii?Q?UiQ4HrDCYToydMmwo06YoI3orJpwLTc8tsQCH5y/2GBs8LWE65mpmc1m5dKA?=
 =?us-ascii?Q?FOCcZ8SY3lduR9BY7G/ofMrVCmGT1xLGzagdg3EAgGUI5xIEF8/6tU5PKc28?=
 =?us-ascii?Q?d1lRl1TLiLoVEPBKZrWQOTeCfu5FziB3t18cv1aj9+uMUd6lNP0TyF4bTruU?=
 =?us-ascii?Q?d+01mCOAKhZqEEgEMqnJygOiOity5T28VPaVQ77t2VszVJm/zCx7sLSAZmVv?=
 =?us-ascii?Q?XA3HHmesYYBF7hHDM3NcuEzACvZAgxYNJUnUgtjRYRB7ZNYOx587FmFbB/Sg?=
 =?us-ascii?Q?5G9QSUZ33Jo1N0PChLhrgPqc4j0LgTXVkMuJVw8UnyhDTiptrg+J6i8k0eYr?=
 =?us-ascii?Q?iyP7OX4PD/PQ7+O1e11eJakL+mlm8h3UEsasC2L1snNyygzN41e3dYrcmyE1?=
 =?us-ascii?Q?acDXEJ1+xEPOMdpxSSPuNVRi2YpUxJuHVPBYJMKj5wYGFK2MLU3hMpmDPm6+?=
 =?us-ascii?Q?Dk3qMdwtyljKR7d/QIB0evpnEC84saOqB6AFAQcGKWysdToPF4UsgwLg9NnJ?=
 =?us-ascii?Q?vbx6c5cE8hGYk5s2H9yE3pd7EgFbGBfAvVKClt5sRbXrerM4ZoEjTnf/2KOv?=
 =?us-ascii?Q?0in3fj26nW3IvRP7pPmxum5lECKFDOHDci3Jya5k9+ymyrL+40RIcaWX+hbF?=
 =?us-ascii?Q?sHokQg2hdk2kDx380VuU8FP+N3fVn25k5b5TNEeHixGBXCTLagKFy5+OLF2S?=
 =?us-ascii?Q?W50kE/OKA4GxNXiTIK+pFEbx8tuEgd82pnOLqgvtX7Ok/5BcDE3IM8HSFMPB?=
 =?us-ascii?Q?7c+DXEcNYEh8aGrxnYc73LYjSM0/yddg6lxeus/u01e/ehVkjsIIgveHdbek?=
 =?us-ascii?Q?dgSY428QReXvJQTcFZ4rUFeDPODLiK/R81Hz9rCtx9sxRnq2rrO3wSJqzMsB?=
 =?us-ascii?Q?zxmMCs6lLep70eeJ+omOnPM+wUhbCBRJc9M5nZOvOhG9k+/8TucTb0pWrfPf?=
 =?us-ascii?Q?yzY5SLnBLUox2YtF8T+pBiJzCpdUS7dNi4cX7zchzifHDVGrJJ1Kmluf/Scp?=
 =?us-ascii?Q?eCtg90dQq+QKC/TXuk65wK8l+We9gZGTL9txgxH92sYN6a9HNwV128FEBYdp?=
 =?us-ascii?Q?IPKhJh7nZ5YKKleNk/+yEdoeb/53nQkL1V1Q47qAH2yAGFLbfASgGA8NT0ZS?=
 =?us-ascii?Q?r5yf7yUtIfIE3z8y9qhE+VaTrlM1B+HfQZxls/fJRk3mld53KXDTqaegSZVz?=
 =?us-ascii?Q?0QAzhZeT7sDpKuOtOBbCDrEgViL+vGE+Bc8WKWDPdHP2VIMyyVpAK1rjtmOj?=
 =?us-ascii?Q?ZyWsS2FIDkJ3YbM81Hf1b9b5V8JkHtowBKg0exIp3nclOWhKWkw3aK1UGvhc?=
 =?us-ascii?Q?luzr2OUDpaErHLuvY0tF7JFHUki59YcW6mv+YWF6qCoQJ/b/XHvpIsJ85WOw?=
 =?us-ascii?Q?IRx4s0qYb+HeKp0jR0gqmArZ05RL+RSQloIKZOTT7cm6G8evYp9LwWvpw55l?=
 =?us-ascii?Q?YI4YjaW5700KtUMcTa3fosYVJ/gU963in4aPummXk2es0LGFTpG5zVIMWzjT?=
 =?us-ascii?Q?QOKuvAe9iDBQ/P6WpbJ+U1gxMO8p54D2odeUUNSOcxMK5/jtCWrKsox2iRoY?=
 =?us-ascii?Q?XA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 389fa222-1123-4caa-bfde-08dd71453bbc
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 17:47:12.7312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QXccJxeNtciXeXZGRKbSwn3x8pxLt6kPPzQDGL/TlD0y5LxXxl2lPRPljGnOjE6WCuU58mDC5cMq9zDiWMDOVWO0uzk7oSd46qeilp7Oq6I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7282
X-OriginatorOrg: intel.com

David Hildenbrand wrote:
> On 21.03.25 19:07, Gregory Price wrote:
> > Device capacity intended for use as system ram should be aligned to the
> > architecture-defined memory block size or that capacity will be silently
> > truncated and capacity stranded.
> > 
> > As hotplug dax memory becomes more prevelant, the memory block size
> > alignment becomes more important for platform and device vendors to
> > pay attention to - so this truncation should not be silent.
> > 
> > This issue is particularly relevant for CXL Dynamic Capacity devices,
> > whose capacity may arrive in spec-aligned but block-misaligned chunks.
> > 
> > Example:
> >   [...] kmem dax0.0: dax region truncated 2684354560 bytes - alignment
> >   [...] kmem dax1.0: dax region truncated 1610612736 bytes - alignment
> > 
> > Signed-off-by: Gregory Price <gourry@gourry.net>
> > ---
> >   drivers/dax/kmem.c | 18 ++++++++++++++----
> >   1 file changed, 14 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> > index e97d47f42ee2..15b6807b703d 100644
> > --- a/drivers/dax/kmem.c
> > +++ b/drivers/dax/kmem.c
> > @@ -28,7 +28,8 @@ static const char *kmem_name;
> >   /* Set if any memory will remain added when the driver will be unloaded. */
> >   static bool any_hotremove_failed;
> >   
> > -static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
> > +static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r,
> > +			  unsigned long *truncated)
> >   {
> >   	struct dev_dax_range *dax_range = &dev_dax->ranges[i];
> >   	struct range *range = &dax_range->range;
> > @@ -41,6 +42,9 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
> >   		r->end = range->end;
> >   		return -ENOSPC;
> >   	}
> > +
> > +	if (truncated && (r->start != range->start || r->end != range->end))
> > +		*truncated = (r->start - range->start) + (range->end - r->end);
> >   	return 0;
> >   }
> >   
> > @@ -75,6 +79,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
> >   	mhp_t mhp_flags;
> >   	int numa_node;
> >   	int adist = MEMTIER_DEFAULT_DAX_ADISTANCE;
> > +	unsigned long ttl_trunc = 0;
> >   
> >   	/*
> >   	 * Ensure good NUMA information for the persistent memory.
> > @@ -97,7 +102,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
> >   	for (i = 0; i < dev_dax->nr_range; i++) {
> >   		struct range range;
> >   
> > -		rc = dax_kmem_range(dev_dax, i, &range);
> > +		rc = dax_kmem_range(dev_dax, i, &range, NULL);
> >   		if (rc) {
> >   			dev_info(dev, "mapping%d: %#llx-%#llx too small after alignment\n",
> >   					i, range.start, range.end);
> > @@ -130,8 +135,9 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
> >   	for (i = 0; i < dev_dax->nr_range; i++) {
> >   		struct resource *res;
> >   		struct range range;
> > +		unsigned long truncated = 0;
> >   
> > -		rc = dax_kmem_range(dev_dax, i, &range);
> > +		rc = dax_kmem_range(dev_dax, i, &range, &truncated);
> >   		if (rc)
> >   			continue;
> >   
> > @@ -180,8 +186,12 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
> >   				continue;
> >   			goto err_request_mem;
> >   		}
> > +
> > +		ttl_trunc += truncated;
> >   		mapped++;
> >   	}
> > +	if (ttl_trunc)
> > +		dev_warn(dev, "dax region truncated %ld bytes - alignment\n", ttl_trunc);
> >   
> >   	dev_set_drvdata(dev, data);
> >   
> > @@ -216,7 +226,7 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
> >   		struct range range;
> >   		int rc;
> >   
> > -		rc = dax_kmem_range(dev_dax, i, &range);
> > +		rc = dax_kmem_range(dev_dax, i, &range, NULL);
> >   		if (rc)
> >   			continue;
> >   
> 
> Can't that be done a bit simpler?
> 
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index e97d47f42ee2e..23a68ff809cdf 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -67,8 +67,8 @@ static void kmem_put_memory_types(void)
>   
>   static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>   {
> +       unsigned long total_len = 0, orig_len = 0;
>          struct device *dev = &dev_dax->dev;
> -       unsigned long total_len = 0;
>          struct dax_kmem_data *data;
>          struct memory_dev_type *mtype;
>          int i, rc, mapped = 0;
> @@ -97,6 +97,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>          for (i = 0; i < dev_dax->nr_range; i++) {
>                  struct range range;
>   
> +               orig_len += range_len(&dev_dax->ranges[i].range);
>                  rc = dax_kmem_range(dev_dax, i, &range);
>                  if (rc) {
>                          dev_info(dev, "mapping%d: %#llx-%#llx too small after alignment\n",
> @@ -109,6 +110,9 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>          if (!total_len) {
>                  dev_warn(dev, "rejecting DAX region without any memory after alignment\n");
>                  return -EINVAL;
> +       } else if (total_len != orig_len) {
> +               dev_warn(dev, "DAX region truncated by %lu bytes due to alignment\n",
> +                        orig_len - total_len);

This looks good, I agree with it being a warn because the user has lost
usable capacity and maybe this eventually pressures platform BIOS to
avoid causing Linux warnings.

In terms of making that loss easier for people to report / understand
how about use string_get_size() to convert raw bytes to power of 10 and
power of 2 values? I.e.

"DAX region truncated by X.XX GiB (Y.YY GB) due to alignment."
