Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C7E13D8AC
	for <nvdimm@lists.linux.dev>; Thu, 31 Oct 2024 22:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730414961; cv=none; b=btme/GjGwKdOtf0ht4lfU+eOcqmten5lbahzSXAmM4Du33SAoTSb+T16Koy2o6nk6yHuUeQfT8rmMGknpBEYaPq0BnVE9bdJpvGVuL0QwKO0v4Yc7ESTq1vFA6mP8gWGrbE4O7Vo5W98IahAQ47UVO1CZ98WH9E0xEEq/h91C/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730414961; c=relaxed/simple;
	bh=ZUWUbVd6vlMjhWzeaLEbi5tYuDL0DufaZoWUS1ZvNR0=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a28Etrp9cw08IaC7+GKSHMR2LL+yxPLRxMdM+Q41zgiizus0WA/tolc1xIXho+G4HU5XlBippfMZOuYqy8HmOdvTN15Y0GO2Xi5ohdpUHNIk8Rna0i30qcByfm3cU9oIzBCxJw/h4XkJkejkBTG43x7XkrnHtYt5xIAYuxmFbBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jxIwaXxG; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jxIwaXxG"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-20c803787abso11458145ad.0
        for <nvdimm@lists.linux.dev>; Thu, 31 Oct 2024 15:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730414955; x=1731019755; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b1qqiuqn4sWIJMyrU31AqAANpEwVjAPAmZe9LE6azyk=;
        b=jxIwaXxGa0WmVaQEwPBBT5kC0fMqtST+7JdrjUNEo/nDr7BWhMhhqThVIe+Y7WoY2P
         4+xy8C45JswoAZ4DgTRDYrwiXnoYMbob5t45gtGtlVnboVx2+9KstCWqP2fN34ASdH1S
         sH+zliFi/yY+2T2F6jzu+LjgmyoBxqaRi7K0P9nYN8HMumEpHWLLRpW2g8leYwJYYURw
         yvd532ZaypaLzDAUPKj00Gf/PzDBmN9XCfmNdOunmhTrT85lXIRQpGAz0fps6Vr3/rXY
         f3JVmtB85J5zmqRT7rF1lI9aYOAUI/HqdXn5qhuk6wkcOVc/eqVG5Yp/tC0W7+qsc8t1
         vbAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730414955; x=1731019755;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b1qqiuqn4sWIJMyrU31AqAANpEwVjAPAmZe9LE6azyk=;
        b=M4qdvyPW/BC6c+PBqmJOnfaTxPYhZcW9r5epX+7VHTFL6BpzfUM2MtF9S3YDNCJS29
         dvdzw0UKdXD+xgX4IoJPXfsOhIkonEb9ruYIr98P72gyzUdYycSShgUcqqAOlqKayqz8
         YDZsRJYCLj58aSvqWdkjAHlFQf/GXLsr3iuXjTEgnuU55eQ0FxuiyoM33dAKXDR2M1Ya
         IbThIzRbucjfXUzVFyB4cEbXTSE8PBjV93jPxg9tke0bBpesoSM9FPqnhus6Ac8dUMFO
         Jr2+JfKNCPr3FG8BwO27bNdodvEDGtyFV3WZRK22xVS2lSBv09GXwWfptDfRx0WYBWrL
         UPaw==
X-Forwarded-Encrypted: i=1; AJvYcCWRBwJ2pgSuW7RIBRq8YUk+P6vfbhzr5laTpMv3kvnDzqYN1WQKYcrZrRYC6ur191I5VHrjWcE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx264qX0+7pp9etxGShd2eodqdF9Ky9tRwdcQGkCsDNL22lDVnA
	umNgF9JkQJ5eyvhJsyCOFOjcrvj/+zClSSOJzZeF6xvMEUFq0HjJ
X-Google-Smtp-Source: AGHT+IHKgqMa5mer2tolVlSeJmdHhm33dAbayczaLFP558NHquPOEyrIUMSHyZlpb5e+FWBzKsEFgQ==
X-Received: by 2002:a17:902:e84a:b0:20c:da7c:6e8c with SMTP id d9443c01a7336-21119390d4bmr26487925ad.3.1730414955309;
        Thu, 31 Oct 2024 15:49:15 -0700 (PDT)
Received: from fan ([2601:646:8f03:9fee:1a14:7759:606e:c90])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211057c1615sm13246825ad.185.2024.10.31.15.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2024 15:49:14 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Thu, 31 Oct 2024 15:48:58 -0700
To: Ira Weiny <ira.weiny@intel.com>
Cc: Fan Ni <nifan.cxl@gmail.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, Sushant1 Kumar <sushant1.kumar@intel.com>
Subject: Re: [ndctl PATCH 4/6] cxl/region: Add creation of Dynamic capacity
 regions
Message-ID: <ZyQJWoPqJRTM2iF1@fan>
References: <20241030-dcd-region2-v1-0-04600ba2b48e@intel.com>
 <20241030-dcd-region2-v1-4-04600ba2b48e@intel.com>
 <ZyPPPycLXADj2Lvb@fan>
 <6724007843a17_8a67029496@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6724007843a17_8a67029496@iweiny-mobl.notmuch>

