Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819C821CFF7
	for <nvdimm@lists.linux.dev>; Wed, 18 Jun 2025 22:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750285301; cv=fail; b=lF4oNt7qM5vuwFcFuu21hSOXPMuONk34RYbo5jsZb6v+7zA+Uk/JRPOQ5nlDhfC5p7p06IzKqGcTqQvajAue/IDbX18h0W3KxwZQRoqwnSWYYjUNQ09T3qf/KgUBVrWd3OXCAJAokYsU8v4JgxeYEWIBjfpuAj4fLKeI9xObPGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750285301; c=relaxed/simple;
	bh=p0gz8OiYaIFACAf0DGUITcFFZyu8bAHgV4bGOorGJc8=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=P/MGQ4GsU7HrpxCHtyakiGbMVBsq/biFIoRngOiqdhFB8VPa1tUnufn+tNA4H6nvdJOMCYZTlB9AKZY2FVLYNkPtFzJX+rIg2PgdDeR/wEfKBxOvwXTdOmOZZdGpNWtk+KEfSQj4UeLVlkifF8czKrOaTOaw7WNEMV008tiD7aI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k2VxjZIE; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k2VxjZIE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750285299; x=1781821299;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=p0gz8OiYaIFACAf0DGUITcFFZyu8bAHgV4bGOorGJc8=;
  b=k2VxjZIEdAZKXb+2oTSy4uuYZ9inN8GVsfcraSmfsScNuoS0nUaZN4Gm
   YuedrtoGaeUP26UL3jy+PG9qx0NWlYEpdPipg8xEY7oLvPRAuiDR+Sy0Q
   C01nx7BBJtLEVJcpLPLJkiI7as20NvJ2+YmEi5iAG3LZmIrDCsLDX57/i
   fut092rAV5t7/t7inFMlVl0PoRghU4FXf/6pIIYWhHnIea3szoJvePS86
   lLNluEYf9Vz4wPjvAwGH7jeAn0TAUE2R0+ZzOXdvBwLlt1T+NQsRn651l
   1WoxkHdlnE6e4CI4zjIHUsp9dtT54u6Wtw7Mt2PFn8USGjkrFLkx/S7cV
   A==;
