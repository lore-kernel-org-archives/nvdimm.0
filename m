Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F40639
	for <nvdimm@lists.linux.dev>; Tue,  8 Aug 2023 05:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691473547; x=1723009547;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rss/Y5zAosHaov/n/J05WzcGSH4tYJvFHlYgT7pvt2U=;
  b=jq7pyfnNd73IfzcSKYSw0rTxhAYE1M5EUYBpgJ9Ab55ZjQEuyji2KKgv
   /Uos+hiy4rft9gqA+f6WyBiFBQ/ndMcN7U2FsxaqzbPGHS/5sY/+DHFJv
   5JsaNKBAaudt8swGI6aoi8CDKEitKPvNpkLDNIPVKDxFpvDqdgQm+V6ly
   FvOO99kGoewYfb36upM4/Masf4S0z6URLZzXy/Qx/iyqncqpr/JpML1Q1
   QmE/rbtd5SYPK4WyfAzs6OrrLP5EBRnfPrAPg0bchdp1/Ea9pgxyp+WXy
   CDCkeqabac1zfGFa6Dii4iXPMp507PXd1byNtoEVr5Hr9E10OFRd9uNT4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="369623935"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="369623935"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2023 22:45:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="905090430"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="905090430"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 07 Aug 2023 22:45:40 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 7 Aug 2023 22:45:40 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 7 Aug 2023 22:45:40 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 7 Aug 2023 22:45:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hCGKs54I8I76JtaprARFK/G6I/8czNuJeMfoyMlb63w3Vv8ptGfmmtbenWLOouGPjw3c4hiVqsbgeh3cr7gRlkU+e3iICSmGGpxXItrwQtbmzZU6empOS6HoVymYh4R4whMZlC3A9MCgwMKT3F++CWG01t4gC2v/JnWKMKBaZiuPXjeQC6iKKT0LWYo//tOH7yDWgo577WqpchBcr1kSzEV6IHjOzxF/JVceP9C3l1whtVT7iUWLn/z16UTEPCGXANY9xhJzjAGjhQS8edS2fjHiI1p6PTqIdUcqeOUc0vZ+o7ycFtJZsNFgAPcpxk0k6Yyg9qnPWNM0zKZVwv5UVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rss/Y5zAosHaov/n/J05WzcGSH4tYJvFHlYgT7pvt2U=;
 b=c0pWdtrZD2wpUBIkLA5z/XPMsLUYMlWsFdf8knBRgK78g5HzwwH/7SBQivNzJ2HTxB2sklFeUs+fCmnggDolDyJNkSKSScEVeE2SikjgZ/svUO8eL+E1aN9CIvjqsEg06wRrsb/kANNW/RDrfOaAwUVcv5U/1bRgDYu8YUgD7d0RpsIFWIjgmj+nRbdwVT0Fp6WmWV53w+SwdfebQMyiGSgCd311ZHgEQ6kqBfiHkmH0beMJGEARz5NRZOAnw5qk/R8xcwVnkBo9jKrfeKDTHF6H686NtnuC5cL7EGI+H7LI6xtuZ8m77zpqZErGP8ouPgVtzKqTh4FlSxZjg7bjHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA1PR11MB6661.namprd11.prod.outlook.com (2603:10b6:806:255::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.26; Tue, 8 Aug
 2023 05:45:34 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::4556:2d4e:a29c:3712]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::4556:2d4e:a29c:3712%4]) with mapi id 15.20.6652.026; Tue, 8 Aug 2023
 05:45:33 +0000
Date: Mon, 7 Aug 2023 22:45:31 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Terry Bowman <terry.bowman@amd.com>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <dave.jiang@intel.com>,
	<vishal.l.verma@intel.com>, <mav@ixsystems.com>
CC: <terry.bowman@amd.com>, <linux-cxl@vger.kernel.org>
Subject: RE: [ndctl RFC 0/1] cxl: Script to manage regions during CXL device
 hotplug remove-reinsert
Message-ID: <64d1d67b33c14_5ea6e2941c@dwillia2-xfh.jf.intel.com.notmuch>
References: <20230807213635.3633907-1-terry.bowman@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230807213635.3633907-1-terry.bowman@amd.com>
X-ClientProxiedBy: MW4PR04CA0382.namprd04.prod.outlook.com
 (2603:10b6:303:81::27) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA1PR11MB6661:EE_
