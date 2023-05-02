Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0C78F6E
	for <nvdimm@lists.linux.dev>; Tue,  2 May 2023 19:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683056887; x=1714592887;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=bulARVwY58zHqpBANFDw2A+CKzrSRaPkMsOet7I8I9A=;
  b=MKzVaRZc7Hk2UhpKOC+3d6ZpOKD0Pt8mgd3IkomcvE80o8pIghXBXr1H
   Da0E6ZJwXVvk5tio353Jwn1imjD7xzzI7O6UQ4Q3Bdf2VQqWsLJg3fZyd
   LGLBXboWN9RtPo2ZimW0NG2AdSnSgOIiG6z3h0NoXuiULLRIioYzrYRJ0
   fft3/Tgq+/lFl/BIyJxqV4z6NQbUq3Ljc+ryOQ1MtbanQaVdt4tXdg5ax
   +gmQaPAqx4wqJDrCM8ka4sj38mcwbVrpGtNuatJfm+BfppWwUt/jK6WUB
   SYvGADp0gGzBLriKa30GP42wq4vI7dSBy7q/ohf1g4H1KgNgZawABtoWu
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10698"; a="351469596"
X-IronPort-AV: E=Sophos;i="5.99,245,1677571200"; 
   d="scan'208";a="351469596"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2023 12:48:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10698"; a="646647013"
X-IronPort-AV: E=Sophos;i="5.99,245,1677571200"; 
   d="scan'208";a="646647013"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 02 May 2023 12:48:06 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 2 May 2023 12:48:06 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 2 May 2023 12:48:06 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 2 May 2023 12:48:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WdqoIyq602DGBuCWwGXyBDihn6B5X3rEAXEOz8VkIogTmS+tfBDnxTb2kjNim2Q2U5W8br1Ku4IlvCk5pYNUb7saDjsh2WIb2Sc6sz2qJzAFbJ5LXHIkAnH2PjDYktJr47vN33T1WDOBcgEvrTrpsP++QRbS3NVdMdQCTHFm2C69eJxRD7YKlMTq5VB/79TVdG+YKI/uqrHYt5SSy3Mo46oU3/PfkfbF0k5JN/1GRT/47BSY4FdSJ1lf8VAS/tBweerKMiEETJzBuO3BQ22IpGu8zEzlYuD75V8rxa83L8T/0bcjovazy0R+01uGPCmPkdUFAy94SJ2qEwtfdhseHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bulARVwY58zHqpBANFDw2A+CKzrSRaPkMsOet7I8I9A=;
 b=J2X4lOJUvWhge/naWYCBUKOjUBp6U74GQ0Ps9f/wzWfxsuC8sr9wvwjlLVPAXQBeZpe15ofitv/E7EzUTyxdtLoe63t49ud72pmBR+MwiL+kJBbb7EjIEui1x9jpXh11FTwqAM1MLVgODGx2ZQdBVCZXqZkihC5mE9VHGtZ4ZjW4gj77fOpRtmtPYppxjzJ2G4iOeFuFNLROY5Y100CYh7qEQ+cP424j/5KpX73d4Xm6UhNLdWV8Kr5LPTEUfzd7cSwqbUyBiFdIqYOTTN/GdNaEYc3JQn9MGXnJx7Zag1jc0NjHN2e4XebYZ3H6KwmerlHokgK/v5Fad6b8uUgLSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA1PR11MB7110.namprd11.prod.outlook.com (2603:10b6:806:2b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Tue, 2 May
 2023 19:48:03 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::95c6:c77e:733b:eee5]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::95c6:c77e:733b:eee5%6]) with mapi id 15.20.6340.030; Tue, 2 May 2023
 19:48:03 +0000
Date: Tue, 2 May 2023 12:48:01 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>
CC: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>
Subject: RE: [PATCH ndctl] ndctl/namespace.c: fix unchecked return value from
 uuid_parse()
