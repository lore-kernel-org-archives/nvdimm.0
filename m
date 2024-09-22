Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579488C07
	for <nvdimm@lists.linux.dev>; Sun, 22 Sep 2024 22:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727045961; cv=fail; b=QrqzCV0BZITeUnI92zMZM9Y03fJL2BhJXnH+u3lAio2r1w51s1QyyANsUM+F2XiLiWBlnD36rMIs9yf45TfMXd3u/szbDWLVuS7p/gK09oOuFxDY8ym+l/DbzD9uVmAT1qKHMtiL1+Y/9xGCWkByZiC23ETbOc5F5ZtU971yOmM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727045961; c=relaxed/simple;
	bh=ucHBFEFnlyviifFWUP3hIGlVHNzSa4a2KY9QZ2s3T8k=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=oWQgxr0kY3OPbS4ByAWYBjyO1LOOkBKVTR33rnSfitHVB2re+vjGqoCMRaKB+FTxvWhn6HqFymvQp091Iz6GtZAE7auJcYWKDyVDmLUjqrrpZ02y9r4x2cYZetytEGL5h6kOTWCUAR8UvBGXY3YTN+QQwlEQoXQV83rArwL9JmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kpe0FGYo; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kpe0FGYo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727045959; x=1758581959;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=ucHBFEFnlyviifFWUP3hIGlVHNzSa4a2KY9QZ2s3T8k=;
  b=kpe0FGYoe2qc6z/gDS9E9ICAhxWJuAvKGVGq0a3KgVTaJkglVzJbiBK1
   tjGBOBq8A0+goZIPtnDnhrFjuIHAuQPlxsw6DoshVKjymMC0HWRwJ4SUt
   jMVGB1xBY6S+vha9bTybz3II9DtE7QBKVAkJbyybD8WgFNkrmafY4vqbc
   iCx63TeUSDrtrlLFAS03Nn6KLZp1LW7k+6I3cq+/xg9hvDQhHxS+rL9l8
   UH0s4a9G0/5FaVDc9cusm9xybd/JWvo9D8Pa7UgfhMfOcHedbIGZ63m74
   sFdlmuYF0P/dTJjGL78duoqBWoXYV4nYUeRle7eNPyT5p1KIGXImHEDt2
   g==;
X-CSE-ConnectionGUID: 0FbKM7fQQxeGQa0B8/feeQ==
X-CSE-MsgGUID: et1gGWgwRWaNLIIG4Wg84g==
X-IronPort-AV: E=McAfee;i="6700,10204,11202"; a="25847642"
X-IronPort-AV: E=Sophos;i="6.10,250,1719903600"; 
   d="scan'208";a="25847642"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2024 15:59:18 -0700
X-CSE-ConnectionGUID: 1ZZcO9VxRomOWf/Qfj0Yug==
X-CSE-MsgGUID: woE91IbUR8WmfPTalsi0XA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,250,1719903600"; 
   d="scan'208";a="71322121"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Sep 2024 15:59:18 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 22 Sep 2024 15:59:17 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 22 Sep 2024 15:59:16 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 22 Sep 2024 15:59:16 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 22 Sep 2024 15:59:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YqcsyD06/PSCM1GWcfzpfVwRkw/AKm/rA/0UO7rgLfgofK913BVGlIbKmUyTCmDNv6EIIFFPY5XYHqhBOZY2mwrE6yQ0Xghn+KMMnT/OMyKbw7QTYe8zzb1hsHuZSK+hjAPAIKx5tBx6ivh5O7Wpkmga+G9p54k/gIC4DjbYEaS+0KKrmL8coYH1r8OzExeGijq0i09GT9xkbzWGAVux0mK0dAOYaebLK4dbYuYVN4kMFMFA3D+e4vamm1oQeWKYhCVyaFzByMMczramPc5JB5K10m1ctxS6Tnwkd3t04rye0zODqcMUNTZZfY87yFni/wHSn77wjtyJ/D2B1OMm6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gUw0iDpLn3GemAHa5IavHKoHhKTc+WTmmssQXgas5iE=;
 b=tTvmNsRCT8k9B3/UUaG7HEr5owTvqsq8z0U7OtS/DjlY55Tcoim7TpayK7A2OzsL8odASjL+RlhqMqGgkJdPjV4d09AN1p2CVaiIb8S734ZZtmYKFoQvK2DV4CiAp9vg159BBRyyapgtttdgJUAiC8EsBn2eY7e/LpucyQalTpXKc+KVjcANjFgPE05uTyY/50ZWwzXsbFC3QWHpYwCOrZF13JgHfa2TIAvflqPFFRt3tV/TKdsZe0kVxQiMlgX100ii0kab13W1VL+AT9DbdHfETSJ4AjQEAIpYfuMPoZSCR3MbJrUozTyek/1jL4RuRC11qDlC5czf2PKtgnxHiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SA1PR11MB8376.namprd11.prod.outlook.com (2603:10b6:806:389::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Sun, 22 Sep
 2024 22:59:14 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%3]) with mapi id 15.20.7982.022; Sun, 22 Sep 2024
 22:59:14 +0000
