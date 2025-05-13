Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A50627455
	for <nvdimm@lists.linux.dev>; Tue, 13 May 2025 00:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747097195; cv=fail; b=KpTCZV7IuyiqQI5f+xdwShJbRq8NEw04QSFWbcUIJDFGxraxFHfwCk92uH7V5MPG9kopd5Ffzg6Djazns/suyAQT/6CXjnDr7qvKYRh14AHrE0fVWC7xaLYK6QeVM5xBD+2apaooGNlqv7VPk80+o+C0YE/pFnIL/+StAYP+G1c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747097195; c=relaxed/simple;
	bh=Yb0rpnZLJIzGEM9jWQDLmCiKWHroOEeyA1p2V3P2qsU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mSHOD72MS6ihrzT/MtyOBhOYM1li1grc+x2TZHl2RfBj9MJXRiOTR1/m/V42Y06Wwl0ktdioACtW73un6TgctntwlzrLDohVXA86jc+uJ5bdl72YQsK5gsYCxTwi2sohJuNHUrfy3xmRuadwG0SLYDk747oZN1OX90aEpPUKOfA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aqwQLyId; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aqwQLyId"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747097193; x=1778633193;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Yb0rpnZLJIzGEM9jWQDLmCiKWHroOEeyA1p2V3P2qsU=;
  b=aqwQLyIdCyr1C+6pqSgc7juXDUOmJcuD/0Dd59nOF7/7Qp1D1qNHSQXp
   dMMxvG8tJJAfa3OWTNG11fiiAhVTLyjT0LTRexpjRPvpU0ZaYeNVg7M91
   ELUgf3nES0s7xBE7TBsLUzAC6ToOuSBGAEZKCNvk0Dk+P/2n/iJdAhL+X
   U2BYEvSo+REO2ehK+PiuepdIRuGP+cIUheoImNFoc5m22RtWHzzqzj9f/
   pnRICNNs8+DwcBIJkrtIAIqEGYHNYi7mgz0mFIWB9h1QhGB6Pn5xCJTlm
   DcCEbxq9TrnjHRK666ZQo37A41Xa5HpXcVbU0KxPYYlPiLyO+qn6k9MJ7
   g==;
X-CSE-ConnectionGUID: yNLayJ2dRAm/MAZp4hrLWQ==
X-CSE-MsgGUID: VatImzc6RrGrs1LhFl/sEg==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="66328337"
X-IronPort-AV: E=Sophos;i="6.15,283,1739865600"; 
   d="scan'208";a="66328337"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 17:46:32 -0700
X-CSE-ConnectionGUID: ZB43DXZGQqa6OpC/5OOYtA==
X-CSE-MsgGUID: XFDdSpqPTJWDfp1tL68GDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,283,1739865600"; 
   d="scan'208";a="142717576"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 17:46:31 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 12 May 2025 17:46:30 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 12 May 2025 17:46:30 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 12 May 2025 17:46:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mquiyuwvAVBVPY5BEuAchpvDo5Bro0jQ+JURVyefKvIth0TH4CY6Qoj9eZV1/y5Rn0n6Z7cP15gZIRRcMK51J9us1ElOCq+a1WplIOQ5Bbt7NBqu0cAHvx6PV/UsSCtPXpmDJ0Ybplu/Gv6mfiEcy5rBhEbXnoev/ZYlUnRktYwjrJoFNdBNNw+QyhJGh9rgZ6iWdZoVffQFNkSV0aVUw92U2bylk9EtzvY+C74qi3LgwiVyqtRSsQOYTCtpA110RRYaCRhSSt9+w5j7xHx+qYusC0tpSjCnaHMIoxwQHJiSG8FrKKzfmsB8mqz5+abmB3Coi+DBKLGCttGeSVKFNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cmnPcXma8csJJQjeNImANCMC7T6jnA4xWSp+ZSBZWcE=;
 b=RhXPTXMW9FvIqTwip4Ru8ZaW1ExiFtrcboo+z5+6h9HIbYoE+lfkUHoRboL4iEGFDapuzSXXCUmazYVULWuzjTZiORviNHxW9KorKf8rqvuZR3mdfVpXjO0Ig8ko4vL0+cFsBL2K0Y44ji93yhYr5bWiE7LQo1i0i81yAXJ4fJM+ju+/MXC26/b78X6x7gstNcT1cvNolqSfAFEhrhG/Mpfp9gE6xLjhg4xeMs1vMvNa0vSLfD9s6pSztTxmrOanzlDHirIRUCIz3DA1hkDhbU+FUKPRjiyI+BL2u4hQXvIGLmn+wHGQMSTP8RBXRrTSEzeBvFAFLhhaoI8v6sUfyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by MW4PR11MB8267.namprd11.prod.outlook.com (2603:10b6:303:1e2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.26; Tue, 13 May
 2025 00:46:09 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 00:46:09 +0000
Date: Mon, 12 May 2025 17:45:59 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Marc Herbert <marc.herbert@linux.intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH] test: fail on unexpected kernel error & warning,
 not just "Call Trace"
