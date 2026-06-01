Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35349224B15
	for <nvdimm@lists.linux.dev>; Mon,  1 Jun 2026 23:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780355009; cv=fail; b=ZL5eIOR4NzyR+iqcFNkqQVVPh6HlyAwIkQwp444t5Ur4C+A3z56UZRnIA26ktjmDzoL34V8BXPlYMDOuEQuI3aHUjzPRQXyVxN7x/LpfYJn1GTibfPxMydhddCziEZwV12bvAIEI/rkQLUIz6dh/O/PfUMN7TFtpzUp/HJdfh+M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780355009; c=relaxed/simple;
	bh=C01KrnVxr6crltjyoTW7EVQ+mm3FAYGIgFfbTJbUHaY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qsxxWB0OjOEs+sNntxp//vNTD4vSXDAZPnQ15DK1cKvnUd0krwT2xKfgfHQFR7im4IofYgWyZgigV+g4ZyLbiDxu9tt80bnTF2nrxr0faX1asMxg7rfFPQMNxifSuKZU7UuLDuxezSQ9zPn61i7YyM2efXxg9C5ZaBp4P3NadtU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RK0Be6yq; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RK0Be6yq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780355008; x=1811891008;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=C01KrnVxr6crltjyoTW7EVQ+mm3FAYGIgFfbTJbUHaY=;
  b=RK0Be6yqApno7pvPq4VlK3ND2sqsTvbeKjc05JscaJ/cym1Mmh66lpfh
   qacwobLYstRkJAodVLkVq/WR4+GmcGMZdg5buS3VQszAgDYW+YSkoCLjb
   wurO73dOtVIe7B7OS7YMUKq8ntCuO0P9i5629+i3ZZ+LFLpZNY3OgZdQd
   yLh+eOb4gZ6P76Qv8szMzqx6UKPRt7s3+KlINrETUwVnJ9cD/+s5PmUaG
   WjxwoOqeJm62L8OCNxICYlxKs+tRf5p+A1bUKw59P+ipsF0Q/89d7jk7c
   NLe1wYF+6WLivV09aSS0vxXksQOIl6iB37LYFQLid4sj0rdn1VaUL51JK
   w==;
