Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927BF7E0
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 01:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669771570; x=1701307570;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=TqesiMM6IlkOygCVD2e9kJF0c6aWCmNVZd273V+jhwk=;
  b=l3IKlDpZ2hSmSA48BpjbM461ySnElq2jYISJhxMWvngNTdT5cY/VFkyb
   ih1UiOVyOf9Zz3dtwa+gtgUwulTB4nQyTSPw35bPlw0ivLA8tGZdTGOEO
   wjV267GDsmyKIpIb8hsErVUUcPs3O+rvzTl9ir9HqCzGdB7YkWvMhQNc4
   4aRKhHb9tAHMtmM+O05dMEY0NvuMOi3uIKZd/XkEVivvdQa9mRcGEitx4
   0057jyWpSRQOX2b6K1Te5lWujo9Kq2uHdyxvnTS5NxPTPmzdz30gQ7o7K
   d0pUV86JKKIfn7reSEKcdIuZjFKi0AzDWR2FSQD4ti8dHqGAMDaFcgPZe
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="342198595"
X-IronPort-AV: E=Sophos;i="5.96,204,1665471600"; 
   d="scan'208";a="342198595"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 17:26:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="750119994"
X-IronPort-AV: E=Sophos;i="5.96,204,1665471600"; 
   d="scan'208";a="750119994"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 29 Nov 2022 17:26:09 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 29 Nov 2022 17:26:09 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 29 Nov 2022 17:26:09 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 29 Nov 2022 17:26:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HW1Zrh06E4Kj5fSk/ZAC+gJmIkqtWnuvIp62QbjkrDgNqrisiQxPH9puTiK/ilnzob6lHieMpniXQekhxIHXVSP4JCVsjYUUvH5AXH+azrb2Z9rrZ6lVw/EB7LcJ9i4x7e7s3DdtRazmIllomqEbdPzBWmKfndOhqkMZRnPMzrBdedVxTc5MzNCDc6hva+YYvJrsd7dmf+eUBoWTVh7Ddqn+GYDuwB4HjixdokosOVxxoQUbzsCv0qDZ/0l7QTcNyOwI7rxf5sTZ2Nz7P7What2IcELASRqivmGwOtU1TtVe6QDc6rRWVE5v1/MGcrPIsh6jMt1B8yBB0c3xBshyew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nSsXMJtbID5YpMCW/u5nkIQjPR6cB5DkB6hLKxqSXJw=;
 b=Yfftt890wxX7wglu9ZeXjrxe8VNQ8pRN8+Xv53LOYs74QC2OTdy/xDR0CuBi1/Q5s2IMflZjzui4ZDwvAagUCh29R+nnF+KLvltNxwlBSFe4uKTDjCOtJLTac7rciHVh5/LPF8NGEKuB60c8zibNIHxDSi9O18ccVe4hODWo1dns5J0HzI1rVjmNmRYngkc/dMjWF2sZECf2zfzzBek4KtCnZyrW6AthtQLMmux0YRn6ineRtZNQwGliKuwpLrphXD+/kQkj5VK7BOSDj+tLlDpxPhA4ARtM8aRBmJ4rwjBJfwb+JJjoeL5QgIfBCnj0FneEbp7/7SAozxDXXq5aHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by PH7PR11MB6450.namprd11.prod.outlook.com
 (2603:10b6:510:1f5::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 01:26:06 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 01:26:06 +0000
Date: Tue, 29 Nov 2022 17:26:04 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
CC: <dan.j.williams@intel.com>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>,
	<Jonathan.Cameron@huawei.com>, <dave@stgolabs.net>,
	<benjamin.cheatham@amd.com>
Subject: RE: [PATCH v5 17/18] libnvdimm: Introduce
 CONFIG_NVDIMM_SECURITY_TEST flag
Message-ID: <6386b12c414dd_3cbe0294da@dwillia2-xfh.jf.intel.com.notmuch>
References: <166863336073.80269.10366236775799773727.stgit@djiang5-desk3.ch.intel.com>
 <166863356449.80269.10160948733785901265.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <166863356449.80269.10160948733785901265.stgit@djiang5-desk3.ch.intel.com>
X-ClientProxiedBy: BYAPR07CA0027.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::40) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|PH7PR11MB6450:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cd7bd99-320f-4d42-4b35-08dad271da63
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fwPRf8as0zI+3mQR9dL4OYzmM42qlkvK1jU9uIdeQUB4Tvdky//xFRCHBfk+HDxHnEQE1imAtWwBz7RMbccsqniuGmH9k160Uw8ZOENKr2+jy9w3qtOR/RqRgTWp707sh7SaUney913t3BMuDoQewHxWXT1NSmPw+iQCrA+BgIsmLDZEp8VrTRqo/cpevqxyS2+6kIxKEAcF2prbP80LfIngxFxV2bqBBdKI7GDc2OOeqdaUqDuZwpc1X+f3x+JjuSZcfzhSvvdMvxObjMIQ7fRuMXKUbHoetgkK9Cx/cVjc6XWUOmjUZpKTJtCb9mlx8Z9dhMFdAnH2m58FZw8tPC23vpc8ioQwqCSJr/wSIxCZyTLwubol1fYOJRJ+CcoHb5AItDT2Z4ftknf6vEkbyW3q/sfP5OkDKKRiYzc0NPHyVSpaJJ3GVDPUtKD9sKIBFISXYZcVCiyTFD5pYmk7BSMfO2xzXCEUo29Vh2JvaExHiGyDHHVXd9tiakOch/vkLpcX/N089fsP+Go6R0Yt6HnmoP0xurgigShf3n8ZeQN/uQMKen9cqz+P+VNUmUq8uGvl0kyNRYTFGnHfWS/8YO5fcfQ0AdVmP8uWE/uQHg/Pa348P2iY47VKq6ba4EhkDFzmc1nyCEQPNxZ3NenNPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199015)(38100700002)(6506007)(82960400001)(26005)(86362001)(316002)(66946007)(5660300002)(9686003)(66556008)(6512007)(4326008)(8936002)(8676002)(66476007)(83380400001)(2906002)(478600001)(6486002)(41300700001)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P4tQ4fUlVxR9xC/rtWLs3koHJtHeQ+7Z+LG2p5bzLYRH9hOlb2nQ+A5iRO4K?=
 =?us-ascii?Q?Pv/J1VYDAjYeD8+7AzpRru9MyQ6h7/uCZK/4lWvQPrXCYUFC5MH5mKA9lJp6?=
 =?us-ascii?Q?Fb0Q/qbM9C0jJlABI9CPQou7D/j8u0HRCPGlmQFqWH2PGydFr6FkkkMw4/LA?=
 =?us-ascii?Q?bmMJaaWjFhYSuDvSQF96/NSJpmFhFSA9+1N/Pf8pi4zukQJm/nLGf1cR/tQb?=
 =?us-ascii?Q?6XDY4B79wYBdSYiloBG2ofPky/CexzKCBypqe4Mjp9AqIm0hoc47nejXUQ1T?=
 =?us-ascii?Q?dkGXkSmBElGbrky3NhUmcNKWTUOLchP1LVgdZDNvkb8kcVzLVLlcGF8SVYHe?=
 =?us-ascii?Q?K8aGg98kSdw0uR+6eFKrNA+UEEouNJZnu8k65bQUzeQdtU7gz9SYBIGCXxPG?=
 =?us-ascii?Q?1FO8DAL5XywPXQgvsLDH7QOTpLGTaxXd0hb996nPVfNuq9+InRb/WQxMQtze?=
 =?us-ascii?Q?SkMXPhbUKUMMNQY/D0hwmUk59zH8HasCSGvov+X5PGa4rBxONCCDKNkOb3oS?=
 =?us-ascii?Q?QdR7JMRyFAepMGj/W7htBXSuszUVAFNFbtF/NyAIoT+LKG3ZHAOW9rhvLMUe?=
 =?us-ascii?Q?5DDVksiRyU0GX4Ibfe+vhjvhESxgH8+bjBBUKxpJyULhn+inX0bRhVpnS5FG?=
 =?us-ascii?Q?c4GuBvI5tB5CEwSbNoUI29cyg47YWEcB3uZIjbJoVzzbW86hqOI7Jj1MfZVl?=
 =?us-ascii?Q?e3AJ0BKJV98wJYo4nVXohdExhlEqSGh0RAlRCbfS4Jccn2Zw58e9cM+rlSLz?=
 =?us-ascii?Q?i94pvWU9tD1dbRbqEBxCLJv5PMMlf3PqCsnhhxhhrDoHpNsKXHp4CWzoJ4hY?=
 =?us-ascii?Q?/BarNL+ktqlz1iJznLiBaP18qK8Wj8kQCHMmTGYpef6x8PfgoYe5Z8+7kwYc?=
 =?us-ascii?Q?/SWWnuD533PayhIcKmpJPxu51Tbz67C1DM8QL8BoRDurTt3p2xCO+BOVNPUw?=
 =?us-ascii?Q?weqCq4ZuSh6HNoaqUxB0dOu/8uXXUoB5z7AdXV/yb/1de5RM8d3AO0ZFCdFA?=
 =?us-ascii?Q?vbcIRp0u1nMGp4UN8XnQPFZVpj+jByuSqfIJeRcKSmtXudnojGRP5mn9vbT4?=
 =?us-ascii?Q?zgEsCpMTJkxzL9qzX2xXDQ1is2wdljaBxsNWNcQcVT9dwDRdoSNi9Ug+nOmn?=
 =?us-ascii?Q?8Z/vFtP8MUEeyQRfjIFJbgD2IdI1MwrClsXtCmy+HNqjJr7InrpbqRkDAun/?=
 =?us-ascii?Q?DYmzLmIL1lGpWL+nGbRAk7a0u2j2rODUEMcKJsXQnsLujLNNEKQAE0n6N1WI?=
 =?us-ascii?Q?a0JYfJFiy7qhK7d02ZpVoczhX+FuSG6TeyYK8+RmTd/3+8ZT0wt9m1zZmUJk?=
 =?us-ascii?Q?Xrc7oy+pdy0TExhYKrDIiE4IaxNwTEZ+bOseKkuBKk3wJdig1YeuvF1rpjoW?=
 =?us-ascii?Q?3YQG3vvpNxmu6ABJXu7j99kqMLUBSjPM8rL3f+l/xqEqqT5WKz7F8L/GLKoD?=
 =?us-ascii?Q?ermiBAGRsi/4c0sfzi/YFJtHrzqnnN+WKOm9+kLCxffRd7VL8Wi3fkFU4/d9?=
 =?us-ascii?Q?A5sIzICHhMmV42lXTlOPd2D/Ts8g9GuLF4sTxALdgg4zF+r8w3kLUkS3DhVH?=
 =?us-ascii?Q?xhJcyNGSpUoBScoPWuxazQ4Swerant3VlqWfY5zX5BOl5Sk/+bSw+yz+OVuC?=
 =?us-ascii?Q?ww=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cd7bd99-320f-4d42-4b35-08dad271da63
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 01:26:06.4674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4QQlvz/+a6TOzOc6p8xaz3k6stUBNfL4r13u/Kr3qcJzlPIbSuwMEKTbej3tWRy63xviUvffMAKxfhSgx681/WSLiV1RiEuPc+5kfJp9EKc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6450
X-OriginatorOrg: intel.com

