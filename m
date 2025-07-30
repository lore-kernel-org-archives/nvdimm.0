Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB051FFC46
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 19:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753905385; cv=fail; b=Zk0n0dXhI8iOwrUMTv4NKq5mRTyIBwyQzxJFcLxUmanNaTblQWcs0Vf5z19mdWXFxIPIkBFKZptYxQTL/Cw72+vbN7JNoCSzCitb06EYg5DG6IDgf7DBbTKHf0JcT5sZR7pKqvvBDJTMuRKzWYqJmHpubBnE2A+oG2K3GZqlzXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753905385; c=relaxed/simple;
	bh=uBAvsPfa08ODlddQDcCMn2ZkBl+qjRKafgO08jGI0H0=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=rdBG7NgSZ9Xh1aDYJIgHeJtx15ssv52Ds663HpArm78mkiyrnrCjePM90TrDks5JTUyDF1uCYXkrVEu2vA/ENTIcnzT5fA6WI4tNzLAglfCJXQjShKiPlUFm/DtBWWCWIyuAdL8Ghd4nxjxZtISd//iVLt+aVfoyibuC/1/oYRA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fVYClgPk; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fVYClgPk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753905383; x=1785441383;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=uBAvsPfa08ODlddQDcCMn2ZkBl+qjRKafgO08jGI0H0=;
  b=fVYClgPksjQTuNYojUlFTAUHSmYsh6YdRlV9sR7z1fW6TtOPSUd5MsFn
   kGfQcQcTWYHfkuLMT5iWEexUaOIuukQb3y/Mbwrg7GGdPWrF6nA85k9PC
   SjmKSmfJjFr31VMbFPxiIX/aWvhBZX+joUiIHN5aSZQoCef3t6wr4s0np
   fzF6pb0Z15U/w64HWCIX1VPtdGDl6773+BSqeAVmbDWvaTMtw2fC5Fpha
   zaDCWousSynkdN+5C4gqPQIOyir1hg7n4P7o5/QnmrnyavW5ZDFyHbvP6
   k3RyNbK2JnU64Fini3OJG4tZK9ULvSMt8gFOoTERgk/8gMWw4Vam5BXcy
   A==;
X-CSE-ConnectionGUID: tE68BXYKQs6XziSt1o65pw==
X-CSE-MsgGUID: C55E+0dcQqS576MYTqJcPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11507"; a="81671827"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="81671827"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 12:56:21 -0700
X-CSE-ConnectionGUID: AoofUA/MQf+lU7vIRF4dWw==
X-CSE-MsgGUID: JwBNqp5vR0qXLT2cpVOFZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="163420334"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 12:56:18 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 30 Jul 2025 12:56:18 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 30 Jul 2025 12:56:18 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.51) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 30 Jul 2025 12:56:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HPe11eerxvjfOHKvqVH726EjaxfiW6+aJpZBrYolAiLNLVUDBbWT3fSRDjmWCtNAzLj+7Xtx3Z+JPnPUyHb6aam1OL8HVjUCoL7lfk3/e4HM/iVXEh9nhV25zOfcSc35e332+CQt41aW988BLG+YgS5Pesa4YzgR4W5pNAiJvXzLGuDISLG81iFsEgsF5V7pAgBgXCpyj/eSLGjFtsdKypFcYwaRSAniPZad8mJPFZxe32XKUlh7GD/C0wWvOaglyU+/U3Qv/ejoUzzeLaoQX9E7slNj7toDZdUmY+Dtt/rZWV/d8p+UbapAnYPMfdUfsGkH5lwiLu5s/5cFhW/KsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D70ntFJHiHan9s6FFzgN32NAFrqYFav6s1BoH5myRus=;
 b=dNNpKgZ6ZCSYkftUx13TJVGT33U9mOU7aPA7FPQCnDXedQDG47yBYaiCIuMvgeqEl+QXdQd7UgEgPtDh6G6o9lf5F4l5M5XHb9p4MG7qjBQHrQH51F+g7JHul85kxvyEltqIdT4WcnvF2pPxaqMXCmSqii5ImA8UfGTtfYnMsyZoO4xKC1UqPAMOqAWU8tYlNpDI3Fr+5L2n5df+Ys326A5DIbpyBHQPrHDlF184jIEZyHbwRzyVgCCppXwsq4HFaU6aCys1qhmiIaQjt/pWRYU0jxmfWbcbG/8gSSCRQMPTtBkiObBfFtVdBq1VpCbTWBqBQU2KK4eOLqMG84dqxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by IA1PR11MB6537.namprd11.prod.outlook.com
 (2603:10b6:208:3a3::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Wed, 30 Jul
 2025 19:56:09 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa%7]) with mapi id 15.20.8964.026; Wed, 30 Jul 2025
 19:56:08 +0000
