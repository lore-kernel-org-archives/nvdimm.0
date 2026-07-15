Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F7835966
	for <nvdimm@lists.linux.dev>; Wed, 15 Jul 2026 00:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784073671; cv=fail; b=tQLUD6Ym63PyDuLWSTXtEpEF0vHDr7EBlKt1sn9IJR6c29D/vnbMzMHGn/SB7Hxfckval8PHw9V3v6hSaG6rY26MfYI8E+IU4IEk53G4IrYYhYXC9ydQ6P2drm8lRtu662srGSJ0cr9LSb7eRdkG8OYsLmwd+NGwoE5XRaI4yWs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784073671; c=relaxed/simple;
	bh=WGDsCNzIWjZXREIh1wvGxwJTYg+ygGL7nLFsRw9Iipg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Q26AK7buVkIE845xjK1GOkvwFgqQiz5dSTPkWZCF3AxtWJQjUH9vsQK2ymuyhm61aurylPDiiXf0H8/d/N+8exkzPpAKgCoe3y6enLBncsXzbdq7xqvlm4K21WvOXBk9PtjWwgSE2JKrg6GMvDJ+7h4DbOtPVMVhyJtOSlmpm6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DVewvtM7; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DVewvtM7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784073669; x=1815609669;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=WGDsCNzIWjZXREIh1wvGxwJTYg+ygGL7nLFsRw9Iipg=;
  b=DVewvtM7MtVew12zoVqyTjrJAOOK8rx0GJSQConCbD9Z2M3n5nWV8niT
   Bt51pKWcr6HS8avlqCkSqhkZpmpByMi0RDAB20n9NON6SVhbYYM7Njrrl
   drJv89aoJOW9ebV/L1lRqo3iy9DgU2D8dQE0XDbIo4XkETuaNp/SLAG9h
   0NewHOEZsoiP/3Yz53M1wETX+fVTYi8uKUM46kwCXwONOoSk0CvvpA58L
   0qmMfLgQcmcg/7XJNYGqP2rROE3rFkizLROLDzN9yK99bf5OSnYBuONQo
   R8x4+5/O6lD+wkqU7XUOcGCAhQPg/n1b50kb+s83kby6xjh4Yz01uBJ4Y
   Q==;
