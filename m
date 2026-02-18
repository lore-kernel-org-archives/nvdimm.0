Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D36EEB3
	for <nvdimm@lists.linux.dev>; Wed, 18 Feb 2026 00:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771375816; cv=none; b=mhNSgQP9yTy2ob/boy5CEk26JbbMggUjHxQ+xv8V1fOdxszNIAEGCYij3xArmrCT43IrJ6j59Tjq85S1j/wLBnMPKtNGPExsHBFnM16BIDojzytrHTUNyOes123DgHyZs1L/Di69S2eGA8LZ/obEY28JGakKPVCNVVULuNMLq8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771375816; c=relaxed/simple;
	bh=DPJV+yIoux+yBES5JCJGLJyQUYuiyjvimN+nUyA7QPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pgXvcg5/3IGMSJoZ8CQjTKJrWtQQAizPlXPTEewRvMsg/KOIFhfT3IT8RVg0sQgLuec8dZGc2/4mHkho0W6tRN8QYlal5DupntIznORJApoE1LMudh3cZ32ZhB68yTpG6Kl5WbYn4DgpKDDJQtudu8D/bMthHbiim0QNlyNj8pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 196B51C238;
	Wed, 18 Feb 2026 00:50:11 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf19.hostedemail.com (Postfix) with ESMTPA id 147B020025;
	Wed, 18 Feb 2026 00:50:00 +0000 (UTC)
Date: Tue, 17 Feb 2026 18:49:59 -0600
From: John Groves <John@groves.net>
To: Ira Weiny <ira.weiny@intel.com>
Cc: John Groves <john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	John Groves <jgroves@fastmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
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
Subject: Re: [PATCH V7 05/19] dax: Add dax_operations for use by fs-dax on
 fsdev dax
Message-ID: <aZUK8aApUbWXVEYN@groves.net>
References: <0100019bd33b1f66-b835e86a-e8ae-443f-a474-02db88f7e6db-000000@email.amazonses.com>
 <20260118223147.92389-1-john@jagalactic.com>
 <0100019bd33c798b-b40d52e8-b393-4a54-9cc2-f30ee62b566f-000000@email.amazonses.com>
 <69909e6740f2c_14e0b410047@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69909e6740f2c_14e0b410047@iweiny-mobl.notmuch>
X-Stat-Signature: c5h1g3x1zjmid5yndwjqw6bzczpzaezy
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 147B020025
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX18Ip8vNKlTim4y5G5AKKvZzagwXyDAy10I=
X-HE-Tag: 1771375800-902739
X-HE-Meta: U2FsdGVkX1/d3n5cPzJjIGRnfE8lIzvjZgmZD7T28WO2Jbg72oWddKbaM+oaBPN9EnwXNS3JZgCgFuVXNYAkmRiZrQ362238Wz6XUHhXRgGF3oKju8t4K1By8iqddpXhlrc6SDJmBoHVkBi4aYhiQZau1KJVcGLM1WSbIiyiSOFh1QVOEHxjBebN5w8UpztH40Y1ahDD3iNB93AtO/4uhgpXVroLbTCaXMCvoNcwYYtzAgdmYkIfHyyd9Z/jNxdcSKN2Av+CtjUTlxPCF7/q8slolpCUHoA3SbZuX0LpzBp7lnJlFP7iXX5WEx+Upfip8eel+vS59TIL9Pfe7/IQkJn9284nOG/Z0ftzelYN+XagIsyXBNZGQ2vTGTPV2nVq

On 26/02/14 10:10AM, Ira Weiny wrote:
> John Groves wrote:
> > From: John Groves <John@Groves.net>
> > 
> > fsdev: Add dax_operations for use by famfs
> > 
> > - These methods are based on pmem_dax_ops from drivers/nvdimm/pmem.c
> > - fsdev_dax_direct_access() returns the hpa, pfn and kva. The kva was
> >   newly stored as dev_dax->virt_addr by dev_dax_probe().
> > - The hpa/pfn are used for mmap (dax_iomap_fault()), and the kva is used
> >   for read/write (dax_iomap_rw())
> 
> I thought this driver did not support mmap?

If a daxdev /dev/dax0.0 is in 'famfs' mode (bound to drivers/dax/fsdev.c),
and you open it and try to mmap - you can't - that's true.

This stuff is necessary to support mmap/read/write on famfs files.

> 
> > - fsdev_dax_recovery_write() and dev_dax_zero_page_range() have not been
> >   tested yet. I'm looking for suggestions as to how to test those.
> > - dax-private.h: add dev_dax->cached_size, which fsdev needs to
> >   remember. The dev_dax size cannot change while a driver is bound
> >   (dev_dax_resize returns -EBUSY if dev->driver is set). Caching the size
> >   at probe time allows fsdev's direct_access path can use it without
> >   acquiring dax_dev_rwsem (which isn't exported anyway).
> > 
> 
> None of the above explains exactly why this code is needed.  Rather it
> just explains what it does.
> 
> I'm not 100% clear on why this is needed in the driver and why this is not
> a layering violation which is going to bite us later?

I'll update the description to make it clear.

But basically: this is the stuff that xfs uses in /dev/pmem when it's in
fs-dax mode, to to resolve read/write to a memcpy variant, and to handle
faults via dax_iomap_fault() (which lets famfs resolve (file, offset) to
(daxdev, offset), and then dax finishes the job by resolving to PFN (or HPA -
whatever).

So for famfs to support file read/write/mmap on a devdax backing device,
this is the necessary glue.

Next patch version (v8) will make this more clear.

Thanks Ira!
John

[snip]