Date: Wed, 30 Jul 2025 14:57:40 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Nathan Chancellor <nathan@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>
Subject: [GIT PULL] NVDIMM for 6.17
Message-ID: <688a7934c0caf_1028b3294db@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: MW4PR02CA0029.namprd02.prod.outlook.com
 (2603:10b6:303:16d::34) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|IA1PR11MB6537:EE_
X-MS-Office365-Filtering-Correlation-Id: b6b3f3f9-597a-469f-ef18-08ddcfa32058
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|13003099007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?xOkM8YIno2bX2KZIrd0MZ+MzkOwFdd6fmdc+YItW3rFxnYYYUybkv6fJiXRD?=
 =?us-ascii?Q?qiY5wLrg9Na9x4aUY/DG75jctwkVl64m/RMONNcYt3hadd8SBAp7bO1Cofu1?=
 =?us-ascii?Q?dIRXFBK4wVbYFHDxf6QJYML0ti5O4dr3TGAkPFozUzU1RLOL5PbvyQTZjNtd?=
 =?us-ascii?Q?/u2qywvA6OPRNJUi484f+k4qbXA5wshgYjinCfW2hu77lnCTbCT6Bvoys7MK?=
 =?us-ascii?Q?qWY5Ol6QgO/vq4RaxzQezcg1eOPVlGNIahjzv5TpX4KFgvcWB6p0q1uoo25U?=
 =?us-ascii?Q?SHjrxyTifpklufVdrNJEII2VKa8/B1uz5yxBX/ABWzgymyQfQ1tOklX1ENru?=
 =?us-ascii?Q?13urPcbGYC53bXi4Uj2IPnVSGG+SKqJnNmbC6no2yRCkbilOUIPqrN4ei+oi?=
 =?us-ascii?Q?oR9cA31BT6YHQgIvvSZMSNdGibYLPAwcK7EleSifLYv+/lI9FdUclelb4ZrL?=
 =?us-ascii?Q?b3XWhjBqeJa3M/c8LUoXrWnIwzXkS+alhRznpPiE4OvFl7WuE7/MrI38JFIk?=
 =?us-ascii?Q?00LSYm8OOic6TlAJeGuJJVjguMUCTl3RLS/a5VcuypmS1wdGc3fyqZuxCy0q?=
 =?us-ascii?Q?x27zqkNClMrgFW/xaj+W7IIRUUdz1STB9NZZs9jGCmNosyaeYxDhaPP9oNSL?=
 =?us-ascii?Q?8wTvTmhacqg/AyC/ydZd02hiq3BfOjMap23Ug839784xoSam699hftKxHu7v?=
 =?us-ascii?Q?uWgZmJrHsPUY48MUBimXVdVdSrrH48eqt0C1xVwirWQSXE8bgBfSGt0xnV1C?=
 =?us-ascii?Q?gDx2zQCskGMMfwjv4XKrqcZsK6IxL6525tWSg1O5DvSmBC09VZOxpDu+fK5K?=
 =?us-ascii?Q?wBjr85IjPClr3mGXoFJwoA/LjR+I/pEHvwcrAFaW1P7BfRk63xmL8t1ryvjW?=
 =?us-ascii?Q?emMq27vi/RxvziMU/avxyiuDshENF5Q/SDY0Nj5C4uxIfT+efOQIFegwqvIS?=
 =?us-ascii?Q?N1t06h+yn2aTQZ8cKqPA2mNMcqN9IwRPQHq4rhSVelWBXNCW+uEeLUKoG2Rl?=
 =?us-ascii?Q?CTWYEyoN3pijDJmPGmcXOI3+1Ls72grR4c9b7qNAx8gvbksCHLcM6a1Y1v+o?=
 =?us-ascii?Q?UniRVhLHejVLgvk9qEzaTfPOkfxjnO0PKOQlPyrZSe1b4DZtJPjYGLs8GtSc?=
 =?us-ascii?Q?GEfFj4JazFzQ1mTCsDd0KHEMFP2PiSB6TmZXkXDZRefVGORZ6iQDAbY9bg6I?=
 =?us-ascii?Q?D3cYUsStEkxaD19VfzfvRkdXNqdC3cPx4KK0hNtQlI0f/Gj+i5IRR0FbbeJM?=
 =?us-ascii?Q?RVJ6fTdx2VAi7fhNOgsq0P1hnbTkwQ/Ctum/hLYrXqkWPMRmZQxKflb+PkIE?=
 =?us-ascii?Q?QUlocwn/LkhhlEq2oDAKjiY4lPDE6BVp03YgZyBmNwv9fCCneudLbDLG23gl?=
 =?us-ascii?Q?yc45JGInR0doTvsjF0jVNTXqqSJK4Qz19VnlzfWs9uOiJyNeQgU5Xjt1tzr4?=
 =?us-ascii?Q?7INR6fEJmXo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MuDJhPApNtS5YW/XhaBQjS0xyPSWmvXJs0QAmzGV7EoSLlk6b5D1YqZjQtHb?=
 =?us-ascii?Q?k0RTSNeoTzo+yWuAdsRoCj++HHQ9IEpgb9IZ8KZTS7NzeoEHQ0Xh+eUe1iI5?=
 =?us-ascii?Q?Gujw5y8lNcu2vqT0ZsDhPJfgx1QJB/niuoVI8te432rqcySu73uKVOZBQ2ZH?=
 =?us-ascii?Q?7jOORko0ckBNQ/PBSPhfTF7OKLVD5hDVsZy9FxImtvsr2O4/BzglfZv6U4mZ?=
 =?us-ascii?Q?XnVqfjfbiTOtZfphuxaHunZHwmsT8M5XZz2R3bRM0uuzsffi376GDl2/6PGF?=
 =?us-ascii?Q?fk4N82XMZQ4WMIu1nMW+1ee2wLh7cqKstWAbAZur4+SXrOeyoqTG4B2/NVa+?=
 =?us-ascii?Q?5fWzGFoJZfcW2UL3wsg4xI0OdibfJjWtTEBEh3jENLCx+KGCzJQKU34y9KGj?=
 =?us-ascii?Q?lkPkQ2RS4YpCXuzlkrBOmCmLdEObXyzUuh+coUr/OM2UQ2l4GKgMo7jC736P?=
 =?us-ascii?Q?B1mhKfKOygEqPGjaswgV1HivcXVESkitmcIZqbLyy0YvgGZ4B+grt73LwHzW?=
 =?us-ascii?Q?eXGgxTDfuZnbiitVYYCoTibadJREaWPgpOjEeNouxVWl+fsMlbt6+5PGX0Ng?=
 =?us-ascii?Q?k+e3zVH3gu1SF2O6sPsyVM3tRrK0/0o9MqCKy5LViK8UgUrTpeNCWOG13hXw?=
 =?us-ascii?Q?Lf6O8h2j8S77A95fSWrMFQvyiEdJdLXgQ5fCPScd5MHVnfNZQXIu+9+hwA6I?=
 =?us-ascii?Q?bfjeesKAqM8uKOpGpFrEMh4RDPbshFjvwn6Styv8B6t383iXVi+CcQ55oXCg?=
 =?us-ascii?Q?Gqdc8EHtAKg4xXn2SvdHj0q7VIIXFjeVfSdkoPsunl5TJ79NBQIVtlafNMPl?=
 =?us-ascii?Q?fg6Dc0l/DAfATvn2/yJBJAEjF81IuIfI+/bLCFXGbF3FBEklUDZdx5Ms1BiO?=
 =?us-ascii?Q?EyL6Ywanl3DHhQJnV+uUYESFv4oWxW1tt2XSbfz6BfMnYRobhBfBqUiGCegA?=
 =?us-ascii?Q?K5CDIgIHclLImtHRNGcX2o876iYuUo63OBQjdCVzDured6OtSTUB17tk7dOF?=
 =?us-ascii?Q?7Cswm8EtQdJwPZSgUfxwuHA4pq0U6FGbY2On3hPeZ20rbFLRiEY1pRseFBeu?=
 =?us-ascii?Q?l6VKsaHSRBrcvbwaxbtelLJaO6fa/MJE1Zinu91jSf0r1gHwNF6Us7ftSmya?=
 =?us-ascii?Q?HwyVfFZWe1z/bLqAz2g1WkM6ABo65rJ0GPcbZYlQH/xENj/t8mBTN7Ke+TD1?=
 =?us-ascii?Q?IkerIL4zghhNoZuIwKnaYnnERwJu4ffFIcQmeHjP3bUjGX70yfGyj1/lpHtb?=
 =?us-ascii?Q?9GQZ+XfRqzOjru+x9Bljqu5Qx+8iAYS0sioRgMLhGMPfRTivazB8jKV0VjAg?=
 =?us-ascii?Q?xg18amZE4FtRcEMt1NG7RxDHIUBiomqfwRb6/lr4EU8c7Ev7F/PzUhvoBIWB?=
 =?us-ascii?Q?7dIjnSco0w1KiKSyl+1eUVImQMC7dm3svm5GnWRwGPDznHpd7xYnTZ/uUqIc?=
 =?us-ascii?Q?y0dQYYmIrQ60yVOu3aQ5rxioJn8yo84onbnBPjFtNTCxGph+4hmArhksKif8?=
 =?us-ascii?Q?Or2HrjebmFJQ2kXV1qAoplQsCWUOg5NzdB89eUh5hNMh+9HHvUpbJfmqTjhm?=
 =?us-ascii?Q?kmK1TSgKP8pRdzLI8pPXxscvl4mqH1TImWQOarCZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b6b3f3f9-597a-469f-ef18-08ddcfa32058
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 19:56:08.7168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bcDu9bQp28CMPDJZhV0nXP2vwxZzD85zk1fhG+34oXrf775OO0v+VRxJfQQfsH3YbrGjN6MpCKCnECaTKz6FDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6537
X-OriginatorOrg: intel.com

Hey Linus, please pull from:

  https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/ tags/libnvdimm-for-6.17

... to get header file cleanups.  Specifically use specific headers rather
than just kernel.h in libnvdimm.h to reduce header file usage.

The second patch is a fix to CXL but is going through my tree as the
libnvdimm patch caused the issue.

Thanks,
Ira

---

The following changes since commit d0b3b7b22dfa1f4b515fd3a295b3fd958f9e81af:

  Linux 6.16-rc4 (2025-06-29 13:09:04 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/ tags/libnvdimm-for-6.17

for you to fetch changes up to 9f97e61bde6a91a429f48da1a461488a15b01813:

  cxl: Include range.h in cxl.h (2025-07-01 11:15:13 -0500)

----------------------------------------------------------------
libnvdimm fixes for 6.17

	- Remove kernel.h from libnvdimm.h
	- Fix build issue found later in next

----------------------------------------------------------------
Andy Shevchenko (1):
      libnvdimm: Don't use "proxy" headers

Nathan Chancellor (1):
      cxl: Include range.h in cxl.h

 drivers/cxl/cxl.h         |  1 +
 include/linux/libnvdimm.h | 15 ++++++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)
