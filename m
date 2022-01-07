Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32CC168
	for <nvdimm@lists.linux.dev>; Fri,  7 Jan 2022 22:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641595206; x=1673131206;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rMKk14UvD9zwnkh1jlI91c3SZkZ4wKA/Xjs/3pmTV3Q=;
  b=PMV9S11VbibJmJsVh/uGbGzcElW60pAz8aFDV25sj2msqrklq31huoAX
   89KbsQp4FbDW0vifWqdjlUBQSid/NPX5tEGpRANwNL2gdGkosNJ+I1a9n
   g882A9SEvwlrh9XCe/PPkGFVtfiq+WUd0QTNdyji7jVyR1BqtFL5xbZR6
   G8k4jo97INIIK5rscBVgOyAzhiyr4q9E+xtCHvCeMGrakmQzCN4bu60VD
   c8/txXZI3RuYIYzNgoq1tlraIT0kDUSJw8gFd4HMksEmoU9DxsJ/KVV+J
   pVvHn0D2Gc7L4XaPLVsMKWw12Lt+mnif8SZKHgWvaqefYhIVKdHyK7Un8
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10220"; a="222943127"
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="222943127"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 14:40:06 -0800
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="668906135"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 14:40:06 -0800
Date: Fri, 7 Jan 2022 14:45:15 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 7/7] cxl: add command set-partition-info
Message-ID: <20220107224515.GA804232@alison-desk>
References: <cover.1641233076.git.alison.schofield@intel.com>
 <fd590fbbc2f1abaeca1fd368d26c4e90c3a89d69.1641233076.git.alison.schofield@intel.com>
 <CAPcyv4gYjDo7vuFYqJgUL6mvOKosrzLRMxTA8tB0v86s08f_VA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gYjDo7vuFYqJgUL6mvOKosrzLRMxTA8tB0v86s08f_VA@mail.gmail.com>

On Thu, Jan 06, 2022 at 02:19:08PM -0800, Dan Williams wrote:
> On Mon, Jan 3, 2022 at 12:11 PM <alison.schofield@intel.com> wrote:
> >

snip

> 
> One of the conventions from ndctl is that any command that modifies an
> object should also emit the updated state of that object in JSON. For
> example, "ndctl reconfigure-namespace" arranges for:
> 
>                 unsigned long flags = UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
>                 struct json_object *jndns;
> 
>                 if (isatty(1))
>                         flags |= UTIL_JSON_HUMAN;
>                 jndns = util_namespace_to_json(ndns, flags);
>                 if (jndns)
>                         printf("%s\n", json_object_to_json_string_ext(jndns,
>                                                 JSON_C_TO_STRING_PRETTY));
> 
> ...to dump the updated state of the namespace, so a similar
> util_memdev_to_json() seems appropriate here. However, perhaps that
> can come later. I have work-in-progress patches to move the core of
> cxl/list.c to a cxl_filter_walk() helper that would allow you to just
> call that to dump a listing for all the memdevs that were passed on
> the command line.

Will add. Thanks!
