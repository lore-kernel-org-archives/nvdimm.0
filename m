Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Mon, 8 Aug 2016 06:11:26 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Subtle races between DAX mmap fault and write path
Message-ID: <20160808131126.GA14464@infradead.org>
References: <20160729022152.GZ16044@dastard>
 <CAPcyv4gOcDGzikJHYGxNXtYqQKkPUgkG+z4ASxogQUnp1zmD2g@mail.gmail.com>
 <20160730001249.GE16044@dastard> <579F20D9.80107@plexistor.com>
 <20160802002144.GL16044@dastard>
 <1470335997.8908.128.camel@hpe.com>
 <20160805112739.GG16044@dastard>
 <CS1PR84MB0119314ACA9B4823C0FE33318E180@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
 <20160808092655.GA29128@quack2.suse.cz>
 <CS1PR84MB0119ACB424699154BDA197B28E1B0@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CS1PR84MB0119ACB424699154BDA197B28E1B0@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Boylston, Brian" <brian.boylston@hpe.com>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Dave Chinner <david@fromorbit.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 08, 2016 at 12:30:18PM +0000, Boylston, Brian wrote:
> I used NVML 1.1 for the measurements.  In this version and with the hardware
> that I used, the pmem_persist() flow is:

Please don't use crap like NVML, given that the people behind it don't
seem to understand persistency at all.

> Perhaps you mean pmem_msync() here?  pmem_msync() calls msync(), but
> pmem_persist() does not.

pmem_persist is misnamed then, don't use it.

> > At which point
> > you've lost most of the advantages using movnt. Ross researches into
> > possibilities of allowing more efficient userspace implementation but
> > currently there are none.
> 
> Apart from the current performance discussion, if the metadata for a file
> is already established (file created, space allocated by explicit writes(),
> and everything synced), then if I map it and do pmem_memcpy_persist(),
> are there any "ongoing" metadata updates that would need to be flushed
> (besides timestamps)?

Yes.  For example because every write might mean a new space allocating
if using reflinks or a COW file system.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
