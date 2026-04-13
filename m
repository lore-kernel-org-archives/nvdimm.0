Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FBB37D13B
	for <nvdimm@lists.linux.dev>; Mon, 13 Apr 2026 20:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776113296; cv=fail; b=c35dK2Hgx/4P2quDP7i1/7RlkZaiThnJzU8IbdHlZDts0zBAjc/EEG2MlK0pQ3UKl2v52zd+2lIxTngpfSwWcBFy2xzJMFgXseWmLFuwsjbmTnNnBYXtZ/BL6ULwvu07Q+MgXbmTG5Qz9jzTQmwCr3c9PvtKSelSytE4K9cv85k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776113296; c=relaxed/simple;
	bh=RwLYRtjkwLOBg17f+5IB6MM2qrhQ7eDbZbSL36sJrH0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UFYoREmqX/dJrLljau/10rP0yiA/rjQgGx81PPk39ATGumjkXAafs4rTfWB/1Wry3Rcx3QbKO+HicTTtwGJ+QkDpICZwR8WFV5mIHTT3XloyJ+TzzZsplYCbKuPKFeFBTTrFkInDw9XxJpF8u4u744vQk3QUCcvLtMp+7c9/ok0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jZpuQ0ui; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jZpuQ0ui"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776113295; x=1807649295;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RwLYRtjkwLOBg17f+5IB6MM2qrhQ7eDbZbSL36sJrH0=;
  b=jZpuQ0uisk65oarPynMPmesD+Xmhpsw9GRaQWbIEQQU2ZHPMRjlqccrh
   SoK+R1aU5xFZ3ZwL9j4m1FRd0n9331pMj+8NxQD1FzysMb+IiGoC/bKLL
   snLkkYQD1Vnc6uoPMOzbA/hy/rsidaa2LRIbvk8oKhl73igoHQay2uvsC
   SDfFtYU1vzZtsZ7dde/o1Qd26r8nR92suaUJAGeEjkOYeywYCds/H8CiY
   DzHCB2x9b3gT11KUJA7fXBhigaoLhM0OI/dvnjlVN4AsUJtyuknIwGqzC
   ibwKu/fBGIRTnJ4EUv5wKPObyDlI/kX1H9d7f4aelDyC7551i12pWN6ya
   g==;
X-CSE-ConnectionGUID: sGOFRnTATrmc6U5BiAvcgA==
X-CSE-MsgGUID: gf41L0whQEKqpTx1esju+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11758"; a="76937940"
X-IronPort-AV: E=Sophos;i="6.23,177,1770624000"; 
   d="scan'208";a="76937940"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2026 13:48:14 -0700
X-CSE-ConnectionGUID: C7HaP/C9SzC0uI8IOZCeWQ==
X-CSE-MsgGUID: 1nAVawXmTimBAQWV5tNIEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,177,1770624000"; 
   d="scan'208";a="234293310"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2026 13:48:15 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 13 Apr 2026 13:48:13 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 13 Apr 2026 13:48:13 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.50) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 13 Apr 2026 13:48:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OEB7RdZ+p7gB5/0S3bKVftiIc1OhgU1aCZYx1fcPT0KtRxP6fCPN3MlaBfSar9NXqX6BCozSHWo5qckwLdaC3twfT0KzBsos8BjoyLjc8W+qTX22hkMgY84fpLA0AYiWs3FPIduokZ+IQNbZ+LbVEHIogEDll6ABF+B260djTMjH+CVyUfPbKfqFhjL9xgleXmSfhY3lHhvUv/3rKvL0aQy4VpM67lz4qTroHQp0T5GThxuqgeBHQrqVNdCdDmtXXHx1XpEtpmT3cZFqHp80tfoLWckH1IcyRr+7W91wpTwv9lQGY2U14TZOG2YMTBJdseNA1bxJeSfzlTyGJIUXIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ed0dWm6yI+SzIrNFM62Vo79sSn3Pay16tmmLMdrljHQ=;
 b=P1edLQIxwhuwBAbFH1Fq+++BaKIcmTSuuJ+N27LKouYgCUgRHKe5q0dlZg5jTj2egi1Wwo36gPqTinywWqbpVikcEPjkT/EM6QUla5wJefZlTv0aDcKCyT8gnJ+lf5i6OAWaBfr/ig/BjTSFdbmryLnBCJwal/IB3U2bC0qtUIPp9qpmBlcXql139LcnOIaBT+GnJclRnkleBc3iwz/ftTtBDNZ4tUvdZo2LJj15bS5h1cHCFU/uNj87emUYpxtXYB4ZCNY1bTXGTWYUp4axqQUjY5iuqL5fT0OLOoGbo1qO8USousTePH6yinIJ9qyWfSFeSxdk6u/IfcpKbXGP/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by DS0PR11MB7358.namprd11.prod.outlook.com
 (2603:10b6:8:135::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Mon, 13 Apr
 2026 20:48:00 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::9618:33dd:29ce:41d1]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::9618:33dd:29ce:41d1%6]) with mapi id 15.20.9818.017; Mon, 13 Apr 2026
 20:48:00 +0000
