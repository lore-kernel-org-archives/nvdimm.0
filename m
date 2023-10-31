Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9603F225BA
	for <nvdimm@lists.linux.dev>; Tue, 31 Oct 2023 20:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oDBSK4ks"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698784497; x=1730320497;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=COm6dV+RCbGeWnVRNYT7dxLBVevUOZkK7fpjDVJIorM=;
  b=oDBSK4ks/mbLqjNOBl3OBVpw6ESL5uYCbaRVPoZsKm8VeEOEyY4Uyvsr
   XnfU/x0xsx/UtOrbx4HDTHoNY9CeKK7TpQAZ1WoK6nfmbKLAy5JIDtyQF
   jBqnalSYlZODNteNIFPGgJppxtDK3gJGwp2SHgKnUsZyA77AlmzItCpU/
   XwashKeOwsXbofW1A/ioLbns3pIC63mPnqs6qW45FRZ1Co7NOpiqArx0I
   KXzXifBXFsNicVAQFnaxOET+x6Hejq3RIFg5TErP7N4F+wcxatBj+cq4X
   Vu28BmzDw2D6TwKlhlkh7eTWUDD7vJF9KMbKxDtxMjWbC18rhvOroTEXw
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="391239372"
X-IronPort-AV: E=Sophos;i="6.03,266,1694761200"; 
   d="scan'208";a="391239372"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 13:34:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="710543370"
X-IronPort-AV: E=Sophos;i="6.03,266,1694761200"; 
   d="scan'208";a="710543370"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Oct 2023 13:34:56 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 31 Oct 2023 13:34:55 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 31 Oct 2023 13:34:55 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 31 Oct 2023 13:34:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ms6lrQXv0H8N9vSdeHjBSDQyid0+SKKPiWK33fI/5CAin9J5lrNSlZr7cY15UeQN15yt9roVUB5O5oD8NqtBpsaMescOwOtVDm9dr6/kQOUIx0acdxtzpuQVYwe3ENdFAXDQlEJU1quWFWPjv2yZd+dGV4hjJIbCkD+P/l7ZE7LBNHDZ5AhckCrFTyCAAxj1nSEWwLEMXJCLH+ehMGSG5OyWpTY2LyRCiTtNVsbn7gLba0NPV6C/0cs7QpcML70cBIPSj5nf8RRUZfyYRh6/nIULKber9n4ND4pU3fu6RUvJmQVHQczg68ZMHA81DMilSpY9KLABArXd2g5trwxuYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r7pvHHfcA1TtngGjcYvKiaLUvQne3vP7yn+wpUTr/E8=;
 b=aMGhAK4X+3oCRFbwdPPyf3ZssB83HAF+ZVlnasvKfsHjuaX4QvZ6WPg/HpVonGm0GaVmDpFU/oLgD/hCZizZ2OSky9IPVUtEH/luFpGRtGjUyPkakL0BzbA3SfH6PrmrlFrmJS87H1JxR1AVv8W44a10Dw94kW3JfUYEmMvJ+HxczsMD1/E8sOrNW3GbjvWUYPZ+0I3tRjbomSixYvxsjaO480qZTBGFXdNIF7fkjT1YPqO5gFC3NJfhM74YQkzMwRZe2RHMartHnZV+a52E4dtEHvY08UlBumVXPf4w2XQbkntOE1kyqPFSJWBPKe/q/bi6C4RrGp7M49OHCs9xkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by SA2PR11MB4905.namprd11.prod.outlook.com (2603:10b6:806:117::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.29; Tue, 31 Oct
 2023 20:34:53 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::28a6:ecda:4bb7:2f9e]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::28a6:ecda:4bb7:2f9e%6]) with mapi id 15.20.6933.029; Tue, 31 Oct 2023
 20:34:53 +0000
Message-ID: <47d34bd4-de45-4743-9151-7e6a0cdd5c4a@intel.com>
Date: Tue, 31 Oct 2023 13:34:49 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [NDCTL PATCH] cxl: Augment documentation on cxl operational
 behavior
