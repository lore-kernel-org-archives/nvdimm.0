Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F785EAC7
	for <nvdimm@lists.linux.dev>; Tue, 17 Mar 2026 20:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773780953; cv=fail; b=PJIETD8zFnVTCPlXS81vWrvMbh5tM5ZooaHYqxyO0RtWJb71vjsv135bEtfrkxG4g8R0t9Se3trTzGs1mAifcSfwc9SUQ8DGWudtWI1tITT0vyw0E+CpF3xLF/6ZihZcXLyxTI9GAax9L9rmaac4APp5Ih38/wQd4PRLAE3Y1NE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773780953; c=relaxed/simple;
	bh=hPo04zUHAAAQKFyrlPDIRSbz8jtHjs/wWnqO5yRgpec=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=jwRkkMtDpqWrBr1kS3sxR0qrtZUUbs2oe2C3qi6ObMhZKiHqWVt88oXydrIWP1bH9iUGejkueVAMMtsebcA8IbU+MycxMziAQ7F3gzcRQSuqJ6wx9eR9XEoX7Tb1DxVPekNTJoe4fCajbR5n6tIAzkb4pDEfPD1kbVDI0DolQAk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BiTk11ls; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BiTk11ls"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773780952; x=1805316952;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=hPo04zUHAAAQKFyrlPDIRSbz8jtHjs/wWnqO5yRgpec=;
  b=BiTk11ls6fFcURTp+tkjZj9gIsda4M1Ognv535JZ2iJE0BuOWoKW+oWj
   GxMDMhdVIM7xYyZRpYKWKi/EeieWC5Q05H2U1qHrwkJit5HeirPDAWrYl
   iBVCGoJ+t/SJtEutg5j5I88aDqEk7CaknkZHzhZ6JdinnzBXkj+4SKhIa
   ckOnW2iLohJuGNMSoDDUmCsN7XX38ZVJ1SouJ2sCAk6VJeXl0q4KCyjJO
   gilyc6xYEsm2ptY2yDRn/TcMV/qok7PXAWB1RgArLOSjwl4s66LDG5yFL
   fsdQrwukfQE+ywhYSJ8xdBBv++64wp+OFo8eSvZCRMORs9wy4mhTm1zyv
   A==;
X-CSE-ConnectionGUID: xZjfg4LeTmSFH5YdkhAbBA==
X-CSE-MsgGUID: gh3kcuelTuC6VxG85R8qyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11732"; a="85459093"
X-IronPort-AV: E=Sophos;i="6.23,126,1770624000"; 
   d="scan'208";a="85459093"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2026 13:55:52 -0700
X-CSE-ConnectionGUID: IcGeQK3PSf+WU/MiJ4dRzQ==
X-CSE-MsgGUID: LC/2bKgrTXehycL21t2mow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,126,1770624000"; 
   d="scan'208";a="226531676"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2026 13:55:52 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 17 Mar 2026 13:55:51 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 17 Mar 2026 13:55:51 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.13) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 17 Mar 2026 13:55:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EWQAp4WI0OCaBWS/yPPObjh+DtcL8vYJuuhiALINs5gaw0oqAmxOF1BbMnKr708fYViU9gGT3fBt7AFB0mIFwrVn818HG1bmgDo4MD2wo/KJhAKUECIObEnnBsqZA+VPVYIHSfwxfgeSmRu++hV4UOJWHSWelFyxDi3qUYcwHgq13AKOBKzwA9pqjLO69GQ9s+VAFAGOs79p6o3eqeEZwJ0rRpcEVwvZMErD8MFDCmtKkhaAb8r0e9Ajr1BSbTE2o2P5puRuxXsn5DkOe4opJ6udHtbNqyhaDe4MV+3J7UEY2ImjDNTPznpT0aoJoGLApWU5IWRWBRQwShEZe0SlvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UDA+gZgiTmO4+RXFjaDRbu5pVOAHdQmCV8OlMAdrHoY=;
 b=TVqy0DIMA0ZSQ23ZCDcQ6ta80wmMvLdz/A2iWPtGgn+uly+pCUUHbX6gpagUkukSWSFw26EII4PCwp7ZP0r0zvaZ+ieNasyQvR5NWS58xbRlHSglINEzZZ0Yy1SXZ9B6U81UWRnl5+Al4ob6k6jCuKboHqXdx7niCZXps13gvH8H0lwXDZM9IFsOrUS/GNU4U9ugfB25dHQNpFuPNX6ieJfm7AYd7dNAtYKHpMZiMvjEqWK9SeBMCOQtZy+nVrVVabZQrnZg9KOCawiQMMDFcnUDAgulM0caPH8Vc9PnW35n83502w2HIeX/cDxhsQ0/sfS3lYo91898le55T1I77w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by CY8PR11MB7947.namprd11.prod.outlook.com (2603:10b6:930:7a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Tue, 17 Mar
 2026 20:55:48 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::e67c:ef48:f469:e337]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::e67c:ef48:f469:e337%5]) with mapi id 15.20.9723.014; Tue, 17 Mar 2026
 20:55:48 +0000