Date: Mon, 13 Apr 2026 15:51:53 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, John Groves
	<john@jagalactic.com>
CC: John Groves <John@groves.net>, Miklos Szeredi <miklos@szeredi.hu>, "Dan
 Williams" <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>,
	"John Groves" <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, Shuah
 Khan <skhan@linuxfoundation.org>, Vishal Verma <vishal.l.verma@intel.com>,
	"Dave Jiang" <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, David
 Hildenbrand <david@kernel.org>, Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi
	<shajnocz@redhat.com>, "Joanne Koong" <joannelkoong@gmail.com>, Josef Bacik
	<josef@toxicpanda.com>, "Bagas Sanjaya" <bagasdotme@gmail.com>, Chen Linxuan
	<chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, Fuad Tabba
	<tabba@google.com>, "Sean Christopherson" <seanjc@google.com>, Shivank Garg
	<shivankg@amd.com>, "Ackerley Tng" <ackerleytng@google.com>, Gregory Price
	<gourry@gourry.net>, "Aravind Ramesh" <arramesh@micron.com>, Ajay Joshi
	<ajayjoshi@micron.com>, "venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V10 0/8] dax: prepare for famfs
Message-ID: <69dd576924b0f_24f910029@iweiny-mobl.notmuch>
References: <20260327210311.79099-1-john@jagalactic.com>
 <0100019d311bed04-dbb67b48-c55d-4e6a-962a-a0f8b714f2e7-000000@email.amazonses.com>
 <acrpbBt5UsWEiEbm@aschofie-mobl2.lan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <acrpbBt5UsWEiEbm@aschofie-mobl2.lan>
X-ClientProxiedBy: MW4PR03CA0160.namprd03.prod.outlook.com
 (2603:10b6:303:8d::15) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|DS0PR11MB7358:EE_
