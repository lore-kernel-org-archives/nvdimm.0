Received: from mgamail.intel.com (unknown [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE3F235A3
	for <nvdimm@lists.linux.dev>; Tue,  1 Aug 2023 19:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690917206; x=1722453206;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=1vXMS1MUoKThQJulP7U6MtBRNKGWrnaVTOVPVrzBu0U=;
  b=YqeQ0QSpNr18ok6wbOjFUYIPuBmgk509BrTaMOYG5OSXhhrwgOiq5weK
   OLWN4I9Q5sd29wVLf5kvOoqzEE2FA4VbjgrCp27z4xnVPnqew826Ya6Xl
   Sa4JYZsZbcmT3KP+F5fQru0dLpfXZ9IR+Y1QRT0I5LQRqpL+2pnUko/2O
   auZ8bTUv2q+UrjUPVgDSfmHy4MluxnZ95V93J7lKu/OmNfNXkEncyORbO
   Ymbjco6A85dyYZLx0RvFx6n8i6uOFfSGUm0sxBXK5E64X1ezc38hN03Si
   ogIvvnYt6xqEl7nwViFyT3Y7n73v3s08TEZMO4ArwrPWIwiuCfIDJKyku
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="372121797"
X-IronPort-AV: E=Sophos;i="6.01,248,1684825200"; 
   d="scan'208";a="372121797"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 12:13:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="818907903"
X-IronPort-AV: E=Sophos;i="6.01,248,1684825200"; 
   d="scan'208";a="818907903"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Aug 2023 12:13:26 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 12:13:25 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 1 Aug 2023 12:13:25 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 1 Aug 2023 12:13:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jXpeGr1OPxZ4nmUHV7W3vyKuVGXZqwfVZ0XR+Ww5bnZLl63eAP4RIeaWnol88dFYYm9Zo2DdXfWK1mhPvOc6kVdOB3zEV8IrtniyGPT1PdaEjD9OsGLi0qQ6LMXUUwHW+RElwZYlPV5+nNOCuS/3MkHNQrYA8Yn6AhrfF87Om2oGIntx7SM+XVBSFpSaOlliYLfEZVjIVvaOowXsG2GUhHc+5Te6MTXn5RhPE2WowfeTx0JjCB9NhgR4tnOk4UtNht9kTdiUSMxQl9SOg54+O/2KkncXHffCRvmNSXPZRgPmWb6yTPMyRzpDqLfGsuPSkFhpTO1rVWOtqd5FFnVV5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w9b4+0S/+XY92pcXZMhvUYJ90u4f+gXsObSYRSRq6ec=;
 b=H/+5S2PAPPdpH+sezkl7mUF0TtsN8yDgs8lXDC5JuNntvFg6EHoGIqkwcSHIGn090qIQzfSkZc9OLuYcYXKFPJkeSjiZ0kJWZp5O3WpIsUJ+HmFb5L4ecHURNdq+h6qQNbs+fdeOrStDbfu424i4BJ39ZG2hy9iRGi0L3Xqczi363cqtrKdLM94kYTTtpkzOPeznBrREbmCpEfrzO/OxRVJSWA7DZBEUTYb6u3J0Aq4gm9zUow+wnyvljbPtwDr/n35oJcLi7VEG7fnSHpQUcOX/qfd5LJ628jVHtBASuUtmiWhX7hW8FsLe5Iq+YOcyvcFlsHK0plY7mr1/FYnN7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by DM4PR11MB6165.namprd11.prod.outlook.com (2603:10b6:8:ae::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6631.43; Tue, 1 Aug 2023 19:13:22 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6da5:f747:ba54:6938]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6da5:f747:ba54:6938%6]) with mapi id 15.20.6631.043; Tue, 1 Aug 2023
 19:13:22 +0000
Date: Tue, 1 Aug 2023 12:13:07 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Weiny, Ira"
	<ira.weiny@intel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave"
	<dave.jiang@intel.com>, "Schofield, Alison" <alison.schofield@intel.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl v2] ndctl/cxl/test: Add CXL event test
Message-ID: <64c959436daae_2616829484@iweiny-mobl.notmuch>
References: <20230726-cxl-event-v2-1-550f5625d22f@intel.com>
 <f65ef4e6cf9c93513ee6395c835553142db602eb.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f65ef4e6cf9c93513ee6395c835553142db602eb.camel@intel.com>
