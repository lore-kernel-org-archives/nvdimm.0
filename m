Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619CA5B21A;
	Thu,  6 Aug 2026 13:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786023415; cv=none; b=XqIQXCy1ikDH3WGNVNXP8/d35WIj+LLuu7k8gwapW2tBsQxx8/tYyvRaRMw5t/4gDhZCLXwD99+j8CtmUWyCZQOjHMav/amsxieRb51oI6HfQwyrhRvWUDYYCbIPo70uVi91PUkcCBPb5eUUFpTmWwNJrp+KP1R+/8V60tunTbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786023415; c=relaxed/simple;
	bh=1jilKzxFY+yt4QHXYapG9VrqSYnTTieJrea1TD9oyFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=twiIvz5aCzPkRSySdt9xjFh+j0oTp5zLi9QWvfn1j6wsS/xI8Ni1KV7KnexFq4GFksO0BF7zXdgzfWmub3Rktd6niDak7ernQHq9/dvsp1BHMsF9RMB16y9oepRyUfuygJfBk24dpmqu7YTbxI5mPCXv7rGXUkAWebD6hcSGQDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6472CA2582;
	Thu,  6 Aug 2026 13:36:37 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf09.hostedemail.com (Postfix) with ESMTPA id D18892002A;
	Thu,  6 Aug 2026 13:36:20 +0000 (UTC)
Date: Thu, 6 Aug 2026 08:36:19 -0500
From: John Groves <John@groves.net>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: John Groves <john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <djbw@kernel.org>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jake Edge <jake@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	Jonathan Cameron <jic23@kernel.org>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Andrew Morton <akpm@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Ira Weiny <iweiny@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Haren Myneni <haren@linux.ibm.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Ethan Nelson-Moore <enelsonmoore@gmail.com>, Gabriel Whigham <gabewhigham@gmail.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
Subject: Re: [PATCH V12 03/12] famfs: Add daxdev table and dax notify_failure
 support
Message-ID: <anSLGYPHAw6OjXo_@groves.net>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022839.75794-1-john@jagalactic.com>
 <0100019fc573c7cd-d37cbc1c-7687-4b05-99e7-7d3624087b98-000000@email.amazonses.com>
 <20260806050527.GC3560084@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806050527.GC3560084@frogsfrogsfrogs>
X-Rspamd-Queue-Id: D18892002A
X-Stat-Signature: 98okigfjbtq8fsq47gg46t9mt68bby4b
X-Rspamd-Server: rspamout07
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX18rCJ03bEiGaIW33HDQgfAKKDy6499XHo0=
X-HE-Tag: 1786023380-59630
X-HE-Meta: U2FsdGVkX19PYkvTOYROG/8Csf4/oSvpmL3bJl7etF2c8GvfIDrKF0z+yxEFdxMDToAteXhLyQenqvZZGd0DHv3E1mBEedBKi+yestjeDyStwZa5WJ4y3lJSqA5k+ZWAIFd7AwBKOpg99GojX8WIwQQ5bLTxwmkMMnGTg1DDAi+sylT7/dYe5L8BfNEAmsel63LR9ZvAoifYC0GMEA8tGa5DBeDY7ykaNxmaELUGQqrZ8zNbrkPATIa63pYHvmJzfqw1ELrGSJNpiylo6A3qIanXQvxyHPBOTwRRNCugK4iEkvh8ITT91u7+Cbi9cQ4eNPAC+kW/+RkthBxoAVa9DJGWBzMrw5JIYOkMVE3Q4/TZOESBOUuGaw265W+eq95E

Quick heads-up: my email provider may rate-limit me before 
I'm done responding to this thread, since there are a *lot* of 
recipients. But hopefully not...

On 26/08/05 10:05PM, Darrick J. Wong wrote:
> On Mon, Aug 03, 2026 at 02:28:47AM +0000, John Groves wrote:
> > From: John Groves <John@Groves.net>
> > 
> > Famfs file systems can span multiple dax devices, and daxdevs are stored
> > in the daxdev_table. This adds the basic table structure, primtives and
> > serialization code. Famfs file extents reference daxdevs by index, which
> > is a cluster invariant maintained by user space.
> > 
> > We also add dax_holder_operations and a notify_failure handler, which
> > is necessary to properly "open" a famfs-mode daxdev.
> 
> So you have to "mount /dev/somedaxthing0 /mnt" but you can then add more
> dax devices later through some ioctl?

The primary daxdev is in the mount command line. Secondaries are added
via the famfs metadata log (their superblocks know the uuid of the primary,
and the primary finds the secondaries via those log entries).

In-memory metadata references daxdevs by their index, which is their order
of appearance in the metadata log (with the primary being index=0).

Theoretically they could be added at any time, but the normal case is they
get added as a "last" step of mkfs.famfs.

