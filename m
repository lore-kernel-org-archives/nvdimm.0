Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1727B
	for <nvdimm@lists.linux.dev>; Sat,  3 Dec 2022 07:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670052152; x=1701588152;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=2jw5gmdCvcBB0dt7x+1TZQHxYMPcXRq8G490UTU8wTA=;
  b=H/SqayeZztlSGvMhyaGSPTW2STsy0OTiv0uU+SEeEwFqh73PyCu2apP3
   MKJAwk8F0G3iooGWDxSffiFJ01hJj+axeVOP+SuL4czgrTAe3AUWcY4zc
   YZiJSIH/Zuo6LI0utw+bAZpJiqNH3erDk7J/bUJ/b05Wz2sbTFDETHc7J
   3q/+8HipV7JAQi7faFVNeUzdMmPqBPBcJg0E+k4RAL6fs4/pIPvXn0HgH
   Em7zh/kRIku5a8URVlOztJCmNIOnRq53LQEU3OBrIzvLMP8To97DAXH3j
   wItXBT79xz6E5cM3Os7LkKKK2Qp3VETb5dV5s7CRMuH7yUsH82qAx8BtH
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="380394668"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="380394668"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 23:22:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="819672233"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="819672233"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 02 Dec 2022 23:22:32 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 23:22:31 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 23:22:31 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 23:22:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DSRSzxd+GVO+c1EVrE7QNhS1PWaGtc18rP/6ehbsBGAIBVrUmwU1yrRc9C/YQDiS63N+2A/9EVnTs9CaD273vczHUlJhwkc0xHC5QGtBCIF3/bHyU7BAVygCdkWFQ+DvrM+YW4uzwtasRujlyRHhD0Nmk2tzSKn60Yf/tsKPL6c0uB5j99yB6ctFoK2+TrHtFK8p64WSh97ka3GFP8oyTWZE2txU7Y1347U/IKfTMtkEH7Qckr/O/Pz0aaS3pq8N54EzWKjV/vVnyfjrYtrP4HWLtE31awbKwktA10866bxxnFXsnnBSzGAJ1hFKd1f6ZPnbD6wNiX6OHDrPoB3HKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nw+5B3flGJNya7wX4gGdkW9kMnEOZBvIRqEI0bPkpkw=;
 b=SzfsVMCCB4agskbkQe9oz0tJIFGR7nHeyHtOl59W2NJjrCQiVfaVnhWp0Be7qWBlcgAjJUrCUTaDc9eI/nvbr4NjtUbMdgacxCpzkkrBovVWySps2AAcKfboXMeKvyGgFxtpr87OTcNr2U/YCr611ZPU24G1CDfC8aNvC/Vp+HuqDAFqbUL5pQoowLiZMac1ZQz20Hk90lM5I8xevjchjrhFvJaK3mj2wLkCW3d0gMBnA/lnY2KgLjnJsftlg9aLc6+wH1FjrpCxOMYpNaitF37srfy7fkT+dvxgCvWoCJF5dEriWMiBBLqlpDBxFuUOmaXSDwWEAirhojYdXXZfbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by PH7PR11MB7596.namprd11.prod.outlook.com
 (2603:10b6:510:27e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Sat, 3 Dec
 2022 07:22:27 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5880.011; Sat, 3 Dec 2022
 07:22:26 +0000
Date: Fri, 2 Dec 2022 23:22:24 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Alison Schofield
	<alison.schofield@intel.com>, Robert Richter <rrichter@amd.com>,
	<terry.bowman@amd.com>, <bhelgaas@google.com>, <dave.jiang@intel.com>,
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH v6 06/12] tools/testing/cxl: Make mock CEDT parsing more
 robust
Message-ID: <638af930a3e8e_3cbe0294d2@dwillia2-xfh.jf.intel.com.notmuch>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
 <166993043433.1882361.17651413716599606118.stgit@dwillia2-xfh.jf.intel.com>
 <20221202155829.0000332c@Huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221202155829.0000332c@Huawei.com>
