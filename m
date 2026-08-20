Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EEA3AE6E5;
	Thu, 20 Aug 2026 06:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787205732; cv=fail; b=Ut0b6h0+ml5Uo/gQa0v9Jy7wQl4ldbkn3EjASYIDNNGsx0Ip4qTL1nKdYImQ0NmD1AVskPcZZJJLmMgMbZK6bJp+PfWx2WGbFMy1KVOhJGej0sHp6d+JWwwn/Jjgmru6Rb/Az3uSoy9hYd7eskiKRFsSDNeLcqppxPua4l344dg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787205732; c=relaxed/simple;
	bh=ca7cAbHo62yjdXn+ak2Fq/PCNGK0kQI2GHeP4F173Kc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OUhJsrndPCJClC7dnRshES6A/zizLQuissDnxLLv1hZtR7/jRIEy3r9YVLOQaNffppcrFSgZOCoSQEWdsyIbURHGUVHGRlYJmBBbSr1X0caMML0hlKPDycv0uhEHGcH2bcFWaKOltLjmbOIXhV/EVSPwnTTpg5/RWNT5at6IMf4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=NI1bARbl; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=FjCgOQPV; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NI1bARbl";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="FjCgOQPV"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787205729; x=1818741729;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ca7cAbHo62yjdXn+ak2Fq/PCNGK0kQI2GHeP4F173Kc=;
  b=NI1bARblt7NbDhTtnn/VWsIRZXBpZ29eWy/LxUDccWh79OHv4ND6DmqA
   gZXqmBlgCZNiOavuzEJffgwInYrFmV8/lqTfetcXoEaRgmUd7nVffpHIL
   bWwU0MDIcjNPqgPwEfbTqvhUGAHm39PbcXtTiF148KTGjiz5o5TOOUboZ
   SpSHo0CY7bXrCW53zzTN7pL7mGXCNU1MeU48LpVf06yhMHMStbyLfajtE
   cT4IGrn42mqwlZaQBs7p9lHybHE+RhfYeWSazkh5+c2tMP8UOtryQS4jH
   tca4itjzxMEsJt9waS3sWYXUNZscTZ0Ea11TvKVmJCf3Op0LLImli5Sk5
   A==;
X-CSE-ConnectionGUID: b4abLd9hQL2QWXw8tY1VbQ==
X-CSE-MsgGUID: PELlWyxvQuyLdUbHlMSBeQ==
X-IronPort-AV: E=Sophos;i="6.25,232,1779120000"; 
   d="scan'208";a="154818758"
Received: from mail-westusazon11012027.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([52.101.43.27])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Aug 2026 14:02:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QOP+bgNPHlUgA1QGGYkRXIPhj/Q91adUymfiquf6mx6CM4qn0XNLZr1jlpKNNK1egAzF4X5sbMGzHvwFZCxOIdS1Z6/d2N1QmZAlzs4IQezED0YAgSo6yA4QsjGf0FYx9Jr9KHD5YnUgZxdRQzdWkQ41sQP3QjupkGkcR+ZF4hNi3jPt52FElsPtYk605OfjzPZY/wqy4bLw5YUlUHSTYFB4XtCiuzvI4FaZoauavZtx1fT16ZKlVhr6HqqmAqoilabpfVvOeIVb6cpfZli7SJcd1DaSiqTH6FJeJw2PT5T9YsFqrgfNM6IBA5Q23V15p5RF0FqN/1tEs7P1TT2kLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FXYHy7sKKrzsrxxnuwH685uUCxAf4aFNOKF1Qcf8ohM=;
 b=OLBS9/9Y4zBqOqs4v5FlFWczemeEhA4WDRLrg6carY7+JrX52sVGiqoMNcqx6yhYSA4wL5WRXoPrk1FrtILX0U7/38UHHGUIMnjN+6t3bPVXyo3PQlNqseQtIC6R8ZfBkmw5VkZu5a1+tdClrwf0v9C0H9s66zD2GANTzeu2T2HqotQgsuVKQVo/Vzvj+MquzA5poOj2Wvk4wolOm8P3UjhhU9hSqPtaDo+m10KfY5WPe6MGRkZYrCuARuZv9VFZagLQSA/lCtGYbcghnG3rrlmHOqiWf6Tn9aEYbdsC1kx9wspJboPJZqdBV/JrvgfdrMIfOv/mE0MMvO+OCJtGfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FXYHy7sKKrzsrxxnuwH685uUCxAf4aFNOKF1Qcf8ohM=;
 b=FjCgOQPVcZxhmBATwgKbAwN6YDcJPMXK/D9vGkxEoOIusjtFj6BHTuZRHhDCSdmBIeRs48UDMFAznuh/azaVrqB3Ce5DZyO7AgOx5u8v1fJKbulRjxEcyOFUCnwcud0y2jJx/tXcqOU/OXjGDjIZkx0MhsA6y9MOG+qF3u+phTo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by CH4PR04MB9460.namprd04.prod.outlook.com
 (2603:10b6:610:23c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Thu, 20 Aug
 2026 06:01:58 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%4]) with mapi id 15.21.0339.007; Thu, 20 Aug 2026
 06:01:58 +0000
Date: Thu, 20 Aug 2026 15:01:47 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Yu Kuai <yukuai@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Yu Kuai <yukuai@fygo.io>, Christoph Hellwig <hch@lst.de>, 
	Tao Cui <cui.tao@linux.dev>, Jan Kara <jack@suse.cz>, Ming Lei <ming.lei@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Coly Li <colyli@fygo.io>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, Song Liu <song@kernel.org>, Li Nan <magiclinan@didiglobal.com>, 
	Xiao Ni <xiao@kernel.org>, Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
	Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <iweiny@kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 0/3] blk-cgroup: store blkcg in bio before
 blkcg_mutex conversion
