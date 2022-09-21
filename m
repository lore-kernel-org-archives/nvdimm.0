Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8587C
	for <nvdimm@lists.linux.dev>; Wed, 21 Sep 2022 21:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663796796; x=1695332796;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UkjKU3jVRLd/tZJnumpL34VRkcM0G1YyRrePH+3xd5w=;
  b=CEHfOTlIX1PqdpCD1IZGKxOgrkrJeV0IC4epqsHIvnJUPlcqvk9GLy/P
   gxFtS5cZdfoRTU7mAVgTLP6/uZFoW4IWTkBtA/IquZtRXaKsFv2ohE+wY
   zAmol4Pz07AfbVyij5LfojcSVSPrGhQpOkWOpyV9IQW3KtqcLUaFRoagq
   vKTLHnUWZBu36uHP670uLXky3VJXsVAyhqk/w0w+B5Lk8Ol+ryRwANXTc
   med4mZTtZ8BogRgjanBBzsZNkK4GvKSCfseKhJ/8tkWeq8v7hYso0KpiG
   8RDB+gwUWEpCAyPIyLdIdnCsZ9YQuKNxORh1bRwmHfgjeE5zJi3j9c8+v
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="280503721"
X-IronPort-AV: E=Sophos;i="5.93,334,1654585200"; 
   d="scan'208";a="280503721"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 14:46:36 -0700
X-IronPort-AV: E=Sophos;i="5.93,334,1654585200"; 
   d="scan'208";a="614969473"
Received: from djiang5-mobl2.amr.corp.intel.com (HELO [10.212.36.150]) ([10.212.36.150])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 14:46:35 -0700
Message-ID: <762b2338-7e65-6462-cf88-9e9cc8dd8f83@intel.com>
Date: Wed, 21 Sep 2022 14:46:34 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.2
Subject: Re: [PATCH v2 2/9] cxl: add helper to parse through all current
 events
Content-Language: en-US
To: Alison Schofield <alison.schofield@intel.com>
Cc: linux-cxl@vger.kernel.org, vishal.l.verma@intel.com, ira.weiny@intel.com,
 bwidawsk@kernel.org, dan.j.williams@intel.com, nafonten@amd.com,
 nvdimm@lists.linux.dev
References: <166363103019.3861186.3067220004819656109.stgit@djiang5-desk3.ch.intel.com>
 <166363120598.3861186.12071132915910252601.stgit@djiang5-desk3.ch.intel.com>
 <Yyt9b99nWEaM5jEF@aschofie-mobl2>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <Yyt9b99nWEaM5jEF@aschofie-mobl2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 9/21/2022 2:09 PM, Alison Schofield wrote:
> On Mon, Sep 19, 2022 at 04:46:46PM -0700, Dave Jiang wrote:
>> Add common function to iterate through and extract the events in the
>> current trace buffer. The function uses tracefs_iterate_raw_events() from
>> libtracefs to go through all the events loaded into a tep_handle. A
>> callback is provided to the API call in order to parse the event. For cxl
>> monitor, an array of interested "systems" is provided in order to filter
>> for the interested events.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>   cxl/event_trace.c |   33 +++++++++++++++++++++++++++++++++
>>   cxl/event_trace.h |    7 +++++++
>>   cxl/meson.build   |    1 +
>>   meson.build       |    2 ++
>>   4 files changed, 43 insertions(+)
>>
>> diff --git a/cxl/event_trace.c b/cxl/event_trace.c
>> index ffa2a9b9b036..430146ce66f5 100644
>> --- a/cxl/event_trace.c
>> +++ b/cxl/event_trace.c
>> @@ -16,6 +16,7 @@
>>   #include <libcxl.h>
>>   #include <uuid/uuid.h>
>>   #include <traceevent/event-parse.h>
>> +#include <tracefs/tracefs.h>
>>   #include "json.h"
>>   #include "event_trace.h"
>>   
>> @@ -164,3 +165,35 @@ err_jevent:
>>   	free(jnode);
>>   	return rc;
>>   }
>> +
>> +static int cxl_event_parse_cb(struct tep_event *event, struct tep_record *record,
>> +		int cpu, void *ctx)
>> +{
>> +	struct event_ctx *event_ctx = (struct event_ctx *)ctx;
>> +	int rc;
>> +
>> +	/* Filter out all the events that the caller isn't interested in. */
>> +	if (strcmp(event->system, event_ctx->system) != 0)
>> +		return 0;
>> +
> While integrating w poison events, I find I'd like to filter on
> tep_event->name == "cxl_poison" here.
>
> Something like this:
>
> +	if (event_ctx->name) {
> +		if (strcmp(event->name, event_ctx->name) != 0)
> +			return 0;
> +	}
>   
> along w this:
>
> struct event_ctx {
>   	const char *system;
> +	const char *name;
>   	struct list_head jlist_head;
>   };

Ok I can add that.

>
> I guess an all|1 option won't suffice for users wanting a subset.
> See how that fits it w your needs for monitor command. I can always
> filter after the fact if this type of change is not generally useful.
>
> Thanks,
> Alison
>
>
>> +	rc = cxl_event_to_json_callback(event, record, &event_ctx->jlist_head);
>> +	if (rc < 0)
>> +		return rc;
>> +
>> +	return 0;
>> +}
>> +
>> +int cxl_parse_events(struct tracefs_instance *inst, struct event_ctx *ectx)
>> +{
>> +	struct tep_handle *tep;
>> +	int rc;
>> +
>> +	tep = tracefs_local_events(NULL);
>> +	if (!tep)
>> +		return -ENOMEM;
>> +
>> +	rc = tracefs_iterate_raw_events(tep, inst, NULL, 0,
>> +			cxl_event_parse_cb, ectx);
>> +	tep_free(tep);
>> +	return rc;
>> +}
>> diff --git a/cxl/event_trace.h b/cxl/event_trace.h
>> index 00975a0b5680..2fbefa1586d9 100644
>> --- a/cxl/event_trace.h
>> +++ b/cxl/event_trace.h
>> @@ -11,4 +11,11 @@ struct jlist_node {
>>   	struct list_node list;
>>   };
>>   
>> +struct event_ctx {
>> +	const char *system;
>> +	struct list_head jlist_head;
>> +};
>> +
>> +int cxl_parse_events(struct tracefs_instance *inst, struct event_ctx *ectx);
>> +
>>   #endif
>> diff --git a/cxl/meson.build b/cxl/meson.build
>> index 8c7733431613..c59876262e76 100644
>> --- a/cxl/meson.build
>> +++ b/cxl/meson.build
>> @@ -21,6 +21,7 @@ cxl_tool = executable('cxl',
>>       json,
>>       versiondep,
>>       traceevent,
>> +    tracefs,
>>     ],
>>     install : true,
>>     install_dir : rootbindir,
>> diff --git a/meson.build b/meson.build
>> index f611e0bdd7f3..c204c8ac52de 100644
>> --- a/meson.build
>> +++ b/meson.build
>> @@ -143,6 +143,8 @@ libudev = dependency('libudev')
>>   uuid = dependency('uuid')
>>   json = dependency('json-c')
>>   traceevent = dependency('libtraceevent')
>> +tracefs = dependency('libtracefs')
>> +
>>   if get_option('docs').enabled()
>>     if get_option('asciidoctor').enabled()
>>       asciidoc = find_program('asciidoctor', required : true)
>>
>>
