Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C3E2C9C
	for <nvdimm@lists.linux.dev>; Sat,  8 Jan 2022 01:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641606372; x=1673142372;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=Jlez/gmtyF3aiW21iBbnM8QJiRU8qEa/fcFMRHLP1zQ=;
  b=KEdzbuFdDOWa/OgxUmdbTo9uoFJMZPL9mt+3Wp8SmKA4oMeUgT1Yoz0w
   wagEgyKGaDY2BB+gcj8wu5dgt9Ld2g7g/1wnyYb0WuZMZdSIBP+hEEBeJ
   5YSaB6KOQEEZd1e8xwTJIonUW27lGp7sUU+ft4Y64WqHfLr5W5UlglqYK
   zNy3LYVp1Q5mjEjIGoI63FW8axKg7tJ85S2Pa3UBsBqSwiZZYCdvqvUMv
   RPfhh7WwQh1pPcobhQjnC5Il9ot8FYaDEiuh1A1EvR/VeDHXsmgg8C+u+
   XvU+lybZkCao5/JWVVS/9b2eyseBaHrXvVoaN0oRrtL0J56wZ6VcDw5mn
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10220"; a="240525126"
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="240525126"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 17:46:11 -0800
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="527579920"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 17:46:11 -0800
Date: Fri, 7 Jan 2022 17:51:21 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 5/7] libcxl: add interfaces for SET_PARTITION_INFO
 mailbox command
Message-ID: <20220108015121.GA804835@alison-desk>
References: <cover.1641233076.git.alison.schofield@intel.com>
 <fa45e95e5d28981b4ec41db65aab82c103bff0c3.1641233076.git.alison.schofield@intel.com>
 <20220106205302.GF178135@iweiny-DESK2.sc.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106205302.GF178135@iweiny-DESK2.sc.intel.com>

On Thu, Jan 06, 2022 at 12:53:02PM -0800, Ira Weiny wrote:
> On Mon, Jan 03, 2022 at 12:16:16PM -0800, Schofield, Alison wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> > Add APIs to allocate and send a SET_PARTITION_INFO mailbox command.
> > 
> > +	le64 volatile_capacity;
> > +	u8 flags;
> > +} __attribute__((packed));
> > +
> > +/* CXL 2.0 8.2.9.5.2 Set Partition Info */
> > +#define CXL_CMD_SET_PARTITION_INFO_NO_FLAG				(0)
> > +#define CXL_CMD_SET_PARTITION_INFO_IMMEDIATE_FLAG			(1)
> 
> BIT(0) and BIT(1)?
> 
> I can't remember which bit is the immediate flag.
> 
Immediate flag is BIT(0).
Seemed awkward/overkill to use bit macro -
+#define CXL_CMD_SET_PARTITION_INFO_NO_FLAG				(0)
+#define CXL_CMD_SET_PARTITION_INFO_IMMEDIATE_FLAG			BIT(1)

I just added api to use this so you'll see it in action in v2
of this patchset and can comment again.

