Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514B144387
	for <nvdimm@lists.linux.dev>; Thu,  7 Dec 2023 15:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wha95zBB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701963606; x=1733499606;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uE+jOfRoSiefCOnyYmgueAyI+DbYgHKZoKl6u8YuuWw=;
  b=Wha95zBBzf6rAwD3DVRa5opFPqNQsFZjDnyy9anWSmNnZehJZslXTowt
   b23qZxu/UIbDs6EOM8Cs5d69EnzlD80zqEL2l2nahrxAU9Nue4cizjJJT
   pyV+ilavGBbzGQHcR8KQBFAQ3mckf97qF9+8cYhcaCKI1kzExs/YF8An1
   4r+lRdrLK14Bl7zkOPyMCwU6KQ4lTNE8PpJ5XqFBznDKp9kZLsGRrOVmX
   fBsNRPby6alutsWdwcvalvNAfm+OGMpvNCs/9wCayzSV4GyYLKmNYivZ9
   sk5BeOfzfzO3bezRJoEbvF6WxZv+mxZJYkqTZvHQ8p/0vhiOzYkRWlgE/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10917"; a="393986133"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="393986133"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2023 07:40:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10917"; a="945078234"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="945078234"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Dec 2023 07:40:04 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Dec 2023 07:40:04 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Dec 2023 07:40:04 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Dec 2023 07:40:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KcB6ewV9yYg9T6/Iko2FYYVqQKPWB6dmGIk/NrXcNknEzScA47t6v3QEAGTaHDGxkzTL0LyVQKCOWqYIPhxp/k2iA5FfonZjUBpaQpJbVJ5cjJAq0Hq+jhlZ8yZlLerlp4N9CMRfYelQWJJzdGfnbj/Nw5FdVqiPTwOOobUCdZwV2zMBu3029sBKWsfacwl2lnscBkjgGKs7S42wu+Z8Hyf4QfLc9FgvFV6Ivb6JP2uQbNY+W+h+VxlplMIqWUl+6dQFa6u7uHsSV/UfvIjD8zDJXfclrR4oHqU91w+aOdrRmr70OZuKSfwE+2aZ782BIGTJoHSs2mMFGPGSSse2AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=weeFBxnV35nPS5Zr2SmaXWRU9wNYojR4aLbaXFOxvXo=;
 b=Ei1fGeB+IffSqP4y+4yIqzVzwJTMGERcnZqb/dU4NvP7Kqzdyu8BnIc6AUAQDRisZYFA6U514QGlYDLfIYXsn+RqlW9bgBqW/OGxZquI6GVUlSo/aOCqGIqSbwQ5sSHsWi+rigwcXNMEVaCdhwlgx4ErAlubEdNF5fvy4vJQEHju6JlKNh9EN019KdhTajroCZ3E3etDYFxp0KEy66qzIM2UMwMwRcRq02sqd21s6FmsG8bqG5zotvekdflEP7AvBsu6XvhaVEaqOc8AgFMCxyEPk+8JOgO3hjhwAEaetgf53AOraxUXzATXi561syu9sldWTW1ZPI035oAmSghR2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by SA1PR11MB6614.namprd11.prod.outlook.com (2603:10b6:806:255::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24; Thu, 7 Dec
 2023 15:40:01 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6f7b:337d:383c:7ad1]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6f7b:337d:383c:7ad1%4]) with mapi id 15.20.7068.027; Thu, 7 Dec 2023
 15:40:01 +0000
Message-ID: <61759600-c908-4c39-a794-03839975cfcd@intel.com>
Date: Thu, 7 Dec 2023 08:39:58 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [PATCH] tools/testing/nvdimm: Add compile-test coverage for
 ndtest
To: Dan Williams <dan.j.williams@intel.com>, <nvdimm@lists.linux.dev>
CC: Greg KH <gregkh@linuxfoundation.org>, Yi Zhang <yi.zhang@redhat.com>, "Ira
 Weiny" <ira.weiny@intel.com>