X-MS-Office365-Filtering-Correlation-Id: c2dceaa8-cc1f-49f5-7f3b-08de999df325
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: G+co2NslQv9RBhS2Z94R1Ssf1vAQJv3dOuLearb4bzBZ3qUuTobJe2g8FXm6Z/bqXD15/7v2X1HD8IQo3BJhuM4MJVN0VV0iOtBSec5K1lOaW0dXG9Fg8tXwmtML7nUTyCzf33Rc5PeLEZKlXXQvaNwkJFOokCeHasYvgT7Llvfbi9HVQPypmdNhhI3LixUytQeCP/7kTZy8T2blvICMLpdCEtT/IH0JrGWPncOotga963CFYk9h2yyvIS8rj6rzILKRLjveCZIw6SZ0CUnaMrQU4Tsa16JhLJQkAwjH+ayO6R4/rCNxRvFt5k5K7xVeGqyWwqIodxh6zNmHIDFzcQRA7vrOEgOx5nzIdD8TP6Ju9/jq3AJt/eqZHNIosrakMigOKiGsW4gE0jJuXR/QAY8EoOhCzA08+iMwYnDxAy3qZPFDUmiPFAWeiPD7S1LNSfCtmNzYxAvBcnI+ag6+ndZibwfEdpFIWP82D/wWWpPzK5q3CPlBL1JytzVXZsRmAYcOy8Oq0CRMJ/k1Idf+BIEk9SUXd5EE4vmBldGCRNotjUtAsz+qsLOUivqKT7CarUbg/47aWKCGNtlHELZFCsDDry4MKWqdgjmKwvjzmviLr6LVU5EdddtBxWJpazrhEHY3F1ZrU7Z3jH2MhAC4aL9JQPqupox7L6YfdRLwNYCE2p94OBm2GOVtFVVkN5cjBhyCkvqoGMZ791GKuLuORZtIzEPJ6YZKps3UlZzZs+U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8lMzUSrjUA1e6765pDlyo0s/BaSUW/GX4BEsdpy3e711g9MPbWhuVss8h5pL?=
 =?us-ascii?Q?ShksS1aSOMn/0Qm4wJxpIKiiVxJ8C/CuM1nl/cGXK4TiqQhqk8WE+hsTgMnm?=
 =?us-ascii?Q?A/cqV7mgnwk6jjf/ebVPgyCTTZJdFvZLWB5w+90qEnwduU/eCb5K0iZifbwS?=
 =?us-ascii?Q?eRZtdqzegCzJDe2NIp1ju3gV5I28Sdk5QJ+2gn2t2jyn7W6Atap5uYelGnob?=
 =?us-ascii?Q?DYWllSA9mrRpNRnmz0Kyy+RGJnd2978JdVdwiAGDW2zOgL/GOSzVtHnvyLgY?=
 =?us-ascii?Q?Bpw4EpsiAPmEf/ZPRoSSbwa2QG1y4Wa8OKe5TOgefPQ8EzYe6vWqV6u/cVbg?=
 =?us-ascii?Q?z+ReaXRl4ipe/DSm9/loygEXrzmPtDhEk9YpGou069j0D5pPCUF/leJaEj8R?=
 =?us-ascii?Q?7uEZ2WJelHGY7pwU5+gOULj/I0Lkx3FMSrMZlK3DiGn5f1IwrBGXq23/o/ML?=
 =?us-ascii?Q?BWyGQpR2fDlOfoV1j03wcbRRUOmXU7A5Pof+cgM0Aoz9/xcIeYnueKptZcpD?=
 =?us-ascii?Q?e6VZkvssDA/OECWZXiBmU8za6/tbg84/Acwu/hKp970ZFY8KtKHcVB21bn9I?=
 =?us-ascii?Q?x4kHh4Sgv+ewCzc/LEmDeD86OEaDp7GLhwn/rmq4hJ+ozcXVtWUF9/OwgPrQ?=
 =?us-ascii?Q?KEbUh++MZwy2WTf6DBdpEvBrslAUcb3qt8whgtxUSJygaeMddgjUM/Nvu1ip?=
 =?us-ascii?Q?b4tn8I5hzRHCAd6itue6URxkuEKT/uv+GINhwfkT5vWKHXCwc12XhAG9bsrz?=
 =?us-ascii?Q?KRYQV5YYjnPkiooAckC3LYtf4dOvJWwFMFs1zOO27eU7Wwp3QozIY/6ARw2P?=
 =?us-ascii?Q?O35klk2kxecAwLD05jnHwKmkZX2R6NmOqchPf0Ob5AzPe/qdh3H/LzF267C1?=
 =?us-ascii?Q?5ZAgQGT01H0Ta8rWtWUb3y5YDIb0hCMhmSyr5KXQgxYGuoSalM2cj1JMauIj?=
 =?us-ascii?Q?fo7iVH4Ap7Ptt2T9ghyHoAv8T/L2SRV4lXUrq9PXf8Pi5lXcvf5ylCigZLFU?=
 =?us-ascii?Q?UkD0CMgA1FlEx6tm2wXpPe5Stl18QnQmpjkyIzqhuCpahFrkf3cfyleExY4U?=
 =?us-ascii?Q?h/1eCDmobI68eWSA5NftbUwIucFqa0KnrYBimOA9XumvVSYcjFlYXZ3KnQc1?=
 =?us-ascii?Q?juGLsaUlmRAYoC1WI1knDW+IHAU1IMqvQZjnRK7eF9vEepZL+kU8tslyayCZ?=
 =?us-ascii?Q?LEtOAeygmMmJ3JllHI4iRwWjzN6jWRjl6kwpQGH8fzTf+hJyDdQymSSFOHCD?=
 =?us-ascii?Q?QpyF2eeCBW1Uler+OlJyDl/cuAl+BcdIkrsH8P6URy7ACVyl6wmOP1vnwd6A?=
 =?us-ascii?Q?WGS+CDf6HKzYi6gOO8esgnAZ3SONUkjEv56/+zl4xjmYZM7hBGP6QqxBnJ9V?=
 =?us-ascii?Q?hrwVdYDPll2oW7SAe6vYHGZvxBXlbsJuKpDlXaYsYfJtU2OMvhYoMvv12Uct?=
 =?us-ascii?Q?cGMpvyg6kphMfevxky1VWvs6xy7By7H3WMC2+EFnl4BjFHdRTaH0vLVEk8aU?=
 =?us-ascii?Q?zwf9+DGRAE8ecrt3vDwT6BvpKplr8f0mExOGzVmMq5iSnL9b3Kkv0u07oQYL?=
 =?us-ascii?Q?knf3D1deZ9DauAqNJWtVyfcuywm/bfy//I4GBozjS+/yJDXHk3HG87+Wnwq4?=
 =?us-ascii?Q?Z48kNXYiuszJOe4oAvzKLYUUEAYzhA8zdRW2Y2tp9SyfS1Ae7wqcqlX6P9Fj?=
 =?us-ascii?Q?Im/ptb+AwFSW3SSnn9kwOUcwmczBPCOr3dR3ZrOakd0AssNz/3mjjTkESo02?=
 =?us-ascii?Q?2Br5XNGiag=3D=3D?=
