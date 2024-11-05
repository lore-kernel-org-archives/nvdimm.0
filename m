Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39C51D2B02
	for <nvdimm@lists.linux.dev>; Tue,  5 Nov 2024 20:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730839106; cv=fail; b=dM9UDei1qM6dNas9nWkRWZbqFnb26ntPMiyJomRsgP2yNTHffCzkoMlujv5cT3KE3I1SG0eLplappU4QREW42G/bUHO2VjZYfFAgP4Ya5MIc28nXX21LBPOo7jWeg1rfR7P0dJeIS0uedahwN3kOvyUzO873ZV56eRgD18LwHNE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730839106; c=relaxed/simple;
	bh=7Vc/CTSgiKj0QTmg83Rx5TiAcmGIkutSxem3ZCPxDdY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=c7rUnzT8atKUu4wXWcjb0rOQQYtaDU4pA59ETx2Jx76lUOb55IavkZQFClhTuaVHli8r6QlFeRBzKufpcLmLMrlEQzyuWQQUqApJ3GiUMy9pZxypeeLunmhATWsoas/PtgZkKONjOcOFXFgB/vI9Xnj+qJpk8mAXlu4Ahtwx4y0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VS5TEgW7; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VS5TEgW7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730839104; x=1762375104;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7Vc/CTSgiKj0QTmg83Rx5TiAcmGIkutSxem3ZCPxDdY=;
  b=VS5TEgW78snmHy8tVmsI/YQ2YR3y8dbuHuZYrPeGe/iAN2xE4B4i4fuR
   SmbfRDfSBkR71S8z+i63N0uxPHAUcs7dCG93l+rA/asJYUvT2NkBUwpcK
   X+NsWqpnXMqAbEF7pSRqUogKxYkNxHd0/le3p2dxHGVKC3os2y/Aj12eI
   zgA1RKkdws3dongDr/tAmfpCB0PFLVY1oWqTwwU6u+oIC3HIJeRz4PacQ
   HROOpeszvglDAx46oDgtuq6Mxd3mp1JFNaSX0KtD5kql0nIl5uNspxmVV
   AF4Ahxwj04pccR4CZcbJf9wcL8ogkHS+SlImSbf6vJ2f+geekfkZDP0Kr
   A==;
X-CSE-ConnectionGUID: +IJiRTNgRoa6PM/awJo9FA==
X-CSE-MsgGUID: 4UENRUiMRyqUVotU/K3I6Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="30037871"
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="30037871"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 12:38:22 -0800
X-CSE-ConnectionGUID: 7jjHxvf4QNqlpXps+Cm7aQ==
X-CSE-MsgGUID: DWy4Tv9oQEWfaB8y123dWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="84110279"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Nov 2024 12:38:22 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 5 Nov 2024 12:38:21 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 5 Nov 2024 12:38:21 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 12:38:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pfTyxF9+W/laAepF/diHRHWA5ziWZpBgGIgr2uVS90VdISkdrIRpGzQ2EJKDFXigcOJ/Do1gt/03vjo4PxkVg6SUgUxNima5MEsj67k1LISQ8KVx/0MAZ+TNgu7SpMTrezHD+qgU18Gb7tuZGzr2ERSABx24LqRc5AiHx49sBdoSExzKgzx4wZbfMmbFBYiQ5ip5gCzzBdnN0IBMcan9yaLi8o+8o/YSLJCz0/UjIq9hAllamuraIJcmKDxPdtBwsQNCim96oF/FSRG8cYT52OQ5cRC4jf5Npg0PsyJHUfEPxv2AfbtJGtw5KFpb2VPFEOYcKUT9pkq9Ll4RowE8yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QFh6ma9cjyNUsIMgNVx6EgChX8tQc3TOpBbj7opa9hk=;
 b=diymCbq7wus9C+d5Znp8YVxNJ8kqnN75rQ4nkgUOdqtjL0lXDlFiigFh2jfjSHjNPDHT9Yqy6rkWKv5hLZE2505yFpeKDlcBFWzj1xNPZSDwckJs7169/lf+LlPceYiuazERA/NnveN12xpPlvfqodoSHN1IFI99a1HMXUqwLm6DXiibNI5bP2pyBtKLoEql7pnY/zG3PJEMT2vM+PaBGo7kQNiA6kCAprk8bPE07rIjtyDZx4dDLzCeo0f3tJd5vqQMz2MnpoLvDcsIj0ByfQ4huaNyA9ygxKpm+huvuK8KpFkWs7I5QXG8PMC7v46G975DneBKbbPB8U7vG2Wr5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by MW4PR11MB5910.namprd11.prod.outlook.com (2603:10b6:303:189::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18; Tue, 5 Nov
 2024 20:38:16 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%3]) with mapi id 15.20.8114.028; Tue, 5 Nov 2024
 20:38:11 +0000
