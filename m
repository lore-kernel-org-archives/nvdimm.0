Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A1338E8A6;
	Thu,  6 Aug 2026 01:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785980285; cv=fail; b=AjL1rEfWv81MjREG7Hwm0Alqte66HoGWCjzVadZyOPT6JyYwFBz0ayuwv+9HBEHmoTfYPUgnofrjqGZfFP/oyzpYYBqVxRdin+C9tozFZJ8Injtmdc7N3FY/AbkCoTR6UsnrBwJhkrcMUqsVeMNeeGbUvjch+xbIq79lKtbSvjU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785980285; c=relaxed/simple;
	bh=istFMcc31ChfCwW8ce/ZY2e/CnkRlJE1aQHNVIB1GL0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=R39Uqmp/yY/zp8vrOIl/871hDR9axnXkC7BhhrEI4LxpzcwH35CkTZ38tUPBz9sfSOCj592Z0CPm3d/X11GSg6g1ERIhKrUwItsENxSKU0FDS/8NjH+9dMMlSo8zwAZJKsA2qbizUDGoAkDejWb0BV5S/Y595dWok4IKWBc+TvA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n14QLQhn; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n14QLQhn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785980280; x=1817516280;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=istFMcc31ChfCwW8ce/ZY2e/CnkRlJE1aQHNVIB1GL0=;
  b=n14QLQhn5jOgE9JOr8OxHBjh/pK2K4rFfTz+sq3KfpA9XajPtt71bznz
   /ZbSoApM0GdwhptDjmyDsrtYNSjYSM4hFX7oH5UubjfFTAgR/WmP62NW8
   oLxyjd6s8DgvRgCQtSRgGcJ3B422f+1+vaPP+NL00KJa/XpGMmumL11un
   EIjmj/7TmVjR7UPr5O4LsiC827cURNz5Qxl0D2vQrlKgb4hPpxwfLSa/e
   3tQGHsndkssew++2JF6dlsHfrpb5WaZNdN26UIy5bQHGD/W70JfRg1ELn
   DuysiHJIZvddzIyU6gAjDfbsckLTJ9G6P/2EFVvAo9WAnI/M0p4r55SZg
   A==;
X-CSE-ConnectionGUID: hh+EW35uRhq229M1+4TE9A==
X-CSE-MsgGUID: MQDOl+vHQeeSBE1qd8m/dQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="86643171"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="86643171"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 18:37:59 -0700
X-CSE-ConnectionGUID: L6HugFEHQsKERwZIyNjy5g==
X-CSE-MsgGUID: jVWRt4rjQpqsNXlKXZQ1lQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="266184174"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 18:37:58 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 5 Aug 2026 18:37:57 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Wed, 5 Aug 2026 18:37:57 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.1) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 5 Aug 2026 18:37:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dgUx3qaOnWuQs1DBbwa93d9jKksApzHxKoqAAKCNZHTDgb8T2K1g7z5tmROFTEr24sDi35w34mYGo4A7ahJ7IND430ZgkyRFGuaQ9TwWED2sLKHfOhcUtEzM9nlLWej1fzbdPxbKZNgNLUZ/6829wJxhQixqddPXTowQkUP5S7haL7wnl62M8TCgZbr67gdcA2UWO+te8iCV7geFKFdPZv7CkEhLZG0oaC9UHXF6C/9GhnAr2VXxnUeal221E+6gHUmJ1v1Vqj/sk/xciPhy/xSxcPmpGxYrepySxG9mmclz9BOoUzso7SpWZDiLjBDQDLMOAYhonTdMTC75YyCx3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eUXm3+c2f/2ujEQdODUNRb14pfCcx3ZtwcSPcPV14OY=;
 b=LCmQ6f238HSpCgOTcRDUyWsWBKuRnB05HOTh7qZOnUTTehyckN+egKdzDSON61ajWpqrkQ+UhVhG5fTvZj5+vmUznMhzyyLZ0u8kXwuBLqU1O56ZomIGr03j1UZfg+i89ngXltHRVuqMtICTzJdytfWvfIg8H5kBvmuHcIN8HBQ+QopoZFeiBwBzuMFA3Ou5bAt5nmetZoiy0w6CFOiUBEMJlW3ktXd9ZFL1CQDkyCpy3arOVhsEeQ8Z3UNzppydSUkYyKijeOWgxx6Ta35ieD1saWlIt/05K0fWT4QwnoZnK4ZV52MtfzMzzhujQlRsCR/ijIQJQu5v1MoX88aQ/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by DSVPR11MB9914.namprd11.prod.outlook.com (2603:10b6:8:45a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Thu, 6 Aug
 2026 01:37:55 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%4]) with mapi id 15.21.0292.018; Thu, 6 Aug 2026
 01:37:55 +0000