Message-ID: <aoaW23NYSa4uhDpa@shinhome>
References: <20260818070641.756747-1-yukuai@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818070641.756747-1-yukuai@kernel.org>
X-ClientProxiedBy: TY4P301CA0069.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:36a::6) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|CH4PR04MB9460:EE_
X-MS-Office365-Filtering-Correlation-Id: f3877da4-66f6-4416-39a5-08defe808b80
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|19092799006|6133799003|56012099006|10067099003|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	8thnMIW6pedWCLJxxuUnTSazARV1MwR9Ivv5ByTlBRkTrGjk4v/6YnNLkZzd8Tezg45bpiwbEajfUJHsmR80jYl9cUv/BLtq13vFTUmtWTiJ3lfHRymTbGRSs0JtFGwXZT2AbJ2VjtYJbj2z/T7lhADuA320x7U3p02Fzr9ZxbdopPCN8m/d8AUHpmm/3cB9J/Uslsw7pCRcsQGEPqktj0Q0KEeSrU3eifKPQ4p7Esepaz2vEnGikGQhEj0dX7Ei01qhYXH4/WemmfMxQGgw4YCDCmikF6N4Zlq0hPh+uxYW/Zy7VqWv9Pt73mUZ4/x2CMf9ZGtNx0fYcrhgpNFw4GuBTsqq+IfEJzXfYNfZYxoNmvKxu3X9VS1yneZVtqoMDdk5iJcILtLILUIJEXxeJmKDekfuKplnW7bZwRCgaIggbm4mOq7JrH4FUtG1LNwPDdFXXLQ6cwP99D7qhT4OI+ZC/pijb0UB0Xsb1yto2YXu8qwytE9bYcBK//qRq7CiDjsPh+oy1MQd02ztL5B+gTAaA/A/kbvd5BHQjBPAbG55JH07IMYwhdHvUm0XzJLr0G/nCI9xx1nFo8ow/6MEqgNsSF/B4JCeZ/2c36MnpB/oL/RmpGivcnvrsHJRzZSYGqCpdrS1V6uETqiqiu7ddywjLf8Kev9eLcwdELwD2dA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(19092799006)(6133799003)(56012099006)(10067099003)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kjBfHImVls/CZ778lwvFd0LxLem8XcjRGJiVyE8IJAOV+LpMpBsjMvDJqbCU?=
 =?us-ascii?Q?nvFzvktjpFA7Am0W5vtvou2YdW4Y/v7zBOIm6DFiOKgmu17XV/Ao6RA5ZJsJ?=
 =?us-ascii?Q?qrpaBo0S4lmCrr4CckPeaIyRhb+JQZMniGicnXYXxagtA+Ri6OPNGHeiglO6?=
 =?us-ascii?Q?yLVnTNhkMHxsW3pMScP4idCie7SiEHPPAfYmXShqW01xD5K1GqT64eeESkrT?=
 =?us-ascii?Q?Y/eW/nCN4gV7/240nG2VmwaT+TexkEQzEM53njEUCkTCEfLCVKVvZJzBdOay?=
 =?us-ascii?Q?ybKK6Fw2lWpAjeq/Pt8LfLegIv6Tz/4QIyDevhKcLdktLfeZoAc/SelAUumQ?=
 =?us-ascii?Q?itcY6pGmLhe7Uqv++tbILuzFQyR4+1ZSDA9u1d5rDU7NhcboXuDiHgHw76+k?=
 =?us-ascii?Q?3wFQe24Qz7pAEdf/QGsX4HlplRTut0yQ8/1sMzGGuFYsy5qXo5QrUEj7orq1?=
 =?us-ascii?Q?vbDpdydE8Op7onpoF+f7ChvKK0TYLz8B0XC9pjNvlyzFSoTooCVP46SYyVN/?=
 =?us-ascii?Q?BBzcam4Z7VhIzRcNn3vu760+iK6FLwmT5DJ/vB9bRSI5DqSYcqxglmEV7A3J?=
 =?us-ascii?Q?zZxR5Sa0BhyUbyB3jxHKi91B4/MpbkXKWocWARiCdAdBMFeI79ndYblV0RFq?=
 =?us-ascii?Q?h3sBXh+EmI3T0CD6B+OlfehVps72CVBRmXbmZX+uGEwCvYyIkna04uGV3Hwt?=
 =?us-ascii?Q?d2QkH6mNjZxWjkZeYEG1sOP6ouAVdlOS6KloWPTlqxQHWCv5z8UCVSr0jm6A?=
 =?us-ascii?Q?Mia9yXE5mYPlpTKPX7MySvfUWf+IS4G/DIyD18cl0TSD+ebfdUZryvc/4auR?=
 =?us-ascii?Q?zTbuCoI4y0dYlbX/Azfe5algFsNBI1/Zhdy4WLfLRtICKAbg/Gd2WDT8KPol?=
 =?us-ascii?Q?xv8lPgaTqw2qZBwFqjGJPrLVBSWm5dz3AzcimL0ay8nvP09f+KFKv2BOBYhp?=
 =?us-ascii?Q?XsLSMHC9htPLBoghfqGCnQ7hTrI6tBAB90sjJBYhMW7Y1CZiMuM0Fou50RzJ?=
 =?us-ascii?Q?euBl/g/nf9JYNYotHJFDITF3gVzUVYA/jALgTMR6aRQYzkD+6s+7VX7mUcGT?=
 =?us-ascii?Q?rrlIXW5k7WO73LHykuZZtY3SSYVAWQm0G5Ni/Ot30LLiY7Je6xJRKEFsdTty?=
 =?us-ascii?Q?C1b8iOf9VGMA5cW7sx8/fwmpXQop8XTXHeObaW0ZDlCQEVzfevtpKZqMEbs4?=
 =?us-ascii?Q?RafnpxkaFwmsmuBhkDm/s9fP8FRaxUmGsCtWxpz1pBrv/DGGFemCh5vDGY0o?=
 =?us-ascii?Q?Z23G5lETB33Zg79+U4JHmdzuNi/A709kXIhyBlBA2vzf0DaBKI5gg4YAW+h5?=
 =?us-ascii?Q?UKLBaCERrUmZaC6nLTDuuUMDjwqyHQOuBok0ggPPkRU6cIwpysRrD1+81cqF?=
 =?us-ascii?Q?RdNf54XLXRrjNjFe1ju70EoavPFd6x4XiiNXXsYWLE23v33Fa8pNSCvk29bA?=
 =?us-ascii?Q?k1MA7lU6dLOo54HOFwG4toUf6iLX+0E9eVsPSM/HOQul71/ASZQW8V6s/bla?=
 =?us-ascii?Q?Bejy8QL38ySLVWSRKtN/89YXkioIUMeJI5jn955cT1INL7tfNO4Zts8IoeiB?=
 =?us-ascii?Q?UOn3cZlQm+8cF0GNUlqh8bI6og1demN0kjDUZfJjzcFBqbZsPCmFt/dnD467?=
 =?us-ascii?Q?j5GAqp+H1gNEXe+X1vdcaIr8DFDCSXWZ9zGRGrqDbLPbIacE2eJIMGA5pLbA?=
 =?us-ascii?Q?kRamRR0vz8TalALoqSNjIX+WBJFubZZ3aPk6c5kqpnxhAJY8pXBg1ec7n1ng?=
 =?us-ascii?Q?qjDk5B3JJImfvHgGan8AU+nv6tRdrPM=3D?=