X-CSE-ConnectionGUID: xd5ODqlOSea8Z6jiUipvuA==
X-CSE-MsgGUID: 1TrTSDWJQV29PEaL1jR1lQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="92236862"
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="92236862"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 16:03:27 -0700
X-CSE-ConnectionGUID: ceeMnnbuRHC5azCIc0WNhA==
X-CSE-MsgGUID: F7POihJwSwyP0dcvDGq20w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="243816194"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 16:03:27 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 1 Jun 2026 16:03:26 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 1 Jun 2026 16:03:26 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.18) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 1 Jun 2026 16:03:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m5bphPuNSZ/sDBZp3VVxPFOOPYejdo5Ns819SmhbOcw5Bi6bAHpkTVH01yvcHjCJfz7oVjZTqvtAxOCiQOIdWSVGuV0ZIfb4GmCqUF+LxTI/X+doCRkToqRlNWv0p/mrdMe9w3EkGaj9nZo8yGVlGN2ImsBTiLVs/YTQRTbEtvBUWNLDthM7/yu1hN6s5EiX8dfOFQJ1MV2H5wpdDb9ezgez5Q5GeAVuwX7hZof5lYjfNIAKEPSwMlGWHAskOuRd4pECFcTV/t80fKVnJacQiOxjqV4uFlwWUYlgQNOxxOsiXxMS7I2YOApquMSD1AzCqyNB8NvM+Ogn/Bixsr6/Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ewh/vJ1s8A0Uma7a/hSiTiU/cP8tffqkbvOAxsfp+w=;
 b=Mgihj2dABchAcFYX0LjMUTAjUJC9dNtlYnFaamAJZCmvP5WTUy3GNCv8ZdTpEYyreJV43CVxYRTNKm6qYhVUDLJO62g/+ihn09noj+EjJIoGB2FE5ueJyW2DmflJnoCS+C+YiV5bKKDQmWxgWeCNMa2AwXdMP+aSVpu/M/1vvoY/wEDrRbuqzc1KIF2mVefhbb8MQAke5vWWidkp+gnwrzdbvvUyOqA6wUX3COwMv/O0nH9AewYLm7BQSDQ7wX3322iYLhEvEckivkh7mWRtAAEffl6tT9VcCq/IFBjzTmstLczKW3JKXz0s5y/w+GQVvVbXB0LjNgtK2ehCSqwYog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by LV3PR11MB8553.namprd11.prod.outlook.com (2603:10b6:408:1b8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Mon, 1 Jun 2026
 23:03:22 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0071.010; Mon, 1 Jun 2026
 23:03:22 +0000
Date: Mon, 1 Jun 2026 16:03:19 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Abdun Nihaal <nihaal@cse.iitm.ac.in>
CC: Vishal Verma <vishal.l.verma@intel.com>, Dan Williams <djbw@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 0/2] nvdimm/btt: fix a few memory leaks
Message-ID: <ah4PtzCjX6mcElt7@aschofie-mobl2.lan>
References: <20260519-nvdimmleaks-v1-0-592300fb7a43@cse.iitm.ac.in>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260519-nvdimmleaks-v1-0-592300fb7a43@cse.iitm.ac.in>
X-ClientProxiedBy: BYAPR21CA0028.namprd21.prod.outlook.com
 (2603:10b6:a03:114::38) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|LV3PR11MB8553:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ee4a796-8922-483f-4f4d-08dec031fabe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|6133799003|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: XyJPNQrZb2EcaEOcRJ/iC9kzMLeE80hY2F3eER8Olmvw3MX8waDpEHDCHn4kRhOa0wBUH9cYHnbWbAEqnPhp5+HuoFbw+oLtFD2M3/bV5rdTFkEj0j3NdzcDU/vJjN7m51bvkRSMaDK1hQvhZ18cFyovMyLijyGC5h/Sn3u4bzwQOgU7MAn7SxxoFnldsMXW+s3WOPVckJe+WLGUzL2m9R4YFxz7eSwZ51lsEshUpOxL61sE2hpACUe9U5dwo458DzTkM+E9K+JyXQANsD7KCnXy/yRoUooUFhUEhrVwJaKIeOIuCU5QIyr0NeLylvn89CHiQZ6Kc5vJKG+uLFJjNc1PXeec46KrXcb6gGb2hwoxfx0hpAlQSahMhYc4Nx3rGE4WfuCPkeVTyrxZbxPqrf0lZjLtSj7VuTUExhoimLROpUcrOdOT9EtXSJZ+NwCGGkcl82mruVsnUcTTV+0T1dHrIXKZT5/hMuJQ+i53naAvoWfUhBpuHiy2x2bFWP87kgwGdxJXfCv28oFNiB1UMbnP3LKGZ+cdroDfLl0hTFrZycJMY0U9cVtdVHu+T288hsHXkx9l4F03ioSU5DNVxcWCDGgiCe2WR73XyZ+gOTQrYtpA1kgsjENJAMstDcxw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(6133799003)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nayegp1MfbF6AL+pm/KBR886Tj6kYJ5xoao7+L1h/+oHXxZ1gZnkwDtoOEJf?=
 =?us-ascii?Q?xJ5/7yb8SdNvzdLB6um957NBCE4n4ySR7tbaelw0hYC7P18j4cbvD1aEpcYb?=
 =?us-ascii?Q?E9sr2olM2DyhhJyONfz6qkWDAsNkajDtOl8LtnoqddhDRwaXQMJY46sJXt5u?=
 =?us-ascii?Q?5TXoekVhlCaC8t05344QlLFaNHQmv5apDQaPPrfICpKNXIaCTecv9SB93TuE?=
 =?us-ascii?Q?AdM34Gw57h7MKqJ9Az5MxgN+PPsc+LjItcOGHMokZckFhuaE5gCr6Q+MNpVp?=
 =?us-ascii?Q?jgFE65xQu+zFg1aMHEe5nEciFcnm5H0zb3pTodK8Djd8KwN8ATmn7oQksTHD?=
 =?us-ascii?Q?LCLkuGxwCiL+hEsU+8xoDkWIhC/Rg10eMLY/ywTGVk/ctU7MZjyByy3oKl3F?=
 =?us-ascii?Q?c+sxagd8SI/ooCvS3DpehodslW2VEWBF8LDdtWLP+FxnkrbGh25jRmGMGWG7?=
 =?us-ascii?Q?HHB18FG5Lsregr3ISFZF0tRSJhrMWHB5FutzH8kj9SEKdPTKm7NfmVO7juvD?=
 =?us-ascii?Q?WHP18HUQvZ/9hHacNlDLjGxKFpxDrLdEb9981ELRghWHlTs9D7cYmB0if77f?=
 =?us-ascii?Q?cscHIJ8XeFptDnlqe9xOQkGw6bCHO3IrN8fCaCk3pFoCKdjDto0O68JyKGQ0?=
 =?us-ascii?Q?KY0tqe7Bvd8H/nceSdQ+RNJYRlLxwLan0JNBZUYgtM5YjPdpW7aCat13FWJ6?=
 =?us-ascii?Q?TMOY411LsxD/kX9qSTuHVVIIe6nA3jiZ05KHR03v/GYu0odOsJLBJcJf5au9?=
 =?us-ascii?Q?6MdnJlAQU/LvunB7wIRT/e8Z/CbBMAFRw1VXSHIChjDMgo/DvGPjMfEzc4VN?=
 =?us-ascii?Q?dAH8MLFGuZ0buG2gLjgj706KhkcoUXO+bcUv7G6ON1k8tvpkv0xQWq47yJjl?=
 =?us-ascii?Q?yVhB5vvMpAd/BdZ7zqbZnjhXefqQrR3zeUFhROVA9qteE3JdPjvL1ExH5wv8?=
 =?us-ascii?Q?kgmfNU33AC0Huw5RP/dUCNhu5KNbrwuah1sTtqqw3PkJgxD7u6/+J3vr6KY2?=
 =?us-ascii?Q?uuvHdQeJfcSPLQKq1KJptNaYDP5vx09MCzNXqa1iHtiOCBtRBELWl14OrjRC?=
 =?us-ascii?Q?wl6UdZXQ9FAR002BObXznUmp/wRUS+FKMjbM9GiObRrM5mX6RpubnekXZ7Uf?=
 =?us-ascii?Q?C2+Ei0hpRsffpVWrqVkU1690XAvme1MsvrF2Q2XCYmSvHuWtEySD9jFTWGEk?=
 =?us-ascii?Q?2Q+N45GtUoMHZhANPckegTOeH2j0gLlnYVIZBbRVOMBqTBTAPG4aTE151uES?=
 =?us-ascii?Q?OFq6lGtCOQ0gL+/NPg9s5dYZI744jntYOXcnNkj+0N+70onL8avqjQ4HFTzz?=
 =?us-ascii?Q?gkEiUSWaRE4YjNxDkqODsLoJKKLOoZiDKEUlpVUGZwRrCr8mmx+KPiXPVIsA?=
 =?us-ascii?Q?N521VyTJrNiUG1QS1GuXHqYIr3eoYhIw7fUBGdfag7awrmNBR77DouSuy2S7?=
 =?us-ascii?Q?+GXjYTS0eRE32eEv3uuSbVLSDMBzr5lD0F+P+B7opOBPwkNvFcg15kUJcAGT?=
 =?us-ascii?Q?F1Z64rwTienfd/LGDi6Dtw7Z27hd5GqxE2aF2Qey9SAKSDtkqxLCnLbh/Gs+?=
 =?us-ascii?Q?mB2p2L7Yu7HRzr+w/wzDrSV0VifIKyIsCD+WXRYwdEwdim/wSk/UhJKisRlw?=
 =?us-ascii?Q?wL6zJg2QlX8vhRP4QnqKMYOEED84u9TCd3DejNilRECkoU736whOsOSermaV?=
 =?us-ascii?Q?k5jzaoL5NNOk+SLFFDtBm1kLNHUoXKqfDp9aA31eqLOer5+iBb9eswLpnYjJ?=
 =?us-ascii?Q?GRT6VW3gegfRHtEStyK+AjkGmJoZn9c=3D?=