Dave Jiang wrote:
> nfit_test overrode the security_show() sysfs attribute function in nvdimm
> dimm_devs in order to allow testing of security unlock. With the
> introduction of CXL security commands, the trick to override
> security_show() becomes significantly more complicated. By introdcing a
> security flag CONFIG_NVDIMM_SECURITY_TEST, libnvdimm can just toggle the
> check via a compile option. In addition the original override can can be
> removed from tools/testing/nvdimm/.

This can be updated to also talk about the new workaround for running
tests with cpu_cache_invalidate_memregion() on QEMU.

> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/nvdimm/Kconfig           |   12 ++++++++++++
>  drivers/nvdimm/dimm_devs.c       |    9 ++++++++-
>  drivers/nvdimm/security.c        |    4 ++++
>  tools/testing/nvdimm/Kbuild      |    1 -
>  tools/testing/nvdimm/dimm_devs.c |   30 ------------------------------
>  5 files changed, 24 insertions(+), 32 deletions(-)
>  delete mode 100644 tools/testing/nvdimm/dimm_devs.c
> 
> diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
> index 5a29046e3319..3eaa94f61da6 100644
> --- a/drivers/nvdimm/Kconfig
> +++ b/drivers/nvdimm/Kconfig
> @@ -114,4 +114,16 @@ config NVDIMM_TEST_BUILD
>  	  core devm_memremap_pages() implementation and other
>  	  infrastructure.
>  
> +config NVDIMM_SECURITY_TEST
> +	bool "Nvdimm security test code toggle"

