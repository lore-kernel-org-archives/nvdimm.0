Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E3D381719;
	Mon,  2 Feb 2026 17:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770052506; cv=fail; b=FRAEwGoEb4AK2vV3YlIIE4/es0MjJX6ntLfZllUOwn6Cv2I2jhBSBQN5Do5eJSu9jtu01e7DyRkz6SnjcjVOjTva1eNMiEMVRklOmuA02XnvlTFH1BleMJDyYqnc6t8E7RU0bIh9pLFScqHgTmCsXfFqqxJZmk3CgxWC08WEvbQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770052506; c=relaxed/simple;
	bh=RbO2icqdlWIYx/hQLWbskQbH3XIlPCEYxVUOLR+J2uI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bNxuXMZ7Yy/vtCnT/UJIuK3wqU7vxNR6n2BjB9/1CzWgROjVYVunzUS2VcoONnZT0q0AmuoUblJ62mfY9zx4+ZF0BAHFGGHqsNyWBATzWd3W/4Pufhti1zN07cjP7ngalxaVKTTl/Ms6n0qbBmDj/1pBj9b52JwJ4CmvbqKnRdE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JTK9l1rH; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JTK9l1rH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770052505; x=1801588505;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RbO2icqdlWIYx/hQLWbskQbH3XIlPCEYxVUOLR+J2uI=;
  b=JTK9l1rHvVOa10TmkLIkMg2BMrq4jYyDyGHxB8IT8Fu7v/ef+ztWZj2K
   vs5AOszt50edoobQY89cUSl49dz/pJhEtu4FZBOH98NKMiwLWLsmSBzzV
   VllPVpJy6oYE9u8TAGBT6MkcEuAYbZTDZQJWEWDrVgdN0unuVw1NURvbd
   hPl7EcDKcTpApFM9IcLrSESuhtyRvEyGN/lG7qDIz90k/FIFv0OPaLhNC
   dULCZxc8VRpvVMCcJJX/UsPTyKyl7bz0RaSyy0ldLo1unqJ9HXRpavTTS
   Oq2FakPvBYw3IZZBdmMRtniakpAb4H7czh7ANDWxZhn2+QtOAUFczC6l7
   A==;
X-CSE-ConnectionGUID: +bXNqG93Tm+VoVXQ6k8ILA==
X-CSE-MsgGUID: be29urvSRoWRlj9RyCbmug==
X-IronPort-AV: E=McAfee;i="6800,10657,11690"; a="82641842"
X-IronPort-AV: E=Sophos;i="6.21,269,1763452800"; 
   d="scan'208";a="82641842"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 09:15:03 -0800
X-CSE-ConnectionGUID: I/rRfu/cSBWkFDr71QW8gg==
X-CSE-MsgGUID: eTMwiKY6R5Gj9gZChvZfDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,269,1763452800"; 
   d="scan'208";a="208683125"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 09:15:02 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 2 Feb 2026 09:15:01 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 2 Feb 2026 09:15:01 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.66)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 2 Feb 2026 09:15:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XUBACleRVEL3EhgcUgRLFcYr4UtWH2ji8hUoIblLpbeyvgLzJBnxnShKHL7QTP3m8RQcDkkRBSDtAWrRBaeGT6SkmnhDGk9QndNVtPp+rTX+/bN+1eFrnmERfLyqTqIZHbIiwMWMZuxoOxuygDx6q0X9gKobShClXHOLqyhISKR8B9hZpHVLuyUT4PaxEJtdlE0S7lgCmCkyK+9xYegdBIuqt05rbwf95A3pQDTeftaV4mQ9OTzxtR6WybyIGn5TuhnFhJmpQJyPmilZNOPQ+K1tz+iYCNU6bltb5DYebeuRJP38kmquQwlg472M8V43fA+fSCmAk4Iz3QCoqpDYOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gg+chW3AdM8SQykUBK7hhnO1ubSVG9KVpndhrbkLSPQ=;
 b=d98gCNRxR2HUEjp4ZQ7zdZtZi6dJSun9Wnr/c7191Y7Zm0dJzEl7kQyhZJKHd2Q6kku46dc+KRsOTsY5vuWyxbeQ5XojtFniBLqpGpkelZVuStx3gY3JnUHmTrCjF6ruSxrIAgCWkyHTpaIyABI/K4qN4hVmako+2O7uD5s852AGjGmnXxHL0WzvUCTTrlf1wIAdafcmO/Lss3fFoX3DTv1OrmyDwskfJ6UqTJmGmzhO7v8SV0zNqu/4AfXGi54P2cuX7ZPUJUa5/hOCEX2LeLNq/Nin49HxNlUfi43vJ+oYmeyzUoIlI70X2isS0dfE1p3uFWZHe5xQ3sc8nBArDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by SJ0PR11MB8296.namprd11.prod.outlook.com
 (2603:10b6:a03:47a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Mon, 2 Feb
 2026 17:14:55 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::1340:c8fe:cf51:9aa2]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::1340:c8fe:cf51:9aa2%2]) with mapi id 15.20.9564.016; Mon, 2 Feb 2026
 17:14:55 +0000
