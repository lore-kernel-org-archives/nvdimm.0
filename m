Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF585CAD
	for <nvdimm@lists.linux.dev>; Wed, 16 Nov 2022 12:57:50 +0000 (UTC)
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NC31P16Nxz67Nc8;
	Wed, 16 Nov 2022 20:55:21 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.31; Wed, 16 Nov 2022 13:57:45 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 16 Nov
 2022 12:57:45 +0000
Date: Wed, 16 Nov 2022 12:57:43 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: <alison.schofield@intel.com>
CC: Dan Williams <dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Ben Widawsky <bwidawsk@kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 2/5] cxl: add an optional pid check to event
 parsing
Message-ID: <20221116125743.0000131e@Huawei.com>
In-Reply-To: <ad642bb987990c17c52c9d84f76141e31a43f549.1668133294.git.alison.schofield@intel.com>
References: <cover.1668133294.git.alison.schofield@intel.com>
	<ad642bb987990c17c52c9d84f76141e31a43f549.1668133294.git.alison.schofield@intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Thu, 10 Nov 2022 19:20:05 -0800
alison.schofield@intel.com wrote:

> From: Alison Schofield <alison.schofield@intel.com>
> 
> When parsing CXL events, callers may only be interested in events
> that originate from the current process. Introduce an optional
> argument to the event trace context: event_pid. When event_pid is
> present, only include events with a matching pid in the returned
> JSON list. It is not a failure to see other, non matching results.
> Simply skip those.
> 
> The initial use case for this is the listing of media errors,
> where only the media errors requested by this process are wanted.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Makes sense to me

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  cxl/event_trace.c | 5 +++++
>  cxl/event_trace.h | 1 +
>  2 files changed, 6 insertions(+)
> 
> diff --git a/cxl/event_trace.c b/cxl/event_trace.c
> index a973a1f62d35..70ab892bbfcb 100644
> --- a/cxl/event_trace.c
> +++ b/cxl/event_trace.c
> @@ -207,6 +207,11 @@ static int cxl_event_parse(struct tep_event *event, struct tep_record *record,
>  			return 0;
>  	}
>  
> +	if (event_ctx->event_pid) {
> +		if (event_ctx->event_pid != tep_data_pid(event->tep, record))
> +			return 0;
> +	}
> +
>  	if (event_ctx->parse_event)
>  		return event_ctx->parse_event(event, record,
>  					      &event_ctx->jlist_head);
> diff --git a/cxl/event_trace.h b/cxl/event_trace.h
> index ec6267202c8b..7f7773b2201f 100644
> --- a/cxl/event_trace.h
> +++ b/cxl/event_trace.h
> @@ -15,6 +15,7 @@ struct event_ctx {
>  	const char *system;
>  	struct list_head jlist_head;
>  	const char *event_name; /* optional */
> +	int event_pid; /* optional */
>  	int (*parse_event)(struct tep_event *event, struct tep_record *record,
>  			   struct list_head *jlist_head); /* optional */
>  };

