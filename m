Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9FC1B9B2A
	for <nvdimm@lists.linux.dev>; Fri, 16 Aug 2024 13:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723815888; cv=fail; b=DbJPJ6meb7UbEVrnB9dDU5I+ZUJS/3vBgIdCU1MHywbppM8CE6mjAHKl/9GVyMz4fbFhI6l/dRpxEN/IL2kN2yAruREzO/8ItvyCYKgF+eT652xyayHDwh62i0G8/59Vym9fJvLCk+RM2nnMB3Cg0QZs6tXhfF24D0VuYQu9P1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723815888; c=relaxed/simple;
	bh=2NQYR50ozBjrwJiiZ2oPf0SgJJXmYB9BR3NLZpluptI=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=rlz+6j7okXmCs9L3moXZiEEzrmTzg5LnRr0Yj93nExqK7SJDLkm+iypmQsfoTcjbIkoqZkiBDvQ+W6MDzt+i0AFbN7yM6jy0zcJSBtbu9l+DggL7VdXRRMXI5UIl80q7J8y9Op99ogX1oEe+0pfQKNte1XtfBO3UKfJ6xdIFe8E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CzDClXTM; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CzDClXTM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723815887; x=1755351887;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=2NQYR50ozBjrwJiiZ2oPf0SgJJXmYB9BR3NLZpluptI=;
  b=CzDClXTMXZpbAvbQCMWkWnKPF/Mf0oOYTocy5k0ecayeaydgkk/gS0BT
   l6ZHfd1G4bpPsV299lFtAArpWVGNRO3OteohVFz+VEFhT9LBFH813/nUJ
   7heLdGFdUzsE/6GiCxSPhcuQojcoDNW3a+NLjbvmHe8SC0FCcY6Qd1+rc
   SZOnC2RMPhsjarLfhhGVQ3eLCQs0FE1CuE/9SHBFINvXRE+XHPEyB6iy5
   +1d0UGQz5kjmqRdHzi7WswMDCZTkDPjTG1EeeVF9Q782X75b7WI+i9odS
   fBpF61Kz0vGmuEOwZhwKYpsOGEeyzyPa3rKy7su/z0/4Rub/4p8PULAGw
   w==;
X-CSE-ConnectionGUID: M39dS5GnTaaGhSw7Uf9lUg==
X-CSE-MsgGUID: W8m2xYt1RVmwM9KOd3Ldxw==
X-IronPort-AV: E=McAfee;i="6700,10204,11166"; a="21966833"
X-IronPort-AV: E=Sophos;i="6.10,151,1719903600"; 
   d="scan'208";a="21966833"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2024 06:44:46 -0700
X-CSE-ConnectionGUID: cSJP3yB0Q62aQmtNTad8AA==
X-CSE-MsgGUID: NtVUnzDsTmaWTdlxvV93IQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,151,1719903600"; 
   d="scan'208";a="59310108"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Aug 2024 06:44:46 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 16 Aug 2024 06:44:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 16 Aug 2024 06:44:45 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 16 Aug 2024 06:44:45 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 16 Aug 2024 06:44:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JpT1P6GB3rkoRvU5IopTCWfmrdta8z1DTt5L/1uc+TmONXW1u6Vg2kSQmNpha0BYbSEaHOgT0x83dv7gBZD7hpbeWZ8cRrT6ZxkKTA7GJdnWN99qlEwEi30GQ5tQF62OeBFBQLN594QKm+hqNYHGkWcbNKSv5PPGFqXFGkxXaWbHoujRBo0NYRkFin3SR+z1RhopBrinjUdo2y6mAJlCOo2j9im33PMk0aWTF47VxsmNBdP1oFLrQ8G2FOOP6P3IuhHwU8a5/NQn3fYbACYN2DT5vJQZ/tcJR9IKQg4tlrcnTFlgsE0hryoSvUNcfhNtfMB4q6yt+tTDgsEH2yDgEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/XEOJvGA5fR6g/yrTOlMaDNjNeQEWs1RpE8qPC9V8Fw=;
 b=jta7zWY/SipxwzPW/z2OGlCzoGudN89SHTwSIxHcNgqS5+uwbmjtq4TbcFcQra8tPfRZIt22lnOIn04uyPJsY2b9ilyqRnXbOtsPSP+aQ/b9duXpBncgB6VUhvgtK6rJIiq7h7By5aZPxHhq2MWlDiG1fYL8hIEoV9rXHTb8iKw4DahVEdWYwLMJib+7UPsQ0pQN/gwNGrLXmvFYdbq2Z6FJ5UeWdU2XbU9IhM8L62fZNMgFwRdAh4lrySgLu0iu7T+zRv9em2pa/rp842P2kTbfKHp96qcFU3UYbOJ3HKITpYm3HxDXh+9SmqPLXWP5/JX8EG2CgG7NBXQAjQORPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SA2PR11MB4857.namprd11.prod.outlook.com (2603:10b6:806:fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Fri, 16 Aug
 2024 13:44:43 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%6]) with mapi id 15.20.7875.016; Fri, 16 Aug 2024
 13:44:43 +0000
