Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB8E28694
	for <nvdimm@lists.linux.dev>; Mon,  4 Dec 2023 18:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YI4zqG9R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701713142; x=1733249142;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=sUZaJo+7GgT+XyZLoV4/V5CXD7skGuBHVVwS9oY9JQ4=;
  b=YI4zqG9Ri4iIk/ayXrFALtIQlyjRIbEttru2egC8kE147fn7tEjPhAbQ
   WRys1xVkPpbmf8qIjermf/WJhcJ2ggvWXTkbAThYcH4T+W7NLpEpAW2pM
   6gtGPeXLvKGbnR8SUfd70cJ/DDfvbrmUvLFJf92G2zoSsnJykx292SPWu
   7XEnfwY3A49lAC/xP05APw08MS2QzVMTVlvW3mg7YOkIU0dnwKx8+Yeia
   R6kPQaG4uAc+6/4SWznotW+A4ppPGNufI0vKQ66Eus+6dLGy6xgsR5hvD
   hF3EZxvJCBRfczmaHKMHFpjgR1WRjAHUNal7svDGXUdYnmEjESWr2NeBW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="460263961"
X-IronPort-AV: E=Sophos;i="6.04,250,1695711600"; 
   d="scan'208";a="460263961"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 10:05:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="861463963"
X-IronPort-AV: E=Sophos;i="6.04,250,1695711600"; 
   d="scan'208";a="861463963"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 10:05:17 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 10:05:17 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 4 Dec 2023 10:05:17 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 10:05:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obM2rFdKWxCeU45pEVOudN6c8XQERFmZUgjGuLz/rL/H0VkwfCj/7gS55PGyrdOdlG55oeqjglTOpMXHR3ErKZsHwfPZdt/0nfJC5BsuMnIYWO3Unh6UjgvfleKFfCpxKTHtpTrUsNaPeNX6qitxxTCqt9yHE7H7pzs4O4gU177F8+wYXwnSepBX/94F3GwbGQ3LxLiXgI3RyRyBWd+9wnejW9LYsGmeaq58vaK25R69AksfFVLXJXXeIsvL4wEdULI1slRAbhEHkj3+wq5nKQvQSIQX2n03gPl9S3y7jm2f6MxyMYfqnB1tLHBDMfY12MtuB/PNDvz5DzxmDUrKlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Itb5WBoyWnGcquWJxElD4GjpQxgVrUaAkKY5Hchc7ic=;
 b=dYIp73YUtTysB7iFZ4kK5De2jXad7HB7R5o85sxe6vT2omnUKDsts2dQbCVCaBMJQgXWPKft5DzRkA9TemekNTGF7/t6LmZfuJywx8PVIxFxpQQU3iRrSccDkFr0Y9V5nkXSfbr+KIq3bYuTuY5FwBH1WY3DGKXhEadQrgQJ3gk1rLb0FICUKotH5Eem1j4kypT5Mp3qfdKI/4+9NNvRS0BjzFTnErdmpoSIt0dWWnR0rUE374WUGbBR55JRVOlaVg0F/EptontN9dGPZHgKEGNCtRkKUU1quwANOGfsgW03/jfWkCgy65Z7TjnidA7Akh1PgVAI/G+ENzeuXKC6Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by DM4PR11MB7278.namprd11.prod.outlook.com (2603:10b6:8:10a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Mon, 4 Dec
 2023 18:05:15 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::da91:dbe5:857c:fa9c]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::da91:dbe5:857c:fa9c%4]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 18:05:15 +0000
Date: Mon, 4 Dec 2023 10:05:12 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, Ira Weiny
	<ira.weiny@intel.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH ndctl RESEND 1/2] ndctl/test: Add destroy region test
Message-ID: <656e14d8285f7_16287c29422@iweiny-mobl.notmuch>
References: <20231130-fix-region-destroy-v1-0-7f916d2bd379@intel.com>
 <20231130-fix-region-destroy-v1-1-7f916d2bd379@intel.com>
 <ZWo2f2eWVtsJrYD9@aschofie-mobl2>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZWo2f2eWVtsJrYD9@aschofie-mobl2>