Date: Wed, 5 Aug 2026 18:37:50 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
CC: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, "Sagi
 Grimberg" <sagi@grimberg.me>, <linux-block@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
	<linux-fsdevel@vger.kernel.org>, <io-uring@vger.kernel.org>,
	<linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	<linaro-mm-sig@lists.linaro.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Sumit Semwal <sumit.semwal@linaro.org>, "Nitesh
 Shetty" <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, "Anuj
 Gupta" <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
	"William Power" <william.power@intel.com>, Phil Cayton
	<phil.cayton@intel.com>, "Jason Gunthorpe" <jgg@nvidia.com>, Damien Le Moal
	<dlemoal@kernel.org>, "Alasdair Kergon" <agk@redhat.com>, Mike Snitzer
	<snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Benjamin
 Marzinski <bmarzins@redhat.com>, Vishal Verma <vishal.l.verma@intel.com>,
	David Sterba <dsterba@suse.com>, Ilya Dryomov <idryomov@gmail.com>,
	<dm-devel@lists.linux.dev>, <nvdimm@lists.linux.dev>,
	<linux-btrfs@vger.kernel.org>, <ceph-devel@vger.kernel.org>
Subject: Re: [Linaro-mm-sig] Re: [PATCH v4 01/14] dma-buf: introduce initial
 file I/O infrastructure
Message-ID: <anPlbjhpPmj2VZxm@gsse-cloud1.jf.intel.com>
References: <cover.1785274111.git.asml.silence@gmail.com>
 <bc20381e8daf85ac58811c344325d8192cde9d1e.1785274111.git.asml.silence@gmail.com>
 <181b08be-04bc-4ae9-bb88-15321a82440f@amd.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <181b08be-04bc-4ae9-bb88-15321a82440f@amd.com>
X-ClientProxiedBy: MW4PR03CA0164.namprd03.prod.outlook.com
 (2603:10b6:303:8d::19) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|DSVPR11MB9914:EE_