X-CSE-ConnectionGUID: tV09o4raSvyLklhxS40Wlg==
X-CSE-MsgGUID: 2zzmOTiMTjSzmkZUIpkP1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="72231641"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="72231641"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 17:01:09 -0700
X-CSE-ConnectionGUID: Pb/lel5ASwSvn51AlBjJOQ==
X-CSE-MsgGUID: EO7Nj88wRsSexqqfpL7DRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="249636026"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 17:01:08 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 17:01:07 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 14 Jul 2026 17:01:07 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.2) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 17:01:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z4/ZtE1VTPnHJbJsYNMZkUUvXmaxDHKxwx462TU4W6TsCaiB+UW/8p/djzyIXnwDqsZzD3s59B7gdVDgydXiEAkV8qTgshypPQAII8QxtMehsbue0rloBMWT0iLkFncHBnQH//Wph/MdduSO+veVBhbudC0aJHaCI6r99vY4QcwX4kX92BSU3XQDTu7jyozCMwoOjNRxd/waNIZFWpwniWd6HuJluJcA3+8zH0IgIa+DojAG/8cx+mmWVHL3w+OgkTlnTCJsRq0b802YZ1dgSiL9NLQE2mdDcf6GhOFNzZuocALuvvZyEXFpq32xzIpaUdfmutzjIvPm1mhZ4jok9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQeZegtsHyYyscIVWLXQXulbanZg6Vhe3ljESD+HQqE=;
 b=UYRfV0gyU3/r6oXc2BummneEn3DwdQSTT9Y15Ffg4mYQ1ArZ4WPwmSQLZ4xiAJb0d3smdm1LJU5t+6hCsx04RHRwkV0hafpNkFosRC+0UF5sO3EpCzHI8IImi6XZqf4bRLqS3MaYZKx/5RE1I2FAu7LeLfpKEyLPq0uZ7r2s8waR8xYBLHczVPnsXbnTmP3xWBqeigDyFC6UigsyrLUTvmAW2evG9PqcAVVHXC9ZtXPPokc3WyLr8fQdIqspVByVueOiR92ztPlXNeIIenGXHJ3yW7GzPyUOZdmCct6w+a4NqaEBgfxnOA4ihKBZo+1l4zXATihG62ApUBiZCpJhog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by BY1PR11MB8056.namprd11.prod.outlook.com (2603:10b6:a03:533::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Wed, 15 Jul
 2026 00:01:04 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 00:01:04 +0000
Date: Tue, 14 Jul 2026 17:01:00 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <mdshahid03@gmail.com>
CC: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <iweiny@kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nvdimm: nfit: remove redundant NULL check before vfree()
Message-ID: <albNvKNqfoGIyGcu@aschofie-mobl2.lan>
References: <20260703144851.80309-1-mdshahid03@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260703144851.80309-1-mdshahid03@gmail.com>
X-ClientProxiedBy: SJ0PR03CA0221.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::16) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|BY1PR11MB8056:EE_
X-MS-Office365-Filtering-Correlation-Id: 702d8de4-6fe3-4900-6285-08dee20429b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|11063799006|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info: fxrD5Jv/AXasTDEy4qCT8qLn0bCwDrls3bfWhhU1Tsudv7v5+7dgTMB4qRJrGVnvnLt+xxthYzoGYlcDhBziIpbG64hHqHouVtnsXfaKGzsakd4ftwISfP7UIBHrrDv4omKs66QG/12T7FJHc1oQkFrGxdA7xlKiwW7rYolMDIcBf7Zj+H++JRcxS5vKdJECrMMpvrIT/i5HkeO8gnuQ508+meeKfYlrfoSfcn6AD07NvLiDlHj35LGbV01KR1S693MMQsdFMqb75ynzCOcvmhf14uJ8qlQ+kZWYnrxj4caeCnMBbzXKSfrTYdQeTwdIcv0kgyEBhoELgj+EIXKvfBpsxsmyxTU+Ov58NQRdDNr7PbmNnqK7CjIas+ZSHaKvkAxcnlu1HUt+egD0rwnY23pKro365Wn84SPz7cAQcksbP/3Bqq2P8kDjEwr0uE8WcGWGx/yrGm8D2B2b82TG0LBYhOqdUXbiTlRaZdd9W1zvfmX2vAvx0az+pFm0nj1MhPNzmmbI7BljakXuc2b7UqkSxng5Gv0RO1FCpA17PhactThPhsaLyNk7TkOUUtISpAFsa/U77cHmEzoXkFGZCdxayqHyn6RHZeSADSFqOb8JNfdKLufcEd3Wt3tobDK5zLs7UixT17ik4gSmeQBd6P/vWpaZxrEifK0Va4DbkGs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(11063799006)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WhvppR/OMZLO2gCA9Mz5Aw0P/G83LmdfX7WwEjnudufLB+FhUxMwy2UTaPMf?=
 =?us-ascii?Q?b2MDD2wFwQjxMc4L9FjdQm4GVIysSm870DLg1kGZts5GgNVg+qLEimMMaeiv?=
 =?us-ascii?Q?vXkugFjDHz9kak81xNkqKidy9VwwIFFPWvHzzlkpRHYnuYF8PtQbRVJtlSLo?=
 =?us-ascii?Q?r0aIeyFgLdI9uMhMvfdnKAXwybhqV5Gd3rnesTNr2pd46czIc/8BHCs32vCf?=
 =?us-ascii?Q?0CsUI+Whxfei2zi8RCQ1AHebIrdgwpyC+mcpmtVOSLWxk25DSE5V7/zPjao5?=
 =?us-ascii?Q?zrKEc1Q8fg/9v97CVLH52g2EHJpc+QFFQ5o+st9fWzWkiIOAT+HrmLsWf61A?=
 =?us-ascii?Q?G5E4GXuIRCLEZI9yU4PSZBWfv9x3CH00v7JsdqMihn6TQeANGZ8mKgPOGoHQ?=
 =?us-ascii?Q?4NbSamtwYNQOcES/2kckvoqnaXZ0Zz6D8d4+iSBLDh+qjrWvNRaaUl/WEUl2?=
 =?us-ascii?Q?gvgjm/ynGP1Dh+YVhHXpMF50CZCuTmWf+BEtnXGXrGN5ps25n4zmC7cHwGTX?=
 =?us-ascii?Q?LDEZT/CWidhWpxV2qCsFna2Ass+lEb3/yD17ajLVRwVKXiBseVQ3nyleIX1c?=
 =?us-ascii?Q?fLj1x7KpglkO5t8xtd2cEDlmf+EfrFrhvVSowhQ/2D7rpBn9ZTx2xXAKMHHB?=
 =?us-ascii?Q?DRnSklgv1UVf17qww85Hc1ulb/mwdryBNBcpYaTLAvST8Ag5Pw6OlY1EzCT4?=
 =?us-ascii?Q?rqjvbInTAHPzeu7BS3efZJly0q9hurZz1jRgvy/RdCa5LyegB8AHv803Wy2X?=
 =?us-ascii?Q?u+j+2tWdp8R9giS16BOG4q0hTemePDR6Y52mNtymG+SwoFSIWb5hYzDc8vfc?=
 =?us-ascii?Q?xwHGry9iHJ/WiA5UL9e/ZbcHKCuT8wyD90F8Wjtgdw67mpAPxiycOTDobjZR?=
 =?us-ascii?Q?W82iJ8lZnZS0K8KzaYeuKvPThXDa0eowNANmsjVfE/twVokJpVEQtdJKH7dx?=
 =?us-ascii?Q?s2Tdamx+PyqgzeSWzZz5JKCUNQP8sObvVxpugsgsi5tnNe/w7j3T/VMt1h53?=
 =?us-ascii?Q?02ludKLDUUNvPn/IQ9g+mSbE7QDHSLDjHEqNuGiKlme6rCBvuF6Q/wJmg8QE?=
 =?us-ascii?Q?JV5bySSmUrpRsxsOxLvMa5HJvoaVE8FmYVLozJv3TbwfZojd1USylYXxsYaf?=
 =?us-ascii?Q?E1FcKUnM7LWlFsPLop943fs4C7+mniADMdGJcRLYeg261ZQo9SxbaprKnke/?=
 =?us-ascii?Q?/BGUgB28paPKtlUMhxnV10kp57ikDni0zdT7r1VOq39ArLTIlb7PWTKF+ppr?=
 =?us-ascii?Q?NMSg1rpqQG3OXt1iNbjQO+hZRkUtllzSaVTtkQzlPSKKK1vEX8/nZhk/vL1s?=
 =?us-ascii?Q?sPvkmdhisrXW5fWkZig0xQg0z9a5Y172+wL+4pIn4Yk1IDmIeVf9LPxt/xRJ?=
 =?us-ascii?Q?0Xx/yHWZEEJz1JDM7jdl7XgcUB/0qYq1fEbNy3mKl23A1q+Pihdog1D0uI4/?=
 =?us-ascii?Q?RAtpRbhXfgnfg4P1Yd62sJAZR3hAeCJIe0lxJySUX0k64akoSaxB1AE6rPdK?=
 =?us-ascii?Q?3IiU71WZ30tpduc20z43CScr7c1EpgyLwwXX2MOuc2LR28FuFjb8j76UjEDF?=
 =?us-ascii?Q?AkgCNMti03AnM3kHpvEYqaHF/cjVpUuOfyveQxeCQqE2v2ZaXtqAhLK1CD+L?=
 =?us-ascii?Q?u0EJUOp7jNYtGE0FnW/m8OT816iSQmmFkwB84E6NtalVjeLMV5lsBfTDlXuK?=
 =?us-ascii?Q?kCnNyHfLczkbDombwsOdnh7beMmenPTHKum4IFQflJ6kVy6Uj5YC3AahbAWm?=
 =?us-ascii?Q?RCBvt0k2v2dPiNI51ELqRjMAVNWHBt0=3D?=