Date: Tue, 5 Nov 2024 14:38:06 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, <ira.weiny@intel.com>, Alison Schofield
	<alison.schofield@intel.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Fan Ni <fan.ni@samsung.com>, Navneet Singh
	<navneet.singh@intel.com>, Dan Williams <dan.j.williams@intel.com>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>, Sushant1 Kumar
	<sushant1.kumar@intel.com>
Subject: Re: [ndctl PATCH v2 4/6] cxl/region: Add creation of Dynamic
 capacity regions
Message-ID: <672a822e2f2ca_166959294dc@iweiny-mobl.notmuch>
References: <20241104-dcd-region2-v2-0-be057b479eeb@intel.com>
 <20241104-dcd-region2-v2-4-be057b479eeb@intel.com>
 <632e3bcd-b949-46d0-b524-d6f055f931b6@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <632e3bcd-b949-46d0-b524-d6f055f931b6@intel.com>
X-ClientProxiedBy: MW4PR03CA0225.namprd03.prod.outlook.com
 (2603:10b6:303:b9::20) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|MW4PR11MB5910:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d158289-2f5c-4b2a-b61b-08dcfdd9c397
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?PeVDmL0fxwkLXpI381a1Rf0zr13bQlfyqsFCYSFDlgSyEhy7oMYu3RsVblM8?=
 =?us-ascii?Q?KDXDhyfKe25SAzWSk6rq0btJb2e6pp0pAZpHA6hIC/RMTFwC5/eG3a7WGyXy?=
 =?us-ascii?Q?gjOD2DbUDxOegLM6a8QQpsP2Qt2iLJ5x4jg5W6m+oQPP56j4lPtzwwk9vsi5?=
 =?us-ascii?Q?KGPk1/n1s/wALo+SrSrJaem9bzmOrPQz9gYTT4VOEdCTNurVEVqIFdVO4iq6?=
 =?us-ascii?Q?JSYqKY1Wm6/QtlRxxD7P+LIA0widxohAi1S+KSgYLyHIrzeF7bZpKOi5WkQ4?=
 =?us-ascii?Q?MfazO1Fi6qEfC8j0y45i8D5jdPovIC0P8gWHeYTksgqCytf578bn1c5hpn4g?=
 =?us-ascii?Q?+wPjoK8bU/xKmMbQn7miupl5NsEQZNMUUWhcVYUvA0dmAvoww4Xji6f1D4Xi?=
 =?us-ascii?Q?znmkbwyJ+3xYTy/P5uIGjQY3i1Oo+bsEvkaZ9W/kPhwm5FvaTy2WZbXfxvwA?=
 =?us-ascii?Q?1a52uTKtJAYfoDWNGUNOTR8VEPLWJ4cv1y0iLyUHEMDJ0/TfuQQbwNxwPt/f?=
 =?us-ascii?Q?OoUFqOKGzAyn+b66at0db799zjaJA+7+pkuoX0LI5aoE9hHzpSXxbTpJWN/9?=
 =?us-ascii?Q?93AEhyIPO1/LiEn64U9U1bEB/3kI7T3JbG8naNdUuWzPyV6U3+OD6Bu9ybYm?=
 =?us-ascii?Q?pSuArl6M8JrKQbA9prJKALJGgs0kR2i5R8pRgqGfnnNMKqtNVwfBEEMr1IRF?=
 =?us-ascii?Q?O1pLLP0bwlEqrNafuBqOoPtNXOFr9pGu/aU8LQRCfnGiAZ8qeRNZTVw33gB9?=
 =?us-ascii?Q?pwLgJxqU5A++7tFe2LPYHr5IRvlHHMQwJeL0KkV2abWEqikzJyjHMZna211x?=
 =?us-ascii?Q?NwMTLxNbZa1bXO7BXUxinhuDXRkEq3z97l042TrWzjdZeGYO9TrtDXX9W70c?=
 =?us-ascii?Q?xDCcbFy+XlnzypF3ZhwlY0z7FYxMwMYYRkxbkN/ROjO1FqSlhd6ndiku6EjZ?=
 =?us-ascii?Q?T6mlYRwzmZnUQza6FtfbXgo5WY9cBq8IksAdVO0u//jtu5KOybzCGnA/b71f?=
 =?us-ascii?Q?srHKGDBPyjH921NKfyFyJXRH5xpSL004udlRFYinG8kPSWzsxgRc10qsAuTi?=
 =?us-ascii?Q?mfrwwoWnSeB4kG2IfPkGyCr++rmhivcdH52cDBT+V58XSxlQypsYl/c5U1+f?=
 =?us-ascii?Q?Bu9DBq7fdO5qBv5i8flarV/AGJFJ/XR5pslsSqAJnWDE6E6QGHmwcCeEPXCg?=
 =?us-ascii?Q?bYAULqNmQBo8yjGzqF9z7uOaZEXkXCqdGeHzW116/XizMuHw3C/eXsETE73S?=
 =?us-ascii?Q?Qq2Il9RdszRmjQ06T4J3kdZj2IfWZUUE9fgfsxoyso1wu43IKfGlPbnTUytd?=
 =?us-ascii?Q?FIfsuX+V9ARXgrR9SpHlAypk?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aLMli7V8+f1HWcOrXkSpqGuDhScjGbS3zUwiKmIL7/QE29jvbSUyZbnGSY0e?=
 =?us-ascii?Q?gSBWgZjnJ6hQFZywAsdU2ldKM2ePEkpFDYg60SdVoJNs4PGvco3Qyg4Zd15A?=
 =?us-ascii?Q?ATv/saVxVpReRnPjcVpgoAeWNxNXPVn1vBTbK8c0/yh8uIljpZqszuTy/LMQ?=
 =?us-ascii?Q?uU7hdFR06yzjf9/gyhJDrdGiCZKDC0yWYOqynV53eU83WzDUYtSvUI8hfKBr?=
 =?us-ascii?Q?SzFqnih5BrH+fdUOWye15xyoDtbkqr/oNSRFx9htWxRubKTSAdwV1xSUL5nC?=
 =?us-ascii?Q?zVatD06zuiQTfAFS009oD+OYlIO45RArfRau1GMyUjdvhyijT2VLraD7lBkT?=
 =?us-ascii?Q?1jjSxdoRNNDve84vQ9khtO0vDOwJpE47VmKz1dqYlrkUx/g0AzHZmjb6mucE?=
 =?us-ascii?Q?pQblr3sGie+yXqLPGmfabxwI3B/lbkPVzpAVdyaUi30knUENDXljr2Ai4gmA?=
 =?us-ascii?Q?3dZnBSs8Dqpjq6fIZIKwxEphzA76OBZk0Z5MYmaaw8JD51n+Clk0b0m1cs6o?=
 =?us-ascii?Q?JYwnk9VQdzsLCoLRTI4TFRVQ37BUOpbHXDpX2IQyKHHaQubkgdZLrl7Nzyz1?=
 =?us-ascii?Q?v/a/Dh72BOimkSm3jzaLau9dj046nJod4FIVREg98nvodd8ROuDmuZseXfBu?=
 =?us-ascii?Q?kSPtF9c++XCSBMljRZqvhBDn3+6aXI1GooWWEZQFNoS3vPZBB+xBnuXe+F+6?=
 =?us-ascii?Q?1juWFRhj8NUEUa3PIT8GE04pbazVTziAM15340dH2dCxonruVo576lblkOPA?=
 =?us-ascii?Q?RmjIcmMlZAJ6J38rEhxqpscH3J8+qiJHmjq2bfu4Qa0rdW1MnLkBgRzBcvyg?=
 =?us-ascii?Q?ysbgraKHvVWiWwkE23qdtDwOoNwI9D0yHz7llMx0YurAxljoh5JzfF/q8e0i?=
 =?us-ascii?Q?Q4LsQttwzxeRZxexsxDIsIotRmX222pMc8Bawko5Sqz0edrJkEHM9/STxzpH?=
 =?us-ascii?Q?lCp/fLfyjfhVA+nCYeag6FuYI1PLLJjuVshNkbizUG2Nw8Gv5KwVeCZX0+0f?=
 =?us-ascii?Q?RMluE2lXjptZJqpo44x9g88X+WJ+MRLAm1fwNw3V0Dpb/GJdGUSch8DTk/r0?=
 =?us-ascii?Q?OUBm9e3EzIeIj9Y96ssy61p7CkDcpi7cOoCEwCbSGrh/YfNkDhK11AgNGDvU?=
 =?us-ascii?Q?+ec1D6GJ+hd+Uz6Nt0tgtWMlR1XTM4U/MTbRer9flpqa+SaEkt3wyqebpfmZ?=
 =?us-ascii?Q?r0WCcvnUsAzWfnJzDvvmO59JwzEWncv6vGjSK43QrFGMhDNLNDThOIJZIWhT?=
 =?us-ascii?Q?Y5osGxqyTfPEY3VPcujcLmpqjEoqCjDNVIJda2IMvhWlRThb1avbLjMawv9U?=
 =?us-ascii?Q?sTo/FroU4bypkh5SasfY+mD4KVlCpOGM/D/SbG9cgHwE2oJt5zNWAeT6BWGQ?=
 =?us-ascii?Q?VaGp7T7sbfZk9DooSqGT3+5T+dqejcPJp3b+hMmpq193NExJ1WPgQxGJcox1?=
 =?us-ascii?Q?fBrEyIptflT2xW1/BMlfGcFxJen7zMHuqC3babZ5tvqBKQLtsJrVS7wwgrCO?=
 =?us-ascii?Q?1NmKr5xI9PrKPrVgwrtXsHOvtfNWXkqg/0EXHZz8zBxmneR42apUIizXuT4S?=
 =?us-ascii?Q?HDnBDzidlYk8QrIY+tq5lUSing62AvhPXADIYbey?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d158289-2f5c-4b2a-b61b-08dcfdd9c397
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 20:38:11.3778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RVoX1Jzq7HjLuICh8QrU0IvQwn+iK9+O2NGsn3HcNjzZFaOBD/eUIZUBEu3O9cJNgxeSVh0NgYoWNkApXggWKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5910
X-OriginatorOrg: intel.com

