Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B94A55C00
	for <nvdimm@lists.linux.dev>; Thu, 11 Jan 2024 19:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GYH9XhQI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705001030; x=1736537030;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=hMIBPGgEW357NJe1nalk7NW/MYv0gqrs7WUaKzMf7Ik=;
  b=GYH9XhQIy/9JcmhEI4GPQ1GI5iHCA4x6C4KmsXwa1JtAsP08lxKc3lyr
   niNkGVwByyvFiwyQkBkIluSDFKNzLNlMN/QCCr19M3adsNDsVD3VjRla8
   1Xs3ooQK0/Ar3luaIPV4/vh5zHehPrb9NeXOspnG2L6lbuHP/pXbouKFz
   XpnSHuYWwhIzHKOcP7JxaEGw17YA0EmTJrhboAaGL28jhVFuMPrpRihg7
   P/iP1gcnryzGRJHi7uf/W8mH1YLv5MW0B5GwpNeiiZ48532AherOO9lsd
   4VJn7cq+853f71Jd6X6fE/NOtgjsixX34Ta6KOXynbtL3WU7Ok7BarAjA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="5690122"
X-IronPort-AV: E=Sophos;i="6.04,187,1695711600"; 
   d="scan'208";a="5690122"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 11:23:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="816828693"
X-IronPort-AV: E=Sophos;i="6.04,187,1695711600"; 
   d="scan'208";a="816828693"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Jan 2024 11:23:49 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Jan 2024 11:23:49 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Jan 2024 11:23:48 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 11 Jan 2024 11:23:48 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 11 Jan 2024 11:23:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GZSgZ855vuT9YGC7O+KXcnZ4UFc1B9rRZQtGWhJGlgfWpW2S62TPRAA/mg2EHPa3iWRoXRTVJJD8MDPuPGmeOSf9zTfF+cBt5jN7yJrd7G7DtaC8lyuq21NoySw6/eWhH4tq34ZSoS0hkEFz1VA0M4LbNG5j7d08QzLOd35D5nuqZnI0G6BUz082ERmVvZy3dmoASvL2MG1MCW+q2aW6fklRHcq6yb6tC/16GC6F9Pcj3QzEININfsEuaLOYDdj6rSyR4NuueRHkDg4p10l53ey5ty+sWB711sp7XYl//KOGmjtbwQ2sqsidU9YeERPd6JqOV0Dvrqgmt9tRa3Wv/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LYwOzhDad4dzDaOXhizkv2JvYxo0XibDE8mP/1C8jAE=;
 b=AXLqkjjCcXGDW+h0QomxZvu3j8/gqRaMFJen9TCT7LKfES4XnZmstarfxlw4ShgmSydByOE+u/jft7htjCbnUKZ2C2MigHxxHnCGqyX6Rv62ok4oCt/dTNzYZm54EsBtgYjpMOK0wpixR0Kj1t5lFI1ZdXAAyS45KAowk3aDNB5BXdjXmroP6ALl9hU7BfGwNZrNx72z4pUscqpEGjOq2EIr5WxHCkkWwu5oI+XpH6dxkPVAk1SFwh50WO7bPTAg/5ezLgHmjMQRy7r5r3Kn5AsdsqgXLazCb3cfsD91XQoNwRi+GpU+0a3UudwPYdcRfkqYLJgAjiToY1FwhcOpUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SN7PR11MB6827.namprd11.prod.outlook.com (2603:10b6:806:2a2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.23; Thu, 11 Jan
 2024 19:23:43 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6257:f90:c7dd:f0b2]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6257:f90:c7dd:f0b2%4]) with mapi id 15.20.7181.015; Thu, 11 Jan 2024
 19:23:43 +0000
Date: Thu, 11 Jan 2024 11:23:41 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
CC: Dan Williams <dan.j.williams@intel.com>, Joao Martins
	<joao.m.martins@oracle.com>, Vishal Verma <vishal.l.verma@intel.com>
Subject: RE: [PATCH ndctl] test/daxctl-create.sh: remove region and dax
 device assumptions
Message-ID: <65a0403d151f9_5cee2944d@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240110-vv-daxctl-create-v1-1-01f5d58afcd8@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240110-vv-daxctl-create-v1-1-01f5d58afcd8@intel.com>
X-ClientProxiedBy: MW4PR04CA0048.namprd04.prod.outlook.com
 (2603:10b6:303:6a::23) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SN7PR11MB6827:EE_