X-Exchange-RoutingPolicyChecked:
	ihTGHEjR3tnrWZXCdsXLmjjNARZF1wHWeEiISo8S3JOcgTmaGgXfSibkU1yiza3WYooQFhFn1OlIOwZOzNOZgsBLSvdTgRmuzbwJ3p+TVKlr0PkkeZjy3+0VG4rk98c0pYzxLujGBrpzeus2geSxNywzeDzQH8cfUVUhn0G+hHM4tY4R1vU53Gj93Q8M+PMtwXGc07uieldncDTnJJGAGYdE0MdfHdPijjemVrvq5Xd3hwbdgEdcUraYk2Gl5KXSwiJYy/JU8HEul3izz2IBnsV10AzEMpNVkUVMqvwSHumyx1nzPfkLC2PGRo90DahSCAd5wSm3Hn8jFUGV64AlTA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5EggR6R9t8w7iV8ch9yY9HxhAMNbe0pjHd/D9zB3YdgbHfxCwQ+ai1jVLnxqh/muYh9u6Iexd8XAdCNY/gDaSDy6f39YovgSW5sGrWJ813PEz6E2u6jAE+Cn0NnWZtbh5BWZDRlgKKbt1HmLpiYXR09zA254I3id4QaSYB9BM8dy31hEYsHSeN5f5xEjqUtS6oHrGtRvp36SlXbkucdQqUfGl9AE44vGve8YNwRkIT5gbUON+TyC9Fomg9vZ0+k+R+dkNNdTwx2QrDwc1AOuGNPloiuyY1IiB5TjWEJGyuzkrWxCVKCOc9JowKxTUvYy2E8V6ASNvaTBn1IBkv+S0j18ukYJSshXzgTaIFCdeowF9T/dSoEoB7FfrTWFGkPfosHFblgFP055pdcRQE4k4EZnFQ0l6vhZaegMs9GYqKjiM4Ee7cGSHyXcf6eMfRVX0JLtPw5PIBhrAU/ks43T+06d4J2OyF8NqUuyxJEiy+p0rL+bw20twhpbAZwqLyh7/uoJI1RbRlERg52vYkgTPXfHjksSLGD0E7Hp1h0xhRpcfrQPqmLANHkjAeT9Hhoij5lrMYIbZKTvIjUuGOny06Az80Wq+1G1xFdhYraxPwaXOT5m+Vv6lnKaWK98RVJf
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3877da4-66f6-4416-39a5-08defe808b80
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2026 06:01:58.5149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q8AuNiDg0kvMNfSNA9/dkzFdgaC3uhtZQTKqHIT/VFGh4EUw2L0TbbxmA4pQ9S4hekiWWGp54lPTst4idLpzzhK2wHITEKQ1dZG2PIOX9ho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9460

On Aug 18, 2026 / 15:06, Yu Kuai wrote:
> From: Yu Kuai <yukuai@fygo.io>
> 
> This RFC remains a preparatory series for the blkcg_mutex conversion
> proposed in the related blkcg_mutex RFC v2 series [1].  That conversion
> moves queue-local blkg topology synchronization from q->queue_lock to
> q->blkcg_mutex, which is awkward while bios directly store queue-local
> blkg references.
> 
> v1 made the stored bio association queue-independent by replacing bi_blkg
> with bi_blkcg, but a bio-owned blkg reference still had to be recovered by
> looking up the bio's blkcg and current request_queue.  Tao Cui reported that
> cgroup removal deletes a dying blkg from the per-blkcg radix tree before a
> throttled bio drops its reference.  A later lookup for that pinned blkg then
> fails, triggers the warning in bio_pinned_blkg(), and leaks the reference.
> 
> v2 makes request_queue the authoritative lookup owner before converting the
> bio association.  A queue-owned rhashtable, keyed by the blkcg CSS ID, keeps
> dying blkgs discoverable until their references drain while q->blkg_list
> remains available for ordered walks.  The bio conversion then stores and
> pins the blkcg CSS, lazily creates a blkg only for users which need one, and
> uses lookup-only access for completion and accounting paths which already
> own a blkg reference.  Async bio punt state is finally moved from blkg to
> blkcg so punting alone does not instantiate a queue-local blkg.

FYI, a blktests-CI trial run found this patch series triggers the failure of
the test case block/027 due to "WARNING: suspicious RCU usage". I manually
confirmed that the failure is recreated in stable manner, using the kernel
at block/for-next branch tip with git hash a33221f7ab12 as the base.


[   60.048652] [    T958] run blktests block/027 at 2026-08-20 14:54:34
[   60.342288] [    T995] sd 9:0:0:0: [sdd] Synchronizing SCSI cache
[   60.512431] [    T998] scsi_debug:sdebug_driver_probe: scsi_debug: trim poll_queues to 0. poll_q/nr_hw = (0/4)
[   60.514009] [    T998] scsi host10: scsi_debug: version 0191 [20210520]
                            dev_size_mb=8, opts=0x0, submit_queues=4, statistics=0
