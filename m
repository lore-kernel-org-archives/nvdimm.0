Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3F3313549
	for <nvdimm@lists.linux.dev>; Thu, 26 Feb 2026 23:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772148065; cv=none; b=FXtrnBkljouX+wDNsLUTBr7xSkjGxwAq41onkXPPfYfUUkSI/P+dmerxzassIPcfRKrIYIGZ8VB/0OU+vP5H9Wf2Gmx51HYD7rn9/GiPYtJuWhovhZz0ZdcCsDVMmNXBRRSx3eaEX0O9GSvzZAS6szKzNOYDlVwhbE69A+tXjTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772148065; c=relaxed/simple;
	bh=gsZ1Y37ys8eHPVBWQ2soaSwjDE57vw/wWgnNT3QtCiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RJtkn6Y3Pz+LhV3clFonSUNAF00q20dTiEeCfqLgAbFip+9wHJcbo2jQXbZQnM53qz1jUJ2ma3YGBN14c9o/UDQhuQIwQ0I1TMfvQODyrjdSFHeXfaWI7KpcqnqZLx0Lpx4k2bH1rSwu41pe/1duSdoJjw8jZ2hqhjWqSlITl0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 299051B7179;
	Thu, 26 Feb 2026 23:20:54 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf03.hostedemail.com (Postfix) with ESMTPA id 8CF326000B;
	Thu, 26 Feb 2026 23:20:44 +0000 (UTC)
Date: Thu, 26 Feb 2026 17:20:43 -0600
From: John Groves <John@groves.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: John Groves <john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	John Groves <jgroves@fastmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V7 07/19] dax: Add fs_dax_get() func to prepare dax for
 fs-dax usage
Message-ID: <aaDVDZTnpxxnzvF9@groves.net>
References: <0100019bd33b1f66-b835e86a-e8ae-443f-a474-02db88f7e6db-000000@email.amazonses.com>
 <20260118223206.92430-1-john@jagalactic.com>
 <0100019bd33cc18d-83012e03-8214-45a4-91cf-c8b598cd4535-000000@email.amazonses.com>
 <47780ff4-27ff-4e14-98cc-a10064d7fe13@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47780ff4-27ff-4e14-98cc-a10064d7fe13@intel.com>
X-Stat-Signature: 48qyziz3jms7k9sc3ckiwa8g16wyfd6u
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 8CF326000B
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX194/HT/O4zbweXGC8UQU3orKD3N/iwHBwQ=
X-HE-Tag: 1772148044-853058
X-HE-Meta: U2FsdGVkX1/23uawr/fo8qM4/BQqCnqWLc4/VCyuFJ5F1xQtJjERKRYQHs9m5x7EfJuizDa9STRyQUX9TF/E4lxX7eq3fsR9+cKfufLqLQbBOlCH7cr0cRwI80mnuGM30zQXMFtszjFR00mYjYLYlXzrILLTrwk4w41Bn7sdlAwVAl6OR6KnRDN2WGtf4YnNOfDMRFG0oWATFtAKBQ8VgYTO8r/Eu4e394qrAZi8C9AhwW/ulSs982rgJhy8eIj1mB6RgNnJKLIba55H3szz8e6s1qvI2/lmY8KJHcyBfgwvwu33Jb+9sxPfj2a1cBwWnzuF+JzQTeIjLtLgB4/azZq8lgUQSDnknaUtkncC+CMRcoqNfnECJRWU/JlyR3TI

