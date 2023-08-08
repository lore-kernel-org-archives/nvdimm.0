Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A209D639
	for <nvdimm@lists.linux.dev>; Tue,  8 Aug 2023 05:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691474292; x=1723010292;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7wKTCalfPSVdoBbreW30YrNqveBYxtbQCnnfJGGwYBg=;
  b=ExWxjaGKTvV74P/IaLzJeykow7x55Ve4RZWnOIrcywnaNKuM0rdFthyc
   iDqBPYlp8WL3Z3Tpw43aylUGENlC3CqMkHssNzw26f8EoXuLwfSPtXuKK
   Q97ZA2yfhiiOdUFpn03btIJKytLr1NuaJCNjpVRsQn0BOiWC84Q3gGTwU
   KM2otZt2pc2THaxl/jROiMeBUOtvluTd8p+ur/xwAQ6WZSj/oTW/N2CAa
   E3Inu78wi2GfuRC7vBD+Hmyyg5umcZLKlcxN7Mt2PAxjR4j8IASZNipZA
   wuhOJ2K8PoHSba8YTwhz/INgZaoL35JdWxsQk1n4PAwp7SUX2OW3BAHzK
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="374403765"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="374403765"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2023 22:58:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="734368160"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="734368160"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 07 Aug 2023 22:58:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 7 Aug 2023 22:58:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 7 Aug 2023 22:58:04 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 7 Aug 2023 22:58:04 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 7 Aug 2023 22:58:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZNxKrlej3PXmgsnrZ7n2LrEM6xV5mpphOxHW++dvwppHiWW+PguasjtmxsGOjDFgqZjPpmAAb77xqQcnBJ+icVhDRyeaW9Gz/5lcViHI9ZtcC+fsCht16H4W+YKFW9mR2pVKomZIB4n8TXQjE4Q7UZxtpSwREqX9paavJbhKMhPdASV3FWhrfCc4rh8EYrBO1tG/xC5dOusKtgqjHqEqCsI4yn+YDH5spIdyVIRcxOzRuzF+1VZN6runMiKUkPeIfzQ13x6ezDTWqybNvGvHMUG2yCKAnQhvw+YoZ7vUEp0QHs2SVkcIBRC22SlsH8+AVT/JzWv/EHqNUz2p7D2pWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2p52pf4ayQzZ0+1Fd/pht3KJ9xSRw3bcCeS67aJj2Ok=;
 b=gPC27Z/2dqfQ4mT83uhS3gSNm2l6KBOAv+zLsemuoGRMUU4dM9DoxW8Xc6o0ZNbqXhEO/gtP6trjy5g4Q23Y/4vPLBuCBPtyv/1kJKORX48uPoDRVA5BokP5KLfUdHAAMCbDgjz9VGoyH1DaCmN1SKqdsH5SHQtphdFfbhfLKrDDaZ+D5ebZyJgi4xrQi48eCZRTNx8nvW4/JdzIDLqfUywZpLlXWqvireJ1zyPQhrCyXyFfLzhe1pUuzfwac0VXrFCjuLJs96Tglrquw1vOqIv73p9l6W2Y8Z4ng/3SMJD2boviQCYvphtDL+vqMTjxS9NerB8Zs1MMVmbMoJpJhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CH3PR11MB8548.namprd11.prod.outlook.com (2603:10b6:610:1ba::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Tue, 8 Aug
 2023 05:58:00 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::4556:2d4e:a29c:3712]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::4556:2d4e:a29c:3712%4]) with mapi id 15.20.6652.026; Tue, 8 Aug 2023
 05:58:00 +0000
Date: Mon, 7 Aug 2023 22:57:57 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Terry Bowman <terry.bowman@amd.com>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <dave.jiang@intel.com>,
	<vishal.l.verma@intel.com>, <mav@ixsystems.com>
CC: <terry.bowman@amd.com>, <linux-cxl@vger.kernel.org>
Subject: RE: [ndctl RFC 1/1] cxl: Script to manage regions during CXL device
 hotplug remove-reinsert
Message-ID: <64d1d965d6f13_5ea6e29436@dwillia2-xfh.jf.intel.com.notmuch>
References: <20230807213635.3633907-1-terry.bowman@amd.com>
 <20230807213635.3633907-2-terry.bowman@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230807213635.3633907-2-terry.bowman@amd.com>
X-ClientProxiedBy: MW3PR06CA0025.namprd06.prod.outlook.com
 (2603:10b6:303:2a::30) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CH3PR11MB8548:EE_