[   60.532043] [    T998] scsi 10:0:0:0: Direct-Access     Linux    scsi_debug       0191 PQ: 0 ANSI: 7
[   60.537838] [    T998] scsi 10:0:0:0: Power-on or device reset occurred
[   60.546792] [     T57] sd 10:0:0:0: [sdd] 268435456 512-byte logical blocks: (137 GB/128 GiB)
[   60.547027] [    T998] sd 10:0:0:0: Attached scsi generic sg3 type 0
[   60.548204] [     T57] sd 10:0:0:0: [sdd] Write Protect is off
[   60.550257] [     T57] sd 10:0:0:0: [sdd] Mode Sense: 73 00 10 08
[   60.550572] [     T57] sd 10:0:0:0: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   60.552280] [    T998] scsi 10:0:0:1: Direct-Access     Linux    scsi_debug       0191 PQ: 0 ANSI: 7
[   60.552669] [     T57] sd 10:0:0:0: [sdd] permanent stream count = 5
[   60.554756] [     T57] sd 10:0:0:0: [sdd] Preferred minimum I/O size 512 bytes
[   60.555874] [     T57] sd 10:0:0:0: [sdd] Optimal transfer size 524288 bytes
[   60.556101] [    T998] scsi 10:0:0:1: Power-on or device reset occurred
[   60.582832] [    T998] sd 10:0:0:1: Attached scsi generic sg4 type 0
[   60.586663] [     T89] sd 10:0:0:1: [sde] 268435456 512-byte logical blocks: (137 GB/128 GiB)
[   60.587870] [     T89] sd 10:0:0:1: [sde] Write Protect is off
[   60.588673] [     T89] sd 10:0:0:1: [sde] Mode Sense: 73 00 10 08
[   60.588824] [     T89] sd 10:0:0:1: [sde] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   60.592560] [     T89] sd 10:0:0:1: [sde] permanent stream count = 5
[   60.594825] [     T89] sd 10:0:0:1: [sde] Preferred minimum I/O size 512 bytes
[   60.596033] [     T89] sd 10:0:0:1: [sde] Optimal transfer size 524288 bytes
[   60.601864] [    T998] scsi 10:0:0:2: Direct-Access     Linux    scsi_debug       0191 PQ: 0 ANSI: 7
[   60.606287] [     T57] sd 10:0:0:0: [sdd] Attached SCSI disk
[   60.610427] [    T998] scsi 10:0:0:2: Power-on or device reset occurred
[   60.623979] [    T998] sd 10:0:0:2: Attached scsi generic sg5 type 0
[   60.629219] [     T12] sd 10:0:0:2: [sdf] 268435456 512-byte logical blocks: (137 GB/128 GiB)
[   60.630662] [     T12] sd 10:0:0:2: [sdf] Write Protect is off
[   60.635090] [     T12] sd 10:0:0:2: [sdf] Mode Sense: 73 00 10 08
[   60.635296] [     T12] sd 10:0:0:2: [sdf] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   60.636699] [    T998] scsi 10:0:0:3: Direct-Access     Linux    scsi_debug       0191 PQ: 0 ANSI: 7
[   60.638127] [     T12] sd 10:0:0:2: [sdf] permanent stream count = 5
[   60.640352] [     T12] sd 10:0:0:2: [sdf] Preferred minimum I/O size 512 bytes
[   60.641526] [    T998] scsi 10:0:0:3: Power-on or device reset occurred
[   60.642765] [     T12] sd 10:0:0:2: [sdf] Optimal transfer size 524288 bytes
[   60.651574] [     T57] sd 10:0:0:3: [sdg] 268435456 512-byte logical blocks: (137 GB/128 GiB)
[   60.653359] [     T57] sd 10:0:0:3: [sdg] Write Protect is off
[   60.654766] [     T57] sd 10:0:0:3: [sdg] Mode Sense: 73 00 10 08
[   60.654923] [     T57] sd 10:0:0:3: [sdg] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   60.656232] [    T998] sd 10:0:0:3: Attached scsi generic sg6 type 0
[   60.658805] [     T89] sd 10:0:0:1: [sde] Attached SCSI disk
[   60.661190] [     T57] sd 10:0:0:3: [sdg] permanent stream count = 5
[   60.662705] [     T57] sd 10:0:0:3: [sdg] Preferred minimum I/O size 512 bytes
[   60.664127] [     T57] sd 10:0:0:3: [sdg] Optimal transfer size 524288 bytes
[   60.666666] [    T998] scsi 10:0:0:4: Direct-Access     Linux    scsi_debug       0191 PQ: 0 ANSI: 7
[   60.670896] [    T998] scsi 10:0:0:4: Power-on or device reset occurred
[   60.745716] [    T998] sd 10:0:0:4: Attached scsi generic sg7 type 0
[   60.747518] [     T85] sd 10:0:0:4: [sdh] 268435456 512-byte logical blocks: (137 GB/128 GiB)
[   60.749227] [     T85] sd 10:0:0:4: [sdh] Write Protect is off
[   60.750985] [     T85] sd 10:0:0:4: [sdh] Mode Sense: 73 00 10 08
[   60.751160] [     T85] sd 10:0:0:4: [sdh] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   60.753246] [     T85] sd 10:0:0:4: [sdh] permanent stream count = 5
[   60.754701] [     T85] sd 10:0:0:4: [sdh] Preferred minimum I/O size 512 bytes
[   60.756101] [     T85] sd 10:0:0:4: [sdh] Optimal transfer size 524288 bytes
[   60.757227] [    T998] scsi 10:0:0:5: Direct-Access     Linux    scsi_debug       0191 PQ: 0 ANSI: 7
[   60.759747] [     T57] sd 10:0:0:3: [sdg] Attached SCSI disk
[   60.763568] [    T998] scsi 10:0:0:5: Power-on or device reset occurred
[   60.787866] [     T12] sd 10:0:0:2: [sdf] Attached SCSI disk
[   60.804506] [     T85] sd 10:0:0:4: [sdh] Attached SCSI disk
[   60.852111] [    T998] sd 10:0:0:5: Attached scsi generic sg8 type 0
[   60.856376] [     T85] sd 10:0:0:5: [sdi] 268435456 512-byte logical blocks: (137 GB/128 GiB)
[   60.857802] [    T998] scsi 10:0:0:6: Direct-Access     Linux    scsi_debug       0191 PQ: 0 ANSI: 7
[   60.858071] [     T85] sd 10:0:0:5: [sdi] Write Protect is off
[   60.861854] [     T85] sd 10:0:0:5: [sdi] Mode Sense: 73 00 10 08
[   60.862017] [     T85] sd 10:0:0:5: [sdi] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   60.862642] [    T998] scsi 10:0:0:6: Power-on or device reset occurred
[   60.863540] [     T85] sd 10:0:0:5: [sdi] permanent stream count = 5
[   60.866947] [     T85] sd 10:0:0:5: [sdi] Preferred minimum I/O size 512 bytes
[   60.870355] [     T85] sd 10:0:0:5: [sdi] Optimal transfer size 524288 bytes
[   60.898965] [    T998] sd 10:0:0:6: Attached scsi generic sg9 type 0
[   60.904198] [     T12] sd 10:0:0:6: [sdj] 268435456 512-byte logical blocks: (137 GB/128 GiB)
[   60.905768] [     T12] sd 10:0:0:6: [sdj] Write Protect is off
[   60.907526] [     T12] sd 10:0:0:6: [sdj] Mode Sense: 73 00 10 08
[   60.907686] [     T12] sd 10:0:0:6: [sdj] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   60.909852] [     T12] sd 10:0:0:6: [sdj] permanent stream count = 5
[   60.911593] [     T12] sd 10:0:0:6: [sdj] Preferred minimum I/O size 512 bytes
[   60.912958] [     T12] sd 10:0:0:6: [sdj] Optimal transfer size 524288 bytes
[   60.951487] [    T998] scsi 10:0:0:7: Direct-Access     Linux    scsi_debug       0191 PQ: 0 ANSI: 7
[   60.953020] [     T12] sd 10:0:0:6: [sdj] Attached SCSI disk
[   60.961132] [    T998] scsi 10:0:0:7: Power-on or device reset occurred
[   61.051690] [     T12] sd 10:0:0:7: [sdk] 268435456 512-byte logical blocks: (137 GB/128 GiB)
[   61.053835] [     T12] sd 10:0:0:7: [sdk] Write Protect is off
[   61.055160] [     T12] sd 10:0:0:7: [sdk] Mode Sense: 73 00 10 08
[   61.055324] [     T12] sd 10:0:0:7: [sdk] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   61.060649] [     T12] sd 10:0:0:7: [sdk] permanent stream count = 5
[   61.062187] [     T12] sd 10:0:0:7: [sdk] Preferred minimum I/O size 512 bytes
[   61.065148] [     T12] sd 10:0:0:7: [sdk] Optimal transfer size 524288 bytes
[   61.101609] [     T85] sd 10:0:0:5: [sdi] Attached SCSI disk
[   61.106279] [    T998] sd 10:0:0:7: Attached scsi generic sg10 type 0
[   61.114062] [    T998] scsi 10:0:0:8: Direct-Access     Linux    scsi_debug       0191 PQ: 0 ANSI: 7
[   61.123360] [    T998] scsi 10:0:0:8: Power-on or device reset occurred
[   61.139984] [     T12] sd 10:0:0:7: [sdk] Attached SCSI disk
[   61.217165] [     T89] sd 10:0:0:8: [sdl] 268435456 512-byte logical blocks: (137 GB/128 GiB)
[   61.219292] [     T89] sd 10:0:0:8: [sdl] Write Protect is off
[   61.221173] [     T89] sd 10:0:0:8: [sdl] Mode Sense: 73 00 10 08
[   61.221335] [     T89] sd 10:0:0:8: [sdl] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   61.223670] [     T89] sd 10:0:0:8: [sdl] permanent stream count = 5
[   61.225332] [     T89] sd 10:0:0:8: [sdl] Preferred minimum I/O size 512 bytes
[   61.226777] [     T89] sd 10:0:0:8: [sdl] Optimal transfer size 524288 bytes
[   61.251833] [    T998] sd 10:0:0:8: Attached scsi generic sg11 type 0
[   61.258846] [    T998] scsi 10:0:0:9: Direct-Access     Linux    scsi_debug       0191 PQ: 0 ANSI: 7
[   61.266439] [    T998] scsi 10:0:0:9: Power-on or device reset occurred
[   61.279306] [     T12] sd 10:0:0:9: [sdm] 268435456 512-byte logical blocks: (137 GB/128 GiB)
[   61.281013] [     T12] sd 10:0:0:9: [sdm] Write Protect is off
[   61.282263] [     T12] sd 10:0:0:9: [sdm] Mode Sense: 73 00 10 08
[   61.282429] [     T12] sd 10:0:0:9: [sdm] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   61.283621] [    T998] sd 10:0:0:9: Attached scsi generic sg12 type 0
[   61.285076] [     T12] sd 10:0:0:9: [sdm] permanent stream count = 5
[   61.286842] [     T12] sd 10:0:0:9: [sdm] Preferred minimum I/O size 512 bytes
[   61.288650] [     T12] sd 10:0:0:9: [sdm] Optimal transfer size 524288 bytes
[   61.350640] [    T998] scsi 10:0:0:10: Direct-Access     Linux    scsi_debug       0191 PQ: 0 ANSI: 7
[   61.356467] [     T12] sd 10:0:0:9: [sdm] Attached SCSI disk
[   61.359096] [    T998] scsi 10:0:0:10: Power-on or device reset occurred
[   61.428598] [     T89] sd 10:0:0:8: [sdl] Attached SCSI disk
[   61.519323] [    T998] sd 10:0:0:10: Attached scsi generic sg13 type 0
[   61.519455] [     T89] sd 10:0:0:10: [sdn] 268435456 512-byte logical blocks: (137 GB/128 GiB)
[   61.524681] [    T998] scsi 10:0:0:11: Direct-Access     Linux    scsi_debug       0191 PQ: 0 ANSI: 7
[   61.525872] [     T89] sd 10:0:0:10: [sdn] Write Protect is off
[   61.530097] [     T89] sd 10:0:0:10: [sdn] Mode Sense: 73 00 10 08
[   61.530292] [     T89] sd 10:0:0:10: [sdn] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   61.530887] [    T998] scsi 10:0:0:11: Power-on or device reset occurred
[   61.532201] [     T89] sd 10:0:0:10: [sdn] permanent stream count = 5
[   61.536746] [     T89] sd 10:0:0:10: [sdn] Preferred minimum I/O size 512 bytes
[   61.539106] [     T89] sd 10:0:0:10: [sdn] Optimal transfer size 524288 bytes
[   61.541544] [     T85] sd 10:0:0:11: [sdo] 268435456 512-byte logical blocks: (137 GB/128 GiB)
[   61.543209] [     T85] sd 10:0:0:11: [sdo] Write Protect is off
[   61.545292] [     T85] sd 10:0:0:11: [sdo] Mode Sense: 73 00 10 08
[   61.545453] [     T85] sd 10:0:0:11: [sdo] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   61.547869] [     T85] sd 10:0:0:11: [sdo] permanent stream count = 5
[   61.550065] [     T85] sd 10:0:0:11: [sdo] Preferred minimum I/O size 512 bytes
[   61.551491] [     T85] sd 10:0:0:11: [sdo] Optimal transfer size 524288 bytes
[   61.560843] [    T998] sd 10:0:0:11: Attached scsi generic sg14 type 0
[   61.575647] [    T998] scsi 10:0:0:12: Direct-Access     Linux    scsi_debug       0191 PQ: 0 ANSI: 7
[   61.581203] [    T998] scsi 10:0:0:12: Power-on or device reset occurred
[   61.659971] [     T89] sd 10:0:0:10: [sdn] Attached SCSI disk
[   61.703691] [    T998] sd 10:0:0:12: Attached scsi generic sg15 type 0
[   61.714468] [     T85] sd 10:0:0:11: [sdo] Attached SCSI disk
[   61.752593] [    T998] scsi 10:0:0:13: Direct-Access     Linux    scsi_debug       0191 PQ: 0 ANSI: 7
[   61.761908] [    T998] scsi 10:0:0:13: Power-on or device reset occurred
[   61.770075] [     T89] sd 10:0:0:12: [sdp] 268435456 512-byte logical blocks: (137 GB/128 GiB)
[   61.771727] [     T89] sd 10:0:0:12: [sdp] Write Protect is off
[   61.773108] [     T89] sd 10:0:0:12: [sdp] Mode Sense: 73 00 10 08
[   61.773266] [     T89] sd 10:0:0:12: [sdp] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   61.775657] [     T89] sd 10:0:0:12: [sdp] permanent stream count = 5
[   61.778651] [     T89] sd 10:0:0:12: [sdp] Preferred minimum I/O size 512 bytes
[   61.781598] [     T89] sd 10:0:0:12: [sdp] Optimal transfer size 524288 bytes
[   61.801054] [     T85] sd 10:0:0:13: [sdq] 268435456 512-byte logical blocks: (137 GB/128 GiB)
[   61.802968] [     T85] sd 10:0:0:13: [sdq] Write Protect is off
[   61.804603] [     T85] sd 10:0:0:13: [sdq] Mode Sense: 73 00 10 08
[   61.804798] [     T85] sd 10:0:0:13: [sdq] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   61.809291] [     T85] sd 10:0:0:13: [sdq] permanent stream count = 5
[   61.812234] [     T85] sd 10:0:0:13: [sdq] Preferred minimum I/O size 512 bytes
[   61.814067] [     T85] sd 10:0:0:13: [sdq] Optimal transfer size 524288 bytes
[   61.856311] [    T998] sd 10:0:0:13: Attached scsi generic sg16 type 0
[   61.872980] [    T998] scsi 10:0:0:14: Direct-Access     Linux    scsi_debug       0191 PQ: 0 ANSI: 7
[   61.880018] [    T998] scsi 10:0:0:14: Power-on or device reset occurred
[   61.898152] [     T12] sd 10:0:0:14: [sdr] 268435456 512-byte logical blocks: (137 GB/128 GiB)
[   61.901297] [     T12] sd 10:0:0:14: [sdr] Write Protect is off
[   61.904599] [     T12] sd 10:0:0:14: [sdr] Mode Sense: 73 00 10 08
[   61.904758] [     T12] sd 10:0:0:14: [sdr] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   61.907952] [     T12] sd 10:0:0:14: [sdr] permanent stream count = 5
[   61.909473] [     T12] sd 10:0:0:14: [sdr] Preferred minimum I/O size 512 bytes
[   61.911556] [     T12] sd 10:0:0:14: [sdr] Optimal transfer size 524288 bytes
[   61.921187] [     T89] sd 10:0:0:12: [sdp] Attached SCSI disk
[   61.947703] [    T998] sd 10:0:0:14: Attached scsi generic sg17 type 0
[   61.956937] [    T998] scsi 10:0:0:15: Direct-Access     Linux    scsi_debug       0191 PQ: 0 ANSI: 7
[   61.964139] [    T998] scsi 10:0:0:15: Power-on or device reset occurred
[   61.966101] [     T85] sd 10:0:0:13: [sdq] Attached SCSI disk
[   62.054834] [    T998] sd 10:0:0:15: Attached scsi generic sg18 type 0
[   62.063562] [    T998] scsi 10:0:0:16: Direct-Access     Linux    scsi_debug       0191 PQ: 0 ANSI: 7
[   62.069436] [    T998] scsi 10:0:0:16: Power-on or device reset occurred
[   62.070705] [     T89] sd 10:0:0:15: [sds] 268435456 512-byte logical blocks: (137 GB/128 GiB)
[   62.073325] [     T89] sd 10:0:0:15: [sds] Write Protect is off
[   62.074520] [     T89] sd 10:0:0:15: [sds] Mode Sense: 73 00 10 08
[   62.074682] [     T89] sd 10:0:0:15: [sds] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   62.078365] [     T85] sd 10:0:0:16: [sdt] 268435456 512-byte logical blocks: (137 GB/128 GiB)
[   62.079508] [     T89] sd 10:0:0:15: [sds] permanent stream count = 5
[   62.080108] [     T85] sd 10:0:0:16: [sdt] Write Protect is off
[   62.080978] [     T89] sd 10:0:0:15: [sds] Preferred minimum I/O size 512 bytes
[   62.082994] [     T85] sd 10:0:0:16: [sdt] Mode Sense: 73 00 10 08
[   62.083665] [     T89] sd 10:0:0:15: [sds] Optimal transfer size 524288 bytes
[   62.084433] [    T998] sd 10:0:0:16: Attached scsi generic sg19 type 0
[   62.086905] [     T85] sd 10:0:0:16: [sdt] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   62.090249] [     T85] sd 10:0:0:16: [sdt] permanent stream count = 5
[   62.091796] [     T85] sd 10:0:0:16: [sdt] Preferred minimum I/O size 512 bytes
[   62.095042] [    T998] scsi 10:0:0:17: Direct-Access     Linux    scsi_debug       0191 PQ: 0 ANSI: 7
[   62.096731] [     T85] sd 10:0:0:16: [sdt] Optimal transfer size 524288 bytes
[   62.099216] [     T12] sd 10:0:0:14: [sdr] Attached SCSI disk
[   62.102505] [    T998] scsi 10:0:0:17: Power-on or device reset occurred
[   62.130600] [     T89] sd 10:0:0:15: [sds] Attached SCSI disk
[   62.152860] [     T57] sd 10:0:0:17: [sdu] 268435456 512-byte logical blocks: (137 GB/128 GiB)
[   62.154661] [     T57] sd 10:0:0:17: [sdu] Write Protect is off
[   62.156840] [     T57] sd 10:0:0:17: [sdu] Mode Sense: 73 00 10 08
[   62.156999] [     T57] sd 10:0:0:17: [sdu] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   62.158980] [     T57] sd 10:0:0:17: [sdu] permanent stream count = 5
[   62.160461] [     T57] sd 10:0:0:17: [sdu] Preferred minimum I/O size 512 bytes
[   62.161941] [     T57] sd 10:0:0:17: [sdu] Optimal transfer size 524288 bytes
[   62.197490] [    T998] sd 10:0:0:17: Attached scsi generic sg20 type 0
[   62.202924] [     T85] sd 10:0:0:16: [sdt] Attached SCSI disk
[   62.246749] [    T998] scsi 10:0:0:18: Direct-Access     Linux    scsi_debug       0191 PQ: 0 ANSI: 7
[   62.253160] [    T998] scsi 10:0:0:18: Power-on or device reset occurred
[   62.362859] [     T85] sd 10:0:0:18: [sdv] 268435456 512-byte logical blocks: (137 GB/128 GiB)
[   62.364530] [     T85] sd 10:0:0:18: [sdv] Write Protect is off
[   62.369860] [     T85] sd 10:0:0:18: [sdv] Mode Sense: 73 00 10 08
[   62.370019] [     T85] sd 10:0:0:18: [sdv] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   62.372485] [     T85] sd 10:0:0:18: [sdv] permanent stream count = 5
[   62.375392] [     T85] sd 10:0:0:18: [sdv] Preferred minimum I/O size 512 bytes
[   62.377326] [     T85] sd 10:0:0:18: [sdv] Optimal transfer size 524288 bytes
[   62.386677] [    T998] sd 10:0:0:18: Attached scsi generic sg21 type 0
[   62.390025] [     T57] sd 10:0:0:17: [sdu] Attached SCSI disk
[   62.395147] [    T998] scsi 10:0:0:19: Direct-Access     Linux    scsi_debug       0191 PQ: 0 ANSI: 7
[   62.400566] [    T998] scsi 10:0:0:19: Power-on or device reset occurred
[   62.492252] [    T998] sd 10:0:0:19: Attached scsi generic sg22 type 0
[   62.504374] [     T89] sd 10:0:0:19: [sdw] 268435456 512-byte logical blocks: (137 GB/128 GiB)
[   62.506027] [     T89] sd 10:0:0:19: [sdw] Write Protect is off
[   62.507260] [     T89] sd 10:0:0:19: [sdw] Mode Sense: 73 00 10 08
[   62.507422] [     T89] sd 10:0:0:19: [sdw] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   62.509393] [     T89] sd 10:0:0:19: [sdw] permanent stream count = 5
[   62.512301] [     T89] sd 10:0:0:19: [sdw] Preferred minimum I/O size 512 bytes
[   62.513697] [     T89] sd 10:0:0:19: [sdw] Optimal transfer size 524288 bytes
[   62.541424] [    T998] scsi 10:0:0:20: Direct-Access     Linux    scsi_debug       0191 PQ: 0 ANSI: 7
[   62.552224] [    T998] scsi 10:0:0:20: Power-on or device reset occurred
[   62.599822] [     T85] sd 10:0:0:18: [sdv] Attached SCSI disk
[   62.609329] [     T57] sd 10:0:0:20: [sdx] 268435456 512-byte logical blocks: (137 GB/128 GiB)
[   62.613381] [     T57] sd 10:0:0:20: [sdx] Write Protect is off
[   62.618693] [     T57] sd 10:0:0:20: [sdx] Mode Sense: 73 00 10 08
[   62.618850] [     T57] sd 10:0:0:20: [sdx] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   62.621631] [     T57] sd 10:0:0:20: [sdx] permanent stream count = 5
[   62.623343] [     T57] sd 10:0:0:20: [sdx] Preferred minimum I/O size 512 bytes
[   62.624997] [     T57] sd 10:0:0:20: [sdx] Optimal transfer size 524288 bytes
[   62.628524] [    T998] sd 10:0:0:20: Attached scsi generic sg23 type 0
[   62.643270] [     T89] sd 10:0:0:19: [sdw] Attached SCSI disk
[   62.726714] [     T57] sd 10:0:0:20: [sdx] Attached SCSI disk
[   71.628857] [    T958] sd 10:0:0:0: [sdd] Synchronizing SCSI cache

