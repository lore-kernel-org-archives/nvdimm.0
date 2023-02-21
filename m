Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8572F79C1
	for <nvdimm@lists.linux.dev>; Tue, 21 Feb 2023 18:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677002945; x=1708538945;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=uj0QP7kybFu/5Ojl75SzZiX4bUwiDbE+f6jsyMNcMLA=;
  b=feuZjCpnVUtGC0MDdqYYcdEfq8FURE7Ye1a6ZgxiL8QMdfHqvMABShfW
   Mle8EIQvPBTJ+rL3frubdU5pARn/xOjwQQtCOghxBTPQ2/Mt2oTkQ9Anr
   55ahplCmHpLn/CjSGrvnzHwxIV9piV0jgh9DANpbdMVa3Kd0n++5ca+yf
   y/X3qQqdLAV1J8iPViJx4ORHZT6o8UsxE0CFDpIVRC7j37gVchAZ/3XDo
   KkNvD1dTdLdRqChsM2sqUsC4VMX93jNFEQ4VWEMIkIH66Z+K0hsMgs5pq
   eeBeEt+s5Yq+aW+bvwnEym5i3eHNXnAIGlJwdn9W5uEMpNwEy1oZQhzW5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="331378849"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="331378849"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 10:09:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="735570644"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="735570644"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 21 Feb 2023 10:09:04 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 10:09:04 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 10:09:03 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 21 Feb 2023 10:09:03 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 21 Feb 2023 10:09:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVIryrdcduLSVQMWn/awd3uv2htqL988qq+GEW2eJkMuTOkVD1isl9glfpYvB2kmUUDYv7vuG2iv1QiqMzzVusWIPTvf8uswAS2wOkXBJF1Ik75H+3VtR1Z7bOEWBekf53Q6QnWdutH1ZVRlz/783OpsboPyIilESrDjmSlL2Yl8Q4vy1y9pdtbkpczoo4BaimDA5GVZE+kLHthewmQgKelVOvCUkagjr//eogEJaeT8BDmKxNix08sW8OV5Ld5TBqW/itEQagEozDHka3WUS8yN34AahwMQkLsxu+7qfiMjM/1NxceEvDr3nCkzzR6aBqii4dnmtG79AW8RJ84nBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NoFO66QC8x0NZT2egeoMNGFBKxosE8HBszhTgC2/PsE=;
 b=IULyUsW6MZSJjShwCeu7ZXnHlT4FLIeyYFRpipTZ5yfDVRSsNmDrKcnIggwXpGZ7YPq2Mq8/z/uKmmawP5yDxqEsfvXkapknM6Pq1payrqSLekKLuPyc66Yb7spwZq6uC23vVPitCheLkreL4yXYECMFgOfZHG51TxDHysgMYNDnfVB9/AFtXQ21IryUewiCuDHLCM4JV3c8++zI25zd21C72lAQwshwxjP0XxqxzUVNv/4m+MCGVtiUmFMBjgevyfhpEH2i6INQGuOm9hBY5a2DNLTWwxh6eYJlf7MSChKrDIkjb63YZxX3LGg8cX6pXLBGk9HBu+mbVyv3H6DyjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA1PR11MB6321.namprd11.prod.outlook.com (2603:10b6:208:38b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Tue, 21 Feb
 2023 18:09:00 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc%6]) with mapi id 15.20.6111.021; Tue, 21 Feb 2023
 18:09:00 +0000
Date: Tue, 21 Feb 2023 10:08:58 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>, Dave Jiang
	<dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH ndctl 3/3] test/cxl-security.sh: avoid intermittent
 failures due to sasync probe
Message-ID: <63f508bab5727_a3c6294a3@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <20230217-coverity-fixes-v1-0-043fac896a40@intel.com>
 <20230217-coverity-fixes-v1-3-043fac896a40@intel.com>
 <Y/T96khZVa7Oo6uU@aschofie-mobl2>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y/T96khZVa7Oo6uU@aschofie-mobl2>
X-ClientProxiedBy: BYAPR11CA0037.namprd11.prod.outlook.com
 (2603:10b6:a03:80::14) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA1PR11MB6321:EE_