Message-ID: <aCKWR4DdzdUh1VN6@aschofie-mobl2.lan>
References: <20250510012046.1067514-1-marc.herbert@linux.intel.com>
 <aCI_ZxeC7r3UpkvZ@aschofie-mobl2.lan>
 <4c923c9d-7e41-42f5-802d-0199c91ec188@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4c923c9d-7e41-42f5-802d-0199c91ec188@linux.intel.com>
X-ClientProxiedBy: SJ0PR03CA0144.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::29) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|MW4PR11MB8267:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cae1f1d-c0b7-4c1b-6321-08dd91b78d02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?2a+VjSW0tJX8vE7n25wVzlkIlgjcZEZOeTJEI73lBQVqofpaLK10cHR8/bCu?=
 =?us-ascii?Q?XneBifmtwgtBJTxcLctoinDWPCaCa9mAomal00lWmgQenDehYXlJRu2CW8ME?=
 =?us-ascii?Q?PbcOse4TcQZi/nJ7FmEvOSMjderxyYYEHPg7+QRmM+KYhXfUUbJqTaGisBgO?=
 =?us-ascii?Q?OWhqqf6vcaYfpDpzNjob2Un/mT2nNsPeVG8kSKAmnAwUyewPtg03ld0KKB1Y?=
 =?us-ascii?Q?FvKIpnO4EVdm4UJXHmS9P5AoEO5X8yckTWuz+ETAWVF+KMvm593MF1y5r1ds?=
 =?us-ascii?Q?nycFuHu9TgP+wULrtBHAfbOFtDmySkMvFhdCvRGeYfeWmEhSqL6Q5i2dxc5D?=
 =?us-ascii?Q?MiqSGs3ieAO6NDhVmtFf9ZFv0lZtFao/rqyh277FkyLVx8XCnxiTwE7CQ2fk?=
 =?us-ascii?Q?DplE+Uz4jfGI8VbmhsWPNBURREL8JX2Hvsw2aarIG3vaCh8PnolkJ5XQHpUu?=
 =?us-ascii?Q?sJftYK5KcLKCdeYTgOIWoC8jd7n1fY8czLtAr/VAV2j7pCq8PrMEd5saObsZ?=
 =?us-ascii?Q?pZoDlwZzaFFDcGPKus4oDRW7M6lM97vdHbJqF7td7P8906DBFpwPJaC8Bdnv?=
 =?us-ascii?Q?1nw0+raIUKq1NgZYx3P50oh8JQPp0cArMJ+x5xa0jiw6B90YC/yn8U57sDez?=
 =?us-ascii?Q?MaaRvXGEYaPxjVEzUbN680B2EbnFJyNpANPOt1Mb4DMq45IF/axvEdhP7IlB?=
 =?us-ascii?Q?gCI5dmYUIi14jwRPdP7RtKAHr2jJfottIiwi+HKVgH39f/PouB8EiSsPbKFG?=
 =?us-ascii?Q?QR2hlki3/gMVTf5ic+LLvVNQWlZf8FE8YUHtrXCdUC8VK6sUJ+iF8/7Rz1dR?=
 =?us-ascii?Q?FwnlTtUMPHLHo1+Zw65juXZNyZNIJ9Y9xUvpxg3u0NI9KeQzOxLi5qwIXaef?=
 =?us-ascii?Q?TrR2illsWo2cAcfVuO8jcQho7mbZGUPSOjMLngXrChBSCDJRcD1MQlWL+5KD?=
 =?us-ascii?Q?sc05h7BSabUM7rz0ygX8F72kz8H0hQFbOe76T/3FbEpH1cdJ0aJC1hfNcYR8?=
 =?us-ascii?Q?O1H2RGcsBW/JilwkhiNO/HGhpHJlCjKvaysCojk/GlakWnmPuUQGNMU42Acs?=
 =?us-ascii?Q?m7N9dPiMq5o/mWqgFL9IIRCc747lNEseuOYxzwvVeMC0EH111Gx4X36nDj8d?=
 =?us-ascii?Q?DyNXmWtXRYJ3nfpam8T1FcpJnDmgcdd55zvlj9PVnF9ah/eSjJUwTS+r1glc?=
 =?us-ascii?Q?cPmcomQkwkLijPVmWPJWSMTd41PX1W8axs8D/EYZ9eJzlsfOi426cCl4eBfF?=
 =?us-ascii?Q?E+xIze7nI+bTIOzwgVJj2H8wkTHVdDuATPy0GNw2NfNZMO/zyIQzHm/UiBM2?=
 =?us-ascii?Q?2Os+l7mll7IYcMviehMTl+S5ONqLkmWd1S/5sZN+Q9PXaLx1oBGfOC74C+TL?=
 =?us-ascii?Q?bsWmvDQfxvdcT6mEkaVWT0kDtrBI?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qyFOR2ra9KJvL7AVpAwW8t4mxDYZj/e43bA6NeBaMiUtjb26eS+EEdXC+kBX?=
 =?us-ascii?Q?kLp0gbcDb6Gy4sCgNTvZsuJIWKfqZwVRKrRR7q8mW9zjiST1fi9PO/ay8iyI?=
 =?us-ascii?Q?yFegSlB/KZFI0PLc6gANy459ImiYN9rupCKn6mAMNI/Hgjf9jqeU8rpKhiOk?=
 =?us-ascii?Q?TzFn2ncyZQ7QvAg4m2rATafz9ZGezP85XQzJYKVMdHahT/7do9wvrleflwCk?=
 =?us-ascii?Q?mOGVAbU5XBN8oP0+wxarYKZ5bM/0Ucf1ylk0u1p0yA025/shq4rEvPpqn364?=
 =?us-ascii?Q?ih99EB45XFBu+vfmbfohi8dVVyMvqI0cdiCS4JxBKsg5Ia8YGWrJ8eIpMT0e?=
 =?us-ascii?Q?iaIURR7BSE6ArkVFgi1SESzTq7Ax8tbtnspSUn1ylWaJEaefD3mth99HE/Rb?=
 =?us-ascii?Q?W+T+lGdugXlyfE9OnGziUCO4YK34NazSY4FAx06S3daVzk1yVhPQ6s+Will4?=
 =?us-ascii?Q?mxIwxbmP5w0rge4vOOahOM776Apho3gLlBKjkdwwc0ag2KnVuSAtOmZV+hiy?=
 =?us-ascii?Q?Mp/HQtccyLY1x2/nMDH6iXrJYvweYigTGPa1SE3778vV+4SptNz7yte6f4Os?=
 =?us-ascii?Q?RF+5KwRq67XKy8l8GSyPwAsWtoQXHlQMqjwX7HloqFHcJdvPPk3eyC/a+Y8I?=
 =?us-ascii?Q?5k2l6jPsOb1u1qZxwdUaCPJAADQy7dsW2xe7gxIXj57G3p3vt/CRB3ea9NQV?=
 =?us-ascii?Q?t9z0GN9XmebiGOjccPIKAOX0u1vVsv78o/AOAMTaPVEr28GuH6qnKb6L6hr+?=
 =?us-ascii?Q?qnW4an64Cy0PN5czNX7c+X+vP+pRWsAf8LQfUFZW7Iq4sYvFYk8FoCY3c2fb?=
 =?us-ascii?Q?XEOblvSvUvextL2pUrgjMtxHWDy53lLxQxj5Ds2pMbSqjyhV6WuB7ByMdEZ0?=
 =?us-ascii?Q?ns2VvIRmqUQTUUb5MxeMCLH0SJLDQkjG9xfGZeqwcXl9miEwgyvI1kW8brNL?=
 =?us-ascii?Q?JD5OhC6LXo7U5pa62F5ooK0NarjuBz44LlH+0YBmDAucmqfRqGpjf9bo2J+D?=
 =?us-ascii?Q?zivf+PNwqBoMgzkro8HcfhF6iZVpambmeXM+yY0y6EH+FIQ+nrmH5NlXQ1N8?=
 =?us-ascii?Q?RM/CkJ/6yU7FyULVmrThIrOX8cRiHHAGIhE3Yn0D7jqXT3OetcWCphtRxDap?=
 =?us-ascii?Q?fXkKC44lXqE2MtuzVpf9GLyKgrjZ/51ioSm3zLko27P1zIyHgQiy5MemXcw0?=
 =?us-ascii?Q?0MeZTEK/KUwSNu6ss57w+M8jt1MRH6ZrbGIwPEiEiuVnZxLFUMHaITCi/+q/?=
 =?us-ascii?Q?WuGXNERa43ZRSC69gWmtAjyL2po4+CL1hI4rSYQjcGt8b5JBjnARySwuKaKq?=
 =?us-ascii?Q?WVRn0AaswbsnQRGXLHdI95/rWEtymMoES1kqo6SRsXViT/luuLlzf9LvOAtx?=
 =?us-ascii?Q?6oyoPY7asqeEDqPipzlupG7VRrvdYhGU52SF7JE5pjMKk3Cj+aChqCph4Kza?=
 =?us-ascii?Q?7t8XroZWg/4Uqz+DN8x451ql5nnvcwJykD8gGeibg4uOoTLG93LLr46JebNc?=
 =?us-ascii?Q?HVWYFGFmDLPKZGbs+gGXOPa+PcoQkHBjVdOEQNcDeWkMaUdMn0+Koi1UEWTa?=
 =?us-ascii?Q?bHlq52VCFE0bG2TaPHLVvjsK/3Q2x50B7a35z40ZdoKNCb63uMgcH29rEQbZ?=
 =?us-ascii?Q?HQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cae1f1d-c0b7-4c1b-6321-08dd91b78d02
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2025 00:46:08.9451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YsV4vbt+QgQBylK//NBYWLljipkJWW3TBR78Y6twMN2qubnEQg1xygAzgBFZ+yVR2HpnY9MgJUC5R/4pOqV9vwMCVLyCx46/5wBtDf0iyM8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB8267
X-OriginatorOrg: intel.com