X-ClientProxiedBy: BYAPR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:a03:54::23) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|PH7PR11MB7596:EE_
X-MS-Office365-Filtering-Correlation-Id: c398fbe3-b01c-4380-dc00-08dad4ff2154
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pQ84GmfOw7X161D49A1A9t4pZ6KyDYmdw5DxV4bn/YUqfUbLYb4HMosOdR38LhY0/wcg/nXCLpxiuoqh6Siwx1SHJDe6KgUahF0e4wFb13EdDu96ywcOFeEn7AUIS/0e5P7zO3gNG+tc9+tKiepdSlbFfAx1/sP32DAm5DzOS2FuhggsNPZS9CwuIxtQScqTGrP2OLAW309eH+3qfWXIruzzCtuyLvikIqeRbEs3KFAExKALhX2DSz2WCtP1dFzeiK2qAII2+dyh09gFcTrKuH52fSo1Pnf/UFYcEKRTkHFrhYe25ZR4Ggpv6fGibZG7IMSL8twx9zvIws64HZNR6gDLhjP3RtM81ioyC4ySdDHhCxRFf7KCaTD28iMyJJxn6KLIYQq7qtI96k3+CBB8H82SpJaA4ofZ1I7RrBiJDrm+aTjTGesh2TkEpEDgtqYe/bR0Bme8R+AdZ70BFLsYfydX3Y6sc639cFatdREGqhwvKRiiRf2jvC+kg5s+oZKZzYJB55q5wVoPAXIAsujsipHiolSc6zssrdGdVKD9SIY71yVmEokwDkGfs9OfjNFRcOdLvdbpb0MLSGwfr6WN7B1X4MQwuLITBTaxnOfUxgTJNWC80GMW+9ModwNtlxo7r7eUF0BiA666UvI/U3RzcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(366004)(39860400002)(136003)(451199015)(38100700002)(82960400001)(4326008)(66556008)(8676002)(66946007)(66476007)(26005)(316002)(186003)(110136005)(6512007)(54906003)(5660300002)(83380400001)(2906002)(41300700001)(8936002)(9686003)(6506007)(478600001)(6486002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kLiP1HSMIe/PpNxn0eDsKcXrLmolgNhn1tE049oenZL5BOmZ6u5R+biVihhq?=
 =?us-ascii?Q?lr7hmR26grT/DF7jjLh6U0YbbOJ04gEZYVYVGW29Uwkn+Z0g7oxZsij3vmFc?=
 =?us-ascii?Q?nrhJTqbLG2ND+RBWHVtYshMeBMaXgXhWgLgbk/hA3OLvv8prC5v/H3q9K50d?=
 =?us-ascii?Q?8+2BFLXPomHvmvqlWFT5AJH/n8+Y7S4jS9cLAcMptLDp/SXEvRODUIsILYmX?=
 =?us-ascii?Q?CvRS40aag+7as4nFNDiOTKUO0A9LB4RaXJVFwd7bdfYCz46A0KTCZwa90gOE?=
 =?us-ascii?Q?pB5ttukPyG26wxaAdXaoMTl+JwooP7WeXpmPRxcpqzYKU4xC1CtAyPgey1wd?=
 =?us-ascii?Q?yvnTWtNHtAfqiY9tVnRzbhwhBXpki5bpVeJttZpaLMJiMaM1De1vjIFGXdqe?=
 =?us-ascii?Q?Di8hhyXFkAf0Srs2EBFea3Z/vuLna9M7hbBVHaoxa9b7BUE/intHrc+nrFt+?=
 =?us-ascii?Q?N/GfMpxH3s2lRIb0TIqeEKj4LCMC+RtUJdg3X+U1X//rGBtMHsaJGQEYCBlC?=
 =?us-ascii?Q?X2I+T2Z4Vy7QoUldm0V/7ed6yEQryxRUxyST49Wj8sdP2q1oR7IT2D7yRrom?=
 =?us-ascii?Q?wlCFdYtS1JvMFEFnvom9wT3cpi8MnWmHYMscxNPUtYOB7g89uhxGQ2KXHev2?=
 =?us-ascii?Q?3+H1qGleAI/KAJPyDTFDXr0OSmlEMQ3ePfWWsye0Y6umwHdlggicm5Bj2YqZ?=
 =?us-ascii?Q?VmP1q6dzm4FL5xA2Oi8ONudp9oBT/LbWHZ3O3vPbzsSezqRSTcndXuTPYpIY?=
 =?us-ascii?Q?IFTE6MSVRluGhVDkHs2uE6xjSfMiw4sNIvYY/plz2o8iaYEz+Y80ockdF66/?=
 =?us-ascii?Q?aPDbap8QILhENZa/Q0Kfc+YMJZGZHpRf6I9QPN1j8kgjKX/TBwbC+6MUexyc?=
 =?us-ascii?Q?8TGFiWUsQne6TSd4izwnoPNWd6utAhL00VS7eEfmL2qd/Ab/SOGr/s5DVg1D?=
 =?us-ascii?Q?h7UWQ1Ei+YCLvFSYKiu0jUAGFKTo/5dVSsdqBOd4e2eI4fPyIAITprzBObuj?=
 =?us-ascii?Q?jsVmIevSK8DKz+LbYM/2iFZox9hdvqbB3MZOS3TzMi14oEj/387L17fN4yjC?=
 =?us-ascii?Q?/PB1thE/MSqP5owIrnhHVk2RZ+p4WHe3Tv9xE7+y12BK76YvzJWQ4il2kiLQ?=
 =?us-ascii?Q?p/HtCthzji5iIGVTnGPSSpBRqX92/avZO96zd5hcolAX4BMmmzb+d4hDixQW?=
 =?us-ascii?Q?Kw+oOlm9pVnuYU+l5IGyc+k7zqR2SJ09BbfWF4bBE8vW0o9tLRvowGVP4WLA?=
 =?us-ascii?Q?BBngDDxJGPZY7hFqZ2aZjhoi7t3E/1N6n4jO2fpzhuMKZwknDSngZfDG0dOH?=
 =?us-ascii?Q?KKkeCByD1uPt/I+vRPR/aoTUIrR76Nkg7q+agwr2+rMsg/Vaa81SsvML+SeD?=
 =?us-ascii?Q?7lDG4tzq8qcyf/f0byq0Eqoec+dQfzWA+Czh3q4GD81c9pFXUe7/BZNFlR3J?=
 =?us-ascii?Q?cvLEf4QCynUZ1fu0iG/EXeh11I61XDqF9+j/oneOYmdbs7f9EzdkOsjPf/nx?=
 =?us-ascii?Q?ntG98DFgsist+5qzcFZJhQ+J+Ld6Fg1qbo8eIjzddhmeyr3wN/JKz8YFhbLE?=
 =?us-ascii?Q?1LZwH++ZdHjWEPOZhNlYz5KjivwcexRvU3sJmdeTiKGF8fmdQGkrkgD9c5Q/?=
 =?us-ascii?Q?gw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c398fbe3-b01c-4380-dc00-08dad4ff2154
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2022 07:22:26.8867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I4WpoZ/7IDxAof0ftGpWzlXFwhhSUGjHUME554DHCRlGTTX3CbPoQ2eVP6pMarBQEDEuJGcJhE4tGpYlTioD4wfZc9aQt5f6olhL5d6TNvc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7596
X-OriginatorOrg: intel.com

Jonathan Cameron wrote:
> On Thu, 01 Dec 2022 13:33:54 -0800
> Dan Williams <dan.j.williams@intel.com> wrote:
> 
> > Accept any cxl_test topology device as the first argument in
> > cxl_chbs_context.
> > 
> > This is in preparation for reworking the detection of the component
> > registers across VH and RCH topologies. Move
> > mock_acpi_table_parse_cedt() beneath the definition of is_mock_port()
> > and use is_mock_port() instead of the explicit mock cxl_acpi device
> > check.
> > 
> > Acked-by: Alison Schofield <alison.schofield@intel.com>
> > Reviewed-by: Robert Richter <rrichter@amd.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>  A comment inline on possible improvement elsewhere, but otherwise seems fine.
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> 
> > ---
> >  tools/testing/cxl/test/cxl.c |   10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
> > index facfcd11cb67..8acf52b7dab2 100644
> > --- a/tools/testing/cxl/test/cxl.c
> > +++ b/tools/testing/cxl/test/cxl.c
> > @@ -320,10 +320,12 @@ static int populate_cedt(void)
> >  	return 0;
> >  }
> >  
> > +static bool is_mock_port(struct device *dev);
> > +
> >  /*
> > - * WARNING, this hack assumes the format of 'struct
> > - * cxl_cfmws_context' and 'struct cxl_chbs_context' share the property that
> > - * the first struct member is the device being probed by the cxl_acpi
> > + * WARNING, this hack assumes the format of 'struct cxl_cfmws_context'
> > + * and 'struct cxl_chbs_context' share the property that the first
> > + * struct member is cxl_test device being probed by the cxl_acpi
> >   * driver.
> Side note, but that requirement would be useful to add to the two
> struct definitions so that we don't change those in future without knowing
> we need to rethink this!

Sure, folded in these hunks:

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index b8407b77aff6..2992bac4c0e4 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -70,6 +70,10 @@ static int cxl_acpi_cfmws_verify(struct device *dev,
        return 0;
 }
 
+/*
+ * Note, @dev must be the first member, see 'struct cxl_chbs_context'
+ * and mock_acpi_table_parse_cedt()
+ */
 struct cxl_cfmws_context {
        struct device *dev;
        struct cxl_port *root_port;
diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index 8acf52b7dab2..4f9dc2b3f655 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -325,7 +325,7 @@ static bool is_mock_port(struct device *dev);
 /*
  * WARNING, this hack assumes the format of 'struct cxl_cfmws_context'
  * and 'struct cxl_chbs_context' share the property that the first
- * struct member is cxl_test device being probed by the cxl_acpi
+ * struct member is a cxl_test device being probed by the cxl_acpi
  * driver.
  */
 struct cxl_cedt_context {

> 
> Beyond that dark mutterings about reformatting lines above the change made
> and hence making this patch noisier than it needs to be...

True, I need to watch out for over auto-formatting.