X-Exchange-RoutingPolicyChecked: rBUK+s8u1eVU+Wd62Y1aKB93IDZnw1Jsn8uIFgjjbbeTBlYKCNx7UFULaU0GhDSk4wdiWlT0wLe1/lunlL74a1BKpVeHn5vX6Y56fe9iUkXa3gNTZSZZzK0rH8nfv48RH0lY4zjP/1MMOf500ev4Y3W0Q9W/yofAl1HzhMGyy+xnFpvZdSN7XiVSKSX7Q1GlNrTVqLjIjgMb34HhGObzdwEe+8BXZUMFDB+4mBCmlR/HeqNzAnbw94Q/wPcbqbcP+RnpAjdgGyCscBaCTjfnwIswkBHzI4MSkQARu5r45w4YOSOgN8KA8kBC0w1Xv9xV4YA5Td9sprxAwXYPef5VGA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 702d8de4-6fe3-4900-6285-08dee20429b9
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 00:01:04.4167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +1Ip6GejK9H5hRVBzCV5fQrVY1V6R0OGCEqFf7fkLB+sgJUdI5klQ7DDNaReoqNc1oZZ6rNlef/XZMYpzgbPWKUDM94TsZdo9q/yLswb0Q8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8056
X-OriginatorOrg: intel.com

On Fri, Jul 03, 2026 at 08:18:51PM +0530, mdshahid03@gmail.com wrote:
> From: Mohammad Shahid <mdshahid03@gmail.com>
> 
> vfree() safely handles NULL pointers, so the explicit NULL check
> before calling vfree() is unnecessary.
> 
> This issue was reported by ifnullfree.cocci.
> 
> Signed-off-by: Mohammad Shahid <mdshahid03@gmail.com>

Applied to libnvdimm-for-next:
https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/