Date: Fri, 16 Aug 2024 08:44:39 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Zhihao Cheng <chengzhihao1@huawei.com>, Christoph Hellwig <hch@lst.de>,
	Dave Jiang <dave.jiang@intel.com>, Alison Schofield
	<alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
Subject: [GIT PULL] DAX for 6.11
Message-ID: <66bf57c7b023f_22218329410@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: MW4PR04CA0153.namprd04.prod.outlook.com
 (2603:10b6:303:85::8) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SA2PR11MB4857:EE_
X-MS-Office365-Filtering-Correlation-Id: fdd8272b-df85-44a6-8113-08dcbdf99596
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?LQCAf1f4fja+1xIiAmBz8hhqoeBcS8Vr023z6L/nhfGPUp71u8pMPP4nLSWf?=
 =?us-ascii?Q?GNMQ0nT2bhy+05LXlcSELSDb2iDTRqE2kHlrTaBA+C1iNIJHgKdFp4yLJclB?=
 =?us-ascii?Q?mXX8z2CBH3uNq2rDQ5f/5355UJGkJgL3dFTDmhtitFdRgaKrIc6ezy2skQJu?=
 =?us-ascii?Q?4YtsqBXAh3lp3q+1EqEyARf9vaVEZSiGD24ZVNnpIgC3AJklNGfev+8xUEl4?=
 =?us-ascii?Q?WVe2L0fwzp/MEk2IQZqSYN0lQb8R3k4yrjC3KWO+4PlvO/UpI7/X4MfdLphA?=
 =?us-ascii?Q?s+nEoSDEW3G+0TKafDZiEHxWP9OuzB8vyfbQeOndDBUxTvqRR0pkqZbnAYcm?=
 =?us-ascii?Q?kPpVFBLVm+mTwnyy0EsSw4kuI0qd2eYgQpmfZcfIXQryqKCwTnsHDfdia4MH?=
 =?us-ascii?Q?EwfVagfpBwQsvz39LGAz8AWRWvaR8yRKtuCR5QBdl44/lAwLjNEXFUvBuCK6?=
 =?us-ascii?Q?YMX5a2Ql0B8vfgT62GUGB2vUUeKTVJW2ouReW27EL73P7uC4XO9w6tkOLrHg?=
 =?us-ascii?Q?lIqS0L8gffx221MN52jaGC/RTqH9VjoRCS6PxzFtyFj8Mlx0Xj+Vwc2OAdXF?=
 =?us-ascii?Q?an1yVTslUPK0xgc2TDv2VEeYn7/O46bKdhVqfNc7LINl6LBIknZ2YHDjkc04?=
 =?us-ascii?Q?PXHPcMlmTxqa9mhOH/SGPLWnuyp5eQErKHYhiCf0KTwohg2eotLNFDMf3PuC?=
 =?us-ascii?Q?M2vnLcH3f9qtpAo5u0VN+PshtdlYYfO8cDsVZXxhhdwYQtsZvvPfa6QlGCAX?=
 =?us-ascii?Q?Jd63VbfEfc1lf6XyQ+MlZ1ySLmFKDzSgu8KMqXMmpgFi+50JCIYTmwr/c7aO?=
 =?us-ascii?Q?r3KSkJLvIEoAiQSRJA0/+vYjcRGt/jrhXgQw96FneePCd1jmbM9jjtQVGwD4?=
 =?us-ascii?Q?DgxXzqqWTbDEBHYqo7LxjavkGt1C4B7FceM3PXv+SQBDJB1d1tyEYdrO+psZ?=
 =?us-ascii?Q?ZaBNOMlAC3ptzMhO9PLgl+89hTVDg7lMsVDfdIeysB5AyqC7c4X7Q4DVcw4e?=
 =?us-ascii?Q?Nqjc8FQR8Kb3PcFoC9OwaqdqGfd1t8qYXTjmXSoaDYEc2UwUSqWEx6eeUVRd?=
 =?us-ascii?Q?02inzIy51RV02mFCdNn/CSnXqGuRFte/shTCGngugfgIdeFmNjEI29z3bTPH?=
 =?us-ascii?Q?py81417twMbIEQbvNcDcxE4TIsEtquj2Gm0JIHsQ2ATeAwbkz2kBEuqCTmEG?=
 =?us-ascii?Q?Xty+VMmPxMGngwu27bN4bYCb+wqUtjbE+HUhZbro6hyQfs9kE7WuWZ5r8lEe?=
 =?us-ascii?Q?uvI62takHdYm2s0L+aOIbvmzZvsJDoRpM2uaX7RZIiu1sho0Gn36AvMdpKBD?=
 =?us-ascii?Q?9jU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P/KQfrlJyZwn4tH3g7vRRwzBAWjNNkrHV8KQ5d5JAOjUk5QfKUqo0+nEmRCP?=
 =?us-ascii?Q?5ATZixJGo5QzhkuHOjDrlGJcOC7Q4stU/WTzrbg5N299YTNtytXmHcsBfDxh?=
 =?us-ascii?Q?j6xRKAKTWSNi7xTjxuvfppRGq+CLn1xNwA2AtPObEj7klrKvib6tU4NX+Jet?=
 =?us-ascii?Q?OhmzFzBrJ+wi4Ct8bACO+ssosC2Q8+VDq63v+7oZmVTYS1NBEwpMlm4ITtxo?=
 =?us-ascii?Q?Z5/EhGbEpcy1qdNRu7+hp+qTHrXx/ZIbeEUE8bGJvCLbXBqUs0ApJswOvjWk?=
 =?us-ascii?Q?8oLWtgXqHfhvdr0guIlN3tdqRZVV+WpFY5X5jZogz+ZW5Cb/RFnwM6D3pJNW?=
 =?us-ascii?Q?1nGvrTXSFzRu1uFM0K4yPdbQnsasNB8e5dCr1HdsLYZe8YBin4LOh6pCcfL2?=
 =?us-ascii?Q?V+kKJHoZTtnNAop+7+i3TqqFgOF7LcNVW32SoxWSz4sPJbPzIKB1gJqtDQdE?=
 =?us-ascii?Q?mIi2idMfQpfTcjtScIZEWO/pwTt8/ewBhBSWSvj13qAnMdsq7CyVt8MJZRri?=
 =?us-ascii?Q?Tbp+mKaE3ljf3vaZ8OeBUsn70zTkREM19N1XWovJUTajIiOAAWirno9qQ09/?=
 =?us-ascii?Q?9svwip8rMtec30IkdV0UCu84PwQDZUc6fDqplhC0mPCXktUou+nK+TxxjiM0?=
 =?us-ascii?Q?Kp0gtDtLCjn3tyMb57E9/lEH0Sq1CFIDJAPEafOYcDC2UG2IdzhvoNuBG1D5?=
 =?us-ascii?Q?uJKkCRTiAbes74sPF9oe7TAbc10Ssed7LskXzRxtS/78ckECR9Oh5f1E+urt?=
 =?us-ascii?Q?yv/cy5Cd3xiOb28hCDXQuYGQUsvPpgIblp9VR6W/OvknXWAQIElbv00E2W0h?=
 =?us-ascii?Q?mFAqv2cJWtgCCsgELfTMjjTEJoms3Fm2BprCMQU2c2SUUHe/q7TqWCg3Suu1?=
 =?us-ascii?Q?fi6CFo+ll/9SR/ZEYsYDRwQs5Yv9P5N1X5DJLC/A/2KSHM9TzDM0PZcKNrk8?=
 =?us-ascii?Q?K5DYuyY+zIwGcnSA8j/9wjO7AwBSXSzI6MdSbG3owJeOR6/8E98xjoNYsj0S?=
 =?us-ascii?Q?jUqAUUAFQSp18Pn3YPQmEKEVtJKcy2Wp8zu6ElsJOXHG8jRzAuzt1v8M7ax3?=
 =?us-ascii?Q?eReod1IZ0JjGMvt2xY4e3Ci+vz9CnNUSbTSS2Kis+85DcpxGbiHDcn0nFxk0?=
 =?us-ascii?Q?UmT6WWVCF0yUiMVA9zq6YrRKn1cUSdLvpFB/iJL5psoiPkWAO2TeqK/zHTAZ?=
 =?us-ascii?Q?Oj2XXiLEikNvKrkTJxNVnkWl6A4kzGnRnoV7On2qfFtcW1wpWksro/pe/ejY?=
 =?us-ascii?Q?tLeaFqQOiN+oYyGKNhA1A0rqWysF7xsXDPugtjYnHeBzkTdDbP2TWx5+yODo?=
 =?us-ascii?Q?p/uvwwHaGOZsOaEKH1EpLqg39mMFclK2aESHChkmONb5QfCloKVHotEJZnzK?=
 =?us-ascii?Q?UtGf6345By9/vuOD8PlLt6p4olHvCWjTtu4Bte4G0KqSS2ogKalASvps/mr4?=
 =?us-ascii?Q?oDJEu5749ib+7DS/280JHUN/xfP3uKumttXi6v+0q1rbmiX4BVlVq3qJZb7u?=
 =?us-ascii?Q?R43r8Zjs4d68kaGWXArpnDdQVlG+JOkwL0Msqp7nsYmQAHcGyGznveixgk8j?=
 =?us-ascii?Q?k5ugw5Mt3Jnnm1xHJqoIJerT4hZVJU2D5EGQHD44?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fdd8272b-df85-44a6-8113-08dcbdf99596
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 13:44:43.4933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qWtUVy1nypQf68+NLhIpQC44eIKK+RYyU8hkDasbEMTKN6ktRwktpob44LWJcUh55g2YZqH/sCtSqglGdYOU9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4857
X-OriginatorOrg: intel.com

Hi Linux, please pull from 

  https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/ tags/libnvdimm-fixes-6.11-rc4

To get a fix for filesystem DAX.

It has been in -next since August 12th without any reported issues.

Thanks,
Ira Weiny

---

The following changes since commit afdab700f65e14070d8ab92175544b1c62b8bf03:

  Merge tag 'bitmap-6.11-rc' of https://github.com/norov/linux (2024-08-09 11:18:09 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/ tags/libnvdimm-fixes-6.11-rc4

for you to fetch changes up to d5240fa65db071909e9d1d5adcc5fd1abc8e96fe:

  nvdimm/pmem: Set dax flag for all 'PFN_MAP' cases (2024-08-09 14:29:58 -0500)

----------------------------------------------------------------
libnvdimm fixes for v6.11-rc4

Commit f467fee48da4 ("block: move the dax flag to queue_limits") broke
the DAX tests by skipping over the legacy pmem mapping pages case.

	- Set the DAX flag in this case as well.

----------------------------------------------------------------
Zhihao Cheng (1):
      nvdimm/pmem: Set dax flag for all 'PFN_MAP' cases

 drivers/nvdimm/pmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