References: <170191437889.426826.15528612879942432918.stgit@dwillia2-xfh.jf.intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <170191437889.426826.15528612879942432918.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0075.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::16) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|SA1PR11MB6614:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fa323d8-3e87-4865-0807-08dbf73ac658
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M+VqkkC3Oi7gpH80YCFFD/QK+suOQhWyqTYLb7nCcGBe4bt87IRTRix16pjVMfS6CpORX9SIgz9L6dmdeILZ2kRSZOwEY6BNfBO3+x8M9ZqLMrbbITvfZodoct9FihTU4I91uFXNY7gJgkI03bpwvF7U4Bu41E13uAsQlezEqvBBvW8g7qyu+gFlaoZsmL452Ms7FuqkzCDaTw3jXbd4hypENvMX3PNk9/CuAtZQZwstbp53zqsbF7n+fg2zEJ32wc9rJVzRlIzytgz+KApBfZFOjR+FzhivTzhcTpHkrJYnQLnaJ8CSKEfW/Qii3f3mwJZggw0J80GQM0WP+6pMLfnlHEIFOC63aEs7R/0uP41usff4UWTDuOk7vgx8ac7m+4ySfVLYKRklyKSVt3389+LOtU2C307AevriQWp95/OpatPkJqyY8PfnWOn/pmz4I3XY7ezQVMav7u9aVUSeYRT9vAuj+S/oBvgtLoBKy8isoHMRqD5ls0vODlY7zruQRasckavJMb0CrMN71L1cShoNWJ2zCUcjFkzqJfYqQOCIzgkzmO2+CjwjHkPhfJigsCjGY2zyoF8FnuntR3hpoqYLhxfTwyBjy3nSYl7/lwg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(366004)(396003)(136003)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(66476007)(31696002)(86362001)(6506007)(6666004)(2616005)(26005)(316002)(107886003)(53546011)(6486002)(8936002)(8676002)(44832011)(4326008)(2906002)(5660300002)(966005)(6512007)(478600001)(66556008)(54906003)(36756003)(41300700001)(66946007)(38100700002)(82960400001)(31686004)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bVkwdEJmU254SEtGK09ycDJmWXZBbDRKS2ZTdE1iZkZSY2xkOG0zWk0xNHVk?=
 =?utf-8?B?cmxYYjFnMDRiYkNpNnZsdnF6dkJFenQ0YWtwOFU1d25IVkJ3bnk0eDJZNzcv?=
 =?utf-8?B?My9yRVlDcXZoUThRQk9WU3dwZkkyTVdjdERjV3k4cTVmYUZ6UmlsNjJobG1x?=
 =?utf-8?B?dFBnVmJwdWlOZWdiRGJONldRWTRwbkIxRlNYd0FlUkp5QSs3M09nek1TMGR5?=
 =?utf-8?B?Wk4vazJUdGNHUDcwa3hLUDJqNTB2cEZPeXFRZ0hJNmhON2NSK3hmWVdoZHYy?=
 =?utf-8?B?Y0hpRFIvY3RVT2QreGFVOEQ3NGFkYTZIajRWQ0xEc2lRcjlaSWU3MWJ4eDBO?=
 =?utf-8?B?cmt3OGdxOElKZmVmOTZBYVpFOC82bVIwNnUrbU9qbk93d2tSV3IzT2VPbWM5?=
 =?utf-8?B?OERpTVlwSzB6WG15T2hIa00xTXlObVV2bndKcUt3TVc4VWRlRmRaS0s2Rlpy?=
 =?utf-8?B?UFVuWUc0dEhSd0hQbjVGU01lc2JuTU5JS1J1czFNd2FUODl4eHZMRVNqSm9o?=
 =?utf-8?B?S3RQMGRnUHRxU3FvZVh2WmJVczFUV1FDd0FleC9zMldmMHF2amc0cU4ya25I?=
 =?utf-8?B?ajlpUzk0TzYzZ3JNZFZDM0FiUUhhVHo0cVJnZitmMnpCaDFEOGtUL0VmNlhu?=
 =?utf-8?B?dnhGQmo5Z05jc0Y5elFja1hnZjRQVndGUkNaVU9wMExhME0wUndSbFdGcHpT?=
 =?utf-8?B?QUd0ZXczSGhTcVRNZVpBQ0RnU1hEQ1hxZzZ2TlBPODllcDJIQjRCTHN5eFpG?=
 =?utf-8?B?SWJjWCsxR3M4bmlsSWZKS0Q1bmswL1FpVEF0ZEwrS1IxaDFRcDM1SUc5MzRR?=
 =?utf-8?B?SExOR3VyL0ZGaFdZT1YxZXkwTWY5WGtJNDFrNUJSVjZtZHhOdHZJSk5wT3dL?=
 =?utf-8?B?TTBOVCtEZ3V4Qmd6WXpIelR5YlFNN0JzY2cwWkp5cVJwcUJKZWtyM1c2MTdR?=
 =?utf-8?B?b2hLcllNTjVhRE8wT1F2R1FJSHlKa3J4V2ZiWEtCRFpGRldpS0dUWUs1U2Fr?=
 =?utf-8?B?T2NGWkhhQU82SStNT2ZiakJISTBqUjVRZDNQQ08rT21uWjNzdG9sSi9lOEF0?=
 =?utf-8?B?WnlldElGN2d2N0FmYyt2VHZYSnhlYmVEYTVLZWJiU1NwdXRnNnFUSzFjVFJw?=
 =?utf-8?B?ZGdRWTd0aG9IZkk0dzhyRVBjckFCbjJLR1ZNdUlvYWNQTk42YkkxRGxUMUNC?=
 =?utf-8?B?UVRLRll4eW1WRWYyWTlnVStINEFpb0VrU2RBaHREVU1EVDdQbERtbVVBNzdh?=
 =?utf-8?B?anBCQUNIVU5YaVF2dkJQVGtSbzFRcGdPTlVWeTI1Mk9zWDdxNitrWVdyQzZR?=
 =?utf-8?B?RFlnUFNSR3hPYnJJOHJ3QVBEd2xmbkJQVGxlaU90eW1zSkZqdzJpUE1IZ2Fr?=
 =?utf-8?B?b01BakpqSWUxUzN0bVBiSEYyOGVrbUtTOGFHR29oOTU2aDloQ21HSW1RbWdK?=
 =?utf-8?B?eEtpZlJ5ZERWbzZtK0RkNjU5SVREa0IvSnBoeDAwUnZwa0dwMkxDbWRqTnZC?=
 =?utf-8?B?Q3JkcDJEVjlLVXNkMDZRQkk4Wis0akx6WEtYNXNSZG9LYktESG0yam5NVDNq?=
 =?utf-8?B?Tm5KWElrMGt2RVlFdFJ0NWJ4WWNtbHppZjlqYk1uM0U3eHdZN05pME1Vam5F?=
 =?utf-8?B?YlZGRkF4czY1elZRcFJpUjA1TVdVaU9mWDhrUjVDQ1lJTnVtbjZsc0wwOGFS?=
 =?utf-8?B?MmgySFRCWjZodzBlMzRPWDFGZ2hRb214eFR6ODRNcDZiZ29MODZESVcvRHJ2?=
 =?utf-8?B?UXdETDJZV2FaR3M5N0VHOUQ0MGI5bmR3RW1JTWo5WFgrT1lYYW4xVkFaRDlq?=
 =?utf-8?B?cEJTSVRQeUJPdVVoMXhlbVY4TG56S0MxeURBRDZlMHZBNHFrRkk1U0FkWkVR?=
 =?utf-8?B?aENuMGJBNEJ3cVA1bTVCSFhkSVlRUENGZjdMa09CdHR4dXVmTDV1S2MwME90?=
 =?utf-8?B?ZUphd0VCd3ZOZFBuWS9pSkZTRGczWld6TCt4aEFrdnpQcEJqVFIyYjZGaVd3?=
 =?utf-8?B?Sm5zK01mKzFFdDh6ejlHSlJXQ0Znc1dEMDRYR2hrWklvZmFCbS9TbFpseVJS?=
 =?utf-8?B?SlV4b0ZacmRLZGVXb0g4dDR2aDlNK0ZsRmEreUpFRjJ3YTRVcitKcFJYYmZv?=
 =?utf-8?Q?UnQSpMLtP8U53wQ73M2euTVLn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fa323d8-3e87-4865-0807-08dbf73ac658
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2023 15:40:01.2850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vV6A6TIt8pN19CEX9obFeg7qmCVyli+4Q/Y3HMYrUerff5eqsW4+ote8auDvdtR01cFRGQT67pJJsWxi5KLvIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6614
X-OriginatorOrg: intel.com



