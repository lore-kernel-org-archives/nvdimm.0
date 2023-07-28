Received: from mgamail.intel.com (unknown [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DCC15A7
	for <nvdimm@lists.linux.dev>; Fri, 28 Jul 2023 00:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690503362; x=1722039362;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=NtiSOCJsprDTLVkRLerK2Vym0SBODHnixqxdL45t2Bw=;
  b=XmKfCe8Q2lR+98HrkY2pnpMu9ZQ+w6Jyd7fSg6Q9Zi22lb1fu4trJYxj
   7+59HwY7J3sEiPrxq/4D/RjlqoW+yYG9bAG5+3qeml5ilphXwtNwAyTDb
   Z75pid+RpK5uuARpRodOucbNvmKldxBEospoQS4jlefjONzlZWffSA4VE
   OKnJnWqz72QAGaHbsEz7wgB/5aEiGRb5sAQxBXVkVE5FI0fSLXXD1Xhot
   zriCMPwisCEwttOTYDnL4qGns0HBThL+kyoP/nzlF98xHofl1eB+Li6Lh
   0ePORnAg5qvVHviHWtUyeTDfrJPZhYiCAx97lerp+cWoQn+ndQAT5F1yX
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10784"; a="432281250"
X-IronPort-AV: E=Sophos;i="6.01,236,1684825200"; 
   d="scan'208";a="432281250"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2023 17:16:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10784"; a="817276731"
X-IronPort-AV: E=Sophos;i="6.01,236,1684825200"; 
   d="scan'208";a="817276731"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Jul 2023 17:16:02 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 27 Jul 2023 17:16:01 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 27 Jul 2023 17:16:01 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 27 Jul 2023 17:16:01 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 27 Jul 2023 17:16:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GR9eqTo6SHeZI3kolhBfDBIMFWrLNfzMa+HLR8nLnkkHcfH8SjbaiBH1HBI7+rbvg3hZ354Q0QjkTxiy/mlmSGpd+UwKv4Cde/drHbSDkUjNhmr1eQMWUA+wqfvAHn//xDCacgkFj0a7fEb6dgCb9p9fIFZpE2/gRXWLu5Yn78aV6RCP6k6GpbJsfbTXCzDSV6dGKZzofDNy6fXK2s81pjTmIPX6sQhEq5OASrv4eZ+HfdGDyXInJWd9MU/vKFi6XzF5/S+vr9GXMtGUYn6iuEMoJ7gbQ7uuR+RznYLVceVGehrO285RJtI7Vj4hLzrz3fe9ud5CxH8+NFls7nnn6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WvZxh2n0+uLA16w/5NvkaVWzEDDJDkW5jlkOA+6sRgI=;
 b=elcp6A7JlOXZjFbT7GGOr9Kt77keZIAgWTUOPAfMUfvx3Ao16ZFp6c8vQg3+KghDW4OBB3iWhcSnfXib2ReLVqzUaEK1Bour1ag6resAy6Vbyv5dqBk2Khw/D9bUNM8fYYnhTc7GWfHntFcflgmuIYAID6GbPbbuwaVcdTgpOPwtVHH2NqwrKJO1umfUdw4SYTJ7Ti4gTpFY5ssEeBvNqgUSrcsNNj8qIj1K1h4S/eADuH/+WC860jBnMLQpscQCJ5lDhJ+gNFwLvYTviio1S9pF+FdwWGGuEB5lb/q1gqNkwFq5vsNzGd0gOMBV5Qyb2+9iREpt6JAWxCC0/ymSRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SA1PR11MB6808.namprd11.prod.outlook.com (2603:10b6:806:24f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Fri, 28 Jul
 2023 00:15:59 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6da5:f747:ba54:6938]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6da5:f747:ba54:6938%6]) with mapi id 15.20.6631.026; Fri, 28 Jul 2023
 00:15:59 +0000
Date: Thu, 27 Jul 2023 17:15:56 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Vishal
 Verma <vishal.l.verma@intel.com>
