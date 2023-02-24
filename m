Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598817C
	for <nvdimm@lists.linux.dev>; Fri, 24 Feb 2023 07:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677225253; x=1708761253;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=tsedEVRHkoieDZZd8XED0H9yaUT8m8ZOLLh96LQwGVY=;
  b=oBMbraZPfzAat9UXBkqVc0ShkzOH3yqbvKedKQ+1FDmJsSGqIyfVodPz
   hIiL1e4fXE6DQ823iXH/ZsKwpVaQjVDT82cAH/i62XxLBDSl+5DKUYLru
   al8QPWaZ4clM3jEfI0qaW6qrvCZq1GOQAASET/M90tRDzz278Czb5BC+W
   X3dgW2Fe1BzDepTuPwMz3CZdaxy3VKjzllvigktnu3Kq95ABA+32Jlgdv
   JwvApfDYbHB9999f3TqmkvbQrUwVbDeuoDRx75E9ha5GqpWSPF8WlUGdt
   MvgsyDleMCYfxLVxqtBeKDWxY1v3OQsUP2zbdc6tfjHJTwZUqn/vbiYvt
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="317176995"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="317176995"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 23:54:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="705178397"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="705178397"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 23 Feb 2023 23:54:12 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 23 Feb 2023 23:54:11 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 23 Feb 2023 23:54:11 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 23 Feb 2023 23:54:11 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 23 Feb 2023 23:54:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFxbLMnrRIx8Z/dmP0REGaTt8Dqfp6Ebi005HTO6nbquVoSv0Q08gYAfhp+c20UX7oi2IIqHJCnweYC6cIbtZuZpfzEhp3gGnoHzn7wlz5K8shlE7XbOAmk5DN4RmHkNV6o2u5jGS7Z9SzQf0XlcOb2+B6LqGqT6KrJyLZzKMcUZ8hKlIbSLhHN7Y+CSmTTCh+CRJVcQ6PbVBzWRnW/DnPfDCWRLLlWRHNS1R3CPqPwhXaBfcwEwRQ1lxlHXCY+kji6sb7exbO76FszIr9zdJ/O4egDaCp4cZsY2er/q6nBkiIMQEiGRrgC08GuxVV1wMuD/326qZL122m9E6RX2cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=78eSHU1gxGEzg+X9nudUQaDUbFK8T76ICX6OmwRdNJ8=;
 b=h4HDJsheAjMXFEy3QNCNqKub52XC25KqU72nFV5j3mY8jf05/gg8eLk7z+WeKXkiRU43O0VU7IHZL1ZlAp4DipLuMgknFT+ydG+ZCDkeX0HBxJuJXM99jUWCeOEqPXY+u8Lhlk0NYTfgvsEDuOe/MuxyOwVzNXVs25GLAK0s9abIyUIPAIz0pMkOt0eIuuukvSa8SMWAq14pbHX1XzddDTY1Nro/Fr/LZsG5L5xOUEljDa2g+MPjx1E1XgwKNx1ZYl5TfnyP7eQD++/uxQPQsEg9Jz1vXSrBfOlOn+6Whoydy+/s2EhhiZLxDGZTvqvMliX780IVXH7dgCmf3e00WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by MW4PR11MB5936.namprd11.prod.outlook.com (2603:10b6:303:16b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Fri, 24 Feb
 2023 07:54:09 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::84dd:d3f2:6d99:d7ff]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::84dd:d3f2:6d99:d7ff%8]) with mapi id 15.20.6134.024; Fri, 24 Feb 2023
 07:54:09 +0000
Date: Thu, 23 Feb 2023 23:54:05 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>, Dave Jiang
	<dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 1/2] cxl/monitor: fix include paths for tracefs and
 traceevent
Message-ID: <63f86d1db5af0_20c82e294f7@iweiny-mobl.notmuch>
References: <20230223-meson-build-fixes-v1-0-5fae3b606395@intel.com>
 <20230223-meson-build-fixes-v1-1-5fae3b606395@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230223-meson-build-fixes-v1-1-5fae3b606395@intel.com>
