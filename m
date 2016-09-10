From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 06/10] dax: provide an iomap based fault handler
Date: Sat, 10 Sep 2016 09:36:46 +0200
Message-ID: <20160910073646.GA18547@lst.de>
References: <1473438884-674-1-git-send-email-hch@lst.de>
 <1473438884-674-7-git-send-email-hch@lst.de> <20160909225557.GF30056@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160909225557.GF30056@dastard>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Sat, Sep 10, 2016 at 08:55:57AM +1000, Dave Chinner wrote:
> THe errors from the above two cases are not acted on. they are
> immediately overwritten by:

Yes, Robert also pointed this out.  Fix below.

> Is there a missing "if (error) goto out;" check somewhere here?

Just the one above.

> I'm also wondering if you've looked at supporting the PMD fault case
> with iomap?

PMD faults currently don't work at all.  Ross has a series to resurrect
them, but we'll need to coordinate between the two series somehow.  My
preference would be to not resurrect them for the bh path and only do
it for the iomap version.


diff --git a/fs/dax.c b/fs/dax.c
index a170a94..5534594 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1440,6 +1440,7 @@ int iomap_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	default:
 		WARN_ON_ONCE(1);
 		error = -EIO;
+		goto unlock_entry;
 	}
 
 	/* Filesystem should not return unwritten buffers to us! */