On Thu, Oct 31, 2024 at 05:11:04PM -0500, Ira Weiny wrote:
> Fan Ni wrote:
> > On Wed, Oct 30, 2024 at 04:54:47PM -0500, ira.weiny@intel.com wrote:
> > > From: Navneet Singh <navneet.singh@intel.com>
> > > 
> > > CXL Dynamic Capacity Devices (DCDs) optionally support dynamic capacity
> > > with up to eight partitions (Regions) (dc0-dc7).  CXL regions can now be
> > > spare and defined as dynamic capacity (dc).
> > > 
> > > Add support for DCD devices.  Query for DCD capabilities.  Add the
> > > ability to add DC partitions to a CXL DC region.
> > > 
> > > Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> > > Co-authored-by: Sushant1 Kumar <sushant1.kumar@intel.com>
> > > Signed-off-by: Sushant1 Kumar <sushant1.kumar@intel.com>
> > > Co-authored-by: Ira Weiny <ira.weiny@intel.com>
> > > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > > 
> > > ---
> > > Changes:
> > > [iweiny: adjust to new sysfs interface.]
> > > [iweiny: Rebase to latest pending]
> > > [iweiny: Adjust DCD region code to new upstream sysfs entries]
> > > [iweiny: Ensure backwards compatibility for non-DC kernels]
> > > [iweiny: fixup help message to show DC type]
> > > [iweiny: don't double declare decoder mode is dc]
> > > [iweiny: simplify __reserve_dpa() with decoder mode to index]
> > > [iweiny: Adjust to the new region mode]
> > > ---
> > >  cxl/json.c         | 26 +++++++++++++++
> > >  cxl/lib/libcxl.c   | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
> > >  cxl/lib/libcxl.sym |  3 ++
> > >  cxl/lib/private.h  |  6 +++-
> > >  cxl/libcxl.h       | 55 +++++++++++++++++++++++++++++--
> > >  cxl/memdev.c       |  7 +++-
> > >  cxl/region.c       | 49 ++++++++++++++++++++++++++--
> > >  7 files changed, 234 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/cxl/json.c b/cxl/json.c
> > > index dcd3cc28393faf7e8adf299a857531ecdeaac50a..4276b9678d7e03eaf2aec581a08450f2a0b857f2 100644
> > > --- a/cxl/json.c
> > > +++ b/cxl/json.c
> > > @@ -754,10 +754,12 @@ err_free:
> > >  	return jpoison;
> > >  }
> > >  
> > > +#define DC_SIZE_NAME_LEN 64
> > >  struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
> > >  		unsigned long flags)
> > >  {
> > >  	const char *devname = cxl_memdev_get_devname(memdev);
> > > +	char size_name[DC_SIZE_NAME_LEN];
> > >  	struct json_object *jdev, *jobj;
> > >  	unsigned long long serial, size;
> > >  	const char *fw_version;
> > > @@ -800,6 +802,17 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
> > >  		}
> > >  	}
> > >  
> > > +	for (int index; index < MAX_NUM_DC_REGIONS; index++) {
> > 
> > index is not initialized.
> > Should be index = 0;
> 
> Thanks for the review!
> 
> Good catch.  I'll fix up.
> 
> > 
> > Also, the "cxl list" looks like below, the size of each DC region is
> > attached to each DCD device, that seems not quite aligned with what
> > "_size" means for pmem/ram. Should we have a separate option for "cxl
> > list" to show DC region info??
> 
> I'm not sure I follow.  The pmem/ram sizes show the size of the partitions on
> the memdev.  This is the same for each DC partition.
> 
> Are you looking for the available size after some extents are available?
> 
> In that case I think you are looking for the dax information details which
> comes after creating a region and using the -X option.
> 
> 17:02:42 > ./build/cxl/cxl list -r 8 -X
> [
>   {
>     "region":"region8",
>     "resource":1031597457408,
>     "size":536870912,
>     "type":"dc",
>     "interleave_ways":1,
>     "interleave_granularity":256,
>     "decode_state":"commit",
>     "daxregion":{
>       "id":8,
>       "size":536870912,
>       "available_size":134217728,
>       "align":2097152
>     }
>   }
> ]
> 
> 
> This shows an available size which can further be dissected with the new
> --extents (-N) option added in patch 5/6.
> 
> 17:04:32 > ./build/cxl/cxl list -r 8 -X -N
> [
>   {
>     "region":"region8",
>     "resource":1031597457408,
>     "size":536870912,
>     "type":"dc",
>     "interleave_ways":1,
>     "interleave_granularity":256,
>     "decode_state":"commit",
>     "daxregion":{
>       "id":8,
>       "size":536870912,
>       "available_size":134217728,
>       "align":2097152
>     },
>     "extents":[
>       {
>         "offset":268435456,
>         "length":67108864,
>         "tag":"00000000-0000-0000-0000-000000000000"
>       },
>       {
>         "offset":134217728,
>         "length":67108864,
>         "tag":"00000000-0000-0000-0000-000000000000"
>       }
>     ]
>   }
> ]
> 
> 
> Does this give you the information you are looking for?  Or am I missing
> something in your question?
> 
> Ira
I was looking for something like the "-N" option provides, so I think we
are good.

Fan
> 
> > 
> > Fan
> > 
> > ----------
> >   {
> >         "memdev":"mem1",
> >         "dc0_size":"2.00 GiB (2.15 GB)",
> >         "dc1_size":"2.00 GiB (2.15 GB)",
> >         "serial":"0xf02",
> >         "host":"0000:11:00.0",
> >         "firmware_version":"BWFW VERSION 00"
> >       },
> >       {
> >         "memdev":"mem3",
> >         "dc0_size":"2.00 GiB (2.15 GB)",
> >         "dc1_size":"2.00 GiB (2.15 GB)",
> >         "serial":"0xf03",
> >         "host":"0000:12:00.0",
> >         "firmware_version":"BWFW VERSION 00"
> >       },
> > ----------
> > 
> 
> [snip]

-- 
Fan Ni