X-ClientProxiedBy: SJ0PR03CA0273.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::8) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|MW4PR11MB5936:EE_
X-MS-Office365-Filtering-Correlation-Id: f84a201f-d675-463b-9074-08db163c4f0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OqdY8kR1ej96bNkJOwB746Da3Y6MND6AeIVHuQb0vhMDkQM5qyCUFZfIegy2f4J22nWnU22eV+l9g5u1StHRkOsZZgzZ4JlXcCJsCNyZ6ROjRWyoifUJkY+/DSrnd6RL1XFy1pyaNoE8TRtaxluDatoufhUzocJjgkyOPALkY/OMcq6LGLSTX8oj1BcMLA1O0EEM97yQrbnGXHvS5E0g8cw36HxEZ2s6GqF2MLJ3O+adjHBtS36e6SPhq0Ty13d3FKKJJNuXHjnoFyqCSOsDAskWhUK6lgQi/pnS1eWW2ltPN+1+3uccj8TCe9bTVbU/ae76AUjk++A8e8/dtQ1ZOIyL/7NmNeMjigszwrPws0sYKu9DEa+kkb2QlgfHWdeY+W3gaEmji4HdYH0G2JBzQ/SkpOuvnxgME/ZZc3kCeuLQ+wDE20bhOMy+B2mQKwJ8uFNpmbKIc72cRrMRb7rs+mDKbJOiQ56BAV7XouitxuKkQb25lZtRqbltoo4dXip9Qic5c3jCRiRGeKOsrkFBIuBJBM/Bv4NnFVu53nDuYasKYEBk2ObP1AKodOAWvuLiTkuzL5UsjWIypDxwu71kbgp55F6TzK9yOJUrkW+bFhF7nShA7FoTy75lokSEKqvF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(39860400002)(136003)(366004)(346002)(451199018)(54906003)(478600001)(8676002)(41300700001)(66556008)(66946007)(66476007)(4326008)(5660300002)(8936002)(86362001)(6512007)(6486002)(26005)(966005)(186003)(82960400001)(6506007)(9686003)(44832011)(2906002)(316002)(6666004)(83380400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Za2PaT5ihkDVsIXd1IMTe9SxyZEBSREUhRGrCoy1cYfh+FRjxL+6tLaZLc?=
 =?iso-8859-1?Q?T4ByTH/5O1GkUFrNwaDji6UbUPhXoVZcjKthyJBlNrxnwiEf2JV7dC5gKe?=
 =?iso-8859-1?Q?ebfkj8WTXkt2MjmxLEim3vbUuJC3eFOq8dfVlpUCsfhLu6ma0uTvSKjfNV?=
 =?iso-8859-1?Q?7PQcBPkWWjItLJkJiRbCYYl7q5etwJ2x+t+QyQNtZg3eSsPdyhd7fZqrim?=
 =?iso-8859-1?Q?EPqH70xeXHmmIEPKZCLt558c0ktFRV88gVG0RKwfzV4+lITRz5jWoBaKPR?=
 =?iso-8859-1?Q?i3EKPCXBSdpWOQmIatlobstIE8W9cknPbNNtviXz8G5lLBfnDumrlSVuFr?=
 =?iso-8859-1?Q?jkv2bhTJAmMrnn4tv1+zltZoj6IL4n3C+9GJ+vQqYFNUSOBnWiCX9pRXe0?=
 =?iso-8859-1?Q?Do2aq5gqUpLjaLAJgOAu4YCO/dTL4DBiopAqL4uEpmmXqQkm6oM50r0lhX?=
 =?iso-8859-1?Q?lVw43dfi0hQgM1iH0AI2DMkeyJbeDUpifXerGgi1HUtEmd6+YaJrey7CGd?=
 =?iso-8859-1?Q?4kGr8TohxZddOJZ1kzHLU0OTuew2wkEFC/NY+vu9/uYWYU7avREpmRyAfb?=
 =?iso-8859-1?Q?u1hL3UcZdK0FEJgEStVNgZiEZpnLNJ4+myikVYxqO9m0eEQ3YhAFwQZ3SP?=
 =?iso-8859-1?Q?Wlk51HH6rfZtaKpZY7kTqVnht+OqObFOGE+1XizCVeQyKzaJBy+UDaxFCg?=
 =?iso-8859-1?Q?Wbk4MtigvVQjB4LnkkxxMUg0Q3kPAltala/byDDaKTylxH0JcBMz7AfH3G?=
 =?iso-8859-1?Q?j0J384e3oa9NQDUDLjdEEa8BMXrllYlxjvxAgJbOKi6IMagfWELvo9UxVg?=
 =?iso-8859-1?Q?cZJex04tHmuDCjYSCNPjldwuS5x4xPjmlqND3XRGRcBLnbDRaKIOYqq7yW?=
 =?iso-8859-1?Q?D+LAjIJwTG6NwIPAXuoTAtRQza5bmKrMLTmWhS7KTGlqHkcN4hFldrElJa?=
 =?iso-8859-1?Q?fTvLJ8t7Yn/PfLolL2YYg2DLfKY8L/wr4/fdh1HFntWYS9CzOTyKw0JQz4?=
 =?iso-8859-1?Q?KOlq5GY4fbUDxXBmx6A+3f/iCUl/KpT1YOqiW+votTM1lohVMk0gmnVgXf?=
 =?iso-8859-1?Q?vpU/3cDSYejWv6FeseTJReowrOipTUMc6yYhjKLg4GxB5KChdo9UNu/3sQ?=
 =?iso-8859-1?Q?aKFdA6x/1D+TpknuEMNSH8BVpzUgQDRRMNCWyYmfuBZZtJBVltI0JtVFz4?=
 =?iso-8859-1?Q?Bp/mpgHlu/jwMX2nsq98DGrLBFXaEfMoBGbDJBki+sryP/nXzIvgqMLh4a?=
 =?iso-8859-1?Q?kQCvC3+y4er2pD3CZwnPKixfCERYXbPmOvOCNTFcNhjZ4US4IxHlF8PldM?=
 =?iso-8859-1?Q?bJPyxDpPm5DvUbnybIHJvFnyDNBZd/QZALswVf8btx5sfLurKDXbW0w1VM?=
 =?iso-8859-1?Q?KP027X7au0TcdXuNhx3sS+Mc+VO3Pq5tR6rVLGTXWhkw5Lths4GtyVe6E+?=
 =?iso-8859-1?Q?Ske4xRx2h6vjzIJN57BU4iR+CQZ/dBwCuPS5NfeOnU9EqDkp1Rn8VGc0eT?=
 =?iso-8859-1?Q?ASi1J1BL4Nym7njQZegQdTKzFm3a/oPugsugV7gRuIPa46ItaKYtLTepEQ?=
 =?iso-8859-1?Q?x6ksQB7X+W82dNgi8EfXWzPO4N/06afBr8eGL4C0Tv+FHwB20bd3/G4miO?=
 =?iso-8859-1?Q?mYBQmUwcwP9B82rEak3DXkPlUt3Xfz76Gn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f84a201f-d675-463b-9074-08db163c4f0b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 07:54:08.5251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8S+j5j+EkHKa4L/PmT+pZFQ9ZdQHAFtf8i3rKqUAeQi5VV7pYb3QyRGsyUlwh3XOoDsMIqIqx3jNO4qL2X9UmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5936
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> Distros vary on whether the above headers are placed in
> {prefix}/libtracefs/ or {prefix}/tracefs/, and likewise for traceevent.
> 
> Since both of these libraries do ship with pkgconfig info to determine
> the exact include path, the respective #include statements can drop the
> {lib}trace{fs,event}/ prefix.
> 
> Since the libraries are declared using meson's dependency() function, it
> already does the requisite pkgconfig parsing. Drop the above
> prefixes to allow the includes work on all distros.
> 
> Link: https://github.com/pmem/ndctl/issues/234
> Fixes: 8dedc6cf5e85 ("cxl: add a helper to parse trace events into a json object")
> Fixes: 7b237bc7a8ae ("cxl: add a helper to go through all current events and parse them")
> Reported-by: Michal Suchánek <msuchanek@suse.de>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  cxl/event_trace.c | 4 ++--
>  cxl/monitor.c     | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/cxl/event_trace.c b/cxl/event_trace.c
> index 76dd4e7..926f446 100644
> --- a/cxl/event_trace.c
> +++ b/cxl/event_trace.c
> @@ -2,14 +2,14 @@
>  // Copyright (C) 2022, Intel Corp. All rights reserved.
>  #include <stdio.h>
>  #include <errno.h>
> +#include <event-parse.h>
>  #include <json-c/json.h>
>  #include <util/json.h>
>  #include <util/util.h>
>  #include <util/strbuf.h>
>  #include <ccan/list/list.h>
>  #include <uuid/uuid.h>
> -#include <traceevent/event-parse.h>
> -#include <tracefs/tracefs.h>
> +#include <tracefs.h>
>  #include "event_trace.h"
>  
>  #define _GNU_SOURCE
> diff --git a/cxl/monitor.c b/cxl/monitor.c
> index 749f472..e3469b9 100644
> --- a/cxl/monitor.c
> +++ b/cxl/monitor.c
> @@ -4,6 +4,7 @@
>  #include <stdio.h>
>  #include <unistd.h>
>  #include <errno.h>
> +#include <event-parse.h>
>  #include <json-c/json.h>
>  #include <libgen.h>
>  #include <time.h>
> @@ -16,8 +17,7 @@
>  #include <util/strbuf.h>
>  #include <sys/epoll.h>
>  #include <sys/stat.h>
> -#include <traceevent/event-parse.h>
> -#include <tracefs/tracefs.h>
> +#include <tracefs.h>
>  #include <cxl/libcxl.h>
>  
>  /* reuse the core log helpers for the monitor logger */
> 
> -- 
> 2.39.1
> 


