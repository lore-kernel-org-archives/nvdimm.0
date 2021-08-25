Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2416029CA
	for <nvdimm@lists.linux.dev>; Wed, 25 Aug 2021 21:56:23 +0000 (UTC)
Received: by linux.microsoft.com (Postfix, from userid 1096)
	id E6CDA20B8604; Wed, 25 Aug 2021 14:56:22 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E6CDA20B8604
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1629928582;
	bh=OLU36peEH1nTNxxpEQuZDxyyz/LX4UWD9d8h3w72+rU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ka4eJByAu/KAfC+Z0OS3Q4lqIOVYj40xT/4XLb1Dl1aJl7Tu5sMJKWyE/Xqm2lpQm
	 SPn4moBcQlwTFrtaZO5dxREdlpiCqw0LFAyVuDYxnoOIjYprFZjHiM8Tzfv/IR0Cws
	 D7S3c30HLiMRxaQmrZ6C+Db3ugcj2UuRqS+T5Y0Q=
Date: Wed, 25 Aug 2021 14:56:22 -0700
From: Taylor Stark <tstark@linux.microsoft.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal L Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	"Weiny, Ira" <ira.weiny@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>, apais@microsoft.com,
	tyhicks@microsoft.com, jamorris@microsoft.com,
	benhill@microsoft.com, sunilmut@microsoft.com,
	grahamwo@microsoft.com, tstark@microsoft.com
Subject: Re: [PATCH v2 0/2] virtio-pmem: Support PCI BAR-relative addresses
Message-ID: <20210825215622.GB3868@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20210715223324.GA29063@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAPcyv4gKqK6Mi6-PT0Mo=P=gBvMkA2zK1Huo3f2aAKYAP3SCVg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gKqK6Mi6-PT0Mo=P=gBvMkA2zK1Huo3f2aAKYAP3SCVg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Tue, Aug 24, 2021 at 05:35:48PM -0700, Dan Williams wrote:
> On Thu, Jul 15, 2021 at 3:34 PM Taylor Stark <tstark@linux.microsoft.com> wrote:
> >
> > Changes from v1 [1]:
> >  - Fixed a bug where the guest might touch pmem region prior to the
> >    backing file being mapped into the guest's address space.
> >
> > [1]: https://www.mail-archive.com/linux-nvdimm@lists.01.org/msg23736.html
> >
> > ---
> >
> > These patches add support to virtio-pmem to allow the pmem region to be
> > specified in either guest absolute terms or as a PCI BAR-relative address.
> > This is required to support virtio-pmem in Hyper-V, since Hyper-V only
> > allows PCI devices to operate on PCI memory ranges defined via BARs.
> >
> > Taylor Stark (2):
> >   virtio-pmem: Support PCI BAR-relative addresses
> >   virtio-pmem: Set DRIVER_OK status prior to creating pmem region
> 
> Are these patches still valid? I am only seeing one of them on the list.

I'd hold off on taking a look for now. I'll need to post a v3 based on some
suggestions while I was updating the virtio-pmem spec. It's a small change
compared to the current patches (adds in a feature bit check). I'll post v3
when the virtio-pmem base spec goes in. More info here:

https://lists.oasis-open.org/archives/virtio-comment/202107/msg00169.html

And yes, I messed up how I sent the patches. First time making linux changes,
so I had some bumps while getting my email properly configured.. :)

Thanks,
Taylor