s/Nvdimm security test code toggle/Enable NVDIMM security unit tests/

> +	depends on NVDIMM_KEYS
> +	help
> +	  Debug flag for security testing when using nfit_test or cxl_test
> +	  modules in tools/testing/.
> +
> +	  Select Y if using nfit_test or cxl_test for security testing.
> +	  Selecting this option when not using cxl_test introduces 1
> +	  mailbox request to the CXL device to get security status
> +	  for DIMM unlock operation or sysfs attribute "security" read.

How about:

"The NVDIMM and CXL subsystems support unit testing of their device
security state machines. The NVDIMM_SECURITY_TEST option disables CPU
cache maintenance operations around events like secure erase and
overwrite.  Also, when enabled, the NVDIMM subsystem core helps the unit
test implement a mock state machine.

If unsure, say N.
"

> +
>  endif
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index c7c980577491..1fc081dcf631 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -349,11 +349,18 @@ static ssize_t available_slots_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(available_slots);
>  
> -__weak ssize_t security_show(struct device *dev,
> +ssize_t security_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
>  	struct nvdimm *nvdimm = to_nvdimm(dev);
>  
> +	/*
> +	 * For the test version we need to poll the "hardware" in order
> +	 * to get the updated status for unlock testing.
> +	 */
> +	if (IS_ENABLED(CONFIG_NVDIMM_SECURITY_TEST))
> +		nvdimm->sec.flags = nvdimm_security_flags(nvdimm, NVDIMM_USER);
> +
>  	if (test_bit(NVDIMM_SECURITY_OVERWRITE, &nvdimm->sec.flags))
>  		return sprintf(buf, "overwrite\n");
>  	if (test_bit(NVDIMM_SECURITY_DISABLED, &nvdimm->sec.flags))
> diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
> index 92af4c3ca0d3..12a3926f4289 100644
> --- a/drivers/nvdimm/security.c
> +++ b/drivers/nvdimm/security.c
> @@ -177,6 +177,10 @@ static int __nvdimm_security_unlock(struct nvdimm *nvdimm)
>  			|| !nvdimm->sec.flags)
>  		return -EIO;
>  
> +	/* While nfit_test does not need this, cxl_test does */