Also, in a later message you asked if daxdevs could be passed in by file
descriptor rather than by path. Yes they could, and I did that in the most
recent famfs_fuse patch series, but then I'd have two different methods of 
"opening" them, which seemed worth avoiding. (Because mount is by dev path).

> 
> Can you remove daxdevs?  (I gather not...)

Daxdevs can't be removed - you just blow away the whole fs and start over.

> 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  fs/famfs/famfs_inode.c    | 234 ++++++++++++++++++++++++++++++++++++++
> >  fs/famfs/famfs_internal.h |  46 ++++++++
> >  2 files changed, 280 insertions(+)
> > 
> > diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
> > index c299a90912a5..ad71e5e7a8e3 100644
> > --- a/fs/famfs/famfs_inode.c
> > +++ b/fs/famfs/famfs_inode.c
> > @@ -75,6 +75,225 @@ static struct inode *famfs_get_inode(
> >  /*
> >   * famfs dax_operations (for famfs-mode dax)
> >   */
> > +static void famfs_set_daxdev_err(struct famfs_fs_info *fsi,
> > +				 struct dax_device *dax_devp);
> > +
> > +static int
> > +famfs_dax_notify_failure(
> > +		struct dax_device *dax_dev, u64 offset,
> > +		u64 len, int mf_flags)
> > +{
> > +	struct super_block *sb = dax_holder(dax_dev);
> > +	struct famfs_fs_info *fsi = sb->s_fs_info;
> > +
> > +	pr_err("%s: offset=%lld len=%llu flags=%x\n", __func__,
> > +	       offset, len, mf_flags);
> > +
> > +	/*
> > +	 * Record the error on the specific daxdev and, near-term, shut the
> > +	 * mount down: famfs_set_daxdev_err() also sets fsi->deverror so
> > +	 * subsequent famfs operations fail. The resolver's per-daxdev
> > +	 * famfs_dax_err() check remains and can make this finer later.
> > +	 */
> > +	famfs_set_daxdev_err(fsi, dax_dev);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct dax_holder_operations famfs_dax_holder_ops = {
> > +	.notify_failure		= famfs_dax_notify_failure,
> > +};
> > +
> > +/*
> > + * Allocate the daxdev table on first use (idempotent via cmpxchg).
> > + */
> > +int famfs_devlist_alloc(struct famfs_fs_info *fsi)
> > +{
> > +	struct famfs_dax_devlist *devlist;
> > +
> > +	if (fsi->dax_devlist)
> > +		return 0;
> > +
> > +	devlist = kcalloc(1, sizeof(*devlist), GFP_KERNEL);
> > +	if (!devlist)
> > +		return -ENOMEM;
> > +
> > +	devlist->nslots = FAMFS_MAX_DAXDEVS;
> > +	devlist->devlist = kcalloc(FAMFS_MAX_DAXDEVS, sizeof(struct famfs_daxdev),
> > +				   GFP_KERNEL);
> > +	if (!devlist->devlist) {
> > +		kfree(devlist);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	/* If another thread allocated it first, drop ours */
> > +	if (cmpxchg(&fsi->dax_devlist, NULL, devlist) != NULL) {
> > +		kfree(devlist->devlist);
> > +		kfree(devlist);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * famfs_install_daxdev() - exclusively acquire a resolved daxdev and publish
> > + * it in the table at @index. Slot 0 is the mount primary; slots 1..n come from
> > + * the daxdev-open ioctl.
> > + *
> > + * Serializes with concurrent installers under devlist_sem and rechecks
> > + * ->valid, so re-registering an already-installed slot is idempotent. A daxdev
> > + * is entered in the table only once it has been exclusively acquired via
> > + * fs_dax_get() (with the super_block as the holder); on failure the
> > + * dax_dev_find() reference is released and the slot is left invalid. @name may
> > + * be NULL (the ioctl path passes no pathname).
> > + */
> > +int famfs_install_daxdev(
> > +		struct famfs_fs_info *fsi,
> > +		struct super_block *sb,
> > +		u64 index,
> > +		dev_t devno,
> > +		const char *name)
> > +{
> > +	struct famfs_daxdev *daxdev;
> > +	int rc = 0;
> > +
> > +	if (index >= fsi->dax_devlist->nslots) {
> > +		pr_debug("%s: index(%llu) >= nslots(%d)\n",
> > +		       __func__, index, fsi->dax_devlist->nslots);
> > +		return -EINVAL;
> > +	}
> > +
> > +	scoped_guard(rwsem_write, &fsi->devlist_sem) {
> > +		daxdev = &fsi->dax_devlist->devlist[index];
> > +
> > +		/* Installed already by a concurrent (or repeated) open */
> > +		if (daxdev->valid)
> > +			return 0;
> > +
> > +		/*
> > +		 * A prior attempt already determined this daxdev cannot be
> > +		 * exclusively acquired (see the fs_dax_get() failure handling
> > +		 * below). Don't thrash on fs_dax_get(); fail fast.
> > +		 */
> > +		if (daxdev->dax_err)
> > +			return -EIO;
> > +
> > +		daxdev->devp = dax_dev_find(devno);
> > +		if (!daxdev->devp) {
> > +			pr_debug("%s: device %u:%u not found or not dax\n",
> > +				__func__, MAJOR(devno), MINOR(devno));
> > +			return -ENODEV;
> > +		}
> > +
> > +		rc = fs_dax_get(daxdev->devp, sb, &famfs_dax_holder_ops);
> > +		if (rc) {
> > +			/*
> > +			 * Distinguish a lost race from a real failure. -EBUSY
> > +			 * with the daxdev already held by *this* super_block
> > +			 * means a concurrent acquire won and will publish the
> > +			 * slot valid: not an error, and must not be cached as
> > +			 * dax_err. Any other failure is permanent for this
> > +			 * mount, so record dax_err to stop re-acquiring it.
> > +			 */
> > +			if (!(rc == -EBUSY && dax_holder(daxdev->devp) == sb)) {
> > +				pr_debug("%s: fs_dax_get(%u:%u) failed rc=%d\n",
> > +				       __func__, MAJOR(devno), MINOR(devno), rc);
> > +				daxdev->dax_err = true;
> > +			}
> > +			put_dax(daxdev->devp);
> > +			daxdev->devp = NULL;
> > +			return rc;
> > +		}
> > +
> > +		daxdev->devno = devno;
> > +		if (name) {
> > +			daxdev->name = kstrdup(name, GFP_KERNEL);
> > +			if (!daxdev->name) {
> > +				fs_put_dax(daxdev->devp, sb);
> > +				put_dax(daxdev->devp);
> > +				daxdev->devp = NULL;
> > +				return -ENOMEM;
> > +			}
> > +		}
> > +
> > +		wmb(); /* All other fields must be visible before valid */
> > +		daxdev->valid = 1;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Release every daxdev in the table and free it. Detach the table under
> > + * devlist_sem so a notify_failure racing teardown either runs first against
> > + * the live table or observes dax_devlist == NULL and bails.
> > + */
> > +static void famfs_devlist_free(
> > +			struct famfs_fs_info *fsi,
> > +			struct super_block *sb)
> > +{
> > +	struct famfs_dax_devlist *devlist __free(kfree) = NULL;
> > +	int i;
> > +
> > +	scoped_guard(rwsem_write, &fsi->devlist_sem) {
> > +		devlist = fsi->dax_devlist;
> > +		fsi->dax_devlist = NULL;
> > +	}
> > +
> > +	if (!devlist || !devlist->devlist)
> > +		return;
> > +
> > +	for (i = 0; i < devlist->nslots; i++) {
> > +		struct famfs_daxdev *dd = &devlist->devlist[i];
> > +
> > +		if (!dd->valid)
> > +			continue;
> > +
> > +		if (dd->devp) {
> > +			if (!dd->dax_err)
> > +				fs_put_dax(dd->devp, sb);
> > +			put_dax(dd->devp);
> > +		}
> > +		kfree(dd->name);
> > +	}
> > +	kfree(devlist->devlist);
> > +}
> > +
> > +/*
> > + * Record a memory error on the daxdev matching @dax_devp. Searches the table
> > + * under the write lock (which serializes against famfs_devlist_free()).
> > + */
> > +static void famfs_set_daxdev_err(
> > +			struct famfs_fs_info *fsi,
> > +			struct dax_device *dax_devp)
> > +{
> > +	int i;
> > +
> > +	scoped_guard(rwsem_write, &fsi->devlist_sem) {
> > +		if (!fsi->dax_devlist)
> > +			return;
> > +		for (i = 0; i < fsi->dax_devlist->nslots; i++) {
> > +			struct famfs_daxdev *dd = &fsi->dax_devlist->devlist[i];
> > +
> > +			if (!dd->valid || dd->devp != dax_devp)
> > +				continue;
> > +
> > +			dd->error = true;
> > +			/*
> > +			 * Near-term policy: any daxdev memory error shuts down
> > +			 * the whole mount. Finer per-daxdev handling (via
> > +			 * famfs_dax_err() in the resolver) already exists and
> > +			 * can supersede this later.
> > +			 */
> > +			fsi->deverror = true;
> 
> Hmm, I guess this is memory where really bad stuff happens ...?
> 
> I would have thought that you'd just kill the files on that device, but
> you can relax this later if desirable.

It's memory, not storage ;). And the longer you leave something in memory,
the more likely you'll get unrecoverable errors. Users are warned not to keep
their only copy of valuable data in famfs. Famfs is mostly for fast access to 
more data than fits in regular memory.

Right now I'm taking the cautious approach, basically shutting down the whole
mount if there are memory errors. Getting smarter is for later...

Finding all the files that touch a device isn't trivial, but *might* be worth
doing at some later date.

Thank you!

John

<snip>