X-Exchange-RoutingPolicyChecked: OKrL/5n+cJ2MIza9U6HAQJowyucFSRoMAjpIx3dfoWAz8PrfVX+HGedT34TTHO7BKl174gkJ6kstsY0NPDg6bpK3o9dJxXr1WEipifIXQ1Co4v1Gqw3Tg0kupnnkuy7SEHNTVu+75+jc7w4ShEjKmFVMHjdXiC+Ox/MnBGXOYt3/91uOU+yaHdbCjC8kQOiYzJFVQGl+AlzR2bxrN90swbNsH70IJgtWpqoksXCLXn0eRWTyHI4eTuwOgGghi+y65dPvctbGN9lDm47LPxHaMO7LhfXjC7Q9170/GLOooeQhJREaP37JhKxc1Lsu0VejOgeJrRHuHcx6Zd2sk7+C2A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ee4a796-8922-483f-4f4d-08dec031fabe
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 23:03:22.7526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ea//f/ehWWMekOdIbl5lnxSnB1rYVdfsOGGQPBhleRJ4H07XeuFoEM8x/N3ZNwGR2YHTKNt7SEBPXHaytnUoJOKWgn5iH1fa2Gwsk9FUIbw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8553
X-OriginatorOrg: intel.com

On Tue, May 19, 2026 at 11:20:11AM +0530, Abdun Nihaal wrote:
> The following two patches fix memory leak issues in error paths in the
> btt_init() and discover_arenas() functions.
> 
> - nvdimm/btt: fix potential memory leak in btt_init()
> - nvdimm/btt: fix potential memory leak in discover_arenas()
> 
> Compile tested only. Issue found using static analysis.
> 
> Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>


Hi Abdun,

Thanks for the patches!

I'm giving this my Reviewed-by Tag and will apply with some fixups
to the commit messages and the commit log of patch 2.

Sashiko noted 3 potential issues which I've worked thru to my
satisfaction (no changes needed) For future reference, I'd expect
you to come back around and offer comment on such complaints.

https://sashiko.dev/#/patchset/20260519-nvdimmleaks-v1-0-592300fb7a43%40cse.iitm.ac.in

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

