Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080FF3FC4
	for <nvdimm@lists.linux.dev>; Fri, 10 Sep 2021 08:56:57 +0000 (UTC)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H5V7C2M3Nz67Vqf;
	Fri, 10 Sep 2021 16:54:47 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 10 Sep 2021 10:56:54 +0200
Received: from localhost (10.52.123.213) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Fri, 10 Sep
 2021 09:56:54 +0100
Date: Fri, 10 Sep 2021 09:56:52 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Ben Widawsky <ben.widawsky@intel.com>
CC: Dan Williams <dan.j.williams@intel.com>, <linux-cxl@vger.kernel.org>, "Ira
 Weiny" <ira.weiny@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>,
	"Linux NVDIMM" <nvdimm@lists.linux.dev>, "Schofield, Alison"
	<alison.schofield@intel.com>
Subject: Re: [PATCH v4 08/21] cxl/pci: Clean up cxl_mem_get_partition_info()
Message-ID: <20210910095652.000037b1@Huawei.com>
In-Reply-To: <20210909210527.eyxreaq2vim3wfps@intel.com>
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
	<163116433533.2460985.14299233004385504131.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20210909162005.ybqjh5xrbhg43wtr@intel.com>
	<CAPcyv4h3LmmpTt_0Om0OCxWPXo-8jucA-9p3rwhx_j2vCFEj9Q@mail.gmail.com>
	<20210909210527.eyxreaq2vim3wfps@intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.123.213]
X-ClientProxiedBy: lhreml710-chm.china.huawei.com (10.201.108.61) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 9 Sep 2021 14:05:27 -0700
Ben Widawsky <ben.widawsky@intel.com> wrote:

> On 21-09-09 11:06:53, Dan Williams wrote:
> > On Thu, Sep 9, 2021 at 9:20 AM Ben Widawsky <ben.widawsky@intel.com> wrote:  
> > >
> > > On 21-09-08 22:12:15, Dan Williams wrote:  
> > > > Commit 0b9159d0ff21 ("cxl/pci: Store memory capacity values") missed
> > > > updating the kernel-doc for 'struct cxl_mem' leading to the following
> > > > warnings:
> > > >
> > > > ./scripts/kernel-doc -v drivers/cxl/cxlmem.h 2>&1 | grep warn
> > > > drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'total_bytes' not described in 'cxl_mem'
> > > > drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'volatile_only_bytes' not described in 'cxl_mem'
> > > > drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'persistent_only_bytes' not described in 'cxl_mem'
> > > > drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'partition_align_bytes' not described in 'cxl_mem'
> > > > drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'active_volatile_bytes' not described in 'cxl_mem'
> > > > drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'active_persistent_bytes' not described in 'cxl_mem'
> > > > drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'next_volatile_bytes' not described in 'cxl_mem'
> > > > drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'next_persistent_bytes' not described in 'cxl_mem'
> > > >
> > > > Also, it is redundant to describe those same parameters in the
> > > > kernel-doc for cxl_mem_get_partition_info(). Given the only user of that
> > > > routine updates the values in @cxlm, just do that implicitly internal to
> > > > the helper.
> > > >
> > > > Cc: Ira Weiny <ira.weiny@intel.com>
> > > > Reported-by: Ben Widawsky <ben.widawsky@intel.com>
> > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > > ---
> > > >  drivers/cxl/cxlmem.h |   15 +++++++++++++--
> > > >  drivers/cxl/pci.c    |   35 +++++++++++------------------------
> > > >  2 files changed, 24 insertions(+), 26 deletions(-)
> > > >
> > > > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > > > index d5334df83fb2..c6fce966084a 100644
> > > > --- a/drivers/cxl/cxlmem.h
> > > > +++ b/drivers/cxl/cxlmem.h
> > > > @@ -78,8 +78,19 @@ devm_cxl_add_memdev(struct cxl_mem *cxlm,
> > > >   * @mbox_mutex: Mutex to synchronize mailbox access.
> > > >   * @firmware_version: Firmware version for the memory device.
> > > >   * @enabled_cmds: Hardware commands found enabled in CEL.
> > > > - * @pmem_range: Persistent memory capacity information.
> > > > - * @ram_range: Volatile memory capacity information.
> > > > + * @pmem_range: Active Persistent memory capacity configuration
> > > > + * @ram_range: Active Volatile memory capacity configuration
> > > > + * @total_bytes: sum of all possible capacities
> > > > + * @volatile_only_bytes: hard volatile capacity
> > > > + * @persistent_only_bytes: hard persistent capacity
> > > > + * @partition_align_bytes: soft setting for configurable capacity  
> 
> see below... How about:
> "alignment size for partition-able capacity"

With that change or something similar.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huwei.com>

Renaming functions as discussed looks sensible to me as well in the longer term.

> 
> > > > + * @active_volatile_bytes: sum of hard + soft volatile
> > > > + * @active_persistent_bytes: sum of hard + soft persistent  
> > >
> > > Looking at this now, probably makes sense to create some helper macros or inline
> > > functions to calculate these as needed, rather than storing them in the
> > > structure.  
> > 
> > Perhaps, I would need to look deeper into what is worth caching vs
> > what is suitable to be recalculated. Do you have a proposal here?  
> 
> I think it's worth being considered... however, this suggestion was my mistake.
> I thought there was a way to infer the active capacities just from identify, but
> there isn't. This leads me to request an update to the kdoc above which was how
> I got confused.
> 
> > 
> >   
> > >  
> > > > + * @next_volatile_bytes: volatile capacity change pending device reset
> > > > + * @next_persistent_bytes: persistent capacity change pending device reset
> > > > + *
> > > > + * See section 8.2.9.5.2 Capacity Configuration and Label Storage for
> > > > + * details on capacity parameters.
> > > >   */
> > > >  struct cxl_mem {
> > > >       struct device *dev;
> > > > diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> > > > index c1e1d12e24b6..8077d907e7d3 100644
> > > > --- a/drivers/cxl/pci.c
> > > > +++ b/drivers/cxl/pci.c
> > > > @@ -1262,11 +1262,7 @@ static struct cxl_mbox_get_supported_logs *cxl_get_gsl(struct cxl_mem *cxlm)
> > > >
> > > >  /**
> > > >   * cxl_mem_get_partition_info - Get partition info
> > > > - * @cxlm: The device to act on
> > > > - * @active_volatile_bytes: returned active volatile capacity
> > > > - * @active_persistent_bytes: returned active persistent capacity
> > > > - * @next_volatile_bytes: return next volatile capacity
> > > > - * @next_persistent_bytes: return next persistent capacity
> > > > + * @cxlm: cxl_mem instance to update partition info
> > > >   *
> > > >   * Retrieve the current partition info for the device specified.  If not 0, the
> > > >   * 'next' values are pending and take affect on next cold reset.
> > > > @@ -1275,11 +1271,7 @@ static struct cxl_mbox_get_supported_logs *cxl_get_gsl(struct cxl_mem *cxlm)
> > > >   *
> > > >   * See CXL @8.2.9.5.2.1 Get Partition Info
> > > >   */
> > > > -static int cxl_mem_get_partition_info(struct cxl_mem *cxlm,
> > > > -                                   u64 *active_volatile_bytes,
> > > > -                                   u64 *active_persistent_bytes,
> > > > -                                   u64 *next_volatile_bytes,
> > > > -                                   u64 *next_persistent_bytes)
> > > > +static int cxl_mem_get_partition_info(struct cxl_mem *cxlm)
> > > >  {
> > > >       struct cxl_mbox_get_partition_info {
> > > >               __le64 active_volatile_cap;
> > > > @@ -1294,15 +1286,14 @@ static int cxl_mem_get_partition_info(struct cxl_mem *cxlm,
> > > >       if (rc)
> > > >               return rc;
> > > >
> > > > -     *active_volatile_bytes = le64_to_cpu(pi.active_volatile_cap);
> > > > -     *active_persistent_bytes = le64_to_cpu(pi.active_persistent_cap);
> > > > -     *next_volatile_bytes = le64_to_cpu(pi.next_volatile_cap);
> > > > -     *next_persistent_bytes = le64_to_cpu(pi.next_volatile_cap);
> > > > -
> > > > -     *active_volatile_bytes *= CXL_CAPACITY_MULTIPLIER;
> > > > -     *active_persistent_bytes *= CXL_CAPACITY_MULTIPLIER;
> > > > -     *next_volatile_bytes *= CXL_CAPACITY_MULTIPLIER;
> > > > -     *next_persistent_bytes *= CXL_CAPACITY_MULTIPLIER;
> > > > +     cxlm->active_volatile_bytes =
> > > > +             le64_to_cpu(pi.active_volatile_cap) * CXL_CAPACITY_MULTIPLIER;
> > > > +     cxlm->active_persistent_bytes =
> > > > +             le64_to_cpu(pi.active_persistent_cap) * CXL_CAPACITY_MULTIPLIER;
> > > > +     cxlm->next_volatile_bytes =
> > > > +             le64_to_cpu(pi.next_volatile_cap) * CXL_CAPACITY_MULTIPLIER;
> > > > +     cxlm->next_persistent_bytes =
> > > > +             le64_to_cpu(pi.next_volatile_cap) * CXL_CAPACITY_MULTIPLIER;  
> > >
> > > Personally, I prefer the more functional style implementation. I guess if you
> > > wanted to make the change, my preference would be to kill
> > > cxl_mem_get_partition_info() entirely. Up to you though...  
> > 
> > I was bringing this function in line with the precedent we already set
> > with cxl_mem_identify() that caches the result in @cxlm. Are you
> > saying you want to change that style too?
> > 
> > I feel like caching device attributes is idiomatic. Look at all the
> > PCI attributes that are cached in "struct pci_device" that could be
> > re-read or re-calculated rather than cached. In general I think a
> > routine that returns 4 values is better off filling in a structure.  
> 
> Caching is totally fine, I was just suggesting keeping the side effects out of
> the innocuous sounding cxl_mem_get_partition_info(). I think I originally
> authored authored cxl_mem_identify(), so mea culpa. I just realized it after
> seeing the removal that I liked Ira's functional style.
> 
> Perhaps simply renaming these functions is the right solution (ie. save it for a
> rainy day). Populate is not my favorite verb, but as an example:
> static int cxl_mem_populate_partition_info
> static int cxl_mem_populate_indentify