[   71.725933] [   T1258] =============================
[   71.727013] [   T1258] WARNING: suspicious RCU usage
[   71.728048] [   T1258] 7.2.0-rc5+ #448 Not tainted
[   71.729043] [   T1258] -----------------------------
[   71.730053] [   T1258] block/blk-cgroup.h:273 blkg_lookup_any() requires an RCU read lock!
[   71.731460] [   T1258] 
                          other info that might help us debug this:

[   71.734042] [   T1258] 
                          rcu_scheduler_active = 2, debug_locks = 1
[   71.735857] [   T1258] 1 lock held by fio/1258:
[   71.736805] [   T1258]  #0: ffff88810a4bb6c8 (&q->queue_lock){..-.}-{3:3}, at: bio_blkg+0x131/0xed0
[   71.738307] [   T1258] 
                          stack backtrace:
[   71.739882] [   T1258] CPU: 0 UID: 0 PID: 1258 Comm: fio Not tainted 7.2.0-rc5+ #448 PREEMPT(full) 
[   71.739886] [   T1258] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-10.fc44 06/10/2025
[   71.739890] [   T1258] Call Trace:
[   71.739892] [   T1258]  <TASK>
[   71.739894] [   T1258]  dump_stack_lvl+0x6a/0x90
[   71.739900] [   T1258]  lockdep_rcu_suspicious.cold+0x3a/0x7d
[   71.739906] [   T1258]  blkg_lookup_any+0x3ad/0x5d0
[   71.739910] [   T1258]  ? find_held_lock+0x2b/0x80
[   71.739915] [   T1258]  ? bio_blkg+0x634/0xed0
[   71.739917] [   T1258]  ? lock_release+0x1b5/0x340
[   71.739922] [   T1258]  bio_blkg+0x681/0xed0
[   71.739930] [   T1258]  bfq_insert_requests+0x17cc/0x8f90
[   71.739937] [   T1258]  ? __create_object+0x4e/0xe0
[   71.739941] [   T1258]  ? find_held_lock+0x2b/0x80
[   71.739945] [   T1258]  ? __create_object+0x78/0xe0
[   71.739947] [   T1258]  ? lock_release+0x1b5/0x340
[   71.739952] [   T1258]  ? _raw_spin_unlock_irqrestore+0x35/0x60
[   71.739956] [   T1258]  ? __pfx_bfq_insert_requests+0x10/0x10
[   71.739959] [   T1258]  ? rcu_is_watching+0x11/0xb0
[   71.739963] [   T1258]  ? kmem_cache_alloc_noprof+0x4bf/0x6d0
[   71.739967] [   T1258]  ? radix_tree_node_alloc.constprop.0+0x19e/0x3a0
[   71.739973] [   T1258]  ? radix_tree_node_alloc.constprop.0+0x19e/0x3a0
[   71.739978] [   T1258]  ? find_held_lock+0x2b/0x80
[   71.739982] [   T1258]  ? ioc_find_get_icq+0x585/0xab0
[   71.739985] [   T1258]  ? lock_release+0x1b5/0x340
[   71.739987] [   T1258]  ? trace_hardirqs_on+0x14/0x190
[   71.739991] [   T1258]  ? ioc_find_get_icq+0x594/0xab0
[   71.739997] [   T1258]  ? bdev_count_inflight_rw.part.0+0x17f/0x320
[   71.740005] [   T1258]  ? bdev_count_inflight+0x67/0xa0
[   71.740008] [   T1258]  ? __pfx_bdev_count_inflight+0x10/0x10
[   71.740012] [   T1258]  ? ktime_get+0x27/0x210
[   71.740016] [   T1258]  ? find_held_lock+0x2b/0x80
[   71.740021] [   T1258]  blk_mq_insert_request+0x248/0xbe0
[   71.740025] [   T1258]  ? __pfx_blk_mq_insert_request+0x10/0x10
[   71.740027] [   T1258]  ? kvm_clock_get_cycles+0x14/0x30
[   71.740036] [   T1258]  blk_mq_submit_bio+0xf25/0x2a00
[   71.740040] [   T1258]  ? bio_associate_blkcg_from_css+0x14b/0x670
[   71.740044] [   T1258]  ? __pfx_blk_mq_submit_bio+0x10/0x10
[   71.740047] [   T1258]  ? iov_iter_extract_bvecs+0x50f/0xb30
[   71.740054] [   T1258]  ? __pfx_blk_cgroup_bio_start+0x10/0x10
[   71.740060] [   T1258]  submit_bio_noacct_nocheck+0x41d/0xb00
[   71.740066] [   T1258]  ? __pfx_submit_bio_noacct_nocheck+0x10/0x10
[   71.740071] [   T1258]  ? submit_bio_noacct+0x80c/0x2070
[   71.740078] [   T1258]  blkdev_direct_IO+0x949/0x1f90
[   71.740080] [   T1258]  ? lock_acquire+0x199/0x320
[   71.740083] [   T1258]  ? is_bpf_text_address+0x1d/0xf0
[   71.740086] [   T1258]  ? lock_acquire+0x1a9/0x320
[   71.740088] [   T1258]  ? find_held_lock+0x2b/0x80
[   71.740092] [   T1258]  ? is_bpf_text_address+0x60/0xf0
[   71.740094] [   T1258]  ? lock_release+0x1b5/0x340
[   71.740099] [   T1258]  ? __pfx_blkdev_direct_IO+0x10/0x10
[   71.740102] [   T1258]  ? __kernel_text_address+0xe/0x30
[   71.740105] [   T1258]  ? __pfx_stack_trace_consume_entry+0x10/0x10
[   71.740108] [   T1258]  ? unwind_get_return_address+0x67/0xd0
[   71.740111] [   T1258]  ? arch_stack_walk+0xef/0x140
[   71.740116] [   T1258]  ? selinux_file_permission+0x3c0/0x530
[   71.740122] [   T1258]  blkdev_read_iter+0x223/0x440
[   71.740128] [   T1258]  aio_read+0x2e8/0x5b0
[   71.740133] [   T1258]  ? __pfx_aio_read+0x10/0x10
[   71.740148] [   T1258]  ? __pfx___might_resched+0x10/0x10
[   71.740151] [   T1258]  ? find_held_lock+0x2b/0x80
[   71.740155] [   T1258]  ? __might_fault+0x97/0x140
[   71.740160] [   T1258]  ? io_submit_one+0x440/0x1a70
[   71.740162] [   T1258]  io_submit_one+0x440/0x1a70
[   71.740171] [   T1258]  ? __pfx_io_submit_one+0x10/0x10
[   71.740173] [   T1258]  ? rcu_is_watching+0x11/0xb0
[   71.740182] [   T1258]  ? __pfx___might_resched+0x10/0x10
[   71.740184] [   T1258]  ? find_held_lock+0x2b/0x80
[   71.740191] [   T1258]  ? __x64_sys_io_submit+0x193/0x2f0
[   71.740194] [   T1258]  __x64_sys_io_submit+0x193/0x2f0
[   71.740198] [   T1258]  ? __pfx___x64_sys_io_submit+0x10/0x10
[   71.740203] [   T1258]  ? lock_release+0x1b5/0x340
[   71.740211] [   T1258]  do_syscall_64+0xdf/0x790
[   71.740218] [   T1258]  ? __lock_acquire+0x3d2/0x2440
[   71.740222] [   T1258]  ? __pfx___css_rstat_updated+0x10/0x10
[   71.740228] [   T1258]  ? lock_acquire+0x199/0x320
[   71.740230] [   T1258]  ? count_memcg_events_mm.constprop.0+0x22/0x130
[   71.740233] [   T1258]  ? rcu_is_watching+0x11/0xb0
[   71.740236] [   T1258]  ? count_memcg_events+0x107/0x4c0
[   71.740238] [   T1258]  ? find_held_lock+0x2b/0x80
[   71.740242] [   T1258]  ? rcu_is_watching+0x11/0xb0
[   71.740245] [   T1258]  ? __up_read+0x351/0x9c0
[   71.740249] [   T1258]  ? __pfx___up_read+0x10/0x10
[   71.740252] [   T1258]  ? do_user_addr_fault+0x28c/0xaf0
[   71.740255] [   T1258]  ? lock_release+0x1b5/0x340
[   71.740260] [   T1258]  ? rcu_is_watching+0x11/0xb0
[   71.740263] [   T1258]  ? trace_hardirqs_on+0x14/0x190
[   71.740265] [   T1258]  ? preempt_count_add+0x7f/0x190
[   71.740267] [   T1258]  ? do_syscall_64+0x5d/0x790
[   71.740270] [   T1258]  ? do_syscall_64+0x8d/0x790
[   71.740272] [   T1258]  ? irqentry_exit+0xfc/0x810
[   71.740277] [   T1258]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   71.740280] [   T1258] RIP: 0033:0x7f40f240c0cd
[   71.740283] [   T1258] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 03 4d 0f 00 f7 d8 64 89 01 48
[   71.740285] [   T1258] RSP: 002b:00007fff410d1b08 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
[   71.740290] [   T1258] RAX: ffffffffffffffda RBX: 00007f40f2316718 RCX: 00007f40f240c0cd
[   71.740292] [   T1258] RDX: 000000001f5f9750 RSI: 0000000000000001 RDI: 00007f40e3fdf000
[   71.740293] [   T1258] RBP: 00007fff410d1b40 R08: 000000001f7094e0 R09: 000000001f709400
[   71.740294] [   T1258] R10: 000000001f709400 R11: 0000000000000246 R12: 00007f40e3fdf000
[   71.740296] [   T1258] R13: 0000000000000000 R14: 000000001f5f9750 R15: 0000000000000001
[   71.740305] [   T1258]  </TASK>
[   73.210606] [    T958] sd 10:0:0:1: [sde] Synchronizing SCSI cache
[   73.251578] [    T296] device offline error, dev sdn, sector 189403096 op 0x0:(READ) flags 0x800000 phys_seg 1 prio class 2
[   73.256114] [    T296] device offline error, dev sdn, sector 199421272 op 0x0:(READ) flags 0x800000 phys_seg 1 prio class 2
[   73.256143] [    T296] device offline error, dev sdn, sector 203643552 op 0x0:(READ) flags 0x800000 phys_seg 1 prio class 2
[   73.256162] [    T296] device offline error, dev sdn, sector 207427136 op 0x0:(READ) flags 0x800000 phys_seg 1 prio class 2
[   73.256201] [    T296] device offline error, dev sdn, sector 214836224 op 0x0:(READ) flags 0x800000 phys_seg 1 prio class 2
[   73.256219] [    T296] device offline error, dev sdn, sector 235862656 op 0x0:(READ) flags 0x800000 phys_seg 1 prio class 2
[   73.256237] [    T296] device offline error, dev sdn, sector 236401976 op 0x0:(READ) flags 0x800000 phys_seg 1 prio class 2
[   73.256272] [    T296] device offline error, dev sdn, sector 238514280 op 0x0:(READ) flags 0x800000 phys_seg 1 prio class 2
[   73.256290] [    T296] device offline error, dev sdn, sector 245902744 op 0x0:(READ) flags 0x800000 phys_seg 1 prio class 2
[   73.256308] [    T296] device offline error, dev sdn, sector 246183280 op 0x0:(READ) flags 0x800000 phys_seg 1 prio class 2
[   74.011940] [    T958] sd 10:0:0:10: [sdn] Synchronizing SCSI cache
[   74.448759] [    T958] sd 10:0:0:11: [sdo] Synchronizing SCSI cache
[   74.839748] [    T958] sd 10:0:0:12: [sdp] Synchronizing SCSI cache
[   75.265115] [    T958] sd 10:0:0:13: [sdq] Synchronizing SCSI cache
[   75.660906] [    T958] sd 10:0:0:14: [sdr] Synchronizing SCSI cache
[   76.010466] [    T958] sd 10:0:0:15: [sds] Synchronizing SCSI cache
[   76.426481] [    T958] sd 10:0:0:16: [sdt] Synchronizing SCSI cache
[   76.871466] [    T958] sd 10:0:0:17: [sdu] Synchronizing SCSI cache
[   77.286379] [    T958] sd 10:0:0:18: [sdv] Synchronizing SCSI cache
[   77.844417] [    T958] sd 10:0:0:19: [sdw] Synchronizing SCSI cache
[   78.325753] [    T958] sd 10:0:0:2: [sdf] Synchronizing SCSI cache
[   78.331587] [   T1336] blk_print_req_error: 225 callbacks suppressed
[   78.331594] [   T1336] device offline error, dev sdx, sector 129278536 op 0x0:(READ) flags 0x800000 phys_seg 1 prio class 2
[   78.334828] [   T1336] device offline error, dev sdx, sector 23920864 op 0x0:(READ) flags 0x800000 phys_seg 1 prio class 2
[   78.687509] [    T958] sd 10:0:0:20: [sdx] Synchronizing SCSI cache
[   78.695490] [    T332] device offline error, dev sdg, sector 200011456 op 0x0:(READ) flags 0x800000 phys_seg 1 prio class 2
[   78.697842] [    T332] device offline error, dev sdg, sector 80898080 op 0x0:(READ) flags 0x800000 phys_seg 1 prio class 2
[   78.700331] [    T332] device offline error, dev sdg, sector 31089776 op 0x0:(READ) flags 0x800000 phys_seg 1 prio class 2
[   78.701066] [    T107] device offline error, dev sdg, sector 107919016 op 0x0:(READ) flags 0x800000 phys_seg 1 prio class 2
[   79.057557] [    T958] sd 10:0:0:3: [sdg] Synchronizing SCSI cache
[   79.506572] [    T958] sd 10:0:0:4: [sdh] Synchronizing SCSI cache
[   79.516857] [    T106] device offline error, dev sdi, sector 118581624 op 0x0:(READ) flags 0x800000 phys_seg 1 prio class 2
[   79.517079] [    T332] device offline error, dev sdi, sector 88640592 op 0x0:(READ) flags 0x800000 phys_seg 1 prio class 2
[   79.518274] [    T106] device offline error, dev sdi, sector 124905824 op 0x0:(READ) flags 0x800000 phys_seg 1 prio class 2
[   79.519554] [    T332] device offline error, dev sdi, sector 102957264 op 0x0:(READ) flags 0x800000 phys_seg 1 prio class 2
[   80.013799] [    T958] sd 10:0:0:5: [sdi] Synchronizing SCSI cache
[   80.364040] [    T958] sd 10:0:0:6: [sdj] Synchronizing SCSI cache
[   80.737957] [    T958] sd 10:0:0:7: [sdk] Synchronizing SCSI cache
[   81.150826] [    T958] sd 10:0:0:8: [sdl] Synchronizing SCSI cache
[   81.468618] [    T958] sd 10:0:0:9: [sdm] Synchronizing SCSI cache
