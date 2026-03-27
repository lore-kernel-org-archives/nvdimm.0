Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8480B308F05
	for <nvdimm@lists.linux.dev>; Fri, 27 Mar 2026 14:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774622771; cv=none; b=mONEYv1uS+DRBXbD6nXjLXpxugfDyFIo5kXHhvJ+g8gH659jZ7cduNlRTLCMXasAj1jRLI+ulbQKemvTlMgXunDQc6EHDVUoJ8IlAok5g0vZSMf4z7wCHd6Dhfl4u6e2iu37Td/Ws1WK0w2FsXih9K4+2wchjWLX6AkIfq1Do1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774622771; c=relaxed/simple;
	bh=4abyi0QFJA+ENtgPePryoxoJ/65jZXwGxdGsYQGWJ/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=STn86rBk6St9gznuoMOc0lQ254cDOXS/S8LCHqSnBP1zNW72OcQZ03UfnurD0RLc+340IC3J6zedQoAmHO7J7rUbYQvKbhblnxbWcX2e8CHE4F1vhyHzn2ikybnu3t1ARhFWBGrAJcSXzvugmoW0HKk0mkE5GQjk3X8Joi1+zqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 10F391411DB;
	Fri, 27 Mar 2026 14:45:57 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf09.hostedemail.com (Postfix) with ESMTPA id F1F552003B;
	Fri, 27 Mar 2026 14:45:44 +0000 (UTC)
Date: Fri, 27 Mar 2026 09:45:42 -0500
From: John Groves <John@groves.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: John Groves <john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V9 7/8] dax: Add fs_dax_get() func to prepare dax for
 fs-dax usage
Message-ID: <acaX5fMhxSl0aD5h@groves.net>
References: <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
 <20260324003919.5106-1-john@jagalactic.com>
 <0100019d1d484ddc-2487f887-7ecd-49a3-abfe-9dabec28873f-000000@email.amazonses.com>
 <20260324150526.000047b6@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324150526.000047b6@huawei.com>
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: F1F552003B
X-Stat-Signature: 9bfz1px3crt5gbbbqfyugqsepybdznwf
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1+2XQXA8LG1Z1gPhCVVcUDiPnAuvqEAEUE=
X-HE-Tag: 1774622744-193271
X-HE-Meta: U2FsdGVkX19uXYBvOa/PdwyxV5VkzlppzyKL/FKiMhfYbCosuJ3ekwr2xWqOqHs4tqX7vVS7EiXaXpsof09wXFdRoEjmq9VNuHMhM8phOJUeE0vCyScTnyWAeORd/3AxPJ5mJHamRkQlNMfJXgl5lOO7xivNG/Mz+6ntwciRcug7cJeTCaSE+O8TRrootHB37g+aziwAwI4V4JqD8cMWsTSbOhrlBJGF3gkleT16yA7gHUOWdDDPcdoHp3DyZTHHWs081bo2h8s6Xtd+yfwPKih/8Tda1Is1l0DxR5HYGyDHF1UgsvrMc1fCY21fv56XdaaRBtMgRdPvAUXdP/g+sveuQ7Qb+x6YpXk1RHw98opI/sgNXmgTUfaZ8mNUiZjKMAH7z+VjvDkZ55zfJQ7aLVPrwKeebgq+tKC89Djw3Trjl/RgfRAQNC+84i+IGPMwtYVRBLrvSMt+sXZCrsdbXw==

On 26/03/24 03:05PM, Jonathan Cameron wrote:
> On Tue, 24 Mar 2026 00:39:31 +0000
> John Groves <john@jagalactic.com> wrote:
> 
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
> Hi John,
> 
> Looks like a stray header change  - see inline.
> 
> With that tidied up.
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> 
> >  #define dax_driver_register(driver) \
> > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > index ba0b4cd18a77..d4ab60c406bf 100644
> > --- a/drivers/dax/super.c
> > +++ b/drivers/dax/super.c
> 
> > diff --git a/include/linux/dax.h b/include/linux/dax.h
> > index b19bfe0c2fd1..bf37b9a982f3 100644
> > --- a/include/linux/dax.h
> > +++ b/include/linux/dax.h
> 
> >  #if IS_ENABLED(CONFIG_FS_DAX)
> > +void fs_put_dax(struct dax_device *dax_dev, void *holder);
> > +int fs_dax_get(struct dax_device *dax_dev, void *holder,
> > +	       const struct dax_holder_operations *hops);
> > +struct dax_device *inode_dax(struct inode *inode);
> 
> What's this? Not used in this patch and not stubbed.
> It's in drivers/dax/dax-private.h already and given I assume code builds
> before this patch (and it's not used in patch 8) then presumably it doesn't
> need to be here.
> 
> I got suspicious due to the lack of stub rather indicating something differnt
> form the other two.

Dropped, thanks!

John