Dave Jiang wrote:
> 
> 
> On 11/4/24 7:10 PM, ira.weiny@intel.com wrote:
> > From: Navneet Singh <navneet.singh@intel.com>
> > 
> > CXL Dynamic Capacity Devices (DCDs) optionally support dynamic capacity
> > with up to eight partitions (Regions) (dc0-dc7).  CXL regions can now be
> > spare and defined as dynamic capacity (dc).
> > 
> > Add support for DCD devices.  Query for DCD capabilities.  Add the
> > ability to add DC partitions to a CXL DC region.
> > 
> > Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> > Co-authored-by: Sushant1 Kumar <sushant1.kumar@intel.com>
> > Signed-off-by: Sushant1 Kumar <sushant1.kumar@intel.com>
> > Co-authored-by: Ira Weiny <ira.weiny@intel.com>
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> A few small things below.

[snip]

> > diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> > index 5cbfb3e7d466b491ef87ea285f7e50d3bac230db..4caa2d02313bf71960971c4eaa67fa42cea08d55 100644
> > --- a/cxl/lib/libcxl.c
> > +++ b/cxl/lib/libcxl.c
> > @@ -1267,7 +1267,6 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
> >  	char buf[SYSFS_ATTR_SIZE];
> >  	struct stat st;
> >  	char *host;
> > -
> 
> Stray line delete

