Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1505633C2;
	Thu, 12 May 2022 15:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652370891; x=1683906891;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NtmTxmIUibqIvUZsk1i2Jxm7uWgkNZfVVWO7Z8pp5AI=;
  b=JSuqp/4TJGx2XHexbngBZiHNPIAAettgmYQO+5zuvGUSW9l5wdlPTjK5
   /chtaOHWOO9OyZzbx958puKBWLrXqydufLWjhJqidqxXospQCU4jqBunz
   uOcqfNJCAkSTg7ydnJMNYCsMm3bU4/GqzeMvXl7ZKSB6BugiAKDCbBxSs
   AbrJj+9PFZuquhQW4bMQ5ZAtWcS+hKh+NI9ypk6y0NHLs892nepE7y/UM
   dKQnUK2YrbZFevLKZUqnMVvgv8bo3144JL8Ut9jc5QYAcHterQ5FrfGsa
   8CU51wkfKlaWQLyNucDxbnW6ok9fsHnDqrzqWGQMjp0rk6qBvVNXruVpw
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="250563278"
X-IronPort-AV: E=Sophos;i="5.91,220,1647327600"; 
   d="scan'208";a="250563278"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 08:54:50 -0700
X-IronPort-AV: E=Sophos;i="5.91,220,1647327600"; 
   d="scan'208";a="739740455"
Received: from wcogara-mobl.amr.corp.intel.com (HELO intel.com) ([10.252.129.107])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 08:54:50 -0700
Date: Thu, 12 May 2022 08:54:43 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Schofield, Alison" <alison.schofield@intel.com>,
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
	"Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [RFC PATCH 12/15] cxl/region: Add region creation ABI
Message-ID: <20220512155443.6mutrxptd7itk4ds@intel.com>
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
 <20220413183720.2444089-13-ben.widawsky@intel.com>
 <f9fa0a306b167db2a91021aff70bcdbc8c154391.camel@intel.com>
 <CAPcyv4jM_N0Sz_MpFC9+tr01ysJ16EwkSsbxOXxCM5aC7FSe3w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jM_N0Sz_MpFC9+tr01ysJ16EwkSsbxOXxCM5aC7FSe3w@mail.gmail.com>

On 22-05-04 22:17:49, Dan Williams wrote:
> On Wed, May 4, 2022 at 3:57 PM Verma, Vishal L <vishal.l.verma@intel.com> wrote:
> >
> > On Wed, 2022-04-13 at 11:37 -0700, Ben Widawsky wrote:
> > > Regions are created as a child of the decoder that encompasses an
> > > address space with constraints. Regions have a number of attributes that
> > > must be configured before the region can be activated.
> > >
> > > Multiple processes which are trying not to race with each other
> > > shouldn't need special userspace synchronization to do so.
> > >
> > > // Allocate a new region name
> > > region=$(cat /sys/bus/cxl/devices/decoder0.0/create_pmem_region)
> > >
> > > // Create a new region by name
> > > while
> > > region=$(cat /sys/bus/cxl/devices/decoder0.0/create_pmem_region)
> > > ! echo $region > /sys/bus/cxl/devices/decoder0.0/create_pmem_region
> > > do true; done
> > >
> > > // Region now exists in sysfs
> > > stat -t /sys/bus/cxl/devices/decoder0.0/$region
> > >
> > > // Delete the region, and name
> > > echo $region > /sys/bus/cxl/devices/decoder0.0/delete_region
> >
> > I noticed a slight ABI inconsistency here while working on the libcxl
> > side of this - see below.
> >
> > > +
> > > +static ssize_t create_pmem_region_show(struct device *dev,
> > > +                                      struct device_attribute *attr, char *buf)
> > > +{
> > > +       struct cxl_decoder *cxld = to_cxl_decoder(dev);
> > > +       struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(cxld);
> > > +       size_t rc;
> > > +
> > > +       /*
> > > +        * There's no point in returning known bad answers when the lock is held
> > > +        * on the store side, even though the answer given here may be
> > > +        * immediately invalidated as soon as the lock is dropped it's still
> > > +        * useful to throttle readers in the presence of writers.
> > > +        */
> > > +       rc = mutex_lock_interruptible(&cxlrd->id_lock);
> > > +       if (rc)
> > > +               return rc;
> > > +       rc = sysfs_emit(buf, "%d\n", cxlrd->next_region_id);
> >
> > This emits a numeric region ID, e.g. "0", where as
> >
> > > +       mutex_unlock(&cxlrd->id_lock);
> > > +
> > > +       return rc;
> > > +}
> > > +
> >
> > <snip>
> >
> > > +static ssize_t delete_region_store(struct device *dev,
> > > +                                  struct device_attribute *attr,
> > > +                                  const char *buf, size_t len)
> > > +{
> > > +       struct cxl_port *port = to_cxl_port(dev->parent);
> > > +       struct cxl_decoder *cxld = to_cxl_decoder(dev);
> > > +       struct cxl_region *cxlr;
> > > +
> > > +       cxlr = cxl_find_region_by_name(cxld, buf);
> >
> > This expects a full region name string e.g. "region0"
> >
> > Was this intentional? I don't think it's a huge deal, the library can
> > certainly deal with it if needed - but would it be better to have the
> > ABI symmetrical between create and delete?
> 
> Yes, makes sense to me.

It was not intentional. It's "region%u" for both create and delete now.
