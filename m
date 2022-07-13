Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C61A46B3
	for <nvdimm@lists.linux.dev>; Wed, 13 Jul 2022 16:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657731232; x=1689267232;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=O2BylACcuV1yD3BDwFxBNxah0SEI8iq2Fc4CVKwPc74=;
  b=JZ1SniDz4EfNR0FJj4y4uxaIGcs54Qi1mcmRYHuPERFuukw4wDdLVqFt
   VWOW1JF/gh77LArlSQ6l9qQt8FJ26RmOyHST0BXH6Z2HIL88/0+bHjDx1
   WRQ5Tk7+jc3t8xtWyzLQLYDKAwC0TNJUIxArZUki6RJeV63dTIX+Oe3uH
   pcMNijxOk4AQYA5I7OhqWNPHYs1unGARiv9Gf+OR3AAkCbsvwH6K5cE6Z
   U5XGthBvi4eFAX/NJpAYc4Pd5M2ygnv9G2+2lFW7BNNjG/U1/k2eqVCmF
   EtzpwtnjFUgKvcHULGsx21Fc8rRrM4HgbP5lom4Rlywo5AudM8nrPMfWE
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="349253491"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="349253491"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 09:53:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="595772338"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 13 Jul 2022 09:53:50 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Jul 2022 09:53:50 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Jul 2022 09:53:50 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 13 Jul 2022 09:53:50 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 13 Jul 2022 09:53:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XrcMRpDGTIEWUy5Wpbl5bOC0hgGlEbjrshNI69rqTX5/r3ws+VA8pNhsFDbU/F/DInNd7y1U7dxC7bGWynBEsdJSNF6zI37nnIZes7a2MqtHM4VtECQrzRvAwdGKC8dBB+goEqtdXoR6oa9NWgH3F8lqDkVLrj0aBRklUibv4jq/hFQvCDrs/yk6x+gBbVVd2ArKxQ5dgN9eu83tCSCgK7r2F1h7MPLi/5S59Mgv2wMFoyTkknIaYmlVbQK6pMoXT/pAH5rsZ9TduvT+rYz4ay1D1PDQySIOzBIfajFf9cjHODN9fG74yroCa3st+hBB/tIdAmlytnxj9Qt19jeJPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hCJvdQyzCh3bqXAb3ZFzPdSjguIqSy5jx6STWVQ2OoQ=;
 b=NYoH0ecPgu1fsKEzcE5n3I+8o6+SwDCGECMSQ7FBHQOTat02MhZXRb4Mp2OPxVE9jg9lsOc/udK0EnJDnK/AwUAHIR3NO0TOn9nmAWYLoMg+RYmmJrgGyj1iNN6314xjD6sq/nJd/9PN44K2NYRzmXYCkiWzNiB0d0zsKZYO0Yc7mYbxkLxbL8lJeuXrIdYyZGoy9VShby9sHvgt16WMLJZrqS9LuREB3NqTRgZRzKBpMveqmRhvEBmSOE3IjDP+aJCCG+4A6r/pnxZ/VrvR7oxDPhJg9wxJSD/1226tr0n3Ri05TXk7vQWgbPv383jGlCJXf6xDZkzq/2c/JerzLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SJ0PR11MB5021.namprd11.prod.outlook.com
 (2603:10b6:a03:2dc::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Wed, 13 Jul
 2022 16:53:48 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5417.026; Wed, 13 Jul
 2022 16:53:48 +0000
Date: Wed, 13 Jul 2022 09:53:45 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>
CC: "Schofield, Alison" <alison.schofield@intel.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 11/11] cxl/test: Checkout region setup/teardown
Message-ID: <62cef89960a0c_156c652948b@dwillia2-xfh.jf.intel.com.notmuch>
References: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
 <165765290724.435671.2335548848278684605.stgit@dwillia2-xfh>
 <4c3074a5393a5d3758ac58028e047edf43f84115.camel@intel.com>
 <62cedb1ad2457_6070c29451@dwillia2-xfh.jf.intel.com.notmuch>
 <78497219caf627714d2ee1b553ff3f78474508eb.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <78497219caf627714d2ee1b553ff3f78474508eb.camel@intel.com>