Oh...  I thought that was adding a space here when I reviewed the diff.
Yes fixed.

> >  	if (!path)
> >  		return NULL;
> >  	dbg(ctx, "%s: base: \'%s\'\n", devname, cxlmem_base);
> > @@ -1304,6 +1303,19 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)

[snip]

> > @@ -1540,6 +1552,14 @@ CXL_EXPORT int cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev)
> >  	return memdev->ram_qos_class;
> >  }
> >  
> > +CXL_EXPORT unsigned long long cxl_memdev_get_dc_size(struct cxl_memdev *memdev, int index)
> 
> If you make index 'unsigned int', you can skip the index >= 0 check below right?

True.  To be safe the following needs to be done then.

diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 17ed682548b9..e0584cd658ec 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -263,8 +263,10 @@ static inline bool cxl_decoder_mode_is_dc(enum cxl_decoder_mode mode)
        return (mode >= CXL_DECODER_MODE_DC0 && mode <= CXL_DECODER_MODE_DC7);
 }
 
-static inline int cxl_decoder_dc_mode_to_index(enum cxl_decoder_mode mode)
+static inline unsigned cxl_decoder_dc_mode_to_index(enum cxl_decoder_mode mode)
 {
+       if (mode < CXL_DECODER_MODE_DC0)
+               return 0;
        return mode - CXL_DECODER_MODE_DC0;
 }
 