X-MS-Office365-Filtering-Correlation-Id: c876cdcb-d8a6-49ec-dd18-08def35b5633
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|23010399003|366016|4022899009|1800799024|6133799003|56012099006|10067099003|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: 3BwP0gKaFbZePSAlr0/DcE4Nbr4VZPqLcgNL+FYdGSS/NY0UGtTzXQCCT9mwiFL1b/xkJ49ZLhp2884ejBQyhyepG/TLvC0YDPqVmZQguFktfO7DBlhbO1NGytXn5T/lKgPtIiiYP4t8K3GvK4qk7XCKv0zNEm1vHI+mmqCalVrtjrbpMlTmznZQ06kbw/SLGhqY2eayyP1Bp1Wcovx3Be6ACCpKPX66aSaIhvG+p4sBK5Cy19TnkVQlHxeMSPvFInZe1H8zRcmVMYUYmpAATDjlef50gI1iuC901Eg5FnFQX9Zf75c1j0WI2eeqYMQ1D+0V9pqE4pj2U+uXA7vDlfxqiAex5zilA5PQbK8XLvSIeQVvVQgB+a7roe1eHwi2B+3nvzqwk3Peb0oeRHMtthhf6X/aq+czMNpm8nkVb5Vd6j7mOj41gDT/PsN5yo1ROpVWlQc3Ke7RO/xVFm+PQAKK+a7vb+i8BuESKpg1tgYOdR4X+ebBCiG97qcgwHbzLi3sQ4NdvrbSdNTu4zyjHrs4XKVoP8z6IlVtehCuyAca2p8YrsTUhTJc9/NeAloFWHeZ16AYukpFG2070IWNM7jsSIVNEpmqPCfofy0Yq1QOB+xpvI6Voq0Natxj3dqP4FEWVWpVukr6Z/3cvhARNG9407RXLO2vvmkD7wBxawA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(4022899009)(1800799024)(6133799003)(56012099006)(10067099003)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?pMqFOC4Gm9IlfT9vCxSBu7/77zTHXmiUAaPuTZ8AwgCiiD0c9yvpm25PBm?=
 =?iso-8859-1?Q?TJvqS87J6zDycb0napnWjaDbrCfGanO5xGpvjDLWTJ4KrhFe+AbhUbF+eG?=
 =?iso-8859-1?Q?9EPp52dTC4zGWuLW9oGexKXGOVht9tMoMMJsVH1nL4dbKc9NKCepzOizdN?=
 =?iso-8859-1?Q?yZ652GXuPpsI4L9n32AeNbhvCUMk5zIaaFxsfPBpCafPS6Wkp3q3DdCg+i?=
 =?iso-8859-1?Q?a7zmrm5aLWLnBDK82LGbSIFu/aWx8zqoQ5v+TOPQLs247rDsciv7A2RyNu?=
 =?iso-8859-1?Q?NGSRGEtgjG2s51/SapeCEkM67O6fmX+x/B94wr66JeciUasWuRELMvrfkq?=
 =?iso-8859-1?Q?gnx9UFwxehtEK/rRH+/0N1aXV6gmJIfEmQRRpu20jzYM+uc8KzpPLsy9tj?=
 =?iso-8859-1?Q?1TTbmBbR64ZaJKrIi7rALl/oLM3CZqLEjh5jKZncuTXL1C2h4Pn97S+pyu?=
 =?iso-8859-1?Q?C7B/2YKIEe5F5P+ihEZtyQuWE46VTM1ibe2slLX208yG4jSOhTQc35Fkr5?=
 =?iso-8859-1?Q?9gCP1A+ZvCk7o0AvN6EC/wvIaUVsEXy6Qqp56qKQVKJCSplmoYBpPpFtl3?=
 =?iso-8859-1?Q?q+fuVSKjgTV4EkvzvVX5XdOhzfafQaRT4aUg9OXLVTLFcn0673/lLTNODf?=
 =?iso-8859-1?Q?9grOELnCE9Iy0UOFjooy5uCjDA2pOq6dGUxyCBBCZuuhX4OWpAK1ZVsh/Y?=
 =?iso-8859-1?Q?fhgHrr/YiVvkc0IQDYQhRET6+kcWne+SPnj0UedBEwaviJhjAl8d4aNdee?=
 =?iso-8859-1?Q?OygZi5+saKaVLi6wDRQZLV04/0J2B74wzylRRrsQTemEiCuQzv8jryeSfL?=
 =?iso-8859-1?Q?z0oV335dkCKW8Zuol2vikurKSEre+GFyWPPqRoMmWz1NglgwJx/FWbf3ch?=
 =?iso-8859-1?Q?hDw54OAShMmeVllcXfPPUIIPtKlFZozfYv5Abf5UT8vggPkgEN6Wp7qWgz?=
 =?iso-8859-1?Q?Fe1e/oTihoWrihtWluECDutqHH+AjX8JxeM7CEQlW+oGKggpRD9g1lc3zd?=
 =?iso-8859-1?Q?HdF2dnGV3SIYeZ3KCyJSwPCkdWul0T4p8Qf7xaFVpAorsojQ2ezmsScNvu?=
 =?iso-8859-1?Q?w/WVLFY04r4gzWRo8u7S/WormdQK6gXzl7P2TTag17ps5yjm2WNKaaEHtZ?=
 =?iso-8859-1?Q?AJFMIf9/fJ8MhFPSMDpZo21OtH7EWz8SUIMMvFx7dzDo6l/oohaBub2fZK?=
 =?iso-8859-1?Q?3tdbn8QNvVEfKKNxtkD7oumJNEcXetcER+2PksXO9Z+M9ok9KReTtK4v7H?=
 =?iso-8859-1?Q?xPtm6bcutbmZdUHrVf3LQJSJ9520n59JJq73+Kl4yzIB49b8iHMO+QfKHb?=
 =?iso-8859-1?Q?LVCTQ+CwM9JIHmSoQx5Y4TsierFdh4z3ymotkufki198Tt/+P+qzgd45Aw?=
 =?iso-8859-1?Q?TsCDIwifxAZDLElRcq1vlliliMmHXHgDl9XGCEnHVt0wBNqIy6bVoVmNG0?=
 =?iso-8859-1?Q?lun3p4uvtvFJ1o70mNmu+WDxRXQ6yQ/tGxNzetmwfLcpu2b/9WU2Pol+cX?=
 =?iso-8859-1?Q?DM+pOTzALDqAG9O8Ol+ao8NLNherLkPHkbjTlxgeIDqt2OH3ocXAcdCfWh?=
 =?iso-8859-1?Q?Qt8K8yWSr7z3G29Wpke3BKfgVpmf7dNJ0MPIjglcXtPad68rvlUI9D5tIg?=
 =?iso-8859-1?Q?zkHXmZHcGvu3BINf9i1eNwfwd0Cl96BnbRXCdPNuWTJsyJ1sXs9+ibgi/k?=
 =?iso-8859-1?Q?QJFJu3zSs7v0WC1Y6O6cFgufEZ8u/FPEQgNSKj88iCZoc7CmsFaynWUxGc?=
 =?iso-8859-1?Q?QxklleOyazzdV3W864TVGKK8qZrUXE+TaPw19vJd48vxi+O4lTqIhEWK9H?=
 =?iso-8859-1?Q?DAfjc9/lJtQaI9hSAErhy78bCN8eRus=3D?=