X-ClientProxiedBy: BY3PR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::15) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66d2e6e1-913c-4d14-9dcb-08da64f04158
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5021:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 62vlsXt9Eg8qJENBePnt+ecwwxNlR7vkIOv89h7KS5GU8ssZmXFuRqS2Pock/noymLMhBiWbsXM2j/MJrFADGppTCBofej71SaUlGRkY772z51pljvpe2LbPY5DqVGzhjM/KW+TpTGY53Q6O+/qFTN/ezTYW8gbZx+jjn/xYyhfcNzdaRKAz3r74Gud20hfeUi+tdk6kvbnT1Zl3nkexfFKxr7uZFwcsFBquUQAHRXJWzRk5RUHUzyogVFhe5X2pSzj54QlsOUKl6qHpQpdfZ+uDPCg6eZLlPetb8DldRloTbgvGxDhAFDU+1VSZcLlJdR8uwNOUfTY8nvyM+vuOOsO7I1K7tCU+zsVGkIBqEJwgJmDA3sx0EXCuOCFRBZ6v1ln79tbNhL10FQZxWs2eHPY+Bgx9vierHTmcO4lKtiXtzatYasGn1Uw1LT4VBhBhZ6XvE6BOhGhLKMlDjZHomJJw6RA4xG7LDSRFn7H/KbgBEb0gxu7LqMYAK8697d8nNl3z27lR21WsIOw5DP3mtJ0TzsNFBYq3nj57LuuxNEdlbfQklH9W2UkWhBvvfDtP0OlE4mJaUdUMzmTzYiLu0Da1YBwxiQ+9dXstAaRvCFIJwiOopY4FHvU01gxV87zKULLUaSv4qhWlszPXk0z8kextonFjpkHvOhKcB8fCHlxPicJULiPd6n6Sb+dvvT3fmXP61dJmkXp77Pw6QQc6MSKv2no/0N/lh7iSwfoahUw/0lZiop725+mfjPsr9c4ef+8RDllGipY7ijXMl8COzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(396003)(39860400002)(366004)(376002)(82960400001)(86362001)(38100700002)(8936002)(478600001)(5660300002)(6486002)(6666004)(41300700001)(54906003)(6506007)(316002)(110136005)(4326008)(66476007)(66556008)(66946007)(8676002)(186003)(6512007)(9686003)(2906002)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?atGXbr2EhYBMu2v/0aK03KtbeNAwbgjE4MsekQsa7+fzmo36Pg4Almeg4o?=
 =?iso-8859-1?Q?t1pznOkAnsqp8JrU/4qutZhCzCH3QBMTI2SNIQ7HZGrhEDVav8pWB6o4kd?=
 =?iso-8859-1?Q?3g60+ZMPyRpV5m8UTJDcWrVymPSxvfA29NRPeevgpX9wctuvMcPuZjWY18?=
 =?iso-8859-1?Q?k3MIhDHaWxSPjMkLwkNgqa8CnUQFshSizF6aErr8GjtvQa6jPCF55b27yC?=
 =?iso-8859-1?Q?BjZ/LgmFk92u6DHVrlYfQ7YP1SsmZ/qLjav+IXjrET9IVObHcNjlFAOevh?=
 =?iso-8859-1?Q?TYseWRq86bS/wKiexRQMBe+Pf8bG3E74ipsSdItOWKhgVKX6vvhyI/qMCQ?=
 =?iso-8859-1?Q?AHdT1cFKwc6jbSjit+Lz7UW07TsnMMXxu4xx1eOVZvQ6bZrhGY5tivl2SI?=
 =?iso-8859-1?Q?s12nsWw05HlnU2G+KQF99S06NYBgIuegfdJWSh2G13fUVp1o2g3c5GSo9k?=
 =?iso-8859-1?Q?odELBbIlsI5PYCP8rcNtGEOdbNA1dgeaE27FYQkPJXkPQ7QVvBUJtQgmr9?=
 =?iso-8859-1?Q?AkvIBc7ZVBiNOzOHyiInlyPRht63NUwWkQDOkz5av1G4HpYODvGnD8rzYA?=
 =?iso-8859-1?Q?u0EpSaMgYPKPDKcW+WwH0Jokk++ObvmHNmyLPD6uFno5RE3dONZPqgrrTj?=
 =?iso-8859-1?Q?dyI2W+2lIrgybaYL2vaxAJv+xBnXwP2VrN0mVIg2Ch36gX/8bt8BrwERrA?=
 =?iso-8859-1?Q?SZCFEG5IIbhg8x90VEUHqnNI3r4j191DXXxgC50T8VuAo94a+aNxfefXre?=
 =?iso-8859-1?Q?wg1APy49nfRZhVHjaflVUuAdaFFDyNRSYx0PayLjAtA6kgTAz8W1zfhwhX?=
 =?iso-8859-1?Q?+GgqbesSX3EDb6+7QrGlWi6E0bzyPAGQNiJsUYnv76pIstQfswtqjRkXxL?=
 =?iso-8859-1?Q?da1BGVD74P3WLY6OLsAFCvHizor2ky3BkwKl4zw7Wp6wKzoB3MnblJ7wJS?=
 =?iso-8859-1?Q?Xbr5AGm0aP1ehdVFhNASl3xtEEPX6HHYZIY6S/yYZ+Zm1jTVx5dK+b7Jcg?=
 =?iso-8859-1?Q?B8zyCAZs1KoQ3/+vwzn6LQlLvMUaHLWvR4rGbUdjJX1Wv4Gt13M9ALz0P7?=
 =?iso-8859-1?Q?pbVSawWn13L+bzvreAVpomu6OAuCdIxSiK+Yx6LCcfQXC8KJx9fNJ9VQ5C?=
 =?iso-8859-1?Q?hUgXCBy2Zpjz5gVwVghH5/ALBTOU7bIsJApKsjDll7ZH3ZDEkA22rns/Dv?=
 =?iso-8859-1?Q?7HK5w1bU5oBZ5WJSe1FatSFKVqCd4PgMX+HAslRgRSAJP7RRnHa78pZAFr?=
 =?iso-8859-1?Q?x6ksLQ9VgMoSr3jfRsZ8NaDJjZtU5wP9vxNHEgyp/dL8ayg/s4zYrnZHpB?=
 =?iso-8859-1?Q?HECPXMI4WzZk4xU0knYqFGAF/nKIG/SonZj43wKXwa9Y2jZpGAHzyy/TiR?=
 =?iso-8859-1?Q?b0xXAI28qJTk9gCVRxVNOYcKUXhPvBaHs7qHNXcHlfYApKvyrQI1BjEprX?=
 =?iso-8859-1?Q?8lVd1kspKCA3+v2Jh60cVVTC9oFdLLRhROHMyAP5/YQnZMRu9Njs1a1M8v?=
 =?iso-8859-1?Q?5Sefj4n3ak9Ae8+M11sNSsT85th6vF+KQlJt/8F7Us6A81JjErP56VvSpk?=
 =?iso-8859-1?Q?gaDDsV4rqUi6hHSv9tfTOETYmkffl3J+6si0m0bAcA//DIL0FOqsTaWIWx?=
 =?iso-8859-1?Q?zYRPhnrKW87VheAjpGkK4CD8X49/b2dIRIaPVY5XOQz7xDxnNfqj59/Q?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 66d2e6e1-913c-4d14-9dcb-08da64f04158
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 16:53:47.9320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: POpkbQaaDoyBd+N5uhPt1NCgX3J04S7vRMIs8y0lKZ7yjH1qOGrarlhnuQXHMdde/az0p7Ouvz7Hz8ewTTNobEZGUyF4F9LpwvsBavr+L5U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5021
X-OriginatorOrg: intel.com