Perhaps just say "cxl_test needs this to pre-populate the security
state", and leave out nfit_test.

> +	if (IS_ENABLED(CONFIG_NVDIMM_SECURITY_TEST))
> +		nvdimm->sec.flags = nvdimm_security_flags(nvdimm, NVDIMM_USER);
> +
>  	/* No need to go further if security is disabled */
>  	if (test_bit(NVDIMM_SECURITY_DISABLED, &nvdimm->sec.flags))
>  		return 0;
> diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
> index 5eb5c23b062f..8153251ea389 100644
> --- a/tools/testing/nvdimm/Kbuild
> +++ b/tools/testing/nvdimm/Kbuild
> @@ -79,7 +79,6 @@ libnvdimm-$(CONFIG_BTT) += $(NVDIMM_SRC)/btt_devs.o
>  libnvdimm-$(CONFIG_NVDIMM_PFN) += $(NVDIMM_SRC)/pfn_devs.o
>  libnvdimm-$(CONFIG_NVDIMM_DAX) += $(NVDIMM_SRC)/dax_devs.o
>  libnvdimm-$(CONFIG_NVDIMM_KEYS) += $(NVDIMM_SRC)/security.o
> -libnvdimm-y += dimm_devs.o
>  libnvdimm-y += libnvdimm_test.o
>  libnvdimm-y += config_check.o
>  
> diff --git a/tools/testing/nvdimm/dimm_devs.c b/tools/testing/nvdimm/dimm_devs.c
> deleted file mode 100644
> index 57bd27dedf1f..000000000000
> --- a/tools/testing/nvdimm/dimm_devs.c
> +++ /dev/null
> @@ -1,30 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -/* Copyright Intel Corp. 2018 */
> -#include <linux/init.h>
> -#include <linux/module.h>
> -#include <linux/moduleparam.h>
> -#include <linux/nd.h>
> -#include "pmem.h"
> -#include "pfn.h"
> -#include "nd.h"
> -#include "nd-core.h"
> -
> -ssize_t security_show(struct device *dev,
> -		struct device_attribute *attr, char *buf)
> -{
> -	struct nvdimm *nvdimm = to_nvdimm(dev);
> -
> -	/*
> -	 * For the test version we need to poll the "hardware" in order
> -	 * to get the updated status for unlock testing.
> -	 */
> -	nvdimm->sec.flags = nvdimm_security_flags(nvdimm, NVDIMM_USER);
> -
> -	if (test_bit(NVDIMM_SECURITY_DISABLED, &nvdimm->sec.flags))
> -		return sprintf(buf, "disabled\n");
> -	if (test_bit(NVDIMM_SECURITY_UNLOCKED, &nvdimm->sec.flags))
> -		return sprintf(buf, "unlocked\n");
> -	if (test_bit(NVDIMM_SECURITY_LOCKED, &nvdimm->sec.flags))
> -		return sprintf(buf, "locked\n");
> -	return -ENOTTY;
> -}
> 
> 


