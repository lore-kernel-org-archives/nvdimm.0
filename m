Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2AD8C1A
	for <nvdimm@lists.linux.dev>; Wed,  7 Dec 2022 21:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670449732; x=1701985732;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3MfMlWEh4blhAhl2IHVwrWnXn350Cwp6Nq2gGUPb3VI=;
  b=lDREimz7sbgCYVtxW2WW0BvxoCdJCse0fxx8dHeuky436GbnMHYW32Vt
   gIspN3DJb044Yr7YXSwHu5cqr2erXv20795Kio9HGe/IF5aBRNeOtxUtK
   JpTeLT14OOfLjLiqi7Ywcc8OjI62dAs0ICqaISWimFJfPZnOk9raO8IQm
   yk4R2ieK2QIV0mncDb3z6aHngz7NNjzgSj4fDiKtfmeE9kCuqwx4AYoIr
   twxEx7Wam83IGB4ghW9swUigijwJGl3CDh/U002wvCwRmQ9cPyLyhpVyI
   Anl5d08GJroPsK8k6uLjs9CKSiUFnN7lo2TXiUSRUHo3vyZrG0ytqEheA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="296703651"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="296703651"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 13:48:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="789052764"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="789052764"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 07 Dec 2022 13:48:51 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 7 Dec 2022 13:48:50 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 7 Dec 2022 13:48:50 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 7 Dec 2022 13:48:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QFoyryxEvvzkokI+UbEkjXbExzvibEjj97g3Nqct7W8zfEUPwhAPG4y+FlClaBpf/k468N/9EA60aT2H28nObMs7/kGUIfdU+7iSWcVqpQ8pxnVb3V51qLjNBO5HE/1gXEcO7+2BVa9xYpcEmpHztoV22XvppogjkTyrQHNmiXXM1knISsmOj+s5LoJGXQz3ZSonhY5B3jjLUhSXzbN8jeehz9Dv3nzOr/uYEWchr5/5D6+J6u/7y0rsEBBexBMbPGh01I2dbl37LNOCM6Q5lKiZChHg+JpYPkyUixmh9Skb1ILKIZbuJ9hkZwKGOKt7VfvJwMJKTC22eTnNQrm/EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HhKNXLafVfQaBPUeBsNGB2LA89rh0qevgtV6Fnz8VpM=;
 b=UvtMcm6hf6W81Nc0l/KDb+zSkMWV4TJk0EqDYfOAVwlq+NWVrhBGycYGP3M3zN7SaOlRzxigBA+TFylfnwcSJoAEhyahn/PyPcMGTo1swJWu9B7hHwTVmgMGKSnAFjg0DqibMOW+0jDKfOWh8xjTskQZietOU1XvkD+9RC9VEt46Glb/IVX9b0zD5IHKtvfUF0UEro6p4h7v4AmfcBgjkAFi6JoBAgNcM6NDOSST9v/BqRgM/hQltA/o83NEtdqMCf+LdcA1h3fPMfA/1gjkeWnfVVRPViKD32zroSnf9D/ONQs2Yksdk9QXeWXmHskj2E55NzTQizrxNcA1JF49fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DS0PR11MB7264.namprd11.prod.outlook.com
 (2603:10b6:8:13b::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 21:48:42 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 21:48:42 +0000
Date: Wed, 7 Dec 2022 13:48:40 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>
CC: Dan Williams <dan.j.williams@intel.com>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<linux-cxl@vger.kernel.org>
Subject: RE: [PATCH ndctl 2/2] meson.build: add a check argument to
 run_command
Message-ID: <63910a38753b_3cbe029478@dwillia2-xfh.jf.intel.com.notmuch>
References: <20221206-vv-misc-v1-0-4c5bd58c90ca@intel.com>
 <20221206-vv-misc-v1-2-4c5bd58c90ca@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221206-vv-misc-v1-2-4c5bd58c90ca@intel.com>
X-ClientProxiedBy: BYAPR07CA0017.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::30) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|DS0PR11MB7264:EE_
X-MS-Office365-Filtering-Correlation-Id: b79a2685-7b81-4060-7dcc-08dad89cce94
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: id1nqmuKp0jFnepfC2kOgXuC1kkaU14s8/A2unPm8Y4sQMFoL1vvCXVPZtJB2j63/DPcqbYmoUH0ay7HZua+BDaVyrzQ/v7oTFmVuKaW06uq+VqfJgDH4xKirhY8/YNuICU0aCkp8rxWXRfgdqxs15BzFruiWjquPKGr+/Wc6CuwEfmYpP9K5KJ//ulZd7HlrSzrwXrhg+mJDFNXZUTVqMlE4JiBm8fq4L0rlKe1etN1DbvFoq0fwNXCrbkrYSIzv7IV1pO2hUdsQVTKMYbxfPj5vhfobGKm9jnJb/DZ1y2jx0nXgckFxlXQXniZqQ5hKaaouUZphH68F4SIcefZI9YA7RoQNwPnSKIxudSn9VDRXyQyKDdgT+HaYuvzH8LYV4dHDb7P4h8Z8U5+Xc47x7m3S0poNvRtAX9pjDope2S+6jcSz60EwkkzHEIZagmOeKWIgcJlIZfV/KMRwbugWl7CnHe/ENOb4b452wR+42Yb2O15yBi6fCtYl2wJaq7TQjLUFUkkMkx1DUhVIbdXvczrn2qyTJ+Kmz9R2iKr1u3gzGr9lT/5DLFhOJoOVyTcjDgynUaJ2CeHN0hUQ4ep1MhelSeXHDNrNON9u7E1fOroCmXvbjLCPDpC3hnxaNyKmS05OQMIeUbCHWHoEjJyXO4ZhOFKaRO6qbxF+PJiDrI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(136003)(376002)(396003)(39860400002)(451199015)(966005)(82960400001)(38100700002)(66946007)(83380400001)(4326008)(66556008)(66476007)(26005)(6506007)(6512007)(9686003)(186003)(5660300002)(2906002)(8936002)(4744005)(41300700001)(54906003)(316002)(6486002)(86362001)(478600001)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WHbcEGg/i/HTjMG1HLtLixrpKbGs7V7JNcwXpPoMjq/8k/9nUijC8gfgQ622?=
 =?us-ascii?Q?euEp2cnpVjGd68PBimwdwKJYU9fBYjRtALa0vImI6htOyWlXHsAFGLcIMBvD?=
 =?us-ascii?Q?xl+9trbt+nWHEGbhdxmYGISjE3bi7xLi3peSGgdl33pj6Rq4rihR/dBFZ5ey?=
 =?us-ascii?Q?pVxEME5S/eH5zcSdU93ZKhV9TNOtQEem9n9xrq6iBrBGsiZIcT8EDDeNWwiX?=
 =?us-ascii?Q?RSsl66qVBxAx6eaXQnnJSud4tR/vQent57eyp21kq5Cv11O7Rlr1Ug3/97ag?=
 =?us-ascii?Q?++D3bjdS1rJTAzWi04L5Dk9bESWssjODFbioKlVizm7f3YJuVXy29HYspM6+?=
 =?us-ascii?Q?wsYW9mPvAbGNHmcC8/93rzvUfPydHIeDmLKlwDzv75k9IHS+YCjKCThJxw9W?=
 =?us-ascii?Q?2UI8avuFX/Eo6IG5S1qJsfTMNaRvPw5SBXvh99EqoPsSTMKISMS7mU78PYAx?=
 =?us-ascii?Q?JLUEofW0sIhn7puiW2OnrFOPB/JG8Ypl1vcs4+x8JA9cWas8D9UobLgUbrIO?=
 =?us-ascii?Q?DMK7UCwlsmdkXF/7pK4/vMJ2Qg/Qyqgnpr6vAH17hptoOMUrCAfDEfR8003g?=
 =?us-ascii?Q?neU9ZrQ87B6VWQY0n/igZOnqfRMFdkJ/LkAutbniOlYEY1kgcWD5ZSk6smSQ?=
 =?us-ascii?Q?+Y8I7oBGZO2SlXpciNyP2NvarJ9njCl7bFLlpLLq+WO/PSoBPE29j5e1EXP4?=
 =?us-ascii?Q?ail/m2Qph2k8HRq3NaZbHRXnDXdNAmZQJutaFJToiNtIylJARHZDjv4PwAfQ?=
 =?us-ascii?Q?JHbvv0EbikpABST72mqNyTbO0d12ojE6eNrg5UcwBjKZR1gXDrn+Pvbg5GcK?=
 =?us-ascii?Q?LitwAQvUB0OZHMJj6CVCnfveuaNVxxPxKnt7VhOgex1EG5qWamwY76ze2TrF?=
 =?us-ascii?Q?QRt7DrcYChEDnRJrKi5F6akMQuWbMEDrv6Ml4BqO3iErlb6lPpkVjQa+WF6s?=
 =?us-ascii?Q?QLM6s5y+GU+oN0kOVwK9lqgwNSdpmRVW+LkhZlAVv3rogs5IejaijzKfg+mH?=
 =?us-ascii?Q?ogOqAZ1a5HCLc2sjDG+VaAN7fOQkqzHXNSuBer59pC4HnU+Kenm9xu9Z+aGE?=
 =?us-ascii?Q?YU/97JF7OEQmEF8Ajk0FZVQK/F9wjw3T43Xp8c57JcydsZ4dnAFJYqW9djbN?=
 =?us-ascii?Q?2DFN5P0I9SX6RI+ZS+dKGDmqAq7TXPaiGOrhv8wvqqAKj115rKinPUVEP9yd?=
 =?us-ascii?Q?Nq+F7iFCNrSyGmWfCFUwo1sHeCvj55fRaFPpuz7ZdeCutJ6jfT0gXyu1Ifqw?=
 =?us-ascii?Q?WCi+mx9aX+0nZ3GOdl1QkJPXzqdiGSQPiOrK6pTpXvsAJ7AGubs/60F/FFz3?=
 =?us-ascii?Q?MoZuK+YpwnUrA6Y4keHJiLpO4HeFou6VwfMVEtfFib3W5mrY7r5kf35z/W64?=
 =?us-ascii?Q?2lGKSZqGq1K95Mx7ue2WBOGRrn9YPH4EnFCMxxj0UTffJleQ9mRG+cMrpzo9?=
 =?us-ascii?Q?/y77TB5L5Z6CkfJG2j+I1+/S7lTZjN3xZRR2QzJv/j9g4f3lCa0BHF7BLirP?=
 =?us-ascii?Q?KNDkQg73y6CgXPzrmYgRvGK8QNbS8hBPe5XAvvgTmbleLFi7Lbs9r9XQgZJD?=
 =?us-ascii?Q?jVYzC0d6y4VBO5/ZPDGtKufqTVDLI7elc8tclzgICWSsT5z4/+EJaamLXdrc?=
 =?us-ascii?Q?3A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b79a2685-7b81-4060-7dcc-08dad89cce94
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 21:48:42.0557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8FncKodsYmnYb2TE/XDyXVoCN5BNKIKu88sEke64tx0mpd+JnPQHdhVaf+MX1R5F/+OLUcyVOEdspPmw6yu41oY1eFm1baq83RgCy1s5DbE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7264
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> Meson has started to warn about:
> 
>   WARNING: You should add the boolean check kwarg to the run_command call.
>          It currently defaults to false,
>          but it will default to true in future releases of meson.
>          See also: https://github.com/mesonbuild/meson/issues/9300
> 
> There is one instance of run_command() in the top-level meson.build
> which elides the explicit check argument. Since we don't care about the
> result of clean_config.sh (if any config.h are found they will be
> cleaned, and if none are found, we're fine), add a 'check: false'
> argument to this and squelch the warning.

Looks good to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