Date: Tue, 17 Mar 2026 15:59:30 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dingisoul <dingiso.kernel@gmail.com>, Dave Jiang <dave.jiang@intel.com>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] NVDIMM fixes for 7.0-rc5
Message-ID: <69b9c0b276c61_290b1007c@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SJ0P220CA0014.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::22) To IA4PR11MB9131.namprd11.prod.outlook.com
 (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|CY8PR11MB7947:EE_
X-MS-Office365-Filtering-Correlation-Id: 51f5c20a-7e7a-42bb-cb4d-08de846790e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info: pwGwwGfpnu5IBGkjrGSjfsNMWvJvRenOXPXcnfw6oA9V031E9WUnpljz6E2yKF/an59SvEkDVg3PHwY4Rw/w4DOFWjnP0Ly4TEmpNllnZgeGrWZSpigVyechjnjwP5rPAD+L2ec8psyKlp/ekZ5YcYBo676m8uB+4a8LevQl4VNffLmxvObn2wRtm+LzWreVPgld17d8uP552Kitusb5AmgTxhfDba7R+YmQK7RV6Db5jbK4SWlS0zDR3nhgTTf9xRlSAM3NoIKF/8ARva4pS/LLiiXE5i8qt9kZKL3EGUMk/xb4c4FYNiHgNt1edmFDA//Kde4rAsi80956UiXcPlFRT3xlrURwva7+x4NDGBgxon8BbBXVaX8HD0LaDgybGyQs/+gggzNxKaE16JLlsq3afDForrw9g9RbFM9h+TQXq4FLgjYpkcpJaP6+ZXq2kz5cjMjktyMC9XLHGBpwQGrg5zfjTnyC+3Me4NuF2/vb7hi3XBUgHfUqlds33VKFKzpXTuKu9ICGbY68oj2SZvHf4isa6mcAvRdfm0/+B7J2wqY/p6vmdqQKjV7cZ89f4CpYOdfbIg6XLF/dOwu4DC47p2w5BZNIAx40yseWq/fDpQB630M9bZJouPQ8a55VAXIau/U3OsN0ddx7USkxJwM29ApIKj0xUkHPc4oCZLSYaBF1CezldxXHZeGQpmzORTclO4EeN+vwqv3uA1iMWoSrVrqu8N+DKimG+xGokJs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6QzXBdq9RSmj/xn/yMj4bka0eHaOA7pOjpmD6sQSDtCr+vOX76rQQhhq5LR2?=
 =?us-ascii?Q?bR2q56j0kVnFKXC4NF2nnbCVcmTNju0w4uX8a9xQnP832mWcSqMgpw3IjDOC?=
 =?us-ascii?Q?Vqp7be8VudkoA814LNavVrNoevuvAnG29Ow2YMS4OBP/OaSX9kIZYY4+8/jw?=
 =?us-ascii?Q?5yEPW5SX1W5cJO76wQsjn/YIWYSCJmhjvDyj/qbZc0lgYxzQV0wOjqtuCOVp?=
 =?us-ascii?Q?Oy4bK/mPGI969kBUHUGPOR779x93HhLuJenHMlYy90hhUVCDSKUewq0DfVjh?=
 =?us-ascii?Q?qzOJpm6pnh2kS70cPhR7zQ13RQ7u3uzrvQoKEkFDB9jBJ1irM2z0HBcnarMx?=
 =?us-ascii?Q?xgss1JzBMNpnFXFj4C901MXMMQX+Fsvo7UsBdpD6vesvDdJLmD7h2GFAl39R?=
 =?us-ascii?Q?weD+WVTzEexVjrIeg9ZiysXOTIaKeBWlhtl/E+BYbj7b/W3ShiFtGM+tNHzD?=
 =?us-ascii?Q?4weL/VYfHD6h7XaUxDoKpK/49abK+lwYOVp7PWUC7Tzo7HIsivV3lnKDQE3c?=
 =?us-ascii?Q?Y4JhhOCm+wMu9tvelm3P4HuSRgLUzoeQHEuQt3Ugj+7TUJJfcFPidDmTMAiA?=
 =?us-ascii?Q?6nWRUi2Q10TdC5BiypJYaXQqvpI7OxACMY6Z+WV3ZITtPtpvfSDMIEL3dB5z?=
 =?us-ascii?Q?L2LHX8rBmsc8PVbfZnbRawfCJZ9/yto8N8DxksA+ElEg3Tu3cst1ayjs3KXk?=
 =?us-ascii?Q?UIrgr+YZyc5GgK2BhyuOsDMPjEWIeUG2GW2xRaRkuUZaLcGDQ4o9BKySx8hr?=
 =?us-ascii?Q?9Tuw1wC4s85BtLc8HOXxleqzCe/18SvHZB90u6LdyZ4GornV7Tep06OHLJF1?=
 =?us-ascii?Q?BxPTk+cnnHoKTf2I2ug7SaJmd+9CK+wfZ/3KOdK7ihs0YdGTdfcJ64U/yBH+?=
 =?us-ascii?Q?Ek0L6lNAF5/Ms9kmY9Wnxo9JqJJPEsWYnQlyu96mSFR8wXIH8tvXXJIMue32?=
 =?us-ascii?Q?72kuKAOoH2Rwvo0kg0zrXn3hnbS24Nz8luBLrVMWQCqPf+tv8+io5qjqDq6C?=
 =?us-ascii?Q?AHfjfCy7e2LHkdt1XxbLO3Rs6TLVhHcv0VAmfy8qEbd7BNmzV9HslPYKjQJw?=
 =?us-ascii?Q?1A+7PETQpf1lgbIc9vhfDz/fIdMnuD+12BgaYu8uI/0XvGYrzZ0OSYtIORr3?=
 =?us-ascii?Q?1U2fkyaqL1lfxaoxyDa5CW8pRI6hzyUiSNralR9ueLYaFfyZxjiXcrcbu9/e?=
 =?us-ascii?Q?PQaiX+H4rvKXpZL9iQEj19ZIWdgyR5YM0T1c0IDTGP9EDlDf7DFizoxU4QGu?=
 =?us-ascii?Q?FTbmzaL0k7zcNDcHcARH3GBdHnzD3PAe+WaFfDEn5DRGjUCM+aRBVyyq+s7k?=
 =?us-ascii?Q?Yxy/+3kTf5AzmPGu01wLGgyepQzDyxJdUcTCvkh2OurZdsuVqt+D9hXusLB1?=
 =?us-ascii?Q?ns8yLnjRtUzMQhOuCcVg84aWI9ag33ey+YB0KD4iIiRJ7snBPw13RJd+qNm7?=
 =?us-ascii?Q?Hrbo3kc3vxnSSj5yl+Qz0e4ppkmGLDrVvqNE0KkynghEGKeNM7gP3i/n3Yqk?=
 =?us-ascii?Q?y2nTBLuywxj4S7f4iiZe4+2NtgtuTgDZjUMJohcwOEsH8IRVzPfwT5GAG70r?=
 =?us-ascii?Q?+o4z4pPjjv+Io5qhHuWh13+et5u+i33rCSZLyQToo88yCg+9YXxctKDT+N44?=
 =?us-ascii?Q?gj0xy30B245E5FpvslrLZzm7hW7NJlUzC5Q5iHNn5KtvIjxoQzeNX2tU000S?=
 =?us-ascii?Q?4VJe/523rKgTTIHQnJLeKf0vN6vE+P0BfqNIIJrw370cz86Hvxm9ho0wiT59?=
 =?us-ascii?Q?KVtX6zqmvA=3D=3D?=
X-Exchange-RoutingPolicyChecked: v6jQ7U1nO9IflllTNQ41xXObLgXzhNOpGi7LQHpFAYvNHkq+L0Z5EatJW4HjwXAAD+G4BHSR/1l6BVcq8Vimnara2bgZ8/fa3Xp5vFBmN4Kgr5rpK9jFQo6lnJONorYVH7prlP5FIkj4zQ0rLupei+yE6M7Q7kAgVJsAXB6E6VkrphBTNUjmac2K79xq2aFEYCJuKZB/LzmJfXFnCUkdxfv3U6I7jwNDgvmKVnIms0VFvZ7cjkWt5hIrNaUkpFlHzGIqRnPG+JZa/UcfZ+yjxJD2C3vCBxYJnOW2ImlxADyctujuZvbHftE4Dzf55p2QtUsljx89RDslA+1ALheQgQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 51f5c20a-7e7a-42bb-cb4d-08de846790e5
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 20:55:48.1915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: APwJDCzdZ9QZPZlxO9+yiiS+ESBWva1whJkUX69mc81cy4p8bzHCoT66ouSVzz9MzKWRjAvqscJNbIKkf0Xb8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7947
X-OriginatorOrg: intel.com

Hey Linus, please pull from:

  https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-fixes-7.0-rc5

... to get a fix for a potential older bug recently discovered.

It is a use after free which requires a memory allocation which is probably why
it was not seen without an analysis tool.

This has been in next for a week without issues.

Thank you,
Ira

---

The following changes since commit 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681:

  Linux 7.0-rc3 (2026-03-08 16:56:54 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-fixes-7.0-rc5

for you to fetch changes up to a8aec14230322ed8f1e8042b6d656c1631d41163:

  nvdimm/bus: Fix potential use after free in asynchronous initialization (2026-03-09 09:38:22 -0500)

----------------------------------------------------------------
libnvdimm fixes for 7.0-rc5

	- Fix old potential use after free bug

----------------------------------------------------------------
Ira Weiny (1):
      nvdimm/bus: Fix potential use after free in asynchronous initialization

 drivers/nvdimm/bus.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)