X-ClientProxiedBy: BY3PR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:a03:217::34) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|DM4PR11MB7278:EE_
X-MS-Office365-Filtering-Correlation-Id: 92d124d6-9920-47fb-0b6d-08dbf4f390d4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FOp+Vqt6VX50sRinUS+MXKUm51TuniYeVRGzBDF+6mmSQE56vRbg8Fxxc9Mp7wkkG7sPxDxPpb3ispFoBRiyyYvuR0d+Lggijf9SDXa72aj56BXnigtZ63XQ4JVGpfEZaPU0M+PQNV6zou08J+XCc6OzdgfXGa4BViSKjVuk0WzV/k3+Ao4lRqpBgInTjLPGVoff0rlFNmB1ysHyWBt4qfM0GQmjcthroSXizf/Yfnm2MxCV4Ga01yzi8Hq/xjwUW1HRfMFaltROzA3i7nvt+c9uGVVa0whCpEEO30EmhIak11xPoLSv6CC/CamBSVaomWSRGn+o+/aLL2mdYbruh/8DM/ZXqPVUiBwTqxCXpfWEyIlsrh1X2OBKH6qZSCk0AUfe1NcPZ8OvxX7mfuA+ABUKRvEOzxF/TsQYhDTMGbiz4f5CwV7FkAMY5+HjquGpLd9MizPwpAEGSN/pPBPVDAHWXIE68Nup1fqg7fjd8Gj7SYvaQyN92wO+vvQgJlMVE/dpeKNVjJkH2wHzNNbuRmhSDgniFFaIJDStb/UdSGbJVB1znHJgojaAQ0B3xHrK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(136003)(366004)(346002)(376002)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(5660300002)(44832011)(86362001)(4326008)(8676002)(8936002)(2906002)(41300700001)(9686003)(6512007)(6506007)(82960400001)(83380400001)(6486002)(478600001)(26005)(6666004)(38100700002)(110136005)(316002)(54906003)(66476007)(66556008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xm1cesEo5stWoJYkMgLCt8hcTyQHSAJQvMuSXNi6M9jwZC5G2VeCINxLHxzP?=
 =?us-ascii?Q?1JX2lJnuSQuj8fanDnqGUAEupjfhwjXHC2j+c3ZAkYz44OO6rKRMexQ9AOEL?=
 =?us-ascii?Q?7XX+6Hh51PeaJv3PQnlEDNmqP2K37mXOiGp34PpFPbQUAiWK9l21gkgLVFL2?=
 =?us-ascii?Q?GBsBMo2mb7S2EcW02QGr5q9v71+A05drY8kTjyNgjqbfIgcpxltRtD21+E2o?=
 =?us-ascii?Q?j/pIDRwzUlmeRSU56sw1DEgKeS2+gc+j0TH2oROAgf0XSZvMY7iaodYXc079?=
 =?us-ascii?Q?PO/pr6PlmLygNNpNqKAyMIFJbj2Qw0QvG7wvx2KK+peZBuNHELh17dy619gh?=
 =?us-ascii?Q?lMEXZTUfzP9KafmihKVEtaNTI/FRawRX7ztR4M4zrr40b3J+oQR228gCq5Pj?=
 =?us-ascii?Q?XLn7b95E//G/koAZj3tNiDvTTkpuXXABFTjaPF03Ci25N8uWYjxEIxNb7Zda?=
 =?us-ascii?Q?QqaV0jNa8IG8GAh7yZhhUmEC+GFETUdmafVaqhAwkTWamRR+q5ur81AQNXHV?=
 =?us-ascii?Q?Ho5uRr8if0nv4RQb63q7fSmvSb8M2zhH3214vNyGIWtdkhCnGeJ2E1HI/dsb?=
 =?us-ascii?Q?4MaUZx+BjTVYgdFVegrlU+wnxJNJ8oFG4rT678NS0xU+/cy+iUABG7YTyPi0?=
 =?us-ascii?Q?zUAVG5J600vaDkI9qlVrc95VA5lcEdDlP8TD7luBR8jzQeM0ZuBrKt+obZKi?=
 =?us-ascii?Q?zKRpjCLVaSpHnovT5JiUtvkmT88Ln1JqhKLSxv1/ePa1wg+X5+l97eCxCOSU?=
 =?us-ascii?Q?nZwOW5ROARFhb0z+l564q8QS7MNFiDDDHcEtGFMWRLDaIVegEixnwPoZDHeN?=
 =?us-ascii?Q?+Ljzgw4+DLmhhRoDwPe9iOXeVkNzUXp+zvvyYjGWxJOShH3fF1dRn5bvGQfM?=
 =?us-ascii?Q?hE0OgUZj+QUDYaa38vmKoMtD3Iv+Nq9HVAwJvjriGQYV/kfImdSCACISpEU4?=
 =?us-ascii?Q?CqyoyqFG5o7XTyabchc+3bKyrGfLSJDfnk68eMv8oGrx/5cuttL1nUVoLqbl?=
 =?us-ascii?Q?gX1W2T82KSVHE0BkTXDBYbFlfGPG4ImX/vZNhi6lRm6WG0c/L+6VZANOlYvP?=
 =?us-ascii?Q?SD3GjR2Pv1JKBhNxNkLXdv9IsjU+qQQC6KS7e72tDVwn6KfQHryq0tc7fI+T?=
 =?us-ascii?Q?n3t7KbRSedZk/BNWN0lMAdMTTNPvJTcBZrcpE4Op3Jee3j/f9nkNXW8Je+P1?=
 =?us-ascii?Q?lNhJDXFbqXPfW4KIWFDc0/UB8GR6T+tt3SowwwfUsWsuqoVZJmVPeoU40sG7?=
 =?us-ascii?Q?t7CJdK0pXQcN4Aas6g7Vw4lxJRPU+hRzTWuOKNiBOAlBj5DPkXzp8q7A/ADw?=
 =?us-ascii?Q?ZHKF7BjVQAyYEVBd4J/RXMg/JZ5Pzc2GZv0wIODetG4PdW/BIHWDJxr57ZDc?=
 =?us-ascii?Q?LVhkbCgjnBG85MHHFQY4JZkYbej20Y8zQOKQgPZpw9IS7byVJkokzJlIlKiN?=
 =?us-ascii?Q?X3wfLsQQAPYVPhhpH0NB1pAktZRNMQrsuamWXDfhwHKCr9/fhdZLuEMhzaer?=
 =?us-ascii?Q?4SOKz1DsjvUl4vfW1V8VRFgdQoMoBWl3syJVGEKxDnI4PiYoDohsmKn7CkY0?=
 =?us-ascii?Q?aaaatpb6w47ihzj4sP6RdxG+LwiWQUvje9WCKXUc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 92d124d6-9920-47fb-0b6d-08dbf4f390d4
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2023 18:05:14.9651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SfHhXuL9QjJZEk6e9SGyP/S+M9QlWCytRvZyfbSlmgzYezztJ2sgs5D4bmF67e3cncJTnT9ucNpbakU3cMW+Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7278
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Thu, Nov 30, 2023 at 08:06:13PM -0800, Ira Weiny wrote:

[snip]

> > +
> > +check_destroy_devdax()
> > +{
> > +	mem=$1
> > +	decoder=$2
> > +
> > +	region=$($CXL create-region -d "$decoder" -m "$mem" | jq -r ".region")
> > +	if [ "$region" == "null" ]; then
> > +		err "$LINENO"
> > +	fi
> > +	$CXL enable-region "$region"
> > +
> > +	dax=$($CXL list -X -r "$region" | jq -r ".[].daxregion.devices" | jq -r '.[].chardev')
> > +
> > +	$DAXCTL reconfigure-device -m devdax "$dax"
> > +
> > +	$CXL disable-region $region
> > +	$CXL destroy-region $region
> > +}
> > +
> > +# Find a memory device to create regions on to test the destroy
> > +readarray -t mems < <("$CXL" list -b cxl_test -M | jq -r '.[].memdev')
> > +for mem in ${mems[@]}; do
> > +        ramsize=$($CXL list -m $mem | jq -r '.[].ram_size')
> > +        if [ "$ramsize" == "null" ]; then
> > +                continue
> > +        fi
> > +        decoder=$($CXL list -b cxl_test -D -d root -m "$mem" |
> > +                  jq -r ".[] |
> > +                  select(.volatile_capable == true) |
> > +                  select(.nr_targets == 1) |
> > +                  select(.size >= ${ramsize}) |
> > +                  .decoder")
> > +        if [[ $decoder ]]; then
> > +		check_destroy_ram $mem $decoder
> > +		check_destroy_devdax $mem $decoder
> > +                break
> > +        fi
> > +done
> 
> Does this need to check results of the region disable & destroy?
> 
> Did the regression this is after leave a trace in the dmesg log,
> so checking that is all that's needed?
> 

The regression causes

	check_destroy_devdax()
		$CXL disable-region $region

to fail.  That command failure will exit with an error which causes the
test script to exit with that error as well.

At least that is what happened when I used this to test the fix.  I'll
defer to Vishal if there is a more explicit or better way to check for
that cxl-cli command to fail.

Ira