On Mon, May 12, 2025 at 04:12:35PM -0700, Marc Herbert wrote:
> Thanks for the prompt feedback!
> 
> On 2025-05-12 11:35, Alison Schofield wrote:
> 
> > Since this patch is doing 2 things, the the journalctl timing, and
> > the parse of additional messages, I would typically ask for 2 patches,
> > but - I want to do even more. I want to revive an old, unmerged set
> > tackling similar work and get it all tidy'd up at once.
> > 
> > https://lore.kernel.org/all/cover.1701143039.git.alison.schofield@intel.com/
> >   cxl/test: add and use cxl_common_[start|stop] helpers
> >   cxl/test: add a cxl_ derivative of check_dmesg()
> >   cxl/test: use an explicit --since time in journalctl
> > 
> > Please take a look at how the prev patch did journalctl start time.
> 
> We've been using a "start time" in
> https://github.com/thesofproject/sof-test for many years and it's been
> only "OK", not great. I did not know about the $SECONDS magic variable
> at the time, otherwise I would have tried it in sof-test! The main
> advantage of $SECONDS: there is nothing to do, meaning there is no
> "cxl_common_start()" to forget or do wrong. Speaking of which: I tested
> this patch on the _entire_ ndctl/test, not just with --suite=cxl whereas
> https://lore.kernel.org/all/d76c005105b7612dc47ccd19e102d462c0f4fc1b.1701143039.git.alison.schofield@intel.com/
> seems to have a CXL-specific "cxl_common_start()" only?
> 
> Also, in my experience some sort of short COOLDOWN is always necessary
> anyway for various reasons:
> - Some tests can sometimes have "after shocks" and a cooldown helps
>   with most of these.
> - A short gap in the logs really help with their _readability_.
> - Clocks can shift, especially inside QEMU (I naively tried to increase
>   the number of cores in run_qemu.sh but had to give up due so "clock skew")
> - Others I probably forgot.
> 
> On my system, the average, per-test duration is about 10s and I find that
> 10% is an acceptable price to pay for the peace of mind. But a starttime
> should hopefully work too, at least for the majority of the time.
>
> 
> > I believe the kmesg_fail... can be used to catch any of the failed
> > sorts that the old series wanted to do.
> 
> Yes it does, I tried to explain that but afraid my English wasn't good
> enough?
> 
> > Maybe add a brief write up of how to use the kmesg choices per
> > test and in the common code.
> 
> Q.E.D ;-)
> 
> > Is the new kmesg approach going to fail on any ERROR or WARNING that
> > we don't kmesg_no_fail_on ?
> 
> Yes, this is the main purpose. The other feature is failing when
> any of the _expected_ ERROR or WARNING is not found.
> 
> > And then can we simply add dev_dbg() messages to fail if missing.
> 
> I'm afraid you just lost me at this point... my patch already does that
> without any dev_dbg()...?