X-CSE-ConnectionGUID: kFX3o1FVQmKJ0W+gMJA8eQ==
X-CSE-MsgGUID: 8dEP++ZYTaOSRc7ZDaRIkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="52609632"
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="52609632"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:21:37 -0700
X-CSE-ConnectionGUID: J90B39t4TLehgt0A3owZUw==
X-CSE-MsgGUID: OKLLsg35Ts+ONcUPvLlIRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="154806009"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:21:36 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 15:21:36 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 15:21:36 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.40)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 15:21:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dtahE/ixkpkQtE374f1qIKtt/KaFI8LB+Ckdu0pLF21OTl8sGcpBe2ikbM9q1SXdDoLJSwPdcWr29mA6yJg24YJ1PQ7FC9c6iOv/L+Vc4LPMrUFdniG93iInni3seFmGZ6jzkA9Xs/r8jittTy51N1GJTegmWWgnZO+HYbIXFWD2XYBMav87P94J+AgA976Hb0MO8BBSIJIS0etq3atobvMakCIKm79g5YXZkgeUrGbwBTVuie6rqqsrPXhVKi7OaIodo3WzBjDg9Gvt0vWD4GWDhFGAvHpQ30IQwqYUUFQ3iUwZwe883rHiE/YbSeTOl+Q3Udk+0rNHdDptjGCwgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eDPPbPYLPAUpclxvpkZ8Ae7q4DUbBOuKAykJIFRRP5c=;
 b=nP9sl7Kf3sEp1NRJHG5y/cy6FE+E6pmWikiH8FsPa2g8aFkEYR6Ko6VeLIq3Ykcvt627V6KDsMrP5v2u4xqvgO2pKnY3jSWEEq3ZmZ39mwle45+27+jcBnolF/O9LJkho0Q/3ZL25XHhI0zVUJaJxD2HjPgRGMW4gfG8YhL/fVFL9NIH8I1/dtOXACoX/jCgAf3xXhTlAAxzaCSBxaOrzn3jh9jmyYUDHl6TKVCwBnQle5sOJm5N3QCrFBeB+9d12udPRBQRar6bKApcNt9YX/909qzHZopXSyD7tQPqA0bhcDsUXJrf2sdUTgW/lYuXuSnDa1ZHQQ2ZLILCs7h0Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SN7PR11MB7668.namprd11.prod.outlook.com (2603:10b6:806:341::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Wed, 18 Jun
 2025 22:21:33 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 22:21:33 +0000
From: Dan Williams <dan.j.williams@intel.com>
To: <alison.schofield@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: [ndctl PATCH 0/5] ndctl: Add missing test dependencies and other fixups
Date: Wed, 18 Jun 2025 15:21:25 -0700
Message-ID: <20250618222130.672621-1-dan.j.williams@intel.com>
X-Mailer: git-send-email 2.49.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::28) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SN7PR11MB7668:EE_
X-MS-Office365-Filtering-Correlation-Id: d3bc88bb-81cd-4916-e9c2-08ddaeb67b1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?R1S2eR2Hfj/e6I87ESHpGEuLGJD5SQZwOxQDmAF8OzsdPO07zGWeu/KD7c6r?=
 =?us-ascii?Q?KGrphgBOBTQWFk3LxC7SRhVEJ34L1cO4GeMxf6LH9wNy5E0kTBI+IjalybZj?=
 =?us-ascii?Q?ZgiUQkTOaDG/5/RddHViolNdyn6yDKykk/dcfiVn7o/LBWm2P12ZmanHoclJ?=
 =?us-ascii?Q?BZlnV7AgFhKB8hF1vm5aEpI2RY+XK6NmVd6VXWZ0nizTuOyM8EyxGru7o6Ih?=
 =?us-ascii?Q?71mzHg0/+ZWJG45YKmyrySNc5vj4hNJvkTV3Pqiu/ugj4Q6hdFi6uY1icfmp?=
 =?us-ascii?Q?5reOY4wPJ1g0+bH0zEaLDqHT0wbLRl4gaVpSJfo1RN0IReZkCA9QHzmjxOSs?=
 =?us-ascii?Q?yfaZvz5ci29F5hMI2Lq/uPt4FLyqk3NCFzErnpILEC40O8YcpI2+EKYpQe+3?=
 =?us-ascii?Q?bUM3tTWjYn/SCIF2fKCkXoZ3ZR0IdEextcDr7x3PUnVxshCPcKWDHmAh27mK?=
 =?us-ascii?Q?TL4hUxEHbsd1Mvr1SawDWq61XzZcW2bR8LGlZW6BtAkB3JCfp8yUX7pHt3Dm?=
 =?us-ascii?Q?erXj+eQm7LGSKW/9O0YCGHn1KkyJ+inSwlLuQj1MBLs66RQ3VPKba8tLp7Hp?=
 =?us-ascii?Q?DB01L70oTjrUhh3zVDIVuViXJkDW/mwGxU6oTAAgS3CJShcxgIr5zEx23NZ9?=
 =?us-ascii?Q?ALQPm1gj6LvIzP/+yWOyO/oekIpW+d5imCT2y8qv1qdfeugzIVdLPkFUeKcZ?=
 =?us-ascii?Q?1tdY2GSpYDP7YygymmA27gKYLeAxcWX/0hgieMNDO9IrA0gw8tbwuihZwWHS?=
 =?us-ascii?Q?AYkVDm49H1XzsuiGLtOnUy9VR6du/1ss1+9bj3WF3VyUMtuFL0ofHgzjvuJN?=
 =?us-ascii?Q?sYpw/3HNpPN+HRDU6X8JfZoS/hGvqXzYantx4Mwxc4nwTk0pNDufcK57ZBD8?=
 =?us-ascii?Q?DnQRJcTHSkF9rLPOzSb30euG3+HVCEhCfur3hryosQbTzTO8/Dqu1IcrcYTK?=
 =?us-ascii?Q?xmHMe2ReCke54ZyO2jC8cFFwjP6KepwwBMngFmG46HLwTWB0OrMqyT38BDKz?=
 =?us-ascii?Q?pr1Ayct4GY+pphYFjufZBBN4r4aLcKOsGxP2JGu7Uw+j4rA6CAaRMD92NCIR?=
 =?us-ascii?Q?iYPtGIXvvU/uzDAgA3gDgT3EOqem2lh2zC6W9RRnYJlktX+E5D17DJIUmbj+?=
 =?us-ascii?Q?Q9SC9iMEimg9KgiyQU0LNENdKQBt3i97GaEKpUR/t2KqWQGg1m5uLqI6UfK1?=
 =?us-ascii?Q?WNvI+u6iohezTxL+LILvtZLZJgP9feN4LAKhLzWZrkfGzc6p1owsVPUDsr/d?=
 =?us-ascii?Q?D9yGoObog/vgd5cThoSRDlIIluf8Uxvq2j2oPP0T6Ug9q7H1NzHwsFpSkgvq?=
 =?us-ascii?Q?uKwUJp1OMbMx45E18/UdaTIzfgayNOoVVPHcyFaGCc8rbNEuYYRcxRr6h77R?=
 =?us-ascii?Q?eDSRwG9B4BeaFldEAEKXYG/dfVlPs6HSc/iLFQHmuCmdd3DfUn9isIZEYpnl?=
 =?us-ascii?Q?+n+yOk7t6xg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OY226DPYNFK3PB+LJZwTBnbHc2XLtGGsviNWfok7rteiZHMOKq0Ejo5i75l0?=
 =?us-ascii?Q?advSmR5cBUpe71mlcBDi0b1xgOSaQNNXSvnHtCGe9yLGFTtDhfSzq+cO1YOU?=
 =?us-ascii?Q?CYwLNAYfABPKCq9bsOErszw12afxus+J66l07G/MwygDT1ZTM0oNsDz6o6iQ?=
 =?us-ascii?Q?rZp2xPWwks6+XAS0vFDvbR8HmU/+Js6UGJj//j1Xb00suP8v+Jc4WEKOug9G?=
 =?us-ascii?Q?bJ2RC21r+ETRRulfbOaYipdhAiCrxndGFpzsNsxDthDkShsYluWt6Ngb9ql0?=
 =?us-ascii?Q?h3V64mI3unvcXrJaL4UH6vk0l5JBpfDQ0CUKZOsKW4gcfFw3hoWZ0th6ZzKo?=
 =?us-ascii?Q?8aWIUCh36oiUE8gXI/Fi4oJSs9I8kaZFqkd9aA3gJPYx8cQ4uZiBINiuCput?=
 =?us-ascii?Q?SbsQnKQAUezLr2b44IOEhqJEJCJfjSwfxX7BDJdUytyVBhk5PafBPGU+Y5r6?=
 =?us-ascii?Q?D46uXazmYTuPxoxvNtkg4x/O/a2Uftq+VpjODItd/oQ4mJSSXcfVTX3aHRZ8?=
 =?us-ascii?Q?ZiYu20+ZXtdcF55jLFWg74c2/fnrU648TdMY1UE0HL92CHfnO0TojOCIZcbN?=
 =?us-ascii?Q?+E4tbuJoAlcALlxjsx0exhcDjbzjmbnj9Xp71QAeMB9vQ/xnMDw3moidE3aw?=
 =?us-ascii?Q?mkNdwM2J2Sc4CysO6GWvCdxeneskHv8gTUSkwXPFSjd9xdGAUH9J4bUw07lL?=
 =?us-ascii?Q?la0GJ5lrC2LGnu3xGp9vSF/S+tbABm1iISdEFN32+JSJgK7RGeipax8pUj21?=
 =?us-ascii?Q?MsKcxq+TCBJmNip/zrw853bVu1QzdjxpulNb5VWhFsSz+jkz7JB0yE1ZTPWL?=
 =?us-ascii?Q?a2rQYydD2Aq8TRN+YAv/GYmIKOEy/WdkRoqJnG54Gk4I/Hu8YX3w5sroIV4b?=
 =?us-ascii?Q?aEFPgEi0J2TiKAmHp1wI5hlkZAhb8FwoI2tO+bwhIVn4DZz6nolj3I1r8Ov3?=
 =?us-ascii?Q?GAlXrGwPSZndHR2/ZR7Qz35NZl8Uyt/QSjnNoMdh02i3G6e/BDxuIQZWG8VM?=
 =?us-ascii?Q?alSZ4X1v1PFNhE3UOjSYQN1tMsn7p2G4n6usNi1o/eEMZQLRrQ+X1Eds+3W+?=
 =?us-ascii?Q?6SgrIUKowByrKO8uAqDRjxdIPMfoXyuPuSTeFJmQ4rCcKfA7RCs2/9OSIZVG?=
 =?us-ascii?Q?9abfWqYfPazQYRfgZWVuRY2VK6d8jNwnAjKWM4Affhxxc0af95XESGHXDnkT?=
 =?us-ascii?Q?0bLAfU1if4XRs2AA7vRiJE0DI50MSDg5Q0SJ0OLXRom6TZHsHqbgmfOndSXQ?=
 =?us-ascii?Q?8ulwlP7Tuf2LfMj5KR11/xveFmc+q9OgtAwrqQBDHS1oVNJGYtgfezAJ4Id2?=
 =?us-ascii?Q?OlnjQ0XZyGfmJD/n6ctJ3fMBgPe1yO33qVeksgJcZ0ZhPFtV5DeMJEsO1Mx+?=
 =?us-ascii?Q?AaXbuXiSsr8e41bOR+vwoMtR/NWDSQx7dbdoLjKoOcgwg8J6qzIGh955PFCJ?=
 =?us-ascii?Q?7byUYKj4HMl0qryS+Lu2ciycRgDjSvj5pZA/X0CmgwtAh/pmmnQvm9plS3Rd?=
 =?us-ascii?Q?oFFNleQ1gpyprOaLqHSkJhMozUgtLwCj6D6y1Zj6HNu1Fl+AO8/33ugCdo5h?=
 =?us-ascii?Q?DoEeoZi3B+S73k02LfGugBo9JWhjENsr59N+hI4yrTz35TNsB1Lx6788dkX8?=
 =?us-ascii?Q?rw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d3bc88bb-81cd-4916-e9c2-08ddaeb67b1d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 22:21:33.3074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wlVQ7EWXTYS/ciN5XyJLvjaNyjLz4F5aqR06VLPEk86KZ77cr74HVvud5Dr8TfBstGHOosuczOVTnySv+RlxYQFz9FPGCbm92BqxJLauezc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7668
X-OriginatorOrg: intel.com

Recently I stood up a new test system from scratch and discovered some
gaps in the documentation and the tests.

Fix those up to get all tests passing with v6.16-rc2 and latest version
of all test dependencies currently available in Fedora Rawhide.

Dan Williams (5):
  build: Fix meson feature deprecation warnings
  test: Fix 'ndctl' dependency in test/sub-section.sh
  test: Fix dax.sh expectations
  test: Update documentation with required packages to install
  test: Fixup fwctl dependency

 README.md           | 5 +++++
 contrib/meson.build | 2 +-
 meson.build         | 5 +++--
 test/dax.sh         | 3 ++-
 test/meson.build    | 1 +
 test/sub-section.sh | 2 +-
 6 files changed, 13 insertions(+), 5 deletions(-)


base-commit: 74b9e411bf13e87df39a517d10143fafa7e2ea92
-- 
2.49.0