Verma, Vishal L wrote:
> On Wed, 2022-07-13 at 07:47 -0700, Dan Williams wrote:
> > Verma, Vishal L wrote:
> > > On Tue, 2022-07-12 at 12:08 -0700, Dan Williams wrote:
> > > > Exercise the fundamental region provisioning sysfs mechanisms of discovering
> > > > available DPA capacity, allocating DPA to a region, and programming HDM
> > > > decoders.
> > > > 
> > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > > ---
> > > >  test/cxl-region-create.sh |  122 +++++++++++++++++++++++++++++++++++++++++++++
> > > >  test/meson.build          |    2 +
> > > >  2 files changed, 124 insertions(+)
> > > >  create mode 100644 test/cxl-region-create.sh
> > > 
> > > Since this isn't actually creating a region, should this be named
> > > cxl-reserve-dpa.sh ?
> > 
> > The test goes all the way to the point of registering a new region with
> > libnvdimm, so it is region creation.
> > 
> > > Alternatively - I guess this test could just be extended to do actual
> > > region creation once that is available in cxl-cli?
> > 
> > I was thinking that's a separate test that moves from just one hardcoded
> > pmem region via sysfs toggling to permuting all the possible cxl_test
> > region configurations across both modes via 'cxl create-region'. One is
> > a sysfs smoke test the other is a create-region unit test.
> 
> Ah okay makes sense - maybe this should be called cxl-region-sysfs to
> reflect that?

Sure, sounds good.