Date: Sun, 22 Sep 2024 17:59:10 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <nvdimm@lists.linux.dev>, "Rob Herring (Arm)" <robh@kernel.org>, "Li
 Zhijian" <lizhijian@fujitsu.com>, Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
Subject: [GIT PULL] NVDIMM for 6.12
Message-ID: <66f0a13e3c35f_26135129411@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: MW2PR2101CA0013.namprd21.prod.outlook.com
 (2603:10b6:302:1::26) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SA1PR11MB8376:EE_
X-MS-Office365-Filtering-Correlation-Id: 90179a86-fc2e-41cf-dab2-08dcdb5a2d92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?oXlvWpR5iWPGz2yxKAQCsmJZovgNerEc5GqdR9LoNEh7cECugD1xub7bgl98?=
 =?us-ascii?Q?d32Ovq38kZ3D7RTyAbfoEgSr/F7zyJ1z5O5m3VovD7khefA+YTVsuAkV9Vuv?=
 =?us-ascii?Q?e9zPEgFh4aWgb06byMsFD/QI/rjRfGWfvcmR82xFph6BkHzQqPFZCU1Lo7O2?=
 =?us-ascii?Q?OBtT3mttcJnNJlYLq9v1ZYUQlVubWyf06dGGI2XrAPDqs4pUT0775a8+N/JC?=
 =?us-ascii?Q?2fE7r1euN9CNdqsA7+INHLrP8SEdsHTopypa7tPywmuaLxcpGDj5QR7FWIS2?=
 =?us-ascii?Q?jqwiwVBJigZyPQXxBPAgsZe789QaHJLatBpYiBfFIhRkIKN2WkkUspoXPNN9?=
 =?us-ascii?Q?KFpObWTsLWYpzXOiY1KxlzqRMyY0wsp3EAHYlO7ct6l+S+RrPtvcG8P0ca02?=
 =?us-ascii?Q?rLgaNx9urVHMF+dTtDhUzcrEK2nZAfeHL9Un+zWYY27kT7uicXErV59X6d0B?=
 =?us-ascii?Q?l4Bjzxeda3SK7bgoo3cJrdrTvmkwh2pzYfq71LBJ+E6ygRihf+S3gzaqRlhi?=
 =?us-ascii?Q?C3NPVANDBh3TWGhth+zz9at0WP28FRwN+V+YoiRa+Y7VytRsEnIkZtCB4ZqB?=
 =?us-ascii?Q?EqA4su5OtFwNtAgdPWl3v6lpvpJ0kBS2/MxoXeRbPaWOivMsYOVcTGBxVlZq?=
 =?us-ascii?Q?Ymn0fy1HvZb9q+SB9b2VlqCpd0w/J711IzJdY+hqVv61/1GrvseXsDKq2oP1?=
 =?us-ascii?Q?OpLTfjdZBbWSyPIHk5LmybM9LDMBq9kXwZaPTnrwceBDMT6zE3SGCSzO7q7B?=
 =?us-ascii?Q?0/8BVnBofqnRoerckBSOcbRmKiuc5f0YFNFaa5SOnPx1kEv6030nj9M8A+y4?=
 =?us-ascii?Q?edbKLO6eS6fsejeVXB/Y6ofK9Ld+zMINkpaUXlUAttEqvuQsExc3TKn0vnEF?=
 =?us-ascii?Q?rTqPx6Z5asweInlzLYmkVmanjduFcSPxCW1H3uGas7k0cTGT+7UloHyXrFNt?=
 =?us-ascii?Q?q1slzTKS7m3gQTbnhP8wWHEY7epN1Mf+pE3Ev9Rt+b1IG6BC3ViheIHXa4/l?=
 =?us-ascii?Q?ClKmfMUT2VRFicYrSV4WG8GvRQbweZyqU0qmoPGre6dTE6noZ0fFM5rYCMHR?=
 =?us-ascii?Q?Axfjz7mw7NunncjLgkhj9OviAmw1wHuqQiutuFLTtwtPJo7Cj9auNi9dOsbE?=
 =?us-ascii?Q?clikapglK3mOw3mTofvSXlcDkII4FVdsnOqrzwIJpdK/fr0ZAo5NEuvvlM9e?=
 =?us-ascii?Q?dYNEvXGZeyTc2/bs5t4QLq93lEnzn+gQtwARwRo1SN2Wi0DFSE77EtROhstJ?=
 =?us-ascii?Q?yct7EiR3U4coNoNQGk+JU7qT5ilELD0AY3i2ZrJ5BvvWTTWhNuir8o/P17S/?=
 =?us-ascii?Q?+QRQl/lVIi0aCT9Xw7dq+gVDBGy4sc6IM9jfIDt81b16Dw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4O9dkjMBKCIh8OuarYFFO/MWr5I7vRY/QAJBBp7vrzKNLwghxd5jY8/h2k3B?=
 =?us-ascii?Q?pl9nkLYxY4BereOFdg2YC/bQWNyJVsHOhvWJ9250q+cU2Bs2MNmlG7RFpndO?=
 =?us-ascii?Q?GEkgHN/63tovqdr0dlL6TkMB8/twU5dn0A3AakzkH5oPUY7cQUTh43+atdXU?=
 =?us-ascii?Q?GShs8jrFveq3FPbem/eoqLXjZQweLlb+saTp2oCArUpH6nqAW1zbbZNEKVKs?=
 =?us-ascii?Q?STQe82yWFvYFF8W4/qEerwwl5dRBVBo4jiUEq3lRZWZKlenwRlWVO+urdvHf?=
 =?us-ascii?Q?3M3LPk8EAT30kmHzDFCYGfknqEegzWNfLlnDJmBN1s49RtqALb9xtP49hc2D?=
 =?us-ascii?Q?f/uXLH5DYeupOKTReeWt5NoSsfrwU0kOiZ7Iv/korV1OwV11Aqxa9s0v5c7K?=
 =?us-ascii?Q?RvfV8ap12UfAuxEyRfOw8GnqC12ay4bKhAM1KU87H0rJhw2mBtxXE36GEA/K?=
 =?us-ascii?Q?+YOnezAshF3zRYZY3njbb0qmvHzO5ViPqIIJgPSehWbMPprY2MUD71ir7Ijo?=
 =?us-ascii?Q?p+GS0m/Nzv638qGXyAvg3TeypGCemphA7qXpVndNcjq9qpIAj5GhmHBBbJbe?=
 =?us-ascii?Q?LBuM8CvXIbmeXX2lkrQJBBRGQrkAfExPEsXhOYN9Gk9vTc01xKLTBm8Q50k2?=
 =?us-ascii?Q?emRGWaD9qekqzP+tJUNJsIA/WtQElLpAezhBGLMH9gEfhyFg+mOcjL+QoTCM?=
 =?us-ascii?Q?pqGjtnN5Ya5XNKKZ3iLOUFk+BZQwR/G88qcE5Vp19cE43PaePDKKlMBD2N9J?=
 =?us-ascii?Q?fSBNxM1XrW6z/xBr+FtCennLxybfrLzqFotaMSGi+tlraXJ+plApmx39PpQq?=
 =?us-ascii?Q?NODs/in5ej+ShmbhXcbSdt3MYktwOjf8XchP3kCOCrsi6/Xskk2gql1kPWlF?=
 =?us-ascii?Q?uffAzttgeBuUTjP1EK3KT4lifVbU/jm6TXtDcZZINrUOfiqfAS1Tuvoyk7re?=
 =?us-ascii?Q?EYgPdJBBfDf2ZHZVWaM/EQNbd7D5gsCW4hBtN5lz0qjXIXgE1UP+EsfomtG/?=
 =?us-ascii?Q?g3gskQ1Up6oQ0a7WsmTD9KO+Y96jUZ7njD7MZtbIZaZF7TOJ9wcMqMzQYICD?=
 =?us-ascii?Q?oBTh9kd4zBKgsLSYjB35RNSGtsSYuIgOtBT62NZPSikUUYn7rgVSolz0LeIa?=
 =?us-ascii?Q?nCGerZfwD7QETV7T2jgA1BsT0eIVtgygaE1Ib36G30tYEulQPjzgbeQib/9Q?=
 =?us-ascii?Q?yHl8YGSdUFtoqN3xUr9JqNSmwKwppQCS0PFG/RjGzJOApDBpXyd0+tvzdEHt?=
 =?us-ascii?Q?7vJayu7v2q2EKiQ1MFekbHKOLYz/qzlsPeAZgSSioWw094qRQTtpX8oyuFPq?=
 =?us-ascii?Q?iyia3Kdgdnz7wH5uCwUW1UFr3+SsJV5K0qyIO4WlLYZuWfzHMHJR30ZbMOzr?=
 =?us-ascii?Q?xkN4iKADML3bNvjOgRVFJKe1aPZdmgclL4bBYLp1MMBX9hPM3sNfV5Tpr088?=
 =?us-ascii?Q?CiKnLeY/cx3ouC+oUvt6PQunjmqfOzCYsEOs1lfIW3/ED+bbHiFwJsS7otsp?=
 =?us-ascii?Q?U7/FUD7CuAWS8JtV3AseUeXk/Qf/zV+3ncyRlITxSOCydLdNxr33StaoR+0g?=
 =?us-ascii?Q?ZJHiTY2e/IwfazExE9sIkrchiQ1Oy/Ti5o6mV8qO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 90179a86-fc2e-41cf-dab2-08dcdb5a2d92
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 22:59:13.9510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YubXUOpQ9yRXzBUSUUDUcYSEJz6+bhCFkxjvt6++hMFze4x0naOhyR/94sVfP4/PYk1CgfZjXyUyYgJ3yTlGgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8376
X-OriginatorOrg: intel.com

