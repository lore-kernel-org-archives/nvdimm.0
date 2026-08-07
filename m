Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14879466AE5;
	Fri,  7 Aug 2026 22:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786141074; cv=none; b=OU5FQfAw7SuiEo57cQ3IB+s/8z8rkRbFCjTNOl7dSD9LnO3DtP5Kal4jK0E2KCca3TFG8Ar6c8rkpbekthIkoK/iufsHuYq+dqs/f0C99esgDsXl5d1/2/grmvlfOqKBiGufh1eMPLZGyTQb+5a3ugIBsnIv4diWhYPQ9GXH48U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786141074; c=relaxed/simple;
	bh=J4JLIR8qt7OMPKMUTgAP0WX5jKAWME93N1J+XGiazdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c8xIiRU+envJBWHryQZ/9cBlv5oMbUsqeK3/rXJKsFTYBQBpRc+IoRP8kL2K4opWaa6zplUf7K0zqVAIrrMHiNDmyvYWfFeS/ojWWELeukohUuG0ukSO69XRM9gkBPsHCl5GeADmB/oyWwsE+/bxj14rnFkQkScJiFNuDL59B5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 42B5AC01E3;
	Fri,  7 Aug 2026 22:17:39 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf17.hostedemail.com (Postfix) with ESMTPA id C813317;
	Fri,  7 Aug 2026 22:17:22 +0000 (UTC)
Date: Fri, 7 Aug 2026 17:17:21 -0500
From: John Groves <john@groves.net>
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
Subject: Re: [PATCH V12 07/12] famfs: MAP_CREATE ioctl and fmap ingest (ABI
 44)
Message-ID: <anZXxns2H0hraevA@groves.net>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022919.75875-1-john@jagalactic.com>
 <0100019fc5746312-6cfe9a07-a658-4aba-b1e9-5233b0ddfcf4-000000@email.amazonses.com>
 <20260806052449.GG3560084@frogsfrogsfrogs>
 <anTxt3qsUQuCKvMz@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anTxt3qsUQuCKvMz@groves.net>
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: C813317
X-Stat-Signature: 8j34j75gqi1wmp6t4z3xaq87gdp38by1
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1+Jhg+QZrZX5fW8FKmAtX44m54gPSILj4M=
X-HE-Tag: 1786141042-871016
X-HE-Meta: U2FsdGVkX19CtPIfRxeFZ3e99ugG6+ZU3FJMM8tlxbxau2+hivErNN8eJFH7VkJHIzdcrThG0zrLMFoBhzt+qIVnrbtUGpNoH2u0ciCcd1TX4m8T34JMcfhKMrCpF1shSRwIqSGS6E9LxQ0z67EQxus0sJB8AqdTVFbP+mFcJhkxSzvGwXcl6DAp1lEouJWztVlhsYZ3ixSy8Cn8s4mKt8jyY2cmnMcg8sxPxG0dz4NQwdQaIqamoAtByXbmTzVN6ymFtoS2vI78/PkZL15H5B2V3yN3vEpo79o3qWwgaxcvIEHzBRpRh+tOZf13+uWS4nO+5VnxYxqjD+oqAyCgLBwCy9PjI0xTdbLAdVpXmobkOf4+RwMP0ar5Mk01PK5t

On 26/08/06 03:53PM, John Groves wrote:
> On 26/08/05 10:24PM, Darrick J. Wong wrote:
> > On Mon, Aug 03, 2026 at 02:29:26AM +0000, John Groves wrote:
> > > From: John Groves <John@Groves.net>
> > > 
> > > Add the famfs file ioctl handler (FAMFSIOC_NOP, FAMFSIOC_MAP_CREATE) and
> > > the KABI-44 self-describing fmap message: the wire ABI in famfs_ioctl.h
> > > (famfs_ioc_fmap_header plus the simple and interleaved extent structs), the
> > > in-core famfs_file_meta, and famfs_file_init_dax(), which copies the
> > > message in, parses both the simple-extent and interleaved (striped) wire
> > > forms into inode->i_private, and sets S_DAX.
> > > 
> > > Resolving those mappings to dax-device offsets (iomap_begin) is added in
> > > the following commit; the read/write/fault paths keep their NULL iomap_ops
> > > stub until then.
> > > 
> > > Also add famfs ioctls to ioctl-number.rst
> > > 
> > > Signed-off-by: John Groves <john@groves.net>
> > > ---
> > >  .../userspace-api/ioctl/ioctl-number.rst      |   1 +
> > >  fs/famfs/famfs_file.c                         | 326 +++++++++++++++++-
> > >  fs/famfs/famfs_inode.c                        |   1 +
> > >  fs/famfs/famfs_internal.h                     |  46 +++
> > >  include/uapi/linux/famfs_ioctl.h              |  91 +++++
> > >  5 files changed, 462 insertions(+), 3 deletions(-)
> > >  create mode 100644 include/uapi/linux/famfs_ioctl.h
> > > 
> > > diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
> > > index 3f0ef1e27eb0..5e244dec1b98 100644
> > > --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> > > +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> > > @@ -299,6 +299,7 @@ Code  Seq#    Include File                                             Comments
> > >  'u'   00-2F  linux/ublk_cmd.h                                          conflict!
> > >  'u'   20-3F  linux/uvcvideo.h                                          USB video class host driver
> > >  'u'   40-4f  linux/udmabuf.h                                           userspace dma-buf misc device
> > > +'u'   50-5F  linux/famfs_ioctl.h                                       famfs shared memory file system
> > >  'v'   00-1F  linux/ext2_fs.h                                           conflict!
> > >  'v'   00-1F  linux/fs.h                                                conflict!
> > >  'v'   00-0F  linux/sonypi.h                                            conflict!
> > > diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> > > index 678f2035fd5f..d710c8a0c923 100644
> > > --- a/fs/famfs/famfs_file.c
> > > +++ b/fs/famfs/famfs_file.c
> > > @@ -13,9 +13,313 @@
> > >  #include <linux/mm.h>
> > >  #include <linux/dax.h>
> > >  #include <linux/iomap.h>
> > > +#include <linux/capability.h>
> > >  
> > > +#include <linux/famfs_ioctl.h>
> > >  #include "famfs_internal.h"
> > >  
> > > +/* Expose famfs kernel abi version as a read-only module parameter */
> > > +static int famfs_kabi_version = FAMFS_KABI_VERSION;
> > > +module_param(famfs_kabi_version, int, 0444);
> > > +MODULE_PARM_DESC(famfs_kabi_version, "famfs kernel abi version");
> > 
> > Maybe make the "NOP" ioctl a geometry ioctl that tells you the abi
> > version and (I guess) the page and pmd size? :D
> 
> I like it - will do

Err, gonna leave this alone after all. The kabi_version is already exposed
as a module parameter - which is better. That is needed before mount (and
the ioctls can't be called till mounted). The other useful stuff that goes 
here is the supported page sizes (which famfs generally calls "allocation 
units". But there again, user space needs them prior to mount. So exposing 
those as one or more module parameters is ideal.

The NOP ioctl originated to answer the question "is this file famfs", and
it still works fine for that (and user space relies on that in certain
circumstances).

Thanks!
John

<snip>

