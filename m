Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C4B72
	for <nvdimm@lists.linux.dev>; Tue, 27 Jul 2021 08:07:22 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6FBEF6736F; Tue, 27 Jul 2021 10:07:19 +0200 (CEST)
Date: Tue, 27 Jul 2021 10:07:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, nvdimm@lists.linux.dev
Subject: DAX setup pains, was Re: RFC: switch iomap to an iterator model
Message-ID: <20210727080719.GA17464@lst.de>
References: <20210719103520.495450-1-hch@lst.de> <20210719175756.GM22357@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719175756.GM22357@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 19, 2021 at 10:57:56AM -0700, Darrick J. Wong wrote:
> Which seems to translate to:
> 
> -machine pc-q35-4.2,accel=kvm,usb=off,vmport=off,dump-guest-core=off,nvdimm=on
> -object memory-backend-file,id=memnvdimm0,prealloc=no,mem-path=/run/g.mem,share=yes,size=10739515392,align=128M
> -device nvdimm,memdev=memnvdimm0,id=nvdimm0,slot=0,label-size=2M
> 
> Evidently something was added to the pmem code(?) that makes it fussy if
> the memory region doesn't align to a 128M boundary or the label isn't
> big enough for ... whatever gets written into them.
> 
> The file /run/g.mem is intended to provide 10GB of pmem to the VM, with
> an additional 2M allocated for the label.

I managed to get something like this to work, and had two pmem devices
shown up.  But of course they don't actually support DAX without a
reconfiguration in the VM, and the #$%$@^$^$ DAX code won't even
tell you about why as the printk for that is a pr_debug (patch to fix
this coming).  After a fair amount of goodling I tried to copy this
command line to reconfigure them:

$NDCTL create-namespace --force --reconfig=namespace0.0 --mode=fsdax --map=mem
$NDCTL create-namespace --force --reconfig=namespace1.0 --mode=fsdax --map=mem

Of course that fails with EINVAL.  And after the first run the second
namespace is gone entirely.  The DAX user story is just a trainwreck.