On 26/02/19 09:07AM, Dave Jiang wrote:
> 
> 
> On 1/18/26 3:32 PM, John Groves wrote:
> > From: John Groves <john@groves.net>
> > 
> > The fs_dax_get() function should be called by fs-dax file systems after
> > opening a fsdev dax device. This adds holder_operations, which provides
> > a memory failure callback path and effects exclusivity between callers
> > of fs_dax_get().
> > 
> > fs_dax_get() is specific to fsdev_dax, so it checks the driver type
> > (which required touching bus.[ch]). fs_dax_get() fails if fsdev_dax is
> > not bound to the memory.
> > 
> > This function serves the same role as fs_dax_get_by_bdev(), which dax
> > file systems call after opening the pmem block device.
> > 
> > This can't be located in fsdev.c because struct dax_device is opaque
> > there.
> > 
> > This will be called by fs/fuse/famfs.c in a subsequent commit.
> > 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  drivers/dax/bus.c   |  2 --
> >  drivers/dax/bus.h   |  2 ++
> >  drivers/dax/super.c | 58 ++++++++++++++++++++++++++++++++++++++++++++-
> >  include/linux/dax.h | 20 ++++++++++------
> >  4 files changed, 72 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> > index e79daf825b52..01402d5103ef 100644
> > --- a/drivers/dax/bus.c
> > +++ b/drivers/dax/bus.c
> > @@ -39,8 +39,6 @@ static int dax_bus_uevent(const struct device *dev, struct kobj_uevent_env *env)
> >  	return add_uevent_var(env, "MODALIAS=" DAX_DEVICE_MODALIAS_FMT, 0);
> >  }
> >  
> > -#define to_dax_drv(__drv)	container_of_const(__drv, struct dax_device_driver, drv)
> > -
> >  static struct dax_id *__dax_match_id(const struct dax_device_driver *dax_drv,
> >  		const char *dev_name)
> >  {
> > diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
> > index 880bdf7e72d7..dc6f112ac4a4 100644
> > --- a/drivers/dax/bus.h
> > +++ b/drivers/dax/bus.h
> > @@ -42,6 +42,8 @@ struct dax_device_driver {
> >  	void (*remove)(struct dev_dax *dev);
> >  };
> >  
> > +#define to_dax_drv(__drv) container_of_const(__drv, struct dax_device_driver, drv)
> > +
> >  int __dax_driver_register(struct dax_device_driver *dax_drv,
> >  		struct module *module, const char *mod_name);
> >  #define dax_driver_register(driver) \
> > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > index ba0b4cd18a77..00c330ef437c 100644
> > --- a/drivers/dax/super.c
> > +++ b/drivers/dax/super.c
> > @@ -14,6 +14,7 @@
> >  #include <linux/fs.h>
> >  #include <linux/cacheinfo.h>
> >  #include "dax-private.h"
> > +#include "bus.h"
> >  
> >  /**
> >   * struct dax_device - anchor object for dax services
> > @@ -111,6 +112,10 @@ struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev, u64 *start_off,
> >  }
> >  EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
> >  
> > +#endif /* CONFIG_BLOCK && CONFIG_FS_DAX */
> > +
> > +#if IS_ENABLED(CONFIG_FS_DAX)
> > +
> >  void fs_put_dax(struct dax_device *dax_dev, void *holder)
> >  {
> >  	if (dax_dev && holder &&
> > @@ -119,7 +124,58 @@ void fs_put_dax(struct dax_device *dax_dev, void *holder)
> >  	put_dax(dax_dev);
> >  }
> >  EXPORT_SYMBOL_GPL(fs_put_dax);
> > -#endif /* CONFIG_BLOCK && CONFIG_FS_DAX */
> > +
> > +/**
> > + * fs_dax_get() - get ownership of a devdax via holder/holder_ops
> > + *
> > + * fs-dax file systems call this function to prepare to use a devdax device for
> > + * fsdax. This is like fs_dax_get_by_bdev(), but the caller already has struct
> > + * dev_dax (and there is no bdev). The holder makes this exclusive.
> > + *
> > + * @dax_dev: dev to be prepared for fs-dax usage
> > + * @holder: filesystem or mapped device inside the dax_device
> > + * @hops: operations for the inner holder
> > + *
> > + * Returns: 0 on success, <0 on failure
> > + */
> > +int fs_dax_get(struct dax_device *dax_dev, void *holder,
> > +	const struct dax_holder_operations *hops)
> > +{
> > +	struct dev_dax *dev_dax;
> > +	struct dax_device_driver *dax_drv;
> > +	int id;
> > +
> > +	id = dax_read_lock();
> > +	if (!dax_dev || !dax_alive(dax_dev) || !igrab(&dax_dev->inode)) {
> > +		dax_read_unlock(id);
> > +		return -ENODEV;
> > +	}
> > +	dax_read_unlock(id);
> > +
> > +	/* Verify the device is bound to fsdev_dax driver */
> > +	dev_dax = dax_get_private(dax_dev);
> > +	if (!dev_dax || !dev_dax->dev.driver) {
> 
> Don't you need to hold the dev_dax->dev device lock in order to check the driver?
> 
> DJ

Derp. Thanks for catching that Dave!

I believe it's fixed for v8, which is probably coming early next week.

John

[snip]