X-ClientProxiedBy: SJ0PR03CA0349.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::24) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|DM4PR11MB6165:EE_
X-MS-Office365-Filtering-Correlation-Id: 48193348-fc54-4a99-23ab-08db92c35f77
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UKnEkK0H03pyO8NlY9wcF4vczSEc2AHnIgVnYMepPuOgzd5kcn16cIb4VbpVSY+1uSGN6v5rWejXOm7O13H8g9sRogX6e6CpbqO7WiMuwsj+mN14TWkQmZDNHlzuFsTw9bBPAeiM4jfg9Dyc/Dtf6JXM+euAsXT8XJE/SGLMUCQX9w3HfB3ZxIizp44yccesHHkpK4yAtTXD/3lSrixm4cbamgND9YF3Z5F/0yv29zAAEfxOJ1DFluPh+IjrWn6lSxw0Pz5dh+Rl1QFjFjaziYI3Aiv2H9qayHSa07hRy4LcYVFhyAvLFi1JqVWKvM0uyX8W1oxtphgAvkQVHDJEPS2EXTovvJtSmperMkuT1iIyEVU4h/bVqPVBCWAX4vefyreMVChwp2fLtz9uuVQuUSm3aEWytQ1MHXi5jN87I1rbXNvJeXe9plhXXg8Ln28tLM7aX8434HkoG0XrzKsJlELduLbVn6IkO91WsHP5UPQHsR5f0Cplc1yail6AV57qjLMy5xmPGa7ySsIg/ETfaXDW1rSfO80hEBog9/cJ6TE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(136003)(39860400002)(366004)(346002)(451199021)(38100700002)(66476007)(86362001)(316002)(8676002)(8936002)(5660300002)(4326008)(54906003)(110136005)(66946007)(66556008)(41300700001)(82960400001)(478600001)(2906002)(6666004)(44832011)(966005)(6512007)(9686003)(6486002)(6506007)(26005)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?cihIwkRDeHS54vyMSHiQwgP99ElXtyITZxPJRjiK/dWTSQJMAN2TSx8WEB?=
 =?iso-8859-1?Q?tIDf+k2FI3p+MfbMnJVfog+JTLg9LHeCjEBNQjDhq7JGWH13oBIc2VjVzM?=
 =?iso-8859-1?Q?xmeChbYpwso9vcyhwlNzwQhG93C+5LcEmxB9IieBeULA7c/7o1Iz59+ZMa?=
 =?iso-8859-1?Q?kHo2zUYrDlmtQvYtF8eGavbGgYpLc9GTOChjbOGwWenJQuCJV9NMEA4Jkk?=
 =?iso-8859-1?Q?qolcjRTK4hnMnUOtZ9YHIfJUd01dgmMpyg4gQh+IHfkjNOD1ZPhVubY1lI?=
 =?iso-8859-1?Q?FRvsbHSGExuBdGHv4qDAuNWojEIwnDhugeCIyRbdeyQFiDKctLH7krDnFl?=
 =?iso-8859-1?Q?o5GaVtO9eZQ7fkK9Ao7yQFKy5veH2QpZn7KwdB859JoNAyqdsILXGX2t0a?=
 =?iso-8859-1?Q?Tx97Scrkzor3fWVHc0MCnQLsy/8cK8vFvNUKVUe46CG01uDjngLw5CTcwt?=
 =?iso-8859-1?Q?8elVo/EZkY4hMriTaiclo7nPp5m0sPbgOa8IvmNHGqwrjWj5yAn/9SY2Nl?=
 =?iso-8859-1?Q?miStD2WJIarImNl/2SCwZiT3G5nm5lAcnlMs/0W0l5VgpUmlAE0tb9zoKT?=
 =?iso-8859-1?Q?rX1N6+1gwouioOYsjC6s11N+S9Y0qrj1zrGU4mtSDI6LrJPS99I2FQkYpm?=
 =?iso-8859-1?Q?kOlrjekUrCaOwqbrfkbEpNMh9ZiQ3GjzqwGSpJx0et/EdYloYgdlUEBeqC?=
 =?iso-8859-1?Q?2Pslq6aOd+IVLQ/yKGrgrfcuQj3Cz/bL8txT1yYm8i/xwwHmAO2BkCTuma?=
 =?iso-8859-1?Q?niHS9gE2jfmEt+/ms3sZcw1dnuwydOAMBtzqd0gSb3hLGUmXRSW08m6CoV?=
 =?iso-8859-1?Q?MbpdPk79hZYNTDc1FeaTbnb8+tXgusqBAwDrbRq5AZSmeV2vYRn/5umIOH?=
 =?iso-8859-1?Q?mFVywgkU4oqP9J5VHphS3Twn1wfb2OXTdFS1Ex69S2A4Ra3xUSoIHpUv5Z?=
 =?iso-8859-1?Q?KRLMkHhG+FexU/MHOqU8OiwOSs2d+soNmiphkGKP2c8L/67zgJSBk/ZuxL?=
 =?iso-8859-1?Q?c1d8zZ/NBHQ2CzaF95sgYl35Ebhk8PRDxn4Ri1tmRT55qGW9NBSShKFfd2?=
 =?iso-8859-1?Q?96JCZxD++9GRtVksamVX4mM6HNQMnpHsvsoxdiaDQePAk0/9Z8hFkmx/vx?=
 =?iso-8859-1?Q?hMyWfMY7+DHFGp4KgvOdyiJI9IXEp1LsrU2etglCaj1WyzT5IuyPjudYwc?=
 =?iso-8859-1?Q?1FMfmcFiH8uSgaQUgOMTkSoqtjnHDtwJ5yihmU9r48j+DgEii/5LXW93QR?=
 =?iso-8859-1?Q?ZDpFproqC8W1xR+eWgjKJqx/kwpwXkOS9PhapmocEI3jElqhbdIkvESI8r?=
 =?iso-8859-1?Q?3zKg8nIqnSyyHBR8TEqNNBn9n70yIgwyx3GrXIVq7sauvnt5rjuF8ayxEJ?=
 =?iso-8859-1?Q?WxVHd4oWxgzkmEzt+LPIS2k+6yNjwy/EsqwZq3stTN/6Mc/zl0yK5BT44j?=
 =?iso-8859-1?Q?GB0MwBK7TNlUbLTZp4MqzzY6iycMwSDoHFzsILHklYuXeV3Sqs/gllGh9J?=
 =?iso-8859-1?Q?riAtfJvKLWQLCBjb6zRHuQDaF07BSsJf5iYcAdaG8hYSzYX7WYh8ZtjC6w?=
 =?iso-8859-1?Q?FzRn6uyifEzUcDCdfi69WS/F9SYzc87kjH9bJ1tw1+4Qs6gvDEuZS030+4?=
 =?iso-8859-1?Q?6E+3ZyUugQi2pA4EbQMc1KgrcNSxLrkO0r?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 48193348-fc54-4a99-23ab-08db92c35f77
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2023 19:13:22.2511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qFDsEWBLRlV2KFhUC+Bi2f6K47oGMzKxoqnBiDzfIsb4MkfV/JyUuqB7bETR1nqbg4LfRxuHLmkaUNCTMM8UoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6165
X-OriginatorOrg: intel.com