X-Exchange-RoutingPolicyChecked: slOMhwlmqESaG1vdD5BdYIrcqUM+oIQ5DNhe6c7J/97j0ZjIdU6zMF9UgPxj5PvueU4O2OZntPFh58ypljuI74cwSp0cbAsaukr0AW/VYFt91zqbvZf4HAtnps0LZTZIgQM6aa3MSnbXAICZ/pA+O0xxdxT9avOPkIVLm1MssIxUXNbNdccz8nGxJIXAuYLb9nSr8mDvNJh0b5y6NGVFTYSyuwpFYWDoM5lROLY4lSJds8ipbq/WSPAzztHd4Ig+cEst4wDuXqwhdDC/nplcnjbWMq4jA7Skwv3SXqIjEgKwIGTmn+8O4iRIQneBVhGQKUF/Q0lo2awXH+k6eft5HQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: c876cdcb-d8a6-49ec-dd18-08def35b5633
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 01:37:54.8795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5274K+gRPC5Cm/bXy8sjTwk1/xIwctC0/is5V4yWEDqjAVm0NDACYv74cEQda09fvvQa3kOLaxTlWxkpeVH2bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR11MB9914
X-OriginatorOrg: intel.com

On Wed, Aug 05, 2026 at 10:27:49AM +0200, Christian König wrote:
> On 7/28/26 23:29, Pavel Begunkov wrote:
> > The goal is to be able to natively use dma-buf in the read-write / IO
> > path. This patch adds basic building blocks serving as a glue and API
> > between drivers and upper layer subsystems providing the uAPI. Later
> > patches implement it for NVMe raw block devices and expose it to the
> > user space via io_uring.
> > 
> > There are two main objects. struct dma_buf_io_ctx and struct
> > dma_buf_io_map. The ctx is used during initial registration and serves
> > as an interface between the upper layer user like io_uring and to the
> > importer subsystem / driver. The map represents the actual dma map
> > established for the target device[s] with dma_buf_map_attachment() and
> > stored in a device specific format. The context is created via a new
> > file operation ->init_dma_buf_io_ctx.
> > 
> > The ctx-map separation exists to support map invalidation (see
> > dma_buf_io_invalidate_mappings()). A ctx can create
> > multiple maps during its lifetime, but there can only be no more than
> > one (active) map attached to it. Invalidation drops the active map
> > if present, and the next map will only be attempted to be created
> > once there is a new request that wants to use the dma-buf IO ctx.
> > 
> > The primary task of the dma_buf_io_map object is to count requests
> > using it and to wait for their completion when we want to destroy the
> > DMA map. Invalidation is delayed by inserting a dma fence, which is
> > signaled when all flight requests are completed.
> > 
> > [un]mapping and any work with dma addresses is delegated to the
> > importer driver via an ops table stored in the ctx, see struct
> > dma_buf_io_ops. Only the target driver / subsystem knows about devices
> > it wants to use the dma-buf with, especially in case of multi-device
> > filesystems or stacking in the future.
> > 
> > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > ---
> >  drivers/dma-buf/Makefile     |   2 +-
> >  drivers/dma-buf/dma-buf-io.c | 275 +++++++++++++++++++++++++++++++++++
> >  include/linux/dma-buf-io.h   |  91 ++++++++++++
> >  include/linux/fs.h           |   2 +
> >  4 files changed, 369 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/dma-buf/dma-buf-io.c
> >  create mode 100644 include/linux/dma-buf-io.h
> > 
> > diff --git a/drivers/dma-buf/Makefile b/drivers/dma-buf/Makefile
> > index b25d7550bacf..523731b0f83e 100644
> > --- a/drivers/dma-buf/Makefile
> > +++ b/drivers/dma-buf/Makefile
> > @@ -1,6 +1,6 @@
> >  # SPDX-License-Identifier: GPL-2.0-only
> >  obj-y := dma-buf.o dma-fence.o dma-fence-array.o dma-fence-chain.o \
> > -	 dma-fence-unwrap.o dma-resv.o dma-buf-mapping.o
> > +	 dma-fence-unwrap.o dma-resv.o dma-buf-mapping.o dma-buf-io.o
> >  obj-$(CONFIG_DMABUF_HEAPS)	+= dma-heap.o
> >  obj-$(CONFIG_DMABUF_HEAPS)	+= heaps/
> >  obj-$(CONFIG_SYNC_FILE)		+= sync_file.o
> > diff --git a/drivers/dma-buf/dma-buf-io.c b/drivers/dma-buf/dma-buf-io.c
> > new file mode 100644
> > index 000000000000..5f545a1bcf32
> > --- /dev/null
> > +++ b/drivers/dma-buf/dma-buf-io.c
> > @@ -0,0 +1,275 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Common infrastructure for supporing dma-buf in the I/O path.
> > + *
> > + * Copyright (C) 2026 Pavel Begunkov <asml.silence@gmail.com>
> > + */
> > +#include <linux/dma-buf-io.h>
> > +#include <linux/dma-resv.h>
> > +
> > +struct dma_buf_io_fence {
> > +	struct dma_fence base;
> > +	spinlock_t lock;
> > +};
> 
> Upstream has change to allow embedding the spinlock into the dma_fence, so this structure here is most likely not necessary any more.
> 
> > +
> > +static const char *dma_buf_io_fence_drv_name(struct dma_fence *fence)
> > +{
> > +	/* default fence release kfree's the base pointer */
> > +	BUILD_BUG_ON(offsetof(struct dma_buf_io_fence, base));
> > +
> > +	return "dma-buf-io-ctx";
> > +}
> > +
> > +static const char *dma_buf_io_fence_timeline_name(struct dma_fence *fence)
> > +{
> > +	return "dma-buf-io-ctx";
> > +}
> > +
> > +const struct dma_fence_ops dma_buf_io_fence_ops = {
> > +	.get_driver_name = dma_buf_io_fence_drv_name,
> > +	.get_timeline_name = dma_buf_io_fence_timeline_name,
> > +};
> > +
> > +static void dma_buf_io_ctx_destroy_work(struct work_struct *work)
> > +{
> > +	struct dma_buf_io_ctx *ctx = container_of(work, struct dma_buf_io_ctx,
> > +						  release_work);
> > +
> > +	if (WARN_ON_ONCE(refcount_read(&ctx->refs)))
> > +		return;
> > +
> > +	ctx->dev_ops->release(ctx);
> > +	dma_buf_put(ctx->dmabuf);
> > +	kfree(ctx);
> > +}
> > +
> > +static void dma_buf_io_map_release_work(struct work_struct *work)
> > +{
> > +	struct dma_buf_io_map *map = container_of(work, struct dma_buf_io_map,
> > +						  release_work);
> > +	struct dma_buf_io_fence *fence = map->fence;
> > +	struct dma_buf_io_ctx *ctx = map->ctx;
> > +	struct dma_buf *dmabuf = ctx->dmabuf;
> > +
> > +	/* the release path must wait for fences */
> > +	if (WARN_ON_ONCE(refcount_read(&ctx->refs) == 0))
> > +		return;
> 
> Stuff like that is usually illegal.
> 
> And why are you using refcount directly instead of kref?
> 
> > +
> > +	/* Prevent from destoying the ctx while unmapping */
> > +	refcount_inc(&ctx->refs);
> 
> > +
> > +	/*
> > +	 * There are no more requests using the map, we can signal the fence.
> > +	 * It should be done before taking the resv lock as someone could be
> > +	 * waiting for the fence while holding the lock.
> > +	 */
> > +	dma_fence_signal(&fence->base);
> 
> Signaling fences has a whole bunch of very strict rules associated with it. E.g. you can't alocate memory for example.
> 

Yes, and the rules around signaling fences from worker threads become
interesting as well. In practice, the entire workqueue (or any work item
scheduled on that workqueue) effectively becomes part of the fence
signaling and reclaim path.

> Are you sure you actually need and want a dma_fence here?
> 
> > +
> > +	dma_resv_lock(dmabuf->resv, NULL);

So this is illegal because code is allowed to hold dma-resv locks while
waiting on dma-fences. See dma_resv_lockdep / __dma_fence_might_wait /
dma_fence_begin_signalling. 

> > +	ctx->dev_ops->unmap(ctx, map);
> > +	dma_resv_unlock(dmabuf->resv);
> > +
> > +	dma_fence_put(&fence->base);
> 
> You should probably set map->fence to NULL after that.
> 
> > +	percpu_ref_exit(&map->refs);
> > +	kfree(map);
> > +
> > +	if (refcount_dec_and_test(&ctx->refs)) {
> > +		/*
> > +		 * Destruction needs to wait for I/O and dma fences. Defer it to
> > +		 * simplify locking.
> > +		 */
> > +		INIT_WORK(&ctx->release_work, dma_buf_io_ctx_destroy_work);
> > +		queue_work(system_wq, &ctx->release_work);
> > +	}
> > +}
> > +
> > +static void dma_buf_io_map_refs_release(struct percpu_ref *ref)
> > +{
> > +	struct dma_buf_io_map *map = container_of(ref, struct dma_buf_io_map, refs);
> > +
> > +	/* might sleep, use a worker */
> > +	INIT_WORK(&map->release_work, dma_buf_io_map_release_work);
> > +	queue_work(system_wq, &map->release_work);

You can't guarantee that a GFP_KERNEL allocation won't be performed from
a system worker thread, so you can't safely signal a fence from one. The
pathological case is when all threads in system_wq are running work
items that perform GFP_KERNEL allocations, enter reclaim, and then wait
on a fence that is signaled by another work item queued on system_wq.
Since all worker threads are occupied, the signaling work item cannot be
scheduled, resulting in a deadlock. We actually hit this exact deadlock
early in Xe.

So, as Christian says, think carefully about whether you really need a
dma-fence here. If you do, then you need to play by the rules.

Matt

> > +}
> > +
> > +int dma_buf_io_init_map(struct dma_buf_io_ctx *ctx, struct dma_buf_io_map *map)
> > +{
> > +	struct dma_buf_io_fence *fence = NULL;
> > +	int ret;
> > +
> > +	fence = kzalloc(sizeof(*fence), GFP_KERNEL);
> > +	if (!fence)
> > +		return -ENOMEM;
> > +
> > +	ret = percpu_ref_init(&map->refs, dma_buf_io_map_refs_release, 0, GFP_KERNEL);
> > +	if (ret) {
> > +		kfree(fence);
> > +		return ret;
> > +	}
> > +
> > +	spin_lock_init(&fence->lock);
> > +	dma_fence_init(&fence->base, &dma_buf_io_fence_ops, &fence->lock,
> > +			ctx->fence_ctx, atomic_inc_return(&ctx->fence_seq));
> > +	map->fence = fence;
> > +	map->ctx = ctx;
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_NS_GPL(dma_buf_io_init_map, "DMA_BUF");
> > +
> > +struct dma_buf_io_map *dma_buf_io_create_map(struct dma_buf_io_ctx *ctx)
> > +{
> > +	struct dma_buf *dmabuf = ctx->dmabuf;
> > +	struct dma_buf_io_map *map;
> > +	long ret;
> > +
> > +retry:
> > +	/*
> > +	 * ->dmabuf_map() will be calling dma_buf_map_attachment(), for which
> > +	 * we'll need to wait for fences. Do a bit nicer and try to wait
> > +	 * without the resv lock first.
> > +	 */
> 
> Clear NAK to that. Always wait while holding the resv lock if you can!
> 
> It is absolutely not beneficial to do this outside of the lock and usually just hides problems instead and prevent fixing them.
> 
> > +	ret = dma_resv_wait_timeout(dmabuf->resv, DMA_RESV_USAGE_KERNEL,
> > +				    true, MAX_SCHEDULE_TIMEOUT);
> > +	if (!ret)
> > +		ret = -EAGAIN;
> > +	if (ret < 0)
> > +		return ERR_PTR(ret);
> > +
> > +	ret = dma_resv_lock_interruptible(dmabuf->resv, NULL);
> > +	if (ret)
> > +		return ERR_PTR(ret);
> > +
> > +	map = dma_buf_io_get_map(ctx);
> > +	if (map) {
> > +		ret = 0;
> > +		goto out;
> > +	}
> > +
> > +	if (dma_resv_wait_timeout(dmabuf->resv, DMA_RESV_USAGE_KERNEL,
> > +				  true, 0) < 0) {
> > +		dma_resv_unlock(dmabuf->resv);
> > +		goto retry;
> > +	}
> > +
> > +	map = ctx->dev_ops->map(ctx);
> > +	if (IS_ERR(map)) {
> > +		ret = PTR_ERR(map);
> > +		goto out;
> > +	}
> > +
> > +	percpu_ref_get(&map->refs);
> > +	rcu_assign_pointer(ctx->map, map);
> > +out:
> > +	dma_resv_unlock(dmabuf->resv);
> > +	if (ret < 0)
> > +		return ERR_PTR(ret);
> > +	return map;
> > +}
> > +
> > +static void dma_buf_io_drop_map(struct dma_buf_io_ctx *ctx)
> > +{
> > +	struct dma_buf *dmabuf = ctx->dmabuf;
> > +	struct dma_buf_io_map *map;
> > +	int ret;
> > +
> > +	dma_resv_assert_held(dmabuf->resv);
> > +
> > +	map = rcu_dereference_protected(ctx->map,
> > +					dma_resv_held(dmabuf->resv));
> > +	if (!map)
> > +		return;
> > +	rcu_assign_pointer(ctx->map, NULL);
> > +
> 
> 
> > +	ret = dma_resv_reserve_fences(dmabuf->resv, 1);
> > +	if (WARN_ON_ONCE(ret)) {
> > +		struct dma_fence *fence = &map->fence->base;
> > +
> > +		dma_fence_get(fence);
> > +		percpu_ref_kill(&map->refs);
> > +		dma_fence_wait(fence, false);
> > +		dma_fence_put(fence);
> > +		return;
> > +	}
> > +
> > +	dma_resv_add_fence(dmabuf->resv, &map->fence->base,
> > +			   DMA_RESV_USAGE_KERNEL);
> 
> That sequence is clearly incorrect!
> 
> The fence must be created after dma_resv_reserve_fences(), otherwise you definately have an illegal memory operation here.
> 
> Regards,
> Christian.
> 
> > +	/*
> > +	 * Delay destruction until all inflight requests using the map arefence->
> > +	 * gone. It'll also signal the fence then.
> > +	 */
> > +	percpu_ref_kill(&map->refs);
> > +}
> > +
> > +void dma_buf_io_invalidate_mappings(struct dma_buf_io_ctx *ctx)
> > +{
> > +	dma_buf_io_drop_map(ctx);
> > +}
> > +EXPORT_SYMBOL_NS_GPL(dma_buf_io_invalidate_mappings, "DMA_BUF");
> > +
> > +static void dma_buf_io_ctx_release_work(struct work_struct *work)
> > +{
> > +	struct dma_buf_io_ctx *ctx = container_of(work, struct dma_buf_io_ctx,
> > +						  release_work);
> > +	struct dma_buf *dmabuf = ctx->dmabuf;
> > +	long ret;
> > +
> > +	dma_resv_lock(dmabuf->resv, NULL);
> > +	/* Remove the last map, there should be no new ones going forward. */
> > +	dma_buf_io_drop_map(ctx);
> > +	dma_resv_unlock(dmabuf->resv);
> > +
> > +	/* Wait until all maps are destroyed. */
> > +	ret = dma_resv_wait_timeout(dmabuf->resv, DMA_RESV_USAGE_KERNEL,
> > +				    false, MAX_SCHEDULE_TIMEOUT);
> > +
> > +	if (WARN_ON_ONCE(ret <= 0))
> > +		return;
> > +	if (WARN_ON_ONCE(rcu_dereference_protected(ctx->map, true)))
> > +		return;
> > +
> > +	if (refcount_dec_and_test(&ctx->refs))
> > +		dma_buf_io_ctx_destroy_work(&ctx->release_work);
> > +}
> > +
> > +void dma_buf_io_ctx_release(struct dma_buf_io_ctx *ctx)
> > +{
> > +	/*
> > +	 * Destruction needs to wait for I/O and dma fences. Defer it to
> > +	 * simplify locking.
> > +	 */
> > +	INIT_WORK(&ctx->release_work, dma_buf_io_ctx_release_work);
> > +	queue_work(system_wq, &ctx->release_work);
> > +}
> > +
> > +int dma_buf_io_ctx_create(struct file *file,
> > +			   struct dma_buf_io_ctx *ctx,
> > +			   struct dma_buf *dmabuf,
> > +			   enum dma_data_direction dir)
> > +{
> > +	int ret;
> > +
> > +	if (!file->f_op->init_dma_buf_io_ctx)
> > +		return -EOPNOTSUPP;
> > +
> > +	memset(ctx, 0, sizeof(*ctx));
> > +	ctx->fence_ctx = dma_fence_context_alloc(1);
> > +	ctx->dir = dir;
> > +	ctx->dmabuf = dmabuf;
> > +	refcount_set(&ctx->refs, 1);
> > +	get_dma_buf(dmabuf);
> > +
> > +	ret = file->f_op->init_dma_buf_io_ctx(file, ctx);
> > +	if (ret) {
> > +		memset(ctx, 0, sizeof(*ctx));
> > +		dma_buf_put(dmabuf);
> > +		return ret;
> > +	}
> > +
> > +	if (WARN_ON_ONCE(!ctx->dev_ops ||
> > +			 !ctx->dev_ops->map ||
> > +			 !ctx->dev_ops->unmap ||
> > +			 !ctx->dev_ops->release))
> > +		return -EINVAL;
> > +
> > +	return ret;
> > +}
> > diff --git a/include/linux/dma-buf-io.h b/include/linux/dma-buf-io.h
> > new file mode 100644
> > index 000000000000..bcffc6202556
> > --- /dev/null
> > +++ b/include/linux/dma-buf-io.h
> > @@ -0,0 +1,91 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef __DMA_BUF_IO_H__
> > +#define __DMA_BUF_IO_H__
> > +
> > +#include <linux/dma-buf.h>
> > +
> > +struct dma_buf_io_fence;
> > +struct dma_buf_io_ctx;
> > +struct dma_buf_io_map;
> > +
> > +struct dma_buf_io_ops {
> > +	/*
> > +	 * Create a new map for the given ctx. Called with the reservation
> > +	 * lock held.
> > +	 */
> > +	struct dma_buf_io_map *(*map)(struct dma_buf_io_ctx *ctx);
> > +
> > +	/*
> > +	 * Clean up device specific parts of the @map. Called with the
> > +	 * reservation lock held.
> > +	 */
> > +	void (*unmap)(struct dma_buf_io_ctx *ctx, struct dma_buf_io_map *map);
> > +
> > +	/*
> > +	 * The user tries to destroy the ctx. Release all device specific
> > +	 * parts of the token.
> > +	 */
> > +	void (*release)(struct dma_buf_io_ctx *);
> > +};
> > +
> > +struct dma_buf_io_map {
> > +	/*
> > +	 * Counts attached requests and other users. Device specific unmapping
> > +	 * is deferred until all refs are dropped.
> > +	 */
> > +	struct percpu_ref		refs;
> > +
> > +	struct work_struct		release_work;
> > +	struct dma_buf_io_fence		*fence;
> > +	struct dma_buf_io_ctx		*ctx;
> > +};
> > +
> > +struct dma_buf_io_ctx {
> > +	struct dma_buf_io_map __rcu		*map;
> > +	struct dma_buf				*dmabuf;
> > +	enum dma_data_direction			dir;
> > +
> > +	atomic_t				fence_seq;
> > +	u64					fence_ctx;
> > +	struct work_struct			release_work;
> > +	refcount_t				refs;
> > +
> > +	void					*dev_priv;
> > +	const struct dma_buf_io_ops		*dev_ops;
> > +};
> > +
> > +int dma_buf_io_ctx_create(struct file *file,
> > +			   struct dma_buf_io_ctx *ctx,
> > +			   struct dma_buf *dmabuf,
> > +			   enum dma_data_direction dir);
> > +void dma_buf_io_ctx_release(struct dma_buf_io_ctx *ctx);
> > +
> > +struct dma_buf_io_map *dma_buf_io_create_map(struct dma_buf_io_ctx *ctx);
> > +
> > +static inline struct dma_buf_io_map *
> > +dma_buf_io_get_map(struct dma_buf_io_ctx *ctx)
> > +{
> > +	struct dma_buf_io_map *map;
> > +
> > +	guard(rcu)();
> > +
> > +	map = rcu_dereference(ctx->map);
> > +	if (unlikely(!map || !percpu_ref_tryget_live_rcu(&map->refs)))
> > +		return NULL;
> > +
> > +	return map;
> > +}
> > +
> > +static inline void dma_buf_io_map_drop(struct dma_buf_io_map *map)
> > +{
> > +	percpu_ref_put(&map->refs);
> > +}
> > +
> > +/*
> > + * Device API
> > + */
> > +
> > +void dma_buf_io_invalidate_mappings(struct dma_buf_io_ctx *ctx);
> > +int dma_buf_io_init_map(struct dma_buf_io_ctx *ctx, struct dma_buf_io_map *map);
> > +
> > +#endif
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index d10897b3a1e3..9fe349a279c7 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -1914,6 +1914,7 @@ struct dir_context {
> >  #define COPY_FILE_SPLICE		(1 << 0)
> >  
> >  struct io_uring_cmd;
> > +struct dma_buf_io_ctx;
> >  struct offset_ctx;
> >  
> >  typedef unsigned int __bitwise fop_flags_t;
> > @@ -1962,6 +1963,7 @@ struct file_operations {
> >  	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
> >  				unsigned int poll_flags);
> >  	int (*mmap_prepare)(struct vm_area_desc *);
> > +	int (*init_dma_buf_io_ctx)(struct file *, struct dma_buf_io_ctx *);
> >  } __randomize_layout;
> >  
> >  /* Supports async buffered reads */
> 
> _______________________________________________
> Linaro-mm-sig mailing list -- linaro-mm-sig@lists.linaro.org
> To unsubscribe send an email to linaro-mm-sig-leave@lists.linaro.org
