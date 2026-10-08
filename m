Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4A41F936
	for <nvdimm@lists.linux.dev>; Thu,  8 Oct 2026 02:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791424933; cv=fail; b=OvQjlpS3vU6IIeyXJBVwSHAKDiMw+CxbpO6h9um6IjvHR05CkMR8Qu0KxVIjwSrj+Huaz0h49y6qpfQGBmZGZWh4gBa8NDd+nvSZsFAcKUh4v9ydtLmfPucfB80nH9s+QheJvTfB6bRIo7PApBHTkWnScfDU/dGOCgii77AEmTo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791424933; c=relaxed/simple;
	bh=7jxATlzu0w3svsKgbQtsz9E9v8NAeIq0dhxsj00RPTY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=c7EaYL6hykoaxbvQ5d6I+HVWu6BX1tbBC7IRfHpcJBfZjmjL57xPcREHfFKzx4+K2UkqXrpOZajfeHt0QaqGKqH4cM/sfaOAqldmBEwoe9zvWbAOLZMYMSd4yHOTQamM3PlzCRtMl5I8kaOLXFxDz4M1dm31TxAHqdVvApecauI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oFiri11P; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oFiri11P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791424931; x=1822960931;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7jxATlzu0w3svsKgbQtsz9E9v8NAeIq0dhxsj00RPTY=;
  b=oFiri11P/SV68Csq7DX6iukxbXASdtVYMVcTgM0Hkx890nRlfT2rcBFe
   HK46zeKBQGhwmZnvaL3blhC7Mr6R8LFI4uJxU6GFjP8w7pz4HLIXpKMqc
   qoA3YBW0Vet5YxxvQ5k0yVrSeUyB9Vhmmv0LRxICfV//wFVIFH/Cjr1gR
   4e/dZKXGaNKwhH786XXXDVo+/n+sI/MLyWaTBMcRJIEN4AM9khqdVaWtP
   5QXgOinv+F2PwudaKsoS6/I5WED43+64nsvo2kBS3blpDRABFSnK95g6P
   wbsL1+W+eNe5qR4dQExCFMAib2ajcjy0nM3j0vK4zuUaZ1vrutJvbDFTA
   w==;
X-CSE-ConnectionGUID: 5CecNYEaT9q9ZOo4cEqW8A==
X-CSE-MsgGUID: Whx4n74qQvCgP2T61wqjGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="195889"
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="195889"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 19:02:10 -0700
X-CSE-ConnectionGUID: Z8p4d5XqR2iA+dll8xZX6w==
X-CSE-MsgGUID: jwP2Q/cjSNKZsMolk6mjQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="1699747"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa012.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 19:02:09 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 19:02:09 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 7 Oct 2026 19:02:09 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.8) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 19:02:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gbJuxUrJVIDsbNh/OoltWI5rIvsaag35wKJpuhlrt0d1YR52QNwlIvWS4lTSWUsexJ6MAsRhqkAVFvxek+94emxQqD6cZAAnf3wDlbaa3ctvVPs0t3XDEXwVLHUUCywjthLE28JOpzZVtlEXnM5xMNXmDN3wQqNaE4/CDLvWGRmy+nAkDojbSS1AuHRqqOzM2JK7FET8ANzhZhoipqPLMMAfOlZfTQNZ+6CEQ9SmbD8irA5nqGqNeNiYikirGIqeDMXxUQRWaU3nrfibZpF+2qdW/q9Z5ILPLvQJUrRPlMp5TTrTlzJ8/l6AX0ogTscRZiWYR5llbjlW0x1MWbDhxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rKtLIVNtP9K/sl21JhRoH9sxdk9W2Tn5IUQjoghBD5s=;
 b=MA2msFmayjQcLcOap+Ta5L5TJhErfw1W1WgbYIhpyivyAESHmeDpfF/S/U4JUR+RkGy77Z8M//IuKiKspLCdwAtJ5Z09YFzg2VttAoPtNbSTt2xDMDNMagWiCn7F3TWO/gNPDo9qNJGTgq4rdpQXSDjoccta/SmKj/5Eukx5VrrjChI36Lea6CXi1Cg0fE8VnquisfVT7j6z3o2JInoxr4PAJ27xTw9PsgzNB0h4ox/V6aOYVKhqRFatLUw3v8bE11ZmiX1q3yay3hRhZvgw9Omj4BzV0YIAZQH0OQdF87EAvUuXzxiPj+LU6M0sd8f7JiRc0GIScceY4INZp7ZyTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH3PPF5ACB2DC0D.namprd11.prod.outlook.com (2603:10b6:518:1::d23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Thu, 8 Oct
 2026 02:02:07 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0496.015; Thu, 8 Oct 2026
 02:02:06 +0000
Date: Wed, 7 Oct 2026 19:02:02 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
CC: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, <linux-kernel@vger.kernel.org>, Peng Fan
	<peng.fan@nxp.com>, <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH] dax: use assign_bit() where applicable