Message-ID: <645168f11e756_1e6f294d1@dwillia2-xfh.jf.intel.com.notmuch>
References: <20230502-vv-coverity-v1-1-079352646ba2@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230502-vv-coverity-v1-1-079352646ba2@intel.com>
X-ClientProxiedBy: BY3PR05CA0054.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::29) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA1PR11MB7110:EE_
X-MS-Office365-Filtering-Correlation-Id: f381d90d-a27a-49f5-268b-08db4b462434
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kJt7IoGr0eBGGg6wDRKX875ak+ZGZRwjj4GrBD/LAITygPYf5MTGII/1VSS0Uzj+s5XxqSvpiqEDTLQB+q9wTMOLd6Ovr1rQIvnNf8fmdGnTVN6N3abcvgxv45l0LucDsT6YEp8gPetW5puPSalYQLvtbYIqzsMXY+pHZ20PzDiML87iPjAG0o0o+Ux5k/B6xnDRSlhf0LOOQ44X4/LYboDMAX898v5z+psy3E/lFK/zMSI9O1d0dt6VnBg9Kkj38YRIwDinVXVkbFR4HS3if780GZ53PqGffrHMW9WkQA+k4ThbHdUZdci24wcCTyoCRZTUssfuNhabYHgnZeNrkDLUOfjC/ImH5Cp3FxkCo8mbM00hTOuVSuZufZjuQFk9Ob8+ZI1QdL7mIuRN/q33Q1bs/yhGwc9CyvR+emmx4okRCsoZlj41RQgzyrEIDEI4CNWpAtUf00LFBfcMAIPc3auEB6SlO6zk6MYBbXZ9WNX7dcjPLyzN0cdiPZvaPd0Xzo5CTDWRQF8iIDSjIUS3bB4bwQv/boN+mPi36sx+McO7TcbxvmoTebx1mTXMqISh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199021)(9686003)(6506007)(26005)(316002)(6512007)(5660300002)(8936002)(8676002)(86362001)(478600001)(186003)(66476007)(66556008)(66946007)(83380400001)(4326008)(54906003)(41300700001)(4744005)(82960400001)(2906002)(107886003)(6486002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ssEqf3/wRGA4FkHxels0SNQjwcp0LFxhCJ84ySmwqHVA/p1Nf7TKhG/1CDsx?=
 =?us-ascii?Q?CUMxoglBhPf1wNBeKIad674sNJQFYi68v3vmCeq29dscQ0M2DG3p+O2Pl3vk?=
 =?us-ascii?Q?5dp70+G3e+LkkzRifjDxZ+YUB1KNrXcJkkSpqhpNNUWI5QajL94VRscFlvDi?=
 =?us-ascii?Q?aG19yavUekj5yY7Mq6SnPuE9DYgI5yBz3kF0zAW2aWjGf3splVyhBVGQDDQj?=
 =?us-ascii?Q?X1FRk1YuNO6+qFqDxMKY2TEZbpEnXT1e0GJxii3hys73DEPIpEv+9hgRzT55?=
 =?us-ascii?Q?kLpLKptStZTRee5puGGzfEoE6n9c7Kzrj9ZTlq6ptVQds59PvPCvQsHLzi5e?=
 =?us-ascii?Q?GH/IKm+F7Ea8+vb4lEXqQKFSl96vpQfWhXWBnuobK0TxdI2MfY57Y27KX2X5?=
 =?us-ascii?Q?sstEIJFzj2WyLd89UWibQmVKBCuv3GytSRMjVI0kHsXacrw8b6OPShYU2yQo?=
 =?us-ascii?Q?/NVJJzyN8xgicbpD7ZtEu9+zv43QW4O8AWIbhVwvjAkjN71Eoyq4c48L0T2O?=
 =?us-ascii?Q?ENLfh2E3x+4o8dbGSVC/1bovmSDZfGZikF/Vd9d2Mc8CXfQaM2slkV8VSZ2v?=
 =?us-ascii?Q?I1a8d92PO1NkeUguWqx42QZw1C5XdlfgUXyVhV/omcBFP6zB3dtqGPD4u0in?=
 =?us-ascii?Q?lANHLNPmfuhhC0+5rX+y0VMq/YsfvXQum1fV2bG+7AgaPYVEQg4qWmNlUVAZ?=
 =?us-ascii?Q?RFIKD7fnr2qH/WnMnNMs5ThulKLofbcI+yhScLihR5MaE+tynfGdq+XNy24e?=
 =?us-ascii?Q?f4tFqIVKPLq/Y0OSIRUNZCvW3DYvSu7Q5ZRe1mwATejNkqxhVbwInDoWcu9T?=
 =?us-ascii?Q?/y0M9vfsWmyidDDfSsZvbhSVFctMaaERTfrC48obqLND6JhJA3j3Y0yJ1QSk?=
 =?us-ascii?Q?SwO2cEtKPZd+8Y+/TMq6qfnTc+Xyu8rckXGtNInLZdkzZbRGBSw7CkW823fS?=
 =?us-ascii?Q?LFq7JgZpYTcnSVFG0bHka0QPiWWtJwRwQPcZhtS5jJLyMmM9pPbSrTlFpnFz?=
 =?us-ascii?Q?mtVBrZ+yry88h27M+IjAOCM3QLR+qgw0WD+vwCjFwbFclFGF4LoTmSnQwr4g?=
 =?us-ascii?Q?W7hPuhYuDRmz3uSqe6fM8KaneRTMZ2iPIK1jq02MioAYkGbkxe1PRsVtbAW8?=
 =?us-ascii?Q?jhyEZK/jlIMulFgba3Ijt4V9XbU/5SZJmn4Yo0M9KW6yIWJ4dJZI1vP1aJD2?=
 =?us-ascii?Q?aD3UJv/R5ne0Ga/FwpPTcbogF4FJUifwI2bcMNV+XAuEEFJgXl+NrEIwTw+i?=
 =?us-ascii?Q?nKDM/dAT2IeXR9l1/DeON+wC82CVHiMWDO7JcGAF2qmOyMK/B4AVS0xu4zTQ?=
 =?us-ascii?Q?g8X5T3JFjdeZqW7ADhG7pCJDKEPo+fDD+IOVxaGW4xUdbr84+hKgUZ8zkL1G?=
 =?us-ascii?Q?fVdlbBNufZEMK6uTE99YCDhYd+gWjYAYAleEkz4WumDVKRlIChN6nLeBoT7T?=
 =?us-ascii?Q?3tGp6YofIga80rPjrpphFOIJvBkIZjLCOX9B4jEdpsD8Owr6a/0ELo4eTV35?=
 =?us-ascii?Q?61f/6r19Mwe1Y3Paj1yz/8c1h46kT0sKFTkoAByayTzWfo/kMKUZXtxwmEDg?=
 =?us-ascii?Q?nEVj3EThadypuP4wCOLiQJdbpfm400gGuPJAnmoAG5sXAaLwN9Ql2uSQavaV?=
 =?us-ascii?Q?rQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f381d90d-a27a-49f5-268b-08db4b462434
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 19:48:03.1948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vx3dIm7ulyPIUGDOooRQa4ERo3vFQgNG71jf1QPFfXJ5W2SI8HIacATTACc8FzLFCHp3UvkvopSWYbhBTN9ZHhgsjY2D7RbezXBZ8zjxEy4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7110
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> Static analysis reports that write_pfn_sb() neglects to check the return
> value from uuid_parse as is done elsewhere. Since the uuid being parsed
> comes from the user, check for failure, and return an EINVAL if so.

Looks good to me, you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
