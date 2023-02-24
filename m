Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D420E6105
	for <nvdimm@lists.linux.dev>; Fri, 24 Feb 2023 15:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677252551; x=1708788551;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HMtFG+dMvxrlkWmNpOcyqXZBB2HP5Tk+pUH45Gz9GFg=;
  b=dvOeazvIkvdlIkX96q2sEu8SDpN+P2oAOS+IPfp//FBno3mjnc+lJeZD
   wN36jFIQjbbZOrrV4EQ+gaYYC80iDJbzJrXoWEm6SOOHm0kdMaPhbjl0Z
   /dzEfJomjpi7ekkdUvGqQPsAGO9Uu3C+66fTYiZfTVRLoQg+w5K1VaRV7
   RN1y/+SI2YlFkzCZabiK8TwRqRAdsJQ3VXcvR9igvnjTOuYF6Zm5VvucA
   6f2wNgvXTPrvwWzJ2pf6wgod5E3zST+npez4c2dH8Vbk5gpAqDQ5Rev8v
   YgTB8UyW9WiB5yf8fprtvyKNNCGoWLy4M8z+UUgCnHznihgTzttMSQ7jB
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="419732014"
X-IronPort-AV: E=Sophos;i="5.97,325,1669104000"; 
   d="scan'208";a="419732014"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 07:29:11 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="782398521"
X-IronPort-AV: E=Sophos;i="5.97,325,1669104000"; 
   d="scan'208";a="782398521"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.212.22.194]) ([10.212.22.194])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 07:29:10 -0800
Message-ID: <35d05194-13a9-943f-e421-58af57359bed@intel.com>
Date: Fri, 24 Feb 2023 08:29:10 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.6.0
Subject: Re: [PATCH ndctl 1/2] cxl/monitor: fix include paths for tracefs and
 traceevent
Content-Language: en-US
To: Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org
Cc: =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>,
 Dan Williams <dan.j.williams@intel.com>, nvdimm@lists.linux.dev
References: <20230223-meson-build-fixes-v1-0-5fae3b606395@intel.com>
 <20230223-meson-build-fixes-v1-1-5fae3b606395@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230223-meson-build-fixes-v1-1-5fae3b606395@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2/23/23 10:45 PM, Vishal Verma wrote:
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
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   cxl/event_trace.c | 4 ++--
>   cxl/monitor.c     | 4 ++--
>   2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/cxl/event_trace.c b/cxl/event_trace.c
> index 76dd4e7..926f446 100644
> --- a/cxl/event_trace.c
> +++ b/cxl/event_trace.c
> @@ -2,14 +2,14 @@
>   // Copyright (C) 2022, Intel Corp. All rights reserved.
>   #include <stdio.h>
>   #include <errno.h>
> +#include <event-parse.h>
>   #include <json-c/json.h>
>   #include <util/json.h>
>   #include <util/util.h>
>   #include <util/strbuf.h>
>   #include <ccan/list/list.h>
>   #include <uuid/uuid.h>
> -#include <traceevent/event-parse.h>
> -#include <tracefs/tracefs.h>
> +#include <tracefs.h>
>   #include "event_trace.h"
>   
>   #define _GNU_SOURCE
> diff --git a/cxl/monitor.c b/cxl/monitor.c
> index 749f472..e3469b9 100644
> --- a/cxl/monitor.c
> +++ b/cxl/monitor.c
> @@ -4,6 +4,7 @@
>   #include <stdio.h>
>   #include <unistd.h>
>   #include <errno.h>
> +#include <event-parse.h>
>   #include <json-c/json.h>
>   #include <libgen.h>
>   #include <time.h>
> @@ -16,8 +17,7 @@
>   #include <util/strbuf.h>
>   #include <sys/epoll.h>
>   #include <sys/stat.h>
> -#include <traceevent/event-parse.h>
> -#include <tracefs/tracefs.h>
> +#include <tracefs.h>
>   #include <cxl/libcxl.h>
>   
>   /* reuse the core log helpers for the monitor logger */
> 