I'm not sure which is best.  Right now cxl_decoder_dc_mode_to_index() is only
called if the mode has been checked to be DC.  So the above check is a noop.
But in general returning an errno would be better for
cxl_decoder_dc_mode_to_index() is in error.

I'll clean this up to match what is in dc_mode_to_region_index().  See below.

[snip]

> > @@ -2318,6 +2354,14 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
> >  	case CXL_PORT_SWITCH:
> >  		decoder->pmem_capable = true;
> >  		decoder->volatile_capable = true;
> > +		decoder->dc_capable[0] = true;
> > +		decoder->dc_capable[1] = true;
> > +		decoder->dc_capable[2] = true;
> > +		decoder->dc_capable[3] = true;
> > +		decoder->dc_capable[4] = true;
> > +		decoder->dc_capable[5] = true;
> > +		decoder->dc_capable[6] = true;
> > +		decoder->dc_capable[7] = true;
> 
> for loop?

Sure.  Changed.

> 
> >  		decoder->mem_capable = true;
> >  		decoder->accelmem_capable = true;
> >  		sprintf(path, "%s/locked", cxldecoder_base);

[snip]

> > @@ -2648,6 +2724,14 @@ CXL_EXPORT bool cxl_decoder_is_mem_capable(struct cxl_decoder *decoder)
> >  	return decoder->mem_capable;
> >  }
> >  
> > +CXL_EXPORT bool cxl_decoder_is_dc_capable(struct cxl_decoder *decoder, int index)
> 
> Same comment as above WRT index.

This forces changes outside of cxl_decoder_is_dc_capable().  Specifically with
dc_mode_to_region_index().  But I actually like checking for the error from
dc_mode_to_region_index() outside of cxl_decoder_is_dc_capable().

I've made the change.


[snip]

> > diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> > index 0f45be89b6a00477d13fb6d7f1906213a3073c48..10abfa63dfc759b1589f9f039da1b920f8eb605e 100644
> > --- a/cxl/lib/private.h
> > +++ b/cxl/lib/private.h
> > @@ -12,7 +12,6 @@
> >  #include <util/bitmap.h>
> >  
> >  #define CXL_EXPORT __attribute__ ((visibility("default")))
> > -
> 
> Errant line deletion

Fixed.

> 
> >  struct cxl_pmem {
> >  	int id;
> >  	void *dev_buf;
> > @@ -47,6 +46,9 @@ struct cxl_memdev {
> >  	struct list_node list;
> >  	unsigned long long pmem_size;
> >  	unsigned long long ram_size;
> > +	unsigned long long dc_size[MAX_NUM_DC_REGIONS];
> > +	unsigned long long dc_qos_class[MAX_NUM_DC_REGIONS];
> > +	int dc_partition_count;
> >  	int ram_qos_class;
> >  	int pmem_qos_class;
> >  	int payload_max;
> > @@ -111,6 +113,7 @@ struct cxl_endpoint {
> >  	struct cxl_memdev *memdev;
> >  };
> >  
> > +
> 
> Errant line addition

Fixed.


[snip]

> > @@ -488,6 +506,13 @@ static int validate_decoder(struct cxl_decoder *decoder,
> >  			return -EINVAL;
> >  		}
> >  		break;
> > +	case CXL_DECODER_MODE_DC0 ... CXL_DECODER_MODE_DC7:
> > +		index =  dc_mode_to_region_index(p->mode);
> 
> Extra space after =

Fixed.

Thanks for the review!

Ira
> 
> DJ

[snip]