X-MS-Office365-Filtering-Correlation-Id: 98d3b72f-9c9e-4085-abf6-08db97d46c1a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ntf2uz5EjhJRTI5eA/j3whog41e1ovmIIV6wRbFRV/dqNf8Cxj40tSgXHWeSQXe/9DfzwnWeCOczmqEPiD5URZGP/SvPpTcIwT1QQmiVO3KTcZqjrgWexL6JTQWlIB1WKL+v/QdciUSX/vJE2fWR6uuW0qqM1A8xHcntLBB8am/2gMwaeTkhhIXA6c6Rx4c6HQoJXe5/nCUQLwPUtGJC0jxZ/+/DW9UYvZzFwWCcfFcYAj3cuUsvamsBb5iHwTRJU9aPGTcOCfoSzXdt9q46n6l1x24N94Xw0m4na2T2EJhwVobGFobwnC9jRbQTzWqCvJ/DN+4ydW8YDHtZji2NQ8QlfBHGUSVHKfNgTZUBycTORuo+y7JISniRUZ4yXxTBkdezh5w+Vp+ftanO/3MttZSpO5AUB8GbNTbz1YFsBYph0J0raAAS87R3rz3KNV+B7jIfP7oV0irc+PtiZgW1xtW2lI/J30qAIzN75VcOI1O6rc4yveNbRX5mJts7CLD+WvZ4OsV2cRa4cO1FcTRjgOynUBbDsUpad92VfvEAJIGEfuRx2qqklp4uqT403wSDw45LDMpRDYoxkEf03AkaoPzLl/x+xDCSRwbEEul8m4GVQyrFvuuHEA+5wGHQLKb6jkFT4g033bn/Pf+hxwJdtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(396003)(366004)(39860400002)(186006)(1800799003)(90021799007)(90011799007)(451199021)(26005)(6506007)(9686003)(6486002)(6512007)(6666004)(478600001)(82960400001)(38100700002)(66476007)(66556008)(66946007)(4326008)(316002)(41300700001)(8676002)(8936002)(5660300002)(30864003)(2906002)(83380400001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rkR37kmY/SGiMPQroj7JN2XHaC1ZGYz1PlBV3ZSQ+V0uvNmExQvUZHRJSqy7?=
 =?us-ascii?Q?QMSbmgylZnUGmBMuVnQbeSsTFdOO13rXYJ0R65bJHkS0v6Lk0hhUuYckUEV/?=
 =?us-ascii?Q?ZZh3uXD0kJf0HYsSrruNyfctdLV+MBcOKh35af6PxNpi3HKFXR5B1wTEbw8y?=
 =?us-ascii?Q?7D7jBNBmqxBcJgR57z8YfaG7Exf4mN06Uu6mYtKUGz7jiGzSELPexXLg7++1?=
 =?us-ascii?Q?IT/8ua7WwHhkMBawGOTDXPlpb52azReXN/gsDV+pwfZwCcWAhGkygSIsrTtZ?=
 =?us-ascii?Q?Y1cBJOxn6HCmtBFqk255KjNPBoYWiBpS3E2E7dieOedBO0M+RNm44m2F4aOK?=
 =?us-ascii?Q?qNW0Q6wAblhjNklQOnusOQ23lJmqCF0GWdb3vjztPd5BOl9XSYsQMoWKaI9P?=
 =?us-ascii?Q?Zg9adizCzK2YbVpAZqsHOGfgwOIWMjCn2+uIV+UR9igLbQyvIwruGoQR0oIR?=
 =?us-ascii?Q?5XZogoTdTS73AJ2Z0XHmCqy2YM/f4sh979vST9yncy/01fEDrgZOxkKgpC5E?=
 =?us-ascii?Q?CAg+jS2ypLHEbyvN/sen8oUNbfYbS5+/018A3F+NE6H9ogFoxzjgecF0unZf?=
 =?us-ascii?Q?GmSSbHA011aK2/1JLlir3w8dZ0q+tLIf0d3uU5a48Tj1Ca4im7jsQkosTZSJ?=
 =?us-ascii?Q?R/7J9I/Stwb/sj5uUbBnA5WqvNkUVHPkFtjPBobYisMXHooWUNPW/wZpQvNC?=
 =?us-ascii?Q?FPvFlP6J5qx6qhZS961KaBN2XP+fb3YFmKQbQG/Azy767QXpIR30t65EKGpK?=
 =?us-ascii?Q?WImxKMssy8bNa8oLWr6aAZD3Zbxv9k5bevg05muuQBQRvGLXO+A+rPcRen8q?=
 =?us-ascii?Q?gPpj55CEpBXAnDaL5DGWXm/Q1YKcLAKsok0LbNuDIRFv2BUs13Tw+XbTlYnv?=
 =?us-ascii?Q?7u1jEoHE4W6giN4aNAb4Ow25QDYw4TvfsV10BKiaV3+pq4k/Rc7ggybnqPjY?=
 =?us-ascii?Q?fSBi8EckD9aIfTOinPCMXKffdE/VbmKiKp2l3I/eMsAogHOkO8MUdwol3NRH?=
 =?us-ascii?Q?0Q1M7WwaWChw0tclEDbd/v32wIHSkrRN4yvBqghxTzssyGZ9ZA0RQWjc3fyD?=
 =?us-ascii?Q?tbmKm5JJIeNHLe1rht8XhYx/bK0+Ue6vZ4gxrqBISmwuO4ZklbRVcVJejD5B?=
 =?us-ascii?Q?hgzmrycGYh9NW2egGaHego5qxEfji2vWn6D36HcFlXIK8pIeDDDeQTpwiiAK?=
 =?us-ascii?Q?23p32gqpE7TGsWQMr3th/IEJWLJRuuTNNlAT99iW/3XYiP1OflagzXa64E46?=
 =?us-ascii?Q?jCHnKSeGnL2rBPqTXs6Sql7U0cAzbumgMJe5wVBXQ+/2/Kp2x2j14VWMcznU?=
 =?us-ascii?Q?gKmjDyklF+X74teTp+VlRyFF7H0bnNU8DJpq4dSDEmndnQ27E7qOn0aje6mJ?=
 =?us-ascii?Q?ZCs95Y2O1upPFRtkAZonC7dzfGNVHiIArMaa4xO0IDi9eiDCy8dKMGBROrTx?=
 =?us-ascii?Q?yzloJdkfFQ9xR06Sd12axHmdYwRXw8fOieMICpyCNRVjxhUJA7L6hC4oAxRJ?=
 =?us-ascii?Q?exXuEzc2lYqiELLVYUQLvoo2bbuTB6W84s+kjUqvAXjYnCMIWcZhwEaiDsVA?=
 =?us-ascii?Q?SdyFapMwd4e9cD6Rl1GLlHUc8/TJ9r4dCk1ca1zHY1QSJnWlK9ILE5AuSE/2?=
 =?us-ascii?Q?Ng=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 98d3b72f-9c9e-4085-abf6-08db97d46c1a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2023 05:58:00.7073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vSIothQO2Gsg4JqZCx/8uZJJ1zBRXHVDq96yHNqv81tpKHvdFSTvFNbyPmSJuR1LQaggaFa9RZwnkNuDBzRUONervl9Mt8RneelFUQVe/m0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8548
X-OriginatorOrg: intel.com

Terry Bowman wrote:
> Hotplug removing a CXL device and hotplug reinserting the same device
> currently requires manual interaction for managing the device
> region. The CXL device region must be manually destroyed before
> hotplug removal and manually created after hotplug reinsertion.
> 
> Create a script to automatically destroy and recreate the region
> during CXL device hotplug remove-reinsert. Save region characteristics to
> a file before destroying the region and hotplug remove. Use the region
> characteristics stored in the file to recreate the region after
> hotplug reinsert.

It strikes me that functionality like this might be formalized under a
command like "cxl export-region [--destroy]" where import support might
be automatic if the exported configuration is saved somewhere udev can
find it, otherwise "cxl import-region" could take hot added device back
to its defined region.

> 
> Signed-off-by: Terry Bowman <terry.bowman@amd.com>
> ---
>  README.txt     | 311 +++++++++++++++++++++++++++++++++++++++++
>  cxl-hotplug.py | 366 +++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 677 insertions(+)
>  create mode 100644 README.txt
>  create mode 100755 cxl-hotplug.py
> 
> diff --git a/README.txt b/README.txt
> new file mode 100644
> index 0000000..97fa793
> --- /dev/null
> +++ b/README.txt
> @@ -0,0 +1,311 @@
> +                          ____________________
> +
> +                           CXL-HOTPLUG.README
> +                          ____________________

mmm, documentation.

> +
> +
> +Table of Contents
> +_________________
> +
> +1. Purpose
> +2. Requirements
> +.. 1. Kernel - v6.4.0
> +.. 2. ndctl - v77 or later
> +.. 3. QEMU - v8.0.3 + the following patches:
> +.. 4. Python modules:
> +.. 5. Additional tool details
> +3. Usage
> +4. Examples
> +.. 1. Swap a device
> +.. 2. Manually unplug and plugin a device
> +.. 3. Manually unplug and plugin a device (w/ step by step details)
> +
> +
> +
> +
> +
> +1 Purpose
> +=========
> +
> +  Hotplug adding and removing CXL devices requires region management not
> +  automatically provided. For instance, if a CXL device is added then a
> +  region must be 'created' before the memory can be used. Likewise, a
> +  region must be 'destroyed' before a CXL device can be
> +  removed. Removing a CXL device before a region is 'destroyed' can
> +  result in CXL device data loss or corruption.
> +
> +  This tool aims to provide region delete and create automation for an
> +  existing CXL device. The typical usage is to hotplug remove an
> +  existing CXL device and then hotplug readd the same device immediately
> +  or at some later time.
> +
> +  An unplug function is provided that will 'destroy' the region making
> +  the device ready for hotplug removal. Note, 'destroying' a PMEM region
> +  incurrs no loss of data. 'destroying' a RAM region will lose the
> +  region data. This tool saves the region structure information so that
> +  the device's region can be created in the future. After the device is
> +  hot hotplug added in the future the region information is used to
> +  recreate the region. The region information is saved to a default file
> +  or can be directed to a specific file provided on the tool comandline.
> +
> +  This tool provides a swap function that automatically executes the
> +  unplug and plugin functions.
> +
> +  This tool is currently limited to non interleaved devices.
> +
> +
> +2 Requirements
> +==============
> +
> +  Tested using the following:
> +
> +
> +2.1 Kernel - v6.4.0
> +~~~~~~~~~~~~~~~~~~~
> +
> +  To include the following kernel config settings:
> +  ,----
> +  | scripts/config --enable LIBNVDIMM
> +  | scripts/config --enable CONFIG_CXL_BUS
> +  | scripts/config --enable CONFIG_CXL_PCI
> +  | scripts/config --enable CONFIG_CXL_ACPI
> +  | scripts/config --enable CONFIG_CXL_MEM
> +  | scripts/config --enable CONFIG_CXL_PMEM
> +  | scripts/config --enable CONFIG_CXL_PORT
> +  | scripts/config --enable CONFIG_CXL_SUSPEND
> +  | scripts/config --enable CONFIG_CXL_REGION
> +  | scripts/config --enable CONFIG_CXL_REGION_INVALIDATION_TEST
> +  | scripts/config --enable CONFIG_PCIEAER_CXL
> +  | scripts/config --enable CONFIG_TRANSPARENT_HUGEPAGE
> +  | scripts/config --enable CONFIG_DEV_DAX
> +  | scripts/config --enable CONFIG_DEV_DAX_HMEM
> +  | scripts/config --enable CONFIG_DEV_DAX_KMEM
> +  | scripts/config --enable CONFIG_DEV_DAX_PMEM
> +  `----
> +  The above configures for statically linked drivers. They could be
> +  dynamically linked as modules as well.
> +
> +
> +2.2 ndctl - v77 or later
> +~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +
> +2.3 QEMU - v8.0.3 + the following patches:
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +  20230227163157.6621-1-Jonathan.Cameron@huawei.com
> +  20230303150908.27889-1-Jonathan.Cameron@huawei.com
> +  <https://lore.kernel.org/linux-cxl/20230303152903.28103-1-Jonathan.Cameron@huawei.com/\#r>
> +
> +
> +2.4 Python modules:
> +~~~~~~~~~~~~~~~~~~~
> +
> +  The following python modules are required: json subprocess os argparse
> +  logging
> +
> +
> +2.5 Additional tool details
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +  <https://confluence.amd.com/display/ALK/CXL+QEMU>

Internal-only web page?

> +
> +
> +3 Usage
> +=======
> +
> +  The utility requires one of the sub-commands: plugin,unplug,list,swap.
> +
> +  Commandline usage information:
> +  ,----
> +  | usage: cxl-hotplug.py [-h] {plugin,unplug,list,swap} ...
> +  | 
> +  | positional arguments:
> +  | {plugin,unplug,list,swap}
> +  | 
> +  | options:
> +  |   -h, --help            show this help message and exit
> +  `----
> +
> +  Commandline plugin usage information:
> +  ,----
> +  | usage: cxl-hotplug.py plugin [-h] -m MEMDEV [-c CONFIG_FILE] [-d]
> +  | 
> +  | options:
> +  |   -h, --help      show this help message and exit
> +  |   -m MEMDEV       CXL memory device to prepare for unplug
> +  |   -c CONFIG_FILE  CXL JSON configuration file to use
> +  |   -d, --debug     Enable debugging
> +  `----
> +
> +  Commandline unplug usage information:
> +  ,----
> +  | usage: cxl-hotplug.py unplug [-h] -m MEMDEV [-c CONFIG_FILE] [-d]
> +  | 
> +  | options:
> +  |   -h, --help      show this help message and exit
> +  |   -m MEMDEV       CXL memory device to prepare for unplug
> +  |   -c CONFIG_FILE  CXL JSON configuration file to save
> +  |   -d, --debug     Enable debugging
> +  `----
> +
> +  Commandline swap usage information:
> +  ,----
> +  | usage: cxl-hotplug.py swap [-h] -m MEMDEV [-d]
> +  | 
> +  | options:
> +  |   -h, --help   show this help message and exit
> +  |   -m MEMDEV    CXL memory device to swap
> +  |   -d, --debug  Enable debugging
> +  `----
> +
> +
> +4 Examples
> +==========
> +
> +4.1 Swap a device
> +~~~~~~~~~~~~~~~~~
> +
> +  ,----
> +  | # cxl create-region -t ram -m  mem0 -d decoder0.0 -w 1 -s 256M
> +  | # ./cxl-hotplug.py swap -m mem0
> +  | Device 'mem0' can now be safely removed.
> +  | Card is ready for removal.
> +  | Press any key to continue after card reinsertion.
> +  | Region created for 'mem0'.
> +  `----
> +
> +
> +4.2 Manually unplug and plugin a device
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +  ,----
> +  | # cxl create-region -t ram -m  mem0 -d decoder0.0 -w 1 -s 256M
> +  | # ./cxl-hotplug.py unplug -m mem0 -c my-cxl.json
> +  | # ./cxl-hotplug.py plugin -m mem0 -c my-cxl.json
> +  `----
> +
> +
> +4.3 Manually unplug and plugin a device (w/ step by step details)
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +  ,----
> +  | # cxl list 
> +  | [
> +  |   {
> +  |     "memdev":"mem0",
> +  |     "ram_size":268435456,
> +  |     "serial":0,
> +  |     "host":"0000:0d:00.0"
> +  |   }
> +  | ]
> +  | 
> +  | # ./cxl-hotplug.py list
> +  | Device        Region Name        Region Size        Movable
> +  | ======        ===========        ===========        =======
> +  |   mem0                 NA                 NA             NA
> +  | 
> +  | # cxl  create-region -t ram -m  mem0 -d decoder0.0 -w 1 -s 256M 
> +  | {
> +  |   "region":"region0",
> +  |   "resource":"0x890000000",
> +  |   "size":"256.00 MiB (268.44 MB)",
> +  |   "type":"ram",
> +  |   "interleave_ways":1,
> +  |   "interleave_granularity":256,
> +  |   "decode_state":"commit",
> +  |   "mappings":[
> +  |     {
> +  |       "position":0,
> +  |       "memdev":"mem0",
> +  |       "decoder":"decoder2.0"
> +  |     }
> +  |   ]
> +  | }
> +  | cxl region: cmd_create_region: created 1 region
> +  | 
> +  | # cxl list 
> +  | [
> +  |   {
> +  |     "memdevs":[
> +  |       {
> +  | 	"memdev":"mem0",
> +  | 	"ram_size":268435456,
> +  | 	"serial":0,
> +  | 	"host":"0000:0d:00.0"
> +  |       }
> +  |     ]
> +  |   },
> +  |   {
> +  |     "regions":[
> +  |       {
> +  | 	"region":"region0",
> +  | 	"resource":36775657472,
> +  | 	"size":268435456,
> +  | 	"type":"ram",
> +  | 	"interleave_ways":1,
> +  | 	"interleave_granularity":256,
> +  | 	"decode_state":"commit"
> +  |       }
> +  |     ]
> +  |   }
> +  | ]
> +  | 
> +  | # ./cxl-hotplug.py list
> +  | Device        Region Name        Region Size        Movable
> +  | ======        ===========        ===========        =======
> +  |   mem0            region0          268435456           True
> +  | 
> +  | # ./cxl-hotplug.py unplug -m mem0 
> +  | Device 'mem0' can now be safely removed.
> +  | 
> +  | # cxl list 
> +  | [
> +  |   {
> +  |     "memdev":"mem0",
> +  |     "ram_size":268435456,
> +  |     "serial":0,
> +  |     "host":"0000:0d:00.0"
> +  |   }
> +  | ]
> +  | 
> +  | # ./cxl-hotplug.py list
> +  | Device        Region Name        Region Size        Movable
> +  | ======        ===========        ===========        =======
> +  |   mem0                 NA                 NA             NA
> +  | 
> +  | # ./cxl-hotplug.py plugin -m mem0 
> +  | Region created for 'mem0'.
> +  | 
> +  | # cxl list 
> +  | [
> +  |   {
> +  |     "memdevs":[
> +  |       {
> +  | 	"memdev":"mem0",
> +  | 	"ram_size":268435456,
> +  | 	"serial":0,
> +  | 	"host":"0000:0d:00.0"
> +  |       }
> +  |     ]
> +  |   },
> +  |   {
> +  |     "regions":[
> +  |       {
> +  | 	"region":"region0",
> +  | 	"resource":36775657472,
> +  | 	"size":268435456,
> +  | 	"type":"ram",
> +  | 	"interleave_ways":1,
> +  | 	"interleave_granularity":256,
> +  | 	"decode_state":"commit"
> +  |       }
> +  |     ]
> +  |   }
> +  | ]
> +  | 
> +  | # ./cxl-hotplug.py list
> +  | Device        Region Name        Region Size        Movable
> +  | ======        ===========        ===========        =======
> +  |   mem0            region0          268435456           True
> +  `----

Overall I like wrapping all the details of the focused sub-commands into
something that is more goal oriented. I have no heartburn with carrying
this in cxl/contrib/ while figuring out if this should also be hooked as
a formal sub-command set.


> diff --git a/cxl-hotplug.py b/cxl-hotplug.py
> new file mode 100755
> index 0000000..971e4e7
> --- /dev/null
> +++ b/cxl-hotplug.py
> @@ -0,0 +1,366 @@
> +#!/usr/bin/python3
> +# SPDX-License-Identifier: LGPL-2.1
> +#
> +# Copyright (C) 2023, Advanced Micro Devices (AMD). All rights reserved.
> +#
> +# @Author - Terry Bowman
> +#
> +# Utility to support CXL hotplug removal and re-insertion. The purpose
> +# is to recreate a CXL region during insertion that existed before
> +# removal.
> +#
> +# '--unplug' sub-command option will save the CXL region information to
> +# a file before a manual hotplug removal.
> +#
> +# '--plugin' sub-command after hotplug insertion will recreate a device
> +# region using the details from the configuration file.
> +#
> +# '--swap' sub-command will run the same functionality as '--unplug',
> +# then prompt for when the card is plugged in, and then execute the
> +# '--plugin' functionality.
> +#
> +# '--list' sub-command will list the CXL devices and associated regions.
> +#
> +
> +import json
> +import subprocess
> +import os
> +import argparse
> +import logging
> +import tempfile
> +
> +class cxl_json:
> +
> +    cxl_memdev_json = {}
> +    decoders_root_json = {}
> +    regions_decoder_json = {}
> +    daxregion_json = {}
> +    daxregion_devices_json = {}
> +
> +    def cxl_list_memdev(self, memdev):
> +        result = subprocess.run(["cxl", "list", "-m", memdev, "-RBMTXEPD"],
> +                                capture_output=True, text=True)
> +        if result.returncode != 0:
> +            print("Error: cxl list command failed for: " + memdev)
> +            exit(1)
> +
> +        result_json = json.loads(result.stdout)
> +
> +        if not result_json:
> +            print("CXL list is empty for: " + memdev)
> +            exit(1)
> +
> +        return(result_json[0])
> +
> +    # Cache embedded json dictionaries to make more easily accessible.
> +    # This helps in later processing .
> +    #
> +    # If the CXL json dictionary is missing any CXL components than this
> +    # implies a CXL device is not configured. In this case exit with an
> +    # error and message.
> +    def decode_json(self, fatal_error = True):
> +        for key in self.cxl_memdev_json:
> +            if key.startswith('decoders:root'):
> +                self.decoders_root_json = self.cxl_memdev_json[key][0]
> +        if self.decoders_root_json == None or \
> +           len(self.decoders_root_json) == 0:
> +            if fatal_error == True:
> +                print("Error: Failed to find decoder root CXL json.")
> +                exit(1)
> +            else:
> +                return
> +
> +        regions_decoder_key = "regions:" + self.decoders_root_json.get('decoder')
> +        if self.decoders_root_json.get(regions_decoder_key) == None:
> +            if fatal_error == True:
> +                print("Error: Failed to find region decoder in CXL json.")
> +                exit(1)
> +            else:
> +                return
> +
> +        self.regions_decoder_json = self.decoders_root_json.get(regions_decoder_key)[0]
> +        if len(self.regions_decoder_json) == 0:
> +            if fatal_error == True:
> +                print("Error: Failed to find region decoder in CXL json.")
> +                exit(1)
> +            else:
> +                return
> +
> +        # PMEM CXL JSON does not include DAX keys searched for below, return early
> +        if 'pmem' == self.regions_decoder_json.get('type'):
> +            return;
> +
> +        for key in self.regions_decoder_json:
> +            if key.startswith('daxregion'):
> +                self.daxregion_json = self.regions_decoder_json[key]
> +        if len(self.daxregion_json) == 0:
> +            if fatal_error == True:
> +                print("Error: Failed to find daxregion in CXL json.")
> +                exit(1)
> +            else:
> +                return
> +
> +        for key in self.daxregion_json:
> +            if key.startswith('devices'):
> +                self.daxregion_devices_json = self.daxregion_json[key][0]
> +        if len(self.daxregion_devices_json) == 0:
> +            if fatal_error == True:
> +                print("Error: Failed to find daxregion devices in CXL json.")
> +                exit(1)
> +            else:
> +                return
> +
> +    def get_block_size_bytes(self):
> +        result = subprocess.run(["cat", "/sys/devices/system/memory/block_size_bytes"],
> +                                capture_output=True, text=True)
> +        if result.returncode != 0:
> +            print("Error: cxl destroy-region command failed. rc = " +
> +                  str(result.returncode))
> +            exit(1)
> +        return int(result.stdout, 16)
> +
> +    def is_region_movable(self):
> +
> +        # PMEM doesn't have movable concept
> +        if 'pmem' == self.regions_decoder_json.get('type'):
> +            return True;
> +
> +        block_size_bytes = self.get_block_size_bytes()
> +        resource = self.regions_decoder_json.get('resource')
> +        resource_size = self.regions_decoder_json.get('size')
> +        start_block = int(resource/block_size_bytes)
> +        stop_block = int((resource+resource_size)/block_size_bytes - 1)
> +        is_movable = True
> +
> +        for i in range(0,(stop_block-start_block + 1)):
> +            block = start_block + i
> +            block_str = ("/sys/devices/system/memory/memory" + str(block) +
> +                         "/valid_zones")
> +            result = subprocess.run(["cat", block_str],
> +                                    capture_output=True, text=True)
> +            if result.returncode != 0:
> +                print("Error: Block cat command failed. rc = " +
> +                      str(result.returncode))
> +                exit(1)
> +
> +            if "Movable" not in result.stdout:
> +                is_movable = False
> +                break;
> +
> +        return is_movable
> +
> +class cxl_unplug(cxl_json):
> +
> +    def __init__(self, memdev, config_file):
> +        # Capture the current CXL (and DAX) configurations. Save
> +        # configurations to file for using later with '--plugin'
> +        # hot-plug adding the memory device.
> +        self.cxl_memdev_json = self.cxl_list_memdev(memdev)
> +        self.serialize_json(self.cxl_memdev_json, config_file)
> +        self.decode_json()
> +
> +        if (self.regions_decoder_json.get('interleave_ways')>1):
> +            print("Interleaved devices are not supported.")
> +            exit(1)
> +
> +    def serialize_json(self, json_str, filename):
> +        with open( filename , "w" ) as write:
> +            json.dump(json_str, write)
> +
> +    def is_dax_memory_offline(self, dax_dev_json):
> +        result = subprocess.run(["daxctl", "list"],
> +                                capture_output=True, text=True)
> +        if result.returncode != 0:
> +            print("Error: daxctl offline command failed command. rc = " +
> +                  str(result.returncode))
> +            exit(1)
> +
> +        dax_dev_online_mb = json.loads(result.stdout)[0]["online_memblocks"]
> +        logging.debug("online_memblocks = " +
> +                      str(json.loads(result.stdout)[0]["online_memblocks"]))
> +        return dax_dev_online_mb == 0
> +
> +    def offline_dax_memory(self):
> +        # Note: self.daxregion_devices_json['movable'] JSON key is missing
> +        # when True (ndctl v77). As a result, use the function region_movable()
> +        if self.is_region_movable() == False:
> +            print("Error: Entire region memory is not zone movable.")
> +            exit(1)
> +
> +        dax_dev = self.daxregion_devices_json['chardev']
> +        result=subprocess.run(["daxctl", "offline-memory", dax_dev],
> +                              capture_output=True, text=True)
> +        if result.returncode != 0:
> +            if self.is_dax_memory_offline(dax_dev) == False:
> +                print("Error: daxctl offline command failed. rc = " +
> +                      str(result.returncode))
> +                exit(1)
> +
> +    def offline_memory(self):
> +        if 'ram' == self.regions_decoder_json.get('type'):
> +            self.offline_dax_memory()
> +
> +    def cxl_destroy_region(self):
> +        result = subprocess.run(["cxl", "destroy-region",
> +                                 str(self.regions_decoder_json.get('region')),
> +                                 "--force"],
> +                                capture_output=True, text=True)
> +        if result.returncode != 0:
> +            print("Error: cxl destroy-region command failed. rc = " +
> +                  str(result.returncode))
> +            exit(1)
> +
> +    def unplug(self):
> +        unplug_dev.offline_memory()
> +        unplug_dev.cxl_destroy_region()
> +        print("Device \'" + args.memdev + "\' can now be safely removed.")
> +
> +class cxl_plugin(cxl_json):
> +
> +    def __init__(self, config_file):
> +        f = open(config_file)
> +        self.cxl_memdev_json = json.load(f)
> +        self.decode_json()
> +
> +        if (self.regions_decoder_json.get('interleave_ways')>1):
> +            print("Interleaved devices are not supported.")
> +            exit(1)
> +
> +    def cxl_create_region(self, cxl_memdev_json, memdev):
> +        type = self.regions_decoder_json.get('type');
> +        decoder = self.decoders_root_json.get('decoder')
> +        interleave_ways = self.regions_decoder_json.get('interleave_ways')
> +        interleave_granularity = self.regions_decoder_json.get('interleave_granularity')
> +        size = self.regions_decoder_json.get('size')
> +
> +        result = subprocess.run(["cxl", "create-region",
> +                                 "-m", memdev,
> +                                 "-t", type,
> +                                 "-d", decoder,
> +                                 "-w", str(interleave_ways),
> +                                 "-s", str(size),
> +                                 "--debug"],
> +                                capture_output=True, text=True)
> +        if result.returncode!=0:
> +            print("Error: cxl destroy-region command failed. rc = " +
> +                  str(result.returncode))
> +            exit(1)
> +
> +    def plugin(self, memdev):
> +        self.cxl_create_region(self.cxl_memdev_json, memdev)
> +        print("Region created for \'" + memdev + "\'.")
> +
> +class cxl_list(cxl_json):
> +
> +    cxl_memdevs_json = {}
> +
> +    def __init__(self):
> +        self.cxl_memdevs_json = self.cxl_list_memdevs()
> +
> +    def display_memdevs(self):
> +        if (self.cxl_memdevs_json == None):
> +            print("Error: Failed to find memory devices")
> +            return
> +
> +        if (len(self.cxl_memdevs_json) == 0):
> +            print("Error: Failed to find memory devices")
> +            return
> +
> +        print("Device        Region Name        Region Size        Movable")
> +        print("======        ===========        ===========        =======")
> +
> +        for memdev in self.cxl_memdevs_json:
> +            self.cxl_memdev_json = self.cxl_list_memdev(memdev['memdev'])
> +            self.decode_json(fatal_error = False)
> +            if len(self.regions_decoder_json) != 0:
> +                region = self.regions_decoder_json.get('region');
> +                size = self.regions_decoder_json.get('size')
> +                is_movable_str = "True"
> +                if self.is_region_movable() == 0:
> +                        is_movable_str = "False"
> +            else:
> +                region = 'NA'
> +                size = 'NA'
> +                is_movable_str = 'NA'
> +
> +            print("%6s %18s %18s %14s" %
> +                  (memdev['memdev'], region, size, is_movable_str))
> +
> +    def cxl_list_memdevs(self):
> +        result = subprocess.run(["cxl", "list", "-M"],
> +                                capture_output=True, text=True)
> +        if result.returncode != 0:
> +            print("Error: cxl list command failed.")
> +            exit(1)
> +
> +        logging.debug("cxl_memdevs_json = " + result.stdout)
> +        self.cxl_memdevs_json = json.loads(result.stdout);
> +
> +        return(self.cxl_memdevs_json)
> +
> +def init_args():
> +    parser = argparse.ArgumentParser()
> +    subparsers = parser.add_subparsers(dest='subparser_name', required=True)
> +
> +    parser_plugin = subparsers.add_parser('plugin')
> +    parser_plugin.add_argument('-m', dest='memdev',
> +                               help='CXL memory device to prepare for unplug',
> +                               required=True)
> +    parser_plugin.add_argument('-c', dest='config_file',
> +                               help='CXL JSON configuration file to save/use',
> +                               required=False, default="cxl.json")
> +    parser_plugin.add_argument('-d', '--debug', help='Enable debug logging',
> +                               required=False, action='store_true')
> +
> +    parser_unplug = subparsers.add_parser('unplug')
> +    parser_unplug.add_argument('-m', dest='memdev',
> +                               help='CXL memory device to prepare for unplug',
> +                               required=True)
> +    parser_unplug.add_argument('-c', dest='config_file',
> +                               help='CXL JSON configuration file to save/use',
> +                               required=False, default="cxl.json")
> +    parser_unplug.add_argument('-d', '--debug', help='Enable debugging',
> +                               required=False, action='store_true')
> +
> +    parser_list = subparsers.add_parser('list')
> +    parser_list.add_argument('-d', '--debug', help='Enable debugging',
> +                             required=False, action='store_true')
> +
> +    parser_swap = subparsers.add_parser('swap')
> +    parser_swap.add_argument('-m', dest='memdev',
> +                               help='CXL memory device to swap',
> +                               required=True)
> +    parser_swap.add_argument('-d', '--debug', help='Enable debugging',
> +                             required=False, action='store_true')
> +
> +    return parser.parse_args()
> +
> +args = init_args()
> +if args.debug:
> +    logging.basicConfig(level=logging.DEBUG)
> +
> +logging.debug("args = " + str(args))
> +
> +if args.subparser_name == 'list':
> +    list_dev = cxl_list();
> +    list_dev.display_memdevs()
> +
> +if args.subparser_name == 'unplug':
> +    unplug_dev = cxl_unplug(args.memdev, args.config_file);
> +    unplug_dev.unplug()
> +
> +if args.subparser_name == 'plugin':
> +    plugin_dev = cxl_plugin(args.config_file);
> +    plugin_dev.plugin(args.memdev)
> +
> +if args.subparser_name == 'swap':
> +    f, filename = tempfile.mkstemp()
> +    unplug_dev = cxl_unplug(args.memdev, filename);
> +    unplug_dev.unplug()
> +
> +    print("Card is ready for removal.")
> +    input("Press any key to continue after card reinsertion.")
> +
> +    plugin_dev = cxl_plugin(filename);
> +    plugin_dev.plugin(args.memdev)
> +    os.close(f)
> -- 
> 2.34.1
> 