Message-ID: <asb5mkEpbCT9I8EF@aschofie-mobl2.lan>
References: <20260919130750.3041470-1-peng.fan@oss.nxp.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260919130750.3041470-1-peng.fan@oss.nxp.com>
X-ClientProxiedBy: BY5PR04CA0016.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::26) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH3PPF5ACB2DC0D:EE_
X-MS-Office365-Filtering-Correlation-Id: be4afd71-aff2-4c8f-dbb6-08df24e0272e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|18002099003|10067099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: NN3Z+ndp0UziCRkZOSIqVJBWS9+tnfmW4EmrmQPdUPmXtqL+bP8+ZlVm38sxJUf87G8G0lfDCOMIaf2/nk8/2cupbnP9bmBWvGlxRBuSoQuDeDOtvR34Kdghh90Gs/TqOWgnBtWnWL31Lcd5Br7f4gnad3/lgKNwSBBitWk8MRtkbS8ywkyW0tZJRrvqiOD+kUxlztRLQ9TjydFQoRAHTU+HDN5FRxOf+FXIlUwABFhj8ykn+R9BeJBG3cx2Vdnzih3U6pPK0Lj1r6JinWtZijrkLDRH0y6IKhBpbD9rstBVS3+y4Sk39N7tbxzTYyyrcJfxNNMlpWrvJ2PPnW3f3xkR4BVlbLwsXLNbkx2lNcSzSuG9jPupc4TG36wjCWlwlWxnrfi4YnDLDYXxMtTYnCtUhON0WrYg/qypT6j4WNRlhGrzUhvV6AcTGG+NsSHsN9JqKp0yC5xwG2zV2Dzft36xyIGRFXJEs9AiOheWwS3fk7eL+2v/AixBXocYJlLGsQsHVs2aneYTQVIP7Ybe5zaqyKfUxsDOPvx8kUBvk2nl1I01/cV57ilx6s2bKJphSA0MXa2X3zvjWvS3zyO3GmrIcwU1rQ6MUR6i6Vmi3h/fWC/mC9ffWectxX0oakMzjkJf0gO4kL+GV3C3thuHaGF17snWzzKSn5IjenhNKBI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(18002099003)(10067099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PIzevZ1uC5egXVzqqzxNXe78mx3omKNbhejFNlfxJ9PSdbyc7FUXWrw0dUR4?=
 =?us-ascii?Q?FkOTOsCKMI5nnoipHUkIYe6Z31Sn+NXxKmIHWJzGGg8FlEQd6UOeO7pDTIlE?=
 =?us-ascii?Q?q3hPAngKDlPbSp2KxS6us6aql8wae5GxuRPbPxcHisM96bE7d70UtMTfpD4D?=
 =?us-ascii?Q?XxU64KKx0I7SJQXla1I/UW2OUsAOsFst+FH9gj8zzzdYUynx7jDiOVB8/W0a?=
 =?us-ascii?Q?AuDKE0U15wCjRCLAc/5Gymy9z1RlkX3xieVHCjxGszKPrZUNwOl3kxatqf22?=
 =?us-ascii?Q?zpYda8RdmtTdT8EYdl3QhP7K+xMAqS9T5vtI0d8hgkE7b8WhXG6nZs7kSaWs?=
 =?us-ascii?Q?zOIACl3IMSp6e1EmoK37rcOTatE+7vRdBGAUCldwtKN8dP1r8SfNu1SimN4L?=
 =?us-ascii?Q?OvgFMn7BBjSkLzlt/RPk6SDAUO1QtJe9dM3QGUjN2PnRGTG5Y0y8DQ9V+bN9?=
 =?us-ascii?Q?mNldnK/D5nOfMSuCMLapOpenGuuADJ0718UQCBVVR5/+gQx+sCAvyqL7xSxL?=
 =?us-ascii?Q?SMsnM5IZ1KqqEhoqB1hICSzdnbD8agt4lesBXjHbXjM5KXgLmWkiRuB70Kon?=
 =?us-ascii?Q?01iTmyDy6rA1ByUPiKJIyIudNY0jFe9B9cs58w6QWP1bRCQeHaHgZ0jb+pyO?=
 =?us-ascii?Q?yzAWujZ3mGCaqcwTehTa/NpvAK5fvrGqYYNoLyUaxmnNeY/p1CPlHZ3dOkg5?=
 =?us-ascii?Q?2b6NckhbCvYdKO/H0unz8Wuu9K/rVlQGXBBgHRPnefr7qXxxOLOGhGJU7H4g?=
 =?us-ascii?Q?uiDIJK0wWx75FSpRkfS0/yiCunCIJ+nOrvCf5CoXYVo4HjPS+Xj4U1it8Gr+?=
 =?us-ascii?Q?Vaxpj4GxA0dt1E7mQvr5kGX/VB2vU/8bDFSJo74KX5bZ+Eq9ztJieDaSNXFh?=
 =?us-ascii?Q?wy3qrbGESDEwlxu2UvO3AXTTqFEKzR3/LYz1+Nc65G4xXzvyCKIWMeq6sm0i?=
 =?us-ascii?Q?G7x8rJ4aLzg8kMVmRd/nOaxeLSfQxGJd4y2tK9+mtjvzeND6OfwZuPVnaQkA?=
 =?us-ascii?Q?fMBz7bvsxCXvCafDdmsOcHFmpZYC7kYzjVF6DweRu2S1NOS7FRKFm/SeslVP?=
 =?us-ascii?Q?ibV039FC77/qjGUXDM+zR+yD+ITVGhxb6g3cC143Fnje0vogWKzSZFQwybsT?=
 =?us-ascii?Q?snwalqHPxymlGSM0FdZw1eKzjPbWADGAmrN+Jobe2xQNeuv7KGmGQENV3Cld?=
 =?us-ascii?Q?xfLorPebU0Woez+9hZ7kXc+DStT16mujk6xht4k7Xg+ZpaP/HHSRB+fVnlc3?=
 =?us-ascii?Q?HeAbjTyiALaZORH6cssV53w4ORs2mtYYGJDHntstl4AM5ycRY++2FzncKmDB?=
 =?us-ascii?Q?rswJnHB3ZumuZTiTTgYLqzdI7dphf1OiJHCEKfYFqloS00SexVEjmKxZF3ZS?=
 =?us-ascii?Q?bzQc6nwPnw7F/PxCJ6bwYKhWpKt2B0BjcFSJN5rThDzuDAe+WJAmuanESvuT?=
 =?us-ascii?Q?HUv1ZJxZykPgHBD6ZjtodZkfGwxERVlthEolxZiljOPEosK/nG94Hu9zf4Dc?=
 =?us-ascii?Q?IAzkYgJKpObWbXYe1aju5j9uPr+9h4bHM6kgpeNp2nHCKCLVZ206fUbTvSrR?=
 =?us-ascii?Q?F5rEVjryPHL0P5LfD3H0CpcEP4/np3sw6oE7ap1eltCXpgfgTEEz7zUiQOuw?=
 =?us-ascii?Q?Xbo8axqGBZrPqViWJAHoNPoLGAruf1ShewsUWTRuxQ+H/kQqB+EBNLgmoEPj?=
 =?us-ascii?Q?j14tQaUnnjDRtRtv1Slw0CWMCkQy8nIbGeEYINSPj7K1lwofiXD5zH2NbMqa?=
 =?us-ascii?Q?p/c8TD2ezdv3r10oTq3R4PTfCRYx8HA=3D?=
X-Exchange-RoutingPolicyChecked: Qih991qy/nJlbo5qPBtkEwuQLgSPe3mvqz3tqhlc++Akr1zXZYySNVF0cCsvOoYFOg7upW0uHq1/IpDuRDoSCUbWK3/H29YxSJk8vbgywNrr9IoTG2EFGTlUf+jH9pR4OlB3u7/lUz3LNQ4n2bshPhurzr3sxrvoCW2C6l7n9/sDWr38bv3yxWYTX4bxeHjfb7otd4CX75rYwlDDebwTI4JrjbQNx79xsEaHJlJU/+2AUiWgzMh/oRN7kWOEiBXboQ1pxi+4tW7JC/Jfxxlo624KkywrFFrzLnX4oyQS8ShxD7FFQDI1VuXqV0rNAuvT/15ZC5TBfV1Eoo8Y8zRTaw==
X-MS-Exchange-CrossTenant-Network-Message-Id: be4afd71-aff2-4c8f-dbb6-08df24e0272e
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 02:02:06.7977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q6UttuBofaWfrdiPNGm6mD5hi7vf2ryLqc1LvFvLLWpTw8mFmeMbvanHBFy+swbYdYShAF5SnD+N7qPrjI4uty0FKbU2pBcKAuahmEn+tcs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF5ACB2DC0D
X-OriginatorOrg: intel.com

On Sat, Sep 19, 2026 at 09:07:50PM +0800, Peng Fan (OSS) wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> Convert open-coded if/else with set_bit/clear_bit to the assign_bit API.


NAK

See also:
https://lore.kernel.org/lkml/asb3hGpSWVQk93cX@aschofie-mobl2.lan/

> 
> Signed-off-by: Peng Fan <peng.fan@nxp.com>
> ---
>  drivers/dax/super.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 45f84b0eb909..60c4aec52ae1 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -385,10 +385,7 @@ EXPORT_SYMBOL_GPL(dax_flush);
>  
>  void dax_write_cache(struct dax_device *dax_dev, bool wc)
>  {
> -	if (wc)
> -		set_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags);
> -	else
> -		clear_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags);
> +	assign_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags, wc);
>  }
>  EXPORT_SYMBOL_GPL(dax_write_cache);
>  
> -- 
> 2.51.0
> 
> 