X-MS-Office365-Filtering-Correlation-Id: cfb8eab0-af62-4194-83ed-08dc12dad339
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: up0bfdwuLN2CrIi6qB0Po6f/XCUENDdE7eYJEuBhpnzBs6jX+XzadoOANkOVVYXp3hjYgZ0SXfwFG3XsW5I0OHVyQCl0Zkkm+h0/dga1Smqkq2qgCXU3JtX74BLLOuiOqJ2WXeuqCUL2hgrmoo0C1+pfOzw/I3hBVJMtEQjAAMMF97x67cBv5N/zjlX2tAgu82ui+6PPTlLumE38qnTL/mCThUmJrCCqOItdP8bYGv2YJFx4KVmbMLyBpStC/jS4NKTAdveeXQbETud3URkMuACNVNGFXt/OmdSfK4hUSQFML8K7eOikmoB+sSVP/LMioq4GDITzzoHS5ZvWDvZTbqolXWDlOtUopQctwN1xqeD5CQg7mHLy7NWBK/3ZyIsMAdTQwmM2ii5pFAOKJBG1Mb90GhgZKXDKjqtcG4Jk1hb9+o1io6u6+XoqiDvNiNtHXGMIkEQIBA8cxoiawGoyLsB7HoHTn0tTazbtaOjgUjLhTqSRSs/V79koYmgmauvuD1aqbFf79nPmw6JSeNFLiIzTLr0EQfk/KHb5xJ7Bl+/GCH4ZjTPlMedHQP1vlmSJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(346002)(396003)(376002)(136003)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(6506007)(478600001)(6512007)(9686003)(6486002)(26005)(38100700002)(82960400001)(316002)(5660300002)(107886003)(66946007)(83380400001)(41300700001)(2906002)(54906003)(86362001)(66556008)(4326008)(8936002)(8676002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GBlror/IT3qdO+xri8HAxgmFx2nJ+GcqEWf9utatrF/nH6lsDAgmINA/5qLX?=
 =?us-ascii?Q?XnH+hBbXKEY8I4UzFvgM7KbodZCqfbsXM+h3BP9z8hg6n5yopO5/GWJNBbqv?=
 =?us-ascii?Q?byMeF1IEq2c+bY+PxVtZqYFmB5uib2LzvP9gr9q8DHLKrilx06rS/kP93x2h?=
 =?us-ascii?Q?6AgHYl37/UQxepWb1SRefuKuc4SyzoaLpAk/hTsRjcDonk8/MgBhg1eYS5EY?=
 =?us-ascii?Q?2fuKiDyu6HikA2azVQy35b+4vgh1kvLqNF54jVnOzZWM/4w5BNtOMngkFHjh?=
 =?us-ascii?Q?KzvEK9hF7N5K/ckldQNWzF620f+iATZHrlFA+zaVVhMuYSZbCB0E74Nmttth?=
 =?us-ascii?Q?TljJ/wml4QaN4FlVJ2+9kPrqRXaYawVGlBUTLT6T5hy9b9EcI20vROzNP4FZ?=
 =?us-ascii?Q?CYNBLzVFh+v1Dz9zanfOZ5tc0QsESP/54DsGfM0Q9AjsnIp71gDwC+Oi9ixt?=
 =?us-ascii?Q?KImVAp6tkddlcdCwiCQ2yb4qikfT4ELAjCae25ZEdsLirZLkoyvQccoYwl+T?=
 =?us-ascii?Q?xLtpH0gKIFdSn+363+FeTMbuOiQSekObH7Gs3d0LgNhQ5keaiBgJvL6CZ8SF?=
 =?us-ascii?Q?QqAgC29f6v7gU8RrshG46dHMwhdt+IhhcJo7KtQzZRD8gHxO6X+Z6XOzgrEJ?=
 =?us-ascii?Q?ZeDhFCTCZbkckzf5fXLVLD4LTZstVOHueYnH23WneY7a16JzWzYs5rPuJkeC?=
 =?us-ascii?Q?VF+7wIGWsClUl+UEDk/mMirki9tIZNwQ5dFYtkFZrSZcuEbioo5WgcftX2sS?=
 =?us-ascii?Q?OrLEJqA7tImiRpASOOBVZGELBbQh9org6DImr6cekiQ4gTKfYmhr91UeXN5O?=
 =?us-ascii?Q?6vCV4Tc692XGwW/gciokiX061emqvELY5OfVb2pn/czOdjflA7db5hXc1tjt?=
 =?us-ascii?Q?z2uSptRQoNzONpSMV115f8U8AjB5pYCWKENftTXiU5++oQda9UncsvuSPZm6?=
 =?us-ascii?Q?BeGoFuwpiZwTzxOjRf459J9/6BXbQI8TcbxLbuMXRHMa4tPvD0gNtXZq0bk3?=
 =?us-ascii?Q?nk5ixuQ0Ogdjjl9uKQSfr93ctgouafOW6jHgSsij6OLIoEFLcA2Naz/Em1LC?=
 =?us-ascii?Q?GLMISIbn/PwF4vbiXGUMLsauuq5+75srDUI8IlM2jCTkcFKJHLmuVXt/0t8X?=
 =?us-ascii?Q?3kqBP5MXRmxoeXVucSxxkiA9sYd2AUkPEz8/VRzAtrNcGyFmCbmfsv08Prme?=
 =?us-ascii?Q?4ECDNao5xxYZ+xeAnvDJiEtwxGRCFecq38CU9brChXymlFKWVZHbXf4A4CkC?=
 =?us-ascii?Q?qwTLOo3wSFiD05KdiEVs8FRWIuf4LPqa15U0qHc/lR42MHhhQHeXeEfgMKce?=
 =?us-ascii?Q?KIRfOQA0Prmal5bIjVT0FAcI2IAbS15mvPwkAp3ghg+nCpNo5L9SCwBX2Qog?=
 =?us-ascii?Q?n3prfhUbrqHSr4F+ezus0gItjpgaYVjBXqn7Hpy9/GlTUFIfyPs/3Nft3Ei+?=
 =?us-ascii?Q?gVbm9+m6faMAC2XWwmX0Wc8FWV20xmrhhITkCiIEjVRtwMxgzy7Kh1cNENbc?=
 =?us-ascii?Q?eUb5xH+iE9TVRkamJfaqWLci1UL0JlR/ZMaQf+EvcF0GYvKLaCwH4Tm+aGfK?=
 =?us-ascii?Q?0+b7RvYoqzATM3YDIK8mRRgu9xS4G4NP5j0keCBnIyoZbPj3/nWiQWaHItv2?=
 =?us-ascii?Q?pw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cfb8eab0-af62-4194-83ed-08dc12dad339
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2024 19:23:43.7548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w2SgiZRRb7oGboRLwJE7sk2cwrdOOLSjfonxH7SjCHKLcD3omEboM9c16Syq0iu4jnZPM4/12f8dclPak0I9FDBP+yXryigG12wxZ+dPN1s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6827
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> The daxctl-create.sh test had some hard-coded assumptions about what dax
> device it expects to find, and what region number it will be under. This
> usually worked when the unit test environment only had efi_fake_mem
> devices as the sources of hmem memory. With CXL however, the region
> numbering namespace is shared with CXL regions, often pushing the
> efi_fake_mem region to something other than 'region0'.
> 
> Remove any region and device number assumptions from this test so it
> works regardless of how regions get enumerated.
> 
> Cc: Joao Martins <joao.m.martins@oracle.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  test/daxctl-create.sh | 62 +++++++++++++++++++++++++++++----------------------
>  1 file changed, 35 insertions(+), 27 deletions(-)
> 
> diff --git a/test/daxctl-create.sh b/test/daxctl-create.sh
> index d319a39..a5df6f2 100755
> --- a/test/daxctl-create.sh
> +++ b/test/daxctl-create.sh
> @@ -29,14 +29,20 @@ find_testdev()
>  	fi
>  
>  	# find a victim region provided by dax_hmem
> -	testpath=$("$DAXCTL" list -r 0 | jq -er '.[0].path | .//""')
> +	region_json="$("$DAXCTL" list -R)"
> +	testpath=$(jq -er '.[0].path | .//""' <<< "$region_json")

This fixes the case where the first dax-region may not be region-id 0,
but would it also fail if the first region is not the "hmem" region?

I wonder if the above and the next line can be fixed with a jq select()
like?

    select(.path | contains("hmem"))

>  	if [[ ! "$testpath" == *"hmem"* ]]; then
>  		printf "Unable to find a victim region\n"
>  		exit "$rc"
>  	fi
> +	region_id=$(jq -er '.[0].id | .//""' <<< "$region_json")
> +	if [[ ! "$region_id" ]]; then
> +		printf "Unable to determine victim region id\n"
> +		exit "$rc"
> +	fi
>  
>  	# find a victim device
> -	testdev=$("$DAXCTL" list -D -r 0 | jq -er '.[0].chardev | .//""')
> +	testdev=$("$DAXCTL" list -D -r "$region_id" | jq -er '.[0].chardev | .//""')
>  	if [[ ! $testdev  ]]; then
>  		printf "Unable to find a victim device\n"
>  		exit "$rc"
> @@ -56,9 +62,10 @@ setup_dev()
>  		exit "$rc"
>  	fi
>  
> +	"$DAXCTL" reconfigure-device -m devdax -f "$testdev"
>  	"$DAXCTL" disable-device "$testdev"
>  	"$DAXCTL" reconfigure-device -s 0 "$testdev"
> -	available=$("$DAXCTL" list -r 0 | jq -er '.[0].available_size | .//""')
> +	available=$("$DAXCTL" list -r "$region_id" | jq -er '.[0].available_size | .//""')

These and the rest of the changes look good.

[..]
