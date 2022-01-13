Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F356168
	for <nvdimm@lists.linux.dev>; Thu, 13 Jan 2022 16:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642091358; x=1673627358;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VJ1RGkVC/trPp/cUPp/GIOHOVDqhtF7ugEFuB9g9+s8=;
  b=bGdgNcM+2TnDK+HWRxGed5R6URykPT4jXxZFH819b+VfSSd+uscEj97w
   nSeK8SA3fqCxwtT6zyd1MWvt8mN3+fWTV62MQIMY+6Pwj+LuUptfFdDWL
   xA/chRkPGlhAFU0eskPUrkur0Y3mZZ2AvfTAyFSv3vUlYD5o7z2vpO2yY
   XpFEhALR8gTe2xs8WhPykn6MDJfcl4TU4NO7s7hblq7BVVe1VimaE4+NC
   bPjP8cRxalQ4pUIHBHP7UyOpBePDCdE5KG0IK3PKHbyOi9znSq2N8RX9P
   fDSBY6+/ga3WBfCboz7von6JsgRmRCEHLodt3lLsu2RON63PgPExiFKIV
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10225"; a="224027858"
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; 
   d="scan'208";a="224027858"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 08:29:17 -0800
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; 
   d="scan'208";a="670563717"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 08:29:17 -0800
Date: Thu, 13 Jan 2022 08:34:15 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v2 3/6] libcxl: return the partition alignment
 field in bytes
Message-ID: <20220113163415.GA831585@alison-desk>
References: <cover.1641965853.git.alison.schofield@intel.com>
 <ca1821eee9f8e2372e378165d5c24bbf9161e6fe.1641965853.git.alison.schofield@intel.com>
 <20220113163149.GA831535@alison-desk>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220113163149.GA831535@alison-desk>

On Thu, Jan 13, 2022 at 08:31:49AM -0800, Alison Schofield wrote:
> 
> On Tue, Jan 11, 2022 at 10:33:31PM -0800, alison.schofield@intel.com wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> > Per the CXL specification, the partition alignment field reports
> > the alignment value in multiples of 256MB. In the libcxl API, values
> > for all capacity fields are defined to return bytes.
> > 
> > Update the partition alignment accessor to return bytes so that it
> > is in sync with other capacity related fields.
> > 
> > Rename the function to reflect the new return value:
> > cxl_cmd_identify_get_partition_align_bytes()
> 
> Vishal,
> Just realized that the cxl_identify_get_partition_align() API was released
> in ndctl-v72. Does that mean NAK on changing the name here?
> Alison

That question was incomplete! Does that mean NAK on changing what it
returns too?  Or are 'we' early enough in cxl-cli to make such a change?

> 
> > 
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> >  cxl/lib/libcxl.c   | 4 ++--
> >  cxl/lib/libcxl.sym | 2 +-
> >  cxl/libcxl.h       | 2 +-
> >  3 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> > index 1fd584a..823bcb0 100644
> > --- a/cxl/lib/libcxl.c
> > +++ b/cxl/lib/libcxl.c
> > @@ -1078,7 +1078,7 @@ CXL_EXPORT int cxl_cmd_identify_get_fw_rev(struct cxl_cmd *cmd, char *fw_rev,
> >  	return 0;
> >  }
> >  
> > -CXL_EXPORT unsigned long long cxl_cmd_identify_get_partition_align(
> > +CXL_EXPORT unsigned long long cxl_cmd_identify_get_partition_align_bytes(
> >  		struct cxl_cmd *cmd)
> >  {
> >  	struct cxl_cmd_identify *id =
> > @@ -1089,7 +1089,7 @@ CXL_EXPORT unsigned long long cxl_cmd_identify_get_partition_align(
> >  	if (cmd->status < 0)
> >  		return cmd->status;
> >  
> > -	return le64_to_cpu(id->partition_align);
> > +	return le64_to_cpu(id->partition_align) * CXL_CAPACITY_MULTIPLIER;
> >  }
> >  
> >  CXL_EXPORT unsigned int cxl_cmd_identify_get_label_size(struct cxl_cmd *cmd)
> > diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> > index b7e969f..1e2cf05 100644
> > --- a/cxl/lib/libcxl.sym
> > +++ b/cxl/lib/libcxl.sym
> > @@ -34,7 +34,7 @@ global:
> >  	cxl_cmd_identify_get_total_bytes;
> >  	cxl_cmd_identify_get_volatile_only_bytes;
> >  	cxl_cmd_identify_get_persistent_only_bytes;
> > -	cxl_cmd_identify_get_partition_align;
> > +	cxl_cmd_identify_get_partition_align_bytes;
> >  	cxl_cmd_identify_get_label_size;
> >  	cxl_cmd_new_get_health_info;
> >  	cxl_cmd_health_info_get_maintenance_needed;
> > diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> > index 46f99fb..f19ed4f 100644
> > --- a/cxl/libcxl.h
> > +++ b/cxl/libcxl.h
> > @@ -71,7 +71,7 @@ int cxl_cmd_identify_get_fw_rev(struct cxl_cmd *cmd, char *fw_rev, int fw_len);
> >  unsigned long long cxl_cmd_identify_get_total_bytes(struct cxl_cmd *cmd);
> >  unsigned long long cxl_cmd_identify_get_volatile_only_bytes(struct cxl_cmd *cmd);
> >  unsigned long long cxl_cmd_identify_get_persistent_only_bytes(struct cxl_cmd *cmd);
> > -unsigned long long cxl_cmd_identify_get_partition_align(struct cxl_cmd *cmd);
> > +unsigned long long cxl_cmd_identify_get_partition_align_bytes(struct cxl_cmd *cmd);
> >  unsigned int cxl_cmd_identify_get_label_size(struct cxl_cmd *cmd);
> >  struct cxl_cmd *cxl_cmd_new_get_health_info(struct cxl_memdev *memdev);
> >  int cxl_cmd_health_info_get_maintenance_needed(struct cxl_cmd *cmd);
> > -- 
> > 2.31.1
> > 
> 