Verma, Vishal L wrote:
> On Mon, 2023-07-31 at 16:53 -0700, Ira Weiny wrote:
> > Previously CXL event testing was run by hand.  This reduces testing
> 
> Reduces or increases / improves? Or did you mean running by hand
> reduced coverage.

Running by hand reduces test coverage.

> 
> Maybe this can read "Improve testing coverage and address a lack of
> automated regression testing by adding a unit test for this"

Sounds good.

> 
> (no need to respin, I can fixup when applying, just making sure I'm not
> misinterpreting what you meant to say).

Thanks,
Ira

> 
> > coverage including a lack of regression testing.
> > 
> > Add a CXL event test as part of the meson test infrastructure.  Passing
> > is predicated on receiving the appropriate number of errors in each log.
> > Individual event values are not checked.
> > 
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > ---
> > Changes in v2:
> > [djiang] run shellcheck and fix as needed                                                                             
> > [vishal] quote variables                                                                                              
> > [vishal] skip test if event_trigger is not available                                                                  
> > [vishal] remove dead code                                                                                             
> > [vishal] explicitly use the first memdev returned from cxl-cli                                                        
> > [vishal] store trace output in a variable                                                                             
> > [vishal] simplify grep statement looking for results                                                                  
> > [vishal] use variables for expected values                                                                            
> > - Link to v1: https://lore.kernel.org/r/20230726-cxl-event-v1-1-1cf8cb02b211@intel.com
> > ---
> >  test/cxl-events.sh | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  test/meson.build   |  2 ++
> >  2 files changed, 78 insertions(+)
> > 
> Thanks for the rev, everything else looks good.