CC: "Schofield, Alison" <alison.schofield@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl] ndctl/cxl/test: Add CXL event test
Message-ID: <64c308bc9a6e9_368368294fb@iweiny-mobl.notmuch>
References: <20230726-cxl-event-v1-1-1cf8cb02b211@intel.com>
 <867b567f-45cc-d6f1-d5f4-cc68a80406b3@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <867b567f-45cc-d6f1-d5f4-cc68a80406b3@intel.com>
X-ClientProxiedBy: BY5PR17CA0050.namprd17.prod.outlook.com
 (2603:10b6:a03:167::27) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SA1PR11MB6808:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f6ddd39-ff52-4a68-28a7-08db8effd1c2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3a5qQ77rnajWDbDaQiiv/BygaMivu8kbFKpMgKs6bRFrlRopTPCWigpEmQsxLqZraX0bPYOAD18Vqik3il2++VUJKTxFf/xzawIcNYsdIALbebygretDO4yGhfxGtsnqk8xj0ZpcEpKl9ApgKnSoKO44dvRnyLW8TTdgyMwcrcybbtMHmTO6sdFmrYuEjoyGXStd8Ks4lg5iG+O0ZZCqu8KRNa6nbasbReMsWbPwT9MGD4LeAQeJDO60gIVyChrrp7cZLEAIWgz9z8UOV9Ov7jGPjjIgPoSNw76BW2DCb8vTwPxf8cXr0xxlkXHZQQ8wMV6A3hdPvY7Dw/glQvJbKuht30ux+T9u3XOxqIzrqst6Y6K7/fLaNXbXHEPb9Dm8f2sGpMMx9ssHTZr9xn59mz1jk3s9lnKmcW636ZUH0Qaq7bI25T2NtPkuU/A3bjG/e+I4cWBp8UulEmj5WMI+6+Q/c1TNS7vW4Kqq7VTeLgsrTKcS/yoLhQohiO2UE7WTAGbk2XRbzZrUyQz2hdIJ5aIXlJ1R7568B50IeClsM7yIHCr36HgR7yEUVgq5xC+f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199021)(44832011)(54906003)(82960400001)(2906002)(110136005)(6666004)(4744005)(6486002)(53546011)(26005)(9686003)(86362001)(478600001)(6512007)(38100700002)(5660300002)(41300700001)(316002)(186003)(66946007)(66556008)(66476007)(6506007)(8676002)(8936002)(4326008)(6636002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WR/FT7YjuImPHaJdpp0Vcnvkx9TzJl5c1XWSNMpo3Cm2HPtsJsOBkCOkex9W?=
 =?us-ascii?Q?eC2EqK7RPJ9nYMJtoUmDdEWfzLd0otUs7xh1yCJSTejUNeMETXhPjHEAL4hW?=
 =?us-ascii?Q?Ftmn3qAYx03xp84deebv8kdRlTF280WjamkCl/rS6EWHPfxZo2LqWr3K1vWt?=
 =?us-ascii?Q?nr51YCXqfgc7pqCZBCKdpUd2EGPiYgFcOuGgny38oeHAIIrfK+DVb4C1P6HD?=
 =?us-ascii?Q?4gUStdUWIDXS7Iu/4u5E+IorB/NxL+TJMizLTJEV4GjLWkhKbYbUAvjq1zWZ?=
 =?us-ascii?Q?wW1IeFzMoT58Q3e0qxKniuSySyNFwYbb7zWnc+eoaHE/xb+3CDUgD3Ds18J5?=
 =?us-ascii?Q?RCghwqALkldHhi1B0xd6DT88lxByt3AsYNWKnymlhYIPB/BQUsCd3a7jrgCm?=
 =?us-ascii?Q?vFzF83/sDeIIMA59mQx/7iMQy7GKS4eY3MeKn5fN9FpbblryGnCf96X6XSiC?=
 =?us-ascii?Q?3kcPnotj769eqblNLjyGXsrtbsJEXA42ZELbZUa2/Iynm7udVUbj9eM0YeL0?=
 =?us-ascii?Q?A2UjfkhBZBDqg/fesG2mlvTG62tybL3sUqq5MC236oZ9CDGLZnIubwloKZH3?=
 =?us-ascii?Q?SH1Liosg2QRyubrMytyjINbiq37XEEz4KQKnr8UU//Cvl0svujVnOKx7fbPZ?=
 =?us-ascii?Q?tB+IenrsfOC/vE/aOVrhwLfwhBM3EZoJde5cfAS8SysnIJzQ28U2Eut6M70D?=
 =?us-ascii?Q?4xjhM6OMJ8whZyfFRE3tWAtRaByOJu04RQ0uQWLiu2zVuP5pEuANS3mHB8FX?=
 =?us-ascii?Q?Hj1JqxZoKrhbleyNrT8DJ+O3jnrcl4x6UydFxzlq5d4keNvbaqjx3DfxTgOm?=
 =?us-ascii?Q?mrprXSjXnDLSOAWBHBhdllKuDQq4AdlS62hCC+T7fzF5FJXqk7g4Xe3NdOe4?=
 =?us-ascii?Q?70uAu6UYENkYlnatyDdUP3pfXaOO8138ViLyHvj/KpTTOHQcUi2I2wW8xN4T?=
 =?us-ascii?Q?ABDhu2iJUSkqnV5qKNx44Ec0Lvb/VLPfssty19zcZ5mUM1V32nQHsnIrcaJJ?=
 =?us-ascii?Q?HmmW1OAAtaRk78CB45/0ywdI7l5oM337hcKhwKjACCvuzkmqTozqyddcyosj?=
 =?us-ascii?Q?KvHxGL2qVe7l4KrjbsomKPq/i5TiGg6vBMOoI8RpyNXVFZAb7SyW0JM3kRXo?=
 =?us-ascii?Q?sfVLFBBF9oVMclQLnIhVxZ7sfIE1JQMzgTTl2Ijob+g1CgRDkYm1VSQUtkPC?=
 =?us-ascii?Q?dVJ3Mob5/mEqHDNfJ/eHD+fCV8gfGmPhmSllTqe4vB8zy8BZjQb38vMOfKcr?=
 =?us-ascii?Q?EiUzikATGoWBw0ZQvK1T+2V9l29hppartwA+CynO/SGggTpGDZ8VXBE1SI1U?=
 =?us-ascii?Q?KyrD7TOQBShB8qMYfQUettgzsSKbpfYxNtI44WFlKLZ+MhOsNkAtzRRGZ25G?=
 =?us-ascii?Q?ThTxQQlUUdylO4FeApXAsaCET8ZTJL2E2LABHt9i3tTkfzzvlB3n8QdkOyUr?=
 =?us-ascii?Q?twEO9/AuH2NwAUB1NamvuujWYqgyJLSS3rfKHki1uPuZm+HT3rHNYmPSRlNz?=
 =?us-ascii?Q?SGStR2zDYHAzGfFO0eAKRM3QIdk6xiWLUZ9akM5gzwcdFYidOnWERavZP4Lj?=
 =?us-ascii?Q?oq+MKh0cNXzzr1jGYFQxEZhGVanxw3MIgCKdnu5u?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f6ddd39-ff52-4a68-28a7-08db8effd1c2
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2023 00:15:59.2344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XgLxUmaiLts8AHlfYctUMYH2gtiJW8On8BV9J2j3KId6kfiIYTsvm7DQ3D2QQsDVw1z9RSX1khkeCa7KshVG5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6808
X-OriginatorOrg: intel.com

Dave Jiang wrote:
> 
> 
> On 7/27/23 14:21, Ira Weiny wrote:
> > Previously CXL event testing was run by hand.  This reduces testing
> > coverage including a lack of regression testing.
> > 
> > Add a CXL test as part of the meson test infrastructure.  Passing is
> > predicated on receiving the appropriate number of errors in each log.
> > Individual event values are not checked.
> > 
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> LGTM. Have you tried running shellcheck?

Never heard of it...  searching...

This?

	ShellCheck.x86_64 : Shell script analysis tool

> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Thanks,
Ira
