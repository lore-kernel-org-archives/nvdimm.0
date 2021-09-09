Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91643FEE
	for <nvdimm@lists.linux.dev>; Thu,  9 Sep 2021 20:35:30 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10102"; a="243218639"
X-IronPort-AV: E=Sophos;i="5.85,281,1624345200"; 
   d="scan'208";a="243218639"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 13:35:30 -0700
X-IronPort-AV: E=Sophos;i="5.85,281,1624345200"; 
   d="scan'208";a="539920259"
Received: from teweicha-mobl.amr.corp.intel.com (HELO intel.com) ([10.252.131.52])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 13:35:29 -0700
Date: Thu, 9 Sep 2021 13:35:28 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, kernel test robot <lkp@intel.com>,
	Vishal L Verma <vishal.l.verma@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	"Schofield, Alison" <alison.schofield@intel.com>,
	"Weiny, Ira" <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v4 11/21] cxl/mbox: Move mailbox and other non-PCI
 specific infrastructure to the core
Message-ID: <20210909203528.frq547zd26efumpz@intel.com>
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163116435233.2460985.16197340449713287180.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210909164125.ttvptq6eiiirvnnp@intel.com>
 <CAPcyv4hH7=cbnpz9dcKFEByqZkVxJVXpuks4g_63VguisDdPPw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hH7=cbnpz9dcKFEByqZkVxJVXpuks4g_63VguisDdPPw@mail.gmail.com>

On 21-09-09 11:50:01, Dan Williams wrote:
> On Thu, Sep 9, 2021 at 9:41 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
> >
> > On 21-09-08 22:12:32, Dan Williams wrote:
> > > Now that the internals of mailbox operations are abstracted from the PCI
> > > specifics a bulk of infrastructure can move to the core.
> > >
> > > The CXL_PMEM driver intends to proxy LIBNVDIMM UAPI and driver requests
> > > to the equivalent functionality provided by the CXL hardware mailbox
> > > interface. In support of that intent move the mailbox implementation to
> > > a shared location for the CXL_PCI driver native IOCTL path and CXL_PMEM
> > > nvdimm command proxy path to share.
> > >
> > > A unit test framework seeks to implement a unit test backend transport
> > > for mailbox commands to communicate mocked up payloads. It can reuse all
> > > of the mailbox infrastructure minus the PCI specifics, so that also gets
> > > moved to the core.
> > >
> > > Finally with the mailbox infrastructure and ioctl handling being
> > > transport generic there is no longer any need to pass file
> > > file_operations to devm_cxl_add_memdev(). That allows all the ioctl
> > > boilerplate to move into the core for unit test reuse.
> > >
> > > No functional change intended, just code movement.
> >
> > At some point, I think some of the comments and kernel docs need updating since
> > the target is no longer exclusively memory devices. Perhaps you do this in later
> > patches....
> 
> I would wait to rework comments when/if it becomes clear that a
> non-memory-device driver wants to reuse the mailbox core. I do not see
> any indications that the comments are currently broken, do you?

I didn't see anything which is incorrect, no. But to would be non-memory-driver
writers, they could be scared off by such comments... I don't mean that it
should hold this patch up btw.

> 
> [..]
> > > diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> > > index 036a3c8106b4..c85b7fbad02d 100644
> > > --- a/drivers/cxl/core/core.h
> > > +++ b/drivers/cxl/core/core.h
> > > @@ -14,7 +14,15 @@ static inline void unregister_cxl_dev(void *dev)
> > >       device_unregister(dev);
> > >  }
> > >
> > > +struct cxl_send_command;
> > > +struct cxl_mem_query_commands;
> > > +int cxl_query_cmd(struct cxl_memdev *cxlmd,
> > > +               struct cxl_mem_query_commands __user *q);
> > > +int cxl_send_cmd(struct cxl_memdev *cxlmd, struct cxl_send_command __user *s);
> > > +
> > >  int cxl_memdev_init(void);
> > >  void cxl_memdev_exit(void);
> > > +void cxl_mbox_init(void);
> > > +void cxl_mbox_exit(void);
> >
> > cxl_mbox_fini()?
> 
> The idiomatic kernel module shutdown function is suffixed _exit().
> 
> [..]

Got it, I argue that these aren't kernel module init/exit functions though. I
will leave it at that.
