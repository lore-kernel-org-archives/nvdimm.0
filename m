From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: xfs: untangle the direct I/O and DAX path, fix DAX locking
Date: Fri, 24 Jun 2016 09:24:46 +1000
Message-ID: <20160623232446.GA12670@dastard>
References: <1466609236-23801-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1466609236-23801-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Wed, Jun 22, 2016 at 05:27:08PM +0200, Christoph Hellwig wrote:
> The last patch is what started the series:  XFS currently uses the
> direct I/O locking strategy for DAX because DAX was overloaded onto
> the direct I/O path.  For XFS this means that we only take a shared
> inode lock instead of the normal exclusive one for writes IFF they
> are properly aligned.  While this is fine for O_DIRECT which requires
> explicit opt-in from the application it's not fine for DAX where we'll
> suddenly lose expected and required synchronization of the file system
> happens to use DAX undeneath.

Except we did that *intentionally* - by definition there is no
cache to bypass with DAX and so all IO is "direct". That, combined
with the fact that all Linux filesystems except XFS break the POSIX
exclusive writer rule you are quoting to begin with, it seemed
pointless to enforce it for DAX....

So, before taking any patches to change that behaviour in XFS, a
wider discussion about the policy needs to be had. I don't think
we should care about POSIX here - if you have an application that
needs this serialisation, turn off DAX. That's why I made it a
per-inode inheritable flag and why the mount option will go away
over time.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