From: Dave Jiang <dave.jiang@intel.com>
To: <vishal.l.verma@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>, "caoqq@fujitsu.com"
	<caoqq@fujitsu.com>
References: <169878439580.80025.16527732447076656149.stgit@djiang5-mobl3>
Content-Language: en-US
In-Reply-To: <169878439580.80025.16527732447076656149.stgit@djiang5-mobl3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0191.namprd05.prod.outlook.com
 (2603:10b6:a03:330::16) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|SA2PR11MB4905:EE_
X-MS-Office365-Filtering-Correlation-Id: 207bde03-c073-4967-f51d-08dbda50d660
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QUrz3FVi6IHC6AlPe3K4Ya9nHaiV0XOsz2RzkH+lVky3RrJerqR+m1qqWCE74LLWMtuzONGYES3h+sozaHrysAVonc73QLwe953BJMoGcwKqXyv74p7T/7SXIcrGZ4Q1cWFWRa11G081Fn+EQjCzfq190Qdd0TOPAIjhaUzEB5e9pfMZPzFUykukQ35X2pVzGoo89Eacmu7cjvd7M9a7fF0ekJK1qMYnvO+7wiIwdd0TVrg9pUs4KCiUhVy+pWOdkFf4Kj0H81Kfg2RT9JUt7o2mEeJflPBIspKGgr9Yp9O061r4frE1739Dn8ZpglShsrlpWBs6QuXloMFwb5Tj/sPXlTRRUpZFbzvS/uxIC8km31DJLyi+GqKCV7OqqboP1tfuPJTTVh9riMXto+YE60w63nnEo8mdfp8Kbw/VVkqprExVyTif5S9X/nxCIjUR13SwJEB6IOfiw2X07jMv7rxt3P4/0Lvjh9+dKTgWLTt4RlnjxNrehLha4aIaonwPVpG7Vyup3OkjfXjDqmVoBSLXBDwyB/Veu3QzPYo5kiQWnmpCRMl/H4fwNgrDGDRLOO0ZUZUxg4QobTcCamUB+vMWRkt5XTT2qbhiA9v67TBRyk4ZKs0bnIigsqGQs7A8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(39860400002)(366004)(346002)(396003)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(86362001)(6512007)(6666004)(31696002)(31686004)(6486002)(478600001)(38100700002)(82960400001)(53546011)(6506007)(2906002)(36756003)(2616005)(41300700001)(6636002)(66556008)(66476007)(37006003)(26005)(316002)(44832011)(66946007)(8936002)(4326008)(83380400001)(8676002)(34206002)(5660300002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VCtscWE4NGdXRGZEb3BjSjBWNmc0VFA1bXQreDlRQjdBU2pob1c1REFjTlN3?=
 =?utf-8?B?Mzc5NUZaaHlNVEF5VkpIVDJha2JTTk8xOFJjSFlHSGZFNWJDVXJCL3lINnBR?=
 =?utf-8?B?aDV4RzNDbU14NUR3TUMzbEthYjZtM2FPVCtheXNBU291ZkYwNjFRa21VQ3Yr?=
 =?utf-8?B?UUlzTXVMeDIwSmh6MGlzK2hVRUJhUGk0ajBuVmU2SjJ1V2RCKzZadytyUnJp?=
 =?utf-8?B?bGYxTXVkV0UvS25sNnZNb2x2NkxZSVU1ejUrTitUQ1VQRmRSbm9HZlkzTUVs?=
 =?utf-8?B?dE9Hc293NlR0SENsQjUyWEk4eFIvOGtoemQrU2lUQ21tOEZvUCtVWFpQMFA1?=
 =?utf-8?B?WkcxdG92QzY3NnhLTUZyUUNaQTFvQUppdDJxcGxhcFZWTGM4VDJDVWdhR3d0?=
 =?utf-8?B?UkFST1J2allFekVldWdxNEcwQ21hVzdmY1lpbitqaGhoMzJ0YjBVUFgrUGtv?=
 =?utf-8?B?YmloWDBMQVhqTk5UaEh2RjRER3hlR0pHQStYVXF2dkZVVy9ZUVlzNlNnL21p?=
 =?utf-8?B?cUNpNG9LZEUzRnREbVV6dFMzT1N0N0RYSUNSTjdPTzQ0N1VIQSs0ekdMK0Zn?=
 =?utf-8?B?bHpxK1ZDNE4vSndPK3V6dWRsVEVQSzBLRGN1c1Y2VFlzbVNaeTlUZ3crQzJi?=
 =?utf-8?B?ZGV1RUFkdEJYRW5IWWlMSjRHUFd2anBRdTVrazBpUmlBaHFPUG40bzZEVSto?=
 =?utf-8?B?Z3dkOXNIai9hbmh1VnR5KzErbHRKeVBBMDcwV1YyRHM1SGRyQlpoR05yd2pq?=
 =?utf-8?B?ZUxyNTkzL0FxcHpvUTJtWkxZWTNkMDNFenNFWjdOTjlUc2dCb011YWUySXlG?=
 =?utf-8?B?c2duaDJaTVRaNVFQb2prdkVaQnNlWjNmbGJhSVJHSWRqNUtzd3ZQYnVtL1B2?=
 =?utf-8?B?R3NKeHp2Y2swNi91ejVhdE5iYXZwcEoxaEI5dXFycTRlNXlRb0hTejFwcDdB?=
 =?utf-8?B?NkE0dkxRQ3BaenNnaFUvUFNISXZzM3lVazhxRW1SU0pyZXg5cHRPUDgxd2FI?=
 =?utf-8?B?V2EvWnVySXRyYS9Kbi9MNnd1WXBlL1I4Q1RZZXR4ajFxS3E2M1hDZU5GK0Rr?=
 =?utf-8?B?VnhKZFB6SzcyZStqMGxpamk0YXNGN0FZdi9CdjJoVkhBTmp2a2NVUjlXNE1N?=
 =?utf-8?B?N1BPbGpISGdONTNtaG41NzhRMUYyODVERlZmbVc1R1NZaXBNZktOQ3FjSkJp?=
 =?utf-8?B?YXJ4K05tcGJyMXV2d1B2ZlVqSTRlU3g2VUF2bGM1SjRZMXU4TDVJVDlESkk4?=
 =?utf-8?B?ajVQM2tHY1B3eGpsbjY4Q2c3VkM1bTFEZm9SNCtVcVFkeW43VnlMTEJNTGVD?=
 =?utf-8?B?ZUpGS0c2SkE2ZnIzQ1JDbVNlK0hBdVNOUnJGaUlzK3hkK0h0QTJPT0wwQUJR?=
 =?utf-8?B?WEo2K1NTcExBaGREWk1GNXc5SDlEU0lCMUNrMWtIdHRiNEcvNkdNVXZLQXZh?=
 =?utf-8?B?UnkvcndoMXNJSW9NMmYwckpveDJPNDJNSG5jcnR6R0NpbzZDY25NWUlGUGU5?=
 =?utf-8?B?TjRXSjdYVFFBSnI5RlNZR2xUaHE4cmFYdmk2eGx1S3ROQU5hc1dTV2Q1MFpS?=
 =?utf-8?B?TUpKTTNZWnBUVTJZenZnamVYcVlWWEhrVEoyRGswWjYyRWNoM05Yc2F3dDFq?=
 =?utf-8?B?V1RQOElGcytNQkwzQUJLQW1hcUlveEZjeTdaMml1NktFdk1yUWI2aHB0MWc3?=
 =?utf-8?B?SEFMMGFNVUtrNWRPUG00WWlpUWNySHNtUDVGcDdUYVJpTUFhS0V6TGZnaDlR?=
 =?utf-8?B?NjlMKzBJZWJGc2dXeThNTmpyckYxYkxicVo2SVVQRGdlRW9UVFdKbjMxdmJD?=
 =?utf-8?B?b1dkRStCL29mNkZwa0lhbXVrdWRscHJ0M09obUJucmNkM2h6S2NjOURxVFBp?=
 =?utf-8?B?YkxzTDk2WE94SkJGN2JYRjA2dkd2OC9DZWl6S1M5a2g1NWJ4VDMrQ1h1Mmlv?=
 =?utf-8?B?WlNJZXM2UVArZ0QvQlIzamJkUXk2d1Q4SnlLc05pTnRWTTNXQnhGYUlMMGJj?=
 =?utf-8?B?d2lEVVVobk13NG9yV01IWlVPa1A2VEpoOC9ORFFJbWxHQXdpaWQ1MjIvM2x6?=
 =?utf-8?B?TXRWbkNkMHVuMUZLTWxzeXVWWkhsaHl2eENnRzJSVGFYR2xoTUpmVXZGWmpH?=
 =?utf-8?Q?PXIwCgExY/S9a4fXdub9Jw+9f?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 207bde03-c073-4967-f51d-08dbda50d660
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2023 20:34:53.3758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ghw3u/YDIzBBXRi5G+El4Y6hnfX+thsnSCSb/ciSonaEq1KV6CLWOWyqW5zq1zPajJIvuaunb53F9F+slzDPdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4905
X-OriginatorOrg: intel.com



On 10/31/23 13:33, Dave Jiang wrote:
> If a cxl operation is executed resulting in no-op, the tool will still
> emit the number of targets the operation has succeeded on. For example, if
> disable-region is issued and the region is already disabled, the tool will
> still report 1 region disabled. Add verbiage to man pages to document the
> behavior.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Cc Quanquan

> ---
>  Documentation/cxl/cxl-disable-bus.txt    |    2 ++
>  Documentation/cxl/cxl-disable-memdev.txt |    1 +
>  Documentation/cxl/cxl-disable-port.txt   |    2 ++
>  Documentation/cxl/cxl-disable-region.txt |    2 ++
>  Documentation/cxl/cxl-enable-memdev.txt  |    2 ++
>  Documentation/cxl/cxl-enable-port.txt    |    2 ++
>  Documentation/cxl/cxl-enable-region.txt  |    2 ++
>  Documentation/cxl/meson.build            |    1 +
>  Documentation/cxl/operations.txt         |   17 +++++++++++++++++
>  9 files changed, 31 insertions(+)
>  create mode 100644 Documentation/cxl/operations.txt
> 
> diff --git a/Documentation/cxl/cxl-disable-bus.txt b/Documentation/cxl/cxl-disable-bus.txt
> index 65f695cd06c8..992a25ec8506 100644
> --- a/Documentation/cxl/cxl-disable-bus.txt
> +++ b/Documentation/cxl/cxl-disable-bus.txt
> @@ -15,6 +15,8 @@ SYNOPSIS
>  For test and debug scenarios, disable a CXL bus and any associated
>  memory devices from CXL.mem operations.
>  
> +include::operations.txt[]
> +
>  OPTIONS
>  -------
>  -f::
> diff --git a/Documentation/cxl/cxl-disable-memdev.txt b/Documentation/cxl/cxl-disable-memdev.txt
> index d39780250939..fc7eeee61c3e 100644
> --- a/Documentation/cxl/cxl-disable-memdev.txt
> +++ b/Documentation/cxl/cxl-disable-memdev.txt
> @@ -12,6 +12,7 @@ SYNOPSIS
>  [verse]
>  'cxl disable-memdev' <mem0> [<mem1>..<memN>] [<options>]
>  
> +include::operations.txt[]
>  
>  OPTIONS
>  -------
> diff --git a/Documentation/cxl/cxl-disable-port.txt b/Documentation/cxl/cxl-disable-port.txt
> index 7a22efc3b821..451aa01fefdd 100644
> --- a/Documentation/cxl/cxl-disable-port.txt
> +++ b/Documentation/cxl/cxl-disable-port.txt
> @@ -15,6 +15,8 @@ SYNOPSIS
>  For test and debug scenarios, disable a CXL port and any memory devices
>  dependent on this port being active for CXL.mem operation.
>  
> +include::operations.txt[]
> +
>  OPTIONS
>  -------
>  -e::
> diff --git a/Documentation/cxl/cxl-disable-region.txt b/Documentation/cxl/cxl-disable-region.txt
> index 6a39aee6ea69..4b0625e40bf6 100644
> --- a/Documentation/cxl/cxl-disable-region.txt
> +++ b/Documentation/cxl/cxl-disable-region.txt
> @@ -21,6 +21,8 @@ EXAMPLE
>  disabled 2 regions
>  ----
>  
> +include::operations.txt[]
> +
>  OPTIONS
>  -------
>  include::bus-option.txt[]
> diff --git a/Documentation/cxl/cxl-enable-memdev.txt b/Documentation/cxl/cxl-enable-memdev.txt
> index 5b5ed66eadc5..436f063e5517 100644
> --- a/Documentation/cxl/cxl-enable-memdev.txt
> +++ b/Documentation/cxl/cxl-enable-memdev.txt
> @@ -18,6 +18,8 @@ it again. This involves detecting the state of the HDM (Host Managed
>  Device Memory) Decoders and validating that CXL.mem is enabled for each
>  port in the device's hierarchy.
>  
> +include::operations.txt[]
> +
>  OPTIONS
>  -------
>  <memory device(s)>::
> diff --git a/Documentation/cxl/cxl-enable-port.txt b/Documentation/cxl/cxl-enable-port.txt
> index 50b53d1f48d1..8b51023d2e16 100644
> --- a/Documentation/cxl/cxl-enable-port.txt
> +++ b/Documentation/cxl/cxl-enable-port.txt
> @@ -18,6 +18,8 @@ again. This involves detecting the state of the HDM (Host Managed Device
>  Memory) Decoders and validating that CXL.mem is enabled for each port in
>  the device's hierarchy.
>  
> +include::operations.txt[]
> +
>  OPTIONS
>  -------
>  -e::
> diff --git a/Documentation/cxl/cxl-enable-region.txt b/Documentation/cxl/cxl-enable-region.txt
> index f6ef00fb945d..f3d3d9db1674 100644
> --- a/Documentation/cxl/cxl-enable-region.txt
> +++ b/Documentation/cxl/cxl-enable-region.txt
> @@ -21,6 +21,8 @@ EXAMPLE
>  enabled 2 regions
>  ----
>  
> +include::operations.txt[]
> +
>  OPTIONS
>  -------
>  include::bus-option.txt[]
> diff --git a/Documentation/cxl/meson.build b/Documentation/cxl/meson.build
> index c5533572ef75..7c70956c3b53 100644
> --- a/Documentation/cxl/meson.build
> +++ b/Documentation/cxl/meson.build
> @@ -25,6 +25,7 @@ filedeps = [
>    'debug-option.txt',
>    'region-description.txt',
>    'decoder-option.txt',
> +  'operations.txt',
>  ]
>  
>  cxl_manpages = [
> diff --git a/Documentation/cxl/operations.txt b/Documentation/cxl/operations.txt
> new file mode 100644
> index 000000000000..046e2bc19532
> --- /dev/null
> +++ b/Documentation/cxl/operations.txt
> @@ -0,0 +1,17 @@
> +// SPDX-License-Identifier: gpl-2.0
> +
> +Given any en/disabling operation, if the operation is a no-op due to the
> +current state of a target, it is still considered successful when executed
> +even if no actual operation is performed. The target applies to a bus,
> +decoder, memdev, or region.
> +
> +For example:
> +If a CXL region is already disabled and the cxl disable-region is called:
> +
> +----
> +# cxl disable-region region0
> +disabled 1 regions
> +----
> +
> +The operation will still succeed with the number of regions operated on
> +reported, even if the operation is a non-action.
> 
> 