Hi Linus, Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.12

... to get updates for the libnvdimm tree.

The fix for the memory leak was caused by invalid pmem labels which should not
happen in practice.  Furthermore it would cause a small leak usually only at
start up (not recurring).  Therefore, it was not critical to submit in the last
rc cycle.

The other patches are simple clean ups.

They have all appeared in next since Sept 4th without issues.

Thanks,
Ira Weiny

---

The following changes since commit 47ac09b91befbb6a235ab620c32af719f8208399:

  Linux 6.11-rc4 (2024-08-18 13:17:27 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.12

for you to fetch changes up to 447b167bb60d0bb95967c4d93dac9af1cca437db:

  nvdimm: Remove dead code for ENODEV checking in scan_labels() (2024-08-21 16:06:43 -0500)

----------------------------------------------------------------
libnvdimm for 6.12

* Use Open Firmware helper routines
* Fix memory leak when nvdimm labels are incorrect
* remove some dead code

----------------------------------------------------------------
Li Zhijian (2):
      nvdimm: Fix devs leaks in scan_labels()
      nvdimm: Remove dead code for ENODEV checking in scan_labels()

Rob Herring (Arm) (1):
      nvdimm: Use of_property_present() and of_property_read_bool()

 drivers/nvdimm/namespace_devs.c | 43 ++++++++++++++++-------------------------
 drivers/nvdimm/of_pmem.c        |  2 +-
 drivers/nvmem/layouts.c         |  2 +-
 3 files changed, 19 insertions(+), 28 deletions(-)