Let me rephrase that - can we simply add dev_dbg() messages to the
'kmesg_' fail scheme, like in my check_dmesg() patch.

> 
> > I'll take a further look for example at the poison test. We want
> > it to warn that the poison is in a region. That is a good and
> > expected warning.  However, if that warn is missing, then the test
> > is broken! It might not 'FAIL', but it's no longer doing what we
> > want.
> 
> I agree: the expected "poison inject" and "poison clear" messages should
> be in the kmsg_fail_if_missing array[], not in the kmsg_no_fail_on[]
> array. BUT in my experience this makes cxl-poison.sh fail when run
> multiple times.  So yes: there seems to be a problem with this test.  (I
> should probably file a bug somewhere?) So I put them in
> kmsg_fail_if_missing[] for now because I don't have time to look into it
> now and I don't think a problem in a single test should hold back the
> improvement for the entire suite that exposes it. Even with just
> kmsg_no_fail_on[], this test is still better than now.
> 
> BTW this is a typical game of whack-a-mole every time you try to tighten
> a test screw. In SOF it took 4-5 years to finally catch all firmware
> errors: https://github.com/thesofproject/sof-test/issues/297
> 
> 
> 
> > So, let's work on a rev 2 that does all the things of both our
> > patches. I'm happy to work it with you, or not.
> 
> I agree the COOLDOWN / starttime is a separate feature. But... I needed it
> for the tests to pass! I find it important to keep the tests all passing
> in every commit for bisectability etc., hope you agree. Also, really hard
> to submit anything that does not pass the tests :-)
> 

How are the tests failing without the COOLDOWN now?

> As of now, the tests tolerate cross-test pollution. Being more
> demanding when inspecting the logs obviously makes them fail, at least
> sometimes. I agree the "timing" solution should go first, so here's
> a suggested plan:
> 
> 1. a) Either I resubmit my COOLDOWN alone,
>    b) or you generalize your cxl_common_start()/starttime to non-CXL tests.
> 
> No check_dmesg() change yet. "cxl_check_dmesg()" is abandoned forever.
> 
> Then:
> 
> 2. I rebase and resubmit my kmsg_no_fail_on=...
> 
> This will give more time for people to try and report any issue in the
> timing fix 1. - whichever is it.
> 
> In the 1.a) case, I think your [cxl_]common_start() de-duplication is
> 99% independent and can be submitted at any point.
> 
> 
> Thoughts?

Split them into a patchset for easier review and then I'll take
a look. Thanks!

> 
> PS: keep in mind I may be pulled in other priorities at any time :-(