X-MS-Office365-Filtering-Correlation-Id: 287678b7-13eb-4d75-910e-08db97d2aed7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VSwjUrQ7JdcKawt3bSc/L5EA5niDWBKjsIX8Ouw1bnCDgcMBPF7IeLyjOmrIB7on8U6RbRHUdt/ogwhaDtymfTlGdjCkEjyA5G34UaWcD5ymJBheFf1BcvgHtlIRT43DSUKyguxOPb8Y/K/FzXEKzxB0/3RPkdSEDj+GhltKNMloQxArXYTuhRYmNfQrm/Prd5hXCGR2d6LS9FcgsccJt5wg8aPZErOg4sbmxPPvVD18CFIULT1mTTZ5xeeoxZSqh2cAoXmGHjYVUyahFdlLbPbvh0K6trJ2Z3bcPALJ2lmXurEKz4bN0SefeXCIKOpSIlz2CpPvqITfdHuLcr7g5GtoHIZSvU4yZSPBW62orwQ7ZAwkwjdmefIkAjuPIRDOLT27ML8D3YnG3Zq6llSaqJmFZlJtIS/ISoXNau40ncsFOTvR/TnxJgNv4x3VIO3X3MrLvUpknemkQ5JmxeOBHLva88AQgFSgJPXw0x1LMpznraKME/faRHM5u7iLqwuaaJfs+Y4+b3V50sDkD7SBpqjKvPQWabGq7XFpPV2sMeG/iu/Lb8nJwZP6xFcw1H7JGkPXbopwejyX7X//lNAopuCkfpZ0iL8LaOqfifonZChB8jfYCH/5gtO9ald0AAeZZwRbyk0fpqF428Luq4JfFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(396003)(39860400002)(366004)(90011799007)(451199021)(90021799007)(1800799003)(186006)(9686003)(6486002)(478600001)(86362001)(6512007)(82960400001)(26005)(6506007)(41300700001)(8936002)(5660300002)(316002)(8676002)(2906002)(4326008)(4744005)(66476007)(66556008)(66946007)(38100700002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HW3u9Wkc/tRYo6A9iBJhn1g/XBAwr3BlOenMKQJ/WUKMwJKpE+IpI1O7bz3a?=
 =?us-ascii?Q?mIRBZlxPPecZ6sjXeAzeHQSmTDnaCHsUeaB9lTXPBrt2vizC5Fc7hqHRKVJ0?=
 =?us-ascii?Q?8Rq58dHrg8+prRG/QRw/kkJh9UsnFNEskvOsVUBs9Fx1LAVWEsC5o79s06no?=
 =?us-ascii?Q?94lxXSB8g1d34cHI+sqZNtrRbHV6v4UNHRYiKXtS37Wr/B8pyLZ/WHunrat0?=
 =?us-ascii?Q?tfDDAXFX1zulNfEr0a0FTXW9zEQBvTQAq+d+NjrvxAbJOBXxeHnnrp8M3nHB?=
 =?us-ascii?Q?J7r78nSQTzWbQ/ty+jiCbzUQDKXPsOpudMC6kSjSWM4miBZnJ6CLyslQMIlT?=
 =?us-ascii?Q?YMGA6CKYtNADYXP7V28o879qlGQCs9mu+VnfWZC+A+VHUm64020EEiZgopFc?=
 =?us-ascii?Q?XxoKkZko5wIyZzzW/mTq/PZkSpdlEjvSdTZloF/DGMKDVgN2qEUfCCReMCzL?=
 =?us-ascii?Q?MhIRex0g/o5Lo1r0/CJ4MeNMnEokbK2FC0bV9m/JKKcglJ/j5LqjmbOviw1X?=
 =?us-ascii?Q?Toi2enqCuJOh2JtSvwlE4I9q7032Q0mQaBv+QnUzUZP98brNWctz3HyWCrcu?=
 =?us-ascii?Q?NZzKGTnBhkUolhY5JAAthhMbfi2SE59Lbwx385mNbbShrxCvrelXEnD1xmtG?=
 =?us-ascii?Q?YeXZcaw0M9ZZa6tbrcHeMTDTen4wYM+XCho3QXts0cnaL2vvyt7ghZab+9Pi?=
 =?us-ascii?Q?nkFoKxPJ5fUY8jYgss6VyemV+rbAso4sG4MO07QFWBXptBs0bBLWMYWLT2ci?=
 =?us-ascii?Q?QjW+/1yCXwDt3Kw/CnVbWxSxWnJZaoSFJxORbjhLD/ABeH/yq3tHgYMIe6NE?=
 =?us-ascii?Q?YXlxpwdEH5fdYedPjSrg9xxC8jEsbeyc9jyLpm4N7lt/5c5ttlh01l+Aj6Ua?=
 =?us-ascii?Q?WECJjawj8hIdjIGLTsgO1qi/D5xtGm5pWTuNJM1gjE/G6TH7YcouPbd1F7vg?=
 =?us-ascii?Q?a7ljneUniNJG0VrX5OSgDrK1nk/Q/19KQEHhYmKEkq5VCXKgfELWXQlsNKWy?=
 =?us-ascii?Q?G4Du/QENZJVZ1KXol0Xq5jazTNi8dFZQvcGhFA6Ec18v+59ofA07Z/qreSBt?=
 =?us-ascii?Q?eLPo6Ldz8UgwNX4fPx54GsMfMzCpivSltHOVC7CzUDNKe364AC4iXUmlnoZO?=
 =?us-ascii?Q?TZ3tuDZlMUic2833qqSbOfECA0F18q8fBMrN2Cm7gQAEm2UEDiL/b+cc1ha7?=
 =?us-ascii?Q?kKM+qJZrJ83DsCl2dvUYZwaq4N1Nb6PCl/Eww0Q8CVHjGMBzu0huG2PrCkuM?=
 =?us-ascii?Q?F8JujecvycXRNtt9mbLJpR9keYgP/g/NYRbKI9+fNAkhjgXlbMgnuFWY2y1W?=
 =?us-ascii?Q?tQjix6rE71RdxUshrgA2ijuQdodr1bKrfeVqA7xQRDCHW2/z5ZVNn4VJDj2S?=
 =?us-ascii?Q?IErUQnCRvl8ntsdlhooE0rMVwygkWCgkv8uLv9EBztWPnAD9+0VW+1BbntuN?=
 =?us-ascii?Q?rlMLfgymeREVYjE+yGGjQs67kQSFhhdJ1eyXyy5L68khSlBm+6c76Td82Dro?=
 =?us-ascii?Q?r+ebV+qtpl9S/ObF4wd5uupFWj69GhQ61r1OSPm9fuEb8VF9iTSyjmkV/iEA?=
 =?us-ascii?Q?WP4FNbJQV//vIrs30QMDbSxhkNU3hFRZDOUyE45iCdb9CaLCvDKp67ZdJjWR?=
 =?us-ascii?Q?iw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 287678b7-13eb-4d75-910e-08db97d2aed7
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2023 05:45:33.6531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sb8QijjbTxvLP7Zi6oWshiLTTj2Xc5vCp2fPCPMEWM3lIRVdBYEST2NlAqgVTcR8LJbhGk+8NgMDSf89ENTzZ3BHjL5hmSYyOIWeK1mR5zg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6661
X-OriginatorOrg: intel.com

Terry Bowman wrote:
> This patch is a script providing region deletion-creation management
> required during hotplug remove-insert. It allows a user to hotplug
> remove and reinsert a CXL device without requiring the user to make
> additional tool calls to destroy-create the region. The tool will save
> the region configuration before removal and recreate the region later
> after hotplug reinsert. The script makes the necessary calls to the cxl
> cli and daxctl tools to manage the regions.

Nice!

> This may be useful to add to the ndctl tools as a standalone tool or
> incoprorate into the existing CXL cli or daxctl tools. I'm interested in
> feedback.

I think something like this could be carried in a new cxl/contrib/
directory.

I also note that the cxl-cli command harness is stolen from git which
has the ability to have sub-commands defined by scripts, like
'git-send-email', rather than C library calls.

So if there is a desire for scripting language support that could be an
option.