X-MS-Office365-Filtering-Correlation-Id: 901cad59-825d-4f84-c864-08db1436b53d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b5KhfVBK1yawZwOct45RF91VpWh0Sy1SgNXQqyL58vMt2dSEG2pLODGzUOocbA7h7/V3J/yxnaNTEH6dINtTIpvKPYWl1T7gmLN65lYX0bc346JeiLBmSSFr65/bH7NuouxBJVEpBtLJNfry9tXwcbU5eIg78429Y10iurAhRBQDOdnqellXf+Tf2aux5XAbPbNyT3pwK97tNpuu/3O2j05uSXX+9Ep1sNzkhvSDiXpzMdmmziOEhdLbGg8xBrtbbO3FRwFJJncmBtQrHtUBISLwNswyPqsiwYiTHGjUhRXRyHtvCIzUdbMeHHp2/9kK277RGNF+uUEqBeOtTnGcplip8GXooWU3qwd0mImnDqNnJB8lJTiukSSh3GhOBkWxUWy8td4acE/nHRDOaJUPROKPdJnZBasvKMcPfv0uk38u41UIf51v9Z8RReTyzYQ4XWbJCplc5kNWRIyTE+G1lGwO6lfLeaGc44eHd3mXhRMFu7ZQbBy4enxhqwtCRZ9ClNSiZ7E1jWFgBJdY/stnJLri17tOXzE+NxqurlXQhAGRwdE6e3Qw6Edj8S4lmJs/JtliRK43cNS/MdwnuN//Qm26jQzI5FDD7FpbZYzjhrO/q+bakmm1U8wga3Nb7UBlEUGTH4tM4wcpiujNUVbwiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(136003)(366004)(346002)(376002)(451199018)(316002)(110136005)(6636002)(54906003)(38100700002)(82960400001)(8676002)(66946007)(66476007)(66556008)(6506007)(41300700001)(186003)(9686003)(6512007)(26005)(6486002)(107886003)(4326008)(5660300002)(478600001)(8936002)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bpbUXlmyAHfPG7S1hQ6kQPV9XSpjlpBdDd00J5N5yCxlqSm5SmJaNwLTEvO9?=
 =?us-ascii?Q?r8Swu/sOK1TPMoeBo9TKrZXOnBSF/x+HDS+vvEzdRpRLbHfjZIMNayNTHFy6?=
 =?us-ascii?Q?iyu2Cs12b8OUURIt5nRFu3lz6DODdl89BVMuzTU0DaVlXIgjW52Pw1Yy+tLO?=
 =?us-ascii?Q?SFRBesxzseL05X7RPv6ERJGpifp6BmrJZRr4jLWULiyZQjmkptDnb3umxMEy?=
 =?us-ascii?Q?wRTKvq0oMWnqYSEUEIJkFmnQTsxW+2zqIgsylwtRwTRvZrxWdeyp2im2O9Cm?=
 =?us-ascii?Q?FYyDI/0A03/c3WN7UVcO/sAkVTMioTgKdL8qHuuAfw98o5xy2xC0vcNnKv3t?=
 =?us-ascii?Q?GHPMdD0JPAcSKsiMas/E9dXQpMfQERgbv/aiY/9c/Ywix3Peg5heEQohhQxc?=
 =?us-ascii?Q?zV+MME2FMgxryvumaW4ckSJ3ZoMVsWqMGoy47l5Ba5I8aaw3rnoPsEpnOh2x?=
 =?us-ascii?Q?2ErZUpcOx32PFSmFKsHgdpDIoxM8HPDJOeP6NOCZlrlJ/NCu89gd4bXiK1Bl?=
 =?us-ascii?Q?BI9SChKoeewuARNHap7T2xRdyR+bX+vMSDyNOHGqp4V32zc2YV4lZc51mfHd?=
 =?us-ascii?Q?2fpnLVomc9Gu3efIJA3NiMwLgsAmFUR7bfJh0W57yjN1iOftUsbob2lmCjUs?=
 =?us-ascii?Q?y6CQh/k3HXrMZxMnhNs25pxpeE1nxX2xLxUjXxLivXcE7fLOlvpli00r2ANR?=
 =?us-ascii?Q?UTeYvufuLKw851exu1jh73WWx+kTu6s28jBcBwwgQpRYuCTXGZK0yh+iqWOj?=
 =?us-ascii?Q?3+GGGuaNJimZntuLH2idsYiGhTwlYs4S9ADPdn/xOJkQHXQ07eyz8Hp7g7yX?=
 =?us-ascii?Q?Mqix6TW7bhUSYGuTyHzPE5hHfsCeitsyVE1jbCotfhZlx6zq9BluOPn3gkfz?=
 =?us-ascii?Q?LEwLdWBpbUaMvDPVXwHmiywyuPUYCHQXlKmm/JVEGxQh3jqeiATGF2y+Ielm?=
 =?us-ascii?Q?+GJEDKiBZzVPl+Qr32Q5it4QJVYUbhuAbYKcg/wLDWJFL5AhiAvTbnUoUbIv?=
 =?us-ascii?Q?4CJnzmw+Ckh9kcCgt7xvGfbdLhthhWZip63QENsdL1LCkbVAeaR6e8Fpd3sw?=
 =?us-ascii?Q?mOYuKvFlclDddmzMP/ykRlsr8/DdWc+05Jq8TQTwgx1xQRBKSXGx7i9ze8hI?=
 =?us-ascii?Q?vGW+YE+hz0/lWUd+OLQDm6aj0aBvaEGv+JLKs55Drg+wv+JotLGmCscIYhjS?=
 =?us-ascii?Q?h4ZdUpOQzoPr5spH6nVRueZdG9cUo1sqQOBEn3WPNjbIsBr5zbt+6Kao/k8y?=
 =?us-ascii?Q?7nHqEeyDEbv/mS8mrGdUym3rzloftXu33xN3tyaGAt3ITmeQxN0JiayaMPdg?=
 =?us-ascii?Q?RcGNTXEcpMwcFpNOSRoNaItcbUn77btzCoJylfy/XWOJwfYM2fmw3sR343jd?=
 =?us-ascii?Q?sQasFrD57mGx2KOV8xR/UJrG6C1aznH1JrPoWwQoz0n16n7fdAd7osCjrX37?=
 =?us-ascii?Q?UwDOrDT8uOB6j7bJkxxIMxO9uQC0mKHnQz00tH8WuyzKWCCWngAQ3zuEuSr4?=
 =?us-ascii?Q?upMfhw2jPSGEcYCLYSA2AUYcKbA9VBfImaiLaSCVbDmrYYs8RhV3UfkZgGcx?=
 =?us-ascii?Q?zQAccpENzgPittdToTppTVb2ekcxJ++KCmXC6SIMkEzJNtjIs6B1R2dhUddH?=
 =?us-ascii?Q?AA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 901cad59-825d-4f84-c864-08db1436b53d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 18:09:00.6289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XG3+KnERX9gAzcmCMzmrRUkoBh1pifq73Dke0w2TBQNnbbHGdDPk4GliK+hzLu9cSnMxcnmXypcxQ/3m56up/VgnXEWAto+DuGoSq/xZ1u8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6321
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Fri, Feb 17, 2023 at 05:40:24PM -0700, Vishal Verma wrote:
> > This test failed intermittently because the ndctl-list operation right
> > after a 'modprobe cxl_test' could race the actual nmem devices getting
> > loaded.
> > 
> > Since CXL device probes are asynchronous, and cxl_acpi might've kicked
> > off a cxl_bus_rescan(), a cxl_flush() (via cxl_wait_probe()) can ensure
> > everything is loaded.
> > 
> > Add a plain cxl-list right after the modprobe to allow for a flush/wait
> > cycle.
> 
> Is this the preferred method to 'settle', instead of udevadm settle?

In general, 'udevadm settle' is only the first phase of flushing
subsystem setup work in that it can only flush the udev event queue.
I.e. a device arriving kicks off a KOBJ_ADD event, and once that event
is processed without kicking off more KOBJ_* events the queue is
settled. For CXL this means that the cxl_acpi and cxl_pci modules are
loaded, but the asynchronous work they kick off to probe devices and
rescan the bus is invisible to 'udevadm settle'.

Internally 'cxl list' is performing a 'udevadm settle' and then flushing
the follow on async work.