On 12/6/23 18:59, Dan Williams wrote:
> Greg lamented:
> "Ick, sorry about that, obviously this test isn't actually built by any
> bots :("
> 
> A quick and dirty way to prevent this problem going forward is to always
> compile ndtest.ko whenever nfit_test is built. While this still does not
> expose the test code to any of the known build bots, it at least makes
> it the case that anyone that runs the x86 tests also compiles the
> powerpc test.
> 
> I.e. the Intel NVDIMM maintainers are less likely to fall into this hole
> in the future.
> 
> Link: http://lore.kernel.org/r/2023112729-aids-drainable-5744@gregkh
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Yi Zhang <yi.zhang@redhat.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  tools/testing/nvdimm/test/Kbuild |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/nvdimm/test/Kbuild b/tools/testing/nvdimm/test/Kbuild
> index 197bcb2b7f35..003d48f5f24f 100644
> --- a/tools/testing/nvdimm/test/Kbuild
> +++ b/tools/testing/nvdimm/test/Kbuild
> @@ -7,6 +7,7 @@ obj-m += nfit_test_iomap.o
>  
>  ifeq  ($(CONFIG_ACPI_NFIT),m)
>  	nfit_test-y := nfit.o
> +	obj-m += ndtest.o
>  else
>  	nfit_test-y := ndtest.o
>  endif
> 