Date: Mon, 2 Feb 2026 11:18:13 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Ira Weiny <ira.weiny@intel.com>
CC: Li Chen <me@linux.beauty>, Dan Williams <dan.j.williams@intel.com>,
	"Vishal Verma" <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	"Pankaj Gupta" <pankaj.gupta.linux@gmail.com>, Cornelia Huck
	<cohuck@redhat.com>, Jakub Staron <jstaron@google.com>,
	<nvdimm@lists.linux.dev>, <virtualization@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nvdimm: virtio_pmem: serialize flush requests
Message-ID: <6980dc5569d5a_3430210092@iweiny-mobl.notmuch>
References: <20260113034552.62805-1-me@linux.beauty>
 <697d19fc772ad_f6311008@iweiny-mobl.notmuch>
 <20260131124628-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260131124628-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: BY5PR13CA0013.namprd13.prod.outlook.com
 (2603:10b6:a03:180::26) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|SJ0PR11MB8296:EE_
X-MS-Office365-Filtering-Correlation-Id: 73bbba4e-c0dd-4dba-d24c-08de627e958b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?/Fo2cdeS9WnFU2pS2732r59Fin8KBDq/JL3/OGv5Yc/4w8s8p4Clh3N1NF4y?=
 =?us-ascii?Q?TJ1XaK/+YRZDkc1LFTzqHpuJFOjApij43SfWUIiDDLPB5b4nuvLjmLzacgra?=
 =?us-ascii?Q?DDK1tyL7lWxhb4gSHZBIOcrCIjZQp2yTpgD4leNXHwGq6j9tWA530iMuit/g?=
 =?us-ascii?Q?LwefNRYD8M59XSkJKJIhtL+OTBCQeS+zHypNFKqSEGB7WgB1E3fVj7ve+rT+?=
 =?us-ascii?Q?JgfoC3tIgKi/dWnlElKE5cHlKbY/t+F3pdjoevggXIK0IGXvh9hplbyeNrv6?=
 =?us-ascii?Q?JBVznJpFSdWDmdbZry29WNsKozSxEHpZp2qNja8FpbMzWULoW4F/UBuH0n22?=
 =?us-ascii?Q?rl1p79oSQZeWkq3fv3+j4vOw+pO78fCkceaaEVCXj2vsb31sE648n5d71SbZ?=
 =?us-ascii?Q?tJjeCQrXU67tLyCBWE9+WaKJP5Bo9YAFk0Jy0fCKUt+5vsDhKC0GjBTae/fV?=
 =?us-ascii?Q?h9sDV6zZwmjyOOFwgo7z++qRhHR7PDDRn2OtwGlMQRT06eJYsw7mXeLg1hd0?=
 =?us-ascii?Q?Qzaal75OhVyKXWnH2EEshVNVSSCcFJ/2KOuUZKHIi1Ppu5Y0H0RiFFiGppAe?=
 =?us-ascii?Q?Mm715AVZ2X9oM2pLxGrMVhw7z4i0qmKjlXpXZ6zD72Pgs+34VtcMFbVV8Y8w?=
 =?us-ascii?Q?5uWvOePWp8CE+OvV1WNKnXbO0eqnQQJ0I3MPR5F/cjAq1U6ZtRcCdbhQw2Db?=
 =?us-ascii?Q?bDmq08rwaXL7eEZuKckMM94ujLaXMkTG0BsNs1VV/I2qywoTcaJYbL9TyJUi?=
 =?us-ascii?Q?/70F4ksDmUjrzgkKkMIOYCl5gvuSEwM7P+YfS3r3bt6EiXTBd6a/rZ4QWPuP?=
 =?us-ascii?Q?ADt1IAKMs7kRr0JGsU8/m4s8LSXExYpkKQur5k8mtWNhkYCRJeQ1LdExjGTP?=
 =?us-ascii?Q?JGNjsx71Tye6C7UtPfnWDN6ixQlsc7RVyRxRQWpxD/74JOatPGieJ6y5kjbw?=
 =?us-ascii?Q?jUyPaiw7S+6NurVv71/HO9T+c8PAmz5S2aJJpRL1ooUfkRBAvyF4q34dDOpu?=
 =?us-ascii?Q?Kn3WjjbVI01HTzOvi9K28beqMEBQwIYd/Ygo8oBkskrivbJUbOG0H6rxE98u?=
 =?us-ascii?Q?8T3i9vN9KHI1IAi//7uX3IeB0X2y7TefsQOjPJGqRhSTFcBbQ/QxgnbVjIjv?=
 =?us-ascii?Q?aMmC5LhiPV+I0DbfkqZkfpKa5wAGkHuyJPt9FmWC3tbuoiYU/mTau1IuRkSy?=
 =?us-ascii?Q?5TgrkW9VgFST8kqrz2JlYyFrOk8tsijTsa0cYGy9x6QYth8TqcCn9EYHY6lN?=
 =?us-ascii?Q?pe4XNtxwY+ac3vo0zbP0EoTQFbuA8zdM3AdJ7yOgjCk0SGwmWGYK3EkNN+L0?=
 =?us-ascii?Q?ifwF1KhTN85Pyl6aqvi28ZYel4F+VEouXbD77gLJbyRbQnl1bDmuQqDxHzZl?=
 =?us-ascii?Q?AXcSAT9UXshdy4HK+XOcBNGVlFUTWFxvci9jsocvasgNpraW2UzKdpUBFGgL?=
 =?us-ascii?Q?k1GsRIUTe2wHcJ4b0kqPQPK30f+YkWpbxRqTxG49FiHafVpsQH7/Dy13EFu9?=
 =?us-ascii?Q?lF830hThNiUQWRuIu+GOIaT0RG3HErJbu5LSHXeFjfxBjabfGqe6ShqGhoHx?=
 =?us-ascii?Q?ycrOdhhAikms4HbiUBs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CeffLSIUNUY7RP8TaYB2raUb8DXtdx9dW6BYU3dkrpZJj8XXQc4OBLMm9tdj?=
 =?us-ascii?Q?XsLnk7Xto43BEC5U2NMf5k1m5tHaIH6Rp8YCyHDuAKkRnEkQFC/sTQ/GWqE3?=
 =?us-ascii?Q?WBusBAjcojvX3oolIZXmNNAJY5XV2Z9YuemubqdwkZ+vCnt2/xwvlOTNyop2?=
 =?us-ascii?Q?N6+slIUY6MN9vY2pdqUVK/Ccr3UL18z5AfsCLBtSd5NGeXWAUe8eqPnb/vE6?=
 =?us-ascii?Q?iM7e1C0LQLo5z5/EXyD65sDsTFco7THRA7gWxUMC3tM7aGjro2qB2DpoVniK?=
 =?us-ascii?Q?irVaUvYvFP0C8G5re912dwaNVrqP1e3FndNNCLGdReiaYUGemJ1UsQJBS5S6?=
 =?us-ascii?Q?kruioQ4fkc1bUhavzeindbaS/ja1tx1c7aA/ZnFFRJ9eGiaFYAGUMHQ/pSzP?=
 =?us-ascii?Q?o9d3J5SwAkqvrU3NSORSnd4r8lBT0cqP1CE4CM8FIh8PLcgAZezC8yEV6UwJ?=
 =?us-ascii?Q?PPeYrI3Cc0liEZ8nxKD1lEP8IGNyA3JzS78HCSm7IjZjQ7oErnXNQV/yBMOH?=
 =?us-ascii?Q?+1cvaTsPRUkSf0TSsCkfDiZVzS5GeHsmDFWT+9xktQdYSrJWUeLcGkXCnOpA?=
 =?us-ascii?Q?iXjsx+jXyR5xb/RGhNHL0orovjETwxKhsZ0AOy3vMEdZ78Qu3Tie+daYbENl?=
 =?us-ascii?Q?Xq4gRA11DTaWmqpjyzueZ52emhJCFGUwCe/+wXlTnrNMlcxJu9tifFTWNU1Y?=
 =?us-ascii?Q?BvXC/qS14GfmXyVV6Az3EZ64Hgdl88aF4weG3RdsK8px/qR097SipJbkHf/K?=
 =?us-ascii?Q?IyQszHkvE9lL8FP3tNhozCHQrL7vM96l637wEFROzSsDB+tpMI0SO9V8Ub+f?=
 =?us-ascii?Q?+ELtSllsZVBoTnhz675pF4EwCVdr3VbCQL9hbeAEd4P/nB1tTyRGYyni6oYp?=
 =?us-ascii?Q?kj0gm6BZugE8ffCpcSJcRCd1LgnEsavJuNTSnBO+x7+728gc45m7rjRNIElS?=
 =?us-ascii?Q?YJcgK4Ec4pv11Vq41/QHu1ngvWL0am+S1Ro2msgLGjdjXWl/AS3mROgOeKc7?=
 =?us-ascii?Q?Dk5TmUysKNkyZYUfJmAhBYcCgx6MB46KiO0/t5uYIHwqQv1riHTuWsi6BPR7?=
 =?us-ascii?Q?IcVZOZtiisG6+zhBOGoTwSok9jM1vg0HvsYFl87Y2mFXtorx0GrfFu7YWOt0?=
 =?us-ascii?Q?JIhGsaIVdbpZwbjklXzksFltTHSNjRdEoizgGqTncZHy0TdJBAN4PXJ5xEON?=
 =?us-ascii?Q?+ICFYlCUYfAOOz5+gMx+nCrW72eff8otHttT4F2xjKeLAqv2v8AbOlL+Y+O+?=
 =?us-ascii?Q?eSw07TUPIfIkyVS4fB7ZC5P2d05HD7ywvSEn4aQNZruNSuoJUQFxpdbbv6mS?=
 =?us-ascii?Q?K2hcPxUp9xhP2pjQ6GFJgkE4Z2tQ7zRxtDIzIeJ1CJgswlI5QucwFkHaQeth?=
 =?us-ascii?Q?9+Ti4oK7uHgMPeZv5ibp5AN7WB+wjcdBMVfQ7jZchpfJiz+Zwtuf8Bi4Mr+r?=
 =?us-ascii?Q?eXae+jOQ3EhHuAlfzSRQZoJfjTtggJkUciq+PjumSBvMKY9BTGNkY2eKaq7F?=
 =?us-ascii?Q?QR4XEEusZzzCNF/UJQtrbqhEUguyKdqzotz6YNZn+WZFl7P4gukHfaylYP8w?=
 =?us-ascii?Q?5fUtdCa4n9dfs2HGfSJmTGxJGbTufBMzEJMGhTcdWceUVKHiLF8Th8YEEYs8?=
 =?us-ascii?Q?etFG7Uoab7elJg+RaQNrtJqhVVwW+DHhFTUFkMJiKneJkcOyi9RM87Ue4ouk?=
 =?us-ascii?Q?kIDI2u54yG9uArGuU2P4Jq7uXaNbOPpJubtgGdFQFkIWBXi5oYdN4pxOW226?=
 =?us-ascii?Q?K93p0NJiOA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 73bbba4e-c0dd-4dba-d24c-08de627e958b
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 17:14:55.0394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EnMMBX1DqjM8cXxg/Wkh0DSGQfdWVhH/IEvlSl4Glr19G+pH05hj9miupWn5xkV7dEUrKkOoXRdo/7ccM46C7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB8296
X-OriginatorOrg: intel.com

Michael S. Tsirkin wrote:
> On Fri, Jan 30, 2026 at 02:52:12PM -0600, Ira Weiny wrote:
> > Li Chen wrote:

[snip]

> > > diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> > > index c3f07be4aa22..827a17fe7c71 100644
> > > --- a/drivers/nvdimm/nd_virtio.c
> > > +++ b/drivers/nvdimm/nd_virtio.c
> > > @@ -44,19 +44,24 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
> > >  	unsigned long flags;
> > >  	int err, err1;
> > >  
> > > +	might_sleep();
> > > +	mutex_lock(&vpmem->flush_lock);
> > 
> > Assuming this does fix a bug I'd rather use guard here.
> 
> Do you, from code review, agree with the logic that
> it's racy right now?

I do now.  I was hoping to understand the test being run.  The additional
detail that it takes multiple runs helps.

> Whether the bug is reproducible isn't really the question.
> 

True.  But we should still use guard().  I'll look for v2.

Ira
