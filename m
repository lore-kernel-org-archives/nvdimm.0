Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DB33FF2
	for <nvdimm@lists.linux.dev>; Thu,  9 Sep 2021 18:07:05 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id w8so2610890pgf.5
        for <nvdimm@lists.linux.dev>; Thu, 09 Sep 2021 11:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DB7d8qlsEXjW0/p+LkG3Ot1Z62d1BxqW2zd0idHHe0Q=;
        b=eVgSeQ7F796y82CTKM+Cp2kt12L7ThBsq/xNzKztOT6g/3VY9KWlhuZGqyGyNk7fmj
         beswRIhKQGuXNkb9M8xG5PwT7ZyJfipkE3mQKUknallBSc2YpWlS6/qpTaDoEnJUl/vp
         tcrbHr4tCMAYPfUowT1tu8kCO8jgfb7iI3fepUoy/4YTu2St+uKVy0nQUNHy1npzvqo5
         CL3uQvK7PDezWBPOG78OCf3Wq5Zr8xikIB6UsQq/NCPLtiOOYCiiR5T1c5IxTqvJA3dv
         aQQjqE63ueJ91oDcyoxMlV1t+5UgIKWLfNr5B51PIP//a9byyKevXzv3uJAbvtQ7ACqi
         Va9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DB7d8qlsEXjW0/p+LkG3Ot1Z62d1BxqW2zd0idHHe0Q=;
        b=6DL/rijNbBcTHApNTmNwSr24M3idkZqfem3GQHY6qE6wTngiQxenAwBbdoGD49vT7W
         Smn3FI0lZX2nPOxSX4YZ2RPW7vFkY5cN6qlFUj6MlBcliXvKYW+dWE3zIhOKROAhAr4Y
         5ZuYWyOU6AXeLX26bJbzKx/h5ebRDvI4x5aHrPNcQ035JycU63K8CitNe4T8PBCWcuRV
         NSTsM+9776l4+9vrytvt6Z/84RByl1y33QlrnSkaBXLuaJ4DhW9lmtSl3TKh6ObcyJxq
         2urQf+p/ui4Ik4Fia524er+Qr/dKjJZ57ZbWLge/UJMovVYmvpddsZChBgpkNMEeFNhv
         OLHg==
X-Gm-Message-State: AOAM532XkkjjLfzCedrVYcWvzrwfZ5Yjzry2XeslV0NxClUNhco+fvxU
	8vxB0cOGljNnfDv/zR8dP2qIKn8cZ7Wtl5hgsLiByA==
X-Google-Smtp-Source: ABdhPJyqAkf2g/NQRuEFf1jdcFOpyadRO6oGaB4+JFa5Qz5TVO7SvGXbKcXs8Yjvowe/QcDEQxiFgTi++eb6eDOArdI=
X-Received: by 2002:a62:1b92:0:b0:3eb:3f92:724 with SMTP id
 b140-20020a621b92000000b003eb3f920724mr4134686pfb.3.1631210824902; Thu, 09
 Sep 2021 11:07:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163116433533.2460985.14299233004385504131.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210909162005.ybqjh5xrbhg43wtr@intel.com>