X-Exchange-RoutingPolicyChecked: iwGemxzJeqeVozhfAq5sp7IwtAH38sP+X15nKP13Njm4qPNaYxsrx4ae0NcZtz4MjUBrTe0BfkaYQlh2tLxXvBN95VGNVHwL/042NG8n3LSU4hPlQkGoa8P1yeIp3N3xeoFzPzGqyPa2wLhAT6YqEvE8+Bf6xxeE1g/mdKLf9dO1JblAFb9I1BC1dj+xjQ2eCgxy16O4vpVpSgilsDf08V9hyncJ3HCl0YH9z6+fPBKaKPnw86UOj7CdqUM3lcho7ZPZC2ULVT84kaR4A1Pv1fruVNJvwFTWkovNfeg/PWB9B/p90yz0S+LH7ykJD8ZYzDZ3Y8WwsAWiKiplXnDyDA==
X-MS-Exchange-CrossTenant-Network-Message-Id: c2dceaa8-cc1f-49f5-7f3b-08de999df325
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 20:48:00.3346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /NejMXr65UuLnf1L1isNTw8wYNw7Nke54+GGbdiucNT7lvn3lBBmoqL5wCKcMYKEQLm/qUOG1UNr7Zx/WOjb9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7358
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Fri, Mar 27, 2026 at 09:03:26PM +0000, John Groves wrote:
> > From: John Groves <john@groves.net>
> > 
> > This patch series along with the bundled patches to fuse are available
> > as a git tag at [0].
> > 
> > Dropped the "bundle" thread. If this submission goes smoothly, I'll update
> > the fuse patches to v10 (very little change there as yet).
> > 
> > Changes v9 -> v10
> > - Minor modernizations per comments from (mostly) Jonathan
> > - Minor Kconfig simplification
> > - bus.c:dax_match_type(): don't make fsdev_dax eligible for automatic binding
> >   where devdax would otherwise bind
> > - dax-private.h: add missing kerneldoc comment for field cached_size in
> >   struct dev_dax_range (thanks Dave)
> > - fsdev_write_dax(): s/pmem_addr/addr/ (thanks Dave)
> > - include/linux/dax.h: remove a spuriously-added declaration of inode_dax()
> >   (thanks Jonathan)
> > 
> > Description:
> > 
> > This patch series introduces the required dax support for famfs.
> > Previous versions of the famfs series included both dax and fuse patches.
> > This series separates them into separate patch series' (and the fuse
> > series dependends on this dax series).
> > 
> > The famfs user space code can be found at [1]
> > 
> > Dax Overview:
> > 
> > This series introduces a new "famfs mode" of devdax, whose driver is
> > drivers/dax/fsdev.c. This driver supports dax_iomap_rw() and
> > dax_iomap_fault() calls against a character dax instance. A dax device
> > now can be converted among three modes: 'system-ram', 'devdax' and
> > 'famfs' via daxctl or sysfs (e.g. unbind devdax and bind famfs instead).
> > 
> > In famfs mode, a dax device initializes its pages consistent with the
> > fsdaxmode of pmem. Raw read/write/mmap are not supported in this mode,
> > but famfs is happy in this mode - using dax_iomap_rw() for read/write and
> > dax_iomap_fault() for mmap faults.
> > 
> 
> Here's what I found:
> 
> famfs-v10 on 7.0-rc5 + ndctl v84:
> 	dax suite all pass 13/13, so no regression appears
> 
> famfs-v10 on 7.0-rc5 +
> (ndctl v84 w https://github.com/jagalactic/ndctl/tree/famfs
> top 3 patches + edit daxctl-famfs.sh to use cxl-test:
> 
> 	existing dax suite keeps passing
> 	daxctl-famfs.sh oops w the new test at # Restore original mode"
> 	seems easy to repoduce, maybe cannot go back to system-ram???

John have you been able to reproduce this?

Ira

> 
> Let me know if you need more info.
> 
> -- Alison
> 
> 


