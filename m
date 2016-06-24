From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: xfs: untangle the direct I/O and DAX path, fix DAX locking
Date: Fri, 24 Jun 2016 09:26:12 +0200
Message-ID: <20160624072612.GA22205@lst.de>
References: <1466609236-23801-1-git-send-email-hch@lst.de>
 <20160623232446.GA12670@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160623232446.GA12670@dastard>
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
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Fri, Jun 24, 2016 at 09:24:46AM +1000, Dave Chinner wrote:
> Except we did that *intentionally* - by definition there is no
> cache to bypass with DAX and so all IO is "direct". That, combined
> with the fact that all Linux filesystems except XFS break the POSIX
> exclusive writer rule you are quoting to begin with, it seemed
> pointless to enforce it for DAX....

No file system breaks the exclusive writer rule - most filesystem
don't make writers atomic vs readers.

More importantly every other filesystem (well there only are ext2
and ext4..) exludes DAX writers against other DAX writers.

> So, before taking any patches to change that behaviour in XFS, a
> wider discussion about the policy needs to be had. I don't think
> we should care about POSIX here - if you have an application that
> needs this serialisation, turn off DAX. That's why I made it a
> per-inode inheritable flag and why the mount option will go away
> over time.

Sorry, but this is simply broken - allowing apps to opt-in behavior
(e.g. like we're using O_DIRECT) is always fine.  Requriring
filesystem-specific tuning that has affect outside the app to get
existing documented behavior is not how to design APIs.

Maybe we'll need to opt-in to use DAX for mmap, but giving the same
existing behavior for read and write and avoiding a copy to the pagecache
is an obvious win.
