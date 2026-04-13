Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A227039A806
	for <nvdimm@lists.linux.dev>; Mon, 13 Apr 2026 22:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776118999; cv=none; b=WkFw2lbTDk+U9W8AJkmg2CVLvLzdJ8eGlODDkFLGJGW+k3iKlsl88WB17Xmnp34YsSunPVXd4nqJOkPmH8giKaYCHUrLcBgWdp0px8PxiaXLu+PkWOzoQa6IuV4/EgwWWCK9FSrIDQuGeY1udlCbQ6ylDyFgaFXNqG/vJAkCex0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776118999; c=relaxed/simple;
	bh=W7LQd+RbFCDLlwCK3dl3WnRGYPp5bs7vZvY0YevKPF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bUGtj3TQPkBm6AMU4yDoKk/pDbB4kcTX/WjScSw6Wf+n7XCQOxZ7gCTuLQ7OL+8/z2j7xZIpppdvQfJ/v3Nw9EyOSaIvROD25FOTaBsbrc3WAeMgBMVm8j36i0/wLQplwHZ+XCwz3AlmEhV2nld4qLu8Aux6xMj0/NwhJWzGImU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D6CD613A79F;
	Mon, 13 Apr 2026 22:23:08 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf02.hostedemail.com (Postfix) with ESMTPA id 5D3898000F;
	Mon, 13 Apr 2026 22:22:58 +0000 (UTC)
Date: Mon, 13 Apr 2026 17:22:56 -0500
From: John Groves <John@groves.net>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>, 
	John Groves <john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, 
	Chen Linxuan <chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V10 0/8] dax: prepare for famfs
Message-ID: <ad1sLaxtitvzRZqy@groves.net>
References: <20260327210311.79099-1-john@jagalactic.com>
 <0100019d311bed04-dbb67b48-c55d-4e6a-962a-a0f8b714f2e7-000000@email.amazonses.com>
 <acrpbBt5UsWEiEbm@aschofie-mobl2.lan>
 <69dd576924b0f_24f910029@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69dd576924b0f_24f910029@iweiny-mobl.notmuch>
X-Rspamd-Queue-Id: 5D3898000F
X-Rspamd-Server: rspamout06
X-Stat-Signature: aq6o5hjqb987mduyjg8epqhuatqpym9e
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX18BTgOtdpukzDxFDyXp1Rh8iUJ3pyzfKOc=
X-HE-Tag: 1776118978-902051
X-HE-Meta: U2FsdGVkX19nSdUOSt1fNMXok71X0uIksOp+201xUmag2jRw28h4GLdRnjUuk1aueJrmZM7LSjyIjSqS0s+LgJo5vHqTED9XKqVMbEfwydqgQ+lYMU3ug0uE8zlJAZC/pWugbnKGvS3EyQQRvtZ3vgzRkzZWaBE7qjjWOX8RbAmBz22gEOJIJJHjn3AHriAUot/8GOHGVlFF+5HgM7zF/el3sT6m1cJQkK6pvUX+bXnlOICp2anv5wtcqamjSNvY49C2vJ2wVJvJW1bfHh6+QMarQg3v1LDQEk8FsC8CL9w2H27igljl/ZnsSGYhAQBKqx8LGr2cUcQW2OfiRqexUnw/PuQi4V4BQT8/3bV9igJQk2xvQ27V7n8+4mnOctTG4GXHVo0ibiyK6oRlFT2Xxw==

On 26/04/13 03:51PM, Ira Weiny wrote:
> Alison Schofield wrote:
> > On Fri, Mar 27, 2026 at 09:03:26PM +0000, John Groves wrote:
> > > From: John Groves <john@groves.net>
> > > 
> > > This patch series along with the bundled patches to fuse are available
> > > as a git tag at [0].
> > > 
> > > Dropped the "bundle" thread. If this submission goes smoothly, I'll update
> > > the fuse patches to v10 (very little change there as yet).
> > > 
> > > Changes v9 -> v10
> > > - Minor modernizations per comments from (mostly) Jonathan
> > > - Minor Kconfig simplification
> > > - bus.c:dax_match_type(): don't make fsdev_dax eligible for automatic binding
> > >   where devdax would otherwise bind
> > > - dax-private.h: add missing kerneldoc comment for field cached_size in
> > >   struct dev_dax_range (thanks Dave)
> > > - fsdev_write_dax(): s/pmem_addr/addr/ (thanks Dave)
> > > - include/linux/dax.h: remove a spuriously-added declaration of inode_dax()
> > >   (thanks Jonathan)
> > > 
> > > Description:
> > > 
> > > This patch series introduces the required dax support for famfs.
> > > Previous versions of the famfs series included both dax and fuse patches.
> > > This series separates them into separate patch series' (and the fuse
> > > series dependends on this dax series).
> > > 
> > > The famfs user space code can be found at [1]
> > > 
> > > Dax Overview:
> > > 
> > > This series introduces a new "famfs mode" of devdax, whose driver is
> > > drivers/dax/fsdev.c. This driver supports dax_iomap_rw() and
> > > dax_iomap_fault() calls against a character dax instance. A dax device
> > > now can be converted among three modes: 'system-ram', 'devdax' and
> > > 'famfs' via daxctl or sysfs (e.g. unbind devdax and bind famfs instead).
> > > 
> > > In famfs mode, a dax device initializes its pages consistent with the
> > > fsdaxmode of pmem. Raw read/write/mmap are not supported in this mode,
> > > but famfs is happy in this mode - using dax_iomap_rw() for read/write and
> > > dax_iomap_fault() for mmap faults.
> > > 
> > 
> > Here's what I found:
> > 
> > famfs-v10 on 7.0-rc5 + ndctl v84:
> > 	dax suite all pass 13/13, so no regression appears
> > 
> > famfs-v10 on 7.0-rc5 +
> > (ndctl v84 w https://github.com/jagalactic/ndctl/tree/famfs
> > top 3 patches + edit daxctl-famfs.sh to use cxl-test:
> > 
> > 	existing dax suite keeps passing
> > 	daxctl-famfs.sh oops w the new test at # Restore original mode"
> > 	seems easy to repoduce, maybe cannot go back to system-ram???
> 
> John have you been able to reproduce this?
> 
> Ira
> 

Not yet, but I'm getting ready to try again. 

John