In-Reply-To: <20210909162005.ybqjh5xrbhg43wtr@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 9 Sep 2021 11:06:53 -0700
Message-ID: <CAPcyv4h3LmmpTt_0Om0OCxWPXo-8jucA-9p3rwhx_j2vCFEj9Q@mail.gmail.com>
Subject: Re: [PATCH v4 08/21] cxl/pci: Clean up cxl_mem_get_partition_info()
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	"Schofield, Alison" <alison.schofield@intel.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 9, 2021 at 9:20 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> On 21-09-08 22:12:15, Dan Williams wrote:
> > Commit 0b9159d0ff21 ("cxl/pci: Store memory capacity values") missed
> > updating the kernel-doc for 'struct cxl_mem' leading to the following
> > warnings:
> >
> > ./scripts/kernel-doc -v drivers/cxl/cxlmem.h 2>&1 | grep warn
> > drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'total_bytes' not described in 'cxl_mem'
> > drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'volatile_only_bytes' not described in 'cxl_mem'
> > drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'persistent_only_bytes' not described in 'cxl_mem'
> > drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'partition_align_bytes' not described in 'cxl_mem'
> > drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'active_volatile_bytes' not described in 'cxl_mem'
> > drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'active_persistent_bytes' not described in 'cxl_mem'
> > drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'next_volatile_bytes' not described in 'cxl_mem'
> > drivers/cxl/cxlmem.h:107: warning: Function parameter or member 'next_persistent_bytes' not described in 'cxl_mem'
> >
> > Also, it is redundant to describe those same parameters in the
> > kernel-doc for cxl_mem_get_partition_info(). Given the only user of that
> > routine updates the values in @cxlm, just do that implicitly internal to
> > the helper.
> >
> > Cc: Ira Weiny <ira.weiny@intel.com>
> > Reported-by: Ben Widawsky <ben.widawsky@intel.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  drivers/cxl/cxlmem.h |   15 +++++++++++++--
> >  drivers/cxl/pci.c    |   35 +++++++++++------------------------
> >  2 files changed, 24 insertions(+), 26 deletions(-)
> >
> > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > index d5334df83fb2..c6fce966084a 100644
> > --- a/drivers/cxl/cxlmem.h
> > +++ b/drivers/cxl/cxlmem.h
> > @@ -78,8 +78,19 @@ devm_cxl_add_memdev(struct cxl_mem *cxlm,
> >   * @mbox_mutex: Mutex to synchronize mailbox access.
> >   * @firmware_version: Firmware version for the memory device.
> >   * @enabled_cmds: Hardware commands found enabled in CEL.
> > - * @pmem_range: Persistent memory capacity information.
> > - * @ram_range: Volatile memory capacity information.
> > + * @pmem_range: Active Persistent memory capacity configuration
> > + * @ram_range: Active Volatile memory capacity configuration
> > + * @total_bytes: sum of all possible capacities
> > + * @volatile_only_bytes: hard volatile capacity
> > + * @persistent_only_bytes: hard persistent capacity
> > + * @partition_align_bytes: soft setting for configurable capacity
> > + * @active_volatile_bytes: sum of hard + soft volatile
> > + * @active_persistent_bytes: sum of hard + soft persistent
>
> Looking at this now, probably makes sense to create some helper macros or inline
> functions to calculate these as needed, rather than storing them in the
> structure.

Perhaps, I would need to look deeper into what is worth caching vs
what is suitable to be recalculated. Do you have a proposal here?


>
> > + * @next_volatile_bytes: volatile capacity change pending device reset
> > + * @next_persistent_bytes: persistent capacity change pending device reset
> > + *
> > + * See section 8.2.9.5.2 Capacity Configuration and Label Storage for
> > + * details on capacity parameters.
> >   */
> >  struct cxl_mem {
> >       struct device *dev;
> > diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> > index c1e1d12e24b6..8077d907e7d3 100644
> > --- a/drivers/cxl/pci.c
> > +++ b/drivers/cxl/pci.c
> > @@ -1262,11 +1262,7 @@ static struct cxl_mbox_get_supported_logs *cxl_get_gsl(struct cxl_mem *cxlm)
> >
> >  /**
> >   * cxl_mem_get_partition_info - Get partition info
> > - * @cxlm: The device to act on
> > - * @active_volatile_bytes: returned active volatile capacity
> > - * @active_persistent_bytes: returned active persistent capacity
> > - * @next_volatile_bytes: return next volatile capacity
> > - * @next_persistent_bytes: return next persistent capacity
> > + * @cxlm: cxl_mem instance to update partition info
> >   *
> >   * Retrieve the current partition info for the device specified.  If not 0, the
> >   * 'next' values are pending and take affect on next cold reset.
> > @@ -1275,11 +1271,7 @@ static struct cxl_mbox_get_supported_logs *cxl_get_gsl(struct cxl_mem *cxlm)
> >   *
> >   * See CXL @8.2.9.5.2.1 Get Partition Info
> >   */
> > -static int cxl_mem_get_partition_info(struct cxl_mem *cxlm,
> > -                                   u64 *active_volatile_bytes,
> > -                                   u64 *active_persistent_bytes,
> > -                                   u64 *next_volatile_bytes,
> > -                                   u64 *next_persistent_bytes)
> > +static int cxl_mem_get_partition_info(struct cxl_mem *cxlm)
> >  {
> >       struct cxl_mbox_get_partition_info {
> >               __le64 active_volatile_cap;
> > @@ -1294,15 +1286,14 @@ static int cxl_mem_get_partition_info(struct cxl_mem *cxlm,
> >       if (rc)
> >               return rc;
> >
> > -     *active_volatile_bytes = le64_to_cpu(pi.active_volatile_cap);
> > -     *active_persistent_bytes = le64_to_cpu(pi.active_persistent_cap);
> > -     *next_volatile_bytes = le64_to_cpu(pi.next_volatile_cap);
> > -     *next_persistent_bytes = le64_to_cpu(pi.next_volatile_cap);
> > -
> > -     *active_volatile_bytes *= CXL_CAPACITY_MULTIPLIER;
> > -     *active_persistent_bytes *= CXL_CAPACITY_MULTIPLIER;
> > -     *next_volatile_bytes *= CXL_CAPACITY_MULTIPLIER;
> > -     *next_persistent_bytes *= CXL_CAPACITY_MULTIPLIER;
> > +     cxlm->active_volatile_bytes =
> > +             le64_to_cpu(pi.active_volatile_cap) * CXL_CAPACITY_MULTIPLIER;
> > +     cxlm->active_persistent_bytes =
> > +             le64_to_cpu(pi.active_persistent_cap) * CXL_CAPACITY_MULTIPLIER;
> > +     cxlm->next_volatile_bytes =
> > +             le64_to_cpu(pi.next_volatile_cap) * CXL_CAPACITY_MULTIPLIER;
> > +     cxlm->next_persistent_bytes =
> > +             le64_to_cpu(pi.next_volatile_cap) * CXL_CAPACITY_MULTIPLIER;
>
> Personally, I prefer the more functional style implementation. I guess if you
> wanted to make the change, my preference would be to kill
> cxl_mem_get_partition_info() entirely. Up to you though...

I was bringing this function in line with the precedent we already set
with cxl_mem_identify() that caches the result in @cxlm. Are you
saying you want to change that style too?

I feel like caching device attributes is idiomatic. Look at all the
PCI attributes that are cached in "struct pci_device" that could be
re-read or re-calculated rather than cached. In general I think a
routine that returns 4 values is better off filling in a structure.
